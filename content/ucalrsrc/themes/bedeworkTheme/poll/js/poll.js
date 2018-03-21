/**
 ##
 # Copyright (c) 2013-2014 Apple Inc. All rights reserved.
 #
 # Licensed under the Apache License, Version 2.0 (the "License");
 # you may not use this file except in compliance with the License.
 # You may obtain a copy of the License at
 #
 # http://www.apache.org/licenses/LICENSE-2.0
 #
 # Unless required by applicable law or agreed to in writing, software
 # distributed under the License is distributed on an "AS IS" BASIS,
 # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 # See the License for the specific language governing permissions and
 # limitations under the License.
 ##
 */

// An editable poll. It manipulates the DOM for editing a poll
Poll = function(resource) {
  this.resource = resource;
  this.owned = this.resource.object.mainComponent().isOwned();
  this.completed = this.resource.object.mainComponent().pollwinner() !== null;
  this.editing_object = null;
  this.editing_poll = null;
};

Poll.prototype.title = function() {
  return this.editing_poll ? this.editing_poll.summary() : this.resource.object.mainComponent().summary();
};

Poll.prototype.closed = function() {
  this.editing_poll = null;
};

// Save the editable state
Poll.prototype.saveResource = function(whenDone) {
  // Only if it changed
  if (this.editing_poll.changed()) {
    this.resource.object = this.editing_object;
    var this_poll = this;
    this.resource.saveResource(function() {
      // Reload from the resource as it might change after write to server
      this_poll.editing_object = this_poll.resource.object.duplicate();
      this_poll.editing_poll = this_poll.editing_object.mainComponent();

      if (whenDone) {
        whenDone();
      }
    });
  }
};

// Fill the UI with details of the poll
Poll.prototype.setPanel = function() {

  this.editing_object = this.resource.object.duplicate();
  this.editing_poll = this.editing_object.mainComponent();

  this.writeVpollValues();
};

/** Save the given choice in the current vpoll
 *
 * @param comp - jcal object
 */
Poll.prototype.saveChoice = function(comp) {
  this.editing_poll.saveChoice(comp);
};

// Fill the UI with details of the poll
Poll.prototype.writeVpollValues = function() {
  var this_poll = this;

  // Setup the details panel with this poll
  $("#editpoll-title-edit").val(this.editing_poll.summary());
  $("#editpoll-title").text(this.editing_poll.summary());
  $("#editpoll-organizer").text(this.editing_poll.organizerDisplayName());

  var curStatus = this.editing_poll.status();
  if (curStatus == null) {
    curStatus = "In Progress";
  }
  $("#editpoll-status").text(curStatus);
  $("#editpoll-choicelist").empty();

  var choices = this.editing_poll.choices();
  choices.sort(function(a, b) {
    return a.start().getEpochMilliseconds() - b.start().getEpochMilliseconds();
  });

  $.each(choices, function(index, choice) {
    this_poll.addChoicePanel(index, choice);
    //$("#debug").append(print_r(choice) + '<div style="margin: 4em 0;">new choice</div>');
  });
  $("#bwComp-voterlist").empty();
  $.each(this.editing_poll.getvoters(), function(index, voter) {
    this_poll.setVoterPanel(this_poll.addParticipantPanel(false, "voter", "Voter"), voter.getVoter());
  });
};

// Get poll details from the UI
Poll.prototype.getVpollValues = function() {
  var this_poll = this;

  // Get values from the details panel
  if (this.owned) {
    this.editing_poll.summary($("#editpoll-title-edit").val());

    //var events = this.editing_poll.choices();
    //$("#editpoll-choicelist").children().each(function(index) {
    //  this_poll.updateEventFromPanel($(this), events[index]);
    //});

  }
};

/** Get voter details from the UI
 *
 */
Poll.prototype.updateVoters = function() {
  if (!this.owned) {
    return;
  }

  var this_poll = this;
  var voters = this.editing_poll.getvoters();

  $("#bwComp-voterlist").children().each(function(index) {
    var voter = voters[index];
    var voter = voter.getVoter();
    var radioName = "voterType" + (index + 1);
    var cutype = $("input:radio[name=" + radioName + "]:checked").val();

    this_poll.updateVoterFromPanel($(this), voter, cutype);
  });


  if ($("#syncPollAttendees").is(":checked")) {
    this.editing_poll.syncAttendees();
  }
};

