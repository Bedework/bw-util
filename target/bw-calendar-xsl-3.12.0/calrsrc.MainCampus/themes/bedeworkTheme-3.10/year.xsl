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

    <!--==== YEAR VIEW ====-->
  <xsl:template name="yearView">
    <div class="yearMonthRow">
      <xsl:apply-templates select="/bedework/eventscalendar/year/month[position() &lt;= 4]" />
    </div>
    <div class="yearMonthRow">
      <xsl:apply-templates select="/bedework/eventscalendar/year/month[(position() &gt; 4) and (position() &lt;= 8)]" />
    </div>
    <div class="yearMonthRow">
      <xsl:apply-templates select="/bedework/eventscalendar/year/month[position() &gt; 8]" />
    </div>
  </xsl:template>
  <!-- year view month tables -->
  <xsl:template match="month">
    <table class="yearViewMonthTable" cellspacing="0"
      cellpadding="0">
      <tr>
        <td colspan="7" class="monthName">
          <xsl:variable name="firstDayOfMonth" select="week/day/date" />
          <a href="{$setViewPeriod}&amp;viewType=monthView&amp;date={$firstDayOfMonth}">
            <xsl:value-of select="longname" />
          </a>
        </td>
      </tr>
      <tr>
        <xsl:for-each select="/bedework/shortdaynames/val">
          <th>
            <xsl:value-of select="." />
          </th>
        </xsl:for-each>
      </tr>
      <xsl:for-each select="week">
        <tr>
          <xsl:for-each select="day">
            <xsl:choose>
              <xsl:when test="filler='true'">
                <td class="filler">&#160;</td>
              </xsl:when>
              <xsl:otherwise>
                <td>
                  <xsl:if test="/bedework/now/date = date">
                    <xsl:attribute name="class">today</xsl:attribute>
                  </xsl:if>
                  <xsl:variable name="dayDate"
                    select="date" />
                  <a href="{$setViewPeriod}&amp;viewType=dayView&amp;date={$dayDate}">
                    <xsl:attribute name="class">today</xsl:attribute>
                    <xsl:value-of select="value" />
                  </a>
                </td>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>


</xsl:stylesheet>
