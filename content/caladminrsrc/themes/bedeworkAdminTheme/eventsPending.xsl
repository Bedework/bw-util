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

  <!--+++++++++++++++ Pending Events Tab ++++++++++++++++++++-->
  <xsl:template name="tabPendingEvents">
    <h2><xsl:copy-of select="$bwStr-TaPE-PendingEvents"/></h2>
    <p><xsl:copy-of select="$bwStr-TaPE-EventsAwaitingModeration"/></p>

    <xsl:variable name="today"><xsl:value-of select="substring(/bedework/now/date,1,4)"/>-<xsl:value-of select="substring(/bedework/now/date,5,2)"/>-<xsl:value-of select="substring(/bedework/now/date,7,2)"/></xsl:variable>

    <xsl:variable name="sort">
      <xsl:choose>
        <xsl:when test="/bedework/appvar[key='sort']/value">
          <xsl:value-of select="/bedework/appvar[key='sort']/value"/>
        </xsl:when>
        <xsl:otherwise>dtstart.utc:asc</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <div id="bwEventListControls">
      <xsl:call-template name="eventListControls">
        <xsl:with-param name="nextAction" select="$nextPendingTab"/>
        <xsl:with-param name="sort" select="$sort"/>
      </xsl:call-template>

      <form name="bwManageEventListControls"
            id="bwManageEventListControls"
            method="post"
            action="{$initPendingTab}">
        <xsl:variable name="calSuite" select="/bedework/calSuiteName"/>
        <xsl:variable name="calSuiteLimit">
          <xsl:choose>
            <xsl:when test="/bedework/userInfo/superUser = 'true'"></xsl:when>
            <xsl:otherwise> and calSuite='<xsl:value-of select="$calSuite"/>'</xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="fexpr">(colPath='<xsl:value-of select="$submissionsRootUnencoded"/>' and (entity_type="event"|entity_type="todo")<xsl:value-of select="$calSuiteLimit"/>)</xsl:variable>

        <input type="hidden" name="listMode" value="true"/>
        <input type="hidden" name="sg" value="true"/>
        <input type="hidden" name="fexpr" value="{$fexpr}"/>
        <input type="hidden" name="setappvar" id="appvar" value=""/>
        <input type="hidden" name="catFilter" value=""/>

        <div class="container-nowrap">
          <label for="bwListWidgetStartDate"><xsl:copy-of select="$bwStr-EvLs-StartDate"/></label>
          <input id="bwListWidgetStartDate" type="text" class="noFocus" name="start" size="10"
                 onchange="setListDate(this.form,this.value);"/>
          <input id="bwListWidgetToday" type="submit" value="{$bwStr-EvLs-Today}"
                 onclick="setListDateToday('{$today}',this.form);"/>
        </div>
        <div class="container-nowrap">
          <label for="listEventsSort"><xsl:copy-of select="$bwStr-EvLs-SortBy"/></label>
          <select name="sort"
                  onchange="setListSort(this.form,this.value);"
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

      </form>
    </div>

    <xsl:call-template name="eventListCommon">
      <xsl:with-param name="pending">true</xsl:with-param>
    </xsl:call-template>

    <xsl:call-template name="eventListControls">
      <xsl:with-param name="nextAction"><xsl:value-of select="$nextPendingTab"/>&amp;sg=true</xsl:with-param>
      <xsl:with-param name="sort" select="$sort"/>
      <xsl:with-param name="bottom">true</xsl:with-param>
    </xsl:call-template>

  </xsl:template>

</xsl:stylesheet>