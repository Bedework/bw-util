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
       Bedework v3.6.x, Barry Leibson

       Purpose: produces an array of javascript objects representing categories.

       Usage: provide a list of categories for form building, particualary for
       the URL Builder.

  -->

  <!-- DEFINE INCLUDES -->
  <!-- util.xsl belongs in bedework-common on your application server for use
       by all stylesheets: -->
  <xsl:include href="/bedework-common/default/default/util.xsl"/>
  
  <xsl:template match='/'>
	<xsl:choose>
      <xsl:when test="/bedework/appvar/key = 'objName'">
    var <xsl:value-of select="/bedework/appvar[key='objName']/value"/> = {"bwGroups": {
      </xsl:when>
      <xsl:otherwise>
    {"bwGroups": {
      </xsl:otherwise>
    </xsl:choose>
        "groups": [
            <xsl:apply-templates select="/bedework/groups/group"/>
        ]
    }}
  </xsl:template>

  <xsl:template match="group">
    {
      "eventOwner" : "<xsl:value-of select="eventOwner"/>",
       "name" : "<xsl:call-template name="escapeJson"><xsl:with-param name="string" select="name"/></xsl:call-template>",
       "description" : "<xsl:call-template name="escapeJson"><xsl:with-param name="string" select="description"/></xsl:call-template>",
       "memberOf" : [
                      {
                      <xsl:apply-templates select="memberof"/>
                      }
                    ]
     }<xsl:if test="position() != last()">,</xsl:if>
  </xsl:template>
   
  <xsl:template match="memberof">
                         "name" : "<xsl:call-template name="escapeJson"><xsl:with-param name="string" select="name"/></xsl:call-template>"<xsl:if test="position() != last()">,</xsl:if>
  </xsl:template>
</xsl:stylesheet>
