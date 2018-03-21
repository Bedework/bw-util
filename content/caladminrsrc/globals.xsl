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

  <!-- GENERATE KEYS -->
  <!-- Pick out unique categories from a collection of events
       for filtering in the manage event list. -->
  <xsl:key name="catUid" match="category" use="uid"/>


  <!-- DEFINE GLOBAL INCLUDES -->
  <xsl:include href="/bedework-common/default/default/util.xsl"/>
  <xsl:include href="/bedework-common/default/default/bedeworkAccess.xsl"/>

  <!-- include the common language string libraries -->
  <xsl:include href="/bedework-common/default/default/errors.xsl" />
  <xsl:include href="/bedework-common/default/default/messages.xsl" />
  <xsl:include href="/bedework-common/default/default/bedeworkAccessStrings.xsl"/>


  <!-- ======================= -->
  <!-- DEFINE GLOBAL CONSTANTS -->
  <!-- ======================= -->

  <!-- Root context of uploaded event images -->
  <xsl:variable name="bwEventImagePrefix">/pubcaldav</xsl:variable>

  <!-- URL of the XSL template directory -->
  <!-- The approot is an appropriate place to put
       included stylesheets and xml fragments. These are generally
       referenced relatively (like errors.xsl and messages.xsl above);
       this variable is here for your convenience if you choose to
       reference it explicitly.  It is not used in this stylesheet, however,
       and can be safely removed if you so choose. -->
  <xsl:variable name="appRoot" select="/bedework/approot"/>

  <!-- Registration module application context -->
  <xsl:variable name="bwRegistrationRoot">/eventreg</xsl:variable>

  <!-- Root folder of the submissions calendars used by the submissions client -->
  <xsl:variable name="submissionsRootEncoded" select="/bedework/submissionsRoot/encoded"/>
  <xsl:variable name="submissionsRootUnencoded" select="/bedework/submissionsRoot/unencoded"/>

  <!-- Root folder of the workflow collections -->
  <xsl:variable name="workflowRootEncoded" select="/bedework/workflowRoot/encoded"/>
  <xsl:variable name="workflowRootUnencoded" select="/bedework/workflowRoot/unencoded"/>

  <xsl:variable name="approverUser" select="/bedework/userInfo/approverUser"/>
  <xsl:variable name="superUser" select="/bedework/userInfo/superUser"/>

  <!-- Properly encoded prefixes to the application actions; use these to build
       urls; allows the application to be used without cookies or within a portal.
       we will probably change the way we create these before long (e.g. build them
       dynamically in the xslt). -->

  <!-- primary navigation, menu tabs -->
  <xsl:variable name="setup" select="/bedework/urlPrefixes/setup"/>
  <xsl:variable name="initPendingTab" select="/bedework/urlPrefixes/initPendingTab"/>
  <xsl:variable name="nextPendingTab" select="/bedework/urlPrefixes/nextPendingTab"/>
  <xsl:variable name="initApprovalQueueTab" select="/bedework/urlPrefixes/initApprovalQueueTab"/>
  <xsl:variable name="nextApprovalQueueTab" select="/bedework/urlPrefixes/nextApprovalQueueTab"/>
  <xsl:variable name="initSuggestionQueueTab" select="/bedework/urlPrefixes/initSuggestionQueueTab"/>
  <xsl:variable name="nextSuggestionQueueTab" select="/bedework/urlPrefixes/nextSuggestionQueueTab"/>
  <xsl:variable name="showCalsuiteTab" select="/bedework/urlPrefixes/showCalsuiteTab"/>
  <xsl:variable name="showUsersTab" select="/bedework/urlPrefixes/showUsersTab"/>
  <xsl:variable name="showSystemTab" select="/bedework/urlPrefixes/showSystemTab"/>
  <xsl:variable name="logout" select="/bedework/urlPrefixes/logout"/>
  <xsl:variable name="search" select="/bedework/urlPrefixes/search/search"/>
  <xsl:variable name="search-next" select="/bedework/urlPrefixes/search/next"/>
  <xsl:variable name="index-unindex" select="/bedework/urlPrefixes/search/unindex"/>

  <!-- events -->
  <xsl:variable name="event-showEvent" select="/bedework/urlPrefixes/event/showEvent"/>
  <xsl:variable name="event-showModForm" select="/bedework/urlPrefixes/event/showModForm"/>
  <xsl:variable name="event-showUpdateList" select="/bedework/urlPrefixes/event/showUpdateList"/>
  <xsl:variable name="event-nextUpdateList" select="/bedework/urlPrefixes/event/nextUpdateList"/>
  <xsl:variable name="event-showDeleteConfirm" select="/bedework/urlPrefixes/event/showDeleteConfirm"/>
  <xsl:variable name="event-initAddEvent" select="/bedework/urlPrefixes/event/initAddEvent"/>
  <xsl:variable name="event-initUpdateEvent" select="/bedework/urlPrefixes/event/initUpdateEvent"/>
  <xsl:variable name="event-delete" select="/bedework/urlPrefixes/event/delete"/>
  <xsl:variable name="event-deletePending" select="/bedework/urlPrefixes/event/deletePending"/>
  <xsl:variable name="event-fetchForDisplay" select="/bedework/urlPrefixes/event/fetchForDisplay"/>
  <xsl:variable name="event-fetchForUpdate" select="/bedework/urlPrefixes/event/fetchForUpdate"/>
  <xsl:variable name="event-fetchForUpdatePending" select="/bedework/urlPrefixes/event/fetchForUpdatePending"/>
  <xsl:variable name="event-fetchForUpdateApprovalQueue" select="/bedework/urlPrefixes/event/fetchForUpdateApprovalQueue"/>
  <xsl:variable name="event-fetchForUpdateSuggestionQueue" select="/bedework/urlPrefixes/event/fetchForUpdateSuggestionQueue"/>
  <xsl:variable name="event-update" select="/bedework/urlPrefixes/event/update"/>
  <xsl:variable name="event-updatePending" select="/bedework/urlPrefixes/event/updatePending"/>
  <xsl:variable name="event-updateApprovalQueue" select="/bedework/urlPrefixes/event/updateApprovalQueue"/>
  <xsl:variable name="event-selectCalForEvent" select="/bedework/urlPrefixes/event/selectCalForEvent"/>
  <xsl:variable name="event-initUpload" select="/bedework/urlPrefixes/event/initUpload"/>
  <xsl:variable name="event-upload" select="/bedework/urlPrefixes/event/upload"/>

  <!-- suggestions -->
  <xsl:variable name="suggest-setStatus" select="/bedework/urlPrefixes/suggest/setStatus"/>
  <xsl:variable name="suggest-setStatusForUpdate" select="/bedework/urlPrefixes/suggest/setStatusForUpdate"/>

  <!-- contacts -->
  <xsl:variable name="contact-showContact" select="/bedework/urlPrefixes/contact/showContact"/>
  <xsl:variable name="contact-showReferenced" select="/bedework/urlPrefixes/contact/showReferenced"/>
  <xsl:variable name="contact-showModForm" select="/bedework/urlPrefixes/contact/showModForm"/>
  <xsl:variable name="contact-showUpdateList" select="/bedework/urlPrefixes/contact/showUpdateList"/>
  <xsl:variable name="contact-showDeleteConfirm" select="/bedework/urlPrefixes/contact/showDeleteConfirm"/>
  <xsl:variable name="contact-initAdd" select="/bedework/urlPrefixes/contact/initAdd"/>
  <xsl:variable name="contact-initUpdate" select="/bedework/urlPrefixes/contact/initUpdate"/>
  <xsl:variable name="contact-delete" select="/bedework/urlPrefixes/contact/delete"/>
  <xsl:variable name="contact-fetchForDisplay" select="/bedework/urlPrefixes/contact/fetchForDisplay"/>
  <xsl:variable name="contact-fetchForUpdate" select="/bedework/urlPrefixes/contact/fetchForUpdate"/>
  <xsl:variable name="contact-update" select="/bedework/urlPrefixes/contact/update"/>
  <!-- locations -->
  <xsl:variable name="location-showLocation" select="/bedework/urlPrefixes/location/showLocation"/>
  <xsl:variable name="location-showReferenced" select="/bedework/urlPrefixes/location/showReferenced"/>
  <xsl:variable name="location-showModForm" select="/bedework/urlPrefixes/location/showModForm"/>
  <xsl:variable name="location-showUpdateList" select="/bedework/urlPrefixes/location/showUpdateList"/>
  <xsl:variable name="location-showDeleteConfirm" select="/bedework/urlPrefixes/location/showDeleteConfirm"/>
  <xsl:variable name="location-initAdd" select="/bedework/urlPrefixes/location/initAdd"/>
  <xsl:variable name="location-initUpdate" select="/bedework/urlPrefixes/location/initUpdate"/>
  <xsl:variable name="location-delete" select="/bedework/urlPrefixes/location/delete"/>
  <xsl:variable name="location-fetchForDisplay" select="/bedework/urlPrefixes/location/fetchForDisplay"/>
  <xsl:variable name="location-fetchForUpdate" select="/bedework/urlPrefixes/location/fetchForUpdate"/>
  <xsl:variable name="location-update" select="/bedework/urlPrefixes/location/update"/>
  <!-- categories -->
  <xsl:variable name="category-showReferenced" select="/bedework/urlPrefixes/category/showReferenced"/>
  <xsl:variable name="category-showModForm" select="/bedework/urlPrefixes/category/showModForm"/>
  <xsl:variable name="category-showUpdateList" select="/bedework/urlPrefixes/category/showUpdateList"/>
  <xsl:variable name="category-showDeleteConfirm" select="/bedework/urlPrefixes/category/showDeleteConfirm"/>
  <xsl:variable name="category-initAdd" select="/bedework/urlPrefixes/category/initAdd"/>
  <xsl:variable name="category-initUpdate" select="/bedework/urlPrefixes/category/initUpdate"/>
  <xsl:variable name="category-delete" select="/bedework/urlPrefixes/category/delete"/>
  <xsl:variable name="category-fetchForUpdate" select="/bedework/urlPrefixes/category/fetchForUpdate"/>
  <xsl:variable name="category-update" select="/bedework/urlPrefixes/category/update"/>
  <!-- calendars -->
  <xsl:variable name="calendar-fetch" select="/bedework/urlPrefixes/calendar/fetch"/>
  <xsl:variable name="calendar-fetchDescriptions" select="/bedework/urlPrefixes/calendar/fetchDescriptions"/>
  <xsl:variable name="calendar-initAdd" select="/bedework/urlPrefixes/calendar/initAdd"/>
  <xsl:variable name="calendar-delete" select="/bedework/urlPrefixes/calendar/delete"/>
  <xsl:variable name="calendar-fetchForDisplay" select="/bedework/urlPrefixes/calendar/fetchForDisplay"/>
  <xsl:variable name="calendar-fetchForUpdate" select="/bedework/urlPrefixes/calendar/fetchForUpdate"/>
  <xsl:variable name="calendar-update" select="/bedework/urlPrefixes/calendar/update"/>
  <!-- <xsl:variable name="calendar-setAccess" select="/bedework/urlPrefixes/calendar/setAccess"/>-->
  <xsl:variable name="calendar-openCloseMod" select="/bedework/urlPrefixes/calendar/calOpenCloseMod"/>
  <xsl:variable name="calendar-openCloseSelect" select="/bedework/urlPrefixes/calendar/calOpenCloseSelect"/>
  <xsl:variable name="calendar-openCloseDisplay" select="/bedework/urlPrefixes/calendar/calOpenCloseDisplay"/>
  <xsl:variable name="calendar-openCloseMove" select="/bedework/urlPrefixes/calendar/calOpenCloseMove"/>
  <xsl:variable name="calendar-move" select="/bedework/urlPrefixes/calendar/move"/>
  <!-- notifications -->
  <xsl:variable name="notify-remove" select="/bedework/urlPrefixes/notifications/remove"/>
  <xsl:variable name="notify-removeTrans" select="/bedework/urlPrefixes/notifications/removeTrans"/>
  <!-- subscriptions -->
  <xsl:variable name="subscriptions-fetch" select="/bedework/urlPrefixes/subscriptions/fetch"/>
  <xsl:variable name="subscriptions-fetchForUpdate" select="/bedework/urlPrefixes/subscriptions/fetchForUpdate"/>
  <xsl:variable name="subscriptions-initAdd" select="/bedework/urlPrefixes/subscriptions/initAdd"/>
  <xsl:variable name="subscriptions-update" select="/bedework/urlPrefixes/subscriptions/update"/>
  <xsl:variable name="subscriptions-delete" select="/bedework/urlPrefixes/subscriptions/delete"/>
  <xsl:variable name="subscriptions-openCloseMod" select="/bedework/urlPrefixes/subscriptions/subOpenCloseMod"/>
  <!-- views -->
  <xsl:variable name="view-fetch" select="/bedework/urlPrefixes/view/fetch"/>
  <xsl:variable name="view-fetchForUpdate" select="/bedework/urlPrefixes/view/fetchForUpdate"/>
  <xsl:variable name="view-addView" select="/bedework/urlPrefixes/view/addView"/>
  <xsl:variable name="view-update" select="/bedework/urlPrefixes/view/update"/>
  <xsl:variable name="view-remove" select="/bedework/urlPrefixes/view/remove"/>
  <!-- system -->
  <xsl:variable name="system-fetch" select="/bedework/urlPrefixes/system/fetch"/>
  <xsl:variable name="system-update" select="/bedework/urlPrefixes/system/update"/>
  <!-- calsuites -->
  <xsl:variable name="calsuite-fetch" select="/bedework/urlPrefixes/calsuite/fetch"/>
  <xsl:variable name="calsuite-fetchForUpdate" select="/bedework/urlPrefixes/calsuite/fetchForUpdate"/>
  <xsl:variable name="calsuite-add" select="/bedework/urlPrefixes/calsuite/add"/>
  <xsl:variable name="calsuite-update" select="/bedework/urlPrefixes/calsuite/update"/>
  <xsl:variable name="calsuite-showAddForm" select="/bedework/urlPrefixes/calsuite/showAddForm"/>
  <!--  <xsl:variable name="calsuite-setAccess" select="/bedework/urlPrefixes/calsuite/setAccess"/> -->
  <xsl:variable name="calsuite-fetchPrefsForUpdate" select="/bedework/urlPrefixes/calsuite/fetchPrefsForUpdate"/>
  <xsl:variable name="calsuite-updatePrefs" select="/bedework/urlPrefixes/calsuite/updatePrefs"/>
  <!-- calsuite resources -->
  <xsl:variable name="calsuite-resources-fetch" select="/bedework/urlPrefixes/calsuiteresources/fetch"/>
  <xsl:variable name="calsuite-resources-edit" select="/bedework/urlPrefixes/calsuiteresources/edit"/>
  <xsl:variable name="calsuite-resources-add" select="/bedework/urlPrefixes/calsuiteresources/add"/>
  <xsl:variable name="calsuite-resources-update" select="/bedework/urlPrefixes/calsuiteresources/update"/>
  <xsl:variable name="calsuite-resources-remove" select="/bedework/urlPrefixes/calsuiteresources/remove"/>
  <!-- global resources -->
  <xsl:variable name="global-resources-fetch" select="/bedework/urlPrefixes/globalresources/fetch"/>
  <xsl:variable name="global-resources-edit" select="/bedework/urlPrefixes/globalresources/edit"/>
  <xsl:variable name="global-resources-add" select="/bedework/urlPrefixes/globalresources/add"/>
  <xsl:variable name="global-resources-update" select="/bedework/urlPrefixes/globalresources/update"/>
  <xsl:variable name="global-resources-remove" select="/bedework/urlPrefixes/globalresources/remove"/>
  <!-- timezones and stats -->
  <xsl:variable name="timezones-initUpload" select="/bedework/urlPrefixes/timezones/initUpload"/>
  <xsl:variable name="timezones-upload" select="/bedework/urlPrefixes/timezones/upload"/>
  <xsl:variable name="timezones-fix" select="/bedework/urlPrefixes/timezones/fix"/>
  <xsl:variable name="stats-update" select="/bedework/urlPrefixes/stats/update"/>
  <!-- authuser and prefs -->
  <xsl:variable name="authuser-showModForm" select="/bedework/urlPrefixes/authuser/showModForm"/>
  <xsl:variable name="authuser-showUpdateList" select="/bedework/urlPrefixes/authuser/showUpdateList"/>
  <xsl:variable name="authuser-initUpdate" select="/bedework/urlPrefixes/authuser/initUpdate"/>
  <xsl:variable name="authuser-fetchForUpdate" select="/bedework/urlPrefixes/authuser/fetchForUpdate"/>
  <xsl:variable name="authuser-update" select="/bedework/urlPrefixes/authuser/update"/>
  <xsl:variable name="prefs-fetchForUpdate" select="/bedework/urlPrefixes/prefs/fetchForUpdate"/>
  <xsl:variable name="prefs-update" select="/bedework/urlPrefixes/prefs/update"/>
  <!-- admin groups -->
  <xsl:variable name="admingroup-showModForm" select="/bedework/urlPrefixes/admingroup/showModForm"/>
  <xsl:variable name="admingroup-showModMembersForm" select="/bedework/urlPrefixes/admingroup/showModMembersForm"/>
  <xsl:variable name="admingroup-showUpdateList" select="/bedework/urlPrefixes/admingroup/showUpdateList"/>
  <xsl:variable name="admingroup-showChooseGroup" select="/bedework/urlPrefixes/admingroup/showChooseGroup"/>
  <xsl:variable name="admingroup-showDeleteConfirm" select="/bedework/urlPrefixes/admingroup/showDeleteConfirm"/>
  <xsl:variable name="admingroup-initAdd" select="/bedework/urlPrefixes/admingroup/initAdd"/>
  <xsl:variable name="admingroup-initUpdate" select="/bedework/urlPrefixes/admingroup/initUpdate"/>
  <xsl:variable name="admingroup-delete" select="/bedework/urlPrefixes/admingroup/delete"/>
  <xsl:variable name="admingroup-fetchUpdateList" select="/bedework/urlPrefixes/admingroup/fetchUpdateList"/>
  <xsl:variable name="admingroup-fetchForUpdate" select="/bedework/urlPrefixes/admingroup/fetchForUpdate"/>
  <xsl:variable name="admingroup-fetchForUpdateMembers" select="/bedework/urlPrefixes/admingroup/fetchForUpdateMembers"/>
  <xsl:variable name="admingroup-update" select="/bedework/urlPrefixes/admingroup/update"/>
  <xsl:variable name="admingroup-updateMembers" select="/bedework/urlPrefixes/admingroup/updateMembers"/>
  <xsl:variable name="admingroup-switch" select="/bedework/urlPrefixes/admingroup/switch"/>
  <!-- filters -->
  <xsl:variable name="filter-showAddForm" select="/bedework/urlPrefixes/filter/showAddForm"/>
  <xsl:variable name="filter-add" select="/bedework/urlPrefixes/filter/add"/>
  <xsl:variable name="filter-delete" select="/bedework/urlPrefixes/filter/delete"/>


  <!-- URL of the web application - includes web context -->
  <xsl:variable name="urlPrefix" select="/bedework/urlprefix"/>

  <!-- Other generally useful global variables -->
  <xsl:variable name="publicCal">/cal</xsl:variable>

  <!-- DEPRECATED: but left here for backward compatibility with older themes.
       The following variable can be set to "true" or "false";
       to use jQuery widgets and fancier UI features, set to false - these are
       not guaranteed to work in portals.  -->
  <xsl:variable name="portalFriendly">false</xsl:variable>

  <!-- get the current date set by the user, if exists, else use now -->
  <xsl:variable name="curListDate">
    <xsl:choose>
      <xsl:when test="/bedework/appvar[key='curListDate']/value"><xsl:value-of select="/bedework/appvar[key='curListDate']/value"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="substring(/bedework/now/date,1,4)"/>-<xsl:value-of select="substring(/bedework/now/date,5,2)"/>-<xsl:value-of select="substring(/bedework/now/date,7,2)"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <!-- get the current number of days set by the user, if exists, else use default -->
  <xsl:variable name="curListDays">
    <xsl:choose>
      <xsl:when test="/bedework/appvar[key='curListDays']/value"><xsl:value-of select="/bedework/appvar[key='curListDays']/value"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="/bedework/defaultdays"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

</xsl:stylesheet>
