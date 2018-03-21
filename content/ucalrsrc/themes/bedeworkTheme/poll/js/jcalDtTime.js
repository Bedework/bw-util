/**
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

/** A wrapper around a moment.js object representing the date/time for
 * a property. If the property is specified with a timezone that timezone
 * will be used to set the offset. That timezone is set in this.moment
 *
 * The locale timezone might be different from property timezone. When
 * displaying time the locale time is more relevant to the end user than
 * the property time. The locale timezone is specified by the global
 * variable defaultTimezone. The field localeMoment has it's timezone
 * set to that display timezone.
 *
 * When the default timezone and the user locael timezone are equal we
 * have no localeMoment
 *
 * @param hour24
 * @param name "start" or "end"
 * @param datePart string or moment
 * @param allDay
 * @param UTC
 * @param tzidPar tzid specified for the property
 * @param hours value appropriate for hour24 and am flags - for string datePart
 * @param minutes - for string datePart
 * @param am - for string datePart
 * @constructor
 */
JcalDtTime = function(hour24, name, datePart, allDay, UTC, tzidPar, hours, minutes, am) {
  this.hour24 = hour24;
  this.name = name;
  this.allDay = allDay;
  this.UTC = false;
  this.fieldType = "date";
  this.localeMoment = null;

  if (name === "end") {
    this.fieldType = preferredEndType;
  }

  if (datePart === undefined) {
    return;
  }

  if (typeof datePart === "string") {
    if (allDay) {
      this.moment = moment.tz(datePart, defaultTzid);
      return;
    }


    if (UTC) {
      datePart += "T" + this.toHour24(am, hours) + ":" + minutes + ":00Z";
      this.moment = moment.tz(datePart, defaultTzid);
      return;
    }

    this.moment = moment.tz(datePart + " " + this.toHour24(am, hours) + ":" + minutes,
        "YYYY-MM-DD HH:mm", tzidPar);
  } else {
    // Presume a moment
    this.moment = datePart.clone();

    if (!allDay) {
      this.UTC = UTC;
      if (!UTC) {
        this.moment.tz(tzidPar);
      }
    }
  }
};

/** Break up the date and time value to make it usable for form population
 *
 * @param hour24 true for 24 hour
 * @param dtProp valid date or date time property
 *               [name, params, type, value]
 */
JcalDtTime.fromProperty = function(hour24, dtProp) {
  var datePart = null;
  var timePart = null;
  var UTC = false;
  var allDay = false;
  var am = false;

  var name;

  if (dtProp[0] === "dtstart") {
    name = "start";
  } else {
    name = "end";
  }

  // Why do I have to assign then use? Does not work otherwise
  var params = dtProp[1];
  var tzid = params.tzid;

//    this.type = dtProp[2];
  var dtTime = dtProp[3];

  if (dtTime.length > 10) {
    timePart = dtTime.substring(11, 19);
    datePart = dtTime.substring(0,10);
  } else {
    datePart = dtTime;
    allDay = true;
  }

  if (allDay) {
    return new JcalDtTime(hour24, name, datePart, true);
  }

  // Set the time fields.
  if ((dtTime.length > 19) && (dtTime.charAt(19) == 'Z')) {
    UTC = true;
  }

  var hours = timePart.substring(0, 2);
  var minutes = timePart.substring(3,5);

  if (!hour24) {
    var hoursInt = parseInt(hours);

    am = hoursInt < 12;
    if (hoursInt > 12) {
      hoursInt -= 12;
    } else if (hoursInt == 0) {
      hoursInt = 12;
    }

    hours = hoursInt;
  }

  return new JcalDtTime(hour24, name, datePart, false, UTC, tzid, hours, minutes, am);
};

/** Convert the hour value to a 24 hour val
 *
 * @param am true/false
 * @param hours int 1->12
 */
JcalDtTime.prototype.toHour24 = function(am, hours) {
  if (this.hour24) {
    return hours;
  }

  if (am && (hours === 12)) {
    return 0;
  }

  if (am) {
    return hours;
  }

  return hours + 12;
};

JcalDtTime.now = function(hour24, name) {
  var mt = moment.tz(defaultTzid);

  mt.minutes(0);
  mt.seconds(0);

  return new JcalDtTime(hour24, name, mt, false, false, defaultTzid);
};

/** Update to reflect the values - switch to date mode.
 *
 * @param datePart string or moment
 * @param allDay
 * @param UTC
 * @param tzidPar
 * @param hours value appropriate for hour24 and am flags - for string datePart
 * @param minutes - for string datePart
 * @param am - for string datePart
 */
