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

  <!--+++++++++++++++ System Tab ++++++++++++++++++++-->
  <xsl:template name="tabSystem">
    <xsl:if test="/bedework/userInfo/superUser='true'">
      <h2><xsl:copy-of select="$bwStr-TaSy-ManageSys"/></h2>
      <ul class="adminMenu strong">
        <li class="calendar">
          <a href="{$calendar-fetch}">
            <xsl:copy-of select="$bwStr-TaSy-ManageCalsAndFolders"/>
          </a>
        </li>
        <li class="categories">
          <a href="{$category-initUpdate}">
            <xsl:copy-of select="$bwStr-TaSy-ManageCategories"/>
          </a>
        </li>
        <li class="calsuites">
          <a href="{$calsuite-fetch}">
            <xsl:copy-of select="$bwStr-TaSy-ManageCalSuites"/>
          </a>
        </li>
        <li class="resources">
          <a href="{$global-resources-fetch}">
            <xsl:copy-of select="$bwStr-TaSy-ManageGlobalResources"/>
          </a>
        </li>
        <li class="upload">
          <a href="{$event-initUpload}">
            <xsl:copy-of select="$bwStr-TaSy-UploadICalFile"/>
          </a>
        </li>
      </ul>
      <!-- System preferences are now almost exclusively managed in JMX-Console
           ... but leave this here for now.
      <ul class="adminMenu">
        <li class="prefs">
          <a href="{$system-fetch}">
            <xsl:copy-of select="$bwStr-TaSy-ManageSysPrefs"/>
          </a>
        </li>
      </ul>
      -->
      <ul class="adminMenu">
        <li>
          <a href="{$filter-showAddForm}">
            <xsl:copy-of select="$bwStr-TaSy-ManageCalDAVFilters"/>
          </a>
        </li>
        <li>
          <form name="unindex" id="bwUnindexHrefForm" action="{$index-unindex}">
            <xsl:copy-of select="$bwStr-Idx-Unindex"/><br/>
            <input type="text" size="40" name="href"/>
            <input type="submit" value="{$bwStr-Cals-Go}"/>
          </form>
        </li>
        <li class="timezones">
          <a href="{$timezones-fix}">
            <xsl:attribute name="title"><xsl:copy-of select="$bwStr-UpTZ-FixTZNote"/></xsl:attribute>
            <xsl:copy-of select="$bwStr-UpTZ-FixTZ"/>
          </a>
          <xsl:text> </xsl:text><xsl:copy-of select="$bwStr-UpTZ-RecalcUTC"/><br/>
        </li>
      </ul>
      <ul class="adminMenu">
        <li>
          <xsl:copy-of select="$bwStr-TaSy-Stats"/>
          <ul>
            <li>
              <a href="{$stats-update}&amp;fetch=yes" target="adminStats">
                <xsl:copy-of select="$bwStr-TaSy-AdminWebClient"/>
              </a>
            </li>
            <li>
              <a href="{$publicCal}/stats/stats.do?fetch=yes" target="pubStats">
                <xsl:copy-of select="$bwStr-TaSy-PublicWebClient"/>
              </a>
            </li>
          </ul>
        </li>
      </ul>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>