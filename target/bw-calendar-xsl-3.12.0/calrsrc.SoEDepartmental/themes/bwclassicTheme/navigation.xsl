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
    <div id="bwTabs">
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
      </ul>
    </div>
  </xsl:template>

  <xsl:template name="navigation">
    <table border="0" cellpadding="0" cellspacing="0" id="navigationBarTable">
      <tr>
        <td class="leftCell">
          <a id="prevViewPeriod" href="{$setViewPeriod}&amp;date={$prevdate}"><img src="{$resourcesRoot}/images/std-arrow-left.gif" alt="previous" width="13" height="16" class="prevImg" border="0"/></a>
          <a id="nextViewPeriod" href="{$setViewPeriod}&amp;date={$nextdate}"><img src="{$resourcesRoot}/images/std-arrow-right.gif" alt="next" width="13" height="16" class="nextImg" border="0"/></a>
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
          <xsl:variable name="nowDate" select="/bedework/now/date"/>
          <button type="button" onclick="location.href='{$setViewPeriod}&amp;date={$nowDate}'">
            <xsl:value-of select="$bwStr-Navi-Today"/>
          </button>
        </td>
        <td align="right" class="gotoForm">
          <form name="calForm" method="post" action="{$setViewPeriod}">
             <table border="0" cellpadding="0" cellspacing="0">
              <tr>
                <xsl:if test="/bedework/periodname!='Year'">
                  <td>
                    <select name="viewStartDate.month" onchange="this.form.submit()">
                      <xsl:for-each select="/bedework/monthlabels/val">
                        <xsl:variable name="pos" select="position()"/>
                        <option>
                          <xsl:if test="substring(/bedework/currentdate/monthname,1,3) = ."><!-- i18n?? -->
                            <xsl:attribute name="selected">selected</xsl:attribute>
                          </xsl:if>
                          <xsl:attribute name="value"><xsl:value-of select="/bedework/monthvalues/val[position()=$pos]"/></xsl:attribute>
                          <xsl:value-of select="."/>
                        </option>
                      </xsl:for-each>
                    </select>
                  </td>
                  <xsl:if test="/bedework/periodname!='Month'">
                    <td>
                      <select name="viewStartDate.day" onchange="this.form.submit()">
                        <xsl:for-each select="/bedework/dayvalues/val">
                          <xsl:variable name="pos" select="position()"/>
                          <option>
                            <xsl:if test="substring-before(substring-after(/bedework/currentdate/shortdate,'/'),'/') = .">
                              <xsl:attribute name="selected">selected</xsl:attribute>
                            </xsl:if>
                            <xsl:attribute name="value"><xsl:value-of select="."/></xsl:attribute>
                            <xsl:value-of select="."/>
                          </option>
                        </xsl:for-each>
                      </select>
                    </td>
                  </xsl:if>
                </xsl:if>
                <td>
                  <input type="text" name="viewStartDate.year" maxlength="4" size="4">
                    <xsl:attribute name="value"><xsl:value-of select="substring(/bedework/currentdate/date,1,4)"/></xsl:attribute>
                  </input>
                </td>
                <td>
                  <input name="dateSubmit" type="submit" value="{$bwStr-Navi-Go}"/>
                </td>
              </tr>
            </table>
          </form>
        </td>
        <td class="rightCell">
        </td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template name="searchBar">
    <table width="100%" border="0" cellpadding="0" cellspacing="0" id="searchBarTable">
       <tr>
         <td class="leftCell">
           <xsl:choose>
             <xsl:when test="/bedework/selectionState/selectionType = 'collections' or /bedework/appvar[key='curCollection']/value != ''">
               <xsl:copy-of select="$bwStr-SrcB-Calendar"/>
               <xsl:text> </xsl:text>
               <strong>
                 <xsl:call-template name="substring-afterLastInstanceOf">
                   <xsl:with-param name="string" select="/bedework/appvar[key='curCollection']/value"/>
                   <xsl:with-param name="char">/</xsl:with-param>
                 </xsl:call-template>
               </strong>
             </xsl:when>
             <xsl:when test="/bedework/selectionState/selectionType = 'search'">
               <xsl:copy-of select="$bwStr-SrcB-CurrentSearch"/><xsl:text> </xsl:text><xsl:value-of select="/bedework/search"/>
             </xsl:when>
             <xsl:otherwise><!-- view -->
               <xsl:copy-of select="$bwStr-SrcB-View"/><xsl:text> </xsl:text>
               <form name="selectViewForm" method="post" action="{$setSelection}">
                <select name="viewName" onchange="displayView('{$setSelection}',this.value)" >
                  <xsl:if test="/bedework/page = 'eventList'"><xsl:attribute name="disabled">disabled</xsl:attribute></xsl:if>
                  <option>please select...</option>
                  <xsl:for-each select="/bedework/views/view">
                    <xsl:choose>
                      <xsl:when test="name=/bedework/selectionState/view/name or name=/bedework/appvar[key='curView']/value">
                        <option selected="selected">
                          <xsl:attribute name="value"><xsl:value-of select="name"/></xsl:attribute>
                          <xsl:value-of select="name"/>
                        </option>
                      </xsl:when>
                      <xsl:otherwise>
                        <option>
                          <xsl:attribute name="value"><xsl:value-of select="name"/></xsl:attribute>
                          <xsl:value-of select="name"/>
                        </option>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:for-each>
                </select>
              </form>
             </xsl:otherwise>
           </xsl:choose>
           <span class="link">
             <xsl:if test="/bedework/selectionState/selectionType = 'collections' or /bedework/appvar[key='curCollection']/value != ''">
               <a href="{$setSelection}&amp;setappvar=curCollection()"><xsl:copy-of select="$bwStr-SrcB-Clear"/></a> |
             </xsl:if>
             <a href="{$fetchPublicCalendars}"><xsl:copy-of select="$bwStr-SrcB-AllCalendars"/></a>
           </span>
         </td>
         <td class="rightCell">
            <xsl:if test="/bedework/page!='searchResult'">
              <form name="searchForm" id="searchForm" method="post" action="{$search}">
                <xsl:copy-of select="$bwStr-SrcB-Search"/>
                <xsl:text> </xsl:text>
                <input type="text" name="query" size="27">
                  <xsl:attribute name="value"><xsl:value-of select="/bedework/searchResults/query"/></xsl:attribute>
                </input>
                <input type="submit" name="submit" value="{$bwStr-SrcB-Go}"/>
              </form>
              <xsl:text> </xsl:text>
            </xsl:if>
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
                    <a class="utilButton" href="{$setup}&amp;setappvar=monthViewMode(cal)" title="{$bwStr-SrcB-ToggleListCalView}">
                      <xsl:copy-of select="$bwStr-Util-Cal"/>
                    </a>
                  </xsl:when>
                  <xsl:otherwise>
                    <a class="utilButton" href="{$setup}&amp;setappvar=monthViewMode(list)" title="{$bwStr-SrcB-ToggleListCalView}">
                      <xsl:copy-of select="$bwStr-Util-List"/>
                    </a>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:otherwise>
                <xsl:choose>
                  <xsl:when test="/bedework/appvar[key='weekViewMode']/value='list'">
                    <a class="utilButton" href="{$setup}&amp;setappvar=weekViewMode(cal)" title="{$bwStr-SrcB-ToggleListCalView}">
                      <xsl:copy-of select="$bwStr-Util-Cal"/>
                    </a>
                  </xsl:when>
                  <xsl:otherwise>
                    <a class="utilButton" href="{$setup}&amp;setappvar=weekViewMode(list)" title="{$bwStr-SrcB-ToggleListCalView}">
                      <xsl:copy-of select="$bwStr-Util-List"/>
                    </a>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
              <xsl:when test="/bedework/page = 'eventList'">
                <xsl:choose>
                  <xsl:when test="/bedework/appvar[key='listEventsSummaryMode']/value='details'">
                    <a class="utilButton" href="{$listEvents}&amp;setappvar=listEventsSummaryMode(summary)" title="{$bwStr-SrcB-ToggleSummDetView}">
                      <xsl:copy-of select="$bwStr-Util-Summary"/>
                    </a>
                  </xsl:when>
                  <xsl:otherwise>
                    <a class="utilButton" href="{$listEvents}&amp;setappvar=listEventsSummaryMode(details)" title="{$bwStr-SrcB-ToggleSummDetView}">
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
                    <a class="utilButton" href="{$setup}&amp;setappvar=summaryMode(summary)" title="{$bwStr-SrcB-ToggleSummDetView}">
                      <xsl:copy-of select="$bwStr-Util-Summary"/>
                    </a>
                  </xsl:when>
                  <xsl:otherwise>
                    <a class="utilButton" href="{$setup}&amp;setappvar=summaryMode(details)" title="{$bwStr-SrcB-ToggleSummDetView}">
                      <xsl:copy-of select="$bwStr-Util-Details"/>
                    </a>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
          </td>
       </tr>
    </table>
  </xsl:template>

</xsl:stylesheet>