//Add a new event item in the UI
// XXX This is wrong. index should be the poll item id
Poll.prototype.addChoicePanel = function(index, choice) {
  var chc = '<div class="bwChoiceDisplay" id="choice-' + index +'">';
  chc += '<div class="bwChoiceButtons">';
  chc += '<div class="bwChoiceType">event</div>'; // XXX replace with actual type (e.g. event, task, location)
  chc += '<button id="choice-edit-' + index + '" class="choice-edit">Edit</button>';
  chc += '<button id="choice-delete-' + index + '" class="choice-delete">Delete</button>';
  chc += '</div>';
  chc += '<div class="bwChoiceSummary">' + choice.summary() + '</div>';

  var rinfo = getRecurrenceInfo(choice);

  if (rinfo !== null) {
    chc += '<div class="bwChoiceRecur">' + rinfo + '</div>';
  }

  chc += '<div class="bwChoiceContent">';
  var start = choice.start();
  var end = choice.end();
  var startDtLocale = start.getPrintableDateLocale() + ' ' + start.getPrintableTimeLocale();
  chc += '<div class="bwChoiceDates">';
  chc += startDtLocale + ' - ';
  if (!start.dateEquals(end)) {
    chc += end.getPrintableDateLocale() + ' ';
  }
  chc += end.getPrintableTimeLocale();
  chc += ' ' + defaultTzid;
  // Debug
  //chc += ' ' + start.getIcalUTC();
  chc += '</div>';

  var startDt = start.getPrintableDate() + ' ' + start.getPrintableTime();

  if (startDt !== startDtLocale) {
    chc += '<div class="bwChoiceDates">';
    chc += startDt + ' - ';
    if (!start.dateEquals(end)) {
      chc += end.getPrintableDate() + ' ';
    }
    chc += end.getPrintableTime();
    chc += ' ' + start.tzid();
    chc += '</div>';
  }

  if (checkStr(choice.description()) !== null) {
    chc += '<div class="bwChoiceDesc">' + choice.description() + '</div>';
  }
  chc += '</div></div>';
  chc = $(chc).appendTo("#editpoll-choicelist");

  var thisPoll = this;

  $("#choice-edit-" + index).button({
    icons : {
      primary : "ui-icon-pencil",
      text: false
    }
  }).click(function() {
    var id = this.id;
    var index = parseInt(id.substring(id.lastIndexOf("-") + 1));
    thisPoll.showChoice(thisPoll.editing_poll.choices()[index]);
  });
  $("#choice-delete-" + index).button({
    icons : {
      primary : "ui-icon-trash",
      text: false
    }
  }).click(function() {
    var id = this.id;
    var index = parseInt(id.substring(id.lastIndexOf("-") + 1));
    thisPoll.editing_poll.removeIndexedChoice(index);

    $("#choice-" + index).remove();
  });

  return chc;
};

// Update the UI for this event
// XXX Deprecated?
Poll.prototype.setChoicePanel = function(panel, event) {
  return panel;
};

// Get details of the event from the UI
Poll.prototype.updateEventFromPanel = function(panel, event) {
  event.summary($("#editpoll-title-edit").val());
};

// Add choice button clicked
Poll.prototype.addChoice = function() {
  var choiceType = $("input:radio[name=choiceType]:checked").val();
  this.getVpollValues();

  var choices = this.editing_poll.choices();

  if (choices.length === 0) {
    // Manufacture a new one

    var start = JcalDtTime.now(hour24, "start");
    start.addHours(1);

    var end = JcalDtTime.now(hour24, "end");
    end.addHours(2);

    // Add new list item
    currentEntity = this.editing_poll.makeChoice(choiceType, start, end);
  } else {
    // Clone one from the last one created.
    var prevEntity = choices[choices.length - 1];
    currentEntity = prevEntity.duplicate();

    start = currentEntity.start();
    start.addDays(1);
    start.updateProperty(currentEntity.data);

    end = currentEntity.end();
    if (end.fieldType !== "duration") {
      end.addDays(1);
    }
    end.updateProperty(currentEntity.data, start);
  }

  var itemId = this.editing_poll.nextPollItemId();
  currentEntity.pollitemid(itemId);
  this.editing_poll.changeVoterResponse(itemId, vpollResponseOk);
  this.showChoice(currentEntity);
};

Poll.prototype.showChoice = function(choice) {
  currentEntity = choice;

  $.magnificPopup.open({
    items: {
      src: "#choice-widget"
    },
    type:'inline',
    fixedBgPos: true,
    midClick: true,
    focus: "#bwEventTitle",
    callbacks: {
      beforeOpen: this.populateChoiceForm(currentEntity),
      open: function() {
        $("#choice-widget #bwEventTitle").select();
      }
    }
  }, 0);

  return true; // this.setEventPanel(this.addChoicePanel(), currentEntity);
};

