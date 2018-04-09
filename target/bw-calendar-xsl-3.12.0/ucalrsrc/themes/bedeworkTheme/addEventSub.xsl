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
  
  <xsl:template match="event" mode="addEventSub">
  <!-- The name "eventForm" is referenced by several javascript functions. Do not
    change it without modifying bedework.js -->
    <form name="eventForm" method="post" action="{$event-addEventSubComplete}" id="standardForm"  enctype="multipart/form-data">
      <xsl:variable name="calPath" select="calendar/path"/>
      <xsl:variable name="name" select="name"/>
      <xsl:variable name="recurrenceId" select="recurrenceId"/>
      <input type="hidden" name="href" value="{$calPath}/{$name}"/>
      <input type="hidden" name="recurrenceId" value="{$recurrenceId}"/>
      <!-- newCalPath is the path to the calendar in which the reference
           should be placed.  If no value, then default calendar. -->
      <input type="hidden" name="newColPath" value="" id="bwNewCalPathField"/>

      <h2><xsl:copy-of select="$bwStr-AEEF-AddEventSubscription"/></h2>
      <table class="common" cellspacing="0">
        <tr>
          <td class="fieldname">
            <xsl:copy-of select="$bwStr-AEEF-EventColon"/>
          </td>
          <td>
            <xsl:choose>
              <xsl:when test="summary = ''">
                <em><xsl:copy-of select="$bwStr-AEEF-NoTitle"/></em><xsl:text> </xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="summary"/>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <td class="fieldname">
            <xsl:copy-of select="$bwStr-AEEF-IntoCalendar"/>
          </td>
          <td align="left">
            <span id="bwEventCalDisplay">
              <em><xsl:copy-of select="$bwStr-AEEF-DefaultCalendar"/></em>
            </span>
            <xsl:call-template name="selectCalForEvent"/>
          </td>
        </tr>
        <tr>
          <td class="fieldname">
            <xsl:copy-of select="$bwStr-AEEF-AffectsFreeBusy"/>
          </td>
          <td align="left">
            <input type="radio" value="OPAQUE" name="transparency"/><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-AEEF-Yes"/><xsl:text> </xsl:text><span class="note"><xsl:copy-of select="$bwStr-AEEF-Opaque"/></span><br/>
            <input type="radio" value="TRANSPARENT" name="transparency" checked="checked"/><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-AEEF-No"/><xsl:text> </xsl:text><span class="note"><xsl:copy-of select="$bwStr-AEEF-Transparent"/></span>
          </td>
        </tr>
      </table>
      <table border="0" id="submitTable">
        <tr>
          <td>
            <input name="submit" type="submit" value="{$bwStr-AEEF-Continue}"/>
            <input name="cancelled" type="submit" value="{$bwStr-AEEF-Cancel}"/>
          </td>
        </tr>
      </table>
    </form>
  </xsl:template>
  
  <xsl:template match="event" mode="addEventSub">
  <!-- The name "eventForm" is referenced by several javascript functions. Do not
    change it without modifying bedework.js -->
    <form name="eventForm" method="post" action="{$event-addEventSubComplete}" id="standardForm"  enctype="multipart/form-data">
      <xsl:variable name="calPath" select="calendar/path"/>
      <xsl:variable name="name" select="name"/>
      <xsl:variable name="recurrenceId" select="recurrenceId"/>
      <input type="hidden" name="href" value="{$calPath}/{$name}"/>
      <input type="hidden" name="recurrenceId" value="{$recurrenceId}"/>
      <!-- newCalPath is the path to the calendar in which the reference
           should be placed.  If no value, then default calendar. -->
      <input type="hidden" name="newColPath" value="" id="bwNewCalPathField"/>

      <h2><xsl:copy-of select="$bwStr-AEEF-AddEventSubscription"/></h2>
      <table class="common" cellspacing="0">
        <tr>
          <td class="fieldname">
            <xsl:copy-of select="$bwStr-AERf-Event"/>
          </td>
          <td>
            <xsl:choose>
              <xsl:when test="summary = ''">
                <em><xsl:copy-of select="$bwStr-AERf-NoTitle"/></em><xsl:text> </xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="summary"/>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <td class="fieldname">
            <xsl:copy-of select="$bwStr-AERf-IntoCalendar"/>
          </td>
          <td align="left">
            <span id="bwEventCalDisplay">
              <em><xsl:copy-of select="$bwStr-AERf-DefaultCalendar"/></em>
            </span>
            <xsl:call-template name="selectCalForEvent"/>
          </td>
        </tr>
        <tr>
          <td class="fieldname">
            <xsl:copy-of select="$bwStr-AERf-AffectsFreeBusy"/>
          </td>
          <td align="left">
            <input type="radio" value="OPAQUE" name="transparency"/><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-AERf-Yes"/><xsl:text> </xsl:text><span class="note"><xsl:copy-of select="$bwStr-AERf-Opaque"/></span><br/>
            <input type="radio" value="TRANSPARENT" name="transparency" checked="checked"/><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-AERf-No"/><xsl:text> </xsl:text><span class="note"><xsl:copy-of select="$bwStr-AERf-Transparent"/></span>
          </td>
        </tr>
      </table>
      <table border="0" id="submitTable">
        <tr>
          <td>
            <input name="submit" type="submit" value="{$bwStr-AERf-Continue}"/>
            <input name="cancelled" type="submit" value="{$bwStr-AERf-Cancel}"/>
          </td>
        </tr>
      </table>
    </form>
  </xsl:template>
  
  
</xsl:stylesheet>