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

<xsl:template match='/'>"summary","subscriptionId","calPath","guid","recurrenceId","link","eventlink","status",<!--
-->"startallday","startshortdate","startlongdate","startdayname","starttime","startutcdate","startdatetime","starttimezone",<!--
-->"endallday","endshortdate","endlongdate","enddayname","endtime","endutcdate","enddatetime","endtimezone",<!--
-->"locationaddress","locationlink",<!--
-->"contactname","contactphone","contactlink",<!--
-->"calendarname","calendardisplayName","calendarpath","calendarencodedPath",<!--
-->"categories","description","cost",<!--
-->"xproperties"
<xsl:for-each select="/bedework/events/event"><!--
-->"<xsl:call-template name="escapeJson"><xsl:with-param name="string" select="summary"/></xsl:call-template>",<!--
-->"<xsl:value-of select="subscription/id"/>",<!--
-->"<xsl:value-of select="calendar/encodedPath"/>",<!--
-->"<xsl:call-template name="url-encode"><xsl:with-param name="str" select="guid"/></xsl:call-template>",<!--
-->"<xsl:value-of select="recurrenceId"/>",<!--
-->"<xsl:value-of select='link'/>",<!--
-->"<xsl:value-of select="$urlPrefix"/><xsl:value-of select="$eventView"/><xsl:text disable-output-escaping="yes"><![CDATA[&]]></xsl:text>calPath=<xsl:value-of select="calendar/encodedPath"/><xsl:text disable-output-escaping="yes"><![CDATA[&]]></xsl:text>guid=<xsl:call-template name="url-encode"><xsl:with-param name="str" select="guid"/></xsl:call-template><xsl:text disable-output-escaping="yes"><![CDATA[&]]></xsl:text>recurrenceId=<xsl:value-of select="recurrenceId"/>",<!--
-->"<xsl:value-of select='status'/>",<!--
-->"<xsl:value-of select='start/allday'/>",<!--
-->"<xsl:value-of select='start/shortdate'/>",<!--
-->"<xsl:value-of select='start/longdate'/>",<!--
-->"<xsl:value-of select='start/dayname'/>",<!--
-->"<xsl:value-of select='start/time'/>",<!--
-->"<xsl:value-of select='start/utcdate'/>",<!--
-->"<xsl:value-of select='start/unformatted'/>",<!--
-->"<xsl:value-of select='start/timezone/id'/>",<!--
-->"<xsl:value-of select='end/allday'/>",<!--
-->"<xsl:value-of select='end/shortdate'/>",<!--
-->"<xsl:value-of select='end/longdate'/>",<!--
-->"<xsl:value-of select='end/dayname'/>",<!--
-->"<xsl:value-of select='end/time'/>",<!--
-->"<xsl:value-of select='end/utcdate'/>",<!--
-->"<xsl:value-of select='end/unformatted'/>",<!--
-->"<xsl:value-of select='end/timezone/id'/>",<!--
-->"<xsl:call-template name="escapeJson"><xsl:with-param name="string" select="location/address"/></xsl:call-template>",<!--
-->"<xsl:value-of select='location/link'/>",<!--
-->"<xsl:call-template name="escapeJson"><xsl:with-param name="string" select="contact/name"/></xsl:call-template>",<!--
-->"<xsl:value-of select="contact/phone"/>",<!--
-->"<xsl:value-of select='contact/link'/>",<!--
-->"<xsl:value-of select='calendar/name'/>",<!--
-->"<xsl:value-of select='calendar/summary'/>",<!--
-->"<xsl:value-of select='calendar/path'/>",<!--
-->"<xsl:value-of select='calendar/encodedPath'/>",<!--
-->"<xsl:for-each select='categories/category'><xsl:call-template name="escapeJson"><xsl:with-param name="string" select="value"/></xsl:call-template><xsl:if test='position() != last()'>,</xsl:if></xsl:for-each>",<!--
-->"<xsl:call-template name="escapeJson"><xsl:with-param name="string" select="description"/></xsl:call-template>",<!--
-->"<xsl:call-template name="escapeJson"><xsl:with-param name="string" select="cost"/></xsl:call-template>",<!--
-->"<xsl:for-each select="xproperties/node()[name() != '']"><xsl:value-of select='name()'/> : values : <xsl:for-each select="values/node()[name() != '']"><xsl:value-of select='name()'/> : <xsl:call-template name="escapeJson"><xsl:with-param name="string" select="."/></xsl:call-template><xsl:if test='position() != last()'>,</xsl:if></xsl:for-each><xsl:if test='position() != last()'>,</xsl:if></xsl:for-each>"
</xsl:for-each></xsl:template></xsl:stylesheet>
