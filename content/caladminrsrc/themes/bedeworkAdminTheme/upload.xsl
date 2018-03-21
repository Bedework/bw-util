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

  <!--==== UPLOAD ical File (for superuser) ====-->
  <xsl:template name="upload">
  <!-- The name "eventForm" is referenced by several javascript functions. Do not
    change it without modifying includes.js -->
    <form name="eventForm" method="post" action="{$event-upload}" id="standardForm" enctype="multipart/form-data">
      <h2><xsl:copy-of select="$bwStr-Upld-UploadICalFile"/></h2>
      <table class="common2" cellspacing="0">
        <tr>
          <th>
            <xsl:copy-of select="$bwStr-Upld-Filename"/>
          </th>
          <td align="left">
            <input type="file" name="uploadFile" size="60" />
          </td>
        </tr>
        <tr>
          <th>
            <xsl:copy-of select="$bwStr-Upld-IntoCalendar"/>
          </th>
          <td align="left" class="padMeTop">
            <input type="hidden" name="newCalPath" value=""/>
            <span id="bwEventCalDisplay">
              <xsl:copy-of select="$bwStr-Upld-NoneSelected"/>
            </span>
            <xsl:text> </xsl:text>
            [<a href="javascript:launchCalSelectWindow('{$event-selectCalForEvent}')" class="small"><xsl:copy-of select="$bwStr-Upld-Change"/></a>]
          </td>
        </tr>
        <tr>
          <th >
            <xsl:copy-of select="$bwStr-Upld-AffectsFreeBusy"/>
          </th>
          <td align="left" class="padMeTop">
            <input type="radio" value="" name="transparency" id="transAccept" checked="checked"/><xsl:text> </xsl:text>
            <label for="transAccept"><xsl:copy-of select="$bwStr-Upld-AcceptEventsSettings"/></label><br/>
            <input type="radio" value="OPAQUE" name="transparency" id="transYes"/><xsl:text> </xsl:text>
            <label for="transYes"><xsl:copy-of select="$bwStr-Upld-Yes"/><xsl:text> </xsl:text><span class="note"><xsl:copy-of select="$bwStr-Upld-Opaque"/></span></label><br/>
            <input type="radio" value="TRANSPARENT" name="transparency" id="transNo"/><xsl:text> </xsl:text>
            <label for="transNo"><xsl:copy-of select="$bwStr-Upld-No"/><xsl:text> </xsl:text><span class="note"><xsl:copy-of select="$bwStr-Upld-Transparent"/></span></label>
          </td>
        </tr>
        <tr>
          <th>
            <xsl:copy-of select="$bwStr-Upld-Status"/>
          </th>
          <td align="left" class="padMeTop">
            <input type="radio" value="" name="status" id="statAccept" checked="checked"/><xsl:text> </xsl:text>
            <label for="statAccept"><xsl:copy-of select="$bwStr-Upld-AcceptEventsStatus"/></label><br/>
            <input type="radio" value="CONFIRMED" name="status" id="statConf"/><xsl:text> </xsl:text>
            <label for="statConf"><xsl:copy-of select="$bwStr-Upld-Confirmed"/></label><br/>
            <input type="radio" value="TENTATIVE" name="status" id="statTent"/><xsl:text> </xsl:text>
            <label for="statTent"><xsl:copy-of select="$bwStr-Upld-Tentative"/></label><br/>
            <input type="radio" value="CANCELLED" name="status" id="statCanc"/><xsl:text> </xsl:text>
            <label for="statCanc"><xsl:copy-of select="$bwStr-Upld-Canceled"/></label>
          </td>
        </tr>
      </table>
      <div class="submitBox">
        <input name="submit" type="submit" value="{$bwStr-Upld-Continue}"/>
        <input name="cancelled" type="submit" value="{$bwStr-Upld-Cancel}"/>
      </div>
    </form>
  </xsl:template>

</xsl:stylesheet>