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

  <!-- URL of html resources (images, css, other html) for the current theme.
       This value is self-referential and should always match the directory name of the current theme. -->
  <xsl:variable name="resourcesRoot"><xsl:value-of select="/bedework/browserResourceRoot"/>/themes/bwSubmissionsTheme</xsl:variable>
  
  <!-- the following variable can be set to "true" or "false";
       to use jQuery widgets and fancier UI features, set to false - these are
       not guaranteed to work in portals. -->
  <xsl:variable name="portalFriendly">false</xsl:variable>
  
  <!-- HEADER -->
  <xsl:variable name="masthead">
    <div id="siteTitleAndNav" class="hidden-xs">
      <!-- siteTitleAndNav is hidden on small devices, where the mobile menu appears -->
      <h1><xsl:copy-of select="$bwStr-Hedr-BedeworkPubEventSub" /></h1>
    </div>
    <div id="siteLogo">
      <a href="/cal">
        <img src="{$resourcesRoot}/images/bedework.png" width="243" height="40" alt="Bedework Calendar"/>
      </a>
    </div>
  </xsl:variable>
  
  <!-- FOOTER  -->
  <xsl:template name="footerText">
    <xsl:copy-of select="$bwStr-Foot-BasedOnThe" />
    <xsl:text> </xsl:text>
    <a href="http://www.jasig.org/bedework/documentation">
      <xsl:copy-of select="$bwStr-Foot-BedeworkCalendarSystem" />
    </a>
    |
    <a
        href="http://www.jasig.org/bedework/whosusing">
      <xsl:copy-of select="$bwStr-Foot-ProductionExamples" />
    </a>
    |
    <a href="?noxslt=yes">
      <xsl:copy-of select="$bwStr-Foot-ShowXML" />
    </a>
    |
    <a href="?refreshXslt=yes">
      <xsl:copy-of select="$bwStr-Foot-RefreshXSLT" />
    </a>
    <br/>
  </xsl:template>

</xsl:stylesheet>