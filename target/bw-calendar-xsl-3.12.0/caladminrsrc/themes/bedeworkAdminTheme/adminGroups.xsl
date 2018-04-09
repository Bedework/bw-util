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

  <!--+++++++++++++++ Admin Groups ++++++++++++++++++++--><!-- templates:
         - listAdminGroups
         - chooseGroup
         - modAdminGroup
         - modAdminGroupMembers
         - deleteAdminGroupConfirm
   -->

  <xsl:template name="listAdminGroups">
    <h2>
      <xsl:copy-of select="$bwStr-LsAG-ModifyGroups"/>
    </h2>
    <form id="adminGroupMembersForm" name="adminGroupMembersForm" method="post"
          action="{$admingroup-initUpdate}">
      <xsl:choose>
        <xsl:when test="/bedework/groups/showMembers='true'">
          <input type="radio" name="showAgMembers" id="hideAgMembers"
                 value="false"
                 onclick="document.adminGroupMembersForm.submit();"/>
          <label for="hideAgMembers">
            <xsl:copy-of select="$bwStr-LsAG-HideMembers"/>
          </label>
          <input type="radio" name="showAgMembers"
                 id="displayAgMembers" value="true" checked="checked"
                 onclick="document.adminGroupMembersForm.submit();"/>
          <label for="displayAgMembers">
            <xsl:copy-of select="$bwStr-LsAG-ShowMembers"/>
          </label>
        </xsl:when>
        <xsl:otherwise>
          <input type="radio" name="showAgMembers" id="hideAgMembers"
                 value="false" checked="checked"
                 onclick="document.adminGroupMembersForm.submit();"/>
          <label for="hideAgMembers">
            <xsl:copy-of select="$bwStr-LsAG-HideMembers"/>
          </label>
          <input type="radio" name="showAgMembers"
                 id="displayAgMembers" value="true"
                 onclick="document.adminGroupMembersForm.submit();"/>
          <label for="displayAgMembers">
            <xsl:copy-of select="$bwStr-LsAG-ShowMembers"/>
          </label>
        </xsl:otherwise>
      </xsl:choose>
    </form>

    <p>
      <xsl:copy-of select="$bwStr-LsAG-SelectGroupName"/>
    </p>
    <p>
      <input type="button" name="return"
             onclick="javascript:location.replace('{$admingroup-initAdd}')"
             value="{$bwStr-LsAG-AddNewGroup}"/>
    </p>
    <div class="notes">
      <p class="note">
        <xsl:copy-of select="$bwStr-LsAG-HighlightedRowsNote"/>
      </p>
    </div>
    <table id="commonListTable">
      <tr>
        <th>
          <xsl:copy-of select="$bwStr-LsAG-Name"/>
        </th>
        <xsl:if test="/bedework/groups/showMembers='true'">
          <th>
            <xsl:copy-of select="$bwStr-LsAG-Members"/>
          </th>
        </xsl:if>
        <th>
          <xsl:copy-of select="$bwStr-LsAG-ManageMembership"/>
        </th>
        <th>
          <xsl:copy-of select="$bwStr-LsAG-CalendarSuite"/>
        </th>
        <th>
          <xsl:copy-of select="$bwStr-LsAG-Description"/>
        </th>
      </tr>
      <xsl:for-each select="/bedework/groups/group">
        <xsl:sort select="name" order="ascending"
                  case-order="lower-first"/>
        <xsl:variable name="groupName" select="name"/>
        <tr>
          <xsl:if test="position() mod 2 = 0">
            <xsl:attribute name="class">even</xsl:attribute>
          </xsl:if>
          <xsl:if test="name = /bedework/calSuites//calSuite/group">
            <xsl:attribute name="class">highlight</xsl:attribute>
          </xsl:if>
          <td>
            <a href="{$admingroup-fetchForUpdate}&amp;adminGroupName={$groupName}">
              <xsl:value-of select="name"/>
            </a>
          </td>
          <xsl:if test="/bedework/groups/showMembers='true'">
            <td class="memberList">
              <xsl:for-each select="members/member/account">
                <xsl:value-of select="."/>
                <br/>
              </xsl:for-each>
            </td>
          </xsl:if>
          <td>
            <a href="{$admingroup-fetchForUpdateMembers}&amp;adminGroupName={$groupName}">
              <xsl:copy-of select="$bwStr-LsAG-Membership"/>
            </a>
          </td>
          <td>
            <xsl:for-each select="/bedework/calSuites/calSuite">
              <xsl:if test="group = $groupName">
                <xsl:value-of select="name"/>
              </xsl:if>
            </xsl:for-each>
          </td>
          <td>
            <xsl:value-of select="desc"/>
          </td>
        </tr>
      </xsl:for-each>
    </table>
    <p>
      <input type="button" name="return"
             onclick="javascript:location.replace('{$admingroup-initAdd}')"
             value="{$bwStr-LsAG-AddNewGroup}"/>
    </p>
  </xsl:template>

  <xsl:template match="groups" mode="chooseGroup">
    <h2>
      <xsl:copy-of select="$bwStr-Grps-ChooseAdminGroup"/>
    </h2>

    <xsl:variable name="userInCalSuiteGroup">
      <xsl:choose>
        <xsl:when
            test="/bedework/calSuites//calSuite/group = .//group/name">
          true
        </xsl:when>
        <xsl:otherwise>false</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <div class="notes">
      <xsl:if test="$userInCalSuiteGroup = 'true'">
        <p class="note">
          <xsl:copy-of select="$bwStr-Grps-HighlightedRowsNote"/>
        </p>
      </xsl:if>
      <!--
      <xsl:if test="/bedework/userInfo/superUser = 'true'">
        <p class="note"><xsl:copy-of select="$bwStr-Grps-Superuser"/></p>
      </xsl:if>
      -->
    </div>

    <table id="commonListTable">
      <tr>
        <th>
          <xsl:copy-of select="$bwStr-Grps-Name"/>
        </th>
        <th>
          <xsl:copy-of select="$bwStr-Grps-Description"/>
        </th>
        <xsl:if test="$userInCalSuiteGroup = 'true'">
          <th>
            <xsl:copy-of select="$bwStr-Grps-CalendarSuite"/>
          </th>
        </xsl:if>
      </tr>

      <xsl:for-each select="group">
        <xsl:sort select="name" order="ascending"
                  case-order="upper-first"/>
        <xsl:variable name="admGroupName" select="name"/>
        <tr>
          <xsl:if test="position() mod 2 = 0">
            <xsl:attribute name="class">even</xsl:attribute>
          </xsl:if>
          <xsl:if test="name = /bedework/calSuites//calSuite/group">
            <xsl:attribute name="class">highlight</xsl:attribute>
          </xsl:if>
          <td>
            <a href="{$setup}&amp;adminGroupName={$admGroupName}">
              <xsl:copy-of select="name"/>
            </a>
          </td>
          <td>
            <xsl:value-of select="desc"/>
          </td>
          <xsl:if test="$userInCalSuiteGroup = 'true'">
            <td>
              <xsl:for-each select="/bedework/calSuites/calSuite">
                <xsl:if test="group = $admGroupName">
                  <xsl:value-of select="name"/>
                </xsl:if>
              </xsl:for-each>
            </td>
          </xsl:if>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <xsl:template name="modAdminGroup">
    <xsl:choose>
      <xsl:when test="/bedework/creating = 'true'">
        <h2>
          <xsl:copy-of select="$bwStr-MoAG-AddGroup"/>
        </h2>
      </xsl:when>
      <xsl:otherwise>
        <h2>
          <xsl:copy-of select="$bwStr-MoAG-ModifyGroup"/>
        </h2>
      </xsl:otherwise>
    </xsl:choose>
    <form name="peForm" method="post" action="{$admingroup-update}">
      <table id="adminGroupFormTable">
        <xsl:choose>
          <xsl:when test="/bedework/creating = 'true'">
            <tr>
              <td class="fieldName">
                <label for="adminGroupName">
                  <xsl:copy-of select="$bwStr-MoAG-Name"/>
                </label>
              </td>
              <td>
                <input type="text" name="updAdminGroup.account"
                       id="adminGroupName" value="">
                  <xsl:attribute name="value">
                    <xsl:value-of
                        select="/bedework/formElements/form/name/input/@value"/>
                  </xsl:attribute>
                </input>
              </td>
            </tr>
          </xsl:when>
          <xsl:otherwise>
            <tr>
              <td class="fieldName">
                <xsl:copy-of select="$bwStr-MoAG-Name"/>
              </td>
              <td>
                <xsl:value-of
                    select="/bedework/formElements/form/name"/>
              </td>
            </tr>
          </xsl:otherwise>
        </xsl:choose>
        <tr>
          <td class="fieldName">
            <label for="adminGroupDesc">
              <xsl:copy-of select="$bwStr-MoAG-Description"/>
            </label>
          </td>
          <td>
            <textarea name="updAdminGroup.description"
                      id="adminGroupDesc" cols="50" rows="3">
              <xsl:value-of
                  select="/bedework/formElements/form/desc/textarea"/>
              <xsl:if test="normalize-space(/bedework/formElements/form/desc/textarea) = ''">
                <xsl:text> </xsl:text>
                <!-- keep this non-breaking space to avoid browser
                rendering errors when the text area is empty -->
              </xsl:if>
            </textarea>
          </td>
        </tr>
        <tr>
          <td class="fieldName">
            <label for="adminGroupOwner">
              <xsl:copy-of select="$bwStr-MoAG-GroupOwner"/>
            </label>
          </td>
          <td>
            <input type="text" name="adminGroupGroupOwner"
                   id="adminGroupOwner" size="60">
              <xsl:attribute name="value">
                <xsl:value-of
                    select="/bedework/formElements/form/groupOwner/input/@value"/>
              </xsl:attribute>
            </input>
            <br/>
            <span class="fieldInfo">
              <xsl:copy-of select="$bwStr-MoAG-GroupOwnerFieldInfo"/>
            </span>
          </td>
        </tr>
        <xsl:choose>
          <xsl:when test="/bedework/creating = 'true'">
            <tr>
              <td class="fieldName">
                <xsl:copy-of select="$bwStr-MoAG-EventsOwner"/>
              </td>
              <td>
                <input name="adminGroupEventOwner" value=""/>
                <span class="fieldInfo">
                  <xsl:copy-of select="$bwStr-MoAG-Optional"/>
                </span>
                <br/>
                <span class="fieldInfo">
                  <span class="fieldInfo">
                    <xsl:copy-of
                        select="$bwStr-MoAG-EventsOwnerFieldInfo"/>
                  </span>
                </span>
              </td>
            </tr>
          </xsl:when>
          <xsl:otherwise>
            <tr>
              <td class="fieldName">
                <xsl:copy-of select="$bwStr-MoAG-EventsOwner"/>
              </td>
              <td>
                <xsl:value-of
                    select="/bedework/formElements/form/eventsOwner/input/@value"/>
              </td>
            </tr>
          </xsl:otherwise>
        </xsl:choose>
      </table>
      <div class="submitBox">
        <div class="right">
          <xsl:if test="/bedework/creating = 'false'">
            <input type="submit" name="delete"
                   value="{$bwStr-MoAG-Delete}"/>
          </xsl:if>
        </div>
        <xsl:choose>
          <xsl:when test="/bedework/creating = 'true'">
            <input type="submit" name="updateAdminGroup"
                   value="{$bwStr-MoAG-AddAdminGroup}"/>
            <input type="submit" name="cancelled"
                   value="{$bwStr-MoAG-Cancel}"/>
          </xsl:when>
          <xsl:otherwise>
            <input type="submit" name="updateAdminGroup"
                   value="{$bwStr-MoAG-UpdateAdminGroup}"/>
            <input type="submit" name="cancelled"
                   value="{$bwStr-MoAG-Cancel}"/>
          </xsl:otherwise>
        </xsl:choose>
      </div>
    </form>
  </xsl:template>

  <xsl:template name="modAdminGroupMembers">
    <h2>
      <xsl:copy-of select="$bwStr-MAGM-UpdateGroupMembership"/>
    </h2>
    <p>
      <xsl:copy-of select="$bwStr-MAGM-EnterUserID"/>
    </p>

    <form id="adminGroupMembersForm" name="adminGroupMembersForm" method="post"
          action="{$admingroup-updateMembers}">
      <p>
        <label for="agMember">
          <xsl:copy-of select="$bwStr-MAGM-AddMember"/>
        </label>
        <xsl:text> </xsl:text>
        <input type="text" id="agMember" name="updGroupMember"
               size="15" onblur="this.value = trim(this.value);"/>
        <input type="radio" value="user" id="agUser" name="kind"
               checked="checked"/>
        <label for="agUser">
          <xsl:copy-of select="$bwStr-MAGM-User"/>
        </label>
        <input type="radio" value="group" id="agGroup" name="kind"/>
        <label for="agGroup">
          <xsl:copy-of select="$bwStr-MAGM-Group"/>
        </label>
        <xsl:text> </xsl:text>
        <input type="submit" name="addGroupMember"
               value="{$bwStr-MAGM-Add}"/>
      </p>
    </form>
    <p>
      <input type="button" name="return"
             onclick="javascript:location.replace('{$admingroup-initUpdate}')"
             value="{$bwStr-MAGM-ReturnToAdminGroupLS}"/>
    </p>

    <table id="adminGroupFormTable">
      <tr>
        <td class="fieldName">
          <xsl:copy-of select="$bwStr-MAGM-Name"/>
        </td>
        <td>
          <xsl:value-of select="/bedework/adminGroup/name"/>
        </td>
      </tr>
      <tr>
        <td class="fieldName">
          <xsl:copy-of select="$bwStr-MAGM-Members"/>
        </td>
        <td>
          <table id="memberAccountList">
            <xsl:for-each
                select="/bedework/adminGroup/members/member">
              <xsl:choose>
                <xsl:when test="kind='1'"><!-- kind = user -->
                  <tr>
                    <td>
                      <img src="{$resourcesRoot}/images/userIcon.gif"
                           width="13" height="13"
                           alt="{$bwStr-MAGM-User}"/>
                    </td>
                    <td>
                      <xsl:value-of select="account"/>
                    </td>
                    <td>
                      <xsl:variable name="acct" select="account"/>
                      <a href="{$admingroup-updateMembers}&amp;removeGroupMember={$acct}&amp;kind=user"
                         title="{$bwStr-MAGM-Remove}">
                        <img src="{$resourcesRoot}/images/trashIcon.gif"
                             width="13" height="13"
                             alt="{$bwStr-MAGM-Remove}"/>
                      </a>
                    </td>
                  </tr>
                </xsl:when>
                <xsl:otherwise><!-- kind = group -->
                  <tr>
                    <td>
                      <img src="{$resourcesRoot}/images/groupIcon.gif"
                           width="13" height="13"
                           alt="group"/>
                    </td>
                    <td>
                      <strong>
                        <xsl:value-of select="account"/>
                      </strong>
                    </td>
                    <td>
                      <xsl:variable name="acct" select="account"/>
                      <a href="{$admingroup-updateMembers}&amp;removeGroupMember={$acct}&amp;kind=group"
                         title="{$bwStr-MAGM-Remove}">
                        <img src="{$resourcesRoot}/images/trashIcon.gif"
                             width="13" height="13"
                             alt="{$bwStr-MAGM-Remove}"/>
                      </a>
                    </td>
                  </tr>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:for-each>
          </table>
        </td>
      </tr>
    </table>
    <p>
      <img src="{$resourcesRoot}/images/userIcon.gif" width="13"
           height="13" alt="{$bwStr-MAGM-User}"/>
      <xsl:text> </xsl:text>
      <xsl:copy-of select="$bwStr-MAGM-User"/>,
      <img src="{$resourcesRoot}/images/groupIcon.gif" width="13"
           height="13" alt="{$bwStr-MAGM-Group}"/>
      <xsl:text> </xsl:text>
      <strong>
        <xsl:copy-of select="$bwStr-MAGM-Group"/>
      </strong>
    </p>
  </xsl:template>

  <xsl:template name="deleteAdminGroupConfirm">
    <h2>
      <xsl:copy-of select="$bwStr-DAGC-DeleteAdminGroup"/>
    </h2>
    <p>
      <xsl:copy-of select="$bwStr-DAGC-GroupWillBeDeleted"/>
    </p>
    <p>
      <strong>
        <xsl:value-of select="/bedework/groups/group/name"/>
      </strong>
      :
      <xsl:value-of select="/bedework/groups/group/desc"/>
    </p>
    <form name="adminGroupDelete" method="post"
          action="{$admingroup-delete}">
      <input type="submit" name="removeAdminGroupOK"
             value="{$bwStr-DAGC-YesDelete}"/>
      <input type="submit" name="cancelled"
             value="{$bwStr-DAGC-NoCancel}"/>
    </form>
  </xsl:template>

</xsl:stylesheet>