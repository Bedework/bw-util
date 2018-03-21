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

  <!--+++++++++++++++ Calendar Lists ++++++++++++++++++++-->
  <!-- templates:
         - addCalendar
         - modCalendar (edit)
   -->

  <xsl:template match="currentCalendar" mode="addCalendar">
    <h3><xsl:copy-of select="$bwStr-CuCa-AddCalFileOrSub"/></h3>
    <p class="note"><xsl:copy-of select="$bwStr-CuCa-NoteAccessSet"/></p>
    <form name="addCalForm" method="post" action="{$calendar-update}" onsubmit="setCatFilters(this);return setCalendarAlias(this);">
      <table class="common">
        <tr>
          <th><xsl:copy-of select="$bwStr-CuCa-Name"/></th>
          <td>
            <xsl:variable name="curCalName" select="name"/>
            <input name="calendar.name" value="{$curCalName}" size="40" onblur="setCalSummary(this.value, this.form['calendar.summary']);"/>
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
                      <xsl:value-of select="value"/>
                    </input>
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
                      <xsl:if test="uid = ../../current//category/uid"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
                      <xsl:if test="uid = /bedework/currentCalSuite/defaultCategories//category/uid">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                      <xsl:value-of select="value"/>
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
            <!-- we will set the value of "calendarCollection on submit.
                 Value is false only for folders, so we default it to true here.  -->
            <input type="hidden" value="true" name="calendarCollection"/>
            <!-- type is defaulted to calendar.  It is changed when a typeSwitch is clicked. -->
            <input type="hidden" value="calendar" name="type" id="bwCalType"/>
            <input type="radio" value="{$bwStr-CuCa-Calendar}" name="typeSwitch" checked="checked" onclick="changeClass('subscriptionTypes','invisible');setField('bwCalType',this.value);"/> Calendar
            <input type="radio" value="{$bwStr-CuCa-Folder}" name="typeSwitch" onclick="changeClass('subscriptionTypes','invisible');setField('bwCalType',this.value);"/> Folder
            <input type="radio" value="{$bwStr-CuCa-Subscription}" name="typeSwitch" onclick="changeClass('subscriptionTypes','visible');setField('bwCalType',this.value);"/> Subscription
          </td>
        </tr>
      </table>

      <div id="subscriptionTypes" class="invisible">
        <h4><xsl:copy-of select="$bwStr-CuCa-SubscriptionURL"/></h4>
        <input type="hidden" value="publicTree" name="subType" id="bwSubType"/>
        <div id="subscriptionTypeExternal">
          <table class="common" id="subscriptionTypes">
            <tr>
              <th><xsl:copy-of select="$bwStr-CuCa-URLToCalendar"/></th>
              <td>
                <input type="text" name="aliasUri" value="" size="40"/>
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
                  <input type="checkbox" name="orgSyncV2" onclick="toggleVisibility('orgSyncFeatures','')"/>
                </td>
              </tr>
            </xsl:if>

            <tr>
              <th><xsl:copy-of select="$bwStr-CuCa-SubscriptionXlocXcontact"/></th>
              <td>
                <input type="checkbox" name="xlocxcontact"/>
              </td>
            </tr>
            <tr>
              <th><xsl:copy-of select="$bwStr-CuCa-SubscriptionXcategories"/></th>
              <td>
                <input type="checkbox" name="xcategories"/>
              </td>
            </tr>
            <tr>
              <th><xsl:copy-of select="$bwStr-CuCa-SubscriptionRefresh"/></th>
              <td>
                <input type="text" name="refinterval" value="15" size="10"/>
              </td>
            </tr>
          </table>
          <div id="orgSyncFeatures" class="invisible">
            <table class="common" id="orgsyncSubscriptionTypes">
              <tr>
                <th><xsl:copy-of select="$bwStr-CuCa-OrgSyncPublicOnly"/></th>
                <td>
                  <input type="checkbox" name="orgSyncPublicOnly"/>
                </td>
              </tr>
              <tr>
                <th><xsl:copy-of select="$bwStr-CuCa-OrgSyncLocKey"/></th>
                <td>
                  <input type="text" name="locKey" value="" size="20"/>
                </td>
              </tr>
            </table>
          </div>
          <p class="note">
            <xsl:copy-of select="$bwStr-CuCa-NoteAliasCanBeAdded"/><br/>
            bwcal://[path], e.g. bwcal:///public/cals/MainCal
          </p>
        </div>
      </div>

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

  <xsl:template match="currentCalendar" mode="modCalendar">
    <xsl:variable name="calPath" select="path"/>
    <xsl:variable name="calPathEncoded" select="encodedPath"/>

    <form name="modCalForm" method="post" onsubmit="setCatFilters(this)">
      <xsl:attribute name="action">
        <xsl:choose>
          <xsl:when test="/bedework/page = 'modSubscription'">
             <xsl:value-of select="$subscriptions-update"/>
          </xsl:when>
          <xsl:otherwise>
             <xsl:value-of select="$calendar-update"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
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
        <tr>
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
        <xsl:if test="/bedework/page = 'modSubscription'">
          <tr>
            <th><xsl:copy-of select="$bwStr-CuCa-TopicalArea"/></th>
            <td>
              <input type="radio" name="calendar.isTopicalArea" id="topicalAreaTrue" value="true">
                <xsl:if test="isTopicalArea = 'true'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
              </input><xsl:text> </xsl:text>
              <label for="topicalAreaTrue"><xsl:copy-of select="$bwStr-CuCa-True"/></label>
              <input type="radio" name="calendar.isTopicalArea" id="topicalAreaFalse" value="false">
                <xsl:if test="isTopicalArea = 'false'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
              </input><xsl:text> </xsl:text>
              <label for="topicalAreaFalse"><xsl:copy-of select="$bwStr-CuCa-False"/></label>
            </td>
          </tr>
        </xsl:if>
        <tr>
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
        <!-- For now, colors need to be set in the calendar suite stylesheet. -->
        <!-- tr>
          <th>Color:</th>
          <td>
            <input type="text" name="calendar.color" value="" size="40">
              <xsl:attribute name="value"><xsl:value-of select="color"/></xsl:attribute>
            </input>
          </td>
        </tr-->
        <tr>
          <th><xsl:copy-of select="$bwStr-CuCa-Display"/></th>
          <td>
            <input type="checkbox" name="calendar.display" id="calDisplay" size="40">
              <xsl:if test="display = 'true'">
                <xsl:attribute name="checked">checked</xsl:attribute>
              </xsl:if>
            </input><xsl:text> </xsl:text>
            <label for="calDisplay"><xsl:copy-of select="$bwStr-CuCa-DisplayItemsInCollection"/></label>
          </td>
        </tr>
        <tr>
          <xsl:if test="disabled = 'true'">
            <xsl:attribute name="class">disabled</xsl:attribute>
          </xsl:if>
          <th><xsl:copy-of select="$bwStr-CuCa-Disabled"/></th>
          <td>
            <input type="radio" name="calendar.disabled" id="calDisabledFalse" value="false">
              <xsl:if test="disabled = 'false'">
                <xsl:attribute name="checked">checked</xsl:attribute>
              </xsl:if>
            </input>
            <label for="calDisabledFalse"><xsl:copy-of select="$bwStr-CuCa-EnabledLabel"/></label>
            <input type="radio" name="calendar.disabled" id="calDisabledTrue" value="true">
              <xsl:if test="disabled = 'true'">
                <xsl:attribute name="checked">checked</xsl:attribute>
              </xsl:if>
            </input>
            <label for="calDisabledTrue"><xsl:copy-of select="$bwStr-CuCa-DisabledLabel"/></label>
            <xsl:if test="disabled = 'true'">
              <span class="disabledNote">
                <xsl:copy-of select="$bwStr-CuCa-ItemIsInaccessible"/>
              </span>
            </xsl:if>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-CuCa-Filter"/></th>
          <td>
            <input type="hidden" name="fexpr" value=""/>
            <xsl:variable name="filterUids" select="substring-before(substring-after(filterExpr,'catuid=('),')')"/>

            <!-- show the selected category filters -->
            <xsl:if test="$filterUids != ''">
              <ul class="catlist">
                <xsl:for-each select="/bedework/categories/all/category">
                  <xsl:sort select="value" order="ascending"/>
                  <xsl:if test="contains($filterUids,uid)">
                    <xsl:variable name="catUid" select="uid"/>
                    <li>
                      <input type="checkbox" name="filterCatUid" checked="checked">
                        <xsl:attribute name="value"><xsl:value-of select="$catUid"/></xsl:attribute>
                        <xsl:attribute name="id">f<xsl:value-of select="$catUid"/></xsl:attribute>
                        <label for="f{$catUid}"><xsl:value-of select="value"/></label>
                      </input>
                    </li>
                  </xsl:if>
                </xsl:for-each>
              </ul>
            </xsl:if>

            <!-- <xsl:value-of select="filterExpr"/><xsl:if test="filterExpr !=''"><br/></xsl:if>
            <xsl:value-of select="$filterUids"/>-->

            <button type="button" onclick="toggleVisibility('filterCategories','visible')">
              <xsl:copy-of select="$bwStr-CuCa-ShowHideCategoriesFiltering"/>
            </button>

            <div id="filterCategories" class="invisible">
              <ul class="catlist">
                <xsl:for-each select="/bedework/categories/all/category">
                  <xsl:sort select="value" order="ascending"/>
                  <!-- don't duplicate the selected filters -->
                  <xsl:if test="not(contains($filterUids,uid))">
                    <xsl:variable name="catUid" select="uid"/>
                    <li>
                      <input type="checkbox" name="filterCatUid">
                        <xsl:attribute name="value"><xsl:value-of select="$catUid"/></xsl:attribute>
                        <xsl:attribute name="id">f<xsl:value-of select="$catUid"/></xsl:attribute>
                        <label for="f{$catUid}"><xsl:value-of select="value"/></label>
                      </input>
                    </li>
                  </xsl:if>
                </xsl:for-each>
              </ul>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-CuCa-Categories"/></th>
          <td>
            <!-- show the selected categories -->
            <ul class="catlist">
              <xsl:for-each select="/bedework/categories/current/category">
                <xsl:sort select="value" order="ascending"/>
                <xsl:variable name="catUid" select="uid"/>
                <li>
                  <input type="checkbox" name="catUid" checked="checked">
                    <xsl:attribute name="value"><xsl:value-of select="$catUid"/></xsl:attribute>
                    <xsl:attribute name="id"><xsl:value-of select="$catUid"/></xsl:attribute>
                    <xsl:if test="uid = /bedework/currentCalSuite/defaultCategories//category/uid">
                      <xsl:attribute name="disabled">disabled</xsl:attribute>
                    </xsl:if>
                    <label for="{$catUid}"><xsl:value-of select="value"/></label>
                  </input>
                </li>
              </xsl:for-each>
            </ul>
            <button type="button" onclick="toggleVisibility('calCategories','visible')">
              <xsl:copy-of select="$bwStr-CuCa-ShowHideCategoriesAutoTagging"/>
            </button>
            <div id="calCategories" class="invisible">
              <ul class="catlist">
                <xsl:for-each select="/bedework/categories/all/category">
                  <xsl:sort select="value" order="ascending"/>
                  <!-- don't duplicate the selected categories -->
                  <xsl:if test="not(uid = ../../current//category/uid)">
                    <xsl:variable name="catUid" select="uid"/>
                    <li>
                      <input type="checkbox" name="catUid">
		                    <xsl:attribute name="value"><xsl:value-of select="$catUid"/></xsl:attribute>
		                    <xsl:attribute name="id"><xsl:value-of select="$catUid"/></xsl:attribute>
                      </input>
                      <label for="{$catUid}"><xsl:value-of select="value"/></label>
                    </li>
                  </xsl:if>
                </xsl:for-each>
              </ul>
            </div>
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

      <div id="sharingBox">
        <h3><xsl:copy-of select="$bwStr-CuCa-CurrentAccess"/></h3>
        <div id="bwCurrentAccessWidget">&#160;</div>
        <script type="text/javascript">
          bwAcl.display("bwCurrentAccessWidget");
        </script>
        <xsl:call-template name="entityAccessForm">
          <xsl:with-param name="outputId">bwCurrentAccessWidget</xsl:with-param>
        </xsl:call-template>
      </div>

      <div class="submitBox">
        <div class="right">
          <xsl:choose>
            <xsl:when test="isSubscription='true'">
              <input type="submit" name="delete" value="{$bwStr-CuCa-RemoveSubscription}"/>
            </xsl:when>
            <xsl:when test="calType = '0'">
              <input type="submit" name="delete" value="{$bwStr-CuCa-DeleteFolder}"/>
            </xsl:when>
            <xsl:otherwise>
              <input type="submit" name="delete" value="{$bwStr-CuCa-DeleteCalendar}"/>
            </xsl:otherwise>
          </xsl:choose>
        </div>
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
      </div>
    </form>
  </xsl:template>

</xsl:stylesheet>