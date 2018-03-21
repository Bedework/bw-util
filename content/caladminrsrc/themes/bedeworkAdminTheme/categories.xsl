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

  <!--+++++++++++++++ Categories ++++++++++++++++++++--><!-- templates:
         - categoryList
         - modCategory (add/edit category form)
         - deleteCategoryConfirm
         - categorySelectionWidget (form used for selecting categories in calendar and pref forms)
   -->

  <xsl:template name="categoryList">
    <div class="mgmtHeading">
      <h2><xsl:copy-of select="$bwStr-CtgL-ManageCategories"/></h2>
      <input type="button" name="return" value="{$bwStr-CtgL-AddNewCategory}" onclick="javascript:location.replace('{$category-initAdd}')"/>
      <p>
        <xsl:copy-of select="$bwStr-CtgL-SelectCategory"/>
      </p>
    </div>

    <table id="commonListTable">
      <tr>
        <th><xsl:copy-of select="$bwStr-CtgL-Keyword"/></th>
        <th><xsl:copy-of select="$bwStr-CtgL-Description"/></th>
        <xsl:if test="/bedework/userInfo/superUser = 'true'">
          <th><xsl:copy-of select="$bwStr-CtgL-Status"/></th>
        </xsl:if>
      </tr>

      <xsl:for-each select="/bedework/categories/category">
        <xsl:variable name="catUid" select="uid"/>
        <tr>
          <xsl:if test="position() mod 2 = 0"><xsl:attribute name="class">even</xsl:attribute></xsl:if>
          <td>
            <a href="{$category-fetchForUpdate}&amp;catUid={$catUid}">
              <xsl:value-of select="value"/>
            </a>
          </td>
          <td>
            <xsl:value-of select="description"/>
          </td>
          <xsl:if test="/bedework/userInfo/superUser = 'true'">
            <td>
              <xsl:value-of select="status"/>
            </td>
          </xsl:if>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <xsl:template name="modCategory">
    <xsl:choose>
      <xsl:when test="/bedework/creating='true'">
        <h2><xsl:copy-of select="$bwStr-MoCa-AddCategory"/></h2>
        <form action="{$category-update}" method="post">
          <table id="eventFormTable">
            <tr>
              <td class="fieldName">
                <label for="categoryKeyword"><xsl:copy-of select="$bwStr-MoCa-Keyword"/></label>
              </td>
              <td>
                <input type="text" name="categoryWord.value" id="categoryKeyword" value="" size="40"/>
              </td>
            </tr>
            <tr class="optional">
              <td>
                <label for="categoryDesc"><xsl:copy-of select="$bwStr-MoCa-Description"/></label>
              </td>
              <td>
                <textarea name="categoryDescription" id="categoryDesc" rows="3" cols="60">
                  <xsl:text> </xsl:text>
                </textarea>
              </td>
            </tr>
          </table>
          <div class="submitBox">
            <input type="submit" name="addCategory" value="{$bwStr-MoCa-AddCategory}"/>
            <input type="submit" name="cancelled" value="{$bwStr-MoCa-Cancel}"/>
          </div>
        </form>
      </xsl:when>
      <xsl:otherwise>
        <h2><xsl:copy-of select="$bwStr-MoCa-UpdateCategory"/></h2>
        <form action="{$category-update}" method="post">
          <table id="eventFormTable">
            <tr>
              <td class="fieldName">
                <label for="categoryKeyword"><xsl:copy-of select="$bwStr-MoCa-Keyword"/></label>
              </td>
              <td>
                <input type="text" name="categoryWord.value" id="categoryKeyword" value="" size="40">
                  <xsl:attribute name="value"><xsl:value-of select="normalize-space(/bedework/currentCategory/category/value)"/></xsl:attribute>
                </input>
              </td>
            </tr>
            <tr class="optional">
              <td>
                <label for="categoryDesc"><xsl:copy-of select="$bwStr-MoCa-Description"/></label>
              </td>
              <td>
                <textarea name="categoryDescription" id="categoryDesc" rows="3" cols="60">
                  <xsl:value-of select="normalize-space(/bedework/currentCategory/category/description)"/>
                  <xsl:if test="normalize-space(/bedework/currentCategory/category/description) = ''"><xsl:text> </xsl:text></xsl:if>
                </textarea>
              </td>
            </tr>
            <xsl:if test="/bedework/userInfo/superUser = 'true'">
              <tr>
                <td>
                  <label for="catDeleted"><xsl:copy-of select="$bwStr-MoCa-Deleted"/></label>
                </td>
                <td>
                  <input type="checkbox" name="deleted" id="catDeleted" value="true">
                    <xsl:if test="/bedework/formElements/form/status/input/@value = 'deleted'">
                      <xsl:attribute name="checked">true</xsl:attribute>
                    </xsl:if>
                  </input>
                </td>
              </tr>
            </xsl:if>
          </table>

          <div class="submitBox">
            <div class="right">
              <input type="submit" name="delete" value="{$bwStr-MoCa-DeleteCategory}"/>
            </div>
            <input type="submit" name="updateCategory" value="{$bwStr-MoCa-UpdateCategory}"/>
            <input type="submit" name="cancelled" value="{$bwStr-MoCa-Cancel}"/>
          </div>
        </form>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="deleteCategoryConfirm">
    <h2><xsl:copy-of select="$bwStr-DeCC-CategoryDeleteOK"/></h2>

    <table class="eventFormTable">
      <tr>
        <th>
          <xsl:copy-of select="$bwStr-DeCC-Keyword"/>
        </th>
        <td>
          <xsl:value-of select="/bedework/currentCategory/category/value"/>
        </td>
      </tr>
      <tr>
        <th>
          <xsl:copy-of select="$bwStr-DeCC-Description"/>
        </th>
        <td>
          <xsl:value-of select="/bedework/currentCategory/category/desc"/>
        </td>
      </tr>
    </table>

    <form action="{$category-delete}" method="post">
      <input type="submit" name="updateCategory" value="{$bwStr-DeCC-YesDelete}"/>
      <input type="submit" name="cancelled" value="{$bwStr-DeCC-NoCancel}"/>
    </form>
  </xsl:template>

  <xsl:template name="categoryReferenced">

    <h2><xsl:copy-of select="$bwStr-DeCR-CategoryInUse"/></h2>

    <table class="eventFormTable">
      <tr>
        <th>
          <xsl:copy-of select="$bwStr-DeCC-Keyword"/>
        </th>
        <td>
          <xsl:value-of select="/bedework/currentCategory/category/value"/>
        </td>
      </tr>
      <tr>
        <th>
          <xsl:copy-of select="$bwStr-DeCC-Description"/>
        </th>
        <td>
          <xsl:value-of select="/bedework/currentCategory/category/desc"/>
        </td>
      </tr>
    </table>

    <p>
      <xsl:copy-of select="$bwStr-DeCR-CategoryInUseBy"/>
    </p>

    <xsl:if test="/bedework/userInfo/superUser = 'true'">
      <div class="suTitle"><xsl:copy-of select="$bwStr-DeCR-SuperUserMsg"/></div>
      <div id="superUserMenu">
        <!-- List collections that reference the category -->
        <xsl:if test="/bedework/propRefs/propRef[isCollection = 'true']">
          <h4><xsl:copy-of select="$bwStr-DeCR-Collections"/></h4>
          <ul>
            <xsl:for-each select="/bedework/propRefs/propRef[isCollection = 'true']">
              <li>
                <xsl:variable name="calPath" select="path"/>
                <a href="{$calendar-fetchForUpdate}&amp;calPath={$calPath}">
                  <xsl:value-of select="path"/>
                </a>
              </li>
            </xsl:for-each>
          </ul>
        </xsl:if>
        <!-- List events that reference the category -->
        <xsl:if test="/bedework/propRefs/propRef[isCollection = 'false']">
          <h4><xsl:copy-of select="$bwStr-DeCR-Events"/></h4>
          <p><em><xsl:copy-of select="$bwStr-DeCR-EventsNote"/></em></p>
          <ul>
            <xsl:for-each select="/bedework/propRefs/propRef[isCollection = 'false']">
              <li>
                <xsl:variable name="calPath" select="path"/>
                <xsl:variable name="guid" select="uid"/>
                <!-- only returns the master event -->
                <a href="{$event-fetchForUpdate}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId=">
                  <xsl:value-of select="uid"/>
                </a>
              </li>
            </xsl:for-each>
          </ul>
        </xsl:if>
      </div>
    </xsl:if>

  </xsl:template>

  <!-- form used for selecting categories in calendar and pref forms -->
  <xsl:template name="categorySelectionWidget">
    <!-- show the selected categories -->
    <ul class="catlist">
      <xsl:for-each select="/bedework/categories/current/category">
        <xsl:sort select="value" order="ascending"/>
        <li>
          <input type="checkbox" name="catUid" checked="checked">
            <xsl:attribute name="value"><xsl:value-of select="uid"/></xsl:attribute>
          </input>
          <xsl:value-of select="value"/>
        </li>
      </xsl:for-each>
    </ul>
    <a href="javascript:toggleVisibility('calCategories','visible')">
      <xsl:copy-of select="$bwStr-CaSW-ShowHideUnusedCategories"/>
    </a>
    <div id="calCategories" class="invisible">
      <ul class="catlist">
        <xsl:for-each select="/bedework/categories/all/category">
          <xsl:sort select="value" order="ascending"/>
          <!-- don't duplicate the selected categories -->
          <xsl:if test="not(uid = ../../current//category/uid)">
            <li>
              <input type="checkbox" name="catUid">
                <xsl:attribute name="value"><xsl:value-of select="uid"/></xsl:attribute>
              </input>
              <xsl:value-of select="value"/>
            </li>
          </xsl:if>
        </xsl:for-each>
      </ul>
    </div>
  </xsl:template>

</xsl:stylesheet>