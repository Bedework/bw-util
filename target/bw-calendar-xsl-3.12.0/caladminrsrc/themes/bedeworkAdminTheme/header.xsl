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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:CSS="http://calendarserver.org/ns/" xmlns:DAV="DAV:" xmlns:C="urn:ietf:params:xml:ns:caldav" xmlns:BW="http://bedeworkcalserver.org/ns/" xmlns:BSS="http://bedework.org/ns/">

  <!--==== BANNER and MENU TABS  ====-->

  <xsl:template name="header">
    <div id="header">
      <a href="/bedework/">
        <img id="logo"
             alt="Bedework Logo"
             src="{$resourcesRoot}/images/bedeworkAdminLogo.gif"
             width="217"
             height="40"/>
      </a>
      <h1>
        <xsl:copy-of select="$bwStr-Head-BedeworkPubEventsAdmin"/>
      </h1>
    </div>
    <div id="statusBar">
      <div id="userInfo">
        <xsl:if test="/bedework/userInfo/user">
          <span id="groupDisplay">
            <xsl:copy-of select="$bwStr-Head-Group"/>
            <xsl:text> </xsl:text>
            <span class="status">
              <xsl:choose>
                <xsl:when test="/bedework/userInfo/group">
                  <xsl:value-of select="/bedework/userInfo/group"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:copy-of select="$bwStr-Head-None"/>
                </xsl:otherwise>
              </xsl:choose>
            </span>
            <xsl:text> </xsl:text>
            <xsl:if test="(/bedework/userInfo/group and /bedework/userInfo/oneGroup = 'false') or /bedework/userInfo/superUser = 'true'">
              <a href="{$admingroup-switch}" class="fieldInfo">
                <xsl:copy-of select="$bwStr-Head-Change"/>
              </a>
            </xsl:if>
            <xsl:text> </xsl:text>
          </span>
          <xsl:copy-of select="$bwStr-Head-LoggedInAs"/>
          <xsl:text> </xsl:text>
          <span class="status">
            <xsl:value-of select="/bedework/userInfo/currentUser"/>
          </span>
          <xsl:text> </xsl:text>
          <a href="{$logout}" id="bwLogoutButton" class="fieldInfo">
            <xsl:copy-of select="$bwStr-Head-LogOut"/>
          </a>
        </xsl:if>
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
      <!-- notification menu - only display if calsuite is active -->
      <xsl:if test="/bedework/currentCalSuite/name">
        <xsl:call-template name="notifications"/>
      </xsl:if>
    </div>
  </xsl:template>

</xsl:stylesheet>