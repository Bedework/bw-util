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
<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml">

<xsl:output
  method="xml"
  indent="no"
  media-type="text/html"
  doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
  doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
  standalone="yes"
  omit-xml-declaration="yes"/>

  <!-- Bring in settings and included xsl -->
  <xsl:include href="globals.xsl"/>
  <xsl:include href="../strings.xsl"/>
  <!-- Provides event template -->
  <xsl:include href="./xsl/htmlEvent.xsl"/>
  <!-- Provides category filter templates -->
  <xsl:include href="./xsl/htmlCategoryFiltering.xsl"/>


  <!-- MAIN TEMPLATE -->
  <xsl:template match="/">
    <html lang="en">
      <head>
        <title><xsl:copy-of select="$bwStr-Root-PageTitle"/></title>
        <meta content="text/html;charset=utf-8" http-equiv="Content-Type" />
        <link rel="stylesheet" href="{$resourcesRoot}/css/list-html.css"/>
        <!-- load javascript -->
        <xsl:if test="/bedework/page='event'">
          <script type="text/javascript" src="/bedework-common/javascript/jquery/jquery-1.3.2.min.js">&#160;</script>
          <script type="text/javascript" src="/bedework-common/javascript/jquery/jquery-ui-1.7.1.custom.min.js">&#160;</script>
          <link rel="stylesheet" href="/bedework-common/javascript/jquery/css/custom-theme/jquery-ui-1.7.1.custom.css"/>
          <link rel="stylesheet" href="/bedework-common/javascript/jquery/css/custom-theme/bedeworkJquery.css"/>
          <script type="text/javascript" src="/bedework-common/javascript/bedework.js">&#160;</script>
        </xsl:if>
        <!-- address bar icon -->
        <link rel="icon" type="image/ico" href="{$resourcesRoot}/images/bedework.ico" />
      </head>
      <body>
        <xsl:if test="/bedework/error">
          <div id="errors">
            <xsl:apply-templates select="/bedework/error"/>
          </div>
        </xsl:if>
        <xsl:choose>
          <xsl:when test="/bedework/page='event'">
            <!-- show an event -->
            <xsl:apply-templates select="/bedework/event"/>
          </xsl:when>
          <xsl:when test="/bedework/page='eventList'">
            <!-- show a list of discrete events in a time period -->
            <xsl:apply-templates select="/bedework/events" mode="eventList"/>
          </xsl:when>
        </xsl:choose>
      </body>
    </html>
  </xsl:template>

  <!--==== LIST EVENTS - for listing discrete events ====-->
  <xsl:template match="events" mode="eventList">
    <div id="listEvents">
      <ul>
        <xsl:choose>
          <xsl:when test="not(event)">
            <li><xsl:copy-of select="$bwStr-LsEv-NoEventsToDisplay"/></li>
          </xsl:when>
          <xsl:otherwise>
            <xsl:for-each select="event">

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
                  <xsl:call-template name="processListEvent" />
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="processListEvent" />
            </xsl:otherwise>
          </xsl:choose>

            </xsl:for-each>
          </xsl:otherwise>
        </xsl:choose>
      </ul>
    </div>
  </xsl:template>

  <xsl:template name="buildListEventsDaysOptions">
    <xsl:param name="i">1</xsl:param>
    <xsl:param name="total">31</xsl:param>
    <xsl:param name="default">7</xsl:param>
    <xsl:variable name="selected"><xsl:value-of select="/bedework/appvar[key='listEventsDays']/value"/></xsl:variable>

    <option onclick="this.form.setappvar.value='listEventsDay({$i})'">
      <xsl:attribute name="value"><xsl:value-of select="$i"/></xsl:attribute>
      <xsl:if test="($selected != '' and $i = $selected) or ($selected = '' and $i = $default)"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
      <xsl:value-of select="$i"/>
    </option>

    <xsl:if test="$i &lt; $total">
      <xsl:call-template name="buildListEventsDaysOptions">
        <xsl:with-param name="i"><xsl:value-of select="$i + 1"/></xsl:with-param>
        <xsl:with-param name="total"><xsl:value-of select="$total"/></xsl:with-param>
        <xsl:with-param name="default"><xsl:value-of select="$default"/></xsl:with-param>
      </xsl:call-template>
    </xsl:if>

  </xsl:template>

