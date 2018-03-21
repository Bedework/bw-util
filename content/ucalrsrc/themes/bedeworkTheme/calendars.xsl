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
  xmlns:DAV="DAV:"
  xmlns:CSS="http://calendarserver.org/ns/"
  xmlns:C="urn:ietf:params:xml:ns:caldav"
  xmlns="http://www.w3.org/1999/xhtml">


  <!--+++++++++++++++ Calendars ++++++++++++++++++++-->

  <!--
    Calendar templates depend heavily on calendar types:

    calTypes: 0 - Folder
              1 - Calendar
              2 - Trash
              3 - Deleted
              4 - Busy
              5 - Inbox
              6 - Outbox
              7 - Alias (internal - the underlying calType will be returned; check for the isSubscription property)
              8 - External subscription (internal - the underlying calType will be returned; check for the isSubscription property and check on the item's status)
              9 - Resource collection
  -->

  <xsl:template match="calendars" mode="manageCalendars">
    <h2><xsl:copy-of select="$bwStr-Cals-ManageCalendarsSubscriptions"/></h2>
    <table id="calendarTable">
      <tr>
        <td class="cals">
          <h3><xsl:copy-of select="$bwStr-Cals-Calendars"/></h3>
          <ul class="calendarTree">
            <xsl:choose>
              <xsl:when test="/bedework/page='calendarDescriptions' or
                              /bedework/page='displayCalendar'">
                <xsl:choose>
                  <xsl:when test="$publicOnly = 'false'">
                    <xsl:apply-templates select="calendar[number(calType) &lt; 2 or number(calType) = 4 or number(calType) &gt; 6]" mode="listForDisplay"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:apply-templates select="calendar[isSubsciption = 'true']" mode="listForDisplay"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:otherwise>
                <xsl:choose>
                  <xsl:when test="$publicOnly = 'false'">
                    <xsl:apply-templates select="calendar[number(calType) &lt; 2 or number(calType) = 4 or number(calType) &gt; 6]" mode="listForUpdate"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:apply-templates select="calendar[number(calType) &lt; 2]" mode="listForUpdate"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
          </ul>
          <div id="addCalSubButtons">
            <xsl:variable name="calPath" select="/bedework/calendars/calendar/encodedPath"/>
            <xsl:value-of select="$bwStr-CuCa-AddCalTextLabel"/><br/>
            <xsl:if test="$publicOnly = 'false'">
              <button type="button" id="addCalButton" onclick="location.href='{$calendar-initAdd}&amp;calPath={$calPath}'">
                <xsl:value-of select="$bwStr-CuCa-Calendar"/>
              </button>
            </xsl:if>
            <button type="button" id="addSubButton" onclick="location.href='{$sharing-initAddSubscription}&amp;calPath={$calPath}'">
              <xsl:value-of select="$bwStr-CuCa-Subscription"/>
            </button>
          </div>
        </td>
        <td class="calendarContent">
          <xsl:choose>
            <xsl:when test="/bedework/page='calendarList' or
                            /bedework/page='calendarReferenced'">
              <xsl:if test="$publicOnly = 'false'">
                <xsl:call-template name="calendarList"/>
              </xsl:if>
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
            <xsl:when test="/bedework/page='addSubscription'">
              <xsl:call-template name="addSubscription"/>
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

  <xsl:template match="calendar" mode="myCalendars">
    <!-- this template receives calType 0,1,4,7,8  (what 9?)  -->
    <xsl:variable name="id" select="id"/>
    <xsl:variable name="userRootCalendar">/user/<xsl:value-of select="/bedework/userid"/></xsl:variable>
    <xsl:variable name="virtualPath"><xsl:call-template name="url-encode"><xsl:with-param name="str">/user<xsl:for-each select="ancestor-or-self::calendar/name">/<xsl:value-of select="."/></xsl:for-each></xsl:with-param></xsl:call-template></xsl:variable>
    <xsl:variable name="calPath" select="encodedPath"/>
    <li>
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="disabled = 'true'">unknown</xsl:when>
          <xsl:when test="lastRefreshStatus &gt; 300">unknown</xsl:when>
          <xsl:when test="not(path = $userRootCalendar) and
                          /bedework/appvar[key='selectedcal']/value = path">selected</xsl:when>
          <xsl:when test="isSubscription = 'true'">
            <xsl:choose>
              <xsl:when test="calType = '0'">aliasFolder</xsl:when>
              <xsl:otherwise>alias</xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="calType = '0'">folder</xsl:when>
          <xsl:otherwise>calendar</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:if test="currentAccess/current-user-privilege-set/privilege/write-content">
        <form name="bwHideDisplayCal" class="bwHideDisplayCal" method="post">
          <xsl:attribute name="action">
            <xsl:choose>
              <xsl:when test="/bedework/page = 'eventList'"><xsl:value-of select="$calendar-setPropsInList"/></xsl:when>
              <xsl:otherwise><xsl:value-of select="$calendar-setPropsInGrid"/></xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <input type="hidden" name="calPath">
            <xsl:attribute name="value"><xsl:value-of select="path"/></xsl:attribute>
          </input>
          <xsl:choose>
            <xsl:when test="display = 'true'">
              <!-- set the value of display to false so that when the form is submitted we toggle
-->
              <input type="hidden" name="display" value="false"/>
              <input type="checkbox" name="bwDisplaySetter" checked="checked"  onclick="this.form.submit()">
                <xsl:if test="(/bedework/page != 'eventscalendar' and
                               /bedework/page != 'eventList') or
                               $userRootCalendar = path"><xsl:attribute name="disabled">disabled</xsl:attribute></xsl:if>
              </input>
            </xsl:when>
            <xsl:otherwise>
              <!-- set the value of display to true so that when the form is submitted we toggle
