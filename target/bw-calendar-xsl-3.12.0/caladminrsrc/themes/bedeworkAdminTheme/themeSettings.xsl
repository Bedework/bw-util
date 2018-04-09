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

  <!-- BEDEWORK ADMIN THEME SETTINGS -->

  <!-- URL of html resources (images, css, other html) for the current theme.
       This value is self-referential and should always match the directory name of the current theme.
       Don't change this value unless you know what you're doing. -->
  <xsl:variable name="resourcesRoot"><xsl:value-of select="/bedework/browserResourceRoot"/>/themes/bedeworkAdminTheme</xsl:variable>

  <!-- Size of results returned from a search.  Upper limit is 250. -->
  <xsl:variable name="searchResultSize">20</xsl:variable>

  <!-- Notification auto-remove: set to true to automatically clear actionable notifications when they are clicked -->
  <xsl:variable name="notificationAutoRemove">true</xsl:variable>

  <!-- If single sign on is enabled (e.g. CAS or similar SSO technology),
       do you wish to allow the event form to automatically authenticate to
       event registration system / web service?
       Leave this value false if you are not using SSO or if you are
       not using the event registration system. -->
  <xsl:variable name="eventRegSsoEnabled">false</xsl:variable>

  <!-- If workflow is enabled (i.e. event approvals) set this to true -->
  <xsl:variable name="workflowEnabled">false</xsl:variable>

</xsl:stylesheet>