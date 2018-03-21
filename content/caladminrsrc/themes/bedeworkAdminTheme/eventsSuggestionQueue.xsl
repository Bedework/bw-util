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

  <!--+++++++++++++++ Suggestion Queue Tab ++++++++++++++++++++-->
  <xsl:template name="tabSuggestionQueueEvents">
    <h2><xsl:copy-of select="$bwStr-TaAQ-SuggestionQueueEvents"/></h2>

    <p><xsl:copy-of select="$bwStr-TaAQ-SuggestedEvents"/></p>

    <xsl:variable name="today"><xsl:value-of select="substring(/bedework/now/date,1,4)"/>-<xsl:value-of select="substring(/bedework/now/date,5,2)"/>-<xsl:value-of select="substring(/bedework/now/date,7,2)"/></xsl:variable>

    <div id="bwEventListControls">
      <xsl:call-template name="eventListControls">
        <xsl:with-param name="nextAction"><xsl:value-of select="$nextSuggestionQueueTab"/>&amp;sg=true</xsl:with-param>
      </xsl:call-template>

      <form name="bwManageEventListControls"
            id="bwManageEventListControls"
            method="post"
            action="{$initSuggestionQueueTab}">

        <input type="hidden" name="sort" value="dtstart.utc:asc"/>
        <input type="hidden" name="listMode" value="true"/>
        <input type="hidden" name="sg" value="true"/>
        <input type="hidden" name="colPath"  value="/public/cals/MainCal"/>
        <input type="hidden" name="suggestedTo">
          <xsl:attribute name="value"><xsl:value-of select="/bedework/currentCalSuite/groupHref"/></xsl:attribute>
        </input>
        <input type="hidden" name="catFilter" value=""/>
        <input type="hidden" name="master" value="true"/>
        <!-- the following two fields are set by javascript -->
        <input type="hidden" name="fexpr" value=""/>
        <input type="hidden" name="setappvar" id="appvar" value="suggestType(P)"/>

        <div class="container-nowrap">
          <label for="bwListWidgetStartDate"><xsl:copy-of select="$bwStr-EvLs-StartDate"/></label>
          <input id="bwListWidgetStartDate" type="text" class="noFocus" name="start" size="10"
                 onchange="setSuggestListDate(this.form,this.value);"/>
          <input id="bwListWidgetToday" type="submit" value="{$bwStr-EvLs-Today}"
                 onclick="setSuggestListDateToday('{$today}',this.form);"/>
        </div>

        <div id="refreshBwList">
          <div id="refreshBwListControls">
            <xsl:copy-of select="$bwStr-TaAQ-View"/>
            <input type="radio" name="suggestedListType" id="bwSuggestTabP" onclick="setSuggestListType(this.form,this.value);" value="P">
              <xsl:if test="not(/bedework/appvar[key='suggestType']) or /bedework/appvar[key='suggestType']/value = 'P'">
                <xsl:attribute name="checked">checked</xsl:attribute>
              </xsl:if>
            </input>
            <label for="bwSuggestTabP"><xsl:copy-of select="$bwStr-TaAQ-Suggested"/></label>
            <input type="radio" name="suggestedListType" id="bwSuggestTabA" onclick="setSuggestListType(this.form,this.value);" value="A">
              <xsl:if test="/bedework/appvar[key='suggestType']/value = 'A'">
                <xsl:attribute name="checked">checked</xsl:attribute>
              </xsl:if>
            </input>
            <label for="bwSuggestTabA"><xsl:copy-of select="$bwStr-TaAQ-Accepted"/></label>
            <input type="radio" name="suggestedListType" id="bwSuggestTabR" onclick="setSuggestListType(this.form,this.value);" value="R">
              <xsl:if test="/bedework/appvar[key='suggestType']/value = 'R'">
                <xsl:attribute name="checked">checked</xsl:attribute>
              </xsl:if>
            </input>
            <label for="bwSuggestTabR"><xsl:copy-of select="$bwStr-TaAQ-Rejected"/></label>
          </div>
        </div>

      </form>
    </div>

    <xsl:call-template name="eventListCommon">
      <xsl:with-param name="suggestionQueue">true</xsl:with-param>
    </xsl:call-template>

    <xsl:call-template name="eventListControls">
      <xsl:with-param name="nextAction"><xsl:value-of select="$nextSuggestionQueueTab"/>&amp;sg=true</xsl:with-param>
      <xsl:with-param name="bottom">true</xsl:with-param>
    </xsl:call-template>

  </xsl:template>

</xsl:stylesheet>