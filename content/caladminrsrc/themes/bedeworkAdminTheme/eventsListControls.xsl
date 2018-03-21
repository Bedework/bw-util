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

  <!--++++++++++++++++++ Manage Events List ++++++++++++++++++++-->
  <xsl:template name="eventListControls">
    <xsl:param name="nextAction"/>
    <xsl:param name="bottom">false</xsl:param>
    <xsl:param name="sort">dtstart.utc:asc</xsl:param>

    <!-- search meta-data -->
    <xsl:variable name="resultSize" select="/bedework/events/resultSize"/>
    <xsl:variable name="pageSize" select="/bedework/events/pageSize"/>
    <xsl:variable name="offset">
      <xsl:choose>
        <xsl:when test="/bedework/events/curOffset = $resultSize">0</xsl:when>
        <xsl:otherwise><xsl:value-of select="/bedework/events/curOffset"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="totalPages"><xsl:value-of select="ceiling($resultSize div $pageSize)"/></xsl:variable>
    <xsl:variable name="curPage"><xsl:value-of select="floor($offset div $pageSize) + 1"/></xsl:variable>

    <xsl:if test="/bedework/events/event">
      <div class="bwEventListNav">
        <xsl:if test="$bottom = 'true'">
          <xsl:attribute name="class">bwEventListNav bwListNavBottom</xsl:attribute>
        </xsl:if>
        <button type="button" class="prev" onclick="location.href='{$nextAction}&amp;prev=prev&amp;sort={$sort}'">
          <xsl:if test="$curPage = 1">
            <xsl:attribute name="disabled">disabled</xsl:attribute>
            <xsl:attribute name="class">prev disabled</xsl:attribute>
          </xsl:if>
          <span class="ui-icon 	ui-icon-carat-1-w"><xsl:text> </xsl:text></span> <xsl:copy-of select="$bwStr-EvLs-Previous"/>
        </button>
        <button type="button" class="next" onclick="location.href='{$nextAction}&amp;next=next&amp;sort={$sort}'">
          <xsl:if test="$curPage = $totalPages">
            <xsl:attribute name="disabled">disabled</xsl:attribute>
            <xsl:attribute name="class">next disabled</xsl:attribute>
          </xsl:if>
          <xsl:copy-of select="$bwStr-EvLs-Next"/> <span class="ui-icon	ui-icon-carat-1-e"><xsl:text> </xsl:text></span>
        </button>
      </div>
    </xsl:if>

  </xsl:template>

</xsl:stylesheet>