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

  <!--+++++++++++++++ Users ++++++++++++++++++++-->
  <!-- templates:
         - tabUsers
         - authUserList - for setting roles
         - modAuthUser
   -->

  <!-- User/Group Tab -->
  <xsl:template name="tabUsers">
    <xsl:if test="/bedework/userInfo/superUser='true'">
      <h2><xsl:copy-of select="$bwStr-TaUs-ManageUsersAndGroups"/></h2>
      <ul class="adminMenu">
        <xsl:if test="/bedework/workflowEnabled='true'">
          <li>
            <a href="{$authuser-initUpdate}">
              <xsl:copy-of select="$bwStr-TaUs-ManageAdminRoles"/>
            </a>
          </li>
        </xsl:if>
        <xsl:if test="/bedework/userInfo/adminGroupMaintOk='true'">
          <li class="groups">
            <a href="{$admingroup-initUpdate}">
              <xsl:copy-of select="$bwStr-TaUs-ManageAdminGroups"/>
            </a>
          </li>
        </xsl:if>
        <li class="changeGroup">
          <a href="{$admingroup-switch}">
            <xsl:copy-of select="$bwStr-TaUs-ChangeGroup"/>
          </a>
        </li>
        <xsl:if test="/bedework/userInfo/userMaintOK='true'">
          <li class="user">
            <form action="{$prefs-fetchForUpdate}" method="post">
              <xsl:copy-of select="$bwStr-TaUs-EditUsersPrefs"/><br/>
              <input type="text" name="user" size="40"/>
              <input type="submit" name="getPrefs" value="{$bwStr-TaUs-Go}"/>
            </form>
          </li>
        </xsl:if>
      </ul>
    </xsl:if>
  </xsl:template>

  <xsl:template name="authUserList">
    <h2><xsl:copy-of select="$bwStr-AuUL-ModifyAdministrators"/></h2>

    <div id="authUserInputForms">
      <form name="getUserRolesForm" action="{$authuser-fetchForUpdate}" method="post">
        <xsl:copy-of select="$bwStr-AuUL-EditAdminRoles"/><xsl:text> </xsl:text><input type="text" name="editAuthUserId" size="20"/>
        <input type="submit" value="{$bwStr-AuUL-Go}" name="submit"/>
      </form>
    </div>

    <table id="commonListTable">
      <tr>
        <th><xsl:copy-of select="$bwStr-AuUL-UserID"/></th>
        <th><xsl:copy-of select="$bwStr-AuUL-Roles"/></th>
        <th></th>
      </tr>

      <xsl:for-each select="/bedework/authUsers/authUser">
        <!--<xsl:sort select="account" order="ascending" case-order="upper-first"/>-->
        <tr>
          <xsl:if test="position() mod 2 = 0"><xsl:attribute name="class">even</xsl:attribute></xsl:if>
          <td>
            <xsl:value-of select="substring-after(userHref,'/principals/users/')"/>
          </td>
          <td>
            <xsl:if test="publicEventUser='true'">
              publicEvent; <xsl:text> </xsl:text>
            </xsl:if>
            <xsl:if test="contentAdminUser='true'">
              contentAdmin; <xsl:text> </xsl:text>
            </xsl:if>
            <xsl:if test="approverUser='true'">
              approver; <xsl:text> </xsl:text>
            </xsl:if>
          </td>
          <td>
            <xsl:variable name="userHref" select="userHref"/>
            <a href="{$authuser-fetchForUpdate}&amp;editAuthUserId={userHref}">
              <xsl:copy-of select="$bwStr-AuUL-Edit"/>
            </a>
          </td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <xsl:template name="modAuthUser">
    <h2><xsl:copy-of select="$bwStr-MoAU-UpdateAdmin"/></h2>
    <xsl:variable name="modAuthUserAction" select="/bedework/formElements/form/@action"/>
    <form action="{$modAuthUserAction}" method="post">
      <table id="eventFormTable">
        <tr>
          <td class="fieldName">
            <xsl:copy-of select="$bwStr-MoAU-Account"/>
          </td>
          <td>
            <xsl:value-of select="/bedework/formElements/form/userHref"/>
          </td>
        </tr>
        <tr>
          <td class="fieldName">
            <xsl:copy-of select="$bwStr-MoAU-PublicEvents"/>
          </td>
          <td>
            <xsl:copy-of select="/bedework/formElements/form/publicEvents/*"/>
          </td>
        </tr>
        <tr>
          <td class="fieldName">
            <xsl:copy-of select="$bwStr-MoAU-ContentAdmin"/>
          </td>
          <td>
            <xsl:copy-of select="/bedework/formElements/form/contentAdmin/*"/>
          </td>
        </tr>
        <tr>
          <td class="fieldName">
            <xsl:copy-of select="$bwStr-MoAU-Approver"/>
          </td>
          <td>
            <xsl:copy-of select="/bedework/formElements/form/approver/*"/>
          </td>
        </tr>
      </table>
      <br />

      <input type="submit" name="modAuthUser" value="{$bwStr-MoAU-Update}"/>
      <input type="submit" name="cancelled" value="{$bwStr-MoAU-Cancel}"/>
    </form>
  </xsl:template>

</xsl:stylesheet>