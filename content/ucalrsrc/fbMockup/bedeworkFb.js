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
// THE CONTENTS OF THIS FILE WILL MOVE INTO bedeworkAttendees.js


// ========================================================================
// free/busy functions
// ========================================================================

// Constants and RFC-5445 values 
// These should be put some place permanent
var bwAttendeeRoleChair = "CHAIR";
var bwAttendeeRoleRequired = "REQ-PARTICIPANT";
var bwAttendeeRoleOptional = "OPT-PARTICIPANT";
var bwAttendeeRoleNonParticipant = "NON-PARTICIPANT";
var bwAttendeeStatusNeedsAction = "NEEDS-ACTION";
var bwAttendeeStatusAccepted = "ACCEPTED";
var bwAttendeeStatusDeclined = "DECLINED";
var bwAttendeeStatusTentative = "TENTATIVE";
var bwAttendeeStatusDelegated = "DELEGATED";
var bwAttendeeStatusCompleted = "COMPLETED";
var bwAttendeeStatusInProcess = "IN-PROCESS";
var bwAttendeeTypePerson = "person";
var bwAttendeeTypeLocation = "location";
var bwAttendeeTypeResource = "resource";

// display strings for the values above
// should be put with other internationalized strings
// can be translated
var bwAttendeeDispRoleChair = "chair";
var bwAttendeeDispRoleRequired = "required participant";
var bwAttendeeDispRoleOptional = "optional participant";
var bwAttendeeDispRoleNonParticipant = "non-participant";
var bwAttendeeDispStatusNeedsAction = "needs action";
var bwAttendeeDispStatusAccepted = "accepted";
var bwAttendeeDispStatusDeclined = "declined";
var bwAttendeeDispStatusTentative = "tentative";
var bwAttendeeDispStatusDelegated = "delegated";
var bwAttendeeDispStatusCompleted = "completed";
var bwAttendeeDispStatusInProcess = "in-process";
var bwAttendeeDispTypePerson = "person";
var bwAttendeeDispTypeLocation = "location";
var bwAttendeeDispTypeResource = "resource";

var bwFreeBusyDispTypeBusy = "BUSY";
var bwFreeBusyDispTypeTentative = "TENTATIVE";
var bwAddAttendeeDisp = "add attendee...";

/* An attendee
 * name:            String - name of attendee, e.g. "Venerable Bede"
 * uid:             String - attendee's uid with mailto included, e.g. "mailto:vbede@example.com"
 * freebusyStrings: Array of rfc5545 freebusy reply values for the current attendee in the current date range
 * role:            String - Attendee role, e.g. CHAIR, REQ-PARTICIPANT, etc
 * status:          String - participation status (PARTSTAT)
 * type:            String - person, location, other resource
 * selected:        Boolean - if attendee is included in picknext selections (checkbox next to attendee in grid) 
 */
var bwAttendee = function(name, uid, freebusyStrings, role, status, type) {
  this.name = name;
  this.uid = uid;
  this.freebusy = new Array();
  this.role = role;
  this.status = status;
  this.type = type;
  this.selected = true;
  
  //populate the freebusy objects
  for (i = 0; i<freebusyStrings.length; i++) {
    var fb = new bwFreeBusy(freebusyStrings[i]);
    this.freebusy.push(fb);
  }
  
  if (this.type == null || this.type == "") {
    this.type == bwAttendeeTypePerson;
  }
}
/* A Freebusy object
 * Provides methods to work on freebusy values
 * fbString: an rfc5545 freebusy string, including FBTYPE parameter if present 
 */
