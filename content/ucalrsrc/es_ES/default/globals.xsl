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
<xsl:output
  method="xml"
  indent="no"
  media-type="text/html"
  doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
  doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
  standalone="yes"
  omit-xml-declaration="yes"/>

  <!-- ===================================================== -->
  <!--       Globals for PERSONAL CALENDAR STYLESHEET        -->
  <!-- ===================================================== -->

  <!-- DEFINE INCLUDES -->
  <xsl:include href="/approots/bedework-common/default/default/util.xsl"/>
  <xsl:include href="/approots/bedework-common/default/default/bedeworkAccess.xsl"/>

  <!-- include the common language string libraries -->
  <xsl:include href="/approots/bedework-common/es_ES/default/errors.xsl"/>
  <xsl:include href="/approots/bedework-common/es_ES/default/messages.xsl"/>
  <xsl:include href="/approots/bedework-common/es_ES/default/bedeworkAccessStrings.xsl"/>

  <!-- ========================================= -->
  <!--         DEFINE GLOBAL CONSTANTS           -->
  <!-- ========================================= -->

  <!-- URL of the XSL template directory -->
  <xsl:variable name="appRoot" select="/bedework/approot"/>

  <!-- Properly encoded prefixes to the application actions; use these to build
       urls; allows the application to be used without cookies or within a portal.
       These urls are rewritten in header.jsp and simply passed through for use
       here. Every url includes a query string (either ?b=de or a real query
       string) so that all links constructed in this stylesheet may begin the
       query string with an ampersand. -->
  <!-- main -->
  <xsl:variable name="setup" select="/bedework/urlPrefixes/setup"/>
  <xsl:variable name="setSelection" select="/bedework/urlPrefixes/main/setSelection"/>
  <xsl:variable name="setViewPeriod" select="/bedework/urlPrefixes/main/setViewPeriod"/>
  <xsl:variable name="listEvents" select="/bedework/urlPrefixes/main/listEvents"/>
  <xsl:variable name="showPage" select="/bedework/urlPrefixes/misc/showPage"/>
  <!-- events -->
  <xsl:variable name="eventView" select="/bedework/urlPrefixes/event/eventView"/>
  <xsl:variable name="initEvent" select="/bedework/urlPrefixes/event/initEvent"/>
  <xsl:variable name="addEvent" select="/bedework/urlPrefixes/event/addEvent"/>
  <xsl:variable name="event-attendeesForEvent" select="/bedework/urlPrefixes/event/attendeesForEvent"/>
  <xsl:variable name="widget-attendees" select="/bedework/urlPrefixes/widget/attendees"/>
  <xsl:variable name="event-showAttendeesForEvent" select="/bedework/urlPrefixes/event/showAttendeesForEvent"/>
  <xsl:variable name="event-initMeeting" select="/bedework/urlPrefixes/event/initMeeting"/>
  <xsl:variable name="event-addEventRefComplete" select="/bedework/urlPrefixes/event/addEventRefComplete"/>
  <xsl:variable name="event-addEventSubComplete" select="/bedework/urlPrefixes/event/addEventSubComplete"/>
  <xsl:variable name="event-showAccess" select="/bedework/urlPrefixes/event/showAccess"/>
  <!-- <xsl:variable name="event-setAccess" select="/bedework/urlPrefixes/event/setAccess"/>-->
  <xsl:variable name="editEvent" select="/bedework/urlPrefixes/event/editEvent"/>
  <xsl:variable name="gotoEditEvent" select="/bedework/urlPrefixes/event/gotoEditEvent"/>
  <xsl:variable name="updateEvent" select="/bedework/urlPrefixes/event/updateEvent"/>
  <xsl:variable name="delEvent" select="/bedework/urlPrefixes/event/delEvent"/>
  <xsl:variable name="delInboxEvent" select="/bedework/urlPrefixes/event/delInboxEvent"/>
  <xsl:variable name="addEventRef" select="/bedework/urlPrefixes/event/addEventRef"/>
  <xsl:variable name="requestFreeBusy" select="/bedework/urlPrefixes/event/requestFreeBusy"/>
  <!-- locations -->
  <xsl:variable name="location-initAdd" select="/bedework/urlPrefixes/location/initAdd"/>
  <xsl:variable name="location-initUpdate" select="/bedework/urlPrefixes/location/initUpdate"/>
  <xsl:variable name="location-fetchForUpdate" select="/bedework/urlPrefixes/location/fetchForUpdate"/>
  <xsl:variable name="location-update" select="/bedework/urlPrefixes/location/update"/>
  <xsl:variable name="location-delete" select="/bedework/urlPrefixes/location/delete"/>
  <!-- categories -->
  <xsl:variable name="category-initAdd" select="/bedework/urlPrefixes/category/initAdd"/>
  <xsl:variable name="category-initUpdate" select="/bedework/urlPrefixes/category/initUpdate"/>
  <xsl:variable name="category-fetchForUpdate" select="/bedework/urlPrefixes/category/fetchForUpdate"/>
  <xsl:variable name="category-update" select="/bedework/urlPrefixes/category/update"/>
  <xsl:variable name="category-delete" select="/bedework/urlPrefixes/category/delete"/>
  <!-- calendars -->
  <xsl:variable name="fetchPublicCalendars" select="/bedework/urlPrefixes/calendar/fetchPublicCalendars"/>
  <xsl:variable name="calendar-fetch" select="/bedework/urlPrefixes/calendar/fetch"/>
  <xsl:variable name="calendar-fetchDescriptions" select="/bedework/urlPrefixes/calendar/fetchDescriptions"/>
  <xsl:variable name="calendar-initAdd" select="/bedework/urlPrefixes/calendar/initAdd"/>
  <xsl:variable name="calendar-initAddExternal" select="/bedework/urlPrefixes/calendar/initAddExternal"/>
  <xsl:variable name="calendar-initAddAlias" select="/bedework/urlPrefixes/calendar/initAddAlias"/>
  <xsl:variable name="calendar-initAddPublicAlias" select="/bedework/urlPrefixes/calendar/initAddPublicAlias"/>
  <xsl:variable name="calendar-delete" select="/bedework/urlPrefixes/calendar/delete"/>
  <xsl:variable name="calendar-fetchForDisplay" select="/bedework/urlPrefixes/calendar/fetchForDisplay"/>
  <xsl:variable name="calendar-fetchForUpdate" select="/bedework/urlPrefixes/calendar/fetchForUpdate"/>
  <xsl:variable name="calendar-update" select="/bedework/urlPrefixes/calendar/update"/>
  <!-- <xsl:variable name="calendar-setAccess" select="/bedework/urlPrefixes/calendar/setAccess"/>-->
  <xsl:variable name="calendar-trash" select="/bedework/urlPrefixes/calendar/trash"/>
  <xsl:variable name="calendar-emptyTrash" select="/bedework/urlPrefixes/calendar/emptyTrash"/>
  <xsl:variable name="calendar-listForExport" select="/bedework/urlPrefixes/calendar/listForExport"/>
  <xsl:variable name="calendar-setPropsInGrid" select="/bedework/urlPrefixes/calendar/setPropsInGrid"/>
  <xsl:variable name="calendar-setPropsInList" select="/bedework/urlPrefixes/calendar/setPropsInList"/>
  <!-- sharing -->
  <xsl:variable name="sharing-shareCollection" select="/bedework/urlPrefixes/sharing/shareCollection"/>
  <xsl:variable name="sharing-reply" select="/bedework/urlPrefixes/sharing/reply"/>
  <xsl:variable name="sharing-initAddSubscription" select="/bedework/urlPrefixes/sharing/initAddSubscription"/>
  <xsl:variable name="sharing-subscribe" select="/bedework/urlPrefixes/sharing/subscribe"/>
  <!-- notifications -->
  <xsl:variable name="notifications-remove" select="/bedework/urlPrefixes/notifications/remove"/>
  <xsl:variable name="notifications-removeTrans" select="/bedework/urlPrefixes/notifications/removeTrans"/>
  <!-- subscriptions -->
  <!-- subscriptions now subsumed by the sharing methods above (v.3.9)
  <xsl:variable name="subscriptions-showSubsMenu" select="/bedework/urlPrefixes/subscriptions/showSubsMenu"/>
  <xsl:variable name="subscriptions-fetch" select="/bedework/urlPrefixes/subscriptions/fetch"/>
  <xsl:variable name="subscriptions-fetchForUpdate" select="/bedework/urlPrefixes/subscriptions/fetchForUpdate"/>
  <xsl:variable name="subscriptions-initAdd" select="/bedework/urlPrefixes/subscriptions/initAdd"/>
  <xsl:variable name="subscriptions-subscribe" select="/bedework/urlPrefixes/subscriptions/subscribe"/>
  <xsl:variable name="subscriptions-inaccessible" select="/bedework/urlPrefixes/subscriptions/inaccessible"/> -->
  <!-- preferences -->
  <xsl:variable name="prefs-fetchForUpdate" select="/bedework/urlPrefixes/prefs/fetchForUpdate"/>
  <xsl:variable name="prefs-update" select="/bedework/urlPrefixes/prefs/update"/>
  <xsl:variable name="prefs-fetchSchedulingForUpdate" select="/bedework/urlPrefixes/prefs/fetchSchedulingForUpdate"/>
  <!-- <xsl:variable name="prefs-setAccess" select="/bedework/urlPrefixes/prefs/setAccess"/>-->
  <xsl:variable name="prefs-updateSchedulingPrefs" select="/bedework/urlPrefixes/prefs/updateSchedulingPrefs"/>
  <!-- vpoll -->
  <xsl:variable name="vpoll-initmanage" select="/bedework/urlPrefixes/vpoll/initManageVpoll"/>
  <!-- scheduling -->
  <xsl:variable name="showInbox" select="/bedework/urlPrefixes/schedule/showInbox"/>
  <xsl:variable name="showOutbox" select="/bedework/urlPrefixes/schedule/showOutbox"/>
  <xsl:variable name="schedule-initAttendeeRespond" select="/bedework/urlPrefixes/schedule/initAttendeeRespond"/>
  <xsl:variable name="schedule-attendeeRespond" select="/bedework/urlPrefixes/schedule/attendeeRespond"/>
  <xsl:variable name="schedule-initAttendeeReply" select="/bedework/urlPrefixes/schedule/initAttendeeReply"/>
  <xsl:variable name="schedule-initAttendeeUpdate" select="/bedework/urlPrefixes/schedule/initAttendeeUpdate"/>
  <xsl:variable name="schedule-changeStatus" select="/bedework/urlPrefixes/schedule/changeStatus"/>
  <xsl:variable name="schedule-processAttendeeReply" select="/bedework/urlPrefixes/schedule/processAttendeeReply"/>
  <xsl:variable name="schedule-clearReply" select="/bedework/urlPrefixes/schedule/clearReply"/>
  <xsl:variable name="schedule-processRefresh" select="/bedework/urlPrefixes/schedule/processRefresh"/>
  <xsl:variable name="schedule-refresh" select="/bedework/urlPrefixes/schedule/refresh"/>
  <!-- misc (mostly import and export) -->
  <xsl:variable name="export" select="/bedework/urlPrefixes/misc/export"/>
  <xsl:variable name="calendar-export" select="/bedework/urlPrefixes/calendar/export"/>
  <xsl:variable name="initUpload" select="/bedework/urlPrefixes/misc/initUpload"/>
  <xsl:variable name="upload" select="/bedework/urlPrefixes/misc/upload"/>
  <!-- search -->
  <xsl:variable name="search" select="/bedework/urlPrefixes/search/search"/>
  <xsl:variable name="search-next" select="/bedework/urlPrefixes/search/next"/>
  <!-- mail -->
  <xsl:variable name="mailEvent" select="/bedework/urlPrefixes/mail/mailEvent"/>
  <!-- alarm -->
  <xsl:variable name="initEventAlarm" select="/bedework/urlPrefixes/alarm/initEventAlarm"/>
  <xsl:variable name="setAlarm" select="/bedework/urlPrefixes/alarm/setAlarm"/>
  <!-- free/busy -->
  <xsl:variable name="freeBusy-fetch" select="/bedework/urlPrefixes/freeBusy/fetch"/>
  <!-- <xsl:variable name="freeBusy-setAccess" select="/bedework/urlPrefixes/freeBusy/setAccess"/>-->

  <!-- URL of the web application - includes web context -->
  <xsl:variable name="urlPrefix" select="/bedework/urlprefix"/>

  <!-- Other generally useful global variables -->
  <xsl:variable name="prevdate" select="/bedework/previousdate"/>
  <xsl:variable name="nextdate" select="/bedework/nextdate"/>
  <xsl:variable name="curdate" select="/bedework/currentdate/date"/>
  <xsl:variable name="nowdate" select="/bedework/now/date"/>
  <xsl:variable name="skin">default</xsl:variable>
  <xsl:variable name="publicCal">/cal</xsl:variable>

  <!-- the following variable can be set to "true" or "false";
       to use jQuery widgets and fancier UI features, set to false - these are
       not guaranteed to work in portals. -->
  <xsl:variable name="portalFriendly">false</xsl:variable>

</xsl:stylesheet>