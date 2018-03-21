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

// Bedework event form functions

// ========================================================================
// ========================================================================
//   Language and customization
//   These should come from values in the header or included as a separate cutomization
//   file.

var rdateDeleteStr = "remove";

// ========================================================================
// rdate functions
// ========================================================================

/* An rdate
 * date: String: internal date
 * time: String
 * tzid: timezone id or null
 */
function BwREXdate(date, time, allDay, floating, utc, tzid) {
  this.date = date;
  this.time = time;
  this.allDay = allDay;
  this.floating = floating;
  this.utc = utc;
  this.tzid = tzid;

  this.toString = function() {
  }

  /* varName: NOT GOOD - name of object
   * reqPar: request par for hidden field
   * row: current table row
   * rdi: index of rdate fro delete
   */
  this.toFormRow = function(varName, row, rdi) {
    row.insertCell(0).appendChild(document.createTextNode(this.date));
    row.insertCell(1).appendChild(document.createTextNode(this.time));
    row.insertCell(2).appendChild(document.createTextNode(this.tzid));
    row.insertCell(3).innerHTML = "<a href=\"javascript:" + varName + ".deleteDate('" +
                                   rdi + "')\">" + rdateDeleteStr + "</a>";
  }

  this.format= function() {
    var res = this.date + "\t" + this.time + "\t";

    if (this.tzid != null) {
      res += this.tzid;
    }

    return res;
  }

  this.equals = function(that) {
    return this.compareTo(that) == 0;
  }

  this.compareTo = function(that) {
    var res = compareTo(that.date, this.date);
    if (res != 0) {
      return res;
    }

    res = compareTo(that.time, this.time);
    if (res != 0) {
      return res;
    }

    return compareTo(that.tzid, this.tzid);
  }
}

function compareTo(thys, that) {
  if (that < thys) {
    return -1;
  }

  if (that > thys) {
    return 1;
  }

  return 0;
}

function sortCompare(thys, that) {
  return thys.compareTo(that);
}

var bwRdates = new BwREXdates("bwRdates", "bwRdatesField",
                              "bwCurrentRdates", "bwCurrentRdatesNone",
                              "visible", "invisible", 2);
var bwExdates = new BwREXdates("bwExdates", "bwExdatesField",
                               "bwCurrentExdates", "bwCurrentExdatesNone",
                               "visible", "invisible", 2);

/** Manipulate table of exception or recurrence dates.
 *
 * @param varName: NOT GOOD - name of object
 * @param reqParId: id of hidden field we update
 * @param tableId:   id of table we are manipulating
 * @param noDatesId: some info to display when we have nothing
 * @param visibleClass: class to set to make something visible
 * @param invisibleClass: class to set to make something invisible
 * @param numHeaderRows: Number of header rows in the table.
 */
function BwREXdates(varName, reqParId, tableId, noDatesId,
                    visibleClass, invisibleClass, numHeaderRows) {
  var dates = new Array();

  this.varName = varName;
  this.reqParId = reqParId;
  this.tableId = tableId;
  this.noDatesId = noDatesId;
  this.visibleClass = visibleClass;
  this.invisibleClass = invisibleClass;
  this.numHeaderRows = numHeaderRows;

  /* val: String: internal date
   * dateOnly: boolean
   * tzid: String or null
   */
  this.addRdate = function(date, time, allDay, floating, utc, tzid) {
    var newRdate = new BwREXdate(date, time, allDay, floating, utc, tzid);

    if (!this.contains(newRdate)) {
      dates.push(newRdate);
    }
  }

  this.contains = function(rdate) {
    for (var j = 0; j < dates.length; j++) {
      var curRdate = dates[j];
      if (curRdate.equals(rdate)) {
        return true;
      }
    }

    return false;
  }

  // Update the list -
  this.update = function(date, time, allDay, floating, utc, tzid) {
    this.addRdate(date, time, allDay, floating, utc, tzid);

    // redraw the display
    this.display();
  }

  this.deleteDate = function(index) {
    dates.splice(index, 1);

    // redraw the display
    this.display();
  }

  // update the rdates table displayed on screen
  this.display = function() {
    try {
      // get the table body
      var rdTableBody = document.getElementById(tableId).tBodies[0];

      // remove existing rows
      for (i = rdTableBody.rows.length - 1; i >= numHeaderRows; i--) {
        rdTableBody.deleteRow(i);
      }

      dates.sort(sortCompare);

      // recreate the table rows
      for (var j = 0; j < dates.length; j++) {
        var curDate = dates[j];
        var tr = rdTableBody.insertRow(j + numHeaderRows);

        curDate.toFormRow(varName, tr, j);
      }

      if (dates.length == 0) {
        changeClass(tableId, invisibleClass);
        changeClass(noDatesId, visibleClass);
      } else {
        changeClass(tableId, visibleClass);
        changeClass(noDatesId, invisibleClass);
      }

      /* Update the hidden field */

      var formAcl = document.getElementById(reqParId);
      formAcl.value = this.format();

    } catch (e) {
      alert(e);
    }
  }

  this.format = function() {
    var res = "";

    for (var j = 0; j < dates.length; j++) {
      var curDate = dates[j];

      res += "DATE\t" + curDate.format();
    }

    return res;
  }
}