<xsl:template name="processListEvent">
 <xsl:variable name="id" select="id"/>
 <xsl:variable name="calPath" select="calendar/encodedPath"/>
 <xsl:variable name="guid" select="guid"/>
 <xsl:variable name="recurrenceId" select="recurrenceId"/>
 <li>
   <xsl:attribute name="class">
     <xsl:choose>
       <xsl:when test="status='CANCELLED'">bwStatusCancelled</xsl:when>
       <xsl:when test="status='TENTATIVE'">bwStatusTentative</xsl:when>
       <xsl:otherwise>bwStatusConfirmed</xsl:otherwise>
     </xsl:choose>
   </xsl:attribute>

   <xsl:if test="status='CANCELLED'"><strong><xsl:copy-of select="$bwStr-LsEv-Canceled"/><xsl:text> </xsl:text></strong></xsl:if>
   <xsl:if test="status='TENTATIVE'"><em><xsl:copy-of select="$bwStr-LsEv-Tentative"/><xsl:text> </xsl:text></em></xsl:if>
   <a href="{$publicCal}/event/eventView.do?calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
     <xsl:value-of select="summary"/>
   </a>

   <xsl:if test="/bedework/appvar[key='dl']/value = 'true'">
     <xsl:text> </xsl:text>
     <xsl:variable name="eventIcalName" select="concat($id,'.ics')"/>
     <a href="{$bwCacheHostUrl}/v1.0/download/{$recurrenceId}/{$guid}/{$eventIcalName}" title="{$bwStr-SgEv-DownloadEvent}">
       <img src="{$resourcesRoot}/images/std-ical_icon_small.gif" width="12" height="16" border="0" alt="{$bwStr-LsEv-DownloadEvent}"/>
     </a>
   </xsl:if>
   <br/>

   <xsl:value-of select="substring(start/dayname,1,3)"/>,
   <xsl:value-of select="start/longdate"/>
   <xsl:text> </xsl:text>
   <xsl:if test="start/allday != 'true'">
     <xsl:value-of select="start/time"/>
   </xsl:if>
   <xsl:choose>
     <xsl:when test="start/shortdate != end/shortdate">
       -
       <xsl:value-of select="substring(end/dayname,1,3)"/>,
       <xsl:value-of select="end/longdate"/>
       <xsl:text> </xsl:text>
       <xsl:if test="start/allday != 'true'">
         <xsl:value-of select="end/time"/>
       </xsl:if>
     </xsl:when>
     <xsl:otherwise>
       <xsl:if test="start/time != end/time">
         -
         <xsl:value-of select="end/time"/>
       </xsl:if>
     </xsl:otherwise>
   </xsl:choose>

   <br/>
   <xsl:if test="location/address != ''"><xsl:value-of select="location/address"/></xsl:if>
   <xsl:if test="/bedework/appvar[key='listEventsSummaryMode']/value='details'">
     <xsl:if test="location/subaddress != ''">
       , <xsl:value-of select="location/subaddress"/>
     </xsl:if>
   </xsl:if>

   <xsl:if test="/bedework/appvar[key='details']/value='true'">
     <br/>
     <xsl:value-of select="description"/>
     <xsl:if test="link != ''">
       <br/>
       <xsl:variable name="link" select="link"/>
       <a href="{$link}" class="moreLink"><xsl:value-of select="link"/></a>
     </xsl:if>
     <xsl:if test="categories/category">
       <br/>
       <xsl:copy-of select="$bwStr-LsEv-Categories"/>
       <xsl:for-each select="categories/category">
         <xsl:value-of select="value"/><xsl:if test="position() != last()">, </xsl:if>
       </xsl:for-each>
     </xsl:if>
     <br/>
     <em>
       <xsl:if test="cost!=''">
         <xsl:value-of select="cost"/>.&#160;
       </xsl:if>
       <xsl:if test="contact/name!='none'">
         <xsl:copy-of select="$bwStr-LsEv-Contact"/><xsl:text> </xsl:text><xsl:value-of select="contact/name"/>
       </xsl:if>
     </em>
   </xsl:if>
 </li>
</xsl:template>

</xsl:stylesheet>
