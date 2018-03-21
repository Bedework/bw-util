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

  <!--==== BANNER and MENU TABS  ====-->

  <xsl:template name="tabs">
    <!-- When workflow is enabled, only show the search form to approvers and superusers (otherwise, show to all) -->
    <xsl:if test="/bedework/workflowEnabled='false' or /bedework/userInfo/superUser='true' or /bedework/userInfo/approverUser='true'">
      <xsl:call-template name="upperSearchForm">
        <xsl:with-param name="toggleLimits">
          <xsl:choose>
            <xsl:when test="/bedework/page='searchResult'">false</xsl:when>
            <xsl:otherwise>true</xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>

    <ul id="bwAdminMenu">
      <li>
        <xsl:if test="/bedework/tab = 'main'">
          <xsl:attribute name="class">selected</xsl:attribute>
        </xsl:if>
        <a href="{$setup}&amp;listMode=true&amp;sort=dtstart.utc:asc">
          <xsl:copy-of select="$bwStr-Head-MainMenu"/>
        </a>
      </li>
      <xsl:if test="/bedework/workflowEnabled='true'">
        <li>
          <xsl:if test="/bedework/tab = 'approvalQueue'">
            <xsl:attribute name="class">selected</xsl:attribute>
          </xsl:if>
          <a>
            <xsl:attribute name="href"><xsl:value-of select="$initApprovalQueueTab"/>&amp;listMode=true&amp;fexpr=(colPath="<xsl:value-of select="$workflowRootEncoded"/>")&amp;sort=dtstart.utc:asc</xsl:attribute>
            <xsl:copy-of select="$bwStr-Head-ApprovalQueueEvents"/>
          </a>
        </li>
      </xsl:if>
      <xsl:if test="/bedework/suggestionEnabled='true' and /bedework/userInfo/approverUser='true'">
        <li>
          <xsl:if test="/bedework/tab = 'suggestionQueue'">
            <xsl:attribute name="class">selected</xsl:attribute>
          </xsl:if>
          <xsl:variable name="suggestedListType">
            <xsl:choose>
              <xsl:when test="/bedework/appvar[key='suggestType']/value = 'A'">A</xsl:when>
              <xsl:when test="/bedework/appvar[key='suggestType']/value = 'R'">R</xsl:when>
              <xsl:otherwise>P</xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <a>
            <xsl:attribute name="href"><xsl:value-of select="$initSuggestionQueueTab"/>&amp;listMode=true&amp;sg=true&amp;start=<xsl:value-of select="$curListDate"/>&amp;fexpr=(colPath="/public/cals/MainCal" and (entity_type="event"|entity_type="todo") and suggested-to="<xsl:value-of select="$suggestedListType"/>:<xsl:value-of
                    select="/bedework/currentCalSuite/groupHref"/>")&amp;master=true&amp;sort=dtstart.utc:asc</xsl:attribute>
            <xsl:copy-of select="$bwStr-Head-SuggestionQueueEvents"/>
          </a>
        </li>
      </xsl:if>
      <li>
        <xsl:if test="/bedework/tab = 'pending'">
          <xsl:attribute name="class">selected</xsl:attribute>
        </xsl:if>
        <a>
          <xsl:variable name="calSuite" select="/bedework/calSuiteName"/>
          <xsl:variable name="calSuiteLimit">
            <xsl:choose>
              <xsl:when test="/bedework/userInfo/superUser = 'true'"></xsl:when>
              <xsl:otherwise> and calSuite='<xsl:value-of select="$calSuite"/>'</xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:attribute name="href"><xsl:value-of select="$initPendingTab"/>&amp;listMode=true&amp;sg=true&amp;start=<xsl:value-of select="$curListDate"/>&amp;fexpr=(colPath="<xsl:value-of select="$submissionsRootEncoded"/>" and (entity_type="event"|entity_type="todo")<xsl:value-of select="$calSuiteLimit"/>)&amp;sort=dtstart.utc:asc</xsl:attribute>
          <xsl:copy-of select="$bwStr-Head-PendingEvents"/>
        </a>
      </li>
      <xsl:if test="/bedework/currentCalSuite/group = /bedework/userInfo/group">
        <xsl:if test="/bedework/currentCalSuite/currentAccess/current-user-privilege-set/privilege/write or /bedework/userInfo/superUser = 'true'">
          <li>
            <xsl:if test="/bedework/tab = 'calsuite'">
              <xsl:attribute name="class">selected</xsl:attribute>
            </xsl:if>
            <a href="{$showCalsuiteTab}">
              <xsl:copy-of select="$bwStr-Head-CalendarSuite"/>
            </a>
          </li>
        </xsl:if>
      </xsl:if>
      <xsl:if test="/bedework/userInfo/superUser='true'">
        <li>
          <xsl:if test="/bedework/tab = 'users'">
            <xsl:attribute name="class">selected</xsl:attribute>
          </xsl:if>
          <a href="{$showUsersTab}">
            <xsl:copy-of select="$bwStr-Head-Users"/>
          </a>
        </li>
        <li>
          <xsl:if test="/bedework/tab = 'system'">
            <xsl:attribute name="class">selected</xsl:attribute>
          </xsl:if>
          <a href="{$showSystemTab}">
            <xsl:copy-of select="$bwStr-Head-System"/>
          </a>
        </li>
      </xsl:if>
    </ul>
    <xsl:call-template name="messagesAndErrors"/>
  </xsl:template>

</xsl:stylesheet>