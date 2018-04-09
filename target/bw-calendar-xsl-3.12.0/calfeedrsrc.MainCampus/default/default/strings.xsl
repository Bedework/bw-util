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
  <xsl:variable name="bwStr-Root-PageTitle">Bedework Events Calendar</xsl:variable>

  <!-- xsl:template name="headBar" -->
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
  <xsl:variable name="bwStr-HdBr-EventInformation">Event Information</xsl:variable>

  <!--  xsl:template name="tabs" -->
  <xsl:variable name="bwStr-Tabs-LoggedInAs">logged in as</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Logout">logout</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Day">DAY</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Week">WEEK</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Month">MONTH</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Year">YEAR</xsl:variable>
  <xsl:variable name="bwStr-Tabs-List">LIST</xsl:variable>

  <!--  xsl:template name="navigation" -->
  <xsl:variable name="bwStr-Navi-WeekOf">Week of</xsl:variable>
  <xsl:variable name="bwStr-Navi-Go">go</xsl:variable>

  <!--  xsl:template name="searchBar" -->
  <xsl:variable name="bwStr-SrcB-Add">add...</xsl:variable>
  <xsl:variable name="bwStr-SrcB-View">View:</xsl:variable>
  <xsl:variable name="bwStr-SrcB-DefaultView">default view</xsl:variable>
  <xsl:variable name="bwStr-SrcB-AllTopicalAreas">all topical areas</xsl:variable>
  <xsl:variable name="bwStr-SrcB-Search">Search:</xsl:variable>
  <xsl:variable name="bwStr-SrcB-Go">go</xsl:variable>
  <xsl:variable name="bwStr-SrcB-ToggleListCalView">toggle list/calendar view</xsl:variable>
  <xsl:variable name="bwStr-SrcB-ToggleSummDetView">toggle summary/detailed view</xsl:variable>
  <xsl:variable name="bwStr-SrcB-TopicalArea">Topical Area:</xsl:variable>
  <xsl:variable name="bwStr-SrcB-CurrentSearch">Current search:</xsl:variable>

  <!--  xsl:template match="event" -->
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
  <!--Link, add master event reference to a calendar, add this event reference to a calendar, add event reference to a calendar -->
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
  <xsl:variable name="bwStr-SgEv-Recurring">Recurring</xsl:variable>
  <!--public, private -->
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
  <xsl:variable name="bwStr-SgEv-Complete">Complete:</xsl:variable>
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
  <!--Recipients:, recipient -->
  <xsl:variable name="bwStr-SgEv-Calendar">Calendar:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Categories">Categories:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Comments">Comments:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-TopicalArea">Topical Area:</xsl:variable>

  <!--  xsl:template name="listView" -->
  <xsl:variable name="bwStr-LsVw-NoEventsToDisplay">No events to display.</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Add">add...</xsl:variable>
  <xsl:variable name="bwStr-LsVw-AllDay">all day</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Today">today</xsl:variable>
  <xsl:variable name="bwStr-LsVw-AddEventToMyCalendar">Add event to MyCalendar</xsl:variable>
  <xsl:variable name="bwStr-LsVw-DownloadEvent">Download event as ical - for Outlook, PDAs, iCal, and other desktop calendars</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Description">description</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Canceled">CANCELED:</xsl:variable>
  <xsl:variable name="bwStr-LsVw-NoTitle">no title</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Contact">Contact:</xsl:variable>

  <!--  xsl:template match="events" mode="eventList" -->
  <xsl:variable name="bwStr-LsEv-Next7Days">Next 7 Days</xsl:variable>
  <xsl:variable name="bwStr-LsEv-NoEventsToDisplay">No events to display.</xsl:variable>
  <xsl:variable name="bwStr-LsEv-DownloadEvent">Download event as ical - for Outlook, PDAs, iCal, and other desktop calendars</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Categories">Categories:</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Contact">Contact:</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Canceled">CANCELED:</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Tentative">TENTATIVE:</xsl:variable>

  <!--  xsl:template name="buildListEventsDaysOptions" -->

  <!--  xsl:template name="weekView" -->

  <!--  xsl:template name="monthView" -->

  <!--  xsl:template match="event" mode="calendarLayout" -->
  <xsl:variable name="bwStr-EvCG-CanceledColon">CANCELED:</xsl:variable>
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

  <!--  xsl:template name="yearView" -->

  <!--  xsl:template match="month" -->

  <!--  xsl:template match="calendars" -->
  <xsl:variable name="bwStr-Cals-AllTopicalAreas">All Topical Areas</xsl:variable>
  <xsl:variable name="bwStr-Cals-SelectTopicalArea">Select a topical area from the list below to see only its events.</xsl:variable>

  <!--  xsl:template match="calendar" mode="calTree" -->
  <xsl:variable name="bwStr-Calr-Folder">folder</xsl:variable>
  <xsl:variable name="bwStr-Calr-Calendar">calendar</xsl:variable>

  <!--  xsl:template match="currentCalendar" mode="export" -->
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
  <xsl:variable name="bwStr-Cals-Export">export</xsl:variable>

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
  <xsl:variable name="bwStr-Srch-Summary">summary</xsl:variable>
  <xsl:variable name="bwStr-Srch-DateAndTime">date &amp; time</xsl:variable>
  <xsl:variable name="bwStr-Srch-Calendar">calendar</xsl:variable>
  <xsl:variable name="bwStr-Srch-Location">location</xsl:variable>
  <xsl:variable name="bwStr-Srch-NoTitle">no title</xsl:variable>

  <!--  xsl:template name="searchResultPageNav" -->

  <!--  xsl:template name="stats" -->
  <xsl:variable name="bwStr-Stat-SysStats">System Statistics</xsl:variable>
  <xsl:variable name="bwStr-Stat-StatsCollection">Stats collection:</xsl:variable>
  <xsl:variable name="bwStr-Stat-Enable">enable</xsl:variable>
  <xsl:variable name="bwStr-Stat-Disable">disable</xsl:variable>
  <xsl:variable name="bwStr-Stat-FetchStats">fetch statistics</xsl:variable>
  <xsl:variable name="bwStr-Stat-DumpStats">dump stats to log</xsl:variable>

  <!--  xsl:template name="footer" -->
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
