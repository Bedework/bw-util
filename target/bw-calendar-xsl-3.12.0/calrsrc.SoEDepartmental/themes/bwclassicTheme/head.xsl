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
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml">

  <xsl:template name="head">
    <head>
      <xsl:choose>
        <xsl:when test="/bedework/page='event'">
          <title><xsl:value-of select="/bedework/event/summary"/></title>
        </xsl:when>
        <xsl:otherwise>
          <title><xsl:copy-of select="$bwStr-Root-PageTitle"/></title>
        </xsl:otherwise>
      </xsl:choose>
      <meta content="text/html;charset=utf-8" http-equiv="Content-Type" />
      <!-- load css -->
      <xsl:choose>
        <xsl:when test="/bedework/appvar[key='style']/value='red'">
          <link rel="stylesheet" href="{$resourcesRoot}/css/red.css"/>
        </xsl:when>
        <xsl:when test="/bedework/appvar[key='style']/value='green'">
          <link rel="stylesheet" href="{$resourcesRoot}/css/green.css"/>
        </xsl:when>
        <xsl:otherwise>
          <link rel="stylesheet" href="{$resourcesRoot}/css/blue.css"/>
        </xsl:otherwise>
      </xsl:choose>
      <link rel="stylesheet" href="/bedework-common/default/default/subColors.css"/>
      <link rel="stylesheet" type="text/css" media="print" href="{$resourcesRoot}/css/print.css" />
      <!-- load javascript -->
      <script type="text/javascript" src="{$resourcesRoot}/javascript/bedework.js">&#160;</script>
      <xsl:if test="/bedework/page='event' or /bedework/page='displayCalendarForExport'">
        <script type="text/javascript" src="/bedework-common/javascript/jquery/jquery-1.3.2.min.js">&#160;</script>
        <script type="text/javascript" src="/bedework-common/javascript/jquery/jquery-ui-1.7.1.custom.min.js">&#160;</script>
        <link rel="stylesheet" href="/bedework-common/javascript/jquery/css/custom-theme/jquery-ui-1.7.1.custom.css"/>
        <link rel="stylesheet" href="/bedework-common/javascript/jquery/css/custom-theme/bedeworkJquery.css"/>
        <xsl:if test="/bedework/page='displayCalendarForExport'">
          <script type="text/javascript">
            <xsl:comment>
            $.datepicker.setDefaults({
              constrainInput: true,
              dateFormat: "yy-mm-dd",
              showOn: "both",
              buttonImage: "<xsl:value-of select='$resourcesRoot'/>/images/calIcon.gif",
              buttonImageOnly: true,
              gotoCurrent: true,
              duration: ""
            });
            $(document).ready(function() {
              $("#bwExportCalendarWidgetStartDate").datepicker({
              }).attr("readonly", "readonly");
              $("#bwExportCalendarWidgetEndDate").datepicker({
              }).attr("readonly", "readonly");
            });
            </xsl:comment>
          </script>
        </xsl:if>
      </xsl:if>
      <!-- address bar icon -->
      <link rel="icon" type="image/ico" href="{$resourcesRoot}/images/bedework.ico" />
    </head>
  </xsl:template>

</xsl:stylesheet>
