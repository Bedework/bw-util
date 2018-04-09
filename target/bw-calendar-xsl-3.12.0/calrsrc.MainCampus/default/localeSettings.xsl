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
        <!-- 
        // JAPANESE EXAMPLE:
        // Correct formats for Japan: yyyy/mm/dd, mm/dd, yyyy/mm 
        YAHOO.bw.jsNavCal.cfg.setProperty("MDY_YEAR_POSITION", 1); 
        YAHOO.bw.jsNavCal.cfg.setProperty("MDY_MONTH_POSITION", 2); 
        YAHOO.bw.jsNavCal.cfg.setProperty("MDY_DAY_POSITION", 3); 
        
        YAHOO.bw.jsNavCal.cfg.setProperty("MY_YEAR_POSITION", 1); 
        YAHOO.bw.jsNavCal.cfg.setProperty("MY_MONTH_POSITION", 2); 
   
        // Date labels for Japanese locale 
        YAHOO.bw.jsNavCal.cfg.setProperty("MONTHS_SHORT",   ["1\u6708", "2\u6708", "3\u6708", "4\u6708", "5\u6708", "6\u6708", "7\u6708", "8\u6708", "9\u6708", "10\u6708", "11\u6708", "12\u6708"]); 
        YAHOO.bw.jsNavCal.cfg.setProperty("MONTHS_LONG",    ["1\u6708", "2\u6708", "3\u6708", "4\u6708", "5\u6708", "6\u6708", "7\u6708", "8\u6708", "9\u6708", "10\u6708", "11\u6708", "12\u6708"]); 
        YAHOO.bw.jsNavCal.cfg.setProperty("WEEKDAYS_1CHAR", ["\u65E5", "\u6708", "\u706B", "\u6C34", "\u6728", "\u91D1", "\u571F"]); 
        YAHOO.bw.jsNavCal.cfg.setProperty("WEEKDAYS_SHORT", ["\u65E5", "\u6708", "\u706B", "\u6C34", "\u6728", "\u91D1", "\u571F"]); 
        YAHOO.bw.jsNavCal.cfg.setProperty("WEEKDAYS_MEDIUM",["\u65E5", "\u6708", "\u706B", "\u6C34", "\u6728", "\u91D1", "\u571F"]); 
        YAHOO.bw.jsNavCal.cfg.setProperty("WEEKDAYS_LONG",  ["\u65E5", "\u6708", "\u706B", "\u6C34", "\u6728", "\u91D1", "\u571F"]); 
         
        YAHOO.bw.jsNavCal.cfg.setProperty("MY_LABEL_YEAR_POSITION",  1); 
        YAHOO.bw.jsNavCal.cfg.setProperty("MY_LABEL_MONTH_POSITION",  2); 
        YAHOO.bw.jsNavCal.cfg.setProperty("MY_LABEL_YEAR_SUFFIX",  "\u5E74"); 
        YAHOO.bw.jsNavCal.cfg.setProperty("MY_LABEL_MONTH_SUFFIX",  ""); 
        -->
        
        <!--  
        // GERMAN EXAMPLE:
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
        -->
      }
     </script>
  </xsl:template>
</xsl:stylesheet>