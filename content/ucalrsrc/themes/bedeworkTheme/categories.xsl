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
  
  <!--+++++++++++++++ Categories ++++++++++++++++++++-->
  <xsl:template name="categoryList">
    <h2><xsl:copy-of select="$bwStr-Ctgy-ManagePreferences"/></h2>
    <ul class="submenu">
      <li>
        <a href="{$prefs-fetchForUpdate}"><xsl:copy-of select="$bwStr-Ctgy-General"/></a>
      </li>
      <li class="selected"><xsl:copy-of select="$bwStr-Ctgy-Categories"/></li>
      <li>
        <a href="{$location-initUpdate}"><xsl:copy-of select="$bwStr-Ctgy-Locations"/></a>
      </li>
      <li>
        <a href="{$prefs-fetchSchedulingForUpdate}"><xsl:copy-of select="$bwStr-Ctgy-SchedulingMeetings"/></a>
      </li>
    </ul>
    <table class="common" id="manage" cellspacing="0">
      <tr>
        <th class="commonHeader"><xsl:copy-of select="$bwStr-Ctgy-ManageCategories"/></th>
      </tr>
      <tr>
        <td>
          <input type="button" name="return" value="{$bwStr-Ctgy-Type}" onclick="javascript:location.replace('{$category-initAdd}')" class="titleButton"/>
          <ul>
            <xsl:choose>
              <xsl:when test="/bedework/categories/category">
                <xsl:for-each select="/bedework/categories/category">
                  <xsl:variable name="catUid" select="uid"/>
                  <li>
                    <a href="{$category-fetchForUpdate}&amp;catUid={$catUid}">
                      <xsl:value-of select="value"/>
                    </a>
                  </li>
                </xsl:for-each>
              </xsl:when>
              <xsl:otherwise>
                <li>
                  <xsl:copy-of select="$bwStr-Ctgy-NoCategoriesDefined"/>
                </li>
              </xsl:otherwise>
            </xsl:choose>
          </ul>
        </td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template name="modCategory">
    <h2><xsl:copy-of select="$bwStr-MCat-ManagePreferences"/></h2>
    <ul class="submenu">
      <li>
        <a href="{$prefs-fetchForUpdate}"><xsl:copy-of select="$bwStr-MCat-General"/></a>
      </li>
      <li class="selected"><xsl:copy-of select="$bwStr-MCat-Categories"/></li>
      <li>
        <a href="{$location-initUpdate}"><xsl:copy-of select="$bwStr-MCat-Locations"/></a>
      </li>
      <li>
        <a href="{$prefs-fetchSchedulingForUpdate}"><xsl:copy-of select="$bwStr-MCat-SchedulingMeetings"/></a>
      </li>
    </ul>
    <xsl:choose>
      <xsl:when test="/bedework/creating='true'">
        <form action="{$category-update}" method="post">
          <table class="common" cellspacing="0">
            <tr>
              <th class="commonHeader" colspan="2"><xsl:copy-of select="$bwStr-MCat-AddCategory"/></th>
            </tr>
            <tr>
              <td class="fieldname">
                <xsl:copy-of select="$bwStr-MCat-Keyword"/>
              </td>
              <td>
                <input type="text" name="categoryWord.value" value="" size="40"/>
              </td>
            </tr>
            <tr>
              <td class="fieldname optional">
                <xsl:copy-of select="$bwStr-MCat-Description"/>
              </td>
              <td>
                <textarea name="categoryDescription" rows="3" cols="60">
                  <xsl:text> </xsl:text>
                </textarea>
              </td>
            </tr>
          </table>
          <table border="0" id="submitTable">
            <tr>
              <td>
                <input type="submit" name="addCategory" value="{$bwStr-MCat-AddCategory}"/>
                <input type="submit" name="cancelled" value="{$bwStr-MCat-Cancel}"/>
              </td>
            </tr>
          </table>
        </form>
      </xsl:when>
      <xsl:otherwise>
        <form action="{$category-update}" method="post">
          <table class="common" cellspacing="0">
            <tr>
              <th class="commonHeader" colspan="2"><xsl:copy-of select="$bwStr-MCat-AddCategory"/></th>
            </tr>
            <tr>
              <td class="fieldname">
                <xsl:copy-of select="$bwStr-MCat-Keyword"/>
              </td>
              <td>
                <input type="text" name="categoryWord.value" value="" size="40">
                  <xsl:attribute name="value"><xsl:value-of select="normalize-space(/bedework/currentCategory/category/value)"/></xsl:attribute>
                </input>
              </td>
            </tr>
            <tr>
              <td class="fieldname optional">
                <xsl:copy-of select="$bwStr-MCat-Description"/>
              </td>
              <td>
                <textarea name="categoryDescription" rows="3" cols="60">
                  <xsl:value-of select="normalize-space(/bedework/currentCategory/category/desc)"/>
                  <xsl:if test="normalize-space(/bedework/currentCategory/category/desc/textarea) = ''">
                    <xsl:text> </xsl:text>
                    <!-- keep this space to avoid browser
                    rendering errors when the text area is empty -->
                  </xsl:if>
                </textarea>
              </td>
            </tr>
          </table>

          <table border="0" id="submitTable">
            <tr>
              <td>
                <input type="submit" name="updateCategory" value="{$bwStr-MCat-UpdateCategory}"/>
                <input type="submit" name="cancelled" value="{$bwStr-MCat-Cancel}"/>
              </td>
              <td align="right">
                <input type="submit" name="delete" value="{$bwStr-MCat-DeleteCategory}"/>
              </td>
            </tr>
          </table>
        </form>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="deleteCategoryConfirm">
    <h2><xsl:copy-of select="$bwStr-DlCC-OKtoDeleteCategory"/></h2>

    <table class="common" cellspacing="0">
      <tr>
        <th class="commonHeader" colspan="2"><xsl:copy-of select="$bwStr-DlCC-DeleteCategory"/></th>
      </tr>
      <tr>
        <td class="fieldname">
          <xsl:copy-of select="$bwStr-DlCC-Keyword"/>
        </td>
        <td>
          <xsl:value-of select="/bedework/currentCategory/category/value"/>
        </td>
      </tr>
      <tr>
        <td class="fieldname optional">
          <xsl:copy-of select="$bwStr-DlCC-Description"/>
        </td>
        <td>
          <xsl:value-of select="/bedework/currentCategory/category/desc"/>
        </td>
      </tr>
    </table>

    <form action="{$category-delete}" method="post">
      <input type="submit" name="deleteCategory" value="{$bwStr-DlCC-YesDeleteCategory}"/>
      <input type="submit" name="cancelled" value="{$bwStr-DlCC-NoCancel}"/>
    </form>
  </xsl:template>
  
  
</xsl:stylesheet>