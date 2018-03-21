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

  <!--==== WEEK CALENDAR VIEW ====-->
  <xsl:template name="weekView">
    <table id="monthCalendarTable" border="0" cellpadding="0" cellspacing="0">
      <tr>
        <xsl:for-each select="/bedework/daynames/val">
          <th class="dayHeading"><xsl:value-of select="."/></th>
        </xsl:for-each>
      </tr>
      <tr>
        <xsl:for-each select="/bedework/eventscalendar/year/month/week/day">
          <xsl:variable name="dayPos" select="position()"/>
          <xsl:if test="filler='false'">
            <td class="bwActiveDay">
              <xsl:if test="/bedework/now/date = date">
                <xsl:attribute name="class">today bwActiveDay</xsl:attribute>
              </xsl:if>
              <xsl:variable name="dayDate" select="date"/>
              <xsl:variable name="actionIconsId">bwActionIcons-<xsl:value-of select="value"/></xsl:variable>
              <a href="{$setViewPeriod}&amp;viewType=dayView&amp;date={$dayDate}" class="dayLink" title="{$bwStr-LsEv-GoToDay}">
                <xsl:value-of select="value"/>
              </a>
              <div class="gridAdd">
                <!-- a href="javascript:toggleActionIcons('{$actionIconsId}','bwActionIcons bwActionIconsInGrid')" title="add...">
                  <img src="{$resourcesRoot}/images/addEvent-forGrid-icon.gif" width="10" height="10" border="0" alt="add..."/>
                </a-->
                <xsl:call-template name="actionIcons">
                  <xsl:with-param name="actionIconsId"><xsl:value-of select="$actionIconsId"/></xsl:with-param>
                  <xsl:with-param name="startDate"><xsl:value-of select="$dayDate"/></xsl:with-param>
                  <xsl:with-param name="startTime"><xsl:value-of select="/bedework/now/twodigithour24"/>0000</xsl:with-param>
                </xsl:call-template>
              </div>
              <xsl:if test="event">
                <ul>
                  <xsl:apply-templates select="event[not(entityType=2)]" mode="calendarLayout">
                    <xsl:with-param name="dayPos" select="$dayPos"/>
                  </xsl:apply-templates>
                </ul>
              </xsl:if>
            </td>
          </xsl:if>
        </xsl:for-each>
      </tr>
    </table>
    <xsl:if test="$publicOnly = 'false'">
      <xsl:call-template name="tasks"/>
    </xsl:if>
  </xsl:template>

  <!--==== MONTH CALENDAR VIEW ====-->
  <xsl:template name="monthView">
    <table id="monthCalendarTable" border="0" cellpadding="0" cellspacing="0">
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
                <td class="bwActiveDay">
                  <xsl:if test="/bedework/now/date = date">
                    <xsl:attribute name="class">today bwActiveDay</xsl:attribute>
                  </xsl:if>
                  <xsl:variable name="dayDate" select="date"/>
                  <xsl:variable name="actionIconsId">bwActionIcons-<xsl:value-of select="value"/></xsl:variable>
                  <a href="{$setViewPeriod}&amp;viewType=dayView&amp;date={$dayDate}" class="dayLink" title="{$bwStr-LsEv-GoToDay}">
                    <xsl:value-of select="value"/>
                  </a>
                  <div class="gridAdd">
                    <!-- a href="javascript:toggleActionIcons('{$actionIconsId}','bwActionIcons bwActionIconsInGrid')" title="add...">
                      <img src="{$resourcesRoot}/images/addEvent-forGrid-icon.gif" width="10" height="10" border="0" alt="add..."/>
                    </a -->
                    <xsl:call-template name="actionIcons">
                      <xsl:with-param name="actionIconsId"><xsl:value-of select="$actionIconsId"/></xsl:with-param>
                      <xsl:with-param name="startDate"><xsl:value-of select="$dayDate"/></xsl:with-param>
                      <xsl:with-param name="startTime"><xsl:value-of select="/bedework/now/twodigithour24"/>0000</xsl:with-param>
                    </xsl:call-template>
                  </div>
                  <xsl:if test="event">
                    <ul>
                      <xsl:apply-templates select="event[not(entityType=2)]" mode="calendarLayout">
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
    <xsl:if test="$publicOnly = 'false'">
      <xsl:call-template name="tasks"/>
    </xsl:if>
  </xsl:template>

  <!--== EVENTS IN THE CALENDAR GRID ==-->
  <xsl:template match="event" mode="calendarLayout">
    <xsl:param name="dayPos"/>
    <xsl:variable name="calPath" select="calendar/encodedPath"/>
    <xsl:variable name="guid"><xsl:call-template name="url-encode"><xsl:with-param name="str" select="guid"/></xsl:call-template></xsl:variable>
    <xsl:variable name="recurrenceId" select="recurrenceId"/>
    <xsl:variable name="eventRootClass">
      <xsl:choose>
        <!-- Otherwise: Alternating colors for all standard events -->
        <xsl:when test="position() = 1">event firstEvent</xsl:when>
        <xsl:otherwise>event</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="eventClass">
      <xsl:choose>
        <!-- Special styles for the month grid -->
        <xsl:when test="status='CANCELLED'">eventCancelled</xsl:when>
        <xsl:when test="status='TENTATIVE'">eventTentative</xsl:when>
        <!-- Otherwise: Alternating colors for all standard events -->
        <xsl:when test="position() mod 2 = 1">eventLinkA</xsl:when>
        <xsl:otherwise>eventLinkB</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="calendarColor">
      <xsl:choose>
        <xsl:when test="color and color != ''"><xsl:value-of select="color"/></xsl:when>
        <xsl:when test="xproperties/X-BEDEWORK-ALIAS/values/text = /bedework/myCalendars//calendar/path"><xsl:value-of select="/bedework/myCalendars//calendar[path=xproperties/X-BEDEWORK-ALIAS/values/text]/color"/></xsl:when>
        <xsl:when test="calendar/color != '' and calendar/color != 'null'"><xsl:value-of select="calendar/color"/></xsl:when>
        <xsl:when test="not(starts-with(calendar/path,/bedework/myCalendars/calendars/calendar/path))">
          <!-- this event comes from a subscription / shared calendar; look up color on user's calendar -->
          <xsl:variable name="remotePath"><xsl:value-of select="calendar/path"/></xsl:variable>
          <xsl:value-of select="/bedework/myCalendars/calendars//calendar[substring-after(aliasUri,'bwcal://')=$remotePath]/color"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <!-- Calendar colors are set in the add/modify calendar forms which, if present,
         override the background-color set by eventClass. User styles should
         not be used for canceled events (tentative is ok). -->
    <li class="event">
      <a href="{$eventView}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}"
        class="{$eventRootClass} {$eventClass}">
        <xsl:if test="status != 'CANCELLED' and $calendarColor != ''">
          <xsl:attribute name="style">background-color: <xsl:value-of select="$calendarColor"/>; color: black;</xsl:attribute>
        </xsl:if>
        <xsl:if test="status='CANCELLED'"><xsl:copy-of select="$bwStr-EvCG-Canceled"/><xsl:text> </xsl:text></xsl:if>
        <xsl:choose>
          <xsl:when test="start/shortdate != ../shortdate">
            <xsl:copy-of select="$bwStr-EvCG-Cont"/>
            <xsl:text> </xsl:text>
          </xsl:when>
          <xsl:when test="start/allday = 'false'">
            <xsl:value-of select="start/time"/>:
          </xsl:when>
          <xsl:otherwise>
            <xsl:copy-of select="$bwStr-EvCG-AllDayColon"/><xsl:text> </xsl:text>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
          <xsl:when test="summary = ''">
            <em><xsl:copy-of select="$bwStr-EvCG-NoTitle"/><xsl:text> </xsl:text></em>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="summary"/>
          </xsl:otherwise>
        </xsl:choose>
      </a>
      <div>
        <xsl:attribute name="class">
          <xsl:choose>
            <xsl:when test="$dayPos &gt; 5">eventTip eventTipReverse</xsl:when>
            <xsl:otherwise>eventTip</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:if test="status='CANCELLED'"><span class="eventTipStatusCancelled"><xsl:copy-of select="$bwStr-EvCG-Canceled"/></span></xsl:if>
        <xsl:if test="status='TENTATIVE'"><span class="eventTipStatusTentative"><xsl:copy-of select="$bwStr-EvCG-Tentative"/></span></xsl:if>
        <div class="eventTipDetails">
          <xsl:choose>
            <xsl:when test="summary = ''">
              <em><xsl:copy-of select="$bwStr-EvCG-NoTitle"/></em><xsl:text> </xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <strong><xsl:value-of select="summary"/></strong><br/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:copy-of select="$bwStr-EvCG-Time"/><xsl:text> </xsl:text>
          <xsl:choose>
            <xsl:when test="start/allday = 'false'">
              <xsl:value-of select="start/time"/>
              <xsl:if test="start/time != end/time">
                - <xsl:value-of select="end/time"/>
              </xsl:if>
            </xsl:when>
            <xsl:otherwise>
              <xsl:copy-of select="$bwStr-EvCG-AllDay"/>
            </xsl:otherwise>
          </xsl:choose><br/>
          <xsl:if test="normalize-space(location/address) != ''">
            <xsl:copy-of select="$bwStr-EvCG-Location"/><xsl:text> </xsl:text><xsl:value-of select="location/address"/><br/>
          </xsl:if>
          <xsl:copy-of select="$bwStr-EvCG-Type"/>
          <xsl:variable name="entityType">
            <xsl:choose>
              <xsl:when test="entityType = '2'"><xsl:copy-of select="$bwStr-EvCG-Task"/></xsl:when>
              <xsl:when test="scheduleMethod = '2'"><xsl:copy-of select="$bwStr-EvCG-Meeting"/></xsl:when>
              <xsl:otherwise><xsl:copy-of select="$bwStr-EvCG-Event"/></xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:if test="recurring='true' or recurrenceId != ''">
            <xsl:copy-of select="$bwStr-EvCG-Recurring"/><xsl:text> </xsl:text>
          </xsl:if>
          <xsl:variable name="userStr"><xsl:value-of select="/bedework/syspars/userPrincipalRoot"/>/<xsl:value-of select="/bedework/userid"/></xsl:variable>
          <xsl:choose>
            <xsl:when test="$userStr = owner">
              <xsl:copy-of select="$bwStr-EvCG-Personal"/><xsl:text> </xsl:text><xsl:value-of select="$entityType"/>
            </xsl:when>
            <xsl:when test="public = 'true'">
              <xsl:copy-of select="$bwStr-EvCG-Public"/><xsl:text> </xsl:text><xsl:value-of select="$entityType"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$entityType"/>
            </xsl:otherwise>
          </xsl:choose><br/>
          <xsl:copy-of select="$bwStr-EvCG-Calendar"/>
          <xsl:choose>
            <xsl:when test="not(starts-with(calendar/path,/bedework/myCalendars/calendars/calendar/path))">
              <!-- this event comes from a subscription / shared calendar; look up and display the local name -->
              <xsl:variable name="remotePath"><xsl:value-of select="calendar/path"/></xsl:variable>
              <xsl:value-of select="/bedework/myCalendars/calendars//calendar[substring-after(aliasUri,'bwcal://')=$remotePath]/summary"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="calendar/summary"/>
            </xsl:otherwise>
          </xsl:choose>
        </div>
        <ul class="eventActionsInGrid">
          <li>
            <a href="{$eventView}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
              <img src="{$resourcesRoot}/images/glassFill-icon-viewGray.gif" width="13" height="13" border="0" alt="view"/>
              <xsl:text> </xsl:text>
              <xsl:copy-of select="$bwStr-EvCG-ViewDetails"/>
            </a>
          </li>
          <li>
            <!-- download -->
            <xsl:variable name="eventIcalName" select="concat($guid,'.ics')"/>
            <xsl:choose>
              <xsl:when test="recurring='true' or recurrenceId != ''">
                <img src="{$resourcesRoot}/images/std-icalDownload-icon-small.gif" width="12" height="16" border="0" alt="{$bwStr-EvCG-DownloadEvent}"/>
                <xsl:text> </xsl:text>
                <xsl:copy-of select="$bwStr-EvCG-Download"/><xsl:text> </xsl:text>
                <a href="{$export}&amp;calPath={$calPath}&amp;guid={$guid}&amp;nocache=no&amp;contentName={$eventIcalName}" title="{$bwStr-EvCG-DownloadMaster}">
                  <xsl:copy-of select="$bwStr-EvCG-All"/>
                </a>,
                <a href="{$export}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}&amp;nocache=no&amp;contentName={$eventIcalName}" title="{$bwStr-EvCG-DownloadThisInstance}">
                  <xsl:copy-of select="$bwStr-EvCG-Instance"/>
                </a>
              </xsl:when>
              <xsl:otherwise>
                <a href="{$export}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}&amp;nocache=no&amp;contentName={$eventIcalName}" title="{$bwStr-EvCG-DownloadEvent}">
                  <img src="{$resourcesRoot}/images/std-icalDownload-icon-small.gif" width="12" height="16" border="0" alt="{$bwStr-EvCG-DownloadEvent}"/>
                  <xsl:text> </xsl:text>
                  <xsl:copy-of select="$bwStr-EvCG-Download"/>
                </a>
              </xsl:otherwise>
            </xsl:choose>
          </li>
          <xsl:if test="currentAccess/current-user-privilege-set/privilege/write-content">
            <li>
              <xsl:choose>
                <xsl:when test="recurring='true' or recurrenceId != ''">
                  <img src="{$resourcesRoot}/images/std-ical_iconEditDkGray.gif" width="12" height="16" border="0" alt="edit master"/>
                  <xsl:text> </xsl:text>
                  <xsl:copy-of select="$bwStr-EvCG-EditColon"/><xsl:text> </xsl:text>
                  <a href="{$editEvent}&amp;calPath={$calPath}&amp;guid={$guid}" title="{$bwStr-EvCG-EditMaster}">
                    <xsl:copy-of select="$bwStr-EvCG-All"/>
                  </a>,
                  <a href="{$editEvent}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}" title="{$bwStr-EvCG-EditThisInstance}">
                    <xsl:copy-of select="$bwStr-EvCG-Instance"/>
                  </a>
                </xsl:when>
                <xsl:otherwise>
                  <a href="{$editEvent}&amp;calPath={$calPath}&amp;guid={$guid}" title="{$bwStr-EvCG-EditEvent}">
                    <img src="{$resourcesRoot}/images/std-ical_iconEditDkGray.gif" width="12" height="16" border="0" alt="edit"/>
                    <xsl:text> </xsl:text>
                    <xsl:text> </xsl:text><xsl:copy-of select="$bwStr-EvCG-Edit"/>
                  </a>
                </xsl:otherwise>
              </xsl:choose>
            </li>
          </xsl:if>
          <li>
            <xsl:choose>
              <xsl:when test="recurring='true' or recurrenceId != ''">
                <img src="{$resourcesRoot}/images/std-ical_iconEditDkGray.gif" width="12" height="16" border="0" alt="edit master"/>
                <xsl:text> </xsl:text>
                <xsl:copy-of select="$bwStr-EvCG-CopyColon"/><xsl:text> </xsl:text>
                <a href="{$editEvent}&amp;calPath={$calPath}&amp;guid={$guid}&amp;copy=true" title="{$bwStr-EvCG-CopyMaster}">
                  <xsl:copy-of select="$bwStr-EvCG-All"/>
                </a>,
                <a href="{$editEvent}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}&amp;copy=true" title="{$bwStr-EvCG-CopyThisInstance}">
                  <xsl:copy-of select="$bwStr-EvCG-Instance"/>
                </a>
              </xsl:when>
              <xsl:otherwise>
                <a href="{$editEvent}&amp;calPath={$calPath}&amp;guid={$guid}&amp;copy=true" title="{$bwStr-EvCG-CopyEvent}">
                  <img src="{$resourcesRoot}/images/std-ical_iconEditDkGray.gif" width="12" height="16" border="0" alt="edit"/>
                  <xsl:text> </xsl:text><xsl:copy-of select="$bwStr-EvCG-Copy"/>
                </a>
              </xsl:otherwise>
            </xsl:choose>
          </li>

          <xsl:if test="not(currentAccess/current-user-privilege-set/privilege/write-content) and not(recurring='true' or recurrenceId != '')">
            <li>
              <!-- temporarily hide from Recurring events -->
              <xsl:choose>
                <xsl:when test="recurring='true' or recurrenceId != ''">
                  <img src="{$resourcesRoot}/images/std-ical_iconLinkDkGray.gif" width="12" height="16" border="0" alt="add event reference"/>
                  <xsl:text> </xsl:text>
                  <xsl:copy-of select="$bwStr-EvCG-LinkColon"/><xsl:text> </xsl:text>
                  <a href="{$addEventRef}&amp;calPath={$calPath}&amp;guid={$guid}" title="{$bwStr-EvCG-AddMasterEventReference}">
                    <xsl:copy-of select="$bwStr-EvCG-All"/>
                  </a>,
                  <a href="{$addEventRef}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}" title="{$bwStr-EvCG-AddThisEventReference}">
                    <xsl:copy-of select="$bwStr-EvCG-Instance"/>
                  </a>
                </xsl:when>
                <xsl:otherwise>
                  <a href="{$addEventRef}&amp;calPath={$calPath}&amp;guid={$guid}" title="{$bwStr-EvCG-AddEventReference}">
                    <img src="{$resourcesRoot}/images/std-ical_iconLinkDkGray.gif" width="12" height="16" border="0" alt="add event reference"/>
                    <xsl:text> </xsl:text><xsl:copy-of select="$bwStr-EvCG-Link"/>
                  </a>
                </xsl:otherwise>
              </xsl:choose>
            </li>
          </xsl:if>

          <xsl:if test="currentAccess/current-user-privilege-set/privilege/unbind">
            <li>
              <xsl:choose>
                <xsl:when test="recurring='true' or recurrenceId != ''">
                  <img src="{$resourcesRoot}/images/trashIcon.gif" width="13" height="13" border="0" alt="delete"/>
                  <xsl:text> </xsl:text>
                  <xsl:copy-of select="$bwStr-EvCG-DeleteColon"/>
                  <xsl:text> </xsl:text>
                  <a href="{$delEvent}&amp;calPath={$calPath}&amp;guid={$guid}" title="{$bwStr-EvCG-DeleteMaster}" onclick="return confirm('{$bwStr-EvCG-DeleteAllRecurrences}');">
                    <xsl:copy-of select="$bwStr-EvCG-All"/>
                  </a>,
                  <a href="{$delEvent}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}" title="{$bwStr-EvCG-DeleteThisInstance}" onclick="return confirm('{$bwStr-EvCG-DeleteThisEvent}');">
                    <xsl:copy-of select="$bwStr-EvCG-Instance"/>
                  </a>
                </xsl:when>
                <xsl:otherwise>
                  <a href="{$delEvent}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}" title="{$bwStr-EvCG-DeleteEvent}" onclick="return confirm('{$bwStr-EvCG-DeleteThisEvent}');">
                    <img src="{$resourcesRoot}/images/trashIcon.gif" width="13" height="13" border="0" alt="delete"/>
                    <xsl:text> </xsl:text><xsl:copy-of select="$bwStr-EvCG-Delete"/>
                  </a>
                </xsl:otherwise>
              </xsl:choose>
            </li>
          </xsl:if>
        </ul>

      </div>
    </li>
  </xsl:template>

</xsl:stylesheet>