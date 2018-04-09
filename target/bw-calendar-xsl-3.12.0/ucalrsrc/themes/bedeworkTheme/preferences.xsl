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

  <!--==== PREFERENCES ====-->
  <xsl:template match="prefs">
    <h2><xsl:copy-of select="$bwStr-Pref-ManagePrefs"/></h2>
    <ul class="submenu">
      <li class="selected"><xsl:copy-of select="$bwStr-Pref-General"/></li>
      <xsl:if test="$publicOnly = 'false'">
        <li>
          <a href="{$category-initUpdate}"><xsl:copy-of select="$bwStr-Pref-Categories"/></a>
        </li>
        <li>
          <a href="{$location-initUpdate}"><xsl:copy-of select="$bwStr-Pref-Locations"/></a>
        </li>
        <li>
          <a href="{$prefs-fetchSchedulingForUpdate}"><xsl:copy-of select="$bwStr-Pref-SchedulingMeetings"/></a>
        </li>
      </xsl:if>
    </ul>
    <!-- The name "eventForm" is referenced by several javascript functions. Do not
         change it without modifying bedework.js -->
    <form name="eventForm" method="post" action="{$prefs-update}" onsubmit="setWorkDays(this)">
      <table class="common">
        <xsl:if test="$publicOnly = 'false'">
          <tr><td colspan="2" class="fill"><xsl:copy-of select="$bwStr-Pref-UserSettings"/></td></tr>
          <tr>
            <td class="fieldname">
              <xsl:copy-of select="$bwStr-Pref-User"/>
            </td>
            <td>
              <xsl:value-of select="user"/>
              <xsl:variable name="user" select="user"/>
              <input type="hidden" name="user" value="{$user}"/>
            </td>
          </tr>
          <tr>
            <td class="fieldname">
              <xsl:copy-of select="$bwStr-Pref-EmailAddress"/>
            </td>
            <td>
              <xsl:variable name="email" select="email"/>
              <input type="text" name="email" value="{$email}" size="40"/>
            </td>
          </tr>
          <tr><td colspan="2">&#160;</td></tr>
          <tr><td colspan="2" class="fill"><xsl:copy-of select="$bwStr-Pref-AddingEvents"/></td></tr>
          <tr>
            <td class="fieldname">
              <xsl:copy-of select="$bwStr-Pref-PreferredTimeType"/>
            </td>
            <td>
              <select name="hour24">
                <option value="false">
                  <xsl:if test="hour24 = 'false'">
                    <xsl:attribute name="selected">selected</xsl:attribute>
                  </xsl:if>
                  <xsl:copy-of select="$bwStr-Pref-12HourAMPM"/>
                </option>
                <option value="true">
                  <xsl:if test="hour24 = 'true'">
                    <xsl:attribute name="selected">selected</xsl:attribute>
                  </xsl:if>
                  <xsl:copy-of select="$bwStr-Pref-24Hour"/>
                </option>
              </select>
            </td>
          </tr>
          <tr>
            <td class="fieldname">
              <xsl:copy-of select="$bwStr-Pref-PreferredEndDateTimeType"/>
            </td>
            <td>
              <select name="preferredEndType">
                <option value="duration">
                  <xsl:if test="preferredEndType = 'duration'">
                    <xsl:attribute name="selected">selected</xsl:attribute>
                  </xsl:if>
                  <xsl:copy-of select="$bwStr-Pref-Duration"/>
                </option>
                <option value="date">
                  <xsl:if test="preferredEndType = 'date'">
                    <xsl:attribute name="selected">selected</xsl:attribute>
                  </xsl:if>
                  <xsl:copy-of select="$bwStr-Pref-DateTime"/>
                </option>
              </select>
            </td>
          </tr>
          <!-- hide if only one calendar to select -->
          <xsl:if test="count(/bedework/myCalendars/calendars//calendar[currentAccess/current-user-privilege-set/privilege/write-content and calType = '1']) &gt; 1">
            <tr>
              <td class="fieldname">
                <xsl:copy-of select="$bwStr-Pref-DefaultSchedulingCalendar"/>
              </td>
              <td>
                <xsl:variable name="newCalPath" select="defaultCalendar/path"/>
                <input type="hidden" name="newCalPath" value="{$newCalPath}" id="bwNewCalPathField"/>
                <xsl:variable name="userPath">user/<xsl:value-of select="/bedework/userid"/>/</xsl:variable>
                <span id="bwEventCalDisplay">
                  <xsl:choose>
                    <xsl:when test="contains(defaultCalendar,$userPath)">
                      <xsl:value-of select="substring-after(defaultCalendar,$userPath)"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="defaultCalendar"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </span>
                <xsl:call-template name="selectCalForEvent"/>
              </td>
            </tr>
          </xsl:if>
          <tr><td colspan="2">&#160;</td></tr>
          <tr><td colspan="2" class="fill"><xsl:copy-of select="$bwStr-Pref-WorkdaySettings"/></td></tr>
          <tr>
            <td class="fieldname">
              <xsl:copy-of select="$bwStr-Pref-Workdays"/>
            </td>
            <td>
              <xsl:variable name="workDays" select="workDays"/>
              <input type="hidden" name="workDays" value="{$workDays}"/>
              <input type="checkbox" name="workDayIndex" value="0">
                <xsl:if test="substring(workDays,1,1) = 'W'">
                  <xsl:attribute name="checked">checked</xsl:attribute>
                </xsl:if>
                <xsl:copy-of select="$bwStr-Pref-Sun"/>
              </input>
              <input type="checkbox" name="workDayIndex" value="1">
                <xsl:if test="substring(workDays,2,1) = 'W'">
                  <xsl:attribute name="checked">checked</xsl:attribute>
                </xsl:if>
                <xsl:copy-of select="$bwStr-Pref-Mon"/>
              </input>
              <input type="checkbox" name="workDayIndex" value="2">
                <xsl:if test="substring(workDays,3,1) = 'W'">
                  <xsl:attribute name="checked">checked</xsl:attribute>
                </xsl:if>
                <xsl:copy-of select="$bwStr-Pref-Tue"/>
              </input>
              <input type="checkbox" name="workDayIndex" value="3">
                <xsl:if test="substring(workDays,4,1) = 'W'">
                  <xsl:attribute name="checked">checked</xsl:attribute>
                </xsl:if>
                <xsl:copy-of select="$bwStr-Pref-Wed"/>
              </input>
              <input type="checkbox" name="workDayIndex" value="4">
                <xsl:if test="substring(workDays,5,1) = 'W'">
                  <xsl:attribute name="checked">checked</xsl:attribute>
                </xsl:if>
                <xsl:copy-of select="$bwStr-Pref-Thu"/>
              </input>
              <input type="checkbox" name="workDayIndex" value="5">
                <xsl:if test="substring(workDays,6,1) = 'W'">
                  <xsl:attribute name="checked">checked</xsl:attribute>
                </xsl:if>
                <xsl:copy-of select="$bwStr-Pref-Fri"/>
              </input>
              <input type="checkbox" name="workDayIndex" value="6">
                <xsl:if test="substring(workDays,7,1) = 'W'">
                  <xsl:attribute name="checked">checked</xsl:attribute>
                </xsl:if>
                <xsl:copy-of select="$bwStr-Pref-Sat"/>
              </input>
            </td>
          </tr>
          <tr>
            <td class="fieldname">
              <xsl:copy-of select="$bwStr-Pref-WorkdayStart"/>
            </td>
            <td>
              <select name="workdayStart">
                <xsl:call-template name="buildWorkdayOptionsList">
                  <xsl:with-param name="selectedVal" select="workdayStart"/>
                </xsl:call-template>
              </select>
            </td>
          </tr>
          <tr>
            <td class="fieldname">
              <xsl:copy-of select="$bwStr-Pref-WorkdayEnd"/>
            </td>
            <td>
              <xsl:variable name="workdayEnd" select="workdayEnd"/>
              <select name="workdayEnd">
                <xsl:call-template name="buildWorkdayOptionsList">
                  <xsl:with-param name="selectedVal" select="workdayEnd"/>
                </xsl:call-template>
              </select>
            </td>
          </tr>
          <tr><td colspan="2">&#160;</td></tr>
        </xsl:if>
        <tr><td colspan="2" class="fill"><xsl:copy-of select="$bwStr-Pref-DisplayOptions"/></td></tr>
        <xsl:if test="/bedework/views/view[position()=2]">
          <!-- only display if there is more than one to select -->
          <tr>
            <td class="fieldname">
              <xsl:copy-of select="$bwStr-Pref-PreferredView"/>
            </td>
            <td>
              <xsl:variable name="preferredView" select="preferredView"/>
              <select name="preferredView">
                <xsl:for-each select="/bedework/views/view">
                  <xsl:variable name="viewName" select="name"/>
                  <xsl:choose>
                    <xsl:when test="viewName = $preferredView">
                      <option value="{$viewName}" selected="selected"><xsl:value-of select="name"/></option>
                    </xsl:when>
                    <xsl:otherwise>
                      <option value="{$viewName}"><xsl:value-of select="name"/></option>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:for-each>
              </select>
            </td>
          </tr>
        </xsl:if>
        <tr>
          <td class="fieldname">
            <xsl:copy-of select="$bwStr-Pref-PreferredViewPeriod"/>
          </td>
          <td>
            <select name="viewPeriod">
              <option value="dayView">
                <xsl:if test="preferredViewPeriod = 'dayView'">
                  <xsl:attribute name="selected">selected</xsl:attribute>
                </xsl:if>
                <xsl:copy-of select="$bwStr-Pref-Day"/>
              </option>
              <option value="todayView">
                <xsl:if test="preferredViewPeriod = 'todayView'">
                  <xsl:attribute name="selected">selected</xsl:attribute>
                </xsl:if>
                <xsl:copy-of select="$bwStr-Pref-Today"/>
              </option>
              <option value="weekView">
                <xsl:if test="preferredViewPeriod = 'weekView'">
                  <xsl:attribute name="selected">selected</xsl:attribute>
                </xsl:if>
                <xsl:copy-of select="$bwStr-Pref-Week"/>
              </option>
              <option value="monthView">
                <xsl:if test="preferredViewPeriod = 'monthView'">
                  <xsl:attribute name="selected">selected</xsl:attribute>
                </xsl:if>
                <xsl:copy-of select="$bwStr-Pref-Month"/>
              </option>
              <option value="yearView">
                <xsl:if test="preferredViewPeriod = 'yearView'">
                  <xsl:attribute name="selected">selected</xsl:attribute>
                </xsl:if>
                <xsl:copy-of select="$bwStr-Pref-Year"/>
              </option>
            </select>
          </td>
        </tr>
        <tr>
          <td class="fieldname">
            <xsl:copy-of select="$bwStr-Pref-DefaultTimezone"/>
          </td>
          <td>
            <xsl:variable name="tzid" select="/bedework/prefs/tzid"/>

            <select name="defaultTzid" id="defaultTzid">
              <option value="-1"><xsl:copy-of select="$bwStr-Pref-SelectTimezone"/></option>
              <!--  deprecated: now calling timezone server.  See bedeworkEventForm.js -->
              <!--
              <xsl:for-each select="/bedework/timezones/timezone">
                <option>
                  <xsl:attribute name="value"><xsl:value-of select="id"/></xsl:attribute>
                  <xsl:if test="/bedework/prefs/defaultTzid = id"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
                  <xsl:value-of select="name"/>
                </option>
              </xsl:for-each>
              -->
            </select>

            <div class="desc">
              <xsl:copy-of select="$bwStr-Pref-DefaultTimezoneNote"/>
            </div>
          </td>
        </tr>
        <!-- as you add skins, update this list and set the selected flag
                 as required; hide if not in use -->
        <!--<tr>
          <td class="fieldname">
            Skin name:
          </td>
          <td>
            <xsl:variable name="skinName" select="skinName"/>
            <select name="skin">
              <option value="default">default</option>
            </select>
          </td>
        </tr> -->
        <!-- if you have skin styles, update this list and set the selected flag
                 as required; hide if not in use -->
        <!--
        <tr>
          <td class="fieldname">
            Skin style:
          </td>
          <td>
            <xsl:variable name="skinStyle" select="skinStyle"/>
            <select name="skinStyle">
              <option value="default">default</option>
            </select>
          </td>
        </tr> -->
        <!-- hide if not in use: -->
        <!--<tr>
          <td class="fieldname">
            Interface mode:
          </td>
          <td>
            <select name="userMode">
              <option value="0">
                <xsl:if test="userMode = 0">
                  <xsl:attribute name="selected">selected</xsl:attribute>
                </xsl:if>
                basic
              </option>
              <option value="1">
                <xsl:if test="userMode = 1">
                  <xsl:attribute name="selected">selected</xsl:attribute>
                </xsl:if>
                simple
              </option>
              <option value="3">
                <xsl:if test="userMode = 3">
                  <xsl:attribute name="selected">selected</xsl:attribute>
                </xsl:if>
                advanced
              </option>
            </select>
          </td>
        </tr>-->
      </table>
      <br />

      <input type="submit" name="modPrefs" value="{$bwStr-Pref-Update}"/>
      <input type="submit" name="cancelled" value="{$bwStr-Pref-Cancel}"/>
    </form>
  </xsl:template>

  <xsl:template match="schPrefs">
    <h2><xsl:copy-of select="$bwStr-ScPr-ManagePreferences"/></h2>
    <ul class="submenu">
      <li>
        <a href="{$prefs-fetchForUpdate}"><xsl:copy-of select="$bwStr-ScPr-General"/></a>
      </li>
      <li>
        <a href="{$category-initUpdate}"><xsl:copy-of select="$bwStr-ScPr-Categories"/></a>
      </li>
      <li>
        <a href="{$location-initUpdate}"><xsl:copy-of select="$bwStr-ScPr-Locations"/></a>
      </li>
      <li class="selected"><xsl:copy-of select="$bwStr-ScPr-SchedulingMeetings"/></li>
    </ul>

    <form name="scheduleAutoProcessingForm" method="post" action="{$prefs-updateSchedulingPrefs}">
      <table class="common">
        <tr><td colspan="2" class="fill"><xsl:copy-of select="$bwStr-ScPr-SchedulingAccess"/></td></tr>
        <tr>
          <td colspan="2">
            <div class="innerBlock">
              <p>
                <a href="{$calendar-fetch}"><xsl:copy-of select="$bwStr-ScPr-SetScheduleAccess"/></a>.<br/>
                <xsl:copy-of select="$bwStr-ScPr-GrantScheduleAccess"/>
              </p>
              <xsl:copy-of select="$bwStr-ScPr-AccessNote"/>
            </div>
          </td>
        </tr>
        <tr><td colspan="2" class="fill"><xsl:copy-of select="$bwStr-ScPr-SchedulingAutoProcessing"/></td></tr>
        <tr>
          <td class="fieldname">
            <xsl:copy-of select="$bwStr-ScPr-RespondToSchedReqs"/>
          </td>
          <td>
            <input type="radio" name="scheduleAutoRespond" value="true" onclick="toggleAutoRespondFields(this.value)">
              <xsl:if test="scheduleAutoRespond = 'true'">
                <xsl:attribute name="checked">checked</xsl:attribute>
              </xsl:if>
              <xsl:copy-of select="$bwStr-ScPr-True"/>
            </input>
            <input type="radio" name="scheduleAutoRespond" value="false" onclick="toggleAutoRespondFields(this.value)">
              <xsl:if test="scheduleAutoRespond = 'false'">
                <xsl:attribute name="checked">checked</xsl:attribute>
              </xsl:if>
              <xsl:copy-of select="$bwStr-ScPr-False"/>
            </input>
          </td>
        </tr>
        <tr class="subField">
          <td class="fieldname">
            <xsl:copy-of select="$bwStr-ScPr-AcceptDoubleBookings"/>
          </td>
          <td>
            <input type="radio" name="scheduleDoubleBook" value="true" id="scheduleDoubleBookTrue">
              <xsl:if test="scheduleAutoRespond = 'false'">
                <xsl:attribute name="disabled">disabled</xsl:attribute>
              </xsl:if>
              <xsl:if test="scheduleDoubleBook = 'true'">
                <xsl:attribute name="checked">checked</xsl:attribute>
              </xsl:if>
              <xsl:copy-of select="$bwStr-ScPr-True"/>
            </input>
            <input type="radio" name="scheduleDoubleBook" value="false" id="scheduleDoubleBookFalse">
              <xsl:if test="scheduleAutoRespond = 'false'">
                <xsl:attribute name="disabled">disabled</xsl:attribute>
              </xsl:if>
              <xsl:if test="scheduleDoubleBook = 'false'">
                <xsl:attribute name="checked">checked</xsl:attribute>
              </xsl:if>
              <xsl:copy-of select="$bwStr-ScPr-False"/>
            </input>
          </td>
        </tr>
        <tr>
          <td colspan="2">&#160;</td>
        </tr>
        <tr>
          <td class="fieldname">
            <xsl:copy-of select="$bwStr-ScPr-CancelProcessing"/>
          </td>
          <td>
            <select name="scheduleAutoCancelAction" id="scheduleAutoCancelAction">
              <option value="0">
                <xsl:if test="scheduleAutoCancelAction = '0'">
                  <xsl:attribute name="selected">selected</xsl:attribute>
                </xsl:if>
                <xsl:copy-of select="$bwStr-ScPr-SetToCanceled"/>
              </option>
              <option value="1">
                <xsl:if test="scheduleAutoCancelAction = '1'">
                  <xsl:attribute name="selected">selected</xsl:attribute>
                </xsl:if>
                <xsl:copy-of select="$bwStr-ScPr-DeleteEvent"/>
              </option>
            </select>
          </td>
        </tr>
        <tr>
          <td class="fieldname">
            <xsl:copy-of select="$bwStr-ScPr-ReponseProcessing"/>
          </td>
          <td>
            <select name="scheduleAutoProcessResponses">
              <option value="0">
                <xsl:if test="scheduleAutoProcessResponses = '0'">
                  <xsl:attribute name="selected">selected</xsl:attribute>
                </xsl:if>
                <xsl:copy-of select="$bwStr-ScPr-ProcessAccepts"/>
              </option>
              <option value="1">
                <xsl:if test="scheduleAutoProcessResponses = '1'">
                  <xsl:attribute name="selected">selected</xsl:attribute>
                </xsl:if>
                <xsl:copy-of select="$bwStr-ScPr-LeaveInInbox"/>
              </option>
              <option value="2">
                <xsl:if test="scheduleAutoProcessResponses = '2'">
                  <xsl:attribute name="selected">selected</xsl:attribute>
                </xsl:if>
                <xsl:copy-of select="$bwStr-ScPr-TryToProcessAll"/>
              </option>
            </select>
          </td>
        </tr>
      </table>
      <input type="submit" name="modPrefs" value="{$bwStr-ScPr-UpdateSchedulingProcessing}"/>
      <input type="submit" name="cancelled" value="{$bwStr-ScPr-Cancel}"/>
    </form>
  </xsl:template>

  <!-- construct the workDay times options listings from minute 0 to less than
       minute 1440 (midnight inclusive); initialize the template with the currently
       selected value. Change the default value for "increment" here. minTime
       and maxTime are constants. -->
  <xsl:template name="buildWorkdayOptionsList">
    <xsl:param name="selectedVal"/>
    <xsl:param name="increment" select="number(30)"/>
    <xsl:param name="currentTime" select="number(0)"/>
    <xsl:variable name="minTime" select="number(0)"/>
    <xsl:variable name="maxTime" select="number(1440)"/>
    <xsl:if test="$currentTime &lt; $maxTime">
      <option value="{$currentTime}">
        <xsl:if test="$currentTime = $selectedVal"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
        <xsl:if test="floor($currentTime div 60) &lt; 10">0</xsl:if><xsl:value-of select="floor($currentTime div 60)"/>:<xsl:if test="string-length($currentTime mod 60)=1">0</xsl:if><xsl:value-of select="$currentTime mod 60"/>
      </option>
      <xsl:call-template name="buildWorkdayOptionsList">
        <xsl:with-param name="selectedVal" select="$selectedVal"/>
        <xsl:with-param name="currentTime" select="$currentTime + $increment"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>


</xsl:stylesheet>