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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- include the common language string libraries -->
  <xsl:include href="/bedework-common/default/default/errors.xsl" />
  <xsl:include href="/bedework-common/default/default/messages.xsl" />
  <xsl:include href="/bedework-common/default/default/bedeworkAccessStrings.xsl"/>

  <!--  xsl:template match="/" -->
  <xsl:variable name="bwStr-Root-PageTitle">Calendar Admin: Public Events Administration</xsl:variable>
  <xsl:variable name="bwStr-Root-NoAdminGroup">No administrative group</xsl:variable>
  <xsl:variable name="bwStr-Root-YourUseridNotAssigned">Your userid has not been assigned to an administrative group.  Please inform your administrator.</xsl:variable>
  <xsl:variable name="bwStr-Root-NoAccess">No Access</xsl:variable>
  <xsl:variable name="bwStr-Root-YouHaveNoAccess">You have no access to the action you just attempted. If you believe you should have access and the problem persists, contact your administrator.</xsl:variable>
  <xsl:variable name="bwStr-Root-Continue">continue</xsl:variable>
  <xsl:variable name="bwStr-Root-AppError">Application error</xsl:variable>
  <xsl:variable name="bwStr-Root-AppErrorOccurred">An application error occurred.</xsl:variable>

  <!--  xsl:template name="header" -->
  <xsl:variable name="bwStr-Head-BedeworkPubEventsAdmin">Bedework Public Events Administration</xsl:variable>
  <xsl:variable name="bwStr-Head-CalendarSuite">Calendar Suite</xsl:variable>
  <xsl:variable name="bwStr-Head-None">none</xsl:variable>
  <xsl:variable name="bwStr-Head-Group">Group:</xsl:variable>
  <xsl:variable name="bwStr-Head-Change">change</xsl:variable>
  <xsl:variable name="bwStr-Head-LoggedInAs">Logged in as:</xsl:variable>
  <xsl:variable name="bwStr-Head-LogOut">log out</xsl:variable>
  <xsl:variable name="bwStr-Head-MainMenu">Main Menu</xsl:variable>
  <xsl:variable name="bwStr-Head-PendingEvents">Pending Queue</xsl:variable>
  <xsl:variable name="bwStr-Head-ApprovalQueueEvents">Approval Queue</xsl:variable>
  <xsl:variable name="bwStr-Head-SuggestionQueueEvents">Suggestion Queue</xsl:variable>
  <xsl:variable name="bwStr-Head-Users">Users</xsl:variable>
  <xsl:variable name="bwStr-Head-System">System</xsl:variable>
  <!-- notifications (in header) -->
  <xsl:variable name="bwStr-Notification-EventSuggestion">Suggestion:</xsl:variable>
  <xsl:variable name="bwStr-Notification-SuggestionTo">Suggestion to</xsl:variable>
  <xsl:variable name="bwStr-Notification-Awaiting">Awaiting approval:</xsl:variable>
  <xsl:variable name="bwStr-Notification-Accepted">accepted</xsl:variable>
  <xsl:variable name="bwStr-Notification-Rejected">rejected</xsl:variable>
  <xsl:variable name="bwStr-Notification-DeclinedLower">declined</xsl:variable>
  <xsl:variable name="bwStr-Notification-AcceptedResp">Accepted:</xsl:variable>
  <xsl:variable name="bwStr-Notification-Declined">Declined:</xsl:variable>
  <xsl:variable name="bwStr-Notification-Dismiss">dismiss</xsl:variable>
  <xsl:variable name="bwStr-Notification-ViewEvent">view event</xsl:variable>
  <xsl:variable name="bwStr-Notification-EventRemoved">--event removed--</xsl:variable>

  <!--  xsl:template name="messagesAndErrors" -->
  <!--  See bedework/resources/xsl for common library -->

  <!--  xsl:template name="mainMenu" -->
  <xsl:variable name="bwStr-MMnu-LoggedInAs">You are logged in as superuser.</xsl:variable>
  <xsl:variable name="bwStr-MMnu-YouMustBeOperating">You must be operating in the context of a calendar suite\nto add or manage events.\n\nYour current group is neither associated with a calendar suite\nnor a child of a group associated with a calendar suite.</xsl:variable>
  <xsl:variable name="bwStr-MMnu-AddEvent">Add Event</xsl:variable>
  <xsl:variable name="bwStr-MMnu-AddContact">Add Contact</xsl:variable>
  <xsl:variable name="bwStr-MMnu-AddLocation">Add Location</xsl:variable>
  <xsl:variable name="bwStr-MMnu-AddCategory">Add Category</xsl:variable>
  <xsl:variable name="bwStr-MMnu-ManageEvents">Manage Events</xsl:variable>
  <xsl:variable name="bwStr-MMnu-ManageContacts">Manage Contacts</xsl:variable>
  <xsl:variable name="bwStr-MMnu-ManageLocations">Manage Locations</xsl:variable>
  <xsl:variable name="bwStr-MMnu-ManageCategories">Manage Categories</xsl:variable>
  <xsl:variable name="bwStr-MMnu-EventSearch">Event search:</xsl:variable>
  <xsl:variable name="bwStr-MMnu-Go">go</xsl:variable>
  <xsl:variable name="bwStr-MMnu-Limit">Limit:</xsl:variable>
  <xsl:variable name="bwStr-MMnu-TodayForward">today forward</xsl:variable>
  <xsl:variable name="bwStr-MMnu-PastDates">past dates</xsl:variable>
  <xsl:variable name="bwStr-MMnu-AddDates">all dates</xsl:variable>

  <!--  xsl:template name="tabPendingEvents" -->
  <xsl:variable name="bwStr-TaPE-PendingEvents">Pending Queue</xsl:variable>
  <xsl:variable name="bwStr-TaPE-EventsAwaitingModeration">The following events are awaiting moderation:</xsl:variable>

  <!--  xsl:template name="tabApprovalQueueEvents" -->
  <xsl:variable name="bwStr-TaAQ-ApprovalQueueEvents">Approval Queue</xsl:variable>
  <xsl:variable name="bwStr-TaAQ-EventsAwaitingApproval">The following events are awaiting approval:</xsl:variable>

  <!--  xsl:template name="tabSuggestionQueueEvents" -->
  <xsl:variable name="bwStr-TaAQ-SuggestionQueueEvents">Suggestion Queue</xsl:variable>
  <xsl:variable name="bwStr-TaAQ-SuggestedEvents">The following events are suggested by other administrative groups for inclusion in your suite:</xsl:variable>
  <xsl:variable name="bwStr-TaAQ-View">View:</xsl:variable>
  <xsl:variable name="bwStr-TaAQ-Suggested">suggested</xsl:variable>
  <xsl:variable name="bwStr-TaAQ-Accepted">accepted</xsl:variable>
  <xsl:variable name="bwStr-TaAQ-Rejected">rejected</xsl:variable>
  <xsl:variable name="bwStr-TaAQ-Unknown">unknown</xsl:variable>

  <!--  xsl:template name="tabCalsuite" -->
  <xsl:variable name="bwStr-TaCS-ManageCalendarSuite">Manage Calendar Suite</xsl:variable>
  <xsl:variable name="bwStr-TaCS-CalendarSuite">Calendar Suite:</xsl:variable>
  <xsl:variable name="bwStr-TaCS-Group">Group:</xsl:variable>
  <xsl:variable name="bwStr-TaCS-Change">change</xsl:variable>
  <xsl:variable name="bwStr-TaCS-ManageSubscriptions">Manage subscriptions</xsl:variable>
  <xsl:variable name="bwStr-TaCS-ManageViews">Manage views</xsl:variable>
  <xsl:variable name="bwStr-TaCS-ManagePreferences">Manage preferences</xsl:variable>
  <xsl:variable name="bwStr-TaCS-ManageResources">Manage resources</xsl:variable>

  <!--  xsl:template name="tabUsers" -->
  <xsl:variable name="bwStr-TaUs-ManageUsersAndGroups">Manage Users &amp; Groups</xsl:variable>
  <xsl:variable name="bwStr-TaUs-ManageAdminRoles">Manage admin roles</xsl:variable>
  <xsl:variable name="bwStr-TaUs-ManageAdminGroups">Manage admin groups</xsl:variable>
  <xsl:variable name="bwStr-TaUs-ChangeGroup">Change group...</xsl:variable>
  <xsl:variable name="bwStr-TaUs-EditUsersPrefs">Edit user preferences (enter userid):</xsl:variable>
  <xsl:variable name="bwStr-TaUs-Go">go</xsl:variable>

  <!--  xsl:template name="tabSystem" -->
  <xsl:variable name="bwStr-TaSy-ManageSys">Manage System</xsl:variable>
  <xsl:variable name="bwStr-TaSy-ManageCalsAndFolders">Manage calendars &amp; folders</xsl:variable>
  <xsl:variable name="bwStr-TaSy-ManageCategories">Manage categories</xsl:variable>
  <xsl:variable name="bwStr-TaSy-ManageCalSuites">Manage calendar suites</xsl:variable>
  <xsl:variable name="bwStr-TaSy-UploadICalFile">Upload ical file</xsl:variable>
  <xsl:variable name="bwStr-TaSy-ManageSysPrefs">Manage system preferences</xsl:variable>
  <xsl:variable name="bwStr-TaSy-ManageSysTZs">Manage system timezones</xsl:variable>
  <xsl:variable name="bwStr-TaSy-Stats">Statistics:</xsl:variable>
  <xsl:variable name="bwStr-TaSy-AdminWebClient">admin web client</xsl:variable>
  <xsl:variable name="bwStr-TaSy-PublicWebClient">public web client</xsl:variable>
  <xsl:variable name="bwStr-TaSy-ManageCalDAVFilters">Manage CalDAV filters</xsl:variable>
  <xsl:variable name="bwStr-TaSy-ManageGlobalResources">Manage global resources</xsl:variable>

  <!--  xsl:template name="eventList" -->
  <xsl:variable name="bwStr-EvLs-ManageEvents">Manage Events</xsl:variable>
  <xsl:variable name="bwStr-EvLs-SelectEvent">Select the event that you would like to update:</xsl:variable>
  <xsl:variable name="bwStr-EvLs-PageTitle">Add new event</xsl:variable>
  <xsl:variable name="bwStr-EvLs-StartDate">Start Date:</xsl:variable>
  <xsl:variable name="bwStr-EvLs-Today">Today</xsl:variable>
  <xsl:variable name="bwStr-EvLs-Days">Days:</xsl:variable>
  <xsl:variable name="bwStr-EvLs-Show">Show:</xsl:variable>
  <xsl:variable name="bwStr-EvLs-Active">Active</xsl:variable>
  <xsl:variable name="bwStr-EvLs-All">All</xsl:variable>
  <xsl:variable name="bwStr-EvLs-Calendar">Calendar:</xsl:variable>
  <xsl:variable name="bwStr-EvLs-FilterBy">Filter by:</xsl:variable>
  <xsl:variable name="bwStr-EvLs-SortBy">Sort by:</xsl:variable>
  <xsl:variable name="bwStr-EvLs-SortByStart">Start Date</xsl:variable>
  <xsl:variable name="bwStr-EvLs-SortByModified">Modified Date</xsl:variable>
  <xsl:variable name="bwStr-EvLs-SortByCreated">Created Date</xsl:variable>
  <xsl:variable name="bwStr-EvLs-SelectCategory">select a category</xsl:variable>
  <xsl:variable name="bwStr-EvLs-ClearFilter">clear filter</xsl:variable>
  <xsl:variable name="bwStr-EvLs-Previous">Previous</xsl:variable>
  <xsl:variable name="bwStr-EvLs-Next">Next</xsl:variable>
  <xsl:variable name="bwStr-EvLs-PublicUrl">Public URL:</xsl:variable>

  <!--  xsl:template name="eventListCommon" -->
  <xsl:variable name="bwStr-EvLC-Title">Title</xsl:variable>
  <xsl:variable name="bwStr-EvLC-CalSuite">Suite</xsl:variable>
  <xsl:variable name="bwStr-EvLC-ClaimedBy">Claimed By</xsl:variable>
  <xsl:variable name="bwStr-EvLC-Start">Start</xsl:variable>
  <xsl:variable name="bwStr-EvLC-End">End</xsl:variable>
  <xsl:variable name="bwStr-EvLC-Suggested">Suggested</xsl:variable>
  <xsl:variable name="bwStr-EvLC-TopicalAreas">Topical Areas</xsl:variable>
  <xsl:variable name="bwStr-EvLC-Categories">Categories</xsl:variable>
  <xsl:variable name="bwStr-EvLC-Author">Author</xsl:variable>
  <xsl:variable name="bwStr-EvLC-Description">Description</xsl:variable>
  <xsl:variable name="bwStr-EvLC-NoEvents">No events to display</xsl:variable>
  <xsl:variable name="bwStr-EvLC-EventDeleted">Deleted</xsl:variable>

  <xsl:variable name="bwStr-EvLC-Page">Page</xsl:variable>
  <xsl:variable name="bwStr-EvLC-Of">of</xsl:variable>
  <xsl:variable name="bwStr-EvLC-Viewing">Viewing</xsl:variable>
  <xsl:variable name="bwStr-EvLC-EventsInA">events in a</xsl:variable>
  <xsl:variable name="bwStr-EvLC-DayWindow">day window</xsl:variable>

  <!--  xsl:template match="event" mode="eventListCommon" -->
  <xsl:variable name="bwStr-EvLC-NoTitle">no title</xsl:variable>
  <xsl:variable name="bwStr-EvLC-Unclaimed">unclaimed</xsl:variable>
  <xsl:variable name="bwStr-EvLC-ThisEventCrossTagged">This event is cross-tagged.</xsl:variable>
  <xsl:variable name="bwStr-EvLC-ShowTagsByOtherGroups">Show tags by other groups</xsl:variable>
  <xsl:variable name="bwStr-EvLC-RecurringEventEdit">Recurring event.  Edit:</xsl:variable>
  <xsl:variable name="bwStr-EvLC-Master">master</xsl:variable>
  <xsl:variable name="bwStr-EvLC-Instance">instance</xsl:variable>
  <xsl:variable name="bwStr-EvLC-Lastmod">Last modified:</xsl:variable>
  <xsl:variable name="bwStr-EvLC-Created">Created:</xsl:variable>
  <xsl:variable name="bwStr-EvLC-Cancelled">CANCELLED:</xsl:variable>
  <xsl:variable name="bwStr-EvLC-Tentative">TENTATIVE:</xsl:variable>
  <xsl:variable name="bwStr-EvLC-EditEvent">edit event</xsl:variable>
  <xsl:variable name="bwStr-EvLC-ShowPublicLink">show public link</xsl:variable>

  <!--  xsl:template match="formElements" mode="modEvent" -->
  <xsl:variable name="bwStr-AEEF-Recurrence">recurrence</xsl:variable>
  <xsl:variable name="bwStr-AEEF-RECURRANCE">Recurrence:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EventInfo">Event Information</xsl:variable>
  <xsl:variable name="bwStr-AEEF-YouMayTag">You may tag this event by selecting topical areas below.</xsl:variable>
  <xsl:variable name="bwStr-AEEF-TheFollowingEvent">The following event has been suggested for inclusion in your calendar suite.</xsl:variable>
  <xsl:variable name="bwStr-AEEF-SubmittedBy">Submitted by</xsl:variable>
  <xsl:variable name="bwStr-AEEF-SendMsg">send message</xsl:variable>
  <xsl:variable name="bwStr-AEEF-CommentsFromSubmitter">Comments from Submitter</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ShowHide">show/hide</xsl:variable>
  <xsl:variable name="bwStr-AEEF-PopUp">pop-up</xsl:variable>
  <xsl:variable name="bwStr-AEEF-For">for</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Title">Title:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Deleted">Deleted:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Type">Type:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Calendar">Calendar:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-SelectColon">Select:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-SubmittedEvents">submitted events</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Preferred">preferred</xsl:variable>
  <xsl:variable name="bwStr-AEEF-All">all</xsl:variable>
  <xsl:variable name="bwStr-AEEF-DateAndTime">Date &amp; Time:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-AllDay">all day</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Floating">floating</xsl:variable>
  <xsl:variable name="bwStr-AEEF-StoreAsUTC">store at UTC</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Start">Start:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-StartDateHour">start date hour</xsl:variable>
  <xsl:variable name="bwStr-AEEF-StartDateMinute">start date minute</xsl:variable>
  <xsl:variable name="bwStr-AEEF-StartDateAmPm">start date am/pm</xsl:variable>
  <xsl:variable name="bwStr-AEEF-StartDateTimezone">start date timezone</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Date">Date</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Due">Due:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-End">End:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EndDate">end date</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EndDateHour">end date hour</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EndDateMinute">end date minute</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EndDateAmPm">end date am/pm</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EndDateTimezone">end date timezone</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Duration">Duration</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Days">days</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Hours">hours</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Minutes">minutes</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Or">or</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Weeks">weeks</xsl:variable>
  <xsl:variable name="bwStr-AEEF-This">This</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Task">task</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Event">event</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Deadline">deadline</xsl:variable>
  <xsl:variable name="bwStr-AEEF-HasNoDurationEndDate">has no duration / end date</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ThisEventHasNoDurationEndDate">This event has no duration / end date</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Complete">Complete:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-AffectsFreeBusy">Affects free/busy:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Yes">yes</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Transparent">(transparent: event status does not affect your free/busy)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-No">no</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Opaque">(opaque: event status affects your free/busy)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Categories">Categories:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-NoCategoriesDefined">no categories defined</xsl:variable>
  <xsl:variable name="bwStr-AEEF-AddCategory">add category</xsl:variable>
  <xsl:variable name="bwStr-AEEF-SelectTimezone">select timezone...</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ThisEventRecurrenceInstance">This event is a recurrence instance.</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EditMasterEvent">edit master event</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EditPendingMasterEvent">edit or publish master event</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EditApprovalQueueMasterEvent">edit or approve master event</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EditMaster">edit master (recurring event)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EventRecurs">event recurs</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EventDoesNotRecur">event does not recur</xsl:variable>
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
  <xsl:variable name="bwStr-AEEF-Times">time(s)</xsl:variable>
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
  <xsl:variable name="bwStr-AEEF-Time">time</xsl:variable>
  <xsl:variable name="bwStr-AEEF-TIME">Time</xsl:variable>
  <xsl:variable name="bwStr-AEEF-TZid">TZid</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ExceptionDates">Exception Dates</xsl:variable>
  <xsl:variable name="bwStr-AEEF-NoExceptionDates">No exception dates</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ExceptionDatesMayBeCreated">Exception dates may be created by deleting an instance of a recurring event.</xsl:variable>
  <xsl:variable name="bwStr-AEEF-AddRecurance">add recurrence</xsl:variable>
  <xsl:variable name="bwStr-AEEF-AddException">add exception</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Status">Status:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Confirmed">confirmed</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Tentative">tentative</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Canceled">canceled</xsl:variable>
  <xsl:variable name="bwStr-AEEF-YesOpaque">yes (opaque)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-NoTransparent">no (transparent)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Description">Description:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EnterPertientInfo">Enter a brief description of the event</xsl:variable>
  <xsl:variable name="bwStr-AEEF-CharsMax">characters max.</xsl:variable>
  <xsl:variable name="bwStr-AEEF-CharsRemaining">character(s) remaining.</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Cost">Cost:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-OptionalPlaceToPurchaseTicks">optional: if any, and place to purchase tickets</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EventURL">Event URL:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-OptionalMoreEventInfo">optional link to more information about the event</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Image">Image:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ImageURL">Image URL:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ImageThumbURL">Thumbnail URL:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ImageUpload">-or- Upload image:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ImageDesc">Image description:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ImageAlt">Alt Text:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-OptionalEventImage">optional link to image</xsl:variable>
  <xsl:variable name="bwStr-AEEF-OptionalEventThumbImage">optional link to thumbnail for event lists, 80px wide</xsl:variable>
  <xsl:variable name="bwStr-AEEF-UseExisting">Use existing...</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Overwrite">Overwrite</xsl:variable>
  <xsl:variable name="bwStr-AEEF-OptionalImageUpload">Uploads can be JPG, PNG, or GIF and will overwrite the image and thumbnail URLs.</xsl:variable>
  <xsl:variable name="bwStr-AEEF-RemoveImages">remove images</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Location">Location:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Add">add</xsl:variable>
  <xsl:variable name="bwStr-AEEF-AddC">Add:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Address">Address:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-IncludeRoom">Please include room, building, and campus.</xsl:variable>
  <xsl:variable name="bwStr-AEEF-LocationURL">Location URL:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-OptionalLocaleInfo">(optional: for information about the location)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Contact">Contact:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Creator">Creator</xsl:variable>
  <xsl:variable name="bwStr-AEEF-TopicalArea">Topical area:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ContactName">Contact (name):</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ContactPhone">Contact Phone Number:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ContactURL">Contact's URL:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ContactEmail">Contact Email Address:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Registration">Registration:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-UsersMayRegister">Users may register for this event</xsl:variable>
  <xsl:variable name="bwStr-AEEF-InternalUsersMayRegister">Internal users may register for this event</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ExternalUsersMayRegister">External users may register for this event</xsl:variable>
  <xsl:variable name="bwStr-AEEF-MaxTickets">Max tickets:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-MaxWaitList">Max wait list:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-MaxTicketsInfo">(maximum number of tickets allowed for the event)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-MaxWaitListInfo">(maximum number of people on the wait list for the event. Integer or percent. Leave blank for no limit.)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-TicketsAllowed">Tickets allowed:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-TicketsAllowedInfo">(maximum number of tickets per user)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-RegistrationOpens">Registration opens:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-RegistrationOpensInfo">(date/time registration becomes available)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-RegistrationCloses">Registration closes:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-RegistrationClosesInfo">(date/time of registration cut off)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-CustomFields">Custom fields:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-CustomFieldsBlank">no custom fields defined</xsl:variable>
  <xsl:variable name="bwStr-AEEF-CustomFieldsRefresh">refresh</xsl:variable>
  <xsl:variable name="bwStr-AEEF-CustomFieldsRemove">remove</xsl:variable>
  <xsl:variable name="bwStr-AEEF-CustomFieldsManage">add / manage</xsl:variable>
  <xsl:variable name="bwStr-AEEF-CustomFieldsInfo">(custom form elements)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-CustomFieldsSelect">select custom field collection</xsl:variable>
  <xsl:variable name="bwStr-AEEF-CustomFieldsShowUnpublished">show unpublished</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ViewRegistrations">View registrations</xsl:variable>
  <xsl:variable name="bwStr-AEEF-DownloadRegistrations">Download registrations</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Optional">(optional)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Loading">loading...</xsl:variable>
  <xsl:variable name="bwStr-AEEF-AddressPrimary">Primary address:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-AddressSecondary">Secondary address:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-SelectOrSearch">select or search</xsl:variable>
  <xsl:variable name="bwStr-AEEF-AddRoom">Add Room</xsl:variable>
  <xsl:variable name="bwStr-AEEF-AddSecAddress">add a new secondary address</xsl:variable>
  <xsl:variable name="bwStr-AEEF-RoomSuiteArea">room, suite, or area</xsl:variable>
  <xsl:variable name="bwStr-AEEF-To">To:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-SuggestTo">Suggest To:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-SuggestionStatus">Suggestion Status:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ChangeGroup1">You are a member of "</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ChangeGroup2">", the group that created this event.<br/>If you wish to edit it fully, you must </xsl:variable>
  <xsl:variable name="bwStr-AEEF-ChangeGroup3">change groups.</xsl:variable>

  <!--  xsl:template match="calendar" mode="showEventFormAliases" -->

  <!--  xsl:template name="submitEventButtons" -->
  <xsl:variable name="bwStr-SEBu-SelectPublishCalendar">Select a calendar in which to publish this event:</xsl:variable>
  <xsl:variable name="bwStr-SEBu-Select">Select:</xsl:variable>
  <xsl:variable name="bwStr-SEBu-SubmittedEvents">submitted events</xsl:variable>
  <xsl:variable name="bwStr-SEBu-CalendarDescriptions">calendar descriptions</xsl:variable>
  <xsl:variable name="bwStr-SEBu-DeleteEvent">Delete Event</xsl:variable>
  <xsl:variable name="bwStr-SEBu-MarkEventDeleted">Mark Deleted</xsl:variable>
  <xsl:variable name="bwStr-SEBu-ReturnToList">Return to list</xsl:variable>
  <xsl:variable name="bwStr-SEBu-UpdateEvent">Update Event</xsl:variable>
  <xsl:variable name="bwStr-SEBu-PublishEvent">Publish Event</xsl:variable>
  <xsl:variable name="bwStr-SEBu-ApproveEvent">Approve Event</xsl:variable>
  <xsl:variable name="bwStr-SEBu-AcceptEvent">Accept Event</xsl:variable>
  <xsl:variable name="bwStr-SEBu-RejectEvent">Reject Event</xsl:variable>
  <xsl:variable name="bwStr-SEBu-Cancel">Cancel</xsl:variable>
  <xsl:variable name="bwStr-SEBu-ClaimEvent">Claim Event</xsl:variable>
  <xsl:variable name="bwStr-SEBu-AddEvent">Add Event</xsl:variable>
  <xsl:variable name="bwStr-SEBu-CopyEvent">Copy Event</xsl:variable>
  <xsl:variable name="bwStr-SEBu-ReleaseEvent">Release Event</xsl:variable>
  <xsl:variable name="bwStr-SEBu-Accept">Accept</xsl:variable>
  <xsl:variable name="bwStr-SEBu-Reject">Reject</xsl:variable>


  <!--  xsl:template match="val" mode="weekMonthYearNumbers" -->

  <!--  xsl:template name="byDayChkBoxList" -->

  <!--  xsl:template name="buildCheckboxList" -->

  <!--  xsl:template name="recurrenceDayPosOptions" -->
  <xsl:variable name="bwStr-RCPO-TheFirst">the first</xsl:variable>
  <xsl:variable name="bwStr-RCPO-TheSecond">the second</xsl:variable>
  <xsl:variable name="bwStr-RCPO-TheThird">the third</xsl:variable>
  <xsl:variable name="bwStr-RCPO-TheFourth">the fourth</xsl:variable>
  <xsl:variable name="bwStr-RCPO-TheFifth">the fifth</xsl:variable>
  <xsl:variable name="bwStr-RCPO-TheLast">the last</xsl:variable>
  <xsl:variable name="bwStr-RCPO-Every">every</xsl:variable>
  <xsl:variable name="bwStr-RCPO-None">none</xsl:variable>

  <!--  xsl:template name="buildRecurFields" -->
  <xsl:variable name="bwStr-BuRF-And">and</xsl:variable>

  <!--  xsl:template name="buildNumberOptions" -->

  <!--  xsl:template name="clock" -->
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

  <!--  xsl:template match="event" mode="displayEvent" -->
  <xsl:variable name="bwStr-DsEv-OkayToDelete">Ok to delete this event?</xsl:variable>
  <xsl:variable name="bwStr-DsEv-NoteDontEncourageDeletes">Note: we do not encourage deletion of old but correct events; we prefer to keep old events for historical reasons.  Please remove only those events that are truly erroneous.</xsl:variable>
  <xsl:variable name="bwStr-DsEv-AllDay">(all day)</xsl:variable>
  <xsl:variable name="bwStr-DsEv-YouDeletingPending">You are deleting a pending event.</xsl:variable>
  <xsl:variable name="bwStr-DsEv-YouDeletingApprovalQueue">You are deleting an entry on the approval queue.</xsl:variable>
  <xsl:variable name="bwStr-DsEv-SendNotification">Send notification to submitter</xsl:variable>
  <xsl:variable name="bwStr-DsEv-Reason">Reason (leave blank to exclude):</xsl:variable>
  <xsl:variable name="bwStr-DsEv-EventInfo">Event Information</xsl:variable>
  <xsl:variable name="bwStr-DsEv-Title">Title:</xsl:variable>
  <xsl:variable name="bwStr-DsEv-When">When:</xsl:variable>
  <xsl:variable name="bwStr-DsEv-TopicalAreas">Topical Areas:</xsl:variable>
  <xsl:variable name="bwStr-DsEv-Description">Description:</xsl:variable>
  <xsl:variable name="bwStr-DsEv-Price">Price:</xsl:variable>
  <xsl:variable name="bwStr-DsEv-URL">URL:</xsl:variable>
  <xsl:variable name="bwStr-DsEv-Location">Location:</xsl:variable>
  <xsl:variable name="bwStr-DsEv-Contact">Contact:</xsl:variable>
  <xsl:variable name="bwStr-DsEv-Owner">Owner:</xsl:variable>
  <xsl:variable name="bwStr-DsEv-Submitter">Submitter:</xsl:variable>
  <xsl:variable name="bwStr-DsEv-Calendar">Calendar:</xsl:variable>
  <xsl:variable name="bwStr-DsEv-Categories">Categories:</xsl:variable>
  <xsl:variable name="bwStr-DsEv-TagEvent">Tag or edit event</xsl:variable>
  <xsl:variable name="bwStr-DsEv-YesMarkDeleted">Yes: Mark Deleted</xsl:variable>
  <xsl:variable name="bwStr-DsEv-YesDeleteEvent">Yes: Delete Event</xsl:variable>
  <xsl:variable name="bwStr-DsEv-Cancel">Cancel</xsl:variable>

  <!--  xsl:template name="contactList" -->
  <xsl:variable name="bwStr-Cont-ManageContacts">Manage Contacts</xsl:variable>
  <xsl:variable name="bwStr-Cont-SelectContact">Select the contact you would like to update:</xsl:variable>
  <xsl:variable name="bwStr-Cont-Name">Name</xsl:variable>
  <xsl:variable name="bwStr-Cont-Phone">Phone</xsl:variable>
  <xsl:variable name="bwStr-Cont-Email">Email</xsl:variable>
  <xsl:variable name="bwStr-Cont-Status">Status</xsl:variable>
  <xsl:variable name="bwStr-Cont-URL">URL</xsl:variable>
  <xsl:variable name="bwStr-Cont-AddNewContact">Add new contact</xsl:variable>
  <xsl:variable name="bwStr-Cont-ListOfContacts">List of contacts</xsl:variable>

  <!--  xsl:template name="modContact" -->
  <xsl:variable name="bwStr-MdCo-ContactInfo">Contact Information</xsl:variable>
  <xsl:variable name="bwStr-MdCo-ContactName">Contact (name):</xsl:variable>
  <xsl:variable name="bwStr-MdCo-ContactName-Placeholder">e.g. name, group, or department</xsl:variable>
  <xsl:variable name="bwStr-MdCo-ContactPhone">Contact Phone Number:</xsl:variable>
  <xsl:variable name="bwStr-MdCo-ContactPhone-Placeholder">e.g. 555-555-5555</xsl:variable>
  <xsl:variable name="bwStr-MdCo-ContactURL">Contact's URL:</xsl:variable>
  <xsl:variable name="bwStr-MdCo-ContactURL-Placeholder">link to more information</xsl:variable>
  <xsl:variable name="bwStr-MdCo-ContactEmail">Contact Email Address:</xsl:variable>
  <xsl:variable name="bwStr-MdCo-ContactDeleted">Deleted:</xsl:variable>
  <xsl:variable name="bwStr-MdCo-Optional">(optional)</xsl:variable>

  <!--  xsl:template name="deleteContactConfirm" -->
  <xsl:variable name="bwStr-DCoC-OKToDelete">Ok to delete this contact?</xsl:variable>
  <xsl:variable name="bwStr-DCoC-Name">Name</xsl:variable>
  <xsl:variable name="bwStr-DCoC-Phone">Phone</xsl:variable>
  <xsl:variable name="bwStr-DCoC-Email">Email</xsl:variable>
  <xsl:variable name="bwStr-DCoC-URL">URL</xsl:variable>
  <xsl:variable name="bwStr-DCoC-DeleteContact">Delete Contact</xsl:variable>
  <xsl:variable name="bwStr-DCoC-UpdateContact">Update Contact</xsl:variable>
  <xsl:variable name="bwStr-DCoC-AddContact">Add Contact</xsl:variable>
  <xsl:variable name="bwStr-DCoC-Cancel">Cancel</xsl:variable>

  <!--  xsl:template name="contactReferenced" -->
  <xsl:variable name="bwStr-DCoR-ContactInUse">Contact In Use</xsl:variable>
  <xsl:variable name="bwStr-DCoR-ContactInUseBy">The contact is in use by events and cannot be deleted. Please contact a superuser.</xsl:variable>
  <xsl:variable name="bwStr-DCoR-Collections">Collections:</xsl:variable>
  <xsl:variable name="bwStr-DCoR-Events">Events:</xsl:variable>
  <xsl:variable name="bwStr-DCoR-SuperUserMsg">The contact is referenced by the items below (<em>superusers only</em>)</xsl:variable>

  <!--  xsl:template name="locationList" -->
  <xsl:variable name="bwStr-LoLi-ManageLocations">Manage Locations</xsl:variable>
  <xsl:variable name="bwStr-LoLi-SelectLocationToUpdate">Select the location that you would like to update:</xsl:variable>
  <xsl:variable name="bwStr-LoLi-Name">Name</xsl:variable>
  <xsl:variable name="bwStr-LoLi-Room">Room</xsl:variable>
  <xsl:variable name="bwStr-LoLi-Address">Address</xsl:variable>
  <xsl:variable name="bwStr-LoLi-SubAddress">Subaddress</xsl:variable>
  <xsl:variable name="bwStr-LoLi-Status">Status</xsl:variable>
  <xsl:variable name="bwStr-LoLi-URL">URL</xsl:variable>
  <xsl:variable name="bwStr-LoLi-AddNewLocation">Add new location</xsl:variable>

  <!--  xsl:template name="modLocation" -->
  <xsl:variable name="bwStr-MoLo-AddLocation">Add Location</xsl:variable>
  <xsl:variable name="bwStr-MoLo-UpdateLocation">Update Location</xsl:variable>
  <xsl:variable name="bwStr-MoLo-Name">Name:</xsl:variable>
  <xsl:variable name="bwStr-MoLo-Name-Placeholder">building or location name</xsl:variable>
  <xsl:variable name="bwStr-MoLo-Address">Address:</xsl:variable>
  <xsl:variable name="bwStr-MoLo-Address-Placeholder"></xsl:variable>
  <xsl:variable name="bwStr-MoLo-Address-Info"></xsl:variable>
  <xsl:variable name="bwStr-MoLo-SubAddress">Subaddress:</xsl:variable>
  <xsl:variable name="bwStr-MoLo-SubAddress-Placeholder">supplimental address information</xsl:variable>
  <xsl:variable name="bwStr-MoLo-Street">Street:</xsl:variable>
  <xsl:variable name="bwStr-MoLo-Street-Placeholder"></xsl:variable>
  <xsl:variable name="bwStr-MoLo-City">City:</xsl:variable>
  <xsl:variable name="bwStr-MoLo-City-Placeholder"></xsl:variable>
  <xsl:variable name="bwStr-MoLo-State">State:</xsl:variable>
  <xsl:variable name="bwStr-MoLo-State-Placeholder"></xsl:variable>
  <xsl:variable name="bwStr-MoLo-PostalCode">Zip:</xsl:variable>
  <xsl:variable name="bwStr-MoLo-PostalCode-Placeholder"></xsl:variable>
  <xsl:variable name="bwStr-MoLo-Room">Room:</xsl:variable>
  <xsl:variable name="bwStr-MoLo-Room-Placeholder">room number, suite number, or area</xsl:variable>
  <xsl:variable name="bwStr-MoLo-Optional">(optional)</xsl:variable>
  <xsl:variable name="bwStr-MoLo-Code">Building/Location ID:</xsl:variable>
  <xsl:variable name="bwStr-MoLo-Code-Placeholder"></xsl:variable>
  <xsl:variable name="bwStr-MoLo-AlternateAddress">Alternate address:</xsl:variable>
  <xsl:variable name="bwStr-MoLo-AlternateAddress-Placeholder">alternate address information</xsl:variable>
  <xsl:variable name="bwStr-MoLo-SubField1">Subfield 1:</xsl:variable>
  <xsl:variable name="bwStr-MoLo-SubField1-Placeholder"></xsl:variable>
  <xsl:variable name="bwStr-MoLo-SubField2">Map URL:</xsl:variable>
  <xsl:variable name="bwStr-MoLo-SubField2-Placeholder">full URL to map</xsl:variable>
  <xsl:variable name="bwStr-MoLo-LocationURL">Location's URL:</xsl:variable>
  <xsl:variable name="bwStr-MoLo-LocationURL-Placeholder">link to more information</xsl:variable>
  <xsl:variable name="bwStr-MoLo-GeoUri">GEO URI:</xsl:variable>
  <xsl:variable name="bwStr-MoLo-GeoUri-Placeholder"></xsl:variable>
  <xsl:variable name="bwStr-MoLo-Deleted">Deleted:</xsl:variable>
  <xsl:variable name="bwStr-MoLo-LocationAccessible">Wheelchair accessible</xsl:variable>
  <xsl:variable name="bwStr-MoLo-DeleteLocation">Delete Location</xsl:variable>
  <xsl:variable name="bwStr-MoLo-Cancel">Cancel</xsl:variable>

  <!--  xsl:template name="deleteLocationConfirm" -->
  <xsl:variable name="bwStr-DeLC-OkDeleteLocation">Ok to delete this location?</xsl:variable>
  <xsl:variable name="bwStr-DeLC-Address">Address:</xsl:variable>
  <xsl:variable name="bwStr-DeLC-SubAddress">Subaddress:</xsl:variable>
  <xsl:variable name="bwStr-DeLC-LocationURL">Location's URL:</xsl:variable>

  <!--  xsl:template name="locationReferenced" -->
  <xsl:variable name="bwStr-DeLR-LocationInUse">Location In Use</xsl:variable>
  <xsl:variable name="bwStr-DeLR-LocationInUseBy">The location is in use by events and cannot be deleted. Please contact a superuser.</xsl:variable>
  <xsl:variable name="bwStr-DeLR-Collections">Collections:</xsl:variable>
  <xsl:variable name="bwStr-DeLR-Events">Events:</xsl:variable>
  <xsl:variable name="bwStr-DeLR-SuperUserMsg">The location is referenced by the items below (<em>superusers only</em>)</xsl:variable>

  <!--  xsl:template name="categoryList" -->
  <xsl:variable name="bwStr-CtgL-ManageCategories">Manage Categories</xsl:variable>
  <xsl:variable name="bwStr-CtgL-SelectCategory">Select the category you would like to update:</xsl:variable>
  <xsl:variable name="bwStr-CtgL-AddNewCategory">Add new category</xsl:variable>
  <xsl:variable name="bwStr-CtgL-Keyword">Keyword</xsl:variable>
  <xsl:variable name="bwStr-CtgL-Description">Description</xsl:variable>
  <xsl:variable name="bwStr-CtgL-Status">Status</xsl:variable>

  <!--  xsl:template name="modCategory" -->
  <xsl:variable name="bwStr-MoCa-AddCategory">Add Category</xsl:variable>
  <xsl:variable name="bwStr-MoCa-Keyword">Keyword:</xsl:variable>
  <xsl:variable name="bwStr-MoCa-Description">Description:</xsl:variable>
  <xsl:variable name="bwStr-MoCa-Deleted">Deleted:</xsl:variable>
  <xsl:variable name="bwStr-MoCa-Cancel">Cancel</xsl:variable>
  <xsl:variable name="bwStr-MoCa-UpdateCategory">Update Category</xsl:variable>
  <xsl:variable name="bwStr-MoCa-DeleteCategory">Delete Category</xsl:variable>

  <!--  xsl:template name="deleteCategoryConfirm" -->
  <xsl:variable name="bwStr-DeCC-CategoryDeleteOK">Ok to delete this category?</xsl:variable>
  <xsl:variable name="bwStr-DeCC-Keyword">Keyword:</xsl:variable>
  <xsl:variable name="bwStr-DeCC-Description">Description:</xsl:variable>
  <xsl:variable name="bwStr-DeCC-YesDelete">Yes: Delete Category</xsl:variable>
  <xsl:variable name="bwStr-DeCC-NoCancel">No: Cancel</xsl:variable>

  <!--  xsl:template name="categoryReferenced" -->
  <xsl:variable name="bwStr-DeCR-CategoryInUse">Category In Use</xsl:variable>
  <xsl:variable name="bwStr-DeCR-CategoryInUseBy">The category is in use by collections and/or events and cannot be deleted. Please contact a superuser.</xsl:variable>
  <xsl:variable name="bwStr-DeCR-Collections">Collections:</xsl:variable>
  <xsl:variable name="bwStr-DeCR-Events">Events:</xsl:variable>
  <xsl:variable name="bwStr-DeCR-EventsNote">Note: if you do not edit the event from the original calendar suite, you may not see the associated topical area that sets the category on the event.</xsl:variable>
  <xsl:variable name="bwStr-DeCR-SuperUserMsg">The categories are referenced by the items below (<em>superusers only</em>)</xsl:variable>

  <!--  xsl:template name="categorySelectionWidget" -->
  <xsl:variable name="bwStr-CaSW-ShowHideUnusedCategories">show/hide unused categories</xsl:variable>

  <!--  xsl:template match="calendars" mode="calendarCommon" -->
  <xsl:variable name="bwStr-Cals-Collections">Collections</xsl:variable>
  <xsl:variable name="bwStr-Cals-SelectByPath">Select by path:</xsl:variable>
  <xsl:variable name="bwStr-Cals-PublicTree">Public Tree</xsl:variable>
  <xsl:variable name="bwStr-Cals-Go">go</xsl:variable>

  <!--  xsl:template match="calendar" mode="listForUpdate" -->
  <xsl:variable name="bwStr-Cals-Alias">alias</xsl:variable>
  <xsl:variable name="bwStr-Cals-Folder">folder</xsl:variable>
  <xsl:variable name="bwStr-Cals-Calendar">calendar</xsl:variable>
  <xsl:variable name="bwStr-Cals-Add">add a calendar or folder</xsl:variable>

  <!--  xsl:template match="calendar" mode="listForDisplay" -->

  <!--  xsl:template match="calendar" mode="listForMove" -->

  <!--  xsl:template match="currentCalendar" mode="addCalendar" -->
  <xsl:variable name="bwStr-CuCa-AddCalFileOrSub">Add Calendar, Folder, or Subscription</xsl:variable>
  <xsl:variable name="bwStr-CuCa-NoteAccessSet">Note: Access may be set on a calendar after it is created.</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Name">System Name:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Summary">Display Name:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Description">Description:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Filter">Filter:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-ShowHideCategoriesFiltering">show/hide categories for filtering on output</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Categories">Categories:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-ShowHideCategoriesAutoTagging">show/hide categories for auto-tagging on input</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Type">Type:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Calendar">calendar</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Folder">folder</xsl:variable>
  <xsl:variable name="bwStr-CuCa-FOLDER">Folder</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Subscription">subscription</xsl:variable>
  <xsl:variable name="bwStr-CuCa-SubscriptionCanCreateEprops">Allow Location etc create?</xsl:variable>
  <xsl:variable name="bwStr-CuCa-SubscriptionXcategories">Process categories?</xsl:variable>
  <xsl:variable name="bwStr-CuCa-SubscriptionXlocXcontact">Process Locations and Contacts?</xsl:variable>
  <xsl:variable name="bwStr-CuCa-SubscriptionRefresh">Refresh rate: minutes?</xsl:variable>
  <xsl:variable name="bwStr-CuCa-SubscriptionURL">Subscription URL</xsl:variable>
  <xsl:variable name="bwStr-CuCa-URLToCalendar">URL to calendar:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-ID">ID (if required):</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Password">Password (if required):</xsl:variable>
  <xsl:variable name="bwStr-CuCa-OrgSync">Select for orgSync subscription:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-OrgSyncPublicOnly">Select for only events marked public:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-OrgSyncLocKey">Locations key name:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-NoteAliasCanBeAdded">Note: An alias can be added to a Bedework calendar using a URL of the form:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Add">Add</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Cancel">Cancel</xsl:variable>

  <!--  xsl:template match="currentCalendar" mode="modCalendar" -->
  <xsl:variable name="bwStr-CuCa-ModifySubscription">Modify Subscription</xsl:variable>
  <xsl:variable name="bwStr-CuCa-ModifyFolder">Modify Folder</xsl:variable>
  <xsl:variable name="bwStr-CuCa-ModifyCalendar">Modify Calendar</xsl:variable>
  <xsl:variable name="bwStr-CuCa-TopicalArea">Topical Area:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-True">true</xsl:variable>
  <xsl:variable name="bwStr-CuCa-False">false</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Display">Display:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-DisplayItemsInCollection">display items in this collection</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Disabled">Disabled:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-DisabledLabel">disabled</xsl:variable>
  <xsl:variable name="bwStr-CuCa-EnabledLabel">enabled</xsl:variable>
  <xsl:variable name="bwStr-CuCa-ItemIsInaccessible">This item is inaccessible and has been disabled.  You may re-enable it to try again.</xsl:variable>
  <xsl:variable name="bwStr-CuCa-URL">URL:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-CurrentAccess">Current Access:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-UpdateSubscription">Update Subscription</xsl:variable>
  <xsl:variable name="bwStr-CuCa-UpdateFolder">Update Folder</xsl:variable>
  <xsl:variable name="bwStr-CuCa-UpdateCalendar">Update Calendar</xsl:variable>

  <!--  xsl:template name="calendarList" -->
  <xsl:variable name="bwStr-CaLi-ManageCalendarsAndFolders">Manage Calendars &amp; Folders</xsl:variable>
  <xsl:variable name="bwStr-CaLi-SelectItemFromPublicTree">Select an item from the Public Tree on the left to modify a calendar or folder</xsl:variable>
  <xsl:variable name="bwStr-CaLi-SelectThe">Select the</xsl:variable>
  <xsl:variable name="bwStr-CaLi-IconToAdd">icon to add a new calendar or folder to the tree.</xsl:variable>
  <xsl:variable name="bwStr-CaLi-FoldersMayContain">Folders may only contain calendars and subfolders.</xsl:variable>
  <xsl:variable name="bwStr-CaLi-CalendarsMayContain">Calendars may only contain events (and other calendar items).</xsl:variable>
  <xsl:variable name="bwStr-CaLi-RetrieveCalendar">Retrieve a calendar or folder directly by its path using the form to the left.</xsl:variable>

  <!--  xsl:template name="calendarDescriptions" -->
  <xsl:variable name="bwStr-CaLD-CalendarInfo">Calendar Information</xsl:variable>
  <xsl:variable name="bwStr-CaLD-SelectItemFromCalendarTree">Select an item from the calendar tree on the left to view all information about that calendar or folder.  The tree on the left represents the calendar heirarchy.</xsl:variable>
  <xsl:variable name="bwStr-CaLD-Name">System Name:</xsl:variable>
  <xsl:variable name="bwStr-CaLD-Path">Path:</xsl:variable>
  <xsl:variable name="bwStr-CaLD-Summary">Display Name:</xsl:variable>
  <xsl:variable name="bwStr-CaLD-Description">Description:</xsl:variable>

  <!--  xsl:template match="currentCalendar" mode="displayCalendar" -->
  <xsl:variable name="bwStr-CuCa-RemoveSubscription">Remove Subscription</xsl:variable>
  <xsl:variable name="bwStr-CuCa-FollowingSubscriptionRemoved">The following subscription will be removed. Continue?</xsl:variable>
  <xsl:variable name="bwStr-CuCa-DeleteFolder">Delete Folder</xsl:variable>
  <xsl:variable name="bwStr-CuCa-FollowingFolderDeleted">The following folder <em>and all its contents</em> will be deleted.  Continue?</xsl:variable>
  <xsl:variable name="bwStr-CuCa-DeleteCalendar">Delete Calendar</xsl:variable>
  <xsl:variable name="bwStr-CuCa-FollowingCalendarDeleted">The following calendar <em>and all its contents</em> will be deleted.  Continue?</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Path">Path:</xsl:variable>

  <!--  xsl:template match="currentCalendar" mode="deleteCalendarConfirm" -->
  <xsl:variable name="bwStr-CuCa-YesRemoveSubscription">Yes: Remove Subscription!</xsl:variable>
  <xsl:variable name="bwStr-CuCa-YesDeleteFolder">Yes: Delete Folder!</xsl:variable>
  <xsl:variable name="bwStr-CuCa-YesDeleteCalendar">Yes: Delete Calendar!</xsl:variable>

 <!--  xsl:template name="selectCalForEvent" -->
  <xsl:variable name="bwStr-SCFE-SelectCal">Select a calendar</xsl:variable>
  <xsl:variable name="bwStr-SCFE-Calendars">Calendars</xsl:variable>

  <!--  xsl:template match="calendar" mode="selectCalForEventCalTree" -->

  <!--  xsl:template name="calendarMove" -->
  <xsl:variable name="bwStr-CaMv-MoveCalendar">Move Calendar/Folder</xsl:variable>
  <xsl:variable name="bwStr-CaMv-CurrentPath">Current Path:</xsl:variable>
  <xsl:variable name="bwStr-CaMv-Name">System Name:</xsl:variable>
  <xsl:variable name="bwStr-CaMv-MailingListID">Mailing List ID:</xsl:variable>
  <xsl:variable name="bwStr-CaMv-Summary">Display Name:</xsl:variable>
  <xsl:variable name="bwStr-CaMv-Description">Description:</xsl:variable>
  <xsl:variable name="bwStr-CaMv-SelectNewParentFolder">Select a new parent folder:</xsl:variable>

  <!--  xsl:template name="schedulingAccessForm" -->
  <xsl:variable name="bwStr-ScAF-User">user</xsl:variable>
  <xsl:variable name="bwStr-ScAF-Group">group</xsl:variable>
  <xsl:variable name="bwStr-ScAF-Or">or</xsl:variable>
  <xsl:variable name="bwStr-ScAF-Owner">owner</xsl:variable>
  <xsl:variable name="bwStr-ScAF-AuthenticatedUsers">authenticated users</xsl:variable>
  <xsl:variable name="bwStr-ScAF-Anyone">anyone</xsl:variable>
  <xsl:variable name="bwStr-ScAF-AllScheduling">all scheduling</xsl:variable>
  <xsl:variable name="bwStr-ScAF-SchedReplies">scheduling replies</xsl:variable>
  <xsl:variable name="bwStr-ScAF-FreeBusyReqs">free-busy requests</xsl:variable>
  <xsl:variable name="bwStr-ScAF-SchedReqs">scheduling requests</xsl:variable>
  <xsl:variable name="bwStr-ScAF-Update">Update</xsl:variable>
  <xsl:variable name="bwStr-ScAF-Cancel">cancel</xsl:variable>

  <!--  xsl:template match="acl" mode="currentAccess" -->
  <xsl:variable name="bwStr-ACLs-CurrentAccess">Current Access:</xsl:variable>
  <xsl:variable name="bwStr-ACLs-Entry">Entry</xsl:variable>
  <xsl:variable name="bwStr-ACLs-Access">Access</xsl:variable>
  <xsl:variable name="bwStr-ACLs-InheritedFrom">Inherited from</xsl:variable>
  <xsl:variable name="bwStr-ACLs-User">user</xsl:variable>
  <xsl:variable name="bwStr-ACLs-Group">group</xsl:variable>
  <xsl:variable name="bwStr-ACLs-Auth">auth</xsl:variable>
  <xsl:variable name="bwStr-ACLs-UnAuth">unauth</xsl:variable>
  <xsl:variable name="bwStr-ACLs-All">all</xsl:variable>
  <xsl:variable name="bwStr-ACLs-Other">other</xsl:variable>
  <xsl:variable name="bwStr-ACLs-Anyone">anyone (other)</xsl:variable>
  <xsl:variable name="bwStr-ACLs-Grant">grant:</xsl:variable>
  <xsl:variable name="bwStr-ACLs-Deny">deny:</xsl:variable>
  <xsl:variable name="bwStr-ACLs-Local">local</xsl:variable>

  <!--  xsl:template match="calendars" mode="subscriptions" -->

  <!--  xsl:template name="subscriptionIntro" -->
  <xsl:variable name="bwStr-Subs-Subscriptions">Subscriptions</xsl:variable>
  <xsl:variable name="bwStr-Subs-ManagingSubscriptions">Managing Subscriptions</xsl:variable>
  <xsl:variable name="bwStr-Subs-SelectAnItem">Select an item from the tree on the left to modify a subscription.</xsl:variable>
  <xsl:variable name="bwStr-Subs-SelectThe">Select the</xsl:variable>
  <xsl:variable name="bwStr-Subs-IconToAdd">icon to add a new subscription or folder to the tree.</xsl:variable>
  <xsl:variable name="bwStr-Subs-TopicalAreasNote"><ul>
    <li><strong>Topical Areas:</strong><ul><li>
          A subscription marked as a "Topical Area" will be presented to event administrators when creating events.
          These are used for input (tagging) and output (if added to a view).
        </li>
        <li>
          A subscription not marked as a "Topical Area" can be used in Views,
          but will not appear when creating events.  Such subscriptions are used for output only,
          e.g. an ical feed of holidays from an external source.
        </li>
    </ul></li></ul></xsl:variable>

  <!--  xsl:template match="calendar" mode="listForUpdateSubscription" -->
  <xsl:variable name="bwStr-Cals-AddSubscription">add a subscription</xsl:variable>

  <!--  xsl:template match="currentCalendar" mode="addSubscription" -->
  <xsl:variable name="bwStr-CuCa-AddSubscription">Add Subscription</xsl:variable>
  <xsl:variable name="bwStr-CuCa-AccessNote">Note: Access may be set on a subscription after it is created.</xsl:variable>
  <xsl:variable name="bwStr-CuCa-PublicAlias">Public alias</xsl:variable>
  <xsl:variable name="bwStr-CuCa-SelectPublicCalOrFolder">Select a public calendar or folder</xsl:variable>

  <!--  xsl:template match="calendar" mode="selectCalForPublicAliasCalTree" -->
  <xsl:variable name="bwStr-Cals-Trash">trash</xsl:variable>

  <!--  xsl:template match="currentCalendar" mode="deleteSubConfirm" -->

  <!-- xsl:template name="listResources" -->
  <xsl:variable name="bwStr-Resource-ManageResources">Manage Resources</xsl:variable>
  <xsl:variable name="bwStr-Resource-ManageResources-Global">Manage Global Resources</xsl:variable>
  <xsl:variable name="bwStr-Resource-ResourcesAre">Resources are files created for and owned by the calendar suite.  They can be CSS, images, or snippets of XML and are unique to each calendar suite.</xsl:variable>
  <xsl:variable name="bwStr-Resource-ResourcesAre-Global">Resources are files created for use by all calendar suites (or any other purpose).  They can be CSS, images, or snippets of XML and are stored in a global area in caldav.</xsl:variable>
  <xsl:variable name="bwStr-Resource-AddNewResource">Add a new resource</xsl:variable>
  <xsl:variable name="bwStr-Resource-Resources">Resources</xsl:variable>
  <xsl:variable name="bwStr-Resource-NameCol">Name</xsl:variable>
  <xsl:variable name="bwStr-Resource-ContentTypeCol">Content Type:</xsl:variable>
  <xsl:variable name="bwStr-Resource-ResourceTypeCol">Resource Type:</xsl:variable>
  <xsl:variable name="bwStr-Resource-ResourceClassCol">Class</xsl:variable>
  <xsl:variable name="bwStr-Resource-Text">Text</xsl:variable>
  <xsl:variable name="bwStr-Resource-NameLabel">Name:</xsl:variable>
  <xsl:variable name="bwStr-Resource-ContentTypeLabel">Content Type:</xsl:variable>
  <xsl:variable name="bwStr-Resource-ResourceTypeLabel">Resource Type:</xsl:variable>
  <xsl:variable name="bwStr-Resource-ClassLabel">Class:</xsl:variable>
  <xsl:variable name="bwStr-Resource-CalendarSuite">Calendar Suite</xsl:variable>
  <xsl:variable name="bwStr-Resource-Admin">Admin</xsl:variable>
  <xsl:variable name="bwStr-Resource-ResourceURL">Resource URL</xsl:variable>

  <!-- xsl:template name="modResource" -->
  <xsl:variable name="bwStr-ModRes-AddResource">Add Resource</xsl:variable>
  <xsl:variable name="bwStr-ModRes-UpdateResource">Update Resource</xsl:variable>
  <xsl:variable name="bwStr-ModRes-EditResource">Edit Resource</xsl:variable>
  <xsl:variable name="bwStr-ModRes-ClickToDownload">Click here to download the current resource content</xsl:variable>
  <xsl:variable name="bwStr-ModRes-NameLabel">Name:</xsl:variable>
  <xsl:variable name="bwStr-ModRes-ContentTypeLabel">Content Type:</xsl:variable>
  <xsl:variable name="bwStr-ModRes-ResourceTypeLabel">Resource Type:</xsl:variable>
  <xsl:variable name="bwStr-ModRes-ClassLabel">Class:</xsl:variable>
  <xsl:variable name="bwStr-ModRes-ResourceContentLabel">Resource Content:</xsl:variable>
  <xsl:variable name="bwStr-ModRes-UploadLabel">Upload Content:</xsl:variable>
  <xsl:variable name="bwStr-ModRes-RemoveResource">Remove Resource</xsl:variable>
  <xsl:variable name="bwStr-ModRes-BackToList">Back to Resource List</xsl:variable>

  <!-- xsl:template name="modResource: featured events strings" -->
  <xsl:variable name="bwStr-ModRes-FeaturedEventsAdmin">Featured Events Admin</xsl:variable>
  <xsl:variable name="bwStr-ModRes-UpdateFeaturedEvents">Update Featured Events</xsl:variable>
  <xsl:variable name="bwStr-ModRes-RemoveFeaturedEvents">Remove Featured Events</xsl:variable>
  <xsl:variable name="bwStr-ModRes-FeaturedEvents">Featured events:</xsl:variable>
  <xsl:variable name="bwStr-ModRes-FeEnabled">enabled</xsl:variable>
  <xsl:variable name="bwStr-ModRes-FeDisabled">disabled</xsl:variable>
  <xsl:variable name="bwStr-ModRes-FeMode">Mode:</xsl:variable>
  <xsl:variable name="bwStr-ModRes-FeTriptychMode">triptych mode (3 panels, 241 x 189 pixels)</xsl:variable>
  <xsl:variable name="bwStr-ModRes-FeSingleMode">single mode (1 panel 725 x 189 pixels)</xsl:variable>
  <xsl:variable name="bwStr-ModRes-FeActive">active</xsl:variable>
  <xsl:variable name="bwStr-ModRes-FePanels">Triptych panels:</xsl:variable>
  <xsl:variable name="bwStr-ModRes-FeImageUrl">Image URL:</xsl:variable>
  <xsl:variable name="bwStr-ModRes-FeLink">Link:</xsl:variable>
  <xsl:variable name="bwStr-ModRes-FeTooltip">Tooltip:</xsl:variable>
  <xsl:variable name="bwStr-ModRes-FeSinglePanel">Single panel:</xsl:variable>
  <xsl:variable name="bwStr-ModRes-FeGenericPanels">Generic panels (when featured events are disabled):</xsl:variable>

  <!--  xsl:template name="deleteResourceConfirm" -->
  <xsl:variable name="bwStr-DelRes-RemoveResource">Remove Resource?</xsl:variable>
  <xsl:variable name="bwStr-DelRes-TheResource">The resource</xsl:variable>
  <xsl:variable name="bwStr-DelRes-WillBeRemoved">will be removed.</xsl:variable>
  <xsl:variable name="bwStr-DelRes-BeForewarned">Be forewarned: if caching is enabled, removing resources from a production system can cause the public interface to behave inconsistently.</xsl:variable>
  <xsl:variable name="bwStr-DelRes-Continue">Continue?</xsl:variable>
  <xsl:variable name="bwStr-DelRes-YesRemoveView">Yes: Remove Resource</xsl:variable>
  <xsl:variable name="bwStr-DelRes-Cancel">No: Cancel</xsl:variable>

  <!--  xsl:template match="views" mode="viewList" -->
  <xsl:variable name="bwStr-View-ManageViews">Manage Views</xsl:variable>
  <xsl:variable name="bwStr-View-ViewsAreNamedAggr">Views are named aggregations of subscriptions used to display sets of events within a calendar suite.</xsl:variable>
  <xsl:variable name="bwStr-View-AddNewView">Add a new view</xsl:variable>
  <xsl:variable name="bwStr-View-Views">Views</xsl:variable>
  <xsl:variable name="bwStr-View-Name">Name</xsl:variable>
  <xsl:variable name="bwStr-View-IncludedSubscriptions">Included subscriptions</xsl:variable>

  <!--  xsl:template name="modView" -->
  <xsl:variable name="bwStr-ModV-UpdateView">Update View</xsl:variable>
  <xsl:variable name="bwStr-ModV-InSomeConfigs">In some configurations, changes made here will not show up in the calendar suite until the cache is flushed (approx. 5 minutes) or you start a new session (e.g. clear your cookies).</xsl:variable>
  <xsl:variable name="bwStr-ModV-DeletingAView">Deleting a view on a production system should be followed by a server restart to clear the cache for all users.</xsl:variable>
  <xsl:variable name="bwStr-ModV-ToSeeUnderlying">To see underlying subscriptions in a local folder, open the folder in the</xsl:variable>
  <xsl:variable name="bwStr-ModV-ManageSubscriptions">Manage Subscriptions</xsl:variable>
  <xsl:variable name="bwStr-ModV-Tree">tree (this will be improved in a later version...).</xsl:variable>
  <xsl:variable name="bwStr-ModV-IfYouInclude">If you include a folder in a view, you do not need to include its children.</xsl:variable>
  <xsl:variable name="bwStr-ModV-AvailableSubscriptions">Available subscriptions:</xsl:variable>
  <xsl:variable name="bwStr-ModV-ActiveSubscriptions">Active subscriptions:</xsl:variable>
  <xsl:variable name="bwStr-ModV-DeleteView">Delete View</xsl:variable>
  <xsl:variable name="bwStr-ModV-ReturnToViewsListing">Return to Views Listing</xsl:variable>

  <!--  xsl:template name="deleteViewConfirm" -->
  <xsl:variable name="bwStr-DeVC-RemoveView">Remove View?</xsl:variable>
  <xsl:variable name="bwStr-DeVC-TheView">The view</xsl:variable>
  <xsl:variable name="bwStr-DeVC-WillBeRemoved">will be removed.</xsl:variable>
  <xsl:variable name="bwStr-DeVC-BeForewarned">Be forewarned: if caching is enabled, removing views from a production system can cause the public interface to throw errors until the cache is flushed (a few minutes).</xsl:variable>
  <xsl:variable name="bwStr-DeVC-Continue">Continue?</xsl:variable>
  <xsl:variable name="bwStr-DeVC-YesRemoveView">Yes: Remove View</xsl:variable>
  <xsl:variable name="bwStr-DeVC-Cancel">No: Cancel</xsl:variable>

  <!--  xsl:template name="upload" -->
  <xsl:variable name="bwStr-Upld-UploadICalFile">Upload iCAL File</xsl:variable>
  <xsl:variable name="bwStr-Upld-Filename">Filename:</xsl:variable>
  <xsl:variable name="bwStr-Upld-IntoCalendar">Into calendar:</xsl:variable>
  <xsl:variable name="bwStr-Upld-NoneSelected"><em>none selected</em></xsl:variable>
  <xsl:variable name="bwStr-Upld-Change">change</xsl:variable>
  <xsl:variable name="bwStr-Upld-AffectsFreeBusy">Affects free/busy:</xsl:variable>
  <xsl:variable name="bwStr-Upld-AcceptEventsSettings">accept event's settings</xsl:variable>
  <xsl:variable name="bwStr-Upld-Yes">yes</xsl:variable>
  <xsl:variable name="bwStr-Upld-Opaque">(opaque: event status affects free/busy)</xsl:variable>
  <xsl:variable name="bwStr-Upld-No">no</xsl:variable>
  <xsl:variable name="bwStr-Upld-Transparent">(transparent: event status does not affect free/busy)</xsl:variable>
  <xsl:variable name="bwStr-Upld-AcceptEventsStatus">accept event's status</xsl:variable>
  <xsl:variable name="bwStr-Upld-Confirmed">confirmed</xsl:variable>
  <xsl:variable name="bwStr-Upld-Tentative">tentative</xsl:variable>
  <xsl:variable name="bwStr-Upld-Canceled">canceled</xsl:variable>
  <xsl:variable name="bwStr-Upld-Continue">Continue</xsl:variable>
  <xsl:variable name="bwStr-Upld-Cancel">Cancel</xsl:variable>
  <xsl:variable name="bwStr-Upld-DefaultCalendar">default calendar</xsl:variable>
  <xsl:variable name="bwStr-Upld-Status">Status:</xsl:variable>

  <!--  xsl:template name="modSyspars" -->
  <xsl:variable name="bwStr-MdSP-ManageSysParams">Manage System Preferences/Parameters</xsl:variable>
  <xsl:variable name="bwStr-MdSP-DoNotChangeUnless">Do not change unless you know what you're doing.<br/>Changes to these parameters have wide impact on the system.</xsl:variable>
  <xsl:variable name="bwStr-MdSP-SystemName">System name:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-SystemNameCannotBeChanged">Name for this system. Cannot be changed.</xsl:variable>
  <xsl:variable name="bwStr-MdSP-DefaultTimezone">Default timezone:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-SelectTimeZone">select timezone...</xsl:variable>
  <xsl:variable name="bwStr-MdSP-DefaultNormallyLocal">Default timezone id for date/time values. This should normally be your local timezone.</xsl:variable>
  <xsl:variable name="bwStr-MdSP-SuperUsers">Super Users:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-CommaSeparatedList">Comma separated list of super users. No spaces.</xsl:variable>
  <xsl:variable name="bwStr-MdSP-SystemID">System id:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-SystemIDNote">System id used when building uids and identifying users. Should not be changed.</xsl:variable>
  <xsl:variable name="bwStr-MdSP-Indexing">Indexing:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-IndexingNote">True if the system does indexing internally. Generally false for externally indexed</xsl:variable>


  <xsl:variable name="bwStr-MdSP-DefaultFBPeriod">Default Freebusy days:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-DefaultFBPeriodNote">The default freebusy fetch period</xsl:variable>
  <xsl:variable name="bwStr-MdSP-MaxFBPeriod">Max. Freebusy days:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-MaxFBPeriodNote">The maximum freebusy fetch period (for non-super user)</xsl:variable>
  <xsl:variable name="bwStr-MdSP-DefaultWebCalPeriod">Default webcal days:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-DefaultWebCalPeriodNote">The default webcal fetch period</xsl:variable>
  <xsl:variable name="bwStr-MdSP-MaxWebCalPeriod">Max. webcal days:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-MaxWebCalPeriodNote">The maximum webcal fetch period (for non-super user)</xsl:variable>



  <xsl:variable name="bwStr-MdSP-PubCalendarRoot">Public Calendar Root:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-PubCalendarRootNote">Name for public calendars root directory. Should not be changed.</xsl:variable>
  <xsl:variable name="bwStr-MdSP-UserCalendarRoot">User Calendar Root:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-UserCalendarRootNote">Name for user calendars root directory. Should not be changed.</xsl:variable>
  <xsl:variable name="bwStr-MdSP-UserCalendarDefaultName">User Calendar Default name:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-UserCalendarDefaultNameNote">efault name for user calendar. Used when initializing user. Possibly can be changed.</xsl:variable>
  <xsl:variable name="bwStr-MdSP-TrashCalendarDefaultName">Trash Calendar Default name:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-TrashCalendarDefaultNameNote">Default name for user trash calendar. Used when initializing user. Possibly can be changed.</xsl:variable>
  <xsl:variable name="bwStr-MdSP-InboxNote">Default name for user inbox. Used when initializing user. Possibly can be changed.</xsl:variable>
  <xsl:variable name="bwStr-MdSP-UserInboxDefaultName">User Inbox Default name:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-UserOutboxDefaultName">User Outbox Default name:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-UserOutboxDefaultNameNote">Default name for user outbox. Used when initializing user. Possibly can be changed.</xsl:variable>
  <xsl:variable name="bwStr-MdSP-UserDeletedCalendarDefaultName">User Deleted Calendar Default name:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-UserDeletedCalendarDefaultNameNote">Default name for user calendar used to hold deleted items. Used when initializing user. Possibly can be changed.</xsl:variable>
  <xsl:variable name="bwStr-MdSP-UserBusyCalendarDefaultName">User Busy Calendar Default name:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-UserBusyCalendarDefaultNameNote">Default name for user busy time calendar. Used when initializing user. Possibly can be changed.</xsl:variable>
  <xsl:variable name="bwStr-MdSP-DefaultUserViewName">Default user view name:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-DefaultUserViewNameNote">Name used for default view created when a new user is added</xsl:variable>
  <xsl:variable name="bwStr-MdSP-MaxAttendees">Maximum attendees:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-MaxAttendeesNote">Maximum number of event attendees (for personal client scheduling)</xsl:variable>
  <!--  Following not used
  <xsl:variable name="bwStr-MdSP-HTTPConnectionsPerUser">Http connections per user:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-HTTPConnectionsPerHost">Http connections per host:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-TotalHTTPConnections">Total http connections:</xsl:variable>
  -->
  <xsl:variable name="bwStr-MdSP-MaxLengthPubEventDesc">Maximum length of public event description:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-MaxLengthUserEventDesc">Maximum length of user event description:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-MaxSizeUserEntity">Maximum size of a user entity:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-DefaultUserQuota">Default user quota:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-MaxRecurringInstances">Max recurring instances:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-MaxRecurringInstancesNote">Used to limit recurring events to reasonable numbers of instances.</xsl:variable>
  <xsl:variable name="bwStr-MdSP-MaxRecurringYears">Max recurring years:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-MaxRecurringYearsNotes">Used to limit recurring events to reasonable period of time.</xsl:variable>
  <xsl:variable name="bwStr-MdSP-UserAuthClass">User authorization class:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-UserAuthClassNote">Class used to determine authorization (not authentication) for administrative users. Should probably only be changed on rebuild.</xsl:variable>
  <xsl:variable name="bwStr-MdSP-MailerClass">Mailer class:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-MailerClassNote">Class used to mail events. Should probably only be changed on rebuild.</xsl:variable>
  <xsl:variable name="bwStr-MdSP-AdminGroupsClass">Admin groups class:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-AdminGroupsClassNote">Class used to query and maintain groups for administrative users. Should probably only be changed on rebuild.</xsl:variable>
  <xsl:variable name="bwStr-MdSP-UserGroupsClass">User groups class:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-UserGroupsClassNote">Class used to query and maintain groups for non-administrative users. Should probably only be changed on rebuild.</xsl:variable>
  <xsl:variable name="bwStr-MdSP-DirBrowseDisallowd">Directory browsing disallowed:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-DirBrowseDisallowedNote">True if the server hosting the xsl disallows directory browsing.</xsl:variable>

  <xsl:variable name="bwStr-MdSP-EvregAdmTkn">Eventreg admin token:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-EvregAdmTknNote">Token for event registration. Must be identical to token set in event reg JMX service</xsl:variable>

  <xsl:variable name="bwStr-MdSP-GblResPath">Global resources path:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-GblResPathNote">Path for global resources</xsl:variable>

  <xsl:variable name="bwStr-MdSP-IndexRoot">Index root:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-IndexRootNote">Root for the event indexes. Should only be changed if the indexes are moved/copied</xsl:variable>
  <xsl:variable name="bwStr-MdSP-UseSolr">Use Solr for public indexing:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-UseSolrNote">Use Solr for public indexing:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-SolrURL">Solr Server URL:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-SolrURLNote">Solr Server URL:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-SolrCoreAdmin">Solr Server core admin path:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-SolrCoreAdminNote">Solr Server core admin path:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-SolrDefaultCore">Solr Server Default Core:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-SolrDefaultCoreNote">Solr Server Default Core:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-SupportedLocales">Supported Locales:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-ListOfSupportedLocales">List of supported locales. The format is a rigid, comma separated list of 2 letter language, underscore, 2 letter country. No spaces. Example: en_US,fr_CA</xsl:variable>
  <xsl:variable name="bwStr-MdSP-Update">Update</xsl:variable>
  <xsl:variable name="bwStr-MdSP-Cancel">Cancel</xsl:variable>
  <xsl:variable name="bwStr-MdSP-DefaultNotifications">Default Receive Notifications:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-DefaultNotificationsNote">Default when user has not specified if they wish to receive change notifications for a collection</xsl:variable>

  <!--  xsl:template match="calSuites" mode="calSuiteList" -->
  <xsl:variable name="bwStr-CalS-ManageCalendarSuites">Manage Calendar Suites</xsl:variable>
  <xsl:variable name="bwStr-CalS-AddCalendarSuite">Add calendar suite</xsl:variable>
  <xsl:variable name="bwStr-CalS-SwitchGroup">Switch group</xsl:variable>
  <xsl:variable name="bwStr-CalS-Name">Name</xsl:variable>
  <xsl:variable name="bwStr-CalS-AssociatedGroup">Associated Group</xsl:variable>

  <!--  xsl:template name="addCalSuite" -->
  <xsl:variable name="bwStr-AdCS-AddCalSuite">Add Calendar Suite</xsl:variable>
  <xsl:variable name="bwStr-AdCS-Name">Name:</xsl:variable>
  <xsl:variable name="bwStr-AdCS-NameCalSuite">Name of your calendar suite</xsl:variable>
  <xsl:variable name="bwStr-AdCS-Group">Group:</xsl:variable>
  <xsl:variable name="bwStr-AdCS-NameAdminGroup">Name of admin group which contains event administrators and event owner to which preferences for the suite are attached</xsl:variable>
  <xsl:variable name="bwStr-AdCS-Add">Add</xsl:variable>
  <xsl:variable name="bwStr-AdCS-Cancel">Cancel</xsl:variable>

  <!--  xsl:template match="calSuite" name="modCalSuite" -->
  <xsl:variable name="bwStr-CalS-ModifyCalendarSuite">Modify Calendar Suite</xsl:variable>
  <xsl:variable name="bwStr-CalS-NameColon">Name:</xsl:variable>
  <xsl:variable name="bwStr-CalS-NameOfCalendarSuite">Name of your calendar suite</xsl:variable>
  <xsl:variable name="bwStr-CalS-Group">Group:</xsl:variable>
  <xsl:variable name="bwStr-CalS-NameOfAdminGroup">Name of admin group which contains event administrators and event owner to which preferences for the suite are attached</xsl:variable>
  <xsl:variable name="bwStr-CalS-CurrentAccess">Current Access:</xsl:variable>
  <xsl:variable name="bwStr-CalS-DeleteCalendarSuite">Delete Calendar Suite</xsl:variable>
  <xsl:variable name="bwStr-CalS-Update">Update</xsl:variable>
  <xsl:variable name="bwStr-CalS-Cancel">Cancel</xsl:variable>

  <!--  xsl:template name="calSuitePrefs" -->
  <xsl:variable name="bwStr-CSPf-EditCalSuitePrefs">Edit Calendar Suite Preferences</xsl:variable>
  <xsl:variable name="bwStr-CSPf-CalSuite">Calendar Suite:</xsl:variable>
  <xsl:variable name="bwStr-CSPf-PreferredView">Preferred view:</xsl:variable>
  <xsl:variable name="bwStr-CSPf-DefaultViewMode">Default view mode:</xsl:variable>
  <xsl:variable name="bwStr-CSPf-DefaultViewModeList">UPCOMING - a list of discrete events from now into the future</xsl:variable>
  <xsl:variable name="bwStr-CSPf-DefaultViewModeDaily">DAY, WEEK, MONTH - a list of events showing entire view period</xsl:variable>
  <xsl:variable name="bwStr-CSPf-DefaultViewModeGrid">GRID - calendar grid for week and month view periods</xsl:variable>
  <xsl:variable name="bwStr-CSPf-PreferredViewPeriod">Preferred view period for<br/>DAY,WEEk,MONTH mode:</xsl:variable>
  <xsl:variable name="bwStr-CSPf-Day">day</xsl:variable>
  <xsl:variable name="bwStr-CSPf-Today">today</xsl:variable>
  <xsl:variable name="bwStr-CSPf-Week">week</xsl:variable>
  <xsl:variable name="bwStr-CSPf-Month">month</xsl:variable>
  <xsl:variable name="bwStr-CSPf-Year">year</xsl:variable>
  <xsl:variable name="bwStr-CSPf-DefaultPageSize">Default number of events to display<br/>for 'UPCOMING' mode (paging):</xsl:variable>
  <xsl:variable name="bwStr-CSPf-DefaultCategories">Default Categories:</xsl:variable>
  <xsl:variable name="bwStr-CSPf-ShowHideUnusedCategories">show/hide unused categories</xsl:variable>
  <xsl:variable name="bwStr-CSPf-PreferredTimeType">Preferred time type:</xsl:variable>
  <xsl:variable name="bwStr-CSPf-12Hour">12 hour + AM/PM</xsl:variable>
  <xsl:variable name="bwStr-CSPf-24Hour">24 hour</xsl:variable>
  <xsl:variable name="bwStr-CSPf-PreferredEndDateTimeType">Preferred end date/time type:</xsl:variable>
  <xsl:variable name="bwStr-CSPf-Duration">duration</xsl:variable>
  <xsl:variable name="bwStr-CSPf-DateTime">date/time</xsl:variable>
  <xsl:variable name="bwStr-CSPf-DefaultTimezone">Default timezone:</xsl:variable>
  <xsl:variable name="bwStr-CSPf-SelectTimezone">select timezone...</xsl:variable>
  <xsl:variable name="bwStr-CSPf-Update">Update</xsl:variable>
  <xsl:variable name="bwStr-CSPf-Cancel">Cancel</xsl:variable>
  <xsl:variable name="bwStr-CSPf-Approvers">Approvers:</xsl:variable>
  <xsl:variable name="bwStr-CSPf-MaxEntitySize">Maximum size for file uploads (in bytes):</xsl:variable>
  <xsl:variable name="bwStr-CSPf-DefaultImageDirectory">Default image directory:</xsl:variable>

  <!--  xsl:template name="uploadTimezones" -->
  <xsl:variable name="bwStr-UpTZ-ManageTZ">Manage Timezones</xsl:variable>
  <xsl:variable name="bwStr-UpTZ-UploadTZ">Upload Timezones</xsl:variable>
  <xsl:variable name="bwStr-UpTZ-Cancel">Cancel</xsl:variable>
  <xsl:variable name="bwStr-UpTZ-FixTZ">Fix Timezones</xsl:variable>
  <xsl:variable name="bwStr-UpTZ-RecalcUTC">(recalculate UTC values)</xsl:variable>
  <xsl:variable name="bwStr-UpTZ-FixTZNote">Run this to make sure UTC values are correct.</xsl:variable>

  <!--  xsl:template name="authUserList" -->
  <xsl:variable name="bwStr-AuUL-ModifyAdministrators">Modify Administrators</xsl:variable>
  <xsl:variable name="bwStr-AuUL-EditAdminRoles">Edit admin roles by userid:</xsl:variable>
  <xsl:variable name="bwStr-AuUL-UserID">UserId</xsl:variable>
  <xsl:variable name="bwStr-AuUL-Roles">Roles</xsl:variable>
  <xsl:variable name="bwStr-AuUL-Edit">edit</xsl:variable>
  <xsl:variable name="bwStr-AuUL-Go">go</xsl:variable>

  <!--  xsl:template name="modAuthUser" -->
  <xsl:variable name="bwStr-MoAU-UpdateAdmin">Update Administrator</xsl:variable>
  <xsl:variable name="bwStr-MoAU-Account">Account:</xsl:variable>
  <xsl:variable name="bwStr-MoAU-PublicEvents">Public Events:</xsl:variable>
  <xsl:variable name="bwStr-MoAU-ContentAdmin">Content Admin:</xsl:variable>
  <xsl:variable name="bwStr-MoAU-Approver">Approver:</xsl:variable>
  <xsl:variable name="bwStr-MoAU-Update">Update</xsl:variable>
  <xsl:variable name="bwStr-MoAU-Cancel">Cancel</xsl:variable>

  <!--  xsl:template name="modPrefs" -->
  <xsl:variable name="bwStr-MoPr-EditUserPrefs">Edit User Preferences</xsl:variable>
  <xsl:variable name="bwStr-MoPr-User">User:</xsl:variable>
  <xsl:variable name="bwStr-MoPr-PreferredView">Preferred view:</xsl:variable>
  <xsl:variable name="bwStr-MoPr-PreferredViewPeriod">Preferred view period:</xsl:variable>
  <xsl:variable name="bwStr-MoPr-Day">day</xsl:variable>
  <xsl:variable name="bwStr-MoPr-Today">today</xsl:variable>
  <xsl:variable name="bwStr-MoPr-Week">week</xsl:variable>
  <xsl:variable name="bwStr-MoPr-Month">month</xsl:variable>
  <xsl:variable name="bwStr-MoPr-Year">year</xsl:variable>
  <xsl:variable name="bwStr-MoPr-PageSize">Page Size:</xsl:variable>
  <xsl:variable name="bwStr-MoPr-NoNotifications">Suppress Notifications:</xsl:variable>
  <xsl:variable name="bwStr-MoPr-Update">Update</xsl:variable>
  <xsl:variable name="bwStr-MoPr-Cancel">Cancel</xsl:variable>

  <!--  xsl:template name="listAdminGroups" -->
  <xsl:variable name="bwStr-LsAG-ModifyGroups">Modify Groups</xsl:variable>
  <xsl:variable name="bwStr-LsAG-HideMembers">Hide members</xsl:variable>
  <xsl:variable name="bwStr-LsAG-ShowMembers">Show members</xsl:variable>
  <xsl:variable name="bwStr-LsAG-SelectGroupName">Select a group name to modify the group owner or description.<br/>Click "membership" to modify group membership.</xsl:variable>
  <xsl:variable name="bwStr-LsAG-AddNewGroup">Add a new group</xsl:variable>
  <xsl:variable name="bwStr-LsAG-HighlightedRowsNote">*Highlighted rows indicate a group to which a Calendar Suite is attached.</xsl:variable>
  <xsl:variable name="bwStr-LsAG-Name">Name</xsl:variable>
  <xsl:variable name="bwStr-LsAG-Members">Members</xsl:variable>
  <xsl:variable name="bwStr-LsAG-ManageMembership">Manage<br/>Membership</xsl:variable>
  <xsl:variable name="bwStr-LsAG-CalendarSuite">Calendar Suite*</xsl:variable>
  <xsl:variable name="bwStr-LsAG-Description">Description</xsl:variable>
  <xsl:variable name="bwStr-LsAG-Membership">membership</xsl:variable>

  <!--  xsl:template match="groups" mode="chooseGroup" -->
  <xsl:variable name="bwStr-Grps-ChooseAdminGroup">Choose Your Administrative Group</xsl:variable>
  <xsl:variable name="bwStr-Grps-HighlightedRowsNote">*Highlighted rows indicate a group to which a Calendar Suite is attached.  Select one of these groups to edit attributes of the associated calendar suite.</xsl:variable>
  <xsl:variable name="bwStr-Grps-Superuser"><strong>Superuser:</strong> to dissasociate yourself from all groups, log out and log back in.</xsl:variable>
  <xsl:variable name="bwStr-Grps-Name">Name</xsl:variable>
  <xsl:variable name="bwStr-Grps-Description">Description</xsl:variable>
  <xsl:variable name="bwStr-Grps-CalendarSuite">Calendar Suite*</xsl:variable>

  <!--  xsl:template name="modAdminGroup" -->
  <xsl:variable name="bwStr-MoAG-AddGroup">Add Group</xsl:variable>
  <xsl:variable name="bwStr-MoAG-ModifyGroup">Modify Group</xsl:variable>
  <xsl:variable name="bwStr-MoAG-Name">Name:</xsl:variable>
  <xsl:variable name="bwStr-MoAG-Description">Description:</xsl:variable>
  <xsl:variable name="bwStr-MoAG-GroupOwner">Group owner:</xsl:variable>
  <xsl:variable name="bwStr-MoAG-GroupOwnerFieldInfo">User responsible for the group, e.g. "admin"</xsl:variable>
  <xsl:variable name="bwStr-MoAG-EventsOwner">Events owner:</xsl:variable>
  <xsl:variable name="bwStr-MoAG-Optional">(optional)</xsl:variable>
  <xsl:variable name="bwStr-MoAG-EventsOwnerFieldInfo">The system owner for all events created by this group.<br/>This value will be created by the system if not supplied.</xsl:variable>
  <xsl:variable name="bwStr-MoAG-Delete">Delete</xsl:variable>
  <xsl:variable name="bwStr-MoAG-AddAdminGroup">Add Admin Group</xsl:variable>
  <xsl:variable name="bwStr-MoAG-Cancel">Cancel</xsl:variable>
  <xsl:variable name="bwStr-MoAG-UpdateAdminGroup">Update Admin Group</xsl:variable>

  <!--  xsl:template name="modAdminGroupMembers" -->
  <xsl:variable name="bwStr-MAGM-UpdateGroupMembership">Update Group Membership</xsl:variable>
  <xsl:variable name="bwStr-MAGM-EnterUserID">Enter a userid (for user or group) and click "add" to update group membership. Click the trash icon to remove a user from the group.</xsl:variable>
  <xsl:variable name="bwStr-MAGM-AddMember">Add member:</xsl:variable>
  <xsl:variable name="bwStr-MAGM-User">user</xsl:variable>
  <xsl:variable name="bwStr-MAGM-Group">group</xsl:variable>
  <xsl:variable name="bwStr-MAGM-Add">Add</xsl:variable>
  <xsl:variable name="bwStr-MAGM-ReturnToAdminGroupLS">Return to Admin Group listing</xsl:variable>
  <xsl:variable name="bwStr-MAGM-Name">Name:</xsl:variable>
  <xsl:variable name="bwStr-MAGM-Members">Members:</xsl:variable>
  <xsl:variable name="bwStr-MAGM-Remove">remove</xsl:variable>

  <!--  xsl:template name="deleteAdminGroupConfirm" -->
  <xsl:variable name="bwStr-DAGC-DeleteAdminGroup">Delete Admin Group?</xsl:variable>
  <xsl:variable name="bwStr-DAGC-GroupWillBeDeleted">The following group will be deleted. Continue?</xsl:variable>
  <xsl:variable name="bwStr-DAGC-YesDelete">Yes: Delete!</xsl:variable>
  <xsl:variable name="bwStr-DAGC-NoCancel">No: Cancel</xsl:variable>

  <!--  xsl:template name="addFilter" -->
  <xsl:variable name="bwStr-AdFi-AddNameCalDAVFilter">Add a Named CalDAV Filter</xsl:variable>
  <xsl:variable name="bwStr-AdFi-Examples">examples</xsl:variable>
  <xsl:variable name="bwStr-AdFi-Name">Name:</xsl:variable>
  <xsl:variable name="bwStr-AdFi-Description">Description:</xsl:variable>
  <xsl:variable name="bwStr-AdFi-FilterDefinition">Filter Definition:</xsl:variable>
  <xsl:variable name="bwStr-AdFi-AddFilter">Add Filter</xsl:variable>
  <xsl:variable name="bwStr-AdFi-Cancel">Cancel</xsl:variable>
  <xsl:variable name="bwStr-AdFi-CurrentFilters">Current Filters</xsl:variable>
  <xsl:variable name="bwStr-AdFi-FilterName">Filter Name</xsl:variable>
  <xsl:variable name="bwStr-AdFi-DescriptionDefinition">Description/Definition</xsl:variable>
  <xsl:variable name="bwStr-AdFi-Delete">Delete</xsl:variable>
  <xsl:variable name="bwStr-AdFi-ShowHideFilterDef">show/hide filter definition</xsl:variable>
  <xsl:variable name="bwStr-AdFi-DeleteFilter">delete filter</xsl:variable>

  <!--  xsl:template match="sysStats" mode="showSysStats" -->
  <xsl:variable name="bwStr-SysS-SystemStatistics">System Statistics</xsl:variable>
  <xsl:variable name="bwStr-SysS-StatsCollection">Stats collection:</xsl:variable>
  <xsl:variable name="bwStr-SysS-Enable">enable</xsl:variable>
  <xsl:variable name="bwStr-SysS-Disable">disable</xsl:variable>
  <xsl:variable name="bwStr-SysS-FetchRefreshStats">fetch/refresh statistics</xsl:variable>
  <xsl:variable name="bwStr-SysS-DumpStatsToLog">dump stats to log</xsl:variable>

  <!--  xsl:template ? -->
  <xsl:variable name="bwStr-Idx-Unindex">Unindex an entity by Href. WARNING - may damage the index</xsl:variable>

  <!--  xsl:template name="searchResult" -->
  <xsl:variable name="bwStr-Srch-Search">Search:</xsl:variable>
  <xsl:variable name="bwStr-Srch-Go">go</xsl:variable>
  <xsl:variable name="bwStr-Srch-ScopeLocal">this group</xsl:variable>
  <xsl:variable name="bwStr-Srch-ScopeMine">my groups</xsl:variable>
  <xsl:variable name="bwStr-Srch-ScopeAll">all groups</xsl:variable>
  <xsl:variable name="bwStr-Srch-Limit">Limit:</xsl:variable>
  <xsl:variable name="bwStr-Srch-TodayForward">today forward</xsl:variable>
  <xsl:variable name="bwStr-Srch-PastDates">past dates</xsl:variable>
  <xsl:variable name="bwStr-Srch-AllDates">all dates</xsl:variable>
  <xsl:variable name="bwStr-Srch-SearchResult">Search Result</xsl:variable>
  <xsl:variable name="bwStr-Srch-Page">page:</xsl:variable>
  <xsl:variable name="bwStr-Srch-Prev">prev</xsl:variable>
  <xsl:variable name="bwStr-Srch-Next">next</xsl:variable>
  <xsl:variable name="bwStr-Srch-PrevFull">Previous</xsl:variable>
  <xsl:variable name="bwStr-Srch-NextFull">Next</xsl:variable>
  <xsl:variable name="bwStr-Srch-Starting">Starting:</xsl:variable>
  <xsl:variable name="bwStr-Srch-ResultReturnedFor">result(s) returned for</xsl:variable>
  <xsl:variable name="bwStr-Srch-Relevance">relevance</xsl:variable>
  <xsl:variable name="bwStr-Srch-Summary">display name</xsl:variable>
  <xsl:variable name="bwStr-Srch-Title">title</xsl:variable>
  <xsl:variable name="bwStr-Srch-DateAndTime">date &amp; time</xsl:variable>
  <xsl:variable name="bwStr-Srch-Calendar">calendar</xsl:variable>
  <xsl:variable name="bwStr-Srch-Location">location</xsl:variable>
  <xsl:variable name="bwStr-Srch-NoTitle">no title</xsl:variable>
  <xsl:variable name="bwStr-Srch-NoResults">no results</xsl:variable>
  <xsl:variable name="bwStr-Srch-NoMoreResults">no more results</xsl:variable>

  <!--  xsl:template name="searchResultPageNav" -->

  <!--  xsl:template name="footer" -->
  <xsl:variable name="bwStr-Foot-BedeworkWebsite">Bedework Website</xsl:variable>
  <xsl:variable name="bwStr-Foot-ShowXML">show XML</xsl:variable>
  <xsl:variable name="bwStr-Foot-RefreshXSLT">refresh XSLT</xsl:variable>

</xsl:stylesheet>
