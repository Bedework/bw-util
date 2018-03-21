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
  <xsl:output method="xml" indent="yes" media-type="text/html"
              standalone="yes" omit-xml-declaration="yes" />

  <xsl:include href="./themeSettings.xsl"/>
  <xsl:include href="./head.xsl"/>
  <xsl:include href="./headerAndNav.xsl"/>
  <xsl:include href="./addEventForm.xsl"/>
  <xsl:include href="./eventList.xsl"/>
  <xsl:include href="./upload.xsl"/>
  <xsl:include href="./footer.xsl"/>


 <!-- BEGIN MAIN TEMPLATE -->
  <xsl:template match="/">
<xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html></xsl:text><!-- HTML5 -->
    <html lang="en">
      <head>
        <xsl:call-template name="headSection"/>
      </head>
      <body>
        <xsl:choose>
          <xsl:when test="/bedework/page = 'addEvent'">
            <xsl:attribute name="onload">focusElement('bwEventTitle');bwSetupDatePickers();</xsl:attribute>
          </xsl:when>
          <xsl:when test="/bedework/page = 'editEvent'">
            <xsl:attribute name="onload">initRXDates();initXProperties();bwSetupDatePickers();</xsl:attribute>
          </xsl:when>
        </xsl:choose>
        <div id="bedework"><!-- main wrapper div -->
          <header id="header">
            <xsl:call-template name="masthead" />
          </header>
          <xsl:call-template name="messagesAndErrors"/>
          <xsl:call-template name="menuTabs"/>
          <div id="bodyContent">
            <xsl:choose>
              <xsl:when test="/bedework/page='addEvent'">
                <xsl:apply-templates select="/bedework/formElements" mode="addEvent"/>
              </xsl:when>
              <xsl:when test="/bedework/page='eventList'">
                <xsl:call-template name="eventList"/>
              </xsl:when>
              <xsl:when test="/bedework/page='editEvent'">
                <xsl:apply-templates select="/bedework/formElements" mode="editEvent"/>
              </xsl:when>
              <xsl:when test="/bedework/page='upload'">
                <xsl:call-template name="upload" />
              </xsl:when>
              <xsl:otherwise>
                <!-- home / entrance screen -->
                <xsl:call-template name="home"/>
              </xsl:otherwise>
            </xsl:choose>
          </div>
          <!-- footer -->
          <footer id="footer" class="row">
            <xsl:call-template name="footer"/>
          </footer>
        </div>
      </body>
    </html>
  </xsl:template>

  <!--==== HOME ====-->
  <xsl:template name="home">
    <div class="navButtons navBox">
      <a href="{$initEvent}"><xsl:copy-of select="$bwStr-Home-Start"/>
        <img alt="previous"
          src="{$resourcesRoot}/images/arrowRight.gif"
          width="13"
          height="13"/>
      </a>
    </div>
    <h1><xsl:copy-of select="$bwStr-Home-EnteringEvents"/></h1>
    <ol id="introduction">
      <li>
        <xsl:copy-of select="$bwStr-Home-BeforeSubmitting"/><xsl:text> </xsl:text><a href="/cal"><xsl:copy-of select="$bwStr-Home-SeeIfItHasBeenEntered"/></a>.<xsl:text> </xsl:text><xsl:copy-of select="$bwStr-Home-ItIsPossible"/>
      </li>
      <li>
        <xsl:copy-of select="$bwStr-Home-MakeYourTitles"/>
      </li>
      <li>
        <xsl:copy-of select="$bwStr-Home-DoNotInclude"/>
      </li>
    </ol>
  </xsl:template>

  <!--==== ADD EVENT ====-->
  <xsl:template match="formElements" mode="addEvent">
    <xsl:variable name="submitter">
      <xsl:choose>
        <xsl:when test="form/xproperties/node()[name()='X-BEDEWORK-SUBMITTEDBY']"><xsl:value-of select="form/xproperties/node()[name()='X-BEDEWORK-SUBMITTEDBY']/values/text"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="/bedework/userid"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <form name="eventForm" method="post" action="{$addEvent}" id="standardForm" onsubmit="return setEventFields(this,{$portalFriendly},'{$submitter}');">
      <xsl:apply-templates select="." mode="eventForm"/>
    </form>
  </xsl:template>

  <!--==== EDIT EVENT ====-->
  <xsl:template match="formElements" mode="editEvent">
    <xsl:variable name="submitter">
      <xsl:choose>
        <xsl:when test="form/xproperties/node()[name()='X-BEDEWORK-SUBMITTEDBY']"><xsl:value-of select="form/xproperties/node()[name()='X-BEDEWORK-SUBMITTEDBY']/values/text"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="/bedework/userid"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <form name="eventForm" method="post" action="{$updateEvent}" id="standardForm" onsubmit="return setEventFields(this,{$portalFriendly},'{$submitter}');">
      <xsl:apply-templates select="." mode="eventForm"/>
    </form>
  </xsl:template>

  <xsl:template name="byDayChkBoxList">
    <xsl:param name="name"/>
    <xsl:for-each select="/bedework/shortdaynames/val">
      <xsl:variable name="pos" select="position()"/>
      <input type="checkbox">
        <xsl:attribute name="value"><xsl:value-of select="/bedework/recurdayvals/val[position() = $pos]"/></xsl:attribute>
        <xsl:attribute name="name"><xsl:value-of select="$name"/></xsl:attribute>
      </input>
      <xsl:value-of select="."/>
    </xsl:for-each>
  </xsl:template>

  <!--==== UTILITY TEMPLATES ====-->

  <!-- time formatter (should be extended as needed) -->
  <xsl:template name="timeFormatter">
    <xsl:param name="timeString"/><!-- required -->
    <xsl:param name="showMinutes">yes</xsl:param>
    <xsl:param name="showAmPm">yes</xsl:param>
    <xsl:param name="hour24">no</xsl:param>
    <xsl:variable name="hour" select="number(substring($timeString,1,2))"/>
    <xsl:variable name="minutes" select="substring($timeString,3,2)"/>
    <xsl:variable name="AmPm">
      <xsl:choose>
        <xsl:when test="$hour &lt; 12"><xsl:copy-of select="$bwStr-TiFo-AM"/></xsl:when>
        <xsl:otherwise><xsl:copy-of select="$bwStr-TiFo-PM"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="hour24 = 'yes'">
        <xsl:value-of select="$hour"/><!--
     --><xsl:if test="$showMinutes = 'yes'">:<xsl:value-of select="$minutes"/></xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$hour = 0">12</xsl:when>
          <xsl:when test="$hour &lt; 13"><xsl:value-of select="$hour"/></xsl:when>
          <xsl:otherwise><xsl:value-of select="$hour - 12"/></xsl:otherwise>
        </xsl:choose><!--
     --><xsl:if test="$showMinutes = 'yes'">:<xsl:value-of select="$minutes"/></xsl:if>
        <xsl:if test="$showAmPm = 'yes'">
          <xsl:text> </xsl:text>
          <xsl:value-of select="$AmPm"/>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>