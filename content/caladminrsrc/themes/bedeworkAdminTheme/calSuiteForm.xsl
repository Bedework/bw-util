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

  <!--+++++++++++++++ Calendar Suite Forms ++++++++++++++++++++--><!-- templates:
         - addCalSuite
         - modCalSuite
   -->

  <xsl:template name="addCalSuite">
    <h2><xsl:copy-of select="$bwStr-AdCS-AddCalSuite"/></h2>
    <form name="calSuiteForm" action="{$calsuite-add}" method="post">
      <input type="hidden" name="calPath" value="/public" size="20"/>
      <table class="eventFormTable">
        <tr>
          <th><xsl:copy-of select="$bwStr-AdCS-Name"/></th>
          <td>
            <input type="text" name="name" size="20"/>
          </td>
          <td>
            <xsl:copy-of select="$bwStr-AdCS-NameCalSuite"/>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-AdCS-Group"/></th>
          <td>
            <input type="text" name="groupName" size="20"/>
          </td>
          <td>
            <xsl:copy-of select="$bwStr-AdCS-NameAdminGroup"/>
          </td>
        </tr>
        <tr>
          <th>Context:</th>
          <td>
            <input type="text" name="context" value="{context}"/>
            <label><input type="checkbox" name="defaultContext" value="true">
              <xsl:if test="defaultContext = 'true'">
                <xsl:attribute name="checked">true</xsl:attribute>
              </xsl:if>
              <xsl:text> </xsl:text>
              <xsl:text>Default context</xsl:text>
            </input></label>
          </td>
        </tr>
      </table>
      <div class="submitBox">
        <input type="submit" name="updateCalSuite" value="{$bwStr-AdCS-Add}"/>
        <input type="submit" name="cancelled" value="{$bwStr-AdCS-Cancel}"/>
      </div>
    </form>
  </xsl:template>

  <xsl:template match="calSuite" name="modCalSuite">
    <h2><xsl:copy-of select="$bwStr-CalS-ModifyCalendarSuite"/></h2>
    <xsl:variable name="calSuiteName" select="name"/>
    <form name="calSuiteForm" action="{$calsuite-update}" method="post">
      <input type="hidden" name="calPath" size="20">
        <xsl:attribute name="value"><xsl:variable name="calPath" select="calPath"/></xsl:attribute>
      </input>
      <table class="eventFormTable">
        <tr>
          <th><xsl:copy-of select="$bwStr-CalS-NameColon"/></th>
          <td>
            <xsl:value-of select="$calSuiteName"/>
          </td>
          <!--
          <td>
            <p class="note">
              <xsl:copy-of select="$bwStr-CalS-NameOfCalendarSuite"/>
            </p>
          </td>
          -->
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-CalS-Group"/></th>
          <td>
            <xsl:value-of select="group"/>
          </td>
          <!--
          <td>
            <p class="note">
              <xsl:copy-of select="$bwStr-CalS-NameOfAdminGroup"/>
            </p>
          </td>
          -->
        </tr>
        <tr>
          <th>Context:</th>
          <td>
            <input type="text" name="context" value="{context}"/>
            <label><input type="checkbox" name="defaultContext" value="true">
              <xsl:if test="defaultContext = 'true'">
                <xsl:attribute name="checked">true</xsl:attribute>
              </xsl:if>
              <xsl:text> </xsl:text>
              <xsl:text>Default context</xsl:text>
            </input></label>
          </td>
        </tr>
      </table>

      <div id="sharingBox">
        <h3><xsl:copy-of select="$bwStr-CalS-CurrentAccess"/></h3>
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
          <input type="submit" name="delete" value="{$bwStr-CalS-DeleteCalendarSuite}"/>
        </div>
        <input type="submit" name="updateCalSuite" value="{$bwStr-CalS-Update}"/>
        <input type="submit" name="cancelled" value="{$bwStr-CalS-Cancel}"/>
      </div>
    </form>

    <!-- div id="sharingBox">
      <xsl:apply-templates select="acl" mode="currentAccess">
        <xsl:with-param name="action" select="$calsuite-setAccess"/>
        <xsl:with-param name="calSuiteName" select="$calSuiteName"/>
      </xsl:apply-templates>
      <form name="calendarShareForm" action="{$calsuite-setAccess}" id="shareForm" onsubmit="setAccessHow(this)" method="post">
        <input type="hidden" name="calSuiteName" value="{$calSuiteName}"/>
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
    </div-->
  </xsl:template>

</xsl:stylesheet>