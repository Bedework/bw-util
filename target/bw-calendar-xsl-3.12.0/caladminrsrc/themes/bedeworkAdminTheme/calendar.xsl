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

  <!--+++++++++++++++ Calendars ++++++++++++++++++++-->
  <!-- templates:
         - calendarCommon
         - calendarList
         - deleteCalendarConfirm
         - selectCalForEvent
         - selectCalForEventCalTree
         - calendarMove
   -->

  <xsl:template match="calendars" mode="calendarCommon">
    <table id="calendarTable">
      <tr>
        <td class="cals">
          <h2><xsl:copy-of select="$bwStr-Cals-Collections"/></h2>
          <form name="getCollection" id="bwGetCollectionForm" action="{$calendar-fetchForUpdate}">
            <xsl:copy-of select="$bwStr-Cals-SelectByPath"/><br/>
            <input type="text" size="15" name="calPath"/>
            <input type="submit" value="{$bwStr-Cals-Go}"/>
          </form>
          <h4 class="calendarTreeTitle"><xsl:copy-of select="$bwStr-Cals-PublicTree"/></h4>
          <ul class="calendarTree">
            <xsl:choose>
              <xsl:when test="/bedework/page='calendarDescriptions' or /bedework/page='displayCalendar'">
                <xsl:apply-templates select="calendar" mode="listForDisplay"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates select="calendar" mode="listForUpdate"/>
              </xsl:otherwise>
            </xsl:choose>
          </ul>
        </td>
        <td class="calendarContent">
          <xsl:choose>
            <xsl:when test="/bedework/page='calendarList' or /bedework/page='calendarReferenced'">
              <xsl:call-template name="calendarList"/>
            </xsl:when>
            <xsl:when test="/bedework/page='calendarDescriptions'">
              <xsl:call-template name="calendarDescriptions"/>
            </xsl:when>
            <xsl:when test="/bedework/page='displayCalendar'">
              <xsl:apply-templates select="/bedework/currentCalendar" mode="displayCalendar"/>
            </xsl:when>
            <xsl:when test="/bedework/page='deleteCalendarConfirm'">
              <xsl:apply-templates select="/bedework/currentCalendar" mode="deleteCalendarConfirm"/>
            </xsl:when>
            <xsl:when test="/bedework/creating='true'">
              <xsl:apply-templates select="/bedework/currentCalendar" mode="addCalendar"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="/bedework/currentCalendar" mode="modCalendar"/>
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
    </table>
  </xsl:template>

    <xsl:template name="calendarList">
    <h3><xsl:copy-of select="$bwStr-CaLi-ManageCalendarsAndFolders"/></h3>
    <ul>

      <li><xsl:copy-of select="$bwStr-CaLi-SelectItemFromPublicTree"/></li>
      <li><xsl:copy-of select="$bwStr-CaLi-SelectThe"/><xsl:text> </xsl:text>
        <img src="{$resourcesRoot}/images/calAddIcon.gif" width="13" height="13" alt="true"/>
        <xsl:text> </xsl:text><xsl:copy-of select="$bwStr-CaLi-IconToAdd"/>
        <ul>
          <li><xsl:copy-of select="$bwStr-CaLi-FoldersMayContain"/></li>
          <li><xsl:copy-of select="$bwStr-CaLi-CalendarsMayContain"/></li>
        </ul>
      </li>
      <li>
        <xsl:copy-of select="$bwStr-CaLi-RetrieveCalendar"/>
      </li>
    </ul>
  </xsl:template>

  <xsl:template name="calendarDescriptions">
    <h2><xsl:copy-of select="$bwStr-CaLD-CalendarInfo"/></h2>
    <ul>
      <li><xsl:copy-of select="$bwStr-CaLD-SelectItemFromCalendarTree"/></li>
    </ul>
  </xsl:template>

  <xsl:template match="currentCalendar" mode="displayCalendar">
    <h2><xsl:copy-of select="$bwStr-CaLD-CalendarInfo"/></h2>
    <table class="eventFormTable">
      <tr>
        <th><xsl:copy-of select="$bwStr-CaLD-Name"/></th>
        <td>
          <xsl:value-of select="name"/>
        </td>
      </tr>
      <tr>
        <th><xsl:copy-of select="$bwStr-CaLD-Path"/></th>
        <td>
          <xsl:value-of select="path"/>
        </td>
      </tr>
      <tr>
        <th><xsl:copy-of select="$bwStr-CaLD-Summary"/></th>
        <td>
          <xsl:value-of select="summary"/>
        </td>
      </tr>
      <tr>
        <th><xsl:copy-of select="$bwStr-CaLD-Description"/></th>
        <td>
          <xsl:value-of select="desc"/>
        </td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template match="currentCalendar" mode="deleteCalendarConfirm">
    <xsl:choose>
      <xsl:when test="isSubscription = 'true'">
        <h3><xsl:copy-of select="$bwStr-CuCa-RemoveSubscription"/></h3>
        <p>
          <xsl:copy-of select="$bwStr-CuCa-FollowingSubscriptionRemoved"/>
        </p>
      </xsl:when>
      <xsl:when test="calType = '0'">
        <h3><xsl:copy-of select="$bwStr-CuCa-DeleteFolder"/></h3>
        <p>
          <xsl:copy-of select="$bwStr-CuCa-FollowingFolderDeleted"/>
        </p>
      </xsl:when>
      <xsl:otherwise>
        <h3><xsl:copy-of select="$bwStr-CuCa-DeleteCalendar"/></h3>
        <p>
          <xsl:copy-of select="$bwStr-CuCa-FollowingCalendarDeleted"/>
        </p>
      </xsl:otherwise>
    </xsl:choose>

    <form name="delCalForm" action="{$calendar-delete}" method="post">
      <input type="hidden" name="deleteContent" value="true"/>
      <table class="eventFormTable">
        <tr>
          <th><xsl:copy-of select="$bwStr-CuCa-Path"/></th>
          <td>
            <xsl:value-of select="path"/>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-CuCa-Name"/></th>
          <td>
            <xsl:value-of select="name"/>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-CuCa-Summary"/></th>
          <td>
            <xsl:value-of select="summary"/>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-CuCa-Description"/></th>
          <td>
            <xsl:value-of select="desc"/>
          </td>
        </tr>
      </table>

      <div class="submitBox">
        <div class="right">
          <xsl:choose>
            <xsl:when test="isSubscription = 'true'">
              <input type="submit" name="delete" value="{$bwStr-CuCa-YesRemoveSubscription}"/>
            </xsl:when>
            <xsl:when test="calType = '0'">
              <input type="submit" name="delete" value="{$bwStr-CuCa-YesDeleteFolder}"/>
            </xsl:when>
            <xsl:otherwise>
              <input type="submit" name="delete" value="{$bwStr-CuCa-YesDeleteCalendar}"/>
            </xsl:otherwise>
          </xsl:choose>
        </div>
        <input type="submit" name="cancelled" value="{$bwStr-CuCa-Cancel}"/>
      </div>
    </form>
  </xsl:template>

  <!-- the selectCalForEvent listing creates a calendar tree in a pop-up window -->
  <xsl:template name="selectCalForEvent">
    <div id="calTreeBlock">
      <h2><xsl:copy-of select="$bwStr-SCFE-SelectCal"/></h2>
      <!--<form name="toggleCals" action="{$event-selectCalForEvent}" method="post">
        <xsl:choose>
          <xsl:when test="/bedework/appvar[key='showAllCalsForEvent']/value = 'true'">
            <input type="radio" name="setappvar" value="showAllCalsForEvent(false)" onclick="submit()"/>
            show only writable calendars
            <input type="radio" name="setappvar" value="showAllCalsForEvent(true)" checked="checked" onclick="submit()"/>
            show all calendars
          </xsl:when>
          <xsl:otherwise>
            <input type="radio" name="setappvar" value="showAllCalsForEvent(false)" checked="checked" onclick="submit()"/>
            show only writable calendars
            <input type="radio" name="setappvar" value="showAllCalsForEvent(true)" onclick="submit()"/>
            show all calendars
          </xsl:otherwise>
        </xsl:choose>
      </form>-->
      <h4><xsl:copy-of select="$bwStr-SCFE-Calendars"/></h4>
      <ul class="calendarTree">
        <xsl:apply-templates select="/bedework/calendars/calendar" mode="selectCalForEventCalTree"/>
      </ul>
    </div>
  </xsl:template>

  <xsl:template match="calendar" mode="selectCalForEventCalTree">
    <xsl:variable name="calPath" select="path"/><!-- not the encodedPath when put in a form - otherwise it gets double encoded -->
    <xsl:variable name="calDisplay" select="path"/>
    <xsl:variable name="itemClass">
      <xsl:choose>
        <xsl:when test="calType = '0'"><xsl:copy-of select="$bwStr-Cals-Folder"/></xsl:when>
        <xsl:otherwise><xsl:copy-of select="$bwStr-Cals-Calendar"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <li class="{$itemClass}">
      <xsl:if test="calType = '0'">
        <!-- test the open state of the folder; if it's open,
             build a URL to close it and vice versa -->
        <xsl:choose>
          <xsl:when test="open = 'true'">
            <a href="{$calendar-openCloseSelect}&amp;calPath={$calPath}&amp;open=false">
              <img src="{$resourcesRoot}/images/minus.gif" width="9" height="9" alt="close" class="bwPlusMinusIcon"/>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <a href="{$calendar-openCloseSelect}&amp;calPath={$calPath}&amp;open=true">
              <img src="{$resourcesRoot}/images/plus.gif" width="9" height="9" alt="open" class="bwPlusMinusIcon"/>
            </a>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="(currentAccess/current-user-privilege-set/privilege/write-content or /bedework/userInfo/superUser = 'true') and (calType != '0')">
          <a href="javascript:updateEventFormCalendar('{$calPath}','{$calDisplay}')">
            <strong>
              <xsl:value-of select="summary"/>
            </strong>
          </a>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="summary"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="calendar">
        <ul>
          <xsl:apply-templates select="calendar" mode="selectCalForEventCalTree"/>
        </ul>
      </xsl:if>
    </li>
  </xsl:template>

  <xsl:template name="calendarMove">
    <table id="calendarTable">
      <tr>
        <td class="calendarContent">
          <h3><xsl:copy-of select="$bwStr-CaMv-MoveCalendar"/></h3>

          <table class="eventFormTable">
            <tr>
              <th><xsl:copy-of select="$bwStr-CaMv-CurrentPath"/></th>
              <td>
                <xsl:value-of select="/bedework/currentCalendar/path"/>
              </td>
            </tr>
            <tr>
              <th><xsl:copy-of select="$bwStr-CaMv-Name"/></th>
              <td>
                <xsl:value-of select="/bedework/currentCalendar/name"/>
              </td>
            </tr>
            <tr>
              <th><xsl:copy-of select="$bwStr-CaMv-MailingListID"/></th>
              <td>
                <xsl:value-of select="/bedework/currentCalendar/mailListId"/>
              </td>
            </tr>
            <tr>
              <th><xsl:copy-of select="$bwStr-CaMv-Summary"/></th>
              <td>
                <xsl:value-of select="/bedework/currentCalendar/summary"/>
              </td>
            </tr>
            <tr>
              <th><xsl:copy-of select="$bwStr-CaMv-Description"/></th>
              <td>
                <xsl:value-of select="/bedework/currentCalendar/desc"/>
              </td>
            </tr>
          </table>
        </td>
        <td class="bwCalsForMove">
          <p><xsl:copy-of select="$bwStr-CaMv-SelectNewParentFolder"/></p>
          <ul class="calendarTree">
            <xsl:apply-templates select="/bedework/calendars/calendar" mode="listForMove"/>
          </ul>
        </td>
      </tr>
    </table>
  </xsl:template>

</xsl:stylesheet>