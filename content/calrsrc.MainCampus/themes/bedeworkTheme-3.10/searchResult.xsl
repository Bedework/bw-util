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


  <!--==== SEARCH RESULT ====-->
  <xsl:template name="searchResult">
    <div class="secondaryColHeader">
      <h3><xsl:copy-of select="$bwStr-Srch-SearchResults"/></h3>
    </div>

    <xsl:if test="/bedework/searchResults/curPage &lt; 2">
      <span class="numReturnedResults">
        <xsl:value-of select="/bedework/searchResults/resultSize" />
        <xsl:text> </xsl:text>
        <xsl:choose>
          <xsl:when test="/bedework/searchResults/resultSize != 1">
            <xsl:copy-of select="$bwStr-Srch-Results"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:copy-of select="$bwStr-Srch-Result"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:text> </xsl:text>
        <xsl:copy-of select="$bwStr-Srch-ReturnedFor"/>
        <xsl:text> </xsl:text>
        <em>
          <xsl:choose>
            <xsl:when test="/bedework/searchResults/query=''">
              <xsl:copy-of select="$bwStr-Srch-NoQuery"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="/bedework/searchResults/query" />
            </xsl:otherwise>
          </xsl:choose>
        </em>
      </span>
    </xsl:if>
    <xsl:if test="/bedework/searchResults/searchResult">
      <table id="searchTable">
        <tr>
          <!-- th class="search_relevance"><xsl:copy-of select="$bwStr-Srch-Rank"/></th-->
          <th class="search_date"><xsl:copy-of select="$bwStr-Srch-Date"/></th>
          <th class="search_summary"><xsl:copy-of select="$bwStr-Srch-Summary"/></th>
          <th class="search_location"><xsl:copy-of select="$bwStr-Srch-Location"/></th>
        </tr>
        <xsl:for-each select="/bedework/searchResults/searchResult">
          <xsl:if test="event/summary">
            <xsl:variable name="calPath" select="event/calendar/encodedPath" />
            <xsl:variable name="href" select="event/encodedHref" />
            <xsl:variable name="guid" select="event/guid" />
            <xsl:variable name="recurrenceId" select="event/recurrenceId" />
            <tr>
              <!-- td class="search_relevance">
                <xsl:choose>
                  <xsl:when test="contains(score,'E')">1%</xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="ceiling(number(score)*100)" />%
                  </xsl:otherwise>
                </xsl:choose>
              </td-->
              <td class="search_date">
                <xsl:value-of select="event/start/shortdate" />
                <xsl:text> </xsl:text>
              </td>
              <td class="search_summary">
                <a href="{$eventView}&amp;href={$href}">
                  <xsl:value-of select="event/summary" />
                  <xsl:if test="event/summary = ''">
                    <xsl:copy-of select="$bwStr-SgEv-NoTitle" />
                  </xsl:if>
                </a>
              </td>
              <td class="search_location">
                <xsl:value-of select="event/location/address" />
              </td>
            </tr>
          </xsl:if>
        </xsl:for-each>
      </table>
    </xsl:if>
    <xsl:if test="/bedework/searchResults/numPages &gt; 1">
      <span class="resultPages" id="resultsBottom">
        <xsl:copy-of select="$bwStr-Srch-Pages" />
        <xsl:variable name="curPage"
          select="/bedework/searchResults/curPage" />
        <xsl:if test="/bedework/searchResults/curPage != 1">
          <xsl:variable name="prevPage"
            select="number($curPage) - 1" />
          <a href="{$search-next}&amp;pageNum={$prevPage}">
            &#171; <!-- left double arrow -->
          </a>
        </xsl:if>
        <xsl:text> </xsl:text>
        <xsl:call-template name="searchResultPageNav">
          <xsl:with-param name="page">
            <xsl:choose>
              <xsl:when test="number($curPage) - 10 &lt; 1">
                1
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="number($curPage) - 6" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
        </xsl:call-template>
        <xsl:text> </xsl:text>
        <xsl:choose>
          <xsl:when test="$curPage != /bedework/searchResults/numPages">
            <xsl:variable name="nextPage" select="number($curPage) + 1" />
            <a href="{$search-next}&amp;pageNum={$nextPage}">
              &#187; <!-- right double arrow -->
            </a>
          </xsl:when>
          <xsl:otherwise>
            <span class="hidden">&#171;<!-- left double arrow --></span>
            <!-- occupy the space to keep the navigation from moving around -->
          </xsl:otherwise>
        </xsl:choose>
      </span>
    </xsl:if>
  </xsl:template>

  <xsl:template name="searchResultPageNav">
    <xsl:param name="page">1</xsl:param>
    <xsl:variable name="curPage" select="/bedework/searchResults/curPage" />
    <xsl:variable name="numPages"
      select="/bedework/searchResults/numPages" />
    <xsl:variable name="endPage">
      <xsl:choose>
        <xsl:when  test="number($curPage) + 6 &gt; number($numPages)">
          <xsl:value-of select="$numPages" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="number($curPage) + 6" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$page = $curPage">
        <span class="current">
          <xsl:value-of select="$page" />
        </span>
      </xsl:when>
      <xsl:otherwise>
        <a href="{$search-next}&amp;pageNum={$page}">
          <xsl:value-of select="$page" />
        </a>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text> </xsl:text>
    <xsl:if test="$page &lt; $endPage">
      <xsl:call-template name="searchResultPageNav">
        <xsl:with-param name="page" select="number($page)+1" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
