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

  <!-- Display the Date and Provide Navigation
       This is the navigation at the top of the event listings -->
  <xsl:template name="eventListRangeNav">
    <div id="eventListRangeNav">
      <div id="bwNavLinks">
		    <a id="prevViewPeriod" href="{$setViewPeriod}&amp;date={$prevdate}&amp;setappvar=navDate({$prevdate})" class="btn btn-default">
		      &#171; <!-- left double arrow -->
		    </a>
		    <a id="nextViewPeriod" href="{$setViewPeriod}&amp;date={$nextdate}&amp;setappvar=navDate({$nextdate})" class="btn btn-default">
		      &#187; <!-- right double arrow -->
		    </a>
	      <h3>
	        <xsl:choose>
	          <xsl:when test="/bedework/periodname='Year'">
	            <xsl:value-of select="substring(/bedework/firstday/date,1,4)" />
	          </xsl:when>
	          <xsl:when test="/bedework/periodname='Month'">
	            <xsl:value-of select="/bedework/firstday/monthname" />,
	            <xsl:value-of select="substring(/bedework/firstday/date,1,4)" />
	          </xsl:when>
	          <xsl:when test="/bedework/periodname='Week'">
	            <xsl:copy-of select="$bwStr-Navi-WeekOf"/>
	            <xsl:text> </xsl:text>
	            <xsl:value-of select="substring-after(/bedework/firstday/longdate,', ')" />
	          </xsl:when>
	          <xsl:otherwise>
	            <xsl:value-of select="/bedework/firstday/longdate" />
	          </xsl:otherwise>
	        </xsl:choose>
	      </h3>
        <xsl:if test="/bedework/periodname!='Month'">
          <ul id="calDisplayOptions">
            <li>
              <xsl:choose>
                <xsl:when test="/bedework/appvar[key='summaryMode']/value='details'">
                  <a href="{$setup}&amp;setappvar=summaryMode(summary)" title="toggle summary/detailed view">
                    <xsl:copy-of select="$bwStr-SrcB-Summary"/>
                  </a>
                </xsl:when>
                <xsl:otherwise>
                  <a href="{$setup}&amp;setappvar=summaryMode(details)" title="toggle summary/detailed view">
                    <xsl:copy-of select="$bwStr-SrcB-Details"/>
                  </a>
                </xsl:otherwise>
              </xsl:choose>
            </li>
            <li>
              <a id="expSubLinksGrid" class="rss" href="#exportSubscribePopup" title="{$bwStr-HdBr-ExportSubscribe}">
                <xsl:copy-of select="$bwStr-HdBr-ExportSubscribe"/><xsl:text> </xsl:text>
                <img src="{$resourcesRoot}/images/feed-icon-14x14.png" alt="{$bwStr-HdBr-ExportSubscribe}" />
              </a>
            </li>
          </ul>
          <xsl:call-template name="exportSubscribeJavascript">
            <xsl:with-param name="id">expSubLinksGrid</xsl:with-param>
          </xsl:call-template>
          <!--
          <script type="text/javascript">
            $(document).ready(function(){
              $('#expSubLinksGrid').magnificPopup({
                type:'inline',
                fixedBgPos: true,
                midClick: true
              });
            });
          </script>
          -->
        </xsl:if>
		  </div>
	  </div>

    <xsl:call-template name="queryFilterDisplay"/>

  </xsl:template>

</xsl:stylesheet>
