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
  <xsl:template match="event">
          {
            "summary" : "<xsl:call-template name="escapeJson"><xsl:with-param name="string" select="summary"/></xsl:call-template>",
            "subscriptionId" : "<xsl:value-of select="subscription/id"/>",
            "calPath" : "<xsl:value-of select="calendar/encodedPath"/>",
            "guid" : "<xsl:call-template name="url-encode"><xsl:with-param name="str" select="guid"/></xsl:call-template>",
            "recurrenceId" : "<xsl:value-of select="recurrenceId"/>",
            "name" : "<xsl:value-of select='name'/>",
            "link" : "<xsl:value-of select='link'/>",
            "eventlink" : "<xsl:value-of select="substring-before($urlPrefix,$feeder)"/><xsl:value-of select="$publicCal"/>/event/eventView.do?calPath=<xsl:value-of select="calendar/encodedPath"/><xsl:text disable-output-escaping="yes"><![CDATA[&guid=]]></xsl:text><xsl:value-of select="guid"/><xsl:text disable-output-escaping="yes"><![CDATA[&recurrenceId=]]></xsl:text><xsl:value-of select="recurrenceId"/>",
            "status" : "<xsl:value-of select='status'/>",
            "formattedDate" : "<xsl:value-of select="start/dayname" />, <xsl:value-of select="start/longdate" /><xsl:text> </xsl:text><xsl:if test="start/allday = 'false'"><xsl:value-of select="start/time" /></xsl:if> <xsl:if test="(end/longdate != start/longdate) or ((end/longdate = start/longdate) and (end/time != start/time))"> - </xsl:if> <xsl:if test="end/longdate != start/longdate"> <xsl:value-of select="substring(end/dayname,1,3)" /> , <xsl:value-of select="end/longdate" /> <xsl:text> </xsl:text> </xsl:if> <xsl:choose> <xsl:when test="start/allday = 'true'"> <xsl:copy-of select="$bwStr-SgEv-AllDay"/> </xsl:when> <xsl:when test="end/longdate != start/longdate"> <xsl:value-of select="end/time" /> </xsl:when> <xsl:when test="end/time != start/time"> <xsl:value-of select="end/time" /> </xsl:when> </xsl:choose> <!-- if timezones are not local, or if floating add labels: --> <xsl:if test="start/timezone/islocal = 'false' or end/timezone/islocal = 'false'"> <xsl:text> </xsl:text> -- <xsl:choose> <xsl:when test="start/floating = 'true'"> <xsl:copy-of select="$bwStr-SgEv-FloatingTime"/> </xsl:when> <xsl:otherwise> <xsl:copy-of select="$bwStr-SgEv-LocalTime"/> </xsl:otherwise> </xsl:choose> </xsl:if> <!-- display in timezone if not local or floating time) --> <xsl:if test="(start/timezone/islocal = 'false' or end/timezone/islocal = 'false') and start/floating = 'false'"> <xsl:choose> <xsl:when test="start/timezone/id != end/timezone/id"> <!-- need to display both timezones if they differ from start to end --> <xsl:copy-of select="$bwStr-SgEv-Start"/><xsl:text> </xsl:text> <xsl:choose> <xsl:when test="start/timezone/islocal='true'"> <xsl:value-of select="start/dayname"/>, <xsl:value-of select="start/longdate"/> <xsl:text> </xsl:text> <xsl:value-of select="start/time"/> </xsl:when> <xsl:otherwise> <xsl:value-of select="start/timezone/dayname"/>, <xsl:value-of select="start/timezone/longdate"/> <xsl:text> </xsl:text> <xsl:value-of select="start/timezone/time"/> </xsl:otherwise> </xsl:choose> -- <xsl:value-of select="start/timezone/id"/> | <xsl:copy-of select="$bwStr-SgEv-End"/><xsl:text> </xsl:text> <xsl:choose> <xsl:when test="end/timezone/islocal='true'"> <xsl:value-of select="end/dayname"/>, <xsl:value-of select="end/longdate"/> <xsl:text> </xsl:text> <xsl:value-of select="end/time"/> </xsl:when> <xsl:otherwise> <xsl:value-of select="end/timezone/dayname"/>, <xsl:value-of select="end/timezone/longdate"/> <xsl:text> </xsl:text> <xsl:value-of select="end/timezone/time"/> </xsl:otherwise> </xsl:choose> -- <xsl:value-of select="end/timezone/id"/> </xsl:when> <xsl:otherwise> <!-- otherwise, timezones are the same: display as a single line --> <xsl:value-of select="start/timezone/dayname"/>, <xsl:value-of select="start/timezone/longdate"/><xsl:text> </xsl:text> <xsl:if test="start/allday = 'false'"> <xsl:value-of select="start/timezone/time"/> </xsl:if> <xsl:if test="(end/timezone/longdate != start/timezone/longdate) or ((end/timezone/longdate = start/timezone/longdate) and (end/timezone/time != start/timezone/time))"> - </xsl:if> <xsl:if test="end/timezone/longdate != start/timezone/longdate"> <xsl:value-of select="substring(end/timezone/dayname,1,3)"/>, <xsl:value-of select="end/timezone/longdate"/><xsl:text> </xsl:text> </xsl:if> <xsl:choose> <xsl:when test="start/allday = 'true'"> <xsl:text> </xsl:text><xsl:copy-of select="$bwStr-SgEv-AllDay"/> </xsl:when> <xsl:when test="end/timezone/longdate != start/timezone/longdate"> <xsl:value-of select="end/timezone/time"/> </xsl:when> <xsl:when test="end/timezone/time != start/timezone/time"> <xsl:value-of select="end/timezone/time"/> </xsl:when> </xsl:choose> <xsl:text> </xsl:text> -- <xsl:value-of select="start/timezone/id"/> </xsl:otherwise> </xsl:choose> </xsl:if>",
            "start" : {
              "allday" : "<xsl:value-of select='start/allday'/>",
              "shortdate" : "<xsl:value-of select='start/shortdate'/>",
              "longdate" : "<xsl:value-of select='start/longdate'/>",
              "dayname" : "<xsl:value-of select='start/dayname'/>",
              "time" : "<xsl:value-of select='start/time'/>",
              "utcdate" : "<xsl:value-of select='start/utcdate'/>",
              "datetime" : "<xsl:value-of select='start/unformatted'/>",
              "timezone" : "<xsl:value-of select='start/timezone/id'/>"
            },
            "end" : {
              "allday" : "<xsl:value-of select='end/allday'/>",
              "shortdate" : "<xsl:value-of select='end/shortdate'/>",
              "longdate" : "<xsl:value-of select='end/longdate'/>",
              "dayname" : "<xsl:value-of select='end/dayname'/>",
              "time" : "<xsl:value-of select='end/time'/>",
              "utcdate" : "<xsl:value-of select='end/utcdate'/>",
              "datetime" : "<xsl:value-of select='end/unformatted'/>",
              "timezone" : "<xsl:value-of select='end/timezone/id'/>"
            },
            "location" : {
              <xsl:choose>
                <xsl:when test="location/address = ''">
                  "address" : "<xsl:call-template name="escapeJson"><xsl:with-param name="string" select="xproperties/node()[name()='X-BEDEWORK-LOCATION']/values/text"/></xsl:call-template>",
                </xsl:when>
                <xsl:otherwise>
                  "address" : "<xsl:call-template name="escapeJson"><xsl:with-param name="string" select="location/address"/></xsl:call-template>",
                </xsl:otherwise>
              </xsl:choose>
              "uid" : "<xsl:value-of select='location/uid'/>",
              "name" : "<xsl:value-of select='location/name'/>",
              "room" : "<xsl:choose><xsl:when test="normalize-space(location/roomField) != ''"><xsl:value-of select='location/roomField'/></xsl:when><xsl:otherwise><xsl:call-template name="escapeJson"><xsl:with-param name="string" select="normalize-space(xproperties/X-YALE-LOCATION-ROOM/values/text)"/></xsl:call-template></xsl:otherwise></xsl:choose>",
              "subField1" : "<xsl:value-of select='location/subField1'/>",
              "subField2" : "<xsl:value-of select='location/subField2'/>",
              "accessible" : "<xsl:value-of select='location/accessible'/>",
              "geouri" : "<xsl:value-of select='location/geouri'/>",
              "status" : "<xsl:value-of select='location/status'/>",
              "street" : "<xsl:value-of select='location/street'/>",
              "city" : "<xsl:value-of select='location/city'/>",
              "state" : "<xsl:value-of select='location/state'/>",
              "zip" : "<xsl:value-of select='location/zip'/>",
              "alternateAddress" : "<xsl:value-of select='location/alternateAddress'/>",
              "code" : "<xsl:value-of select='location/code'/>",
              "link" : "<xsl:value-of select='location/link'/>"
            },
            "contact" : {
              "name" : "<xsl:call-template name="escapeJson"><xsl:with-param name="string" select="contact/name"/></xsl:call-template>",
              "phone" : "<xsl:value-of select="contact/phone"/>",
              "email" : "<xsl:value-of select="contact/email"/>",
              "link" : "<xsl:value-of select='contact/link'/>"
            },
            "calendar" : {
              "name" : "<xsl:value-of select='calendar/name'/>",
              "displayName" : "<xsl:value-of select='calendar/summary'/>",
              "path" : "<xsl:value-of select='calendar/path'/>",
              "encodedPath" : "<xsl:value-of select='calendar/encodedPath'/>"
            },
            "categories" : [
              <xsl:for-each select='categories/category'>"<xsl:call-template name="escapeJson"><xsl:with-param name="string" select="value"/></xsl:call-template>"<xsl:if test='position() != last()'>,</xsl:if></xsl:for-each>
            ],
            "description" : "<xsl:call-template name="escapeJson"><xsl:with-param name="string" select="description"/></xsl:call-template>",
            "cost" : "<xsl:call-template name="escapeJson"><xsl:with-param name="string" select="cost"/></xsl:call-template>",
            "xproperties" : [
              <xsl:for-each select="xproperties/node()[name() != '']">
              {
                "<xsl:value-of select='name()'/>" : {
                  <xsl:if test="parameters">
                  "parameters" : {
                     <xsl:for-each select="parameters/node()[name() != '']">
                       "<xsl:value-of select='name()'/>" : "<xsl:call-template name="escapeJson"><xsl:with-param name="string" select="."/></xsl:call-template>"<xsl:if test='position() != last()'>,</xsl:if>
                     </xsl:for-each>
                  },
                  </xsl:if>
                  "values" : {
                     <xsl:for-each select="values/node()[name() != '']">
                       "<xsl:value-of select='name()'/>" : "<xsl:call-template name="escapeJson"><xsl:with-param name="string" select="."/></xsl:call-template>"<xsl:if test='position() != last()'>,</xsl:if>
                     </xsl:for-each>
                  }
                }
              }<xsl:if test='position() != last()'>,</xsl:if></xsl:for-each>

            ]
         }<xsl:if test="position() != last()">,</xsl:if>
  </xsl:template>
</xsl:stylesheet>
