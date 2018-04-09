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

  <!-- Bring in settings and included xsl -->
  <xsl:include href="globals.xsl"/>
  <xsl:include href="../strings.xsl"/>

  <!-- Provides event template -->
  <xsl:include href="./xsl/jsonEvent.xsl"/>
  <!-- Provides category filter templates -->
  <xsl:include href="./xsl/categoryFiltering.xsl"/>

  <xsl:template match='/'>
    <xsl:choose>
      <xsl:when test="/bedework/appvar/key = 'objName'">
        var <xsl:value-of select="/bedework/appvar[key='objName']/value"/> = {'bwEventCalendar': {
      </xsl:when>
      <xsl:otherwise>
      {"bwEventCalendar": {
      </xsl:otherwise>
    </xsl:choose>
        "year": {
          "value": "<xsl:value-of select='/bedework/eventscalendar/year/value'/>",
         <xsl:apply-templates select="/bedework/eventscalendar/year/month" />
      }
      }}
  </xsl:template>

  

  <xsl:template match="month">
      "month": {
        "value" : "<xsl:value-of select='value'/>",
        "longname" : "<xsl:value-of select='longname'/>",
        "shortname" : "<xsl:value-of select='shortname'/>",
        "weeks" : [
          <xsl:apply-templates select="week" />
          ]
        }<xsl:if test="position() != last()">,</xsl:if>
  </xsl:template>

  <xsl:template match="week">
        {
          "value" : "<xsl:value-of select='value'/>",
          "days" : [
             <xsl:apply-templates select="day" />
          ]
        }<xsl:if test="position() != last()">,</xsl:if>
  </xsl:template>

  <xsl:template match="day">
          {
            <xsl:choose>
            <xsl:when test="filler = 'true'">
            "filler" : "<xsl:value-of select='filler'/>"
            </xsl:when>
            <xsl:otherwise>
            "filler" : "<xsl:value-of select='filler'/>",
            "value" : "<xsl:value-of select='value'/>",
            "name" : "<xsl:value-of select='name'/>",
            "date" : "<xsl:value-of select='date'/>",
            "longdate" : "<xsl:value-of select='longdate'/>",
            "shortdate" : "<xsl:value-of select='shortdate'/>",
            "events" : [
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
              ]
            </xsl:otherwise>
            </xsl:choose>
        }<xsl:if test="position() != last()">,</xsl:if>
  </xsl:template>
</xsl:stylesheet>
