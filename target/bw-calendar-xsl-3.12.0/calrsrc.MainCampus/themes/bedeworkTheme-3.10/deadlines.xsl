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
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template name="deadlines">
    <h3 class="secondaryColHeaderGray">
      <xsl:copy-of select="$bwStr-Deadline-Title"/>
    </h3>
    <ul class="eventList">
      <xsl:choose>
        <!-- Pick out the tasks -->
        <xsl:when test="/bedework/eventscalendar//event[entityType = 2]">
          <xsl:for-each select="/bedework/eventscalendar/year/month/week/day/event[entityType = 2]">
            <xsl:sort select="start/unformatted" order="ascending" data-type="number"/>
            <xsl:sort select="id" data-type="number"/>
            <xsl:variable name="lastId" select="id"/>
            <xsl:if test="not(preceding::event[id=$lastId])">
              <xsl:call-template name="deadline"/>
            </xsl:if>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <li>
            <xsl:copy-of select="$bwStr-Deadline-NoEvents"/>
          </li>
        </xsl:otherwise>
      </xsl:choose>
    </ul>
  </xsl:template>

  <xsl:template name="deadline">
    <li>
      <xsl:variable name="calPath" select="calendar/encodedPath"/>
      <xsl:variable name="guid" select="guid"/>
      <xsl:variable name="href" select="encodedHref"/>
      <xsl:variable name="recurrenceId" select="recurrenceId"/>
      <xsl:variable name="statusClass">
        <xsl:choose>
          <xsl:when test="status='CANCELLED'">
            bwStatusCancelled
          </xsl:when>
          <xsl:when test="status='TENTATIVE'">
            bwStatusTentative
          </xsl:when>
          <xsl:otherwise>bwStatusConfirmed</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <a href="{$eventView}&amp;href={$href}">
        <xsl:if test="status != 'CONFIRMED'">
          <xsl:value-of select="status"/>
          <xsl:text>: </xsl:text>
        </xsl:if>
        <xsl:value-of select="summary"/>
        <xsl:if test="summary = ''">
          <xsl:copy-of select="$bwStr-SgEv-NoTitle"/>
        </xsl:if>
      </a>,<xsl:copy-of select="$bwStr-SgEv-DueBy"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="end/shortdate"/>
      <xsl:text> </xsl:text>
      <xsl:if test="start/allday = 'false'">
        <xsl:value-of select="end/time"/>
      </xsl:if>
    </li>
  </xsl:template>

</xsl:stylesheet>
