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
  
  <!--==== ALARM OPTIONS ====-->
  <xsl:template name="alarmOptions">
    <form method="post" action="{$setAlarm}" id="standardForm">
      <input type="hidden" name="updateAlarmOptions" value="true"/>
      <table class="common" cellspacing="0">
        <tr>
          <th colspan="2" class="commonHeader"><xsl:copy-of select="$bwStr-AlOp-AlarmOptions"/></th>
        </tr>
        <tr>
          <td class="fieldname">
            <xsl:copy-of select="$bwStr-AlOp-AlarmDateTime"/>
            <xsl:copy-of select="/bedework/alarmoptionsform/form/alarmTriggerSelectorDate/*"/>
          </td>
          <td class="fieldval">
            <xsl:copy-of select="/bedework/alarmoptionsform/form/alarmdate/*"/>
            <span class="std-text"><xsl:copy-of select="$bwStr-AlOp-At"/><xsl:text> </xsl:text></span>
            <xsl:copy-of select="/bedework/alarmoptionsform/form/alarmtime/*"/>
          </td>
        </tr>
        <tr>
          <td class="fieldname">
            <xsl:copy-of select="$bwStr-AlOp-OrBeforeAfterEvent"/>
            <xsl:copy-of select="/bedework/alarmoptionsform/form/alarmTriggerSelectorDuration/*"/>
          </td>
          <td align="left">
            <xsl:copy-of select="/bedework/alarmoptionsform/form/alarmduration/days/*"/>
            <xsl:copy-of select="$bwStr-AlOp-Days"/>
            <xsl:copy-of select="/bedework/alarmoptionsform/form/alarmduration/hours/*"/>
            <xsl:copy-of select="$bwStr-AlOp-Hours"/>
            <xsl:copy-of select="/bedework/alarmoptionsform/form/alarmduration/minutes/*"/>
            <xsl:copy-of select="$bwStr-AlOp-Minutes"/>
            <xsl:copy-of select="/bedework/alarmoptionsform/form/alarmduration/seconds/*"/>
            <xsl:copy-of select="$bwStr-AlOp-SecondsOr"/>
            <xsl:copy-of select="/bedework/alarmoptionsform/form/alarmduration/weeks/*"/>
            <xsl:copy-of select="$bwStr-AlOp-Weeks"/>
            &#160;
            <xsl:copy-of select="/bedework/alarmoptionsform/form/alarmDurationBefore/*"/>
            <xsl:copy-of select="$bwStr-AlOp-Before"/>
            <xsl:copy-of select="/bedework/alarmoptionsform/form/alarmDurationAfter/*"/>
            <xsl:copy-of select="$bwStr-AlOp-After"/>
            &#160;
            <xsl:copy-of select="/bedework/alarmoptionsform/form/alarmDurationRelStart/*"/>
            <xsl:copy-of select="$bwStr-AlOp-Start"/>
            <xsl:copy-of select="/bedework/alarmoptionsform/form/alarmDurationRelEnd/*"/>
            <xsl:copy-of select="$bwStr-AlOp-End"/>
          </td>
        </tr>
        <tr>
          <td>
            <xsl:copy-of select="$bwStr-AlOp-EmailAddress"/>
          </td>
          <td align="left">
            <xsl:copy-of select="/bedework/alarmoptionsform/form/email/*"/>
          </td>
        </tr>
        <tr>
          <td>
            <xsl:copy-of select="$bwStr-AlOp-Subject"/>
          </td>
          <td align="left">
            <xsl:copy-of select="/bedework/alarmoptionsform/form/subject/*"/>
          </td>
        </tr>
        <tr>
          <td>&#160;</td>
          <td>
            <input name="submit" type="submit" value="{$bwStr-AlOp-Continue}"/>&#160;
            <input name="cancelled" type="submit" value="{$bwStr-AlOp-Cancel}"/>
          </td>
        </tr>
      </table>
    </form>
  </xsl:template>

  
</xsl:stylesheet>