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

  <!--==== Head Section ====-->
  <xsl:template name="head">

    <head>
      <title>BW 3.10:
        <xsl:if test="/bedework/page='event'">
          <xsl:value-of select="/bedework/event/summary" />
          <xsl:text> - </xsl:text>
        </xsl:if>
        <xsl:copy-of select="$bwStr-Root-PageTitle" />
      </title>

      <meta property="og:title">
        <xsl:attribute name="content">
          <xsl:choose>
            <xsl:when test="/bedework/page='event'">
              <xsl:value-of select="/bedework/event/summary" />
            </xsl:when>
            <xsl:otherwise><xsl:copy-of select="$bwStr-Root-PageTitle" /></xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </meta>
      <meta property="og:type" content="website" />
      <meta property="og:site_name" content="Bedework Events" />

      <xsl:variable name="ogURL">
        <xsl:choose>
          <xsl:when test="/bedework/page='event'">
            <xsl:value-of select="$eventView"/>&amp;calPath=<xsl:value-of select="bedework/event/calendar/path"/>&amp;guid=<xsl:value-of select="bedework/event/guid"/>&amp;recurrenceId=<xsl:value-of select="bedework/event/recurrenceId"/>
          </xsl:when>
          <xsl:otherwise><xsl:value-of select="$urlPrefix"/></xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <meta property="og:url" content="{$ogURL}"/>


      <xsl:if test="/bedework/page='event'">
        <xsl:if test="normalize-space(xproperties/X-BEDEWORK-IMAGE/values/text) != ''">
          <meta property="og:image">
            <xsl:attribute name="content">
              <xsl:value-of select="substring(/bedework/urlprefix,1,string-length(/bedework/urlprefix)-3)"/>pubcaldav<xsl:value-of select="/bedework/event/xproperties/X-BEDEWORK-IMAGE/values/text"/>
            </xsl:attribute>
          </meta>
        </xsl:if>
        <meta property="og:description">
          <xsl:attribute name="content">
            <xsl:value-of select="/bedework/event/description"/>
          </xsl:attribute>
        </meta>
      </xsl:if>

      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <meta content="text/html;charset=utf-8" http-equiv="Content-Type" />
      <xsl:if test="$useIE-X-UA-Compatible = 'true'">
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
      </xsl:if>

      <link rel="canonical" href="{$ogURL}" />
      <!-- address bar favicon -->
      <link rel="icon" type="image/ico" href="{$favicon}" />

      <!-- load library css -->
      <link rel="stylesheet" type="text/css" media="screen" href="{$resourcesRoot}/javascript/bootstrap3/css/bootstrap.min.css" />
      <link rel="stylesheet" type="text/css" media="screen" href="{$resourcesRoot}/javascript/jquery/jquery-ui-1.10.3.custom.min.css" />
      <!-- load Bedework css ... you may wish to combine (and minify) these files for a production service. -->
      <link rel="stylesheet" type="text/css" media="all" href="{$resourcesRoot}/css/bwThemeGlobal.css" />
      <link rel="stylesheet" type="text/css" media="screen" href="{$resourcesRoot}/css/bwThemeResponsive-00-Tiny.css" /><!-- @media (max-width: 767px) -->
      <link rel="stylesheet" type="text/css" media="screen" href="{$resourcesRoot}/css/bwThemeResponsive-01-Small.css" /><!-- @media (min-width: 768px) and (max-width: 991px) -->
      <link rel="stylesheet" type="text/css" media="screen" href="{$resourcesRoot}/css/bwThemeResponsive-02-Medium.css" /><!-- @media (min-width: 992px) -->
      <link rel="stylesheet" type="text/css" media="screen" href="{$resourcesRoot}/css/bwThemeResponsive-03-Large.css" /><!-- @media (min-width: 1200px) -->
      <link rel="stylesheet" type="text/css" media="print" href="{$resourcesRoot}/css/print.css" />

      <!--  If special CSS support is needed for IE6, IE7, or IE8, uncomment the following block and
            add the css files as shown below.  When uncommenting this block, you MUST fix the
            comments before and after each if statement. That is, remove the space
            in the "<!- -" and the "- ->".  -->
      <!--
      <xsl:text disable-output-escaping="yes">
        <![CDATA[
        <!- -[if IE 6]>
          <link rel="stylesheet" type="text/css" media="screen" href="{$resourcesRoot}/css/ie6.css"/>
        <![endif]- ->
        <!- -[if IE 7]>
          <link rel="stylesheet" type="text/css" media="screen" href="{$resourcesRoot}/css/ie7.css"/>
        < ![endif]- ->
        <!- -[if IE 8]>
          <link rel="stylesheet" type="text/css" media="screen" href="{$resourcesRoot}/css/ie8.css"/>
        <![endif]- ->
        ]]>
      </xsl:text>
      -->

      <!-- load library javascript -->
      <script type="text/javascript" src="{$resourcesRoot}/javascript/modernizr-2.6.2-input.min.js">/* include modernizr */</script>
      <script type="text/javascript" src="{$resourcesRoot}/javascript/jquery/jquery-1.10.2.min.js">/* include jquery */</script>
      <script type="text/javascript" src="{$resourcesRoot}/javascript/jquery/jquery-ui-1.10.3.custom.min.js">/* include jquery UI */</script>
      <!--script type="text/javascript" src="{$resourcesRoot}/javascript/bootstrap3/js/bootstrap.min.js">/* include bootstrap */</script-->
      <script type="text/javascript" src="{$resourcesRoot}/javascript/bootstrap3/respond.min.js">/* include respond for IE6-8 responsive support */</script>

      <!-- load Bedework javascript -->
      <xsl:call-template name="themeJavascriptVariables"/><!-- these are defined in themeSettings.xsl  -->
      <script type="text/javascript" src="{$resourcesRoot}/javascript/bedework/bedework.js">/* bedework */</script>
      <script type="text/javascript" src="{$resourcesRoot}/javascript/bedework/navigation.js">/* bedework navigation (menus, links) */</script>
      <script type="text/javascript" src="{$resourcesRoot}/javascript/bedework/eventList.js">/* bedework list events object */</script>
      <script type="text/javascript" src="/bedework-common/javascript/bedework/bedeworkUtil.js">/* bedework utilities */</script>

      <!-- load conditional javascript -->
      <xsl:if test="/bedework/page='eventList' or /bedework/page='eventscalendar'">
        <link rel="stylesheet" type="text/css" media="screen" href="{$resourcesRoot}/javascript/magnific/magnific-popup.css" />
        <script type="text/javascript" src="{$resourcesRoot}/javascript/magnific/jquery.magnific-popup.min.js">/* for export/subscribe lightbox */</script>
        <link rel="stylesheet" type="text/css" media="screen" href="{$resourcesRoot}/css/bwExportSubscribe.css" />
        <script type="text/javascript" src="{$resourcesRoot}/javascript/bedework/exportSubscribe.js">/* bedework export/subscribe form */</script>
        <script src="/bedework-common/javascript/jquery/spin.min.js">/* spinner for event load animations */</script>
      </xsl:if>
      <xsl:if test="/bedework/page='searchResult'">
        <script type="text/javascript" src="{$resourcesRoot}/javascript/catSearch.js">/* category search */</script> <!-- probably should be deprecated-->
      </xsl:if>


      <xsl:variable name="navDate">
        <xsl:choose>
          <xsl:when test="/bedework/appvar[key='navDate']/value != ''">
            <xsl:choose>
              <xsl:when test="contains(/bedework/appvar[key='navDate']/value,'-')"><xsl:value-of select="/bedework/appvar[key='navDate']/value"/></xsl:when>
              <xsl:otherwise><xsl:value-of select="substring(/bedework/appvar[key='navDate']/value,0,5)"/><xsl:text>-</xsl:text><xsl:value-of select="substring(/bedework/appvar[key='navDate']/value,5,2)"/><xsl:text>-</xsl:text><xsl:value-of select="substring(/bedework/appvar[key='navDate']/value,7,2)"/></xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise><xsl:value-of select="substring(/bedework/currentdate/date,0,5)"/><xsl:text>-</xsl:text><xsl:value-of select="substring(/bedework/currentdate/date,5,2)"/><xsl:text>-</xsl:text><xsl:value-of select="substring(/bedework/currentdate/date,7,2)"/></xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <!-- Set up list and navigation options for the main events list - must be global.
           The list of URLs is for use by JavaScript functions.  These are
           passed up from the client XML and contain the context.  -->
      <script type="text/javascript">
        var bwPage = "<xsl:value-of select="/bedework/page"/>";
        var bwListPage = "<xsl:value-of select="/bedework/appvar[key='listPage']/value"/>";
        var bwLastDateSeparatorInList = "<xsl:value-of select="/bedework/appvar[key='lastDateSeparatorInList']/value"/>";
        var bwClearFilterStr = '<xsl:value-of select="$bwStr-LsEv-ClearFilters"/>';
        var bwResourcesRoot = "<xsl:value-of select="$resourcesRoot"/>";

        var bwUrls = new Object;
        bwUrls = {
          "setSelection" : "<xsl:value-of select="$setSelection"/>",
          "setSelectionList" : "<xsl:value-of select="$setSelectionList"/>",
          "async" : "<xsl:value-of select="$async"/>",
          "feedPrefix" : "<xsl:value-of select="/bedework/cachePrefix"/>",
          "feedResources" : "/calfeedrsrc.MainCampus/default/default/theme"
        }

        // calendar explorers
        var closedViews = new Array();
        var openCals = new Array();
        <xsl:if test="/bedework/appvar[key='closedViews']">
          var closedViewsRaw = "<xsl:value-of select="/bedework/appvar[key='closedViews']/value"/>";
          closedViews = closedViewsRaw.split(",");
        </xsl:if>
        <xsl:if test="/bedework/appvar[key='opencals']">
          var openCalsRaw = "<xsl:value-of select="/bedework/appvar[key='opencals']/value"/>";
          openCals = openCalsRaw.split(",");
        </xsl:if>

        // set up the filtering objects
        var bwQuery = "";

        // search query
        <xsl:if test="/bedework/appvar[key='bwQuery']">
          bwQuery = "<xsl:value-of select="/bedework/appvar[key='bwQuery']/value"/>";
        </xsl:if>
        var bwQueryName = "<xsl:value-of select="$bwStr-LsEv-Filter"/>";
        <xsl:choose>
          <xsl:when test="/bedework/page = 'eventscalendar'">
            var bwClearQueryMarkup = '<a id="bwClearQuery" href="{$setSelection}&amp;viewName=All&amp;setappvar=bwFilters()&amp;setappvar=bwFilterLabels()"><xsl:value-of select="$bwStr-LsEv-ClearSearch"/></a>';
          </xsl:when>
          <xsl:otherwise>
            var bwClearQueryMarkup = '<a id="bwClearQuery" href="javascript:bwClearSearch();"><xsl:value-of select="$bwStr-LsEv-ClearSearch"/></a>';
          </xsl:otherwise>
        </xsl:choose>


        // filters from menus
        var bwFilters = new Array(); <!-- 2D array -->
        var bwFilterPaths = new Array(); <!-- 2D array -->

        <xsl:for-each select="/bedework/views/view">
          bwFilters[<xsl:value-of select="position()-1"/>] = new Array();
        </xsl:for-each>
        <xsl:if test="/bedework/appvar[key='bwFilters']">
          var bwFiltersRaw = "<xsl:value-of select="/bedework/appvar[key='bwFilters']/value"/>";
          bwFilters = restoreFilters(bwFiltersRaw);
        </xsl:if>

        var bwFilterPrefix = "";
        <xsl:if test="$ongoingEventsEnabled = 'true'">
          bwFilterPrefix = '(categories.href!="<xsl:value-of select="$ongoingEventsCatPath"/>")';
        </xsl:if>

        <!-- The main list options - only used if the dataType is set to "json" -->
        var bwMainEventsListOptions = {
          title: "<xsl:copy-of select="$bwStr-LsEv-Upcoming"/>",
          showTitle: false,
          displayDescription: false,
          displayEventDetailsInline: false,
          displayDayNameInList: true,
          displayTimeInList: true,
          displayLocationInList: true,
          locationTitle: "<xsl:copy-of select="$bwStr-LsVw-Location"/>",
          displayTopicalAreasInList: true,
          topicalAreasTitle: "<xsl:copy-of select="$bwStr-LsVw-TopicalArea"/>",
          displayThumbnailInList: <xsl:value-of select="$thumbsEnabled"/>,
          thumbWidth: <xsl:value-of select="$thumbWidth"/>,
          useFullImageThumbs: <xsl:value-of select="$useFullImageThumbs"/>,
          usePlaceholderThumb: <xsl:value-of select="$usePlaceholderThumb"/>,
          eventImagePrefix: "<xsl:value-of select="$bwEventImagePrefix"/>",
          resourcesRoot: "<xsl:value-of select="$resourcesRoot"/>",
          limitList: false,
          limit: 5,
          listMode: "byTitle",
          displayContactInDetails: true,
          displayCostInDetails: true,
          displayTagsInDetails: true,
          displayTimezoneInDetails: true,
          displayNoEventText: true,
          showTitleWhenNoEvents: false,
          noEventsText: "<xsl:copy-of select="$bwStr-LsVw-NoEventsToDisplay"/>"
        };

        var bwMainEventList;

        <!-- Put it all together after the page renders. -->
        $(document).ready(function(){
          <!-- Retrieve any existing filter paths (pulled from the DOM) -->
          bwFilterPaths = buildFilterPaths();

          <!-- Create the main event list object -->
          bwMainEventList = new BwEventList("listEvents","html",bwMainEventsListOptions,"<xsl:value-of select="$navDate"/>",bwFilterPrefix,bwFilterPaths,bwQuery,"<xsl:value-of select="$setMainEventList"/>","<xsl:value-of select="$nextMainEventList"/>","bwStartDate","bwResultSize",10);

          <!-- show filters / highlight selected nav -->
          displayAllFilters(bwFilters);
        });
      </script>

      <xsl:if test="$eventIconShareThis = 'true'">
        <!-- ShareThis code.  Gets publisher code from variable set in themeSettings.xsl -->
        <script type="text/javascript" src="http://w.sharethis.com/button/buttons.js"><xsl:text> </xsl:text></script>
        <script type="text/javascript">
           stLight.options({
            publisher:'<xsl:value-of select="$shareThisCode"/>',
            offsetTop:'0'
           })
        </script>
      </xsl:if>

    </head>
  </xsl:template>

</xsl:stylesheet>
