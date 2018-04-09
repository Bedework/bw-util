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
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml">
<xsl:output
  method="text"
  indent="yes"
  media-type="application/json"
  standalone="yes"/>

  <!-- ====================================================== -->
  <!--    PERSONAL CALENDAR STYLESHEET for JSON WIDGETS       -->
  <!-- ====================================================== -->
 
  <!-- GENERATE KEYS -->
  <!-- We occasionally need to pick out unique events from the calendar tree view
       which breaks up an event across multiple days.  In the future, we may
       work from a list of unique events and build the tree from it in the UI. -->
       <xsl:key name="eventUid" match="event" use="guid"/>

  <!-- DEFINE INCLUDES -->
  <xsl:include href="./globals.xsl" />
  <xsl:include href="../strings.xsl" />
  <!-- xsl:include href="../localeSettings.xsl" /-->

  <!-- DEFAULT WIDGET STYLESHEET -->
  <!-- to change the default json stylesheets, change this include -->
  <xsl:include href="../../widgets/json.xsl" />

</xsl:stylesheet>
