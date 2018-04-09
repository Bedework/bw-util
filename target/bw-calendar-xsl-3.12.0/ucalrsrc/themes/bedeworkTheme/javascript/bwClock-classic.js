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

var bwClockHour = null;
var bwClockMinute = null;
var bwClockRequestedType = null;
var bwClockCurrentType = null;

function bwClockLaunch(type) {
  // type: type of clock "eventStartDate" or "eventEndDate"
  if ((document.getElementById("clock").className == "visible") && (bwClockCurrentType == type)) {
    // if the clock with the same type is visible, toggle it off
    changeClass("clock","invisible");
  } else {
    // otherwise, turn it on and display the correct type
    changeClass("clock","visible");
    bwClockRequestedType = type;
    bwClockCurrentType = type;
    // reset hours and minutes to null
    bwClockHour = null;
    bwClockMinute = null;
    var bwClockIndicator = document.getElementById("bwClockDateTypeIndicator");
    var bwClockSwitch = document.getElementById("bwClockSwitch");
    document.getElementById("bwClockTime").innerHTML = "select time";
    if (type == 'eventStartDate') {
      bwClockIndicator.innerHTML = "Start Time";
      bwClockSwitch.innerHTML = '<a href="javascript:bwClockLaunch(\'eventEndDate\');">switch to end</a>';
    } else {
      bwClockIndicator.innerHTML = "End Time";
      bwClockSwitch.innerHTML = '<a href="javascript:bwClockLaunch(\'eventStartDate\');">switch to start</a>';
    }
  }
}

function bwClockClose() {
  changeClass("clock","invisible");
}

function bwClockUpdateDateTimeForm(valType,val,hour24) {
  // valType: "hour" or "minute"
  // val: hour or minute value as integer
  // hour24: true (24hr clock) or false (12hr clock + am/pm) 
  if (bwClockRequestedType) {
    try {
      if (valType == 'minute') {
        var fieldName = bwClockRequestedType + ".minute"
        window.document.eventForm[fieldName].value = val;
        if (val < 10) {
          val = "0" + val; // pad the value for display
        }
        bwClockMinute = val;
      } else {
        var fieldName = bwClockRequestedType + ".hour"
        if (hour24) {
          window.document.eventForm[fieldName].value = val;
          if (val < 10) {
            val = "0" + val; // pad the value for display
          }
          bwClockHour = val;
        } else {
          var hour12 = val;
          if (hour12 > 12) {
            hour12 -= 12;
          } else if (hour12 == 12) {
            hour12 = 0; // noon and midnight are both represented by '0' in 12hr mode
          }
          window.document.eventForm[fieldName].value = hour12;
          if (val < 10) {
            val = "0" + val; // pad the value for display
          }
          bwClockHour = val;
          // now set the am/pm field
          fieldName = bwClockRequestedType + ".ampm";
          window.document.eventForm[fieldName].value = bwClockGetAmPm(bwClockHour);
        }
      }
      if (bwClockHour && bwClockMinute) {
        document.getElementById("bwClockTime").innerHTML = bwClockHour + ":" + bwClockMinute + " , " + bwClockConvertAmPm(bwClockHour) + ":" + bwClockMinute + " " + bwClockGetAmPm(bwClockHour);
      } else if (bwClockMinute) {
        document.getElementById("bwClockTime").innerHTML = ":" + bwClockMinute;
      } else {
        document.getElementById("bwClockTime").innerHTML = bwClockHour + " , " + bwClockConvertAmPm(bwClockHour) + " " + bwClockGetAmPm(bwClockHour);
      }
    } catch(e) {
      alert("There was an error:\n" + e );
    }
  } else {
    alert("The date type is null.");
  }
}

function bwClockConvertAmPm(hour24) {
  hour24 = parseInt(hour24,10);
  if (hour24 == 0) {
    return 12;
  } else if (hour24 > 12) {
    return hour24 - 12;
  } else {
    return hour24;
  }
}

function bwClockGetAmPm(hour24) {
  hour24 = parseInt(hour24,10);
  if (hour24 < 12) {
    return 'am';
  } else {
    return 'pm';
  }
}
