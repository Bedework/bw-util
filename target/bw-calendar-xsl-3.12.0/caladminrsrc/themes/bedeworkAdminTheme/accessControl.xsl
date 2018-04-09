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

  <!--++++ ACCESS CONTROL TEMPLATES ++++-->
  <!-- templates:
         - schedulingAccessForm
         - currentAccess
   -->

  <!-- schedulingAccessForm template may be deprecated -->
  <xsl:template name="schedulingAccessForm">
    <xsl:param name="what"/>
    <input type="hidden" name="what">
      <xsl:attribute name="value"><xsl:value-of select="$what"/></xsl:attribute>
    </input>
    <p>
      <input type="text" name="who" width="40"/>
      <span class="nowrap">
        <input type="radio" name="whoType" id="whoTypeUser" value="user" checked="checked"/>
        <label for="whoTypeUser"><xsl:copy-of select="$bwStr-ScAF-User"/></label>
      </span>
      <span class="nowrap">
        <input type="radio" name="whoType" id="whoTypeGroup" value="group"/>
        <label for="whoTypeGroup"><xsl:copy-of select="$bwStr-ScAF-Group"/></label>
      </span>
    </p>
    <p>
      <strong><xsl:copy-of select="$bwStr-ScAF-Or"/></strong>
      <span class="nowrap"><input type="radio" name="whoType" value="owner"/><xsl:copy-of select="$bwStr-ScAF-Owner"/></span>
      <span class="nowrap"><input type="radio" name="whoType" value="auth"/><xsl:copy-of select="$bwStr-ScAF-AuthenticatedUsers"/></span>
      <span class="nowrap"><input type="radio" name="whoType" value="other"/><xsl:copy-of select="$bwStr-ScAF-Anyone"/></span>
    </p>

    <input type="hidden" name="how" value="S"/>
    <dl>
      <dt>
        <input type="checkbox" name="howSetter" value="S" checked="checked" onchange="toggleScheduleHow(this.form,this)"/><xsl:copy-of select="$bwStr-ScAF-AllScheduling"/>
      </dt>
      <dd>
        <input type="checkbox" name="howSetter" value="t" checked="checked" disabled="disabled"/><xsl:copy-of select="$bwStr-ScAF-SchedReqs"/><br/>
        <input type="checkbox" name="howSetter" value="y" checked="checked" disabled="disabled"/><xsl:copy-of select="$bwStr-ScAF-SchedReplies"/><br/>
        <input type="checkbox" name="howSetter" value="s" checked="checked" disabled="disabled"/><xsl:copy-of select="$bwStr-ScAF-FreeBusyReqs"/>
      </dd>
    </dl>

    <input type="submit" name="modPrefs" value="{$bwStr-ScAF-Update}"/>
    <input type="submit" name="cancelled" value="{$bwStr-ScAF-Cancel}"/>
  </xsl:template>

  <xsl:template match="acl" mode="currentAccess">
    <xsl:param name="action"/> <!-- required -->
    <xsl:param name="calPathEncoded"/> <!-- optional (for entities) -->
    <xsl:param name="guid"/> <!-- optional (for entities) -->
    <xsl:param name="recurrenceId"/> <!-- optional (for entities) -->
    <xsl:param name="what"/> <!-- optional (for scheduling only) -->
    <xsl:param name="calSuiteName"/> <!-- optional (for calendar suites only) -->
    <h3><xsl:copy-of select="$bwStr-ACLs-CurrentAccess"/></h3>
      <table class="common scheduling">
        <tr>
          <th><xsl:copy-of select="$bwStr-ACLs-Entry"/></th>
          <th><xsl:copy-of select="$bwStr-ACLs-Access"/></th>
          <th><xsl:copy-of select="$bwStr-ACLs-InheritedFrom"/></th>
          <td></td>
        </tr>
        <xsl:for-each select="ace">
        <xsl:variable name="who">
          <xsl:choose>
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
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="whoType">
          <xsl:choose>
            <xsl:when test="contains($who,/bedework/syspars/userPrincipalRoot)"><xsl:copy-of select="$bwStr-ACLs-User"/></xsl:when>
            <xsl:when test="contains($who,/bedework/syspars/groupPrincipalRoot)"><xsl:copy-of select="$bwStr-ACLs-Group"/></xsl:when>
            <xsl:when test="$who='authenticated'"><xsl:copy-of select="$bwStr-ACLs-Auth"/></xsl:when>
            <xsl:when test="$who='unauthenticated'"><xsl:copy-of select="$bwStr-ACLs-UnAuth"/></xsl:when>
            <xsl:when test="$who='all'"><xsl:copy-of select="$bwStr-ACLs-All"/></xsl:when>
            <xsl:when test="invert/principal/property/owner"><xsl:copy-of select="$bwStr-ACLs-Other"/></xsl:when>
            <xsl:when test="principal/property"><xsl:value-of select="name(principal/property/*)"/></xsl:when>
            <xsl:when test="invert/principal/property"><xsl:value-of select="name(invert/principal/property/*)"/></xsl:when>
            <xsl:otherwise></xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="shortWho">
          <xsl:choose>
            <xsl:when test="$whoType='user'"><xsl:value-of select="substring-after(substring-after($who,normalize-space(/bedework/syspars/userPrincipalRoot)),'/')"/></xsl:when>
            <xsl:when test="$whoType='group'"><xsl:value-of select="substring-after(substring-after($who,normalize-space(/bedework/syspars/groupPrincipalRoot)),'/')"/></xsl:when>
            <xsl:otherwise></xsl:otherwise> <!-- if not user or group, send no who -->
          </xsl:choose>
        </xsl:variable>
        <tr>
          <td>
            <xsl:choose>
              <xsl:when test="$whoType = 'user' or ($who = 'owner' and $whoType != 'other')">
                <img src="{$resourcesRoot}/images/userIcon.gif" width="13" height="13" alt="user"/>
              </xsl:when>
              <xsl:otherwise>
                <img src="{$resourcesRoot}/images/groupIcon.gif" width="13" height="13" alt="group"/>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:text> </xsl:text>
            <xsl:choose>
              <xsl:when test="$whoType = 'other'">
                <xsl:copy-of select="$bwStr-ACLs-Anyone"/>
              </xsl:when>
              <xsl:when test="$shortWho != ''">
                <xsl:value-of select="$shortWho"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$who"/>
              </xsl:otherwise>
            </xsl:choose>
          </td>
          <td class="acls">
            <xsl:if test="grant">
              <xsl:copy-of select="$bwStr-ACLs-Grant"/>
              <span class="grant">
                <xsl:for-each select="grant/privilege/*">
                  <xsl:value-of select="name(.)"/>
                  <xsl:if test="position() != last()">, </xsl:if>
                </xsl:for-each>
              </span><br/>
            </xsl:if>
            <xsl:if test="deny">
              <xsl:copy-of select="$bwStr-ACLs-Deny"/>
              <span class="deny">
                <xsl:for-each select="deny/privilege/*">
                  <xsl:value-of select="name(.)"/>
                  <xsl:if test="position() != last()">, </xsl:if>
                </xsl:for-each>
              </span>
            </xsl:if>
          </td>
          <td>
            <xsl:choose>
              <xsl:when test="inherited">
                <xsl:value-of select="inherited/href"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:copy-of select="$bwStr-ACLs-Local"/>
              </xsl:otherwise>
            </xsl:choose>
          </td>
          <td>
            <xsl:if test="not(inherited)">
              <a href="{$action}&amp;how=default&amp;what={$what}&amp;who={$shortWho}&amp;whoType={$whoType}&amp;calPath={$calPathEncoded}&amp;calSuiteName={$calSuiteName}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}" title="reset to default">
                <img src="{$resourcesRoot}/images/trashIcon.gif" width="13" height="13" alt="reset to default"/>
              </a>
            </xsl:if>
          </td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

</xsl:stylesheet>