//Add a new choice item in the UI
Poll.prototype.populateChoiceForm = function(choice) {
  $("#choice-widget #bwEventTitle").val(choice.summary());
  $("#choice-widget #description").val(choice.description());

  var dtSt = choice.start();
  var hour24Opts = "";
  var locNames = locations.getDisplayNames();
  var thisPoll = this;

  $("#choice-widget #bwEventWidgetStartDate").val(dtSt.getDatePart());

  if(dtSt.allDay) {
    $("#allDayFlag").click();
  } else {
    $("#storeUTCFlag").attr('checked', dtSt.UTC);
    if (hour24) { // hour24 is a global variable passed in from the XML in the XSLT
      $("#choice-widget #eventStartDateAmpm").hide();
      // generate the 24 hour options
      for (i=0; i<24; i++) {
        hour24Opts += '<option value="' + i + '">' + i + '</option>';
      }
      $("#choice-widget #eventStartDateHour").empty();
      $("#choice-widget #eventStartDateHour").html(hour24Opts);
    } else {
      if(!dtSt.am()) {
        $("#eventStartDateAmpm").val("pm");
      }
    }

    $('#eventStartDateHour option[value="' + dtSt.hoursAmPm24() + '"]').prop('selected',true);
    $('#eventStartDateMinute option[value="' + dtSt.minutes() + '"]').prop('selected',true);

    if (dtSt.tzid() !== undefined) {
      $("#startTzid").val(dtSt.tzid());
    }
  }

  var dur = choice.duration();

  if (dur != null) {
    // Flag it as end type duration
    $("input[name=eventEndType][value=D]").click();

    var jdur = new Jcalduration();

    jdur.parse(dur);

    if (jdur.mWeeks != 0) {
      $("#choice-widget #durationTypeWeeks").attr('checked', 'checked');
      $("#choice-widget #durationWeeks").val(jdur.mWeeks);
    } else {
      $("#choice-widget #durationTypeDayTime").attr('checked', 'checked');
      $("#choice-widget #durationDays").val(jdur.mDays);

      // Should hide hours/minutes for all day
      $("#choice-widget #durationHours").val(jdur.mHours);
      $("#choice-widget #durationMinutes").val(jdur.mMinutes);
    }
  } else {
    $("input[name=eventEndType][value=E]").click();

    var dtE = choice.end();

    $("#choice-widget #bwEventWidgetEndDate").val(dtE.getDatePart());

    if (!dtSt.allDay) {
      if (hour24) { // hour24 is a global variable passed in from the XML in the XSLT
        $("#choice-widget #eventEndDateAmpm").hide();
        $("#choice-widget #eventEndDateHour").empty();
        $("#choice-widget #eventEndDateHour").html(hour24Opts);
      } else {
        if(!dtE.am) {
          $("#choice-widget #eventEndDateAmpm").val("pm");
        }
      }
      $('#eventEndDateHour option[value="' + dtE.hoursAmPm24() + '"]').prop('selected',true);
      $('#eventEndDateMinute option[value="' + dtE.minutes() + '"]').prop('selected',true);

      if (dtE.tzid !== undefined) {
        $("#startTzid").val(dtE.tzid());
      }
    }
  }

  // Add a handler for the all day flag.
  $("#allDayFlag").on('click', function(cb){
    swapAllDayEvent(this);
  });

  // setup the location data
  var locationOptions = "";
  for (i = 0; i < locNames.length; i++) {
    locationOptions = '<option value="' + i + '">' + locNames[i] + '</options>';
  }

  $("#eventFormLocationList select").append(locationOptions);

  var rinfo = getRecurrenceInfo(choice);

  if (rinfo === null) {
    // Not recurring
    $("#isNotRecurring").click();
  } else {
    $("#recurrenceInfo").text(rinfo);
    this.addFormRecurrenceInfo(choice);
    $("#isRecurring").click();
  }

  $("#bwComp-attendeelist").empty();
  $.each(choice.attendees(), function(index, attendee) {
    thisPoll.setAttendeePanel(thisPoll.addParticipantPanel(true, "attendee", "Attendee"), attendee);
  });
};

/** Add any recurrence info to the form.
 *
 * @param choice
 */
Poll.prototype.addFormRecurrenceInfo = function(choice) {
  // First set to the default state
  $("#freqNONE").click();
  $("#recurCount").click();
  $("#recurCountVal").val(1);
  $("#recurInterval").val(1);
  $('#recurAdvanced').checked = false;

  var rrules = choice.rrules(); // Array - we only handle 1
  var rdates = choice.rdates();

  if ((rrules.length === 0) && (rdates.length === 0)) {
    // not recurring
    return false;
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
    return false;
  }

  $("#isRecurring").click();
  $("#freq" + freq).click();

  // until or count or neither
  var until = rrule["until"];
  var count = rrule["count"];

  if (until !== undefined) {
    $("#bwEventWidgetUntilDate").val(until);
    $("#recurUntil").click();
  } else if (count !== undefined) {
    $("#recurCount").click();
    $("#recurCountVal").val(count);
  } else {
    $("#recurForever").click();
  }

  var interval = rrule["interval"];

  var advanced = false;

  if (interval !== undefined) {
    if (interval != 1) {
      advanced = true;
    }

    $("#recurInterval").val(interval);
  }

  var bymonth = rrule["bymonth"];
  if (bymonth !== undefined) {
    asArray(bymonth).forEach(function setByMonth(val) { $("#byMonthItem" + val).click();});
    advanced = true;
  }

  var byday = rrule["byday"];
  if (byday !== undefined) {
    advanced = true;
    byday = asArray(byday);
    for (var i = 0; i < byday.length; i++) {
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

      $('[name=byDayPos' + i + ']').val(pos);
      $('#byDayRecurFields' + (i + 1) + ' [value=' + bydayval + ']').checked = true;
    }
  }

  var wkst = rrule["wkst"];
  if (wkst !== undefined) {
    advanced = true;
    $('#recurWkst option[value="' + wkst + '"]').prop('selected',true);
  }

  var bymonth = rrule["bymonth"];
  if (bymonth !== undefined) {
    advanced = true;
    bymonth = asArray(bymonth);
    for (var i = 0; i < bymonth.length; i++) {
      // 1-12
      var bymonthval = bymonth[i];

      $('#byMonthItem' + bymonthval).checked = true;
    }
  }

  var bymonthday = rrule["bymonthday"];
  if (bymonthday !== undefined) {
    advanced = true;
    bymonthday = asArray(bymonthday);
    for (var i = 0; i < bymonthday.length; i++) {
      // +/-1-31
      var bymonthdayval = bymonthday[i];

      $('#byMonthItem' + bymonthval).checked = true;
    }
  }

  if (advanced) {
    $('#recurAdvanced').checked = true;
  }

  return true;
};

// Update UI for this attendee
Poll.prototype.setAttendeePanel = function(panel, attendee) {
  panel.find(".attendee-address").val(attendee.addressDescription());
  return panel;
};


/** The reverse of populateChoiceForm - takes values from the form and
 * puts them into the given choice
 *
 * @param choice
 */
