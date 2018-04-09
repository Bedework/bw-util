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

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="formElements" mode="eventForm">
    <xsl:variable name="calPath" select="form/calendar/path"/>
    <xsl:variable name="guid" select="guid"/>
    <xsl:variable name="recurrenceId" select="recurrenceId"/>
    <!-- comment field to hold the user's suggestions:  -->
    <input type="hidden" name="xbwsubmitcomment" id="bwEventComment" value=""/>

      <!-- event info for edit event -->
      <xsl:if test="/bedework/creating != 'true'">

        <table class="common" cellspacing="0">
          <tr>
            <th colspan="2" class="commonHeader">
              <div id="eventActions">
                <xsl:choose>
                  <xsl:when test="recurrenceId != ''">
                    <img src="{$resourcesRoot}/images/trashIcon.gif" width="13" height="13" alt="delete"/>
                    <xsl:copy-of select="$bwStr-FoEl-DeleteColon"/>
                    <a href="{$delEvent}&amp;calPath={$calPath}&amp;guid={$guid}" title="delete master (recurring event)"><xsl:copy-of select="$bwStr-FoEl-All"/></a>,
                    <a href="{$delEvent}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}" title="delete instance (recurring event)"><xsl:copy-of select="$bwStr-FoEl-Instance"/>instance</a>
                  </xsl:when>
                  <xsl:otherwise>
                    <a href="{$delEvent}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}" title="delete event">
                      <img src="{$resourcesRoot}/images/trashIcon.gif" width="13" height="13" alt="delete"/>
                      <xsl:copy-of select="$bwStr-FoEl-Delete"/>
                      <xsl:if test="form/recurringEntity='true'">
                        <xsl:copy-of select="$bwStr-FoEl-All"/>
                      </xsl:if>
                    </a>
                  </xsl:otherwise>
                </xsl:choose>
              </div>
              <!-- Display type of event -->
              <xsl:variable name="entityType">
                <xsl:choose>
                  <xsl:when test="entityType = '2'"><xsl:copy-of select="$bwStr-FoEl-TASK"/></xsl:when>
                  <xsl:when test="scheduleMethod = '2'"><xsl:copy-of select="$bwStr-FoEl-Meeting"/></xsl:when>
                  <xsl:otherwise><xsl:copy-of select="$bwStr-FoEl-EVENT"/></xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              <xsl:if test="form/recurringEntity='true' or recurrenceId != ''">
                <xsl:copy-of select="$bwStr-FoEl-Recurring"/>
              </xsl:if>
              <xsl:choose>
                <xsl:when test="form">
                  <!-- just a placeholder: need to add owner to the jsp -->
                  <xsl:copy-of select="$bwStr-FoEl-Personal"/><xsl:text> </xsl:text><xsl:value-of select="$entityType"/>
                </xsl:when>
                <xsl:when test="public = 'true'">
                  <xsl:copy-of select="$bwStr-FoEl-Public"/><xsl:text> </xsl:text><xsl:value-of select="$entityType"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$entityType"/> (<xsl:value-of select="calendar/owner"/>)
                </xsl:otherwise>
              </xsl:choose>
              <xsl:if test="form/recurringEntity='true' and recurrenceId = ''">
                <xsl:text> </xsl:text>
                <em><xsl:copy-of select="$bwStr-FoEl-RecurrenceMaster"/></em>
              </xsl:if>
            </th>
          </tr>
        </table>
      </xsl:if>

    <div id="instructions">
      <div id="bwHelp-Details">
        <div class="navButtons">
          <a href="javascript:show('bwEventTab-Location','bwHelp-Location','bwBottomNav-Location');hide('bwEventTab-Details','bwHelp-Details','bwBottomNav-Details');"
             onclick="return validateStep1();">
            <xsl:copy-of select="$bwStr-FoEl-Next"/>
            <xsl:text> </xsl:text>
            <img alt="{$bwStr-FoEl-Next}"
              src="{$resourcesRoot}/images/arrowRight.gif"
              width="13"
              height="13"
             />
          </a>
        </div>
        <xsl:copy-of select="$bwStr-FoEl-Step1"/>
      </div>
      <div id="bwHelp-Location" class="invisible">
        <div class="navButtons">
          <a href="javascript:show('bwEventTab-Details','bwHelp-Details','bwBottomNav-Details'); hide('bwEventTab-Location','bwHelp-Location','bwBottomNav-Location');">
            <img alt="{$bwStr-FoEl-Previous}"
              src="{$resourcesRoot}/images/arrowLeft.gif"
              width="13"
              height="13"
             />
            <xsl:text> </xsl:text>
            <xsl:copy-of select="$bwStr-FoEl-Previous"/>
          </a> |
          <a href="javascript:show('bwEventTab-Contact','bwHelp-Contact','bwBottomNav-Contact'); hide('bwEventTab-Location','bwHelp-Location','bwBottomNav-Location');"
             onclick="return validateStep2();">
            <xsl:copy-of select="$bwStr-FoEl-Next"/>
            <xsl:text> </xsl:text>
            <img alt="{$bwStr-FoEl-Next}"
              src="{$resourcesRoot}/images/arrowRight.gif"
              width="13"
              height="13"
             />
          </a>
        </div>
        <xsl:copy-of select="$bwStr-FoEl-Step2"/>
      </div>
      <div id="bwHelp-Contact" class="invisible">
        <div class="navButtons">
          <a href="javascript:show('bwEventTab-Location','bwHelp-Location','bwBottomNav-Location'); hide('bwHelp-Contact','bwEventTab-Contact','bwBottomNav-Contact');">
            <img alt="{$bwStr-FoEl-Previous}"
              src="{$resourcesRoot}/images/arrowLeft.gif"
              width="13"
              height="13"
             />
            <xsl:text> </xsl:text>
            <xsl:copy-of select="$bwStr-FoEl-Previous"/>
          </a> |
          <a href="javascript:show('bwEventTab-Categories','bwHelp-Categories','bwBottomNav-Categories'); hide('bwHelp-Contact','bwEventTab-Contact','bwBottomNav-Contact');"
             onclick="return validateStep3();">
            <xsl:copy-of select="$bwStr-FoEl-Next"/>
            <xsl:text> </xsl:text>
            <img alt="{$bwStr-FoEl-Next}"
              src="{$resourcesRoot}/images/arrowRight.gif"
              width="13"
              height="13"
             />
          </a>
        </div>
        <xsl:copy-of select="$bwStr-FoEl-Step3"/>
      </div>
      <div id="bwHelp-Categories" class="invisible">
        <!-- this tab is now "topical areas - we will leave the ids named "categories" for now. -->
        <div class="navButtons">
          <a href="javascript:show('bwEventTab-Contact','bwHelp-Contact','bwBottomNav-Contact'); hide('bwHelp-Categories','bwEventTab-Categories','bwBottomNav-Categories');">
            <img alt="{$bwStr-FoEl-Previous}"
              src="{$resourcesRoot}/images/arrowLeft.gif"
              width="13"
              height="13"
             />
            <xsl:text> </xsl:text>
            <xsl:copy-of select="$bwStr-FoEl-Previous"/>
          </a> |
          <a href="javascript:show('bwHelp-Review','bwEventTab-Review','bwBottomNav-Review'); hide('bwHelp-Categories','bwEventTab-Categories','bwBottomNav-Categories'); ">
            <xsl:copy-of select="$bwStr-FoEl-Next"/>
            <xsl:text> </xsl:text>
            <img alt="{$bwStr-FoEl-Next}"
              src="{$resourcesRoot}/images/arrowRight.gif"
              width="13"
              height="13"
             />
          </a>
        </div>
        <xsl:copy-of select="$bwStr-FoEl-Step4"/>
      </div>
      <div id="bwHelp-Review" class="invisible">
        <div class="navButtons">
          <a href="javascript:show('bwHelp-Categories','bwEventTab-Categories','bwBottomNav-Categories'); hide('bwHelp-Review','bwEventTab-Review','bwBottomNav-Review'); ">
            <img alt="{$bwStr-FoEl-Previous}"
              src="{$resourcesRoot}/images/arrowLeft.gif"
              width="13"
              height="13"
             />
            <xsl:text> </xsl:text>
            <xsl:copy-of select="$bwStr-FoEl-Previous"/>
          </a>
        </div>
        <xsl:copy-of select="$bwStr-FoEl-Step5"/>
      </div>
    </div>

    <div id="eventFormContent">
      <!-- Basic tab -->
      <!-- ============== -->
      <!-- this tab is visible by default -->
      <div id="bwEventTab-Details">
        <table cellspacing="0" class="common">
          <!-- Calendar -->
          <!-- ======== -->
          <xsl:variable name="submissionCalendars">
            <xsl:value-of select="count(/bedework/myCalendars//calendar[calType='1'])"/>
          </xsl:variable>
          <tr>
            <xsl:if test="$submissionCalendars = 1">
              <xsl:attribute name="class">invisible</xsl:attribute>
              <!-- hide this row altogether if there is only one calendar; if you want the calendar
                   path displayed, comment out this xsl:if. -->
            </xsl:if>
            <td class="fieldname">
              <xsl:copy-of select="$bwStr-FoEl-Calendar"/>
            </td>
            <td class="fieldval">
              <xsl:choose>
                <xsl:when test="$submissionCalendars = 1">
                  <!-- there is only 1 writable calendar, just send a hidden field -->
                  <xsl:variable name="newCalPath"><xsl:value-of select="/bedework/myCalendars//calendar[calType='1']/path"/></xsl:variable>
                  <input type="hidden" name="newCalPath" value="{$newCalPath}"/>
                  <span id="bwEventCalDisplay">
                    <xsl:value-of select="$newCalPath"/>
                  </span>
                </xsl:when>
                <xsl:otherwise>
                  <select name="newCalPath" id="bwNewCalPathField">
                    <xsl:for-each select="/bedework/myCalendars//calendar[calType='1']">
                      <option>
                        <xsl:attribute name="value"><xsl:value-of select="path"/></xsl:attribute>
                        <xsl:value-of select="substring-after(substring-after(path,/bedework/submissionsRoot/unencoded),'/')"/>
                      </option>
                    </xsl:for-each>
                  </select>
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
          <!--  Summary (title) of event  -->
          <!--  ========================= -->
          <tr>
            <td class="fieldname">
              <xsl:copy-of select="$bwStr-FoEl-Title"/>
            </td>
            <td class="fieldval">
              <div id="bwEventTitleNotice" class="invisible"><xsl:copy-of select="$bwStr-FoEl-MustIncludeTitle"/></div> <!-- a holder for validation notes -->
              <xsl:variable name="title" select="form/title/input/@value"/>
              <input type="text" name="summary" size="80" value="{$title}" id="bwEventTitle"/>
            </td>
          </tr>

          <!--  Date and Time -->
          <!--  ============= -->
          <tr>
            <td class="fieldname">
              <xsl:copy-of select="$bwStr-FoEl-DateAndTime"/>
            </td>
            <td class="fieldval">
              <!-- Set the timefields class for the first load of the page;
                   subsequent changes will take place using javascript without a
                   page reload. -->
              <xsl:variable name="timeFieldsClass">
                <xsl:choose>
                  <xsl:when test="form/allDay/input/@checked='checked'">invisible</xsl:when>
                  <xsl:otherwise>timeFields</xsl:otherwise>
                </xsl:choose>
              </xsl:variable>

              <!-- All day flag -->
                <input type="checkbox" name="allDayFlag" id="allDayFlag" onclick="swapAllDayEvent(this)" value="off">
                  <xsl:if test="form/allDay/input/@checked='checked'">
                    <xsl:attribute name="checked">checked</xsl:attribute>
                    <xsl:attribute name="value">on</xsl:attribute>
                  </xsl:if>
                </input>
                <input type="hidden" name="eventStartDate.dateOnly" value="off" id="allDayStartDateField">
                  <xsl:if test="form/allDay/input/@checked='checked'">
                    <xsl:attribute name="value">on</xsl:attribute>
                  </xsl:if>
                </input>
                <input type="hidden" name="eventEndDate.dateOnly" value="off" id="allDayEndDateField">
                  <xsl:if test="form/allDay/input/@checked='checked'">
                    <xsl:attribute name="value">on</xsl:attribute>
                  </xsl:if>
                </input>
                <label for="allDayFlag">
                  <xsl:copy-of select="$bwStr-FoEl-AllDay"/>
                </label>

              <!-- HIDE floating event: no timezone (and not UTC)
              <xsl:choose>
                <xsl:when test="form/floating/input/@checked='checked'">
                  <input type="checkbox" name="floatingFlag" id="floatingFlag" onclick="swapFloatingTime(this)" value="on" checked="checked"/>
                  <input type="hidden" name="eventStartDate.floating" value="true" id="startFloating"/>
                  <input type="hidden" name="eventEndDate.floating" value="true" id="endFloating"/>
                </xsl:when>
                <xsl:otherwise>
                  <input type="checkbox" name="floatingFlag" id="floatingFlag" onclick="swapFloatingTime(this)" value="off"/>
                  <input type="hidden" name="eventStartDate.floating" value="false" id="startFloating"/>
                  <input type="hidden" name="eventEndDate.floating" value="false" id="endFloating"/>
                </xsl:otherwise>
              </xsl:choose>
              floating -->

              <!-- HIDE store time as coordinated universal time (UTC)
              <xsl:choose>
                <xsl:when test="form/storeUTC/input/@checked='checked'">
                  <input type="checkbox" name="storeUTCFlag" id="storeUTCFlag" onclick="swapStoreUTC(this)" value="on" checked="checked"/>
                  <input type="hidden" name="eventStartDate.storeUTC" value="true" id="startStoreUTC"/>
                  <input type="hidden" name="eventEndDate.storeUTC" value="true" id="endStoreUTC"/>
                </xsl:when>
                <xsl:otherwise>
                  <input type="checkbox" name="storeUTCFlag" id="storeUTCFlag" onclick="swapStoreUTC(this)" value="off"/>
                  <input type="hidden" name="eventStartDate.storeUTC" value="false" id="startStoreUTC"/>
                  <input type="hidden" name="eventEndDate.storeUTC" value="false" id="endStoreUTC"/>
                </xsl:otherwise>
              </xsl:choose>
              store as UTC-->

              <br/>
              <div class="dateStartEndBox">
                <strong><xsl:copy-of select="$bwStr-FoEl-Start"/></strong>
                <div class="dateFields">
                  <span class="startDateLabel"><xsl:copy-of select="$bwStr-FoEl-Date"/><xsl:text> </xsl:text></span>
                  <xsl:choose>
                    <xsl:when test="$portalFriendly = 'true'">
                      <xsl:copy-of select="/bedework/formElements/form/start/month/*"/>
                      <xsl:copy-of select="/bedework/formElements/form/start/day/*"/>
                      <xsl:choose>
                        <xsl:when test="/bedework/creating = 'true'">
                          <xsl:copy-of select="/bedework/formElements/form/start/year/*"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:copy-of select="/bedework/formElements/form/start/yearText/*"/>
                        </xsl:otherwise>
                      </xsl:choose>
                      <script language="JavaScript" type="text/javascript">
                        <xsl:comment>
                        startDateDynCalWidget = new dynCalendar('startDateDynCalWidget', <xsl:value-of select="number(/bedework/formElements/form/start/yearText/input/@value)"/>, <xsl:value-of select="number(/bedework/formElements/form/start/month/select/option[@selected='selected']/@value)-1"/>, <xsl:value-of select="number(/bedework/formElements/form/start/day/select/option[@selected='selected']/@value)"/>, 'startDateCalWidgetCallback', '<xsl:value-of select="$resourcesRoot"/>/images/');
                        </xsl:comment>
                      </script>
                    </xsl:when>
                    <xsl:otherwise>
                      <input type="text" name="bwEventWidgetStartDate" id="bwEventWidgetStartDate" size="10"/>
                      <script language="JavaScript" type="text/javascript">
                        <xsl:comment>
                        /*$("#bwEventWidgetStartDate").datepicker({
                          defaultDate: new Date(<xsl:value-of select="form/start/yearText/input/@value"/>, <xsl:value-of select="number(form/start/month/select/option[@selected = 'selected']/@value) - 1"/>, <xsl:value-of select="form/start/day/select/option[@selected = 'selected']/@value"/>)
                        }).attr("readonly", "readonly");
                        $("#bwEventWidgetStartDate").val('<xsl:value-of select="substring-before(form/start/rfc3339DateTime,'T')"/>');
                        */
                        </xsl:comment>
                      </script>
                      <input type="hidden" name="eventStartDate.year">
                        <xsl:attribute name="value"><xsl:value-of select="form/start/yearText/input/@value"/></xsl:attribute>
                      </input>
                      <input type="hidden" name="eventStartDate.month">
                        <xsl:attribute name="value"><xsl:value-of select="form/start/month/select/option[@selected = 'selected']/@value"/></xsl:attribute>
                      </input>
                      <input type="hidden" name="eventStartDate.day">
                        <xsl:attribute name="value"><xsl:value-of select="form/start/day/select/option[@selected = 'selected']/@value"/></xsl:attribute>
                      </input>
                    </xsl:otherwise>
                  </xsl:choose>
                </div>
                <div class="{$timeFieldsClass}" id="startTimeFields">
                  <span id="calWidgetStartTimeHider" class="show">
                      <select name="eventStartDate.hour" id="eventStartDateHour">
                        <xsl:copy-of select="form/start/hour/select/*"/>
                      </select>
                      <select name="eventStartDate.minute" id="eventStartDateMinute">
                        <xsl:copy-of select="form/start/minute/select/*"/>
                      </select>
                      <xsl:if test="form/start/ampm">
                        <select name="eventStartDate.ampm" id="eventStartDateAmpm">
                          <xsl:copy-of select="form/start/ampm/select/*"/>
                        </select>
                      </xsl:if>
                    <xsl:text> </xsl:text>
                    <img src="{$resourcesRoot}/images/clockIcon.gif" width="16" height="15" alt="bwClock" id="bwStartClock"/>

                    <select name="eventStartDate.tzid" id="startTzid" class="timezones">
                      <xsl:if test="form/floating/input/@checked='checked'"><xsl:attribute name="disabled">disabled</xsl:attribute></xsl:if>
                      <option value="-1"><xsl:copy-of select="$bwStr-FoEl-SelectTimezone"/></option>
                      <xsl:variable name="startTzId" select="form/start/tzid"/>
                      <xsl:for-each select="/bedework/timezones/timezone">
                        <option>
                          <xsl:attribute name="value"><xsl:value-of select="id"/></xsl:attribute>
                          <xsl:if test="$startTzId = id"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
                          <xsl:value-of select="name"/>
                        </option>
                      </xsl:for-each>
                    </select>
                  </span>
                </div>
              </div>
              <div class="dateStartEndBox">
                <strong>
                  <xsl:choose>
                    <xsl:when test="form/entityType = '2'"><xsl:copy-of select="$bwStr-FoEl-Due"/></xsl:when>
                    <xsl:otherwise><xsl:copy-of select="$bwStr-FoEl-End"/></xsl:otherwise>
                  </xsl:choose>
                </strong>
                <xsl:choose>
                  <xsl:when test="form/end/type='E'">
                    <input type="radio" name="eventEndType" id="bwEndDateTimeButton" value="E" checked="checked" onclick="changeClass('endDateTime','shown');changeClass('endDuration','invisible');"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <input type="radio" name="eventEndType" id="bwEndDateTimeButton" value="E" onclick="changeClass('endDateTime','shown');changeClass('endDuration','invisible');"/>
                  </xsl:otherwise>
                </xsl:choose>
                  <label for="bwEndDateTimeButton">
                    <xsl:copy-of select="$bwStr-FoEl-Date"/>
                  </label>
                <xsl:variable name="endDateTimeClass">
                  <xsl:choose>
                    <xsl:when test="form/end/type='E'">shown</xsl:when>
                    <xsl:otherwise>invisible</xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <div class="{$endDateTimeClass}" id="endDateTime">
                  <div class="dateFields">
                    <xsl:choose>
                      <xsl:when test="$portalFriendly = 'true'">
                        <xsl:copy-of select="/bedework/formElements/form/end/dateTime/month/*"/>
                        <xsl:copy-of select="/bedework/formElements/form/end/dateTime/day/*"/>
                        <xsl:choose>
                          <xsl:when test="/bedework/creating = 'true'">
                            <xsl:copy-of select="/bedework/formElements/form/end/dateTime/year/*"/>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:copy-of select="/bedework/formElements/form/end/dateTime/yearText/*"/>
                          </xsl:otherwise>
                        </xsl:choose>
                        <script language="JavaScript" type="text/javascript">
                        <xsl:comment>
                          endDateDynCalWidget = new dynCalendar('endDateDynCalWidget', <xsl:value-of select="number(/bedework/formElements/form/start/yearText/input/@value)"/>, <xsl:value-of select="number(/bedework/formElements/form/start/month/select/option[@selected='selected']/@value)-1"/>, <xsl:value-of select="number(/bedework/formElements/form/start/day/select/option[@selected='selected']/@value)"/>, 'endDateCalWidgetCallback', '<xsl:value-of select="$resourcesRoot"/>/images/');
                        </xsl:comment>
                        </script>
                      </xsl:when>
                      <xsl:otherwise>
                        <input type="text" name="bwEventWidgetEndDate" id="bwEventWidgetEndDate" size="10"/>
                        <script language="JavaScript" type="text/javascript">
                          <xsl:comment>
                          /*$("#bwEventWidgetEndDate").datepicker({
                            defaultDate: new Date(<xsl:value-of select="form/end/dateTime/yearText/input/@value"/>, <xsl:value-of select="number(form/end/dateTime/month/select/option[@selected = 'selected']/@value) - 1"/>, <xsl:value-of select="form/end/dateTime/day/select/option[@selected = 'selected']/@value"/>)
                          }).attr("readonly", "readonly");
                          $("#bwEventWidgetEndDate").val('<xsl:value-of select="substring-before(form/end/rfc3339DateTime,'T')"/>');
                          */
                          </xsl:comment>
                        </script>
                        <input type="hidden" name="eventEndDate.year">
                          <xsl:attribute name="value"><xsl:value-of select="form/end/dateTime/yearText/input/@value"/></xsl:attribute>
                        </input>
                        <input type="hidden" name="eventEndDate.month">
                          <xsl:attribute name="value"><xsl:value-of select="form/end/dateTime/month/select/option[@selected = 'selected']/@value"/></xsl:attribute>
                        </input>
                        <input type="hidden" name="eventEndDate.day">
                          <xsl:attribute name="value"><xsl:value-of select="form/end/dateTime/day/select/option[@selected = 'selected']/@value"/></xsl:attribute>
                        </input>
                      </xsl:otherwise>
                    </xsl:choose>
                  </div>
                  <div class="{$timeFieldsClass}" id="endTimeFields">
                    <span id="calWidgetEndTimeHider" class="show">
                        <select name="eventEndDate.hour" id="eventEndDateHour">
                          <xsl:copy-of select="form/end/dateTime/hour/select/*"/>
                        </select>
                        <select name="eventEndDate.minute" id="eventEndDateMinute">
                          <xsl:copy-of select="form/end/dateTime/minute/select/*"/>
                        </select>
                        <xsl:if test="form/start/ampm">
                          <select name="eventEndDate.ampm" id="eventEndDateAmpm">
                            <xsl:copy-of select="form/end/dateTime/ampm/select/*"/>
                          </select>
                        </xsl:if>
                      <xsl:text> </xsl:text>
                      <img src="{$resourcesRoot}/images/clockIcon.gif" width="16" height="15" alt="bwClock" id="bwEndClock"/>

                      <select name="eventEndDate.tzid" id="endTzid" class="timezones">
                        <xsl:if test="form/floating/input/@checked='checked'"><xsl:attribute name="disabled">disabled</xsl:attribute></xsl:if>
                        <option value="-1"><xsl:copy-of select="$bwStr-FoEl-SelectTimezone"/></option>
                        <xsl:variable name="endTzId" select="form/end/dateTime/tzid"/>
                        <xsl:for-each select="/bedework/timezones/timezone">
                          <option>
                            <xsl:attribute name="value"><xsl:value-of select="id"/></xsl:attribute>
                              <xsl:if test="$endTzId = id"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
                            <xsl:value-of select="name"/>
                          </option>
                        </xsl:for-each>
                      </select>
                    </span>
                  </div>
                </div><br/>
                <div class="dateFields">
                  <xsl:choose>
                    <xsl:when test="form/end/type='D'">
                      <input type="radio" name="eventEndType" id="bwEndDurationButton" value="D" checked="checked" onclick="changeClass('endDateTime','invisible');changeClass('endDuration','shown');"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <input type="radio" name="eventEndType" id="bwEndDurationButton" value="D" onclick="changeClass('endDateTime','invisible');changeClass('endDuration','shown');"/>
                    </xsl:otherwise>
                  </xsl:choose>
                    <label for="bwEndDurationButton">
                      <xsl:copy-of select="$bwStr-FoEl-Duration"/>
                    </label>
                  <xsl:variable name="endDurationClass">
                    <xsl:choose>
                      <xsl:when test="form/end/type='D'">shown</xsl:when>
                      <xsl:otherwise>invisible</xsl:otherwise>
                    </xsl:choose>
                  </xsl:variable>
                  <xsl:variable name="durationHrMinClass">
                    <xsl:choose>
                      <xsl:when test="form/allDay/input/@checked='checked'">invisible</xsl:when>
                      <xsl:otherwise>shown</xsl:otherwise>
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
                          <input type="text" name="eventDuration.daysStr" size="2" value="{$daysStr}" id="durationDays"/><xsl:copy-of select="$bwStr-FoEl-Days"/>
                          <span id="durationHrMin" class="{$durationHrMinClass}">
                            <xsl:variable name="hoursStr" select="form/end/duration/hours/input/@value"/>
                            <input type="text" name="eventDuration.hoursStr" size="2" value="{$hoursStr}" id="durationHours"/><xsl:copy-of select="$bwStr-FoEl-Hours"/>
                            <xsl:variable name="minutesStr" select="form/end/duration/minutes/input/@value"/>
                            <input type="text" name="eventDuration.minutesStr" size="2" value="{$minutesStr}" id="durationMinutes"/><xsl:copy-of select="$bwStr-FoEl-Minutes"/>
                          </span>
                        </div>
                        <span class="durationSpacerText"><xsl:copy-of select="$bwStr-FoEl-Or"/></span>
                        <div class="durationBox">
                          <input type="radio" name="eventDuration.type" value="weeks" onclick="swapDurationType('week')"/>
                          <xsl:variable name="weeksStr" select="form/end/duration/weeks/input/@value"/>
                          <input type="text" name="eventDuration.weeksStr" size="2" value="{$weeksStr}" id="durationWeeks" disabled="disabled"/><xsl:copy-of select="$bwStr-FoEl-Weeks"/>
                        </div>
                      </xsl:when>
                      <xsl:otherwise>
                        <!-- we are using week format -->
                        <div class="durationBox">
                          <input type="radio" name="eventDuration.type" value="daytime" onclick="swapDurationType('daytime')"/>
                          <xsl:variable name="daysStr" select="form/end/duration/days/input/@value"/>
                          <input type="text" name="eventDuration.daysStr" size="2" value="{$daysStr}" id="durationDays" disabled="disabled"/><xsl:copy-of select="$bwStr-FoEl-Days"/>
                          <span id="durationHrMin" class="{$durationHrMinClass}">
                            <xsl:variable name="hoursStr" select="form/end/duration/hours/input/@value"/>
                            <input type="text" name="eventDuration.hoursStr" size="2" value="{$hoursStr}" id="durationHours" disabled="disabled"/><xsl:copy-of select="$bwStr-FoEl-Hours"/>
                            <xsl:variable name="minutesStr" select="form/end/duration/minutes/input/@value"/>
                            <input type="text" name="eventDuration.minutesStr" size="2" value="{$minutesStr}" id="durationMinutes" disabled="disabled"/><xsl:copy-of select="$bwStr-FoEl-Minutes"/>
                          </span>
                        </div>
                        <span class="durationSpacerText"><xsl:copy-of select="$bwStr-FoEl-Or"/></span>
                        <div class="durationBox">
                          <input type="radio" name="eventDuration.type" value="weeks" onclick="swapDurationType('week')" checked="checked"/>
                          <xsl:variable name="weeksStr" select="form/end/duration/weeks/input/@value"/>
                          <input type="text" name="eventDuration.weeksStr" size="2" value="{$weeksStr}" id="durationWeeks"/><xsl:copy-of select="$bwStr-FoEl-Weeks"/>
                        </div>
                      </xsl:otherwise>
                    </xsl:choose>
                  </div>
                </div><br/>
                <div class="dateFields" id="noDuration">
                  <xsl:choose>
                    <xsl:when test="form/end/type='N'">
                      <input type="radio" name="eventEndType" id="bwEndNoneButton" value="N" checked="checked" onclick="changeClass('endDateTime','invisible');changeClass('endDuration','invisible');"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <input type="radio" name="eventEndType" id="bwEndNoneButton" value="N" onclick="changeClass('endDateTime','invisible');changeClass('endDuration','invisible');"/>
                    </xsl:otherwise>
                  </xsl:choose>
                  <label for="bwEndNoneButton">
                      <xsl:copy-of select="$bwStr-FoEl-This"/><xsl:text> </xsl:text>
                      <xsl:choose>
                        <xsl:when test="form/entityType = '2'"><xsl:copy-of select="$bwStr-FoEl-Task"/></xsl:when>
                        <xsl:otherwise><xsl:copy-of select="$bwStr-FoEl-Event"/></xsl:otherwise>
                      </xsl:choose>
                      <xsl:text> </xsl:text>
                    <xsl:copy-of select="$bwStr-FoEl-HasNoDurationEndDate"/>
                  </label>
                </div>
              </div>
            </td>
          </tr>

          <!--  Description  -->
          <tr>
            <td class="fieldname"><xsl:copy-of select="$bwStr-FoEl-Description"/></td>
            <td class="fieldval">
              <div id="bwEventDescNotice" class="invisible"><xsl:copy-of select="$bwStr-FoEl-MustIncludeDescription"/></div> <!-- a holder for validation notes -->
              <xsl:choose>
                <xsl:when test="normalize-space(form/desc/textarea) = ''">
                  <textarea name="description" cols="60" rows="4" id="bwEventDesc">
                    <xsl:text> </xsl:text>
                  </textarea>
                  <!-- keep this space to avoid browser
                  rendering errors when the text area is empty -->
                </xsl:when>
                <xsl:otherwise>
                  <textarea name="description" cols="60" rows="4" id="bwEventDesc">
                    <xsl:value-of select="form/desc/textarea"/>
                  </textarea>
                </xsl:otherwise>
              </xsl:choose>
              <br />
              <span class="maxCharNotice"><xsl:value-of select="form/descLength"/><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-FoEl-CharsMax"/></span>
              <span id="remainingChars">&#160;</span>
            </td>
          </tr>
          <!--  Status  -->
          <!-- <tr>
            <td class="fieldname">
              <xsl:copy-of select="$bwStr-FoEl-Status"/>
            </td>
            <td class="fieldval">
              <input type="radio" name="eventStatus" value="CONFIRMED">
                <xsl:if test="form/status = 'CONFIRMED' or /bedework/creating = 'true' or form/status = ''"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
              </input>
              <xsl:copy-of select="$bwStr-FoEl-Confirmed"/>
              <input type="radio" name="eventStatus" value="TENTATIVE">
                <xsl:if test="form/status = 'TENTATIVE'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
              </input>
              <xsl:copy-of select="$bwStr-FoEl-Tentative"/>
              <input type="radio" name="eventStatus" value="CANCELLED">
                <xsl:if test="form/status = 'CANCELLED'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
              </input>
              <xsl:copy-of select="$bwStr-FoEl-Canceled"/>
            </td>
          </tr> -->
          <!-- Cost -->
          <tr>
            <td class="fieldname"><em><xsl:copy-of select="$bwStr-FoEl-Cost"/></em></td>
            <td class="fieldval">
              <input type="text" name="eventCost" size="30" value="">
                <xsl:attribute name="value"><xsl:value-of select="form/cost/input/@value"/></xsl:attribute>
              </input>
              <span class="note"><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-FoEl-CostOptional"/></span>
            </td>
          </tr>
          <!--  Link (url associated with event)  -->
          <tr>
            <td class="fieldname"><em><xsl:copy-of select="$bwStr-FoEl-EventURL"/></em></td>
            <td class="fieldval">
              <input type="text" name="eventLink" size="30" value="">
                <xsl:attribute name="value"><xsl:value-of select="form/link/input/@value"/></xsl:attribute>
              </input>
              <span class="note"><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-FoEl-EventURLOptional"/></span>
            </td>
          </tr>
          <!-- Image Url -->
          <tr>
            <td class="fieldname"><em><xsl:copy-of select="$bwStr-FoEl-ImageURL"/></em></td>
            <td class="fieldval">
              <input type="text" name="xBwImageHolder" size="30" value="">
                <xsl:attribute name="value"><xsl:value-of select="form/xproperties/node()[name()='X-BEDEWORK-IMAGE']/values/text" disable-output-escaping="yes"/></xsl:attribute>
              </input>
              <xsl:text> </xsl:text>
              <span class="note"><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-FoEl-ImageURLOptional"/></span>
            </td>
          </tr>
        </table>
      </div>

      <!-- Location tab -->
      <!-- ============== -->
      <div id="bwEventTab-Location" class="invisible">
        <div id="bwLocationUidNotice" class="invisible"><xsl:copy-of select="$bwStr-FoEl-MustSelectLocation"/></div>
        <div class="mainForm">
          <span id="eventFormLocationList">
            <select name="locationUid" class="bigSelect" id="bwLocationUid">
              <option value=""><xsl:copy-of select="$bwStr-FoEl-SelectExistingLocation"/></option>
              <xsl:copy-of select="form/location/locationmenu/select/*"/>
            </select>
          </span>
        </div>
        <p class="subFormMessage">
          <xsl:copy-of select="$bwStr-FoEl-DidntFindLocation"/>
        </p>
        <div class="subForm">
          <p>
            <label for="commentLocationAddress"><xsl:copy-of select="$bwStr-FoEl-Address"/><xsl:text> </xsl:text></label>
            <input type="text" name="commentLocationAddress" id="bwCommentLocationAddress">
              <xsl:attribute name="value"><xsl:value-of select="form/xproperties/node()[name()='X-BEDEWORK-LOCATION']/values/text" disable-output-escaping="yes"/></xsl:attribute>
            </input>
          </p>
          <p>
            <label for="commentLocationSubaddress"><em><xsl:copy-of select="$bwStr-FoEl-SubAddress"/></em> </label>
            <input type="text" name="commentLocationSubaddress" id="commentLocationSubaddress">
              <xsl:attribute name="value"><xsl:value-of select="form/xproperties/node()[name()='X-BEDEWORK-LOCATION']/parameters/node()[name()='X-BEDEWORK-PARAM-SUBADDRESS']" disable-output-escaping="yes"/></xsl:attribute>
            </input>
            <span class="note"><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-FoEl-Optional"/></span>
          </p>
          <p>
            <label for="commentLocationURL"><em><xsl:copy-of select="$bwStr-FoEl-URL"/></em> </label>
            <input type="text" name="commentLocationURL" id="commentLocationURL">
              <xsl:attribute name="value"><xsl:value-of select="form/xproperties/node()[name()='X-BEDEWORK-LOCATION']/parameters/node()[name()='X-BEDEWORK-PARAM-URL']" disable-output-escaping="yes"/></xsl:attribute>
            </input>
            <span class="note"><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-FoEl-Optional"/></span>
          </p>
        </div>
      </div>

      <!-- Contact tab -->
      <!-- ============== -->
      <div id="bwEventTab-Contact" class="invisible">
        <div id="bwContactUidNotice" class="invisible"><xsl:copy-of select="$bwStr-FoEl-MustSelectContact"/></div>
        <div class="mainForm">
          <select name="contactUid" id="bwContactUid" class="bigSelect">
            <option value="">
              <xsl:copy-of select="$bwStr-FoEl-SelectExistingContact"/>
            </option>
            <xsl:copy-of select="form/contact/all/select/*"/>
          </select>
        </div>
        <p class="subFormMessage">
          <xsl:copy-of select="$bwStr-FoEl-DidntFindContact"/>
        </p>
        <div class="subForm">
          <p>
            <label for="commentContactName"><xsl:copy-of select="$bwStr-FoEl-OrganizationName"/><xsl:text> </xsl:text> </label>
            <input type="text" name="commentContactName" id="bwCommentContactName" size="40">
              <xsl:attribute name="value"><xsl:value-of select="form/xproperties/node()[name()='X-BEDEWORK-CONTACT']/values/text" disable-output-escaping="yes"/></xsl:attribute>
            </input>
            <span class="note"><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-FoEl-PleaseLimitContacts"/></span>
          </p>
          <p>
            <label for="commentContactPhone"><em><xsl:copy-of select="$bwStr-FoEl-Phone"/></em> </label>
            <input type="text" name="commentContactPhone">
              <xsl:attribute name="value"><xsl:value-of select="form/xproperties/node()[name()='X-BEDEWORK-CONTACT']/parameters/node()[name()='X-BEDEWORK-PARAM-PHONE']" disable-output-escaping="yes"/></xsl:attribute>
            </input>
            <span class="note"><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-FoEl-Optional"/></span>
          </p>
          <p>
            <label for="commentContactURL"><em><xsl:copy-of select="$bwStr-FoEl-URL"/></em> </label>
            <input type="text" name="commentContactURL">
              <xsl:attribute name="value"><xsl:value-of select="form/xproperties/node()[name()='X-BEDEWORK-CONTACT']/parameters/node()[name()='X-BEDEWORK-PARAM-URL']" disable-output-escaping="yes"/></xsl:attribute>
            </input>
            <span class="note"><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-FoEl-Optional"/></span>
          </p>
          <p>
            <label for="commentContactEmail"><em><xsl:copy-of select="$bwStr-FoEl-Email"/></em> </label>
            <input type="text" name="commentContactEmail">
              <xsl:attribute name="value"><xsl:value-of select="form/xproperties/node()[name()='X-BEDEWORK-CONTACT']/parameters/node()[name()='X-BEDEWORK-PARAM-EMAIL']" disable-output-escaping="yes"/></xsl:attribute>
            </input>
            <span class="note"><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-FoEl-Optional"/></span>
          </p>
        </div>
      </div>

      <!-- Topical areas tab -->
      <!-- ================= -->
      <div id="bwEventTab-Categories" class="invisible">
        <!-- Topical area  -->
        <!-- These are the subscriptions (aliases) where the events should show up.
             By selecting one or more of these, appropriate categories will be set on the event -->
        <ul class="aliasTree">
          <!-- hard coding the "aliases" name is not best, but will do for now -->
          <xsl:apply-templates select="form/calendars/calendar" mode="showEventFormAliases">
            <xsl:with-param name="root">true</xsl:with-param>
            <xsl:sort select="summary" />
          </xsl:apply-templates>
        </ul>
        <p class="subFormMessage">
          <xsl:copy-of select="$bwStr-FoEl-MissingTopicalArea"/>
        </p>
        <div class="subForm">
          <p>
            <label for="commentCategories"><xsl:copy-of select="$bwStr-FoEl-TypeOfEvent"/><xsl:text> </xsl:text></label>
            <input type="text" name="commentCategories" size="80">
              <xsl:attribute name="value"><xsl:value-of select="form/xproperties/node()[name()='X-BEDEWORK-CATEGORIES']/values/text" disable-output-escaping="yes"/></xsl:attribute>
            </input>
          </p>
        </div>
        <!-- xsl:variable name="catCount" select="count(form/categories/all/category)"/>
        <xsl:choose>
          <xsl:when test="not(form/categories/all/category)">
            no categories defined
          </xsl:when>
          <xsl:otherwise>
            <table cellpadding="0" id="allCategoryCheckboxes">
              <tr>
                <td>
                  <xsl:for-each select="form/categories/all/category[position() &lt;= ceiling($catCount div 2)]">
                    <input type="checkbox" name="catUid">
                      <xsl:attribute name="value"><xsl:value-of select="uid"/></xsl:attribute>
                      <xsl:if test="uid = ../../current//category/uid"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
                      <xsl:value-of select="value"/>
                    </input><br/>
                  </xsl:for-each>
                </td>
                <td>
                  <xsl:for-each select="form/categories/all/category[position() &gt; ceiling($catCount div 2)]">
                    <input type="checkbox" name="catUid">
                      <xsl:attribute name="value"><xsl:value-of select="uid"/></xsl:attribute>
                      <xsl:if test="uid = ../../current//category/uid"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
                      <xsl:value-of select="value"/>
                    </input><br/>
                  </xsl:for-each>
                </td>
              </tr>
            </table>
          </xsl:otherwise>
        </xsl:choose>
        <p class="subFormMessage">
          Didn't find the category you want?  Suggest a new one:
        </p>
        <div class="subForm">
          <p>
            <label for="commentCategories">Category suggestion: </label>
            <input type="text" name="commentCategories" size="30">
              <xsl:attribute name="value"><xsl:value-of select="form/xproperties/node()[name()='X-BEDEWORK-CATEGORIES']/values/text" disable-output-escaping="yes"/></xsl:attribute>
            </input>
          </p>
        </div-->
      </div>

      <!--   Review tab   -->
      <!-- ============== -->
      <div id="bwEventTab-Review" class="invisible">
        <!--  <table id="bwEventSubmitReview" class="common">
          <tr>
            <th colspan="2">Event Details</th>
          </tr>-->
          <!-- the form elements will be inserted here -->
        <!-- </table>-->

        <div id="bwCommentNotes">
          <!-- holders for validation notes -->
          <div id="xBwEmailHolderNotice" class="invisible"><xsl:copy-of select="$bwStr-FoEl-MustIncludeEmail"/></div>
          <div id="xBwEmailHolderInvalidNotice" class="invisible"><xsl:copy-of select="$bwStr-FoEl-InvalidEmailAddress"/></div>
          <p>
            <label for="xBwEmailHolder"><xsl:copy-of select="$bwStr-FoEl-EnterEmailAddress"/><xsl:text> </xsl:text></label><br/>
            <input type="text" name="xBwEmailHolder" id="xBwEmailHolder" size="80">
              <xsl:attribute name="value"><xsl:value-of select="form/xproperties/node()[name()='X-BEDEWORK-SUBMITTER-EMAIL']/values/text"/></xsl:attribute>
            </input>
          </p>

          <p>
            <xsl:copy-of select="$bwStr-FoEl-FinalNotes"/><br/>
          <!-- note: don't remove the #160 from the textarea or browsers will see it as a closed tag when empty -->
           <textarea name="commentNotes" cols="60" rows="4"><!--
           --><xsl:value-of select="normalize-space(form/xproperties/node()[name()='X-BEDEWORK-SUBMIT-COMMENT']/values/text)" disable-output-escaping="yes"/><!--
           --><xsl:if test="normalize-space(form/xproperties/node()[name()='X-BEDEWORK-SUBMIT-COMMENT']/values/text) = ''"><xsl:text> </xsl:text></xsl:if><!--
           --></textarea>
          </p>
        </div>
        <div class="eventSubmitButtons">
          <input name="submit" class="submit" type="submit" value="{$bwStr-FoEl-SubmitForApproval}"/>
          <input name="cancelled" type="submit" value="{$bwStr-FoEl-Cancel}"/>
        </div>
      </div>
    </div>

    <div id="bwBottomNav">
      <div id="bwBottomNav-Details">
        <div class="navButtons">
          <a href="javascript:show('bwEventTab-Location','bwHelp-Location','bwBottomNav-Location'); hide('bwEventTab-Details','bwHelp-Details','bwBottomNav-Details');"
             onclick="return validateStep1();">
            <xsl:copy-of select="$bwStr-FoEl-Next"/>
            <xsl:text> </xsl:text>
            <img alt="{$bwStr-FoEl-Next}"
              src="{$resourcesRoot}/images/arrowRight.gif"
              width="13"
              height="13"
             />
          </a>
        </div>
      </div>
      <div id="bwBottomNav-Location" class="invisible">
        <div class="navButtons">
          <a href="javascript:show('bwEventTab-Details','bwHelp-Details','bwBottomNav-Details'); hide('bwEventTab-Location','bwHelp-Location','bwBottomNav-Location');">
            <img alt="{$bwStr-FoEl-Previous}"
              src="{$resourcesRoot}/images/arrowLeft.gif"
              width="13"
              height="13"
             />
            <xsl:text> </xsl:text>
            <xsl:copy-of select="$bwStr-FoEl-Previous"/>
          </a> |
          <a href="javascript:show('bwEventTab-Contact','bwHelp-Contact','bwBottomNav-Contact'); hide('bwEventTab-Location','bwHelp-Location','bwBottomNav-Location');"
             onclick="return validateStep2();">
            <xsl:copy-of select="$bwStr-FoEl-Next"/>
            <xsl:text> </xsl:text>
            <img alt="{$bwStr-FoEl-Next}"
              src="{$resourcesRoot}/images/arrowRight.gif"
              width="13"
              height="13"
             />
          </a>
        </div>
      </div>
      <div id="bwBottomNav-Contact" class="invisible">
        <div class="navButtons">
          <a href="javascript:show('bwEventTab-Location','bwHelp-Location','bwBottomNav-Location'); hide('bwHelp-Contact','bwEventTab-Contact','bwBottomNav-Contact');">
            <img alt="{$bwStr-FoEl-Previous}"
              src="{$resourcesRoot}/images/arrowLeft.gif"
              width="13"
              height="13"
             />
            <xsl:text> </xsl:text>
            <xsl:copy-of select="$bwStr-FoEl-Previous"/>
          </a> |
          <a href="javascript:show('bwEventTab-Categories','bwHelp-Categories','bwBottomNav-Categories'); hide('bwHelp-Contact','bwEventTab-Contact','bwBottomNav-Contact');"
             onclick="return validateStep3();">
            <xsl:copy-of select="$bwStr-FoEl-Next"/>
            <xsl:text> </xsl:text>
            <img alt="{$bwStr-FoEl-Next}"
              src="{$resourcesRoot}/images/arrowRight.gif"
              width="13"
              height="13"
             />
          </a>
        </div>
      </div>
      <div id="bwBottomNav-Categories" class="invisible">
        <div class="navButtons">
          <a href="javascript:show('bwEventTab-Contact','bwHelp-Contact','bwBottomNav-Contact'); hide('bwHelp-Categories','bwEventTab-Categories','bwBottomNav-Categories');">
            <img alt="{$bwStr-FoEl-Previous}"
              src="{$resourcesRoot}/images/arrowLeft.gif"
              width="13"
              height="13"
             />
            <xsl:text> </xsl:text>
            <xsl:copy-of select="$bwStr-FoEl-Previous"/>
          </a> |
          <a href="javascript:show('bwHelp-Review','bwEventTab-Review','bwBottomNav-Review'); hide('bwHelp-Categories','bwEventTab-Categories','bwBottomNav-Categories');">
            <!-- displayReview('standardForm','bwEventSubmitReview',1) -->
            <xsl:copy-of select="$bwStr-FoEl-Next"/>
            <xsl:text> </xsl:text>
            <img alt="{$bwStr-FoEl-Next}"
              src="{$resourcesRoot}/images/arrowRight.gif"
              width="13"
              height="13"
             />
          </a>
        </div>
      </div>
      <div id="bwBottomNav-Review" class="invisible">
        <div class="navButtons">
          <a href="javascript:show('bwHelp-Categories','bwEventTab-Categories','bwBottomNav-Categories'); hide('bwHelp-Review','bwEventTab-Review','bwBottomNav-Review'); ">
            <img alt="{$bwStr-FoEl-Previous}"
              src="{$resourcesRoot}/images/arrowLeft.gif"
              width="13"
              height="13"
             />
            <xsl:text> </xsl:text>
            <xsl:copy-of select="$bwStr-FoEl-Previous"/>
          </a>
          <span class="hidden">
            <xsl:text> </xsl:text>|<xsl:text> </xsl:text>
            <xsl:copy-of select="$bwStr-FoEl-Next"/>
            <xsl:text> </xsl:text>
            <img alt="{$bwStr-FoEl-Next}"
              src="{$resourcesRoot}/images/arrowRight.gif"
              width="13"
              height="13"
             />
          </span>
        </div>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="calendar" mode="showEventFormAliases">
    <xsl:param name="root">false</xsl:param>
    <li>
      <xsl:if test="$root != 'true'">
        <!-- hide the root calendar. -->
        <xsl:choose>
          <xsl:when test="calType = '7' or calType = '8'">
            <!-- we've hit an unresolvable alias; stop descending -->
            <input type="checkbox" name="forDiplayOnly" disabled="disabled"/>
            <em><xsl:value-of select="summary"/>?</em>
          </xsl:when>
          <xsl:when test="calType = '0'">
            <!-- no direct selecting of folders or folder aliases: we only want users to select the
                 underlying calendar aliases -->
            <img src="{$resourcesRoot}/images/catIcon.gif" width="13" height="13" alt="folder" class="folderForAliasTree"/>
            <xsl:value-of select="summary"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:variable name="virtualPath"><xsl:for-each select="ancestor-or-self::calendar/name">/<xsl:value-of select="."/></xsl:for-each></xsl:variable>
            <xsl:variable name="displayName" select="summary"/>
            <input type="checkbox" name="alias" id="{generate-id(path)}" onclick="toggleBedeworkXProperty('X-BEDEWORK-SUBMIT-ALIAS','{$displayName}','{$virtualPath}',this.checked)">
              <xsl:attribute name="value"><xsl:value-of select="$virtualPath"/></xsl:attribute>
              <xsl:if test="$virtualPath = /bedework/formElements/form/xproperties//X-BEDEWORK-SUBMIT-ALIAS/values/text"><xsl:attribute name="checked"><xsl:value-of select="checked"/></xsl:attribute></xsl:if>
            </input>
            <label for="{generate-id(path)}">
                <xsl:choose>
                  <xsl:when test="$virtualPath = /bedework/formElements/form/xproperties//X-BEDEWORK-SUBMIT-ALIAS/values/text">
                    <strong><xsl:value-of select="summary"/></strong>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="summary"/>
                  </xsl:otherwise>
                </xsl:choose>
            </label>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>

      <!-- Return topical areas and all underlying calendars.
           Check for topical areas only if the subscription is owned by the calendar suite:
           If the subscription points out to a calendar or folder in another tree,
           return the branch regardless of the topical area setting.  -->
      <xsl:if test="calendar[(isSubscription = 'true' or calType = '0') and ((isTopicalArea = 'true' and  starts-with(path,/bedework/currentCalSuite/resourcesHome)) or not(starts-with(path,/bedework/currentCalSuite/resourcesHome)))]">
        <ul>
          <xsl:apply-templates select="calendar[(isSubscription = 'true' or calType = '0') and ((isTopicalArea = 'true' and  starts-with(path,/bedework/currentCalSuite/resourcesHome)) or not(starts-with(path,/bedework/currentCalSuite/resourcesHome)))]" mode="showEventFormAliases"/>
        </ul>
      </xsl:if>
    </li>
  </xsl:template>

  <xsl:template match="val" mode="weekMonthYearNumbers">
    <xsl:if test="position() != 1 and position() = last()"><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-WMYN-Next"/><xsl:text> </xsl:text></xsl:if>
    <xsl:value-of select="."/><xsl:choose>
      <xsl:when test="substring(., string-length(.)-1, 2) = '11' or
                      substring(., string-length(.)-1, 2) = '12' or
                      substring(., string-length(.)-1, 2) = '13'">th</xsl:when>
      <xsl:when test="substring(., string-length(.), 1) = '1'">st</xsl:when>
      <xsl:when test="substring(., string-length(.), 1) = '2'">nd</xsl:when>
      <xsl:when test="substring(., string-length(.), 1) = '3'">rd</xsl:when>
      <xsl:otherwise>th</xsl:otherwise>
    </xsl:choose>
    <xsl:if test="position() != last()">, </xsl:if>
  </xsl:template>
  <xsl:template name="buildCheckboxList">
    <xsl:param name="current"/>
    <xsl:param name="end"/>
    <xsl:param name="name"/>
    <xsl:param name="splitter">10</xsl:param>
    <span class="chkBoxListItem">
      <input type="checkbox">
        <xsl:attribute name="name"><xsl:value-of select="$name"/></xsl:attribute>
        <xsl:attribute name="value"><xsl:value-of select="$current"/></xsl:attribute>
      </input>
      <xsl:value-of select="$current"/>
    </span>
    <xsl:if test="$current mod $splitter = 0"><br/></xsl:if>
    <xsl:if test="$current = $end"><br/></xsl:if>
    <xsl:if test="$current &lt; $end">
      <xsl:call-template name="buildCheckboxList">
        <xsl:with-param name="current"><xsl:value-of select="$current + 1"/></xsl:with-param>
        <xsl:with-param name="end"><xsl:value-of select="$end"/></xsl:with-param>
        <xsl:with-param name="name"><xsl:value-of select="$name"/></xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="recurrenceDayPosOptions">
    <option value="0"><xsl:copy-of select="$bwStr-RDPO-None"/></option>
    <option value="1"><xsl:copy-of select="$bwStr-RDPO-TheFirst"/></option>
    <option value="2"><xsl:copy-of select="$bwStr-RDPO-TheSecond"/></option>
    <option value="3"><xsl:copy-of select="$bwStr-RDPO-TheThird"/></option>
    <option value="4"><xsl:copy-of select="$bwStr-RDPO-TheFourth"/></option>
    <option value="5"><xsl:copy-of select="$bwStr-RDPO-TheFifth"/></option>
    <option value="-1"><xsl:copy-of select="$bwStr-RDPO-TheLast"/></option>
    <option value=""><xsl:copy-of select="$bwStr-RDPO-Every"/></option>
  </xsl:template>

  <xsl:template name="buildRecurFields">
    <xsl:param name="current"/>
    <xsl:param name="total"/>
    <xsl:param name="name"/>
    <div class="invisible">
      <xsl:attribute name="id"><xsl:value-of select="$name"/>RecurFields<xsl:value-of select="$current"/></xsl:attribute>
      <xsl:copy-of select="$bwStr-BReF-And"/>
      <select width="12em">
        <xsl:attribute name="name">by<xsl:value-of select="$name"/>posPos<xsl:value-of select="$current"/></xsl:attribute>
        <xsl:if test="$current != $total">
          <xsl:attribute name="onchange">changeClass('<xsl:value-of select="$name"/>RecurFields<xsl:value-of select="$current+1"/>','shown')</xsl:attribute>
        </xsl:if>
        <xsl:call-template name="recurrenceDayPosOptions"/>
      </select>
      <xsl:call-template name="byDayChkBoxList"/>
    </div>
    <xsl:if test="$current &lt; $total">
      <xsl:call-template name="buildRecurFields">
        <xsl:with-param name="current"><xsl:value-of select="$current+1"/></xsl:with-param>
        <xsl:with-param name="total"><xsl:value-of select="$total"/></xsl:with-param>
        <xsl:with-param name="name"><xsl:value-of select="$name"/></xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="buildNumberOptions">
    <xsl:param name="current"/>
    <xsl:param name="total"/>
    <option value="{$current}"><xsl:value-of select="$current"/></option>
    <xsl:if test="$current &lt; $total">
      <xsl:call-template name="buildNumberOptions">
        <xsl:with-param name="current"><xsl:value-of select="$current+1"/></xsl:with-param>
        <xsl:with-param name="total"><xsl:value-of select="$total"/></xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>