var bwFreeBusy = function(fbString) {
  this.name = fbString;  
  this.params = "";    // if there are parameters, we will split them from the name and put them here
  this.type = bwFreeBusyDispTypeBusy; // default rfc5545 FBTYPE, "BUSY"
  this.start = "";    // will hold the UTC start value in milliseconds 
  this.end = "";      // will hold the UTC end value in milliseconds
  
  if (this.name.match(":")) {
    // parameters are included with the freebusy string
    // e.g. FBTYPE=BUSY:19980415T133000Z/19980415T170000Z 
    this.name = fbString.substr(fbString.indexOf(":")+1);
    this.params = fbString.substring(0,fbString.indexOf(":"));
  }
  
  if (this.params.match("FBTYPE=BUSY-TENTATIVE")) {
    this.type = bwFreeBusyDispTypeTentative;
  }
  
  // set the freebusy start date
  var startDate = new Date();
  startDate.setUTCFullYear(this.name.substring(0,4),this.name.substring(4,6)-1,this.name.substring(6,8));
  startDate.setUTCHours(this.name.substring(9,11),this.name.substring(11,13),this.name.substring(13,15));
  
  // set the start in milliseconds
  this.start = startDate.getTime();

  var endMs; // end in milliseconds
  if (this.name.indexOf("P") > -1) {
    // freebusy value is of the form: 19971015T223000Z/PT6H30M
    // extract the hours and minutes from the strings and cast as numbers  
    var durationHours = this.name.substring(this.name.lastIndexOf("T")+1,this.name.indexOf("H"));
    var durationMins = this.name.substring(this.name.indexOf("H")+1,this.name.indexOf("M"));
    // calculate the duration
    var duration = (Number(durationHours) * 3600000) + (Number(durationMins) * 60000);
    // set start and end in milliseconds 
    endMs = this.start + duration;
  } else { 
    // freebusy value is of the form: 19980314T233000Z/19980315T003000Z
    // set the freebusy end date
    var endDate = new Date();
    endDate.setUTCFullYear(this.name.substring(17,21),this.name.substring(21,23)-1,this.name.substring(23,25));
    endDate.setUTCHours(this.name.substring(26,28),this.name.substring(28,30),this.name.substring(30,32));
    endMs = endDate.getTime();
  }
  
  // set the end in milliseconds
  this.end = endMs;
    
  /* returns true if a date is contained in this freebusy value
   * mils: date/time in milliseconds
   */  
  this.contains = function(mils) {
    if (mils >= this.start && mils < this.end) {
      return true;
    }
    return false;
  }
}

/* Object to model the freebusy grid
 * displayId:       ID of html block for display output
 * startRange:      js date string - start of date range for grid
 * endRange:        js date string - end of date range for grid
 * startHoursRange: integer, 0-23 - hours of range start time (we'll use all minutes in an hour)
 * endHoursRange:   integer, 0-23 - hours of range end time  (we'll use all minutes in an hour)
 * startDate:       js date string - start date/time for meeting
 * endDate:         date string - end date/time for meeting
 * attendees:       array   - array of attendee objects; MUST include organizer on first instantiation
 * workday:         boolean - true to display workday hours only, false to display all 24 hours
 * zoom:            integer - scalar value for zooming the grid
 */