Poll.prototype.populateChoice = function(choice) {
  choice.summary($("#choice-widget #bwEventTitle").val());
  choice.description($("#choice-widget #description").val());

  var datePart = $("#choice-widget #bwEventWidgetStartDate").val();
  var allDay = $("#allDayFlag").is(":checked");
  var UTC = $("#storeUTCFlag").is(":checked");
  var hours = $("#choice-widget #eventStartDateHour").val();
  var minutes = $("#choice-widget #eventStartDateMinute").val();

  var am = false;
  if (!hour24) {
    am = $("#eventStartDateAmpm").val() === "am";
  }

  // Set the tzid from the form if one is selected
  var tzid = $("#startTzid").val();

  choice.start().update(datePart, allDay, UTC, tzid, parseInt(hours), parseInt(minutes), am);
  choice.start().updateProperty(choice.data);

  var endType = $("input:radio[name=eventEndType]:checked").val();
  if (endType === "D") {
    // Duration type

    var dur = {};

    var durType = $("input:radio[name=eventDurationType]:checked").val();

    if (durType === "weeks") {
      dur.weeks = parseInt($("#choice-widget #durationWeeks").val());
    } else {
      dur.days = parseInt($("#choice-widget #durationDays").val());

      if (!choice.start().allDay) {
        dur.hours = parseInt($("#choice-widget #durationHours").val());
        dur.minutes = parseInt($("#choice-widget #durationMinutes").val());
      }
    }

    choice.end().updateFromDuration(moment.duration(dur), choice.start());
  } else {
    // Dtend type

    datePart = $("#choice-widget #bwEventWidgetEndDate").val();
    UTC = choice.start().UTC;
    hours = $("#choice-widget #eventEndDateHour").val();
    minutes = $("#choice-widget #eventEndDateMinute").val();

    am = false;
    if (!hour24) {
      am = $("#eventEndDateAmpm").val() === "am";
    }

    // Set the tzid from the form if one is selected
    tzid = $("#endTzid").val();

    choice.end().update(datePart, allDay, UTC, tzid, parseInt(hours), parseInt(minutes), am);
  }

  choice.end().updateProperty(choice.data, choice.start());

  var rrule = this.populateRRule();

  if (rrule !== null) {
    choice.rrules(rrule);
  }
};

Poll.prototype.populateRRule = function() {
  if (!$("#isRecurring").is(":checked")) {
    return null;
  }

  /* Set the frequency */
  var f1 = $('input:radio[name="recurFreq"]');

  var freq = $('input:radio[name="recurFreq"]:checked').val();

  if (freq === "NONE") {
    return null;
  }

  var rrule = {};

  rrule['freq'] = freq;

  // until or count or neither
  if ($("#recurUntil").is(":checked")) {
    rrule['until'] = $("#bwEventWidgetUntilDate").val();
  } else if ($("#recurCount").is(":checked")) {
    rrule['count'] = parseInt($("#recurCountVal").val());
  }

  if (!$("#recurAdvanced").is(":checked")) {
    return rrule;
  }

  var interval = parseInt($("#recurInterval").val());

  if (interval !== 1) {
    rrule['interval'] = interval;
  }

  if (!$("#byMonthEnabled").is(":checked")) {
    var byMonthVals = $("[name=byMonthItem] :checked");
  }

  var byDayI = 1;

  while (true) {
    var byDayPosField = $('#byDayPos' + byDayI);

    if (byDayPosField.length === 0) {
      break;
    }

    var byDayPos = byDayPosField.val();

    if (byDayPos == 0) {
      break;
    }


    byDayI++;
  }

  var wkst = rrule["wkst"];
  if (wkst !== undefined) {
  }

  return rrule;
};

/** Add a new voter or attendee item in the UI
 *
 * @param readOnly true if this is for display only
 * @param itemType "attendee" or "voter"
 * @param itemLabel currently "Attendee" or "Voter"
 * @returns {string}
 */
Poll.prototype.addParticipantPanel = function(readOnly, itemType, itemLabel) {
  var ctr = $("#bwComp-" + itemType + "list").children().length + 1;
  var iditem = itemType + "-address-" + ctr;
  var iditemTypePrefix = itemType + "-" + ctr;
  var idRemove = itemType + "-remove-" + ctr;
  var idDiv = itemType + "-div-" + ctr;
  var radioName = itemType + "Type" + ctr;

  // Add new list item
  var idiv = '';

  if (readOnly) {
    // if readOnly, just generate a very simple list
    idiv += '<div class="' + itemType + '" id="' + idDiv + '">';
    idiv += '<div class="edit-' + itemType + '">';
    idiv += '<label for="' + iditem + '">' + itemLabel + ': </label>';
    idiv += '<input type="text" id="' + iditem + '" class="' + itemType + '-address" disabled="disabled"/>';
    idiv += '</div>';
    idiv += '</div>';
    idiv = $(idiv).appendTo("#bwComp-" + itemType + "list");
  } else {
    // is editable - generate a panel
    idiv += '<div class="' + itemType + '" id="' + idDiv + '">';
    idiv += '<div class="edit-' + itemType + '">';
    idiv += '<label for="' + iditem + '">' + itemLabel + ': </label>';
    idiv += '<input type="text" id="' + iditem + '" class="' + itemType + '-address" placeholder="Type a name"/>';
    idiv += '<span id="edit-' + itemType + 'type">';
    idiv += '<input type="radio" id="' + iditemTypePrefix +
        '-typeUser" name="' + radioName + '" value="INDIVIDUAL" checked/>';
    idiv += '<label for="' + iditemTypePrefix + '-typeUser">user</label>';
    idiv += '<input type="radio" id="' + iditemTypePrefix +
        '-typeGroup" name="' + radioName + '" value="GROUP"/>';
    idiv += '<label for="' + iditemTypePrefix + '-typeGroup">group</label>';
    idiv += '<input type="radio" disabled="disabled" id="' + iditemTypePrefix +
        '-typeLocation" name="' + radioName + '" value="ROOM"/>';
    idiv += '<label for="' + iditemTypePrefix + '-typeLocation" class="disabled">location</label>';
    /* Not yet
     idiv += '<input type="radio" id="' + iditemTypePrefix +
     '-typeAny" name="' + radioName + '" value="ANY"/>';
     idiv += '<label for="' + iditemTypePrefix + '-typeAny">Any</label>';
     */
    idiv += '</span>';
    idiv += '</div>';
    idiv += '<button class="input-remove" id="' + idRemove + '">Remove</button>';
    idiv += '</div>';
    idiv = $(idiv).appendTo("#bwComp-" + itemType + "list");

    var this_poll = this;

    var addrField = idiv.find("." + itemType + "-address");
    addrField.hover(
        function () {
          this_poll.hoverCuaddrDialogOpen(addrField);
        },
        this_poll.hoverCuaddrDialogClose
    );

    addrField.autocomplete({
      minLength: 3,
      extraParams: {
        cutype: function () {
          return  $("input:radio[name=" + radioName + "]:checked").val();
        }
      },
      source: function (request, response) {
        var cutype = this.options.extraParams.cutype();
        if (cutype === "ANY") {
          cutype = null;
        }
        gSession.calendarUserSearch(request.term, cutype, function (results) {
          response(results);
        });
      }
    }).focus(function () {
      $(this).select();
    });

    idiv.find(".input-remove").button({
      icons: {
        primary: "ui-icon-trash",
        text: false
      }
    }).click(function () {
      //alert("remove particpant " + ctr);
      this_poll.removeParticipant(itemType, ctr - 1, idDiv)
    });
  }

  return idiv;
};

