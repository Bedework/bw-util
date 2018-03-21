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

  <!--+++++++++++++++ System Stats ++++++++++++++++++++-->
  <xsl:template name="stats">
    <div id="stats">
      <h2><xsl:copy-of select="$bwStr-Stat-SysStats"/></h2>
      <p><xsl:copy-of select="$bwStr-Stat-StatsCollection"/></p>
      <ul>
        <li>
          <a href="{$stats}&amp;enable=yes"><xsl:copy-of select="$bwStr-Stat-Enable"/></a>
          |
          <a href="{$stats}&amp;disable=yes"><xsl:copy-of select="$bwStr-Stat-Disable"/></a>
        </li>
        <li>
          <a href="{$stats}&amp;fetch=yes">
            <xsl:copy-of select="$bwStr-Stat-FetchStats"/>
          </a>
        </li>
        <li>
          <a href="{$stats}&amp;dump=yes">
            <xsl:copy-of select="$bwStr-Stat-DumpStats"/>
          </a>
        </li>
      </ul>
      <table id="statsTable" cellpadding="0">
        <xsl:for-each select="/bedework/sysStats/*">
          <xsl:choose>
            <xsl:when test="name(.) = 'header'">
              <tr>
                <th colspan="2">
                  <xsl:value-of select="." />
                </th>
              </tr>
            </xsl:when>
            <xsl:otherwise>
              <tr>
                <td class="label">
                  <xsl:value-of select="label" />
                </td>
                <td class="value">
                  <xsl:value-of select="value" />
                </td>
              </tr>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </table>
    </div>
  </xsl:template>

</xsl:stylesheet>
