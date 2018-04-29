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

  <xsl:template name="entityAccessForm">
    <xsl:param name="type"/><!-- optional: currently used for inbox and outbox to conditionally display scheduling access -->
    <xsl:param name="acl"/><!-- required: nodeset of entity acls used to initialize javascript object. -->
    <xsl:param name="outputId"/><!-- required: id of the current access block display to update -->

    <table cellpadding="0" id="accessFormTable" class="common">
      <tr>
        <th colspan="2" class="commonHeader"><xsl:value-of select="$bwStr-Access-Add"/></th>
      </tr>
      <tr>
        <td>
          <h5><xsl:value-of select="$bwStr-Access-Who"/></h5>
          <div class="whoTypes">
            <input type="text" name="who" size="20"/><br/>
            <input type="radio" value="user" name="whoType" id="whoTypeUser" checked="checked"/>
            <label for="whoTypeUser"><xsl:value-of select="$bwStr-Access-User"/></label>
            <input type="radio" value="group" name="whoType" id="whoTypeGroup"/>
            <label for="whoTypeGroup"><xsl:value-of select="$bwStr-Access-Group"/></label>

            <p><xsl:value-of select="$bwStr-Access-Or"/></p>

            <p>
              <input type="radio" value="owner" name="whoType" id="whoTypeOwner"/>
              <label for="whoTypeOwner"><xsl:value-of select="$bwStr-Access-Owner"/></label><br/>
              <input type="radio" value="auth" name="whoType" id="whoTypeAuth"/>
              <label for="whoTypeAuth"><xsl:value-of select="$bwStr-Access-Authenticated"/></label><br/>
              <input type="radio" value="unauth" name="whoType" id="whoTypeUnauth"/>
              <label for="whoTypeUnauth"><xsl:value-of select="$bwStr-Access-Unauthenticated"/></label><br/>
              <input type="radio" value="all" name="whoType" id="whoTypeAll"/>
              <label for="whoTypeAll"><xsl:value-of select="$bwStr-Access-AllUsers"/></label>
            </p>
            <input type="button" name="updateACLs" value="{$bwStr-Access-AddEntry}" onclick="bwAcl.update(this.form,'{$outputId}')"/>
          </div>
        </td>
        <td>
          <h5>
            <span id="accessRightsToggle">
              <xsl:choose>
                <xsl:when test="/bedework/appvar[key='accessRightsToggle']/value='advanced'">
                  <input type="radio" name="setappvar" value="accessRightsToggle(basic)" id="aclsBasic" onclick="changeClass('howList','visible');changeClass('howTable','invisible');"/>
                  <label for="aclsBasic"><xsl:value-of select="$bwStr-Access-Basic"/></label>
                  <input type="radio" name="setappvar" value="accessRightsToggle(advanced)" id="aclsAdvanced" checked="checked" onclick="changeClass('howList','invisible');changeClass('howTable','visible');"/>
                  <label for="aclsAdvanced"><xsl:value-of select="$bwStr-Access-Advanced"/></label>
                </xsl:when>
                <xsl:otherwise>
                  <input type="radio" name="setappvar" value="accessRightsToggle(basic)" id="aclsBasic" checked="checked" onclick="changeClass('howList','visible');changeClass('howTable','invisible');"/>
                  <label for="aclsBasic"><xsl:value-of select="$bwStr-Access-Basic"/></label>
                  <input type="radio" name="setappvar" value="accessRightsToggle(advanced)" id="aclsAdvanced" onclick="changeClass('howList','invisible');changeClass('howTable','visible');"/>
                  <label for="aclsAdvanced"><xsl:value-of select="$bwStr-Access-Advanced"/></label>
                </xsl:otherwise>
              </xsl:choose>
            </span>
            <xsl:value-of select="$bwStr-Access-Rights"/>
          </h5>
          <input type="hidden" name="how" value="" id="bwCurrentHow"/>
          <!-- field 'acl' will receive xml for method 2 -->
          <input type="hidden" name="acl" value="" id="bwCurrentAcl" />
          <!-- Advanced Access Rights: -->
          <!-- the "how" field is set by iterating over the howItems below -->
          <table id="howTable" class="invisible" cellspacing="0">
            <xsl:if test="/bedework/appvar[key='accessRightsToggle']/value='advanced'">
              <xsl:attribute name="class">visible</xsl:attribute>
            </xsl:if>
            <tr>
              <th><xsl:value-of select="$bwStr-Access-AccessType"/></th>
              <th><xsl:value-of select="$bwStr-Access-Allow"/></th>
              <th><xsl:value-of select="$bwStr-Access-Deny"/></th>
            </tr>
            <tr>
              <td class="level1">
                <input type="checkbox" value="A" id="accessAll" name="howItem" onclick="setupAccessForm(this, this.form); toggleAllowDenyFlag(this, this.form)"/>
                <label for="accessAll"><xsl:value-of select="$bwStr-Access-All"/></label>
              </td>
              <td>
                <input type="radio" value="A" name="accessAll" checked="checked" disabled="disabled"/>
              </td>
              <td>
                <input type="radio" value="-A" name="accessAll" disabled="disabled"/>
              </td>
            </tr>
            <tr>
              <td class="level2">
                <input type="checkbox" value="R" id="accessRead" name="howItem" onclick="setupAccessForm(this, this.form); toggleAllowDenyFlag(this, this.form)" checked="checked"/>
                <label for="accessRead"><xsl:value-of select="$bwStr-Access-Read"/></label>
              </td>
              <td>
                <input type="radio" value="R" name="accessRead" checked="checked"/>
              </td>
              <td>
                <input type="radio" value="-R" name="accessRead"/>
              </td>
            </tr>
            <tr>
              <td class="level3">
                <input type="checkbox" value="r" id="r" name="howItem" disabled="disabled" onclick="toggleAllowDenyFlag(this, this.form)"/>
                <label for="r"><xsl:value-of select="$bwStr-Access-ReadACL"/></label>
              </td>
              <td>
                <input type="radio" value="r" name="r" checked="checked" disabled="disabled"/>
              </td>
              <td>
                <input type="radio" value="-r" name="r" disabled="disabled"/>
              </td>
            </tr>
            <tr>
              <td class="level3">
                <input type="checkbox" value="P" id="accessPriv" name="howItem" disabled="disabled" onclick="toggleAllowDenyFlag(this, this.form)"/>
                <label for="accessPriv"><xsl:value-of select="$bwStr-Access-ReadCurrentUserPrivilegeSet"/></label>
              </td>
              <td>
                <input type="radio" value="P" name="accessPriv" checked="checked" disabled="disabled"/>
              </td>
              <td>
                <input type="radio" value="-P" name="accessPriv" disabled="disabled"/>
              </td>
            </tr>
            <tr>
              <td class="level3">
                <input type="checkbox" value="F" id="F" name="howItem" disabled="disabled" onclick="toggleAllowDenyFlag(this, this.form)"/>
                <label for="F"><xsl:value-of select="$bwStr-Access-ReadFreebusy"/></label>
              </td>
              <td>
                <input type="radio" value="F" name="F" checked="checked" disabled="disabled"/>
              </td>
              <td>
                <input type="radio" value="-F" name="F" disabled="disabled"/>
              </td>
            </tr>
            <tr>
              <td class="level2">
                <input type="checkbox" value="W" id="W" name="howItem" onclick="setupAccessForm(this, this.form); toggleAllowDenyFlag(this, this.form)"/>
                <label for="W"><xsl:value-of select="$bwStr-Access-Write"/></label>
              </td>
              <td>
                <input type="radio" value="W" name="W" checked="checked" disabled="disabled"/>
              </td>
              <td>
                <input type="radio" value="-W" name="W" disabled="disabled"/>
              </td>
            </tr>
            <tr>
              <td class="level3">
                <input type="checkbox" value="a" id="a" name="howItem" onclick="toggleAllowDenyFlag(this, this.form)"/>
                <label for="a"><xsl:value-of select="$bwStr-Access-WriteACL"/></label>
              </td>
              <td>
                <input type="radio" value="a" name="a" checked="checked" disabled="disabled"/>
              </td>
              <td>
                <input type="radio" value="-a" name="a" disabled="disabled"/>
              </td>
            </tr>
            <tr>
              <td class="level3">
                <input type="checkbox" value="p" id="p" name="howItem" onclick="toggleAllowDenyFlag(this, this.form)"/>
                <label for="p"><xsl:value-of select="$bwStr-Access-WriteProperties"/></label>
              </td>
              <td>
                <input type="radio" value="p" name="p" checked="checked" disabled="disabled"/>
              </td>
              <td>
                <input type="radio" value="-p" name="p" disabled="disabled"/>
              </td>
            </tr>
            <tr>
              <td class="level3">
                <input type="checkbox" value="c" id="c" name="howItem" onclick="toggleAllowDenyFlag(this, this.form)"/>
                <label for="c"><xsl:value-of select="$bwStr-Access-WriteContent"/></label>
              </td>
              <td>
                <input type="radio" value="c" name="c" checked="checked" disabled="disabled"/>
              </td>
              <td>
                <input type="radio" value="-c" name="c" disabled="disabled"/>
              </td>
            </tr>
            <tr>
              <td class="level3">
                <input type="checkbox" value="b" id="b" name="howItem" onclick="setupAccessForm(this, this.form); toggleAllowDenyFlag(this, this.form)"/>
                <label for="b"><xsl:value-of select="$bwStr-Access-Create"/></label>
              </td>
              <td>
                <input type="radio" value="b" name="b" checked="checked" disabled="disabled"/>
              </td>
              <td>
                <input type="radio" value="-b" name="b" disabled="disabled"/>
              </td>
            </tr>
            <tr>
              <td class="level3">
                 <input type="checkbox" value="u" id="u" name="howItem" onclick="toggleAllowDenyFlag(this, this.form)"/>
                 <label for="u"><xsl:value-of select="$bwStr-Access-Delete"/></label>
              </td>
              <td>
                <input type="radio" value="u" name="u" checked="checked" disabled="disabled"/>
              </td>
              <td>
                <input type="radio" value="-u" name="u" disabled="disabled"/>
              </td>
            </tr>
            <tr>
              <td class="level2">
                <input type="checkbox" value="D" id="accessScheduleDeliver" name="howItem" onclick="setupAccessForm(this, this.form); toggleAllowDenyFlag(this, this.form)" checked="checked"/>
                <label for="accessScheduleDeliver"><xsl:value-of select="$bwStr-Access-ScheduleDeliver"/></label>
              </td>
              <td>
                <input type="radio" value="D" name="accessScheduleDeliver" checked="checked"/>
              </td>
              <td>
                <input type="radio" value="-D" name="accessScheduleDeliver"/>
              </td>
            </tr>
            <tr>
              <td class="level3">
                <input type="checkbox" value="i" id="i" name="howItem" disabled="disabled" onclick="toggleAllowDenyFlag(this, this.form)"/>
                <label for="i"><xsl:value-of select="$bwStr-Access-ScheduleDeliverInvite"/></label>
              </td>
              <td>
                <input type="radio" value="i" name="i" checked="checked" disabled="disabled"/>
              </td>
              <td>
                <input type="radio" value="-i" name="i" disabled="disabled"/>
              </td>
            </tr>
            <tr>
              <td class="level3">
                <input type="checkbox" value="e" id="e" name="howItem" disabled="disabled" onclick="toggleAllowDenyFlag(this, this.form)"/>
                <label for="e"><xsl:value-of select="$bwStr-Access-ScheduleDeliverReply"/></label>
              </td>
              <td>
                <input type="radio" value="e" name="e" checked="checked" disabled="disabled"/>
              </td>
              <td>
                <input type="radio" value="-e" name="e" disabled="disabled"/>
              </td>
            </tr>
            <tr>
              <td class="level3">
                <input type="checkbox" value="q" id="q" name="howItem" disabled="disabled" onclick="toggleAllowDenyFlag(this, this.form)"/>
                <label for="q"><xsl:value-of select="$bwStr-Access-ScheduleQueryFreebusy"/></label>
              </td>
              <td>
                <input type="radio" value="q" name="q" checked="checked" disabled="disabled"/>
              </td>
              <td>
                <input type="radio" value="-q" name="q" disabled="disabled"/>
              </td>
            </tr>
            <tr>
              <td class="level2">
                <input type="checkbox" value="T" id="accessScheduleSend" name="howItem" onclick="setupAccessForm(this, this.form); toggleAllowDenyFlag(this, this.form)" checked="checked"/>
                <label for="accessScheduleSend"><xsl:value-of select="$bwStr-Access-ScheduleSend"/></label>
              </td>
              <td>
                <input type="radio" value="T" name="accessScheduleSend" checked="checked"/>
              </td>
              <td>
                <input type="radio" value="-T" name="accessScheduleSend"/>
              </td>
            </tr>
            <tr>
              <td class="level3">
                <input type="checkbox" value="I" id="I" name="howItem" disabled="disabled" onclick="toggleAllowDenyFlag(this, this.form)"/>
                <label for="I"><xsl:value-of select="$bwStr-Access-ScheduleSendInvite"/></label>
              </td>
              <td>
                <input type="radio" value="I" name="I" checked="checked" disabled="disabled"/>
              </td>
              <td>
                <input type="radio" value="-I" name="I" disabled="disabled"/>
              </td>
            </tr>
            <tr>
              <td class="level3">
                <input type="checkbox" value="E" id="E" name="howItem" disabled="disabled" onclick="toggleAllowDenyFlag(this, this.form)"/>
                <label for="E"><xsl:value-of select="$bwStr-Access-ScheduleSendReply"/></label>
              </td>
              <td>
                <input type="radio" value="E" name="E" checked="checked" disabled="disabled"/>
              </td>
              <td>
                <input type="radio" value="-E" name="E" disabled="disabled"/>
              </td>
            </tr>
            <tr>
              <td class="level3">
                <input type="checkbox" value="Q" id="Q" name="howItem" disabled="disabled" onclick="toggleAllowDenyFlag(this, this.form)"/>
                <label for="Q"><xsl:value-of select="$bwStr-Access-ScheduleSendFreebusy"/></label>
              </td>
              <td>
                <input type="radio" value="Q" name="Q" checked="checked" disabled="disabled"/>
              </td>
              <td>
                <input type="radio" value="-Q" name="Q" disabled="disabled"/>
              </td>
            </tr>
            <!--<tr>
              <td class="level1">
                <input type="checkbox" value="N" name="howItem" onclick="setupAccessForm(this, this.form)"/> <xsl:value-of select="$bwStr-Access-None"/>
              </td>
              <td>
              </td>
              <td>
              </td>
            </tr>-->
          </table>
          <!-- Simple Access Rights: -->
          <!-- the "how" field is set by getting the selected basicHowItem -->
          <ul id="howList">
            <xsl:if test="/bedework/appvar[key='accessRightsToggle']/value='advanced'">
              <xsl:attribute name="class">invisible</xsl:attribute>
            </xsl:if>
            <li>
              <input type="radio" value="A" name="basicHowItem" id="basicHowA"/>
              <label for="basicHowA"><xsl:value-of select="$bwStr-Access-BasicAll"/></label>
            </li>
            <li>
              <input type="radio" value="R" name="basicHowItem" id="basicHowR" checked="checked"/>
              <label for="basicHowR"><xsl:value-of select="$bwStr-Access-BasicRead"/></label>
            </li>
          </ul>
        </td>
      </tr>
    </table>
  </xsl:template>

  <!-- return string values to be loaded into javascript for access control forms -->
  <xsl:template match="ace" mode="initJS"><!--
  --><xsl:variable name="who"><!--
   --><xsl:choose>
        <xsl:when test="invert">
          <xsl:choose>
            <xsl:when test="invert/principal/href"><xsl:value-of select="normalize-space(invert/principal/href)"/></xsl:when>
            <xsl:when test="invert/principal/property"><xsl:value-of select="name(invert/principal/property/*)"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="name(invert/principal/*)"/></xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="principal/href"><xsl:value-of select="normalize-space(principal/href)"/></xsl:when>
            <xsl:when test="principal/property"><xsl:value-of select="name(principal/property/*)"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="name(principal/*)"/></xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose><!--
  --></xsl:variable><!--
  --><xsl:variable name="whoType"><!--
   --><xsl:choose>
        <xsl:when test="contains($who,/bedework/syspars/userPrincipalRoot)">user</xsl:when>
        <xsl:when test="contains($who,/bedework/syspars/groupPrincipalRoot)">group</xsl:when>
        <xsl:when test="$who='authenticated'">auth</xsl:when>
        <xsl:when test="$who='unauthenticated'">unauth</xsl:when>
        <xsl:when test="$who='all'">all</xsl:when>
        <xsl:when test="invert/principal/property/owner">other</xsl:when>
        <xsl:when test="principal/property"><xsl:value-of select="name(principal/property/*)"/></xsl:when>
        <xsl:when test="invert/principal/property"><xsl:value-of select="name(invert/principal/property/*)"/></xsl:when>
        <xsl:otherwise></xsl:otherwise>
      </xsl:choose><!--
 --></xsl:variable><!--
 --><xsl:variable name="aclString"><!--
   --><xsl:if test="grant"><!--
     --><xsl:for-each select="grant/privilege/*"><xsl:call-template name="grantDenyToInternal"><xsl:with-param name="name"><xsl:value-of select="name(.)"/></xsl:with-param></xsl:call-template></xsl:for-each><!--
   --></xsl:if><!--
   --><xsl:if test="deny"><!--
     --><xsl:for-each select="deny/privilege/*">-<xsl:call-template name="grantDenyToInternal"><xsl:with-param name="name"><xsl:value-of select="name(.)"/></xsl:with-param></xsl:call-template></xsl:for-each><!--
   --></xsl:if><!--
 --></xsl:variable><!--
 --><xsl:variable name="inherited"><!--
   --><xsl:choose>
       <xsl:when test="inherited"><xsl:value-of select="inherited/href"/></xsl:when>
       <xsl:otherwise></xsl:otherwise>
     </xsl:choose><!--
  --></xsl:variable><!--
  --><xsl:variable name="invert"><!--
    --><xsl:choose>
         <xsl:when test="invert">true</xsl:when>
         <xsl:otherwise>false</xsl:otherwise>
       </xsl:choose><!--
  --></xsl:variable>
  <!-- now initialize the object:-->
    bwAcl.init('<xsl:value-of select="$who"/>','<xsl:value-of select="$whoType"/>','<xsl:value-of select="$aclString"/>','<xsl:value-of select="$inherited"/>','<xsl:value-of select="$invert"/>');
  </xsl:template>

  <xsl:template name="grantDenyToInternal"><!--
  --><xsl:param name="name"/><!--
  --><xsl:choose>
       <xsl:when test="$name = 'all'">A</xsl:when>
       <xsl:when test="$name = 'read'">R</xsl:when>
       <xsl:when test="$name = 'read-acl'">r</xsl:when>
       <xsl:when test="$name = 'read-cuurrent-user-privilege-set'">P</xsl:when>
       <xsl:when test="$name = 'read-free-busy'">F</xsl:when>
       <xsl:when test="$name = 'write'">W</xsl:when>
       <xsl:when test="$name = 'write-acl'">a</xsl:when>
       <xsl:when test="$name = 'write-properties'">p</xsl:when>
       <xsl:when test="$name = 'write-content'">c</xsl:when>
       <xsl:when test="$name = 'bind'">b</xsl:when>
       <xsl:when test="$name = 'schedule'">S</xsl:when>
       <xsl:when test="$name = 'schedule-request'">t</xsl:when>
       <xsl:when test="$name = 'schedule-reply'">y</xsl:when>
       <xsl:when test="$name = 'schedule-free-busy'">s</xsl:when>
       <xsl:when test="$name = 'unbind'">u</xsl:when>
       <xsl:when test="$name = 'unlock'">U</xsl:when>
       <xsl:when test="$name = 'schedule-deliver'">D</xsl:when>
       <xsl:when test="$name = 'schedule-deliver-invite'">i</xsl:when>
       <xsl:when test="$name = 'schedule-deliver-reply'">e</xsl:when>
       <xsl:when test="$name = 'schedule-query-freebusy'">q</xsl:when>
       <xsl:when test="$name = 'schedule-send'">T</xsl:when>
       <xsl:when test="$name = 'schedule-send-invite'">I</xsl:when>
       <xsl:when test="$name = 'schedule-send-reply'">E</xsl:when>
       <xsl:when test="$name = 'schedule-send-freebusy'">Q</xsl:when>
       <xsl:when test="$name = 'none'">N</xsl:when>
     </xsl:choose><!--
--></xsl:template>
</xsl:stylesheet>
