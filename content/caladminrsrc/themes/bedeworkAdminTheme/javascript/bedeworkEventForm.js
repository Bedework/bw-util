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

  this.format = function() {
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
    var strippedDate = date.replace(/-/g, ""); // strip out hyphens if present
    this.addRdate(strippedDate, time, allDay, floating, utc, tzid);

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
// Submitted event comments
// ========================================================================

/* A comment accompanying a submitted event.
 * These values come from sumbitted x-properties
 * locationAddress: value of property X-BEDEWORK-LOCATION
 * locationSubaddress: value of location's parameter X-BEDEWORK-SUBADDRESS
 * locationUrl: value of location's parameter X-BEDEWORK-PARAM-URL
 * contactName: value of x-property X-BEDEWORK-CONTACT
 * contactPhone: value of contact's parameter X-BEDEWORK-PARAM-PHONE
 * contactUrl: value of contact's parameter X-BEDEWORK-PARAM-URL
 * contactEmail: value of contact's parameter X-BEDEWORK-PARAM-EMAIL
 * topicalAreas: list of submitted topical areas (may not match the event admin's view
 * category: value of x-property X-BEDEWORK-CATEGORIES - a freeform user suggestion
 * notes: value of the x-property X-BEDEWORK-SUBMIT-COMMENT
 */
function bwSubmitComment(locationAddress,locationSubaddress,locationUrl,contactName,contactPhone,contactUrl,contactEmail,topicalAreas,category,notes) {
  this.locationAddress = locationAddress;
  this.locationSubaddress = locationSubaddress;
  this.locationUrl = locationUrl;
  this.contactName = contactName;
  this.contactPhone = contactPhone;
  this.contactUrl = contactUrl;
  this.contactEmail = contactEmail;
  this.topicalAreas = topicalAreas;
  this.category = category;
  this.notes = notes;

  this.render = function() {
    var output = "";
    if (this.locationAddress != "" || this.locationSubaddress != "" || this.locationUrl != "") {
      output += '<table>';
      output += '<tr><th colspan="2">Suggested Location:</th></tr>';
      output += '<tr><td>Address:</td><td>' + this.locationAddress + '</td>';
      output += '<tr><td>Subaddress:</td><td>' + this.locationSubaddress + '</td>';
      output += '<tr><td>URL:</td><td>' + this.locationUrl + '</td>';
      output += '</table>';
    }
    if (this.contactName != "" || this.contactPhone != "" || this.contactEmail != "" || this.contactUrl != "") {
      output += '<table>';
      output += '<tr><th colspan="2">Suggested Contact:</th></tr>';
      output += '<tr><td>Name:</td><td>' + this.contactName + '</td></tr>';
      output += '<tr><td>Phone:</td><td>' + this.contactPhone + '</td></tr>';
      output += '<tr><td>URL:</td><td>' + this.contactUrl + '</td></tr>';
      output += '<tr><td>Email:</td><td>' + this.contactEmail + '</td></tr>';
      output += '</table>';
    }
    if (this.topicalAreas != "") {
      output += '<table>';
      output += '<tr><th>Suggested Topical Areas:</th></tr>';
      output += '<tr><td>' + this.topicalAreas + '</td></tr>';
      output += '</table>';
    }
    if (this.category != "") {
      output += '<p><strong>Suggested Type of Event:</strong><br/>';
      output += this.category;
      output += '</p>';
    }
    output += '<p>';
    if (this.notes != "") {
      output += '<strong>Notes:</strong><br/>';
      output += this.notes;
    }
    output += '</p>';

    return output;
  }

  this.display = function(displayId) {
    var showComment = document.getElementById(displayId);
    showComment.innerHTML = this.render();
  }

  // launch comment in a pop-up window
  this.launch = function() {
    var commentWindow = window.open("", "commentWindow", "width=800,height=400,scrollbars=yes,resizable=yes,alwaysRaised=yes,menubar=no,toolbar=no");
    commentWindow.document.open();
    commentWindow.document.writeln("<html><head><title>Submitted Event Comments</title>");
    commentWindow.document.writeln('<style type="text/css">');
    commentWindow.document.writeln('body{background-color: #ffe; color: black; padding: 1em; font-size: 0.9em; font-family: Arial,sans-serif;}');
    commentWindow.document.writeln('table{float: left; margin: 1em 1em 0 0; padding: 0.5em; border: 1px solid #ccc; font-size: 0.9em;}');
    commentWindow.document.writeln('th{text-align: left;}');
    commentWindow.document.writeln('td{padding-left: 2em;}');
    commentWindow.document.writeln('p{clear:both; padding-top: 1em;}');
    commentWindow.document.writeln('</style></head>');
    commentWindow.document.writeln("<body><h3>Comments from Submitter</h3>");
    commentWindow.document.writeln(this.render());
    commentWindow.document.writeln("</body></html>");
    commentWindow.document.close();
    commentWindow.focus();
  }
}

// ========================================================================
// ========================================================================

function setEventFields(formObj,portalFriendly,submitter,creating) {
  if(formObj.submitVal.value != 'cancelled') {
    cleanEventFields(formObj);
    if (!validateEventForm(formObj,creating)) {
      return false;
    }
    if (!portalFriendly) {
      setDates(formObj);
    }
    if(formObj.freq){
      setRecurrence(formObj);
    } // else we are editing an instance of a recurrence
    setBedeworkXProperties(formObj,submitter);
  }
  return true;
}

/* pre-clean summary and description to remove
 * input characters that trouble the XSLT; this is a convenience
 * function that can be extended */
function cleanEventFields(formObj) {
  // clean the description:
  var descriptionText = trim(formObj["description"].value);
  descriptionText = descriptionText.replace("\x0B",""); // remove vertical tab
  descriptionText =  descriptionText.replace(RegExp(String.fromCharCode(31),"g"),""); // remove universal separator
  formObj["description"].value = descriptionText;

  // clean the summary
  var summaryText = trim(formObj["summary"].value);
  summaryText = summaryText.replace("\x0B",""); // remove vertical tab
  summaryText = summaryText.replace(RegExp(String.fromCharCode(31),"g"),""); // remove universal separator
  formObj["summary"].value = summaryText;
}

/* do some basic client-side validation where needed */
function validateEventForm(formObj,creating) {

  // Event registration
  if(formObj["bwIsRegisterableEvent"] != undefined) {
    if(formObj["bwIsRegisterableEvent"].checked) {
      var maxTickets = trim(formObj["xBwMaxTicketsHolder"].value);
      var maxTicketsPerUser = trim(formObj["xBwMaxTicketsPerUserHolder"].value);
      var maxWaitList = trim(formObj["xBwMaxWaitListHolder"].value);
      if(maxTickets == "" || isNaN(maxTickets)) {
        alert(maxTicketsWarning);
        formObj["xBwMaxTicketsHolder"].focus();
        return false;
      }
      if(maxTicketsPerUser == "" || isNaN(maxTicketsPerUser)) {
        alert(maxTicketsPerUserWarning);
        formObj["xBwMaxTicketsPerUserHolder"].focus();
        return false;
      }
      if(maxWaitList == "") {
        removeRegistrationWaitList();
        formObj["xBwMaxWaitListHolder"].value = "";
      }
      if(!isNaN(maxWaitList)) {
        return true;
      } else if ((maxWaitList.slice(-1) == '%') && (!isNaN(maxWaitList.slice(0, -2)))) {
        return true;
      } else {
        alert(maxWaitListWarning);
        formObj["xBwMaxWaitListHolder"].focus();
        return false;
      }
    }
  }

  return true;
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
  if (formObj["xBwImageHolder"] &&
      formObj["xBwImageHolder"].value != '') {

    var imgDesc = '';
    if (formObj["xBwImageDescHolder"] &&
      formObj["xBwImageDescHolder"].value != '') {
      imgDesc = formObj["xBwImageDescHolder"].value;
    }

    var imgAlt = '';
    if (formObj["xBwImageAltHolder"] &&
      formObj["xBwImageAltHolder"].value != '') {
      imgAlt = formObj["xBwImageAltHolder"].value;
    }

    bwXProps.update(bwXPropertyImage,
                  [[bwXParamDescription,imgDesc],
                   [bwXParamAlt,imgAlt],
                   [bwXParamWidth,''],
                   [bwXParamHeight,'']],
                   formObj["xBwImageHolder"].value,true);
  }

  // X-BEDEWORK-THUMB-IMAGE:
  if (formObj["xBwImageThumbHolder"] &&
      formObj["xBwImageThumbHolder"].value != '') {
    bwXProps.update(bwXPropertyThumbImage,[],formObj["xBwImageThumbHolder"].value,true);
  }

  // UPLOADING AN IMAGE
  // If the imageUpload field is not empty or the "overwrite" flag is checked,
  // don't send the image field x-properties. This enables uploads to override
  // existing images. Comment this out to disable.
  if (formObj["eventImageUpload"] != undefined) {
    if (formObj["eventImageUpload"].value != '') {
      removeEventImage(formObj["xBwImageHolder"],formObj["xBwImageThumbHolder"]);
    }
  }

  // Event registration x-properties:
  if (formObj["bwIsRegisterableEvent"] != undefined) {
    if (formObj["bwIsRegisterableEvent"].checked) {
      bwXProps.update(bwXPropertyMaxTickets,[],formObj["xBwMaxTicketsHolder"].value,true);
      bwXProps.update(bwXPropertyMaxTicketsPerUser,[],formObj["xBwMaxTicketsPerUserHolder"].value,true);
      bwXProps.update(bwXPropertyMaxWaitList,[],formObj["xBwMaxWaitListHolder"].value,true);

      var bwRegDateString = "";
      if (formObj["xBwRegistrationOpensAmpm"] == undefined) {
        // 24-hour
        var bwRegOpensHour = setBwRegXpropHour(formObj["xBwRegistrationOpens.hour"].value);
        var bwRegClosesHour = setBwRegXpropHour(formObj["xBwRegistrationCloses.hour"].value);
      } else {
        // am/pm
        var bwRegOpensHour = setBwRegXpropHour(formObj["xBwRegistrationOpens.hour"].value,formObj["xBwRegistrationOpensAmpm"].value);
        var bwRegClosesHour = setBwRegXpropHour(formObj["xBwRegistrationCloses.hour"].value,formObj["xBwRegistrationClosesAmpm"].value);
      }

      bwRegDateString = formObj["xBwRegistrationOpensDate"].value.replace(/-/g,"") + "T" + bwRegOpensHour + padTimeUnit(formObj["xBwRegistrationOpens.minute"].value) + "00";
      bwXProps.update(bwXPropertyRegistrationStart,[["TZID",formObj["xBwRegistrationOpensTzid"].value]],bwRegDateString,true);

      bwRegDateString = formObj["xBwRegistrationClosesDate"].value.replace(/-/g,"") + "T" + bwRegClosesHour + padTimeUnit(formObj["xBwRegistrationCloses.minute"].value) + "00";
      bwXProps.update(bwXPropertyRegistrationEnd,[["TZID",formObj["xBwRegistrationClosesTzid"].value]],bwRegDateString,true);

      var bwCustomFields = formObj["xbwCustomFieldCollections"].value;
      if (bwCustomFields != undefined) {
        if (bwCustomFields != "") {
          bwXProps.update(bwXPropertyRegistrationForm,[],bwCustomFields,true);
        }
      }

      if (((formObj["bwRegisterableInternal"] != undefined) &&
          (formObj["bwRegisterableInternal"].checked)) ||
          (formObj["bwRegisterableNoExternal"])) {
        bwXProps.update(bwXPropertyRegistrationInternal,[],true);
      }

      if ((formObj["bwRegisterableExternal"] != undefined) &&
          (formObj["bwRegisterableExternal"].checked)) {
        bwXProps.update(bwXPropertyRegistrationExternal,[],true);
      }
    }
  }

  // X-BEDEWORK-SUBMITTEDBY
  bwXProps.update(bwXPropertySubmittedBy,[],submitter,true);

  // commit all xproperties back to the form
  bwXProps.generate(formObj);
}
function padTimeUnit(val) {
  var timeUnit = parseInt(val,10);
  if (isNaN(timeUnit)) {
    return "00"; // this shouldn't happen, but let's ensure our xprops stay clean.
  }
  if (timeUnit < 10) {
    return "0" + timeUnit;
  } else {
    return String(timeUnit);
  }
}
function hour24ToAmpm(val) {
  var hour = parseInt(val,10);
  if (isNaN(hour)) {
    return "0";
  }
  if (hour > 11) {
    return String(hour - 12);
  } else {
    return String(hour);
  }
}
function timeString2Int(val) {
  var timeString = parseInt(val,10);
  if (isNaN(timeString)){
    return "0";
  }
  return String(timeString);
}
function hour24GetAmpm(val) {
  var hour = parseInt(val,10);
  if (hour < 12 || isNaN(hour)) {
    return "am";
  } else {
    return "pm";
  }
}
function setBwRegXpropHour(val,ampm) {
  if (ampm == undefined) {
    // 24 hour mode
    return padTimeUnit(val);
  }
  var hour = parseInt(val,10);
  if (isNaN(hour)) {
    return "00"; // this shouldn't happen, but let's ensure our xprops stay clean.
  }
  // 12 hour mode, PM:
  if (ampm == 'pm') {
    if (hour < 12) {
      return String(hour + 12);
    }
    return hour;
  }
  // 12 hour mode, AM:
  if (hour == 12) {
    return "00";
  }
  if (hour < 10) {
    return "0" + hour;
  }
  return hour;
}
function removeEventImage(imgField,thumbField,descField,altField) {
  bwXProps.remove(bwXPropertyImage);
  bwXProps.remove(bwXPropertyThumbImage);
  imgField.value = "";
  thumbField.value = "";
  if (descField != undefined) {
    descField.value = "";
  }
  if (altField != undefined) {
    altField.value = "";
  }
  $("#eventFormImage").hide();
  $("#eventImageRemoveButton").hide();
}

function removeRegistrationWaitList() {
  bwXProps.remove(bwXPropertyMaxWaitList);
}

function removeCustomFields() {
  if (confirm("Removing custom fields will have significant\nconsequences on registration reporting.\nAre you sure you wish to proceed?")) {
    bwXProps.remove(bwXPropertyRegistrationForm);
    $("#xbwCustomFieldCurrentFormHolder").hide();
    $("#xbwCustomFieldCollectionsHolder").show();
    $("#bwToggleUnpublishedCustFieldsHolder").show();
    getCustomFields(true); // true = don't set the selected index after retrieval
    $("#xbwCustomFieldCollections")[0].selectedIndex = 0;; // set to empty first element
    alert("You must save the event for this change to take effect.");
  }
}
function toggleBedeworkTopicalArea(displayName,vpath,checked,submitted,path,aliasPath) {
  toggleBedeworkXProperty('X-BEDEWORK-ALIAS',displayName,vpath,path,aliasPath,checked,true);
  if (submitted && !checked) {
    // This is a submitted event; remove the submitted alias if unchecked (don't toggle these).
    // Send both the path and aliasPath for removal - it will be one or the other (but not both).
    // The correct value depends on where the alias sits in the topical area tree.
    bwXProps.removeByValue('X-BEDEWORK-SUBMIT-ALIAS',path);
    bwXProps.removeByValue('X-BEDEWORK-SUBMIT-ALIAS',aliasPath);
  }
  if (bwJsDebug) {
    console.log(bwXProps.display());
  }
}
function toggleBedeworkXProperty(xprop,displayName,value,path,aliasPath,checked,isUniqueByValue) {
  if (!checked) {
    if (bwJsDebug) {
      console.log("Removing " + xprop + ":" + value);
    }
    bwXProps.removeByValue(xprop, value);
  } else {
    var uniqueByValue = false;
    if (isUniqueByValue) {
      uniqueByValue = true;
    }
    bwXProps.update(xprop,[[bwXParamDisplayName,displayName],[bwXParamPath,path],[bwXParamAliasPath,aliasPath]],value,false,uniqueByValue);
  }
}
/**
 * Show or hide the unpublished custom fields from pull-down
 * @param {boolean} checked - state of checkbox that toggles the visibility of the unpublished sets
 */
function toggleUnpublishedCustomFields(checked) {
  if (checked) {
    $("#xbwCustomFieldCollections option.unpublished").show();
  } else {
    $("#xbwCustomFieldCollections option.unpublished").hide();
  }
}
/**
 * Disable suggestions if an unpublished custom field set is selected
 * @param customFieldsType - "published" or "unpublished"
 */
function toggleSuggestions(customFieldsType) {
  if(customFieldsType == "unpublished") {
    $("#bwSuggestions").addClass("dim");
    $("#bwSuggestions input[type=checkbox]").each(function() {
      $(this).prop('checked', false);
      $(this).prop("disabled",true);
    });
  } else {
    $("#bwSuggestions").removeClass("dim");
    $("#bwSuggestions input[type=checkbox]").each(function() {
      $(this).prop("disabled", false);
    });
  }
}
function claimPendingEvent(group,user) {
  bwXProps.update(bwXPropertySubmissionClaimant,[[bwXParamClaimantUser,user]],group,true);
}
function releasePendingEvent() {
  bwXProps.remove(bwXPropertySubmissionClaimant);
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
  } else {
    changeClass('startTimeFields','timeFields');
    changeClass('endTimeFields','timeFields');
    changeClass('durationHrMin','shown');
    allDayStartDateField.value = "false";
    allDayEndDateField.value = "false";
    durDays.value = 0;
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
function showRrules(freq) {
  // reveal and hide rrules fields
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
          var dayPos = dayPosSelect[0][dayPosSelect[0].selectedIndex].value;
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
        // Dojo is deprecated:
        //formObj.until.value = dojo.widget.byId("bwEventWidgetUntilDate").getValue() + "T000000";
        formObj.until.value = formObj.bwEventUntilDate.value + "T000000";
        break;
    }
  }

  if (bwJsDebug) {
    console.log("frequency: " + freq + "\ninterval: " + formObj.interval.value + "\ncount: " + formObj.count.value + "\nuntil: " + formObj.until.value + "\nbyday: " + formObj.byday.value + "\nbymonthday: " + formObj.bymonthday.value + "\nbymonth: " + formObj.bymonth.value + "\nbyyearday: " + formObj.byyearday.value + "\nwkst: " + formObj.wkst.value);
    var formFields = '';
    for (i = 0; i < formObj.length; i++) {
      formFields += formObj[i].name + ": " + formObj[i].value + "\n";
    }
    console.log(formFields);
  }
  return true;
}
function showRegistrationFields(obj,hasForm) {
  // toggle the registration fields
  if (obj.checked) {
    changeClass('bwRegistrationFields','visible');
    if (!hasForm) { // don't retrieve the forms if the event already has one attached
      getCustomFields();
    }
  } else {
    changeClass('bwRegistrationFields','invisible');
  }
}
function resetPublishBox(calSelectId) {
  // User has closed the publish box without publishing.
  // Reset the calendar select box to default value and hide the publishBox.
  var calSelect = document.getElementById(calSelectId);
  calSelect.selectedIndex = 0;
  changeClass('publishBox','invisible');
}