// Update UI for this voter
Poll.prototype.setVoterPanel = function(panel, voter) {
  panel.find(".voter-address").val(voter.addressDescription());
  panel.find("[name='voterType']").find("[value='" + voter.cutype() + "']").prop('checked', true);
  return panel;
};

// Get details of the voter from the UI
Poll.prototype.updateVoterFromPanel = function(panel, voter, cutype) {
  voter.addressDescription(panel.find(".voter-address").val());
  voter.cutype(cutype)
};

// Add voter button clicked
Poll.prototype.addVoter = function() {
  // Add new list item
  poll_syncAttendees = $("#syncPollAttendees").is(":checked");

  var voter = this.editing_poll.addvoter();
  return this.setVoterPanel(this.addParticipantPanel(false, "voter", "Voter"), voter.getVoter());
};

// Remove participant button clicked
Poll.prototype.removeParticipant = function(itemType, index, idDiv) {
  if (itemType !== "voter") {
    alert("Remove attendee not implemented");
    return;
  }

  $("#" + idDiv).remove();

  poll_syncAttendees = $("#syncPollAttendees").is(":checked");

  this.editing_poll.removevoter(index);
};

/** Build the results UI based on the poll details
 * We're building something that looks like below: i,e
 *
 * table head is the overall results
 * table body information about choice
 * table footer is the voting buttons and per-voter status.
 *
 * The first element in each row is the label column
 *
 * For overall results -
 *    first row - some sort of status
 *    Second row - if we own the poll we can select the winner so
 *                      we have a row of commit buttons.
 *
 *  For body:
 *    Varying number of rows with choice data
 *
 *  For footer
 *
 * <div id="editpoll-resultsbox">
   <table id="editpoll-resulttable">
     <thead>
       <tr>
         <td class="noborder"></td>
         <td class="respNoResponseOverall">No Response</td>
         <td class="respNoResponseOverall">No Response</td>
       </tr>
       <tr id="editpoll-resultsButtons" class="" style="display: none;">
     </thead>
     <tbody>
       <tr>
         <td>Summary:</td>
         <td class="summary-td">la - 10pm 7th</td>
         <td class="summary-td">la - 10pm 8th</td>
       </tr>
       <tr>
         <td>When:</td>
         <td class="when-td"></td>
         <td class="when-td"></td>
       </tr>
       <tr class="invisible">
         <td>Recurs:</td>
         <td class="recur-td">no</td>
         <td class="recur-td">no</td>
       </tr>
       <tr></tr>
     </tbody>
     <tfoot>
       <tr class="active-voter">
         <td> Douglass</td>
         <td class="center-td">
         <td class="center-td">
       </tr>
       <tr>
         <td>johnsa</td>
         <td class="center-td respOk">Ok</td>
         <td class="center-td respOk">Ok</td>
       </tr>
     </tfoot>
   </table>
 </div>

 */
