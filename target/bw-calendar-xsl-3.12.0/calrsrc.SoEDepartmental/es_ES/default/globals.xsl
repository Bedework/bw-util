<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml">

  <!-- DEFINE GLOBAL INCLUDES -->
  <xsl:include href="/bedework-common/default/default/util.xsl" />
  
  <!-- include the common language string libraries -->
  <xsl:include href="/bedework-common/es_ES/default/errors.xsl" />
  <xsl:include href="/bedework-common/es_ES/default/messages.xsl" />


  <!-- ======================= -->
  <!-- DEFINE GLOBAL CONSTANTS -->
  <!-- ======================= -->

  <!-- URL of the XSL template directory for this calendar suite -->
  <xsl:variable name="appRoot" select="/bedework/approot" />

  <!-- Properly encoded prefixes to the application actions; use these to build
    urls; allows the application to be used without cookies or within a portal.
    These urls are rewritten in header.jsp and simply passed through for use
    here. Every url includes a query string (either ?b=de or a real query
    string) so that all links constructed in this stylesheet may begin the
    query string with an ampersand. -->
  <xsl:variable name="setup" select="/bedework/urlPrefixes/setup" />
  <xsl:variable name="setSelection" select="/bedework/urlPrefixes/main/setSelection" />
  <xsl:variable name="fetchPublicCalendars" select="/bedework/urlPrefixes/calendar/fetchPublicCalendars" />
  <xsl:variable name="setViewPeriod" select="/bedework/urlPrefixes/main/setViewPeriod" />
  <xsl:variable name="listEvents" select="/bedework/urlPrefixes/main/listEvents" />
  <xsl:variable name="eventView" select="/bedework/urlPrefixes/event/eventView" />
  <xsl:variable name="addEventRef" select="/bedework/urlPrefixes/event/addEventRef" />
  <xsl:variable name="export" select="/bedework/urlPrefixes/misc/export" />
  <xsl:variable name="search" select="/bedework/urlPrefixes/search/search" />
  <xsl:variable name="search-next" select="/bedework/urlPrefixes/search/next" />
  <xsl:variable name="calendar-fetchForExport" select="/bedework/urlPrefixes/calendar/fetchForExport" />
  <xsl:variable name="mailEvent" select="/bedework/urlPrefixes/mail/mailEvent" />
  <xsl:variable name="stats" select="/bedework/urlPrefixes/stats/stats" />

  <!-- URL of the web application - includes web context -->
  <xsl:variable name="urlPrefix" select="/bedework/urlprefix" />

  <!-- Other generally useful global variables -->
  <xsl:variable name="privateCal">/ucal</xsl:variable>
  <xsl:variable name="feeder">/feeder</xsl:variable>
  <xsl:variable name="urlbuilder">/urlbuilder</xsl:variable>
  <xsl:variable name="prevdate" select="/bedework/previousdate" />
  <xsl:variable name="nextdate" select="/bedework/nextdate" />
  <xsl:variable name="curdate" select="/bedework/currentdate/date" />

</xsl:stylesheet>
