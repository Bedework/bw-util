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
  <xsl:output method="html" omit-xml-declaration="yes" indent="no" media-type="text/javascript" standalone="yes"/>
  <!-- JSON feed of Bedework events,
       Bedework v3.6, Arlen Johnson

       Purpose: produces an array of javascript objects representing events.

  -->

  <!-- Bring in settings and included xsl -->
  <xsl:include href="globals.xsl"/>
  <xsl:include href="../strings.xsl"/>

  <xsl:include href="./xsl/jsonEvent.xsl"/>
  <!-- Provides category filter templates -->
  <xsl:include href="./xsl/categoryFiltering.xsl"/>

  <xsl:template match='/'>
    <xsl:choose>
      <xsl:when test="/bedework/error">
        {"error": "<xsl:call-template name="escapeJson"><xsl:with-param name="string" select="/bedework/error/id"/></xsl:call-template>"}
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="/bedework/appvar/key = 'objName'">
            var <xsl:value-of select="/bedework/appvar[key='objName']/value"/> = {"bwEventList": {
          </xsl:when>
          <xsl:otherwise>
            {"bwEventList": {
          </xsl:otherwise>
        </xsl:choose>
        "resultSize": "<xsl:value-of select="/bedework/events/resultSize"/>",
        "paged": "<xsl:value-of select="/bedework/events/paged"/>",
        "lastMod" : {
        "utc" : "<xsl:value-of select="/bedework/now/utc"/>",
        "long" : "<xsl:value-of select="/bedework/now/longdate"/><xsl:text> </xsl:text><xsl:value-of select="/bedework/now/time"/>"
        },
        "events": [
        <xsl:apply-templates select="/bedework/events" />
        ]
        }}
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="events">
    <xsl:choose>
      <xsl:when test="/bedework/appvar/key = 'filter'">
        <xsl:variable name="filterName" select="substring-before(/bedework/appvar[key='filter']/value,':')"/>
        <xsl:variable name="filterVal" select="substring-after(/bedework/appvar[key='filter']/value,':')"/>
        <!-- Define filters here: -->
        <xsl:choose>
          <xsl:when test="$filterName = 'grpAndCats'">
            <xsl:call-template name="preprocessCats">
              <xsl:with-param name="allCats" select="$filterVal"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <!-- Filter name not defined? Turn off filtering. -->
            <xsl:apply-templates select="event"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="event"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>


