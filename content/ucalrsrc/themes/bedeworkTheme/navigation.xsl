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

  <xsl:template name="tabs">
    <xsl:variable name="navAction">
      <xsl:choose>
        <xsl:when test="/bedework/page='attendees'"><xsl:value-of select="$event-attendeesForEvent"/></xsl:when>
        <xsl:when test="/bedework/page='freeBusy'"><xsl:value-of select="$freeBusy-fetch"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="$setViewPeriod"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <div id="bwTabs">
      <div id="bwUserInfo">
        <xsl:copy-of select="$bwStr-Tabs-LoggedInAs"/><xsl:text> </xsl:text>
        <xsl:text> </xsl:text>
        <strong><xsl:value-of select="/bedework/userid"/></strong>
        <xsl:text> </xsl:text>
        <span class="logout"><a href="{$setup}&amp;logout=true"><xsl:copy-of select="$bwStr-Tabs-Logout"/></a></span>
      </div>
      <ul>
        <li>
          <xsl:if test="/bedework/page='eventscalendar' and /bedework/periodname='Day'">
            <xsl:attribute name="class">selected</xsl:attribute>
          </xsl:if>
          <a href="{$setViewPeriod}&amp;viewType=dayView&amp;date={$curdate}"><xsl:copy-of select="$bwStr-Tabs-Day"/></a>
        </li>
        <li>
          <xsl:if test="/bedework/page='eventscalendar' and /bedework/periodname='Week' or /bedework/periodname=''">
            <xsl:attribute name="class">selected</xsl:attribute>
          </xsl:if>
          <a href="{$setViewPeriod}&amp;viewType=weekView&amp;date={$curdate}"><xsl:copy-of select="$bwStr-Tabs-Week"/></a>
        </li>
        <li>
          <xsl:if test="/bedework/page='eventscalendar' and /bedework/periodname='Month'">
            <xsl:attribute name="class">selected</xsl:attribute>
          </xsl:if><a href="{$setViewPeriod}&amp;viewType=monthView&amp;date={$curdate}"><xsl:copy-of select="$bwStr-Tabs-Month"/></a>
        </li>
        <li>
          <xsl:if test="/bedework/page='eventscalendar' and /bedework/periodname='Year'">
            <xsl:attribute name="class">selected</xsl:attribute>
          </xsl:if><a href="{$setViewPeriod}&amp;viewType=yearView&amp;date={$curdate}"><xsl:copy-of select="$bwStr-Tabs-Year"/></a>
        </li>
        <li>
          <xsl:if test="/bedework/page='eventList'">
            <xsl:attribute name="class">selected</xsl:attribute>
          </xsl:if>
          <xsl:variable name="usersRootCal" select="/bedework/myCalendars/calendars/calendar/path"/>
          <a href="{$listEvents}&amp;listMode=true&amp;fexpr=(colPath=%22{$usersRootCal}%22 and (entity_type=%22event%22|entity_type=%22todo%22))&amp;sort=dtstart.utc:asc"><xsl:copy-of select="$bwStr-Tabs-Upcoming"/></a>
        </li>
        <xsl:if test="$useVpoll = 'true'">
          <li>
            <xsl:if test="/bedework/page='managePolls'">
              <xsl:attribute name="class">selected</xsl:attribute>
            </xsl:if><a href="{$vpoll-initmanage}">POLLS</a>
          </li>
        </xsl:if>
      </ul>
    </div>
  </xsl:template>

  <xsl:template name="navigation">
    <xsl:variable name="navAction">
      <xsl:choose>
        <xsl:when test="/bedework/page='attendees'"><xsl:value-of select="$event-attendeesForEvent"/></xsl:when>
        <xsl:when test="/bedework/page='freeBusy'"><xsl:value-of select="$freeBusy-fetch"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="$setViewPeriod"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <table border="0" cellpadding="0" cellspacing="0" id="navigationBarTable">
      <tr>
        <td class="leftCell">
          <div id="timezoneDisplay">
            <xsl:copy-of select="$bwStr-Navi-Timezone"/><xsl:text> </xsl:text>
            <xsl:value-of select="/bedework/now/defaultTzid"/>
          </div>
          <a href="{$navAction}&amp;date={$prevdate}"><img src="{$resourcesRoot}/images/std-arrow-left.gif" alt="previous" width="13" height="16" class="prevImg" border="0"/></a>
          <a href="{$navAction}&amp;date={$nextdate}"><img src="{$resourcesRoot}/images/std-arrow-right.gif" alt="next" width="13" height="16" class="nextImg" border="0"/></a>
          <xsl:choose>
            <xsl:when test="/bedework/periodname='Year'">
              <xsl:value-of select="substring(/bedework/firstday/date,1,4)"/>
            </xsl:when>
            <xsl:when test="/bedework/periodname='Month'">
              <xsl:value-of select="/bedework/firstday/monthname"/>, <xsl:value-of select="substring(/bedework/firstday/date,1,4)"/>
            </xsl:when>
            <xsl:when test="/bedework/periodname='Week'">
              <xsl:copy-of select="$bwStr-Navi-WeekOf"/><xsl:text> </xsl:text><xsl:value-of select="substring-after(/bedework/firstday/longdate,', ')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="/bedework/firstday/longdate"/>
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td class="todayButton">
          <button type="button" onclick="window.location='{$navAction}&amp;viewType=todayView&amp;date={$nowdate}'">
            <xsl:value-of select="$bwStr-Navi-Today"/>
          </button>
        </td>
        <td align="right" class="gotoForm">
          <form name="calForm" method="post" action="{$navAction}">
            <table border="0" cellpadding="0" cellspacing="0">
              <tr>
                <xsl:if test="/bedework/periodname!='Year'">
                  <td>
                    <select name="viewStartDate.month">
                      <xsl:for-each select="/bedework/monthvalues/val">
                        <xsl:variable name="temp" select="."/>
                        <xsl:variable name="pos" select="position()"/>
                        <xsl:choose>
                          <xsl:when test="/bedework/monthvalues[start=$temp]">
                            <option value="{$temp}" selected="selected">
                              <xsl:value-of select="/bedework/monthlabels/val[position()=$pos]"/>
                            </option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="{$temp}">
                              <xsl:value-of select="/bedework/monthlabels/val[position()=$pos]"/>
                            </option>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:for-each>
                    </select>
                  </td>
                  <xsl:if test="/bedework/periodname!='Month'">
                    <td>
                      <select name="viewStartDate.day">
                        <xsl:for-each select="/bedework/dayvalues/val">
                          <xsl:variable name="temp" select="."/>
                          <xsl:variable name="pos" select="position()"/>
                          <xsl:choose>
                            <xsl:when test="/bedework/dayvalues[start=$temp]">
                              <option value="{$temp}" selected="selected">
                                <xsl:value-of select="/bedework/daylabels/val[position()=$pos]"/>
                              </option>
                            </xsl:when>
                            <xsl:otherwise>
                              <option value="{$temp}">
                                <xsl:value-of select="/bedework/daylabels/val[position()=$pos]"/>
                              </option>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:for-each>
                      </select>
                    </td>
                  </xsl:if>
                </xsl:if>
                <td>
                  <xsl:variable name="temp" select="/bedework/yearvalues/start"/>
                  <input type="text" name="viewStartDate.year" maxlength="4" size="4" value="{$temp}"/>
                </td>
                <td>
                  <input name="submit" type="submit" value="{$bwStr-Navi-Go}"/>
                </td>
              </tr>
            </table>
          </form>
        </td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template name="utilBar">
    <h3 id="bwEventColTitle"><xsl:copy-of select="$bwStr-Util-EventsTitle"/></h3>
    <table width="100%" border="0" cellpadding="0" cellspacing="0" id="utilBarTable">
      <tr>
        <td class="leftCell">
          <xsl:if test="$publicOnly = 'false'">
            <xsl:if test="/bedework/page != 'addEvent' or /bedework/page='editEvent'">
              <input type="button" value="{$bwStr-Util-Add}" id="bwAddButton"/>
              <xsl:call-template name="actionIcons">
                <xsl:with-param name="actionIconsId">bwActionIcons-0</xsl:with-param>
                <xsl:with-param name="startDate">
                  <xsl:choose> <!-- why are we doing this choose? -->
                    <xsl:when test="/bedework/periodname = 'Day'"><xsl:value-of select="/bedework/firstday/date"/></xsl:when>
                    <xsl:otherwise><xsl:value-of select="/bedework/now/date"/></xsl:otherwise>
                  </xsl:choose>
                </xsl:with-param>
                <xsl:with-param name="startTime"><xsl:value-of select="/bedework/now/twodigithour24"/>0000</xsl:with-param>
              </xsl:call-template>
            </xsl:if>
          </xsl:if>
        </td>
        <td class="rightCell">

          <!-- search -->
          <xsl:if test="/bedework/page!='searchResult'">
            <form name="searchForm" method="post" action="{$search}">
              <xsl:copy-of select="$bwStr-Util-Search"/>:
              <input type="text" name="query" size="15">
                <xsl:attribute name="value"><xsl:value-of select="/bedework/searchResults/query"/></xsl:attribute>
              </input>
              <input type="submit" name="submit" value="{$bwStr-Util-Go}"/>
            </form>
          </xsl:if>

          <!-- show free / busy -->
          <!-- DEPRECATED as of Bedework 3.7: the feature is left in place for backwards compatibility -->
          <!--
           <xsl:choose>
             <xsl:when test="/bedework/periodname!='Year'">
               <xsl:choose>
                 <xsl:when test="/bedework/page='freeBusy'">
                   <a class="utilButton" href="{$setViewPeriod}&amp;date={$curdate}" title="{$bwStr-Util-ShowEvents}">
                     <xsl:copy-of select="$bwStr-Util-Events"/>
                   </a>
                 </xsl:when>
                 <xsl:otherwise>
                   <a class="utilButton" href="{$freeBusy-fetch}&amp;date={$curdate}" title="{$bwStr-Util-ShowFreebusy}">
                     <xsl:copy-of select="$bwStr-Util-Freebusy"/>
                   </a>
                 </xsl:otherwise>
               </xsl:choose>
             </xsl:when>
             <xsl:otherwise>
               <span class="utilButtonOff"><xsl:copy-of select="$bwStr-Util-Freebusy"/></span>
             </xsl:otherwise>
           </xsl:choose>
           -->

          <!-- toggle list / calendar view -->
          <xsl:choose>
            <xsl:when test="/bedework/periodname='Day' or /bedework/page='eventList'">
              <span class="utilButtonOff"><xsl:copy-of select="$bwStr-Util-List"/></span>
            </xsl:when>
            <xsl:when test="/bedework/periodname='Year'">
              <span class="utilButtonOff"><xsl:copy-of select="$bwStr-Util-Cal"/></span>
            </xsl:when>
            <xsl:when test="/bedework/periodname='Month'">
              <xsl:choose>
                <xsl:when test="/bedework/appvar[key='monthViewMode']/value='list'">
                  <a class="utilButton" href="{$setup}&amp;setappvar=monthViewMode(cal)" title="{$bwStr-Util-ToggleListCalView}">
                    <xsl:copy-of select="$bwStr-Util-Cal"/>
                  </a>
                </xsl:when>
                <xsl:otherwise>
                  <a class="utilButton" href="{$setup}&amp;setappvar=monthViewMode(list)" title="{$bwStr-Util-ToggleListCalView}">
                    <xsl:copy-of select="$bwStr-Util-List"/>
                  </a>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="/bedework/appvar[key='weekViewMode']/value='list'">
                  <a class="utilButton" href="{$setup}&amp;setappvar=weekViewMode(cal)" title="{$bwStr-Util-ToggleListCalView}">
                    <xsl:copy-of select="$bwStr-Util-Cal"/>
                  </a>
                </xsl:when>
                <xsl:otherwise>
                  <a class="utilButton" href="{$setup}&amp;setappvar=weekViewMode(list)" title="{$bwStr-Util-ToggleListCalView}">
                    <xsl:copy-of select="$bwStr-Util-List"/>
                  </a>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>

          <!-- summary / detailed mode toggle -->
          <xsl:choose>
            <xsl:when test="/bedework/page = 'eventList'">
              <xsl:choose>
                <xsl:when test="/bedework/appvar[key='listEventsSummaryMode']/value='details'">
                  <a class="utilButton" href="{$listEvents}&amp;setappvar=listEventsSummaryMode(summary)" title="{$bwStr-Util-ToggleSummDetView}">
                    <xsl:copy-of select="$bwStr-Util-Summary"/>
                  </a>
                </xsl:when>
                <xsl:otherwise>
                  <a class="utilButton" href="{$listEvents}&amp;setappvar=listEventsSummaryMode(details)" title="{$bwStr-Util-ToggleSummDetView}">
                    <xsl:copy-of select="$bwStr-Util-Details"/>
                  </a>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:when test="/bedework/periodname='Year' or
                              (/bedework/periodname='Month' and
                              (/bedework/appvar[key='monthViewMode']/value='cal' or
                               not(/bedework/appvar[key='monthViewMode']))) or
                              (/bedework/periodname='Week' and
                              (/bedework/appvar[key='weekViewMode']/value='cal' or
                               not(/bedework/appvar[key='weekViewMode'])))">
              <xsl:choose>
                <xsl:when test="/bedework/appvar[key='summaryMode']/value='details'">
                  <span class="utilButtonOff"><xsl:copy-of select="$bwStr-Util-Summary"/></span>
                </xsl:when>
                <xsl:otherwise>
                  <span class="utilButtonOff"><xsl:copy-of select="$bwStr-Util-Details"/></span>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="/bedework/appvar[key='summaryMode']/value='details'">
                  <a class="utilButton" href="{$setup}&amp;setappvar=summaryMode(summary)" title="{$bwStr-Util-ToggleSummDetView}">
                    <xsl:copy-of select="$bwStr-Util-Summary"/>
                  </a>
                </xsl:when>
                <xsl:otherwise>
                  <a class="utilButton" href="{$setup}&amp;setappvar=summaryMode(details)" title="{$bwStr-Util-ToggleSummDetView}">
                    <xsl:copy-of select="$bwStr-Util-Details"/>
                  </a>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>

          <!-- refresh button -->
          <!-- deprecate? -->
          <!-- <a href="{$setup}"><img src="{$resourcesRoot}/images/std-button-refresh.gif" width="70" height="21" border="0" alt="refresh view"/></a> -->
        </td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template name="actionIcons">
    <xsl:param name="startDate"/>
    <xsl:param name="startTime"/>
    <xsl:param name="actionIconsId"/>
    <xsl:variable name="dateTime">
      <xsl:choose>
        <xsl:when test="$startTime != ''"><xsl:value-of select="$startDate"/>T<xsl:value-of select="$startTime"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="$startDate"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <br/>
    <div id="{$actionIconsId}" class="bwActionIcons">
      <a href="{$initEvent}&amp;entityType=event&amp;startdate={$dateTime}" title="{$bwStr-Actn-AddEvent}" onclick="javascript:changeClass('{$actionIconsId}','invisible')">
        <img src="{$resourcesRoot}/images/add2mycal-icon-small.gif" width="12" height="16" border="0" alt="add event"/>
        <xsl:text> </xsl:text>
        <xsl:copy-of select="$bwStr-Actn-AddEvent"/>
      </a>
      <!--
       <a href="{$event-initMeeting}&amp;entityType=event&amp;schedule=request&amp;startdate={$dateTime}" title="schedule a meeting" onclick="javascript:changeClass('{$actionIconsId}','invisible')">
          <img src="{$resourcesRoot}/images/std-icalMeeting-icon-small.gif" width="12" height="16" border="0" alt="schedule meeting"/>
          <xsl:text> </xsl:text>
          <xsl:copy-of select="$bwStr-Actn-ScheduleMeeting"/>
       </a>
       -->
      <a href="{$initEvent}&amp;entityType=task&amp;startdate={$dateTime}" title="{$bwStr-Actn-AddTask}" onclick="javascript:changeClass('{$actionIconsId}','invisible')">
        <img src="{$resourcesRoot}/images/std-icalTask-icon-small.gif" width="12" height="16" border="0" alt="add task"/>
        <xsl:text> </xsl:text>
        <xsl:copy-of select="$bwStr-Actn-AddTask"/>
      </a>
      <!--
       <a href="{$event-initMeeting}&amp;entityType=task&amp;schedule=request&amp;startdate={$dateTime}" title="{$bwStr-Actn-ScheduleTask}" onclick="javascript:changeClass('{$actionIconsId}','invisible')">
          <img src="{$resourcesRoot}/images/std-icalSchTask-icon-small.gif" width="12" height="16" border="0" alt="schedule task"/>
          <xsl:text> </xsl:text>
          <xsl:copy-of select="$bwStr-Actn-ScheduleTask"/>
       </a>
       <a href="{$initUpload}" title="{$bwStr-Actn-UploadEvent}" onclick="javascript:changeClass('{$actionIconsId}','invisible')">
          <img src="{$resourcesRoot}/images/std-icalUpload-icon-small.gif" width="12" height="16" border="0" alt="upload event"/>
          <xsl:text> </xsl:text>
          <xsl:copy-of select="$bwStr-Actn-Upload"/>
       </a>
       -->
    </div>
  </xsl:template>


</xsl:stylesheet>