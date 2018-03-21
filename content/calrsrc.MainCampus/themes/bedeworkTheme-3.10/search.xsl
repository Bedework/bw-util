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
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


  <!--==== SEARCH FORM (basic) ====-->
  <xsl:template name="search">
    <form name="bwBasicSearch" id="bwBasicSearch" class="form-group" method="post" onsubmit="return bwSearch(this.query.value)" action="#">
      <label for="bwBasicSearchInput" class="sr-only"><xsl:value-of select="$bwStr-SrcB-SearchForEvents"/></label>
      <div class="bwInputs">
        <input type="text" name="query" id="bwBasicSearchInput" class="form-control" placeholder="add a filter">
          <!--<xsl:attribute name="value"><xsl:value-of select="/bedework/searchResults/query" /></xsl:attribute>-->
          <xsl:if test="/bedework/appvar[key='bwQuery']">
            <xsl:attribute name="value"><xsl:value-of select="/bedework/appvar[key='bwQuery']/value" /></xsl:attribute>
          </xsl:if>
        </input>
        <button id="searchSubmit" type="submit" name="submit" class="btn">
          <span class="glyphicon glyphicon-search"><xsl:text> </xsl:text></span>
          <span class="bwa-label"><xsl:value-of select="$bwStr-SrcB-ApplyFilter"/></span>
        </button>
      </div>
      <!--
      <div id="bwSearchButtons">
	      <! - -advance search link  - - >
	      <a href="{$search-next}"><xsl:copy-of select="$bwStr-Tabs-AdvSearch"/></a>
	    </div>
	    -->
    </form>
  </xsl:template>

  <xsl:template name="advancedSearch">
    <div id="advSearch">
      <h3><xsl:copy-of select="$bwStr-Srch-AdvancedSearch"/></h3>
      <form id="advSearchForm" name="searchForm"
        onsubmit="return initCat()" method="post" action="{$search}">
        <xsl:copy-of select="$bwStr-Srch-Search"/>
        <xsl:text> </xsl:text>
        <input type="text" name="query" size="40">
          <xsl:attribute name="value">
            <xsl:value-of select="/bedework/searchResults/query"/>
          </xsl:attribute>
        </input>
        <input type="submit" name="submit" value="{$bwStr-Srch-Go}" />
        <br />
        <label><xsl:copy-of select="$bwStr-Srch-Limit"/></label>
        <xsl:text> </xsl:text>
        <input type="radio" name="searchLimits" value="fromToday">
          <xsl:if test="/bedework/searchResults/searchLimits = 'fromToday'">
            <xsl:attribute name="checked">checked</xsl:attribute>
          </xsl:if>
        </input>
        <xsl:copy-of select="$bwStr-Srch-TodayForward"/>
        <input type="radio" name="searchLimits" value="beforeToday">
          <xsl:if test="/bedework/searchResults/searchLimits = 'beforeToday'">
            <xsl:attribute name="checked">checked</xsl:attribute>
          </xsl:if>
        </input>
        <xsl:copy-of select="$bwStr-Srch-PastDates"/>
        <input type="radio" name="searchLimits" value="none">
          <xsl:if test="/bedework/searchResults/searchLimits = 'none'">
            <xsl:attribute name="checked">checked</xsl:attribute>
          </xsl:if>
        </input>
        <xsl:copy-of select="$bwStr-Srch-AllDates"/>

        <div id="searchCats">
          <h4><xsl:copy-of select="$bwStr-Srch-CatsToSearch"/></h4>
          <p>
            <xsl:copy-of select="$bwStr-Srch-SearchTermNotice"/>
          </p>
          <xsl:variable name="catCount" select="count(/bedework/categories/category)" />
          <table>
            <tr>
              <td>
                <ul>
                  <xsl:for-each select="/bedework/categories/category[position() &lt;= ceiling($catCount div 3)]">
                    <xsl:variable name="currId" select="value" />
                    <li>
                      <p>
                        <input type="checkbox" name="categoryKey" value="{$currId}" />
                        <xsl:value-of select="value" />
                      </p>
                    </li>
                  </xsl:for-each>
                </ul>
              </td>
              <td>
                <ul>
                  <xsl:for-each select="/bedework/categories/category[(position() &gt; ceiling($catCount div 3)) and (position() &lt;= ceiling($catCount div 3)*2)]">
                    <xsl:variable name="currId2" select="value" />
                    <li>
                      <p>
                        <input type="checkbox" name="categoryKey" value="{$currId2}" />
                        <xsl:value-of select="value" />
                      </p>
                    </li>
                  </xsl:for-each>
                </ul>
              </td>
              <td>
                <ul>
                  <xsl:for-each select="/bedework/categories/category[position() &gt; ceiling($catCount div 3)*2]">
                    <xsl:variable name="currId2" select="value" />
                    <li>
                      <p>
                        <input type="checkbox" name="categoryKey" value="{$currId2}" />
                        <xsl:value-of select="value" />
                      </p>
                    </li>
                  </xsl:for-each>
                </ul>
              </td>
            </tr>
          </table>
        </div>
      </form>
    </div>
  </xsl:template>

</xsl:stylesheet>
