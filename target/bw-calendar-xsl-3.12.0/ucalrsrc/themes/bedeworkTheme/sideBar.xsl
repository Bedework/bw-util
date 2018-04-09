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

  <xsl:template name="sideBar">
    <!--  We'll leave the following views block here in case we (or someone) wants to make use of views.
          We are not using them at the moment in the personal client, so we'll hide it. -->
    <!--
    <h3>
      <xsl:copy-of select="$bwStr-SdBr-Views"/>
    </h3>
    <ul id="myViews">
      <xsl:choose>
        <xsl:when test="/bedework/views/view">
          <xsl:for-each select="/bedework/views/view">
            <xsl:variable name="viewName" select="name"/>
            <xsl:choose>
              <xsl:when test="/bedework/selectionState/selectionType = 'view'
                              and name=/bedework/selectionState/view/name">
                <li class="selected"><a href="{$setSelection}&amp;viewName={$viewName}"><xsl:value-of select="name"/></a></li>
              </xsl:when>
              <xsl:otherwise>
                <li><a href="{$setSelection}&amp;viewName={$viewName}"><xsl:value-of select="name"/></a></li>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <li class="none"><xsl:copy-of select="$bwStr-SdBr-NoViews"/></li>
        </xsl:otherwise>
      </xsl:choose>
    </ul>
    -->

    <h3>
      <a href="{$calendar-fetch}" title="{$bwStr-SdBr-ManageCalendarsAndSubscriptions}" class="calManageLink">
        <xsl:copy-of select="$bwStr-SdBr-Manage"/>
      </a>
      <xsl:copy-of select="$bwStr-SdBr-Calendars"/>
    </h3>
    <!-- normal calendars -->
    <ul class="calendarTree">
      <xsl:choose>
        <xsl:when test="$publicOnly = 'true'">
          <xsl:apply-templates select="/bedework/myCalendars/calendars/calendar[calType = 0]" mode="myCalendars"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="/bedework/myCalendars/calendars/calendar[calType &lt; 2 or calType = 4 or calType = 7 or calType = 8]" mode="myCalendars"/>
        </xsl:otherwise>
      </xsl:choose>
    </ul>
    <!-- special calendars: inbox, outbox, and trash -->
    <xsl:if test="$publicOnly = 'false'">
      <ul class="calendarTree">
        <xsl:apply-templates select="/bedework/myCalendars/calendars/calendar/calendar[calType = 5]" mode="mySpecialCalendars"/> <!-- inbox -->
        <!--<xsl:apply-templates select="/bedework/myCalendars/calendars/calendar/calendar[calType = 6]" mode="mySpecialCalendars"/> --> <!-- outbox: do not display -->
        <xsl:apply-templates select="/bedework/myCalendars/calendars/calendar/calendar[calType = 2]" mode="mySpecialCalendars"/> <!-- trash -->
        <xsl:apply-templates select="/bedework/myCalendars/calendars/calendar/calendar[calType = 3]" mode="mySpecialCalendars"/> <!-- deleted -->
      </ul>
    </xsl:if>

    <!--
    <h3>
      <a href="{$subscriptions-fetch}" title="manage subscriptions">
        manage
      </a>
      subscriptions
    </h3>
    <ul class="calendarTree">
      <xsl:variable name="userPath">user/<xsl:value-of select="/bedework/userid"/></xsl:variable>
      <xsl:choose>
        <xsl:when test="/bedework/mySubscriptions/subscription[not(contains(uri,$userPath))]">
          <xsl:apply-templates select="/bedework/mySubscriptions/subscription[not(contains(uri,$userPath))]" mode="mySubscriptions"/>
        </xsl:when>
        <xsl:otherwise>
          <li class="none">no subscriptions</li>
        </xsl:otherwise>
      </xsl:choose>
    </ul>-->

    <h3><xsl:copy-of select="$bwStr-SdBr-Options"/></h3>
    <ul id="sideBarMenu">
      <xsl:if test="$publicOnly = 'false' and $useAddressBook = 'true'">
        <li>
          <xsl:variable name="userid" select="/bedework/userid"/>
          <a href="/bwAddrbookClient/?user={$userid}" target="bwAddrBook">
            <img height="13" border="0" width="13"
            src="{$resourcesRoot}/images/silk/book.png"
            alt="{$bwStr-SdBr-AddrBook}" />
            <xsl:text> </xsl:text>
            <xsl:copy-of select="$bwStr-SdBr-AddrBook"/>
          </a>
        </li>
      </xsl:if>
      <li class="prefs">
        <a href="{$prefs-fetchForUpdate}">
          <img height="13" border="0" width="13"
            src="{$resourcesRoot}/images/prefsIcon.gif"
            alt="upload event" />
          <xsl:text> </xsl:text>
          <xsl:copy-of select="$bwStr-SdBr-Preferences"/>
        </a>
      </li>
      <xsl:if test="$publicOnly = 'false'">
        <li>
          <a href="{$initUpload}" title="{$bwStr-SdBr-UploadEvent}">
            <img height="16" border="0" width="12"
            src="{$resourcesRoot}/images/std-icalUpload-icon-small.gif"
            alt="upload ical" />
            <xsl:text> </xsl:text>
            <xsl:copy-of select="$bwStr-SdBr-UploadICal"/>
          </a>
        </li>
      </xsl:if>
      <li>
        <a href="{$calendar-listForExport}" title="{$bwStr-SdBr-ExportCalendars}">
          <img height="16" border="0" width="12"
            src="{$resourcesRoot}/images/std-icalDownload-icon-small.gif"
            alt="upload event" />
          <xsl:text> </xsl:text>
          <xsl:copy-of select="$bwStr-SdBr-ExportCalendars"/>
        </a>
      </li>
    </ul>
  </xsl:template>

</xsl:stylesheet>