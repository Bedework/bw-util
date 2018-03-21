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

  <!-- LOCALE SETTINGS -->
  <!-- This currently provides only a template for the default theme's 
       javascript calendar widget, but could provide layout templates
       for locale specific date rendering as well. -->

  <xsl:template name="jsCalendarLocale">
    <!-- 
      Set the locale settings for the YUI javascript calendar widget
      used in the default bedeworkTheme.
      
      Leave commented out to use default settings (English, US).
      
      For more information about customizing the widget's locale, see
      http://developer.yahoo.com/yui/calendar/
    -->
    <script type="text/javascript">
      function setJsCalendarLocale() {
        // GERMAN:
        // Correct formats for locale: dd.mm.yyyy, dd.mm, mm.yyyy 
        YAHOO.bw.jsNavCal.cfg.setProperty("DATE_FIELD_DELIMITER", "."); 
        YAHOO.bw.jsNavCal.cfg.setProperty("MDY_DAY_POSITION", 1); 
        YAHOO.bw.jsNavCal.cfg.setProperty("MDY_MONTH_POSITION", 2); 
        YAHOO.bw.jsNavCal.cfg.setProperty("MDY_YEAR_POSITION", 3); 
         
        YAHOO.bw.jsNavCal.cfg.setProperty("MD_DAY_POSITION", 1); 
        YAHOO.bw.jsNavCal.cfg.setProperty("MD_MONTH_POSITION", 2); 

        // Date labels for locale 
        YAHOO.bw.jsNavCal.cfg.setProperty("MONTHS_SHORT",   ["Jan", "Feb", "M\u00E4r", "Apr", "Mai", "Jun", "Jul", "Aug", "Sep", "Okt", "Nov", "Dez"]); 
        YAHOO.bw.jsNavCal.cfg.setProperty("MONTHS_LONG",    ["Januar", "Februar", "M\u00E4rz", "April", "Mai", "Juni", "Juli", "August", "September", "Oktober", "November", "Dezember"]); 
        YAHOO.bw.jsNavCal.cfg.setProperty("WEEKDAYS_1CHAR", ["S", "M", "D", "M", "D", "F", "S"]); 
        YAHOO.bw.jsNavCal.cfg.setProperty("WEEKDAYS_SHORT", ["So", "Mo", "Di", "Mi", "Do", "Fr", "Sa"]); 
        YAHOO.bw.jsNavCal.cfg.setProperty("WEEKDAYS_MEDIUM",["Son", "Mon", "Die", "Mit", "Don", "Fre", "Sam"]); 
        YAHOO.bw.jsNavCal.cfg.setProperty("WEEKDAYS_LONG",  ["Sonntag", "Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag"]);
      }
     </script>
  </xsl:template>
</xsl:stylesheet>
