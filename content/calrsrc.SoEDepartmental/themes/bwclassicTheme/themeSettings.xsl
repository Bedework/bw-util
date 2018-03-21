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

  <!-- URL of html resources (images, css, other html); by default this is
       set to the current theme directory  -->
  <xsl:variable name="resourcesRoot"><xsl:value-of select="/bedework/browserResourceRoot"/>/themes/bwclassicTheme</xsl:variable>
  
  <!-- Location of the urlbuilder application; this is set to the 
       default quickstart location. If you move it, you may need to change this
       value. -->
  <xsl:variable name="urlbuilder">/urlbuilder</xsl:variable>

</xsl:stylesheet>
