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
  <xsl:template name="upload">
  <!-- The name "eventForm" is referenced by several javascript functions. Do not
    change it without modifying bedework.js -->
    <form name="eventForm" method="post" action="{$upload}" id="standardForm"  enctype="multipart/form-data">
      <h2><xsl:copy-of select="$bwStr-Upld-UploadICalFile"/></h2>
      <table class="common" cellspacing="0">
        <tr>
          <td class="fieldname">
            <xsl:copy-of select="$bwStr-Upld-Filename"/>
          </td>
          <td align="left">
            <input type="file" name="uploadFile" size="60" />
          </td>
        </tr>
        <tr>
          <td class="fieldname padMeTop">
            <xsl:copy-of select="$bwStr-Upld-IntoCalendar"/>
          </td>
          <td align="left" class="padMeTop">
            <input type="hidden" name="newCalPath" id="bwNewCalPathField" value=""/>
            <span id="bwEventCalDisplay">
              <em><xsl:copy-of select="$bwStr-Upld-DefaultCalendar"/></em>
            </span>
          </td>
        </tr>
        <tr>
          <td class="fieldname padMeTop">
            <xsl:copy-of select="$bwStr-Upld-AffectsFreeBusy"/>
          </td>
          <td align="left" class="padMeTop">
            <input type="radio" value="" name="transparency" checked="checked"/><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-Upld-AcceptEventsSettings"/><br/>
            <input type="radio" value="OPAQUE" name="transparency"/><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-Upld-Opaque"/><xsl:text> </xsl:text><span class="note"><xsl:copy-of select="$bwStr-Upld-Yes"/></span><br/>
            <input type="radio" value="TRANSPARENT" name="transparency"/><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-Upld-No"/><xsl:text> </xsl:text><span class="note"><xsl:copy-of select="$bwStr-Upld-Transparent"/></span><br/>
          </td>
        </tr>
        <tr>
          <td class="fieldname padMeTop">
            <xsl:copy-of select="$bwStr-Upld-Status"/>
          </td>
          <td align="left" class="padMeTop">
            <input type="radio" value="" name="status" checked="checked"/><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-Upld-AcceptEventsStatus"/><br/>
            <input type="radio" value="CONFIRMED" name="status"/><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-Upld-Confirmed"/><br/>
            <input type="radio" value="TENTATIVE" name="status"/><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-Upld-Tentative"/><br/>
            <input type="radio" value="CANCELLED" name="status"/><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-Upld-Canceled"/><br/>
          </td>
        </tr>
      </table>
      <table id="submitTable">
        <tr>
          <td>
            <input name="submit" type="submit" value="{$bwStr-Upld-Continue}"/>
            <input name="cancelled" type="submit" value="{$bwStr-Upld-Cancel}"/>
          </td>
        </tr>
      </table>
    </form>
  </xsl:template>
</xsl:stylesheet>