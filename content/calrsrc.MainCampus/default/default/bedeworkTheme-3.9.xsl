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
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml">

  <xsl:output method="xml" indent="no" media-type="text/html"
    doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
    standalone="yes" omit-xml-declaration="yes" />

  <!-- =========================================================

    DEMONSTRATION CALENDAR STYLESHEET

    MainCampus Calendar Suite - Duke/Yale Skin

    This stylesheet is devoid of school branding.  It is a good
    starting point for development of a customized theme.

    It is based on work by Duke University and Yale University with
    credit also to the University of Chicago.

    For detailed instructions on how to work with the XSLT
    stylesheets included with this distribution, please see the
    Bedework Manual at http://www.jasig.org/bedework/documentation

    ===============================================================  -->

  <!-- DEFINE INCLUDES -->
  <xsl:include href="./globals.xsl" />
  <xsl:include href="../strings.xsl" />
  <xsl:include href="../localeSettings.xsl" />

  <!-- DEFAULT THEME NAME -->
  <!-- to change the default theme, change this include -->
  <xsl:include href="../../themes/bedeworkTheme-3.9/bedework.xsl" />

</xsl:stylesheet>
