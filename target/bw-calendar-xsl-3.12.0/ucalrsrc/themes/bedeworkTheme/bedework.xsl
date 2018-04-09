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
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml">

  <xsl:output method="xml" indent="no" media-type="text/html"
    doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
    standalone="yes" omit-xml-declaration="yes" />

  <!-- DEFINE INCLUDES -->
  <!-- Theme preferences -->
  <xsl:include href="themeSettings.xsl" />

  <!-- Page subsections -->
  <xsl:include href="head.xsl" />
  <xsl:include href="headBar.xsl" />
  <xsl:include href="sideBar.xsl" />
  <xsl:include href="messagesErrors.xsl" />
  <xsl:include href="navigation.xsl" />
  <xsl:include href="eventGrid.xsl" />
  <xsl:include href="eventList.xsl" />
  <xsl:include href="eventListDiscrete.xsl" />
  <xsl:include href="event.xsl" />
  <xsl:include href="tasks.xsl" />
  <xsl:include href="polls.xsl" />
  <xsl:include href="year.xsl" />
  <xsl:include href="notifications.xsl" />
  <xsl:include href="eventForm.xsl" />
  <xsl:include href="addRef.xsl" />
  <xsl:include href="addEventSub.xsl" />
  <xsl:include href="attendees.xsl" />
  <xsl:include href="categories.xsl" />
  <xsl:include href="calendars.xsl" />
  <!-- xsl:include href="subscriptions.xsl" /-->
  <xsl:include href="alarms.xsl" />
  <xsl:include href="upload.xsl" />
  <xsl:include href="email.xsl" />
  <xsl:include href="freeBusy.xsl" />
  <xsl:include href="locations.xsl" />
  <xsl:include href="scheduling.xsl" />
  <xsl:include href="preferences.xsl" />
  <xsl:include href="accessControl.xsl" />
  <xsl:include href="searchResults.xsl" />
  <xsl:include href="showPage.xsl" />
  <xsl:include href="footer.xsl" />

  <!-- THEME GLOBAL VARIABLES -->

  <!-- Are we on a page with a running transaction?
       Used to determine behavior for some ajax requests. -->
  <xsl:variable name="transaction">
    <xsl:choose>
      <xsl:when test="/bedework/page = 'eventscalendar' or
                      /bedework/page = 'event' or
                      /bedework/page = 'eventList' or
                      /bedework/page = 'categoryList' or
                      /bedework/page = 'locationList' or
                      /bedework/page = 'calendarList' or
                      /bedework/page = 'inbox' or
                      /bedework/page = 'outbox' or
                      /bedework/page = 'searchResult' or
                      /bedework/page = 'upload' or
                      /bedework/page = 'other'">false</xsl:when>
      <xsl:otherwise>true</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- BEGIN MAIN TEMPLATE -->
  <xsl:template match="/">
    <html lang="en">
      <head>
        <xsl:call-template name="head"/>
      </head>
      <body>
        <div id="bedework"><!-- main wrapper div to keep styles encapsulated -->
          <xsl:call-template name="headBar"/>
          <xsl:call-template name="messagesAndErrors"/>
          <xsl:call-template name="tabs"/>
          <xsl:choose>
            <xsl:when test="/bedework/page='showPage'">
              <!-- show an arbitrary page -->
              <div id="pageBlock">
                <div id="pageBlockContainer">
                  <xsl:call-template name="selectPage"/>
                </div>
              </div>
            </xsl:when>
            <xsl:when test="/bedework/page='managePolls'">
              <div id="pageBlock">
                <div id="pageBlockContainer">
                  <xsl:call-template name="polls"/>
                </div>
              </div>
            </xsl:when>
            <xsl:otherwise>
              <xsl:if test="/bedework/page != 'eventList'">
                <xsl:call-template name="navigation"/>
              </xsl:if>
              <table id="bodyBlock" cellspacing="0">
                <xsl:if test="/bedework/schedulingMessages/events/event[scheduleState = 1] or /bedework/notifications/notification">
                  <xsl:attribute name="class">withNotices</xsl:attribute>
                </xsl:if>
                <tr>
                  <td id="sideBar" class="sideMenus">
                    <xsl:call-template name="sideBar"/>
                  </td>
                  <td id="bodyContent">
                    <xsl:call-template name="utilBar"/>
                    <xsl:choose>
                      <xsl:when test="/bedework/page='event'">
                        <!-- show an event -->
                        <xsl:apply-templates select="/bedework/event"/>
                      </xsl:when>
                      <xsl:when test="/bedework/page='eventList'">
                        <!-- show a list of discrete events in a time period -->
                        <xsl:apply-templates select="/bedework/events" mode="eventList"/>
                      </xsl:when>
                      <xsl:when test="/bedework/page='addEvent'">
                        <xsl:apply-templates select="/bedework/formElements" mode="addEvent"/>
                      </xsl:when>
                      <xsl:when test="/bedework/page='attendees'">
                        <xsl:call-template name="attendees"/>
                      </xsl:when>
                      <xsl:when test="/bedework/page='attendeeWidget'">
                        <!-- generate json list of attendees after modifying the scheduling widget -->
                        {<xsl:apply-templates select="/bedework/attendees" mode="loadBwGrid"/>}
                      </xsl:when>
                      <xsl:when test="/bedework/page='editEvent'">
                        <xsl:apply-templates select="/bedework/formElements" mode="editEvent"/>
                      </xsl:when>
                      <xsl:when test="/bedework/page='addEventRef'">
                        <xsl:apply-templates select="/bedework/event" mode="addEventRef"/>
                      </xsl:when>
                      <xsl:when test="/bedework/page='addEventSub'">
                        <xsl:apply-templates select="/bedework/event" mode="addEventSub"/>
                      </xsl:when>
                      <xsl:when test="/bedework/page='alarmOptions'">
                        <xsl:call-template name="alarmOptions" />
                      </xsl:when>
                      <xsl:when test="/bedework/page='upload'">
                        <xsl:call-template name="upload" />
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
                      <xsl:when test="/bedework/page='locationList'">
                        <xsl:call-template name="locationList" />
                      </xsl:when>
                      <xsl:when test="/bedework/page='modLocation'">
                        <xsl:call-template name="modLocation"/>
                      </xsl:when>
                      <xsl:when test="/bedework/page='deleteLocationConfirm'">
                        <xsl:call-template name="deleteLocationConfirm"/>
                      </xsl:when>
                      <!-- DEPRECATED
                      <xsl:when test="/bedework/page='subsMenu'">
                        <xsl:call-template name="subsMenu"/>
                      </xsl:when>
                      <xsl:when test="/bedework/page='subscriptions' or
                                      /bedework/page='modSubscription'">
                        <xsl:apply-templates select="/bedework/subscriptions"/>
                      </xsl:when>
                      <xsl:when test="/bedework/page='addAlias'">
                        <xsl:call-template name="addAlias"/>
                      </xsl:when>
                      -->
                      <xsl:when test="/bedework/page='calendarList' or
                                      /bedework/page='calendarDescriptions' or
                                      /bedework/page='displayCalendar' or
                                      /bedework/page='modCalendar' or
                                      /bedework/page='deleteCalendarConfirm' or
                                      /bedework/page='calendarReferenced' or
                                      /bedework/page='addSubscription'">
                        <xsl:apply-templates select="/bedework/calendars" mode="manageCalendars"/>
                      </xsl:when>
                       <xsl:when test="/bedework/page='calendarListForExport'">
                        <xsl:apply-templates select="/bedework/calendars" mode="exportCalendars"/>
                      </xsl:when>
                      <xsl:when test="/bedework/page='freeBusy'">
                        <xsl:apply-templates select="/bedework/freebusy" mode="freeBusyPage"/>
                      </xsl:when>
                      <xsl:when test="/bedework/page='modPrefs'">
                        <xsl:apply-templates select="/bedework/prefs"/>
                      </xsl:when>
                      <xsl:when test="/bedework/page='modSchedulingPrefs'">
                        <xsl:apply-templates select="/bedework/schPrefs"/>
                      </xsl:when>
                      <xsl:when test="/bedework/page='inbox'">
                        <xsl:apply-templates select="/bedework/inbox"/>
                      </xsl:when>
                      <xsl:when test="/bedework/page='outbox'">
                        <xsl:apply-templates select="/bedework/outbox"/>
                      </xsl:when>
                      <xsl:when test="/bedework/page='attendeeRespond'">
                        <xsl:apply-templates select="/bedework/formElements" mode="attendeeRespond"/>
                      </xsl:when>
                      <xsl:when test="/bedework/page='attendeeReply'">
                        <xsl:apply-templates select="/bedework/event" mode="attendeeReply"/>
                      </xsl:when>
                      <xsl:when test="/bedework/page='searchResult'">
                        <xsl:call-template name="searchResult"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <!-- otherwise, show the eventsCalendar -->
                        <!-- main eventCalendar content -->
                        <xsl:choose>
                          <xsl:when test="/bedework/periodname='Day'">
                            <xsl:call-template name="listView"/>
                          </xsl:when>
                          <xsl:when test="/bedework/periodname='Week' or /bedework/periodname=''">
                            <xsl:choose>
                              <xsl:when test="/bedework/appvar[key='weekViewMode']/value='list'">
                                <xsl:call-template name="listView"/>
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:call-template name="weekView"/>
                              </xsl:otherwise>
                            </xsl:choose>
                          </xsl:when>
                          <xsl:when test="/bedework/periodname='Month'">
                            <xsl:choose>
                              <xsl:when test="/bedework/appvar[key='monthViewMode']/value='list'">
                                <xsl:call-template name="listView"/>
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:call-template name="monthView"/>
                              </xsl:otherwise>
                            </xsl:choose>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:call-template name="yearView"/>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                  <xsl:if test="/bedework/schedulingMessages/events/event[scheduleState = 1] or /bedework/notifications/notification">
                    <td id="msgTaskBar" class="sideMenus">
                      <h3>messages</h3>
                      <ul>
                        <!-- show notifications -->
                        <xsl:apply-templates select="/bedework/notifications/notification"/>
                        <!-- only show processed scheduling messages (scheduleState = 1) -->
                        <xsl:apply-templates select="/bedework/schedulingMessages/events/event[scheduleState = 1]" mode="schedNotifications"/>
                      </ul>
                      <xsl:call-template name="notificationReplyWidgets"/>
                    </td>
                  </xsl:if>
                </tr>
              </table>
            </xsl:otherwise>
          </xsl:choose>
          <!-- footer -->
          <xsl:call-template name="footer"/>
        </div>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>