var bwSchedulingGrid = function(displayId, startRange, endRange, startDate, endDate, startHoursRange, endHoursRange, attendees, workday, zoom) {
  this.displayId = displayId;
  this.startRange = new Date(startRange);
  this.endRange = new Date(endRange);
  this.startHoursRange = startHoursRange;
  this.endHoursRange = endHoursRange; 
  this.startDate = new Date(startDate);
  this.endDate = new Date(endDate);
  this.zoom = zoom;
  this.workday = workday;
  this.attendees = new Array();  // array of bwAttendee objects
  
  // 2D array of time and busy state for all attendees
  // [millisecond value,true/false if busy]
  // this value is initialized when we draw the allAttendees row
  this.fb = new Array();  
  // a lookup table of free times based on the duration of the meeting, calculated from the fb array
  this.freeTime = new Array();
  this.freeTimeIndex = 0;
  
  // initialize any incoming attendees on first load
  for (i = 0; i < attendees.length; i++) {
    var newAttendee = new bwAttendee(attendees[i].name,attendees[i].uid ,attendees[i].freebusy,attendees[i].role,attendees[i].status,attendees[i].type);
    this.attendees.push(newAttendee); 
  }
    
  // how much will we divide the hour in the grid?
  // ALWAYS set as a factor of 60 and never below 1
  // Be forewarned: changing this value quantizes the set of
  // times to be displayed, e.g. hourDivision = 4 quantizes the 
  // display to 15 minute increments; hourDivision = 1 locks the events to the
  // nearest hour (not a good outcome)
  // 4, 6, or 12 is preferred (and higher begins to slow down the display)
  // If in doubt, leave this at 4
  this.hourDivision = 4;
  
  // internal variables
  var hourMils = 3600000;
  var startMils = Number(this.startRange.getTime()) + Number(this.startHoursRange * hourMils); // the start of the grid
  var durationMils = hourMils; // value used to calculate default endSelectionMils, defaults to 1 hour in milliseconds 
  var incrementMils = hourMils / this.hourDivision; // increment for the pick next/previous buttons
  var startSelectionMils = startMils;  // where a mouse selection begins, milliseconds parsed from the first half of a fbcell's ID, default to beginning of grid
  var endSelectionMils;       // where a mouse selection ends, milliseconds parsed from the first half of a fbcell's ID
  var selecting = false;      // are we currently selecting?  If true, we'll highlight as we hover
  var cellsInDuration = durationMils / incrementMils; // calculate the number of cells in the duration for use in setting freeTime lookup
  var pickNextClicked = false; // false until the first time we click "pick next" - allows us to show the first free time window on first click
  

  this.addAttendee = function(name, uid, freebusy, role, status, type) {
    var newAttendee = new bwAttendee(name, uid, freebusy, role, status, type);
    this.attendees.push(newAttendee);
    
    this.display();
  }
  
  this.removeAttendee = function(index) {
    this.attendees.splice(index, 1);
    this.display();
  }
  
  this.pickNext = function() {
    // clear highlighting
    $("#bwScheduleTable .fbcell").removeClass("highlight");
    
    // go to the next freeTime if available and highlight it
    // don't increment if it's the very first time we've clicked the button
    if (this.freeTimeIndex < this.freeTime.length - 1 && pickNextClicked) {
      this.freeTimeIndex += 1;
    }
    
    // set the start of the selection range using the freeTimeIndex
    var curSelectionTime = Number(this.freeTime[this.freeTimeIndex]);
    // set the end time by adding the duration
    endSelectionMils = Number(curSelectionTime) + Number(durationMils);
    
    // now do the highlighting
    $("#bwScheduleTable .fbcell").each(function(index) {
      var splId = $(this).attr("id").split("-");
      if (splId[0] >= curSelectionTime && splId[0] < endSelectionMils) {
        $(this).addClass("highlight");
      }
    });
    
    // we've clicked pickedNext - so set the pickNextClicked flag to true
    // this flag lets us highlight the very first free time window on first click
    pickNextClicked = true;
  } 
  
  this.pickPrevious = function(gridObj) {
    // clear highlighting
    $("#bwScheduleTable .fbcell").removeClass("highlight");
    
    // go to the previous freeTime if available and highlight it
    if (this.freeTimeIndex > 0) {
      this.freeTimeIndex -= 1;
    }
    // set the start of the selection range using the freeTimeIndex
    var curSelectionTime = Number(this.freeTime[this.freeTimeIndex]);
    // set the end time by adding the duration
    endSelectionMils = Number(curSelectionTime) + Number(durationMils);
    
    // now do the highlighting
    $("#bwScheduleTable .fbcell").each(function(index) {
      var splId = $(this).attr("id").split("-");
      if (splId[0] >= curSelectionTime && splId[0] < endSelectionMils) {
        $(this).addClass("highlight");
      }
    });
  }
  
  // create the lookup values for a free window for use with picknext/previous
  this.setFreeTime = function() {
    // this assumes we have a properly populated fb array
    
    // empty the array
    this.freeTime.length = 0;
    
    // now look over the next group of cells to see if the range
    // we want to select is busy.  If not, store the value for lookup.
    for (i=0; i <= this.fb.length - cellsInDuration; i++) {
      var rangeNotBusy = true;
      for (j = i; j < i + cellsInDuration; j++) {
        if (this.fb[j][1]) { // we hit a busy cell
          rangeNotBusy = false; 
        }         
      }
      if (rangeNotBusy) {
        this.freeTime.push(this.fb[i][0]);  
      }
    }
  }
  
  this.setIncrement = function(val) {
    this.hourDivision = val;
    this.display();
  }
  
  this.display = function() {
    try {
      // number of days to display
      var range = dayRange(this.startRange, this.endRange);
      // number of hours to display
      var hourRange = this.endHoursRange - this.startHoursRange;
      var startHour = this.startHoursRange;
      
      if (!workday) {
        // show full 24 hours in grid
        hourRange = 24;
        startHour = 0;
      }
      
      var cellsInDay = hourRange * this.hourDivision;
    
      // build the entire free/busy table
      var fbDisplay = document.createElement("table");
      fbDisplay.id = "bwScheduleTable";
      
      // generate the date row - includes top left empty corner 
      var fbDisplayDateRow = fbDisplay.insertRow(fbDisplay.rows.length);
      $(fbDisplayDateRow).html('<td rowspan="2" colspan="4" class="corner"></td><td class="fbBoundry"></td>');
      for (i=0; i < range; i++) {
        var curDate = new Date(this.startRange); 
        curDate.addDays(i);
        $(fbDisplayDateRow).append('<td class="date" colspan="' + cellsInDay + '">' + curDate.getDayName() + ', ' + curDate.getMonthName() + ' ' + curDate.getDate() + ', ' + curDate.getFullYear() + '</td><td class="dayBoundry"></td>');
      }
      
      // generate the times row - each cell spans over the day divisions
      fbDisplayTimesRow = fbDisplay.insertRow(fbDisplay.rows.length);
      $(fbDisplayTimesRow).html('<td class="fbBoundry"></td>');
      for (i=0; i < range; i++) {
        var curDate = new Date(this.startRange); 
        curDate.setHours(startHour);
        curDate.addDays(i);
        // add the time cells by iterating over the hours
        for (j = 0; j < hourRange; j++) {
          // this is where we could use zoom to increase or decrease tick marks and time labels on the grid
          if (this.zoom == 100) {
            $(fbDisplayTimesRow).append('<td class="hourBoundry" id="' + curDate.getTime() + '-TimeRow" colspan="' + this.hourDivision + '">' + curDate.getHours12() + ':' + curDate.getMinutesFull() + '</td>');
            curDate.addHours(1);
          }
        }
        $(fbDisplayTimesRow).append('<td class="dayBoundry"></td>');
      }
      
      // empty out the fb array so we can refill it
      this.fb.length = 0;

      // generate the "All Attendees" row, and populate the (now empty) fb array
      fbDisplayTimesRow = fbDisplay.insertRow(fbDisplay.rows.length);
      $(fbDisplayTimesRow).addClass("allAttendees");
      $(fbDisplayTimesRow).html('<td class="status"></td><td class="role"></td><td class="name">All Attendees</td><td></td><td class="fbBoundry"></td>');
      for (i=0; i < range; i++) {
        var curDate = new Date(this.startRange); 
        curDate.setHours(startHour);
        curDate.addDays(i);
        // add the time cells by iterating over the hours
        for (j = 0; j < hourRange; j++) {
          for (k = 0; k < this.hourDivision; k++) {
            var fbCell = document.createElement("td");
            var timeClass = curDate.getTime().toString();
            fbCell.id = timeClass + "-AllAttendees";
            $(fbCell).addClass("fbcell");
            $(fbCell).addClass(timeClass);
            if (curDate.getMinutes() == 0 && j != 0) {
              $(fbCell).addClass("hourBoundry");
            } 
            // create a hash of the freebusy time/busy state, default to false
            this.fb.push([timeClass,false]);     
            // set busy if any freebusy in this timeperiod
            loop1: // since we only need to know if anyone is busy, provide a simple means of breaking from the inner loop
            for (att = 0; att < this.attendees.length; att++) {
              for (m = 0; m < this.attendees[att].freebusy.length; m++) {
                var tzoffset = -curDate.getTimezoneOffset() * 60000; // in milliseconds
                // adding the hourdivision increment in the calculation below is to correct for a bug
                // in which the class was always offset by one table cell - should find cause
                var curDateUTC = curDate.getTime() + tzoffset + (60 / this.hourDivision * 60000);
                if (this.attendees[att].freebusy[m].contains(curDateUTC) && this.attendees[att].selected) {
                  $(fbCell).addClass("busy");
                  // change the last added fb in the hash to true
                  this.fb[this.fb.length - 1][1] = true;             
                  break loop1;
                }
              }
                          
            }
            $(fbDisplayTimesRow).append(fbCell);
            curDate.addMinutes(60/this.hourDivision);
          }
        }
        $(fbDisplayTimesRow).append('<td class="dayBoundry"></td>');
      }
      
      // generate the regular attendees rows
      for (attendee = 0; attendee < this.attendees.length; attendee++) {
        fbDisplayAttendeeRow = fbDisplay.insertRow(fbDisplay.rows.length);
        var curAttendee = this.attendees[attendee];
        
        // if the current attendee is deselected, mark the row as such
        if (!curAttendee.selected) {
          $(fbDisplayAttendeeRow).addClass("deselected");
        }
        
        // set the status icon and class 
        // the status class is used for rollover descriptions of the icon
        switch (curAttendee.status) {
          case bwAttendeeStatusAccepted: // &#10004; - make an image to avoid font issues
            $(fbDisplayAttendeeRow).html('<td class="status accepted"><span class="icon"><img src="check.gif" alt="accepted" width="15" height="15"/></span><span class="tip">' + bwAttendeeDispStatusAccepted + '</span></td>');
            break;
          case bwAttendeeStatusDeclined:
            $(fbDisplayAttendeeRow).html('<td class="status declined"><span class="icon">x</span><span class="tip">' + bwAttendeeDispStatusDeclined + '</span></td>');
            break;
          case bwAttendeeStatusTentative:
            $(fbDisplayAttendeeRow).html('<td class="status tentative"><span class="icon">-</span><span class="tip">' + bwAttendeeDispStatusTentative + '</span></td>');
            break;
          case bwAttendeeStatusDelegated:
            $(fbDisplayAttendeeRow).html('<td class="status delegated"><span class="icon"></span><span class="tip">' + bwAttendeeDispStatusDelegated + '</span></td>');
            break;
          case bwAttendeeStatusCompleted:
            $(fbDisplayAttendeeRow).html('<td class="status completed"><span class="icon"></span><span class="tip">' + bwAttendeeDispStatusCompleted + '</span></td>');
            break;
          case bwAttendeeStatusInProcess:
            $(fbDisplayAttendeeRow).html('<td class="status inprocess"><span class="icon"></span><span class="tip">' + bwAttendeeDispStatusInProcess + '</span></td>');
            break;
          default: // default to bwAttendeeStatusNeedsAction - display question mark
            $(fbDisplayAttendeeRow).html('<td class="status needsaction"><span class="icon">?</span><span class="tip">' + bwAttendeeDispStatusNeedsAction + '</span></td>');
        }
        
        // set the role icon
        // the role class is used for rollover descriptions of the icon
        switch (curAttendee.role) {
          case bwAttendeeRoleChair: // displays writing hand icon - &#9997;
            $(fbDisplayAttendeeRow).append('<td class="role chair"><span class="icon"><img src="chair.gif" alt="chair" width="17" height="15"/></span><span class="tip">' + bwAttendeeDispRoleChair + '</span></td>');
            break;
          case bwAttendeeRoleRequired: // displays right-pointing arrow icon - &#10137;
            $(fbDisplayAttendeeRow).append('<td class="role required"><span class="icon"><img src="reqArrow.gif" alt="required" width="17" height="12"/></span><span class="tip">' + bwAttendeeDispRoleRequired + '</span></td>');
            break;
          case bwAttendeeRoleNonParticipant: // non-participant
            $(fbDisplayAttendeeRow).append('<td class="role nonparticipant"><span class="icon">x</span><span class="tip">' + bwAttendeeDispRoleNonParticipant + '</span></td>');
            break;
          default: // bwAttendeeRoleOptional - no icon (use a space to provide a rollover)
            $(fbDisplayAttendeeRow).append('<td class="role optional"><span class="icon">&#160;</span><span class="tip">' + bwAttendeeDispRoleOptional + '</span></td>');
        }
        
        
        // output the attendee name or address (depending on which we have available)
        // and add attendee functions
        var attendeeAddress = curAttendee.uid.substr(curAttendee.uid.lastIndexOf(":") + 1);
        var attendeeNameHtml = '<td class="name"><span class="bwAttendee" id="' + attendeeAddress + '">';
        if (curAttendee.name && curAttendee.name != "") {
          attendeeNameHtml += curAttendee.name;
        } else {
          attendeeNameHtml += attendeeAddress;
        }
        attendeeNameHtml += '</span>';
        //attendeeNameHtml += '<div id="' + attendeeAddress + '-menu" class="attendeeMenu">hi</div>';
        attendeeNameHtml += '</td>';
        $(fbDisplayAttendeeRow).append(attendeeNameHtml);
        
        // output delete mark and checkbox for attendee
        if (curAttendee.selected) {
          $(fbDisplayAttendeeRow).append('<td class="check"><span id="' + attendeeAddress + '-rm" class="removeAttendee">x</span> <input type="checkbox" checked="checked" name="selectedToggle" class="selectedToggle"/></td><td class="fbBoundry"></td>');
        } else {
          $(fbDisplayAttendeeRow).append('<td class="check"><span id="' + attendeeAddress + '-rm" class="removeAttendee">x</span> <input type="checkbox" name="selectedToggle" class="selectedToggle"/></td><td class="fbBoundry"></td>');
        }
        
        
        // build the time row for an attendee
        for (i = 0; i < range; i++) {
          var curDate = new Date(this.startRange);
          curDate.setHours(startHour);
          curDate.addDays(i);
          // add the time cells by iterating over the hours
          for (j = 0; j < hourRange; j++) {
            for (k = 0; k < this.hourDivision; k++) {
              var fbCell = document.createElement("td");
              fbCell.id = curDate.getTime() + "-" + curAttendee.uid.substr(curAttendee.uid.lastIndexOf(":") + 1);
              $(fbCell).addClass("fbcell");
              $(fbCell).addClass(curDate.getTime().toString());
              if (curDate.getMinutes() == 0 && j != 0) {
                $(fbCell).addClass("hourBoundry");
              }
              for (m = 0; m < curAttendee.freebusy.length; m++) {
                var tzoffset = -curDate.getTimezoneOffset() * 60000; // in milliseconds
                // adding the hourdivision increment in the calculation below is to correct for a bug
                // in which the class was always offset by one table cell - should find cause
                var curDateUTC = curDate.getTime() + tzoffset + (60 / this.hourDivision * 60000);
                if (curAttendee.freebusy[m].contains(curDateUTC)) {
                  if (curAttendee.freebusy[m].type.match("TENTATIVE")) {
                    $(fbCell).addClass("tentative");
                  } else {
                    $(fbCell).addClass("busy");
                  }
                  $(fbCell).addClass("activeCell");
                  $(fbCell).append('<span class="tip">' + curAttendee.freebusy[m].type + '</span>');
                  break;
                }
              }
              $(fbDisplayAttendeeRow).append(fbCell);
              curDate.addMinutes(60 / this.hourDivision);
            }
          }
          $(fbDisplayAttendeeRow).append('<td class="dayBoundry"></td>');
        }
      }
      
      // generate the "add attendee" row
      fbDisplayAddAttendeeRow = fbDisplay.insertRow(fbDisplay.rows.length);
      
      // create the add attendee form 
      var addAttendeeHtml = '<td class="status"></td><td class="role"></td><td class="addAttendee" colspan="2">';
      addAttendeeHtml += '<input type="text" value="' + bwAddAttendeeDisp +'" name="attendee" id="addAttendee" class="pending" size="14"/>';
      addAttendeeHtml += '<span class="addAttendeeAdvanced">advanced</span>';
      //addAttendeeHtml += '<div id="addAttendeeFields">';
      //addAttendeeHtml += '<select><option>person</option><option>group</option><option>resource</option></select>';
      //addAttendeeHtml += '<input type="checkbox"/>personal <input type="checkbox"/>public';
      //addAttendeeHtml += '</div>';
      addAttendeeHtml += '</td><td class="fbBoundry"></td>';
      
      $(fbDisplayAddAttendeeRow).html(addAttendeeHtml);
      
      for (i = 0; i < range; i++) {
        var curDate = new Date(this.startRange);
        curDate.setHours(startHour);
        curDate.addDays(i);
        // add the time cells by iterating over the hours
        for (j = 0; j < hourRange; j++) {
          for (k = 0; k < this.hourDivision; k++) {
            var fbCell = document.createElement("td");
            fbCell.id = curDate.getTime() + "-add";
            $(fbCell).addClass("fbcell");
            $(fbCell).addClass(curDate.getTime().toString());
            if (curDate.getMinutes() == 0 && j != 0) {
              $(fbCell).addClass("hourBoundry");
            } 
            $(fbDisplayAddAttendeeRow).append(fbCell);
            curDate.addMinutes(60/this.hourDivision);
          }
        }
        $(fbDisplayAddAttendeeRow).append('<td class="dayBoundry"></td>');
      }
      
      // generate a blank row at the end (this is just for visual padding)
      fbDisplayBlankRow = fbDisplay.insertRow(fbDisplay.rows.length);
      $(fbDisplayBlankRow).html('<td class="status"></td><td class="role"></td><td class="name"></td><td></td><td class="fbBoundry"></td>');
      for (i = 0; i < range; i++) {
        var curDate = new Date(this.startRange);
        curDate.setHours(startHour);
        curDate.addDays(i);
        // add the time cells by iterating over the hours
        for (j = 0; j < hourRange; j++) {
          for (k = 0; k < this.hourDivision; k++) {
            var fbCell = document.createElement("td");
            fbCell.id = curDate.getTime() + "-blank";
            $(fbCell).addClass("fbcell");
            $(fbCell).addClass(curDate.getTime().toString());
            if (curDate.getMinutes() == 0 && j != 0) {
              $(fbCell).addClass("hourBoundry");
            } 
            $(fbDisplayBlankRow).append(fbCell);
            curDate.addMinutes(60/this.hourDivision);
          }
        }
        $(fbDisplayBlankRow).append('<td class="dayBoundry"></td>');
      }
      
      // populate the freeTime lookup array from the newly created fb array
      this.setFreeTime();
      
      // write the table back to the display
      $("#" + displayId).html(fbDisplay);
      
      
      // now add some rollovers and onclick actions 
      // to the elements of the freebusy grid
      $("#bwScheduleTable .icon").hover(
        function () {
          $(this).next(".tip").fadeIn(100);
        }, 
        function () {
          $(this).next(".tip").fadeOut(100);
        }
      );  
      
      $("#bwScheduleTable .activeCell").hover(
        function () {
          $(this).children(".tip").fadeIn(20);
        }, 
        function () {
          $(this).children(".tip").fadeOut(20);
        }
      );
      
      $("#bwScheduleTable .fbcell").click (
        function () {
          // clear all previous highlighting
          $("#bwScheduleTable .highlight").removeClass("highlight");
          
          // get the id of the current cell - takes the form "1271947500000-attendeestring"
          // we want the first half, which is the same as the time class associated with the column
          var splitId = $(this).attr("id").split("-");
          
          // set the start of the selection range in milliseconds (first half of the ID)
          // we will use this to set the start time and to find cells in the same column
          startSelectionMils = splitId[0];
          endSelectionMils = Number(startSelectionMils) + Number(durationMils);
          
          // now do the highlighting
          $("#bwScheduleTable .fbcell").each(function(index) {
            var splId = $(this).attr("id").split("-");
            if (splId[0] >= startSelectionMils && splId[0] < endSelectionMils) {
              $(this).addClass("highlight");
            }
          });
          
          // set the freeTimeIndex to the nearest index for the pickNext/previous buttons
          for (i = 0; i < bwGrid.freeTime.length; i++) {
            if (Number(bwGrid.freeTime[i]) >= Number(startSelectionMils)) {
              bwGrid.freeTimeIndex = i - 1; // this will make pick previous jump an extra gap after clicking in a busy space, but it makes pick next work correctly in the same circumstance
              if (bwGrid.freeTimeIndex < 0) {
                bwGrid.freeTimeIndex = 0;
              }
              break;
            }
          }
  
        }
      );
      
      /*
      $("#bwScheduleTable .fbcell").mousedown (
        function () {
          // clear all previous highlighting
          $("#bwScheduleTable .highlight").removeClass("highlight");
          
          // get the id of the current cell - takes the form "1271947500000-attendeestring"
          // we want the first half, which is the same as the time class associated with the column
          var splitId = $(this).attr("id").split("-");
          
          // set the start of the selection range in milliseconds (first half of the ID)
          // we will use this to set the start time and to find cells in the same column
          startSelectionMils = splitId[0];
          
          // find the cells (the column) that share the same class
          $("#bwScheduleTable ." + startSelectionMils).addClass("highlight");
          
          // we are now selecting, so highlight as we go
          selecting = true;          
        }
      );

      $("#bwScheduleTable .fbcell").mouseover (
        function () {
          if (selecting) {
            // get the id of the current cell - takes the form "1271947500000-attendeestring"
            // we want the first half, which is the same as the time class associated with the column
            var splitId = $(this).attr("id").split("-");

            // find the cells (the column) that contain the first half as a class
            $("#bwScheduleTable ." + splitId[0]).addClass("highlight");
          }          
        }
      );
      
      $("#bwScheduleTable .fbcell").mouseup (
        function () {
          // we are no longer selecting
          selecting = false;
          
          // get the id of the current cell - takes the form "1271947500000-attendeestring"
          // we want the first half, which is the same as the time class associated with the column
          var splitId = $(this).attr("id").split("-");
          
          // set the end of the selection range in milliseconds (first half of the ID)
          // we will use this to set the end time / duration
          endSelectionMils = splitId[0];
          
        }
      );
      */
      
      $("#bwScheduleTable #addAttendee").click (
        function () {
          if (this.value == bwAddAttendeeDisp) {
            this.value = "";
          }
          $(this).addClass("active");
          $(this).removeClass("pending");
        }
      );
      
      $("#bwScheduleTable .removeAttendee").click (
        function () {
          var i = $("#bwScheduleTable .removeAttendee").index(this);
          bwGrid.removeAttendee(i);
        }
      );
      
      $("#bwScheduleTable input.selectedToggle").click (
        function () {
          var i = $("#bwScheduleTable input.selectedToggle").index(this);
          if (this.checked) {
             bwGrid.attendees[i].selected = true;
          } else {
             bwGrid.attendees[i].selected = false;
          }
          bwGrid.display();
        }
      );
      

    } catch (e) {
      alert(e);
    }
    
    /*var myString = "";
    for(i=0; i < this.fb.length; i++) {
      myString += this.fb[i][0]+ " " + this.fb[i][1] +"\n";
    }
    alert("Fb values:\n" + myString);
    */
  }
}



