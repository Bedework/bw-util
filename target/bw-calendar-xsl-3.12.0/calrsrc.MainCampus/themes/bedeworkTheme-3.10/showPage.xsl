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

  <!-- branch to an arbitrary page using the
       "appvar" session variable on a link like so:
       /misc/showPage.rdo?setappvar=page(mypage) -->

  <xsl:template name="showPage">
    <xsl:param name="pageName"/>
    <!-- branch here by adding xsl:when statements -->
    <xsl:choose>
      <xsl:when test="$pageName = 'urlbuilder'">
        <xsl:call-template name="urlbuilder"/>
      </xsl:when>
      <xsl:otherwise>
        <div id="page">
          <xsl:copy-of select="$bwStr-Error-PageNotDefined"/>
        </div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="urlbuilder">
    <!-- call the urlbuilder by its globally defined prefix -->
    <iframe id="feedBuilder" src="{$urlbuilder}" width="790" height="2200">
      <p>
        <xsl:copy-of select="$bwStr-Error-IframeUnsupported"/>
      </p>
    </iframe>
  </xsl:template>

</xsl:stylesheet>
