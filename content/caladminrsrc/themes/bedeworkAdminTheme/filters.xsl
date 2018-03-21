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

  <!--+++++++++++++++ Filters ++++++++++++++++++++-->
  <xsl:template name="addFilter">
    <h2><xsl:copy-of select="$bwStr-AdFi-AddNameCalDAVFilter"/><xsl:text> </xsl:text>(<a href="http://bedework.org/trac/bedework/wiki/Bedework/DevDocs/Filters"><xsl:copy-of select="$bwStr-AdFi-Examples"/></a>)</h2>
    <form name="peForm" method="post" action="{$filter-add}">
      <table id="addFilterFormTable" class="eventFormTable">
        <tr>
          <th>
            <xsl:copy-of select="$bwStr-AdFi-Name"/>
          </th>
          <td>
            <input type="text" name="name" value="" size="40"/>
          </td>
        </tr>
        <tr>
          <th>
            <xsl:copy-of select="$bwStr-AdFi-Description"/>
          </th>
          <td>
            <input type="text" name="desc" value="" size="40"/>
          </td>
        </tr>
        <tr>
          <th>
            <xsl:copy-of select="$bwStr-AdFi-FilterDefinition"/>
          </th>
          <td>
            <textarea name="def" rows="30" cols="80">
              <xsl:text> </xsl:text>
            </textarea>
          </td>
        </tr>
        <tr>
          <td>
          </td>
          <td>
            <input type="submit" name="add" value="{$bwStr-AdFi-AddFilter}"/>
            <input type="submit" name="cancelled" value="{$bwStr-AdFi-Cancel}"/>
          </td>
        </tr>
      </table>
    </form>
    <xsl:if test="/bedework/filters/filter">
      <h2><xsl:copy-of select="$bwStr-AdFi-CurrentFilters"/></h2>
      <table id="filterTable">
        <tr>
          <th><xsl:copy-of select="$bwStr-AdFi-FilterName"/></th>
          <th><xsl:copy-of select="$bwStr-AdFi-DescriptionDefinition"/></th>
          <th><xsl:copy-of select="$bwStr-AdFi-Delete"/></th>
        </tr>
        <xsl:for-each select="/bedework/filters/filter">
          <xsl:variable name="filterName" select="name"/>
          <tr>
            <td><xsl:value-of select="$filterName"/></td>
            <td>
              <xsl:if test="description != ''"><xsl:value-of select="description"/><br/></xsl:if>
              <a href="javascript:toggleVisibility('bwfilter-{$filterName}','filterdef')">
                <xsl:copy-of select="$bwStr-AdFi-ShowHideFilterDef"/>
              </a>
              <div id="bwfilter-{$filterName}" class="invisible">
                <xsl:value-of select="definition"/>
              </div>
            </td>
            <td>
              <a href="{$filter-delete}&amp;name={$filterName}" title="{$bwStr-AdFi-DeleteFilter}">
                <img src="{$resourcesRoot}/images/trashIcon.gif" width="13" height="13" alt="{$bwStr-AdFi-DeleteFilter}"/>
              </a>
            </td>
          </tr>
        </xsl:for-each>
      </table>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>