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
  
  <!--==== EMAIL OPTIONS ====-->
  <xsl:template name="emailOptions">
    <form method="post" action="{$mailEvent}" id="standardForm">
      <input type="hidden" name="updateEmailOptions" value="true"/>
      <table class="common" cellspacing="0">
        <tr>
          <th colspan="2" class="commonHeader"><xsl:copy-of select="$bwStr-EmOp-UpdateEmailOptions"/></th>
        </tr>
        <tr>
          <td>
            <xsl:copy-of select="$bwStr-EmOp-EmailAddress"/>
          </td>
          <td align="left">
            <xsl:copy-of select="/bedework/emailoptionsform/form/email/*"/>
          </td>
        </tr>
        <tr>
          <td>
            <xsl:copy-of select="$bwStr-EmOp-Subject"/>
          </td>
          <td align="left">
            <xsl:copy-of select="/bedework/emailoptionsform/form/subject/*"/>
          </td>
        </tr>
        <tr>
          <td>&#160;</td>
          <td>
            <input name="submit" type="submit" value="{$bwStr-EmOp-Continue}"/>&#160;
            <input name="cancelled" type="submit" value="{$bwStr-EmOp-Cancel}"/>
          </td>
        </tr>
      </table>
    </form>
  </xsl:template>

  
</xsl:stylesheet>