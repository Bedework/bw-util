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

  <!--+++++++++++++++ Views ++++++++++++++++++++-->
  <!-- templates:
         - viewList
         - modView
         - deleteViewConfirm
  -->

  <xsl:template match="views" mode="viewList">
    <!-- fix this: /user/ and /public/aliases should be parameterized not hard-coded here -->
    <xsl:variable name="userPath">/user/<xsl:value-of select="/bedework/userInfo/user"/>/</xsl:variable>
    <xsl:variable name="publicAliasPath">/public/aliases/</xsl:variable>

    <h2><xsl:copy-of select="$bwStr-View-ManageViews"/></h2>
    <p>
      <xsl:copy-of select="$bwStr-View-ViewsAreNamedAggr"/>
    </p>

    <h4><xsl:copy-of select="$bwStr-View-AddNewView"/></h4>
    <form name="addView" action="{$view-addView}" method="post">
      <input type="text" name="name" size="60"/>
      <input type="submit" value="add view" name="addview"/>
    </form>

    <h4><xsl:copy-of select="$bwStr-View-Views"/></h4>
    <table id="commonListTable" class="viewsTable">
      <tr>
        <th><xsl:copy-of select="$bwStr-View-Name"/></th>
        <th><xsl:copy-of select="$bwStr-View-IncludedSubscriptions"/></th>
      </tr>

      <xsl:for-each select="view">
        <xsl:sort select="name" order="ascending" case-order="upper-first"/>
        <tr>
          <xsl:if test="position() mod 2 = 0"><xsl:attribute name="class">even</xsl:attribute></xsl:if>
          <td>
            <xsl:variable name="viewName" select="name"/>
            <a href="{$view-fetchForUpdate}&amp;name={$viewName}">
              <xsl:value-of select="name"/>
            </a>
          </td>
          <td>
            <xsl:for-each select="path">
              <xsl:sort order="ascending" case-order="upper-first"/>
              <xsl:choose>
                <xsl:when test="contains(.,$userPath)">
                  <xsl:value-of select="substring-after(.,$userPath)"/>
                </xsl:when>
                <xsl:when test="contains(.,$publicAliasPath)">
                  <xsl:value-of select="substring-after(.,$publicAliasPath)"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="."/>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:if test="position()!=last()"><br/></xsl:if>
            </xsl:for-each>
          </td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <xsl:template name="modView">
    <xsl:variable name="viewName" select="/bedework/currentView/name"/>
    <!-- fix this: /user/ and /public/aliases should be parameterized not hard-coded here -->
    <xsl:variable name="userPath">/user/<xsl:value-of select="/bedework/userInfo/user"/>/</xsl:variable>
    <xsl:variable name="publicAliasPath">/public/aliases/</xsl:variable>

    <h2><xsl:copy-of select="$bwStr-ModV-UpdateView"/></h2>

    <ul class="note">
      <li>
        <xsl:copy-of select="$bwStr-ModV-InSomeConfigs"/>
      </li>
      <li>
        <xsl:copy-of select="$bwStr-ModV-DeletingAView"/>
      </li>
      <li>
        <xsl:copy-of select="$bwStr-ModV-ToSeeUnderlying"/><xsl:text> </xsl:text>
        "<a href="{$subscriptions-fetch}" title="subscriptions to calendars"><xsl:copy-of select="$bwStr-ModV-ManageSubscriptions"/></a>"<xsl:text> </xsl:text><xsl:copy-of select="$bwStr-ModV-Tree"/>
      </li>
      <li>
        <xsl:copy-of select="$bwStr-ModV-IfYouInclude"/>
      </li>
    </ul>

    <h3 class="viewName">
      <xsl:value-of select="$viewName"/>
    </h3>
    <table id="viewsTable">
      <tr>
        <td class="subs">
          <h3><xsl:copy-of select="$bwStr-ModV-AvailableSubscriptions"/></h3>
          <xsl:if test="/bedework/calendars/calendar/calendar[(calType &lt; 2) and (name != 'calendar') and not(starts-with(name,'.cs'))]">
            <ul class="subscriptionsListSubs">
              <!--<xsl:for-each select="/bedework/calendars/calendar//calendar[isSubscription = 'true' or calType = '0']">
                <xsl:sort select="substring-after(path, $userPath)" order="ascending" case-order="upper-first"/>-->
              <xsl:apply-templates select="/bedework/calendars/calendar/calendar[((calType &lt; 2) or (calType = 8)) and (name != 'calendar') and not(starts-with(name,'.cs'))]" mode="availableForViews">
                <xsl:sort select="summary" order="ascending" case-order="upper-first"/>
              </xsl:apply-templates>
            </ul>
          </xsl:if>
        </td>
        <td class="view">
          <h3><xsl:copy-of select="$bwStr-ModV-ActiveSubscriptions"/></h3>
          <xsl:if test="/bedework/currentView/path">
            <ul class="subscriptionsListView">
              <xsl:for-each select="/bedework/currentView/path">
                <xsl:sort select="." order="ascending" case-order="upper-first"/>
                <li>
                  <xsl:variable name="subRemoveName" select="."/>
                  <a href="{$view-update}&amp;name={$viewName}&amp;remove={$subRemoveName}">
                    <span class="arrow">
                        <img src="{$resourcesRoot}/images/arrowLeft.gif"
                             width="13" height="13"
                             alt="add subscription"/>
                    </span>
                    <span class="viewCalSummary">
                      <xsl:choose>
                        <xsl:when test="contains(.,$userPath)">
                          <xsl:value-of select="substring-after(.,$userPath)"/>
                        </xsl:when>
                        <xsl:when test="contains(.,$publicAliasPath)">
                          <xsl:value-of select="substring-after(.,$publicAliasPath)"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="."/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </span>
                  </a>
                </li>
              </xsl:for-each>
            </ul>
          </xsl:if>
        </td>
      </tr>
    </table>

    <div class="submitBox">
      <div class="right">
        <form name="deleteViewForm" action="{$view-fetchForUpdate}" method="post">
          <input type="submit" name="deleteButton" value="{$bwStr-ModV-DeleteView}"/>
          <input type="hidden" name="name" value="{$viewName}"/>
          <input type="hidden" name="delete" value="yes"/>
        </form>
      </div>
      <input type="button" name="return" value="{$bwStr-ModV-ReturnToViewsListing}" onclick="javascript:location.replace('{$view-fetch}')"/>
    </div>
  </xsl:template>

  <xsl:template match="calendar" mode="availableForViews">
    <xsl:choose>
      <xsl:when test="/bedework/currentView//path = path">
        <li class="activeSub">
          <span class="viewCalSummary">
            <xsl:if test="actualCalType = '0' and isSubscription = 'false'">
              <!-- display a folder icon for local folders... -->
              <img src="{$resourcesRoot}/images/catIcon.gif"
                   width="13" height="13"
                   alt="folder"/>
              <xsl:text> </xsl:text>
            </xsl:if>
            <xsl:value-of select="summary"/>
          </span>
        </li>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="viewName" select="/bedework/currentView/name"/>
        <li>
          <xsl:variable name="subAddName" select="encodedPath"/>
          <a href="{$view-update}&amp;name={$viewName}&amp;add={$subAddName}">
            <span class="viewCalSummary">
              <xsl:if test="actualCalType = '0' and isSubscription = 'false'">
                <!-- display a folder icon for local folders... -->
                <img src="{$resourcesRoot}/images/catIcon.gif"
                     width="13" height="13"
                     alt="folder"/>
                <xsl:text> </xsl:text>
              </xsl:if>
              <xsl:value-of select="summary"/>
            </span>
            <span class="arrow">
              <img src="{$resourcesRoot}/images/arrowRight.gif" width="13" height="13" alt="add subscription"/>
            </span>
          </a>
          <xsl:if test="calendar">
            <ul>
              <xsl:apply-templates select="calendar" mode="availableForViews">
                <xsl:sort select="summary" order="ascending" case-order="upper-first"/>
              </xsl:apply-templates>
            </ul>
          </xsl:if>
        </li>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="deleteViewConfirm">
    <h2><xsl:copy-of select="$bwStr-DeVC-RemoveView"/></h2>

    <p>
      <xsl:copy-of select="$bwStr-DeVC-TheView"/><xsl:text> </xsl:text><strong><xsl:value-of select="/bedework/currentView/name"/></strong><xsl:text> </xsl:text>
      <xsl:copy-of select="$bwStr-DeVC-WillBeRemoved"/>
    </p>
    <p class="note">
      <xsl:copy-of select="$bwStr-DeVC-BeForewarned"/>
    </p>

    <p><xsl:copy-of select="$bwStr-DeVC-Continue"/></p>

    <form name="removeView" action="{$view-remove}" method="post">
      <input type="hidden" name="name">
        <xsl:attribute name="value"><xsl:value-of select="/bedework/currentView/name"/></xsl:attribute>
      </input>
      <input type="submit" name="delete" value="{$bwStr-DeVC-YesRemoveView}"/>
      <input type="submit" name="cancelled" value="{$bwStr-DeVC-Cancel}"/>
    </form>

  </xsl:template>

</xsl:stylesheet>