JcalDtTime.prototype.update = function(datePart, allDay, UTC, tzidPar, hours, minutes, am) {
  this.moment = moment.tz(datePart, "YYYY-MM-DD", defaultTzid);

  this.allDay = allDay;
  this.UTC = UTC;

  if (this.allDay) {
    return;
  }

  this.moment.minutes(minutes);
  this.moment.hours(this.toHour24(am, hours));

  if (!this.UTC) {
    this.tzid(tzidPar);
  }
};

/** Update to reflect the values - switch to duration mode.
 *
 * @param duration a moment.duration object
 * @param start duration is from this
 */
JcalDtTime.prototype.updateFromDuration = function(duration, start) {
  this.allDay = start.allDay;
  this.UTC = start.UTC;

  this.moment = start.moment.clone();
  var offset = duration.asSeconds();
  this.addSeconds(offset);

  if (!this.UTC) {
    this.tzid(start.tzid());
  }
};

/**javascript parseint
 *
 * @param val - number of seconds
 * @returns moment
 */
JcalDtTime.prototype.addSeconds = function(val) {
  return this.moment.add(val, 'seconds');
};

/**
 *
 * @param val - number of hours
 * @returns moment
 */
JcalDtTime.prototype.addHours = function(val) {
  return this.moment.add(val, 'hours');
};

/**
 *
 * @param val - number of hours
 * @returns moment
 */
JcalDtTime.prototype.subtractHours = function(val) {
  return this.moment.subtract(val, 'hours');
};

/**
 *
 * @param val - number of days
 * @returns moment
 */
JcalDtTime.prototype.addDays = function(val) {
  return this.moment.add(val, 'days');
};

JcalDtTime.prototype.getDate = function() {
  return this.moment.toDate();
};

/**
 *
 * @param val
 * @returns {*} int from 0-23
 */
JcalDtTime.prototype.hours = function(val) {
  return this.moment.hours(val);
};

/** Return a value suitable for date widgets. If hours24 return 0-23
 * otherwise adjusts for an am/pm style.
 *
 * Caller must call am() to determine the am/pm status
 *
 * @param val hours
 * @returns {*} 1-12 or 0-23
 */
JcalDtTime.prototype.hoursAmPm24 = function(val) {
  if (val === undefined) {
    var h = this.hours();

    if (this.hour24) {
      return h;
    }

    if (h > 12) {
      return h - 12;
    }

    if (h === 0) {
      return 12;
    }

    return h;
  }

  return this.moment.hours(val);
};

JcalDtTime.prototype.minutes = function(val) {
  return this.moment.minutes(val);
};

JcalDtTime.prototype.seconds = function(val) {
  return this.moment.seconds(val);
};

/** The milliseconds value - usually 0
 *
 * @param val
 * @returns {*}
 */
JcalDtTime.prototype.milliseconds = function(val) {
  return this.moment.milliseconds(val);
};

JcalDtTime.prototype.getEpochMilliseconds = function() {
  return this.moment.valueOf();
};


JcalDtTime.prototype.am = function() {
  return this.moment.hours() < 12;
};

//JcalDtTime.prototype.getLocalizedShortDate = function() {
//  return this.moment.format("ll");
//};

/**
 *
 * @returns {String} yyyyMMdd[ThhmmssZ]
 */
JcalDtTime.prototype.getIcalUTC = function() {
  if (this.allDay) {
    return this.moment.format("YYYYMMDD");
  }

  var res = this.moment.clone().utc().format("YYYYMMDD[T]HHmmss[Z]");
//  this.moment.local(); // Switch back to local mode
  return res;
};

JcalDtTime.prototype.equals = function(other) {
  return this.milliseconds() === other.milliseconds();
};

JcalDtTime.prototype.dateEquals = function(other) {
  return this.getDatePart() === other.getDatePart();
};

/**
 * Return a correctly formatted date based on the field values
 */
JcalDtTime.prototype.getDatePart = function() {
  return this.moment.format("YYYY-MM-DD");
};

/**
 * Return a correctly formatted date/time based on the field values
 */
JcalDtTime.prototype.getDtval = function() {
  var datePart = this.getDatePart();
  if (this.allDay) {
    return datePart;
  }

  var res = datePart +
            "T" + digits2(this.hours()) + ":" + digits2(this.minutes()) + ":00";

  if (this.UTC) {
    res += "Z";
  }

  return res;
};

