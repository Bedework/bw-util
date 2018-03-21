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

/* Preferences and Scheduling */
// build the workdays parameter as a string when submitting user preferences form
function setWorkDays(formObj) {
  if (formObj) {
    var workDays = "";
    for (i=0; i<7; i++) {
      if (formObj.workDayIndex[i].checked) {
        workDays += "W";
      } else {
        workDays += "n";
      }
    }
    formObj.workDays.value = workDays;
  } else {
    alert("The preferences form is not available.");
  }
}
function setScheduleHow(formObj) {
  if (formObj.howSetter[0].checked == true) {
    formObj.how.value = formObj.howSetter[0].value;
  } else {
    var access = new Array();
    // gather up the access characters - begin on the second element
    for (i = 1; i < formObj.howSetter.length; i++) {
      if (formObj.howSetter[i].checked == true) {
        access.push(formObj.howSetter[i].value);
      }
    }
    formObj.how.value = access.join('');
  }

  if (debug) {
    alert(formObj.how.value);
  }
}
function toggleScheduleHow(formObj,chkBox) {
  if (chkBox.checked == false) {
    // we start on the second checkbox element
    for (i = 1; i < formObj.howSetter.length; i++) {
      formObj.howSetter[i].disabled = false;
    }
  } else {
    for (i = 1; i < formObj.howSetter.length; i++) {
      formObj.howSetter[i].checked = true;
      formObj.howSetter[i].disabled = true;
    }
  }
}
function swapScheduleDisplay(val) {
  if (val == "show") {
    changeClass('scheduleLocationEdit','visible');
    changeClass('scheduleDateEdit','visible');
  } else {
    changeClass('scheduleLocationEdit','invisible');
    changeClass('scheduleDateEdit','invisible');
  }
}
function toggleAutoRespondFields(val) {
  if (val == "true") {
    document.getElementById("scheduleDoubleBookTrue").disabled = false;
    document.getElementById("scheduleDoubleBookFalse").disabled = false;
    document.getElementById("scheduleAutoCancelAction").disabled = false;
  } else {
    document.getElementById("scheduleDoubleBookTrue").disabled = true;
    document.getElementById("scheduleDoubleBookFalse").disabled = true;
    document.getElementById("scheduleAutoCancelAction").disabled = true;
  }
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
  $('#defaultTzid').html(defaultTzOptions);
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
