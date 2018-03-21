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
  <!-- JSON representation of Bedework categories (only)
       Bedework v3.8.x, Arlen Johnson

       Purpose: produces a json representation of the current calendar suite's calendar tree. 
       Provides a tree of calendars for use in menu building, particularly for the 
       left-hand navigation in the public client.

       Usage:
       
       To call the object as pure json:  
       /feeder/calendar/fetchPublicCalendars.do?skinName=widget-json-cals&setappvar=setSelectionAction(calsuiteSetSelectionAction)
       where the "calsuiteSetSelectionAction" is the path to the setSelection.do action as produced by 
       the current calendar suite calling this page.  Different suites will have different contexts, so we 
       need to account for that by passing in the server-relative path to setSelection.do. 
       
       To call the object and assign it to a variable:
       /feeder/calendar/fetchPublicCalendars.do?skinName=widget-json-cals&setappvar=setSelectionAction(calsuiteSetSelectionAction)&setappvar=objName(somename)
       This usage assigns the json object to a "somename" variable which can be directly referenced. 

  -->

  <!-- DEFINE INCLUDES -->
  <!-- util.xsl belongs in bedework-common on your application server for use
       by all stylesheets: -->
  <xsl:include href="/bedework-common/default/default/util.xsl"/>
  
  <xsl:template match='/'>
	<xsl:choose>
      <xsl:when test="/bedework/appvar/key = 'objName'">
    var <xsl:value-of select="/bedework/appvar[key='objName']/value"/> = {"bwCals": {
      </xsl:when>
      <xsl:otherwise>
    {"bwCals": {
      </xsl:otherwise>
    </xsl:choose>
        "calendars": [
            <xsl:apply-templates select="/bedework/calendars/calendar">
              <xsl:with-param name="isRoot">true</xsl:with-param>
            </xsl:apply-templates>
        ]
    }}
  </xsl:template>
  
  <!-- output root calendar and all children (recursively) -->
  <xsl:template match="calendar">
    <xsl:param name="isRoot"/>
    <xsl:variable name="virtualPath"><xsl:call-template name="escapeJson"><xsl:with-param name="string">/user<xsl:for-each select="ancestor-or-self::calendar/name">/<xsl:value-of select="."/></xsl:for-each></xsl:with-param></xsl:call-template></xsl:variable>
    <xsl:variable name="encVirtualPath"><xsl:call-template name="url-encode"><xsl:with-param name="str" select="$virtualPath"/></xsl:call-template></xsl:variable>
    <xsl:variable name="summary"><xsl:call-template name="escapeJson"><xsl:with-param name="string" select="summary"/></xsl:call-template></xsl:variable>
    {
      "name" : "<xsl:call-template name="escapeJson"><xsl:with-param name="string" select="name"/></xsl:call-template>",
      "summary" : "<xsl:value-of select="$summary"/>",
      "path" : "<xsl:call-template name="escapeJson"><xsl:with-param name="string" select="path"/></xsl:call-template>",
      "encodedPath" : "<xsl:call-template name="escapeJson"><xsl:with-param name="string" select="encodedPath"/></xsl:call-template>",
      "virtualPath" : "<xsl:value-of select="$virtualPath"/>",
      <xsl:choose>
        <xsl:when test="$isRoot = 'true'">
      "calendarLink" : "<xsl:value-of select="/bedework/appvar[key='setSelectionAction']/value"/>&amp;setappvar=curCollection()",
        </xsl:when>
        <xsl:otherwise>
      "calendarLink" : "<xsl:value-of select="/bedework/appvar[key='setSelectionAction']/value"/>&amp;virtualPath=<xsl:value-of select="$encVirtualPath"/>&amp;setappvar=curCollection(<xsl:value-of select="$summary"/>)",
        </xsl:otherwise>
      </xsl:choose>
      "ownerHref" : "<xsl:call-template name="escapeJson"><xsl:with-param name="string" select="ownerHref"/></xsl:call-template>",
      "calType" : "<xsl:call-template name="escapeJson"><xsl:with-param name="string" select="calType"/></xsl:call-template>",
      "calendarCollection" : "<xsl:call-template name="escapeJson"><xsl:with-param name="string" select="calendarCollection"/></xsl:call-template>",
      "color" : "<xsl:call-template name="escapeJson"><xsl:with-param name="string" select="color"/></xsl:call-template>",
      "isTopicalArea" : "<xsl:call-template name="escapeJson"><xsl:with-param name="string" select="isTopicalArea"/></xsl:call-template>",
      "display" : "<xsl:call-template name="escapeJson"><xsl:with-param name="string" select="display"/></xsl:call-template>",
      "disabled" : "<xsl:call-template name="escapeJson"><xsl:with-param name="string" select="disabled"/></xsl:call-template>",
      "open" : "<xsl:call-template name="escapeJson"><xsl:with-param name="string" select="open"/></xsl:call-template>",
      "desc" : "<xsl:call-template name="escapeJson"><xsl:with-param name="string" select="desc"/></xsl:call-template>",
      "isSubscription" : "<xsl:call-template name="escapeJson"><xsl:with-param name="string" select="isSubscription"/></xsl:call-template>",
      "aliasUri" : "<xsl:call-template name="escapeJson"><xsl:with-param name="string" select="aliasUri"/></xsl:call-template>",
      "internalAlias" : "<xsl:call-template name="escapeJson"><xsl:with-param name="string" select="internalAlias"/></xsl:call-template>",
      "externalSub" : "<xsl:call-template name="escapeJson"><xsl:with-param name="string" select="externalSub"/></xsl:call-template>"<!-- 
    --><xsl:if test="calendar">,
      "children" : [
        <xsl:apply-templates select="calendar">
          <xsl:with-param name="isRoot">false</xsl:with-param>
        </xsl:apply-templates>
      ]
      </xsl:if>
     }<xsl:if test="position() != last()">,</xsl:if>
  </xsl:template>
   
</xsl:stylesheet>
