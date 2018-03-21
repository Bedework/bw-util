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
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!--==== TAB BAR  ====-->
  <!-- these templates are separated out for convenience and to simplify the default template -->
  <!-- DEPRECATED in the 3.10 theme.  If you wish to use this, xsl:include it in bedework.xsl. -->

  <xsl:template name="tabs">
    <nav id="tabs">
      <ul id="nav-main">
        <xsl:variable name="currentClass">current</xsl:variable>
        <li>
          <a
            href="{$setSelectionList}&amp;listMode=true&amp;setappvar=listPage(upcoming)">
            <xsl:if test="/bedework/page='eventList'">
              <xsl:attribute name="class">
                <xsl:value-of select="$currentClass" />
              </xsl:attribute>
            </xsl:if>
            <xsl:copy-of select="$bwStr-Tabs-Upcoming"/>
          </a>
        </li>
        <li>
          <a
            href="{$setViewPeriod}&amp;viewType=dayView&amp;date={$curdate}&amp;setappvar=listPage(eventscalendar)">
            <xsl:if test="/bedework/periodname='Day' and /bedework/page = 'eventscalendar'">
              <xsl:attribute name="class">
                <xsl:value-of select="$currentClass" />
              </xsl:attribute>
            </xsl:if>
            <xsl:copy-of select="$bwStr-Tabs-Day"/>
          </a>
        </li>
        <li>
          <a
            href="{$setViewPeriod}&amp;viewType=weekView&amp;date={$curdate}&amp;setappvar=listPage(eventscalendar)">
            <xsl:if test="/bedework/periodname='Week' and /bedework/page = 'eventscalendar'">
              <xsl:attribute name="class">
                <xsl:value-of select="$currentClass" />
              </xsl:attribute>
            </xsl:if>
            <xsl:copy-of select="$bwStr-Tabs-Week"/>
          </a>
        </li>
        <li>
          <a
            href="{$setViewPeriod}&amp;viewType=monthView&amp;date={$curdate}&amp;setappvar=listPage(eventscalendar)">
            <xsl:if test="/bedework/periodname='Month' and /bedework/page = 'eventscalendar'">
              <xsl:attribute name="class">
                <xsl:value-of select="$currentClass" />
              </xsl:attribute>
            </xsl:if>
            <xsl:copy-of select="$bwStr-Tabs-Month"/>
          </a>
        </li>
<!-- YEAR is not very useful.  You can turn it back on if you wish. -->
<!--
        <li>
          <a
            href="{$setViewPeriod}&amp;viewType=yearView&amp;date={$curdate}">
            <xsl:if test="/bedework/periodname='Year' and /bedework/page = 'eventscalendar'">
              <xsl:attribute name="class">
                <xsl:value-of select="$currentClass" />
              </xsl:attribute>
            </xsl:if>
            <xsl:copy-of select="$bwStr-Tabs-Year"/>
          </a>
        </li>
-->
        <li>
          <a
            href="{$setViewPeriod}&amp;viewType=todayView">
            <xsl:if test="/bedework/periodname='Today' and /bedework/page = 'eventscalendar'">
              <xsl:attribute name="class">
                <xsl:value-of select="$currentClass" />
              </xsl:attribute>
            </xsl:if>
            <xsl:copy-of select="$bwStr-Tabs-Today"/>
          </a>
        </li>
      </ul>
      <div class="clear">&#160;</div>
    </nav>
  </xsl:template>

</xsl:stylesheet>
