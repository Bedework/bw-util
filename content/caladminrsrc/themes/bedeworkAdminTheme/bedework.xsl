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
  <xsl:output method="xml" indent="yes" media-type="text/html"
              standalone="yes" omit-xml-declaration="yes" />

  <!-- DEFINE INCLUDES -->
  <!-- Theme preferences -->
  <xsl:include href="themeSettings.xsl" />

  <!-- Site subsections -->
  <xsl:include href="head.xsl" />
  <xsl:include href="header.xsl" />
  <xsl:include href="notifications.xsl" />
  <xsl:include href="tabs.xsl" />
  <xsl:include href="messagesErrors.xsl" />
  <xsl:include href="mainMenu.xsl" />
  <xsl:include href="eventsManage.xsl" />
  <xsl:include href="eventsListCommon.xsl" />
  <xsl:include href="eventsListControls.xsl" />
  <xsl:include href="eventsForm.xsl" />
  <xsl:include href="eventsDisplay.xsl" />
  <xsl:include href="eventsPending.xsl" />
  <xsl:include href="eventsApprovalQueue.xsl" />
  <xsl:include href="eventsSuggestionQueue.xsl" />
  <xsl:include href="contacts.xsl" />
  <xsl:include href="locations.xsl" />
  <xsl:include href="categories.xsl" />
  <xsl:include href="calendar.xsl" />
  <xsl:include href="calendarLists.xsl" />
  <xsl:include href="calendarForm.xsl" />
  <xsl:include href="subscriptions.xsl" />
  <xsl:include href="accessControl.xsl" />
  <xsl:include href="views.xsl" />
  <xsl:include href="resources.xsl" />
  <xsl:include href="calSuites.xsl" />
  <xsl:include href="calSuiteForm.xsl" />
  <xsl:include href="calSuitePrefs.xsl" />
  <xsl:include href="user.xsl" />
  <xsl:include href="userPrefs.xsl" />
  <xsl:include href="adminGroups.xsl" />
  <xsl:include href="search.xsl" />
  <xsl:include href="systemMain.xsl" />
  <xsl:include href="systemParams.xsl" />
  <xsl:include href="filters.xsl" />
  <xsl:include href="upload.xsl" />
  <xsl:include href="timezones.xsl" />
  <xsl:include href="stats.xsl" />
  <xsl:include href="footer.xsl" />

  <!--==== MAIN TEMPLATE  ====-->
  <xsl:template match="/">
<xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html></xsl:text><!-- HTML5 -->
    <html lang="en">
      <xsl:call-template name="head"/>
      <body>
        <div id="bedework"><!-- main wrapper div to keep styles encapsulated -->
        <xsl:choose>
          <xsl:when test="/bedework/page='selectCalForEvent'">
            <xsl:call-template name="selectCalForEvent"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="header"/>
            <xsl:call-template name="tabs"/>
            <div id="content">
              <xsl:choose>
                <xsl:when test="/bedework/page='tabPendingEvents'">
                  <xsl:call-template name="tabPendingEvents"/>
                </xsl:when>
                <xsl:when test="/bedework/page='tabApprovalQueueEvents'">
                  <xsl:call-template name="tabApprovalQueueEvents"/>
                </xsl:when>
                <xsl:when test="/bedework/page='tabSuggestionQueueEvents'">
                  <xsl:call-template name="tabSuggestionQueueEvents"/>
                </xsl:when>
                <xsl:when test="/bedework/page='tabCalsuite'">
                  <xsl:call-template name="tabCalsuite"/>
                </xsl:when>
                <xsl:when test="/bedework/page='tabUsers'">
                  <xsl:call-template name="tabUsers"/>
                </xsl:when>
                <xsl:when test="/bedework/page='tabSystem'">
                  <xsl:call-template name="tabSystem"/>
                </xsl:when>
                <xsl:when test="/bedework/page='eventList'">
                  <xsl:call-template name="eventList"/>
                </xsl:when>
                <xsl:when test="/bedework/page='modEvent' or
                               /bedework/page='modEventPending' or
                               /bedework/page='modEventApprovalQueue' or
                               /bedework/page='modEventSuggestionQueue'">
                  <xsl:apply-templates select="/bedework/formElements" mode="modEvent"/>
                </xsl:when>
                <xsl:when test="/bedework/page='displayEvent' or
                                /bedework/page='deleteEventConfirm' or
                                /bedework/page='deleteEventConfirmPending' or
                                /bedework/page='deleteEventConfirmApprovalQueue' or
                                /bedework/page='deleteEventConfirmSuggestionQueue'">
                  <xsl:apply-templates select="/bedework/event" mode="displayEvent"/>
                </xsl:when>
                <xsl:when test="/bedework/page='contactList'">
                  <xsl:call-template name="contactList"/>
                </xsl:when>
                <xsl:when test="/bedework/page='modContact'">
                  <xsl:call-template name="modContact"/>
                </xsl:when>
                <xsl:when test="/bedework/page='deleteContactConfirm'">
                  <xsl:call-template name="deleteContactConfirm"/>
                </xsl:when>
                <xsl:when test="/bedework/page='contactReferenced'">
                  <xsl:call-template name="contactReferenced"/>
                </xsl:when>
                <xsl:when test="/bedework/page='locationList'">
                  <xsl:call-template name="locationList"/>
                </xsl:when>
                <xsl:when test="/bedework/page='modLocation'">
                  <xsl:call-template name="modLocation"/>
                </xsl:when>
                <xsl:when test="/bedework/page='deleteLocationConfirm'">
                  <xsl:call-template name="deleteLocationConfirm"/>
                </xsl:when>
                <xsl:when test="/bedework/page='locationReferenced'">
                  <xsl:call-template name="locationReferenced"/>
                </xsl:when>
                <xsl:when test="/bedework/page='categoryList'">
                  <xsl:call-template name="categoryList"/>
                </xsl:when>
                <xsl:when test="/bedework/page='modCategory'">
                  <xsl:call-template name="modCategory"/>
                </xsl:when>
                <xsl:when test="/bedework/page='deleteCategoryConfirm'">
                  <xsl:call-template name="deleteCategoryConfirm"/>
                </xsl:when>
                <xsl:when test="/bedework/page='categoryReferenced'">
                  <xsl:call-template name="categoryReferenced"/>
                </xsl:when>
                <xsl:when test="/bedework/page='calendarList' or
                                /bedework/page='calendarDescriptions' or
                                /bedework/page='displayCalendar' or
                                /bedework/page='modCalendar' or
                                /bedework/page='deleteCalendarConfirm' or
                                /bedework/page='calendarReferenced'">
                  <xsl:apply-templates select="/bedework/calendars" mode="calendarCommon"/>
                </xsl:when>
                <xsl:when test="/bedework/page='moveCalendar'">
                  <xsl:call-template name="calendarMove"/>
                </xsl:when>
                <xsl:when test="/bedework/page='subscriptions' or
                                /bedework/page='modSubscription' or
                                /bedework/page='deleteSubConfirm'">
                  <xsl:apply-templates select="/bedework/calendars" mode="subscriptions"/>
                </xsl:when>
                <xsl:when test="/bedework/page='views'">
                  <xsl:apply-templates select="/bedework/views" mode="viewList"/>
                </xsl:when>
                <xsl:when test="/bedework/page='modView'">
                  <xsl:call-template name="modView"/>
                </xsl:when>
                <xsl:when test="/bedework/page='deleteViewConfirm'">
                  <xsl:call-template name="deleteViewConfirm"/>
                </xsl:when>
                <!-- Calendar Suite Resources -->
                <xsl:when test="/bedework/page='resources'">
                  <xsl:call-template name="listResources" />
                </xsl:when>
                <xsl:when test="/bedework/page='modResource'">
                  <xsl:call-template name="modResource"/>
                </xsl:when>
                <xsl:when test="/bedework/page='deleteResourceConfirm'">
                  <xsl:call-template name="deleteResourceConfirm"/>
                </xsl:when>
                <!-- Global Resources -->
                <xsl:when test="/bedework/page='globalresources'">
                  <xsl:call-template name="listResources">
                    <xsl:with-param name="global" select="'true'" />
                  </xsl:call-template>
                </xsl:when>
                <xsl:when test="/bedework/page='modSyspars'">
                  <xsl:call-template name="modSyspars"/>
                </xsl:when>
                <xsl:when test="/bedework/page='calSuiteList'">
                  <xsl:apply-templates select="/bedework/calSuites" mode="calSuiteList"/>
                </xsl:when>
                <xsl:when test="/bedework/page='addCalSuite'">
                  <xsl:call-template name="addCalSuite"/>
                </xsl:when>
                <xsl:when test="/bedework/page='modCalSuite'">
                  <xsl:apply-templates select="/bedework/calSuite"/>
                </xsl:when>
                <xsl:when test="/bedework/page='calSuitePrefs'">
                  <xsl:call-template name="calSuitePrefs"/>
                </xsl:when>
                <xsl:when test="/bedework/page='authUserList'">
                  <xsl:call-template name="authUserList"/>
                </xsl:when>
                <xsl:when test="/bedework/page='modAuthUser'">
                  <xsl:call-template name="modAuthUser"/>
                </xsl:when>
                <xsl:when test="/bedework/page='modPrefs'">
                  <xsl:call-template name="modPrefs"/>
                </xsl:when>
                <xsl:when test="/bedework/page='chooseGroup'">
                  <xsl:apply-templates select="/bedework/groups" mode="chooseGroup"/>
                </xsl:when>
                <xsl:when test="/bedework/page='adminGroupList'">
                  <xsl:call-template name="listAdminGroups"/>
                </xsl:when>
                <xsl:when test="/bedework/page='modAdminGroup'">
                  <xsl:call-template name="modAdminGroup"/>
                </xsl:when>
                <xsl:when test="/bedework/page='modAdminGroupMembers'">
                  <xsl:call-template name="modAdminGroupMembers"/>
                </xsl:when>
                <xsl:when test="/bedework/page='deleteAdminGroupConfirm'">
                  <xsl:call-template name="deleteAdminGroupConfirm"/>
                </xsl:when>
                <xsl:when test="/bedework/page='addFilter'">
                  <xsl:call-template name="addFilter"/>
                </xsl:when>
                <xsl:when test="/bedework/page='searchResult'">
                  <xsl:call-template name="searchResult"/>
                </xsl:when>
                <xsl:when test="/bedework/page='noGroup'">
                  <h2><xsl:copy-of select="$bwStr-Root-NoAdminGroup"/></h2>
                  <p><xsl:copy-of select="$bwStr-Root-YourUseridNotAssigned"/></p>
                </xsl:when>
                <xsl:when test="/bedework/page='upload'">
                  <xsl:call-template name="upload"/>
                </xsl:when>
                <xsl:when test="/bedework/page='uploadTimezones'">
                  <xsl:call-template name="uploadTimezones"/>
                </xsl:when>
                <xsl:when test="/bedework/page='showSysStats'">
                  <xsl:apply-templates select="/bedework/sysStats" mode="showSysStats"/>
                </xsl:when>
                <xsl:when test="/bedework/page='noAccess'">
                  <h2><xsl:copy-of select="$bwStr-Root-NoAccess"/></h2>
                  <p>
                    <xsl:copy-of select="$bwStr-Root-YouHaveNoAccess"/>
                  </p>
                  <p>
                    <a href="{$setup}"><xsl:copy-of select="$bwStr-Root-Continue"/></a>
                  </p>
                </xsl:when>
                <xsl:when test="/bedework/page='error'">
                  <h2><xsl:copy-of select="$bwStr-Root-AppError"/></h2>
                  <p><xsl:copy-of select="$bwStr-Root-AppErrorOccurred"/></p>
                  <p>
                    <a href="{$setup}"><xsl:copy-of select="$bwStr-Root-Continue"/></a>
                  </p>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:call-template name="mainMenu"/>
                </xsl:otherwise>
              </xsl:choose>
            </div>
            <!-- footer -->
            <xsl:call-template name="footer"/>
          </xsl:otherwise>
        </xsl:choose>
        </div>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>