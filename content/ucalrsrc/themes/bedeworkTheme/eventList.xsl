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

  <!--==== LIST VIEW  (for day, week, and month) ====-->
  <xsl:template name="listView">
    <table id="listTable" border="0" cellpadding="0" cellspacing="0">
      <xsl:choose>
        <xsl:when test="not(/bedework/eventscalendar/year/month/week/day/event[not(entityType=2)])">
          <tr>
            <td class="noEventsCell">
              <xsl:copy-of select="$bwStr-LsVw-NoEventsToDisplay"/>
            </td>
          </tr>
        </xsl:when>
        <xsl:otherwise>
          <xsl:for-each select="/bedework/eventscalendar/year/month/week/day[event[not(entityType=2)]]">
            <!-- tasks (entityType=2) are displayed below the normal event listings.  Reminders (tasks without
               start or end dates) can also be represented as:
               entityType=2 and start/noStart='true' and end/type='N'; we skip them within grid and list views -->
            <xsl:if test="/bedework/periodname='Week' or /bedework/periodname='Month' or /bedework/periodname=''">
              <tr>
                <td colspan="6" class="dateRow">
                  <xsl:variable name="date" select="date"/>
                  <xsl:variable name="actionIconsId">bwActionIcons-<xsl:value-of select="value"/></xsl:variable>
                  <div class="listAdd">
                    <span class="listAddButton">
                      <xsl:copy-of select="$bwStr-LsVw-Add"/>
                    </span>
                    <xsl:call-template name="actionIcons">
                      <xsl:with-param name="actionIconsId"><xsl:value-of select="$actionIconsId"/></xsl:with-param>
                      <xsl:with-param name="startDate"><xsl:value-of select="$date"/></xsl:with-param>
                      <xsl:with-param name="startTime"><xsl:value-of select="/bedework/now/twodigithour24"/>0000</xsl:with-param>
                    </xsl:call-template>
                  </div>
                  <a href="{$setViewPeriod}&amp;viewType=dayView&amp;date={$date}">
                    <xsl:value-of select="name"/>, <xsl:value-of select="longdate"/>
                  </a>
                </td>
              </tr>
            </xsl:if>
            <xsl:for-each select="event[not(entityType=2)]">
              <xsl:variable name="id" select="id"/>
              <xsl:variable name="calPath" select="calendar/encodedPath"/>
              <xsl:variable name="guid"><xsl:call-template name="url-encode"><xsl:with-param name="str" select="guid"/></xsl:call-template></xsl:variable>
              <xsl:variable name="recurrenceId" select="recurrenceId"/>
              <tr>
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
                <xsl:choose>
                  <xsl:when test="start/allday = 'true' and
                                  start/shortdate = end/shortdate">
                    <td class="{$dateRangeStyle} center" colspan="3">
                      <xsl:copy-of select="$bwStr-LsVw-AllDay"/>
                    </td>
                  </xsl:when>
                  <xsl:when test="start/shortdate = end/shortdate and
                                  start/time = end/time">
                    <td class="{$dateRangeStyle} center" colspan="3">
                      <a href="{$eventView}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
                        <xsl:value-of select="start/time"/>
                      </a>
                    </td>
                  </xsl:when>
                  <xsl:otherwise>
                    <td class="{$dateRangeStyle} right">
                      <a href="{$eventView}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
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
                      </a>
                    </td>
                    <td class="{$dateRangeStyle} center">
                      <a href="{$eventView}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">-</a>
                    </td>
                    <td class="{$dateRangeStyle} left">
                      <a href="{$eventView}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
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
                    </td>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:variable name="descriptionClass">
                  <xsl:choose>
                    <xsl:when test="status='CANCELLED'">description bwStatusCancelled</xsl:when>
                    <xsl:when test="status='TENTATIVE'">description bwStatusTentative</xsl:when>
                    <xsl:otherwise><xsl:copy-of select="$bwStr-LsVw-Description"/></xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <xsl:variable name="subStyle" select="subscription/subStyle"/>
                <td class="{$descriptionClass} {$subStyle}">
                  <xsl:if test="status='CANCELLED'"><strong><xsl:copy-of select="$bwStr-LsVw-Canceled"/><xsl:text> </xsl:text></strong></xsl:if>
                  <xsl:choose>
                    <xsl:when test="/bedework/appvar[key='summaryMode']/value='details'">
                      <a href="{$eventView}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
                        <xsl:choose>
                          <xsl:when test="summary = ''">
                            <em><xsl:copy-of select="$bwStr-LsVw-NoTitle"/></em>
                          </xsl:when>
                          <xsl:otherwise>
                            <strong>
                              <xsl:value-of select="summary"/>:
                            </strong>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:value-of select="description"/>&#160;
                        <em>
                          <xsl:value-of select="location/address"/>
                          <xsl:if test="location/subaddress != ''">
                            , <xsl:value-of select="location/subaddress"/>
                          </xsl:if>.&#160;
                          <xsl:if test="cost!=''">
                            <xsl:value-of select="cost"/>.&#160;
                          </xsl:if>
                          <xsl:if test="sponsor/name!='none'">
                            <xsl:copy-of select="$bwStr-LsVw-Contact"/><xsl:text> </xsl:text><xsl:value-of select="sponsor/name"/>
                          </xsl:if>
                        </em>
                      </a>
                      <xsl:if test="link != ''">
                        <xsl:variable name="link" select="link"/>
                        <a href="{$link}" class="moreLink"><xsl:value-of select="link"/></a>
                      </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                      <a href="{$eventView}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
                        <xsl:choose>
                          <xsl:when test="summary = ''">
                            <em><xsl:copy-of select="$bwStr-LsVw-NoTitle"/></em>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of select="summary"/>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="location/address != ''">, <xsl:value-of select="location/address"/></xsl:if>
                      </a>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="eventLinks">
                  <xsl:call-template name="eventLinks"/>
                </td>
                <td class="smallIcon">
                  <xsl:variable name="eventIcalName" select="concat($guid,'.ics')"/>
                  <a href="{$export}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}&amp;nocache=no&amp;contentName={$eventIcalName}" title="{$bwStr-LsVw-DownloadEvent}">
                    <img src="{$resourcesRoot}/images/std-ical_icon_small.gif" width="12" height="16" border="0" alt="{$bwStr-LsVw-DownloadEvent}"/>
                  </a>
                </td>
              </tr>
            </xsl:for-each>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
    </table>
    <xsl:if test="$publicOnly = 'false'">
      <xsl:call-template name="tasks"/>
    </xsl:if>
  </xsl:template>

  <xsl:template name="eventLinks">
    <xsl:variable name="calPath" select="calendar/encodedPath"/>
    <xsl:variable name="eventName" select="name"/>
    <xsl:variable name="guid"><xsl:call-template name="url-encode"><xsl:with-param name="str" select="guid"/></xsl:call-template></xsl:variable>
    <xsl:variable name="recurrenceId" select="recurrenceId"/>
    <xsl:if test="currentAccess/current-user-privilege-set/privilege/write-content">
      <xsl:choose>
        <xsl:when test="recurring='true' or recurrenceId != ''">
          <xsl:copy-of select="$bwStr-EvLn-EditColon"/><xsl:text> </xsl:text>
          <a href="{$editEvent}&amp;calPath={$calPath}&amp;guid={$guid}" title="{$bwStr-EvLn-EditMaster}"><xsl:copy-of select="$bwStr-EvLn-All"/></a>
          <a href="{$editEvent}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}" title="{$bwStr-EvLn-EditInstance}"><xsl:copy-of select="$bwStr-EvLn-Instance"/></a>
          <br/>
        </xsl:when>
        <xsl:otherwise>
          <a href="{$editEvent}&amp;calPath={$calPath}&amp;guid={$guid}" title="{$bwStr-EvLn-EditEvent}">
            <xsl:copy-of select="$bwStr-EvLn-Edit"/>
          </a>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <xsl:if test="not(currentAccess/current-user-privilege-set/privilege/write-content) and not(recurring='true' or recurrenceId != '')">
      <!-- temporarily hide from Recurring events -->
      <a href="{$addEventRef}&amp;calPath={$calPath}&amp;guid={$guid}" title="{$bwStr-EvLn-AddEventReference}">
        <xsl:copy-of select="$bwStr-EvLn-Link"/>
      </a>
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:if test="currentAccess/current-user-privilege-set/privilege/unbind">
      <xsl:choose>
        <xsl:when test="recurring='true' or recurrenceId != ''">
          <xsl:copy-of select="$bwStr-EvLn-DeleteColon"/><xsl:text> </xsl:text>
          <a href="{$delEvent}&amp;calPath={$calPath}&amp;eventName={$eventName}" title="{$bwStr-EvLn-DeleteMaster}" onclick="return confirm('{$bwStr-EvLn-DeleteAllRecurrences}');"><xsl:copy-of select="$bwStr-EvLn-All"/></a>
          <a href="{$delEvent}&amp;calPath={$calPath}&amp;eventName={$eventName}&amp;recurrenceId={$recurrenceId}" title="{$bwStr-EvLn-DeleteInstance}" onclick="return confirm('{$bwStr-EvLn-DeleteThisEvent}');"><xsl:copy-of select="$bwStr-EvLn-Instance"/></a>
        </xsl:when>
        <xsl:otherwise>
          <a href="{$delEvent}&amp;calPath={$calPath}&amp;eventName={$eventName}&amp;recurrenceId={$recurrenceId}" title="{$bwStr-EvLn-DeleteEvent}" onclick="return confirm('{$bwStr-EvLn-DeleteThisEvent}');">
            <xsl:copy-of select="$bwStr-EvLn-Delete"/>
          </a>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>


</xsl:stylesheet>