Poll.prototype.buildResults = function() {
  var this_poll = this;
  var resultTable = $("#editpoll-resulttable");

  // Sync with any changes from other panels
  this.getVpollValues();

  var choices = this.editing_poll.choices();
  choices.sort(function(a, b) {
    return a.start().getEpochMilliseconds() - b.start().getEpochMilliseconds();
  });

  var th = resultTable.children("thead").first();
  var thOverallRows = th.children("tr");
  var thOverall = thOverallRows.first().empty();
  var thCommit = thOverallRows.last().empty();
  thCommit.toggle(this.owned || !this_poll.editing_poll.editable());

  // Add empty invisible label boxes to the overall rows as first column.
  $('<td class="noborder"></td>').appendTo(thOverall);
  $('<td class="noborder"/>').appendTo(thCommit);

  var tbody = resultTable.children("tbody").first();
  var tbodyRows = tbody.children("tr");
  var tb_summary = tbodyRows.eq(0).empty();
  var tb_when = tbodyRows.eq(1).empty();
  var tb_recur = tbodyRows.eq(2).empty().addClass("invisible");
  //var tb_desc = tbodyRows.eq(3).empty();

  // Add labels to each body row as column 0
  $('<td>Summary:</td>').appendTo(tb_summary);
  $('<td>When:</td>').appendTo(tb_when);
  $('<td>Recurs:</td>').appendTo(tb_recur);
  // XXX deprecate? $('<td>Description:</td>').appendTo(tb_desc);


  var tfoot = resultTable.children("tfoot").first().empty();

  if (this_poll.editing_poll.editable()) {
    $('#editpoll-resultsButtons').removeClass('invisible');
  } else {
    $('#editpoll-resultsButtons').addClass('invisible');
  }

  /* For each choice add a column with the choice data
   */
  $.each(choices, function(index, choice) {
    var td_summary = $('<td />').appendTo(tb_summary).text(choice.summary()).addClass("summary-td");

    var when = getWhen(choice, "ChoiceDates");
    var td_when = $('<td />').appendTo(tb_when).html(when).addClass("when-td");

    var rinfo = getRecurrenceInfo(choice);

    if (rinfo !== null) {
      tb_recur.removeClass("invisible");
      var td_recur = $('<td />').appendTo(tb_recur).text(rinfo).addClass("recur-td");
    } else {
      var td_recur = $('<td />').appendTo(tb_recur).text(i18nStrings["bwStr-AEEF-No"]).addClass("recur-td");
    }

    $('<td />').appendTo(thOverall).addClass("center-td");
    $('<td />').appendTo(thCommit).addClass("center-td");
    if (choice.ispollwinner()) {
      td_summary.addClass("poll-winner-td");
      td_when.addClass("poll-winner-td");
      td_recur.addClass("poll-winner-td");
    }
    /* XXX Disable while in progress
    td_summary.hover(
        function() {
          this_poll.hoverCalDialogOpen(td_summary, tbody, event);
        },
        this_poll.hoverCalDialogClose
    ); */
  });
  var voterDetails = this.editing_poll.getvoters();

  $.each(voterDetails, function(index, vvoter) {
    var voter = vvoter.getVoter();
    var active = gSession.currentPrincipal.matchingAddress(voter.cuaddr());
    var tr = $("<tr/>").appendTo(tfoot);
    var voterName = voter.nameOrAddress();
    if (voterName.indexOf("mailto:") == 0) {
      voterName = voterName.substring(7);
    }
    $("<td/>").appendTo(tr).text(voterName);

    $.each(choices, function(index, event) {
      var pollItemId = event.pollitemid();
      var td = $("<td />").appendTo(tr).addClass("center-td");
      if (event.ispollwinner()) {
        td.addClass("poll-winner-td");
      }
      var response = vvoter.getResponseNormalised(pollItemId);

      if (!active || !this_poll.editing_poll.editable()) {
        td.text(textForResponse[response]);
        td.addClass(classForResponse[response]);
        return;
      }

      /* Add voting buttons */
      var name = "response-" + pollItemId;
      var radios = $('<div id="' + name + '" />').appendTo(td).addClass("response-btns");
      for (var i = 1; i < idPrefixForResponse.length; i++) {
        var id = idPrefixForResponse[i] + "-" + pollItemId;
        $('<input type="radio" id="' + id + '" name="' + name + '"/>').appendTo(radios);
        $('<label for="' + id + '"/>').appendTo(radios);
      }
      radios.buttonset();

      if (response >= 0) {
        $('#' + idPrefixForResponse[response] + '-' + pollItemId).click();
      }

      for (var i = 1; i < idPrefixForResponse.length; i++) {
        var id = '#' + idPrefixForResponse[i] + "-" + pollItemId;
        $(id).button({
          icons: {
            primary: iconForResponse[i]
          },
          label: textForResponse[i],
          text: false
        }).click(this_poll.clickResponse);
        $(id).next("label").addClass(buttonClassForResponse[i]);
      }
    });
    if (active) {
      tr.addClass("active-voter");
    }
  });

  if (this.editing_poll.editable()) {
    $.each(choices, function(index, choice) {
      $('<button id="winner-' + choice.pollitemid() + '">Pick Winner</button>').appendTo(thCommit.children()[index + 1]).button({
        icons : {
          primary : "ui-icon-star"
        }
      }).click(this_poll.clickWinner);
    });
  }

  this.updateOverallResults();
};

// TODO - add to localizations
var textForResponse = [
  "No Response",
  "No",
  "Maybe",
  "Ok",
  "Best"
];

var classForResponse = [
  "respNoResponse",
  "respNo",
  "respMaybe",
  "respOk",
  "respBest"
];

var iconForResponse = [
  null,
  "ui-icon-close",
  "ui-icon-help",
  "ui-icon-check",
  "ui-icon-circle-check"
];

var idPrefixForResponse = [
  "respondNoResponse",
  "respondNo",
  "respondMaybe",
  "respondOk",
  "respondBest"
];

var buttonClassForResponse = [
  null,
  "noButton",
  "maybeButton",
  "okButton",
  "bestButton"
];

Poll.prototype.clickResponse = function() {
  var splits = $(this).attr("id").split("-");
  var idPrefix = splits[0];
  var itemId = parseInt(splits[1]);
  var response = vpollResponseNone;

  for (var i = 1; i < idPrefixForResponse.length; i++) {
    if (idPrefix === idPrefixForResponse[i]) {
      response = i;
      break;
    }
  }

  gViewController.activePoll.editing_poll.changeVoterResponse(itemId, response);
  gViewController.activePoll.updateOverallResults();
};

