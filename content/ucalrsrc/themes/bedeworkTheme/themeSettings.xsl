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

  <!--==== THEME SETTINGS ====-->

  <script type="text/javascript">
    <xsl:comment>
    var featureFlags = <xsl:value-of select="/bedework/featureFlags"/>;
    </xsl:comment>
  </script>

  <xsl:variable name="featureFlags"><xsl:value-of select="/bedework/featureFlags" /></xsl:variable>

  <!-- URL of html resources (images, css, other html); for the personal calendar
       this should be changed to point to a web server over https to avoid mixed content errors, e.g.,
  <xsl:variable name="resourcesRoot">https://mywebserver.edu/myresourcesdir</xsl:variable>
    -->
  <!-- URL of html resources (images, css, other html) for the current theme -->
  <xsl:variable name="resourcesRoot"><xsl:value-of select="/bedework/browserResourceRoot" />/themes/bedeworkTheme</xsl:variable>

  <!-- Use address book? -->
  <xsl:variable name="useAddressBook">true</xsl:variable>

  <!-- Set true to make this a "subscription-only" client -->
  <xsl:variable name="publicOnly">false</xsl:variable>

  <!-- Set true to use vpoll features in the client -->
  <xsl:variable name="useVpoll">
    <xsl:choose>
      <xsl:when test="contains($featureFlags, '-VPOLLUI-')">true</xsl:when>
      <xsl:otherwise>false</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="useVpollAutofill">
    <xsl:choose>
      <xsl:when test="contains($featureFlags, '-VPOLLUI+AUTOFILL-')">true</xsl:when>
      <xsl:otherwise>false</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
</xsl:stylesheet>