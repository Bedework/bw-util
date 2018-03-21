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

  <!--==== INBOX, OUTBOX, and SCHEDULING ====-->
  <xsl:template match="inbox">
    <h2 class="common"><xsl:copy-of select="$bwStr-Inbx-Inbox"/></h2>
    <table id="inoutbox" class="common" cellspacing="0">
      <tr>
        <th class="commonHeader">&#160;</th>
        <th class="commonHeader"><xsl:copy-of select="$bwStr-Inbx-Sent"/></th>
        <th class="commonHeader"><xsl:copy-of select="$bwStr-Inbx-From"/></th>
        <th class="commonHeader"><xsl:copy-of select="$bwStr-Inbx-Title"/></th>
        <th class="commonHeader"><xsl:copy-of select="$bwStr-Inbx-Start"/></th>
        <th class="commonHeader"><xsl:copy-of select="$bwStr-Inbx-End"/></th>
        <th class="commonHeader"><xsl:copy-of select="$bwStr-Inbx-Method"/></th>
        <th class="commonHeader"><xsl:copy-of select="$bwStr-Inbx-Status"/></th>
        <th class="commonHeader">&#160;</th>
        <th class="commonHeader">&#160;</th>
      </tr>
      <xsl:for-each select="events/event">
        <xsl:sort select="lastmod" order="descending"/>
        <xsl:variable name="guid"><xsl:call-template name="url-encode"><xsl:with-param name="str" select="guid"/></xsl:call-template></xsl:variable>
        <xsl:variable name="calPath" select="calendar/encodedPath"/>
        <xsl:variable name="eventName" select="name"/>
        <xsl:variable name="recurrenceId" select="recurrenceId"/>
        <xsl:variable name="inboxItemAction">
          <xsl:choose>
            <xsl:when test="entityType=7"><xsl:value-of select="$vpoll-initmanage"/></xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="scheduleMethod=2"><xsl:value-of select="$schedule-initAttendeeUpdate"/></xsl:when>
                <xsl:when test="scheduleMethod=3"><xsl:value-of select="$eventView"/></xsl:when>
                <xsl:when test="scheduleMethod=6"><xsl:value-of select="$schedule-processRefresh"/></xsl:when>
                <xsl:when test="scheduleMethod=7"><xsl:value-of select="$eventView"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="$schedule-initAttendeeUpdate"/></xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <tr>
          <xsl:attribute name="class">
            <xsl:choose>
              <xsl:when test="scheduleState=0"><xsl:copy-of select="$bwStr-Inbx-Unprocessed"/></xsl:when>
              <xsl:when test="scheduleMethod=1"><xsl:copy-of select="$bwStr-Inbx-Publish"/></xsl:when>
              <xsl:when test="scheduleMethod=2"><xsl:copy-of select="$bwStr-Inbx-Request"/></xsl:when>
              <xsl:when test="scheduleMethod=5"><xsl:copy-of select="$bwStr-Inbx-Cancel"/></xsl:when>
              <xsl:when test="scheduleMethod=7 or scheduleMethod=8"><xsl:copy-of select="$bwStr-Inbx-Counter"/></xsl:when>
            </xsl:choose>
          </xsl:attribute>
          <td>
            <a href="{$inboxItemAction}&amp;calPath={$calPath}&amp;eventName={$eventName}&amp;recurrenceId={$recurrenceId}" title="{$bwStr-Inbx-CheckMessage}">
              <img src="{$resourcesRoot}/images/calIconSchedule-sm.gif" width="13" height="13" border="0" alt="{$bwStr-Inbx-CheckMessage}"/>
            </a>
          </td>
          <td>
            <a href="{$inboxItemAction}&amp;calPath={$calPath}&amp;eventName={$eventName}&amp;recurrenceId={$recurrenceId}" title="check message">
              <!--<xsl:value-of select="dtstamp/shortdate"/><xsl:text> </xsl:text><xsl:value-of select="dtstamp/time"/>-->
              <!--<xsl:value-of select="lastmod"/>-->
              <xsl:variable name="dt" select="substring-before(lastmod,'T')"/>
              <xsl:variable name="tm" select="substring-after(lastmod,'T')"/>
              <xsl:value-of select="substring($dt,1,4)"/>-<xsl:value-of select="substring($dt,5,2)"/>-<xsl:value-of select="substring($dt,7,2)"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="substring($tm,1,2)"/>:<xsl:value-of select="substring($tm,3,2)"/>
            </a>
          </td>
          <td>
            <xsl:choose>
              <xsl:when test="scheduleMethod = '1' or
                              scheduleMethod = '2' or
                              scheduleMethod = '4' or
                              scheduleMethod = '5' or
                              scheduleMethod = '8'">
                <xsl:if test="organizer">
                  <xsl:variable name="organizerUri" select="organizer/organizerUri"/>
                  <xsl:choose>
                    <xsl:when test="organizer/cn != ''">
                      <xsl:value-of select="organizer/cn"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="substring-after(organizer/organizerUri,'mailto:')"/>
                    </xsl:otherwise>
                  </xsl:choose>
                  <xsl:if test="organizer/organizerUri != ''">
                    <a href="{$organizerUri}" class="emailIcon" title="{$bwStr-Inbx-Email}">
                      <img src="{$resourcesRoot}/images/email.gif" width="16" height="10" border="0" alt="email"/>
                    </a>
                  </xsl:if>
                </xsl:if>
              </xsl:when>
              <xsl:otherwise>
                <xsl:if test="attendees/attendee">
                  <!-- there will only be one attendee at this point -->
                  <xsl:variable name="attendeeUri" select="attendees/attendee/attendeeUri"/>
                  <xsl:choose>
                    <xsl:when test="attendees/attendee/cn != ''">
                      <xsl:value-of select="attendees/attendee/cn"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="substring-after(attendees/attendee/attendeeUri,'mailto:')"/>
                    </xsl:otherwise>
                  </xsl:choose>
                  <xsl:if test="$attendeeUri != ''">
                    <a href="{$attendeeUri}" class="emailIcon" title="{$bwStr-Inbx-Email}">
                      <img src="{$resourcesRoot}/images/email.gif" width="16" height="10" border="0" alt="email"/>
                    </a>
                  </xsl:if>
                </xsl:if>
              </xsl:otherwise>
            </xsl:choose>
          </td>
          <td>
            <a href="{$inboxItemAction}&amp;calPath={$calPath}&amp;eventName={$eventName}&amp;recurrenceId={$recurrenceId}" title="{$bwStr-Inbx-CheckMessage}">
              <xsl:value-of select="title"/>
            </a>
          </td>
          <td><xsl:value-of select="start/shortdate"/><xsl:text> </xsl:text><xsl:value-of select="start/time"/></td>
          <td><xsl:value-of select="end/shortdate"/><xsl:text> </xsl:text><xsl:value-of select="end/time"/></td>
          <td><xsl:apply-templates select="scheduleMethod"/></td>
          <td>
            <a href="{$inboxItemAction}&amp;calPath={$calPath}&amp;eventName={$eventName}&amp;recurrenceId={$recurrenceId}" title="{$bwStr-Inbx-CheckMessage}">
              <xsl:choose>
                <xsl:when test="scheduleState=0"><em><xsl:copy-of select="$bwStr-Inbx-Unprocessed"/></em></xsl:when>
                <xsl:otherwise><xsl:copy-of select="$bwStr-Inbx-Processed"/></xsl:otherwise>
              </xsl:choose>
            </a>
          </td>
          <td>
            <xsl:variable name="eventIcalName" select="concat($guid,'.ics')"/>
            <a href="{$export}&amp;calPath={$calPath}&amp;&amp;eventName={$eventName}&amp;recurrenceId={$recurrenceId}&amp;nocache=no&amp;contentName={$eventIcalName}" title="{$bwStr-Inbx-Download}">
              <img src="{$resourcesRoot}/images/std-ical_icon_small.gif" width="12" height="16" border="0" alt="{$bwStr-Inbx-Download}"/>
            </a>
          </td>
          <td>
            <a href="{$delInboxEvent}&amp;calPath={$calPath}&amp;&amp;eventName={$eventName}&amp;recurrenceId={$recurrenceId}" title="{$bwStr-Inbx-Delete}">
              <img src="{$resourcesRoot}/images/trashIcon.gif" width="13" height="13" border="0" alt="{$bwStr-Inbx-Delete}"/>
            </a>
          </td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <xsl:template match="outbox">
    <h2 class="common"><xsl:copy-of select="$bwStr-Oubx-Outbox"/></h2>
    <table id="inoutbox" class="common" cellspacing="0">
      <tr>
        <th class="commonHeader">&#160;</th>
        <th class="commonHeader"><xsl:copy-of select="$bwStr-Oubx-Sent"/></th>
        <th class="commonHeader"><xsl:copy-of select="$bwStr-Oubx-Organizer"/></th>
        <th class="commonHeader"><xsl:copy-of select="$bwStr-Oubx-Title"/></th>
        <th class="commonHeader"><xsl:copy-of select="$bwStr-Oubx-Start"/></th>
        <th class="commonHeader"><xsl:copy-of select="$bwStr-Oubx-End"/></th>
        <th class="commonHeader"><xsl:copy-of select="$bwStr-Oubx-Method"/></th>
        <th class="commonHeader"><xsl:copy-of select="$bwStr-Oubx-Status"/></th>
        <th class="commonHeader">&#160;</th>
        <th class="commonHeader">&#160;</th>
      </tr>
      <xsl:for-each select="events/event">
        <xsl:sort select="lastmod" order="descending"/>
        <xsl:variable name="guid"><xsl:call-template name="url-encode"><xsl:with-param name="str" select="guid"/></xsl:call-template></xsl:variable>
        <xsl:variable name="calPath" select="calendar/encodedPath"/>
        <xsl:variable name="eventName" select="name"/>
        <xsl:variable name="recurrenceId" select="recurrenceId"/>
        <xsl:variable name="inboxItemAction">
          <xsl:choose>
            <xsl:when test="scheduleMethod=2"><xsl:value-of select="$schedule-initAttendeeRespond"/></xsl:when>
            <xsl:when test="scheduleMethod=3"><xsl:value-of select="$schedule-initAttendeeReply"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="$schedule-initAttendeeRespond"/></xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <tr>
          <xsl:attribute name="class">
            <xsl:choose>
              <xsl:when test="scheduleMethod=1"><xsl:copy-of select="$bwStr-Oubx-Publish"/></xsl:when>
              <xsl:when test="scheduleMethod=2"><xsl:copy-of select="$bwStr-Oubx-Request"/></xsl:when>
              <xsl:when test="scheduleMethod=5"><xsl:copy-of select="$bwStr-Oubx-Cancel"/></xsl:when>
              <xsl:when test="scheduleMethod=7 or scheduleMethod=8"><xsl:copy-of select="$bwStr-Oubx-Counter"/></xsl:when>
            </xsl:choose>
          </xsl:attribute>
          <td>
            <a href="{$inboxItemAction}&amp;calPath={$calPath}&amp;eventName={$eventName}&amp;recurrenceId={$recurrenceId}" title="{$bwStr-Oubx-CheckMessage}">
              <img src="{$resourcesRoot}/images/calIconSchedule-sm.gif" width="13" height="13" border="0" alt="{$bwStr-Oubx-CheckMessage}"/>
            </a>
          </td>
          <td>
            <a href="{$inboxItemAction}&amp;calPath={$calPath}&amp;eventName={$eventName}&amp;recurrenceId={$recurrenceId}" title="{$bwStr-Oubx-CheckMessage}">
              <!-- <xsl:value-of select="dtstamp/shortdate"/><xsl:text> </xsl:text><xsl:value-of select="dtstamp/time"/>-->
              <!--<xsl:value-of select="lastmod"/>-->
              <xsl:variable name="dt" select="substring-before(lastmod,'T')"/>
              <xsl:variable name="tm" select="substring-after(lastmod,'T')"/>
              <xsl:value-of select="substring($dt,1,4)"/>-<xsl:value-of select="substring($dt,5,2)"/>-<xsl:value-of select="substring($dt,7,2)"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="substring($tm,1,2)"/>:<xsl:value-of select="substring($tm,3,2)"/>
            </a>
          </td>
          <td>
            <xsl:if test="organizer">
              <xsl:variable name="organizerUri" select="organizer/organizerUri"/>
              <xsl:choose>
                <xsl:when test="organizer/cn != ''">
                  <xsl:value-of select="organizer/cn"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="substring-after(organizer/organizerUri,'mailto:')"/>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:if test="organizer/organizerUri != ''">
                <a href="{$organizerUri}" class="emailIcon" title="{$bwStr-Oubx-Email}">
                  <img src="{$resourcesRoot}/images/email.gif" width="16" height="10" border="0" alt="{$bwStr-Oubx-Email}"/>
                </a>
              </xsl:if>
            </xsl:if>
          </td>
          <td>
            <a href="{$inboxItemAction}&amp;calPath={$calPath}&amp;eventName={$eventName}&amp;recurrenceId={$recurrenceId}">
              <xsl:value-of select="title"/>
            </a>
          </td>
          <td><xsl:value-of select="start/shortdate"/><xsl:text> </xsl:text><xsl:value-of select="start/time"/></td>
          <td><xsl:value-of select="end/shortdate"/><xsl:text> </xsl:text><xsl:value-of select="end/time"/></td>
          <td><xsl:apply-templates select="scheduleMethod"/></td>
          <td>
            <a href="{$inboxItemAction}&amp;calPath={$calPath}&amp;eventName={$eventName}&amp;recurrenceId={$recurrenceId}">
              <xsl:choose>
                <xsl:when test="scheduleState=0"><em><xsl:copy-of select="$bwStr-Oubx-Unprocessed"/></em></xsl:when>
                <xsl:otherwise><xsl:copy-of select="$bwStr-Oubx-Processed"/></xsl:otherwise>
              </xsl:choose>
            </a>
          </td>
          <td>
            <xsl:variable name="eventIcalName" select="concat($guid,'.ics')"/>
            <a href="{$export}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}&amp;nocache=no&amp;contentName={$eventIcalName}" title="{$bwStr-Oubx-Download}">
              <img src="{$resourcesRoot}/images/std-ical_icon_small.gif" width="12" height="16" border="0" alt="{$bwStr-Oubx-Download}"/>
            </a>
          </td>
          <td>
            <a href="{$delEvent}&amp;calPath={$calPath}&amp;eventName={$eventName}&amp;recurrenceId={$recurrenceId}" title="{$bwStr-Oubx-Delete}">
              <img src="{$resourcesRoot}/images/trashIcon.gif" width="13" height="13" border="0" alt="{$bwStr-Oubx-Delete}"/>
            </a>
          </td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <xsl:template match="scheduleMethod">
    <xsl:choose>
      <xsl:when test="node()=1"><xsl:copy-of select="$bwStr-ScMe-Publish"/></xsl:when>
      <xsl:when test="node()=2"><xsl:copy-of select="$bwStr-ScMe-Request"/></xsl:when>
      <xsl:when test="node()=3"><xsl:copy-of select="$bwStr-ScMe-Reply"/></xsl:when>
      <xsl:when test="node()=4"><xsl:copy-of select="$bwStr-ScMe-Add"/></xsl:when>
      <xsl:when test="node()=5"><xsl:copy-of select="$bwStr-ScMe-Cancel"/></xsl:when>
      <xsl:when test="node()=6"><xsl:copy-of select="$bwStr-ScMe-Refresh"/></xsl:when>
      <xsl:when test="node()=7"><xsl:copy-of select="$bwStr-ScMe-Counter"/></xsl:when>
      <xsl:when test="node()=8"><xsl:copy-of select="$bwStr-ScMe-Declined"/></xsl:when><!-- declinecounter -->
      <xsl:otherwise>unknown</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="formElements" mode="attendeeRespond">
    <xsl:variable name="calPathEncoded" select="form/calendar/encodedPath"/>
    <xsl:variable name="calPath" select="form/calendar/path"/>
    <xsl:variable name="eventName" select="name"/>
    <xsl:variable name="guid"><xsl:call-template name="url-encode"><xsl:with-param name="str" select="guid"/></xsl:call-template></xsl:variable>
    <xsl:variable name="recurrenceId" select="recurrenceId"/>
    <!-- The name "eventForm" is referenced by several javascript functions. Do not
    change it without modifying bedework.js -->
    <form name="eventForm" method="post" action="{$schedule-attendeeRespond}" id="standardForm">
      <input type="hidden" name="updateEvent" value="true"/>
      <input type="hidden" name="endType" value="date"/>
      <h2>
        <xsl:choose>
          <xsl:when test="scheduleMethod = '5'">
            <xsl:copy-of select="$bwStr-AtRe-MeetingCanceled"/>
          </xsl:when>
          <xsl:when test="scheduleMethod = '8'">
            <xsl:copy-of select="$bwStr-AtRe-MeetingCounterDeclined"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:copy-of select="$bwStr-AtRe-MeetingRequest"/>
          </xsl:otherwise>
        </xsl:choose>
      </h2>
      <table class="common" cellspacing="0">
        <tr>
          <th colspan="2" class="commonHeader">
            <xsl:copy-of select="$bwStr-AtRe-Organizer"/>
            <xsl:choose>
              <xsl:when test="organizer/cn != ''">
                <xsl:value-of select="organizer/cn"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="substring-after(organizer/organizerUri,'mailto:')"/>
              </xsl:otherwise>
            </xsl:choose>
          </th>
        </tr>
        <xsl:choose>
          <xsl:when test="scheduleMethod = '5'">
            <tr>
              <td colspan="2" class="highlight">
                <xsl:copy-of select="$bwStr-AtRe-ThisMeetingCanceled"/>
              </td>
            </tr>
          </xsl:when>
          <xsl:when test="scheduleMethod = '8'">
            <tr>
              <td colspan="2" class="highlight">
                <xsl:copy-of select="$bwStr-AtRe-CounterReqDeclined"/>
              </td>
            </tr>
          </xsl:when>
        </xsl:choose>
        <!--
        <tr>
          <td class="fieldname">
            <xsl:copy-of select="$bwStr-AtRe-Calendar"/>
          </td>
          <td class="fieldval scheduleActions">
            <xsl:choose>
              <xsl:when test="not(guidcals/calendar)">
              <!- - the event has not been added to a calendar, so this is the
                   first request - - >

                <!- - the string "user/" should not be hard coded; fix this - - >
                <xsl:variable name="userPath">user/<xsl:value-of select="/bedework/userid"/></xsl:variable>
                <xsl:variable name="writableCalendars">
                  <xsl:value-of select="
                    count(/bedework/myCalendars//calendar[calType = '1' and
                           currentAccess/current-user-privilege-set/privilege/write-content]) +
                    count(/bedework/mySubscriptions//calendar[calType = '1' and
                           currentAccess/current-user-privilege-set/privilege/write-content and
                           (not(contains(path,$userPath)))])"/>
                </xsl:variable>
                <xsl:choose>
                  <xsl:when test="$writableCalendars = 1">
                    <!- - there is only 1 writable calendar, so find it by looking down both trees at once - - >
                    <xsl:variable name="newCalPath"><xsl:value-of select="/bedework/myCalendars//calendar[calType = '1' and
                             currentAccess/current-user-privilege-set/privilege/write-content]/path"/><xsl:value-of select="/bedework/mySubscriptions//calendar[calType = '1' and
                           currentAccess/current-user-privilege-set/privilege/write-content and
                           (not(contains(path,$userPath)))]/path"/></xsl:variable>

                    <input type="hidden" name="newCalPath" value="{$newCalPath}"/>

                    <xsl:variable name="userFullPath"><xsl:value-of select="$userPath"/>/</xsl:variable>
                    <span id="bwEventCalDisplay">
                      <xsl:choose>
                        <xsl:when test="contains($newCalPath,$userFullPath)">
                          <xsl:value-of select="substring-after($newCalPath,$userFullPath)"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="$newCalPath"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </span>
                  </xsl:when>
                  <xsl:otherwise>
                    <input type="hidden" name="newCalPath" id="bwNewCalPathField" value=""/>
                    <!- -
                      <xsl:if test="form/calendar/calType = '1'"><xsl:attribute name="value"><xsl:value-of select="form/calendar/path"/></xsl:attribute></xsl:if>
                    </input>- - >

                    <xsl:variable name="userFullPath"><xsl:value-of select="$userPath"/>/</xsl:variable>

                    <span id="bwEventCalDisplay">
                      <xsl:if test="form/calendar/calType = '1'">
                        <xsl:choose>
                          <xsl:when test="contains(form/calendar/path,$userFullPath)">
                            <xsl:value-of select="substring-after(form/calendar/path,$userFullPath)"/>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of select="form/calendar/path"/>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:if>
                      <xsl:text> </xsl:text>
                      <!- - this final text element is required to avoid an empty
                           span element which is improperly rendered in the browser - - >
                    </span>

                    <xsl:call-template name="selectCalForEvent"/>

                  </xsl:otherwise>
                </xsl:choose>

              </xsl:when>
              <xsl:otherwise>
                <!- - the event exists in calendars already, so this is a
                     subsequent follow-up.  Let the user choose which copies
                     of the event to update.  For now, we'll just list them
                     and add calPath request parameters.

                     This should be changed - we will only have one of these so
                     the for-each is not needed - - >
                <ul>
                  <xsl:for-each select="guidcals/calendar">
                    <li class="calendar">
                      <xsl:value-of select="name"/>
                      <input type="hidden" name="calPath">
                        <xsl:attribute name="value"><xsl:value-of select="path"/></xsl:attribute>
                      </input>
                    </li>
                  </xsl:for-each>
                </ul>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        -->
        <xsl:if test="scheduleMethod != '8'">
          <tr>
            <td class="fieldname"><xsl:copy-of select="$bwStr-AtRe-Action"/></td>
            <td class="fieldval scheduleActions">
              <xsl:choose>
                <xsl:when test="scheduleMethod = '5' or scheduleMethod = '8'">
                <!-- respond to a cancel -->
                  <input type="hidden" name="method" value="REPLY"/>
                  <select name="cancelAction">
                    <option value="mark"><xsl:copy-of select="$bwStr-AtRe-MarkEventAsCanceled"/></option>
                    <option value="delete"><xsl:copy-of select="$bwStr-AtRe-DeleteEvent"/></option>
                  </select>
                </xsl:when>
                <xsl:otherwise>
                <!-- respond to a request -->
                  <input type="radio" name="method" value="REPLY" checked="checked" onclick="swapScheduleDisplay('hide');"/><xsl:copy-of select="$bwStr-AtRe-ReplyAs"/>
                  <select name="partstat">
                    <option value="ACCEPTED"><xsl:copy-of select="$bwStr-AtRe-Accepted"/></option>
                    <option value="DECLINED"><xsl:copy-of select="$bwStr-AtRe-Declined"/></option>
                    <option value="TENTATIVE"><xsl:copy-of select="$bwStr-AtRe-Tentative"/></option>
                  </select><br/>
                  <!--<input type="radio" name="method" value="REFRESH" onclick="swapScheduleDisplay('hide');"/>refresh this event<br/>-->
                  <input type="radio" name="method" value="DELEGATE" onclick="swapScheduleDisplay('hide');"/><xsl:copy-of select="$bwStr-AtRe-DelegateTo"/>
                  <input type="test" name="delegate" value=""/><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-AtRe-URIOrAccount"/><br/>
                  <!-- We are hiding "counter" for now.  It may come back, so the code should remain. -->
                  <!--
                  <input type="radio" name="method" value="COUNTER" onclick="swapScheduleDisplay('show');"/><xsl:copy-of select="$bwStr-AtRe-CounterSuggest"/>
                  -->
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
          <tr id="scheduleDateEdit" class="invisible">
            <td class="fieldname"><xsl:copy-of select="$bwStr-AtRe-NewDateTime"/></td>
            <td class="fieldval scheduleActions">
              <!-- Set the timefields class for the first load of the page;
                   subsequent changes will take place using javascript without a
                   page reload. -->
              <xsl:variable name="timeFieldsClass">
                <xsl:choose>
                  <xsl:when test="form/allDay/input/@checked='checked'"><xsl:copy-of select="$bwStr-AtRe-Invisible"/>invisible</xsl:when>
                  <xsl:otherwise><xsl:copy-of select="$bwStr-AtRe-TimeFields"/></xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              <xsl:choose>
                <xsl:when test="form/allDay/input/@checked='checked'">
                  <input type="checkbox" name="allDayFlag" onclick="swapAllDayEvent(this)" value="on" checked="checked"/>
                  <input type="hidden" name="eventStartDate.dateOnly" value="on" id="allDayStartDateField"/>
                  <input type="hidden" name="eventEndDate.dateOnly" value="on" id="allDayEndDateField"/>
                </xsl:when>
                <xsl:otherwise>
                  <input type="checkbox" name="allDayFlag" onclick="swapAllDayEvent(this)" value="off"/>
                  <input type="hidden" name="eventStartDate.dateOnly" value="off" id="allDayStartDateField"/>
                  <input type="hidden" name="eventEndDate.dateOnly" value="off" id="allDayEndDateField"/>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:copy-of select="$bwStr-AtRe-AllDayEvent"/><br/>
              <div class="dateStartEndBox">
                <strong><xsl:copy-of select="$bwStr-AtRe-Start"/></strong>
                <div class="dateFields">
                  <span class="startDateLabel"><xsl:copy-of select="$bwStr-AtRe-Date"/><xsl:text> </xsl:text></span>
                  <xsl:copy-of select="form/start/month/*"/>
                  <xsl:copy-of select="form/start/day/*"/>
                  <xsl:choose>
                    <xsl:when test="/bedework/creating = 'true'">
                      <xsl:copy-of select="form/start/year/*"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:copy-of select="form/start/yearText/*"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </div>
                <!--<script type="text/javascript">
                <xsl:comment>
                  startDateDynCalWidget = new dynCalendar('startDateDynCalWidget', <xsl:value-of select="number(/bedework/formElements/form/start/yearText/input/@value)"/>, <xsl:value-of select="number(/bedework/formElements/form/start/month/select/option[@selected='selected']/@value)-1"/>, <xsl:value-of select="number(/bedework/formElements/form/start/day/select/option[@selected='selected']/@value)"/>, 'startDateCalWidgetCallback');
                </xsl:comment>
                </script>-->
                <!--<img src="{$resourcesRoot}/images/calIcon.gif" width="16" height="15" border="0"/>-->
                <div class="{$timeFieldsClass}" id="startTimeFields">
                  <span id="calWidgetStartTimeHider" class="show">
                    <xsl:copy-of select="form/start/hour/*"/>
                    <xsl:copy-of select="form/start/minute/*"/>
                    <xsl:if test="form/start/ampm">
                      <xsl:copy-of select="form/start/ampm/*"/>
                    </xsl:if>
                    <xsl:text> </xsl:text>
                    <!--<a href="javascript:bwClockLaunch('eventStartDate');"><img src="{$resourcesRoot}/images/clockIcon.gif" width="16" height="15" border="0"/></a>-->
                  </span>
                </div>
              </div>
              <div class="dateStartEndBox">
                <strong><xsl:copy-of select="$bwStr-AtRe-End"/></strong>
                <xsl:choose>
                  <xsl:when test="form/end/type='E'">
                    <input type="radio" name="eventEndType" value="E" checked="checked" onclick="changeClass('endDateTime','shown');changeClass('endDuration','invisible');"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <input type="radio" name="eventEndType" value="E" onclick="changeClass('endDateTime','shown');changeClass('endDuration','invisible');"/>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:copy-of select="$bwStr-AtRe-Date"/>
                <xsl:variable name="endDateTimeClass">
                  <xsl:choose>
                    <xsl:when test="form/end/type='E'"><xsl:copy-of select="$bwStr-AtRe-Shown"/></xsl:when>
                    <xsl:otherwise><xsl:copy-of select="$bwStr-AtRe-Invisible"/></xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <div class="{$endDateTimeClass}" id="endDateTime">
                  <div class="dateFields">
                    <xsl:copy-of select="form/end/dateTime/month/*"/>
                    <xsl:copy-of select="form/end/dateTime/day/*"/>
                    <xsl:choose>
                      <xsl:when test="/bedework/creating = 'true'">
                        <xsl:copy-of select="form/end/dateTime/year/*"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:copy-of select="form/end/dateTime/yearText/*"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </div>
                  <!--<script type="text/javascript">
                  <xsl:comment>
                    endDateDynCalWidget = new dynCalendar('endDateDynCalWidget', <xsl:value-of select="number(/bedework/formElements/form/start/yearText/input/@value)"/>, <xsl:value-of select="number(/bedework/formElements/form/start/month/select/option[@selected='selected']/@value)-1"/>, <xsl:value-of select="number(/bedework/formElements/form/start/day/select/option[@selected='selected']/@value)"/>, 'endDateCalWidgetCallback');
                  </xsl:comment>
                  </script>-->
                  <div class="{$timeFieldsClass}" id="endTimeFields">
                    <span id="calWidgetEndTimeHider" class="show">
                      <xsl:copy-of select="form/end/dateTime/hour/*"/>
                      <xsl:copy-of select="form/end/dateTime/minute/*"/>
                      <xsl:if test="form/end/dateTime/ampm">
                        <xsl:copy-of select="form/end/dateTime/ampm/*"/>
                      </xsl:if>
                      <xsl:text> </xsl:text>
                      <!--<a href="javascript:bwClockLaunch('eventEndDate');"><img src="{$resourcesRoot}/images/clockIcon.gif" width="16" height="15" border="0"/></a>-->
                    </span>
                  </div>
                </div><br/>
                <div id="clock" class="invisible">
                  <xsl:call-template name="clock"/>
                </div>
                <div class="dateFields">
                  <xsl:choose>
                    <xsl:when test="form/end/type='D'">
                      <input type="radio" name="eventEndType" value="D" checked="checked" onclick="changeClass('endDateTime','invisible');changeClass('endDuration','shown');"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <input type="radio" name="eventEndType" value="D" onclick="changeClass('endDateTime','invisible');changeClass('endDuration','shown');"/>
                    </xsl:otherwise>
                  </xsl:choose>
                  <xsl:copy-of select="$bwStr-AtRe-Duration"/>
                  <xsl:variable name="endDurationClass">
                    <xsl:choose>
                      <xsl:when test="form/end/type='D'"><xsl:copy-of select="$bwStr-AtRe-Shown"/></xsl:when>
                      <xsl:otherwise><xsl:copy-of select="$bwStr-AtRe-Invisible"/></xsl:otherwise>
                    </xsl:choose>
                  </xsl:variable>
                  <xsl:variable name="durationHrMinClass">
                    <xsl:choose>
                      <xsl:when test="form/allDay/input/@checked='checked'"><xsl:copy-of select="$bwStr-AtRe-Invisible"/></xsl:when>
                      <xsl:otherwise><xsl:copy-of select="$bwStr-AtRe-Shown"/></xsl:otherwise>
                    </xsl:choose>
                  </xsl:variable>
                  <div class="{$endDurationClass}" id="endDuration">
                    <xsl:choose>
                      <xsl:when test="form/end/duration/weeks/input/@value = '0'">
                      <!-- we are using day, hour, minute format -->
                      <!-- must send either no week value or week value of 0 (zero) -->
                        <div class="durationBox">
                          <input type="radio" name="eventDuration.type" value="daytime" onclick="swapDurationType('daytime')" checked="checked"/>
                          <xsl:variable name="daysStr" select="form/end/duration/days/input/@value"/>
                          <input type="text" name="eventDuration.daysStr" size="2" value="{$daysStr}" id="durationDays"/><xsl:copy-of select="$bwStr-AtRe-Days"/>
                          <span id="durationHrMin" class="{$durationHrMinClass}">
                            <xsl:variable name="hoursStr" select="form/end/duration/hours/input/@value"/>
                            <input type="text" name="eventDuration.hoursStr" size="2" value="{$hoursStr}" id="durationHours"/><xsl:copy-of select="$bwStr-AtRe-Hours"/>
                            <xsl:variable name="minutesStr" select="form/end/duration/minutes/input/@value"/>
                            <input type="text" name="eventDuration.minutesStr" size="2" value="{$minutesStr}" id="durationMinutes"/><xsl:copy-of select="$bwStr-AtRe-Minutes"/>
                          </span>
                        </div>
                        <span class="durationSpacerText"><xsl:copy-of select="$bwStr-AtRe-Or"/></span>
                        <div class="durationBox">
                          <input type="radio" name="eventDuration.type" value="weeks" onclick="swapDurationType('week')"/>
                          <xsl:variable name="weeksStr" select="form/end/duration/weeks/input/@value"/>
                          <input type="text" name="eventDuration.weeksStr" size="2" value="{$weeksStr}" id="durationWeeks" disabled="disabled"/><xsl:copy-of select="$bwStr-AtRe-Weeks"/>
                        </div>
                      </xsl:when>
                      <xsl:otherwise>
                        <!-- we are using week format -->
                        <div class="durationBox">
                          <input type="radio" name="eventDuration.type" value="daytime" onclick="swapDurationType('daytime')"/>
                          <xsl:variable name="daysStr" select="form/end/duration/days/input/@value"/>
                          <input type="text" name="eventDuration.daysStr" size="2" value="{$daysStr}" id="durationDays" disabled="disabled"/><xsl:copy-of select="$bwStr-AtRe-Days"/>
                          <span id="durationHrMin" class="{$durationHrMinClass}">
                            <xsl:variable name="hoursStr" select="form/end/duration/hours/input/@value"/>
                            <input type="text" name="eventDuration.hoursStr" size="2" value="{$hoursStr}" id="durationHours" disabled="disabled"/><xsl:copy-of select="$bwStr-AtRe-Hours"/>
                            <xsl:variable name="minutesStr" select="form/end/duration/minutes/input/@value"/>
                            <input type="text" name="eventDuration.minutesStr" size="2" value="{$minutesStr}" id="durationMinutes" disabled="disabled"/><xsl:copy-of select="$bwStr-AtRe-Minutes"/>
                          </span>
                        </div>
                        <span class="durationSpacerText"><xsl:copy-of select="$bwStr-AtRe-Or"/></span>
                        <div class="durationBox">
                          <input type="radio" name="eventDuration.type" value="weeks" onclick="swapDurationType('week')" checked="checked"/>
                          <xsl:variable name="weeksStr" select="form/end/duration/weeks/input/@value"/>
                          <input type="text" name="eventDuration.weeksStr" size="2" value="{$weeksStr}" id="durationWeeks"/><xsl:copy-of select="$bwStr-AtRe-Weeks"/>
                        </div>
                      </xsl:otherwise>
                    </xsl:choose>
                  </div>
                </div><br/>
                <div class="dateFields" id="noDuration">
                  <xsl:choose>
                    <xsl:when test="form/end/type='N'">
                      <input type="radio" name="eventEndType" value="N" checked="checked" onclick="changeClass('endDateTime','invisible');changeClass('endDuration','invisible');"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <input type="radio" name="eventEndType" value="N" onclick="changeClass('endDateTime','invisible');changeClass('endDuration','invisible');"/>
                    </xsl:otherwise>
                  </xsl:choose>
                  <xsl:copy-of select="$bwStr-AtRe-ThisEventNoDuration"/>
                </div>
              </div>
            </td>
          </tr>
          <tr id="scheduleLocationEdit" class="invisible">
            <td class="fieldname"><xsl:copy-of select="$bwStr-AtRe-NewLocation"/></td>
            <td class="fieldval scheduleActions">
              <span class="std-text"><xsl:copy-of select="$bwStr-AtRe-Choose"/><xsl:text> </xsl:text></span>
              <span id="eventFormLocationList">
                <select name="eventLocationUid">
                  <option value="-1"><xsl:copy-of select="$bwStr-AtRe-Select"/></option>
                  <xsl:copy-of select="/bedework/formElements/form/location/locationmenu/select/*"/>
                </select>
              </span>
              <span class="std-text"><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-AtRe-OrAddNew"/><xsl:text> </xsl:text></span>
              <input type="text" name="locationAddress.value" value="" />
            </td>
          </tr>
          <!-- hide ability to set comments in v.3.6 (will restore in v.3.7)
          <xsl:if test="scheduleMethod != '5'">
            <tr>
              <td class="fieldname"><xsl:copy-of select="$bwStr-AtRe-Comment"/></td>
              <td class="fieldval scheduleActions">
                <textarea name="comment" cols="60" rows="2">
                  <xsl:text> </xsl:text>
                </textarea>
              </td>
            </tr>
          </xsl:if>
          -->
        </xsl:if>
        <tr>
          <td class="fieldname">&#160;</td>
          <td class="fieldval scheduleActions">
            <xsl:choose>
              <xsl:when test="scheduleMethod='8'">
                <input name="delete" type="button" value="{$bwStr-AtRe-Delete}" onclick="document.location.replace('{$delEvent}&amp;calPath={$calPath}&amp;eventName={$eventName}&amp;recurrenceId={$recurrenceId}')"/>
              </xsl:when>
              <xsl:otherwise>
                <input name="submit" type="submit" value="{$bwStr-AtRe-Submit}"/>
              </xsl:otherwise>
            </xsl:choose>
            &#160;
            <input name="cancelled" type="submit" value="{$bwStr-AtRe-Cancel}"/>
          </td>
        </tr>
        <tr>
          <td class="fieldname">
            <xsl:copy-of select="$bwStr-AtRe-Title"/>
          </td>
          <td class="fieldval">
            <strong><xsl:value-of select="form/title/input/@value"/></strong>
          </td>
        </tr>
        <tr>
          <td class="fieldname"><xsl:copy-of select="$bwStr-AtRe-Description"/></td>
          <td class="fieldval">
            <xsl:value-of select="/bedework/formElements/form/desc/textarea"/>
          </td>
        </tr>
        <tr>
          <td class="fieldname">
            <xsl:copy-of select="$bwStr-AtRe-DateAndTime"/>
          </td>
          <td class="fieldval">
            <xsl:value-of select="form/start/month/select/option[@selected='selected']"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="form/start/day/select/option[@selected='selected']"/>,
            <xsl:value-of select="form/start/yearText/input/@value"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="form/start/hour/select/option[@selected='selected']"/>:<xsl:value-of select="form/start/minute/select/option[@selected='selected']"/>
            -
            <xsl:value-of select="form/end/dateTime/month/select/option[@selected='selected']"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="form/end/dateTime/day/select/option[@selected='selected']"/>,
            <xsl:value-of select="form/end/dateTime/yearText/input/@value"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="form/end/dateTime/hour/select/option[@selected='selected']"/>:<xsl:value-of select="form/end/dateTime/minute/select/option[@selected='selected']"/>
            <xsl:if test="form/allDay/input/@checked='checked'">
              <xsl:text> </xsl:text>
              <xsl:copy-of select="$bwStr-AtRe-AllDay"/>
            </xsl:if>
          </td>
        </tr>
        <tr>
          <td class="fieldname"><xsl:copy-of select="$bwStr-AtRe-Location"/></td>
          <td class="fieldval" align="left">
            <xsl:if test="location/address = ''">
             <em><xsl:copy-of select="$bwStr-AtRe-NotSpecified"/></em>
            </xsl:if>
            <xsl:value-of select="location/address"/>
          </td>
        </tr>
        <xsl:if test="attendee">
          <tr>
            <td class="fieldname"><xsl:copy-of select="$bwStr-AtRe-Attendees"/></td>
            <td class="fieldval">
              <table id="attendees" cellspacing="0">
                <tr>
                  <th><xsl:copy-of select="$bwStr-AtRe-Role"/></th>
                  <th><xsl:copy-of select="$bwStr-AtRe-Status"/></th>
                  <th><xsl:copy-of select="$bwStr-AtRe-Attendee"/></th>
                </tr>
                <xsl:for-each select="attendee">
                  <xsl:sort select="cn" order="ascending" case-order="upper-first"/>
                  <xsl:sort select="attendeeUri" order="ascending" case-order="upper-first"/>
                  <tr>
                    <td class="role">
                      <xsl:apply-templates select="role"/>
                    </td>
                    <td class="status">
                      <xsl:apply-templates select="partstat"/>
                    </td>
                    <td>
                      <xsl:variable name="attendeeUri" select="attendeeUri"/>
                      <a href="{$attendeeUri}">
                        <xsl:choose>
                          <xsl:when test="cn != ''">
                            <xsl:value-of select="cn"/>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of select="substring-after(attendeeUri,'mailto:')"/>
                          </xsl:otherwise>
                        </xsl:choose>
                      </a>
                    </td>
                  </tr>
                </xsl:for-each>
              </table>
            </td>
          </tr>
        </xsl:if>
        <!--  Transparency  -->
        <!--
        <tr>
          <td class="fieldname">
            Affects free/busy:
          </td>
          <td class="fieldval">
            <xsl:choose>
              <xsl:when test="form/transparency = 'TRANSPARENT'">
                <input type="radio" name="transparency" value="OPAQUE"/>yes <span class="note">(opaque: event status affects your free/busy)</span><br/>
                <input type="radio" name="transparency" value="TRANSPARENT" checked="checked"/>no <span class="note">(transparent: event status does not affect your free/busy)</span>
              </xsl:when>
              <xsl:otherwise>
                <input type="radio" name="transparency" value="OPAQUE" checked="checked"/>yes <span class="note">(opaque: event status affects your free/busy)</span><br/>
                <input type="radio" name="transparency" value="TRANSPARENT"/>no <span class="note">(transparent: event status does not affect your free/busy)</span>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>-->
        <xsl:if test="form/link/input/@value != ''">
          <tr>
            <td class="fieldname"><xsl:copy-of select="$bwStr-AtRe-See"/></td>
            <td class="fieldval">
              <a>
                <xsl:attribute name="href"><xsl:value-of select="form/link/input/@value"/></xsl:attribute>
                <xsl:value-of select="form/link/input/@value"/>
              </a>
            </td>
          </tr>
        </xsl:if>
        <!--  Status  -->
        <tr>
          <td class="fieldname">
            <xsl:copy-of select="$bwStr-AtRe-Status"/>
          </td>
          <td class="fieldval">
            <xsl:value-of select="form/status"/>
          </td>
        </tr>
      </table>
    </form>
  </xsl:template>

  <xsl:template match="event" mode="attendeeReply">
    <xsl:variable name="calPath" select="calendar/encodedPath"/>
    <xsl:variable name="guid"><xsl:call-template name="url-encode"><xsl:with-param name="str" select="guid"/></xsl:call-template></xsl:variable>
    <xsl:variable name="recurrenceId" select="recurrenceId"/>
    <xsl:variable name="statusClass">
      <xsl:choose>
        <xsl:when test="status='CANCELLED'">bwStatusCancelled</xsl:when>
        <xsl:when test="status='TENTATIVE'">bwStatusTentative</xsl:when>
        <xsl:otherwise>bwStatusConfirmed</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <h2>
      <xsl:choose>
        <xsl:when test="scheduleMethod='7'">
          <xsl:copy-of select="$bwStr-AtRy-MeetingChangeRequest"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="$bwStr-AtRy-MeetingReply"/>
        </xsl:otherwise>
      </xsl:choose>
    </h2>
    <form name="processReply" method="post" action="{$schedule-processAttendeeReply}">
      <table class="common" cellspacing="0">
        <tr>
          <th colspan="2" class="commonHeader">
            <div id="eventActions">
            </div>
            <xsl:copy-of select="$bwStr-AtRy-Organizer"/>
            <xsl:choose>
              <xsl:when test="organizer/cn != ''">
                <xsl:value-of select="organizer/cn"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="substring-after(organizer/organizerUri,'mailto:')"/>
              </xsl:otherwise>
            </xsl:choose>
          </th>
        </tr>
        <xsl:choose>
          <xsl:when test="scheduleMethod = '7'">
            <tr>
              <td colspan="2" class="highlight">
                <xsl:copy-of select="$bwStr-AtRy-Shown"/><xsl:text> </xsl:text><xsl:value-of select="substring-after(attendees/attendee/attendeeUri,'mailto:')"/><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-AtRy-HasRequestedChange"/>
              </td>
            </tr>
          </xsl:when>
          <xsl:otherwise>
            <tr>
              <td colspan="2" class="highlight">
                <xsl:copy-of select="$bwStr-AtRy-Attendee"/><xsl:text> </xsl:text><xsl:value-of select="substring-after(attendees/attendee/attendeeUri,'mailto:')"/><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-AtRy-Has"/>
                <xsl:choose>
                  <xsl:when test="attendees/attendee/partstat = 'TENTATIVE'">
                    <xsl:copy-of select="$bwStr-AtRy-TentativelyAccepted"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:apply-templates select="attendees/attendee/partstat"/>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:copy-of select="$bwStr-AtRy-YourInvitation"/>
              </td>
            </tr>
          </xsl:otherwise>
        </xsl:choose>
        <tr>
          <td class="fieldname">
            <xsl:copy-of select="$bwStr-AtRy-Calendar"/>
          </td>
          <td class="fieldval scheduleActions">
            <xsl:choose>
              <xsl:when test="not(/bedework/guidcals/calendar)">
              <!-- the event has been deleted by the organizer -->
                <xsl:copy-of select="$bwStr-AtRy-EventNoLongerExists"/>
              </xsl:when>
              <xsl:otherwise>
                <!-- the event exists.  Let the user choose which copies
                     of the event to update.  For now, we'll just list them
                     and add calPath request parameters -->
                <ul>
                  <xsl:for-each select="/bedework/guidcals/calendar">
                    <li class="calendar">
                      <xsl:value-of select="name"/>
                      <input type="hidden" name="calPath">
                        <xsl:attribute name="value"><xsl:value-of select="path"/></xsl:attribute>
                      </input>
                    </li>
                  </xsl:for-each>
                </ul>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <td class="fieldname">
            <xsl:copy-of select="$bwStr-AtRy-From"/>
          </td>
          <td class="fieldval scheduleActions">
            <strong>
              <a>
                <xsl:attribute name="href"><xsl:value-of select="attendees/attendee/attendeeUri"/></xsl:attribute>
                <xsl:choose>
                  <xsl:when test="cn != ''">
                    <xsl:value-of select="cn"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="substring-after(attendees/attendee/attendeeUri,'mailto:')"/>
                  </xsl:otherwise>
                </xsl:choose>
              </a>
            </strong>
          </td>
        </tr>
        <tr>
          <td class="fieldname">
            <xsl:copy-of select="$bwStr-AtRy-Status"/>
          </td>
          <td class="fieldval scheduleActions">
            <xsl:apply-templates select="attendees/attendee/partstat"/>
            <xsl:if test="comments/value">
              <p><strong><xsl:copy-of select="$bwStr-AtRy-Comments"/></strong></p>
              <div id="comments">
                <xsl:for-each select="comments/value">
                  <p><xsl:value-of select="."/></p>
                </xsl:for-each>
              </div>
            </xsl:if>
          </td>
        </tr>
        <tr>
          <td class="fieldname">
            <xsl:copy-of select="$bwStr-AtRy-Action"/>
          </td>
          <td class="fieldval scheduleActions">
            <xsl:choose>
              <xsl:when test="scheduleMethod='7'"><!-- counter -->
                <input type="submit" value="accept / modify" name="{$bwStr-AtRy-Accept}"/>
                <input type="submit" value="decline" name="{$bwStr-AtRy-Decline}"/>
                <input type="submit" value="cancel" name="{$bwStr-AtRy-Canceled}"/>
              </xsl:when>
              <xsl:otherwise><!-- normal reply -->
                <input type="submit" value="ok" name="{$bwStr-AtRy-Update}"/>
                <input type="submit" value="cancel" name="{$bwStr-AtRy-Canceled}"/>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <td class="fieldname"><xsl:copy-of select="$bwStr-AtRy-Title"/></td>
          <td class="fieldval">
            <strong>
              <xsl:choose>
                <xsl:when test="summary = ''">
                  <em><xsl:copy-of select="$bwStr-AtRy-NoTitle"/></em><xsl:text> </xsl:text>
                </xsl:when>
                <xsl:when test="link != ''">
                  <xsl:variable name="link" select="link"/>
                  <a href="{$link}">
                    <xsl:value-of select="summary"/>
                  </a>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="summary"/>
                </xsl:otherwise>
              </xsl:choose>
            </strong>
          </td>
        </tr>
        <tr>
          <td class="fieldname"><xsl:copy-of select="$bwStr-AtRy-When"/></td>
          <td class="fieldval">
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
                <span class="time"><em><xsl:copy-of select="$bwStr-AtRy-AllDay"/></em></span>
              </xsl:when>
              <xsl:when test="end/longdate != start/longdate">
                <span class="time"><xsl:value-of select="end/time"/></span>
              </xsl:when>
              <xsl:when test="end/time != start/time">
                <span class="time"><xsl:value-of select="end/time"/></span>
              </xsl:when>
            </xsl:choose>
          </td>
          <!--<th class="icon" rowspan="2">
            <xsl:variable name="eventIcalName" select="concat($guid,'.ics')"/>
            <a href="{$export}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}&amp;nocache=no&amp;contentName={$eventIcalName}" title="Download event as ical - for Outlook, PDAs, iCal, and other desktop calendars">
              <img src="{$resourcesRoot}/images/std-ical-icon.gif" width="20" height="26" border="0" align="left" alt="Download this event"/>
            </a>
          </th>-->
        </tr>
        <tr>
          <td class="fieldname"><xsl:copy-of select="$bwStr-AtRy-Where"/></td>
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
        <tr>
          <td class="fieldname"><xsl:copy-of select="$bwStr-AtRy-Description"/></td>
          <td class="fieldval">
            <xsl:call-template name="replace">
              <xsl:with-param name="string" select="description"/>
              <xsl:with-param name="pattern" select="'&#xA;'"/>
              <xsl:with-param name="replacement"><br/></xsl:with-param>
            </xsl:call-template>
          </td>
        </tr>
        <xsl:if test="status !='' and status != 'CONFIRMED'">
          <tr>
            <td class="fieldname"><xsl:copy-of select="$bwStr-AtRy-Status"/></td>
            <td class="fieldval">
              <xsl:value-of select="status"/>
            </td>
          </tr>
        </xsl:if>
        <tr>
          <td class="fieldname filler">&#160;</td>
          <td class="fieldval">&#160;</td>
        </tr>
      </table>
    </form>
  </xsl:template>


</xsl:stylesheet>