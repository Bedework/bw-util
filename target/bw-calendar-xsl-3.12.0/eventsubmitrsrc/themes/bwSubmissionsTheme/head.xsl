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
  <xsl:template name="headSection">
    <title><xsl:copy-of select="$bwStr-Head-BedeworkSubmitPubEv"/></title>
    <meta name="robots" content="noindex,nofollow"/>
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8"/>
    <link rel="stylesheet" href="{$resourcesRoot}/css/default.css"/>
    <link rel="icon" type="image/ico" href="{$resourcesRoot}/images/bedework.ico" />

    <!-- note: the non-breaking spaces in the script bodies below are to avoid
         losing the script closing tags (which avoids browser problems) -->
    <script type="text/javascript" src="/bedework-common/javascript/jquery/jquery-1.3.2.min.js"><xsl:text> </xsl:text></script>
    <script type="text/javascript" src="/bedework-common/javascript/jquery/jquery-ui-1.7.1.custom.min.js"><xsl:text> </xsl:text></script>
    <link rel="stylesheet" href="/bedework-common/javascript/jquery/css/custom-theme/jquery-ui-1.7.1.custom.css"/>
    <link rel="stylesheet" href="/bedework-common/javascript/jquery/css/custom-theme/bedeworkJquery.css"/>

    <script type="text/javascript" src="{$resourcesRoot}/javascript/bedework.js"><xsl:text> </xsl:text></script>

    <xsl:if test="/bedework/page='addEvent' or /bedework/page='editEvent'">
      <script type="text/javascript" src="/bedework-common/javascript/bedework/bwClock.js">&#160;</script>
      <link rel="stylesheet" href="/bedework-common/javascript/bedework/bwClock.css"/>
      <script type="text/javascript">
        <xsl:comment>
        
         $(document).ready(function(){
          // trim the event description:
          $("#bwEventDesc").val($.trim($("#bwEventDesc").val()));

          // limit the event description to maxPublicDescriptionLength as configured in cal.options.xml
          $("#bwEventDesc").keyup(function(){
             var maxDescLength = parseInt(<xsl:value-of select="/bedework/formElements/form/descLength"/>);
             var desc = $(this).val();
             var remainingChars = maxDescLength - desc.length;
             if (remainingChars &lt; 0) {
               remainingChars = 0;
             }
             $("#remainingChars").html(remainingChars + " <xsl:value-of select="$bwStr-FoEl-CharsRemaining"/>");
             if(desc.length > maxDescLength){
               var truncDesc = desc.substr(0, maxDescLength);
               $(this).val(truncDesc);
             };
          });
        });
        
        $.datepicker.setDefaults({
          constrainInput: true,
          dateFormat: "yy-mm-dd",
          showOn: "both",
          buttonImage: "<xsl:value-of select='$resourcesRoot'/>/images/calIcon.gif",
          buttonImageOnly: true,
          gotoCurrent: true,
          duration: ""
        });
        
        function bwSetupDatePickers() {
          // startdate
          $("#bwEventWidgetStartDate").datepicker({
            defaultDate: new Date(<xsl:value-of select="/bedework/formElements/form/start/yearText/input/@value"/>, <xsl:value-of select="number(/bedework/formElements/form/start/month/select/option[@selected = 'selected']/@value) - 1"/>, <xsl:value-of select="/bedework/formElements/form/start/day/select/option[@selected = 'selected']/@value"/>)
          }).attr("readonly", "readonly");
          $("#bwEventWidgetStartDate").val('<xsl:value-of select="substring-before(/bedework/formElements/form/start/rfc3339DateTime,'T')"/>');

          // starttime
          $("#bwStartClock").bwTimePicker({
            hour24: <xsl:value-of select="/bedework/hour24"/>,
            attachToId: "calWidgetStartTimeHider",
            hourIds: ["eventStartDateHour","eventStartDateSchedHour"],
            minuteIds: ["eventStartDateMinute","eventStartDateSchedMinute"],
            ampmIds: ["eventStartDateAmpm","eventStartDateSchedAmpm"],
            hourLabel: "<xsl:value-of select="$bwStr-Cloc-Hour"/>",
            minuteLabel: "<xsl:value-of select="$bwStr-Cloc-Minute"/>",
            amLabel: "<xsl:value-of select="$bwStr-Cloc-AM"/>",
            pmLabel: "<xsl:value-of select="$bwStr-Cloc-PM"/>"
          });

          // enddate
          $("#bwEventWidgetEndDate").datepicker({
            defaultDate: new Date(<xsl:value-of select="/bedework/formElements/form/end/dateTime/yearText/input/@value"/>, <xsl:value-of select="number(/bedework/formElements/form/end/dateTime/month/select/option[@selected = 'selected']/@value) - 1"/>, <xsl:value-of select="/bedework/formElements/form/end/dateTime/day/select/option[@selected = 'selected']/@value"/>)
          }).attr("readonly", "readonly");
          $("#bwEventWidgetEndDate").val('<xsl:value-of select="substring-before(/bedework/formElements/form/end/rfc3339DateTime,'T')"/>');

          // endtime
          $("#bwEndClock").bwTimePicker({
            hour24: <xsl:value-of select="/bedework/hour24"/>,
            attachToId: "calWidgetEndTimeHider",
            hourIds: ["eventEndDateHour"],
            minuteIds: ["eventEndDateMinute"],
            ampmIds: ["eventEndDateAmpm"],
            hourLabel: "<xsl:value-of select="$bwStr-Cloc-Hour"/>",
            minuteLabel: "<xsl:value-of select="$bwStr-Cloc-Minute"/>",
            amLabel: "<xsl:value-of select="$bwStr-Cloc-AM"/>",
            pmLabel: "<xsl:value-of select="$bwStr-Cloc-PM"/>"
          });
        }
        </xsl:comment>
      </script>
      <script type="text/javascript" src="{$resourcesRoot}/javascript/bedeworkEventForm.js">&#160;</script>
      <script type="text/javascript" src="/bedework-common/javascript/bedework/bedeworkXProperties.js">&#160;</script>
      <script type="text/javascript" src="/bedework-common/javascript/bedework/bedeworkUtil.js">&#160;</script>
      <script type="text/javascript" src="{$resourcesRoot}/javascript/modernizr-2.6.2-input.min.js">&#160;</script>
    </xsl:if>
    <script type="text/javascript">
      <xsl:comment>
      function focusElement(id) {
      // focuses element by id
        document.getElementById(id).focus();
      }
      function initRXDates() {
        // return string values to be loaded into javascript for rdates
        <xsl:for-each select="/bedework/formElements/form/rdates/rdate">
          bwRdates.update('<xsl:value-of select="date"/>','<xsl:value-of select="time"/>',false,false,false,'<xsl:value-of select="tzid"/>');
        </xsl:for-each>
        // return string values to be loaded into javascript for exdates
        <xsl:for-each select="/bedework/formElements/form/exdates/rdate">
          bwExdates.update('<xsl:value-of select="date"/>','<xsl:value-of select="time"/>',false,false,false,'<xsl:value-of select="tzid"/>');
        </xsl:for-each>
      }
      function initXProperties() {
        <xsl:for-each select="/bedework/formElements/form/xproperties/node()[text()]">
          bwXProps.init("<xsl:value-of select="name()"/>",[<xsl:for-each select="parameters/node()">["<xsl:value-of select="name()"/>","<xsl:value-of select="node()"/>"]<xsl:if test="position() != last()">,</xsl:if></xsl:for-each>],"<xsl:call-template name="escapeJson"><xsl:with-param name="string"><xsl:value-of select="values/text"/></xsl:with-param></xsl:call-template>");
        </xsl:for-each>
      }
      </xsl:comment>
    </script>
  </xsl:template>
</xsl:stylesheet>
