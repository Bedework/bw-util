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
  <xsl:template name="eventList">
    <h1><xsl:copy-of select="$bwStr-EvLs-PendingEvents"/></h1>
    <p>
      <xsl:copy-of select="$bwStr-EvLs-EventsBelowWaiting"/>
    </p>
    <xsl:call-template name="eventListCommon"/>
  </xsl:template>

  <xsl:template name="eventListCommon">
    <table id="commonListTable">
      <tr>
        <th><xsl:copy-of select="$bwStr-EvLC-Title"/></th>
        <th><xsl:copy-of select="$bwStr-EvLC-CalSuite"/></th>
        <th><xsl:copy-of select="$bwStr-EvLC-ClaimedBy"/></th>
        <th><xsl:copy-of select="$bwStr-EvLC-Start"/></th>
        <th><xsl:copy-of select="$bwStr-EvLC-End"/></th>
        <th><xsl:copy-of select="$bwStr-EvLC-TopicalAreas"/></th>
        <th><xsl:copy-of select="$bwStr-EvLC-Description"/></th>
      </tr>

      <xsl:for-each select="/bedework/events/event">
        <xsl:variable name="calPath" select="calendar/encodedPath"/>
        <xsl:variable name="calSuite" select="calSuite"/>
        <xsl:variable name="guid" select="guid"/>
        <xsl:variable name="recurrenceId" select="recurrenceId"/>
        <tr>
          <td>
            <a href="{$editEvent}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}&amp;cs={$calSuite}">
              <xsl:choose>
                <xsl:when test="summary != ''">
                  <xsl:value-of select="summary"/>
                </xsl:when>
                <xsl:otherwise>
                  <em><xsl:copy-of select="$bwStr-EvLC-NoTitle"/></em>
                </xsl:otherwise>
              </xsl:choose>
            </a>
          </td>
          <td>
            <xsl:value-of select="calSuite"/>
          </td>
          <xsl:choose>
            <xsl:when test="xproperties/X-BEDEWORK-SUBMISSION-CLAIMANT">
              <td>
                <xsl:value-of select="xproperties/X-BEDEWORK-SUBMISSION-CLAIMANT/values/text"/>
                <xsl:text> </xsl:text>
                (<xsl:value-of select="xproperties/X-BEDEWORK-SUBMISSION-CLAIMANT/parameters/X-BEDEWORK-SUBMISSION-CLAIMANT-USER"/>)
              </td>
            </xsl:when>
            <xsl:otherwise>
              <td class="unclaimed"><xsl:copy-of select="$bwStr-EvLC-Unclaimed"/></td>
            </xsl:otherwise>
          </xsl:choose>
          <td class="date">
            <xsl:value-of select="start/shortdate"/>
                <xsl:text> </xsl:text>
                <xsl:choose>
                  <xsl:when test="start/allday = 'false'">
                    <xsl:value-of select="start/time"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:copy-of select="$bwStr-FoEl-AllDay"/>
                  </xsl:otherwise>
                </xsl:choose>
          </td>
          <td class="date">
            <xsl:value-of select="end/shortdate"/>
                <xsl:text> </xsl:text>
                <xsl:choose>
                  <xsl:when test="start/allday = 'false'">
                    <xsl:value-of select="end/time"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:copy-of select="$bwStr-FoEl-AllDay"/>
                  </xsl:otherwise>
                </xsl:choose>
          </td>
          <td>
            <xsl:for-each select="xproperties/X-BEDEWORK-SUBMIT-ALIAS">
              <xsl:value-of select="parameters/X-BEDEWORK-PARAM-DISPLAYNAME"/><br/> 
            </xsl:for-each>
          </td>
          <td>
            <xsl:value-of select="description"/>
            <xsl:if test="recurring = 'true' or recurrenceId != ''">
              <div class="recurrenceEditLinks">
                <xsl:copy-of select="$bwStr-EvLC-RecurringEvent"/>
                <xsl:copy-of select="$bwStr-EvLC-Edit"/>
                <xsl:text> </xsl:text>
                <a href="{$editEvent}&amp;calPath={$calPath}&amp;guid={$guid}">
                  <xsl:copy-of select="$bwStr-EvLC-Master"/>
                </a> |
                <a href="{$editEvent}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}&amp;cs={$calSuite}">
                  <xsl:copy-of select="$bwStr-EvLC-Instance"/>
                </a>
              </div>
            </xsl:if>
          </td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>
</xsl:stylesheet>