function doPublishEvent(publishingCal,eventTitle,eventUrlPrefix,formObj) {
  // User has submitted the event when there is only a single publishing calendar.
  // Update the newCalPath to reflect the publishing calendar:
  newCalPath = document.getElementById("newCalPath");
  newCalPath.value = publishingCal;

  // If email notification is enabled, set field to true
  // (set to 'true' for now to get the feature working)
  submitNotification = document.getElementById("submitNotification");
  submitNotification.value = true;

  // set the email field values
  snsubject = document.getElementById("snsubject");
  snsubject.value = "Event Approved: " + eventTitle;
  sntext = document.getElementById("sntext");
  var message;
  message = "Your event has been approved and is now published.\n\n";
  message += "EVENT DETAILS\n-------------\n";
  message += "Title: " + eventTitle + "\n";
  message += "URL: " + eventUrlPrefix + "&calPath=" + publishingCal;
  sntext.value = message;

  // Send the names of xproperties we wish to retain after we publish.
  // Those not listed will be thrown away
  // but must first be passed to the backend for use
  // (e.g. the email address of the submitter).
  var xpropPreserve = [bwXPropertyAlias, bwXPropertyImage, bwXPropertySubmittedBy];

  for (var i = 0; i < xpropPreserve.length; i++) {
    var xpropPreserveField = document.createElement("input");
    xpropPreserveField.type = "hidden"; // change type prior to appending to DOM
    formObj.appendChild(xpropPreserveField);
    xpropPreserveField.name = "xprop-preserve";
    xpropPreserveField.value = xpropPreserve[i];
  }
}

