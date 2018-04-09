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


/** This file builds a scheduling widget for the "meeting" tab of the 
 * add/edit event form used for adding and removing attendees, observing
 * free/busy, and for picking available time in a free/busy grid. 
 *
 * @author Arlen Johnson       johnsa - rpi.edu
 * 
 * All strings used for display in this file are referenced from localeSettings.xsl
 */

// Constants and RFC-5445 values 
// Not for translation
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
var bwNonParticipant = "non-participant";
var bwNeedsAction = "needs action";
var bwAccepted = "accepted";
var bwDeclined = "declined";
var bwTentative = "tentative";
var bwDelegated = "delegated";

/* An attendee
 * name:            String - name of attendee, e.g. "Venerable Bede"
 * uid:             String - attendee's uid, e.g. "vbede@example.com"
 * role:            String - Attendee role, e.g. CHAIR, REQ-PARTICIPANT, etc
 * status:          String - participation status (PARTSTAT)
 * type:            String - person, location, other resource
 * selected:        Boolean - if attendee is included in picknext selections (checkbox next to attendee in grid) 
 */
var bwAttendee = function(name, uid, role, status, type) {
  this.name = name;
  this.uid = uid;
  this.freebusy = new Array();
  this.role = role;
  this.status = status;
  this.type = type;
  this.selected = true;
  
  // set the default type if needed
  if (this.type == null || this.type == "") {
    this.type == bwAttendeeTypePerson;
  }
    
  // function to populate the freebusy objects
  // fbObj: JSON representation of rfc5545 freebusy reply values and types for the current attendee in the current date range 
  //        as supplied by Bedework
 
  this.updateFreeBusy = function(fbObj) {
    if (fbObj) {
      // empty the freebusy array (to refresh on updates)
      this.freebusy.length = 0;
      // push the new freebusy strings into the array
      for (var i = 0; i < fbObj.length; i++) {
        var type = fbObj[i].fbtype.value;
        for (var j = 0; j < fbObj[i].periods.length; j++) {
          var fb = new bwFreeBusy(fbObj[i].periods[j].value, type);
          this.freebusy.push(fb);          
        }
      }  
    }
  };
};

/* A Freebusy object
 * Provides methods to work on freebusy values
 * fbString: an rfc5545 freebusy string 
 * fbType:   rfc5545 FBTYPE parameter 
 */
var bwFreeBusy = function(fbString, fbType) {
  this.value = fbString;  
  this.params = "";   // placeholder for parameters if we use them
  this.type = fbType; 
  this.typeDisplay = bwFreeBusyDispTypeBusy; // default rfc5545 FBTYPE, "BUSY"
  this.start = "";    // will hold the UTC start value in milliseconds 
  this.end = "";      // will hold the UTC end value in milliseconds
  
  if (this.type == "BUSY-TENTATIVE") {
    this.typeDisplay = bwFreeBusyDispTypeTentative;
  }
  
  // set the freebusy start date
  var startDate = new Date();
  startDate.setUTCFullYear(this.value.substring(0,4),this.value.substring(4,6)-1,this.value.substring(6,8));
  startDate.setUTCHours(this.value.substring(9,11),this.value.substring(11,13),this.value.substring(13,15));
  
  // set the start in milliseconds
  this.start = startDate.getTime();

  var endMs; // end in milliseconds
  if (this.value.indexOf("P") > -1) {
    // freebusy value is of the form: 19971015T223000Z\/PT6H30M
    // extract the hours and minutes from the strings and cast as numbers  
    var durationHours = this.value.substring(this.value.lastIndexOf("T")+1,this.value.indexOf("H"));
    var durationMins = 0;
    if (this.value.indexOf("M") > -1) {
      durationMins = this.value.substring(this.value.indexOf("H") + 1, this.value.indexOf("M"));
    }
    // calculate the duration
    var duration = (Number(durationHours) * 3600000) + (Number(durationMins) * 60000);
    // set start and end in milliseconds 
    endMs = this.start + duration;
  } else { 
    // freebusy value is of the form: 19980314T233000Z\/19980315T003000Z
    // set the freebusy end date
    var endDate = new Date();
    endDate.setUTCFullYear(this.value.substring(18,22),this.value.substring(22,24)-1,this.value.substring(24,26));
    endDate.setUTCHours(this.value.substring(27,29),this.value.substring(29,31),this.value.substring(31,33));
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
  };
};

/* Object to model the freebusy grid
 * displayId:       ID of html block for display output
 * startRange:      js date string - start of date range for grid
 * startHoursRange: integer, 0-23 - hours of range start time 
 * endHoursRange:   integer, 0-23 - hours of range end time 
 * attendees:       array   - array of attendee objects; MUST include organizer on first instantiation
 * workday:         boolean - true to display workday hours only, false to display all 24 hours
 * zoom:            integer - scalar value for zooming the grid
 * browserResourcesRoot: string - URL of browser resources (for displaying images, etc)
 * fbUrlPrefix:     string - URL prefix for making freebusy requests 
 * organizerUri:    string - e.g. "someone@mysite.edu" 
 */
