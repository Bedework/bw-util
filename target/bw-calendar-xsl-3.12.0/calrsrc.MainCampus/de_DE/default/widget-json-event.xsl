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
            "encodedHref" : "<xsl:value-of select="encodedHref"/>",
            "link" : "<xsl:value-of select='link'/>",
            "eventlink" : "<xsl:value-of select="$urlPrefix"/><xsl:value-of select="$eventView"/>&amp;calPath=<xsl:value-of select="calendar/encodedPath"/>&amp;guid=<xsl:call-template name="url-encode"><xsl:with-param name="str" select="guid"/></xsl:call-template>&amp;recurrenceId=<xsl:value-of select="recurrenceId"/>",
            "status" : "<xsl:value-of select='status'/>",
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
              "address" : "<xsl:call-template name="escapeJson"><xsl:with-param name="string" select="location/address"/></xsl:call-template>",
              "link" : "<xsl:value-of select='location/link'/>"
            },
            "contact" : {
              "name" : "<xsl:call-template name="escapeJson"><xsl:with-param name="string" select="contact/name"/></xsl:call-template>",
              "phone" : "<xsl:value-of select="contact/phone"/>",<!--
              "email" : "<xsl:value-of select="contact/email"/>", -->
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
                  "parameters" : {
                    <xsl:for-each select="parameters/node()[name() != '']">
                      "<xsl:value-of select='name()'/>" : "<xsl:call-template name="escapeJson"><xsl:with-param name="string" select="."/></xsl:call-template>"<xsl:if test='position() != last()'>,</xsl:if>
                    </xsl:for-each>
                  },
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