function doApproveEvent(approvedCal, eventTitle, eventUrlPrefix, formObj) {
  // User has submitted the event when there is only a single publishing calendar.
  // Update the newCalPath to reflect the public calendar:
  newCalPath = document.getElementById("newCalPath");
  newCalPath.value = approvedCal;

  // If email notification is enabled, set field to true
  // (set to 'true' for now to get the feature working)
  submitNotification = document.getElementById("submitNotification");
  submitNotification.value = true;

  // set the email field values
  snsubject = document.getElementById("snsubject");
  snsubject.value = "Event Approved: " + eventTitle;
  sntext = document.getElementById("sntext");
  var message;
  message = "Your event has been approved and is now published.\n\n";
  message += "EVENT DETAILS\n-------------\n";
  message += "Title: " + eventTitle + "\n";
  message += "URL: " + eventUrlPrefix + "&calPath=" + approvedCal;
  sntext.value = message;

  // Send the names of xproperties we wish to retain after we publish.
  // Those not listed will be thrown away
  // but must first be passed to the backend for use
  // (e.g. the email address of the submitter).
  var xpropPreserve = [bwXPropertyAlias, bwXPropertyImage, bwXPropertySubmittedBy];

  for (var i = 0; i < xpropPreserve.length; i++) {
    var xpropPreserveField = document.createElement("input");
    xpropPreserveField.type = "hidden"; // change type prior to appending to DOM
    formObj.appendChild(xpropPreserveField);
    xpropPreserveField.name = "xprop-preserve";
    xpropPreserveField.value = xpropPreserve[i];
  }
}

