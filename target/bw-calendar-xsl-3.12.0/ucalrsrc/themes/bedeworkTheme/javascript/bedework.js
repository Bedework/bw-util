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

/* NOTE: this file is different between Bedework web applications and is
   therefore not currently interchangable between apps.  This will be normalized
   in the coming versions, but for now don't try to exchange them. */

/* Global variables / properties */
// URLs
var timezoneUrl = "/tzsvr/?names";
var carddavUrl = "/ucarddavweb/find";

var debug = false; // very basic debugging for now

/* COMMON and GENERAL FUNCTIONS */

function changeClass(id, newClass) {
  var identity = document.getElementById(id);
  if (identity == null) {
    alert("No element with id: " + id + " to set to class: " + newClass);
  }
  identity.className=newClass;
}
// set a field's value by ID
// typically used to set the value of a hidden field
function setField(id,val) {
  field = document.getElementById(id);
  field.value = val;
}
// show hide items using a checkbox
function swapVisible(obj,id) {
  if (obj.checked) {
    changeClass(id,'visible');
  } else {
    changeClass(id,'invisible');
  }
}
// hide a group of items
// send IDs as parameters
function hide() {
  if (arguments.length != 0) {
    for (i = 0; i < arguments.length; i++) {
      changeClass(arguments[i],'invisible');
    }
  }
}
// show a group of items
// send IDs as parameters
function show() {
  if (arguments.length != 0) {
    for (i = 0; i < arguments.length; i++) {
      changeClass(arguments[i],'visible');
    }
  }
}
// show and hide an item based on its current
// visibility; if visible, hide it; if invisible
// show it.
function toggleVisibility(id,newClass) {
  if (document.getElementById(id).className == 'invisible') {
    if (newClass != "") {
      changeClass(id,newClass);
    } else {
      changeClass(id,'visible');
    }
  } else {
    changeClass(id,'invisible');
  }
}
// Toggle action icons box visibility at the selected position and
// set any open action icon boxes to invisible.
// Action icon boxes are used in the calendar grid - their ids are
// built from a prefix plus the day number; the box identified by zero is the topmost box
// associated with the "add..." button.  Id's will therefore be prefix-0 through
// prefix-31
function toggleActionIcons(id,cl) {
  var dash = id.indexOf("-");
  var boxNum = id.substring(dash+1);
  var prefix = id.substring(0,dash);
  var currentBox;
  for (i = 0; i < 32; i++) {
    currentBox = prefix + "-" + i;
    if (i != boxNum && document.getElementById(currentBox)) {
      changeClass(currentBox,"invisible");
    }
  }
  toggleVisibility(id,cl);
}
function setTab(listId,listIndex) {
  var list = document.getElementById(listId);
  var elementArray = new Array();
  for (i = 0; i < list.childNodes.length; i++) {
    if (list.childNodes[i].nodeName == "LI") {
      elementArray.push(list.childNodes[i]);
    }
  }
  for (i = 0; i < elementArray.length; i++) {
    if (i == listIndex) {
      elementArray[i].className = 'selected';
    } else {
      elementArray[i].className = '';
    }
  }
}
function getSelectedRadioButtonVal(radioCollection) {
  for(var i = 0; i < radioCollection.length; i++) {
    if(radioCollection[i].checked == true) {
       return radioCollection[i].value;
    }
  }
}
// returns an array of collected checkbox values
function collectRecurChkBoxVals(valArray,chkBoxes,dayPos) {
  if (chkBoxes) {
    if (typeof chkBoxes.length != 'undefined') {
      for (i = 0; i < chkBoxes.length; i++) {
        if (chkBoxes[i].checked == true) {
          if (dayPos) {
            valArray.push(dayPos + chkBoxes[i].value);
          } else {
            valArray.push(chkBoxes[i].value);
          }
        }
      }
    }
  }
  return valArray;
}
// launch a simple window for displaying information; no header or status bar
function launchSimpleWindow(URL) {
  simpleWindow = window.open(URL, "simpleWindow", "width=800,height=600,scrollbars=yes,resizable=yes,alwaysRaised=yes,menubar=no,toolbar=no");
  window.simpleWindow.focus();
}

// launch a size parameterized window for displaying information; no header or status bar
function launchSizedWindow(URL,width,height) {
  paramStr = "width=" + width + ",height=" + height + ",scrollbars=yes,resizable=yes,alwaysRaised=yes,menubar=no,toolbar=no";
  sizedWindow = window.open(URL, "sizedWindow", paramStr);
  window.sizedWindow.focus();
}

