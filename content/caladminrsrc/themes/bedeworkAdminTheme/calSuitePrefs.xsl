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

  <!--+++++++++++++++ Calendar Suite Preferences ++++++++++++++++++++-->
  <xsl:template name="calSuitePrefs">
    <h2><xsl:copy-of select="$bwStr-CSPf-EditCalSuitePrefs"/></h2>
    <form name="userPrefsForm" method="post" action="{$calsuite-updatePrefs}" onsubmit="checkPrefCategories(this);">
      <table class="common2">
        <tr>
          <th>
            <xsl:copy-of select="$bwStr-CSPf-CalSuite"/>
          </th>
          <td>
            <xsl:value-of select="/bedework/currentCalSuite/name"/>
          </td>
        </tr>
        <tr>
          <th>
            <label for="csPreferredView">
              <xsl:copy-of select="$bwStr-CSPf-PreferredView"/>
            </label>
          </th>
          <td><xsl:variable name="preferredView" select="/bedework/prefs/preferredView"/>
            <input type="text" id="csPreferredView" name="preferredView" value="{$preferredView}" size="40"/>
          </td>
        </tr>
        <tr>
          <th>
            <label for="csDefaultViewMode">
              <xsl:copy-of select="$bwStr-CSPf-DefaultViewMode"/>
            </label>
          </th>
          <td>
            <select name="defaultViewMode" id="csDefaultViewMode">
              <!-- What's daily? -->
              <!--
              <option value="daily">
                <xsl:if test="/bedework/prefs/defaultViewMode = 'daily'">
                  <xsl:attribute name="selected">selected</xsl:attribute>
                </xsl:if>
                <xsl:copy-of select="$bwStr-CSPf-DefaultViewModeDaily"/>
              </option>
              -->
              <option value="list">
                <xsl:if test="/bedework/prefs/defaultViewMode = 'list'">
                  <xsl:attribute name="selected">selected</xsl:attribute>
                </xsl:if>
                <xsl:copy-of select="$bwStr-CSPf-DefaultViewModeList"/>
              </option>
              <option value="grid">
                <xsl:if test="/bedework/prefs/defaultViewMode = 'grid'">
                  <xsl:attribute name="selected">selected</xsl:attribute>
                </xsl:if>
                <xsl:copy-of select="$bwStr-CSPf-DefaultViewModeGrid"/>
              </option>
            </select>

          </td>
        </tr>
        <tr>
          <th>
            <label for="csViewPeriod">
              <xsl:copy-of select="$bwStr-CSPf-PreferredViewPeriod"/>
            </label>
          </th>
          <td>
            <xsl:variable name="preferredViewPeriod" select="/bedework/prefs/preferredViewPeriod"/>
            <select name="viewPeriod" id="csViewPeriod">
              <!-- picking the selected item could be done with javascript. for
                   now, this will do.  -->
              <xsl:choose>
                <xsl:when test="$preferredViewPeriod = 'dayView'">
                  <option value="dayView" selected="selected"><xsl:copy-of select="$bwStr-CSPf-Day"/></option>
                </xsl:when>
                <xsl:otherwise>
                  <option value="dayView"><xsl:copy-of select="$bwStr-CSPf-Day"/></option>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:choose>
                <xsl:when test="$preferredViewPeriod = 'todayView'">
                  <option value="todayView" selected="selected"><xsl:copy-of select="$bwStr-CSPf-Today"/></option>
                </xsl:when>
                <xsl:otherwise>
                  <option value="todayView"><xsl:copy-of select="$bwStr-CSPf-Today"/></option>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:choose>
                <xsl:when test="$preferredViewPeriod = 'weekView'">
                  <option value="weekView" selected="selected"><xsl:copy-of select="$bwStr-CSPf-Week"/></option>
                </xsl:when>
                <xsl:otherwise>
                  <option value="weekView"><xsl:copy-of select="$bwStr-CSPf-Week"/></option>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:choose>
                <xsl:when test="$preferredViewPeriod = 'monthView'">
                  <option value="monthView" selected="selected"><xsl:copy-of select="$bwStr-CSPf-Month"/></option>
                </xsl:when>
                <xsl:otherwise>
                  <option value="monthView"><xsl:copy-of select="$bwStr-CSPf-Month"/></option>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:choose>
                <xsl:when test="$preferredViewPeriod = 'yearView'">
                  <option value="yearView" selected="selected"><xsl:copy-of select="$bwStr-CSPf-Year"/></option>
                </xsl:when>
                <xsl:otherwise>
                  <option value="yearView"><xsl:copy-of select="$bwStr-CSPf-Year"/></option>
                </xsl:otherwise>
              </xsl:choose>
            </select>
          </td>
        </tr>
        <tr>
          <th>
            <label for="csDefaultPageSize">
              <xsl:copy-of select="$bwStr-CSPf-DefaultPageSize"/>
            </label>
          </th>
	        <td>
	          <input type="text" name="pageSize" id="csDefaultPageSize" value="" size="40">
	            <xsl:attribute name="value"><xsl:value-of select="/bedework/prefs/pageSize"/></xsl:attribute>
	          </input>
	        </td>
	      </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-CSPf-DefaultCategories"/></th>
          <td>
            <!-- show the selected categories -->
            <ul class="catlist">
              <xsl:for-each select="/bedework/categories/current/category">
                <xsl:sort select="value" order="ascending"/>
                <xsl:variable name="selCatId">selCat<xsl:value-of select="position()"/></xsl:variable>
                <li>
                  <input type="checkbox" name="defaultCategory" id="{$selCatId}" checked="checked">
                    <xsl:attribute name="value"><xsl:value-of select="uid"/></xsl:attribute>
                    <label for="{$selCatId}"><xsl:value-of select="value"/></label>
                  </input>
                </li>
              </xsl:for-each>
            </ul>
            <a href="javascript:toggleVisibility('calCategories','visible')">
              <xsl:copy-of select="$bwStr-CSPf-ShowHideUnusedCategories"/>
            </a>
            <div id="calCategories" class="invisible">
              <ul class="catlist">
                <xsl:for-each select="/bedework/categories/all/category">
                  <xsl:sort select="value" order="ascending"/>
                  <xsl:variable name="catId">selCat<xsl:value-of select="position()"/></xsl:variable>
                  <!-- don't duplicate the selected categories -->
                  <xsl:if test="not(uid = ../../current//category/uid)">
                    <li>
                      <input type="checkbox" name="defaultCategory" id="{$catId}">
                        <xsl:attribute name="value"><xsl:value-of select="uid"/></xsl:attribute>
                        <label for="{$catId}"><xsl:value-of select="value"/></label>
                      </input>
                    </li>
                  </xsl:if>
                </xsl:for-each>
              </ul>
            </div>
          </td>
        </tr>
        <tr>
          <th>
            <label for="csHour24">
              <xsl:copy-of select="$bwStr-CSPf-PreferredTimeType"/>
            </label>
          </th>
          <td>
            <select name="hour24" id="csHour24">
              <option value="false">
                <xsl:if test="/bedework/prefs/hour24 = 'false'">
                  <xsl:attribute name="selected">selected</xsl:attribute>
                </xsl:if>
                <xsl:copy-of select="$bwStr-CSPf-12Hour"/>
              </option>
              <option value="true">
                <xsl:if test="/bedework/prefs/hour24 = 'true'">
                  <xsl:attribute name="selected">selected</xsl:attribute>
                </xsl:if>
                <xsl:copy-of select="$bwStr-CSPf-24Hour"/>
              </option>
            </select>
          </td>
        </tr>
        <tr>
          <th>
            <label for="csPreferredEndType">
              <xsl:copy-of select="$bwStr-CSPf-PreferredEndDateTimeType"/>
            </label>
          </th>
          <td>
            <select name="preferredEndType" id="csPreferredEndType">
              <option value="duration">
                <xsl:if test="/bedework/prefs/preferredEndType = 'duration'">
                  <xsl:attribute name="selected">selected</xsl:attribute>
                </xsl:if>
                <xsl:copy-of select="$bwStr-CSPf-Duration"/>
              </option>
              <option value="date">
                <xsl:if test="/bedework/prefs/preferredEndType = 'date'">
                  <xsl:attribute name="selected">selected</xsl:attribute>
                </xsl:if>
                <xsl:copy-of select="$bwStr-CSPf-DateTime"/>
              </option>
            </select>
          </td>
        </tr>
        <tr>
          <th>
            <label for="defaultTzid">
              <xsl:copy-of select="$bwStr-CSPf-DefaultTimezone"/>
            </label>
          </th>
          <td>
            <xsl:variable name="tzid" select="/bedework/prefs/tzid"/>

            <select name="defaultTzid" id="defaultTzid">
              <option value="-1"><xsl:copy-of select="$bwStr-CSPf-SelectTimezone"/></option>
            </select>

          </td>
        </tr>
        <xsl:if test="/bedework/userInfo/superUser = 'true'">
          <tr>
            <th>
              <label for="csApprovers">
                <xsl:copy-of select="$bwStr-CSPf-Approvers"/>
              </label>
            </th>
            <td>
              <input type="text" name="approvers" id="csApprovers" value="" size="50">
                <xsl:attribute name="value"><xsl:value-of select="/bedework/prefs/calsuiteApprovers"/></xsl:attribute>
              </input>
            </td>
          </tr>
          <tr>
            <th>
              <label for="csDefaultImageDirectory">
                <xsl:copy-of select="$bwStr-CSPf-DefaultImageDirectory"/>
              </label>
            </th>
            <td>
              <input type="text" name="defaultImageDirectory" id="csDefaultImageDirectory" value="" size="40">
                <xsl:attribute name="value"><xsl:value-of select="/bedework/prefs/defaultImageDirectory"/></xsl:attribute>
              </input>
            </td>
          </tr>
          <tr>
            <th>
              <label for="csMaxEntitySize">
                <xsl:copy-of select="$bwStr-CSPf-MaxEntitySize"/>
              </label>
            </th>
            <td>
              <input type="text" name="maxEntitySize" id="csMaxEntitySize" value="" size="40">
                <xsl:attribute name="value"><xsl:value-of select="/bedework/prefs/maxEntitySize"/></xsl:attribute>
              </input>
            </td>
          </tr>
        </xsl:if>
        <!--
        <tr>
          <td class="fieldName">
            Skin name:
          </td>
          <td>
            <xsl:variable name="skinName" select="/bedework/prefs/skinName"/>
            <input type="text" name="skin" value="{$skinName}" size="40"/>
          </td>
        </tr>
        <tr>
          <td class="fieldName">
            Skin style:
          </td>
          <td>
            <xsl:variable name="skinStyle" select="/bedework/prefs/skinStyle"/>
            <input type="text" name="skinStyle" value="{$skinStyle}" size="40"/>
          </td>
        </tr>
        -->
      </table>
      <br />

      <input type="submit" name="modPrefs" value="{$bwStr-CSPf-Update}"/>
      <input type="submit" name="cancelled" value="{$bwStr-CSPf-Cancel}"/>
    </form>
  </xsl:template>

</xsl:stylesheet>