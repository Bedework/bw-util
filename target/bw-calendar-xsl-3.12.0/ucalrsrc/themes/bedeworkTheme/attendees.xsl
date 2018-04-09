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
  
  
   <!-- Transform the attendees into an array of json objects 
       for use in the BwGrid.  This is called on edit event to process 
       attendees from the xml.  -->
  <xsl:template match="attendees" mode="loadBwGrid">
    <xsl:for-each select="attendee">
      <xsl:sort select="attendeeUri"/>
      {name:"<xsl:value-of select="cn"/>",uid:"<xsl:value-of select="attendeeUri"/>",role:"<xsl:value-of select="role"/>",status:"<xsl:value-of select="partstat"/>",type:"<xsl:value-of select="cuType"/>"}<xsl:if test="position()!=last()">,</xsl:if>
    </xsl:for-each>
  </xsl:template>


  <!-- THE FOLLOWING TEMPLATE IS DEPRECATED, BUT MUST REMAIN FOR NOW  -->
  <!-- Recipients and attendees are handled by the json widgets in the newer versions.
       This template remains for both backward compatibility and testing.
   -->
  <xsl:template name="attendees">
    <h2>
      <span class="formButtons"><input type="button" value="{$bwStr-Atnd-Continue}" onclick="window.location='{$gotoEditEvent}'"/></span>
        <xsl:copy-of select="$bwStr-Atnd-SchedulMeetingOrTask"/>
    </h2>

    <div id="recipientsAndAttendees">
      <h4><xsl:copy-of select="$bwStr-Atnd-AddAttendees"/></h4>
      <form name="raForm" id="recipientsAndAttendeesForm" action="{$event-attendeesForEvent}" method="post">
        <div id="raContent">
          <div id="raFields">
            <input type="text" name="uri" width="40" id="bwRaUri"/>
            <input type="submit" value="{$bwStr-Atnd-Add}" />
            <!-- Recipients are deprecated: default all to attendees -->
            <input type="hidden" name="recipient" value="true"/>
            <input type="hidden" name="attendee"  value="true"/>
            <xsl:text> </xsl:text>
            <xsl:copy-of select="$bwStr-Atnd-RoleColon"/>
            <select name="role">
              <option value="REQ-PARTICIPANT"><xsl:copy-of select="$bwStr-Atnd-RequiredParticipant"/></option>
              <option value="OPT-PARTICIPANT"><xsl:copy-of select="$bwStr-Atnd-OptionalParticipant"/></option>
              <option value="CHAIR"><xsl:copy-of select="$bwStr-Atnd-Chair"/></option>
              <option value="NON-PARTICIPANT"><xsl:copy-of select="$bwStr-Atnd-NonParticipant"/></option>
            </select>
            <xsl:text> </xsl:text>
            <xsl:copy-of select="$bwStr-Atnd-StatusColon"/>
            <select name="partstat">
              <option value="NEEDS-ACTION"><xsl:copy-of select="$bwStr-Atnd-NeedsAction"/></option>
              <option value="ACCEPTED"><xsl:copy-of select="$bwStr-Atnd-Accepted"/></option>
              <option value="DECLINED"><xsl:copy-of select="$bwStr-Atnd-Declined"/></option>
              <option value="TENTATIVE"><xsl:copy-of select="$bwStr-Atnd-Tentative"/></option>
              <option value="DELEGATED"><xsl:copy-of select="$bwStr-Atnd-Delegated"/></option>
            </select>
          </div>

          <xsl:if test="/bedework/attendees/attendee">
            <xsl:apply-templates select="/bedework/attendees"/>
          </xsl:if>

          <!-- Recipients are deprecated -->
          <!--
          <xsl:if test="/bedework/recipients/recipient">
            <xsl:apply-templates select="/bedework/recipients"/>
          </xsl:if>
          -->

          <xsl:apply-templates select="/bedework/freebusy" mode="freeBusyGrid">
            <xsl:with-param name="aggregation">true</xsl:with-param>
            <xsl:with-param name="type">meeting</xsl:with-param>
          </xsl:apply-templates>

          <div class="eventSubmitButtons">
            <input type="button" value="{$bwStr-AEEF-Continue}" onclick="window.location='{$gotoEditEvent}'"/>
          </div>
        </div>
      </form>
    </div>
  </xsl:template>
  
  <xsl:template match="attendees">
    <xsl:param name="trash">yes</xsl:param>
    <table id="attendees" class="widget" cellspacing="0">
      <tr>
        <th colspan="4"><xsl:copy-of select="$bwStr-Atnd-Attendees"/></th>
      </tr>
      <tr class="subHead">
        <xsl:if test="$trash = 'yes'"><td></td></xsl:if>
        <td><xsl:copy-of select="$bwStr-Atnd-Attendee"/></td>
        <td><xsl:copy-of select="$bwStr-Atnd-Role"/></td>
        <td><xsl:copy-of select="$bwStr-Atnd-Status"/></td>
      </tr>
      <xsl:for-each select="attendee">
        <xsl:sort select="cn" order="ascending" case-order="upper-first"/>
        <xsl:sort select="attendeeUri" order="ascending" case-order="upper-first"/>
        <xsl:variable name="attendeeUri" select="attendeeUri"/>
        <tr>
          <xsl:if test="$trash = 'yes'">
            <td class="trash">
              <a href="{$event-attendeesForEvent}&amp;uri={$attendeeUri}&amp;attendee=true&amp;delete=true" title="{$bwStr-Atnd-Remove}">
                <img src="{$resourcesRoot}/images/trashIcon.gif" width="13" height="13" border="0" alt="remove"/>
              </a>
            </td>
          </xsl:if>
          <td>
            <a href="{$attendeeUri}">
              <xsl:choose>
                <xsl:when test="cn != ''">
                  <xsl:value-of select="cn"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="attendeeUri"/>
                </xsl:otherwise>
              </xsl:choose>
            </a>
          </td>
          <td class="role">
            <xsl:apply-templates select="role"/>
          </td>
          <td class="status">
            <xsl:apply-templates select="partstat"/>
          </td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <xsl:template match="partstat">
    <xsl:choose>
      <xsl:when test=". = 'NEEDS-ACTION' or . = ''"><xsl:copy-of select="$bwStr-ptst-NeedsAction"/></xsl:when>
      <xsl:when test=". = 'ACCEPTED'"><xsl:copy-of select="$bwStr-ptst-Accepted"/></xsl:when>
      <xsl:when test=". = 'DECLINED'"><xsl:copy-of select="$bwStr-ptst-Declined"/></xsl:when>
      <xsl:when test=". = 'TENTATIVE'"><xsl:copy-of select="$bwStr-ptst-Tentative"/></xsl:when>
      <xsl:when test=". = 'DELEGATED'"><xsl:copy-of select="$bwStr-ptst-Delegated"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="role">
    <xsl:choose>
      <xsl:when test=". = 'REQ-PARTICIPANT' or . = ''">required participant</xsl:when>
      <xsl:when test=". = 'CHAIR'">chair</xsl:when>
      <xsl:when test=". = 'OPT-PARTICIPANT'">optional participant</xsl:when>
      <xsl:when test=". = 'NON-PARTICIPANT'">non-participant</xsl:when>
      <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Recipients are deprecated -->
  <xsl:template match="recipients">
    <xsl:param name="trash">yes</xsl:param>
    <table id="recipients" class="widget" cellspacing="0">
      <tr>
        <th colspan="2"><xsl:copy-of select="$bwStr-Rcpt-Recipients"/></th>
      </tr>
      <tr class="subHead">
        <xsl:if test="$trash = 'yes'"><td></td></xsl:if>
        <td><xsl:copy-of select="$bwStr-Rcpt-Recipient"/></td>
      </tr>
      <xsl:for-each select="recipient">
        <xsl:variable name="recipientUri" select="."/>
        <tr>
          <xsl:if test="$trash = 'yes'">
            <td class="trash">
              <a href="{$event-attendeesForEvent}&amp;uri={$recipientUri}&amp;recipient=true&amp;delete=true" title="{$bwStr-Rcpt-Remove}">
                <img src="{$resourcesRoot}/images/trashIcon.gif" width="13" height="13" border="0" alt="remove"/>
              </a>
            </td>
          </xsl:if>
          <td>
            <a href="{$recipientUri}">
              <xsl:value-of select="."/>
            </a>
          </td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>
  
</xsl:stylesheet>