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

  <!--==== NOTIFICATIONS ====-->

  <xsl:template name="notifications">
    <xsl:if test="/bedework/notifications/notification/message and
                  (/bedework/userInfo/approverUser = 'true' or
                  (/bedework/userInfo/approverUser = 'false' and
                   /bedework/notifications/notification[type = 'approvalResponse']))">
      <div id="notificationMenu">
        <div id="notificationIcon">
          <span class="ui-icon ui-icon-mail-closed"><xsl:text> </xsl:text></span>
          <span class="notificationCount">
            <xsl:choose>
              <xsl:when test="/bedework/userInfo/approverUser = 'false'"><xsl:value-of select="count(/bedework/notifications/notification[type = 'approvalResponse'])"/></xsl:when>
              <xsl:otherwise><xsl:value-of select="count(/bedework/notifications/notification)"/></xsl:otherwise>
            </xsl:choose>
          </span>
        </div>
        <ul id="notificationMessages">
          <xsl:choose>
            <xsl:when test="/bedework/userInfo/approverUser = 'false'">
              <xsl:apply-templates select="/bedework/notifications/notification[type = 'approvalResponse']" mode="notificationMenu"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="/bedework/notifications/notification" mode="notificationMenu"/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:if test="position() > 5">
            <li class="viewAll"><a href="#">View all notifications</a></li>
          </xsl:if>
        </ul>
      </div>
      <script language="javascript" type="text/javascript">
        $(document).ready(function() {
          $("#notificationMenu").hover(
            function() {
              $("#notificationMessages").fadeIn(100);
            },
            function() {
              $("#notificationMessages").fadeOut(200);
            }
          );
        });
      </script>
    </xsl:if>
  </xsl:template>

  <!-- Match an individual notification for the menu -->
  <xsl:template match="notification" mode="notificationMenu">
    <xsl:variable name="eventTitle">
      <xsl:choose>
        <xsl:when test="resource/summary != ''">
          <strong>"<xsl:value-of select="resource/summary"/>"</strong>
        </xsl:when>
        <xsl:otherwise>
          <em><xsl:value-of select="$bwStr-Notification-EventRemoved"/></em>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <li>
      <xsl:attribute name="id"><xsl:value-of select="name"/></xsl:attribute>

      <a href="#" class="notificationClear" title="{$bwStr-Notification-Dismiss}">
        <xsl:attribute name="href">javascript:bwRemoveNotification('<xsl:value-of select="$notify-remove"/>&amp;name=<xsl:value-of select="name"/>','<xsl:value-of select="name"/>',true);</xsl:attribute>
        <span class="ui-icon ui-icon-circle-close"><xsl:text> </xsl:text></span>
      </a>

      <xsl:choose>
        <!-- suggestions -->
        <xsl:when test="type = 'suggest'">
          <!-- we will set the href to visit the event in question -->
          <a title="{$bwStr-Notification-ViewEvent}" class="suggest">
            <xsl:attribute name="href"><xsl:value-of select="$event-fetchForUpdateSuggestionQueue"/>&amp;href=<xsl:value-of select="resource/href"/></xsl:attribute>
            <xsl:if test="$notificationAutoRemove = 'true'">
              <xsl:attribute name="onclick">javascript:bwRemoveNotification('<xsl:value-of select="$notify-remove"/>&amp;name=<xsl:value-of select="name"/>','<xsl:value-of select="name"/>',false);</xsl:attribute>
            </xsl:if>
            <span class="ui-icon ui-icon-transferthick-e-w"><xsl:text> </xsl:text></span>
            <xsl:variable name="suggester" select="message/node()[local-name()='notification']/node()[local-name()='suggest']/node()[local-name()='suggesterHref']"/>
            <xsl:value-of select="$bwStr-Notification-EventSuggestion"/>
            <xsl:text> </xsl:text>
            <xsl:copy-of select="$eventTitle"/>
            <xsl:text> </xsl:text>
            <em>(<xsl:value-of select="substring-after($suggester, '_')"/>)</em> <!-- XXX this is fragile - need a display name -->
          </a>
        </xsl:when>
        <!-- suggestion replies -->
        <xsl:when test="type = 'suggestReply'">
          <xsl:variable name="reply"><xsl:value-of select="message/node()[local-name()='notification']/node()[local-name()='suggestReply']/node()[local-name()='accepted']"/></xsl:variable>
          <xsl:choose>
            <xsl:when test="$notificationAutoRemove = 'true'">
              <a href="#" title="{$bwStr-Notification-Dismiss}" class="suggestReply {$reply} dismiss">
                <xsl:attribute name="href">javascript:bwRemoveNotification('<xsl:value-of select="$notify-remove"/>&amp;name=<xsl:value-of select="name"/>','<xsl:value-of select="name"/>',true);</xsl:attribute>
                <span class="ui-icon ui-icon-transferthick-e-w"><xsl:text> </xsl:text></span>
                <xsl:variable name="suggestee" select="message/node()[local-name()='notification']/node()[local-name()='suggestReply']/node()[local-name()='suggesteeHref']"/>
                <xsl:value-of select="$bwStr-Notification-SuggestionTo"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="substring-after($suggestee, '_')"/>
                <xsl:text> </xsl:text>
                <xsl:choose>
                  <xsl:when test="$reply = 'true'"><xsl:value-of select="$bwStr-Notification-Accepted"/></xsl:when>
                  <xsl:otherwise><xsl:value-of select="$bwStr-Notification-DeclinedLower"/></xsl:otherwise>
                </xsl:choose>
                <xsl:text> : </xsl:text>
                <xsl:copy-of select="$eventTitle"/>
              </a>
            </xsl:when>
            <xsl:otherwise>
              <span class="suggestReply {$reply}">
                <span class="ui-icon ui-icon-transferthick-e-w"><xsl:text> </xsl:text></span>
                <xsl:variable name="suggestee" select="message/node()[local-name()='notification']/node()[local-name()='suggestReply']/node()[local-name()='suggesteeHref']"/>
                <xsl:value-of select="$bwStr-Notification-SuggestionTo"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="substring-after($suggestee, '_')"/>
                <xsl:text> </xsl:text>
                <xsl:choose>
                  <xsl:when test="$reply = 'true'"><xsl:value-of select="$bwStr-Notification-Accepted"/></xsl:when>
                  <xsl:otherwise><xsl:value-of select="$bwStr-Notification-DeclinedLower"/></xsl:otherwise>
                </xsl:choose>
                <xsl:text> : </xsl:text>
                <xsl:copy-of select="$eventTitle"/>
              </span>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <!-- event awaiting approval -->
        <xsl:when test="type = 'awaitingApproval'">
          <!-- we will set the href to visit the event in question -->
          <a title="{$bwStr-Notification-ViewEvent}" class="awaitingApproval">
            <xsl:attribute name="href"><xsl:value-of select="$event-fetchForUpdateApprovalQueue"/>&amp;href=<xsl:value-of select="resource/href"/></xsl:attribute>
            <xsl:if test="$notificationAutoRemove = 'true'">
              <xsl:attribute name="onclick">javascript: bwRemoveNotification('<xsl:value-of select="$notify-remove"/>&amp;name=<xsl:value-of select="name"/>','<xsl:value-of select="name"/>',false);</xsl:attribute>
            </xsl:if>
            <span class="ui-icon ui-icon-flag"><xsl:text> </xsl:text></span>
            <xsl:value-of select="$bwStr-Notification-Awaiting"/>
            <xsl:text> </xsl:text>
            <xsl:copy-of select="$eventTitle"/>
          </a>
        </xsl:when>
        <!-- approval response -->
        <xsl:when test="type = 'approvalResponse'">
          <xsl:variable name="response"><xsl:value-of select="message/node()[local-name()='notification']/node()[local-name()='approvalResponse']/node()[local-name()='accepted']"/></xsl:variable>
          <xsl:choose>
            <xsl:when test="$notificationAutoRemove = 'true'">
              <a href="#" title="{$bwStr-Notification-Dismiss}" class="approvalResponse {$response} dismiss">
                <xsl:attribute name="href">javascript:bwRemoveNotification('<xsl:value-of select="$notify-remove"/>&amp;name=<xsl:value-of select="name"/>','<xsl:value-of select="name"/>',true);</xsl:attribute>
                <span class="ui-icon ui-icon-flag"><xsl:text> </xsl:text></span>
                <xsl:choose>
                  <xsl:when test="$response = 'true'">
                    <xsl:value-of select="$bwStr-Notification-AcceptedResp"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="$bwStr-Notification-Declined"/>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:text> </xsl:text>
                <xsl:copy-of select="$eventTitle"/>
              </a>
            </xsl:when>
            <xsl:otherwise>
              <span class="ui-icon ui-icon-flag"><xsl:text> </xsl:text></span>
              <xsl:choose>
                <xsl:when test="$response = 'true'">
                  <xsl:value-of select="$bwStr-Notification-AcceptedResp"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$bwStr-Notification-Declined"/>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:text> </xsl:text>
              <xsl:copy-of select="$eventTitle"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <!-- a notification we don't have mapped yet -->
        <xsl:otherwise>
          <xsl:value-of select="type"/>: <xsl:value-of select="name"/>
        </xsl:otherwise>
      </xsl:choose>

    </li>
  </xsl:template>

</xsl:stylesheet>