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

  <!-- DEFINE GLOBAL INCLUDES -->
  <xsl:include href="/bedework-common/default/default/errors.xsl" />
  <xsl:include href="/bedework-common/default/default/messages.xsl" />
  <xsl:include href="/bedework-common/default/default/util.xsl" />


  <!-- ======================= -->
  <!-- DEFINE GLOBAL CONSTANTS -->
  <!-- ======================= -->

  <!-- URL of the XSL template directory for this calendar suite -->
  <xsl:variable name="appRoot" select="/bedework/approot" />

  <!-- Properly encoded prefixes to the application actions; use these to build
    urls; allows the application to be used without cookies or within a portal.
    These urls are rewritten in header.jsp and simply passed through for use
    here. Every url includes a query string (either ?b=de or a real query
    string) so that all links constructed in this stylesheet may begin the
    query string with an ampersand. -->
  <xsl:variable name="setup" select="/bedework/urlPrefixes/setup" />
  <xsl:variable name="setSelection" select="/bedework/urlPrefixes/main/setSelection" />
  <xsl:variable name="fetchPublicCalendars" select="/bedework/urlPrefixes/calendar/fetchPublicCalendars" />
  <xsl:variable name="setViewPeriod" select="/bedework/urlPrefixes/main/setViewPeriod" />
  <xsl:variable name="listEvents" select="/bedework/urlPrefixes/main/listEvents" />
  <xsl:variable name="eventView" select="/bedework/urlPrefixes/event/eventView" />
  <xsl:variable name="addEventRef" select="/bedework/urlPrefixes/event/addEventRef" />
  <xsl:variable name="export" select="/bedework/urlPrefixes/misc/export" />
  <xsl:variable name="search" select="/bedework/urlPrefixes/search/search" />
  <xsl:variable name="search-next" select="/bedework/urlPrefixes/search/next" />
  <xsl:variable name="calendar-fetchForExport" select="/bedework/urlPrefixes/calendar/fetchForExport" />
  <xsl:variable name="mailEvent" select="/bedework/urlPrefixes/mail/mailEvent" />
  <xsl:variable name="stats" select="/bedework/urlPrefixes/stats/stats" />

  <!-- URL of the web application - includes web context -->
  <xsl:variable name="urlPrefix" select="/bedework/urlprefix" />

  <!-- Other generally useful global variables -->
  <xsl:variable name="privateCal">/ucal</xsl:variable>
  <xsl:variable name="feeder">/feeder</xsl:variable>
  <xsl:variable name="prevdate" select="/bedework/previousdate" />
  <xsl:variable name="nextdate" select="/bedework/nextdate" />
  <xsl:variable name="curdate" select="/bedework/currentdate/date" />

</xsl:stylesheet>
