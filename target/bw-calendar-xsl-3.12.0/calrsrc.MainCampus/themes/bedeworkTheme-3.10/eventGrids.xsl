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
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


  <!--==== WEEK CALENDAR VIEW ====-->
  <xsl:template name="weekGrid">
    <table id="gridCalendarTable" border="0" cellpadding="0" cellspacing="0">
      <tr>
        <xsl:for-each select="/bedework/daynames/val">
          <th class="dayHeading"><xsl:value-of select="."/></th>
        </xsl:for-each>
      </tr>
      <tr>
        <xsl:for-each select="/bedework/eventscalendar/year/month/week/day">
          <xsl:variable name="dayPos" select="position()"/>
          <xsl:if test="filler='false'">
            <td>
              <xsl:if test="/bedework/now/date = date">
                <xsl:attribute name="class">today</xsl:attribute>
              </xsl:if>
              <xsl:variable name="dayDate" select="date"/>
              <a href="{$setViewPeriod}&amp;viewType=dayView&amp;date={$dayDate}" class="dayLink">
                <xsl:value-of select="value"/>
              </a>
              <xsl:if test="event">
                <ul>
                  <xsl:apply-templates select="event" mode="calendarLayout">
                    <xsl:with-param name="dayPos" select="$dayPos"/>
                  </xsl:apply-templates>
                </ul>
              </xsl:if>
            </td>
          </xsl:if>
        </xsl:for-each>
      </tr>
    </table>
  </xsl:template>

  <!--==== MONTH CALENDAR VIEW ====-->
  <xsl:template name="monthGrid">
    <table id="gridCalendarTable" border="0" cellpadding="0" cellspacing="0">
      <tr>
        <xsl:for-each select="/bedework/daynames/val">
          <th class="dayHeading"><xsl:value-of select="."/></th>
        </xsl:for-each>
      </tr>
      <xsl:for-each select="/bedework/eventscalendar/year/month/week">
        <tr>
          <xsl:for-each select="day">
            <xsl:variable name="dayPos" select="position()"/>
            <xsl:choose>
              <xsl:when test="filler='true'">
                <td class="filler">&#160;</td>
              </xsl:when>
              <xsl:otherwise>
                <td>
                  <xsl:if test="/bedework/now/date = date">
                    <xsl:attribute name="class">today</xsl:attribute>
                  </xsl:if>
                  <xsl:variable name="dayDate" select="date"/>
                  <a href="{$setViewPeriod}&amp;viewType=dayView&amp;date={$dayDate}" class="dayLink">
                    <xsl:value-of select="value"/>
                  </a>
                  <xsl:if test="event">
                    <ul>
                      <xsl:apply-templates select="event" mode="calendarLayout">
                        <xsl:with-param name="dayPos" select="$dayPos"/>
                      </xsl:apply-templates>
                    </ul>
                  </xsl:if>
                </td>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <!--== EVENTS IN THE CALENDAR GRID ==-->
  <xsl:template match="event" mode="calendarLayout">
    <xsl:param name="dayPos"/>
    <xsl:variable name="calPath" select="calendar/encodedPath"/>
    <xsl:variable name="guid" select="guid"/>
    <xsl:variable name="href" select="encodedHref"/>
    <xsl:variable name="recurrenceId" select="recurrenceId"/>
    <xsl:variable name="eventClass">
      <xsl:choose>
        <!-- Special styles for the month grid -->
        <xsl:when test="status='CANCELLED'">eventCancelled</xsl:when>
        <xsl:when test="status='TENTATIVE'">eventTentative</xsl:when>
        <!-- Default alternating colors for all standard events -->
        <xsl:when test="position() mod 2 = 1">eventLinkA</xsl:when>
        <xsl:otherwise>eventLinkB</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!-- Subscription styles.
         These are set in the add/modify subscription forms in the admin client;
         if present, these override the background-color set by eventClass. The
         subscription styles should not be used for canceled events (tentative is ok). -->
    <xsl:variable name="subscriptionClass">
      <xsl:if test="status != 'CANCELLED'">
        <xsl:apply-templates select="categories" mode="customEventColor"/>
      </xsl:if>
    </xsl:variable>
    <li>
      <a href="{$eventView}&amp;href={$href}" class="{$eventClass} {$subscriptionClass}">
        <xsl:if test="status='CANCELLED'"><xsl:copy-of select="$bwStr-EvCG-CanceledColon"/><xsl:text> </xsl:text></xsl:if>
        <xsl:choose>
          <xsl:when test="start/shortdate != ../shortdate">
            <xsl:copy-of select="$bwStr-EvCG-Cont"/>
          </xsl:when>
          <xsl:when test="start/allday = 'false'">
            <xsl:value-of select="start/time"/>:
          </xsl:when>
          <xsl:otherwise>
            <xsl:copy-of select="$bwStr-EvCG-AllDayColon"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="summary"/>
        <xsl:variable name="eventTipClass">
          <xsl:choose>
            <xsl:when test="$dayPos &gt; 5">eventTipReverse</xsl:when>
            <xsl:otherwise>eventTip</xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <span class="{$eventTipClass}">
          <xsl:if test="status='CANCELLED'"><span class="eventTipStatusCancelled"><xsl:copy-of select="$bwStr-EvCG-CanceledColon"/></span></xsl:if>
          <xsl:if test="status='TENTATIVE'"><span class="eventTipStatusTentative"><xsl:copy-of select="$bwStr-EvCG-Tentative"/></span></xsl:if>
          <strong><xsl:value-of select="summary"/></strong><br/>
          <xsl:copy-of select="$bwStr-EvCG-Time"/>
          <xsl:choose>
            <xsl:when test="start/allday = 'true'">
              <xsl:copy-of select="$bwStr-EvCG-AllDay"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:if test="start/shortdate != ../shortdate">
                <xsl:value-of select="start/month"/>/<xsl:value-of select="start/day"/>
                <xsl:text> </xsl:text>
              </xsl:if>
              <xsl:value-of select="start/time"/>
              <xsl:if test="(start/time != end/time) or (start/shortdate != end/shortdate)">
                -
                <xsl:if test="end/shortdate != ../shortdate">
                  <xsl:value-of select="end/month"/>/<xsl:value-of select="end/day"/>
                  <xsl:text> </xsl:text>
                </xsl:if>
                <xsl:value-of select="end/time"/>
              </xsl:if>
            </xsl:otherwise>
          </xsl:choose><br/>
          <xsl:if test="location/address">
            <xsl:copy-of select="$bwStr-EvCG-Location"/><xsl:text> </xsl:text><xsl:value-of select="location/address"/><br/>
          </xsl:if>
          <xsl:if test="xproperties/X-BEDEWORK-ALIAS">
            <xsl:copy-of select="$bwStr-EvCG-TopicalArea"/>
              <xsl:for-each select="xproperties/X-BEDEWORK-ALIAS">
                <xsl:call-template name="substring-afterLastInstanceOf">
                  <xsl:with-param name="string" select="values/text"/>
                  <xsl:with-param name="char">/</xsl:with-param>
                </xsl:call-template>
                <xsl:if test="position()!=last()">, </xsl:if>
              </xsl:for-each>
          </xsl:if>
        </span>
      </a>
    </li>
  </xsl:template>

    <xsl:template match="categories" mode="customEventColor">
    <!-- Set custom color schemes here.
         This template looks at the categories found in the event and
         returns a color class for use with the "subscriptionClass" variable.
         The classes suggested below come from bwColors.css found in the bedework-common directory. -->
      <xsl:choose>
       <!--
       <xsl:when test="category/value = 'Athletics'">bwltpurple</xsl:when>
       <xsl:when test="category/value = 'Arts'">bwltsalmon</xsl:when>
       -->
        <xsl:otherwise></xsl:otherwise> <!-- do nothing -->
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>