// ========================================================================
// Form Manipulation Functions
// ========================================================================

function setEventFields(formObj,portalFriendly,submitter) {
  if (!portalFriendly) {
    setDates(formObj);
  }
  if(formObj.freq){
    setRecurrence(formObj);
  } // else we are editing an instance of a recurrence
  setBedeworkXProperties(formObj,submitter);
  //setAccessHow(formObj);
  //setAccessAcl(formObj);
}
/* Set dates based on jQuery widgets */
function setDates(formObj) {
  var startDate = new Date();
  startDate = $("#bwEventWidgetStartDate").datepicker("getDate");
  formObj["eventStartDate.year"].value = startDate.getFullYear();
  formObj["eventStartDate.month"].value = startDate.getMonth() + 1;
  formObj["eventStartDate.day"].value = startDate.getDate();

  var endDate = new Date();
  endDate = $("#bwEventWidgetEndDate").datepicker("getDate");
  formObj["eventEndDate.year"].value = endDate.getFullYear();
  formObj["eventEndDate.month"].value = endDate.getMonth() + 1;
  formObj["eventEndDate.day"].value = endDate.getDate();
}
function setBedeworkXProperties(formObj,submitter) {
  // Set up specific Bedework X-Properties on event form submission
  // Depends on bedeworkXProperties.js
  // Set application local x-properties here.

  // X-BEDEWORK-IMAGE and its parameters:
  if (formObj["xBwImageHolder"] && formObj["xBwImageHolder"].value != '') {
    bwXProps.update(bwXPropertyImage,
                  [[bwXParamDescription,''],
                   [bwXParamWidth,''],
                   [bwXParamHeight,'']],
                   formObj["xBwImageHolder"].value,true);
  }
  // X-BEDEWORK-SUBMITTEDBY
  bwXProps.update(bwXPropertySubmittedBy,[],submitter,true);

  // commit all xproperties back to the form
  bwXProps.generate(formObj);
}
function swapAllDayEvent(obj) {
  allDayStartDateField = document.getElementById("allDayStartDateField");
  allDayEndDateField = document.getElementById("allDayEndDateField");
  durDays = document.getElementById("durationDays");
  if (obj.checked) {
    // show or hide time fields and set the days duration
    changeClass('startTimeFields','invisible');
    changeClass('endTimeFields','invisible');
    changeClass('durationHrMin','invisible');
    allDayStartDateField.value = "true";
    allDayEndDateField.value = "true";
    durDays.value = 1;
    bwGrid.allDay(true);
  } else {
    changeClass('startTimeFields','timeFields');
    changeClass('endTimeFields','timeFields');
    changeClass('durationHrMin','shown');
    allDayStartDateField.value = "false";
    allDayEndDateField.value = "false";
    durDays.value = 0;
    bwGrid.allDay(false);
  }
}
function swapFloatingTime(obj) {
  startTimezone = document.getElementById("startTzid");
  endTimezone = document.getElementById("endTzid");
  startFloating = document.getElementById("startFloating");
  endFloating = document.getElementById("endFloating");
  if (obj.checked) {
    document.getElementById("storeUTCFlag").checked = false;
    startTimezone.disabled = true;
    endTimezone.disabled = true;
    startFloating.value = "true";
    endFloating.value = "true";
  } else {
    startTimezone.disabled = false;
    endTimezone.disabled = false;
    startFloating.value = "false";
    endFloating.value = "false";
  }
}
function swapStoreUTC(obj) {
  startTimezone = document.getElementById("startTzid");
  endTimezone = document.getElementById("endTzid");
  startStoreUTC = document.getElementById("startStoreUTC");
  endStoreUTC = document.getElementById("endStoreUTC");
  if (obj.checked) {
    document.getElementById("floatingFlag").checked = false;
    startTimezone.disabled = false;
    endTimezone.disabled = false;
    startStoreUTC.value = "true";
    endStoreUTC.value = "true";
  } else {
    startStoreUTC.value = "false";
    endStoreUTC.value = "false";
  }
}
function swapRdateAllDay(obj) {
  if (obj.checked) {
    changeClass('rdateTimeFields','invisible');
  } else {
    changeClass('rdateTimeFields','timeFields');
  }
}
function swapRdateFloatingTime(obj) {
  rdateTimezone = document.getElementById("rdateTzid");
  rdateFloating = document.getElementById("rdateFloating");
  if (obj.checked) {
    document.getElementById("rdateStoreUTC").checked = false;
    rdateTimezone.disabled = true;
  } else {
    rdateTimezone.disabled = false;
    rdateFloating.value = "false";
  }
}
function swapRdateStoreUTC(obj) {
  rdateTimezone = document.getElementById("rdateTzid");
  rdateStoreUTC = document.getElementById("rdateStoreUTC");
  if (obj.checked) {
    document.getElementById("rdateFloating").checked = false;
    rdateTimezone.disabled = false;
    rdateStoreUTC.value = "true";
  } else {
    rdateStoreUTC.value = "false";
  }
}
function swapDurationType(type) {
  // get the components we need to manipulate
  daysDurationElement = document.getElementById("durationDays");
  hoursDurationElement = document.getElementById("durationHours");
  minutesDurationElement = document.getElementById("durationMinutes");
  weeksDurationElement = document.getElementById("durationWeeks");
  if (type == 'week') {
    weeksDurationElement.disabled = false;
    daysDurationElement.disabled = true;
    hoursDurationElement.disabled = true;
    minutesDurationElement.disabled = true;
  } else {
    daysDurationElement.disabled = false;
    hoursDurationElement.disabled = false;
    minutesDurationElement.disabled = false;
    // we are using day, hour, minute -- zero out the weeks.
    weeksDurationElement.value = "0";
    weeksDurationElement.disabled = true;
  }
}
function swapRecurrence(obj) {
  if (obj.value == 'true') {
    changeClass('recurrenceFields','visible');
    if (document.getElementById('rrulesSwitch')) {
      changeClass('rrulesSwitch','visible');
    }
  } else {
    changeClass('recurrenceFields','invisible');
    if (document.getElementById('rrulesSwitch')) {
      changeClass('rrulesSwitch','invisible');
    }
  }
}
function swapRrules(obj) {
  if (obj.checked) {
    // make sure the user knows the ramifications of their actions
    if(confirm(bwRecurChangeWarning)) {
      changeClass('rrulesTable','visible');
      changeClass('rrulesUiSwitch','visible');
      if (document.getElementById('recurrenceInfo')) {
        changeClass('recurrenceInfo','invisible');
      }
    } else {
      // they decided against it. Uncheck the box.
      obj.checked = false;
    }
  } else {
    changeClass('rrulesTable','invisible');
    changeClass('rrulesUiSwitch','invisible');
    if (document.getElementById('recurrenceInfo')) {
      changeClass('recurrenceInfo','visible');
    }
  }
}