/** For basic poll mode we need to provide some overall view of the
 * voting for a choice. Simple aerages don't work. What we do here is:
 *
 * If all voters (except the organizer) vote NO - then it's a NO vote
 *       (We'll fake this for the moment by saying on non-no vote must be the organizer)
 *
 * If all voters vote best - then it's a Best vote
 *
 * If all voters vote best or Ok - then it's an Ok vote
 *
 * Otherwise it's maybe
 *
 */
Poll.prototype.updateOverallResults = function() {
  var thisPoll = this;
  var choices = this.editing_poll.choices();
  var voterDetails = this.editing_poll.getvoters();
  var resultTable = $("#editpoll-resulttable");
  var th = resultTable.children("thead").first();
  var tbody = resultTable.children("tbody").first();
  var tfoot = resultTable.children("tfoot").first();

  var overallStatusRow = th.children("tr").first().children("td");

  // Update overall items
  $.each(choices, function(index, choice) {
    var numResponses = 0;
    var responses = [0, 0, 0, 0, 0];

    var itemId = choice.pollitemid();
    $.each(voterDetails, function(index, voter) {
      var response = voter.getResponseNormalised(itemId);

      responses[response]++;

      if (response === vpollResponseNone) {
        return;
      }

      numResponses++;
    });

    var overallResponse = vpollResponseNone;

    if (numResponses > 1) {
      if ((responses[1] / numResponses) > 0.5) {
        // At least half said No
        overallResponse = vpollResponseNo;
      } else if (numResponses === responses[4]) {
        // All say Aye
        overallResponse = vpollResponseBest;
      } else if ((responses[4] > 0) &&
          (numResponses === (responses[3] + responses[4]))) {
        // At least some say Aye and the rest are near enough
        overallResponse = vpollResponseBest;
      } else if (numResponses === responses[3]) {
        // All say Ok
        overallResponse = vpollResponseOk;
      } else {
        // TODO - I think the above works better - this probably needs work
        /* More than half the responses were not NO -
         If necessary we could add some intermediate states but I think
         people really only case about the best ones and the worst ones.

         That is - we need to know if everybody says NO and Ok + Best
         is really good enough. If we get a true everybody says this
         is best that's the one to highlight.

         I'm guessing that after about half the responses we're better
         off showing only the best - at least for polls with a lot
         of choices
         */
        overallResponse = vpollResponseMaybe;
      }
    }

    var overallClass = classForResponse[overallResponse] + "Overall";

    /*
     $(overallStatusRow[index + 1]).text(textForResponse[overallResponse]);
     $(overallStatusRow[index + 1]).removeClass();
     if(choice.ispollwinner()) {
     $(overallStatusRow[index + 1]).addClass("poll-winner-td");
     $(overallStatusRow[index + 1]).html('<div id="winner-text"><span id="winner-icon-left" class="ui-icon ui-icon-star" />Winner<span id="winner-icon-right" class="ui-icon ui-icon-star" /></div>');
     } else {
     $(overallStatusRow[index + 1]).addClass(overallClass);
     }
     //$(overallStatusRow[index + 1]).addClass(event.ispollwinner() ? "poll-winner-td" : response_details[1]);
     */

    /* Remove the overall status from each cell in the current column
     */

    /* Index is offset by 1 to account for the label column. Note that
     index is 0 based and nth-child is 1 based so we have to offset
     by 2.
     */

    var colI = "" + (index + 2);
    var headCol = $(th).find("tr td:nth-child(" + colI + ")");
    var bodyCol = $(tbody).find("tr td:nth-child(" + colI + ")");
    var footCol = $(tfoot).find("tr td:nth-child(" + colI + ")");

    thisPoll.removeOverallClasses(headCol);
    thisPoll.removeOverallClasses(bodyCol);
    thisPoll.removeOverallClasses(footCol);

    headCol.addClass(overallClass);
    bodyCol.addClass(overallClass);
    footCol.addClass(overallClass);

    if(choice.ispollwinner()) {
      $(overallStatusRow[index + 1]).addClass("poll-winner-td");
      $(overallStatusRow[index + 1]).html('<div id="winner-text"><span id="winner-icon-left" class="ui-icon ui-icon-star" />Winner<span id="winner-icon-right" class="ui-icon ui-icon-star" /></div>');
    }
  });
};

Poll.prototype.removeOverallClasses = function(element) {
  for (var index = 0; index < classForResponse.length; ++index) {
    $(element).removeClass(classForResponse[index] + "Overall");
  }
};

// A winner was chosen, make poll changes and create new event and save everything
Poll.prototype.clickWinner = function() {
  var splits = $(this).attr("id").split("-");
  var poll = gViewController.activePoll;
  var vpoll = poll.editing_poll;
  var comp = vpoll.getChoice(parseInt(splits[1]));
  var new_resource = comp.pickAsWinner();
  new_resource.saveResource(function() {
    poll.saveResource(function() {
//      gViewController.activatePoll(gViewController.activePoll, false);
      // Make everything disappear
//      gViewController.clickPollCancel();
    });
  });

  gViewController.clickPollSave();
  gViewController.completed(this);
};

