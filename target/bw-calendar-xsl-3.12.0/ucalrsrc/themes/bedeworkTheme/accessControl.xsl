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
  
  <!--==== ACCESS CONTROL TEMPLATES ====-->

  <xsl:template name="schedulingAccessForm">
    <xsl:param name="what"/>
    <input type="hidden" name="what">
      <xsl:attribute name="value"><xsl:value-of select="$what"/></xsl:attribute>
    </input>
    <p>
      <input type="text" name="who" size="40"/>
      <span class="nowrap"><input type="radio" name="whoType" value="user" checked="checked"/><xsl:copy-of select="$bwStr-ScAF-User"/></span>
      <span class="nowrap"><input type="radio" name="whoType" value="group"/><xsl:copy-of select="$bwStr-ScAF-Group"/></span>
    </p>
    <p>
      <strong>or</strong>
      <span class="nowrap"><input type="radio" name="whoType" value="owner"/><xsl:copy-of select="$bwStr-ScAF-Owner"/></span>
      <span class="nowrap"><input type="radio" name="whoType" value="auth"/><xsl:copy-of select="$bwStr-ScAF-Authenticated"/></span>
      <span class="nowrap"><input type="radio" name="whoType" value="unauth"/><xsl:copy-of select="$bwStr-ScAF-UnAuthenticated"/></span>
      <span class="nowrap"><input type="radio" name="whoType" value="all"/><xsl:copy-of select="$bwStr-ScAF-All"/></span>
    </p>

    <input type="hidden" name="how" value="S"/>
    <dl>
      <dt>
        <input type="checkbox" name="howSetter" value="S" checked="checked" onchange="toggleScheduleHow(this.form,this)"/><xsl:copy-of select="$bwStr-ScAF-AllScheduling"/>
      </dt>
      <dd>
        <input type="checkbox" name="howSetter" value="t" checked="checked" disabled="disabled"/><xsl:copy-of select="$bwStr-ScAF-SchedulingReqs"/><br/>
        <input type="checkbox" name="howSetter" value="y" checked="checked" disabled="disabled"/><xsl:copy-of select="$bwStr-ScAF-SchedulingReplies"/><br/>
        <input type="checkbox" name="howSetter" value="s" checked="checked" disabled="disabled"/><xsl:copy-of select="$bwStr-ScAF-FreeBusyReqs"/>
      </dd>
    </dl>

    <input type="submit" name="modPrefs" value="{$bwStr-ScAF-Update}"/>
  </xsl:template>
  
  
</xsl:stylesheet>