function showFreqRrules(freq, intervalLabel, byMonthDayLabel) {
  // reveal and hide rrules fields for vpoll style event form
  changeClass('recurrenceUntilRules','visible');
  $('p span#recurIntervalLabel').text(intervalLabel);
  $('span#byMonthDayLabel').text(byMonthDayLabel);
  changeClass('freqInterval','invisible');
  changeClass('recurByDayRules','invisible');
  changeClass('recurWkStRules','invisible');
  changeClass('byMonthRules','invisible');
  changeClass('byMonthDayRules','invisible');

  if (freq == 'NONE') {
    changeClass('noneRecurrenceRules','visible');
    changeClass('recurrenceUntilRules','invisible');
  } else {
    changeClass('freqInterval','visible');
    changeClass('noneRecurrenceRules','invisible');
  }
  if (freq == 'HOURLY') {
    changeClass('hourlyRecurrenceRules','visible');
  } else {
    changeClass('hourlyRecurrenceRules','invisible');
  }
  if (freq == 'DAILY') {
    changeClass('dailyRecurrenceRules','visible');
    changeClass('byMonthRules','visible');
    changeClass('byMonthDayRules','visible');
  } else {
    changeClass('dailyRecurrenceRules','invisible');
  }
  if (freq == 'WEEKLY') {
    changeClass('weeklyRecurrenceRules','visible');
    changeClass('recurWkStRules','visible');
  } else {
    changeClass('weeklyRecurrenceRules','invisible');
  }
  if (freq == 'MONTHLY') {
    changeClass('monthlyRecurrenceRules','visible');
    changeClass('recurByDayRules','visible');
    changeClass('byMonthDayRules','visible');
  } else {
    changeClass('monthlyRecurrenceRules','invisible');
  }
  if (freq == 'YEARLY') {
    changeClass('yearlyRecurrenceRules','visible');
    changeClass('recurByDayRules','visible');
    changeClass('recurWkStRules','visible');
    changeClass('byMonthRules','visible');
    changeClass('byMonthDayRules','visible');
  } else {
    changeClass('yearlyRecurrenceRules','invisible');
  }
}