// Open the event time-range hover dialog
Poll.prototype.hoverCalDialogOpenClassic = function(td_summary, tbody, event) {
  var dialog_div = $('<div id="hover-cal" />').appendTo(td_summary).dialog({
    dialogClass: "no-close",
    position: { my: "left top", at: "right+20 top", of: tbody },
    show: "fade",
    title: "Your Events for " + event.start().getPrintableDateLocale(),
    width: 400
  });
  var start = event.start().clone().addHours(-6);
  var end = event.end().clone().addHours(6);
  gSession.currentPrincipal.eventsForTimeRange(
      start,
      end,
      function(results) {
        var text = "";
        results = $.map(results, function(result) {
          return result.mainComponent();
        });
        results.push(event);
        results.sort(function(a, b) {
          return a.start().getEpochMilliseconds() - b.start().getEpochMilliseconds();
        });
        var relative_offset = 10;
        var last_end = null;
        $.each(results, function(index, result) {
          text = result.start().getPrintableTimeLocale() + " - ";
          text += result.end().getPrintableTimeLocale() + " : ";
          text += result.summary();
          if (last_end !== null && !last_end.equals(result.start())) {
            relative_offset += 10;
          }
          last_end = result.end();
          $('<div class="hover-event ui-corner-all" style="top:' + relative_offset + 'px"/>').appendTo(dialog_div).addClass(result.pollitemid() !== null ? "ui-state-active" : "ui-state-default").text(text);
        });
      }
  );
}

// Open the event time-range hover dialog
Poll.prototype.hoverCalDialogOpenFancy = function(td_summary, tbody, event) {
  var dialog_div = $('<div id="hover-cal" />').appendTo(td_summary).dialog({
    dialogClass: "no-close",
    position: { my: "left top", at: "right+20 top", of: tbody },
    show: "fade",
    title: "Your Events for " + event.start().getPrintableDateLocale(),
    width: 400
  });

  /* get 12 hour span */
  var start = event.start().clone();
  start.subtractHours(6);

  var end = event.end().clone();
  end.addHours(6);

  var gridStart = start.clone();

  var grid = $('<table id="hover-grid" />').appendTo(dialog_div);
  for(var i = 0; i <= 12; i++) {
    var text = gridStart.getPrintableTimeLocale();
    gridStart.addHours(1);
    $('<tr><td class="hover-grid-td-time">' + text + '</td><td class="hover-grid-td-slot" /></tr>').appendTo(grid);
  }

  gSession.currentPrincipal.eventsForTimeRange(
      start,
      end,
      function(results) {
        results = $.map(results, function(result) {
          return result.mainComponent();
        });

        /* Add the current event to the result */
        results.push(event);
        results.sort(function(a, b) {
          return a.start().getEpochMilliseconds - b.start().getEpochMilliseconds();
        });
        var lastDtend = null;
        $.each(results, function(index, result) {
          result.start().tzid(start.tzid());
          result.end().tzid(start.tzid());

          var hoursOffset = result.start().diff(start, 'hours');
          var topOffset = hoursOffset * 30;

          var seconds = result.end().diff(result.start(), 'seconds');
          var height = (seconds * 30) / (60 * 60) - 6;

          var theDiv = $('<div class="hover-event ui-corner-all"/>').appendTo(grid);

          theDiv.css('position', 'absolute');
          theDiv.css('top', topOffset + "px");
          theDiv.css('height', height + "px");

          if ((lastDtend !== null) && (lastDtend.diff(result.start(), 'millisecsonds') > 0)) {
            theDiv.css('left', "206px");
            theDiv.css('width', "125px");
          }
          lastDtend = result.end();
          theDiv.addClass(result.pollitemid() !== null ? "ui-state-active" : "ui-state-default").text(result.summary());
        });
      }
  );
};

Poll.prototype.hoverCalDialogOpen = Poll.prototype.hoverCalDialogOpenFancy;

// Close the event time-range hover dialog
Poll.prototype.hoverCalDialogClose = function() {
  $("#hover-cal").dialog("close").remove();
};

// Open the participant address hover dialog
Poll.prototype.hoverCuaddrDialogOpen = function(td_addr) {
  var splits = splitAddressDescription(td_addr.val());

  var card = cuaddrVcards[splits[1]];

  if (card === undefined) {
    return;
  }

  if (card === null) {
    return;
  }

  var kind = card.data.getPropertyValue("kind");
  if (kind !== "group") {
    return;
  }

  var dialog_div = $('<div id="hover-cuaddr" />').appendTo(td_addr).dialog({
    dialogClass: "no-close",
    position: { my: "left top", at: "right+20 top", of: td_addr },
    show: "fade",
    title: "Card for " + td_addr.val(),
    width: 400
  });

  var grid = $('<table id="hover-grid" />').appendTo(dialog_div);
  var members = card.data.properties("member");
  for (var i = 0; i < members.length; i++) {
    var member = members[i];
    $('<tr><td class="hover-grid-td-time">' + member[3] + '</td><td class="hover-grid-td-slot" /></tr>').appendTo(grid);
  }
};

// Close the participant address hover dialog
Poll.prototype.hoverCuaddrDialogClose = function() {
  $("#hover-cuaddr").dialog("close").remove();
};

/** Fill in the responses based on users freebusy at the time of the choice
 *
 */
Poll.prototype.autoFill = function() {

  var choice_details = this.editing_poll.choices();
  $.each(choice_details, function(index, choice) {
    // Freebusy
    gSession.currentPrincipal.isBusy(
        gSession.currentPrincipal.defaultAddress(),
        choice.start(),
        choice.end(),
        function(result) {
          $((result ? "#respond_no-" : "#respond_ok-") + index).click();
        }
    );
  });
};

