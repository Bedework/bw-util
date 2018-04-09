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

  <xsl:template name="queryFilterDisplay">
    <div id="bwQueryContainer">
      <xsl:text> </xsl:text><!-- keep this here to avoid self-closing of the tag if empty -->
      <xsl:if test="/bedework/appvar[key='bwQuery']">
          <!-- The page has been reloaded, and we have a search query. -->
        <div id="bwQuery" class="eventFilterInfo">
          <span class="bwQueryText">
            <span class="bwQueryTitle"><xsl:copy-of select="$bwStr-LsEv-Filter"/></span><xsl:text> </xsl:text>
            <strong class="bwQueryQuery">"<xsl:value-of select="/bedework/appvar[key='bwQuery']/value"/>"</strong>
          </span>
          <xsl:text> </xsl:text>
          <a id="bwClearQuery" href="javascript:bwClearSearch();"><xsl:copy-of select="$bwStr-LsEv-ClearSearch"/></a>
        </div>
      </xsl:if>
    </div>

    <xsl:for-each select="/bedework/views/view">
      <xsl:variable name="filterSetIndex"><xsl:value-of select="position()-1"/></xsl:variable>
      <div id="calFilterContainer{$filterSetIndex}" class="calFilterContainer">
        <xsl:text> </xsl:text><!-- keep this here to avoid self-closing of the tag if empty -->
        <xsl:if test="/bedework/appvar[key='bwFilters']">
          <!-- The page has been reloaded, and we have multiple nav items selected -->
          <div id="bwFilterList{$filterSetIndex}" class="eventFilterInfo">
            <xsl:text> </xsl:text>
          </div>
        </xsl:if>
      </div>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>