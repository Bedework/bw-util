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


  <!--======== list events ==========-->
  <!-- This formats a list of events from /bedework/eventscalendar, the original
       day, week, and month views.  Look to eventList.xsl for the listing
       produced by setSelectionList.do, setOngoingList.do, and listEvents.do actions -->

  <xsl:template name="eventListRange">

    <!-- attach onclick events so that the entire event is clickable - this is
         particularly good for touch screens -->
    <script type="text/javascript">
      $(document).ready(function() {
        $(".eventRow .eventInfoLauncher").click(function() {
          $(this).closest("tr").addClass("clickedEvent");
          location.href = ($(this).find("a").attr("href"));
        });
      });
    </script>

    <table class="eventList" desc="{$bwStr-LsVw-ListWithinTimeRange}">

      <tr id="noResultsMsg" class="invisible">
        <td colspan="3"><xsl:copy-of select="$bwStr-LsVw-NoEventsFromSelection"/></td>
      </tr>
      <!-- produce the list of events -->
      <xsl:choose>
        <xsl:when test="not(/bedework/eventscalendar/year/month/week/day/event)">
          <tr>
            <td colspan="3" class="noEventsCell">
              <xsl:copy-of select="$bwStr-LsVw-NoEventsToDisplay"/>
            </td>
          </tr>
        </xsl:when>
        <xsl:when test="$ongoingEventsEnabled = 'true' and $ongoingEventsShowForCollection = 'true'
               and not(/bedework/eventscalendar/year/month/week/day/event[not(categories/category/uid = $ongoingEventsCatUid)])">
            <tr>
              <td colspan="3" class="noEventsCell">
                <xsl:copy-of select="$bwStr-LsVw-NoEventsToDisplayWithOngoing"/>
              </td>
            </tr>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="$ongoingEventsEnabled = 'true' and $ongoingEventsShowForCollection = 'true'">
              <xsl:apply-templates select="/bedework/eventscalendar/year/month/week/day[event[not(categories/category/uid = $ongoingEventsCatUid)]]" mode="dayInList"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="/bedework/eventscalendar/year/month/week/day[event]" mode="dayInList"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </table>

    <!-- Subscribe/Export Form Popup -->
    <div id="exportSubscribePopup" class="mfp-hide">
      <xsl:call-template name="exportSubscribe"/>
    </div>
  </xsl:template>

  <xsl:template match="day" mode="dayInList">
     <tr>
       <td colspan="2" class="dateRow">
          <xsl:variable name="date" select="date"/>
          <a href="{$setViewPeriod}&amp;viewType=dayView&amp;date={$date}">
            <xsl:value-of select="name"/>, <xsl:value-of select="longdate"/>
          </a>
       </td>
     </tr>
      <xsl:choose>
       <xsl:when test="$ongoingEventsEnabled = 'true' and $ongoingEventsShowForCollection = 'true'">
         <xsl:apply-templates select="event[not(categories/category/uid = $ongoingEventsCatUid)]" mode="eventInList"/>
       </xsl:when>
       <xsl:otherwise>
         <xsl:apply-templates select="event" mode="eventInList"/>
       </xsl:otherwise>
     </xsl:choose>
   </xsl:template>

   <xsl:template match="event" mode="eventInList">
    <xsl:variable name="id" select="id"/>
    <xsl:variable name="calPath" select="calendar/encodedPath"/>
    <xsl:variable name="guid" select="guid"/>
    <xsl:variable name="href" select="encodedHref"/>
    <xsl:variable name="name" select="name"/>
    <xsl:variable name="guidEsc" select="translate(guid, '.', '_')"/>
    <xsl:variable name="recurrenceId" select="recurrenceId"/>
    <tr class="eventRow">
      <xsl:variable name="dateRangeStyle">
        <xsl:choose>
          <xsl:when test="start/shortdate = parent::day/shortdate">
            <xsl:choose>
              <xsl:when test="start/allday = 'true'">dateRangeCrossDay</xsl:when>
              <xsl:when test="start/hour24 &lt; 6">dateRangeEarlyMorning</xsl:when>
              <xsl:when test="start/hour24 &lt; 12">dateRangeMorning</xsl:when>
              <xsl:when test="start/hour24 &lt; 18">dateRangeAfternoon</xsl:when>
              <xsl:otherwise>dateRangeEvening</xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>dateRangeCrossDay</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <!-- Event Date / Time Column  -->
      <td class="time {$dateRangeStyle} eventInfoLauncher">
       <xsl:choose>
        <xsl:when test="start/allday = 'true' and start/shortdate = end/shortdate">
            <xsl:copy-of select="$bwStr-LsVw-AllDay"/>
        </xsl:when>
        <xsl:when test="start/shortdate = end/shortdate and start/time = end/time">
          <a href="{$eventView}&amp;href={$href}">
            <xsl:value-of select="start/time"/>
          </a>
        </xsl:when>
        <xsl:otherwise>
          <a href="{$eventView}&amp;href={$href}">
            <xsl:choose>
              <xsl:when test="start/allday = 'true' and
                              parent::day/shortdate = start/shortdate">
                <xsl:copy-of select="$bwStr-LsVw-Today"/>
              </xsl:when>
              <xsl:when test="parent::day/shortdate != start/shortdate">
                <span class="littleArrow">&#171;</span>&#160;
                <xsl:value-of select="start/month"/>/<xsl:value-of select="start/day"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="start/time"/>
              </xsl:otherwise>
            </xsl:choose>
            -
           <xsl:choose>
             <xsl:when test="end/allday = 'true' and
                             parent::day/shortdate = end/shortdate">
               <xsl:copy-of select="$bwStr-LsVw-Today"/>
             </xsl:when>
             <xsl:when test="parent::day/shortdate != end/shortdate">
               <xsl:value-of select="end/month"/>/<xsl:value-of select="end/day"/>
               &#160;<span class="littleArrow">&#187;</span>
             </xsl:when>
             <xsl:otherwise>
               <xsl:value-of select="end/time"/>
             </xsl:otherwise>
           </xsl:choose>
          </a>
       </xsl:otherwise>
     </xsl:choose>
    </td>

      <!-- Event Description Column -->

      <td>
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="status='CANCELLED'">description bwStatusCancelled</xsl:when>
          <xsl:when test="status='TENTATIVE'">description bwStatusTentative</xsl:when>
          <xsl:otherwise>description</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>

      <!-- event icons -->
      <span class="icons">
          <xsl:variable name="gStartdate" select="start/utcdate"/>
          <xsl:variable name="gLocation"><xsl:call-template name="url-encode"><xsl:with-param name="str" select="location/address"/></xsl:call-template></xsl:variable>
          <xsl:variable name="gEnddate" select="end/utcdate"/>
          <xsl:variable name="gText"><xsl:call-template name="url-encode"><xsl:with-param name="str" select="summary"/></xsl:call-template></xsl:variable>
          <xsl:variable name="gDetails" select="$gText"/>
        <!-- this could be changed to better reflect the details -->

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
            <xsl:variable name="shareURL"><xsl:value-of select="/bedework/urlprefix"/>/event/eventView.do?b=de&amp;calPath=/public/cals/MainCal&amp;guid=<xsl:value-of select="guid"/>&amp;recurrenceId=<xsl:value-of select="recurrenceId"/></xsl:variable>
            <xsl:variable name="encodedShareURL">
              <xsl:call-template name="url-encode">
                <xsl:with-param name="str" select="$shareURL"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="noNewLineDetails">
              <xsl:call-template name="replace">
                <xsl:with-param name="string" select="description"/>
                <xsl:with-param name="pattern" select="'&#xa;'"/>
                <xsl:with-param name="substitution" select="''"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="shareThisId">shareThis--<xsl:value-of select="$guid"/><xsl:value-of select="recurrenceId"/></xsl:variable>
            <span id="{$shareThisId}">
              <script type="text/javascript">
                stWidget.addEntry({
                  "service":"sharethis",
                  "element":document.getElementById('<xsl:value-of select="$shareThisId"/>'),
                  "title":'<xsl:call-template name="escapeApos"><xsl:with-param name="str" select="$gText"/></xsl:call-template>',
                  "content":'<xsl:call-template name="escapeApos"><xsl:with-param name="str" select="$noNewLineDetails"/></xsl:call-template>',
                  "summary":'<xsl:value-of select="$shareThisSummary"/>',
                  "url":'<xsl:value-of select="$encodedShareURL"/>'
                });
              </script>
            </span>
          </xsl:if>
        </span>

      <ul class="eventInfoLauncher">
        <li class="titleEvent">
          <!-- event title -->
          <xsl:if test="status='CANCELLED'"><strong><xsl:copy-of select="$bwStr-LsVw-Canceled"/><xsl:text> </xsl:text></strong></xsl:if>
          <xsl:if test="status='TENTATIVE'"><strong><xsl:copy-of select="$bwStr-LsEv-Tentative"/><xsl:text> </xsl:text></strong></xsl:if>
          <a href="{$eventView}&amp;href={$href}">
            <xsl:value-of select="summary"/>
            <xsl:if test="summary = ''">
              <xsl:copy-of select="$bwStr-SgEv-NoTitle"/>
            </xsl:if>
          </a>
        </li>

          <li>
            <span class="bwFieldName"><xsl:copy-of select="$bwStr-LsVw-Location"/><xsl:text> </xsl:text></span>
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
          </li>

        <!-- items to display only in detail mode -->
        <xsl:if test="/bedework/appvar[key='summaryMode']/value='details'">

          <xsl:if test="cost!=''">
            <li>
              <xsl:copy-of select="$bwStr-LsVw-Cost"/><xsl:text> </xsl:text>
              <xsl:value-of select="cost"/>
            </li>
          </xsl:if>

          <xsl:if test="contact/name!='none'">
            <li>
              <xsl:copy-of select="$bwStr-LsVw-Contact"/><xsl:text> </xsl:text>
              <xsl:value-of select="contact/name"/>
            </li>
          </xsl:if>

          <li>
            <xsl:copy-of select="$bwStr-LsVw-Description"/><xsl:text> </xsl:text>
            <xsl:value-of select="description"/>
          </li>

          <xsl:if test="link != ''">
            <li>
              <xsl:copy-of select="$bwStr-LsVw-Link"/><xsl:text> </xsl:text>
              <a>
                <xsl:attribute name="href"><xsl:value-of select="link"/></xsl:attribute>
                <xsl:value-of select="link"/>
              </a>
            </li>
          </xsl:if>

        </xsl:if>

        <!-- always show the aliases -->
        <xsl:if test="xproperties/X-BEDEWORK-ALIAS">
          <li>
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
          </li>
        </xsl:if>
      </ul>
    </td>
      <!-- td class="icons">
          keep and place icons here if spacing is an issue
          (but change the day cell to colspan=3)
        </td-->
    </tr>
  </xsl:template>

</xsl:stylesheet>