-->
              <input type="hidden" name="display" value="true"/>
              <input type="checkbox" name="bwDisplaySetter" onclick="this.form.submit()">
                <xsl:if test="(/bedework/page != 'eventscalendar' and
                               /bedework/page != 'eventList') or
                               $userRootCalendar = path"><xsl:attribute name="disabled">disabled</xsl:attribute></xsl:if>
              </input>
            </xsl:otherwise>
          </xsl:choose>
        </form>
        <xsl:text> </xsl:text>
      </xsl:if>
      <!--a href="{$setSelection}&amp;virtualPath={$virtualPath}&amp;calUrl={$calPath}"-->
      <a href="{$setSelection}&amp;fexpr=(vpath=%22{$virtualPath}%22)&amp;calUrl={$calPath}&amp;setappvar=selectedcal({$calPath})">
        <xsl:if test="lastRefreshStatus &gt;= 300">
          <xsl:attribute name="title">
            <xsl:call-template name="httpStatusCodes">
              <xsl:with-param name="code"><xsl:value-of  select="lastRefreshStatus"/></xsl:with-param>
            </xsl:call-template>
          </xsl:attribute>
        </xsl:if>
        <xsl:value-of select="summary"/>
      </a>
      <xsl:if test="color != '' and color != 'null'">
        <!-- the spacer gif approach allows us to avoid some IE misbehavior -->
        <xsl:variable name="color" select="color"/>
        <img src="{$resourcesRoot}/images/spacer.gif" width="6" height="6" alt="calendar color" class="bwCalendarColor" style="background-color: {$color}; color:black;"/>
      </xsl:if>
      <xsl:if test="calendar">
        <ul>
          <xsl:choose>
            <xsl:when  test="$publicOnly = 'false'">
              <xsl:apply-templates select="calendar[canAlias = 'true' and (calType &lt; 2 or calType = 4 or calType = 7 or calType = 8)]" mode="myCalendars">
                <xsl:sort select="summary" order="ascending" case-order="upper-first"/>
              </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="calendar[canAlias = 'true' and actualCalType = '7']" mode="myCalendars">
                <xsl:sort select="summary" order="ascending" case-order="upper-first"/>
              </xsl:apply-templates>
            </xsl:otherwise>
          </xsl:choose>
        </ul>
      </xsl:if>
    </li>
  </xsl:template>

  <xsl:template match="calendar" mode="mySpecialCalendars">
    <!-- this template receives calType 2,3,5,6  -->
    <xsl:variable name="id" select="id"/>
    <li>
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="/bedework/selectionState/selectionType = 'collections'
                          and path = /bedework/selectionState/subscriptions/subscription/calendar/path">selected</xsl:when>
          <xsl:when test="calType='2' or calType='3'">trash</xsl:when>
          <xsl:when test="calType='5'">inbox</xsl:when>
          <xsl:when test="calType='6'">outbox</xsl:when>
          <xsl:when test="calType='0'">folder</xsl:when>
          <xsl:otherwise>calendar</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:variable name="calPath" select="encodedPath"/>
      <xsl:choose>
        <xsl:when test="calType='5'">
          <a href="{$showInbox}" title="{$bwStr-Cals-IncomingSchedulingRequests}">
            <xsl:value-of select="summary"/>
          </a>
          <xsl:text> </xsl:text>
          <xsl:if test="/bedework/inboxState/numActive != '0'">
            <span class="inoutboxActive">(<xsl:value-of select="/bedework/inboxState/numActive"/>)</span>
          </xsl:if>
        </xsl:when>
        <xsl:when test="calType='6'">
          <a href="{$showOutbox}" title="{$bwStr-Cals-OutgoingSchedulingRequests}">
            <xsl:value-of select="summary"/>
          </a>
          <xsl:text> </xsl:text>
          <xsl:if test="/bedework/outboxState/numActive != '0'">
            <span class="inoutboxActive">(<xsl:value-of select="/bedework/outboxState/numActive"/>)</span>
          </xsl:if>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="virtualPath"><xsl:call-template name="url-encode"><xsl:with-param name="str">/user<xsl:for-each select="ancestor-or-self::calendar/name">/<xsl:value-of select="."/></xsl:for-each></xsl:with-param></xsl:call-template></xsl:variable>
          <!--a href="{$setSelection}&amp;virtualPath={$virtualPath}&amp;calUrl={$calPath}"-->
          <a href="{$setSelection}&amp;fexpr=(vpath=%22{$virtualPath}%22)">
            <xsl:attribute name="title">
              <xsl:choose>
                <xsl:when test="calType = 2">Contains items you have access to delete.</xsl:when>
                <xsl:when test="calType = 3">Used to mask items you do not have access to truly delete, such as many subscribed events.</xsl:when>
              </xsl:choose>
            </xsl:attribute>
            <xsl:value-of select="summary"/>
          </a>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="calendar">
        <ul>
          <xsl:apply-templates select="calendar" mode="myCalendars"/>
        </ul>
      </xsl:if>
    </li>
  </xsl:template>

  <xsl:template match="calendar" mode="listForUpdate">
    <!-- this template receives all calTypes -->
    <xsl:variable name="calPath" select="encodedPath"/>
    <li>
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="disabled = 'true'">unknown</xsl:when>
          <xsl:when test="lastRefreshStatus &gt;= 300">unknown</xsl:when>
          <xsl:when test="isSubscription = 'true'">
            <xsl:choose>
              <xsl:when test="calType = '0'">aliasFolder</xsl:when>
              <xsl:otherwise>alias</xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="calType = '0'">folder</xsl:when>
          <xsl:when test="calType='2' or calType='3'">trash</xsl:when>
          <xsl:when test="calType='5'">inbox</xsl:when>
          <xsl:when test="calType='6'">outbox</xsl:when>
          <xsl:otherwise>calendar</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <a href="{$calendar-fetchForUpdate}&amp;calPath={$calPath}" title="{$bwStr-Cals-Update}">
        <xsl:value-of select="summary"/>
      </a>
      <xsl:if test="calType = '0' and isSubscription = 'false'">
        <!-- <xsl:if test="$publicOnly = 'false'">
          <xsl:text> </xsl:text>
          <a href="{$calendar-initAdd}&amp;calPath={$calPath}" title="{$bwStr-Cals-AddCalendarOrFolder}">
            <img src="{$resourcesRoot}/images/calAddIcon.gif" width="13" height="13" alt="*" border="0"/>
            <span class="addCalText"><xsl:copy-of select="$bwStr-CuCa-AddCalText"/></span>
          </a>
        </xsl:if> -->
      </xsl:if>
      <xsl:if test="calendar and isSubscription='false'">
        <ul>
          <xsl:choose>
            <xsl:when test="$publicOnly = 'false'">
              <xsl:apply-templates select="calendar" mode="listForUpdate">
                <xsl:sort select="summary" order="ascending" case-order="upper-first"/>
              </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="calendar[isSubscription = 'true']" mode="listForUpdate">
                <xsl:sort select="summary" order="ascending" case-order="upper-first"/>
              </xsl:apply-templates>
            </xsl:otherwise>
          </xsl:choose>
        </ul>
      </xsl:if>
    </li>
  </xsl:template>

  <xsl:template match="calendar" mode="listForDisplay">
    <!-- this template receives calType 0,1,4,7,8,9 -->
    <xsl:variable name="calPath" select="encodedPath"/>
    <li>
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="isSubscription = 'true'">alias</xsl:when>
          <xsl:when test="calType = '0'">folder</xsl:when>
          <xsl:otherwise>calendar</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <a href="{$calendar-fetchForDisplay}&amp;calPath={$calPath}" title="{$bwStr-Cals-Display}">
        <xsl:value-of select="summary"/>
      </a>
      <xsl:if test="calendar">
        <ul>
          <xsl:apply-templates select="calendar[number(calType) &lt; 2 or number(calType) = 4 or number(calType) &gt; 6]" mode="listForDisplay">
            <xsl:sort select="summary" order="ascending" case-order="upper-first"/>
          </xsl:apply-templates>
        </ul>
      </xsl:if>
    </li>
  </xsl:template>

  <xsl:template name="selectCalForEvent">
    <!-- selectCalForEvent creates a calendar tree in a pop-up window.
      Used when selecting a calendar while adding or editing an event.

      This template will be called when
      a) we add an event by date with no specific calendar selected
      b) we import an event
      c) we add an event ref
      d) we edit an event and change it's calendar (or change it while adding)

      The intention is to load the calendar listing in a "pop-up" widget as a
      tree of myCalendars and writable calendars associated with subscriptions.
      The xml for the tree is already in header.jsp in myCalendars and
      mySubscriptions.
       -->
    <input type="button" onclick="javascript:changeClass('calSelectWidget','visible')" value="select calendar" class="small"/>
    <div id="calSelectWidget" class="invisible">
      <h2><xsl:copy-of select="$bwStr-SCfE-SelectACalendar"/></h2>
      <a href="javascript:changeClass('calSelectWidget','invisible')" id="calSelectWidgetCloser" title="{$bwStr-SCfE-Close}">x</a>
      <ul class="calendarTree">
        <xsl:choose>
          <xsl:when test="/bedework/formElements/form/calendars/select/option">
            <xsl:apply-templates select="/bedework/myCalendars/calendars/calendar" mode="selectCalForEventCalTree">
              <xsl:sort select="summary" order="ascending" case-order="upper-first"/>
            </xsl:apply-templates>
          </xsl:when>
          <xsl:otherwise>
            <li><em><xsl:copy-of select="$bwStr-SCfE-NoWritableCals"/></em></li>
          </xsl:otherwise>
        </xsl:choose>
      </ul>
    </div>
  </xsl:template>

  <xsl:template match="calendar" mode="selectCalForEventCalTree">
    <xsl:variable name="id" select="id"/>
    <li>
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="/bedework/selectionState/selectionType = 'calendar'
                          and name = /bedework/selectionState/subscriptions/subscription/calendar/name">selected</xsl:when>
          <xsl:when test="isSubscription = 'true'">alias</xsl:when>
          <xsl:when test="name='Trash'">trash</xsl:when>
          <xsl:when test="calType = '0'">folder</xsl:when>
          <xsl:otherwise>calendar</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:variable name="calPath" select="path"/>
      <xsl:variable name="calDisplay" select="summary"/>
      <xsl:choose>
        <xsl:when test="path = /bedework/formElements/form/calendars/select//option/@value and (calType != '0')">
          <a href="javascript:updateEventFormCalendar('{$calPath}','{$calDisplay}')">
            <strong><xsl:value-of select="summary"/></strong>
          </a>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="summary"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="calendar">
        <ul>
          <xsl:apply-templates select="calendar[calType &lt; 2]" mode="selectCalForEventCalTree">
            <xsl:sort select="summary" order="ascending" case-order="upper-first"/>
          </xsl:apply-templates>
        </ul>
      </xsl:if>
    </li>
  </xsl:template>

  <xsl:template name="selectCalForPublicAlias">
    <!-- This template is DEPRECATED ... selectCalForPublicAliasCalTree is now used instead.