// launches new browser window with print-friendly version of page when
// print icon is clicked
function launchPrintWindow(URL) {
  printWindow = window.open(URL, "printWindow", "width=640,height=500,scrollbars=yes,resizable=yes,alwaysRaised=yes,menubar=yes,toolbar=yes");
  window.printWindow.focus();
}
// launch the calSelect pop-up window for selecting a calendar when creating,
// editing, and importing events
function launchCalSelectWindow(URL) {
  calSelect = window.open(URL, "calSelect", "width=500,height=600,scrollbars=yes,resizable=yes,alwaysRaised=yes,menubar=no,toolbar=no");
  window.calSelect.focus();
}
// launch a dojo widget used for contextual help
/*function launchHelpWidget(id) {
  var helpWidget = dojo.widget.byId(id);
  helpWidget.show();
}*/
// used to update the calendar in various forms from
// the calSelect pop-up widget.  We must do three things: update the hidden
// calendar input field, update the displayed text, and close widget
function updateEventFormCalendar(newCalPath,calDisplay,calendarCollection) {
  newCalPathField = document.getElementById("bwNewCalPathField");
  newCalPathField.value = newCalPath;
  bwCalDisplay = document.getElementById("bwEventCalDisplay");
  bwCalDisplay.innerHTML = "<strong>" + calDisplay + "</strong>";
  bwCalCollectionField = document.getElementById("bwCalCollectionField");
  if (bwCalCollectionField && calendarCollection != '') {
    bwCalCollectionField.value = calendarCollection;
  }
  changeClass("calSelectWidget","invisible");
}
// used to update a calendar subscription (alias) We must do two things: update the hidden
// calendar input field and update the displayed text
function updatePublicCalendarAlias(newCalPath,calDisplay,calendarCollection) {
  var calendarAliasHolder = document.getElementById("publicAliasHolder");
  var bwCalDisplay = document.getElementById("bwPublicCalDisplay");
  var calDisplayName = document.getElementById("intSubDisplayName");
  calendarAliasHolder.value = newCalPath;
  calDisplayName.value = calDisplay.substring(calDisplay.lastIndexOf("/")+1);
  bwCalDisplay.innerHTML = '<strong>' + calDisplay + '</strong> <button type="button" onclick="showPublicCalAliasTree();">change</button>';
  changeClass("publicSubscriptionTree","invisible");
  changeClass("bwPublicCalSubscribe","visible");
}
function showPublicCalAliasTree() {
  changeClass("publicSubscriptionTree","calendarTree");
}
// set the subscription URI when creating or updating a subscription
function setCalendarAlias(formObj) {
  if (!formObj) {
    alert("The subscription form is not available.");
    return false;
  }

  //check first to make sure we have a valid calendar system name:
  if (validateCalName(formObj['calendar.name'])) {

    // set the aliasUri to an empty string.  Only set it if user
    // has requested a subscription.
    if (formObj.aliasUri != undefined) {
      formObj.aliasUri.value == "";
      switch (formObj.subType.value) {
        case "public":
          formObj.aliasUri.value = "bwcal://" + formObj.publicAliasHolder.value;
          break;
        case "user":
          //the "/user/" string is temporary; it needs to be passed as a param.
          formObj.aliasUri.value = "bwcal:///user/" + formObj.userIdHolder.value + "/" + formObj.userCalHolder.value;
          break;
        case "external":
          formObj.aliasUri.value = formObj.aliasUriHolder.value;
          break;
      }
    }
    return true;
  } else {
    return false;
  }
}
// set the calendar summary to the calendar name in the form if summary is empty
function setCalSummary(val,summaryField) {
  if (summaryField.value == '') {
    summaryField.value = val;
  }
}
//Stop user from entering invalid characters in calendar names
//In 3.6 this will only test for & ' " and /
//In future releases, we will go further and only allow
//alphanumerics and dashes and underscores.
function validateCalName(nameObj) {
  if(nameObj.value.indexOf("'") == -1 &&
    nameObj.value.indexOf('"') == -1 &&
    nameObj.value.indexOf("&") == -1 &&
    nameObj.value.indexOf("/") == -1) {
   return true;
  } else { // we have bad characters
   var badChars = "";
   if(nameObj.value.indexOf("'") != -1) {
     badChars += " ' ";
   }
   if(nameObj.value.indexOf('"') != -1) {
     badChars += ' \" ';
   }
   if(nameObj.value.indexOf("&") != -1) {
     badChars += " & ";
   }
   if(nameObj.value.indexOf("/") != -1) {
     badChars += " / ";
   }
   alert("System Names may not include the following characters: " + badChars);
   nameObj.focus();
   return false;
  }
}
function exportCalendar(formId,name,calPath) {
  var formObj = document.getElementById(formId);
  formObj.calPath.value = calPath;
  formObj.contentName.value = name + '.ics';
  formObj.submit();
}
// this toggles various elements in the access control form when
// a checkbox for All, Read, Write, Schedule, or None is clicked
function setupAccessForm(val,formObj) {
  switch (val) {
    case "A":
      alert("A");
      break;
    case "R":
      alert("R");
      break;
    case "W":
      alert("W");
      break;
    case "S":
      alert("S");
      break;
    case "N":
      alert("N");
      break;
  }
}
function setCalDisplayFlag(calDisplayFlag, val){
  calDisplayFlag.value = val;
}
function launchBwColorPicker() {
  $.ui.dialog.defaults.bgiframe = true;
  $(function() {
    $("#bwColorPicker").dialog();
  });
}
function bwUpdateColor(color,colorFieldId) {
  var colorField = document.getElementById(colorFieldId);
  colorField.value = color;
  colorField.style.backgroundColor = color;
}
function validateShareForm(acct) {
  if(acct == "") {
    alert("Please enter an account.");
    return false;
  }
}
function notificationReply(href,name,accept,colName) {
  location.href = href + "&name=" + name + "&accept=" + accept + "&colName=" + colName;
}
function notificationRemoveReply(href,notificationName) {
  $.get(href, { name: notificationName, remove: 'true'});
}
