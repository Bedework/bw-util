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

  <!--++++ SEARCH ++++-->
  <!-- templates:
         - searchResult
         - upperSearchForm
         - searchResultPageNav
   -->
  <xsl:template name="searchResult">
    <xsl:variable name="today"><xsl:value-of select="substring(/bedework/now/date,1,4)"/>-<xsl:value-of select="substring(/bedework/now/date,5,2)"/>-<xsl:value-of select="substring(/bedework/now/date,7,2)"/></xsl:variable>

    <h2 class="bwStatusConfirmed"><xsl:copy-of select="$bwStr-Srch-SearchResult"/></h2>
    <div id="searchResultSize">
      <strong><xsl:value-of select="/bedework/searchResults/resultSize"/></strong>
      <xsl:text> </xsl:text>
      <xsl:copy-of select="$bwStr-Srch-ResultReturnedFor"/><xsl:text> </xsl:text>
      <strong><em><xsl:value-of select="substring-before(substring-after(/bedework/appvar[key='bwQuery']/value,'|'),'|')"/></em></strong>
    </div>

    <div class="bwEventListNav">
      <button class="searchPrevious" onclick="location.href='{$search-next}&amp;prev=prev'"><span class="searchArrow searchArrowLeft">◄</span> <xsl:copy-of select="$bwStr-Srch-PrevFull"/></button>
      <button class="searchNext" onclick="location.href='{$search-next}&amp;next=next'"><xsl:copy-of select="$bwStr-Srch-NextFull"/> <span class="searchArrow searchArrowRight">►</span></button>
    </div>

    <form name="bwSearchEventListControls" id="bwSearchEventListControls" method="post" action="{$search}" onsubmit="return setBwQuery(this,this.start.value);">
      <label for="bwSearchWidgetStartDate"><xsl:copy-of select="$bwStr-EvLs-StartDate"/></label>
      <input id="bwSearchWidgetStartDate" type="text" class="noFocus" name="start" size="10" onchange="setBwQuery(this.form,this.value,true);"/>
      <input id="bwSearchWidgetToday" type="button" value="{$bwStr-EvLs-Today}" onclick="setBwQuery(this.form,'today',true);"/>

      <xsl:copy-of select="$bwStr-Srch-Search"/>
      <xsl:text> </xsl:text>
      <input type="text" name="query" size="27">
        <xsl:attribute name="value"><xsl:value-of select="substring-before(substring-after(/bedework/appvar[key='bwQuery']/value,'|'),'|')"/></xsl:attribute>
      </input>
      <input type="submit" value="{$bwStr-Srch-Go}"/>


      <input type="radio" name="fexpr" id="searchScopeSP-local">
        <xsl:attribute name="value">(creator="/principals/users/<xsl:value-of select="/bedework/userInfo/user"/>" and colPath="/public/cals/MainCal" and (entity_type="event"|entity_type="todo"))</xsl:attribute>
        <xsl:if test="not(/bedework/appvar[key='bwQuery']) or substring-after(substring-after(/bedework/appvar[key='bwQuery']/value,'|'),'|') = 'local'">
          <xsl:attribute name="checked">checked</xsl:attribute>
        </xsl:if>
      </input>
      <label for="searchScopeSP-local"><xsl:value-of select="$bwStr-Srch-ScopeLocal"/></label>

      <input type="radio" name="fexpr" id="searchScopeSP-mine">
        <xsl:attribute name="value">(colPath="/public/cals/MainCal" and (entity_type="event"|entity_type="todo"))</xsl:attribute>
        <xsl:if test="substring-after(substring-after(/bedework/appvar[key='bwQuery']/value,'|'),'|') = 'mine'">
          <xsl:attribute name="checked">checked</xsl:attribute>
        </xsl:if>
      </input>
      <label for="searchScopeSP-mine"><xsl:value-of select="$bwStr-Srch-ScopeMine"/></label>

      <input type="radio" name="fexpr" id="searchScopeSP-all">
        <xsl:attribute name="value">(colPath="/public/cals/MainCal" and (entity_type="event"|entity_type="todo"))</xsl:attribute>
        <xsl:if test="substring-after(substring-after(/bedework/appvar[key='bwQuery']/value,'|'),'|') = 'all'">
          <xsl:attribute name="checked">checked</xsl:attribute>
        </xsl:if>
      </input>
      <label for="searchScopeSP-all"><xsl:value-of select="$bwStr-Srch-ScopeAll"/></label>


      <input type="hidden" name="setappvar" id="curQueryHolder" value="bwQuery()"/>
      <input type="hidden" name="sort" value="dtstart.utc:asc"/>
      <input type="hidden" name="count" value="{$searchResultSize}"/>
      <input type="hidden" name="ignoreCreator" value="true"/>
    </form>

    <table id="searchTable">
      <xsl:choose>
        <xsl:when test="/bedework/searchResults/searchResult">
          <tr class="fieldNames">
            <th>
              <xsl:copy-of select="$bwStr-Srch-Title"/>
            </th>
            <th>
              <xsl:copy-of select="$bwStr-Srch-DateAndTime"/>
            </th>
            <!-- <td>  XXX would like to restore these
              topical areas
            </td>-->
            <th>
              <xsl:copy-of select="$bwStr-Srch-Location"/>
            </th>
          </tr>
          <xsl:for-each select="/bedework/searchResults/searchResult">
            <xsl:variable name="calPath" select="event/calendar/encodedPath"/>
            <xsl:variable name="guid" select="event/guid"/>
            <xsl:variable name="recurrenceId" select="event/recurrenceId"/>
            <tr>
              <td>
                <a href="{$event-fetchForDisplay}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
                  <xsl:value-of select="event/summary"/>
                  <xsl:if test="event/summary = ''"><em><xsl:copy-of select="$bwStr-Srch-NoTitle"/></em></xsl:if>
                </a>
              </td>
              <td>
                <xsl:value-of select="event/start/longdate"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="event/start/time"/>
                <xsl:choose>
                  <xsl:when test="event/start/longdate != event/end/longdate">
                    - <xsl:value-of select="event/end/longdate"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="event/end/time"/>
                  </xsl:when>
                  <xsl:when test="event/start/time != event/end/time">
                    - <xsl:value-of select="event/end/time"/>
                  </xsl:when>
                </xsl:choose>
              </td>
              <!--
              <td>
                <xsl:for-each select="xproperties/X-BEDEWORK-ALIAS">
                  <xsl:call-template name="substring-afterLastInstanceOf">
                    <xsl:with-param name="string" select="values/text"/>
                    <xsl:with-param name="char">/</xsl:with-param>
                  </xsl:call-template><br/>
                </xsl:for-each>
              </td>-->
              <td>
                <xsl:value-of select="event/location/address"/>
              </td>
            </tr>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <tr>
            <td>
              <xsl:choose>
                <xsl:when test="/bedework/searchResults/resultSize = '0'"><xsl:copy-of select="$bwStr-Srch-NoResults"/></xsl:when>
                <xsl:otherwise><xsl:copy-of select="$bwStr-Srch-NoMoreResults"/></xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
        </xsl:otherwise>
      </xsl:choose>
    </table>
    <div class="bwEventListNav">
      <button class="searchPrevious" onclick="location.href='{$search-next}&amp;prev=prev'"><span class="searchArrow searchArrowLeft">&#9668;</span> <xsl:copy-of select="$bwStr-Srch-PrevFull"/></button>
      <button class="searchNext" onclick="location.href='{$search-next}&amp;next=next'"><xsl:copy-of select="$bwStr-Srch-NextFull"/> <span class="searchArrow searchArrowRight">&#9658;</span></button>
    </div>
  </xsl:template>

  <xsl:template name="upperSearchForm">
    <xsl:param name="toggleLimits">false</xsl:param>
    <div id="searchFilter">
      <form name="searchForm" method="post" action="{$search}" onsubmit="return setBwQuery(this);">
        <div class="searchQueryBlock">
          <label for="query">
            <xsl:copy-of select="$bwStr-Srch-Search"/>
          </label>
          <xsl:text> </xsl:text>
          <input type="text" name="query" id="query" size="27">
            <xsl:attribute name="value"><xsl:value-of select="substring-before(substring-after(/bedework/appvar[key='bwQuery']/value,'|'),'|')"/></xsl:attribute>
            <xsl:attribute name="class">noFocus</xsl:attribute>
          </input>
          <input type="hidden" name="count" value="{$searchResultSize}"/>
          <input type="hidden" name="listMode" value="true"/>
          <input type="hidden" name="start" value="today"/>
          <input type="hidden" name="sort" value="dtstart.utc:asc"/>
          <input type="hidden" name="ignoreCreator" value="true"/>
          <input type="hidden" name="setappvar" value="bwQuery()"/>
          <input type="submit" name="submit" value="{$bwStr-Srch-Go}" class="noFocus"/>
          <div id="searchScope">

            <input type="radio" name="fexpr" id="searchScope-local">
              <xsl:attribute name="value">(creator="/principals/users/<xsl:value-of select="/bedework/userInfo/user"/>" and colPath="/public/cals/MainCal" and (entity_type="event"|entity_type="todo"))</xsl:attribute>
              <xsl:if test="not(/bedework/appvar[key='bwQuery']) or substring-after(substring-after(/bedework/appvar[key='bwQuery']/value,'|'),'|') = 'local'">
                <xsl:attribute name="checked">checked</xsl:attribute>
              </xsl:if>
            </input>
            <label for="searchScope-local"><xsl:value-of select="$bwStr-Srch-ScopeLocal"/></label>

            <input type="radio" name="fexpr" id="searchScope-mine">
              <xsl:attribute name="value">
                <xsl:choose>
                  <xsl:when test="/bedework/userInfo/superUser = 'true'">(colPath="/public/cals/MainCal" and (entity_type="event"|entity_type="todo"))</xsl:when>
                  <xsl:when test="/bedework/userInfo/oneGroup = 'true'">(creator="/principals/users/<xsl:value-of select="/bedework/userInfo/user"/>" and colPath="/public/cals/MainCal" and (entity_type="event"|entity_type="todo"))</xsl:when>
                  <xsl:otherwise>((<xsl:for-each select="/bedework/userInfo/groups/group">creator="<xsl:value-of select="ownerHref"/>"<xsl:if test="position() != last()"> or </xsl:if></xsl:for-each>) and colPath="/public/cals/MainCal" and (entity_type="event"|entity_type="todo"))</xsl:otherwise>
                </xsl:choose>
              </xsl:attribute>
              <xsl:if test="substring-after(substring-after(/bedework/appvar[key='bwQuery']/value,'|'),'|') = 'mine'">
                <xsl:attribute name="checked">checked</xsl:attribute>
              </xsl:if>
            </input>
            <label for="searchScope-mine"><xsl:value-of select="$bwStr-Srch-ScopeMine"/></label>

            <input type="radio" name="fexpr" id="searchScope-all">
              <xsl:attribute name="value">(colPath="/public/cals/MainCal" and (entity_type="event"|entity_type="todo"))</xsl:attribute>
              <xsl:if test="substring-after(substring-after(/bedework/appvar[key='bwQuery']/value,'|'),'|') = 'all'">
                <xsl:attribute name="checked">checked</xsl:attribute>
              </xsl:if>
            </input>
            <label for="searchScope-all"><xsl:value-of select="$bwStr-Srch-ScopeAll"/></label>

          </div>
        </div>

      </form>
    </div>
  </xsl:template>

  <xsl:template name="searchResultPageNav">
    <xsl:param name="page">1</xsl:param>
    <xsl:variable name="curPage" select="/bedework/searchResults/curPage"/>
    <xsl:variable name="numPages" select="/bedework/searchResults/numPages"/>
    <xsl:variable name="endPage">
      <xsl:choose>
        <xsl:when test="number($curPage) + 6 &gt; number($numPages)"><xsl:value-of select="$numPages"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="number($curPage) + 6"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$page = $curPage">
        <xsl:value-of select="$page"/>
      </xsl:when>
      <xsl:otherwise>
        <a href="{$search-next}&amp;pageNum={$page}">
          <xsl:value-of select="$page"/>
        </a>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text> </xsl:text>
    <xsl:if test="$page &lt; $endPage">
       <xsl:call-template name="searchResultPageNav">
         <xsl:with-param name="page" select="number($page)+1"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>