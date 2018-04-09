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

  <!--++++++++++++++++++ Manage Events List ++++++++++++++++++++-->
  <xsl:template name="eventList">
    <xsl:variable name="today"><xsl:value-of select="substring(/bedework/now/date,1,4)"/>-<xsl:value-of select="substring(/bedework/now/date,5,2)"/>-<xsl:value-of select="substring(/bedework/now/date,7,2)"/></xsl:variable>
    <xsl:variable name="calendarPath">
      <xsl:choose>
        <xsl:when test="/bedework/appvar[key='calendarPath']/value">
          <xsl:value-of select="/bedework/appvar[key='calendarPath']/value"/>
        </xsl:when>
        <xsl:otherwise>/public/cals/MainCal</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="catFilter">
      <xsl:choose>
        <xsl:when test="/bedework/appvar[key='catFilter']/value">
          <xsl:value-of select="/bedework/appvar[key='catFilter']/value"/>
        </xsl:when>
        <xsl:otherwise></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="sort">
      <xsl:choose>
        <xsl:when test="/bedework/appvar[key='sort']/value">
          <xsl:value-of select="/bedework/appvar[key='sort']/value"/>
        </xsl:when>
        <xsl:otherwise>dtstart.utc:asc</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <h2 class="leftTitle"><xsl:copy-of select="$bwStr-EvLs-ManageEvents"/></h2>
    <button id="bwEventListAddEventButton" onclick="javascript:location.replace('{$event-initAddEvent}')"><xsl:value-of select="$bwStr-EvLs-PageTitle"/></button>

    <div id="bwEventListControls">
      <xsl:call-template name="eventListControls">
        <xsl:with-param name="nextAction" select="$event-nextUpdateList"/>
        <xsl:with-param name="sort" select="$sort"/>
      </xsl:call-template>

      <form name="bwManageEventListControls"
            id="bwManageEventListControls"
            method="get"
            action="{$event-initUpdateEvent}">

        <input type="hidden" name="listMode" value="true"/>
        <!-- following two params set by JavaScript -->
        <input type="hidden" name="fexpr" value=""/>
        <input type="hidden" name="setappvar" id="appvar" value=""/>

        <div class="container-nowrap">
          <label for="bwListWidgetStartDate"><xsl:copy-of select="$bwStr-EvLs-StartDate"/></label>
          <input id="bwListWidgetStartDate" type="text" class="noFocus" name="start" size="10"
                 onchange="setListDate(this.form,this.value);"/>
          <input id="bwListWidgetToday" type="submit" value="{$bwStr-EvLs-Today}"
                 onclick="setListDateToday('{$today}',this.form);"/>
        </div>

        <div class="container-nowrap">
          <label for="colPathSetter"><xsl:copy-of select="$bwStr-EvLs-Calendar"/></label>
          <select name="colPath"
                  onchange="setEventList(this.form,'calPath');"
                  id="colPathSetter">
            <xsl:for-each select="/bedework/calendars/calendar">
              <option>
                <xsl:attribute name="value"><xsl:value-of select="path"/></xsl:attribute>
                <xsl:if test="$calendarPath = path">
                  <xsl:attribute name="selected">selected</xsl:attribute>
                </xsl:if>
                <xsl:value-of select="path"/>
              </option>
            </xsl:for-each>
          </select>
        </div>

        <div class="container-nowrap">
          <label for="listEventsCatFilter"><xsl:copy-of select="$bwStr-EvLs-FilterBy"/></label>
          <select name="catFilter"
                  onchange="setEventList(this.form,'cat');"
                  id="listEventsCatFilter">
            <option value="">
              <xsl:copy-of select="$bwStr-EvLs-SelectCategory"/>
            </option>
            <xsl:for-each select="/bedework/categories/category">
              <xsl:sort order="ascending" select="value"/>
              <xsl:variable name="catPathName"><xsl:value-of select="colPath"/><xsl:value-of select="name"/></xsl:variable>
              <option>
                <xsl:attribute name="value"><xsl:value-of select="$catPathName"/></xsl:attribute>
                <xsl:if test="/bedework/appvar[key='catFilter']/value = $catPathName">
                  <xsl:attribute name="selected">selected</xsl:attribute>
                </xsl:if>
                <xsl:value-of select="value"/>
              </option>
            </xsl:for-each>
          </select>
          <xsl:if test="/bedework/appvar[key='catFilter'] and /bedework/appvar[key='catFilter']/value != ''">
            <input type="button" value="{$bwStr-EvLs-ClearFilter}" onclick="clearCat(this.form);"/>
          </xsl:if>
        </div>

        <div class="container-nowrap">
          <label for="listEventsSort"><xsl:copy-of select="$bwStr-EvLs-SortBy"/></label>
          <select name="sort"
                  onchange="setEventList(this.form,'sort');"
                  id="listEventsSort">
            <option value="dtstart.utc:asc">
              <xsl:copy-of select="$bwStr-EvLs-SortByStart"/>
            </option>
            <option value="created:desc">
              <xsl:if test="/bedework/appvar[key='sort']/value = 'created:desc'">
                <xsl:attribute name="selected">selected</xsl:attribute>
              </xsl:if>
              <xsl:copy-of select="$bwStr-EvLs-SortByCreated"/>
            </option>
            <option value="last_modified:desc">
              <xsl:if test="/bedework/appvar[key='sort']/value = 'last_modified:desc'">
                <xsl:attribute name="selected">selected</xsl:attribute>
              </xsl:if>
              <xsl:copy-of select="$bwStr-EvLs-SortByModified"/>
            </option>
          </select>
        </div>

        <xsl:if test="/bedework/userInfo/superUser = 'true'">
          <div class="container-nowrap">
            <input type="checkbox" name="sg" id="listEventsAllGroups" value="true" onchange="setEventList(this.form,'allGroups');">
              <xsl:if test="/bedework/appvar[key='listEventsAllGroups']/value = 'true'">
                <xsl:attribute name="checked">checked</xsl:attribute>
              </xsl:if>
            </input>
            <label for="listEventsAllGroups"><xsl:copy-of select="$bwStr-Srch-ScopeAll"/></label>
          </div>
        </xsl:if>

      </form>
    </div>
    <xsl:call-template name="eventListCommon"/>

    <xsl:call-template name="eventListControls">
      <xsl:with-param name="nextAction" select="$event-nextUpdateList"/>
      <xsl:with-param name="sort" select="$sort"/>
      <xsl:with-param name="bottom">true</xsl:with-param>
    </xsl:call-template>

    <div id="bwPublicEventLinkBox" class="popup invisible">
      <h2><xsl:copy-of select="$bwStr-EvLs-PublicUrl"/></h2>
      <div id="bwPublicEventLink"><xsl:text> </xsl:text></div>
      <div class="container">
        <input id="bwPublicEventLinkInput" value=""/>
      </div>
    </div>

  </xsl:template>

  <xsl:template name="buildListDays">
    <xsl:param name="index">1</xsl:param>
    <xsl:variable name="max" select="/bedework/maxdays"/>
    <xsl:if test="number($index) &lt; number($max)">
      <option value="{$index}">
        <xsl:if test="$index = $curListDays"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
        <xsl:value-of select="$index"/>
      </option>
      <xsl:call-template name="buildListDays">
        <xsl:with-param name="index"><xsl:value-of select="number($index)+1"/></xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>