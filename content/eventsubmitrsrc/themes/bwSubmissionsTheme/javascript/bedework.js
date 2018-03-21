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

var debug = false; // very basic debugging for now

/* COMMON and GENERAL FUNCTIONS */

function changeClass(id, newClass) {
  var identity = document.getElementById(id);
  if (identity == null) {
    alert("No element with id: " + id + " to set to class: " + newClass);
  }
  identity.className=newClass;
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
function toggleVisibility(id,cl) {
  if(document.getElementById(id).className == 'invisible') {
    changeClass(id,cl);
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
// DEPRECATED - can't use pop-ups in current portal environments in a
// portal-agnostic way
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
function updateEventFormCalendar(newCalPath,calDisplay) {
  newCalPathField = document.getElementById("bwNewCalPathField");
  newCalPathField.value = newCalPath;
  bwCalDisplay = document.getElementById("bwEventCalDisplay");
  bwCalDisplay.innerHTML = calDisplay;
  changeClass("calSelectWidget","invisible");
}
// build a uri based on user and path in the subscription form
function setSubscriptionUri(formObj,prefix) {
  if (formObj) {
    var fullUri =  prefix + formObj.userId.value;
    if (formObj.userPath.value != "") {
      if (formObj.userPath.value.substring(0,1) == "/") {
        fullUri += formObj.userPath.value;
      } else {
        fullUri += "/" + formObj.userPath.value;
      }
    }
    formObj.calUri.value = fullUri;
    return true;
  } else {
    alert("The subscription form is not available.");
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
// trim function
function trim(str) {
  var trimmedStr = str.replace(/^\s+|\s+$/g, '');
  return trimmedStr.replace(/^(\&nbsp\;)+|(\&nbsp\;)+$/g, '');
}

