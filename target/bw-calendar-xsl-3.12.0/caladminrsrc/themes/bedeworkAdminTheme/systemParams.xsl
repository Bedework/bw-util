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

  <!--+++++++++++++++ System Parameters (preferences) ++++++++++++++++++++-->

  <!-- THIS STYLESHEET IS DEPRECATED: You will now find these preferences in the
       JMX console. -->

  <xsl:template name="modSyspars">
    <h2><xsl:copy-of select="$bwStr-MdSP-ManageSysParams"/></h2>
    <p>
      <xsl:copy-of select="$bwStr-MdSP-DoNotChangeUnless"/>
    </p>
    <form name="systemParamsForm" action="{$system-update}" method="post">
      <table class="eventFormTable params">
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-SystemName"/></th>
          <td>
            <xsl:variable name="sysname" select="/bedework/system/name"/>
            <xsl:value-of select="$sysname"/>
            <div class="desc">
              <xsl:copy-of select="$bwStr-MdSP-SystemNameCannotBeChanged"/>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-DefaultTimezone"/></th>
          <td>
            <xsl:variable name="tzid" select="/bedework/system/tzid"/>

            <select name="tzid">
              <option value="-1"><xsl:copy-of select="$bwStr-MdSP-SelectTimeZone"/></option>
              <xsl:for-each select="/bedework/timezones/timezone">
                <option>
                  <xsl:attribute name="value"><xsl:value-of select="id"/></xsl:attribute>
                  <xsl:if test="/bedework/system/tzid = id"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
                  <xsl:value-of select="name"/>
                </option>
              </xsl:for-each>
            </select>

            <div class="desc">
              <xsl:copy-of select="$bwStr-MdSP-DefaultNormallyLocal"/>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-SuperUsers"/></th>
          <td>
            <xsl:variable name="rootUsers" select="/bedework/system/rootUsers"/>
            <input value="{$rootUsers}" name="rootUsers" class="wide"/>
            <div class="desc">
              <xsl:copy-of select="$bwStr-MdSP-CommaSeparatedList"/>
            </div>
          </td>
        </tr>
        <!--<tr>
          <th>12 or 24 hour clock/time:</th>
          <td>
            <select name="">
              <option value="-1">select preference...</option>
              <option value="true">
                <xsl:if test="/bedework/system/NEEDPARAM = 'true'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
                Use 24 hour clock/time
              </option>
              <option value="false">
                <xsl:if test="/bedework/system/NEEDPARAM = 'false'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
                Use 12 Hour clock/time + am/pm
              </option>
            </select>
            <div class="desc">
              Affects the time fields when adding and editing events
            </div>
          </td>
        </tr>-->
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-SystemID"/></th>
          <td>
            <xsl:variable name="systemid" select="/bedework/system/systemid"/>
            <xsl:value-of select="$systemid"/>
            <div class="desc">
              <xsl:copy-of select="$bwStr-MdSP-SystemIDNote"/>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-DefaultFBPeriod"/></th>
          <td>
            <xsl:variable name="defaultFBPeriod" select="/bedework/system/defaultFBPeriod"/>
            <input value="{$defaultFBPeriod}" name="defaultFBPeriod" />
            <div class="desc">
              <xsl:copy-of select="$bwStr-MdSP-DefaultFBPeriodNote"/>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-MaxFBPeriod"/></th>
          <td>
            <xsl:variable name="systemp" select="/bedework/system/maxFBPeriod"/>
            <input value="{$systemp}" name="maxFBPeriod" />
            <div class="desc">
              <xsl:copy-of select="$bwStr-MdSP-MaxFBPeriodNote"/>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-DefaultWebCalPeriod"/></th>
          <td>
            <xsl:variable name="systemp" select="/bedework/system/defaultWebCalPeriod"/>
            <input value="{$systemp}" name="defaultWebCalPeriod" />
            <div class="desc">
              <xsl:copy-of select="$bwStr-MdSP-DefaultWebCalPeriodNote"/>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-MaxWebCalPeriod"/></th>
          <td>
            <xsl:variable name="systemp" select="/bedework/system/maxWebCalPeriod"/>
            <input value="{$systemp}" name="maxWebCalPeriod" />
            <div class="desc">
              <xsl:copy-of select="$bwStr-MdSP-MaxWebCalPeriodNote"/>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-PubCalendarRoot"/></th>
          <td>
            <xsl:variable name="publicCalendarRoot" select="/bedework/system/publicCalendarRoot"/>
            <xsl:value-of select="$publicCalendarRoot"/>
            <div class="desc">
              <xsl:copy-of select="$bwStr-MdSP-PubCalendarRootNote"/>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-UserCalendarRoot"/></th>
          <td>
            <xsl:variable name="userCalendarRoot" select="/bedework/system/userCalendarRoot"/>
            <xsl:value-of select="$userCalendarRoot"/>
            <div class="desc">
              <xsl:copy-of select="$bwStr-MdSP-UserCalendarRootNote"/>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-UserCalendarDefaultName"/></th>
          <td>
            <xsl:variable name="userDefaultCalendar" select="/bedework/system/userDefaultCalendar"/>
            <input value="{$userDefaultCalendar}" name="userDefaultCalendar" />
            <div class="desc">
              <xsl:copy-of select="$bwStr-MdSP-UserCalendarDefaultNameNote"/>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-TrashCalendarDefaultName"/></th>
          <td>
            <xsl:variable name="defaultTrashCalendar" select="/bedework/system/defaultTrashCalendar"/>
            <input value="{$defaultTrashCalendar}" name="defaultTrashCalendar" />
            <div class="desc">
              <xsl:copy-of select="$bwStr-MdSP-TrashCalendarDefaultNameNote"/>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-UserInboxDefaultName"/></th>
          <td>
            <xsl:variable name="userInbox" select="/bedework/system/userInbox"/>
            <input value="{$userInbox}" name="userInbox" />
            <div class="desc">
              <xsl:copy-of select="$bwStr-MdSP-InboxNote"/>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-UserOutboxDefaultName"/></th>
          <td>
            <xsl:variable name="userOutbox" select="/bedework/system/userOutbox"/>
            <input value="{$userOutbox}" name="userOutbox" />
            <div class="desc">
              <xsl:copy-of select="$bwStr-MdSP-UserOutboxDefaultNameNote"/>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-UserDeletedCalendarDefaultName"/></th>
          <td>
            <xsl:variable name="deletedCalendar" select="/bedework/system/deletedCalendar"/>
            <input value="{$deletedCalendar}" name="deletedCalendar" />
            <div class="desc">
              <xsl:copy-of select="$bwStr-MdSP-UserDeletedCalendarDefaultNameNote"/>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-UserBusyCalendarDefaultName"/></th>
          <td>
            <xsl:variable name="busyCalendar" select="/bedework/system/busyCalendar"/>
            <input value="{$busyCalendar}" name="busyCalendar" />
            <div class="desc">
              <xsl:copy-of select="$bwStr-MdSP-UserBusyCalendarDefaultNameNote"/>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-DefaultUserViewName"/></th>
          <td>
            <xsl:variable name="defaultViewName" select="/bedework/system/defaultUserViewName"/>
            <input value="{$defaultViewName}" name="defaultUserViewName" />
            <div class="desc">
              <xsl:copy-of select="$bwStr-MdSP-DefaultUserViewNameNote"/>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-MaxAttendees"/></th>
          <td>
            <xsl:variable name="maxAttendees" select="/bedework/system/maxAttendees"/>
            <input value="{$maxAttendees}" name="maxAttendees" />
            <div class="desc">
              <xsl:copy-of select="$bwStr-MdSP-MaxAttendeesNote"/>
            </div>
          </td>
        </tr>
        <!--  Following not used
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-HTTPConnectionsPerUser"/></th>
          <td>
            <xsl:variable name="httpPerUser" select="/bedework/system/httpConnectionsPerUser"/>
            <input value="{$httpPerUser}" name="httpConnectionsPerUser" />
            <div class="desc">
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-HTTPConnectionsPerHost"/></th>
          <td>
            <xsl:variable name="httpPerHost" select="/bedework/system/httpConnectionsPerHost"/>
            <input value="{$httpPerHost}" name="httpConnectionsPerHost" />
            <div class="desc">
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-TotalHTTPConnections"/></th>
          <td>
            <xsl:variable name="httpTotal" select="/bedework/system/httpConnections"/>
            <input value="{$httpTotal}" name="httpConnections" />
            <div class="desc">
            </div>
          </td>
        </tr>
        -->
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-MaxLengthPubEventDesc"/></th>
          <td>
            <xsl:variable name="maxPublicDescriptionLength" select="/bedework/system/maxPublicDescriptionLength"/>
            <input value="{$maxPublicDescriptionLength}" name="maxPublicDescriptionLength" />
            <div class="desc">
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-MaxLengthUserEventDesc"/></th>
          <td>
            <xsl:variable name="maxUserDescriptionLength" select="/bedework/system/maxUserDescriptionLength"/>
            <input value="{$maxUserDescriptionLength}" name="maxUserDescriptionLength" />
            <div class="desc">
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-MaxSizeUserEntity"/></th>
          <td>
            <xsl:variable name="maxUserEntitySize" select="/bedework/system/maxUserEntitySize"/>
            <input value="{$maxUserEntitySize}" name="maxUserEntitySize" />
            <div class="desc">
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-DefaultUserQuota"/></th>
          <td>
            <xsl:variable name="defaultUserQuota" select="/bedework/system/defaultUserQuota"/>
            <input value="{$defaultUserQuota}" name="defaultUserQuota" />
            <div class="desc">
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-MaxRecurringInstances"/></th>
          <td>
            <xsl:variable name="maxInstances" select="/bedework/system/maxInstances"/>
            <input value="{$maxInstances}" name="maxInstances" />
            <div class="desc">
              <xsl:copy-of select="$bwStr-MdSP-MaxRecurringInstancesNote"/>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-MaxRecurringYears"/></th>
          <td>
            <xsl:variable name="maxYears" select="/bedework/system/maxYears"/>
            <input value="{$maxYears}" name="maxYears" />
            <div class="desc">
              <xsl:copy-of select="$bwStr-MdSP-MaxRecurringYearsNotes"/>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-UserAuthClass"/></th>
          <td>
            <xsl:variable name="userauthClass" select="/bedework/system/userauthClass"/>
            <input value="{$userauthClass}" name="userauthClass" class="wide"/>
            <div class="desc">
              <xsl:copy-of select="$bwStr-MdSP-UserAuthClassNote"/>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-MailerClass"/></th>
          <td>
            <xsl:variable name="mailerClass" select="/bedework/system/mailerClass"/>
            <input value="{$mailerClass}" name="mailerClass" class="wide"/>
            <div class="desc">
              <xsl:copy-of select="$bwStr-MdSP-MailerClassNote"/>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-AdminGroupsClass"/></th>
          <td>
            <xsl:variable name="admingroupsClass" select="/bedework/system/admingroupsClass"/>
            <input value="{$admingroupsClass}" name="admingroupsClass" class="wide"/>
            <div class="desc">
              <xsl:copy-of select="$bwStr-MdSP-AdminGroupsClassNote"/>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-UserGroupsClass"/></th>
          <td>
            <xsl:variable name="usergroupsClass" select="/bedework/system/usergroupsClass"/>
            <input value="{$usergroupsClass}" name="usergroupsClass" class="wide"/>
            <div class="desc">
              <xsl:copy-of select="$bwStr-MdSP-UserGroupsClassNote"/>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-DirBrowseDisallowd"/></th>
          <td>
            <xsl:variable name="directoryBrowsingDisallowed" select="/bedework/system/directoryBrowsingDisallowed"/>
            <input value="{$directoryBrowsingDisallowed}" name="directoryBrowsingDisallowed" />
            <div class="desc">
              <xsl:copy-of select="$bwStr-MdSP-DirBrowseDisallowedNote"/>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-EvregAdmTkn"/></th>
          <td>
            <xsl:variable name="evregAdmTkn" select="/bedework/system/eventRegAdminToken"/>
            <input value="{$evregAdmTkn}" name="eventRegAdminToken" class="wide"/>
            <div class="desc">
              <xsl:copy-of select="$bwStr-MdSP-EvregAdmTknNote"/>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-GblResPath"/></th>
          <td>
            <xsl:variable name="gblResPath" select="/bedework/system/globalResourcesPath"/>
            <input value="{$gblResPath}" name="globalResourcesPath" class="wide"/>
            <div class="desc">
              <xsl:copy-of select="$bwStr-MdSP-GblResPathNote"/>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-IndexRoot"/></th>
          <td>
            <xsl:variable name="indexRoot" select="/bedework/system/indexRoot"/>
            <input value="{$indexRoot}" name="indexRoot" class="wide"/>
            <div class="desc">
              <xsl:copy-of select="$bwStr-MdSP-IndexRootNote"/>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-UseSolr"/></th>
          <td>
            <xsl:variable name="useSolr" select="/bedework/system/useSolr"/>
            <input value="{$useSolr}" name="useSolr" class="wide"/>
            <div class="desc">
              <xsl:copy-of select="$bwStr-MdSP-UseSolrNote"/>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-SolrURL"/></th>
          <td>
            <xsl:variable name="solrURL" select="/bedework/system/solrURL"/>
            <input value="{$solrURL}" name="solrURL" class="wide"/>
            <div class="desc">
              <xsl:copy-of select="$bwStr-MdSP-SolrURLNote"/>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-SolrCoreAdmin"/></th>
          <td>
            <xsl:variable name="solrCoreAdmin" select="/bedework/system/solrCoreAdmin"/>
            <input value="{$solrCoreAdmin}" name="solrCoreAdmin" class="wide"/>
            <div class="desc">
              <xsl:copy-of select="$bwStr-MdSP-SolrCoreAdminNote"/>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-SolrDefaultCore"/></th>
          <td>
            <xsl:variable name="solrDefaultCore" select="/bedework/system/solrDefaultCore"/>
            <input value="{$solrDefaultCore}" name="solrDefaultCore" class="wide"/>
            <div class="desc">
              <xsl:copy-of select="$bwStr-MdSP-SolrDefaultCoreNote"/>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-SupportedLocales"/></th>
          <td>
            <xsl:variable name="localeList" select="/bedework/system/localeList"/>
            <input value="{$localeList}" name="localeList" class="wide"/>
            <div class="desc">
              <xsl:copy-of select="$bwStr-MdSP-ListOfSupportedLocales"/>
            </div>
          </td>
        </tr>
        <tr>
          <th><xsl:copy-of select="$bwStr-MdSP-DefaultNotifications"/></th>
          <td>
            <xsl:variable name="defaultChangesNotifications" select="/bedework/system/defaultChangesNotifications"/>
            <input value="{$defaultChangesNotifications}" name="defaultChangesNotifications" class="wide"/>
            <div class="desc">
              <xsl:copy-of select="$bwStr-MdSP-DefaultNotificationsNote"/>
            </div>
          </td>
        </tr>
      </table>
      <div class="submitBox">
        <input type="submit" name="updateSystemParams" value="{$bwStr-MdSP-Update}"/>
        <input type="submit" name="cancelled" value="{$bwStr-MdSP-Cancel}"/>
      </div>
    </form>
  </xsl:template>

</xsl:stylesheet>