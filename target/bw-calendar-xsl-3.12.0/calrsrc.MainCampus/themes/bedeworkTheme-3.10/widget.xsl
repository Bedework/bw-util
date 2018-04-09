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
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" indent="yes" media-type="text/html"
    standalone="yes" omit-xml-declaration="yes" />

  <!-- =========================================================

    HTML WIDGETS ROOT STYLESHEET

    This stylesheet is the root transform that returns HTML
    data islands used in AJAX calls by the 3.10 theme.
    The 3.10 theme also makes use of JSON data for simpler lists,
    and is transformed by the widget-json-* stylesheets found down
    the default/* path.

    ===============================================================  -->

  <!-- DEFINE INCLUDES -->
  <!-- Theme preferences -->
  <xsl:include href="themeSettings.xsl" />

  <!-- theme utility functions -->
  <xsl:include href="themeUtil.xsl" />

  <!-- Widget subsections -->
  <xsl:include href="widgetEventList.xsl" />

  <!-- MAIN TEMPLATE -->
  <xsl:template match="/">
    <div class="bwWidget">
      <div class="bwWidgetGlobals"><!-- meta information for all widgets -->
        <ul class="bwwgCurrentDate">
          <li class="bwwgCdDate"><xsl:value-of select="/bedework/currentdate/date"/></li>
          <li class="bwwgCdLongDate"><xsl:value-of select="/bedework/currentdate/longdate"/></li>
          <li class="bwwgCdShortDate"><xsl:value-of select="/bedework/currentdate/shortdate"/></li>
          <li class="bwwgCdMonthName"><xsl:value-of select="/bedework/currentdate/monthname"/></li>
        </ul>
      </div>
      <!-- branch on content (for both header and body content), as defined by /bedework/page -->
      <div class="bwWidgetHeader">
        <xsl:choose>
          <xsl:when test="/bedework/page = 'eventList'">
            <span class="bwwhResultSize"><xsl:value-of select="/bedework/events/resultSize"/></span>
          </xsl:when>
        </xsl:choose>
      </div>
      <div class="bwWidgetBody">
        <xsl:choose>

          <!-- list of discrete events - used for upcoming events -->
          <xsl:when test="/bedework/page = 'eventList'">
            <xsl:apply-templates select="/bedework/events" mode="widgetEventList"/>
          </xsl:when>

          <!-- otherwise, show us what page was requested
               (if the stylesheet is thorough, you should never see this) -->
          <xsl:otherwise>
            <xsl:copy-of select="$bwStr-Error"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="/bedework/page" />
          </xsl:otherwise>

        </xsl:choose>
        <xsl:text> </xsl:text>
      </div>
    </div><!-- /bwWidget -->

  </xsl:template>
</xsl:stylesheet>
