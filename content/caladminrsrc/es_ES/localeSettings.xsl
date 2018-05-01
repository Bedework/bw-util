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

  <!-- LOCALE SETTINGS -->
  <!-- A place for javascript strings and locale specific javascript overrides -->
  
  <xsl:template name="localeAccessStringsJsInclude">
    <script type="text/javascript" src="{$bedeworkCommon}/javascript/bedework/lang/bwAccessStrings-es.js">&#160;</script>
  </xsl:template>

  <!-- Set up the datepicker defaults -->
  <!-- For futher configuration, see http://docs.jquery.com/UI/Datepicker -->
  <xsl:template name="jqueryDatepickerDefaults">
    
    <!-- pull in the localization strings and defaults. -->

    <script type="text/javascript" src="{$bedeworkCommon}/javascript/jquery/lang-datepicker/jquery.ui.datepicker-es.js">&#160;</script>
    
    <!-- Bedework datepicker defaults.  You can include further overrides to regionalization here. -->
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
      </xsl:comment>
    </script>
    
  </xsl:template>
    
  <!-- Declare the JavaScript event strings. -->
  <!-- These are for display and can be translated. -->
  <xsl:template name="bedeworkEventJsStrings">
    <script type="text/javascript">
      // recurrence strings
      var bwRecurChangeWarning = "WARNING: changing your recurrence rules\nwill destroy all existing recurrence overrides\nand exceptions when you save the event.\n\nContinue?";
      // registration strings
      var maxTicketsWarning = "Event Registration Settings:\nYou must set the maximum number of tickets allowed for this event.";
      var maxTicketsPerUserWarning = "Event Registration Settings:\nYou must set the maximum number of tickets each user may aquire.";
      var maxWaitListWarning = "Event Registration Settings:\n Max wait list value must be an integer or a percentage, or left blank (for no limit).";
    </script>
  </xsl:template>
  
  <!-- Declare the access control strings. -->
  <xsl:template name="bedeworkAccessStrings">
    <!-- The default JavaScript strings are found in resources/javascript/bedework/bedeworkAccess.js which 
       gets deployed to the {$bedeworkCommon}/ libraries during the build.  Overrides are found in
       resources/javascript/bedework/lang/ and are included here. -->
    <script type="text/javascript" src="{$bedeworkCommon}/javascript/bedework/lang/bwAccessStrings-es_ES.js">&#160;</script>
    
    <!-- The XSL access strings are found in resources/xsl/lang and are referenced in default/globals.xsl -->
  </xsl:template>
  
</xsl:stylesheet>