function doRejectEvent(formObj, eventTitle, eventDatesForEmail){
  // If email notification is enabled, set field to true
  // (set to 'true' for now to get the feature working)
  formObj.submitNotification.value = true;

  // set the email field values
  formObj.snsubject.value = "Event Rejected: " + eventTitle;

  var message;
  message = "Your event has been rejected.\n\n";
  message += "EVENT DETAILS\n-------------\n";
  message += "Event Title: " + eventTitle + "\n";
  message += "Event Dates: " + eventDatesForEmail + "\n\n\n";
  if (trim(formObj.reason.value) != '') {
    message += "Reason:\n";
    message += formObj.reason.value;
  }
  formObj.sntext.value = message;
}
function setOverwriteImageField(chkBox) {
  if(chkBox.checked) {
    $("#replaceImage").attr('checked','checked');
  } else {
    $("#replaceImage").removeAttr('checked');
  }
}
/* checkboxes for all suggestion
   groups and preferred suggestion groups are on the page
   simultaneously.  The user can toggle between which group is shown and which is
   hidden.  When a checkbox from one collection is changed, the corresponding
   checkbox should be changed in the other set if it exists. */
function setCollChBx(thisID,otherID) {
  thisCollCheckBox = document.getElementById(thisID);
  if (document.getElementById(otherID)) {
    otherCollCheckBox = document.getElementById(otherID);
    otherCollCheckBox.checked =  thisCollCheckBox.checked;
  }
}
function processLocationsPrimary(locations,selectedUid) {
// Process bwLocation options returned by ajax call
  var locs = new Array();
  var locOptions = "";
  var lastAddress = "";
  var selectedLocIndex = -1;
  var selectedLocText = "";

  // build an array of primary addresses + the selected location
  $(locations).each(function() {
    if (this.addressField != undefined) {
      if (this.uid == selectedUid) {
        locs.push([this.uid,this.addressField]);
        lastAddress = this.addressField;
        selectedLocIndex = locs.length - 1;
        selectedLocText = this.addressField;
      } else if (lastAddress != this.addressField) {
        locs.push([this.uid,this.addressField]);
        lastAddress = this.addressField;
      }
    }
  });

  /* If our selected location is not in the first position
     for the primary address, we will end up with
     a duplicate entry that we'll now remove */
  if (selectedLocIndex != -1) {
    for (var i=0; i<locs.length; i++) {
      if((i != selectedLocIndex) && (locs[i][1] == selectedLocText)) {
        locs.splice(i,1);
        break;
      }
    }
  }

  // Finally convert the resulting array into a string of html options tags
  for (var i=0; i<locs.length; i++) {
    locOptions += "<option value=\"" + locs[i][0] + "\"";
    if (locs[i][0] == selectedUid) {
      locOptions += ' selected="selected" ';
    }
    locOptions += ">" + locs[i][1] + "</option>";
  }

  return locOptions;
}
function processLocationsSecondary(locations,key,emptyText,selectedUid) {
// Gather the sublocations associated with a primary address
  var locOptions = "";
  $(locations).each(function() {
    if (this.addressField != undefined) {
      if (this.addressField == key) {
        if (this.roomField == undefined) { // there is no room field; just use the primary address
          locOptions += "<option value=\"" + this.uid + "\"";
          if (this.uid == selectedUid) {
            locOptions += ' selected="selected" ';
          }
          locOptions += ">" + emptyText + "</option>";
        } else {
          locOptions += "<option value=\"" + this.uid + "\"";
          if (this.uid == selectedUid) {
            locOptions += ' selected="selected" ';
          }
          locOptions += ">" + this.roomField + "</option>";
        }
      }
    }
  });
  return locOptions;
}
/**
 * Determine if a location is selected yet.
 * Used to turn off the add room link.
 */
