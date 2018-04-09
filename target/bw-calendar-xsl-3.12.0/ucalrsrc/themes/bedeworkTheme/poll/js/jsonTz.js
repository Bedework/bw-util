var tzTbl = {};

var tzsExpanded = [];

var tzsdebug = true;

/** Maintain a table of expanded timezone information
 *
 * @constructor
 */
TzHandler = function() {
  this.url = "/tzsvr";
  this.fetchingStatus = "FETCHING";
  this.errorStatus = "ERROR";
  this.okStatus = "OK";
};

TzHandler.prototype.get = function(tzid, year) {
  var exp = tzsExpanded[tzid];

  if (exp != null) {
    if ((year == null) || exp.coversYear(year)) {
      return exp;
    }
  }

  var thisTzHandler = this;
  exp = new TzExpanded(tzid);
  tzsExpanded[tzid] = exp;

  //alert("about to fetch tz " + tzid);

    var tzreq = $.ajax({
      url: this.url,
      data: { "action": "expand", "tzid": tzid, "start": year },
      async: false
    })
    .done(function(data) {
      thisTzHandler.parseExpanded(data, tzid);
    })
    .error(function() {
      alert("tz error");
      exp.status = this.errorStatus;
    });

  return exp;
};

TzHandler.prototype.waitFetch = function(tzid, year) {
  // create a spinner
  // TODO need to move this to a general place for general use - will do for now
  var spinnerDiv = '<div id="coSpinner"></div>';
  $("body").append(spinnerDiv);
  var coSpinnerOpts = {
    lines: 13, // The number of lines to draw
    length: 20, // The length of each line
    width: 8, // The line thickness
    radius: 20, // The radius of the inner circle
    corners: 0.4, // Corner roundness (0..1)
    rotate: 0, // The rotation offset
    direction: 1, // 1: clockwise, -1: counterclockwise
    color: '#9FC6E2', // #rgb or #rrggbb or array of colors
    speed: 1.2, // Rounds per second
    trail: 60, // Afterglow percentage
    shadow: false, // Whether to render a shadow
    hwaccel: false, // Whether to use hardware acceleration
    className: 'spinner', // The CSS class to assign to the spinner
    zIndex: 100 // The z-index (defaults to 2000000000)
  };
  var coSpinnerTarget = document.getElementById('coSpinner');
  var coSpinner = new Spinner(coSpinnerOpts).spin(coSpinnerTarget);

  // do the call
  var exp = tzs.get(tzid, year);

  while (exp.status == tzs.fetchingStatus) {
    //alert("Waiting for fetch - status=" + exp.status);
  }

  // kill spinner, and return
  coSpinner.stop();
  return exp;
};

/** Given a date and a tzid return the offset for that date
 *
 * @param dt    - json format date/time YYYY-MM-DDTHH:mm:ss
 * @param tzid - name of timezone
 * @return null if unknown timezone otherwise offset in minutes
 */
TzHandler.prototype.getOffset = function(dt, tzid) {
  if (tzid == null) {
    return null;
  }

  var exptz = this.waitFetch(tzid, dt.substring(0, 4));
  var offset = null;

  if ((exptz == null) || (exptz.status != this.okStatus)) {
    return null;
  }

  var obs = exptz.findObservance(dt);

  if (obs == null) {
    return null;
  }

  // Observance is AFTER current one.

  return obs.from / 60;
}


var tzs = new TzHandler();

TzHandler.prototype.parseExpanded = function(data, tzid) {
//	var json = $.parseJSON(data);

  //  alert("data=" + data);
  //alert("json=" + json);

  var exp = tzsExpanded[tzid];

  $.each(data.observances, function(index, single) {
    exp.addObservance(
        single["name"],
        single["onset"],
        single["utc-offset-from"],
        single["utc-offset-to"]);
  });

  exp.status = tzs.okStatus;
  //tzsExpanded[tzid] = exp;
}

function TzObservance(name, onset, from, to) {
  this.name = name;
  this.onset = onset;
  this.from = from;
  this.to = to;

  this.toString = function() {
    return name + ", " + onset + ", " + from + ", " + to + "<br />";
  };

  this.compare = function(thatone) {
    if (this.onset == thatone.onset) {
      return 0;
    }

    if (this.onset > thatone.onset) {
      return 1;
    }

    return -1;
  }
}

function tzObservanceCompare(thisone, thatone) {
  return thisone.compare(thatone);
}

TzExpanded = function(tzid) {
  this.observances = [];
  this.status = tzs.fetchingStatus;
  this.tzid = tzid;
  this.sortedObservances = null;
};

TzExpanded.prototype.addObservance = function(name, onset, from, to) {
  this.observances.push(new TzObservance(name, onset, from, to));
};

TzExpanded.prototype.coversYear = function(year) {
    if (this.sortedObservances == null) {
        this.sortedObservances = this.observances.sort(tzObservanceCompare);
    }

		if (year < this.sortedObservances[0].onset.substring(0, 4)) {
        return false;
    }

    var lastYear = $(this.sortedObservances).get(-1);
    return year <= lastYear;
};

/**
 *
 * @param dt - date time value in format YYYY-MM-DDTHH:mm:ss
 * @returns {*} observance after one we are in
 */
TzExpanded.prototype.findObservance = function(dt) {
  if (this.sortedObservances == null) {
    this.sortedObservances = this.observances.sort(tzObservanceCompare);
  }

  var obss = this.sortedObservances;

  for (var i = 0; i < obss.length; i++) {
    var obs = obss[i];
    var onset = obs.onset;

    if (onset > dt) {
      return obs;
    }
  }

  return null;
};

TzExpanded.prototype.toString = function() {
  var out = this.tzid + "<br />";

  for (i in this.observances) {
    out = out + this.observances[i].toString();
  }

  return out;
};