var dayRange = function(startDate, endDate) {  
  // find difference in milliseconds and return number of days.
  // 86400000 is the number of milliseconds in a day;
  return Math.round((Math.abs(startDate.getTime() - endDate.getTime())) / 86400000)
}

// DATE PROTOTYPE OVERRIDES - should be pulled into a library
// the following need to call internationalized strings - from a localeSettings file
Date.prototype.getMonthName = function() {
  var m = ['January','February','March','April','May','June','July','August','September','October','November','December'];
  return m[this.getMonth()];
}
Date.prototype.getDayName = function() {
  var d = ['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'];
  return d[this.getDay()];
} 
Date.prototype.addDays = function(days) {
  this.setDate(this.getDate() + days);
} 
Date.prototype.addHours = function(hours) {
  this.setHours(this.getHours() + hours);
}
Date.prototype.addMinutes = function(minutes) {
  this.setMinutes(this.getMinutes() + minutes);
}
// return a twelve-hour hour
Date.prototype.getHours12 = function() {
  var hours12 = this.getHours();
  if (hours12 > 12) {
    hours12 = hours12 - 12;
  } 
  return hours12;
}
// prepend minutes with zero if needed
Date.prototype.getMinutesFull = function() {
  var minutesFull = this.getMinutes();
  if (minutesFull < 10) {
    return "0" + minutesFull;
  }  
  return hours12;
}

