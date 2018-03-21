/*
 Licensed to Jasig under one or more contributor license
 agreements. See the NOTICE file distributed with this work
 for additional information regarding copyright ownership.
 Jasig licenses this file to you under the Apache License,
 Version 2.0 (the "License"); you may not use this file
 except in compliance with the License. You may obtain a
 copy of the License at:

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on
 an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied. See the License for the
 specific language governing permissions and limitations
 under the License.
 */

/** Maintain a local list of locations
 *
 * @constructor
 */
BwLocations = function() {
  this.url = "/ucal/location/all.gdo";
  this.data = "";
  this.locationNames = [];
};

BwLocations.prototype.getDisplayNames = function(flush) {

  var my = this;

  if (flush || this.data == "") {
    $.ajax({
      url: this.url,
      async: false
    })
    .done(function( data ) {
      my.data = data;
      for (i=0; i < my.data.length; i++) {
        my.locationNames[i] = my.data[i].address.value;
      }
      return my.locationNames;
    })
    .fail(function(){
      my.data = {"message" : "ajax error"};
      my.locationNames = ["lookup error"];
      return my.locationNames;
    })
  }

  return my.locationNames;
};

function asArray(val) {
  if (val instanceof Array) {
    return val;
  }

  var temp = [];
  temp.push(val);
  return val;
}

// Debug utility
function print_r(obj) {
  var str = '';
  if (typeof obj === 'object') {
    for (var prop in obj) {
      if (typeof obj[prop] === 'object') {
        str += '<div>[' + prop + '] => ' + typeof(obj) + '</div>';
        str += '<div style="margin-left:2em;">' + print_r(obj[prop]) + '</div>';
      } else {
        str += '<div>[' + prop + '] => ' + obj[prop] + '</div>';
      }
    }
  }
  return str;
}

/** Turn null or undefined values into a zero length string.
 *
 * @param val
 * @returns {*}
 */
function nullToStr(val) {
  if (val === undefined) {
    return "";
  }

  if (val === null) {
    return "";
  }

  return val;
}

/** If the value is undefined or null or zero length returns null -
 * otherwise returns the value.
 *
 * @param val - to test
 * @returns {*}
 */
function checkStr(val) {
  if (val === null) {
    return null;
  }

  if (val === undefined) {
    return null;
  }

  if ($.trim(val) === "") {
    return null;
  }

  return val;
}

/**
 * @param comp
 * @param purpose - String purpose for the dates
 * @returns {String} describing when the component happens
 */
function getWhen(comp, purpose) {
  var start = comp.start();
  var end = comp.end();
  var startDtLocale = start.getPrintableDateLocale() + '<br/>' + start.getPrintableTimeLocale();
  var when = '<div class="bw' + purpose + '">';
  when += startDtLocale + ' - ';
  if (!start.dateEquals(end)) {
    when += end.getPrintableDateLocale() + ' ';
  }
  when += end.getPrintableTimeLocale();
  when += '<br/><span class="tz">' + defaultTzid + '</span>';
  // Debug
  //when += ' ' + start.getIcalUTC();
  when += '</div>';

  var startDt = start.getPrintableDate() + '<br/>' + start.getPrintableTime();

  if (startDt !== startDtLocale) {
    when += '<div class="bw' + purpose + 'Locale">';
    when += startDt + ' - ';
    if (!start.dateEquals(end)) {
      when += end.getPrintableDate() + '<br/>';
    }
    when += end.getPrintableTime();
    when += '<br/><span class="tz">' + start.tzid() + '</span>';
    when += '</div>';
  }

  return when;
}

/* Normalised vpoll response values */

var vpollResponseNone = 0;
var vpollResponseNo = 1;
var vpollResponseMaybe = 2;
var vpollResponseOk = 3;
var vpollResponseBest = 4;

/* Max values for each normalised value - from the spec */
var vpollResponseThresholds = [-1, 39, 79, 89, 100];

/** Normalise a vpoll response value
 *
 * @param response - int 0-100
 * @returns int normalised value
 */
function normaliseVpollResponse(response) {
  if (response === null) {
    return vpollResponseNone;
  }

  for (var i = 0; i < vpollResponseThresholds.length; i++) {
    if (response <=  vpollResponseThresholds[i]) {
      return i;
    }
  }

  return vpollResponseBest; // Assume illegal response > 100
}

/** Unnormalise a vpoll response - that is create a compliant number
 *
 * @param response
 * @returns int 0-100
 */
function unnormaliseVpollResponse(response) {
  if (response === null) {
    return vpollResponseNone;
  }

  return vpollResponseThresholds[response - 1] + 1;
}

/**
 * @param comp
 * @returns {String} describing the recurrence - null for not recurring
 */
