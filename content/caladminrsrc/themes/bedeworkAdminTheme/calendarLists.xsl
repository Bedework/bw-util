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
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!--+++++++++++++++ Calendar Lists ++++++++++++++++++++-->
  <!-- templates:
         - listForUpdate
         - listForDisplay
         - listForMove
   -->

  <xsl:template match="calendar" mode="listForUpdate">
    <xsl:variable name="calPath" select="encodedPath"/>
    <li>
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="disabled = 'true'">unknown</xsl:when>
          <xsl:when test="lastRefreshStatus &gt;= 300">unknown
          </xsl:when>
          <xsl:when test="isSubscription = 'true'">
            <xsl:choose>
              <xsl:when test="calType = '0'">aliasFolder</xsl:when>
              <xsl:otherwise>alias</xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="calType = '0'">folder</xsl:when>
          <xsl:otherwise>calendar</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:if test="calType = '0'">
        <!-- test the open state of the folder; if it's open,
             build a URL to close it and vice versa -->
        <xsl:choose>
          <xsl:when test="open = 'true'">
            <a href="{$calendar-openCloseMod}&amp;calPath={$calPath}&amp;open=false">
              <img src="{$resourcesRoot}/images/minus.gif" width="9"
                   height="9" alt="close"
                   class="bwPlusMinusIcon"/>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <a href="{$calendar-openCloseMod}&amp;calPath={$calPath}&amp;open=true">
              <img src="{$resourcesRoot}/images/plus.gif" width="9"
                   height="9" alt="open"
                   class="bwPlusMinusIcon"/>
            </a>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
      <a href="{$calendar-fetchForUpdate}&amp;calPath={$calPath}"
         title="update">
        <xsl:value-of select="summary"/>
      </a>
      <xsl:if test="calType = '0' and isSubscription = 'false'">
        <xsl:text> </xsl:text>
        <a href="{$calendar-initAdd}&amp;calPath={$calPath}"
           title="{$bwStr-Cals-Add}">
          <img src="{$resourcesRoot}/images/calAddIcon.gif" width="13"
               height="13" alt="{$bwStr-Cals-Add}"/>
        </a>
      </xsl:if>
      <xsl:if test="calendar and isSubscription='false'">
        <ul>
          <xsl:apply-templates select="calendar" mode="listForUpdate">
            <xsl:sort select="summary" order="ascending"
                      case-order="upper-first"/>
          </xsl:apply-templates>
        </ul>
      </xsl:if>
    </li>
  </xsl:template>

  <xsl:template match="calendar" mode="listForDisplay">
    <xsl:variable name="calPath" select="encodedPath"/>
    <li>
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="disabled = 'true'">unknown</xsl:when>
          <xsl:when test="lastRefreshStatus &gt;= 300">unknown
          </xsl:when>
          <xsl:when test="isSubscription = 'true'">alias</xsl:when>
          <xsl:when test="calType = '0'">folder</xsl:when>
          <xsl:otherwise>calendar</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:if test="calType = '0'">
        <!-- test the open state of the folder; if it's open,
             build a URL to close it and vice versa -->
        <xsl:choose>
          <xsl:when test="open = 'true'">
            <a href="{$calendar-openCloseDisplay}&amp;calPath={$calPath}&amp;open=false">
              <img src="{$resourcesRoot}/images/minus.gif" width="9"
                   height="9" alt="close"
                   class="bwPlusMinusIcon"/>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <a href="{$calendar-openCloseDisplay}&amp;calPath={$calPath}&amp;open=true">
              <img src="{$resourcesRoot}/images/plus.gif" width="9"
                   height="9" alt="open"
                   class="bwPlusMinusIcon"/>
            </a>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
      <a href="{$calendar-fetchForDisplay}&amp;calPath={$calPath}"
         title="display">
        <xsl:if test="lastRefreshStatus &gt;= 300">
          <xsl:attribute name="title">
            <xsl:call-template name="httpStatusCodes">
              <xsl:with-param name="code">
                <xsl:value-of select="lastRefreshStatus"/>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:attribute>
        </xsl:if>
        <xsl:value-of select="summary"/>
      </a>
      <xsl:if test="calendar">
        <ul>
          <xsl:apply-templates select="calendar"
                               mode="listForDisplay">
            <!--<xsl:sort select="title" order="ascending" case-order="upper-first"/>--></xsl:apply-templates>
        </ul>
      </xsl:if>
    </li>
  </xsl:template>

  <xsl:template match="calendar" mode="listForMove">
    <xsl:variable name="calPath" select="encodedPath"/>
    <xsl:if test="calType = '0'">
      <li class="folder">
        <!-- test the open state of the folder; if it's open,
             build a URL to close it and vice versa -->
        <xsl:choose>
          <xsl:when test="open = 'true'">
            <a href="{$calendar-openCloseMove}&amp;newCalPath={$calPath}&amp;open=false">
              <img src="{$resourcesRoot}/images/minus.gif" width="9"
                   height="9" alt="close"
                   class="bwPlusMinusIcon"/>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <a href="{$calendar-openCloseMove}&amp;newCalPath={$calPath}&amp;open=true">
              <img src="{$resourcesRoot}/images/plus.gif" width="9"
                   height="9" alt="open"
                   class="bwPlusMinusIcon"/>
            </a>
          </xsl:otherwise>
        </xsl:choose>
        <a href="{$calendar-update}&amp;newCalPath={$calPath}"
           title="update">
          <xsl:value-of select="summary"/>
        </a>
        <xsl:if test="calendar">
          <ul>
            <xsl:apply-templates select="calendar"
                                 mode="listForMove"/>
          </ul>
        </xsl:if>
      </li>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>