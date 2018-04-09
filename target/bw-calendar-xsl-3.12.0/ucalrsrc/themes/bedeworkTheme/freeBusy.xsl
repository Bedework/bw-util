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
  
  <!--+++++++++++++++ Free / Busy ++++++++++++++++++++-->
  <xsl:template match="freebusy" mode="freeBusyPage">
    <span id="freeBusyShareLink">
      <a href="{$calendar-fetch}">share my free-busy</a>
      <!--<div dojoType="FloatingPane" id="bwHelpWidget-shareFreeBusy"
               title="Bedework Help" toggle="plain"
               windowState="minimized" hasShadow="true"
               displayMinimizeAction="true" resizable="false"
               constrainToContainer="true">
        You may share your free busy with a user or group
        by <a href="{$calendar-fetch}">setting
        access to "read freebusy" on calendars</a> you wish to share.
        To share all your free busy, grant
        "read freebusy" access on your root folder.
      </div>
      <span class="contextHelp">
        <a href="javascript:launchHelpWidget('bwHelpWidget-shareFreeBusy')">
          <img src="{$resourcesRoot}/images/std-button-help.gif" width="13" height="13" border="0" alt="help"/>
        </a>
      </span>-->
      <span class="contextHelp">
        <img src="{$resourcesRoot}/images/std-button-help.gif" width="13" height="13" alt="help" onmouseover="changeClass('helpShareFreeBusy','visible helpBox');" onmouseout="changeClass('helpShareFreeBusy','invisible');"/>
      </span>
      <div id="helpShareFreeBusy" class="helpBox invisible">
          <xsl:copy-of select="$bwStr-FrBu-YouMayShareYourFreeBusy"/>
      </div>
    </span>
    <h2>
      <xsl:copy-of select="$bwStr-FrBu-FreeBusy"/>
    </h2>

    <div id="freeBusyPage">
      <form name="viewFreeBusyForm" id="viewFreeBusyForm" method="post" action="{$freeBusy-fetch}">
        <xsl:copy-of select="$bwStr-FrBu-ViewUsersFreeBusy"/>
        <input type="text" name="userid" size="20"/>
        <input type="submit" name="submit" value="Submit"/>
      </form>
      <xsl:apply-templates select="." mode="freeBusyGrid">
        <xsl:with-param name="type">normal</xsl:with-param>
      </xsl:apply-templates>
    </div>
  </xsl:template>
  
  <xsl:template match="freebusy" mode="freeBusyGrid">
    <xsl:param name="aggregation">false</xsl:param>
    <xsl:param name="type">normal</xsl:param>
      <table id="freeBusy">
        <tr>
          <td>&#160;</td>
          <td colspan="24" class="left">
            <xsl:copy-of select="$bwStr-FrBu-FreebusyFor"/><xsl:text> </xsl:text>
            <span class="who">
              <xsl:choose>
                <xsl:when test="$aggregation = 'true'">
                  <xsl:copy-of select="$bwStr-FrBu-AllAttendees"/>
                </xsl:when>
                <xsl:when test="starts-with(fbattendee/recipient,'mailto:')">
                  <xsl:value-of select="substring-after(fbattendee/recipient,'mailto:')"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="fbattendee/recipient"/>
                </xsl:otherwise>
              </xsl:choose>
            </span>
          </td>
          <!-- at some point allow switching of timezones:
          <td colspan="24" class="right">
            <xsl:variable name="currentTimezone">America/Los_Angeles</xsl:variable>
            <xsl:value-of select="$formattedStartDate"/> to <xsl:value-of select="$formattedEndDate"/>
            <select name="timezone" id="timezonesDropDown" onchange="submit()">
              <xsl:for-each select="/bedework-fbaggregator/timezones/tzid">
                <option>
                  <xsl:attribute name="value"><xsl:value-of select="."/></xsl:attribute>
                  <xsl:if test="node() = $currentTimezone"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
                  <xsl:value-of select="."/>
                </option>
              </xsl:for-each>
            </select>
          </td>-->
        </tr>
        <tr>
          <td>&#160;</td>
          <td colspan="12" class="morning"><xsl:copy-of select="$bwStr-FrBu-AM"/></td>
          <td colspan="12" class="evening"><xsl:copy-of select="$bwStr-FrBu-PM"/></td>
        </tr>
        <tr>
          <td>&#160;</td>
          <xsl:for-each select="day[position()=1]/period">
            <td class="timeLabels">
              <xsl:choose>
                <xsl:when test="number(start) mod 200 = 0">
                  <xsl:call-template name="timeFormatter">
                    <xsl:with-param name="timeString" select="start"/>
                    <xsl:with-param name="showMinutes">no</xsl:with-param>
                    <xsl:with-param name="showAmPm">no</xsl:with-param>
                  </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                  &#160;
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </xsl:for-each>
        </tr>
        <xsl:for-each select="day">
          <tr>
            <td class="dayDate"><xsl:value-of select="number(substring(dateString,5,2))"/>-<xsl:value-of select="number(substring(dateString,7,2))"/></td>
            <xsl:for-each select="period">
              <xsl:variable name="startTime" select="start"/>
              <!-- the start date for the add event link is a concat of the day's date plus the period's time (+ seconds)-->
              <xsl:variable name="startDate"><xsl:value-of select="../dateString"/>T<xsl:value-of select="start"/>00</xsl:variable>
              <xsl:variable name="meetingDuration" select="length"/>
              <td>
                <xsl:attribute name="class">
                  <xsl:choose>
                    <xsl:when test="fbtype = '0'"><xsl:copy-of select="$bwStr-FrBu-Busy"/></xsl:when>
                    <xsl:when test="fbtype = '3'"><xsl:copy-of select="$bwStr-FrBu-Tentative"/></xsl:when>
                    <xsl:otherwise><xsl:copy-of select="$bwStr-FrBu-Free"/></xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
                <xsl:variable name="action">
                  <xsl:choose>
                    <xsl:when test="$aggregation = 'true'"><xsl:value-of select="$updateEvent"/></xsl:when>
                    <xsl:otherwise><xsl:value-of select="$initEvent"/></xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <xsl:variable name="urlString">
                  <xsl:choose>
                   <xsl:when test="$type='meeting'"><xsl:value-of select="$action"/>&amp;meetingStartdt=<xsl:value-of select="$startDate"/>&amp;meetingDuration=<xsl:value-of select="$meetingDuration"/>&amp;initDates=yes</xsl:when>
                   <xsl:otherwise><xsl:value-of select="$action"/>&amp;startdate=<xsl:value-of select="$startDate"/>&amp;minutes=<xsl:value-of select="$meetingDuration"/></xsl:otherwise>
                 </xsl:choose>
                </xsl:variable>
                <a href="{$urlString}">
                  <xsl:choose>
                    <xsl:when test="((numBusy &gt; 0) and (numBusy &lt; 9)) or ((numTentative &gt; 0) and (numTentative &lt; 9)) and (number(numBusy) + number(numTentative) &lt; 9)">
                      <xsl:value-of select="number(numBusy) + number(numTentative)"/>
                    </xsl:when>
                    <xsl:otherwise><img src="{$resourcesRoot}/images/spacer.gif" width="10" height="20" border="0" alt="f"/></xsl:otherwise>
                  </xsl:choose>
                  <span class="eventTip">
                    <xsl:value-of select="substring(../dateString,1,4)"/>-<xsl:value-of select="number(substring(../dateString,5,2))"/>-<xsl:value-of select="number(substring(../dateString,7,2))"/>
                    <br/>
                    <strong>
                      <xsl:call-template name="timeFormatter">
                        <xsl:with-param name="timeString" select="$startTime"/>
                      </xsl:call-template>
                    </strong>
                    <xsl:if test="numBusy &gt; 0">
                      <br/><xsl:value-of select="numBusy"/><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-FrBu-Busy"/>
                    </xsl:if>
                    <xsl:if test="numTentative &gt; 0">
                      <br/><xsl:value-of select="numTentative"/><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-FrBu-Tentative"/>
                    </xsl:if>
                    <xsl:if test="numBusy = 0 and numTentative = 0">
                      <br/><em><xsl:copy-of select="$bwStr-FrBu-AllFree"/></em>
                    </xsl:if>
                  </span>
                </a>
              </td>
            </xsl:for-each>
          </tr>
        </xsl:for-each>
      </table>

      <table id="freeBusyKey">
        <tr>
          <td class="free">*</td>
          <td><xsl:copy-of select="$bwStr-FrBu-Free"/></td>
          <td>&#160;</td>
          <td class="busy">*</td>
          <td><xsl:copy-of select="$bwStr-FrBu-Busy"/></td>
          <td>&#160;</td>
          <td class="tentative">*</td>
          <td><xsl:copy-of select="$bwStr-FrBu-Tentative"/></td>
        </tr>
      </table>
  </xsl:template>
  
  <!-- time formatter (should be extended as needed) -->
  <xsl:template name="timeFormatter">
    <xsl:param name="timeString"/><!-- required -->
    <xsl:param name="showMinutes">yes</xsl:param>
    <xsl:param name="showAmPm">yes</xsl:param>
    <xsl:param name="hour24">no</xsl:param>
    <xsl:variable name="hour" select="number(substring($timeString,1,2))"/>
    <xsl:variable name="minutes" select="substring($timeString,3,2)"/>
    <xsl:variable name="AmPm">
      <xsl:choose>
        <xsl:when test="$hour &lt; 12"><xsl:copy-of select="$bwStr-TiFo-AM"/></xsl:when>
        <xsl:otherwise><xsl:copy-of select="$bwStr-TiFo-PM"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="hour24 = 'yes'">
        <xsl:value-of select="$hour"/><!--
     --><xsl:if test="$showMinutes = 'yes'">:<xsl:value-of select="$minutes"/></xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$hour = 0">12</xsl:when>
          <xsl:when test="$hour &lt; 13"><xsl:value-of select="$hour"/></xsl:when>
          <xsl:otherwise><xsl:value-of select="$hour - 12"/></xsl:otherwise>
        </xsl:choose><!--
     --><xsl:if test="$showMinutes = 'yes'">:<xsl:value-of select="$minutes"/></xsl:if>
        <xsl:if test="$showAmPm = 'yes'">
          <xsl:text> </xsl:text>
          <xsl:value-of select="$AmPm"/>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
</xsl:stylesheet>