-->
    <!-- selectCalForPublicAlias creates a calendar tree pop-up window for
       selecting a public calendar subscription (alias).
-->

    <input type="button" onclick="javascript:changeClass('calSelectWidget','visible')" value="select calendar" class="small"/>
    <div id="calSelectWidget" class="invisible">
      <h2><xsl:copy-of select="$bwStr-SCPA-SelectACalendar"/></h2>
      <a href="javascript:changeClass('calSelectWidget','invisible')" id="calSelectWidgetCloser" title="{$bwStr-SCPA-Close}">x</a>
      <ul class="calendarTree">
        <xsl:apply-templates select="/bedework/publicCalendars/calendar" mode="selectCalForPublicAliasCalTree"/>
      </ul>
      <!-- Uncomment the following to use a three column format
      <xsl:variable name="topCalsCount" select="count(/bedework/calendars/calendar/calendar)"/>
      <xsl:variable name="topCalsDivThree" select="floor($topCalsCount div 3)"/>
      <xsl:variable name="topCalsTopSet" select="number($topCalsCount - $topCalsDivThree)"/>
      <ul class="calendarTree left">
        <xsl:apply-templates select="/bedework/calendars/calendar/calendar[canAlias='true' and (position() &lt;= $topCalsDivThree)]" mode="selectCalForPublicAliasCalTree"/>
      </ul>
      <ul class="calendarTree left">
        <xsl:apply-templates select="/bedework/calendars/calendar/calendar[canAlias='true' and (position() &gt; $topCalsDivThree) and (position() &lt;= $topCalsTopSet)]" mode="selectCalForPublicAliasCalTree"/>
      </ul>
      <ul class="calendarTree left">
        <xsl:apply-templates select="/bedework/calendars/calendar/calendar[canAlias='true' and (position() &gt; $topCalsTopSet)]" mode="selectCalForPublicAliasCalTree"/>
      </ul>
      -->
    </div>
  </xsl:template>

  <xsl:template match="calendar" mode="selectCalForPublicAliasCalTree">
    <xsl:variable name="id" select="id"/>
    <li>
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="name='Trash'">trash</xsl:when>
          <xsl:when test="isSubscription = 'true'">alias</xsl:when>
          <xsl:when test="calType = '0'">folder</xsl:when>
          <xsl:otherwise>calendar</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:variable name="calPath" select="path"/>
      <xsl:variable name="calDisplay" select="path"/>
      <xsl:variable name="calendarCollection" select="calendarCollection"/>
      <xsl:choose>
        <xsl:when test="canAlias = 'true'">
          <a href="javascript:updatePublicCalendarAlias('{$calPath}','{$calDisplay}','{$calendarCollection}')">
            <xsl:value-of select="summary"/>
          </a>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="summary"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="calendar">
        <ul>
          <xsl:apply-templates select="calendar" mode="selectCalForPublicAliasCalTree"/>
        </ul>
      </xsl:if>
    </li>
  </xsl:template>

  <xsl:template match="currentCalendar" mode="addCalendar">
    <h3><xsl:copy-of select="$bwStr-CuCa-AddCalOrFolder"/></h3>
    <form name="addCalForm" method="post" action="{$calendar-update}" onsubmit="return setCalendarAlias(this)">
      <input type="hidden" value="true" name="calendarCollection"/>
      <table class="common">
        <tr>
          <th><xsl:copy-of select="$bwStr-CuCa-Name"/></th>
          <td>
            <xsl:variable name="curCalName" select="name"/>
            <input name="calendar.name" value="{$curCalName}" onblur="setCalSummary(this.value, this.form['calendar.summary']);" size="40"/>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-CuCa-Summary"/></th>
          <td>
            <xsl:variable name="curCalSummary" select="summary"/>
            <input type="text" name="calendar.summary" value="{$curCalSummary}" size="40"/>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-CuCa-Description"/></th>
          <td>
            <textarea name="calendar.description" cols="30" rows="4">
              <xsl:value-of select="desc"/>
              <xsl:if test="normalize-space(desc) = ''">
                <xsl:text> </xsl:text>
                <!-- keep this non-breaking space to avoid browser
                rendering errors when the text area is empty -->
              </xsl:if>
            </textarea>
          </td>
        </tr>
        <tr id="bwColorField">
          <th><xsl:copy-of select="$bwStr-CuCa-Color"/></th>
          <td>
            <input type="text" name="calendar.color" id="bwCalColor" value="" size="7"/>
            <xsl:call-template name="colorPicker">
              <xsl:with-param name="colorFieldId">bwCalColor</xsl:with-param>
            </xsl:call-template>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-CuCa-Display"/></th>
          <td>
            <input type="hidden" name="calendar.display">
              <xsl:attribute name="value"><xsl:value-of select="display"/></xsl:attribute>
            </input>
            <input type="checkbox" name="displayHolder" id="calDisplayHolder" size="40" onclick="setCalDisplayFlag(this.form['calendar.display'],this.checked);">
              <xsl:if test="display = 'true'">
                <xsl:attribute name="checked">checked</xsl:attribute>
              </xsl:if>
            </input>
            <xsl:text> </xsl:text>
            <label for="calDisplayHolder">
              <xsl:copy-of select="$bwStr-CuCa-DisplayItemsInThisCollection"/>
            </label>
          </td>
        </tr>
        <!-- hide filter expression for now -->
        <!--
        <tr>
          <th><xsl:copy-of select="$bwStr-CuCa-FilterExpression"/></th>
          <td>
            <input type="text" name="fexpr" value="" size="40"/>
          </td>
        </tr>
        -->
        <!--
        <tr>
          <th><xsl:copy-of select="$bwStr-CuCa-Type"/></th>
          <td>
            < ! - - we will set the value of "calendarCollection on submit.
                 Value is false only for folders, so we default it to true here.  - - >
            <input type="hidden" value="calendar" name="type" id="bwCalType"/>
            < ! - - type is defaulted to calendar.  It is changed when a typeSwitch is clicked. - - >
            <input type="hidden" value="calendar" name="type" id="bwCalType"/>
            <input type="radio" value="calendar" name="typeSwitch" id="bwCalTypeCal" checked="checked" onclick="changeClass('subscriptionTypes','invisible');setField('bwCalType',this.value);"/>
            <xsl:text> </xsl:text>
            <label for="bwCalTypeCal">
              <xsl:copy-of select="$bwStr-CuCa-Calendar"/>
            </label>
            <input type="radio" value="folder" name="typeSwitch" id="bwCalTypeFolder" onclick="changeClass('subscriptionTypes','invisible');setField('bwCalType',this.value);"/>
            <xsl:text> </xsl:text>
            <label for="bwCalTypeFolder">
              <xsl:copy-of select="$bwStr-CuCa-Folder"/>
            </label>
          </td>
        </tr>
        -->
      </table>
      <div class="note sharingNote">
        <xsl:copy-of select="$bwStr-CuCa-SharingMayBeAdded"/>
      </div>
      <div class="submitButtons">
        <input type="submit" name="addCalendar" value="{$bwStr-CuCa-Add}"/>
        <input type="submit" name="cancelled" value="{$bwStr-CuCa-Cancel}"/>
      </div>
    </form>

  </xsl:template>

  <xsl:template name="addSubscription">
    <h3><xsl:value-of select="$bwStr-CuCa-AddSubscription"/></h3>
    <div id="subscriptionTypes">
      <!-- If we are making a subscription, we will set the hidden value of "aliasUri" based
            on the subscription type. -->
      <input type="hidden" name="aliasUri" value=""/>
      <p>
        <strong><xsl:copy-of select="$bwStr-CuCa-SubscriptionType"/></strong>
        <xsl:text> </xsl:text>
        <!-- subType is defaulted to external.  It is changed when a subTypeSwitch is clicked. -->
        <input type="hidden" value="external" name="subType" id="bwSubType"/><br/>

        <input type="radio" name="subTypeSwitch" id="subSwitchExternal" value="external" checked="checked" onclick="changeClass('subscriptionTypePublic','invisible');changeClass('subscriptionTypeExternal','visible');setField('bwSubType',this.value);"/>
        <xsl:text> </xsl:text>
        <label for="subSwitchExternal">
          <xsl:copy-of select="$bwStr-CuCa-URL"/>
        </label>

        <input type="radio" name="subTypeSwitch" id="subSwitchPublic" value="public" onclick="changeClass('subscriptionTypePublic','visible');changeClass('subscriptionTypeExternal','invisible');setField('bwSubType',this.value);"/>
        <xsl:text> </xsl:text>
        <label for="subSwitchPublic">
          <xsl:copy-of select="$bwStr-CuCa-PublicCalendar"/>
        </label>

        <!-- type user is deprecated in this way - will stick with new sharing model as of version 3.9 -->
        <!--
         <input type="radio" name="subTypeSwitch" value="user" onclick="changeClass('subscriptionTypePublic','invisible');changeClass('subscriptionTypeExternal','invisible');changeClass('subscriptionTypeUser','visible');setField('bwSubType',this.value);"/><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-CuCa-UserCalendar"/>
         -->
      </p>

      <div id="subscriptionTypePublic" class="invisible">
        <form id="intSubscription" name="intSubscription" action="{$sharing-subscribe}" method="post">
          <input type="hidden" value="" name="colHref" id="publicAliasHolder"/>
          <div id="bwPublicCalSubscribe" class="invisible">
            <table class="common">
              <tr>
                <th>
	                 Path:
                </th>
                <td>
                  <div id="bwPublicCalDisplay"></div>
                  <!-- button type="button" onclick="showPublicCalAliasTree();"><xsl:copy-of select="$bwStr-CuCa-SelectAPublicCalOrFolder"/></button-->
                </td>
              </tr>
              <tr>
                <th>
                  <xsl:copy-of select="$bwStr-CuCa-Summary"/>
                </th>
                <td>
                  <input type="text" name="colName" id="intSubDisplayName" value="" size="40"/>
                </td>
              </tr>
              <tr>
                <td colspan="2">
                  <input type="submit" id="intSubSubmit">
                    <xsl:attribute name="value"><xsl:value-of select="$bwStr-CuCa-Add"/></xsl:attribute>
                  </input>
                </td>
              </tr>
            </table>
          </div>
        </form>
        <ul id="publicSubscriptionTree">
          <xsl:apply-templates select="/bedework/publicCalendars/calendar/calendar[name='aliases']/calendar" mode="selectCalForPublicAliasCalTree"/>
        </ul>
      </div>

      <!-- deprecated version 3.9 -->
      <!--
       <div id="subscriptionTypeUser" class="invisible">
         <table class="common">
           <tr>
             <th><xsl:copy-of select="$bwStr-CuCa-UsersID"/></th>
             <td>
               <input type="text" name="userIdHolder" value="" size="40"/>
             </td>
           </tr>
           <tr>
             <th><xsl:copy-of select="$bwStr-CuCa-CalendarPath"/></th>
             <td>
               <input type="text" name="userCalHolder" value="calendar" size="40"/><br/>
               <span class="note"><xsl:copy-of select="$bwStr-CuCa-DefaultCalendarOrSomeCalendar"/></span>
             </td>
           </tr>
           <tr>
             <td colspan="2">
               <button><xsl:value-of select="$bwStr-CuCa-Add"/></button>
             </td>
           </tr>
         </table>
       </div>
       -->


      <div id="subscriptionTypeExternal">
        <form id="extSubscription" name="extSubscription" action="{$sharing-subscribe}" method="post">
          <table class="common">
            <tr>
              <th><xsl:copy-of select="$bwStr-CuCa-URLToCalendar"/></th>
              <td>
                <input type="text" name="extUrl" id="extUrl" value="" size="40"/>
              </td>
            </tr>
            <tr>
              <th><xsl:copy-of select="$bwStr-CuCa-Summary"/></th>
              <td>
                <input type="text" name="colName" id="extSubDisplayName" value="" size="40"/>
              </td>
            </tr>
            <tr>
              <td><xsl:copy-of select="$bwStr-CuCa-ID"/></td>
              <td>
                <input type="text" name="remoteId" value="" size="40"/>
              </td>
            </tr>
            <tr>
              <td><xsl:copy-of select="$bwStr-CuCa-Password"/></td>
              <td>
                <input type="password" name="remotePw" value="" size="40"/>
              </td>
            </tr>
            <tr>
              <td colspan="2">
                <input type="submit" id="extSubSubmit">
                  <xsl:attribute name="value"><xsl:value-of select="$bwStr-CuCa-Add"/></xsl:attribute>
                </input>
              </td>
            </tr>
          </table>
        </form>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="currentCalendar" mode="modCalendar">
    <xsl:variable name="calPath" select="path"/>
    <xsl:variable name="calPathEncoded" select="encodedPath"/>

    <form name="modCalForm" id="modCalForm" method="post" action="{$calendar-update}">
      <xsl:if test="$publicOnly = 'false'">
        <a href="#" id="modCalAdvancedSwitch" class="modCalBasic"><xsl:copy-of select="$bwStr-CuCa-AdvancedOptions"/></a>
      </xsl:if>
      <a href="#" id="modCalBasicSwitch" class="modCalAdvanced"><xsl:copy-of select="$bwStr-CuCa-BasicOptions"/></a>
      <xsl:choose>
        <xsl:when test="isSubscription='true'">
          <h3><xsl:copy-of select="$bwStr-CuCa-ModifySubscription"/></h3>
          <input type="hidden" value="true" name="calendarCollection"/>
        </xsl:when>
        <xsl:when test="calType = '0'">
          <h3><xsl:copy-of select="$bwStr-CuCa-ModifyFolder"/></h3>
          <input type="hidden" value="false" name="calendarCollection"/>
        </xsl:when>
        <xsl:otherwise>
          <h3><xsl:copy-of select="$bwStr-CuCa-ModifyCalendar"/></h3>
          <input type="hidden" value="true" name="calendarCollection"/>
        </xsl:otherwise>
      </xsl:choose>

      <table class="common">
        <tr>
          <th class="commonHeader" colspan="2">
            <xsl:value-of select="path"/>
          </th>
        </tr>
        <xsl:if test="lastRefreshStatus &gt;= 300">
          <tr class="httpStatusMsg">
            <th><xsl:copy-of select="$bwStr-CuCa-HttpStatus"/></th>
            <td>
              <xsl:call-template name="httpStatusCodes">
                <xsl:with-param name="code"><xsl:value-of  select="lastRefreshStatus"/></xsl:with-param>
              </xsl:call-template>
            </td>
          </tr>
        </xsl:if>
        <tr class="modCalAdvanced">
          <th><xsl:copy-of select="$bwStr-CuCa-Name"/></th>
          <td>
            <xsl:value-of select="name"/>
          </td>
        </tr>
        <!-- tr>
          <th>Mailing List ID:</th>
          <td>
            <xsl:value-of select="mailListId"/>
          </td>
        </tr -->
        <tr>
          <th><xsl:copy-of select="$bwStr-CuCa-Summary"/></th>
          <td>
            <xsl:variable name="curCalSummary" select="summary"/>
            <input type="text" name="calendar.summary" value="{$curCalSummary}" size="40"/>
          </td>
        </tr>
        <tr class="modCalAdvanced">
          <th><xsl:copy-of select="$bwStr-CuCa-Description"/></th>
          <td>
            <textarea name="calendar.description" cols="40" rows="4">
              <xsl:value-of select="desc"/>
              <xsl:if test="normalize-space(desc) = ''">
                <xsl:text> </xsl:text>
                <!-- keep this non-breaking space to avoid browser
                rendering errors when the text area is empty -->
              </xsl:if>
            </textarea>
          </td>
        </tr>
        <!-- xsl:if test="isSubscription='false'" -->
        <!-- we can't color subscriptions yet -->
        <tr>
          <th><xsl:copy-of select="$bwStr-CuCa-Color"/></th>
          <td>
            <input type="text" name="calendar.color" id="bwCalColor" size="7">
              <xsl:attribute name="value"><xsl:value-of select="color"/></xsl:attribute>
              <xsl:attribute name="style">background-color: <xsl:value-of select="color"/>;color: black;</xsl:attribute>
            </input>
            <xsl:call-template name="colorPicker">
              <xsl:with-param name="colorFieldId">bwCalColor</xsl:with-param>
              <xsl:with-param name="colorValue"><xsl:value-of select="color"/></xsl:with-param>
            </xsl:call-template>
          </td>
        </tr>
        <!-- /xsl:if -->
        <tr class="modCalAdvanced">
          <th><xsl:copy-of select="$bwStr-CuCa-Display"/></th>
          <td>
            <input type="hidden" name="calendar.display">
              <xsl:attribute name="value"><xsl:value-of select="display"/></xsl:attribute>
            </input>
            <input type="checkbox" name="displayHolder" size="40" onclick="setCalDisplayFlag(this.form['calendar.display'],this.checked)">
              <xsl:if test="display = 'true'">
                <xsl:attribute name="checked">checked</xsl:attribute>
              </xsl:if>
            </input><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-CuCa-DisplayItemsInThisCollection"/>
          </td>
        </tr>
        <tr class="modCalAdvanced">
          <xsl:attribute name="class">disabled</xsl:attribute>
          <th><xsl:copy-of select="$bwStr-CuCa-Disabled"/></th>
          <td>
            <input type="radio" name="calendar.disabled" value="false">
              <xsl:if test="disabled = 'false'">
                <xsl:attribute name="checked">checked</xsl:attribute>
              </xsl:if>
            </input>
            <xsl:copy-of select="$bwStr-CuCa-EnabledLabel"/>
            <input type="radio" name="calendar.disabled" value="true">
              <xsl:if test="disabled = 'true'">
                <xsl:attribute name="checked">checked</xsl:attribute>
              </xsl:if>
            </input>
            <xsl:copy-of select="$bwStr-CuCa-DisabledLabel"/>
            <xsl:if test="disabled = 'true'">
              <span class="disabledNote">
                <xsl:copy-of select="$bwStr-CuCa-ThisItemIsInaccessible"/>
              </span>
            </xsl:if>
          </td>
        </tr>
        <tr class="modCalAdvanced">
          <th><xsl:copy-of select="$bwStr-CuCa-FilterExpression"/></th>
          <td>
            <input type="text" name="fexpr" value="" size="40">
              <xsl:attribute name="value"><xsl:value-of select="filterExpr"/></xsl:attribute>
            </input>
          </td>
        </tr>
        <xsl:if test="isSubscription = 'true'">
          <tr>
            <th><xsl:copy-of select="$bwStr-CuCa-URL"/></th>
            <td>
              <input name="aliasUri" value="" size="40">
                <xsl:attribute name="value"><xsl:value-of select="aliasUri"/></xsl:attribute>
              </input>
            </td>
          </tr>
          <xsl:if test="externalSub = 'true'">
            <tr>
              <th><xsl:copy-of select="$bwStr-CuCa-ID"/></th>
              <td>
                <input name="remoteId" value="" size="40"/>
              </td>
            </tr>
            <tr>
              <th><xsl:copy-of select="$bwStr-CuCa-Password"/></th>
              <td>
                <input type="password" name="remotePw" value="" size="40"/>
              </td>
            </tr>
          </xsl:if>
        </xsl:if>
      </table>

      <div id="calAccessBoxHolder" class="modCalAdvanced">
        <span id="calAccessBoxToggle">
          <img src="{$resourcesRoot}/images/plus.gif"/> Advanced Access Controls
        </span>
        <div id="accessBox">
          <h3><xsl:copy-of select="$bwStr-CuCa-CurrentAccess"/></h3>
          <div id="bwCurrentAccessWidget">&#160;</div>
          <script type="text/javascript">
	          bwAcl.display("bwCurrentAccessWidget");
          </script>
          <xsl:call-template name="entityAccessForm">
            <xsl:with-param name="outputId">bwCurrentAccessWidget</xsl:with-param>
          </xsl:call-template>

          <div class="note">
            <xsl:copy-of select="$bwStr-CuCa-AccessNote"/>
          </div>
        </div>
      </div>

      <table border="0" id="submitTable">
        <tr>
          <td>
            <xsl:choose>
              <xsl:when test="isSubscription='true'">
                <input type="submit" name="updateCalendar" value="{$bwStr-CuCa-UpdateSubscription}"/>
              </xsl:when>
              <xsl:when test="calType = '0'">
                <input type="submit" name="updateCalendar" value="{$bwStr-CuCa-UpdateFolder}"/>
              </xsl:when>
              <xsl:otherwise>
                <input type="submit" name="updateCalendar" value="{$bwStr-CuCa-UpdateCalendar}"/>
              </xsl:otherwise>
            </xsl:choose>
            <input type="submit" name="cancelled" value="{$bwStr-CuCa-Cancel}"/>
          </td>
          <td align="right">
            <xsl:if test="calType != '3' and calType != '5' and calType != '6'">
              <xsl:choose>
                <xsl:when test="isSubscription='true'">
                  <input type="submit" name="delete" value="{$bwStr-CuCa-DeleteSubscription}"/>
                </xsl:when>
                <xsl:when test="calType = '0'">
                  <input type="submit" name="delete" value="{$bwStr-CuCa-DeleteFolder}"/>
                </xsl:when>
                <xsl:otherwise>
                  <input type="submit" name="delete" value="{$bwStr-CuCa-DeleteCalendar}"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
          </td>
        </tr>
      </table>
    </form>

    <xsl:if test="can-be-shared">
      <div id="calSharingBox">
        <h3><xsl:copy-of select="$bwStr-CuCa-Sharing"/></h3>
        <form id="calSharingForm" name="calSharingForm" method="post" action="{$sharing-shareCollection}" onsubmit="return validateShareForm(this.shareWithAcct.value);">
          <table class="common">
            <tr>
              <td>
                <label for="shareWithAcct"><xsl:copy-of select="$bwStr-CuCa-ShareWith"/></label>
              </td>
              <td>
                <input type="hidden" name="colHref" value="{$calPath}"/>
                <input type="text" id="shareWithAcct" name="cua" size="18" placeholder="{$bwStr-CuCa-SharePlaceholder}"/>
              </td>
              <td>
                <button name="submit" id="shareWithButton" type="submit">
                  <xsl:copy-of select="$bwStr-CuCa-Share"/>
                </button>
              </td>
            </tr>
            <tr>
              <td>
                <label for="shareColName"><xsl:copy-of select="$bwStr-CuCa-SuggestedName"/></label>
              </td>
              <td>
                <xsl:variable name="calSummary" select="summary"/>
                <input type="text" id="shareColName" name="colName" size="18" value="{$calSummary}"/><br/>
                <span class="calShareField"><input type="checkbox" name="rw" value="true"/><xsl:copy-of select="$bwStr-CuCa-WriteAccess"/></span>
              </td>
              <td></td>
            </tr>
          </table>
        </form>
      </div>
      <xsl:if test="CSS:invite/CSS:user">
        <table id="shareesTable" class="common">
          <tr>
            <th><xsl:copy-of select="$bwStr-CuCa-SharedBy"/></th>
            <th><xsl:copy-of select="$bwStr-CuCa-Status"/></th>
            <th><xsl:copy-of select="$bwStr-CuCa-WriteAccess"/></th>
            <th><xsl:copy-of select="$bwStr-CuCa-Remove"/></th>
          </tr>
          <xsl:for-each select="CSS:invite/CSS:user">
            <xsl:sort order="ascending" select="DAV:href"/>
            <xsl:variable name="sharee" select="DAV:href"/>
            <tr>
              <td class="sharee">
                <xsl:value-of select="substring-after($sharee,'mailto:')"/>
              </td>
              <td class="status">
                <xsl:choose>
                  <xsl:when test="CSS:invite-noresponse"><span class="invite-pending"><xsl:copy-of select="$bwStr-CuCa-Pending"/></span></xsl:when>
                  <xsl:when test="CSS:invite-declined"><span class="invite-declined"><xsl:copy-of select="$bwStr-CuCa-Declined"/></span></xsl:when>
                  <xsl:otherwise><span class="invite-accepted"><xsl:copy-of select="$bwStr-CuCa-Accepted"/></span></xsl:otherwise>
                </xsl:choose>
              </td>
              <td class="access">
                <form method="post" action="{$sharing-shareCollection}">
                  <input type="hidden" name="colHref" value="{$calPath}"/>
                  <input type="hidden" name="cua" value="{$sharee}"/>
                  <input type="checkbox" name="rw" onclick="this.form.submit();">
                    <xsl:if test="CSS:access/CSS:write">
                      <xsl:attribute name="checked">checked</xsl:attribute>
                    </xsl:if>
                  </input>
                </form>
              </td>
              <td class="remove">
                <a href="{$sharing-shareCollection}&amp;colHref={$calPath}&amp;cua={$sharee}&amp;remove=true">
                  <img src="{$resourcesRoot}/images/trashIcon.gif" width="13" height="13" border="0" alt="{$bwStr-Inbx-Delete}"/>
                </a>
              </td>
            </tr>
          </xsl:for-each>
          <!--
		      <xsl:for-each select="CSS:invite/CSS:user[CSS:invite-noresponse]">
            <xsl:sort type="ascending" select="DAV:href"/>
            <xsl:variable name="sharee" select="DAV:href"/>
            <tr>
              <td class="sharee"><xsl:value-of select="substring-after($sharee,'mailto:')"/></td>
              <td colspan="2">invitation awaiting response</td>
              <td style="text-align: center;">
                <a href="{$sharing-shareCollection}&amp;colHref={$calPath}&amp;cua={$sharee}&amp;remove=true">
                  <img src="{$resourcesRoot}/images/trashIcon.gif" width="13" height="13" border="0" alt="{$bwStr-Inbx-Delete}"/>
                </a>
              </td>
            </tr>
          </xsl:for-each>
          <xsl:for-each select="CSS:invite/CSS:user[CSS:invite-declined]">
            <xsl:sort type="ascending" select="DAV:href"/>
            <xsl:variable name="sharee" select="DAV:href"/>
            <tr>
              <td><xsl:value-of select="substring-after($sharee,'mailto:')"/></td>
              <td colspan="2">invitation declined</td>
              <td style="text-align: center;">
                <a href="{$sharing-shareCollection}&amp;colHref={$calPath}&amp;cua={$sharee}&amp;remove=true">
                  <img src="{$resourcesRoot}/images/trashIcon.gif" width="13" height="13" border="0" alt="{$bwStr-Inbx-Delete}"/>
                </a>
              </td>
            </tr>
          </xsl:for-each>
          -->
        </table>
      </xsl:if>
    </xsl:if>


    <!-- Method 1 access setting is now deprecated.
         see the "entityAccessForm" template for more information -->
    <!--  div id="accessBox">
      <xsl:apply-templates select="acl" mode="currentAccess">
        <xsl:with-param name="action" select="$calendar-setAccess"/>
        <xsl:with-param name="calPathEncoded" select="$calPathEncoded"/>
      </xsl:apply-templates>
      <form name="calendarShareForm" method="post" action="{$calendar-setAccess}" id="shareForm" onsubmit="setAccessHow(this)">
        <input type="hidden" name="calPath" value="{$calPath}"/>
        <xsl:call-template name="entityAccessForm">
          <xsl:with-param name="type">
            <xsl:choose>
              <xsl:when test="calType = '5'">inbox</xsl:when>
              <xsl:when test="calType = '6'">outbox</xsl:when>
              <xsl:otherwise>normal</xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
        </xsl:call-template>
      </form>
    </div -->
  </xsl:template>

  <xsl:template name="colorPicker">
    <xsl:param name="colorFieldId"/><!-- required: id of text field to be updated -->
    <button type="button" id="bwColorPickerButton" value="{$bwStr-CoPi-Pick}"><img src="{$resourcesRoot}/images/colorIcon.gif" width="16" height="13" alt="pick a color"/></button>
    <script type="text/javascript">
      $(document).ready(function() {
        $('#bwColorPickerButton').ColorPicker({
				  onSubmit: function(hsb, hex, rgb, el) {
              var fullHex = "#" + hex;
              $('#<xsl:value-of select="$colorFieldId"/>').val(fullHex);
              $('#<xsl:value-of select="$colorFieldId"/>').css('background-color',fullHex);
              $(el).ColorPickerHide();
            },
            onBeforeShow: function () {
              var curColor = $('#<xsl:value-of select="$colorFieldId"/>').val();
              $(this).ColorPickerSetColor(curColor);
            }
				});
      });
    </script>
  </xsl:template>

  <xsl:template name="calendarList">
    <h3><xsl:copy-of select="$bwStr-CaLi-ManagingCalendars"/></h3>
    <ul>
      <li><xsl:copy-of select="$bwStr-CaLi-SelectFromCalendar"/><xsl:text> </xsl:text>(<img src="{$resourcesRoot}/images/calIcon-sm.gif" width="13" height="13" alt="true" border="0"/>),
        <xsl:copy-of select="$bwStr-CaLi-Subscription"/><xsl:text> </xsl:text>(<img src="{$resourcesRoot}/images/calIconAlias2-sm.gif" width="17" height="13" alt="true" border="0"/>)<xsl:copy-of select="$bwStr-CaLi-OrFolder"/><xsl:text> </xsl:text>(<img src="{$resourcesRoot}/images/catIcon.gif" width="13" height="13" alt="true" border="0"/>).</li>
      <li><xsl:copy-of select="$bwStr-CaLi-Select"/><xsl:text> </xsl:text>
        <img src="{$resourcesRoot}/images/calAddIcon.gif" width="13" height="13" alt="true" border="0"/>
        <xsl:text> </xsl:text><xsl:copy-of select="$bwStr-CaLi-Icon"/>
        <ul>
          <li><xsl:copy-of select="$bwStr-CaLi-Folders"/></li>
          <li><xsl:copy-of select="$bwStr-CaLi-Calendars"/></li>
        </ul>
      </li>
    </ul>
  </xsl:template>

  <xsl:template name="calendarDescriptions">
    <h2><xsl:copy-of select="$bwStr-CaDe-CalInfo"/></h2>
    <ul>
      <li><xsl:copy-of select="$bwStr-CaDe-SelectAnItem"/></li>
    </ul>

    <p><strong><xsl:copy-of select="$bwStr-CaDe-AllCalDescriptions"/></strong></p>
    <table id="flatCalendarDescriptions" cellspacing="0">
      <tr>
        <th><xsl:copy-of select="$bwStr-CaDe-Name"/></th>
        <th><xsl:copy-of select="$bwStr-CaDe-Description"/></th>
      </tr>
      <xsl:for-each select="//calendar[calType &lt; 2]">
        <xsl:variable name="descClass">
          <xsl:choose>
            <xsl:when test="position() mod 2 = 0">even</xsl:when>
            <xsl:otherwise>odd</xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <tr class="{$descClass}">
          <td>
            <xsl:value-of select="summary"/>
          </td>
          <td>
            <xsl:value-of select="desc"/>
          </td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <xsl:template match="currentCalendar" mode="displayCalendar">
    <h2><xsl:copy-of select="$bwStr-CuCa-CalendarInformation"/></h2>
    <table class="common">
      <tr>
        <th><xsl:copy-of select="$bwStr-CuCa-Name"/></th>
        <td>
          <xsl:value-of select="name"/>
        </td>
      </tr>
      <tr>
        <th><xsl:copy-of select="$bwStr-CuCa-Path"/></th>
        <td>
          <xsl:value-of select="path"/>
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
  </xsl:template>

  <xsl:template match="currentCalendar" mode="deleteCalendarConfirm">
    <xsl:choose>
      <xsl:when test="calType = '0'">
        <h3><xsl:copy-of select="$bwStr-CuCa-DeleteFolder"/></h3>
        <p>
          <xsl:copy-of select="$bwStr-CuCa-TheFollowingFolder"/>
        </p>
      </xsl:when>
      <xsl:otherwise>
        <h3><xsl:copy-of select="$bwStr-CuCa-DeleteCalendar"/></h3>
        <p>
          <xsl:copy-of select="$bwStr-CuCa-TheFollowingCalendar"/>
        </p>
      </xsl:otherwise>
    </xsl:choose>

    <form name="delCalForm" method="post" action="{$calendar-delete}">
      <input type="hidden" name="deleteContent" value="true"/>
      <table class="common">
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

      <table border="0" id="submitTable">
        <tr>
          <td>
            <input type="submit" name="cancelled" value="{$bwStr-CuCa-Cancel}"/>
          </td>
          <td align="right">
            <xsl:choose>
              <xsl:when test="calType = '0'">
                <input type="submit" name="delete" value="{$bwStr-CuCa-YesDeleteFolder}"/>
              </xsl:when>
              <xsl:otherwise>
                <input type="submit" name="delete" value="{$bwStr-CuCa-YesDeleteCalendar}"/>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
      </table>
    </form>

  </xsl:template>

  <xsl:template match="calendars" mode="exportCalendars">
    <h2><xsl:copy-of select="$bwStr-Cals-ExportCals"/></h2>
    <form name="eventForm" id="exportCalendarForm" action="{$export}" method="post">
      <input type="hidden" name="calPath" value=""/>
      <input type="hidden" name="nocache" value="no"/>
      <input type="hidden" name="contentName" value="calendar.ics"/>

      <table class="common" cellspacing="0">
        <tr>
          <th class="commonHeader">
            <xsl:copy-of select="$bwStr-Cals-EventDateLimits"/>
            <input type="radio" name="dateLimits" value="active" checked="checked" onclick="changeClass('exportDateRange','invisible')"/> <xsl:copy-of select="$bwStr-Cals-TodayForward"/>
            <input type="radio" name="dateLimits" value="none" onclick="changeClass('exportDateRange','invisible')"/> <xsl:copy-of select="$bwStr-Cals-AllDates"/>
            <input type="radio" name="dateLimits" value="limited" onclick="changeClass('exportDateRange','visible')"/> <xsl:copy-of select="$bwStr-Cals-DateRange"/>
          </th>
        </tr>
        <tr id="exportDateRange" class="invisible">
          <td class="dates">
            <xsl:copy-of select="$bwStr-Cals-Start"/>
            <div class="dateFields">
              <xsl:copy-of select="/bedework/formElements/form/start/month/*"/>
              <xsl:copy-of select="/bedework/formElements/form/start/day/*"/>
              <xsl:copy-of select="/bedework/formElements/form/start/yearText/*"/>
            </div>
            &#160;&#160;
            <xsl:copy-of select="$bwStr-Cals-End"/>
            <div class="dateFields">
              <xsl:copy-of select="/bedework/formElements/form/end/month/*"/>
              <xsl:copy-of select="/bedework/formElements/form/end/day/*"/>
              <xsl:copy-of select="/bedework/formElements/form/end/yearText/*"/>
            </div>
          </td>
        </tr>
        <tr>
          <th class="borderRight">
            <xsl:copy-of select="$bwStr-Cals-MyCalendars"/>
          </th>
        </tr>
        <tr>
          <td class="borderRight">
            <!-- My Calendars -->
            <ul class="calendarTree">
              <!-- list normal calendars first -->
              <xsl:choose>
                <xsl:when test="$publicOnly = 'true'">
                  <xsl:for-each select="/bedework/myCalendars/calendars/calendar//calendar[calType = '1' and isSubscription = 'true']">
                    <li class="calendar">
                      <xsl:variable name="calPath" select="path"/>
                      <xsl:variable name="name" select="name"/>
                      <a href="javascript:exportCalendar('exportCalendarForm','{$name}','{$calPath}')">
                        <xsl:value-of select="summary"/>
                      </a>
                    </li>
                  </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:for-each select="/bedework/myCalendars/calendars/calendar//calendar[calType = '1']">
                    <li class="calendar">
                      <xsl:variable name="calPath" select="path"/>
                      <xsl:variable name="name" select="name"/>
                      <a href="javascript:exportCalendar('exportCalendarForm','{$name}','{$calPath}')">
                        <xsl:value-of select="summary"/>
                      </a>
                    </li>
                  </xsl:for-each>
                </xsl:otherwise>
              </xsl:choose>
            </ul>
            <xsl:if test="$publicOnly = 'false'">
              <ul class="calendarTree">
                <!-- list special calendars next -->
                <xsl:for-each select="/bedework/myCalendars/calendars/calendar//calendar[calType &gt; 1]">
                  <li class="calendar">
                    <xsl:variable name="calPath" select="path"/>
                    <xsl:variable name="name" select="name"/>
                    <a href="javascript:exportCalendar('exportCalendarForm','{$name}','{$calPath}')">
                      <xsl:value-of select="summary"/>
                    </a>
                  </li>
                </xsl:for-each>
              </ul>
            </xsl:if>
          </td>
          <!-- td>
            <ul class="calendarTree">
              <xsl:apply-templates select="./calendar" mode="buildExportTree"/>
            </ul>
          </td-->
        </tr>
      </table>
    </form>
  </xsl:template>

  <xsl:template match="calendar" mode="buildExportTree">
    <xsl:choose>
      <xsl:when test="calType = '0'">
        <li class="folder">
          <xsl:value-of select="summary"/>
          <xsl:if test="calendar">
            <ul>
              <xsl:apply-templates select="calendar" mode="buildExportTree"/>
            </ul>
          </xsl:if>
        </li>
      </xsl:when>
      <xsl:otherwise>
        <li class="calendar">
          <xsl:variable name="calPath" select="path"/>
          <xsl:variable name="name" select="name"/>
          <a href="javascript:exportCalendar('exportCalendarForm','{$name}','{$calPath}')">
            <xsl:value-of select="summary"/>
          </a>
        </li>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
