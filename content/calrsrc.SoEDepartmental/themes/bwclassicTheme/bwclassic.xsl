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

<!-- =========================================================

              DEMONSTRATION CALENDAR STYLESHEET

                  MainCampus Calendar Suite

     This stylesheet is devoid of school branding.  It is a good
     starting point for development of a customized calendar.

     For detailed instructions on how to work with the XSLT
     stylesheets included with this distribution, please see the
     Bedework Manual at http://www.jasig.org/bedework/documentation

===============================================================  -->

  <!-- ================================= -->
  <!--  DEMO PUBLIC CALENDAR STYLESHEET  -->
  <!-- ================================= -->

  <!-- DEFINE INCLUDES -->
  <!-- Theme preferences -->
  <xsl:include href="themeSettings.xsl" />

  <!-- Page subsections -->
  <xsl:include href="head.xsl" />
  <xsl:include href="header.xsl" />
  <xsl:include href="navigation.xsl" />
  <xsl:include href="eventGrids.xsl" />
  <xsl:include href="eventLists.xsl" />
  <xsl:include href="event.xsl" />
  <xsl:include href="calendarList.xsl" />
  <xsl:include href="search.xsl" />
  <xsl:include href="stats.xsl" />
  <xsl:include href="footer.xsl" />

  <!-- MAIN TEMPLATE -->
  <xsl:template match="/">
    <html lang="en">
      <xsl:call-template name="head"/>
      <body>
        <xsl:call-template name="headBar"/>
        <xsl:if test="/bedework/error">
          <div id="errors">
            <xsl:apply-templates select="/bedework/error"/>
          </div>
        </xsl:if>
        <xsl:call-template name="tabs"/>
        <xsl:call-template name="navigation"/>
        <xsl:call-template name="searchBar"/>
        <xsl:choose>
          <xsl:when test="/bedework/page='event'">
            <!-- show an event -->
            <xsl:apply-templates select="/bedework/event"/>
          </xsl:when>
          <xsl:when test="/bedework/page='eventList'">
            <!-- show a list of discrete events in a time period -->
            <xsl:apply-templates select="/bedework/events" mode="eventList"/>
          </xsl:when>
          <xsl:when test="/bedework/page='showSysStats'">
            <!-- show system stats -->
            <xsl:call-template name="stats"/>
          </xsl:when>
          <xsl:when test="/bedework/page='calendarList'">
            <!-- show a list of all calendars -->
            <xsl:apply-templates select="/bedework/calendars"/>
          </xsl:when>
          <xsl:when test="/bedework/page='displayCalendarForExport'">
            <!-- page for calendar export (can optionally be replaced by
                 a pop-up widget; see the calendars template) -->
            <xsl:apply-templates select="/bedework/currentCalendar" mode="export"/>
          </xsl:when>
          <xsl:when test="/bedework/page='searchResult'">
            <!-- display search results -->
            <xsl:call-template name="searchResult"/>
          </xsl:when>
          <xsl:otherwise>
            <!-- otherwise, show the eventsCalendar -->
            <!-- main eventCalendar content -->
            <xsl:choose>
              <xsl:when test="/bedework/periodname='Day'">
                <xsl:call-template name="listView"/>
              </xsl:when>
              <xsl:when test="/bedework/periodname='Week' or /bedework/periodname=''">
                <xsl:choose>
                  <xsl:when test="/bedework/appvar[key='weekViewMode']/value='list'">
                    <xsl:call-template name="listView"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="weekView"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="/bedework/periodname='Month'">
                <xsl:choose>
                  <xsl:when test="/bedework/appvar[key='monthViewMode']/value='list'">
                    <xsl:call-template name="listView"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="monthView"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="yearView"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
        <!-- footer -->
        <xsl:call-template name="footer"/>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>
