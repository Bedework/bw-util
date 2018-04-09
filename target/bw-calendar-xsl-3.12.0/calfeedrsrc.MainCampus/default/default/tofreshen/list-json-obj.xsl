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
       Bedework v3.4.x, Arlen Johnson

       Purpose: produces an array of javascript objects representing events.

       Usage: call the JSON feed from an html file by embedding a script tag.
       Examples:

       The next four days (max days = 31):
       <script src="http://localhost:8080/cal/main/listEvents.do?days=4&skinName=json-list-src" type="text/javascript"></script>

       A range of dates:
       <script src="http://localhost:8080/cal/main/listEvents.do?start=2008-10-03&end=2008-11-02&skinName=json-list-src" type="text/javascript"></script>

       The next ten days limited by category (you can append as many categories as you like):
       <script src="http://localhost:8080/cal/main/listEvents.do?days=10&cat=Concerts&skinName=json-list-src" type="text/javascript"></script>

       Filters: Arbitrary filters can be sent to this stylesheet using the query
       parameter "setappvar=filter(somekey:somevalue)".  Group (creator) and
       location filters are included here, but you can add more under line 82.

       The next ten days filtered by a group (creator):
       <script src="http://localhost:8080/cal/main/listEvents.do?days=10&setappvar=filter(creator:agrp_Library)&skinName=json-list-src" type="text/javascript"></script>

       Object name: The json object name can be passed by adding
       "setappvar=objName(myobjname)" to the query string, allowing multiple
       json object calls on the same html page.  If objName is not supplied,
       the default name is "bwObject".  e.g.:
       <script src="http://localhost:8080/cal/main/listEvents.do?days=4&setappvar(objName=myobj)&skinName=json-list-src" type="text/javascript"></script>
  -->

  <!-- DEFINE INCLUDES -->
  <!-- util.xsl belongs in bedework-common on your application server for use
       by all stylesheets: -->
  <xsl:include href="/bedework-common/default/default/util.xsl"/>

  <xsl:variable name="urlprefix" select="/bedework/urlprefix"/>
  <xsl:variable name="eventView" select="/bedework/urlPrefixes/event/eventView"/>
  <xsl:template match='/'>
    <xsl:choose>
      <xsl:when test="/bedework/appvar/key = 'objName'">
        var <xsl:value-of select="/bedework/appvar[key='objName']/value"/> = {'bwEventList': {
      </xsl:when>
      <xsl:otherwise>
        var bwObject = {'bwEventList': {
      </xsl:otherwise>
    </xsl:choose>
        'events': [
          <xsl:choose>
            <xsl:when test="/bedework/appvar/key = 'filter'">
              <xsl:variable name="filterName" select="substring-before(/bedework/appvar[key='filter']/value,':')"/>
              <xsl:variable name="filterVal" select="substring-after(/bedework/appvar[key='filter']/value,':')"/>
              <!-- Define filters here: -->
              <xsl:choose>
                <xsl:when test="$filterName = 'creator'">
                  <xsl:apply-templates select="/bedework/events//event[creator = $filterVal]"/>
                </xsl:when>
                <xsl:when test="$filterName = 'location'">
                  <xsl:apply-templates select="/bedework/events//event[location/address = $filterVal]"/>
                </xsl:when>
                <xsl:otherwise>
                  <!-- Filter name not defined? Turn off filtering. -->
                  <xsl:apply-templates select="/bedework/events//event"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="/bedework/events//event"/>
            </xsl:otherwise>
          </xsl:choose>
        ]
    }}
  </xsl:template>

  <xsl:template match="event">
    <!-- first, escape apostrophes -->
    <xsl:variable name="aposStrippedSummary">
      <xsl:call-template name="replace">
        <xsl:with-param name="string" select="summary"/>
        <xsl:with-param name="pattern" select='"&apos;"'/>
        <xsl:with-param name="replacement" select='"\&apos;"'/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="aposStrippedDescription">
      <xsl:call-template name="replace">
        <xsl:with-param name="string" select="description"/>
        <xsl:with-param name="pattern" select='"&apos;"'/>
        <xsl:with-param name="replacement" select='"\&apos;"'/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="aposStrippedLocAddress">
      <xsl:call-template name="replace">
        <xsl:with-param name="string" select="location/address"/>
        <xsl:with-param name="pattern" select='"&apos;"'/>
        <xsl:with-param name="replacement" select='"\&apos;"'/>
      </xsl:call-template>
    </xsl:variable>
    <!-- second, strip line breaks -->
    <xsl:variable name="strippedSummary" select='translate($aposStrippedSummary,"&#xA;"," ")'/>
    <xsl:variable name="strippedDescription" select='translate($aposStrippedDescription,"&#xA;"," ")'/>
    <xsl:variable name="strippedLocAddress" select='translate($aposStrippedLocAddress,"&#xA;"," ")'/>
    <!-- finally, produce the JSON output -->
            {
                'summary' : '<xsl:value-of select="$strippedSummary"/>',
                'subscriptionId' : '<xsl:value-of select="subscription/id"/>',
                'calPath' : '<xsl:value-of select="calendar/encodedPath"/>',
                'guid' : '<xsl:call-template name="url-encode"><xsl:with-param name="str" select="guid"/></xsl:call-template>',
                'recurrenceId' : '<xsl:value-of select="recurrenceId"/>',
                'link' : '<xsl:value-of select='link'/>',
                'eventlink' : '<xsl:value-of select="$urlprefix"/><xsl:value-of select="$eventView"/>&amp;calPath=<xsl:value-of select="calendar/encodedPath"/>&amp;guid=<xsl:call-template name="url-encode"><xsl:with-param name="str" select="guid"/></xsl:call-template>&amp;recurrenceId=<xsl:value-of select="recurrenceId"/>', // link of this event
                'status' : '<xsl:value-of select='status'/>',
                'start' : {
                    'allday' : '<xsl:value-of select='start/allday'/>',
                    'shortdate' : '<xsl:value-of select='start/shortdate'/>',
                    'longdate' : '<xsl:value-of select='start/longdate'/>',
                    'dayname' : '<xsl:value-of select='start/dayname'/>',
                    'time' : '<xsl:value-of select='start/time'/>',
                    'utcdate' : '<xsl:value-of select='start/utcdate'/>',
                    'datetime' : '<xsl:value-of select='start/unformatted'/>',
                    'timezone' : '<xsl:value-of select='start/timezone/id'/>'
                },
                'end' : {
                    'allday' : '<xsl:value-of select='end/allday'/>',
                    'shortdate' : '<xsl:value-of select='end/shortdate'/>',
                    'longdate' : '<xsl:value-of select='end/longdate'/>',
                    'dayname' : '<xsl:value-of select='end/dayname'/>',
                    'time' : '<xsl:value-of select='end/time'/>',
                    'utcdate' : '<xsl:value-of select='end/utcdate'/>',
                    'datetime' : '<xsl:value-of select='end/unformatted'/>',
                    'timezone' : '<xsl:value-of select='end/timezone/id'/>'
                },
                'location' : {
                    'address' : '<xsl:value-of select="$strippedLocAddress"/>',
                    'link' : '<xsl:value-of select='location/link'/>'
                },
                'calendar' : {
                    'name' : '<xsl:value-of select='calendar/name'/>',
                    'displayName' : '<xsl:value-of select='calendar/summary'/>',
                    'path' : '<xsl:value-of select='calendar/path'/>',
                    'encodedPath' : '<xsl:value-of select='calendar/encodedPath'/>'
                },
                'categories' : [
                    <xsl:for-each select='categories/category'>'<xsl:value-of select='value'/>'<xsl:if test='position() != last()'>,</xsl:if></xsl:for-each>
                ],
                'description' : '<xsl:value-of select='$strippedDescription'/>',
                'xproperties' : {
                  <xsl:for-each select="xproperties/node()[name() != '']">
                    '<xsl:value-of select='name()'/>' : {
                       'values' : {
                           <xsl:for-each select="values/node()[name() != '']">
                             '<xsl:value-of select='name()'/>' : '<xsl:call-template name="replace"><xsl:with-param name="string" select="."/><xsl:with-param name="pattern" select='"&apos;"'/><xsl:with-param name="replacement" select='"\&apos;"'/></xsl:call-template>'<xsl:if test='position() != last()'>,</xsl:if>
                           </xsl:for-each>
                        }
                    }<xsl:if test='position() != last()'>,</xsl:if>
                  </xsl:for-each>
                }
            }<xsl:if test="position() != last()">,</xsl:if>
  </xsl:template>
</xsl:stylesheet>
