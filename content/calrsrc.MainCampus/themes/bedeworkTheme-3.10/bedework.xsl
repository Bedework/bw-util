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
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" indent="yes" media-type="text/html"
    standalone="yes" omit-xml-declaration="yes" />

  <!-- =========================================================

    DEMONSTRATION CALENDAR STYLESHEET

    MainCampus Calendar Suite Theme:
    responsive, includes jQuery and Bootstrap

    Many theme settings can be made in themeSettings.xsl.

    CSS is loaded in this order:
    - Bootstrap
    - jQuery and jQuery UI
    - bwThemeGlobal - the global styles (mobile first)
    - bwThemeResponsive - responsive overrides

    This stylesheet is devoid of school branding.  It is a good
    starting point for development of a customized theme.

    It is based on work by Duke University, Yale University, and
    Rensselaer Polytechnic Institute with credit also to the
    University of Chicago.

    For detailed instructions on how to work with the XSLT
    stylesheets included with this distribution, please see the
    Bedework Manual at http://www.jasig.org/bedework/documentation

    ===============================================================  -->

  <!-- DEFINE INCLUDES -->
  <!-- Theme preferences -->
  <xsl:include href="themeSettings.xsl" />

  <!-- theme utility functions -->
  <xsl:include href="themeUtil.xsl" />

  <!-- Page subsections -->
  <xsl:include href="head.xsl" />
  <xsl:include href="header.xsl" />
  <xsl:include href="datePicker.xsl" />
  <xsl:include href="search.xsl" />
  <xsl:include href="leftColumn.xsl" />
  <xsl:include href="views.xsl" />
  <xsl:include href="featuredEvents.xsl"/>
  <xsl:include href="eventListRangeNav.xsl" />
  <xsl:include href="eventListRange.xsl" />
  <xsl:include href="eventList.xsl" />
  <xsl:include href="eventGrids.xsl" />
  <xsl:include href="queryFilterDisplay.xsl" />
  <xsl:include href="event.xsl" />
  <xsl:include href="year.xsl" />
  <xsl:include href="exportSubscribe.xsl" />
  <xsl:include href="calendarsAll.xsl" />
  <xsl:include href="searchResult.xsl"/>
  <xsl:include href="ongoing.xsl" />
  <xsl:include href="deadlines.xsl" />
  <xsl:include href="systemStats.xsl"/>
  <xsl:include href="showPage.xsl"/>

  <!-- MAIN TEMPLATE -->
  <xsl:template match="/">
<xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html></xsl:text><!-- HTML5 -->
    <html lang="en">
      <xsl:call-template name="head"/>
      <body>
        <!-- HEADER BAR -->
        <header id="header">
          <xsl:call-template name="masthead" />
        </header>
        <div class="container">
          <!-- ERROR MESSAGES -->
          <xsl:if test="/bedework/error">
            <div id="errors" class="ui-state-error ui-corner-all">
              <xsl:apply-templates select="/bedework/error" />
            </div>
          </xsl:if>
          <noscript><xsl:copy-of select="$bwStr-Error-NoScript"/></noscript>

          <section id="content">
            <div class="row">

              <!-- LEFT COLUMN: date picker, search, subscriptions, views, and other navigation -->
              <div id="leftColumn" class="col-lg-3 col-md-3 col-sm-3">
                <xsl:call-template name="datePicker" />
                <xsl:call-template name="search" />
                <xsl:call-template name="leftColumn" />
              </div>

              <!-- RIGHT FULL COLUMN: features, event lists and navigation, ongoing events -->
              <div id="rightFullColumn" class="col-lg-9 col-md-9 col-sm-9">

	              <!-- FEATURED EVENTS, if enabled -->
	              <xsl:if test="$featuredEventsEnabled = 'true'">
	                <xsl:call-template name="featuredEvents"/>
	              </xsl:if>

                <!-- ONGOING EVENTS if enabled -->
                <xsl:if test="$ongoingEvents = 'true'">
                  <div id="ongoing">
                    <xsl:attribute name="class">
                      <xsl:choose>
                        <xsl:when test="/bedework/page='eventscalendar' and /bedework/periodname='Month'">ongoingForGrid</xsl:when>
                        <xsl:otherwise>col-lg-3 col-md-3 col-sm-3</xsl:otherwise>
                      </xsl:choose>
                    </xsl:attribute>
                    <xsl:call-template name="ongoingEventList" />
                  </div>
                </xsl:if>

	              <!-- MAIN CONTENT: event listings, single events, calendar lists, search results -->
                <div id="centerColumn">
                  <xsl:attribute name="class">
                    <xsl:choose>
                      <xsl:when test="$ongoingEvents = 'true' and not(/bedework/page='eventscalendar' and /bedework/periodname='Month')">col-lg-9 col-md-9 col-sm-9</xsl:when>
                      <xsl:otherwise>col-lg-12 col-md-12 col-sm-12</xsl:otherwise>
                    </xsl:choose>
                  </xsl:attribute>

                  <!-- branch on content, as defined by /bedework/page -->
                  <xsl:choose>

                    <!-- list of discrete events - used for upcoming events, paged views, and data feeds -->
                    <xsl:when test="/bedework/page = 'eventList'">
                      <xsl:call-template name="eventList"/>
                      <!-- original call to directly process xml:
                      <xsl:apply-templates select="/bedework/events" mode="eventListDiscrete"/>
                      -->
                    </xsl:when>

                    <!-- day, week, month, year event listings -->
                    <xsl:when test="/bedework/page='eventscalendar'">
                      <div class="secondaryColHeader">
                        <xsl:call-template name="eventListRangeNav" />
                      </div>
                      <xsl:choose>
                        <xsl:when test="/bedework/periodname = 'Year'">
                          <xsl:call-template name="yearView" />
                        </xsl:when>
                        <xsl:when test="/bedework/periodname='Month'">
                          <xsl:call-template name="monthGrid"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:call-template name="eventListRange"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:when>

                    <!-- single event display -->
                    <xsl:when test="/bedework/page = 'event'">
                      <xsl:apply-templates select="/bedework/event" mode="singleEvent"/>
                    </xsl:when>

                    <!-- list of calendar suite's subscriptions -->
                    <xsl:when test="/bedework/page='calendarList'">
                      <xsl:apply-templates select="/bedework/calendars" />
                    </xsl:when>

                    <!-- export calendar form -->
                    <xsl:when test="/bedework/page='displayCalendarForExport'">
                      <xsl:apply-templates select="/bedework/currentCalendar" mode="export" />
                    </xsl:when>

                    <!-- search result -->
                    <xsl:when test="/bedework/page='searchResult'">
                      <xsl:call-template name="searchResult" />
                      <xsl:call-template name="advancedSearch" />
                    </xsl:when>

                    <!-- system statistics -->
                    <xsl:when test="/bedework/page='showSysStats'">
                      <xsl:call-template name="stats" />
                    </xsl:when>

                    <!-- branch to an arbitrary page (an xsl template) using the
                         "appvar" session variable on a link like so:
                         /misc/showPage.rdo?setappvar=page(mypage)
                         Page templates are defined in showPage.xsl -->
                    <xsl:when test="/bedework/page='showPage'">
                      <xsl:choose>
                        <xsl:when test="/bedework/appvar[key='page']">
                          <xsl:call-template name="showPage">
                            <xsl:with-param name="pageName"><xsl:value-of select="/bedework/appvar[key='page']/value"/></xsl:with-param>
                          </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                          <div id="page">
                            <xsl:copy-of select="$bwStr-Error-NoPage"/>
                          </div>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:when>

                    <!-- otherwise, show us what page was requested
                         (if the stylesheet is thorough, you should never see this) -->
                    <xsl:otherwise>
                      <xsl:copy-of select="$bwStr-Error"/>
                      <xsl:text> </xsl:text>
                      <xsl:value-of select="/bedework/page" />
                    </xsl:otherwise>

                  </xsl:choose>
                </div><!-- /center_column -->

		          </div><!-- /div right_full_column -->

            </div><!-- /row -->
          </section><!-- /section id="content" -->

          <!-- FOOTER -->
          <footer id="footer" class="row">
            <xsl:call-template name="footerText"/>  <!-- in themeSettings.xsl -->
          </footer>

        </div><!-- /container -->

      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
