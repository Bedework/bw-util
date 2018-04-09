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

  <!--+++++++++++++++ Timezones ++++++++++++++++++++-->
  <xsl:template name="uploadTimezones">
    <h2><xsl:copy-of select="$bwStr-UpTZ-ManageTZ"/></h2>

    <form name="peForm" method="post" action="{$timezones-upload}" enctype="multipart/form-data">
      <input type="file" name="uploadFile" size="40" value=""/>
      <input type="submit" name="doUpload" value="{$bwStr-UpTZ-UploadTZ}"/>
      <input type="submit" name="cancelled" value="{$bwStr-UpTZ-Cancel}"/>
    </form>

    <p>
      <a href="{$timezones-fix}"><xsl:copy-of select="$bwStr-UpTZ-FixTZ"/></a>
      <xsl:text> </xsl:text><xsl:copy-of select="$bwStr-UpTZ-RecalcUTC"/><br/>
      <span class="note"><xsl:copy-of select="$bwStr-UpTZ-FixTZNote"/></span>
    </p>

  </xsl:template>

</xsl:stylesheet>