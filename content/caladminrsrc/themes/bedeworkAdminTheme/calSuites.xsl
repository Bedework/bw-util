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

  <!--+++++++++++++++ Calendar Suites (calsuite) ++++++++++++++++++++-->
  <!-- templates:
         - tabCalsuite
         - calSuiteList
   -->

  <xsl:template name="tabCalsuite">
    <xsl:if test="/bedework/currentCalSuite/currentAccess/current-user-privilege-set/privilege/write or /bedework/userInfo/superUser='true'">
      <h2>
        <xsl:copy-of select="$bwStr-TaCS-ManageCalendarSuite"/>
      </h2>

      <div id="calSuiteTitle">
        <xsl:copy-of select="$bwStr-TaCS-CalendarSuite"/><xsl:text> </xsl:text>
        <strong><xsl:value-of select="/bedework/currentCalSuite/name"/></strong>
        <xsl:text> </xsl:text>
        <xsl:copy-of select="$bwStr-TaCS-Group"/><xsl:text> </xsl:text>
        <strong><xsl:value-of select="/bedework/currentCalSuite/group"/></strong>
        <xsl:text> </xsl:text>
        <a href="{$admingroup-switch}" class="fieldInfo"><xsl:copy-of select="$bwStr-TaCS-Change"/></a>
      </div>
      <ul class="adminMenu">
        <li>
          <a href="{$subscriptions-fetch}" title="subscriptions to calendars">
            <xsl:copy-of select="$bwStr-TaCS-ManageSubscriptions"/>
          </a>
        </li>
        <li>
          <a href="{$view-fetch}" title="collections of subscriptions">
            <xsl:copy-of select="$bwStr-TaCS-ManageViews"/>
          </a>
        </li>
        <li>
          <a href="{$calsuite-resources-fetch}" title="suite-specific resources (images, CSS, XML configuration, etc...)">
            <xsl:copy-of select="$bwStr-TaCS-ManageResources"/>
          </a>
        </li>
        <li>
          <a href="{$calsuite-fetchPrefsForUpdate}" title="calendar suite defaults such as viewperiod and view">
            <xsl:copy-of select="$bwStr-TaCS-ManagePreferences"/>
          </a>
        </li>
      </ul>
    </xsl:if>
  </xsl:template>

  <xsl:template match="calSuites" mode="calSuiteList">
    <h2><xsl:copy-of select="$bwStr-CalS-ManageCalendarSuites"/></h2>

    <p>
      <input type="button" name="addSuite" value="{$bwStr-CalS-AddCalendarSuite}" onclick="javascript:location.replace('{$calsuite-showAddForm}')"/>
      <input type="button" name="switchGroup" value="{$bwStr-CalS-SwitchGroup}" onclick="javascript:location.replace('{$admingroup-switch}')"/>
    </p>

    <table id="commonListTable">
      <tr>
        <th><xsl:copy-of select="$bwStr-CalS-Name"/></th>
        <th><xsl:copy-of select="$bwStr-CalS-AssociatedGroup"/></th>
        <th>Context</th>
      </tr>
      <xsl:for-each select="calSuite">
        <tr>
          <xsl:if test="position() mod 2 = 0"><xsl:attribute name="class">even</xsl:attribute></xsl:if>
          <td>
            <xsl:variable name="name" select="name"/>
            <a href="{$calsuite-fetchForUpdate}&amp;name={$name}">
              <xsl:value-of select="name"/>
            </a>
          </td>
          <td>
            <xsl:value-of select="group"/>
          </td>
          <td>
            <xsl:if test="defaultContext = 'true'">
              <em><xsl:text>* </xsl:text></em>
            </xsl:if>
            <xsl:value-of select="context"/>
          </td>
        </tr>
      </xsl:for-each>
    </table>

    <br/>
    <span><i>Note: a (*) next to the context name indicates the default context (if any).</i></span>

  </xsl:template>

</xsl:stylesheet>