function bwCheckPrimaryLoc() {
  var currentAddrUid = $("#bwLocationsPrimary option:selected").val();
  if (currentAddrUid == undefined || currentAddrUid == "") {
    return false;
  }
  return true;
}
/**
 * Launch the add room popup box
 */
function bwAddRoomInit() {
  // set up the form
  var currentAddrTxt = $("#bwLocationsPrimary option:selected").text();
  var currentAddrUid = $("#bwLocationsPrimary option:selected").val();
  $("#bwAddRoomAddress").html(currentAddrTxt);
  $("#bwAddRoomUid").val(currentAddrUid);
  $("#bwAddRoomContainer").removeClass("invisible");
}
/**
 * Add a room to a location
 */
function bwAddRoom() {
  var roomName = $("#bwAddRoomName").val();
  var locationUid = $("#bwAddRoomUid").val();
  $.ajax({
    type: "POST",
    url: "/caladmin/location/addsub.gdo",
    data: {
      uid: locationUid,
      sub: roomName
    },
    success: function(response) {
      if(response.uid != undefined) {
        // we have a new location (room) - set the list display and the hidden field
        bwSetupLocations(response.uid);
        $("#bwLocation").val(response.uid);
      } else {
        // must have been a problem; just keep the original selection in place
        bwSetupLocations(locationUid);
      }
      $("#bwAddRoomLink").magnificPopup("close");
    }
  })
  .fail(function(jqxhr, textStatus, error ) {
    alert("There was an error saving the room.");
    if (bwJsDebug) {
      var err = textStatus + ", " + error;
      console.log( "Add room failed: " + err );
    }
  });
}
