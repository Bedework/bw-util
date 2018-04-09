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
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!--==== HEADER / MASTHEAD ====-->
  <xsl:template name="masthead">
    <div id="masthead">
      <div class="container">
        <!-- the mobile menu button: -->
        <a href="#" id="mobileMenu" class="btn btn-default navbar-toggle">
          <span class="sr-only"><xsl:value-of select="$bwStr-DatePicker-Menu"/></span>
          <span class="icon-bar"><xsl:text> </xsl:text></span>
          <span class="icon-bar"><xsl:text> </xsl:text></span>
          <span class="icon-bar"><xsl:text> </xsl:text></span>
        </a>
        <!-- user customizable masthead set in themeSettings.xsl -->
        <xsl:copy-of select="$masthead"/>
      </div>
    </div>
  </xsl:template>

</xsl:stylesheet>
