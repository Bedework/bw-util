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
  xmlns:DAV="DAV:"
  xmlns:CSS="http://calendarserver.org/ns/"
  xmlns:C="urn:ietf:params:xml:ns:caldav"
  xmlns="http://www.w3.org/1999/xhtml">

  <!--== NOTIFICATIONS ==-->
  <xsl:template match="notification">
    <xsl:variable name="position" select="position()"/>

    <xsl:choose>
      <!-- check invite status - look for invite-deleted -->
      <xsl:when test="type = 'invite-notification' and message/CSS:notification/CSS:invite-notification/CSS:invite-deleted">
        <xsl:variable name="sharer"><xsl:value-of select="substring-after(message/CSS:notification/CSS:invite-notification/CSS:organizer/DAV:href,'mailto:')"/></xsl:variable>

        <li class="shareRemove shareNotification" id="shareNotification-{$position}">
          <xsl:copy-of select="$bwStr-Notif-NotificationFrom"/>
          <xsl:text> </xsl:text>
          <em><xsl:value-of select="$sharer"/></em>
          <div class="notificationDialog invisible" id="notificationDialog-{$position}">
            <xsl:attribute name="title"><xsl:copy-of select="$bwStr-Notif-SharingRemoval"/></xsl:attribute>
            <xsl:copy-of select="$bwStr-Notif-TheUser"/><xsl:text> </xsl:text>
            <em><xsl:value-of select="$sharer"/></em><xsl:text> </xsl:text>
            <xsl:copy-of select="$bwStr-Notif-HasRemoved"/><xsl:text> </xsl:text>
            <xsl:value-of select="message/CSS:notification/CSS:invite-notification/CSS:hosturl/DAV:href"/>
          </div>

          <script type="text/javascript">
            $(document).ready(function() {
              $("#notificationDialog-<xsl:value-of select="$position"/>").dialog({
                resizable: false,
                modal: true,
                autoOpen: false,
                buttons: {
                   "<xsl:copy-of select="$bwStr-Notif-Clear"/>" : function() {
                     $("#shareNotification-<xsl:value-of select="$position"/>").hide();
                     $(this).dialog("close");
                     <!-- we need different actions to avoid terminating running transactions -->
                     <xsl:choose>
                       <xsl:when test="$transaction = 'false'">
                         <!-- this action terminates a running transaction -->
                         notificationRemoveReply("<xsl:value-of select="$notifications-remove"/>","<xsl:value-of select="name"/>");
                       </xsl:when>
                       <xsl:otherwise>
                         <!-- this action continues/gets added to a running transaction -->
                         notificationRemoveReply("<xsl:value-of select="$notifications-removeTrans"/>","<xsl:value-of select="name"/>");
                       </xsl:otherwise>
                     </xsl:choose>
                   }
                 }
               });

               $("#shareNotification-<xsl:value-of select="$position"/>").click(function() {
                 $("#notificationDialog-<xsl:value-of select="$position"/>").dialog("open");
               });

            });
          </script>
        </li>
      </xsl:when>
      <xsl:when test="type = 'invite-notification'">
        <xsl:variable name="sharer"><xsl:value-of select="substring-after(message/CSS:notification/CSS:invite-notification/CSS:organizer/DAV:href,'mailto:')"/></xsl:variable>

        <li class="shareInvite shareNotification" id="shareNotification-{$position}">
          <xsl:copy-of select="$bwStr-Notif-InviteFrom"/>
          <xsl:text> </xsl:text>
          <em><xsl:value-of select="$sharer"/></em>
          <div class="notificationDialog invisible" id="notificationDialog-{$position}">
            <xsl:attribute name="title"><xsl:copy-of select="$bwStr-Notif-SharingInvitation"/></xsl:attribute>
            <xsl:copy-of select="$bwStr-Notif-TheUser"/><xsl:text> </xsl:text>
            <em><xsl:value-of select="$sharer"/></em><xsl:text> </xsl:text>
            <xsl:copy-of select="$bwStr-Notif-HasInvited"/><xsl:text> </xsl:text>
            <xsl:value-of select="message/CSS:notification/CSS:invite-notification/CSS:hosturl/DAV:href"/>
          </div>

          <script type="text/javascript">
			      $(document).ready(function() {
			        $("#notificationDialog-<xsl:value-of select="$position"/>").dialog({
			          resizable: false,
			          modal: true,
			          autoOpen: false,
			          buttons: {
			            "<xsl:copy-of select="$bwStr-Notif-Reject"/>" : function() {
			              notificationReply("<xsl:value-of select="$sharing-reply"/>","<xsl:value-of select="name"/>","false","");
			            },
			            "<xsl:copy-of select="$bwStr-Notif-Accept"/>" : function() {
                    notificationReply("<xsl:value-of select="$sharing-reply"/>","<xsl:value-of select="name"/>","true","<xsl:value-of select="message/CSS:notification/CSS:invite-notification/CSS:summary"/>");
			            }
			          }
			        });

			        $("#shareNotification-<xsl:value-of select="$position"/>").click(function() {
			          $("#notificationDialog-<xsl:value-of select="$position"/>").dialog("open");
			        });

			      });
			    </script>
        </li>
      </xsl:when>
      <xsl:when test="type = 'invite-reply'">
        <xsl:variable name="sharee"><xsl:value-of select="substring-after(message/CSS:notification/CSS:invite-reply/DAV:href,'mailto:')"/></xsl:variable>

        <li class="shareReply shareNotification" id="shareNotification-{$position}">
          <xsl:copy-of select="$bwStr-Notif-ReplyFrom"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="$sharee"/>

          <div class="notificationDialog invisible" id="notificationDialog-{$position}">
            <xsl:attribute name="title"><xsl:copy-of select="$bwStr-Notif-SharingReply"/></xsl:attribute>
            <xsl:copy-of select="$bwStr-Notif-TheUser"/><xsl:text> </xsl:text>
            <em><xsl:value-of select="$sharee"/></em><xsl:text> </xsl:text>
            <xsl:choose>
              <xsl:when test="message/CSS:notification/CSS:invite-reply/CSS:invite-declined">
                <span class="declined"><xsl:copy-of select="$bwStr-Notif-HasDeclined"/></span><xsl:text> </xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <span class="accepted"><xsl:copy-of select="$bwStr-Notif-HasAccepted"/></span><xsl:text> </xsl:text>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:value-of select="message/CSS:notification/CSS:invite-reply/CSS:hosturl/DAV:href"/>
          </div>

          <script type="text/javascript">
            $(document).ready(function() {
              $("#notificationDialog-<xsl:value-of select="$position"/>").dialog({
                resizable: false,
                modal: true,
                autoOpen: false,
                buttons: {
                  "<xsl:copy-of select="$bwStr-Notif-Clear"/>" : function() {
                    $("#shareNotification-<xsl:value-of select="$position"/>").hide();
                    $(this).dialog("close");
                    <!-- we need different actions to avoid terminating running transactions -->
                    <xsl:choose>
                      <xsl:when test="$transaction = 'false'">
                        <!-- this action terminates a running transaction -->
                        notificationRemoveReply("<xsl:value-of select="$notifications-remove"/>","<xsl:value-of select="name"/>");
                      </xsl:when>
                      <xsl:otherwise>
                        <!-- this action continues/gets added to a running transaction -->
                        notificationRemoveReply("<xsl:value-of select="$notifications-removeTrans"/>","<xsl:value-of select="name"/>");
                      </xsl:otherwise>
                    </xsl:choose>
                  }
                }
              });

              $("#shareNotification-<xsl:value-of select="$position"/>").click(function() {
                $("#notificationDialog-<xsl:value-of select="$position"/>").dialog("open");
              });

            });
          </script>
        </li>
      </xsl:when>
      <xsl:otherwise>
        <li><xsl:value-of select="type"/></li>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="notificationReplyWidgets"><!-- not yet in use, but will be -->
	  <xsl:if test="/bedework/notifications/notification/type = 'invite-notification'">
	    <div id="sharingColNameWidget" class="invisible">
	      <form id="sharingColNameForm">
	        <fieldset>
	          <label for="sharingColName"><xsl:copy-of select="$bwStr-Notif-CalendarName"/></label>
	          <input type="text" value="" name="sharingColName" id="sharingColName"/>
	        </fieldset>
	      </form>
	    </div>
	  </xsl:if>
  </xsl:template>

  <!-- scheduling messages -->
  <xsl:template match="event" mode="schedNotifications">
    <xsl:variable name="calPath" select="calendar/encodedPath"/>
    <xsl:variable name="eventName" select="name"/>
    <xsl:variable name="entityType" select="entityType"/>
    <xsl:variable name="recurrenceId" select="recurrenceId"/>
    <xsl:variable name="inboxItemAction">
      <xsl:choose>
        <xsl:when test="entityType=7"><xsl:value-of select="$vpoll-initmanage"/></xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="scheduleMethod=2"><xsl:value-of select="$schedule-initAttendeeUpdate"/></xsl:when>
            <xsl:when test="scheduleMethod=3"><xsl:value-of select="$eventView"/></xsl:when>
            <xsl:when test="scheduleMethod=5"><xsl:value-of select="$eventView"/></xsl:when>
            <xsl:when test="scheduleMethod=6"><xsl:value-of select="$schedule-processRefresh"/></xsl:when>
            <xsl:when test="scheduleMethod=7"><xsl:value-of select="$eventView"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="$schedule-initAttendeeUpdate"/></xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="title">
      <xsl:choose>
        <xsl:when test="title != ''"><xsl:value-of select="title"/></xsl:when><!-- title is used for entityType 7 (vpoll) -->
        <xsl:when test="summary != ''"><xsl:value-of select="summary"/></xsl:when><!-- summary is used for other types of events -->
        <xsl:otherwise><xsl:copy-of select="$bwStr-EvCG-NoTitle"/></xsl:otherwise><!-- otherwise show "no title" text -->
      </xsl:choose>
    </xsl:variable>

    <li>
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="entityType=7">bwPollMsg</xsl:when>
          <xsl:otherwise>bwSchMsg</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <a href="{$inboxItemAction}&amp;calPath={$calPath}&amp;eventName={$eventName}&amp;recurrenceId={$recurrenceId}&amp;refinterval=1500">
        <xsl:attribute name="title">
          <xsl:choose>
            <xsl:when test="entityType = 7 ">
              <xsl:choose>
                <xsl:when test="originator = organizer/organizerUri">Poll from </xsl:when>
                <xsl:otherwise>Poll response from </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:when test="scheduleMethod = 3">Meeting reply from </xsl:when>
            <xsl:otherwise>Meeting request for <xsl:value-of select="start/longdate"/> from </xsl:otherwise>
          </xsl:choose>
          <xsl:value-of select="substring-after(originator,'mailto:')"/>
        </xsl:attribute>
        <xsl:if test="scheduleMethod = 3"><xsl:copy-of select="$bwStr-ScN-Re"/><xsl:text> </xsl:text></xsl:if>
        <xsl:value-of select="$title"/>
        <xsl:if test="entityType = 0 and scheduleMethod = 2"><!-- this is an organizers message -->
          - <xsl:value-of select="start/shortdate"/>
        </xsl:if>
      </a>
      <!--From <xsl:value-of select="substring-before(substring-after(originator,'mailto:'),'@')"/>-->
    </li>
  </xsl:template>


</xsl:stylesheet>