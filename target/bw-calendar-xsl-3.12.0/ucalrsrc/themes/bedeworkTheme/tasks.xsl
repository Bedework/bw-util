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
  
  <!--== TASKS ==-->
  <xsl:template name="tasks">
    <xsl:if test="/bedework/eventscalendar//event[entityType=2]">
      <div id="tasks">
        <h3>
          <xsl:copy-of select="$bwStr-Task-Tasks"/> &amp; <xsl:copy-of select="$bwStr-Task-Reminders"/>
        </h3>
        <ul class="tasks">
          <xsl:apply-templates select="/bedework/eventscalendar//event[entityType=2 and generate-id() = generate-id(key('eventUid',guid)[1])]" mode="tasks"/>
        </ul>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template match="event" mode="tasks">
    <xsl:variable name="calPath" select="calendar/encodedPath"/>
    <xsl:variable name="guid"><xsl:call-template name="url-encode"><xsl:with-param name="str" select="guid"/></xsl:call-template></xsl:variable>
    <xsl:variable name="recurrenceId" select="recurrenceId"/>

    <li>
      <a href="{$eventView}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
        <xsl:choose>
          <xsl:when test="summary = ''">
            <em><xsl:copy-of select="$bwStr-TskE-NoTitle"/></em><xsl:text> </xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="summary"/>
            <xsl:if test="not(start/noStart='true')">
              <span class="taskDate"> - <xsl:copy-of select="$bwStr-TskE-Start"/><xsl:text> </xsl:text><xsl:value-of select="start/shortdate"/></span>
            </xsl:if>
            <xsl:if test="not(end/type='N')">
              <span class="taskDate">- <xsl:copy-of select="$bwStr-TskE-Due"/><xsl:text> </xsl:text><xsl:value-of select="end/shortdate"/></span>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
      </a>
    </li>
  </xsl:template>
  
  
</xsl:stylesheet>