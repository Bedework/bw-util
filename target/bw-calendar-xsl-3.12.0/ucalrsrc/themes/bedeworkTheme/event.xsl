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

    <!--==== SINGLE EVENT ====-->
  <xsl:template match="event">
    <xsl:variable name="calPath" select="calendar/encodedPath"/>
    <xsl:variable name="guid"><xsl:call-template name="url-encode"><xsl:with-param name="str" select="guid"/></xsl:call-template></xsl:variable>
    <xsl:variable name="eventName" select="name"/>
    <xsl:variable name="recurrenceId" select="recurrenceId"/>
    <xsl:variable name="statusClass">
      <xsl:choose>
        <xsl:when test="status='CANCELLED'">bwStatusCancelled</xsl:when>
        <xsl:when test="status='TENTATIVE'">bwStatusTentative</xsl:when>
        <xsl:otherwise>bwStatusConfirmed</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <h2 class="{$statusClass}">
      <xsl:if test="status='CANCELLED'"><xsl:copy-of select="$bwStr-SgEv-Canceled"/><xsl:text> </xsl:text></xsl:if>
      <xsl:choose>
        <xsl:when test="link != ''">
          <xsl:variable name="link" select="link"/>
          <a href="{$link}">
            <xsl:value-of select="summary"/>
          </a>
        </xsl:when>
        <xsl:when test="summary = ''">
          <xsl:copy-of select="$bwStr-SgEv-Event"/><xsl:text> </xsl:text><em>(<xsl:copy-of select="$bwStr-SgEv-NoTitle"/>)</em>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="summary"/>
        </xsl:otherwise>
      </xsl:choose>
    </h2>
    <table class="common" cellspacing="0">
      <tr>
        <th colspan="2" class="commonHeader">
          <div id="eventActions">

            <xsl:if test="currentAccess/current-user-privilege-set/privilege/unbind">
              <xsl:choose>
                <xsl:when test="recurring='true' or recurrenceId != ''">
                  <div id="bwDeleteRecurButton" class="bwMenuButton">
                    <img src="{$resourcesRoot}/images/trashIcon.gif" width="13" height="13" border="0" alt="delete"/>
                    <xsl:copy-of select="$bwStr-SgEv-Delete"/>
                    <div id="bwDeleteRecurWidget" class="bwMenuWidget">
                      <ul>
                        <li>
                          <a href="{$delEvent}&amp;calPath={$calPath}&amp;eventName={$eventName}" title="{$bwStr-SgEv-DeleteMaster}" onclick="return confirm('{$bwStr-SgEv-DeleteAllRecurrences}');">
                            <xsl:copy-of select="$bwStr-SgEv-All"/>
                          </a>
                        </li>
                        <li>
                          <a href="{$delEvent}&amp;calPath={$calPath}&amp;eventName={$eventName}&amp;recurrenceId={$recurrenceId}" title="{$bwStr-SgEv-DeleteThisInstance}" onclick="return confirm('{$bwStr-SgEv-DeleteThisEvent}');">
                            <xsl:copy-of select="$bwStr-SgEv-Instance"/>
                          </a>
                        </li>
                      </ul>
                    </div>
                  </div>
                </xsl:when>
                <xsl:otherwise>
                  <a href="{$delEvent}&amp;calPath={$calPath}&amp;eventName={$eventName}&amp;recurrenceId={$recurrenceId}" title="{$bwStr-SgEv-DeleteEvent}" class="bwMenuButton" onclick="return confirm('{$bwStr-SgEv-DeleteThisEvent}');">
                    <img src="{$resourcesRoot}/images/trashIcon.gif" width="13" height="13" border="0" alt="delete"/>
                    <xsl:copy-of select="$bwStr-SgEv-Delete"/><xsl:text> </xsl:text>
                  </a>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>

            <xsl:if test="not(currentAccess/current-user-privilege-set/privilege/write-content) and not(recurring='true' or recurrenceId != '')">
              <!-- temporarily hide from Recurring events -->
              <xsl:choose>
                <xsl:when test="recurring='true' or recurrenceId != ''">
                  <div id="bwLinkRecurButton" class="bwMenuButton">
                    <img src="{$resourcesRoot}/images/std-ical_iconLinkDkGray.gif" width="12" height="16" border="0" alt="add event reference"/>
                    <xsl:copy-of select="$bwStr-SgEv-Link"/>
                    <div id="bwLinkRecurWidget" class="bwMenuWidget">
                      <ul>
                        <li>
                          <a href="{$addEventRef}&amp;calPath={$calPath}&amp;guid={$guid}" title="{$bwStr-SgEv-AddMasterEvent}">
                            <xsl:copy-of select="$bwStr-SgEv-All"/>
                          </a>
                        </li>
                        <li>
                          <a href="{$addEventRef}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}" title="{$bwStr-SgEv-AddThisEvent}">
                            <xsl:copy-of select="$bwStr-SgEv-Instance"/>
                          </a>
                        </li>
                      </ul>
                    </div>
                  </div>
                </xsl:when>
                <xsl:otherwise>
                  <a href="{$addEventRef}&amp;calPath={$calPath}&amp;guid={$guid}" title="{$bwStr-SgEv-AddEventReference}" class="bwMenuButton">
                    <img src="{$resourcesRoot}/images/std-ical_iconLinkDkGray.gif" width="12" height="16" border="0" alt="add event reference"/>
                    <xsl:copy-of select="$bwStr-SgEv-Link"/>
                  </a>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>

            <xsl:choose>
              <xsl:when test="recurring='true' or recurrenceId != ''">
                <div id="bwCopyRecurButton" class="bwMenuButton">
                  <img src="{$resourcesRoot}/images/std-ical_iconEditDkGray.gif" width="12" height="16" border="0" alt="edit master"/>
                  <xsl:copy-of select="$bwStr-SgEv-Copy"/>
                  <div id="bwCopyRecurWidget" class="bwMenuWidget">
                    <ul>
                      <li>
                        <a href="{$editEvent}&amp;calPath={$calPath}&amp;guid={$guid}&amp;copy=true" title="{$bwStr-SgEv-CopyMaster}">
                          <xsl:copy-of select="$bwStr-SgEv-All"/>
                        </a>
                      </li>
                      <li>
                        <a href="{$editEvent}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}&amp;copy=true" title="{$bwStr-SgEv-CopyThisInstance}">
                          <xsl:copy-of select="$bwStr-SgEv-Instance"/>
                        </a>
                      </li>
                    </ul>
                  </div>
                </div>
              </xsl:when>
              <xsl:otherwise>
                <a href="{$editEvent}&amp;calPath={$calPath}&amp;guid={$guid}&amp;copy=true" title="{$bwStr-SgEv-CopyEvent}" class="bwMenuButton">
                  <img src="{$resourcesRoot}/images/std-ical_iconEditDkGray.gif" width="12" height="16" border="0" alt="edit"/>
                  <xsl:copy-of select="$bwStr-SgEv-Copy"/>
                </a>
              </xsl:otherwise>
            </xsl:choose>

            <xsl:if test="currentAccess/current-user-privilege-set/privilege/write-content">
              <xsl:choose>
                <xsl:when test="recurring='true' or recurrenceId != ''">
                  <div id="bwEditRecurButton" class="bwMenuButton">
                    <img src="{$resourcesRoot}/images/std-ical_iconEditDkGray.gif" width="12" height="16" border="0" alt="edit master"/>
                    <xsl:copy-of select="$bwStr-SgEv-Edit"/>
                    <div id="bwEditRecurWidget" class="bwMenuWidget">
                      <ul>
                        <li>
                          <a href="{$editEvent}&amp;calPath={$calPath}&amp;guid={$guid}" title="{$bwStr-SgEv-EditMaster}">
                            <xsl:copy-of select="$bwStr-SgEv-All"/>
                          </a>
                        </li>
                        <li>
                          <a href="{$editEvent}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}" title="{$bwStr-EvCG-EditThisInstance}">
                            <xsl:copy-of select="$bwStr-SgEv-Instance"/>
                          </a>
                        </li>
                      </ul>
                    </div>
                  </div>
                </xsl:when>
                <xsl:otherwise>
                  <a href="{$editEvent}&amp;calPath={$calPath}&amp;guid={$guid}" title="{$bwStr-SgEv-EditEvent}" class="bwMenuButton">
                    <img src="{$resourcesRoot}/images/std-ical_iconEditDkGray.gif" width="12" height="16" border="0" alt="edit"/>
                    <xsl:copy-of select="$bwStr-SgEv-Edit"/>
                  </a>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>

            <!-- download -->
            <xsl:variable name="eventIcalName" select="concat($guid,'.ics')"/>
            <xsl:choose>
              <xsl:when test="recurring='true' or recurrenceId != ''">
                <div id="bwDownloadButton" class="bwMenuButton">
                  <img src="{$resourcesRoot}/images/std-icalDownload-icon-small.gif" width="12" height="16" border="0" alt="{$bwStr-SgEv-DownloadEvent}"/>
                  <xsl:copy-of select="$bwStr-SgEv-Download"/>
                  <div id="bwDownloadWidget" class="bwMenuWidget">
                    <ul>
                      <li>
                        <a href="{$export}&amp;calPath={$calPath}&amp;guid={$guid}&amp;nocache=no&amp;contentName={$eventIcalName}" title="{$bwStr-SgEv-DownloadMaster}">
                          <xsl:copy-of select="$bwStr-SgEv-All"/>
                        </a>
                      </li>
                      <li>
                        <a href="{$export}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}&amp;nocache=no&amp;contentName={$eventIcalName}" title="{$bwStr-SgEv-DownloadThisInstance}">
                          <xsl:copy-of select="$bwStr-SgEv-Instance"/>
                        </a>
                      </li>
                    </ul>
                  </div>
                </div>
              </xsl:when>
              <xsl:otherwise>
                <a href="{$export}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}&amp;nocache=no&amp;contentName={$eventIcalName}" class="bwMenuButton" title="{$bwStr-SgEv-DownloadEvent}">
                  <img src="{$resourcesRoot}/images/std-icalDownload-icon-small.gif" width="12" height="16" border="0" alt="Download event as ical - for Outlook, PDAs, iCal, and other desktop calendars"/>
                  <xsl:copy-of select="$bwStr-SgEv-Download"/>
                </a>
              </xsl:otherwise>
            </xsl:choose>
          </div>
          <!-- Display type of event -->
          <xsl:variable name="entityType">
            <xsl:choose>
              <xsl:when test="entityType = '2'"><xsl:copy-of select="$bwStr-SgEv-Task"/></xsl:when>
              <xsl:when test="scheduleMethod = '2'"><xsl:copy-of select="$bwStr-SgEv-Meeting"/></xsl:when>
              <xsl:otherwise><xsl:copy-of select="$bwStr-SgEv-Event"/></xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:if test="recurring='true' or recurrenceId != ''">
            <xsl:copy-of select="$bwStr-SgEv-Recurring"/>
          </xsl:if>
          <xsl:choose>
            <xsl:when test="public = 'true'">
              <xsl:copy-of select="$bwStr-SgEv-Public"/><xsl:text> </xsl:text><xsl:value-of select="$entityType"/>
            </xsl:when>
            <xsl:when test="owner = /bedework/userid">
              <xsl:copy-of select="$bwStr-SgEv-Personal"/><xsl:text> </xsl:text><xsl:value-of select="$entityType"/>
            </xsl:when>
            <xsl:when test="scheduleMethod = '2'">
              <!-- a scheduled meeting ro task -->
              <xsl:value-of select="$entityType"/> - <xsl:copy-of select="$bwStr-SgEv-Organizer"/><xsl:text> </xsl:text><xsl:value-of select="substring-after(organizer/organizerUri,':')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$entityType"/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:if test="recurring='true' and recurrenceId = ''">
            <xsl:text> </xsl:text>
            <em><xsl:copy-of select="$bwStr-SgEv-RecurrenceMaster"/></em>
          </xsl:if>
          <!--
          <xsl:if test="scheduleMethod = '2' and not(/bedework/userid = substring-before(substring-after(organizer/organizerUri,':'),'@'))">
             /* this is a scheduled event (meeting or task) - allow a direct refresh
                NOTE: we need to actually output the organizer account for testing, rather
                 than testing against the organizerUri...might not be the same */
            <a href="{$schedule-refresh}&amp;method=REFRESH" id="refreshEventAction">
              <img src="{$resourcesRoot}/images/std-icalRefresh-icon-small.gif" width="12" height="16" border="0" alt="send a request to refresh this scheduled event"/>
              Request refresh
            </a>
          </xsl:if>
          -->
        </th>
      </tr>
      <tr>
        <td class="fieldname"><xsl:copy-of select="$bwStr-SgEv-When"/><xsl:text> </xsl:text></td>
        <td class="fieldval">
          <!-- always display local time -->
          <xsl:value-of select="start/dayname"/>, <xsl:value-of select="start/longdate"/><xsl:text> </xsl:text>
          <xsl:if test="start/allday = 'false'">
            <span class="time"><xsl:value-of select="start/time"/></span>
          </xsl:if>
          <xsl:if test="(end/longdate != start/longdate) or
                        ((end/longdate = start/longdate) and (end/time != start/time))"> - </xsl:if>
          <xsl:if test="end/longdate != start/longdate">
            <xsl:value-of select="substring(end/dayname,1,3)"/>, <xsl:value-of select="end/longdate"/><xsl:text> </xsl:text>
          </xsl:if>
          <xsl:choose>
            <xsl:when test="start/allday = 'true'">
              <span class="time"><em><xsl:copy-of select="$bwStr-SgEv-AllDay"/></em></span>
            </xsl:when>
            <xsl:when test="end/longdate != start/longdate">
              <span class="time"><xsl:value-of select="end/time"/></span>
            </xsl:when>
            <xsl:when test="end/time != start/time">
              <span class="time"><xsl:value-of select="end/time"/></span>
            </xsl:when>
          </xsl:choose>
          <!-- if timezones are not local, or if floating add labels: -->
          <xsl:if test="start/timezone/islocal = 'false' or end/timezone/islocal = 'false'">
            <xsl:text> </xsl:text>
            --
            <strong>
              <xsl:choose>
                <xsl:when test="start/floating = 'true'">
                  <xsl:copy-of select="$bwStr-SgEv-FloatingTime"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="/bedework/now/defaultTzid"/>
                </xsl:otherwise>
              </xsl:choose>
            </strong>
            <br/>
          </xsl:if>
          <!-- display in timezone if not local or floating time) -->
          <xsl:if test="(start/timezone/islocal = 'false' or end/timezone/islocal = 'false') and start/floating = 'false'">
            <xsl:choose>
              <xsl:when test="start/timezone/id != end/timezone/id">
                <!-- need to display both timezones if they differ from start to end -->
                <table border="0" cellspacing="0" id="tztable">
                  <tr>
                    <td>
                      <strong><xsl:copy-of select="$bwStr-SgEv-Start"/></strong><xsl:text> </xsl:text>
                    </td>
                    <td>
                      <xsl:choose>
                        <xsl:when test="start/timezone/islocal='true'">
                          <xsl:value-of select="start/dayname"/>,
                          <xsl:value-of select="start/longdate"/>
                          <xsl:text> </xsl:text>
                          <span class="time"><xsl:value-of select="start/time"/></span>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="start/timezone/dayname"/>,
                          <xsl:value-of select="start/timezone/longdate"/>
                          <xsl:text> </xsl:text>
                          <span class="time"><xsl:value-of select="start/timezone/time"/></span>
                        </xsl:otherwise>
                      </xsl:choose>
                    </td>
                    <td>
                      --
                      <strong><xsl:value-of select="start/timezone/id"/></strong>
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <strong><xsl:copy-of select="$bwStr-SgEv-End"/></strong><xsl:text> </xsl:text>
                    </td>
                    <td>
                      <xsl:choose>
                        <xsl:when test="end/timezone/islocal='true'">
                          <xsl:value-of select="end/dayname"/>,
                          <xsl:value-of select="end/longdate"/>
                          <xsl:text> </xsl:text>
                          <span class="time"><xsl:value-of select="end/time"/></span>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="end/timezone/dayname"/>,
                          <xsl:value-of select="end/timezone/longdate"/>
                          <xsl:text> </xsl:text>
                          <span class="time"><xsl:value-of select="end/timezone/time"/></span>
                        </xsl:otherwise>
                      </xsl:choose>
                    </td>
                    <td>
                      --
                      <strong><xsl:value-of select="end/timezone/id"/></strong>
                    </td>
                  </tr>
                </table>
              </xsl:when>
              <xsl:otherwise>
                <!-- otherwise, timezones are the same: display as a single line  -->
                <xsl:value-of select="start/timezone/dayname"/>, <xsl:value-of select="start/timezone/longdate"/><xsl:text> </xsl:text>
                <xsl:if test="start/allday = 'false'">
                  <span class="time"><xsl:value-of select="start/timezone/time"/></span>
                </xsl:if>
                <xsl:if test="(end/timezone/longdate != start/timezone/longdate) or
                              ((end/timezone/longdate = start/timezone/longdate) and (end/timezone/time != start/timezone/time))"> - </xsl:if>
                <xsl:if test="end/timezone/longdate != start/timezone/longdate">
                  <xsl:value-of select="substring(end/timezone/dayname,1,3)"/>, <xsl:value-of select="end/timezone/longdate"/><xsl:text> </xsl:text>
                </xsl:if>
                <xsl:choose>
                  <xsl:when test="start/allday = 'true'">
                    <span class="time"><em><xsl:copy-of select="$bwStr-SgEv-AllDay"/></em></span>
                  </xsl:when>
                  <xsl:when test="end/timezone/longdate != start/timezone/longdate">
                    <span class="time"><xsl:value-of select="end/timezone/time"/></span>
                  </xsl:when>
                  <xsl:when test="end/timezone/time != start/timezone/time">
                    <span class="time"><xsl:value-of select="end/timezone/time"/></span>
                  </xsl:when>
                </xsl:choose>
                <xsl:text> </xsl:text>
                --
                <strong><xsl:value-of select="start/timezone/id"/></strong>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
        </td>
        <!--<th class="icon" rowspan="2">
          <xsl:variable name="eventIcalName" select="concat($guid,'.ics')"/>
          <a href="{$export}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}&amp;nocache=no&amp;contentName={$eventIcalName}" title="Download event as ical - for Outlook, PDAs, iCal, and other desktop calendars">
            <img src="{$resourcesRoot}/images/std-ical-icon.gif" width="20" height="26" border="0" align="left" alt="Download this event"/>
          </a>
        </th>-->
      </tr>
      <xsl:if test="location/address != ''">
        <tr>
          <td class="fieldname"><xsl:copy-of select="$bwStr-SgEv-Where"/><xsl:text> </xsl:text></td>
          <td class="fieldval">
            <xsl:choose>
              <xsl:when test="location/link=''">
                <xsl:value-of select="location/address"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:variable name="locationLink" select="location/link"/>
                <a href="{$locationLink}">
                  <xsl:value-of select="location/address"/>
                </a>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="location/subaddress!=''">
              <br/><xsl:value-of select="location/subaddress"/>
            </xsl:if>
          </td>
        </tr>
      </xsl:if>
      <!--  Percent Complete (only for Tasks)  -->
      <xsl:if test="percentComplete != ''">
        <tr>
          <td class="fieldname">
            <xsl:copy-of select="$bwStr-SgEv-Complete"/><xsl:text> </xsl:text>
          </td>
          <td class="fieldval">
            <xsl:value-of select="percentComplete"/>%
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="description != ''">
        <tr>
          <td class="fieldname"><xsl:copy-of select="$bwStr-SgEv-Description"/><xsl:text> </xsl:text></td>
          <td class="fieldval">
            <xsl:if test="xproperties/node()[name()='X-BEDEWORK-IMAGE']">
              <xsl:variable name="bwImage"><xsl:value-of select="xproperties/node()[name()='X-BEDEWORK-IMAGE']/values/text"/></xsl:variable>
              <img src="{$bwImage}" class="bwEventImage"/>
            </xsl:if>
            <xsl:call-template name="replace">
              <xsl:with-param name="string" select="description"/>
              <xsl:with-param name="pattern" select="'&#xA;'"/>
              <xsl:with-param name="replacement"><br/></xsl:with-param>
            </xsl:call-template>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="status !='' and status != 'CONFIRMED'">
        <tr>
          <td class="fieldname"><xsl:copy-of select="$bwStr-SgEv-STATUS"/></td>
          <td class="fieldval">
            <xsl:value-of select="status"/>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="organizer">
        <tr>
          <td class="fieldname"><xsl:copy-of select="$bwStr-SgEv-ORGANIZER"/><xsl:text> </xsl:text></td>
          <xsl:variable name="organizerUri" select="organizer/organizerUri"/>
          <td class="fieldval">
            <xsl:choose>
              <xsl:when test="organizer/cn != ''">
                <xsl:value-of select="organizer/cn"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="substring-after(organizer/organizerUri,'mailto:')"/>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="organizer/organizerUri != ''">
              <a href="{$organizerUri}" class="emailIcon" title="{$bwStr-SgEv-Email}">
                <img src="{$resourcesRoot}/images/email.gif" width="16" height="10" border="0" alt="email"/>
              </a>
            </xsl:if>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="attendees/attendee">
        <tr>
          <td class="fieldname"><xsl:copy-of select="$bwStr-SgEv-Attendees"/><xsl:text> </xsl:text></td>
          <td class="fieldval">
            <table id="attendees" cellspacing="0">
              <tr>
                <th><xsl:copy-of select="$bwStr-SgEv-Attendee"/></th>
                <th><xsl:copy-of select="$bwStr-SgEv-Role"/></th>
                <th><xsl:copy-of select="$bwStr-SgEv-Status"/></th>
              </tr>
              <xsl:for-each select="attendees/attendee">
                <xsl:sort select="cn" order="ascending" case-order="upper-first"/>
                <xsl:sort select="attendeeUri" order="ascending" case-order="upper-first"/>
                <tr>
                  <td>
                    <xsl:variable name="attendeeUri" select="attendeeUri"/>
                    <a href="{$attendeeUri}" class="emailIcon" title="{$bwStr-SgEv-Email}">
                      <img src="{$resourcesRoot}/images/email.gif" width="16" height="10" border="0" alt="email"/>
                    </a>
                    <xsl:choose>
                      <xsl:when test="cn != ''">
                        <xsl:value-of select="cn"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="substring-after(translate(attendeeUri, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'),'mailto:')"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                  <td class="role">
                    <xsl:apply-templates select="role"/>
                  </td>
                  <td class="status">
                    <xsl:apply-templates select="partstat"/>
                  </td>
                </tr>
              </xsl:for-each>
            </table>
            <xsl:if test="not(organizerSchedulingObject)">
              <p>
                <em>
                  <a href="{$schedule-changeStatus}&amp;initUpdate=yes">
                    <xsl:copy-of select="$bwStr-SgEv-ChangeMyStatus"/>
                  </a>
                </em>
              </p>
            </xsl:if>
          </td>
        </tr>
      </xsl:if>
      <!-- Recipients are deprecated -->
      <!--
      <xsl:if test="recipient">
        <tr>
          <td class="fieldname">Recipients:</td>
          <td class="fieldval">
            <table id="attendees" cellspacing="0">
              <tr>
                <th>recipient</th>
              </tr>
              <xsl:for-each select="recipient">
                <tr>
                  <td>
                    <xsl:choose>
                      <xsl:when test="contains(.,'mailto:')">
                        <xsl:value-of select="substring-after(.,'mailto:')"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="."/>
                      </xsl:otherwise>
                    </xsl:choose>
                    <xsl:variable name="recipientUri" select="."/>
                    <a href="{$recipientUri}" class="emailIcon" title="email">
                      <img src="{$resourcesRoot}/images/email.gif" width="16" height="10" border="0" alt="email"/>
                    </a>
                  </td>
                </tr>
              </xsl:for-each>
            </table>
          </td>
        </tr>
      </xsl:if>
      -->
      <xsl:if test="cost!=''">
        <tr>
          <td class="fieldname"><xsl:copy-of select="$bwStr-SgEv-Cost"/></td>
          <td class="fieldval"><xsl:value-of select="cost"/></td>
        </tr>
      </xsl:if>
      <xsl:if test="link != ''">
        <tr>
          <td class="fieldname"><xsl:copy-of select="$bwStr-SgEv-See"/></td>
          <td class="fieldval">
            <xsl:variable name="link" select="link"/>
            <a href="{$link}"><xsl:value-of select="link"/></a>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="contact/name!='none'">
        <tr>
          <td class="fieldname"><xsl:copy-of select="$bwStr-SgEv-Contact"/></td>
          <td class="fieldval">
            <xsl:choose>
              <xsl:when test="contact/link=''">
                <xsl:value-of select="contact/name"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:variable name="sponsorLink" select="contact/link"/>
                <a href="{$sponsorLink}">
                  <xsl:value-of select="contact/name"/>
                </a>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="contact/phone!=''">
              <br /><xsl:value-of select="contact/phone"/>
            </xsl:if>
            <xsl:if test="contact/email!=''">
              <br />
              <xsl:variable name="email" select="contact/email"/>
              <xsl:variable name="subject" select="summary"/>
              <a href="mailto:{$email}&amp;subject={$subject}">
                <xsl:value-of select="contact/email"/>
              </a>
            </xsl:if>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="calendar/path!=''">
        <tr>
          <td class="fieldname"><xsl:copy-of select="$bwStr-SgEv-Calendar"/><xsl:text> </xsl:text></td>
          <td class="fieldval">

            <xsl:value-of select="calendar/summary"/>
            <xsl:if test="not(starts-with(calendar/path,/bedework/myCalendars/calendars/calendar/path))">
              <xsl:variable name="remotePath"><xsl:value-of select="calendar/path"/></xsl:variable>
              <!-- this event comes from a subscription / shared calendar; look up and display the local name:
                   v. 3.9: Can't display local name at the moment with new subscription model - but keep this code for future use:
              <xsl:value-of select="/bedework/myCalendars/calendars//calendar[substring-after(aliasUri,'bwcal://')=$remotePath]/summary"/>
              -->
              <!-- do, however, display the full remote path: -->
              <br/><em>(<xsl:value-of select="$remotePath"/>)</em>
            </xsl:if>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="categories/category">
        <tr>
          <td class="fieldname"><xsl:copy-of select="$bwStr-SgEv-Categories"/></td>
          <td class="fieldval">
            <xsl:for-each select="categories/category">
              <xsl:value-of select="value"/><xsl:if test="position() != last()">, </xsl:if>
            </xsl:for-each>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="comments/comment">
        <tr>
          <td class="fieldname"><xsl:copy-of select="$bwStr-SgEv-Comments"/></td>
          <td class="fieldval comments">
            <xsl:for-each select="comments/comment">
              <p><xsl:value-of select="value"/></p>
            </xsl:for-each>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="scheduleMethod = 3 and calendar/name = 'Inbox'">
        <tr>
          <td class="fieldname"></td>
          <td class="fieldval">
            <input name="submit" type="button" value="{$bwStr-AEEF-Clear}" onclick="window.location='{$schedule-clearReply}&amp;calPath={$calPath}&amp;eventName={$eventName}&amp;recurrenceId={$recurrenceId}'"/>
          </td>
        </tr>
      </xsl:if>
      <tr>
        <td class="fieldname filler">&#160;</td>
        <td class="fieldval">&#160;</td>
      </tr>
    </table>
  </xsl:template>

</xsl:stylesheet>