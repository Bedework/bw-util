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

  <!-- Most text exposed by the stylesheets is set here. -->

  <xsl:variable name="bwStr-Root-PageTitle">Bedework Events Calendar</xsl:variable>
  <xsl:variable name="bwStr-Error">Error:</xsl:variable>
  <xsl:variable name="bwStr-Error-NoPage">No page to display</xsl:variable>
  <xsl:variable name="bwStr-Error-PageNotDefined">Page "<xsl:value-of select="/bedework/appvar[key='page']/value"/>" is not defined.</xsl:variable>
  <xsl:variable name="bwStr-Error-IframeUnsupported">Your browser does not support iframes.</xsl:variable>
  <xsl:variable name="bwStr-Error-NoScript">Your browser does not support JavaScript!</xsl:variable>

  <!-- xsl:template name="headBar" -->
  <xsl:variable name="bwStr-HdBr-SiteTitle">Public Events Calendar</xsl:variable>
  <xsl:variable name="bwStr-HdBr-UniversityHome">University Home</xsl:variable>
  <xsl:variable name="bwStr-HdBr-OtherLink">Other Link</xsl:variable>
  <xsl:variable name="bwStr-HdBr-ExportSubscribe">Export/Subscribe</xsl:variable>
  <xsl:variable name="bwStr-HdBr-EventInformation">Event Information</xsl:variable>
  <xsl:variable name="bwStr-HdBr-BackLink">(return to events)</xsl:variable>

  <!-- ongoing events -->
  <xsl:variable name="bwStr-Ongoing-Title">Ongoing</xsl:variable>
  <xsl:variable name="bwStr-Ongoing-NoEvents">There are no ongoing events in this time period or view</xsl:variable>
  <xsl:variable name="bwStr-Ongoing-Ends">Ends</xsl:variable>

  <!-- deadlines -->
  <xsl:variable name="bwStr-Deadline-Title">Deadlines</xsl:variable>
  <xsl:variable name="bwStr-Deadline-NoEvents">There are no deadlines in this time period or view</xsl:variable>

  <!--  xsl:template name="tabs" -->
  <xsl:variable name="bwStr-Tabs-LoggedInAs">logged in as</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Logout">logout</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Today">TODAY</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Upcoming">UPCOMING</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Day">DAY</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Week">WEEK</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Month">MONTH</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Year">YEAR</xsl:variable>
  <xsl:variable name="bwStr-Tabs-List">LIST</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Search">search</xsl:variable>
  <xsl:variable name="bwStr-Tabs-AdvSearch">advanced</xsl:variable>
  <xsl:variable name="bwStr-Tabs-JumpToDate">Jump To Date</xsl:variable>

  <!--  xsl:template name="datePicker" -->
  <xsl:variable name="bwStr-DatePicker-Today">today</xsl:variable>
  <xsl:variable name="bwStr-DatePicker-Upcoming">upcoming</xsl:variable>
  <xsl:variable name="bwStr-DatePicker-Range">range</xsl:variable>
  <xsl:variable name="bwStr-DatePicker-Day">day</xsl:variable>
  <xsl:variable name="bwStr-DatePicker-Week">week</xsl:variable>
  <xsl:variable name="bwStr-DatePicker-Month">month</xsl:variable>
  <xsl:variable name="bwStr-DatePicker-StartDate">Start date:</xsl:variable>
  <xsl:variable name="bwStr-DatePicker-Menu">menu</xsl:variable>

  <!--  xsl:template name="navigation" -->
  <xsl:variable name="bwStr-Navi-WeekOf">Week of</xsl:variable>

  <!--  xsl:template name="searchBar" -->
  <xsl:variable name="bwStr-SrcB-SearchForEvents">Search for events:</xsl:variable>
  <xsl:variable name="bwStr-SrcB-ApplyFilter">apply filter</xsl:variable>
  <xsl:variable name="bwStr-Util-List">LIST</xsl:variable>
  <xsl:variable name="bwStr-Util-Cal">CAL</xsl:variable>
  <xsl:variable name="bwStr-Util-Summary">SUMMARY</xsl:variable>
  <xsl:variable name="bwStr-Util-Details">DETAILS</xsl:variable>
  <xsl:variable name="bwStr-SrcB-Summary">Summary</xsl:variable>
  <xsl:variable name="bwStr-SrcB-Details">Details</xsl:variable>

  <!--  xsl:template name="leftColumnText" -->
   <xsl:variable name="bwStr-LCol-DownloadCalendars">Download Calendars</xsl:variable>
   <xsl:variable name="bwStr-LCol-Options">OPTIONS:</xsl:variable>
   <xsl:variable name="bwStr-LCol-ManageEvents">Manage Events</xsl:variable>
   <xsl:variable name="bwStr-LCol-Submit">Submit an Event</xsl:variable>
   <xsl:variable name="bwStr-LCol-Help">Help</xsl:variable>

  <!--  xsl:template match="event" -->
  <xsl:variable name="bwStr-SgEv-Canceled">CANCELED:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Event">Event</xsl:variable>
  <xsl:variable name="bwStr-SgEv-NoTitle">no title</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Download">Download</xsl:variable>
  <xsl:variable name="bwStr-SgEv-EventLink">Event Link:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-When">When:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-AllDay">(all day)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-FloatingTime">Floating time</xsl:variable>
  <xsl:variable name="bwStr-SgEv-LocalTime">Local time</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Start">Start:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-End">End:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-DueBy">Due By</xsl:variable>
  <xsl:variable name="bwStr-SgEv-AddToMyCalendar">add to my calendar</xsl:variable>
  <xsl:variable name="bwStr-SgEv-AddEventToMyCalendar">Add to MyCalendar</xsl:variable>
  <xsl:variable name="bwStr-SgEv-AddToGoogleCalendar">Add to Google Calendar</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Where">Where:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Location-Accessible">(This venue is wheelchair accessible)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Location-Map">map</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Description">Description:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-STATUS">Status:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Cost">Cost:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-See">See:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Contact">Contact:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Comments">Comments:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Categories">Categories:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-TopicalArea">Topical Areas:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Calendars">Calendars:</xsl:variable>

  <!--  xsl:template name="listView" -->
  <xsl:variable name="bwStr-LsVw-NoEventsToDisplay">No events found.  Please try a different view or time period.</xsl:variable>
  <xsl:variable name="bwStr-LsVw-NoEventsToDisplayWithOngoing">No non-ongoing events found.  Please try a different view or time period or look in the Ongoing events list.</xsl:variable>
  <xsl:variable name="bwStr-LsVw-NoEventsFromSelection">Your selection returns no results.</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Add">add...</xsl:variable>
  <xsl:variable name="bwStr-LsVw-AllDay">All Day</xsl:variable>
  <xsl:variable name="bwStr-LsVw-At">at</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Today">Today</xsl:variable>
  <xsl:variable name="bwStr-LsVw-AddEventToMyCalendar">Add to MyCalendar</xsl:variable>
  <xsl:variable name="bwStr-LsVw-DownloadEvent">Download ical</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Canceled">CANCELED:</xsl:variable>
  <xsl:variable name="bwStr-LsVw-NoTitle">no title</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Contact">Contact:</xsl:variable>
  <xsl:variable name="bwStr-LsVw-DispEventsForCal">Displaying Events for Calendar</xsl:variable>
  <xsl:variable name="bwStr-LsVw-DispEventsForView">Displaying Events for View</xsl:variable>
  <xsl:variable name="bwStr-LsVw-ShowAll">(show all)</xsl:variable>
  <xsl:variable name="bwStr-LsVw-TopicalArea">Topical Areas:</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Location">Location:</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Cost">Cost:</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Description">Description:</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Link">Link:</xsl:variable>
  <xsl:variable name="bwStr-LsVw-ListWithinTimeRange">List of events within a time range</xsl:variable>

  <!--  xsl:template match="events" mode="eventList" -->
  <xsl:variable name="bwStr-LsEv-Event">event returned</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Events">events returned</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Next7Days">Next 7 Days</xsl:variable>
  <xsl:variable name="bwStr-LsEv-NoEventsToDisplay">No events to display.</xsl:variable>
  <xsl:variable name="bwStr-LsEv-ContinueFrom">Continue from </xsl:variable>
  <xsl:variable name="bwStr-LsEv-ReturnToToday">Return to Today</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Calendars">Calendars:</xsl:variable>
  <xsl:variable name="bwStr-LsEv-ClearFilters">(clear all)</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Search">Search:</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Filter">Filter:</xsl:variable>
  <xsl:variable name="bwStr-LsEv-ClearSearch">(clear)</xsl:variable>
  <xsl:variable name="bwStr-LsEv-DownloadEvent">Download ical</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Categories">Categories:</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Contact">Contact:</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Canceled">CANCELED:</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Tentative">TENTATIVE:</xsl:variable>
  <xsl:variable name="bwStr-LsEv-EventList">Event List</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Upcoming">Upcoming Events</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Starting">Starting</xsl:variable>

  <!--  xsl:template match="event" mode="calendarLayout" -->
  <xsl:variable name="bwStr-EvCG-CanceledColon">CANCELED:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Tentative">TENTATIVE:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Cont">(cont)</xsl:variable>
  <xsl:variable name="bwStr-EvCG-AllDayColon">all day:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Time">Time:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-AllDay">all day</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Location">Location:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-TopicalArea">Topical Area:</xsl:variable>

  <!--  xsl:template match="calendars" -->
  <xsl:variable name="bwStr-Cals-DownloadCalendars">Download Calendars</xsl:variable>
  <xsl:variable name="bwStr-Cals-SelectCalendar">Select a calendar to download its events in ical format.</xsl:variable>

  <!--  xsl:template match="currentCalendar" mode="export" -->
  <xsl:variable name="bwStr-Cals-ExportCals">Export Calendar as iCal</xsl:variable>
  <xsl:variable name="bwStr-Cals-CalendarToExport">Exporting:</xsl:variable>
  <xsl:variable name="bwStr-Cals-TodayForward">today forward</xsl:variable>
  <xsl:variable name="bwStr-Cals-AllDates">all dates</xsl:variable>
  <xsl:variable name="bwStr-Cals-DateRange">date range</xsl:variable>
  <xsl:variable name="bwStr-Cals-Start"><strong>Start:</strong></xsl:variable>
  <xsl:variable name="bwStr-Cals-End"><strong>End:</strong></xsl:variable>
  <xsl:variable name="bwStr-Cals-Export">export</xsl:variable>

  <!--  xsl:template name="searchResult" -->
  <xsl:variable name="bwStr-Srch-Search">Search:</xsl:variable>
  <xsl:variable name="bwStr-Srch-Go">go</xsl:variable>
  <xsl:variable name="bwStr-Srch-Limit">Limit:</xsl:variable>
  <xsl:variable name="bwStr-Srch-TodayForward">today forward</xsl:variable>
  <xsl:variable name="bwStr-Srch-PastDates">past dates</xsl:variable>
  <xsl:variable name="bwStr-Srch-AllDates">all dates</xsl:variable>
  <xsl:variable name="bwStr-Srch-SearchResults">Search Results</xsl:variable>
  <xsl:variable name="bwStr-Srch-Location">location</xsl:variable>
  <xsl:variable name="bwStr-Srch-NoQuery">no query</xsl:variable>
  <xsl:variable name="bwStr-Srch-Result">result</xsl:variable>
  <xsl:variable name="bwStr-Srch-Results">results</xsl:variable>
  <xsl:variable name="bwStr-Srch-ReturnedFor">returned for:</xsl:variable>
  <xsl:variable name="bwStr-Srch-Rank">Rank</xsl:variable>
  <xsl:variable name="bwStr-Srch-Date">Date</xsl:variable>
  <xsl:variable name="bwStr-Srch-Summary">Summary</xsl:variable>
  <xsl:variable name="bwStr-Srch-Pages">Page:</xsl:variable>
  <xsl:variable name="bwStr-Srch-AdvancedSearch">Advanced Search</xsl:variable>
  <xsl:variable name="bwStr-Srch-CatsToSearch">Select Categories to Search (Optional)</xsl:variable>
  <xsl:variable name="bwStr-Srch-SearchTermNotice">A search term is not required if at least one category is selected.</xsl:variable>

  <!--  xsl:template name="stats" -->
  <xsl:variable name="bwStr-Stat-SysStats">System Statistics</xsl:variable>
  <xsl:variable name="bwStr-Stat-StatsCollection">Stats collection:</xsl:variable>
  <xsl:variable name="bwStr-Stat-Enable">enable</xsl:variable>
  <xsl:variable name="bwStr-Stat-Disable">disable</xsl:variable>
  <xsl:variable name="bwStr-Stat-FetchStats">fetch statistics</xsl:variable>
  <xsl:variable name="bwStr-Stat-DumpStats">dump stats to log</xsl:variable>

  <!--  xsl:template name="exportSubscribe" -->
  <xsl:variable name="bwStr-exSu-ExportSubscribe">Export / Subscribe</xsl:variable>
  <xsl:variable name="bwStr-exSu-CurrentFiltersColon">Current Filters:</xsl:variable>
  <xsl:variable name="bwStr-exSu-FeedOrWidget">Event feed or embeddable widget?</xsl:variable>
  <xsl:variable name="bwStr-exSu-Feed">Feed</xsl:variable>
  <xsl:variable name="bwStr-exSu-Widget">Widget (code to copy and paste onto a website)</xsl:variable>
  <xsl:variable name="bwStr-exSu-DataFormat">Data format?</xsl:variable>
  <xsl:variable name="bwStr-exSu-HTMLList">HTML list (copy &amp; paste into Word, etc.)</xsl:variable>
  <xsl:variable name="bwStr-exSu-EventCount">Event count</xsl:variable>
  <xsl:variable name="bwStr-exSu-EventCountTotal">Total number of events returned:</xsl:variable>
  <xsl:variable name="bwStr-exSu-IncludeDownloadLink">Include download link?</xsl:variable>
  <xsl:variable name="bwStr-exSu-True">True</xsl:variable>
  <xsl:variable name="bwStr-exSu-False">False</xsl:variable>
  <xsl:variable name="bwStr-exSu-ShowDetailsOrSummary">Show details or summary?</xsl:variable>
  <xsl:variable name="bwStr-exSu-Details">Details</xsl:variable>
  <xsl:variable name="bwStr-exSu-Summary">Summary</xsl:variable>
  <xsl:variable name="bwStr-exSu-Timeframe">Time frame</xsl:variable>
  <xsl:variable name="bwStr-exSu-UseDefaultListing">Use the default listing, limit the number of days (from the current date), or provide a start date and an end date.</xsl:variable>
  <xsl:variable name="bwStr-exSu-Default">Default: pull events from "today" forward</xsl:variable>
  <xsl:variable name="bwStr-exSu-LimitTo">Limit to</xsl:variable>
  <xsl:variable name="bwStr-exSu-DaysFromToday">days from "today"</xsl:variable>
  <xsl:variable name="bwStr-exSu-DateRangeColon">Date Range:</xsl:variable>
  <xsl:variable name="bwStr-exSu-StartDateColon">Start Date:</xsl:variable>
  <xsl:variable name="bwStr-exSu-EndDateColon">End Date:</xsl:variable>
  <xsl:variable name="bwStr-exSu-DateRangeNote">Note: Event count takes precedence over date range!</xsl:variable>
  <xsl:variable name="bwStr-exSu-WidgetOptions">Widget Options</xsl:variable>
  <xsl:variable name="bwStr-exSu-LimitEvents">Limit the number of events listed?</xsl:variable>
  <xsl:variable name="bwStr-exSu-DefaultFalse">(default: false)</xsl:variable>
  <xsl:variable name="bwStr-exSu-LimitToColon">Limit to:</xsl:variable>
  <xsl:variable name="bwStr-exSu-Events">events</xsl:variable>
  <xsl:variable name="bwStr-exSu-ShowTitle">Show a title above event list?</xsl:variable>
  <xsl:variable name="bwStr-exSu-DefaultTrue">(default: true)</xsl:variable>
  <xsl:variable name="bwStr-exSu-TitleColon">Title:</xsl:variable>
  <xsl:variable name="bwStr-exSu-UpcomingEvents">Upcoming Events</xsl:variable>
  <xsl:variable name="bwStr-exSu-DefaultUpcomingEvents">(default: "Upcoming Events")</xsl:variable>
  <xsl:variable name="bwStr-exSu-HighlightDatesOrTitles">Highlight event dates or event titles?</xsl:variable>
  <xsl:variable name="bwStr-exSu-ByTitle">By title</xsl:variable>
  <xsl:variable name="bwStr-exSu-ByDate">By date</xsl:variable>
  <xsl:variable name="bwStr-exSu-DefaultByTitle">(default 'by title')</xsl:variable>
  <xsl:variable name="bwStr-exSu-ShowDescription">Show description in listing?</xsl:variable>
  <xsl:variable name="bwStr-exSu-DisplayEndDate">Display end date in listing?</xsl:variable>
  <xsl:variable name="bwStr-exSu-DisplayTime">Display time in listing?</xsl:variable>
  <xsl:variable name="bwStr-exSu-DisplayLocation">Display location in listing?</xsl:variable>
  <xsl:variable name="bwStr-exSu-DisplayDetailsInline">Display event details inline?</xsl:variable>
  <xsl:variable name="bwStr-exSu-DisplayContact">Display contact in event details?</xsl:variable>
  <xsl:variable name="bwStr-exSu-DisplayCost">>Display cost in event details?</xsl:variable>
  <xsl:variable name="bwStr-exSu-DisplayTags">Display tags in event details?</xsl:variable>
  <xsl:variable name="bwStr-exSu-DisplayTimezone">Display timezone in event details?</xsl:variable>
  <xsl:variable name="bwStr-exSu-URL">Your URL:</xsl:variable>
  <xsl:variable name="bwStr-exSu-WidgetCode">Widget Code:</xsl:variable>

  <!--  xsl:template name="footer" -->
  <xsl:variable name="bwStr-Foot-BasedOnThe">Based on the</xsl:variable>
  <xsl:variable name="bwStr-Foot-BedeworkCalendarSystem">Bedework Calendar System</xsl:variable>
  <xsl:variable name="bwStr-Foot-ProductionExamples">Production Examples</xsl:variable>
  <xsl:variable name="bwStr-Foot-ShowXML">Show XML</xsl:variable>
  <xsl:variable name="bwStr-Foot-RefreshXSLT">Refresh XSLT</xsl:variable>
  <xsl:variable name="bwStr-Foot-Credits">This theme is based on work by Duke and Yale Universities with thanks also to the University of Chicago</xsl:variable>

</xsl:stylesheet>
