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

  <!--+++++++++++++++ Subscriptions (aliases) ++++++++++++++++++++-->
  <!-- templates:
         - subscriptions
         - subscriptionIntro
         - listForUpdateSubscription
         - addSubscription
         - selectCalForPublicAliasCalTree
         - deleteSubConfirm

    Note: subscriptions are calendar aliases: calendar collections that
    point at another calendar with or without a filter applied.


    Calendar and subscription templates depend heavily on calendar types:

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

      calType 7 and 8 will only be returned when a link to an alias is broken.
      The system will instead return the underlying calendar type (down the tree).
      Check the isSubscription flag to see if a collection is an alias and set
      icons etc. based on that + the underlying calType.
  -->

  <xsl:template match="calendars" mode="subscriptions">
    <table id="calendarTable">
      <tr>
        <td class="cals">
          <h3><xsl:copy-of select="$bwStr-Subs-Subscriptions"/></h3>
          <ul class="calendarTree">
            <xsl:apply-templates select="calendar" mode="listForUpdateSubscription">
              <xsl:with-param name="root">true</xsl:with-param>
            </xsl:apply-templates>
          </ul>
        </td>
        <td class="calendarContent">
          <xsl:choose>
            <xsl:when test="/bedework/page='subscriptions'">
              <xsl:call-template name="subscriptionIntro"/>
            </xsl:when>
            <xsl:when test="/bedework/page='deleteSubConfirm'">
              <xsl:apply-templates select="/bedework/currentCalendar" mode="deleteSubConfirm"/>
            </xsl:when>
            <xsl:when test="/bedework/creating='true'">
              <xsl:apply-templates select="/bedework/currentCalendar" mode="addSubscription"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="/bedework/currentCalendar" mode="modCalendar"/>
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template name="subscriptionIntro">
    <h3><xsl:copy-of select="$bwStr-Subs-ManagingSubscriptions"/></h3>
    <ul>
      <li>
        <xsl:copy-of select="$bwStr-Subs-SelectAnItem"/>
      </li>
      <li>
        <xsl:copy-of select="$bwStr-Subs-SelectThe"/>
        <img src="{$resourcesRoot}/images/calAddIcon.gif" width="13" height="13" alt="true"/>
        <xsl:copy-of select="$bwStr-Subs-IconToAdd"/>
      </li>
    </ul>
    <xsl:copy-of select="$bwStr-Subs-TopicalAreasNote"/>
  </xsl:template>

  <xsl:template match="calendar" mode="listForUpdateSubscription">
    <xsl:param name="root">false</xsl:param>
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
          <xsl:when test="calType = '0'"><xsl:copy-of select="$bwStr-Cals-Folder"/></xsl:when>
          <xsl:otherwise>calendar</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:if test="calType = '0' and isSubscription='false'">
         <xsl:choose>
          <xsl:when test="open = 'true'">
            <a href="{$subscriptions-openCloseMod}&amp;calPath={$calPath}&amp;open=false">
              <img src="{$resourcesRoot}/images/minus.gif" width="9" height="9" alt="close" class="bwPlusMinusIcon"/>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <a href="{$subscriptions-openCloseMod}&amp;calPath={$calPath}&amp;open=true">
              <img src="{$resourcesRoot}/images/plus.gif" width="9" height="9" alt="open" class="bwPlusMinusIcon"/>
            </a>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="$root = 'true'">
          <!-- treat the root calendar as the root of calendar suite; don't allow edits -->
          <xsl:value-of select="/bedework/currentCalSuite/name"/>
        </xsl:when>
        <xsl:otherwise>
          <a href="{$subscriptions-fetchForUpdate}&amp;calPath={$calPath}" title="update">
          <xsl:if test="lastRefreshStatus &gt;= 300">
            <xsl:attribute name="title">
              <xsl:call-template name="httpStatusCodes">
                <xsl:with-param name="code"><xsl:value-of select="lastRefreshStatus"/></xsl:with-param>
              </xsl:call-template>
            </xsl:attribute>
          </xsl:if>
            <xsl:value-of select="summary"/>
          </a>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="calType = '0' and isSubscription='false'">
        <xsl:text> </xsl:text>
        <a href="{$subscriptions-initAdd}&amp;calPath={$calPath}" title="{$bwStr-Cals-AddSubscription}">
          <img src="{$resourcesRoot}/images/calAddIcon.gif" width="13" height="13" alt="{$bwStr-Cals-AddSubscription}"/>
        </a>
      </xsl:if>
      <xsl:if test="calendar">
        <ul>
          <xsl:apply-templates select="calendar[isSubscription = 'true' or calType = '0']" mode="listForUpdateSubscription"/>
        </ul>
      </xsl:if>
    </li>
  </xsl:template>

  <xsl:template match="currentCalendar" mode="addSubscription">
    <h3><xsl:copy-of select="$bwStr-CuCa-AddSubscription"/></h3>
    <p class="note"><xsl:copy-of select="$bwStr-CuCa-AccessNote"/></p>
    <form name="addCalForm" method="post" action="{$subscriptions-update}" onsubmit="setCatFilters(this);return setCalendarAlias(this);">
      <table class="common">
        <tr>
          <th><xsl:copy-of select="$bwStr-CuCa-Name"/></th>
          <td>
            <xsl:variable name="curCalName" select="name"/>
            <input name="calendar.name" value="{$curCalName}" size="40"/>
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
          <th><xsl:copy-of select="$bwStr-CuCa-TopicalArea"/></th>
          <td>
            <input type="radio" name="calendar.isTopicalArea" id="isTaTrue" value="true" checked="checked"/>
            <xsl:text> </xsl:text>
            <label for="isTaTrue"><xsl:copy-of select="$bwStr-CuCa-True"/></label>
            <input type="radio" name="calendar.isTopicalArea" id="isTaFalse" value="false"/>
            <xsl:text> </xsl:text>
            <label for="isTaFalse"><xsl:copy-of select="$bwStr-CuCa-False"/></label>
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
        <!-- For now, colors need to be set in the calendar suite stylesheet. -->
        <!-- tr>
          <th>Color:</th>
          <td>
            <select name="calendar.color">
              <option value="">default</option>
              <xsl:for-each select="document('subColors.xml')/subscriptionColors/color">
                <xsl:variable name="subColor" select="@rgb"/>
                <xsl:variable name="subColorClass" select="."/>
                <option value="{$subColor}" class="{$subColorClass}">
                  <xsl:value-of select="@name"/>
                </option>
              </xsl:for-each>
            </select>
          </td>
        </tr-->
        <tr>
          <th><xsl:copy-of select="$bwStr-CuCa-Filter"/></th>
          <td>
            <input type="hidden" name="fexpr" value=""/>
            <button type="button" onclick="toggleVisibility('filterCategories','visible')">
              <xsl:copy-of select="$bwStr-CuCa-ShowHideCategoriesFiltering"/>
            </button>
            <div id="filterCategories" class="invisible">
              <ul class="catlist">
                <xsl:for-each select="/bedework/categories/all/category">
                  <xsl:sort select="value" order="ascending"/>
                  <li>
                    <input type="checkbox" name="filterCatUid">
                      <xsl:attribute name="value"><xsl:value-of select="uid"/></xsl:attribute>
                      <xsl:attribute name="id">f<xsl:value-of select="generate-id(uid)"/></xsl:attribute>
                    </input>
                    <label for="f{generate-id(uid)}"><xsl:value-of select="value"/></label>
                  </li>
                </xsl:for-each>
              </ul>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-CuCa-Categories"/></th>
          <td>
            <button type="button" onclick="toggleVisibility('calCategories','visible')">
              <xsl:copy-of select="$bwStr-CuCa-ShowHideCategoriesAutoTagging"/>
            </button>
            <div id="calCategories" class="invisible">
              <ul class="catlist">
                <xsl:for-each select="/bedework/categories/all/category">
                  <xsl:sort select="value" order="ascending"/>
                  <li>
                    <input type="checkbox" name="catUid">
                      <xsl:attribute name="value"><xsl:value-of select="uid"/></xsl:attribute>
                      <xsl:attribute name="id">c<xsl:value-of select="generate-id(uid)"/></xsl:attribute>
                      <xsl:if test="uid = ../../current//category/uid"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
                      <xsl:if test="uid = /bedework/currentCalSuite/defaultCategories//category/uid">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                      <label for="c{generate-id(uid)}"><xsl:value-of select="value"/></label>
                    </input>
                  </li>
                </xsl:for-each>
              </ul>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-CuCa-Type"/></th>
          <td>
            <!-- we will set the value of "calendarCollection" on submit.
                 Value is false only for folders, so we default it to true here. -->
            <input type="hidden" value="true" name="calendarCollection"/>

            <!-- type is defaulted to "subscription".  It is changed to "folder"
                 if subTypeSwitch is set to folder. -->
            <input type="hidden" name="type" value="subscription" id="bwType"/>
            <input type="hidden" name="aliasUri" value=""/>

            <!-- subType is defaulted to public.  It is changed when a subTypeSwitch is clicked. -->
            <input type="hidden" value="public" name="subType" id="bwSubType"/>
            <input type="radio" name="subTypeSwitch" id="subTypeFolder" value="folder" onclick="changeClass('subscriptionTypePublic','invisible');changeClass('subscriptionTypeExternal','invisible');setField('bwType',this.value);"/>
            <xsl:text> </xsl:text>
            <label for="subTypeFolder"><xsl:copy-of select="$bwStr-CuCa-FOLDER"/></label>
            <input type="radio" name="subTypeSwitch" id="subTypePublic" value="public" checked="checked" onclick="changeClass('subscriptionTypePublic','visible');changeClass('subscriptionTypeExternal','invisible');setField('bwSubType',this.value);"/>
            <xsl:text> </xsl:text>
            <label for="subTypePublic"><xsl:copy-of select="$bwStr-CuCa-PublicAlias"/></label>
            <input type="radio" name="subTypeSwitch" id="subTypeExternal" value="external" onclick="changeClass('subscriptionTypePublic','invisible');changeClass('subscriptionTypeExternal','visible');setField('bwSubType',this.value);"/>
            <xsl:text> </xsl:text>
            <label for="subTypeExternal"><xsl:copy-of select="$bwStr-CuCa-URL"/></label>

              <div id="subscriptionTypePublic">
                <input type="hidden" value="" name="publicAliasHolder" id="publicAliasHolder"/>
                <div id="bwPublicCalDisplay">
                  <button type="button" onclick="showPublicCalAliasTree();"><xsl:copy-of select="$bwStr-CuCa-SelectPublicCalOrFolder"/></button>
                </div>
                <ul id="publicSubscriptionTree" class="invisible">
                  <xsl:apply-templates select="/bedework/publicCalendars/calendar" mode="selectCalForPublicAliasCalTree"/>
                </ul>
              </div>

              <div class="invisible" id="subscriptionTypeExternal">
                <table class="common">
                  <tr>
                    <th><xsl:copy-of select="$bwStr-CuCa-URLToCalendar"/></th>
                    <td>
                      <input type="text" name="aliasUriHolder" id="aliasUriHolder" value="" size="40"/>
                    </td>
                  </tr>
                  <tr>
                    <th><xsl:copy-of select="$bwStr-CuCa-ID"/></th>
                    <td>
                      <input type="text" name="remoteId" value="" size="40"/>
                    </td>
                  </tr>
                  <tr>
                    <th><xsl:copy-of select="$bwStr-CuCa-Password"/></th>
                    <td>
                      <input type="password" name="remotePw" value="" size="40"/>
                    </td>
                  </tr>
                  <xsl:if test="/bedework/userInfo/superUser='true'">
                    <tr>
                      <th><xsl:copy-of select="$bwStr-CuCa-OrgSync"/></th>
                      <td>
                        <input type="checkbox" name="orgSyncV2"/>
                      </td>
                    </tr>
                  </xsl:if>
                </table>
              </div>

          </td>
        </tr>
      </table>
      <!-- div id="sharingBox">
        <h3>Current Access:</h3>
        <div id="bwCurrentAccessWidget">&#160;</div>
        <script type="text/javascript">
          bwAcl.display("bwCurrentAccessWidget");
        </script>
        <xsl:call-template name="entityAccessForm">
          <xsl:with-param name="outputId">bwCurrentAccessWidget</xsl:with-param>
        </xsl:call-template>
      </div-->

      <div class="submitButtons">
        <input type="submit" name="addCalendar" value="{$bwStr-CuCa-Add}"/>
        <input type="submit" name="cancelled" value="{$bwStr-CuCa-Cancel}"/>
      </div>
    </form>

  </xsl:template>

  <xsl:template match="calendar" mode="selectCalForPublicAliasCalTree">
    <xsl:variable name="id" select="id"/>
    <li>
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="disabled = 'true'">unknown</xsl:when>
          <xsl:when test="lastRefreshStatus &gt; 300">unknown</xsl:when>
          <xsl:when test="name='Trash'"><xsl:copy-of select="$bwStr-Cals-Trash"/></xsl:when>
          <xsl:when test="isSubscription = 'true'"><xsl:copy-of select="$bwStr-Cals-Alias"/></xsl:when>
          <xsl:when test="calType = '0'"><xsl:copy-of select="$bwStr-Cals-Folder"/></xsl:when>
          <xsl:otherwise><xsl:copy-of select="$bwStr-Cals-Calendar"/></xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:variable name="calPath" select="path"/>
      <xsl:variable name="calDisplay" select="path"/>
      <xsl:variable name="calendarCollection" select="calendarCollection"/>
      <xsl:choose>
        <xsl:when test="canAlias = 'true'">
          <a href="javascript:updatePublicCalendarAlias('{$calPath}','{$calDisplay}','bw-{$calPath}','{$calendarCollection}')" id="bw-{$calPath}">
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

  <xsl:template match="currentCalendar" mode="deleteSubConfirm">
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

    <form name="delCalForm" action="{$subscriptions-delete}" method="post">
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

</xsl:stylesheet>