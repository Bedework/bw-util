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

  <xsl:template name="ongoingEventList">
    <div id="bwOngoing"><xsl:text> </xsl:text></div>

    <script type="text/javascript">
      var bwOngoingOptions = {
        title: "<xsl:copy-of select="$bwStr-Ongoing-Title"/>",
        showTitle: true,
        showCaret: true,
        displayDescription: false,
        displayEventDetailsInline: false,
        suppressStartDateInList: true,
        untilText: "<xsl:copy-of select="$bwStr-Ongoing-Ends"/>",
        displayTimeInList: false,
        displayLocationInList: false,
        limitList: false,
        limit: 5,
        listMode: "byTitle",
        displayContactInDetails: true,
        displayCostInDetails: true,
        displayTagsInDetails: true,
        displayTimezoneInDetails: true,
        displayNoEventText: true,
        showTitleWhenNoEvents: true,
        noEventsText: "<xsl:copy-of select="$bwStr-Ongoing-NoEvents"/>"
      };

      var ongoingFilter = '(vpath="<xsl:value-of select="$ongoingEventsAlias"/>")';

      <!-- Create the ongoing event list object -->
      var bwOngoingEventList = new BwEventList("bwOngoing","json",bwOngoingOptions,"<xsl:value-of select="/bedework/currentdate/date"/>",ongoingFilter,"","","<xsl:value-of select="$setOngoingList"/>");

      $(document).ready(function () {
        bwOngoingEventList.display();
      });

    </script>
  </xsl:template>

</xsl:stylesheet>
