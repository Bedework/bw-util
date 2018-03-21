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

  <!--  xsl:template name="headSection" -->
  <xsl:variable name="bwStr-Head-PageTitle">Bedework: Personal Calendar Client</xsl:variable>

  <!--  xsl:template name="messagesAndErrors" -->

  <!--  xsl:template name="headBar" -->
  <xsl:variable name="bwStr-HdBr-PublicCalendar">Public Calendar</xsl:variable>
  <xsl:variable name="bwStr-HdBr-PersonalCalendar">Personal Calendar</xsl:variable>
  <xsl:variable name="bwStr-HdBr-UniversityHome">University Home</xsl:variable>
  <xsl:variable name="bwStr-HdBr-SchoolHome">School Home</xsl:variable>
  <xsl:variable name="bwStr-HdBr-OtherLink">Other Link</xsl:variable>
  <xsl:variable name="bwStr-HdBr-ExampleCalendarHelp">Example Calendar Help</xsl:variable>
  <xsl:variable name="bwStr-HdBr-Print">print</xsl:variable>
  <xsl:variable name="bwStr-HdBr-PrintThisView">print this view</xsl:variable>
  <xsl:variable name="bwStr-HdBr-RSS">RSS</xsl:variable>
  <xsl:variable name="bwStr-HdBr-RSSFeed">RSS feed</xsl:variable>

  <!--  xsl:template name="sideBar" -->
  <xsl:variable name="bwStr-SdBr-Views">views</xsl:variable>
  <xsl:variable name="bwStr-SdBr-NoViews">no views</xsl:variable>
  <xsl:variable name="bwStr-SdBr-SubscribeToCalendarsOrICalFeeds">subscribe to calendars or iCal feeds</xsl:variable>
  <xsl:variable name="bwStr-SdBr-Subscribe">subscribe</xsl:variable>
  <xsl:variable name="bwStr-SdBr-ManageCalendarsAndSubscriptions">manage calendars and subscriptions</xsl:variable>
  <xsl:variable name="bwStr-SdBr-Manage">manage</xsl:variable>
  <xsl:variable name="bwStr-SdBr-Calendars">calendars</xsl:variable>
  <xsl:variable name="bwStr-SdBr-Options">options</xsl:variable>
  <xsl:variable name="bwStr-SdBr-Preferences">Preferences</xsl:variable>
  <xsl:variable name="bwStr-SdBr-UploadICal">Upload iCAL</xsl:variable>
  <xsl:variable name="bwStr-SdBr-AddrBook">Contacts</xsl:variable>
  <xsl:variable name="bwStr-SdBr-ExportCalendars">Export Calendars</xsl:variable>
  <xsl:variable name="bwStr-SdBr-UploadEvent">Upload Event</xsl:variable>

  <!--  xsl:template name="tabs" -->
  <xsl:variable name="bwStr-Tabs-LoggedInAs">logged in as</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Logout">logout</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Day">DAY</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Week">WEEK</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Month">MONTH</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Year">YEAR</xsl:variable>
  <xsl:variable name="bwStr-Tabs-List">LIST</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Agenda">AGENDA</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Upcoming">UPCOMING</xsl:variable>

  <!--  xsl:template name="navigation" -->
  <xsl:variable name="bwStr-Navi-WeekOf">Week of</xsl:variable>
  <xsl:variable name="bwStr-Navi-Go">go</xsl:variable>
  <xsl:variable name="bwStr-Navi-Today">today</xsl:variable>
  <xsl:variable name="bwStr-Navi-Timezone">Timezone:</xsl:variable>

  <!--  xsl:template name="utilBar" -->
  <xsl:variable name="bwStr-Util-EventsTitle">events</xsl:variable>
  <xsl:variable name="bwStr-Util-Add">add...</xsl:variable>
  <xsl:variable name="bwStr-Util-View">View</xsl:variable>
  <xsl:variable name="bwStr-Util-DefaultView">default view</xsl:variable>
  <xsl:variable name="bwStr-Util-AllTopicalAreas">all topical areas</xsl:variable>
  <xsl:variable name="bwStr-Util-Search">Search</xsl:variable>
  <xsl:variable name="bwStr-Util-Go">go</xsl:variable>
  <xsl:variable name="bwStr-Util-List">LIST</xsl:variable>
  <xsl:variable name="bwStr-Util-Cal">CAL</xsl:variable>
  <xsl:variable name="bwStr-Util-ToggleListCalView">toggle list/calendar view</xsl:variable>
  <xsl:variable name="bwStr-Util-Summary">SUMMARY</xsl:variable>
  <xsl:variable name="bwStr-Util-Details">DETAILS</xsl:variable>
  <xsl:variable name="bwStr-Util-ToggleSummDetView">toggle summary/detailed view</xsl:variable>
  <xsl:variable name="bwStr-Util-ShowEvents">Show Events</xsl:variable>
  <xsl:variable name="bwStr-Util-Events">EVENTS</xsl:variable>
  <xsl:variable name="bwStr-Util-ShowFreebusy">Show Free/Busy</xsl:variable>
  <xsl:variable name="bwStr-Util-Freebusy">FREE/BUSY</xsl:variable>

  <!--  xsl:template name="actionIcons" -->
  <xsl:variable name="bwStr-Actn-AddEvent">add event</xsl:variable>
  <xsl:variable name="bwStr-Actn-ScheduleMeeting">schedule meeting</xsl:variable>
  <xsl:variable name="bwStr-Actn-AddTask">add task</xsl:variable>
  <xsl:variable name="bwStr-Actn-ScheduleTask">schedule task</xsl:variable>
  <xsl:variable name="bwStr-Actn-Upload">upload</xsl:variable>
  <xsl:variable name="bwStr-Actn-UploadEvent">upload event</xsl:variable>

  <!--  xsl:template name="listView" -->
  <xsl:variable name="bwStr-LsVw-NoEventsToDisplay">No events to display.</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Add">add...</xsl:variable>
  <xsl:variable name="bwStr-LsVw-AllDay">all day</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Today">today</xsl:variable>
  <xsl:variable name="bwStr-LsVw-DownloadEvent">Download event as ical - for Outlook, PDAs, iCal, and other desktop calendars</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Description">description</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Canceled">CANCELED:</xsl:variable>
  <xsl:variable name="bwStr-LsVw-NoTitle">no title</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Contact">Contact:</xsl:variable>

  <!--  <xsl:template name="eventLinks" -->
  <xsl:variable name="bwStr-EvLn-EditMaster">edit master (recurring event)</xsl:variable>
  <xsl:variable name="bwStr-EvLn-All">all</xsl:variable>
  <xsl:variable name="bwStr-EvLn-Instance">instance</xsl:variable>
  <xsl:variable name="bwStr-EvLn-EditInstance">edit instance (recurring event)</xsl:variable>
  <xsl:variable name="bwStr-EvLn-Edit">Edit</xsl:variable>
  <xsl:variable name="bwStr-EvLn-EditEvent">edit event</xsl:variable>
  <xsl:variable name="bwStr-EvLn-EditColon">Edit:</xsl:variable>
  <xsl:variable name="bwStr-EvLn-Link">Link</xsl:variable>
  <xsl:variable name="bwStr-EvLn-DeleteColon">Delete:</xsl:variable>
  <xsl:variable name="bwStr-EvLn-DeleteMaster">delete master (recurring event)</xsl:variable>
  <xsl:variable name="bwStr-EvLn-DeleteThisEvent">Delete this event?</xsl:variable>
  <xsl:variable name="bwStr-EvLn-DeleteEvent">Ddelete event</xsl:variable>
  <xsl:variable name="bwStr-EvLn-DeleteAllRecurrences">Delete all recurrences of this event?</xsl:variable>
  <xsl:variable name="bwStr-EvLn-DeleteInstance">delete instance (recurring event)</xsl:variable>
  <xsl:variable name="bwStr-EvLn-Delete">Delete</xsl:variable>
  <xsl:variable name="bwStr-EvLn-AddEventReference">add event reference to a calendar</xsl:variable>


  <!-- xsl:template match="events" mode="eventList" -->
  <xsl:variable name="bwStr-LsEv-Upcoming">Upcoming Events</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Next7Days">Next 7 Days</xsl:variable>
  <xsl:variable name="bwStr-LsEv-NoEventsToDisplay">No events to Display</xsl:variable>
  <xsl:variable name="bwStr-LsEv-DownloadEvent">Download event as ical - for Outlook, PDAs, iCal, and other desktop calendars</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Categories">Categories:</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Contact">Contact:</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Canceled">CANCELED:</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Tentative">TENTATIVE:</xsl:variable>
  <xsl:variable name="bwStr-LsEv-GoToDay">go to day</xsl:variable>

  <!-- xsl:template name="weekView" -->

  <!-- xsl:template name="monthView" -->

  <!-- xsl:template match="event" mode="calendarLayout" -->
  <xsl:variable name="bwStr-EvCG-Canceled">CANCELED:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Tentative">TENTATIVE:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Cont">(cont)</xsl:variable>
  <xsl:variable name="bwStr-EvCG-AllDayColon">all day:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-NoTitle">no title</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Time">Time:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-AllDay">all day</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Location">Location:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-TopicalArea">Topical Area:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Calendar">Calendar:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Type">Type:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Task">task</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Meeting">meeting</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Event">event</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Recurring">recurring</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Personal">personal</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Public">public</xsl:variable>
  <xsl:variable name="bwStr-EvCG-ViewDetails">View details</xsl:variable>
  <xsl:variable name="bwStr-EvCG-DownloadEvent">Download event as ical - for Outlook, PDAs, iCal, and other desktop calendars</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Download">Download</xsl:variable>
  <xsl:variable name="bwStr-EvCG-DownloadMaster">download master (recurring event)</xsl:variable>
  <xsl:variable name="bwStr-EvCG-DownloadThisInstance">download this instance (recurring event)</xsl:variable>
  <xsl:variable name="bwStr-EvCG-All">all</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Instance">instance</xsl:variable>
  <xsl:variable name="bwStr-EvCG-EditColon">Edit:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-EditMaster">edit master (recurring event)</xsl:variable>
  <xsl:variable name="bwStr-EvCG-EditThisInstance">edit this instance (recurring event)</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Edit">Edit</xsl:variable>
  <xsl:variable name="bwStr-EvCG-EditEvent">edit event</xsl:variable>
  <xsl:variable name="bwStr-EvCG-CopyColon">Copy:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-CopyMaster">copy master (recurring event)</xsl:variable>
  <xsl:variable name="bwStr-EvCG-CopyThisInstance">copy this instance (recurring event)</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Copy">Copy</xsl:variable>
  <xsl:variable name="bwStr-EvCG-CopyEvent">copy event</xsl:variable>
  <xsl:variable name="bwStr-EvCG-LinkColon">Link:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Link">Link</xsl:variable>
  <xsl:variable name="bwStr-EvCG-DeleteColon">Delete:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-DeleteThisEvent">Delete this event?</xsl:variable>
  <xsl:variable name="bwStr-EvCG-DeleteAllRecurrences">Delete all recurrences of this event?</xsl:variable>
  <xsl:variable name="bwStr-EvCG-DeleteMaster">delete master (recurring event)</xsl:variable>
  <xsl:variable name="bwStr-EvCG-DeleteThisInstance">delete this instance (recurring event)</xsl:variable>
  <xsl:variable name="bwStr-EvCG-DeleteEvent">delete event</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Delete">Delete</xsl:variable>
  <xsl:variable name="bwStr-EvCG-AddMasterEventReference">add master event reference to a calendar</xsl:variable>
  <xsl:variable name="bwStr-EvCG-AddThisEventReference">add this event reference to a calendar</xsl:variable>
  <xsl:variable name="bwStr-EvCG-AddEventReference">add event reference to a calendar</xsl:variable>

  <!-- <xsl:template name="yearView" -->

  <!-- <xsl:template match="month" -->

  <!-- <xsl:template name="tasks" -->
  <xsl:variable name="bwStr-Task-Tasks">tasks</xsl:variable>
  <xsl:variable name="bwStr-Task-Reminders">reminders</xsl:variable>

  <!-- <xsl:template match="event" mode="tasks" -->
  <xsl:variable name="bwStr-TskE-NoTitle">no title</xsl:variable>
  <xsl:variable name="bwStr-TskE-Start">Start:</xsl:variable>
  <xsl:variable name="bwStr-TskE-Due">Due:</xsl:variable>

  <!-- <xsl:template match="event" mode="schedNotifications" -->

  <!-- <xsl:template match="event" -->
  <xsl:variable name="bwStr-SgEv-GenerateLinkToThisEvent">generate link to this event</xsl:variable>
  <xsl:variable name="bwStr-SgEv-LinkToThisEvent">link to this event</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Canceled">CANCELED:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Event">Event</xsl:variable>
  <xsl:variable name="bwStr-SgEv-NoTitle">no title</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Delete">Delete</xsl:variable>
  <xsl:variable name="bwStr-SgEv-DeleteThisEvent">Delete this event?</xsl:variable>
  <xsl:variable name="bwStr-SgEv-DeleteAllRecurrences">Delete all recurrences of this event?</xsl:variable>
  <xsl:variable name="bwStr-SgEv-DeleteMaster">delete master (recurring event)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-DeleteThisInstance">delete this instance (recurring event)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-DeleteEvent">delete event</xsl:variable>
  <xsl:variable name="bwStr-SgEv-All">all</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Instance">instance</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Link">Link</xsl:variable>
  <xsl:variable name="bwStr-SgEv-AddMasterEvent">add master event reference to a calendar</xsl:variable>
  <xsl:variable name="bwStr-SgEv-AddThisEvent">add this event reference to a calendar</xsl:variable>
  <xsl:variable name="bwStr-SgEv-AddEventReference">add event reference to a calendar</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Copy">Copy</xsl:variable>
  <xsl:variable name="bwStr-SgEv-CopyMaster">copy master (recurring event)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-CopyThisInstance">copy this instance (recurring event)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-CopyEvent">copy event</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Edit">Edit</xsl:variable>
  <xsl:variable name="bwStr-SgEv-EditMaster">edit master (recurring event)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-EditThisInstance">edit this instance (recurring event)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-EditEvent">edit event</xsl:variable>
  <xsl:variable name="bwStr-SgEv-DownloadEvent">Download event as ical - for Outlook, PDAs, iCal, and other desktop calendars</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Download">Download</xsl:variable>
  <xsl:variable name="bwStr-SgEv-DownloadMaster">download master (recurring event)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-DownloadThisInstance">download this instance (recurring event)</xsl:variable>

  <xsl:variable name="bwStr-SgEv-Task">Task</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Meeting">Meeting</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Event">Event</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Recurring">Recurring</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Public">Public</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Personal">Personal</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Organizer">organizer:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-RecurrenceMaster">recurrence master</xsl:variable>
  <xsl:variable name="bwStr-SgEv-When">When:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-AllDay">(all day)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-FloatingTime">Floating time</xsl:variable>
  <xsl:variable name="bwStr-SgEv-LocalTime">Local time</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Start">Start:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-End">End:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-AddToMyCalendar">add to my calendar</xsl:variable>
  <xsl:variable name="bwStr-SgEv-AddEventToMyCalendar">Add event to MyCalendar</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Where">Where:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Complete">% Complete:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-ORGANIZER">Organizer:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Description">Description:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-STATUS">Status:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Attendees">Attendees:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Attendee">Attendee</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Role">role</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Status">status</xsl:variable>
  <xsl:variable name="bwStr-SgEv-ChangeMyStatus">change my status</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Cost">Cost:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-See">See:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Contact">Contact:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Calendar">Calendar:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Categories">Categories:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Comments">Comments:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-TopicalArea">Topical Area:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Email">email</xsl:variable>

  <!-- <xsl:template match="formElements" mode="addEvent" -->
  <xsl:variable name="bwStr-AddE-AddTask">Add Task</xsl:variable>
  <xsl:variable name="bwStr-AddE-AddEvent">Add Event</xsl:variable>
  <xsl:variable name="bwStr-AddE-AddMeeting">Add Meeting</xsl:variable>

  <!--  <xsl:template match="formElements" mode="editEvent" -->
  <xsl:variable name="bwStr-EdtE-EditTask">Edit task</xsl:variable>
  <xsl:variable name="bwStr-EdtE-EditEvent">Edit Event</xsl:variable>
  <xsl:variable name="bwStr-EdtE-EditMeeting">Edit Meeting</xsl:variable>

  <!--  <xsl:template match="formElements" mode="eventForm" -->
  <xsl:variable name="bwStr-AEEF-Delete">Delete</xsl:variable>
  <xsl:variable name="bwStr-AEEF-DeleteMaster">delete master (recurring event)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-DeleteThisEvent">Delete this event?</xsl:variable>
  <xsl:variable name="bwStr-AEEF-DeleteAllRecurrences">Delete all recurrences of this event?</xsl:variable>
  <xsl:variable name="bwStr-AEEF-DeleteThisInstance">delete this instance (recurring event)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-DeleteEvent">delete event</xsl:variable>
  <xsl:variable name="bwStr-AEEF-All">All</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Instance">Instance</xsl:variable>
  <xsl:variable name="bwStr-AEEF-View">View</xsl:variable>
  <xsl:variable name="bwStr-AEEF-TASK">Task</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Meeting">Meeting</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EVENT">Event</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Recurring">Recurring</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Personal">Personal</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Public">Public</xsl:variable>
  <xsl:variable name="bwStr-AEEF-RecurrenceMaster">recurrence master</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Basic">basic</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Details">details</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Recurrence">recurrence</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Scheduling">scheduling</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Meetingtab">meeting</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Calendar">Calendar:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Title">Title:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-DateAndTime">Date &amp; Time:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-AllDay">all day</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Floating">floating</xsl:variable>
  <xsl:variable name="bwStr-AEEF-StoreAsUTC">store in UTC</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Start">Start:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Date">Date</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Due">Due:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-End">End:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Duration">Duration</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Duration-Sched">Duration:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Days">days</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Hours">hours</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Minutes">minutes</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Or">or</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Weeks">weeks</xsl:variable>
  <xsl:variable name="bwStr-AEEF-This">This</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Task">task</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Event">event</xsl:variable>
  <xsl:variable name="bwStr-AEEF-HasNoDurationEndDate">has no duration / end date</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Complete">% Complete:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-AffectsFreeBusy">Affects free/busy:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Yes">yes</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Transparent">(transparent: event status does not affect your free/busy)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-No">no</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Opaque">(opaque: event status affects your free/busy)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Categories">Categories:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-NoCategoriesDefined">no categories defined</xsl:variable>
  <xsl:variable name="bwStr-AEEF-AddCategory">add category</xsl:variable>
  <xsl:variable name="bwStr-AEEF-SelectTimezone">select timezone...</xsl:variable>
  <xsl:variable name="bwStr-AEEF-PickPrevious">&#171; Pick Previous</xsl:variable>
  <xsl:variable name="bwStr-AEEF-PickNext">Pick Next &#187;</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Options">Options &#x25BC;</xsl:variable>
  <xsl:variable name="bwStr-AEEF-24Hours">24 Hours</xsl:variable>
  <xsl:variable name="bwStr-AEEF-FromTheEnd">from the end</xsl:variable>

  <!-- Details tab (3153)-->
  <xsl:variable name="bwStr-AEEF-Location">Location:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Choose">choose:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Select">select...</xsl:variable>
  <xsl:variable name="bwStr-AEEF-OrAddNew">or add new:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EventLink">Event Link:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Description">Description:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Status">Status:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Confirmed">confirmed</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Tentative">tentative</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Canceled">canceled</xsl:variable>

  <!-- Recurrence tab (3292)-->
  <xsl:variable name="bwStr-AEEF-ThisEventRecurrenceInstance">This event is a recurrence instance.</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EditMasterEvent">edit master event</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EditMaster">edit master (recurring event)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EventRecurs">event recurs</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EventDoesNotRecur">event does not recur</xsl:variable>

  <!-- wrapper for all recurrence fields (rrules and rdates): -->
  <xsl:variable name="bwStr-AEEF-RecurrenceRules">Recurrence Rules</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ChangeRecurrenceRules">change recurrence rules</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ShowAdvancedRecurrenceRules">show advanced recurrence rules</xsl:variable>
  <xsl:variable name="bwStr-AEEF-And">and</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EVERY">Every</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Every">every</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Day">day(s)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Hour">hour(s)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Month">month(s)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Week">week(s)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Year">year(s)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-On">on</xsl:variable>
  <xsl:variable name="bwStr-AEEF-In">in</xsl:variable>
  <xsl:variable name="bwStr-AEEF-OnThe">on the</xsl:variable>
  <xsl:variable name="bwStr-AEEF-InThe">in the</xsl:variable>
  <xsl:variable name="bwStr-AEEF-TheFirst">the first</xsl:variable>
  <xsl:variable name="bwStr-AEEF-TheSecond">the second</xsl:variable>
  <xsl:variable name="bwStr-AEEF-TheThird">the third</xsl:variable>
  <xsl:variable name="bwStr-AEEF-TheFourth">the fourth</xsl:variable>
  <xsl:variable name="bwStr-AEEF-TheFifth">the fifth</xsl:variable>
  <xsl:variable name="bwStr-AEEF-TheLast">the last</xsl:variable>
  <xsl:variable name="bwStr-AEEF-DayOfTheMonth">day(s) of the month</xsl:variable>
  <xsl:variable name="bwStr-AEEF-DayOfTheYear">day(s) of the year</xsl:variable>
  <xsl:variable name="bwStr-AEEF-WeekOfTheYear">week(s) of the year</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Repeating">repeating</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Forever">forever</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Until">until</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Time">time(s)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Frequency">Frequency:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-None">none</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Daily">daily</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Weekly">weekly</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Monthly">monthly</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Yearly">yearly</xsl:variable>
  <xsl:variable name="bwStr-AEEF-NoRecurrenceRules">no recurrence rules</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Repeat">Repeat:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Interval">Interval:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-InTheseMonths">in these months:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-WeekOn">week(s) on</xsl:variable>
  <xsl:variable name="bwStr-AEEF-SelectWeekdays">select weekdays</xsl:variable>
  <xsl:variable name="bwStr-AEEF-SelectWeekends">select weekends</xsl:variable>
  <xsl:variable name="bwStr-AEEF-WeekStart">Week start:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-OnTheseDays">on these days:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-OnTheseDaysOfTheMonth">on these days of the month:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-InTheseWeeksOfTheYear">in these weeks of the year:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-OnTheseDaysOfTheYear">on these days of the year:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-RecurrenceAndExceptionDates">Recurrence and Exception Dates</xsl:variable>
  <xsl:variable name="bwStr-AEEF-RecurrenceDates">Recurrence Dates</xsl:variable>
  <xsl:variable name="bwStr-AEEF-NoRecurrenceDates">No recurrence dates</xsl:variable>
  <xsl:variable name="bwStr-AEEF-TIME">Time</xsl:variable>
  <xsl:variable name="bwStr-AEEF-TZid">TZid</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ExceptionDates">Exception Dates</xsl:variable>
  <xsl:variable name="bwStr-AEEF-NoExceptionDates">No exception dates</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ExceptionDatesMayBeCreated">Exception dates may be created by deleting an instance of a recurring event.</xsl:variable>
  <xsl:variable name="bwStr-AEEF-AddRecurance">add recurrence</xsl:variable>
  <xsl:variable name="bwStr-AEEF-AddException">add exception</xsl:variable>

  <!-- Access tab -->

  <!-- Scheduling tab -->
  <xsl:variable name="bwStr-AEEF-EditAttendees">edit attendees</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ChangeMyStatus">change my status</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ScheduleThisTask">schedule this task with other users</xsl:variable>
  <xsl:variable name="bwStr-AEEF-MakeIntoMeeting">make into meeting - invite attendees</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Save">save</xsl:variable>
  <xsl:variable name="bwStr-AEEF-SaveDraft">save draft</xsl:variable>
  <xsl:variable name="bwStr-AEEF-SaveAndSendInvites">send</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Clear">clear message from Inbox</xsl:variable>

  <!-- xsl:template match="val" mode="weekMonthYearNumbers" -->

  <!-- xsl:template name="byDayChkBoxList" -->

  <!-- xsl:template name="buildCheckboxList" -->

  <!-- xsl:template name="recurrenceDayPosOptions" -->
  <xsl:variable name="bwStr-RCPO-TheFirst">the first</xsl:variable>
  <xsl:variable name="bwStr-RCPO-TheSecond">the second</xsl:variable>
  <xsl:variable name="bwStr-RCPO-TheThird">the third</xsl:variable>
  <xsl:variable name="bwStr-RCPO-TheFourth">the fourth</xsl:variable>
  <xsl:variable name="bwStr-RCPO-TheFifth">the fifth</xsl:variable>
  <xsl:variable name="bwStr-RCPO-TheLast">the last</xsl:variable>
  <xsl:variable name="bwStr-RCPO-Every">every</xsl:variable>
  <xsl:variable name="bwStr-RCPO-None">none</xsl:variable>

  <!-- xsl:template name="buildRecurFields" -->
  <xsl:variable name="bwStr-BuRF-And">and</xsl:variable>

  <!-- xsl:template name="buildNumberOptions" -->

  <!-- xsl:template name="clock" -->
  <xsl:variable name="bwStr-Cloc-Bedework24HourClock">Bedework 24-Hour Clock</xsl:variable>
  <xsl:variable name="bwStr-Cloc-Type">type</xsl:variable>
  <xsl:variable name="bwStr-Cloc-SelectTime">select time</xsl:variable>
  <xsl:variable name="bwStr-Cloc-Switch">switch</xsl:variable>
  <xsl:variable name="bwStr-Cloc-Close">close</xsl:variable>
  <xsl:variable name="bwStr-Cloc-CloseClock">close clock</xsl:variable>

  <!-- xsl:template name="newclock" -->
  <xsl:variable name="bwStr-Cloc-Hour">Hour</xsl:variable>
  <xsl:variable name="bwStr-Cloc-Minute">Minute</xsl:variable>
  <xsl:variable name="bwStr-Cloc-AM">am</xsl:variable>
  <xsl:variable name="bwStr-Cloc-PM">pm</xsl:variable>

  <!-- xsl:template name="attendees" -->
  <xsl:variable name="bwStr-Atnd-Continue">continue</xsl:variable>
  <xsl:variable name="bwStr-Atnd-SchedulMeetingOrTask">Schedule Meeting or Task</xsl:variable>
  <xsl:variable name="bwStr-Atnd-AddAttendees">Add attendees</xsl:variable>
  <xsl:variable name="bwStr-Atnd-Add">add</xsl:variable>
  <xsl:variable name="bwStr-Atnd-Recipients">Recipients</xsl:variable>
  <xsl:variable name="bwStr-Atnd-Attendee">attendee</xsl:variable>
  <xsl:variable name="bwStr-Atnd-Attendees">Attendees</xsl:variable>
  <xsl:variable name="bwStr-Atnd-RoleColon">role:</xsl:variable>
  <xsl:variable name="bwStr-Atnd-Role">role</xsl:variable>
  <xsl:variable name="bwStr-Atnd-StatusColon">status:</xsl:variable>
  <xsl:variable name="bwStr-Atnd-Status">status</xsl:variable>
  <xsl:variable name="bwStr-Atnd-RequiredParticipant">required participant</xsl:variable>
  <xsl:variable name="bwStr-Atnd-OptionalParticipant">optional participant</xsl:variable>
  <xsl:variable name="bwStr-Atnd-Chair">chair</xsl:variable>
  <xsl:variable name="bwStr-Atnd-NonParticipant">non-participant</xsl:variable>
  <xsl:variable name="bwStr-Atnd-NeedsAction">needs action</xsl:variable>
  <xsl:variable name="bwStr-Atnd-Accepted">accepted</xsl:variable>
  <xsl:variable name="bwStr-Atnd-Declined">declined</xsl:variable>
  <xsl:variable name="bwStr-Atnd-Tentative">tentative</xsl:variable>
  <xsl:variable name="bwStr-Atnd-Delegated">delegated</xsl:variable>
  <xsl:variable name="bwStr-Atnd-Remove">remove</xsl:variable>

  <!-- xsl:template match="partstat" -->
  <xsl:variable name="bwStr-ptst-NeedsAction">needs action</xsl:variable>
  <xsl:variable name="bwStr-ptst-Accepted">accepted</xsl:variable>
  <xsl:variable name="bwStr-ptst-Declined">declined</xsl:variable>
  <xsl:variable name="bwStr-ptst-Tentative">tentative</xsl:variable>
  <xsl:variable name="bwStr-ptst-Delegated">delegated</xsl:variable>

  <!-- xsl:template match="freebusy" mode="freeBusyGrid"  -->
  <xsl:variable name="bwStr-FrBu-FreebusyFor">Freebusy for</xsl:variable>
  <xsl:variable name="bwStr-FrBu-AllAttendees">all attendees</xsl:variable>
  <xsl:variable name="bwStr-FrBu-AM">AM</xsl:variable>
  <xsl:variable name="bwStr-FrBu-PM">PM</xsl:variable>
  <xsl:variable name="bwStr-FrBu-Busy">busy</xsl:variable>
  <xsl:variable name="bwStr-FrBu-Tentative">tentative</xsl:variable>
  <xsl:variable name="bwStr-FrBu-Free">free</xsl:variable>
  <xsl:variable name="bwStr-FrBu-AllFree">all free</xsl:variable>

  <!-- xsl:template match="attendees" -->
  <!-- Stings defined above -->

  <!-- xsl:template match="recipients"-->
  <xsl:variable name="bwStr-Rcpt-Recipient">recipient</xsl:variable>
  <xsl:variable name="bwStr-Rcpt-Recipients">Recipients</xsl:variable>
  <xsl:variable name="bwStr-Rcpt-Remove">remove</xsl:variable>

  <!-- xsl:template match="event" mode="addEventRef" -->
  <!-- some strings defined above -->
  <xsl:variable name="bwStr-AEEF-AddEventReference">Add Event Reference</xsl:variable>
  <xsl:variable name="bwStr-AEEF-AddEventSubscription">Add Event Subscription</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EventColon">Event:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-NoTitle">no title</xsl:variable>
  <xsl:variable name="bwStr-AEEF-IntoCalendar">Into calendar:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-DefaultCalendar">default calendar</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Cancel">cancel</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Continue">continue</xsl:variable>

  <!-- xsl:template match="freebusy" mode="freeBusyPage" -->
  <xsl:variable name="bwStr-FrBu-YouMayShareYourFreeBusy">You may share your free busy with a user or group by setting access to "read freebusy" on calendars you wish to share. To share all your free busy, grant "read freebusy" access on your root folder.</xsl:variable>
  <xsl:variable name="bwStr-FrBu-FreeBusy">Free / Busy</xsl:variable>
  <xsl:variable name="bwStr-FrBu-ViewUsersFreeBusy">View user's free/busy:</xsl:variable>

  <!-- xsl:template name="categoryList" -->
  <xsl:variable name="bwStr-Ctgy-ManagePreferences">Manage Preferences</xsl:variable>
  <xsl:variable name="bwStr-Ctgy-General">general</xsl:variable>
  <xsl:variable name="bwStr-Ctgy-Categories">categories</xsl:variable>
  <xsl:variable name="bwStr-Ctgy-Locations">locations</xsl:variable>
  <xsl:variable name="bwStr-Ctgy-SchedulingMeetings">scheduling/meetings</xsl:variable>
  <xsl:variable name="bwStr-Ctgy-ManageCategories">Manage Categories</xsl:variable>
  <xsl:variable name="bwStr-Ctgy-Type">Add new category</xsl:variable>
  <xsl:variable name="bwStr-Ctgy-NoCategoriesDefined">No categories defined</xsl:variable>

  <!-- xsl:template name="modCategory" -->
  <xsl:variable name="bwStr-MCat-ManagePreferences">Manage Preferences</xsl:variable>
  <xsl:variable name="bwStr-MCat-General">general</xsl:variable>
  <xsl:variable name="bwStr-MCat-Categories">categories</xsl:variable>
  <xsl:variable name="bwStr-MCat-Locations">locations</xsl:variable>
  <xsl:variable name="bwStr-MCat-SchedulingMeetings">scheduling/meetings</xsl:variable>
  <xsl:variable name="bwStr-MCat-AddCategory">Add Category</xsl:variable>
  <xsl:variable name="bwStr-MCat-EditCategory">Edit Category</xsl:variable>
  <xsl:variable name="bwStr-MCat-UpdateCategory">Update Category</xsl:variable>
  <xsl:variable name="bwStr-MCat-DeleteCategory">Delete Category</xsl:variable>
  <xsl:variable name="bwStr-MCat-Keyword">Keyword:</xsl:variable>
  <xsl:variable name="bwStr-MCat-Description">Description:</xsl:variable>
  <xsl:variable name="bwStr-MCat-Cancel">cancel</xsl:variable>

  <!--  xsl:template name="deleteCategoryConfirm" -->
  <xsl:variable name="bwStr-DlCC-OKtoDeleteCategory">Ok to delete this category?</xsl:variable>
  <xsl:variable name="bwStr-DlCC-DeleteCategory">Delete Category</xsl:variable>
  <xsl:variable name="bwStr-DlCC-Keyword">Keyword:</xsl:variable>
  <xsl:variable name="bwStr-DlCC-Description">Description:</xsl:variable>
  <xsl:variable name="bwStr-DlCC-YesDeleteCategory">Yes: Delete Category</xsl:variable>
  <xsl:variable name="bwStr-DlCC-NoCancel">No: Cancel</xsl:variable>

  <!--  xsl:template match="calendars" mode="manageCalendars" -->
  <xsl:variable name="bwStr-Cals-ManageCalendarsSubscriptions">Manage Calendars &amp; Subscriptions</xsl:variable>
  <xsl:variable name="bwStr-Cals-Calendars">Calendars</xsl:variable>

  <!--  xsl:template match="calendar" mode="myCalendars"  -->

  <!--  xsl:template match="calendar" mode="mySpecialCalendars" -->
  <xsl:variable name="bwStr-Cals-IncomingSchedulingRequests">incoming scheduling requests</xsl:variable>
  <xsl:variable name="bwStr-Cals-OutgoingSchedulingRequests">outgoing scheduling requests</xsl:variable>

  <!--  xsl:template match="calendar" mode="listForUpdate"  -->
  <xsl:variable name="bwStr-Cals-Update">update</xsl:variable>
  <xsl:variable name="bwStr-Cals-AddCalendarOrFolder">add a calendar or folder</xsl:variable>

  <!--  xsl:template match="calendar" mode="listForDisplay"  -->
  <xsl:variable name="bwStr-Cals-Display">display</xsl:variable>

  <!--  xsl:template name="selectCalForEvent" -->
  <xsl:variable name="bwStr-SCfE-SelectACalendar">select a calendar</xsl:variable>
  <xsl:variable name="bwStr-SCfE-NoWritableCals">no writable calendars</xsl:variable>
  <xsl:variable name="bwStr-SCfE-Close">close</xsl:variable>

  <!--  xsl:template match="calendar" mode="selectCalForEventCalTree" -->

  <!--  xsl:template name="selectCalForPublicAlias" -->
  <xsl:variable name="bwStr-SCPA-SelectACalendar">select a calendar</xsl:variable>
  <xsl:variable name="bwStr-SCPA-Close">close</xsl:variable>

  <!--  xsl:template match="calendar" mode="selectCalForPublicAliasCalTree" -->

  <!--  xsl:template match="currentCalendar" mode="addCalendar" -->
  <xsl:variable name="bwStr-CuCa-AddCalOrFolder">Add Calendar or Folder</xsl:variable>
  <xsl:variable name="bwStr-CuCa-AddSubscription">Add Subscription</xsl:variable>
  <xsl:variable name="bwStr-CuCa-AddCalFolderOrSubscription">Add Calendar, Folder, or Subscription</xsl:variable>
  <xsl:variable name="bwStr-CuCa-AddCalText">add</xsl:variable>
  <xsl:variable name="bwStr-CuCa-AddCalTextLabel">Add:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-AddSubText">Add subscription</xsl:variable>
  <xsl:variable name="bwStr-CuCa-HttpStatus">HTTP Status:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Name">System Name:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Summary">Display Name:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Description">Description:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Color">Color:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Display">Display:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-DisplayItemsInThisCollection">display items in this collection</xsl:variable>
  <xsl:variable name="bwStr-CuCa-FilterExpression">Filter Expression:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Type">Type:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Calendar">Calendar</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Folder">Folder</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Subscription">Subscription</xsl:variable>
  <xsl:variable name="bwStr-CuCa-SubscriptionType">Subscription Type:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-PublicCalendar">Public calendar</xsl:variable>
  <xsl:variable name="bwStr-CuCa-UserCalendar">User calendar</xsl:variable>
  <xsl:variable name="bwStr-CuCa-URL">URL</xsl:variable>
  <xsl:variable name="bwStr-CuCa-SelectAPublicCalOrFolder">Select a public calendar or folder</xsl:variable>
  <xsl:variable name="bwStr-CuCa-UsersID">User's ID:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-CalendarPath">Calendar Path:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-DefaultCalendarOrSomeCalendar">E.g. "calendar" (default) or "someFolder/someCalendar"</xsl:variable>
  <xsl:variable name="bwStr-CuCa-URLToCalendar">URL to calendar:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-ID">ID (if required):</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Password">Password (if required):</xsl:variable>
  <xsl:variable name="bwStr-CuCa-SharingMayBeAdded">Note: Sharing may be added to a calendar once created.</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Add">Add</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Cancel">cancel</xsl:variable>

  <!--  xsl:template match="currentCalendar" mode="modCalendar -->
  <xsl:variable name="bwStr-CuCa-ModifySubscription">Modify Subscription</xsl:variable>
  <xsl:variable name="bwStr-CuCa-ModifyFolder">Modify Folder</xsl:variable>
  <xsl:variable name="bwStr-CuCa-ModifyCalendar">Modify Calendar</xsl:variable>
  <xsl:variable name="bwStr-CuCa-UpdateSubscription">Update Subscription</xsl:variable>
  <xsl:variable name="bwStr-CuCa-UpdateFolder">Update Folder</xsl:variable>
  <xsl:variable name="bwStr-CuCa-UpdateCalendar">Update Calendar</xsl:variable>
  <xsl:variable name="bwStr-CuCa-DeleteSubscription">Delete Subscription</xsl:variable>
  <xsl:variable name="bwStr-CuCa-DeleteFolder">Delete Folder</xsl:variable>
  <xsl:variable name="bwStr-CuCa-DeleteCalendar">Delete Calendar</xsl:variable>
  <xsl:variable name="bwStr-CuCa-AdvancedOptions">advanced options</xsl:variable>
  <xsl:variable name="bwStr-CuCa-BasicOptions">basic options</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Cancel">cancel</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Disabled">Disabled:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-DisabledLabel">disabled</xsl:variable>
  <xsl:variable name="bwStr-CuCa-EnabledLabel">enabled</xsl:variable>
  <xsl:variable name="bwStr-CuCa-ThisItemIsInaccessible">This item is inaccessible and has been disabled.  You may re-enable it to try again.</xsl:variable>
  <xsl:variable name="bwStr-CuCa-FilterExpression">Filter Expression:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Sharing">Calendar Sharing</xsl:variable>
  <xsl:variable name="bwStr-CuCa-ShareWith">Share calendar with:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-SharePlaceholder">enter a user account</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Share">share</xsl:variable>
  <xsl:variable name="bwStr-CuCa-SuggestedName">Suggested name:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-SharedBy">Shared by</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Status">Status</xsl:variable>
  <xsl:variable name="bwStr-CuCa-WriteAccess">Write access</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Remove">Remove</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Pending">pending</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Declined">declined</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Accepted">accepted</xsl:variable>
  <xsl:variable name="bwStr-CuCa-DefaultSchedNotShared">This calendar is the default scheduling calendar; it may not be shared.</xsl:variable>
  <xsl:variable name="bwStr-CuCa-CurrentAccess">Current Access:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-AccessNote"><p><strong>Note:</strong> Advanced access controls can break standard sharing.  Use this feature with care.</p><p>If you grant write access to another user, and you wish to see events added by that user in your calendar, <strong>you must explicitly grant yourself access to the same calendar.</strong>  Enter your UserID as a user in the "Who" box with "All" set in the "Rights" box. This is standard access control; the reason you will not see the other user's events without doing this is that the default access is grant:all to "owner" - and you don't own the other user's events.</p></xsl:variable>
  <xsl:variable name="bwStr-CuCa-WriteAccess">grant write access</xsl:variable>

  <!-- notifications.xsl -->
  <xsl:variable name="bwStr-Notif-SharingInvitation">Sharing Invitation</xsl:variable>
  <xsl:variable name="bwStr-Notif-SharingReply">Sharing Reply</xsl:variable>
  <xsl:variable name="bwStr-Notif-SharingRemoval">Sharing Removal</xsl:variable>
  <xsl:variable name="bwStr-Notif-NotificationFrom">Notification from</xsl:variable>
  <xsl:variable name="bwStr-Notif-InviteFrom">Invitation from</xsl:variable>
  <xsl:variable name="bwStr-Notif-ReplyFrom">Reply from</xsl:variable>
  <xsl:variable name="bwStr-Notif-TheUser">The user</xsl:variable>
  <xsl:variable name="bwStr-Notif-HasInvited">has invited you to share the calendar</xsl:variable>
  <xsl:variable name="bwStr-Notif-HasRemoved">has removed sharing to the calendar</xsl:variable>
  <xsl:variable name="bwStr-Notif-Reject">reject</xsl:variable>
  <xsl:variable name="bwStr-Notif-Accept">accept</xsl:variable>
  <xsl:variable name="bwStr-Notif-CalendarName">Calendar Name:</xsl:variable>
  <xsl:variable name="bwStr-Notif-HasAccepted">has <strong>accepted</strong> your invitation to share</xsl:variable>
  <xsl:variable name="bwStr-Notif-HasDeclined">has <strong>declined</strong> your invitation to share</xsl:variable>
  <xsl:variable name="bwStr-Notif-Clear">clear</xsl:variable>

  <!--  xsl:template name="colorPicker"  -->
  <xsl:variable name="bwStr-CoPi-Pick">pick</xsl:variable>
  <xsl:variable name="bwStr-CoPi-UseDefaultColors">use default colors</xsl:variable>
  <xsl:variable name="bwStr-CoPi-SelectColor">Select a color</xsl:variable>

