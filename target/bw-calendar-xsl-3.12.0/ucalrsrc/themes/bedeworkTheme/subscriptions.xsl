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

  <!-- *****************************************************
       ALL TEMPLATES BELOW ARE DEPRECATED AS OF BEDEWORK 3.9
       Subscriptions are maintained in subscriptions.xsl using
       new sharing methods.
       ***************************************************** -->

  <!--+++++++++++++++ Subscriptions ++++++++++++++++++++-->
  <xsl:template name="subsMenu">
    <!-- This top-level menu adds subscriptions to the root of the user's calendar tree.
         Contextual menus on the calendar tree (will) allow for adding subscriptions under
         subfolders.  -->
    <xsl:variable name="userid" select="/bedework/userid"/>
    <h2><xsl:copy-of select="$bwStr-SuMe-AddSubs"/></h2>
    <div id="content">
      <h4><xsl:copy-of select="$bwStr-SuMe-SubscribeTo"/></h4>
      <ul id="subsMenu">
        <li>
          <a href="{$calendar-initAddPublicAlias}&amp;calPath=/user/{$userid}" title="{$bwStr-SuMe-SubscribeToPublicCalendar}">
            <xsl:copy-of select="$bwStr-SuMe-PublicCal"/>
          </a>
        </li>
        <li>
          <a href="{$calendar-initAddAlias}&amp;calPath=/user/{$userid}" title="{$bwStr-SuMe-SubscribeToUserCalendar}">
            <xsl:copy-of select="$bwStr-SuMe-UserCal"/>
          </a>
        </li>
        <li>
          <a href="{$calendar-initAddExternal}&amp;calPath=/user/{$userid}" title="{$bwStr-SuMe-SubscribeToExternalCalendar}">
            <xsl:copy-of select="$bwStr-SuMe-ExternalFeed"/>
          </a>
        </li>
      </ul>
    </div>
  </xsl:template>


  <xsl:template match="calendar" mode="subscribe">
    <xsl:variable name="calPath" select="encodedPath"/>
    <xsl:variable name="itemClass">
      <xsl:choose>
        <xsl:when test="calType = '0'"><xsl:copy-of select="$bwStr-Calr-Folder"/></xsl:when>
        <xsl:otherwise><xsl:copy-of select="$bwStr-Calr-Calendar"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <li class="{$itemClass}">
      <a href="{$subscriptions-initAdd}&amp;calPath={$calPath}">
        <xsl:value-of select="name"/>
      </a>
      <xsl:if test="calendar">
        <ul>
          <xsl:apply-templates select="calendar" mode="subscribe">
            <!--<xsl:sort select="title" order="ascending" case-order="upper-first"/>-->
          </xsl:apply-templates>
        </ul>
      </xsl:if>
    </li>
  </xsl:template>

  <!-- add a subscription to a user calendar by user and path -->
  <xsl:template name="addAlias">
    <h2><xsl:copy-of select="$bwStr-AddA-SubscribeToUserCal"/></h2>
    <div id="content">
      <p class="note"><xsl:copy-of select="$bwStr-AddA-SubscriptionMustBeUnique"/></p>
      <form name="subscribeForm" action="{$calendar-update}" onsubmit="return setBwSubscriptionUri(this, false)" method="post">
        <table class="common" cellspacing="0">
          <tr>
            <td class="fieldname"><xsl:copy-of select="$bwStr-AddA-Name"/></td>
            <td>
              <input type="text" value="" name="calendar.name" size="60"/>
            </td>
          </tr>
          <!-- the following would be for an arbitrary URI.  We'll add this later.
          <tr>
            <td class="fieldname">Uri:</td>
            <td>
              <input type="text" value="" name="aliasUri" size="60"/>
            </td>
          </tr>-->
          <tr>
            <td class="fieldname"><xsl:copy-of select="$bwStr-AddA-UserID"/></td>
            <td>
              <input type="hidden" value="" name="aliasUri"/>
              <input type="text" value="" name="userId" size="20"/>
              <span class="note"><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-AddA-ExJaneDoe"/></span>
            </td>
          </tr>
          <tr>
            <td class="fieldname"><xsl:copy-of select="$bwStr-AddA-CalendarPath"/></td>
            <td>
              <input type="text" value="" name="userPath" size="20"/>
              <span class="note"><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-AddA-ExCalendar"/></span>
            </td>
          </tr>
          <!--<tr>
            <td class="fieldname">Display:</td>
            <td>
              <input type="radio" value="true" name="display" checked="checked"/> yes
              <input type="radio" value="false" name="display"/> no
            </td>
          </tr>-->
          <tr>
            <td class="fieldname"><xsl:copy-of select="$bwStr-AddA-AffectsFreeBusy"/></td>
            <td>
              <input type="radio" value="true" name="affectsFreeBusy"/><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-AddA-Yes"/>
              <input type="radio" value="false" name="affectsFreeBusy" checked="checked"/><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-AddA-No"/>
            </td>
          </tr>
          <tr>
            <td class="fieldname">Color:</td>
            <td>
              <select name="calendar.color">
                <option value="default"><xsl:copy-of select="$bwStr-AddA-Default"/></option>
                <xsl:for-each select="document('subColors.xml')/subscriptionColors/color">
                  <xsl:variable name="subColor" select="."/>
                  <option value="{$subColor}" class="{$subColor}">
                    <xsl:value-of select="@name"/>
                  </option>
                </xsl:for-each>
              </select>
            </td>
          </tr>
          <!--<tr>
            <td class="fieldname">Unremovable:</td>
            <td>
              <input type="radio" value="true" name="unremoveable" size="60"/> true
              <input type="radio" value="false" name="unremoveable" size="60" checked="checked"/> false
            </td>
          </tr>-->
        </table>
        <table border="0" id="submitTable">
          <tr>
            <td>
              <input type="submit" name="addSubscription" value="{$bwStr-AddA-AddSubscription}"/>
              <input type="submit" name="cancelled" value="{$bwStr-AddA-Cancel}"/>
            </td>
          </tr>
        </table>
      </form>

      <xsl:copy-of select="$bwStr-AddA-NoteAboutAccess"/>
    </div>
  </xsl:template>


</xsl:stylesheet>