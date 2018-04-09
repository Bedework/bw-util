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
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- View List -->
  <xsl:template name="viewList">
    <div id="bwViewList">
      <xsl:for-each select="/bedework/views/view">
        <xsl:variable name="viewId">bwNav<xsl:value-of select="position()-1"/></xsl:variable>
        <xsl:variable name="viewState">
          <xsl:choose>
            <xsl:when test="contains(/bedework/appvar[key='closedViews']/value,$viewId)">closed</xsl:when>
            <xsl:otherwise>open</xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <div class="bwMenu">
          <xsl:attribute name="id"><xsl:value-of select="$viewId"/></xsl:attribute>
          <div class="bwMenuTitle">
            <span class="caret">
              <xsl:if test="$viewState = 'closed'"><xsl:attribute name="class">caret caret-right</xsl:attribute></xsl:if>
              <xsl:text> </xsl:text>
            </span>
            <xsl:text> </xsl:text>
            <xsl:value-of select="name"/>
          </div>
          <div class="bwMenuTree">
            <xsl:if test="$viewState = 'closed'"><xsl:attribute name="style">display: none</xsl:attribute></xsl:if>
            <ul>
              <xsl:for-each select="paths/path">
                <xsl:sort select="." order="ascending"/><!-- when a sort field is available, remove this line -->
                <xsl:variable name="currentPath"><xsl:value-of select="."/></xsl:variable>
                <xsl:apply-templates select="/bedework/myCalendars/calendars//calendar[path=$currentPath]" mode="menuTree">
                  <xsl:with-param name="viewId"><xsl:value-of select="$viewId"/></xsl:with-param>
                </xsl:apply-templates>
              </xsl:for-each>
            </ul>
          </div>
        </div>
      </xsl:for-each>
    </div>
  </xsl:template>

  <xsl:template match="calendar" mode="menuTree">
    <xsl:param name="viewId"/>
    <xsl:variable name="isHiddenCalendar"></xsl:variable>
    <xsl:variable name="curPath"><xsl:call-template name="escapeJson"><xsl:with-param name="string"><xsl:value-of select="/bedework/selectionState/collection/virtualpath"/></xsl:with-param></xsl:call-template></xsl:variable>
    <xsl:variable name="virtualPath"><xsl:call-template name="escapeJson"><xsl:with-param name="string">/user<xsl:for-each select="ancestor-or-self::calendar/name">/<xsl:value-of select="."/></xsl:for-each></xsl:with-param></xsl:call-template></xsl:variable>
    <xsl:variable name="encVirtualPath"><xsl:call-template name="url-encode"><xsl:with-param name="str" select="$virtualPath"/></xsl:call-template></xsl:variable>

    <xsl:variable name="name" select="name"/>
    <xsl:variable name="summary" select="summary"/>
    <xsl:variable name="itemId"><xsl:value-of select="$viewId"/>-<xsl:value-of select="translate(path,translate(path,'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789',''),'')"/></xsl:variable>
    <!--<xsl:variable name="itemId">bw<xsl:value-of select="$viewPrefix"/>-<xsl:value-of select="generate-id(path)"/></xsl:variable>-->
    <xsl:variable name="folderState">
      <xsl:choose>
        <xsl:when test="contains(/bedework/appvar[key='opencals']/value,$itemId)">open</xsl:when>
        <xsl:otherwise>closed</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <li>
      <xsl:attribute name="id"><xsl:value-of select="$itemId"/>exp</xsl:attribute>
      <xsl:if test="calendar">
        <xsl:attribute name="class">
          <xsl:choose>
            <xsl:when test="$virtualPath = $curPath">hasChildren selected <xsl:value-of select="$folderState"/></xsl:when>
            <xsl:when test="contains($curPath,$virtualPath)">hasChildren selectedPath open</xsl:when>
            <xsl:otherwise>hasChildren <xsl:value-of select="$folderState"/></xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <span class="menuTreeToggle">
          <xsl:choose>
            <xsl:when test="$folderState = 'closed'">+</xsl:when>
            <xsl:otherwise>-</xsl:otherwise>
          </xsl:choose>
        </span>
      </xsl:if>
      <xsl:if test="not(calendar) and $virtualPath = $curPath">
        <xsl:attribute name="class">selected</xsl:attribute>
      </xsl:if>
      <a>
        <xsl:attribute name="href">
          <xsl:value-of select="path"/>
        </xsl:attribute>
        <xsl:attribute name="id"><xsl:value-of select="$itemId"/></xsl:attribute>
        <xsl:value-of select="summary"/>
      </a>
	    <xsl:if test="calendar[((calType &lt; 2) or (calType = 8)) and (name != 'calendar')]"><!-- the test for "calendar" isn't best -->
        <ul>
	        <xsl:apply-templates select="calendar[((calType &lt; 2) or (calType = 8)) and (name != 'calendar') and not(starts-with(name,'.cs'))]" mode="menuTree"><!-- ".cs" calendars hold calendar suite resources -->
            <xsl:with-param name="viewId"><xsl:value-of select="$viewId"/></xsl:with-param>
	        </xsl:apply-templates>
	      </ul>
	    </xsl:if>
    </li>
  </xsl:template>

</xsl:stylesheet>
