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

  <!--+++++++++++++++ User Prefs ++++++++++++++++++++-->
  <xsl:template name="modPrefs">
    <h2><xsl:copy-of select="$bwStr-MoPr-EditUserPrefs"/></h2>
    <form name="userPrefsForm" method="post" action="{$prefs-update}">
      <table id="eventFormTable">
        <tr>
          <td class="fieldName">
            <xsl:copy-of select="$bwStr-MoPr-User"/>
          </td>
          <td>
            <xsl:value-of select="/bedework/prefs/user"/>
            <xsl:variable name="user" select="/bedework/prefs/user"/>
            <input type="hidden" name="user" value="{$user}"/>
          </td>
        </tr>
        <tr>
          <td class="fieldName">
            <xsl:copy-of select="$bwStr-MoPr-PreferredView"/>
          </td>
          <td>
            <xsl:variable name="preferredView" select="/bedework/prefs/preferredView"/>
            <input type="text" name="preferredView" value="{$preferredView}" size="40"/>
          </td>
        </tr>
        <tr>
          <td class="fieldName">
            <xsl:copy-of select="$bwStr-MoPr-PreferredViewPeriod"/>
          </td>
          <td>
            <xsl:variable name="preferredViewPeriod" select="/bedework/prefs/preferredViewPeriod"/>
            <select name="viewPeriod">
              <!-- picking the selected item could be done with javascript. for
                   now, this will do.  -->
              <xsl:choose>
                <xsl:when test="$preferredViewPeriod = 'dayView'">
                  <option value="dayView" selected="selected"><xsl:copy-of select="$bwStr-MoPr-Day"/></option>
                </xsl:when>
                <xsl:otherwise>
                  <option value="dayView"><xsl:copy-of select="$bwStr-MoPr-Day"/></option>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:choose>
                <xsl:when test="$preferredViewPeriod = 'todayView'">
                  <option value="todayView" selected="selected"><xsl:copy-of select="$bwStr-MoPr-Today"/></option>
                </xsl:when>
                <xsl:otherwise>
                  <option value="todayView"><xsl:copy-of select="$bwStr-MoPr-Today"/></option>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:choose>
                <xsl:when test="$preferredViewPeriod = 'weekView'">
                  <option value="weekView" selected="selected"><xsl:copy-of select="$bwStr-MoPr-Week"/></option>
                </xsl:when>
                <xsl:otherwise>
                  <option value="weekView"><xsl:copy-of select="$bwStr-MoPr-Week"/></option>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:choose>
                <xsl:when test="$preferredViewPeriod = 'monthView'">
                  <option value="monthView" selected="selected"><xsl:copy-of select="$bwStr-MoPr-Month"/></option>
                </xsl:when>
                <xsl:otherwise>
                  <option value="monthView"><xsl:copy-of select="$bwStr-MoPr-Month"/></option>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:choose>
                <xsl:when test="$preferredViewPeriod = 'yearView'">
                  <option value="yearView" selected="selected"><xsl:copy-of select="$bwStr-MoPr-Year"/></option>
                </xsl:when>
                <xsl:otherwise>
                  <option value="yearView"><xsl:copy-of select="$bwStr-MoPr-Year"/></option>
                </xsl:otherwise>
              </xsl:choose>
            </select>
          </td>
        </tr>
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
        <tr>
          <td class="fieldName">
            <label for="upHour24">
              <xsl:copy-of select="$bwStr-CSPf-PreferredTimeType"/>
            </label>
          </td>
          <td>
            <select name="hour24" id="upHour24">
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
          <td class="fieldName">
            <xsl:copy-of select="$bwStr-MoPr-PageSize"/>
          </td>
          <td>
            <xsl:variable name="pageSize" select="/bedework/prefs/pageSize"/>
            <input type="text" name="pageSize" value="{pageSize}" size="40"/>
          </td>
        </tr>
        <tr>
          <td class="fieldName">
            <xsl:copy-of select="$bwStr-MoPr-NoNotifications"/>
          </td>
          <td>
            <input type="checkbox" name="noNotifications" value="true">
              <xsl:if test="/bedework/prefs/noNotifications = 'true'">
                <xsl:attribute name="checked">true</xsl:attribute>
              </xsl:if>
            </input>
          </td>
        </tr>
        <!--
        <tr>
          <td class="fieldName">
            <xsl:copy-of select="$bwStr-MoPr-AdminResourcesDirectory"/>
          </td>
          <td>
            <xsl:variable name="adminResourcesDirectory" select="/bedework/prefs/adminResourcesDirectory"/>
            <input type="text" name="adminResourcesDirectory" value="{adminResourcesDirectory}" size="40"/>
          </td>
        </tr>
        <tr>
          <td class="fieldName">
            <xsl:copy-of select="$bwStr-MoPr-SuiteResourcesDirectory"/>
          </td>
          <td>
            <xsl:variable name="suiteResourcesDirectory" select="/bedework/prefs/suiteResourcesDirectory"/>
            <input type="text" name="suiteResourcesDirectory" value="{suiteResourcesDirectory}" size="40"/>
          </td>
        </tr>
         -->
      </table>
      <br />

      <input type="submit" name="modPrefs" value="{$bwStr-MoPr-Update}"/>
      <input type="submit" name="cancelled" value="{$bwStr-MoPr-Cancel}"/>
    </form>
  </xsl:template>

</xsl:stylesheet>