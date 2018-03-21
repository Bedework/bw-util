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
  <xsl:template name="masthead">
    <div id="masthead">
      <!-- user customizable masthead set in themeSettings.xsl -->
      <xsl:copy-of select="$masthead"/>
    </div>

    <div id="statusBar">
      <div id="userInfo">
        <xsl:copy-of select="$bwStr-Hedr-LoggedInAs"/>
          <xsl:text> </xsl:text>
          <strong><xsl:value-of select="/bedework/userid"/></strong>
          <xsl:text> </xsl:text>
        <span class="logout"><a href="{$setup}&amp;logout=true"><xsl:copy-of select="$bwStr-Hedr-Logout"/></a></span>
      </div>
      <xsl:copy-of select="$bwStr-Head-CalendarSuite"/>:
      <xsl:text> </xsl:text>
      <span class="status">
        <xsl:choose>
          <xsl:when test="/bedework/currentCalSuite/name">
            <xsl:value-of select="/bedework/currentCalSuite/name"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:copy-of select="$bwStr-Head-None"/>
          </xsl:otherwise>
        </xsl:choose>
      </span>
    </div>
  </xsl:template>

  <xsl:template name="messagesAndErrors">
    <xsl:if test="/bedework/message">
      <ul id="messages">
        <xsl:for-each select="/bedework/message">
          <li><xsl:apply-templates select="."/></li>
        </xsl:for-each>
      </ul>
    </xsl:if>
    <xsl:if test="/bedework/error">
      <ul id="errors">
        <xsl:for-each select="/bedework/error">
          <li><xsl:apply-templates select="."/></li>
        </xsl:for-each>
      </ul>
    </xsl:if>
  </xsl:template>

  <xsl:template name="menuTabs">
    <ul id="menuTabs">
      <xsl:choose>
        <xsl:when test="/bedework/page='home'">
          <li class="selected"><xsl:copy-of select="$bwStr-MeTa-Overview"/></li>
          <li><a href="{$initEvent}"><xsl:copy-of select="$bwStr-MeTa-AddEvent"/></a></li>
          <li>
            <a>
              <xsl:attribute name="href"><xsl:value-of select="$initPendingEvents"/>&amp;listMode=true&amp;fexpr=(colPath="<xsl:value-of select="$submissionsRootEncoded"/>")</xsl:attribute>
              <xsl:copy-of select="$bwStr-MeTa-MyPendingEvents"/>
            </a>
          </li>
        </xsl:when>
        <xsl:when test="/bedework/page='eventList'">
          <li><a href="{$setup}"><xsl:copy-of select="$bwStr-MeTa-Overview"/></a></li>
          <li><a href="{$initEvent}"><xsl:copy-of select="$bwStr-MeTa-AddEvent"/></a></li>
          <li class="selected"><xsl:copy-of select="$bwStr-MeTa-MyPendingEvents"/></li>
        </xsl:when>
        <xsl:otherwise>
          <li><a href="{$setup}"><xsl:copy-of select="$bwStr-MeTa-Overview"/></a></li>
          <li class="selected"><xsl:copy-of select="$bwStr-MeTa-AddEvent"/></li>
          <li>
            <a>
              <xsl:attribute name="href"><xsl:value-of select="$initPendingEvents"/>&amp;listMode=true&amp;fexpr=(colPath="<xsl:value-of select="$submissionsRootEncoded"/>")</xsl:attribute>
              <xsl:copy-of select="$bwStr-MeTa-MyPendingEvents"/>
            </a>
          </li>
        </xsl:otherwise>
      </xsl:choose>
    </ul>
  </xsl:template>
</xsl:stylesheet>