function showRrules(freq) {
  // reveal and hide rrules fields for old style event form
  changeClass('recurrenceUntilRules','visible');

  if (freq == 'NONE') {
    changeClass('noneRecurrenceRules','visible');
    changeClass('recurrenceUntilRules','invisible');
  } else {
    changeClass('noneRecurrenceRules','invisible');
  }
  if (freq == 'HOURLY') {
    changeClass('hourlyRecurrenceRules','visible');
  } else {
    changeClass('hourlyRecurrenceRules','invisible');
  }
  if (freq == 'DAILY') {
    changeClass('dailyRecurrenceRules','visible');
  } else {
    changeClass('dailyRecurrenceRules','invisible');
  }
  if (freq == 'WEEKLY') {
    changeClass('weeklyRecurrenceRules','visible');
  } else {
    changeClass('weeklyRecurrenceRules','invisible');
  }
  if (freq == 'MONTHLY') {
    changeClass('monthlyRecurrenceRules','visible');
  } else {
    changeClass('monthlyRecurrenceRules','invisible');
  }
  if (freq == 'YEARLY') {
    changeClass('yearlyRecurrenceRules','visible');
  } else {
    changeClass('yearlyRecurrenceRules','invisible');
  }
}
function recurSelectWeekends(id) {
  chkBoxCollection = document.getElementById(id).getElementsByTagName('input');
  if (chkBoxCollection) {
    if (typeof chkBoxCollection.length != 'undefined') {
      for (i = 0; i < chkBoxCollection.length; i++) {
        if (chkBoxCollection[i].value == 'SU' || chkBoxCollection[i].value == 'SA') {
           chkBoxCollection[i].checked = true;
        } else {
          chkBoxCollection[i].checked = false;
        }
      }
    }
  }
}
function recurSelectWeekdays(id) {
  chkBoxCollection = document.getElementById(id).getElementsByTagName('input');
  if (chkBoxCollection) {
    if (typeof chkBoxCollection.length != 'undefined') {
      for (i = 0; i < chkBoxCollection.length; i++) {
        if (chkBoxCollection[i].value == 'SU' || chkBoxCollection[i].value == 'SA') {
           chkBoxCollection[i].checked = false;
        } else {
          chkBoxCollection[i].checked = true;
        }
      }
    }
  }
}
function selectRecurCountUntil(id) {
  document.getElementById(id).checked = true;
}
// Assemble the recurrence rules if recurrence is specified.
// Request params to set ('freq' is always set):
// interval, count, until (count OR until, not both)
// possibly: byday, bymonthday, bymonth, byyearday
function setRecurrence(formObj) {
  var freq = getSelectedRadioButtonVal(formObj.freq);
  if (freq != 'NONE') {
    // build up recurrence rules
    switch (freq) {
      case "DAILY":
        var bymonth = new Array();
        // get the bymonth values
        bymonth = collectRecurChkBoxVals(bymonth,document.getElementById('dayMonthCheckBoxList').getElementsByTagName('input'),false);
        // set the form values
        formObj.bymonth.value = bymonth.join(',');
        formObj.interval.value = formObj.dailyInterval.value;
        break;
      case "WEEKLY":
        var byday = new Array();
        byday = collectRecurChkBoxVals(byday, document.getElementById('weekRecurFields').getElementsByTagName('input'),false);
        formObj.byday.value = byday.join(',');
        if (formObj.weekWkst.selectedIndex != -1) {
          formObj.wkst.value = formObj.weekWkst[formObj.weekWkst.selectedIndex].value;
        }
        formObj.interval.value = formObj.weeklyInterval.value;
        break;
      case "MONTHLY":
        var i = 1;
        var monthByDayId = 'monthRecurFields' + i;
        var byday = new Array();
        var bymonthday = new Array();
        var byyearday = new Array();
        // get the byday values
        while (document.getElementById(monthByDayId)) {
          var monthFields = document.getElementById(monthByDayId);
          var dayPosSelect = monthFields.getElementsByTagName('select');
          var dayPos = dayPosSelect[0].value;
          if (dayPos) {
            byday = collectRecurChkBoxVals(byday,monthFields.getElementsByTagName('input'),dayPos);
          }
          monthByDayId = monthByDayId.substring(0,monthByDayId.length-1) + ++i;
        }
        // get the bymonthday values
        bymonthday = collectRecurChkBoxVals(bymonthday,document.getElementById('monthDaysCheckBoxList').getElementsByTagName('input'),false);
        // set the form values
        formObj.byday.value = byday.join(',');
        formObj.bymonthday.value = bymonthday.join(',');
        formObj.interval.value = formObj.monthlyInterval.value;
        break;
      case "YEARLY":
        var i = 1;
        var yearByDayId = 'yearRecurFields' + i;
        var byday = new Array();
        var bymonthday = new Array();
        var bymonth = new Array();
        var byweekno = new Array();
        var byyearday = new Array();
        // get the byday values
        while (document.getElementById(yearByDayId)) {
          var yearFields = document.getElementById(yearByDayId);
          var dayPosSelect = yearFields.getElementsByTagName('select');
          var dayPos = dayPosSelect[0][dayPosSelect[0].selectedIndex].value;
          if (dayPos) {
            byday = collectRecurChkBoxVals(byday,yearFields.getElementsByTagName('input'),dayPos);
          }
          yearByDayId = yearByDayId.substring(0,yearByDayId.length-1) + ++i;
        }
        // get the bymonth values
        bymonth = collectRecurChkBoxVals(bymonth,document.getElementById('yearMonthCheckBoxList').getElementsByTagName('input'),false);
        // get the bymonthday values
        bymonthday = collectRecurChkBoxVals(bymonthday,document.getElementById('yearMonthDaysCheckBoxList').getElementsByTagName('input'),false);
        // get the byweekno values
        byweekno = collectRecurChkBoxVals(byweekno,document.getElementById('yearWeeksCheckBoxList').getElementsByTagName('input'),false);
        // get the byyearday values
        byyearday = collectRecurChkBoxVals(byyearday,document.getElementById('yearDaysCheckBoxList').getElementsByTagName('input'),false);

        // set the form values
        formObj.byday.value = byday.join(',');
        formObj.bymonth.value = bymonth.join(',');
        formObj.bymonthday.value = bymonthday.join(',');
        formObj.byweekno.value = byweekno.join(',');
        formObj.byyearday.value = byyearday.join(',');
        if (formObj.yearWkst.selectedIndex != -1) {
          formObj.wkst.value = formObj.yearWkst[formObj.yearWkst.selectedIndex].value;
        }
        formObj.interval.value = formObj.yearlyInterval.value;
        break;
    }
    // build up count or until values
    var recur = getSelectedRadioButtonVal(formObj.recurCountUntil);
    switch (recur) {
      case "forever":
        // do nothing
        break;
      case "count":
        formObj.count.value = formObj.countHolder.value;
        break;
      case "until":
        // the following will not be adequate for recurrences smaller than a day;
        // we will need to set the time properly at that point.
        formObj.until.value = formObj.bwEventUntilDate.value + "T000000";
        break;
    }
  }

  if (debug) {
    alert("frequency: " + freq + "\ninterval: " + formObj.interval.value + "\ncount: " + formObj.count.value + "\nuntil: " + formObj.until.value + "\nbyday: " + formObj.byday.value + "\nbymonthday: " + formObj.bymonthday.value + "\nbymonth: " + formObj.bymonth.value + "\nbyyearday: " + formObj.byyearday.value + "\nwkst: " + formObj.wkst.value);
    var formFields = '';
    for (i = 0; i < formObj.length; i++) {
      formFields += formObj[i].name + ": " + formObj[i].value + "\n";
    }
    alert(formFields);
  }
  return true;
}