<!--  xsl:template name="calendarList"  -->
  <xsl:variable name="bwStr-CaLi-ManagingCalendars">Managing Calendars &amp; Subscriptions</xsl:variable>
  <xsl:variable name="bwStr-CaLi-SelectFromCalendar">Select an item from the calendar tree on the left to modify a calendar</xsl:variable>
  <xsl:variable name="bwStr-CaLi-Subscription">subscription</xsl:variable>
  <xsl:variable name="bwStr-CaLi-OrFolder">, or folder</xsl:variable>
  <xsl:variable name="bwStr-CaLi-Select">Select the</xsl:variable>
  <xsl:variable name="bwStr-CaLi-Icon">icon to add a new calendar, subscription, or folder to the tree.</xsl:variable>
  <xsl:variable name="bwStr-CaLi-Folders">Folders may only contain calendars and subfolders.</xsl:variable>
  <xsl:variable name="bwStr-CaLi-Calendars">Calendars may only contain events (and other calendar items).</xsl:variable>

  <!--  xsl:template name="calendarDescriptions"  -->
  <xsl:variable name="bwStr-CaDe-CalInfo">Calendar Information</xsl:variable>
  <xsl:variable name="bwStr-CaDe-SelectAnItem">Select an item from the calendar tree on the left to view all information about that calendar or folder.  The tree on the left represents the calendar heirarchy.</xsl:variable>
  <xsl:variable name="bwStr-CaDe-AllCalDescriptions">All Calendar Descriptions:</xsl:variable>
  <xsl:variable name="bwStr-CaDe-Name">Name</xsl:variable>
  <xsl:variable name="bwStr-CaDe-Description">Description</xsl:variable>

  <!--  xsl:template match="currentCalendar" mode="displayCalendar"  -->
  <xsl:variable name="bwStr-CuCa-CalendarInformation">Calendar Information</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Path">Path:</xsl:variable>
  <!-- The rest found above -->

  <!--  xsl:template match="currentCalendar" mode="deleteCalendarConfirm"  -->
  <xsl:variable name="bwStr-CuCa-YesDeleteFolder">Yes: Delete Folder!</xsl:variable>
  <xsl:variable name="bwStr-CuCa-YesDeleteCalendar">Yes: Delete Calendar!</xsl:variable>
  <xsl:variable name="bwStr-CuCa-TheFollowingFolder">The following folder <em>and all its contents</em> will be deleted.  Continue?</xsl:variable>
  <xsl:variable name="bwStr-CuCa-TheFollowingCalendar">The following calendar <em>and all its contents</em> will be deleted.  Continue?</xsl:variable>
  <!-- The rest found above -->

  <!--  xsl:template match="calendars" mode="exportCalendars" -->
  <xsl:variable name="bwStr-Cals-ExportCals">Export Calendars as iCal</xsl:variable>
  <xsl:variable name="bwStr-Cals-CalendarToExport">Calendar to export:</xsl:variable>
  <xsl:variable name="bwStr-Cals-Name">Name:</xsl:variable>
  <xsl:variable name="bwStr-Cals-Path">Path:</xsl:variable>
  <xsl:variable name="bwStr-Cals-EventDateLimits">Event date limits:</xsl:variable>
  <xsl:variable name="bwStr-Cals-TodayForward">today forward</xsl:variable>
  <xsl:variable name="bwStr-Cals-AllDates">all dates</xsl:variable>
  <xsl:variable name="bwStr-Cals-DateRange">date range</xsl:variable>
  <xsl:variable name="bwStr-Cals-Start"><strong>Start:</strong></xsl:variable>
  <xsl:variable name="bwStr-Cals-End"><strong>End:</strong></xsl:variable>
  <xsl:variable name="bwStr-Cals-MyCalendars">My Calendars</xsl:variable>

  <!--  xsl:template match="calendar" mode="buildExportTree"  -->

  <!--  xsl:template name="subsMenu"  -->
  <xsl:variable name="bwStr-SuMe-AddSubs">Add Subscriptions</xsl:variable>
  <xsl:variable name="bwStr-SuMe-SubscribeTo">Subscribe to:</xsl:variable>
  <xsl:variable name="bwStr-SuMe-PublicCal">a public calendar (in this system)</xsl:variable>
  <xsl:variable name="bwStr-SuMe-UserCal">a user calendar (in this system)</xsl:variable>
  <xsl:variable name="bwStr-SuMe-ExternalFeed">an external iCal feed (e.g. Google, Eventful, etc)</xsl:variable>
  <xsl:variable name="bwStr-SuMe-SubscribeToPublicCalendar">subscribe to a public calendar</xsl:variable>
  <xsl:variable name="bwStr-SuMe-SubscribeToUserCalendar">subscribe to a user calendar</xsl:variable>
  <xsl:variable name="bwStr-SuMe-SubscribeToExternalCalendar">subscribe to an external calendar</xsl:variable>

  <!--  xsl:template name="addPublicAlias"  -->
  <xsl:variable name="bwStr-AdPA-SubscribeToPublicCal">Subscribe to a Public Calendar</xsl:variable>
  <xsl:variable name="bwStr-AdPA-AddPublicSubscription">Add a public subscription</xsl:variable>
  <xsl:variable name="bwStr-AdPA-SubscriptionNote">*the subscription name must be unique</xsl:variable>
  <xsl:variable name="bwStr-AdPA-Calendar">Calendar:</xsl:variable>
  <xsl:variable name="bwStr-AdPA-Name">Name:</xsl:variable>
  <xsl:variable name="bwStr-AdPA-AffectsFreeBusy">Affects Free/Busy:</xsl:variable>
  <xsl:variable name="bwStr-AdPA-Yes">yes</xsl:variable>
  <xsl:variable name="bwStr-AdPA-No">no</xsl:variable>
  <xsl:variable name="bwStr-AdPA-Style">Style:</xsl:variable>
  <xsl:variable name="bwStr-AdPA-Default">default</xsl:variable>
  <xsl:variable name="bwStr-AdPA-AddSubscription">Add Subscription</xsl:variable>
  <xsl:variable name="bwStr-AdPA-Cancel">cancel</xsl:variable>

  <!--  xsl:template match="calendar" mode="subscribe" -->
  <xsl:variable name="bwStr-Calr-Folder">folder</xsl:variable>
  <xsl:variable name="bwStr-Calr-Calendar">calendar</xsl:variable>

  <!--  xsl:template name="addAlias" -->
  <xsl:variable name="bwStr-AddA-SubscribeToUserCal">Subscribe to a User Calendar</xsl:variable>
  <xsl:variable name="bwStr-AddA-SubscriptionMustBeUnique">*the subsciption name must be unique</xsl:variable>
  <xsl:variable name="bwStr-AddA-Name">Name:</xsl:variable>
  <xsl:variable name="bwStr-AddA-UserID">User ID:</xsl:variable>
  <xsl:variable name="bwStr-AddA-ExJaneDoe">ex: janedoe</xsl:variable>
  <xsl:variable name="bwStr-AddA-CalendarPath">Calendar path:</xsl:variable>
  <xsl:variable name="bwStr-AddA-ExCalendar">ex: calendar</xsl:variable>
  <xsl:variable name="bwStr-AddA-AddSubscription">Add Subscription</xsl:variable>
  <xsl:variable name="bwStr-AddA-Cancel">cancel</xsl:variable>
  <xsl:variable name="bwStr-AddA-AffectsFreeBusy">Affects Free/Busy:</xsl:variable>
  <xsl:variable name="bwStr-AddA-Yes">yes</xsl:variable>
  <xsl:variable name="bwStr-AddA-No">no</xsl:variable>
  <xsl:variable name="bwStr-AddA-Style">Style:</xsl:variable>
  <xsl:variable name="bwStr-AddA-Default">default</xsl:variable>
  <xsl:variable name="bwStr-AddA-NoteAboutAccess"><ul class="note" style="margin-left: 2em;">
      <li>You must be granted at least read access to the other user's calendar to subscribe to it.</li>
      <li>The <strong>Name</strong> is anything you want to call your subscription.</li>
      <li>The <strong>User ID</strong> is the user id that owns the calendar</li>
      <li>The <strong>Path</strong> is the name of the folder and/or calendar within the remote user's calendar tree.  For example, to subscribe to janedoe/someFolder/someCalendar, enter "someFolder/someCalendar".  To subscribe to janedoe's root folder, leave this field blank.</li>
      <li>You can add subscriptions to your own calendars to help group and organize collections you may wish to share.</li></ul></xsl:variable>

  <!--  xsl:template match="subscription" mode="modSubscription" (Deprecated: Strings left in place)-->

  <!--  xsl:template name="subscriptionList" (Deprecated: Strings left in place)-->

  <!--  xsl:template match="subscription" mode="mySubscriptions" (Deprecated: Strings left in place)-->

  <!--  xsl:template name="subInaccessible" (Deprecated: Strings left in place)-->

  <!--  xsl:template name="alarmOptions" -->
  <xsl:variable name="bwStr-AlOp-AlarmOptions">Alarm options</xsl:variable>
  <xsl:variable name="bwStr-AlOp-AlarmDateTime">Alarm Date/Time:</xsl:variable>
  <xsl:variable name="bwStr-AlOp-At">at</xsl:variable>
  <xsl:variable name="bwStr-AlOp-OrBeforeAfterEvent">or Before/After event:</xsl:variable>
  <xsl:variable name="bwStr-AlOp-Days">days</xsl:variable>
  <xsl:variable name="bwStr-AlOp-Hours">hours</xsl:variable>
  <xsl:variable name="bwStr-AlOp-Minutes">minutes</xsl:variable>
  <xsl:variable name="bwStr-AlOp-SecondsOr">seconds OR:</xsl:variable>
  <xsl:variable name="bwStr-AlOp-Weeks">weeks</xsl:variable>
  <xsl:variable name="bwStr-AlOp-Before">before</xsl:variable>
  <xsl:variable name="bwStr-AlOp-After">after</xsl:variable>
  <xsl:variable name="bwStr-AlOp-Start">start</xsl:variable>
  <xsl:variable name="bwStr-AlOp-End">end</xsl:variable>
  <xsl:variable name="bwStr-AlOp-EmailAddress">Email Address:</xsl:variable>
  <xsl:variable name="bwStr-AlOp-Subject">Subject:</xsl:variable>
  <xsl:variable name="bwStr-AlOp-Continue">Continue</xsl:variable>
  <xsl:variable name="bwStr-AlOp-Cancel">cancel</xsl:variable>

  <!--  xsl:template name="upload" -->
  <xsl:variable name="bwStr-Upld-AffectsFreeBusy">Affects free/busy:</xsl:variable>
  <xsl:variable name="bwStr-Upld-Yes">yes</xsl:variable>
  <xsl:variable name="bwStr-Upld-Transparent">(transparent: event status does not affect your free/busy)</xsl:variable>
  <xsl:variable name="bwStr-Upld-StripAlarms">Strip alarms:</xsl:variable>
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

  <!--  xsl:template name="emailOptions" -->
  <xsl:variable name="bwStr-EmOp-UpdateEmailOptions">Update email options</xsl:variable>
  <xsl:variable name="bwStr-EmOp-EmailAddress">Email Address:</xsl:variable>
  <xsl:variable name="bwStr-EmOp-Subject">Subject:</xsl:variable>
  <xsl:variable name="bwStr-EmOp-Continue">Continue</xsl:variable>
  <xsl:variable name="bwStr-EmOp-Cancel">cancel</xsl:variable>

  <!--  xsl:template name="locationList" -->
  <xsl:variable name="bwStr-LocL-ManagePreferences">Manage Preferences</xsl:variable>
  <xsl:variable name="bwStr-LocL-General">general</xsl:variable>
  <xsl:variable name="bwStr-LocL-Categories">categories</xsl:variable>
  <xsl:variable name="bwStr-LocL-Locations">locations</xsl:variable>
  <xsl:variable name="bwStr-LocL-SchedulingMeetings">scheduling/meetings</xsl:variable>
  <xsl:variable name="bwStr-LocL-ManageLocations">Manage Locations</xsl:variable>
  <xsl:variable name="bwStr-LocL-AddNewLocation">Add new location</xsl:variable>

  <!--  xsl:template name="modLocation" -->
  <xsl:variable name="bwStr-ModL-ManagePreferences">Manage Preferences</xsl:variable>
  <xsl:variable name="bwStr-ModL-General">general</xsl:variable>
  <xsl:variable name="bwStr-ModL-Categories">categories</xsl:variable>
  <xsl:variable name="bwStr-ModL-Locations">locations</xsl:variable>
  <xsl:variable name="bwStr-ModL-SchedulingMeetings">scheduling/meetings</xsl:variable>
  <xsl:variable name="bwStr-ModL-AddLocation">Add Location</xsl:variable>
  <xsl:variable name="bwStr-ModL-EditLocation">Edit Location</xsl:variable>
  <xsl:variable name="bwStr-ModL-MainAddress">Main Address:</xsl:variable>
  <xsl:variable name="bwStr-ModL-SubAddress">Subaddress:</xsl:variable>
  <xsl:variable name="bwStr-ModL-LocationLink">Location Link:</xsl:variable>
  <xsl:variable name="bwStr-ModL-SubmitLocation">Submit Location</xsl:variable>
  <xsl:variable name="bwStr-ModL-DeleteLocation">Delete Location</xsl:variable>
  <xsl:variable name="bwStr-ModL-Cancel">cancel</xsl:variable>

  <!--  xsl:template name="deleteLocationConfirm" -->
  <xsl:variable name="bwStr-OKDL-OKToDeleteLocation">Ok to delete this location?</xsl:variable>
  <xsl:variable name="bwStr-OKDL-DeleteLocation">Delete Location</xsl:variable>
  <xsl:variable name="bwStr-OKDL-MainAddress">Main Address:</xsl:variable>
  <xsl:variable name="bwStr-OKDL-Subaddress">Subaddress:</xsl:variable>
  <xsl:variable name="bwStr-OKDL-LocationLink">Location Link:</xsl:variable>
  <xsl:variable name="bwStr-OKDL-YesDeleteLocation">Yes: Delete Location</xsl:variable>
  <xsl:variable name="bwStr-OKDL-Cancel">No: Cancel</xsl:variable>


  <!--  xsl:template match="inbox" -->
  <xsl:variable name="bwStr-Inbx-Inbox">Inbox</xsl:variable>
  <xsl:variable name="bwStr-Inbx-Sent">sent</xsl:variable>
  <xsl:variable name="bwStr-Inbx-From">from</xsl:variable>
  <xsl:variable name="bwStr-Inbx-Title">title</xsl:variable>
  <xsl:variable name="bwStr-Inbx-Start">start</xsl:variable>
  <xsl:variable name="bwStr-Inbx-End">end</xsl:variable>
  <xsl:variable name="bwStr-Inbx-Method">method</xsl:variable>
  <xsl:variable name="bwStr-Inbx-Status">status</xsl:variable>
  <xsl:variable name="bwStr-Inbx-Unprocessed">unprocessed</xsl:variable>
  <xsl:variable name="bwStr-Inbx-Publish">publish</xsl:variable>
  <xsl:variable name="bwStr-Inbx-Request">request</xsl:variable>
  <xsl:variable name="bwStr-Inbx-Cancel">cancel</xsl:variable>
  <xsl:variable name="bwStr-Inbx-Counter">counter</xsl:variable>
  <xsl:variable name="bwStr-Inbx-Processed">processed</xsl:variable>
  <xsl:variable name="bwStr-Inbx-CheckMessage">check message</xsl:variable>
  <xsl:variable name="bwStr-Inbx-Email">email</xsl:variable>
  <xsl:variable name="bwStr-Inbx-Download">download</xsl:variable>
  <xsl:variable name="bwStr-Inbx-Delete">delete</xsl:variable>

  <!--  xsl:template match="outbox" -->
  <xsl:variable name="bwStr-Oubx-Outbox">Outbox</xsl:variable>
  <xsl:variable name="bwStr-Oubx-Sent">sent</xsl:variable>
  <xsl:variable name="bwStr-Oubx-Start">start</xsl:variable>
  <xsl:variable name="bwStr-Oubx-End">end</xsl:variable>
  <xsl:variable name="bwStr-Oubx-Method">method</xsl:variable>
  <xsl:variable name="bwStr-Oubx-Status">status</xsl:variable>
  <xsl:variable name="bwStr-Oubx-Title">title</xsl:variable>
  <xsl:variable name="bwStr-Oubx-Organizer">organizer</xsl:variable>
  <xsl:variable name="bwStr-Oubx-Publish">publish</xsl:variable>
  <xsl:variable name="bwStr-Oubx-Request">request</xsl:variable>
  <xsl:variable name="bwStr-Oubx-Cancel">cancel</xsl:variable>
  <xsl:variable name="bwStr-Oubx-Counter">counter</xsl:variable>
  <xsl:variable name="bwStr-Oubx-Unprocessed">unprocessed</xsl:variable>
  <xsl:variable name="bwStr-Oubx-Processed">processed</xsl:variable>
  <xsl:variable name="bwStr-Oubx-CheckMessage">check message</xsl:variable>
  <xsl:variable name="bwStr-Oubx-Email">email</xsl:variable>
  <xsl:variable name="bwStr-Oubx-Download">download</xsl:variable>
  <xsl:variable name="bwStr-Oubx-Delete">delete</xsl:variable>

  <!--  xsl:template match="scheduleMethod" -->
  <xsl:variable name="bwStr-ScMe-Publish">publish</xsl:variable>
  <xsl:variable name="bwStr-ScMe-Request">request</xsl:variable>
  <xsl:variable name="bwStr-ScMe-Reply">reply</xsl:variable>
  <xsl:variable name="bwStr-ScMe-Add">add</xsl:variable>
  <xsl:variable name="bwStr-ScMe-Cancel">cancel</xsl:variable>
  <xsl:variable name="bwStr-ScMe-Refresh">refresh</xsl:variable>
  <xsl:variable name="bwStr-ScMe-Counter">counter</xsl:variable>
  <xsl:variable name="bwStr-ScMe-Declined">declined</xsl:variable>

  <!--  xsl:template match="formElements" mode="attendeeRespond" -->
  <xsl:variable name="bwStr-AtRe-MeetingCanceled">Meeting Canceled</xsl:variable>
  <xsl:variable name="bwStr-AtRe-MeetingCounterDeclined">Meeting Counter Declined</xsl:variable>
  <xsl:variable name="bwStr-AtRe-MeetingRequest">Meeting Request</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Update">(update)</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Organizer">Organizer:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-ThisMeetingCanceled">This meeting has been canceled.</xsl:variable>
  <xsl:variable name="bwStr-AtRe-CounterReqDeclined">Your counter request has been declined.</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Calendar">Calendar:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Action">Action:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-MarkEventAsCanceled">mark event as canceled</xsl:variable>
  <xsl:variable name="bwStr-AtRe-DeleteEvent">delete event</xsl:variable>
  <xsl:variable name="bwStr-AtRe-ReplyAs">reply as</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Accepted">accepted</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Declined">declined</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Tentative">tentative</xsl:variable>
  <xsl:variable name="bwStr-AtRe-DelegateTo">delegate to</xsl:variable>
  <xsl:variable name="bwStr-AtRe-URIOrAccount">(uri or account)</xsl:variable>
  <xsl:variable name="bwStr-AtRe-CounterSuggest">counter (suggest a different date, time, and/or location)</xsl:variable>
  <xsl:variable name="bwStr-AtRe-NewDateTime">New Date/Time:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Invisible">invisible</xsl:variable>
  <xsl:variable name="bwStr-AtRe-TimeFields">timeFields</xsl:variable>
  <xsl:variable name="bwStr-AtRe-AllDayEvent">all day event</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Start">Start:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Date">Date</xsl:variable>
  <xsl:variable name="bwStr-AtRe-End">End:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Shown">shown</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Duration">Duration</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Days">days</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Hours">hours</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Minutes">minutes</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Weeks">weeks</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Or">or</xsl:variable>
  <xsl:variable name="bwStr-AtRe-ThisEventNoDuration">This event has no duration / end date</xsl:variable>
  <xsl:variable name="bwStr-AtRe-NewLocation">New Location:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Choose">choose:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Select">select...</xsl:variable>
  <xsl:variable name="bwStr-AtRe-OrAddNew">or add new:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Comment">Comment:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Delete">Delete</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Submit">Submit</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Cancel">cancel</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Title">Title:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Description">Description:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-DateAndTime">Date &amp; Time:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-AllDay">(all day)</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Location">Location:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-NotSpecified">not specified</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Attendees">Attendees:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Role">role</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Status">status</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Attendee">attendee</xsl:variable>
  <xsl:variable name="bwStr-AtRe-See">See:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Status">Status:</xsl:variable>

  <!--  xsl:template match="event" mode="attendeeReply" -->
  <xsl:variable name="bwStr-AtRy-MeetingChangeRequest">Meeting Change Request (Counter)</xsl:variable>
  <xsl:variable name="bwStr-AtRy-MeetingReply">Meeting Reply</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Organizer">Organizer:</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Shown">Attendee</xsl:variable>
  <xsl:variable name="bwStr-AtRy-HasRequestedChange">has requested a change to this meeting.</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Attendee">Attendee</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Has">has</xsl:variable>
  <xsl:variable name="bwStr-AtRy-TentativelyAccepted">TENTATIVELY accepted</xsl:variable>
  <xsl:variable name="bwStr-AtRy-YourInvitation">your invitation.</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Calendar">Calendar:</xsl:variable>
  <xsl:variable name="bwStr-AtRy-EventNoLongerExists">Event no longer exists.</xsl:variable>
  <xsl:variable name="bwStr-AtRy-From">From:</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Status">Status:</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Comments">Comments:</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Action">Action:</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Accept">accept</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Decline">decline</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Canceled">canceled</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Update">update"</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Title">Title:</xsl:variable>
  <xsl:variable name="bwStr-AtRy-NoTitle">no title</xsl:variable>
  <xsl:variable name="bwStr-AtRy-When">When:</xsl:variable>
  <xsl:variable name="bwStr-AtRy-AllDay">(all day)</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Where">Where:</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Description">Description:</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Status">Status:</xsl:variable>


  <!--  xsl:template match="event" mode="addEventRef" -->
  <xsl:variable name="bwStr-AERf-AddEventReference">Add Event Reference</xsl:variable>
  <xsl:variable name="bwStr-AERf-Event">Event:</xsl:variable>
  <xsl:variable name="bwStr-AERf-NoTitle">no title</xsl:variable>
  <xsl:variable name="bwStr-AERf-IntoCalendar">Into calendar:</xsl:variable>
  <xsl:variable name="bwStr-AERf-DefaultCalendar">default calendar</xsl:variable>
  <xsl:variable name="bwStr-AERf-AffectsFreeBusy">Affects Free/busy:</xsl:variable>
  <xsl:variable name="bwStr-AERf-Yes">yes</xsl:variable>
  <xsl:variable name="bwStr-AERf-Opaque">(opaque: event status affects your free/busy)</xsl:variable>
  <xsl:variable name="bwStr-AERf-No">no</xsl:variable>
  <xsl:variable name="bwStr-AERf-Transparent">(transparent: event status does not affect your free/busy)</xsl:variable>
  <xsl:variable name="bwStr-AERf-Cancel">cancel</xsl:variable>
  <xsl:variable name="bwStr-AERf-Continue">Continue</xsl:variable>

  <!--  xsl:template match="prefs" -->
  <xsl:variable name="bwStr-Pref-ManagePrefs">Manage Preferences</xsl:variable>
  <xsl:variable name="bwStr-Pref-General">general</xsl:variable>
  <xsl:variable name="bwStr-Pref-Categories">categories</xsl:variable>
  <xsl:variable name="bwStr-Pref-Locations">locations</xsl:variable>
  <xsl:variable name="bwStr-Pref-SchedulingMeetings">scheduling/meetings</xsl:variable>
  <xsl:variable name="bwStr-Pref-UserSettings">User settings:</xsl:variable>
  <xsl:variable name="bwStr-Pref-User">User:</xsl:variable>
  <xsl:variable name="bwStr-Pref-EmailAddress">Email address:</xsl:variable>
  <xsl:variable name="bwStr-Pref-AddingEvents">Adding events:</xsl:variable>
  <xsl:variable name="bwStr-Pref-PreferredTimeType">Preferred time type:</xsl:variable>
  <xsl:variable name="bwStr-Pref-12HourAMPM">12 hour + AM/PM</xsl:variable>
  <xsl:variable name="bwStr-Pref-24Hour">24 hour</xsl:variable>
  <xsl:variable name="bwStr-Pref-PreferredEndDateTimeType">Preferred end date/time type:</xsl:variable>
  <xsl:variable name="bwStr-Pref-Duration">duration</xsl:variable>
  <xsl:variable name="bwStr-Pref-DateTime">date/time</xsl:variable>
  <xsl:variable name="bwStr-Pref-DefaultSchedulingCalendar">Default scheduling calendar:</xsl:variable>
  <xsl:variable name="bwStr-Pref-WorkdaySettings">Workday settings:</xsl:variable>
  <xsl:variable name="bwStr-Pref-Workdays">Workdays:</xsl:variable>
  <xsl:variable name="bwStr-Pref-Sun">Sun</xsl:variable>
  <xsl:variable name="bwStr-Pref-Mon">Mon</xsl:variable>
  <xsl:variable name="bwStr-Pref-Tue">Tue</xsl:variable>
  <xsl:variable name="bwStr-Pref-Wed">Wed</xsl:variable>
  <xsl:variable name="bwStr-Pref-Thu">Thu</xsl:variable>
  <xsl:variable name="bwStr-Pref-Fri">Fri</xsl:variable>
  <xsl:variable name="bwStr-Pref-Sat">Sat</xsl:variable>
  <xsl:variable name="bwStr-Pref-WorkdayStart">Workday start:</xsl:variable>
  <xsl:variable name="bwStr-Pref-WorkdayEnd">Workday end:</xsl:variable>
  <xsl:variable name="bwStr-Pref-DisplayOptions">Display options:</xsl:variable>
  <xsl:variable name="bwStr-Pref-PreferredView">Preferred view:</xsl:variable>
  <xsl:variable name="bwStr-Pref-PreferredViewPeriod">Preferred view period:</xsl:variable>
  <xsl:variable name="bwStr-Pref-Day">day</xsl:variable>
  <xsl:variable name="bwStr-Pref-Today">today</xsl:variable>
  <xsl:variable name="bwStr-Pref-Week">week</xsl:variable>
  <xsl:variable name="bwStr-Pref-Month">month</xsl:variable>
  <xsl:variable name="bwStr-Pref-Year">year</xsl:variable>
  <xsl:variable name="bwStr-Pref-DefaultTimezone">Default timezone:</xsl:variable>
  <xsl:variable name="bwStr-Pref-SelectTimezone">select timezone...</xsl:variable>
  <xsl:variable name="bwStr-Pref-DefaultTimezoneNote">Default timezone id for date/time values. This should normally be your local timezone.</xsl:variable>
  <xsl:variable name="bwStr-Pref-Update">Update</xsl:variable>
  <xsl:variable name="bwStr-Pref-Cancel">cancel</xsl:variable>
  <xsl:variable name="bwStr-ScPr-ManagePreferences">Manage Preferences</xsl:variable>
  <xsl:variable name="bwStr-ScPr-General">general</xsl:variable>
  <xsl:variable name="bwStr-ScPr-Categories">categories</xsl:variable>
  <xsl:variable name="bwStr-ScPr-Locations">locations</xsl:variable>
  <xsl:variable name="bwStr-ScPr-SchedulingMeetings">scheduling/meetings</xsl:variable>
  <xsl:variable name="bwStr-ScPr-SchedulingAccess">Scheduling access:</xsl:variable>
  <xsl:variable name="bwStr-ScPr-SetScheduleAccess">Set scheduling access by modifying acls on your inbox and outbox</xsl:variable>
  <xsl:variable name="bwStr-ScPr-GrantScheduleAccess">Grant "scheduling" access and "read freebusy".</xsl:variable>
  <xsl:variable name="bwStr-ScPr-AccessNote"><ul>
  <li>Inbox: users granted scheduling access on your inbox can send you scheduling requests.</li>
    <li>Outbox: users granted scheduling access on your outbox can schedule on your behalf.</li></ul>
    <p class="note">*this approach is temporary and will be improved in upcoming releases.</p></xsl:variable>
  <xsl:variable name="bwStr-ScPr-SchedulingAutoProcessing">Scheduling auto-processing:</xsl:variable>
  <xsl:variable name="bwStr-ScPr-RespondToSchedReqs">Auto-respond to scheduling requests:</xsl:variable>
  <xsl:variable name="bwStr-ScPr-True">true</xsl:variable>
  <xsl:variable name="bwStr-ScPr-False">false</xsl:variable>
  <xsl:variable name="bwStr-ScPr-AcceptDoubleBookings">Accept double-bookings:</xsl:variable>
  <xsl:variable name="bwStr-ScPr-CancelProcessing">Cancel processing:</xsl:variable>
  <xsl:variable name="bwStr-ScPr-DoNothing">do nothing</xsl:variable>
  <xsl:variable name="bwStr-ScPr-SetToCanceled">set event status to CANCELED</xsl:variable>
  <xsl:variable name="bwStr-ScPr-DeleteEvent">delete the event</xsl:variable>
  <xsl:variable name="bwStr-ScPr-ReponseProcessing">Response processing:</xsl:variable>
  <xsl:variable name="bwStr-ScPr-LeaveInInbox">leave in Inbox for manual processing</xsl:variable>
  <xsl:variable name="bwStr-ScPr-ProcessAccepts">process "Accept" responses - leave the rest in Inbox</xsl:variable>
  <xsl:variable name="bwStr-ScPr-TryToProcessAll">try to process all responses</xsl:variable>
  <xsl:variable name="bwStr-ScPr-UpdateSchedulingProcessing">Update scheduling auto-processing</xsl:variable>
  <xsl:variable name="bwStr-ScPr-Cancel">cancel</xsl:variable>

  <!-- xsl:template name="buildWorkdayOptionsList" -->

  <!--  xsl:template name="schedulingAccessForm" -->
  <xsl:variable name="bwStr-ScAF-User">user</xsl:variable>
  <xsl:variable name="bwStr-ScAF-Group">group</xsl:variable>
  <xsl:variable name="bwStr-ScAF-Owner">owner</xsl:variable>
  <xsl:variable name="bwStr-ScAF-Authenticated">authenticated</xsl:variable>
  <xsl:variable name="bwStr-ScAF-UnAuthenticated">unauthenticated</xsl:variable>
  <xsl:variable name="bwStr-ScAF-All">all</xsl:variable>
  <xsl:variable name="bwStr-ScAF-AllScheduling">all scheduling</xsl:variable>
  <xsl:variable name="bwStr-ScAF-SchedulingReqs">scheduling requests</xsl:variable>
  <xsl:variable name="bwStr-ScAF-SchedulingReplies">scheduling replies</xsl:variable>
  <xsl:variable name="bwStr-ScAF-FreeBusyReqs">free-busy requests</xsl:variable>
  <xsl:variable name="bwStr-ScAF-Update">update</xsl:variable>

  <!--  xsl:template match="event" mode="schedNotifications" -->
  <xsl:variable name="bwStr-ScN-Re">Re:</xsl:variable>

  <!--  xsl:template name="searchResult" -->
  <xsl:variable name="bwStr-Srch-Search">Search:</xsl:variable>
  <xsl:variable name="bwStr-Srch-Go">go</xsl:variable>
  <xsl:variable name="bwStr-Srch-Limit">Limit:</xsl:variable>
  <xsl:variable name="bwStr-Srch-TodayForward">today forward</xsl:variable>
  <xsl:variable name="bwStr-Srch-PastDates">past dates</xsl:variable>
  <xsl:variable name="bwStr-Srch-AllDates">all dates</xsl:variable>
  <xsl:variable name="bwStr-Srch-SearchResult">Search Result</xsl:variable>
  <xsl:variable name="bwStr-Srch-Page">page:</xsl:variable>
  <xsl:variable name="bwStr-Srch-Prev">prev</xsl:variable>
  <xsl:variable name="bwStr-Srch-Next">next</xsl:variable>
  <xsl:variable name="bwStr-Srch-ResultReturnedFor">result(s) returned for</xsl:variable>
  <xsl:variable name="bwStr-Srch-Relevance">relevance</xsl:variable>
  <xsl:variable name="bwStr-Srch-Summary">display name</xsl:variable>
  <xsl:variable name="bwStr-Srch-DateAndTime">date &amp; time</xsl:variable>
  <xsl:variable name="bwStr-Srch-Calendar">calendar</xsl:variable>
  <xsl:variable name="bwStr-Srch-Location">location</xsl:variable>
  <xsl:variable name="bwStr-Srch-NoTitle">no title</xsl:variable>

  <!-- xsl:template name="searchResultPageNav" -->

  <!-- xsl:template match="calendar" mode="sideList" -->

  <!-- xsl:template name="selectPage" -->

  <!-- xsl:template name="noPage" -->

  <!-- xsl:template name="timeFormatter" -->
  <xsl:variable name="bwStr-TiFo-AM">AM</xsl:variable>
  <xsl:variable name="bwStr-TiFo-PM">PM</xsl:variable>

  <!-- xsl:template name="footer"  -->
  <xsl:variable name="bwStr-Foot-DemonstrationCalendar">Demonstration calendar; place footer information here.</xsl:variable>
  <xsl:variable name="bwStr-Foot-BedeworkWebsite">Bedework Website</xsl:variable>
  <xsl:variable name="bwStr-Foot-ShowXML">show XML</xsl:variable>
  <xsl:variable name="bwStr-Foot-RefreshXSLT">refresh XSLT</xsl:variable>
  <xsl:variable name="bwStr-Foot-BasedOnThe">Based on the</xsl:variable>
  <xsl:variable name="bwStr-Foot-BedeworkCalendarSystem">Bedework Calendar System</xsl:variable>
  <xsl:variable name="bwStr-Foot-ProductionExamples">production examples</xsl:variable>
  <xsl:variable name="bwStr-Foot-ExampleStyles">example styles</xsl:variable>
  <xsl:variable name="bwStr-Foot-Green">green</xsl:variable>
  <xsl:variable name="bwStr-Foot-Red">red</xsl:variable>
  <xsl:variable name="bwStr-Foot-Blue">blue</xsl:variable>
  <xsl:variable name="bwStr-Foot-ExampleSkins">example skins</xsl:variable>
  <xsl:variable name="bwStr-Foot-RSSNext3Days">rss: next 3 days</xsl:variable>
  <xsl:variable name="bwStr-Foot-JavascriptNext3Days">javascript: next 3 days</xsl:variable>
  <xsl:variable name="bwStr-Foot-JavascriptTodaysEvents">javascript: today's events</xsl:variable>
  <xsl:variable name="bwStr-Foot-ForMobileBrowsers">for mobile browsers</xsl:variable>
  <xsl:variable name="bwStr-Foot-VideoFeed">video feed</xsl:variable>
  <xsl:variable name="bwStr-Foot-ResetToCalendarDefault">reset to calendar default</xsl:variable>

</xsl:stylesheet>
