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

  <!--==== THEME UTILITIES ====-->

  <!-- look for existence of ongoing events as appropriate -->
  <xsl:variable name="ongoingEvents">
    <xsl:choose>
      <xsl:when test="$ongoingEventsEnabled = 'true' and
                     (/bedework/page = 'eventscalendar' or /bedework/page = 'eventList') and
                      /bedework/periodname != 'Year'">
        <xsl:choose>
          <xsl:when test="$ongoingEventsAlwaysDisplayed = 'true'">true</xsl:when>
          <xsl:when test="$ongoingEventsUseCategory = 'true' and
                          /bedework/eventscalendar//event/categories//category/uid = $ongoingEventsCatUid">true</xsl:when>
          <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>false</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

</xsl:stylesheet>
