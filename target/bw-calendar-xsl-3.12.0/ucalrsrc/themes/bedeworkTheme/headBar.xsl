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

  <xsl:template name="headBar">
    <table width="100%" border="0" cellpadding="0" cellspacing="0" id="logoTable">
      <tr>
        <td colspan="3" id="logoCell"><a href="/bedework/"><img src="{$resourcesRoot}/images/bedeworkLogo.gif" width="292" height="75" border="0" alt="Bedework"/></a></td>
        <td colspan="2" id="schoolLinksCell">
          <h2><xsl:copy-of select="$bwStr-HdBr-PersonalCalendar"/></h2>
          <a href="{$publicCal}"><xsl:copy-of select="$bwStr-HdBr-PublicCalendar"/></a> |
          <a href="http://www.jasig.org/bedework"><xsl:copy-of select="$bwStr-HdBr-SchoolHome"/></a> |
          <a href="?refreshXslt=yes"><xsl:copy-of select="$bwStr-HdBr-OtherLink"/></a> |
          <a href="http://www.jasig.org/bedework/documentation">
            <xsl:copy-of select="$bwStr-HdBr-ExampleCalendarHelp"/>
          </a>
        </td>
      </tr>
    </table>
    <table id="curDateRangeTable"  cellspacing="0">
      <tr>
        <td class="sideBarOpenCloseIcon">
        </td>
        <td class="date">
          <xsl:value-of select="/bedework/firstday/longdate"/>
          <xsl:if test="/bedework/periodname!='Day'">
            -
            <xsl:value-of select="/bedework/lastday/longdate"/>
          </xsl:if>
        </td>
        <td class="rssPrint">
          <a href="javascript:window.print()" title="{$bwStr-HdBr-PrintThisView}">
            <img alt="print this view" src="{$resourcesRoot}/images/std-print-icon.gif" width="20" height="14" border="0"/> <xsl:copy-of select="$bwStr-HdBr-Print"/>
          </a>
          <a class="rss" href="{$listEvents}&amp;setappvar=summaryMode(details)&amp;skinName=rss-list&amp;days=3" title="{$bwStr-HdBr-RSSFeed}"><xsl:copy-of select="$bwStr-HdBr-RSS"/></a>
        </td>
      </tr>
    </table>
  </xsl:template>


</xsl:stylesheet>