<?xml version="1.0" encoding="UTF-8"?>
<!-- 
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
-->
<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml">

  <!-- xsl:template match="/" -->

  <!-- xsl:template name="headSection" -->
  <xsl:variable name="bwStr-Head-BedeworkSubmitPubEv">Bedework: Submit a Public Event</xsl:variable>

  <!-- xsl:template name="header" -->
  <xsl:variable name="bwStr-Head-CalendarSuite">Calendar Suite</xsl:variable>
  <xsl:variable name="bwStr-Head-None">none</xsl:variable>
  <xsl:variable name="bwStr-Hedr-BedeworkPubEventSub">Submit a Public Event</xsl:variable>
  <xsl:variable name="bwStr-Hedr-LoggedInAs">logged in as</xsl:variable>
  <xsl:variable name="bwStr-Hedr-Logout">logout</xsl:variable>

  <!-- xsl:template name="messagesAndErrors" -->

  <!-- xsl:template name="menuTabs" -->
  <xsl:variable name="bwStr-MeTa-Overview">Overview</xsl:variable>
  <xsl:variable name="bwStr-MeTa-AddEvent">Add Event</xsl:variable>
  <xsl:variable name="bwStr-MeTa-MyPendingEvents">My Pending Events</xsl:variable>

  <!-- xsl:template name="home" -->
  <xsl:variable name="bwStr-Home-Start">start</xsl:variable>
  <xsl:variable name="bwStr-Home-EnteringEvents">Entering Events</xsl:variable>
  <xsl:variable name="bwStr-Home-BeforeSubmitting">Before submitting a public event,</xsl:variable>
  <xsl:variable name="bwStr-Home-SeeIfItHasBeenEntered">see if it has already been entered</xsl:variable>
  <xsl:variable name="bwStr-Home-ItIsPossible">It is possible that an event may be created under a different title than you'd expect.</xsl:variable>
  <xsl:variable name="bwStr-Home-MakeYourTitles">Make your titles descriptive: rather than "Lecture" use "Music Lecture Series: 'Uses of the Neapolitan Chord'". "Cinema Club" would also be too vague, while "Cinema Club: 'Citizen Kane'" is better. Bear in mind that your event will "share the stage" with other events in the calendar - try to be as clear as possible when thinking of titles. Express not only what the event is, but (briefly) what it's about. Elaborate on the event in the description field, but try not to repeat the same information.  Try to think like a user when suggesting an event: use language that will explain your event to someone who knows absolutely nothing about it.</xsl:variable>
  <xsl:variable name="bwStr-Home-DoNotInclude">Do not include locations and times in the description field (unless it is to add extra information not already displayed).</xsl:variable>

  <!-- xsl:template match="formElements" mode="addEvent" -->
  <!-- xsl:template match="formElements" mode="editEvent" -->
  <!-- xsl:template match="formElements" mode="eventForm" -->
  <xsl:variable name="bwStr-FoEl-DeleteColon">Delete:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Instance">instance</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Delete">Delete</xsl:variable>
  <xsl:variable name="bwStr-FoEl-All">all</xsl:variable>
  <xsl:variable name="bwStr-FoEl-TASK">Task</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Task">task</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Meeting">Meeting</xsl:variable>
  <xsl:variable name="bwStr-FoEl-EVENT">Event</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Event">event</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Recurring">Recurring</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Personal">Personal</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Public">Public</xsl:variable>
  <xsl:variable name="bwStr-FoEl-RecurrenceMaster">(recurrence master)</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Next">next</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Step1"><strong>Step 1:</strong> Enter Event Details. <em>Optional fields are italicized.</em></xsl:variable>
  <xsl:variable name="bwStr-FoEl-Previous">previous</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Step2"><strong>Step 2:</strong> Select Location.</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Step3"><strong>Step 3:</strong> Select Contact.</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Step4"><strong>Step 4:</strong> Suggest Topical Areas. <em>Optional.</em></xsl:variable>
  <xsl:variable name="bwStr-FoEl-Step5"><strong>Step 5:</strong> Contact Information and Comments.</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Calendar">Calendar:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Title">Title:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-MustIncludeTitle">You must include a title.</xsl:variable>
  <xsl:variable name="bwStr-FoEl-DateAndTime">Date &amp; Time:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-AllDay">all day</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Start">Start:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-SelectTimezone">select timezone</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Due">Due:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-End">End:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Date">Date</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Duration">Duration</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Days">days</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Hours">hours</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Minutes">minutes</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Weeks">weeks</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Or">or</xsl:variable>
  <xsl:variable name="bwStr-FoEl-This">This</xsl:variable>
  <xsl:variable name="bwStr-FoEl-HasNoDurationEndDate">has no duration / end date</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Description">Description</xsl:variable>
  <xsl:variable name="bwStr-FoEl-CharsMax">characters max.</xsl:variable>
  <xsl:variable name="bwStr-FoEl-CharsRemaining">character(s) remaining.</xsl:variable>
  <xsl:variable name="bwStr-FoEl-MustIncludeDescription">You must include a description.</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Status">Status:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Confirmed">confirmed</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Tentative">tentative</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Canceled">canceled</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Cost">Cost:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-CostOptional">optional: if any, and place to purchase tickets</xsl:variable>
  <xsl:variable name="bwStr-FoEl-EventURL">Event URL:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-EventURLOptional">optional: for more information about the event</xsl:variable>
  <xsl:variable name="bwStr-FoEl-ImageURL">Image URL:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-ImageURLOptional">optional: to include an image with the event description</xsl:variable>
  <xsl:variable name="bwStr-FoEl-MustSelectLocation">You must either select a location or suggest one below.</xsl:variable>
  <xsl:variable name="bwStr-FoEl-SelectExistingLocation">select an existing location...</xsl:variable>
  <xsl:variable name="bwStr-FoEl-DidntFindLocation">Didn't find the location?  Suggest a new one:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Address">Address:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-SubAddress">Sub-address:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Optional">optional</xsl:variable>
  <xsl:variable name="bwStr-FoEl-URL">URL:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-MustSelectContact">You must either select a contact or suggest one below.</xsl:variable>
  <xsl:variable name="bwStr-FoEl-SelectExistingContact">select an existing contact...</xsl:variable>
  <xsl:variable name="bwStr-FoEl-DidntFindContact">Didn't find the contact you need?  Suggest a new one:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-OrganizationName">Organization Name:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-PleaseLimitContacts">Please limit contacts to organizations, not individuals.</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Phone">Phone:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Email">Email:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-MissingTopicalArea">Missing a topical area?  Please describe what type of event you're submitting:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-TypeOfEvent">Type of event:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-MustIncludeEmail">You must include your email address.</xsl:variable>
  <xsl:variable name="bwStr-FoEl-InvalidEmailAddress">This does not appear to be a valid email address.  Please correct.</xsl:variable>
  <xsl:variable name="bwStr-FoEl-EnterEmailAddress">Enter your email address:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-FinalNotes">Please supply any final notes or instructions regarding your event:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-SubmitForApproval">submit for approval</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Cancel">cancel</xsl:variable>

  <!-- xsl:template match="calendar" mode="showEventFormAliases" -->

  <!-- xsl:template match="val" mode="weekMonthYearNumbers" -->
  <xsl:variable name="bwStr-WMYN-Next">and</xsl:variable>

  <!-- xsl:template name="byDayChkBoxList" -->

  <!-- xsl:template name="buildCheckboxList" -->

  <!-- xsl:template name="recurrenceDayPosOptions" -->
  <xsl:variable name="bwStr-RDPO-None">none</xsl:variable>
  <xsl:variable name="bwStr-RDPO-TheFirst">the first</xsl:variable>
  <xsl:variable name="bwStr-RDPO-TheSecond">the second</xsl:variable>
  <xsl:variable name="bwStr-RDPO-TheThird">the third</xsl:variable>
  <xsl:variable name="bwStr-RDPO-TheFourth">the fourth</xsl:variable>
  <xsl:variable name="bwStr-RDPO-TheFifth">the fifth</xsl:variable>
  <xsl:variable name="bwStr-RDPO-TheLast">the last</xsl:variable>
  <xsl:variable name="bwStr-RDPO-Every">every</xsl:variable>

  <!-- xsl:template name="buildRecurFields" -->
  <xsl:variable name="bwStr-BReF-And">and</xsl:variable>

  <!-- xsl:template name="buildNumberOptions" -->

  <!-- xsl:template name="clock" -->
  <xsl:variable name="bwStr-Cloc-Bedework24HourClock">Bedework 24-Hour Clock</xsl:variable>
  <xsl:variable name="bwStr-Cloc-Type">type</xsl:variable>
  <xsl:variable name="bwStr-Cloc-SelectTime">select time</xsl:variable>
  <xsl:variable name="bwStr-Cloc-Switch">switch</xsl:variable>
  <xsl:variable name="bwStr-Cloc-Close">close</xsl:variable>
  
  <!-- xsl:template name="newclock" -->
  <xsl:variable name="bwStr-Cloc-Hour">Hour</xsl:variable>
  <xsl:variable name="bwStr-Cloc-Minute">Minute</xsl:variable>
  <xsl:variable name="bwStr-Cloc-AM">am</xsl:variable>
  <xsl:variable name="bwStr-Cloc-PM">pm</xsl:variable>
  
  <!-- xsl:template name="eventList" -->
  <xsl:variable name="bwStr-EvLs-PendingEvents">Pending Events</xsl:variable>
  <xsl:variable name="bwStr-EvLs-EventsBelowWaiting">The events below are waiting to be published by a calendar administrator.  You may edit or delete the events until they have been accepted.  Once your event is published, you will no longer see it in your list.</xsl:variable>

  <!-- xsl:template name="eventListCommon" -->
  <xsl:variable name="bwStr-EvLC-Title">Title</xsl:variable>
  <xsl:variable name="bwStr-EvLC-CalSuite">Suite</xsl:variable>
  <xsl:variable name="bwStr-EvLC-ClaimedBy">Claimed By</xsl:variable>
  <xsl:variable name="bwStr-EvLC-Start">Start</xsl:variable>
  <xsl:variable name="bwStr-EvLC-End">End</xsl:variable>
  <xsl:variable name="bwStr-EvLC-TopicalAreas">Topical Areas</xsl:variable>
  <xsl:variable name="bwStr-EvLC-Description">Description</xsl:variable>
  <xsl:variable name="bwStr-EvLC-NoTitle">no title</xsl:variable>
  <xsl:variable name="bwStr-EvLC-Unclaimed">unclaimed</xsl:variable>
  <xsl:variable name="bwStr-EvLC-RecurringEvent">Recurring event.</xsl:variable>
  <xsl:variable name="bwStr-EvLC-Edit">Edit:</xsl:variable>
  <xsl:variable name="bwStr-EvLC-Master">master</xsl:variable>
  <xsl:variable name="bwStr-EvLC-Instance">instance</xsl:variable>

  <!-- xsl:template name="upload" -->
  <xsl:variable name="bwStr-Upld-AffectsFreeBusy">Affects free/busy:</xsl:variable>
  <xsl:variable name="bwStr-Upld-Yes">yes</xsl:variable>
  <xsl:variable name="bwStr-Upld-Transparent">(transparent: event status does not affect your free/busy)</xsl:variable>
  <xsl:variable name="bwStr-Upld-No">no</xsl:variable>
  <xsl:variable name="bwStr-Upld-Opaque">(opaque: event status affects your free/busy)</xsl:variable>
  <xsl:variable name="bwStr-Upld-UploadICalFile">Upload iCAL File</xsl:variable>
  <xsl:variable name="bwStr-Upld-Filename">Filename:</xsl:variable>
  <xsl:variable name="bwStr-Upld-IntoCalendar">Into calendar:</xsl:variable>
  <xsl:variable name="bwStr-Upld-DefaultCalendar">default calendar</xsl:variable>
  <xsl:variable name="bwStr-Upld-AcceptEventsSettings">accept event's settings</xsl:variable>
  <xsl:variable name="bwStr-Upld-Status">Status:</xsl:variable>
  <xsl:variable name="bwStr-Upld-AcceptEventsStatus">accept event's status</xsl:variable>
  <xsl:variable name="bwStr-Upld-Confirmed">confirmed</xsl:variable>
  <xsl:variable name="bwStr-Upld-Tentative">tentative</xsl:variable>
  <xsl:variable name="bwStr-Upld-Canceled">canceled</xsl:variable>
  <xsl:variable name="bwStr-Upld-Continue">Continue</xsl:variable>
  <xsl:variable name="bwStr-Upld-Cancel">cancel</xsl:variable>

  <!-- xsl:template name="timeFormatter" -->
  <xsl:variable name="bwStr-TiFo-AM">AM</xsl:variable>
  <xsl:variable name="bwStr-TiFo-PM">PM</xsl:variable>

  <!-- xsl:template name="footer" -->
  <xsl:variable name="bwStr-Foot-BasedOnThe">Based on the</xsl:variable>
  <xsl:variable name="bwStr-Foot-ShowXML">show XML</xsl:variable>
  <xsl:variable name="bwStr-Foot-RefreshXSLT">refresh XSLT</xsl:variable>
  <xsl:variable name="bwStr-Foot-BedeworkCalendarSystem">Bedework Calendar System</xsl:variable>
  <xsl:variable name="bwStr-Foot-ProductionExamples">Production Examples</xsl:variable>
</xsl:stylesheet>