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

    HTML WIDGET - GENERATE HTML EVENT LIST

    ===============================================================  -->

  <!-- Output the event list as an html data island -->
  <xsl:template match="events" mode="widgetEventList">
    <xsl:choose>
      <xsl:when test="not(event)">
        <xsl:variable name="todayDate"><xsl:value-of select="substring(/bedework/now/date,0,5)"/><xsl:text>-</xsl:text><xsl:value-of select="substring(/bedework/now/date,5,2)"/><xsl:text>-</xsl:text><xsl:value-of select="substring(/bedework/now/date,7,2)"/></xsl:variable>
        <xsl:variable name="continueDate"><xsl:value-of select="substring(toDate.dtval,0,5)"/><xsl:text>-</xsl:text><xsl:value-of select="substring(toDate.dtval,5,2)"/><xsl:text>-</xsl:text><xsl:value-of select="substring(toDate.dtval,7,2)"/></xsl:variable>

        <script type="text/javascript">
          // We have no more events: turn off scrolling update, and remove
          // "Load more events" link (if they exist)
          $(document).ready(function () {
            $(window).off("scroll",bwScroll);
            $("#loadMoreEventsLink").remove();
            setBwContinueFromMarkup("#continueFrom","<xsl:value-of select="$bwStr-LsEv-ContinueFrom"/>","<xsl:value-of select="$continueDate"/>","<xsl:value-of select="$bwStr-LsEv-ReturnToToday"/>","<xsl:value-of select="$todayDate"/>");
          });
        </script>
      </xsl:when>
      <xsl:otherwise>
        <ul>
          <script type="text/javascript">
            // add more events when we scroll
            $(document).ready(function () {
              $(window).on("scroll",bwScroll);
            });
          </script>
          <xsl:for-each select="event">
            <xsl:variable name="id" select="id"/>
            <xsl:variable name="calPath" select="calendar/encodedPath"/>
            <xsl:variable name="guid" select="guid"/>
            <xsl:variable name="href" select="encodedHref"/>
            <xsl:variable name="name" select="name"/>
            <xsl:variable name="guidEsc" select="translate(guid, '.', '_')"/>
            <xsl:variable name="recurrenceId" select="recurrenceId"/>
            <xsl:variable name="lastStartDate" select="substring(preceding-sibling::event[1]/start/unformatted,1,8)"/>

            <!-- Print out a date separator if enabled in themeSettings.xsl.
                 Don't print a separator out at the top of list for events on the
                 current date or for events spanning multiple days that begin
                 before the current date. To avoid duplicating the date row between
                 ajax page loads, we must maintain the value of the last date
                 separator in javascript and pass it back to the server on each
                 request. -->
            <xsl:if test="($useDateSeparatorsInList = 'true') and
                          (substring(start/unformatted,1,8) != $lastStartDate) and
                          (number(substring(start/unformatted,1,8)) &gt; number(/bedework/currentdate/date)) and
                          (number(substring(start/unformatted,1,8)) != number(/bedework/appvar[key='lastDateSeparatorInList']/value))">
              <li class="bwDateRow"><xsl:value-of select="start/dayname"/>, <xsl:value-of select="start/longdate"/></li>
              <script type="text/javascript">bwLastDateSeparatorInList = "<xsl:value-of select="substring(start/unformatted,1,8)"/>";</script>
            </xsl:if>

            <!-- generate the event -->
            <li>
              <xsl:attribute name="class">
                <xsl:choose>
                  <xsl:when test="status='CANCELLED'">bwStatusCancelled</xsl:when>
                  <xsl:when test="status='TENTATIVE'">bwStatusTentative</xsl:when>
                  <xsl:when test="position() mod 2 = 0">even</xsl:when>
                  <xsl:otherwise>odd</xsl:otherwise>
                </xsl:choose>
              </xsl:attribute>

              <!-- event icons -->
              <span class="icons">
                <xsl:variable name="gStartdate" select="start/utcdate"/>
                <xsl:variable name="gLocation"><xsl:call-template name="url-encode"><xsl:with-param name="str" select="location/address" /></xsl:call-template></xsl:variable>
                <xsl:variable name="gEnddate" select="end/utcdate"/>
                <xsl:variable name="gText"><xsl:call-template name="url-encode"><xsl:with-param name="str" select="summary" /></xsl:call-template></xsl:variable>
                <xsl:variable name="gDetails" select="$gText"/><!-- this could be changed to better reflect the details -->

                <xsl:if test="$eventIconDownloadIcs = 'true'">
                  <a href="{$export}&amp;href={$href}&amp;nocache=no&amp;contentName={$name}" title="{$bwStr-SgEv-Download}">
                    <img src="{$resourcesRoot}/images/std-ical_icon_small.gif" alt="{$bwStr-SgEv-Download}"/>
                  </a>
                </xsl:if>
                <xsl:if test="$eventIconAddToMyCal = 'true'">
                  <a href="{$privateCal}/event/addEventRef.do?href={$href}" title="{$bwStr-LsVw-AddEventToMyCalendar}" target="myCalendar">
                    <img class="addref" src="{$resourcesRoot}/images/add2mycal-icon-small.gif" width="12" height="16" alt="{$bwStr-LsVw-AddEventToMyCalendar}"/>
                  </a>
                </xsl:if>
                <xsl:if test="$eventIconGoogleCal = 'true'">
                  <a href="http://www.google.com/calendar/event?action=TEMPLATE&amp;dates={$gStartdate}/{$gEnddate}&amp;text={$gText}&amp;details={$gDetails}&amp;location={$gLocation}">
                    <img title="{$bwStr-SgEv-AddToGoogleCalendar}" src="{$resourcesRoot}/images/gcal_small.gif" alt="{$bwStr-SgEv-AddToGoogleCalendar}"/>
                  </a>
                </xsl:if>
                <xsl:if test="$eventIconShareThis = 'true'">
                  <xsl:variable name="shareURL"><xsl:value-of select="/bedework/urlprefix"/>/event/eventView.do?b=de&amp;href=<xsl:value-of select="encodedHref"/></xsl:variable>
                  <xsl:variable name="noNewLineDetails">
                    <xsl:call-template name="replace">
                      <xsl:with-param name="string" select="description"/>
                      <xsl:with-param name="pattern" select="'&#xa;'"/>
                      <xsl:with-param name="substitution" select="''"/>
                    </xsl:call-template>
                  </xsl:variable>
                  <xsl:variable name="shareThisId">shareThis-<xsl:value-of select="$guid"/><xsl:value-of select="recurrenceId"/></xsl:variable>
                  <span id="{$shareThisId}">
                    <script language="javascript" type="text/javascript">
                      stWidget.addEntry({
                        "service":"sharethis",
                        "element":document.getElementById('<xsl:value-of select="$shareThisId"/>'),
                        "title":'<xsl:call-template name="escapeApos"><xsl:with-param name="str" select="$gText"/></xsl:call-template>',
                        "content":'<xsl:call-template name="escapeApos"><xsl:with-param name="str" select="$noNewLineDetails"/></xsl:call-template>',
                        "summary":'<xsl:value-of select="$shareThisSummary"/>',
                        "url":'<xsl:value-of select="$shareURL"/>'
                      });
                    </script>
                  </span>
                </xsl:if>
              </span>

              <!-- event thumbnail -->
              <xsl:if test="$thumbsEnabled = 'true' and (normalize-space(xproperties/X-BEDEWORK-IMAGE/values/text) != '' or $usePlaceholderThumb = 'true')">
                <xsl:variable name="imgPrefix">
                  <xsl:choose>
                    <xsl:when test="starts-with(xproperties/X-BEDEWORK-IMAGE/values/text,'http')"></xsl:when>
                    <xsl:otherwise><xsl:value-of select="$bwEventImagePrefix"/></xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <xsl:variable name="imgThumbPrefix">
                  <xsl:choose>
                    <xsl:when test="starts-with(xproperties/X-BEDEWORK-THUMB-IMAGE/values/text,'http')"></xsl:when>
                    <xsl:otherwise><xsl:value-of select="$bwEventImagePrefix"/></xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <a href="{$eventView}&amp;href={$href}" class="eventThumbLink">
                  <img class="eventThumb img-responsive">
                    <xsl:attribute name="width"><xsl:value-of select="$thumbWidth"/></xsl:attribute>
                    <xsl:attribute name="src">
                      <xsl:choose>
                        <xsl:when test="xproperties/X-BEDEWORK-THUMB-IMAGE"><xsl:value-of select="$imgThumbPrefix"/><xsl:value-of select="xproperties/X-BEDEWORK-THUMB-IMAGE/values/text"/></xsl:when>
                        <xsl:when test="xproperties/X-BEDEWORK-IMAGE and $useFullImageThumbs = 'true'"><xsl:value-of select="$imgPrefix"/><xsl:value-of select="xproperties/X-BEDEWORK-IMAGE/values/text"/></xsl:when>
                        <xsl:otherwise><xsl:value-of select="$resourcesRoot"/>/images/placeholder.png</xsl:otherwise>
                      </xsl:choose>
                    </xsl:attribute>
                    <xsl:attribute name="alt">
                      <xsl:choose>
                        <xsl:when test="xproperties/X-BEDEWORK-IMAGE/parameters/X-BEDEWORK-PARAM-ALT">
                          <xsl:value-of select="xproperties/X-BEDEWORK-IMAGE/parameters/X-BEDEWORK-PARAM-ALT" />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:call-template name="escapeJson"><xsl:with-param name="string" select="summary" /></xsl:call-template>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:attribute>
                  </img>
                </a>
              </xsl:if>

              <div class="eventListContent">
                <xsl:attribute name="class">
                  <xsl:choose>
                    <xsl:when test="xproperties/X-BEDEWORK-IMAGE or $usePlaceholderThumb = 'true'">eventListContent withImage</xsl:when>
                    <xsl:when test="$usePlaceholderThumbBlank = 'true'">eventListContent withBlank</xsl:when>
                    <xsl:otherwise>eventListContent</xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>


                <!-- event title -->
                <xsl:if test="status='CANCELLED'"><strong><xsl:copy-of select="$bwStr-LsVw-Canceled"/><xsl:text> </xsl:text></strong></xsl:if>
                <xsl:if test="status='TENTATIVE'"><strong><xsl:copy-of select="$bwStr-LsEv-Tentative"/><xsl:text> </xsl:text></strong></xsl:if>
                <div class="bwSummary">
                  <a href="{$eventView}&amp;href={$href}">
                    <xsl:value-of select="summary"/>
                    <xsl:if test="summary = ''">
                      <xsl:copy-of select="$bwStr-SgEv-NoTitle" />
                    </xsl:if>
                  </a>
                </div>

                <xsl:value-of select="substring(start/dayname,1,3)"/>,
                <xsl:value-of select="start/longdate"/>
                <xsl:text> </xsl:text>
                <xsl:if test="start/allday != 'true'">
                  <xsl:value-of select="start/time"/>
                </xsl:if>
                <xsl:choose>
                  <xsl:when test="start/shortdate != end/shortdate">
                    -
                    <xsl:value-of select="substring(end/dayname,1,3)"/>,
                    <xsl:value-of select="end/longdate"/>
                    <xsl:text> </xsl:text>
                    <xsl:if test="start/allday != 'true'">
                      <xsl:value-of select="end/time"/>
                    </xsl:if>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:if test="start/time != end/time">
                      -
                      <xsl:value-of select="end/time"/>
                    </xsl:if>
                  </xsl:otherwise>
                </xsl:choose>

                <br/>
                <xsl:copy-of select="$bwStr-LsVw-Location"/><xsl:text> </xsl:text>
                <xsl:choose>
                  <xsl:when test="location/address = ''">
                    <xsl:value-of select="xproperties/node()[name()='X-BEDEWORK-LOCATION']/values/text"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="location/address"/><!--
                 --><xsl:if test="location/roomField!=''">, <xsl:text> </xsl:text><xsl:value-of select="location/roomField" /></xsl:if><!--
                 --><xsl:if test="location/street!=''">, <xsl:text> </xsl:text><xsl:value-of select="location/street" /></xsl:if><!--
                 --><xsl:if test="location/city!=''">, <xsl:text> </xsl:text><xsl:value-of select="location/city" /></xsl:if><!--
                 --><xsl:if test="location/state!=''">, <xsl:text> </xsl:text><xsl:value-of select="location/state" /></xsl:if><!--
                 --><xsl:if test="location/zip!=''"><xsl:text> </xsl:text><xsl:value-of select="location/zip" /></xsl:if>
                  </xsl:otherwise>
                </xsl:choose>

                <xsl:if test="/bedework/appvar[key='listEventsSummaryMode']/value='details'">
                  <br/>
                  <xsl:value-of select="description"/>
                  <xsl:if test="link != ''">
                    <br/>
                    <xsl:variable name="link" select="link"/>
                    <a href="{$link}" class="moreLink"><xsl:value-of select="link"/></a>
                  </xsl:if>
                  <xsl:if test="categories/category">
                    <br/>
                    <xsl:copy-of select="$bwStr-LsEv-Categories"/>
                    <xsl:for-each select="categories/category">
                      <xsl:value-of select="value"/><xsl:if test="position() != last()">, </xsl:if>
                    </xsl:for-each>
                  </xsl:if>
                  <br/>
                  <em>
                    <xsl:if test="cost!=''">
                      <xsl:value-of select="cost"/>.&#160;
                    </xsl:if>
                    <xsl:if test="contact/name!='none'">
                      <xsl:copy-of select="$bwStr-LsEv-Contact"/><xsl:text> </xsl:text><xsl:value-of select="contact/name"/>
                    </xsl:if>
                  </em>
                </xsl:if>

                <xsl:if test="xproperties/X-BEDEWORK-ALIAS">
                  <br/>
                  <xsl:copy-of select="$bwStr-LsVw-TopicalArea"/><xsl:text> </xsl:text>
                  <span class="eventSubscription">
                    <xsl:for-each select="xproperties/X-BEDEWORK-ALIAS">
                      <xsl:choose>
                        <xsl:when test="parameters/X-BEDEWORK-PARAM-DISPLAYNAME">
                          <xsl:value-of select="parameters/X-BEDEWORK-PARAM-DISPLAYNAME"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:call-template name="substring-afterLastInstanceOf">
                            <xsl:with-param name="string" select="values/text"/>
                            <xsl:with-param name="char">/</xsl:with-param>
                          </xsl:call-template>
                        </xsl:otherwise>
                      </xsl:choose>
                      <xsl:if test="position()!=last()">, </xsl:if>
                    </xsl:for-each>
                  </span>
                </xsl:if>
              </div>

            </li>
          </xsl:for-each>
        </ul>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