function getRecurrenceInfo(comp) {
  if (comp.data.getProperty("recurrence-id") !== null) {
    // An instance
    return null;
  }

  var rrules = comp.rrules(); // Array - we only handle 1
  var rdates = comp.rdates();

  if ((rrules.length === 0) && (rdates.length === 0)) {
    // not recurring
    return null;
  }

  var rrule;

  if (rrules[0] instanceof Array) {
    // Multiple rrules - not supported - do the first
    rrule = rrules[0][3];  // value part
  } else {
    rrule = rrules[3];  // value part
  }

  /* Set the frequency */
  var freq = rrule["freq"];
  if (freq === undefined) {
    // Invalid - freq is required.
    return null;
  }

  var rinfo = i18nStrings["bwStr-AEEF-EVERY"];

  var interval = rrule["interval"];

  if (interval !== undefined) {
    if (interval != 1) {
      rinfo += interval;
    }
  }

  rinfo += " ";

  if (freq === "HOURLY") {
    rinfo += i18nStrings["bwStr-AEEF-Hour"];
  } else if (freq === "DAILY") {
    rinfo += i18nStrings["bwStr-AEEF-Day"];
  } else if (freq === "WEEKLY") {
    rinfo += i18nStrings["bwStr-AEEF-Week"];
  } else if (freq === "MONTHLY") {
    rinfo += i18nStrings["bwStr-AEEF-Month"];
  } else if (freq === "YEARLY") {
    rinfo += i18nStrings["bwStr-AEEF-Year"];
  }

  rinfo += " ";

  var byday = rrule["byday"];

  if (byday !== undefined) {
    byday = asArray(byday);
    var delim = " ";
    for (var i = 0; i < byday.length; i++) {
      rinfo += delim;
      delim = " " + i18nStrings["bwStr-AEEF-And"] + " ";
      // [+/-[n]]day-name
      // SU MO TU etc
      var bydayval = byday[i];
      var dayname;
      var pos = 1;
      if (bydayval.length > 2) {
        dayname = bydayval.substr(-2);
        pos = parseInt(bydayval.substr(0, -2));
      } else {
        dayname = bydayval;
      }

      if (pos === 1) {
        rinfo += i18nStrings["bwStr-AEEF-TheFirst"];
      } else if (pos === 2) {
        rinfo += i18nStrings["bwStr-AEEF-TheSecond"];
      } else if (pos === 3) {
        rinfo += i18nStrings["bwStr-AEEF-TheThird"];
      } else if (pos === 4) {
        rinfo += i18nStrings["bwStr-AEEF-TheFourth"];
      } else if (pos === 5) {
        rinfo += i18nStrings["bwStr-AEEF-TheFifth"];
      } else if (pos === -1) {
        rinfo += i18nStrings["bwStr-AEEF-TheLast"];
      }

      // TODO - wrong for years

      // TODO - add /bedework/shortdaynames/ to i18nStrings

      var dayNums = {
        "SU": 0,
        "MO": 1,
        "TU": 2,
        "WE": 3,
        "TH": 4,
        "FR": 5,
        "SA": 6
      }
      rinfo += moment().locale().weekdays[daynums[dayname]];
    }
  }

  // TODO - add /bedework/monthlabels/ to i18nStrings

  var monthLabels = [
    "January", "February", "March", "April",
    "May", "June", "July", "August",
    "September", "October", "November", "December"];

  var bymonth = rrule["bymonth"];
  if (bymonth !== undefined) {
    rinfo += " " + i18nStrings["bwStr-AEEF-In"] + " " +
       monthLabels[parseInt(bymonth)];
  }

  var bymonthday = rrule["bymonthday"];
  if (bymonthday !== undefined) {
    rinfo += " " + i18nStrings["bwStr-AEEF-OnThe"] + " " +
        moment().ordinal[parseInt(bymonthday)] + " " +
        i18nStrings["bwStr-AEEF-DayOfTheMonth"];
  }

  var byyearday = rrule["byyearday"];
  if (byyearday !== undefined) {
    // TODO - something with negative byyearday values
    byyearday = parseInt(byyearday);

    var neg;

    if (byyearday < 0) {
      neg = true;
      byyearday = -byyearday;
    } else {
      neg = false;
    }
    rinfo += " " + i18nStrings["bwStr-AEEF-OnThe"] + " " +
        moment().ordinal[byyearday] + " " +
        i18nStrings["bwStr-AEEF-DayOfTheYear"];

    if (neg) {
      rinfo += " " + i18nStrings["bwStr-AEEF-FromTheEnd"];
    }
  }

  var byweekno = rrule["byweekno"];
  if (byweekno !== undefined) {
    // TODO - something with negative byweekno values
    byweekno = parseInt(byweekno);

    if (byweekno < 0) {
      neg = true;
      byweekno = -byweekno;
    } else {
      neg = false;
    }
    rinfo += " " + i18nStrings["bwStr-AEEF-OnThe"] + " " +
        moment().ordinal[byweekno] + " " +
        i18nStrings["bwStr-AEEF-WeekOfTheYear"];

    if (neg) {
      rinfo += " " + i18nStrings["bwStr-AEEF-FromTheEnd"];
    }
  }

  var wkst = rrule["wkst"];
  if (wkst !== undefined) {
  }

  // until or count or neither
  var until = rrule["until"];
  var count = rrule["count"];

  rinfo += i18nStrings["bwStr-AEEF-Repeating"] + " ";

  if (until !== undefined) {
    rinfo += i18nStrings["bwStr-AEEF-Until"] + until;
    // TODO - use moment to parse and display
  } else if (count !== undefined) {
    rinfo += count + " " + i18nStrings["bwStr-AEEF-Time"];
  } else {
    rinfo += i18nStrings["bwStr-AEEF-Forever"];
  }

  return rinfo;
}

