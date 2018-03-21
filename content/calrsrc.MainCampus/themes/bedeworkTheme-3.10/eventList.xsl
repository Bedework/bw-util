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
<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!--==== LIST UPCOMING EVENTS - for listing discrete events ====-->

  <!-- The setSelectionList.do, setOngoingList.do, and listEvents.do actions
       produce a discrete listing of events from a start date
      (defaulted to "today") into the the future. Can use paging.
  -->

  <xsl:template name="eventList">
    <div class="secondaryColHeader">
      <h2>
        <!--<xsl:copy-of select="$bwStr-LsEv-Starting"/><xsl:text> </xsl:text>-->
        <span id="bwStartDate"><xsl:value-of select="/bedework/currentdate/longdate"/></span>
      </h2>

      <a href="#exportSubscribePopup" id="expSubLinksList" class="rss" title="{$bwStr-HdBr-ExportSubscribe}">
        <xsl:copy-of select="$bwStr-HdBr-ExportSubscribe"/><xsl:text> </xsl:text>
        <img src="{$resourcesRoot}/images/feed-icon-14x14.png" alt="{$bwStr-HdBr-ExportSubscribe}" />
      </a>
      <xsl:call-template name="exportSubscribeJavascript">
        <xsl:with-param name="id">expSubLinksList</xsl:with-param>
      </xsl:call-template>

    </div>

    <div id="bwResultSize">
      <xsl:text> </xsl:text>
    </div>

    <xsl:call-template name="queryFilterDisplay"/>

    <div id="listEvents"><xsl:text> </xsl:text></div>


    <script type="text/javascript">
      $(document).ready(function () {

        bwMainEventList.display();

      });
    </script>

    <div id="loadMoreEventsLink">
      <a href="javascript:bwMainEventList.appendEvents();" class="button">Load more events</a>
    </div>

    <div id="noEventsToDisplayText" class="invisible">
      <xsl:text> </xsl:text>
    </div>

    <div id="continueFrom" class="invisible">
      <xsl:text> </xsl:text>
    </div>

    <!-- Subscribe/Export Form Popup -->
    <div id="exportSubscribePopup" class="mfp-hide">
      <xsl:call-template name="exportSubscribe"/>
    </div>

  </xsl:template>

</xsl:stylesheet>