// populate timezone select boxes in event form
function setTimezones(timezones) {
  var tzList = timezones.split(/\n|\r/);
  tzList.sort();

  var defaultTzOptions = '<option value="-1">select timezone...</option>';

  // create the default options list
  for (i = 0; i < tzList.length; i++) {
    if (tzList[i] != "") {
      // defaultTzid is set in the xslt head
      if (defaultTzid == tzList[i]) {
        defaultTzOptions += '<option value="' + tzList[i] + '" selected="selected">' + tzList[i] + '</option>';
      } else {
        defaultTzOptions += '<option value="' + tzList[i] + '">' + tzList[i] + '</option>';
      }
    }
  }

  // set the start and end timezone options to the default
  var startTimeTzOptions = defaultTzOptions;
  var endTimeTzOptions = defaultTzOptions;

  // startTzid and endTzid are set in the xslt head
  // if the start and end date timezones exist, and if they are
  // different from the default timezone, build the options list appropriately

  if (startTzid != defaultTzid) {
    // create the start time options list
    for (i = 0; i < tzList.length; i++) {
      if (tzList[i] != "") {
        if (startTzid == tzList[i]) {
          startTimeTzOptions += '<option value="' + tzList[i] + '" selected="selected">' + tzList[i] + '</option>';
        } else {
          startTimeTzOptions += '<option value="' + tzList[i] + '">' + tzList[i] + '</option>';
        }
      }
    }
  }

  if (endTzid != defaultTzid) {
    // create the end time options list
    for (i = 0; i < tzList.length; i++) {
      if (tzList[i] != "") {
        if (endTzid == tzList[i]) {
          endTimeTzOptions += '<option value="' + tzList[i] + '" selected="selected">' + tzList[i] + '</option>';
        } else {
          endTimeTzOptions += '<option value="' + tzList[i] + '">' + tzList[i] + '</option>';
        }
      }
    }
  }

  $('#startTzid').html(startTimeTzOptions);
  $('#endTzid').html(endTimeTzOptions);
  $('#rdateTzid').html(defaultTzOptions);
}

/* jQuery initialization */
// timezoneUrl supplied in bedework.js
jQuery(document).ready(function($) {
  // get the timezones from the timezone server
  $.ajax({
    type: "GET",
    url: timezoneUrl,
    dataType: "text",
    success: function(text){
      setTimezones(text);
    }
  });
});

