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

  <!--==== CALENDARS ====-->
  <!-- list of available calendars -->
  <xsl:template match="calendars">
    <xsl:variable name="topLevelCalCount" select="count(calendar/calendar[calType != 5 and calType != 6 and name != 'calendar'])"/>

    <div class="secondaryColHeader">
      <h3><xsl:copy-of select="$bwStr-Cals-DownloadCalendars"/></h3>
    </div>
    <p class="info">
      <xsl:copy-of select="$bwStr-Cals-SelectCalendar"/>
    </p>

    <!-- adjust the following calculations to get a balanced layout between the cells -->
    <div class="calendarList">
      <ul class="calendarTree">
        <xsl:apply-templates select="calendar/calendar[(calType != 5 and calType != 6 and name != 'calendar' and not(starts-with(name,'.'))) and (position() &lt;= ceiling($topLevelCalCount div 2)+2)]" mode="calTree"/>
      </ul>
    </div>
    <div class="calendarList">
      <ul class="calendarTree">
        <xsl:apply-templates select="calendar/calendar[(calType != 5 and calType != 6 and name != 'calendar' and not(starts-with(name,'.'))) and (position() &gt; ceiling($topLevelCalCount div 2)+2)]" mode="calTree"/>
      </ul>
    </div>
  </xsl:template>

  <xsl:template match="calendar" mode="calTree">
    <xsl:variable name="virtualPath"><xsl:call-template name="url-encode"><xsl:with-param name="str">/user<xsl:for-each select="ancestor-or-self::calendar/name">/<xsl:value-of select="."/></xsl:for-each></xsl:with-param></xsl:call-template></xsl:variable>
    <li>
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="calType = '0'">folder</xsl:when>
          <xsl:otherwise>calendar</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:variable name="calPath" select="path"/>
      <xsl:variable name="displayName" select="summary"/>

      <a href="{$calendar-fetchForExport}&amp;calPath={$calPath}&amp;virtualPath={$virtualPath}" title="export calendar as iCal">
        <xsl:value-of select="summary"/>
        <span class="exportCalLink">
          <img src="{$resourcesRoot}/images/calIconExport-sm.gif" width="13" height="13" alt="export calendar"/>
        </span>
      </a>
      <xsl:if test="calendar[not(starts-with(name,'.'))]">
        <ul>
          <xsl:apply-templates select="calendar[not(starts-with(name,'.'))]" mode="calTree"/>
        </ul>
      </xsl:if>
    </li>
  </xsl:template>

  <!-- calendar export page -->
  <xsl:template match="currentCalendar" mode="export">
    <div class="secondaryColHeader">
      <h3><xsl:copy-of select="$bwStr-Cals-ExportCals"/></h3>
    </div>
    <div id="export">

      <p>
        <xsl:copy-of select="$bwStr-Cals-CalendarToExport"/>
        <xsl:text> </xsl:text>
        <em><xsl:value-of select="summary"/></em>
      </p>

      <form name="exportCalendarForm" id="exportCalendarForm" action="{$export}" method="post">
        <input type="hidden" name="calPath">
          <xsl:attribute name="value"><xsl:value-of select="path"/></xsl:attribute>
        </input>
        <!-- fill these on submit -->
        <input type="hidden" name="eventStartDate.year" value=""/>
        <input type="hidden" name="eventStartDate.month" value=""/>
        <input type="hidden" name="eventStartDate.day" value=""/>
        <input type="hidden" name="eventEndDate.year" value=""/>
        <input type="hidden" name="eventEndDate.month" value=""/>
        <input type="hidden" name="eventEndDate.day" value=""/>
        <!-- static fields -->
        <input type="hidden" name="nocache" value="no"/>
        <input type="hidden" name="contentName">
          <xsl:attribute name="value"><xsl:value-of select="name"/>.ics</xsl:attribute>
        </input>
        <!-- visible fields -->
        <input type="radio" id="bwCalExportForward" name="dateLimits" value="active" checked="checked" onclick="changeClass('exportDateRange','invisible')"/>
        <xsl:text> </xsl:text>
        <label for="bwCalExportForward"><xsl:copy-of select="$bwStr-Cals-TodayForward"/></label>
        <xsl:text> </xsl:text>
        <input type="radio" id="bwCalExportNoLimit" name="dateLimits" value="none" onclick="changeClass('exportDateRange','invisible')"/>
        <xsl:text> </xsl:text>
        <label for="bwCalExportNoLimit"><xsl:copy-of select="$bwStr-Cals-AllDates"/></label>
        <xsl:text> </xsl:text>
        <input type="radio" id="bwCalExportLimited" name="dateLimits" value="limited" onclick="changeClass('exportDateRange','visible')"/>
        <xsl:text> </xsl:text>
        <label for="bwCalExportLimited"><xsl:copy-of select="$bwStr-Cals-DateRange"/></label>
        <xsl:text> </xsl:text>
        <div id="exportDateRange" class="invisible">
          <xsl:copy-of select="$bwStr-Cals-Start"/><xsl:text> </xsl:text><input type="text" name="bwExportCalendarWidgetStartDate" id="bwExportCalendarWidgetStartDate" size="10"/>
          <span id="bwExportEndField"><xsl:copy-of select="$bwStr-Cals-End"/><xsl:text> </xsl:text><input type="text" name="bwExportCalendarWidgetEndDate" id="bwExportCalendarWidgetEndDate" size="10"/></span>
        </div>
        <input type="submit" value="{$bwStr-Cals-Export}" class="bwWidgetSubmit" onclick="fillExportFields(this.form)"/>
      </form>

      <script type="text/javascript">
       $.datepicker.setDefaults({
         constrainInput: true,
         dateFormat: "yy-mm-dd",
         showOn: "both",
         buttonImage: "<xsl:value-of select='$resourcesRoot'/>/images/calIcon.gif",
         buttonImageOnly: true,
         gotoCurrent: true,
         duration: ""
       });
       $(document).ready(function() {
         $("#bwExportCalendarWidgetStartDate").datepicker({
         }).attr("readonly", "readonly");
         $("#bwExportCalendarWidgetEndDate").datepicker({
         }).attr("readonly", "readonly");
       });
      </script>

    </div>
  </xsl:template>

</xsl:stylesheet>
