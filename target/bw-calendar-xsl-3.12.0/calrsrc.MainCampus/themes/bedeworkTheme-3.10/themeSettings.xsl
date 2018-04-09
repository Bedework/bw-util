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

  <!-- BEDEWORK THEME SETTINGS -->

  <!-- URL of html resources (images, css, other html) for the current theme.
       This value is self-referential and should always match the directory name of the current theme.
       Don't change this value unless you know what you're doing. -->
  <xsl:variable name="resourcesRoot"><xsl:value-of select="/bedework/browserResourceRoot" />/themes/bedeworkTheme-3.10</xsl:variable>

  <!-- Root context of uploaded event images -->
  <xsl:variable name="bwEventImagePrefix">/pubcaldav</xsl:variable>

  <!-- ============================== -->
  <!-- Features for the current theme -->
  <!-- ============================== -->
  <!-- Note: Set the global calendar suite preferences
       in the administrative web client (default view, default viewPeriod, etc) -->

  <!-- HOW TO CLEAR THE CACHE:
       Bedework caches stylesheets to improve performance.
       To see changes to this file (or any xslt file) reflected on a running system
       (i.e. to clear the stylesheet cache), append "refreshXslt=yes" to the query
       string in your browser's address bar.
       For example: "http://localhost:8080/cal/showMain.rdo?refreshXslt=yes

       Clicking the "Refresh XSLT" link at the bottom of most Bedework themes
       will do this for you.

       For more information about theming, see the Bedework Manual -->


  <!-- CUSTOM CONTENT: FAVICON, MASTHEAD, LEFT COLUMN, FOOTER -->
  <!-- The masthead, left column, and footer templates below are pulled
       into the theme using internationalized strings
       (found in ../default/strings.xsl).

       If you plan on using only one language, you can safely
       change the <xsl:copy> blocks to plain text below.

       If you plan on using more than one language, use the
       strings.xsl file.  See the manual about setting up a
       strings.xsl for multiple languages. -->


  <!-- MASTHEAD / LOGO / SITE-TITLE -->
  <!-- For simple logo replacement, change your logo values here. Original logo height is 40px.
       More advanced and/or responsive choices can be made altering the contents of
       the html in this variable and/or by using CSS. As noted above, if you intend to support only one
       language, you can simply replace the xsl:copy-of tags below with plain text.-->
  <xsl:variable name="masthead">
    <div id="siteTitleAndNav" class="hidden-xs">
      <!-- siteTitleAndNav is hidden on small devices, where the mobile menu appears -->
      <h1><xsl:copy-of select="$bwStr-HdBr-SiteTitle" /></h1>
      <ul>
        <li>
          <a href="/bedework">
            <xsl:copy-of select="$bwStr-HdBr-UniversityHome" />
          </a>
        </li>
        <li class="last">
          <a href="?refreshXslt=yes">
            <xsl:copy-of select="$bwStr-HdBr-OtherLink" />
          </a>
        </li>
      </ul>
    </div>
    <div id="siteLogo">
      <a href="/bedework">
        <img src="{$resourcesRoot}/images/bedework.png" width="243" height="40" alt="Bedework Calendar"/>
      </a>
    </div>
  </xsl:variable>


  <!-- FAVICON -->
  <!-- address bar icon -->
  <xsl:variable name="favicon"><xsl:value-of select="$resourcesRoot"/>/images/bedework.ico</xsl:variable>


  <!-- FOOTER TEXT/LINKS -->
  <!-- Show the skin select box in the footer?
  You may also opt to remove the form in footer.xsl. -->
  <xsl:variable name="showFootForm">true</xsl:variable>

  <!-- text in the footer -->
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
    <!--xsl:copy-of select="$bwStr-Foot-Credits" /-->
  </xsl:template>


  <!-- LEFT COLUMN TEXT -->
  <!-- custom text in the left column -->
  <xsl:template name="leftColumnText">
    <div class="leftMenuTitle"><xsl:copy-of select="$bwStr-LCol-Options"/></div>
    <ul class="sideLinks">
      <li>
        <a href="{$fetchPublicCalendars}">
          <xsl:copy-of select="$bwStr-LCol-DownloadCalendars"/>
        </a>
      </li>
      <li>
        <a href="/caladmin"><xsl:copy-of select="$bwStr-LCol-ManageEvents"/></a>
      </li>
      <li>
        <a href="/eventsubmit">
          <xsl:copy-of select="$bwStr-LCol-Submit"/>
        </a>
      </li>
      <li>
        <a href="http://www.jasig.org/bedework/documentation"><xsl:copy-of select="$bwStr-LCol-Help"/></a>
      </li>
    </ul>
  </xsl:template>



  <!-- DISPLAY ADVANCED DATE RANGE MENU? -->
  <!-- Links under the date picker "upcoming, day, week, month" can be
       optionally enabled or disabled.  If turned off, you are advised
       to set your calendar suite preferences to use the "UPCOMING"  default
       view mode.  Disabling this menu makes the user interface simpler.
       Enabling it provides more ways of looking at the event lists. -->
  <xsl:variable name="useAdvancedDateRangeMenu">true</xsl:variable>

  <!-- DISPLAY A DATE SEPARATOR IN UPCOMING EVENT LIST? -->
  <!-- If true, a date will be inserted between events in the upcoming
       list when the start date changes.  Note that events that cross
       day boundaries will NOT be duplicated.  (For that behavior,
       turn on the advanced date range menu, and use the week or month
       view where this is the default behavior.)-->
  <xsl:variable name="useDateSeparatorsInList">true</xsl:variable>

  <!-- DATE PICKER: USE HTML5 NATIVE? -->
  <!-- If true, the native HTML5 date picker will be used in browsers that
       support it (e.g. iPhone, iPad, Chrome).  If false, the jquery date picker
       will be used across all browsers. The jquery date picker will be used
       in browsers that do not yet support a native date picker regardless of
       this setting. -->
  <xsl:variable name="useHTML5DatePicker">true</xsl:variable>

  <!-- IE COMPATIBILITY MODE -->
  <!-- Support latest rendering for IE?  This switch turns on the following
       meta tag in head.xsl:
       <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
       Note that this invalidates the page relative to W3C, so set it to false if
       you want to remain valid HTML 5; but understand that earlier versions of
       IE may not work well without this.  -->
  <xsl:variable name="useIE-X-UA-Compatible">false</xsl:variable>


  <!-- EVENT ACTION ICONS -->
  <!-- which services to include for event actions in list and detail view: -->

  <!-- download ics file -->
  <xsl:variable name="eventIconDownloadIcs">true</xsl:variable>

  <!-- download event to my personal Bedework calendar ... use only
       if you plan on running the Bedework personal client  -->
  <xsl:variable name="eventIconAddToMyCal">true</xsl:variable>

  <!-- add to Google calendar -->
  <xsl:variable name="eventIconGoogleCal">true</xsl:variable>

  <!-- "Share This"
       Works, but has a bogus publishers code.  Replace with yours.
       Also, set the summary line to reflect your institution. E.g., "MyCollege Events Calendar"
  -->
  <xsl:variable name="eventIconShareThis">true</xsl:variable>
  <xsl:variable name="shareThisCode">bogus</xsl:variable>
  <xsl:variable name="shareThisSummary">Bedework Events Calendar</xsl:variable>




  <!-- FEATURED EVENTS TRIPTYCH -->
  <!-- Display the featured event images? -->
  <xsl:variable name="featuredEventsEnabled">true</xsl:variable>

  <!-- a master switch - default for the 3.10 theme is "true" -->
  <xsl:variable name="featuredEventsAlwaysOn">true</xsl:variable>

  <!-- a master switch for small devices - default for the 3.10 theme is "true" -->
  <xsl:variable name="featuredEventsHiddenOnSmallDevices">true</xsl:variable>

  <!-- if the above switch is false, the following settings take effect,
       showing or hiding the featured events images for each view. -->
  <xsl:variable name="featuredEventsForEventList">true</xsl:variable><!-- upcoming events -->
  <xsl:variable name="featuredEventsForEventDisplay">false</xsl:variable><!-- a single event -->
  <xsl:variable name="featuredEventsForDay">true</xsl:variable>
  <xsl:variable name="featuredEventsForWeek">true</xsl:variable>
  <xsl:variable name="featuredEventsForMonth">false</xsl:variable>
  <xsl:variable name="featuredEventsForYear">false</xsl:variable>
  <xsl:variable name="featuredEventsForCalList">false</xsl:variable>




  <!-- ONGOING EVENTS -->
  <!-- Use the ongoing events sidebar? -->
  <!-- If ongoing events sidebar is enabled,
   you must set UseCategory for ongoing events to appear. -->
  <xsl:variable name="ongoingEventsEnabled">true</xsl:variable>

  <!-- Use the specified category to mark an event as ongoing.  -->
  <xsl:variable name="ongoingEventsUseCategory">true</xsl:variable>

  <!-- There are three methods of identifying the Ongoing events, category uid,
       category path, and alias. All three are used in different ways in this theme,
       so set them all.  -->
  <!-- The following CatUid represents category "sys/Ongoing" -->
  <xsl:variable name="ongoingEventsCatUid">402881e7-25b99d14-0125-b9a50c22-00000002</xsl:variable>
  <!-- The following CatPath represents category "sys/Ongoing" -->
  <xsl:variable name="ongoingEventsCatPath">/public/.bedework/categories/sys/Ongoing</xsl:variable>
  <!-- The following Alias represents category "sys/Ongoing" -->
  <xsl:variable name="ongoingEventsAlias">/user/agrp_calsuite-MainCampus/Ongoing</xsl:variable>

  <!-- Always display sidebar, even if no events are ongoing? -->
  <xsl:variable name="ongoingEventsAlwaysDisplayed">true</xsl:variable>

  <!-- Reveal ongoing events in the main event list
       when a collection (e.g calendar "Exhibits") is directly selected? -->
  <xsl:variable name="ongoingEventsShowForCollection">true</xsl:variable>




  <!-- EVENT REGISTRATION SYSTEM -->
  <!-- Bedework provides an application that allows users to register for events. -->

  <!-- Enable the events registration system?  If set to true, the theme will
       look for registration X-Properties and expose the registration system to
       users for registerable events. -->
  <xsl:variable name="eventRegEnabled">true</xsl:variable>

  <!-- Location of the event registration application; this is set to the
       default quickstart location. If you move it, you must change this
       value. The value includes the path to initialize the system on page load.  -->
  <xsl:variable name="eventReg">/eventreg/ureg/init.do</xsl:variable>

  <!-- Location of the external users event registration application; this is set to the
       default quickstart location. If you move it, you must change this
       value. The value includes the path to initialize the system on page load.  -->
  <xsl:variable name="extEventReg">/eventregext/ureg/init.do</xsl:variable>




  <!-- FEED URL AND WIDGET BUILDER -->
  <!-- The urlbuilder constructs filtered feeds (e.g. json, rss, xml)
       and widgets and points to the cached feeder application for delivery. -->

  <!-- Location of the urlbuilder application; this is set to the
       default quickstart location. If you move it, you must change this
       value. -->
  <xsl:variable name="urlbuilder">/urlbuilder</xsl:variable>

  <!-- Embed the urlbuilder??
       If true, the urlbuilder will be rendered in an iframe.
       If false, it will be treated as an external link.  -->
  <xsl:variable name="embedUrlBuilder">false</xsl:variable>




  <!-- EVENT THUMBNAILS -->
  <!-- Use event thumbnails in the "upcoming" event listings? (see eventList.xsl) -->
  <xsl:variable name="thumbsEnabled">true</xsl:variable>
  <!-- Thumbnail width (default should be 80px) -->
  <xsl:variable name="thumbWidth">80</xsl:variable>
  <!-- Use full-size image scaled to a thumbnail if only full-size image is present? -->
  <xsl:variable name="useFullImageThumbs">true</xsl:variable>
  <!-- Use a placeholder thumbnail in listing if no image supplied with event? -->
  <xsl:variable name="usePlaceholderThumb">false</xsl:variable>
  <!-- Use a blank instead of an image for placeholder -->
  <xsl:variable name="usePlaceholderThumbBlank">true</xsl:variable>

  <!-- THE FOLLOWING THREE SETTINGS ARE NOT IMPLEMENTED IN AJAX LISTINGS -->
  <!-- Limit thumbs to specific views and collections? (Used with the next two variables.) -->
  <xsl:variable name="limitThumbs">false</xsl:variable>
  <!-- Limit the thumbs to these comma separated view names: -->
  <xsl:variable name="limitThumbsToView"></xsl:variable>
  <!-- Limit the thumbs to these comma separated collections (full virtual paths): -->
  <xsl:variable name="limitThumbsToCollections"></xsl:variable>





  <!-- JAVASCRIPT CONSTANTS -->
  <xsl:template name="themeJavascriptVariables">
    <!--
      If you have any JavaScript constants/variables, add them here.
      These will end up in the head section of the page.
      This is currently used to load some sting constants from strings.xsl
    -->
    <script type="text/javascript">
      var bwStrEvent = "<xsl:value-of select="$bwStr-LsEv-Event"/>";
      var bwStrEvents = "<xsl:value-of select="$bwStr-LsEv-Events"/>";
    </script>
  </xsl:template>




  <!-- NOT YET ENABLED -->
  <!-- the following features did not make the 3.8 release, and are here
       for reference -->

   <!-- DEADLINES/TASKS -->
   <!-- use the deadlines sidebar? -->
   <!-- if deadlines sidebar is enabled, deadlines will appear
        in the sidebar under ongoing events.  Deadlines will
        be presented as tasks and will be treated as such in
        calendar clients. -->
   <!-- <xsl:variable name="deadlinesEnabled">false</xsl:variable> -->

   <!-- always display sidebar, even if no deadlines are present? -->
   <!-- <xsl:variable name="deadlinesAlwaysDisplayed">true</xsl:variable> -->

  <!-- FOR ONGOING EVENTS -->
  <!-- pull normal events that are longer than day range into ongoing list? -->
  <!-- (this automates the use of ongoing - tagging not needed) -->
  <!-- <xsl:variable name="ongoingEventsUseDayRange">false</xsl:variable> -->
  <!-- <xsl:variable name="ongoingEventsDayRange">12</xsl:variable> -->

</xsl:stylesheet>