var bwSchedulingGrid = function(displayId, startRange, startHoursRange, endHoursRange, attendees, workday, zoom, browserResourcesRoot, fbUrlPrefix, attUrlPrefix, organizerUri, curUserId) {
  this.displayId = displayId;
  this.startRange = new Date(startRange);
  this.endRange = new Date(startRange); 
  this.dayRange = 5; // number of days to increment the end range
  this.startHoursRange = startHoursRange;
  this.endHoursRange = endHoursRange; 
  this.zoom = zoom;
  this.workday = workday;
  this.attendees = new Array();  // array of bwAttendee objects
  this.resourcesRoot = browserResourcesRoot;
  this.fbUrlPrefix = fbUrlPrefix;
  this.attUrlPrefix = attUrlPrefix;
  this.organizer = organizerUri;
  this.curUser = curUserId;
  
  // increment the endRange
  this.endRange.addDays(this.dayRange);  
    
  // 2D array of time and busy state for all attendees
  // [millisecond value,true/false if busy]
  // this value is initialized when we draw the allAttendees row
  this.fb = new Array();  
  // a lookup table of free times based on the duration of the meeting, calculated from the fb array
  this.freeTime = new Array();
  this.freeTimeIndex = 0;
  
  // how much will we divide the hour in the grid?
  // ALWAYS set as a factor of 60 and never below 1
  // Be forewarned: changing this value quantizes the set of
  // times to be displayed, e.g. hourDivision = 4 quantizes the 
  // display to 15 minute increments; hourDivision = 1 locks the events to the
  // nearest hour (which is likely not best)
  // 4, 6, or 12 is preferred (and higher begins to slow down the display)
  // If in doubt, leave this at 4
  this.hourDivision = 4;
  
  // internal variables
  var hourMils = 3600000;
  var startMils = Number(this.startRange.getTime()) + Number(this.startHoursRange * hourMils); // the start of the grid
  var durationMils = hourMils; //getTimeFromForm("duration"); 
    // hourMils; // value used to calculate default endSelectionMils, defaults to 1 hour in milliseconds
                               // - SHOULD DEFAULT TO DATE/TIME SETTINGS
  var incrementMils = hourMils / this.hourDivision; // increment for the pick next/previous buttons
  var startSelectionMils = startMils; //getTimeFromForm("start");
    // startMils;  // where a mouse selection begins, milliseconds parsed from the first half of a fbcell's ID, default to beginning of grid
                                       // - SHOULD DEFAULT TO DATE/TIME SETTINGS
  var endSelectionMils;       // where a mouse selection ends, milliseconds parsed from the first half of a fbcell's ID
  var selecting = false;      // are we currently selecting?  If true, we'll highlight as we hover
  var cellsInDuration = durationMils / incrementMils; // calculate the number of cells in the duration for use in setting freeTime lookup
  var pickNextClicked = false; // false until the first time we click "pick next" - allows us to show the first free time window on first click
  
  // initialize the grid
  this.init = function() {
    // initialize all incoming attendees on first load
    for (var i = 0; i < attendees.length; i++) {
      // strip off "mailto:" if present
      var attUri = attendees[i].uid;
      if (attUri.indexOf("mailto:") != -1) {
        attUri = attUri.substr(7); 
      }
      var newAttendee = new bwAttendee(attendees[i].name, attUri, attendees[i].role, attendees[i].status, attendees[i].type);
      bwGrid.attendees.push(newAttendee); 
    }
    
    // now go get the freebusy information for the attendees
    if (this.attendees.length > 0) {
      bwGrid.requestFreeBusy();
    } else {
      // no attendees - just display the widget
      bwGrid.display();
    }
  };
  
  // add attendee in the bwGrid
  /* examples:
    bwGrid.addAttendee("Venerable Bede", "vbede@mysite.edu", "CHAIR", "ACCEPTED", "person");
    bwGrid.addAttendee("Samual Clemens", "sclemens@mysite.edu", "REQ-PARTICIPANT", "NEEDS-ACTION");
    bwGrid.addAttendee("", "noname@mysite.edu", "OPT-PARTICIPANT", "DECLINED");
  */
  this.addAttendee = function(name, uid, role, status, type) {
    var attendeeIsNew = true;
    
    // display the processing message
    $("#bwSchedProcessingMsg").show();
    
    // check to see if attendee already exists
    for (var i=0; i < bwGrid.attendees.length; i++) {
      /*if (uid.indexOf("mailto:") == -1) {
         uid = "mailto:" + uid; 
      }*/
      if (uid == bwGrid.attendees[i].uid) {
        attendeeIsNew = false;
        alert(bwAttendeeExistsDisp);
        // hide the processing message
        $("#bwSchedProcessingMsg").hide();
        break;
      } 
    }
    
    if (attendeeIsNew) {
      // try to add attendee to the back end
      $.ajax({
        type: "POST",
        url: bwGrid.attUrlPrefix,
        data: "uri=" + uid + "&role=" + role + "&partstat=" + status + "&attendee=true&submit=add&list=yes&skinName=widget",
        dataType: "json",
        success: function(responseData){

          // the local array is overwritten with attendee data returned from the ajax call
          if (responseData.attendees != undefined && responseData.attendees.length) {
            bwGrid.attendees.length = 0;
            for (var i=0; i < responseData.attendees.length; i++) {
              var att = responseData.attendees[i];
              // strip off mailto: from uids to store locally
              var attUri = att.uid;
              if (attUri.indexOf("mailto:") != -1) {
                attUri = attUri.substr(7); 
              }
              var newAttendee = new bwAttendee(att.name, attUri, att.role, att.status, att.type);
              bwGrid.attendees.push(newAttendee); 
            }
            bwGrid.requestFreeBusy();
          } else { // no attendees were returned
            alert(bwErrorAttendees);
          }
          
          // got attendees??  set the param that will trigger a
          // scheduling request. For now, just set this every time
          // (we'll trim back later)
          if (bwGrid.attendees.length) {
            $("input.bwEventFormSubmit").each(function(i) {
               $(this).attr("name","submitAndSend");
               $(this).val(bwEventSubmitMeetingDisp);
            });
          }
        },
        error: function(msg) {
          // there was a problem
          alert("Error: " + msg.statusText);
        }
      });
    }
    
  };
  
  // add a group of attendees returned from the CardDAV server
  // uids - an array of uids to add
  this.addGroupOfAttendees = function(uids) {
    // display the processing message
    $("#bwSchedProcessingMsg").show();
    
    // the json string we'll send to the server
    var attendees = "";
    var isFirst = true;
    
    for (var i = 0; i<uids.length; i++) {
      var attendeeIsNew = true;
      var uid = uids[i];
      
      // check to see if attendee already exists
      for (var j=0; j < bwGrid.attendees.length; j++) {
        if (uid.indexOf("mailto:") == -1) {
           uid = "mailto:" + uid; 
        }
        if (uid == bwGrid.attendees[j].uid) {
          attendeeIsNew = false;
          break;
        } 
      }
      
      if (attendeeIsNew) {
         if (!isFirst) attendees += "&"; 
         attendees += 'attjson={"uri":"' + uid + '"}';
         isFirst = false;
      }
    }
    
    // send the json string to the server:
    $.ajax({
      type: "POST",
      url: bwGrid.attUrlPrefix,
      data: attendees + "&attendee=true&submit=add&list=yes&skinName=widget",
      dataType: "json",
      success: function(responseData){

        // the local array is overwritten with attendee data returned from the ajax call
        if (responseData.attendees != undefined && responseData.attendees.length) {
          bwGrid.attendees.length = 0;
          for (var k=0; k < responseData.attendees.length; k++) {
            var att = responseData.attendees[k];
            // strip off mailto: from uids to store locally
            var attUri = att.uid;
            if (attUri.indexOf("mailto:") != -1) {
              attUri = attUri.substr(7); 
            }
            var newAttendee = new bwAttendee(att.name, attUri, att.role, att.status, att.type);
            bwGrid.attendees.push(newAttendee); 
          }
          bwGrid.requestFreeBusy();
        } else { // no attendees were returned
          alert(bwErrorAttendees);
        }
        
        // got attendees??  set the param that will trigger a
        // scheduling request. For now, just set this every time
        // (we'll trim back later)
        if (bwGrid.attendees.length) {
          $("input.bwEventFormSubmit").each(function(k) {
             $(this).attr("name","submitAndSend");
             $(this).val(bwEventSubmitMeetingDisp);
          });
        }
      },
      error: function(msg) {
        // there was a problem
        alert("Error: " + msg.statusText);
      }
    });
    
    // hide the processing message
    $("#bwSchedProcessingMsg").hide();
  }
  
  this.addAttendeeFromGrid = function() {
    var uid = $("#bwAddAttendee").val();
    var role = $("#bwAddAttendeeRole").val();
    var partstat = $("#bwAddAttendeePartstat").val();
    // these are preliminary values - will get more from server after ajax call
    if (uid.indexOf(",") != -1) {
      // we have a list of uids from a group
      // alert("can't add a group yet, but soon...");
      var uids = uid.split(",");
      bwGrid.addGroupOfAttendees(uids);
    } else {
      // we have a single uid
      bwGrid.addAttendee("",uid,role,partstat,"person");
    }
  };
  
  this.removeAttendee = function(index) {
    var uid = bwGrid.attendees[index].uid;
    
    // display the processing message
    $("#bwSchedProcessingMsg").show();
    
    // try to remove the attendee from the back end
    $.ajax({
      type: "POST",
      url: bwGrid.attUrlPrefix,
      data: "uri=" + uid + "&attendee=true&delete=true&list=yes&skinName=widget",
      success: function(){
        // remove the attendee from the local array
        bwGrid.attendees.splice(index, 1);
        if (bwGrid.attendees.length) {
          bwGrid.requestFreeBusy();
        } else {
          bwGrid.display();
        }
        
        // no more attendees??  change back to a normal event.
        if (!bwGrid.attendees.length) {
          $("input.bwEventFormSubmit").each(function(i) {
             $(this).attr("name","submit");
             $(this).val(bwEventSubmitDisp);
          });
        }
        
      },
      error: function(msg) {
        // there was a problem
       if (msg.statusText == "OK") {
         alert(msg.responseText);
       }
       else {
        alert(msg.statusText);
       }
      }
    });
    
  };
  
  this.requestFreeBusy = function() {
    // set up the freebusy URL based on current parameters
    // e.g. http://localhost:8080/ucal/event/requestFreeBusy.gdo?b=de&start=20100510T050000Z&end=20100517T050000Z&organizerUri=mailto:douglm@mysite.edu&attendeeUri=douglm@mysite.edu&attendeeUri=johnsa@mysite.edu
    var fbUrlStart = "&start=" + this.startRange.getUTCFullYear() + this.startRange.getUTCMonthFull() + this.startRange.getUTCDateFull() + "T" + this.startRange.getUTCHoursFull() + this.startRange.getUTCMinutesFull() + "00Z";
    var fbUrlEnd = "&end=" + this.endRange.getUTCFullYear() + this.endRange.getUTCMonthFull() + this.endRange.getUTCDateFull() + "T" + this.endRange.getUTCHoursFull() + this.endRange.getUTCMinutesFull() + "00Z";;
    var fbOrganizer = "&organizerUri=" + this.organizer;
    var fbAttendees = "";
    for (var i=0; i < bwGrid.attendees.length; i++) {
      fbAttendees += "&attendeeUri=" + bwGrid.attendees[i].uid;
    }
    var fbUrl = this.fbUrlPrefix + fbUrlStart + fbUrlEnd + fbOrganizer + fbAttendees;
    
    $.ajax({
      type: "POST",
      url: fbUrl,
      dataType: "json",
      success: function(fb){
        for (var i=0; i < fb.microformats["schedule-response"].length; i++) {
          var r = fb.microformats["schedule-response"][i]; // reference the current response
          
          if (r["calendar-data"] != undefined && r["calendar-data"].freebusy != undefined) {
            // find the attendee and pass in the freebusy object if the attendee has any
            for (var j=0; j < bwGrid.attendees.length; j++) {
              if (bwGrid.attendees[j].uid == r["calendar-data"].attendee[0].value.substr(r["calendar-data"].attendee[0].value.lastIndexOf(":") + 1)) {
                bwGrid.attendees[j].updateFreeBusy(r["calendar-data"].freebusy);
              }
            }
          }
        }
        bwGrid.display();
      },
      error: function(msg) {
        // there was a problem
        alert(msg.statusText);
      }
    });
    
  };
  
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
    bwGrid.highlight(curSelectionTime, endSelectionMils);
    
    // we've clicked pickedNext - so set the pickNextClicked flag to true
    // this flag lets us highlight the very first free time window on first click
    pickNextClicked = true;
    
    bwGrid.setDateTimeWidgets(curSelectionTime);
  };
  
  this.pickPrevious = function() {
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
    bwGrid.highlight(curSelectionTime, endSelectionMils);
        
    bwGrid.setDateTimeWidgets(curSelectionTime);
  };
  
  this.highlight = function (curSelectionTime, endSelectionMils) {
    $("#bwScheduleTable .fbcell").each(function(index) {
      var splId = $(this).attr("id").split("-");
      if (splId[0] >= curSelectionTime && splId[0] < endSelectionMils) {
        $(this).addClass("highlight");
      }
    });
  };
  
  // create the lookup values for a free window for use with picknext/previous
  this.setFreeTime = function() {
    // this assumes we have a properly populated fb array
    
    // empty the array
    this.freeTime.length = 0;
    
    // reset the freetime index and the pickNextClicked value 
    this.freeTimeIndex = 0;
    pickNextClicked = false;
    
    // now look over the next group of cells to see if the range
    // we want to select is busy.  If not, store the value for lookup.
    for (var i=0; i <= this.fb.length - cellsInDuration; i++) {
      var rangeNotBusy = true;
      for (var j = i; j < i + cellsInDuration; j++) {
        if (this.fb[j][1]) { // we hit a busy cell
          rangeNotBusy = false; 
        }         
      }
      if (rangeNotBusy) {
        this.freeTime.push(this.fb[i][0]);  
      }
    }
  };
  
  this.setIncrement = function(val) {
    this.hourDivision = val;
    this.display();
  };
  
  // The scheduling duration fields have been modified.
  // Update the corresponding form elements and set the 
  // duration for selection in the grid.
  this.bwSchedChangeDuration = function(inputId) {     
    var days;
    var hours;
    var mins;
    
    if (inputId.indexOf("Sched") > -1) {
      // we changed a duration on the meeting tab       
      days = parseInt($("#durationDaysSched").val());
      hours = parseInt($("#durationHoursSched").val());
      mins = parseInt($("#durationMinutesSched").val());
    } else {
      // we changed a duration on the main tab     
      days = parseInt($("#durationDays").val());
      hours = parseInt($("#durationHours").val());
      mins = parseInt($("#durationMinutes").val());
    }
    
    //do some form validation - make sure the durations are integers
    if (isNaN(days) || isNaN(hours) || isNaN(mins)) {
      alert("Please enter an integer value for durations.")
      return false;
    }
    
    // force duration on the basic tab
    $("#standardForm input[name='eventEndType']").val("D");
    $("#eventEndTypeDuration").attr("checked","checked");
    changeClass('endDateTime','invisible');
    changeClass('endDuration','shown');
    
    // set the basic tab's duration values
    $("#durationDays").val(days);
    $("#durationHours").val(hours);
    $("#durationMinutes").val(mins);
    
    // set the scheduling duration field values from the parsed values
    // -- this also strips any floating point values from user input
    $("#durationDaysSched").val(days);
    $("#durationHoursSched").val(hours);
    $("#durationMinutesSched").val(mins);
    
    // set the duration in the bwGrid and recalculate cells 
    durationMils = (days * 86400000) + (hours * 3600000) + (mins * 60000);
    cellsInDuration = durationMils / incrementMils;
    // repopulate the free time lookup
    this.setFreeTime();
  };
  
  // The time fields have been modified.
  // Update the corresponding form elements 
  this.bwSchedChangeTime = function(inputId) {     
    var hours;
    var mins;
    
    if (inputId.indexOf("Sched") > -1) {
      // we changed a time on the meeting tab       
      hours = parseInt($("#eventStartDateSchedHour").val());
      mins = parseInt($("#eventStartDateSchedMinute").val());
    } else {
      // we changed a time on the main tab     
      hours = parseInt($("#eventStartDateHour").val());
      mins = parseInt($("#eventStartDateMinute").val());
    }
        
    // set the basic tab's time values
    $("#eventStartDateHour").val(hours);
    $("#eventStartDateMinute").val(mins);
    
    // set the scheduling time field values from the parsed values
    $("#eventStartDateSchedHour").val(hours);
    $("#eventStartDateSchedMinute").val(mins);
    
  };
  
  // if the "all day" checkbox is clicked, 
  // change the duration widgets, the duration in the grid,
  // and recalculate the freetime lookup
  this.allDay = function(isAllDay) {
    if (isAllDay) {
      $(".schedTime").hide();
      $("#durationHrMinSched").hide();
      $("#durationDaysSched").val(1);
      $("#durationHoursSched").val(0);
      $("#durationMinutesSched").val(0);
      // set the duration in the bwGrid and recalculate cells 
      durationMils = 86400000;
      cellsInDuration = durationMils / incrementMils;
      // repopulate the free time lookup
      this.setFreeTime();
    } else {
      $(".schedTime").show();
      $("#durationHrMinSched").show();
      $("#durationDaysSched").val(0);
      $("#durationHoursSched").val(1);
      $("#durationMinutesSched").val(0);
      // set the duration in the bwGrid and recalculate cells 
      durationMils = 3600000;
      cellsInDuration = durationMils / incrementMils;
      // repopulate the free time lookup
      this.setFreeTime();
    }
  }
  
  this.display = function() {
    try {
      // number of days to display
      var range = getDayRange(this.startRange, this.endRange);
      // number of hours to display, default to 24 hour mode
      var hourRange = 24;
      var startHour = 0;
      
      if (this.workday) {
        // show only workday hours in grid
        hourRange = this.endHoursRange - this.startHoursRange;
        startHour = this.startHoursRange;
      }
      
      var cellsInDay = hourRange * this.hourDivision;
    
      // build the entire free/busy table
      var fbDisplay = document.createElement("table");
      fbDisplay.id = "bwScheduleTable";
      
      // create navigation buttons
      var navigationHtml = '';
      navigationHtml += '<div id="bwGridNav">';
      navigationHtml += '  <a href="javascript:bwGrid.gotoPreviousRange()" title="previous date range">';
      navigationHtml += '    <img src="' + this.resourcesRoot + '/images/std-arrow-left-sched.gif" width="13" height="16" alt="previous date range" border="0"/>';
      navigationHtml += '  </a>';
      navigationHtml += '  <a href="javascript:bwGrid.gotoNextRange()" title="next date range">';
      navigationHtml += '    <img src="' + this.resourcesRoot + '/images/std-arrow-right-sched.gif" width="13" height="16" alt="next date range" border="0"/>';
      navigationHtml += '  </a>';
      navigationHtml += '</div>';
      navigationHtml += '<div id="bwSchedProcessingMsg">processing...</div>';
      
      // generate the date row - includes top left corner navigation buttons 
      var fbDisplayDateRow = fbDisplay.insertRow(fbDisplay.rows.length);
      $(fbDisplayDateRow).html('<td rowspan="2" colspan="4" class="corner">' + navigationHtml + '</td><td class="fbBoundry"></td>');
      for (var i=0; i < range; i++) {
        var curDate = new Date(this.startRange); 
        curDate.addDays(i);
        $(fbDisplayDateRow).append('<td class="date" colspan="' + cellsInDay + '">' + curDate.getDayName() + ', ' + curDate.getMonthName() + ' ' + curDate.getDate() + ', ' + curDate.getFullYear() + '</td><td class="dayBoundry"></td>');
      }
      
      // generate the times row - each cell spans over the day divisions
      fbDisplayTimesRow = fbDisplay.insertRow(fbDisplay.rows.length);
      $(fbDisplayTimesRow).html('<td class="fbBoundry"></td>');
      for (var i=0; i < range; i++) {
        var curDate = new Date(this.startRange); 
        curDate.setHours(startHour);
        curDate.addDays(i);
        // add the time cells by iterating over the hours
        for (j = 0; j < hourRange; j++) {
          // this is where we could use zoom to increase or decrease tick marks and time labels on the grid
          if (this.zoom == 100) {
            $(fbDisplayTimesRow).append('<td class="hourBoundry timeCell" id="' + curDate.getTime() + '-TimeRow" colspan="' + this.hourDivision + '">' + curDate.getHours12() + ':' + curDate.getMinutesFull() + '</td>');
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
      $(fbDisplayTimesRow).html('<td class="status"></td><td class="role"></td><td class="name">' + bwAttendeeDispGridAllAttendees + '</td><td></td><td class="fbBoundry"></td>');
      for (var i=0; i < range; i++) {
        var curDate = new Date(this.startRange); 
        curDate.setHours(startHour);
        curDate.addDays(i);
        // add the time cells by iterating over the hours
        for (var j = 0; j < hourRange; j++) {
          for (var k = 0; k < this.hourDivision; k++) {
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
            for (var att = 0; att < this.attendees.length; att++) {
              for (var m = 0; m < this.attendees[att].freebusy.length; m++) {
                // keep for reference: var tzoffset = -curDate.getTimezoneOffset() * 60000; // in milliseconds
                // adding the hourdivision increment in the calculation below is to correct for a bug
                // in which the class was always offset by one table cell - should find cause
                var curDateUTC = curDate.getTime() + (60 / this.hourDivision * 60000);
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
      
   // generate the "add attendee" row
      fbDisplayAddAttendeeRow = fbDisplay.insertRow(fbDisplay.rows.length);
      
      // create the add attendee form 
      var addAttendeeHtml = '<td class="addAttendee" colspan="4">';
      addAttendeeHtml += '<input type="text" value="' + bwAddAttendeeDisp +'" name="q" id="bwAddAttendee" class="pending" size="30"/>';
      addAttendeeHtml += '<span id="bwAddAttendeeAdd" class="invisible">' + bwAddDisp +'</span>';
      //addAttendeeHtml += '<span id="bwAddAttendeeAdvanced">advanced</span>';
      addAttendeeHtml += '<div id="bwAddAttendeeFields" class="invisible">';
      addAttendeeHtml += '  <div class="bwAddAttendeeSubField" id="bwAddAttendeeRoleBlock">';
      addAttendeeHtml += '    <span class="bwAddAttendeeSubFieldHead">' + bwAddAttendeeRoleDisp + '</span>';
      addAttendeeHtml += '    <select name="role" id="bwAddAttendeeRole">';
      addAttendeeHtml += '      <option value="REQ-PARTICIPANT">' + bwReqParticipantDisp + '</option>';
      addAttendeeHtml += '      <option value="OPT-PARTICIPANT">' + bwOptParticipantDisp + '</option>';
      addAttendeeHtml += '      <option value="CHAIR">' + bwChairDisp + '</option>';
      addAttendeeHtml += '      <option value="NON-PARTICIPANT">' + bwNonParticipant + '</option>';
      addAttendeeHtml += '    </select>';
      addAttendeeHtml += '  </div>';
      // DON'T include partstat except for testing.  This value should be determined by actual participants.
      //addAttendeeHtml += '<select name="partstat" id="bwAddAttendeePartstat">';
      //addAttendeeHtml += '  <option value="NEEDS-ACTION">' + bwNeedsAction + '</option>';
      //addAttendeeHtml += '  <option value="ACCEPTED">' + bwAccepted + '</option>';
      //addAttendeeHtml += '  <option value="DECLINED">' + bwDeclined + '</option>';
      //addAttendeeHtml += '  <option value="TENTATIVE">' + bwTentative + '</option>';
      //addAttendeeHtml += '  <option value="DELEGATED">' + bwDelegated + '</option>';
      //addAttendeeHtml += '</select>';
      addAttendeeHtml += '  <div class="bwAddAttendeeSubField" id="bwAddAttendeeBookBlock">';
      addAttendeeHtml += '    <span class="bwAddAttendeeSubFieldHead">' + bwAddAttendeeBookDisp + '</span>';
      addAttendeeHtml += '    <input type="radio" name="bwAddAttendeeAddrBk" value="/user/' + bwGrid.curUser + '/addressbook" checked="checked" onclick="changeClass(\'bwAddAttendeeTypeBlock\',\'invisible\');bwGrid.updateBookPath(this.value);">personal';
      // note: the public switch uses a separate click handler set after the display is written to the output (below)
      addAttendeeHtml += '    <input type="radio" name="bwAddAttendeeAddrBk" id="bwAddAttendeePublicSwitch" value="/public" onclick="changeClass(\'bwAddAttendeeTypeBlock\',\'bwAddAttendeeSubField\');">public';
      addAttendeeHtml += '  </div>';
      addAttendeeHtml += '  <div class="invisible" id="bwAddAttendeeTypeBlock">';
      addAttendeeHtml += '    <span class="bwAddAttendeeSubFieldHead">' + bwAddAttendeeTypeDisp + '</span>';
      addAttendeeHtml += '    <input type="radio" name="bwAddAttendeeType" value="/public/people" checked="checked" onclick="bwGrid.updateBookPath(this.value);"/>person';
      addAttendeeHtml += '    <input type="radio" name="bwAddAttendeeType" value="/public/groups" disabled="disabled" onclick="bwGrid.updateBookPath(this.value);"/>group';
      addAttendeeHtml += '    <input type="radio" name="bwAddAttendeeType" value="/public/locations" onclick="bwGrid.updateBookPath(this.value);"/>location';
      addAttendeeHtml += '  </div>';
      addAttendeeHtml += '  <input type="hidden" name="bwCardDavBookPath" id="bwCardDavBookPath" value="/user/' + bwGrid.curUser + '/addressbook"/>';
      addAttendeeHtml += '</div>';
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
            $(fbDisplayAttendeeRow).html('<td class="status accepted"><span class="icon"><img src="' + resourcesRoot + '/images/check.gif" alt="accepted" width="15" height="15"/></span><span class="tip">' + bwAttendeeDispStatusAccepted + '</span></td>');
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
            $(fbDisplayAttendeeRow).append('<td class="role chair"><span class="icon"><img src="' + resourcesRoot + '/images/chair.gif" alt="chair" width="17" height="15"/></span><span class="tip">' + bwAttendeeDispRoleChair + '</span></td>');
            break;
          case bwAttendeeRoleRequired: // displays right-pointing arrow icon - &#10137;
            $(fbDisplayAttendeeRow).append('<td class="role required"><span class="icon"><img src="' + resourcesRoot + '/images/reqArrow.gif" alt="required" width="17" height="12"/></span><span class="tip">' + bwAttendeeDispRoleRequired + '</span></td>');
            break;
          case bwAttendeeRoleNonParticipant: // non-participant
            $(fbDisplayAttendeeRow).append('<td class="role nonparticipant"><span class="icon">x</span><span class="tip">' + bwAttendeeDispRoleNonParticipant + '</span></td>');
            break;
          default: // bwAttendeeRoleOptional - no icon (use a space to provide a rollover)
            $(fbDisplayAttendeeRow).append('<td class="role optional"><span class="icon">&#160;</span><span class="tip">' + bwAttendeeDispRoleOptional + '</span></td>');
        }
        
        
        // output the attendee name or address (depending on which we have available)
        // and output attendee functions
        var attendeeAddress = curAttendee.uid;
        var attendeeNameHtml = '<td class="name"><span class="bwAttendee" id="' + attendeeAddress + '">';
        if (curAttendee.name && curAttendee.name != "") {
          attendeeNameHtml += curAttendee.name;
        } else {
          if (attendeeAddress.indexOf("mailto:") != -1) {
            attendeeNameHtml += attendeeAddress.substring(7);
          } else {
            attendeeNameHtml += attendeeAddress;
          } 
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
        for (var i = 0; i < range; i++) {
          var curDate = new Date(this.startRange);
          curDate.setHours(startHour);
          curDate.addDays(i);
          // add the time cells by iterating over the hours
          for (var j = 0; j < hourRange; j++) {
            for (var k = 0; k < this.hourDivision; k++) {
              var fbCell = document.createElement("td");
              fbCell.id = curDate.getTime() + "-" + curAttendee.uid;
              $(fbCell).addClass("fbcell");
              $(fbCell).addClass(curDate.getTime().toString());
              if (curDate.getMinutes() == 0 && j != 0) {
                $(fbCell).addClass("hourBoundry");
              }
              for (var m = 0; m < curAttendee.freebusy.length; m++) {
                // keep for reference: var tzoffset = -curDate.getTimezoneOffset() * 60000; // in milliseconds
                // adding the hourdivision increment in the calculation below is to correct for a bug
                // in which the class was always offset by one table cell - should find cause
                var curDateUTC = curDate.getTime() + (60 / this.hourDivision * 60000);
                if (curAttendee.freebusy[m].contains(curDateUTC)) {
                  if (curAttendee.freebusy[m].typeDisplay == bwFreeBusyDispTypeTentative) {
                    $(fbCell).addClass("tentative");
                  } else {
                    $(fbCell).addClass("busy");
                  }
                  $(fbCell).addClass("activeCell");
                  $(fbCell).append('<span class="tip">' + curAttendee.freebusy[m].typeDisplay + '</span>');
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
      
      // generate a blank row at the end (this is just for visual padding)
      fbDisplayBlankRow = fbDisplay.insertRow(fbDisplay.rows.length);
      $(fbDisplayBlankRow).html('<td class="status"></td><td class="role"></td><td class="name"></td><td></td><td class="fbBoundry"></td>');
      for (var i = 0; i < range; i++) {
        var curDate = new Date(this.startRange);
        curDate.setHours(startHour);
        curDate.addDays(i);
        // add the time cells by iterating over the hours
        for (var j = 0; j < hourRange; j++) {
          for (var k = 0; k < this.hourDivision; k++) {
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
      
      // **** OUTPUT *****
      // write the table back to the display
      $("#" + displayId).html(fbDisplay);
      
       // now hide the processing message
       $("#bwSchedProcessingMsg").fadeOut(100);

      // highlight the time based on the current date/time settings
      //var curSelectionTime = Number(startSelectionMils);
      // set the end time by adding the duration
      //endSelectionMils = Number(curSelectionTime) + Number(durationMils);
      //bwGrid.highlight(curSelectionTime, endSelectionMils);
       
     //**** ACTIONS ****
     //now add some rollovers and onclick actions 
     //to the elements of the freebusy grid 
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
         var startSelectionMils = splitId[0];
         var endSelectionMils = Number(startSelectionMils) + Number(durationMils);
         
         // now do the highlighting
         $("#bwScheduleTable .fbcell").each(function(index) {
           var splId = $(this).attr("id").split("-");
           if (splId[0] >= startSelectionMils && splId[0] < endSelectionMils) {
             $(this).addClass("highlight");
           }
         });
         
         // set the freeTimeIndex to the nearest index for the pickNext/previous buttons
         for (var i = 0; i < bwGrid.freeTime.length; i++) {
           if (Number(bwGrid.freeTime[i]) >= Number(startSelectionMils)) {
             bwGrid.freeTimeIndex = i - 1; // this will make pick previous jump an extra gap after clicking in a busy space, but it makes pick next work correctly in the same circumstance
             if (bwGrid.freeTimeIndex < 0) {
               bwGrid.freeTimeIndex = 0;
             }
             break;
           }
         }
         
         bwGrid.setDateTimeWidgets(startSelectionMils);
     
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
     
     $("#bwScheduleTable #bwAddAttendee").click (
       function () {
         if (this.value == bwAddAttendeeDisp) {
           this.value = "";
         }
         $(this).addClass("active");
         $(this).removeClass("pending");
         
         // hide advanced switch, show add button
         // $("#bwAddAttendeeAdvanced").hide();
         changeClass("bwAddAttendeeAdd","visible");
         changeClass("bwAddAttendeeFields", "visible");
       }
     );
     
     // add a handler for the public switch (not in-line like the others)
     $("#bwAddAttendeePublicSwitch").click(function(){
       bwGrid.updateBookPath($('input:radio[name=bwAddAttendeeType]:checked').val());  
     });
     
     // add attendee box - use jquery UI autocomplete
     // carddavUrl supplied in bedework.js
     // var carddavUrlTemp = "/ucalrsrc/themes/bedeworkTheme/javascript/addrbookUsers.js"
     // var carddavUrlTemp = "/ucalrsrc/themes/bedeworkTheme/javascript/addrbookLocations.js"
     $("#bwScheduleTable #bwAddAttendee").autocomplete({
       minLength: 1,
       // set the data source, call it, and format the results:
       source: function(req, include) {
         // build the address book url; the path to the address book is determined by the
         // radio button choices in the "add attendee" widget - these are stored on the fly
         // in the hidden field with id bwCardDavBookPath
         addrBookUrl = carddavUrl + "?format=json&addrbook=" + $("#bwCardDavBookPath").val();
         
         // call the server and push the results into an array "items"
         $.getJSON(addrBookUrl, req, function(data) {
           var acResults = "";
           if (data !== undefined && data.microformats !== undefined) {
             acResults = data.microformats;
           }
           var items = [];
           $.each(acResults, function(i,entry) {

             var card = new jcard(entry);

             // build the label from the full name and email address
             var curFn = card.getPropertyValue("fn");
             var curEmail = "";
             var curLabel = "";
             var curKind = card.getPropertyValue("kind");

             if (curKind === "group") {
               var member = card.getPropertyValue("member");
               if (member !== null && member.length > 0) {
                 var members = "";
                 for (var i = 0; i < member.length; i++ ) {
                   members += member[i].value + ",";
                 }
                 members = members.substring(0, members.length-1);
                 var curItem = {label: curFn, value: members};
                 items.push(curItem);
               }
             } else {
               // this is probably not enough: we should account for all email addresses if there is no calendar uri
               curEmail = card.getPropertyValue("email");

               if (curFn !== null) {
                 curLabel = curFn + ", " + curEmail;
               } else {
                 curLabel = curEmail;
               }
               
               // use the calendar address uri if available, otherwise use email
               var curUri = card.getPropertyValue("caladruri");

               if (curUri === null && curEmail !== null) {
                 curUri = "mailto:" + curEmail;
               }
               
               // only add the entry if there is a uri and a label to use
               if (curUri !== null && curLabel !== "") {
                 var curItem = {label: curLabel, value: curUri};
                 items.push(curItem);
               }
             }
           });
           
           // pass items to the callback function for display in the autocomplete pulldown
           include(items);
         });
       }
     });
     
     // capture the enter key when entering an attendee;
     // do not submit the form; add the attendee.
     $("#bwScheduleTable #bwAddAttendee").keypress (
         function (e) {
           if(e.keyCode == 13) { // enter
             e.preventDefault();
             bwGrid.addAttendeeFromGrid();
           }
         }
       );
     
     $("#bwScheduleTable #bwAddAttendeeAdd").click (
       function () {
         bwGrid.addAttendeeFromGrid();
       }
     );
     
     
     $("#bwScheduleTable .removeAttendee").click (
       function () {
         var i = $("#bwScheduleTable .removeAttendee").index(this);
         bwGrid.removeAttendee(i);
       }
     );
     
     // enable or disable an attendee
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
      alert("Error: " + e);
    }
    
  };
    
  this.updateBookPath = function(path) {
    $("#bwCardDavBookPath").val(path);
  }
  
  this.gotoNextRange = function() {
    $("#bwSchedProcessingMsg").show();
    bwGrid.startRange.addDays(bwGrid.dayRange);
    bwGrid.endRange.addDays(bwGrid.dayRange);
    if (bwGrid.attendees.length) {
      bwGrid.requestFreeBusy();
    } else {
      bwGrid.display(); 
    }
  }
  
  this.gotoPreviousRange = function() {
    $("#bwSchedProcessingMsg").show();
    bwGrid.startRange.subtractDays(bwGrid.dayRange);
    bwGrid.endRange.subtractDays(bwGrid.dayRange);
    if (bwGrid.attendees.length) {
      bwGrid.requestFreeBusy();
    } else {
      bwGrid.display(); 
    }
  }
  
  this.setDateTimeWidgets = function(startMils) {
    // set the values of the date/time widgets on the main and meeting tabs
    var selectedDate = new Date(Number(startMils));
    var selectedDateStr = selectedDate.getFullYear() + "-" + selectedDate.getMonthFull() + "-" + selectedDate.getDateFull();
    $("#bwEventWidgetStartDate").val(selectedDateStr);
    $("#bwEventWidgetStartDateSched").val(selectedDateStr);
    // check for ampm or hour24
    if ($("#eventStartDateSchedAmpm").length) {
      // we are using am/pm
      $("#eventStartDateHour").val(selectedDate.getHours12());
      $("#eventStartDateMinute").val(selectedDate.getMinutesFull());
      $("#eventStartDateAmpm").val(selectedDate.getAmpm());
      $("#eventStartDateSchedHour").val(selectedDate.getHours12());
      $("#eventStartDateSchedMinute").val(selectedDate.getMinutesFull());
      $("#eventStartDateSchedAmpm").val(selectedDate.getAmpm());
    } else {
      // we are using hour24
      $("#eventStartDateHour").val(selectedDate.getHours());
      $("#eventStartDateMinute").val(selectedDate.getMinutesFull());
      $("#eventStartDateSchedHour").val(selectedDate.getHours());
      $("#eventStartDateSchedMinute").val(selectedDate.getMinutesFull());
    }
  } 
  
};


//now add some interactions between the freebusy control buttons,
// the scheduling widget, and the rest of the form. once the
// document is loaded
$(document).ready(function() {
  // toggle 24 hour mode - can be done with text or with checkbox
  // checkbox handler:
  function switchSched24() {
    if($("#bwSched24HoursCb").is(":checked")) {
      bwGrid.workday = false;
    } else {
      bwGrid.workday = true;
    }
    bwGrid.display(); 
  }
  // text handler: checks or unchecks the box
  function switchSched24Text() {
    if($("#bwSched24HoursCb").is(":checked")) {
      $("#bwSched24HoursCb").removeAttr('checked');
    } else {
      $("#bwSched24HoursCb").attr('checked','checked');
    }
    switchSched24();
  }
  // bind the text and the checkbox to the handlers
  $("#bwSched24HoursCb").click(switchSched24);
  $("#bwSched24HoursText").click(switchSched24Text);
  
  // if we change the main tab's start date, time, or duration, update the meeting tab
  // and reset the range of the scheduling grid
  $("#bwEventWidgetStartDate").change(function(event) {
    $("#bwEventWidgetStartDateSched").val($("#bwEventWidgetStartDate").val());
    bwGrid.startRange = $("#bwEventWidgetStartDate").datepicker("getDate");
    bwGrid.endRange = $("#bwEventWidgetStartDate").datepicker("getDate");
    bwGrid.endRange.addDays(bwGrid.dayRange);
    if (bwGrid.attendees.length) {
      bwGrid.requestFreeBusy();
    } else {
      bwGrid.display();
    }
  });
  
  $("#eventStartDateHour").change(function() { 
    bwGrid.bwSchedChangeTime("#eventStartDateHour");
  });
  
  $("#eventStartDateMinute").change(function() { 
    bwGrid.bwSchedChangeTime("#eventStartDateMinute");
  });
  
  $("#durationDays").change(function() {
    bwGrid.bwSchedChangeDuration("#durationDays");
  });
  
  $("#durationHours").change(function() {
    bwGrid.bwSchedChangeDuration("#durationHours");
  });
  
  $("#durationMinutes").change(function() {
    bwGrid.bwSchedChangeDuration("#durationMinutes");
  });
  
  // if we change the meeting tab's date, time, or duration, update the main tab
  // and reset the range of the scheduling grid
  $("#bwEventWidgetStartDateSched").change(function(event) {
    $("#bwEventWidgetStartDate").val($("#bwEventWidgetStartDateSched").val());
    bwGrid.startRange = $("#bwEventWidgetStartDateSched").datepicker("getDate");
    bwGrid.endRange = $("#bwEventWidgetStartDateSched").datepicker("getDate");
    bwGrid.endRange.addDays(bwGrid.dayRange);
    if (bwGrid.attendees.length) {
      bwGrid.requestFreeBusy();
    } else {
      bwGrid.display(); 
    }
  });
  
  $("#eventStartDateSchedHour").change(function() { 
    bwGrid.bwSchedChangeTime("#eventStartDateSchedHour");
  });
  
  $("#eventStartDateSchedMinute").change(function() { 
    bwGrid.bwSchedChangeTime("#eventStartDateSchedMinute");
  });
  
  $("#durationDaysSched").change(function() {
    bwGrid.bwSchedChangeDuration("#durationDaysSched");
  });
  
  $("#durationHoursSched").change(function() {
    bwGrid.bwSchedChangeDuration("#durationHoursSched");
  });
  
  $("#durationMinutesSched").change(function() {
    bwGrid.bwSchedChangeDuration("#durationMinutesSched");
  });
});

// Utilities
var getDayRange = function(startDate, endDate) {  
  // find difference in milliseconds and return number of days.
  // 86400000 is the number of milliseconds in a day;
  return Math.round((Math.abs(startDate.getTime() - endDate.getTime())) / 86400000)
};

var getTimeFromForm = function(type) {
  var startDate = new Date();
  //startDate = $("#bwEventWidgetStartDate").datepicker("getDate");
  var startMils = Number(startDate.getTime());
  
  switch(type) {
    case "start": 
      return startMils;
    case "duration":
      var hourMils = 3600000;
      var endType = $("input[@name='eventEndType']:radio:checked").val();
      if (endType = "E") { // datetime end type
        return hourMils;
      } else if (endType = "D") { // duration end type
        return hourMils;
      } else {
        return hourMils; 
      }
    default: 
      return undefined;
  }
}

// DATE PROTOTYPE OVERRIDES - should be pulled into a library
// the following need to call internationalized strings - from a localeSettings file
Date.prototype.getMonthName = function() {
  var m = ['January','February','March','April','May','June','July','August','September','October','November','December'];
  return m[this.getMonth()];
};
Date.prototype.getDayName = function() {
  var d = ['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'];
  return d[this.getDay()];
}; 
Date.prototype.addDays = function(days) {
  this.setDate(this.getDate() + days);
}; 
Date.prototype.subtractDays = function(days) {
  this.setDate(this.getDate() - days);
}; 
Date.prototype.addHours = function(hours) {
  this.setHours(this.getHours() + hours);
};
Date.prototype.addMinutes = function(minutes) {
  this.setMinutes(this.getMinutes() + minutes);
};
// return a twelve-hour hour
Date.prototype.getHours12 = function() {
  var hours12 = this.getHours();
  if (hours12 > 12) {
    hours12 = hours12 - 12;
  } 
  return hours12;
};
Date.prototype.getAmpm = function() {
  var ampm = "am";
  var hours = this.getHours();
  if (hours > 11) {
    ampm = "pm";
  }
  return ampm;
};
// prepend months with zero if needed
Date.prototype.getMonthFull = function() {
  var monthFull = this.getMonth() + 1;
  if (monthFull < 10) {
    return "0" + monthFull;
  }  
  return monthFull;
};
// return a formatted day date, prepended with zero if needed
Date.prototype.getDateFull = function() {
  var dateFull = this.getDate();
  if (dateFull < 10) {
    return "0" + dateFull;
  }  
  return dateFull;
};
// prepend minutes with zero if needed
Date.prototype.getMinutesFull = function() {
  var minutesFull = this.getMinutes();
  if (minutesFull < 10) {
    return "0" + minutesFull;
  }  
  return minutesFull;
};


/* UTC FORMATTERS */

// return a formatted UTC month, prepended with zero if needed
Date.prototype.getUTCMonthFull = function() {
  var monthFull = this.getUTCMonth() + 1;
  if (monthFull < 10) {
    return "0" + monthFull;
  }  
  return monthFull;
};
// return a formatted UTC day date, prepended with zero if needed
Date.prototype.getUTCDateFull = function() {
  var dateFull = this.getUTCDate();
  if (dateFull < 10) {
    return "0" + dateFull;
  }  
  return dateFull;
};
// return formatted UTC hours, prepended with zero if needed
Date.prototype.getUTCHoursFull = function() {
  var hoursFull = this.getUTCHours();
  if (hoursFull < 10) {
    return "0" + hoursFull;
  }  
  return hoursFull;
};
// return formatted UTC minutes, prepended with zero if needed
Date.prototype.getUTCMinutesFull = function() {
  var minutesFull = this.getUTCMinutes();
  if (minutesFull < 10) {
    return "0" + minutesFull;
  }  
  return minutesFull;
};

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