/*
 * From RFC 5545
 * The following is an example of a "VFREEBUSY" calendar component
 used to reply to the request with busy time information:
 
 BEGIN:VFREEBUSY
 UID:19970901T095957Z-76A912@example.com
 ORGANIZER:mailto:jane_doe@example.com
 ATTENDEE:mailto:john_public@example.com
 DTSTAMP:19970901T100000Z
 FREEBUSY:19971015T050000Z/PT8H30M,
 19971015T160000Z/PT5H30M,19971015T223000Z/PT6H30M
 URL:http://example.com/pub/busy/jpublic-01.ifb
 COMMENT:This iCalendar file contains busy time information for
 the next three months.
 END:VFREEBUSY

 The following is an example of a "VFREEBUSY" calendar component
 used to publish busy time information:

 BEGIN:VFREEBUSY
 UID:19970901T115957Z-76A912@example.com
 DTSTAMP:19970901T120000Z
 ORGANIZER:jsmith@example.com
 DTSTART:19980313T141711Z
 DTEND:19980410T141711Z
 FREEBUSY:19980314T233000Z/19980315T003000Z
 FREEBUSY:19980316T153000Z/19980316T163000Z
 FREEBUSY:19980318T030000Z/19980318T040000Z
 URL:http://www.example.com/calendar/busytime/jsmith.ifb
 END:VFREEBUSY
 *
 */