/** return difference between this and that. If that is later result is negative
 *
 * @param that - another JcalDtTime object
 * @param units - as defined in moment.
 */
JcalDtTime.prototype.diff = function(that, units) {
  return this.moment.diff(that.moment, units);
};

/**
 *
 * @param comp a jcal object
 * @param start a JcalDtTime object so we can calculate duration.
 */
JcalDtTime.prototype.updateProperty = function(comp, start) {
  var params;
  var type;

  if (this.fieldType === "duration") {
    var dur = moment.duration(this.moment.diff(start.moment, "seconds"), "seconds").toISOString();

    comp.updateProperty("duration", dur, {}, "duration");
    // May have switched from end to duration
    comp.removeProperties(this.pname(comp));

    return;
  }

  var val = this.getDtval();

  if (this.tzid() === null) {
    params = {};
  } else {
    params = {"tzid": this.tzid()};
  }

  if (this.allDay) {
    type = "date";
  } else {
    type = "date-time";
  }

  comp.updateProperty(this.pname(comp), val, params, type);
  if (this.name === "end") {
    comp.removeProperties("duration");
  }
};

JcalDtTime.prototype.pname = function(comp) {
  if (this.name === "start") {
    return "dtstart";
  }

  if (comp.isEvent()) {
    return "dtend";
  }

  return "due";
};

JcalDtTime.prototype.duplicateAs = function(name) {
  var that = new JcalDtTime(this.hour24, name);
  that.UTC = this.UTC;
  that.allDay = this.allDay;
  that.moment = this.moment.clone();

  return that;
};

JcalDtTime.prototype.clone = function() {
  return this.duplicateAs(this.name);
};

/** 'static' date conversioncl
 *
 * @param date
 * @returns {string}
 */
JcalDtTime.jsDateToiCal = function(date) {
  return date.toISOString().substr(0, 19).replace(/\-/g, "").replace(/\:/g, "");
};

/**
 *
 * @returns {String} printable time in properties timezone
 */
JcalDtTime.prototype.getPrintableTime = function() {
  if (this.hour24) {
    return this.moment.format("HH:mm")
  }
  return this.moment.format("h:mm a");
};

/**
 *
 * @returns {String} printable date according to properties timezone
 */
JcalDtTime.prototype.getPrintableDate = function() {
  return this.moment.format("dd, ll");
};

/**
 *
 * @returns {String} printable time in locale timezone
 */
JcalDtTime.prototype.getPrintableTimeLocale = function() {
  if (defaultTzid === this.tzid()) {
    return this.getPrintableTime();
  }

  if (this.hour24) {
    return this.getLocaleMoment().format("HH:mm")
  }
  return this.getLocaleMoment().format("h:mm a");
};

/**
 *
 * @returns {String} printable date according to locale timezone
 */
JcalDtTime.prototype.getPrintableDateLocale = function() {
  if (defaultTzid === this.tzid()) {
    return this.getPrintableDate();
  }

  return this.getLocaleMoment().format("dd, ll");
};

JcalDtTime.prototype.getLocaleMoment = function() {
  if (this.localeMoment !== null) {
    return this.localeMoment;
  }

  this.localeMoment = this.moment.clone();
  this.localeMoment.tz(defaultTzid);
//  var offset = tzs.getOffset(this.localeMoment.format("YYYY-MM-DD"), defaultTzid);

  /* Note the oddity with sign of timezone offset and
     UTC offset
     http://stackoverflow.com/questions/22275025/inverted-zone-in-moment-timezone
     */
//  this.localeMoment.utc().zone(-offset).local();
//  this.localeMoment.utc(true).zone(-offset, true);
  return this.localeMoment;
};

JcalDtTime.prototype.tzid = function(val) {
  if (val === undefined) {
    return this.moment.tz();
  }
  /*
  if (val === undefined) {
    if (this.UTC) {
      return "UTC";
    }
    return this.theTzid;
  }

  this.theTzid = val;

  if (this.theTzid === null) {
    this.theTzid = defaultTzid;
  }

  if (this.theTzid === null) {
    // Can't set
    return;
  }
  */

//  var offset = tzs.getOffset(this.getDatePart(), this.theTzid);

  /* Note the oddity with sign of timezone offset and
   UTC offset
   http://stackoverflow.com/questions/22275025/inverted-zone-in-moment-timezone
   */
//  this.moment.utc().zone(-offset).local();
//  this.moment.zone(-offset, true);
  this.moment = this.moment.tz(val);
};

//moment.fn.setOffset = function(val) {
//  this._offset = val;
//}
