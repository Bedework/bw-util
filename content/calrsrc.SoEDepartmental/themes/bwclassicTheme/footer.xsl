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

  <!--==== FOOTER ====-->
  <xsl:template name="footer">
    <div id="footer">
      <xsl:copy-of select="$bwStr-Foot-BasedOnThe"/><xsl:text> </xsl:text><a href="http://www.jasig.org/bedework"><xsl:copy-of select="$bwStr-Foot-BedeworkCalendarSystem"/></a>
    </div>
    <table id="skinSelectorTable" border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td class="leftCell">
          <a href="http://www.jasig.org/bedework"><xsl:copy-of select="$bwStr-Foot-BedeworkWebsite"/></a> |
          <a href="http://www.jasig.org/bedework/whosusing"><xsl:copy-of select="$bwStr-Foot-ProductionExamples"/></a> |
          <a href="?noxslt=yes"><xsl:copy-of select="$bwStr-Foot-ShowXML"/></a> |
          <a href="?refreshXslt=yes"><xsl:copy-of select="$bwStr-Foot-RefreshXSLT"/></a>
        </td>
        <td class="rightCell">
          <form name="styleSelectForm" method="get" action="{$setup}">
            <select name="setappvar" onchange="submit()">
              <option value=""><xsl:copy-of select="$bwStr-Foot-ExampleStyles"/>:</option>
              <option value="style(green)"><xsl:copy-of select="$bwStr-Foot-Green"/></option>
              <option value="style(red)"><xsl:copy-of select="$bwStr-Foot-Red"/></option>
              <option value="style(blue)"><xsl:copy-of select="$bwStr-Foot-Blue"/></option>
            </select>
          </form>
          <!--
          <form name="skinSelectForm" method="post" action="{$setup}">
            <input type="hidden" name="setappvar" value="summaryMode(details)"/>
            <select name="skinPicker" onchange="window.location = this.value">
              <option value="{$setup}&amp;skinNameSticky=default">
                <xsl:copy-of select="$bwStr-Foot-ExampleSkins" />
              </option>
              <option value="{$setup}&amp;skinNameSticky=default">
                <xsl:copy-of select="$bwStr-Foot-ResetToCalendarDefault" />
              </option>
              <option value="{$setup}&amp;browserTypeSticky=PDA">
                <xsl:copy-of select="$bwStr-Foot-ForMobileBrowsers" />
              </option>
              <option value="{$feeder}/main/listEvents.do?skinName=list-rss&amp;days=3">
                <xsl:copy-of select="$bwStr-Foot-RSSNext3Days" />
              </option>
              <option value="{$feeder}/main/listEvents.do?skinName=list-json&amp;days=3&amp;contentType=text/javascript&amp;contentName=bedework.js">
                <xsl:copy-of select="$bwStr-Foot-JavascriptNext3Days" />
              </option>
              <option value="{$setViewPeriod}&amp;viewType=todayView&amp;skinNameSticky=videocal">
                <xsl:copy-of select="$bwStr-Foot-VideoFeed" />
              </option>
            </select>
          </form>
          -->
        </td>
      </tr>
    </table>
  </xsl:template>

</xsl:stylesheet>
