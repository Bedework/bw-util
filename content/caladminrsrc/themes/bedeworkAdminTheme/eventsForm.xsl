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

  <!--++++++++++++++++++ Add/Edit Event Form ++++++++++++++++++++-->
  <!-- templates:
         - modEvent (the base of the add/edit event form)
         - showEventFormAliases (build the topical area listing in the event form)
         - submitEventButtons

         - weekMonthYearNumbers (utility template)
         - byDayChkBoxList (utility template)
         - buildCheckboxList (utility template)
         - recurrenceDayPosOptions (utility template)
         - buildRecurFields (utility template)
         - buildNumberOptions (utility template)
   -->

  <xsl:template match="formElements" mode="modEvent">
    <xsl:variable name="calPathEncoded" select="form/calendar/event/encodedPath"/>
    <xsl:variable name="calPath" select="form/calendar/event/path"/>
    <xsl:variable name="guid" select="guid"/>
    <xsl:variable name="recurrenceId" select="recurrenceId"/>
    <xsl:variable name="eventTitle" select="form/title/input/@value"/>
    <xsl:variable name="eventUrlPrefix"><xsl:value-of select="$publicCal"/>/event/eventView.do?guid=<xsl:value-of select="$guid"/>&amp;recurrenceId=<xsl:value-of select="$recurrenceId"/></xsl:variable>
    <xsl:variable name="userPath"><xsl:value-of select="/bedework/syspars/userPrincipalRoot"/><xsl:value-of select="/bedework/userInfo/user"/></xsl:variable>

    <!-- Set some booleans for our page types for shorter testing of true and false -->
    <xsl:variable name="modEventPending">
      <xsl:choose>
        <xsl:when test="/bedework/page = 'modEventPending'">true</xsl:when>
        <xsl:otherwise>false</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="modEventApprovalQueue">
      <xsl:choose>
        <xsl:when test="/bedework/page = 'modEventApprovalQueue'">true</xsl:when>
        <xsl:otherwise>false</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="modEventSuggestionQueue">
      <xsl:choose>
        <xsl:when test="/bedework/page = 'modEventSuggestionQueue'">true</xsl:when>
        <xsl:otherwise>false</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- Determine if the current user can edit this event.
         If canEdit is false, we will only allow tagging by topical area,
         and other fields will be disabled. -->
    <xsl:variable name="canEdit">
      <xsl:choose>
        <xsl:when test="($userPath = creator) or
                        ($modEventPending = 'true') or
                        ($modEventApprovalQueue = 'true') or
                        ($superUser = 'true') or
                        (/bedework/creating = 'true')">true</xsl:when>
        <xsl:otherwise>false</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <h2><xsl:copy-of select="$bwStr-AEEF-EventInfo"/></h2>

    <xsl:if test="$canEdit = 'false'">
      <p>
        <xsl:if test="$modEventSuggestionQueue = 'true'">
          <xsl:copy-of select="$bwStr-AEEF-TheFollowingEvent"/><br/>
        </xsl:if>
        <xsl:copy-of select="$bwStr-AEEF-YouMayTag"/>
      </p>
    </xsl:if>

    <xsl:if test="/bedework/page = 'modEventPending'">
      <!-- if a submitted event has topical areas that match with
           those in the calendar suite, convert them -->
      <script type="text/javascript">
      $(document).ready(function() {
        $("ul.aliasTree input:checked").trigger("onclick");
      });
      </script>

      <!-- if a submitted event has comments, display them -->
      <xsl:if test="form/xproperties/node()[name()='X-BEDEWORK-LOCATION' or name()='X-BEDEWORK-CONTACT' or name()='X-BEDEWORK-CATEGORIES' or name()='X-BEDEWORK-SUBMIT-COMMENT']">
        <script type="text/javascript">
          bwSubmitComment = new bwSubmitComment(
            '<xsl:call-template name="escapeApos"><xsl:with-param name="str" select="form/xproperties/node()[name()='X-BEDEWORK-LOCATION']/values/text"/></xsl:call-template>',
            '<xsl:call-template name="escapeApos"><xsl:with-param name="str" select="form/xproperties/node()[name()='X-BEDEWORK-LOCATION']/parameters/node()[name()='X-BEDEWORK-PARAM-SUBADDRESS']"/></xsl:call-template>',
            '<xsl:call-template name="escapeApos"><xsl:with-param name="str" select="form/xproperties/node()[name()='X-BEDEWORK-LOCATION']/parameters/node()[name()='X-BEDEWORK-PARAM-URL']"/></xsl:call-template>',
            '<xsl:call-template name="escapeApos"><xsl:with-param name="str" select="form/xproperties/node()[name()='X-BEDEWORK-CONTACT']/values/text"/></xsl:call-template>',
            '<xsl:call-template name="escapeApos"><xsl:with-param name="str" select="form/xproperties/node()[name()='X-BEDEWORK-CONTACT']/parameters/node()[name()='X-BEDEWORK-PARAM-PHONE']"/></xsl:call-template>',
            '<xsl:call-template name="escapeApos"><xsl:with-param name="str" select="form/xproperties/node()[name()='X-BEDEWORK-CONTACT']/parameters/node()[name()='X-BEDEWORK-PARAM-URL']"/></xsl:call-template>',
            '<xsl:call-template name="escapeApos"><xsl:with-param name="str" select="form/xproperties/node()[name()='X-BEDEWORK-CONTACT']/parameters/node()[name()='X-BEDEWORK-PARAM-EMAIL']"/></xsl:call-template>',
            '<xsl:for-each select="form/xproperties/node()[name()='X-BEDEWORK-SUBMIT-ALIAS']"><xsl:call-template name="escapeApos"><xsl:with-param name="str"><xsl:value-of select="parameters/X-BEDEWORK-PARAM-DISPLAYNAME"/></xsl:with-param></xsl:call-template><br/></xsl:for-each>',
            '<xsl:call-template name="escapeApos"><xsl:with-param name="str" select="form/xproperties/node()[name()='X-BEDEWORK-CATEGORIES']/values/text"/></xsl:call-template>',
            '<xsl:call-template name="escapeJson"><xsl:with-param name="string" select="form/xproperties/node()[name()='X-BEDEWORK-SUBMIT-COMMENT']/values/text"/></xsl:call-template>');
        </script>

        <div id="bwSubmittedEventCommentBlock">
          <div id="bwSubmittedBy">
            <xsl:copy-of select="$bwStr-AEEF-SubmittedBy"/>
            <xsl:text> </xsl:text>
            <xsl:variable name="submitterEmail" select="form/xproperties/node()[name()='X-BEDEWORK-SUBMITTER-EMAIL']/values/text"/>
            <a href="mailto:{$submitterEmail}?subject=[Event%20Submission] {$eventTitle}" title="Email {$submitterEmail}" class="submitter">
              <xsl:value-of select="form/xproperties/node()[name()='X-BEDEWORK-SUBMITTEDBY']/values/text"/>
            </a><xsl:text> </xsl:text>
            (<a href="mailto:{$submitterEmail}?subject=[Event%20Submission] {$eventTitle}" title="Email {$submitterEmail}">
              <img src="{$resourcesRoot}/images/email.gif" alt="*"/>
              <xsl:text> </xsl:text>
              <xsl:copy-of select="$bwStr-AEEF-SendMsg"/>
            </a>)
          </div>
          <h4><xsl:copy-of select="$bwStr-AEEF-CommentsFromSubmitter"/></h4>
          <a href="javascript:toggleVisibility('bwSubmittedEventComment','visible');" class="toggle"><xsl:copy-of select="$bwStr-AEEF-ShowHide"/></a>
          <a href="javascript:bwSubmitComment.launch();" class="toggle"><xsl:copy-of select="$bwStr-AEEF-PopUp"/></a>
          <div id="bwSubmittedEventComment">
            <xsl:if test="/bedework/page = 'modEvent'"><xsl:attribute name="class">invisible</xsl:attribute></xsl:if>
            <xsl:text> </xsl:text>
          </div>
        </div>
        <script type="text/javascript">
          bwSubmitComment.display('bwSubmittedEventComment');
        </script>
      </xsl:if>
    </xsl:if>

    <xsl:variable name="submitter">
      <xsl:choose>
        <xsl:when test="form/xproperties/node()[name()='X-BEDEWORK-SUBMITTEDBY']"><xsl:value-of select="form/xproperties/node()[name()='X-BEDEWORK-SUBMITTEDBY']/values/text"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="/bedework/userInfo/currentUser"/><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-AEEF-For"/><xsl:text> </xsl:text><xsl:value-of select="/bedework/userInfo/group"/> (<xsl:value-of select="/bedework/userInfo/user"/>)</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="creating"><xsl:value-of select="/bedework/creating"/></xsl:variable>
    <form id="bwEventForm" name="eventForm" method="post" enctype="multipart/form-data" onsubmit="return setEventFields(this,{$portalFriendly},'{$submitter}','{$creating}')">
      <xsl:choose>
        <xsl:when test="/bedework/page = 'modEventPending'">
          <xsl:attribute name="action"><xsl:value-of select="$event-updatePending"/></xsl:attribute>
        </xsl:when>
        <xsl:when test="/bedework/page = 'modEventApprovalQueue'">
          <xsl:attribute name="action"><xsl:value-of select="$event-updateApprovalQueue"/></xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="action"><xsl:value-of select="$event-update"/></xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>

      <!-- Provide a placeholder to test which submit button was pressed -->
      <input type="hidden" name="submitVal" value=""/>

      <!-- Set the underlying calendar; if there is more than one publishing calendar, the
           form below will test for that and allow this value to be changed.  -->
      <input type="hidden" name="newCalPath" id="newCalPath">
        <xsl:choose>
          <xsl:when test="not(form/calendar/all/select/option)">
            <xsl:attribute name="value">/public/unbrowsable/workflow/unapproved</xsl:attribute>
          </xsl:when>
          <xsl:when test="/bedework/creating='true'">
            <xsl:attribute name="value"><xsl:value-of select="form/calendar/all/select/option/@value"/></xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="value"><xsl:value-of select="form/calendar/all/select/option[@selected]/@value"/></xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>
      </input>

      <!-- Setup email notification fields -->
      <input type="hidden" id="submitNotification" name="submitNotification" value="false"/>
      <!-- "from" should be a preference: hard code it for now -->
      <input type="hidden" id="snfrom" name="snfrom" value="bedework@yoursite.edu"/>
      <input type="hidden" id="snsubject" name="snsubject" value=""/>
      <input type="hidden" id="sntext" name="sntext" value=""/>

      <xsl:call-template name="submitEventButtons">
        <xsl:with-param name="eventTitle" select="$eventTitle"/>
        <xsl:with-param name="eventUrlPrefix" select="$eventUrlPrefix"/>
        <xsl:with-param name="canEdit" select="$canEdit"/>
        <xsl:with-param name="modEventApprovalQueue" select="$modEventApprovalQueue"/>
        <xsl:with-param name="modEventSuggestionQueue" select="$modEventSuggestionQueue"/>
        <xsl:with-param name="actionPrefix"><xsl:value-of select="$suggest-setStatusForUpdate"/>&amp;calPath=<xsl:value-of select="$calPath"/>&amp;guid=<xsl:value-of select="$guid"/>&amp;recurrenceId=<xsl:value-of select="$recurrenceId"/></xsl:with-param>
        <xsl:with-param name="calPath" select="form/calendar/event/path"/>
        <xsl:with-param name="guid" select="guid"/>
        <xsl:with-param name="recurrenceId" select="recurrenceId"/>
      </xsl:call-template>

      <xsl:if test="$modEventSuggestionQueue = 'true'">
        <div class="suggestionStatus">
          <xsl:value-of select="$bwStr-AEEF-SuggestionStatus"/>
          <xsl:text> </xsl:text>
          <xsl:variable name="suggestStatus">
            <xsl:value-of select="/bedework/suggestions/suggestion[groupHref = /bedework/currentCalSuite/groupHref]/status"/>
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="$suggestStatus = 'P'"><span class="suggestion-suggested"><xsl:value-of select="$bwStr-TaAQ-Suggested"/></span></xsl:when>
            <xsl:when test="$suggestStatus = 'A'"><span class="suggestion-accepted"><xsl:value-of select="$bwStr-TaAQ-Accepted"/></span></xsl:when>
            <xsl:when test="$suggestStatus = 'R'"><span class="suggestion-rejected"><xsl:value-of select="$bwStr-TaAQ-Rejected"/></span></xsl:when>
            <xsl:otherwise><xsl:value-of select="$bwStr-TaAQ-Unknown"/></xsl:otherwise>
          </xsl:choose>
        </div>
      </xsl:if>

      <table class="eventFormTable" title="Event Modification Form">
        <xsl:if test="$canEdit = 'false'">
          <xsl:if test="creator = /bedework/userInfo/groups//group/ownerHref">
            <xsl:variable name="evCreator"><xsl:value-of select="creator"/></xsl:variable>
            <!--
            <xsl:variable name="switchGroupUrl">
              <xsl:value-of select="$setup"/>&amp;adminGroupName=<xsl:value-of select="/bedework/userInfo/groups/group[ownerHref = $evCreator]/name"/>
            </xsl:variable>
            -->
            <tr>
              <td colspan="2">
                <div class="bwHighlightBox">
                  <xsl:value-of select="$bwStr-AEEF-ChangeGroup1"/><strong><xsl:value-of select="/bedework/userInfo/groups/group[ownerHref = $evCreator]/name"/></strong><xsl:copy-of select="$bwStr-AEEF-ChangeGroup2"/>
                  <a href="{$admingroup-switch}"><xsl:value-of select="$bwStr-AEEF-ChangeGroup3"/></a>
                </div>
              </td>
            </tr>
          </xsl:if>
        </xsl:if>
        <tr>
          <td class="fieldName">
            <label for="bwSummary"><xsl:copy-of select="$bwStr-AEEF-Title"/></label>
          </td>
          <td>
            <input type="text" size="60" name="summary" id="bwSummary" required="required">
              <xsl:attribute name="value"><xsl:value-of select="form/title/input/@value"/></xsl:attribute>
              <xsl:if test="$canEdit = 'false'"><xsl:attribute name="class">invisible</xsl:attribute></xsl:if>
            </input>
            <xsl:if test="$canEdit = 'false'">
              <div class="bwHighlightBox">
                <strong><xsl:value-of select="form/title/input/@value"/></strong>
              </div>
            </xsl:if>
          </td>
        </tr>
        <xsl:if test="form/deleted/input/@checked='checked'">
          <tr>
            <td class="fieldName">
              <label for="bwDeleted"><xsl:copy-of select="$bwStr-AEEF-Deleted"/></label>
            </td>
            <td>
              <input type="checkbox" name="deleted" id="bwDeleted" checked="checked"/>
            </td>
          </tr>
        </xsl:if>
        <!--
                <tr>
                  <xsl:if test="$canEdit = 'false'"><xsl:attribute name="class">invisible</xsl:attribute></xsl:if>
                  <td class="fieldName">
                    <xsl:copy-of select="$bwStr-AEEF-Type"/>
                  </td>
                  <td>
                    <input type="radio" name="entityType" value="1"/><xsl:copy-of select="$bwStr-AEEF-Event"/>
                    <input type="radio" name="entityType" value="2"/><xsl:copy-of select="$bwStr-AEEF-Deadline"/>
                  </td>
                </tr>
        -->
        <xsl:if test="count(form/calendar/all/select/option) &gt; 1 and
                      not(starts-with(form/calendar/event/path,$submissionsRootUnencoded)) and
                      not(starts-with(form/calendar/event/path,$workflowRootUnencoded))">
          <!-- check to see if we have more than one publishing calendar
             but disallow directly setting for pending events -->
          <tr>
            <xsl:if test="$canEdit = 'false'"><xsl:attribute name="class">invisible</xsl:attribute></xsl:if>
            <td class="fieldName">
              <label>
                <xsl:attribute name="for">
                  <xsl:choose>
                    <xsl:when test="form/calendar/preferred/select/option">bwPreferredCalendars</xsl:when>
                    <xsl:otherwise>bwAllCalendars</xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
                <xsl:copy-of select="$bwStr-AEEF-Calendar"/>
              </label>
            </td>
            <td>
              <xsl:if test="form/calendar/preferred/select/option">
                <!-- Display the preferred calendars by default if they exist -->
                <select name="bwPreferredCalendars" id="bwPreferredCalendars" onchange="this.form.newCalPath.value = this.value">

                  <option value="">
                    <xsl:copy-of select="$bwStr-AEEF-SelectColon"/>
                  </option>
                  <xsl:for-each select="form/calendar/preferred/select/option">
                    <xsl:sort select="." order="ascending"/>
                    <option>
                      <xsl:attribute name="value"><xsl:value-of select="@value"/></xsl:attribute>
                      <xsl:if test="@selected"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
                      <xsl:choose>
                        <xsl:when test="starts-with(node(),/bedework/submissionsRoot/unencoded)">
                          <xsl:copy-of select="$bwStr-AEEF-SubmittedEvents"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="substring-after(node(),'/public/')"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </option>
                  </xsl:for-each>
                </select>
              </xsl:if>
              <!-- hide the listing of all calendars if preferred calendars exist, otherwise show them -->
              <select name="bwAllCalendars" id="bwAllCalendars" onchange="this.form.newCalPath.value = this.value;">

                <xsl:if test="form/calendar/preferred/select/option">
                  <xsl:attribute name="class">invisible</xsl:attribute>
                </xsl:if>
                <option value="">
                  <xsl:copy-of select="$bwStr-AEEF-SelectColon"/>
                </option>
                <xsl:for-each select="form/calendar/all/select/option">
                  <xsl:sort select="." order="ascending"/>
                  <option>
                    <xsl:attribute name="value"><xsl:value-of select="@value"/></xsl:attribute>
                    <xsl:if test="@selected"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
                    <xsl:choose>
                      <xsl:when test="starts-with(node(),/bedework/submissionsRoot/unencoded)">
                        <xsl:copy-of select="$bwStr-AEEF-SubmittedEvents"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="substring-after(node(),'/public/')"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </option>
                </xsl:for-each>
              </select>
              <xsl:text> </xsl:text>
              <!-- allow for toggling between the preferred and all calendars listings if preferred
                   calendars exist -->
              <xsl:if test="form/calendar/preferred/select/option">
                <input type="radio" name="toggleCalendarLists" id="toggleCalendarListsPreferred" value="preferred" checked="checked" onclick="changeClass('bwPreferredCalendars','shown');changeClass('bwAllCalendars','invisible');this.form.newCalPath.value = this.form.bwPreferredCalendars.value;"/>
                <label for="toggleCalendarListsPreferred"><xsl:copy-of select="$bwStr-AEEF-Preferred"/></label>
                <input type="radio" name="toggleCalendarLists" id="toggleCalendarListsAll" value="all" onclick="changeClass('bwPreferredCalendars','invisible');changeClass('bwAllCalendars','shown');this.form.newCalPath.value = this.form.bwAllCalendars.value;"/>
                <label for="toggleCalendarListsAll"><xsl:copy-of select="$bwStr-AEEF-All"/></label>
              </xsl:if>
            </td>
          </tr>
        </xsl:if>

        <tr>
          <xsl:if test="$canEdit = 'false'"><xsl:attribute name="class">invisible</xsl:attribute></xsl:if>
          <td class="fieldName">
            <xsl:copy-of select="$bwStr-AEEF-DateAndTime"/>
          </td>
          <td>
            <!-- Set the timefields class for the first load of the page;
                 subsequent changes will take place using javascript without a
                 page reload. -->
            <xsl:variable name="timeFieldsClass">
              <xsl:choose>
                <xsl:when test="form/allDay/input/@checked='checked'">invisible</xsl:when>
                <xsl:otherwise>timeFields</xsl:otherwise>
              </xsl:choose>
            </xsl:variable>

            <!-- All day flag -->
            <input type="checkbox" name="allDayFlag" id="allDayFlag" onclick="swapAllDayEvent(this)" value="off">
              <xsl:if test="form/allDay/input/@checked='checked'">
                <xsl:attribute name="checked">checked</xsl:attribute>
                <xsl:attribute name="value">on</xsl:attribute>
              </xsl:if>
            </input>
            <input type="hidden" name="eventStartDate.dateOnly" value="off" id="allDayStartDateField">
              <xsl:if test="form/allDay/input/@checked='checked'">
                <xsl:attribute name="value">on</xsl:attribute>
              </xsl:if>
            </input>
            <input type="hidden" name="eventEndDate.dateOnly" value="off" id="allDayEndDateField">
              <xsl:if test="form/allDay/input/@checked='checked'">
                <xsl:attribute name="value">on</xsl:attribute>
              </xsl:if>
            </input>
            <label for="allDayFlag">
              <xsl:copy-of select="$bwStr-AEEF-AllDay"/>
            </label>

            <!-- floating event: no timezone (and not UTC) --><!-- let's hide it completely unless it comes in checked
                 (e.g. from import); to restore this field, remove the if  -->
            <xsl:if test="form/floating/input/@checked='checked'">
              <input type="checkbox" name="floatingFlag" id="floatingFlag" onclick="swapFloatingTime(this)" value="off">
                <xsl:if test="form/floating/input/@checked='checked'">
                  <xsl:attribute name="checked">checked</xsl:attribute>
                  <xsl:attribute name="value">on</xsl:attribute>
                </xsl:if>
              </input>
              <input type="hidden" name="eventStartDate.floating" value="off" id="startFloating">
                <xsl:if test="form/floating/input/@checked='checked'">
                  <xsl:attribute name="value">on</xsl:attribute>
                </xsl:if>
              </input>
              <input type="hidden" name="eventEndDate.floating" value="off" id="endFloating">
                <xsl:if test="form/floating/input/@checked='checked'">
                  <xsl:attribute name="value">on</xsl:attribute>
                </xsl:if>
              </input>
              <label for="floatingFlag">
                <xsl:copy-of select="$bwStr-AEEF-Floating"/>
              </label>
            </xsl:if>

            <!-- store time as coordinated universal time (UTC) --><!-- like floating time, let's hide UTC completely unless an
                 event comes in checked; (e.g. from import);
                 to restore this field, remove the if -->
            <xsl:if test="form/storeUTC/input/@checked='checked'">
              <input type="checkbox" name="storeUTCFlag" id="storeUTCFlag" onclick="swapStoreUTC(this)" value="off">
                <xsl:if test="form/storeUTC/input/@checked='checked'">
                  <xsl:attribute name="checked">checked</xsl:attribute>
                  <xsl:attribute name="value">on</xsl:attribute>
                </xsl:if>
              </input>
              <input type="hidden" name="eventStartDate.storeUTC" value="off" id="startStoreUTC">
                <xsl:if test="form/storeUTC/input/@checked='checked'">
                  <xsl:attribute name="value">on</xsl:attribute>
                </xsl:if>
              </input>
              <input type="hidden" name="eventEndDate.storeUTC" value="off" id="endStoreUTC">
                <xsl:if test="form/storeUTC/input/@checked='checked'">
                  <xsl:attribute name="value">on</xsl:attribute>
                </xsl:if>
              </input>
              <xsl:copy-of select="$bwStr-AEEF-StoreAsUTC"/>
            </xsl:if>

            <br/>
            <fieldset class="dateStartEndBox">
              <legend><xsl:copy-of select="$bwStr-AEEF-Start"/></legend>
              <div class="dateFields">
                <label class="startDateLabel" for="bwEventWidgetStartDate"><xsl:copy-of select="$bwStr-AEEF-Date"/><xsl:text> </xsl:text></label>
                <xsl:choose>
                  <xsl:when test="$portalFriendly = 'true'">
                    <xsl:copy-of select="form/start/month/*"/>
                    <xsl:copy-of select="form/start/day/*"/>
                    <xsl:choose>
                      <xsl:when test="/bedework/creating = 'true'">
                        <xsl:copy-of select="form/start/year/*"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:copy-of select="form/start/yearText/*"/>
                      </xsl:otherwise>
                    </xsl:choose>
                    <script type="text/javascript">
                      <xsl:comment>
                      startDateDynCalWidget = new dynCalendar('startDateDynCalWidget', <xsl:value-of select="number(form/start/yearText/input/@value)"/>, <xsl:value-of select="number(form/start/month/select/option[@selected='selected']/@value)-1"/>, <xsl:value-of select="number(form/start/day/select/option[@selected='selected']/@value)"/>, 'startDateCalWidgetCallback',true,'<xsl:value-of select="$resourcesRoot"/>/resources/');
                      </xsl:comment>
                    </script>
                  </xsl:when>
                  <xsl:otherwise>
                    <input type="text" name="bwEventWidgetStartDate" id="bwEventWidgetStartDate" size="10"/>
                    <script type="text/javascript">
                      <xsl:comment>
                      /*$("#bwEventWidgetStartDate").datepicker({
                        defaultDate: new Date(<xsl:value-of select="form/start/yearText/input/@value"/>, <xsl:value-of select="number(form/start/month/select/option[@selected = 'selected']/@value) - 1"/>, <xsl:value-of select="form/start/day/select/option[@selected = 'selected']/@value"/>)
                      }).attr("readonly", "readonly");
                      $("#bwEventWidgetStartDate").val('<xsl:value-of select="substring-before(form/start/rfc3339DateTime,'T')"/>');*/
                      </xsl:comment>
                    </script>
                    <input type="hidden" name="eventStartDate.year">
                      <xsl:attribute name="value"><xsl:value-of select="form/start/yearText/input/@value"/></xsl:attribute>
                    </input>
                    <input type="hidden" name="eventStartDate.month">
                      <xsl:attribute name="value"><xsl:value-of select="form/start/month/select/option[@selected = 'selected']/@value"/></xsl:attribute>
                    </input>
                    <input type="hidden" name="eventStartDate.day">
                      <xsl:attribute name="value"><xsl:value-of select="form/start/day/select/option[@selected = 'selected']/@value"/></xsl:attribute>
                    </input>
                  </xsl:otherwise>
                </xsl:choose>
              </div>
              <div class="{$timeFieldsClass}" id="startTimeFields">
                <span id="calWidgetStartTimeHider" class="show">
                  <select name="eventStartDate.hour" id="eventStartDateHour" title="{$bwStr-AEEF-StartDateHour}">
                    <xsl:copy-of select="form/start/hour/select/*"/>
                  </select>
                  <select name="eventStartDate.minute" id="eventStartDateMinute" title="{$bwStr-AEEF-StartDateMinute}">
                    <xsl:copy-of select="form/start/minute/select/*"/>
                  </select>
                  <xsl:if test="form/start/ampm">
                    <select name="eventStartDate.ampm" id="eventStartDateAmpm" title="{$bwStr-AEEF-StartDateAmPm}">
                      <xsl:copy-of select="form/start/ampm/select/*"/>
                    </select>
                  </xsl:if>
                  <xsl:text> </xsl:text>
                  <img src="{$resourcesRoot}/images/clockIcon.gif" width="16" height="15" id="bwStartClock" alt="*"/>

                  <select name="eventStartDate.tzid" id="startTzid" class="timezones" title="{$bwStr-AEEF-StartDateTimezone}">
                    <xsl:if test="form/floating/input/@checked='checked'"><xsl:attribute name="disabled">disabled</xsl:attribute></xsl:if>
                    <option value="-1"><xsl:copy-of select="$bwStr-AEEF-SelectTimezone"/></option>
                    <xsl:variable name="startTzId" select="form/start/tzid"/>
                    <xsl:for-each select="/bedework/timezones/timezone">
                      <option>
                        <xsl:attribute name="value"><xsl:value-of select="id"/></xsl:attribute>
                        <xsl:if test="$startTzId = id"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
                        <xsl:value-of select="name"/>
                      </option>
                    </xsl:for-each>
                  </select>
                </span>
              </div>
            </fieldset>
            <fieldset class="dateStartEndBox">
              <legend><xsl:copy-of select="$bwStr-AEEF-End"/></legend>
              <xsl:choose>
                <xsl:when test="form/end/type='E'">
                  <input type="radio" name="eventEndType" id="bwEndDateTimeButton" value="E" checked="checked" onclick="changeClass('endDateTime','shown');changeClass('endDuration','invisible');"/>
                </xsl:when>
                <xsl:otherwise>
                  <input type="radio" name="eventEndType" id="bwEndDateTimeButton" value="E" onclick="changeClass('endDateTime','shown');changeClass('endDuration','invisible');"/>
                </xsl:otherwise>
              </xsl:choose>
              <label for="bwEndDateTimeButton">
                <xsl:copy-of select="$bwStr-AEEF-Date"/>
              </label>
              <xsl:variable name="endDateTimeClass">
                <xsl:choose>
                  <xsl:when test="form/end/type='E'">shown</xsl:when>
                  <xsl:otherwise>invisible</xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              <div class="{$endDateTimeClass}" id="endDateTime">
                <div class="dateFields">
                  <xsl:choose>
                    <xsl:when test="$portalFriendly = 'true'">
                      <xsl:copy-of select="form/end/dateTime/month/*"/>
                      <xsl:copy-of select="form/end/dateTime/day/*"/>
                      <xsl:choose>
                        <xsl:when test="/bedework/creating = 'true'">
                          <xsl:copy-of select="form/end/dateTime/year/*"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:copy-of select="form/end/dateTime/yearText/*"/>
                        </xsl:otherwise>
                      </xsl:choose>
                      <script type="text/javascript">
                        <xsl:comment>
                        endDateDynCalWidget = new dynCalendar('endDateDynCalWidget', <xsl:value-of select="number(form/start/yearText/input/@value)"/>, <xsl:value-of select="number(form/start/month/select/option[@selected='selected']/@value)-1"/>, <xsl:value-of select="number(form/start/day/select/option[@selected='selected']/@value)"/>, 'endDateCalWidgetCallback',true,'<xsl:value-of select="$resourcesRoot"/>/resources/');
                        </xsl:comment>
                      </script>
                    </xsl:when>
                    <xsl:otherwise>
                      <input type="text" name="bwEventWidgetEndDate" id="bwEventWidgetEndDate" size="10" title="{$bwStr-AEEF-EndDate}"/>
                      <script type="text/javascript">
                        <xsl:comment>
                        /*$("#bwEventWidgetEndDate").datepicker({
                          defaultDate: new Date(<xsl:value-of select="form/end/dateTime/yearText/input/@value"/>, <xsl:value-of select="number(form/end/dateTime/month/select/option[@selected = 'selected']/@value) - 1"/>, <xsl:value-of select="form/end/dateTime/day/select/option[@selected = 'selected']/@value"/>)
                        }).attr("readonly", "readonly");
                        $("#bwEventWidgetEndDate").val('<xsl:value-of select="substring-before(form/end/rfc3339DateTime,'T')"/>');*/
                        </xsl:comment>
                      </script>
                      <input type="hidden" name="eventEndDate.year">
                        <xsl:attribute name="value"><xsl:value-of select="form/end/dateTime/yearText/input/@value"/></xsl:attribute>
                      </input>
                      <input type="hidden" name="eventEndDate.month">
                        <xsl:attribute name="value"><xsl:value-of select="form/end/dateTime/month/select/option[@selected = 'selected']/@value"/></xsl:attribute>
                      </input>
                      <input type="hidden" name="eventEndDate.day">
                        <xsl:attribute name="value"><xsl:value-of select="form/end/dateTime/day/select/option[@selected = 'selected']/@value"/></xsl:attribute>
                      </input>
                    </xsl:otherwise>
                  </xsl:choose>
                </div>
                <div class="{$timeFieldsClass}" id="endTimeFields">
                  <span id="calWidgetEndTimeHider" class="show">
                    <select name="eventEndDate.hour" id="eventEndDateHour" title="{$bwStr-AEEF-EndDateHour}">
                      <xsl:copy-of select="form/end/dateTime/hour/select/*"/>
                    </select>
                    <select name="eventEndDate.minute" id="eventEndDateMinute" title="{$bwStr-AEEF-EndDateMinute}">
                      <xsl:copy-of select="form/end/dateTime/minute/select/*"/>
                    </select>
                    <xsl:if test="form/start/ampm">
                      <select name="eventEndDate.ampm" id="eventEndDateAmpm" title="{$bwStr-AEEF-EndDateAmPm}">
                        <xsl:copy-of select="form/end/dateTime/ampm/select/*"/>
                      </select>
                    </xsl:if>
                    <xsl:text> </xsl:text>
                    <img src="{$resourcesRoot}/images/clockIcon.gif" width="16" height="15" id="bwEndClock" alt="*"/>

                    <select name="eventEndDate.tzid" id="endTzid" class="timezones" title="{$bwStr-AEEF-EndDateTimezone}">
                      <xsl:if test="form/floating/input/@checked='checked'"><xsl:attribute name="disabled">disabled</xsl:attribute></xsl:if>
                      <option value="-1"><xsl:copy-of select="$bwStr-AEEF-SelectTimezone"/></option>
                      <xsl:variable name="endTzId" select="form/end/dateTime/tzid"/>
                      <xsl:for-each select="/bedework/timezones/timezone">
                        <option>
                          <xsl:attribute name="value"><xsl:value-of select="id"/></xsl:attribute>
                          <xsl:if test="$endTzId = id"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
                          <xsl:value-of select="name"/>
                        </option>
                      </xsl:for-each>
                    </select>
                  </span>
                </div>
              </div>
              <br/>
              <div class="dateFields">
                <xsl:choose>
                  <xsl:when test="form/end/type='D'">
                    <input type="radio" name="eventEndType" id="bwEndDurationButton" value="D" checked="checked" onclick="changeClass('endDateTime','invisible');changeClass('endDuration','shown');"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <input type="radio" name="eventEndType" id="bwEndDurationButton" value="D" onclick="changeClass('endDateTime','invisible');changeClass('endDuration','shown');"/>
                  </xsl:otherwise>
                </xsl:choose>
                <label for="bwEndDurationButton">
                  <xsl:copy-of select="$bwStr-AEEF-Duration"/>
                </label>
                <xsl:variable name="endDurationClass">
                  <xsl:choose>
                    <xsl:when test="form/end/type='D'">shown</xsl:when>
                    <xsl:otherwise>invisible</xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <xsl:variable name="durationHrMinClass">
                  <xsl:choose>
                    <xsl:when test="form/allDay/input/@checked='checked'">invisible</xsl:when>
                    <xsl:otherwise>shown</xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <div class="{$endDurationClass}" id="endDuration">
                  <xsl:choose>
                    <xsl:when test="form/end/duration/weeks/input/@value = '0'">
                      <!-- we are using day, hour, minute format --><!-- must send either no week value or week value of 0 (zero) -->
                      <div class="durationBox">
                        <input type="radio" name="eventDuration.type" value="daytime" onclick="swapDurationType('daytime')" checked="checked"/>
                        <input type="text" name="eventDuration.daysStr" size="2" id="durationDays">
                          <xsl:attribute name="value"><xsl:value-of select="form/end/duration/days/input/@value"/></xsl:attribute>
                        </input><xsl:copy-of select="$bwStr-AEEF-Days"/>
                        <span id="durationHrMin" class="{$durationHrMinClass}">
                          <input type="text" name="eventDuration.hoursStr" size="2" id="durationHours">
                            <xsl:attribute name="value"><xsl:value-of select="form/end/duration/hours/input/@value"/></xsl:attribute>
                          </input><xsl:copy-of select="$bwStr-AEEF-Hours"/>
                          <input type="text" name="eventDuration.minutesStr" size="2" id="durationMinutes">
                            <xsl:attribute name="value"><xsl:value-of select="form/end/duration/minutes/input/@value"/></xsl:attribute>
                          </input><xsl:copy-of select="$bwStr-AEEF-Minutes"/>
                        </span>
                      </div>
                      <span class="durationSpacerText"><xsl:copy-of select="$bwStr-AEEF-Or"/></span>
                      <div class="durationBox">
                        <input type="radio" name="eventDuration.type" value="weeks" onclick="swapDurationType('week')"/>
                        <input type="text" name="eventDuration.weeksStr" size="2" id="durationWeeks" disabled="disabled">
                          <xsl:attribute name="value"><xsl:value-of select="form/end/duration/weeks/input/@value"/></xsl:attribute>
                        </input><xsl:copy-of select="$bwStr-AEEF-Weeks"/>
                      </div>
                    </xsl:when>
                    <xsl:otherwise>
                      <!-- we are using week format -->
                      <div class="durationBox">
                        <input type="radio" name="eventDuration.type" value="daytime" onclick="swapDurationType('daytime')"/>
                        <xsl:variable name="daysStr" select="form/end/duration/days/input/@value"/>
                        <input type="text" name="eventDuration.daysStr" size="2" value="{$daysStr}" id="durationDays" disabled="disabled"/><xsl:copy-of select="$bwStr-AEEF-Days"/>
                        <span id="durationHrMin" class="{$durationHrMinClass}">
                          <xsl:variable name="hoursStr" select="form/end/duration/hours/input/@value"/>
                          <input type="text" name="eventDuration.hoursStr" size="2" value="{$hoursStr}" id="durationHours" disabled="disabled"/><xsl:copy-of select="$bwStr-AEEF-Hours"/>
                          <xsl:variable name="minutesStr" select="form/end/duration/minutes/input/@value"/>
                          <input type="text" name="eventDuration.minutesStr" size="2" value="{$minutesStr}" id="durationMinutes" disabled="disabled"/><xsl:copy-of select="$bwStr-AEEF-Minutes"/>
                        </span>
                      </div>
                      <span class="durationSpacerText">or</span>
                      <div class="durationBox">
                        <input type="radio" name="eventDuration.type" value="weeks" onclick="swapDurationType('week')" checked="checked"/>
                        <input type="text" name="eventDuration.weeksStr" size="2" id="durationWeeks">
                          <xsl:attribute name="value"><xsl:value-of select="form/end/duration/weeks/input/@value"/></xsl:attribute>
                        </input><xsl:copy-of select="$bwStr-AEEF-Weeks"/>
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </div>
              </div>
              <br/>
              <div class="dateFields" id="noDuration">
                <xsl:choose>
                  <xsl:when test="form/end/type='N'">
                    <input type="radio" name="eventEndType" id="bwEndNoneButton" value="N" checked="checked" onclick="changeClass('endDateTime','invisible');changeClass('endDuration','invisible');"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <input type="radio" name="eventEndType" id="bwEndNoneButton" value="N" onclick="changeClass('endDateTime','invisible');changeClass('endDuration','invisible');"/>
                  </xsl:otherwise>
                </xsl:choose>
                <label for="bwEndNoneButton">
                  <xsl:copy-of select="$bwStr-AEEF-ThisEventHasNoDurationEndDate"/>
                </label>
              </div>
            </fieldset>
          </td>
        </tr>
        <xsl:if test="$canEdit = 'false'">
          <!-- admin user can't edit this, so just dispaly some useful information -->
          <tr>
            <td class="fieldName">
              <xsl:copy-of select="$bwStr-AEEF-DateAndTime"/>
            </td>
            <td>
              <xsl:value-of select="form/start/month/select/option[@selected]"/><xsl:text> </xsl:text>
              <xsl:value-of select="form/start/day/select/option[@selected]"/><xsl:text> </xsl:text>
              <xsl:value-of select="form/start/yearText/input/@value"/><xsl:text>, </xsl:text>
              <xsl:value-of select="form/start/hour/select/option[@selected]"/>:<xsl:value-of select="form/start/minute/select/option[@selected]"/><xsl:text> </xsl:text>
              <xsl:value-of select="form/start/ampm/select/option[@selected]"/><xsl:text> </xsl:text>
              <xsl:if test="form/allDay/input/@checked='checked'">(all day)<xsl:text> </xsl:text></xsl:if>
              <xsl:if test="form/start/tzid != form/end/dateTime/tzid"><xsl:value-of select="form/start/tzid"/></xsl:if>
              <xsl:if test="form/start/rfc3339DateTime != form/end/rfc3339DateTime">
                -
                <xsl:if test="substring(form/start/rfc3339DateTime,1,10) != substring(form/end/rfc3339DateTime,1,10)">
                  <xsl:value-of select="form/end/dateTime/month/select/option[@selected]"/><xsl:text> </xsl:text>
                  <xsl:value-of select="form/end/dateTime/day/select/option[@selected]"/><xsl:text> </xsl:text>
                  <xsl:value-of select="form/end/dateTime/yearText/input/@value"/><xsl:text>, </xsl:text>
                </xsl:if>
                <xsl:if test="substring(form/start/rfc3339DateTime,12,16) != substring(form/end/rfc3339DateTime,12,16)">
                  <xsl:value-of select="form/end/dateTime/hour/select/option[@selected]"/>:<xsl:value-of select="form/end/dateTime/minute/select/option[@selected]"/><xsl:text> </xsl:text>
                  <xsl:value-of select="form/end/dateTime/ampm/select/option[@selected]"/><xsl:text> </xsl:text>
                  <xsl:value-of select="form/end/dateTime/tzid"/>
                </xsl:if>
              </xsl:if>
            </td>
          </tr>
        </xsl:if>

        <!-- Recurrence fields --><!-- ================= -->
        <tr>
          <xsl:if test="($canEdit = 'false') and (form/recurringEntity = 'false') and (recurrenceId = '')"><xsl:attribute name="class">invisible</xsl:attribute></xsl:if>
          <td class="fieldName">
            <xsl:copy-of select="$bwStr-AEEF-RECURRANCE"/>
          </td>
          <td>
            <xsl:choose>
              <xsl:when test="recurrenceId != ''">
                <!-- recurrence instances can not themselves recur,
                     so provide access to master event -->
                <em><xsl:copy-of select="$bwStr-AEEF-ThisEventRecurrenceInstance"/></em><br/>
                <xsl:choose>
                  <xsl:when test="starts-with(form/calendar/event/path,$submissionsRootUnencoded)">
                    <a href="{$event-fetchForUpdatePending}&amp;calPath={$calPath}&amp;guid={$guid}" title="{$bwStr-AEEF-EditMaster}"><xsl:copy-of select="$bwStr-AEEF-EditPendingMasterEvent"/></a>
                  </xsl:when>
                  <xsl:when test="starts-with(form/calendar/event/path,$workflowRootUnencoded)">
                    <a href="{$event-fetchForUpdateApprovalQueue}&amp;calPath={$calPath}&amp;guid={$guid}" title="{$bwStr-AEEF-EditMaster}"><xsl:copy-of select="$bwStr-AEEF-EditPendingMasterEvent"/></a>
                  </xsl:when>
                  <xsl:otherwise>
                    <a href="{$event-fetchForUpdate}&amp;calPath={$calPath}&amp;guid={$guid}" title="{$bwStr-AEEF-EditMaster}"><xsl:copy-of select="$bwStr-AEEF-EditMasterEvent"/></a>
                  </xsl:otherwise>
                </xsl:choose>

              </xsl:when>
              <xsl:otherwise>
                <!-- has recurrenceId, so is master -->

                <xsl:choose>
                  <xsl:when test="form/recurringEntity = 'false'">
                    <!-- the switch is required to turn recurrence on - maybe we can infer this instead? -->
                    <div id="recurringSwitch">
                      <xsl:if test="$canEdit = 'false'"><xsl:attribute name="class">invisible</xsl:attribute></xsl:if>
                      <!-- set or remove "recurring" and show or hide all recurrence fields: -->
                      <input type="radio" name="recurring" id="bwRecurringOnButton" value="true" onclick="swapRecurrence(this)">
                        <xsl:if test="form/recurringEntity = 'true'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
                      </input>
                      <label for="bwRecurringOnButton">
                        <xsl:copy-of select="$bwStr-AEEF-EventRecurs"/>
                      </label>
                      <input type="radio" name="recurring" id="bwRecurringOffButton" value="false" onclick="swapRecurrence(this)">
                        <xsl:if test="form/recurringEntity = 'false'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
                      </input>
                      <label for="bwRecurringOffButton">
                        <xsl:copy-of select="$bwStr-AEEF-EventDoesNotRecur"/>
                      </label>
                    </div>
                  </xsl:when>
                  <xsl:otherwise>
                    <!-- is a recurring event; once created as such, it can no longer be made non-recurring. -->
                    <input type="hidden" name="recurring" value="true"/>
                  </xsl:otherwise>
                </xsl:choose>

                <!-- wrapper for all recurrence fields (rrules and rdates): -->
                <div id="recurrenceFields" class="invisible">
                  <xsl:if test="form/recurringEntity = 'true'"><xsl:attribute name="class">visible</xsl:attribute></xsl:if>

                  <h4>
                    <xsl:if test="$canEdit = 'false'"><xsl:attribute name="class">invisible</xsl:attribute></xsl:if>
                    <xsl:copy-of select="$bwStr-AEEF-RecurrenceRules"/>
                  </h4>
                  <!-- show or hide rrules fields when editing: -->
                  <xsl:if test="form/recurrence">
                    <span id="rrulesSwitch">
                      <xsl:if test="$canEdit = 'false'"><xsl:attribute name="class">invisible</xsl:attribute></xsl:if>
                      <input type="checkbox" name="rrulesFlag" onclick="swapRrules(this)" value="on">
                        <xsl:if test="$canEdit = 'false'"><xsl:attribute name="disabled">disabled</xsl:attribute></xsl:if>
                      </input>
                      <xsl:copy-of select="$bwStr-AEEF-ChangeRecurrenceRules"/>
                    </span>
                  </xsl:if>
                  <span id="rrulesUiSwitch">
                    <xsl:if test="form/recurrence">
                      <xsl:attribute name="class">invisible</xsl:attribute>
                    </xsl:if>
                    <input type="checkbox" name="rrulesUiSwitch" id="bwRrulesAdvancedButton" value="advanced" onchange="swapVisible(this,'advancedRrules')"/>
                    <label for="bwRrulesAdvancedButton">
                      <xsl:copy-of select="$bwStr-AEEF-ShowAdvancedRecurrenceRules"/>
                    </label>
                  </span>

                  <xsl:if test="form/recurrence">
                    <!-- Output descriptive recurrence rules information.  Probably not
                         complete yet. Replace all strings so can be
                         more easily internationalized. -->
                    <div id="recurrenceInfo">
                      <xsl:copy-of select="$bwStr-AEEF-Every"/><xsl:text> </xsl:text>
                      <xsl:choose>
                        <xsl:when test="form/recurrence/interval &gt; 1">
                          <xsl:value-of select="form/recurrence/interval"/>
                        </xsl:when>
                      </xsl:choose>
                      <xsl:text> </xsl:text>
                      <xsl:choose>
                        <xsl:when test="form/recurrence/freq = 'HOURLY'"><xsl:copy-of select="$bwStr-AEEF-Hour"/><xsl:text> </xsl:text></xsl:when>
                        <xsl:when test="form/recurrence/freq = 'DAILY'"><xsl:copy-of select="$bwStr-AEEF-Day"/><xsl:text> </xsl:text></xsl:when>
                        <xsl:when test="form/recurrence/freq = 'WEEKLY'"><xsl:copy-of select="$bwStr-AEEF-Week"/><xsl:text> </xsl:text></xsl:when>
                        <xsl:when test="form/recurrence/freq = 'MONTHLY'"><xsl:copy-of select="$bwStr-AEEF-Month"/><xsl:text> </xsl:text></xsl:when>
                        <xsl:when test="form/recurrence/freq = 'YEARLY'"><xsl:copy-of select="$bwStr-AEEF-Year"/><xsl:text> </xsl:text></xsl:when>
                      </xsl:choose>
                      <xsl:text> </xsl:text>

                      <xsl:if test="form/recurrence/byday">
                        <xsl:for-each select="form/recurrence/byday/pos">
                          <xsl:if test="position() != 1"><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-AEEF-And"/><xsl:text> </xsl:text></xsl:if>
                          <xsl:copy-of select="$bwStr-AEEF-On"/>
                          <xsl:text> </xsl:text>
                          <xsl:choose>
                            <xsl:when test="@val='1'">
                              <xsl:copy-of select="$bwStr-AEEF-TheFirst"/><xsl:text> </xsl:text>
                            </xsl:when>
                            <xsl:when test="@val='2'">
                              <xsl:copy-of select="$bwStr-AEEF-TheSecond"/><xsl:text> </xsl:text>
                            </xsl:when>
                            <xsl:when test="@val='3'">
                              <xsl:copy-of select="$bwStr-AEEF-TheThird"/><xsl:text> </xsl:text>
                            </xsl:when>
                            <xsl:when test="@val='4'">
                              <xsl:copy-of select="$bwStr-AEEF-TheFourth"/><xsl:text> </xsl:text>
                            </xsl:when>
                            <xsl:when test="@val='5'">
                              <xsl:copy-of select="$bwStr-AEEF-TheFifth"/><xsl:text> </xsl:text>
                            </xsl:when>
                            <xsl:when test="@val='-1'">
                              <xsl:copy-of select="$bwStr-AEEF-TheLast"/><xsl:text> </xsl:text>
                            </xsl:when>
                            <!-- don't output "every" --><!--<xsl:otherwise>
                              every
                            </xsl:otherwise>-->
                          </xsl:choose>
                          <xsl:for-each select="day">
                            <xsl:if test="position() != 1 and position() = last()"><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-AEEF-And"/><xsl:text> </xsl:text></xsl:if>
                            <xsl:variable name="dayVal" select="."/>
                            <xsl:variable name="dayPos">
                              <xsl:for-each select="/bedework/recurdayvals/val">
                                <xsl:if test="node() = $dayVal"><xsl:value-of select="position()"/></xsl:if>
                              </xsl:for-each>
                            </xsl:variable>
                            <xsl:value-of select="/bedework/shortdaynames/val[position() = $dayPos]"/>
                            <xsl:if test="position() != last()">, </xsl:if>
                          </xsl:for-each>
                        </xsl:for-each>
                      </xsl:if>

                      <xsl:if test="form/recurrence/bymonth">
                        <xsl:copy-of select="$bwStr-AEEF-In"/>
                        <xsl:for-each select="form/recurrence/bymonth/val">
                          <xsl:if test="position() != 1 and position() = last()"><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-AEEF-And"/><xsl:text> </xsl:text></xsl:if>
                          <xsl:variable name="monthNum" select="number(.)"/>
                          <xsl:value-of select="/bedework/monthlabels/val[position() = $monthNum]"/>
                          <xsl:if test="position() != last()">, </xsl:if>
                        </xsl:for-each>
                      </xsl:if>

                      <xsl:if test="form/recurrence/bymonthday">
                        <xsl:text> </xsl:text>
                        <xsl:copy-of select="$bwStr-AEEF-OnThe"/>
                        <xsl:text> </xsl:text>
                        <xsl:apply-templates select="form/recurrence/bymonthday/val" mode="weekMonthYearNumbers"/>
                        <xsl:text> </xsl:text>
                        <xsl:copy-of select="$bwStr-AEEF-DayOfTheMonth"/>
                        <xsl:text> </xsl:text>
                      </xsl:if>

                      <xsl:if test="form/recurrence/byyearday">
                        <xsl:text> </xsl:text>
                        <xsl:copy-of select="$bwStr-AEEF-OnThe"/>
                        <xsl:text> </xsl:text>
                        <xsl:apply-templates select="form/recurrence/byyearday/val" mode="weekMonthYearNumbers"/>
                        <xsl:text> </xsl:text>
                        <xsl:copy-of select="$bwStr-AEEF-DayOfTheYear"/>
                        <xsl:text> </xsl:text>
                      </xsl:if>

                      <xsl:if test="form/recurrence/byweekno">
                        <xsl:text> </xsl:text>
                        <xsl:copy-of select="$bwStr-AEEF-InThe"/>
                        <xsl:text> </xsl:text>
                        <xsl:apply-templates select="form/recurrence/byweekno/val" mode="weekMonthYearNumbers"/>
                        <xsl:text> </xsl:text>
                        <xsl:copy-of select="$bwStr-AEEF-WeekOfTheYear"/>
                        <xsl:text> </xsl:text>
                      </xsl:if>

                      <xsl:copy-of select="$bwStr-AEEF-Repeating"/>
                      <xsl:choose>
                        <xsl:when test="form/recurrence/count = '-1'"><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-AEEF-Forever"/></xsl:when>
                        <xsl:when test="form/recurrence/until">
                          <xsl:text> </xsl:text>
                          <xsl:copy-of select="$bwStr-AEEF-Until"/>
                          <xsl:text> </xsl:text>
                          <xsl:value-of select="substring(form/recurrence/until,1,4)"/>-<xsl:value-of select="substring(form/recurrence/until,5,2)"/>-<xsl:value-of select="substring(form/recurrence/until,7,2)"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:text> </xsl:text>
                          <xsl:value-of select="form/recurrence/count"/>
                          <xsl:text> </xsl:text>
                          <xsl:copy-of select="$bwStr-AEEF-Times"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </div>
                  </xsl:if>

                  <!-- set these dynamically when form is submitted -->
                  <input type="hidden" name="interval" value=""/>
                  <input type="hidden" name="count" value=""/>
                  <input type="hidden" name="until" value=""/>
                  <input type="hidden" name="byday" value=""/>
                  <input type="hidden" name="bymonthday" value=""/>
                  <input type="hidden" name="bymonth" value=""/>
                  <input type="hidden" name="byweekno" value=""/>
                  <input type="hidden" name="byyearday" value=""/>
                  <input type="hidden" name="wkst" value=""/>
                  <input type="hidden" name="setpos" value=""/>

                  <!-- wrapper for rrules: -->
                  <table id="rrulesTable" cellspacing="0">
                    <xsl:if test="form/recurrence">
                      <xsl:attribute name="class">invisible</xsl:attribute>
                    </xsl:if>
                    <tr>
                      <td id="recurrenceFrequency" rowspan="2">
                        <em><xsl:copy-of select="$bwStr-AEEF-Frequency"/></em><br/>
                        <input type="radio" name="freq" id="bwFreqNone" value="NONE" onclick="showRrules(this.value)" checked="checked"/>
                        <label for="bwFreqNone">
                          <xsl:copy-of select="$bwStr-AEEF-None"/>
                        </label><br/>
                        <!--<input type="radio" name="freq" value="HOURLY" onclick="showRrules(this.value)"/>hourly<br/>-->
                        <input type="radio" name="freq" id="bwFreqDaily" value="DAILY" onclick="showRrules(this.value)"/>
                        <label for="bwFreqDaily">
                          <xsl:copy-of select="$bwStr-AEEF-Daily"/>
                        </label><br/>
                        <input type="radio" name="freq" id="bwFreqWeekly" value="WEEKLY" onclick="showRrules(this.value)"/>
                        <label for="bwFreqWeekly">
                          <xsl:copy-of select="$bwStr-AEEF-Weekly"/>
                        </label><br/>
                        <input type="radio" name="freq" id="bwFreqMonthly" value="MONTHLY" onclick="showRrules(this.value)"/>
                        <label for="bwFreqMonthly">
                          <xsl:copy-of select="$bwStr-AEEF-Monthly"/>
                        </label><br/>
                        <input type="radio" name="freq" id="bwFreqYearly" value="YEARLY" onclick="showRrules(this.value)"/>
                        <label for="bwFreqYearly">
                          <xsl:copy-of select="$bwStr-AEEF-Yearly"/>
                        </label>
                      </td>
                      <!-- recurrence count, until, forever -->
                      <td id="recurrenceUntil">
                        <div id="noneRecurrenceRules">
                          <xsl:copy-of select="$bwStr-AEEF-NoRecurrenceRules"/>
                        </div>
                        <div id="recurrenceUntilRules" class="invisible">
                          <em><xsl:copy-of select="$bwStr-AEEF-Repeat"/></em>
                          <p>
                            <input type="radio" name="recurCountUntil" value="forever">
                              <xsl:if test="not(form/recurring) or form/recurring/count = '-1'">
                                <xsl:attribute name="checked">checked</xsl:attribute>
                              </xsl:if>
                            </input>
                            <xsl:copy-of select="$bwStr-AEEF-Forever"/>
                            <input type="radio" name="recurCountUntil" value="count" id="recurCount">
                              <xsl:if test="form/recurring/count != '-1'">
                                <xsl:attribute name="checked">checked</xsl:attribute>
                              </xsl:if>
                            </input>
                            <input type="text" value="1" size="2" name="countHolder" onfocus="selectRecurCountUntil('recurCount')">
                              <xsl:if test="form/recurring/count and form/recurring/count != '-1'">
                                <xsl:attribute name="value"><xsl:value-of select="form/recurring/count"/></xsl:attribute>
                              </xsl:if>
                            </input>
                            <xsl:copy-of select="$bwStr-AEEF-Time"/>
                            <input type="radio" name="recurCountUntil" value="until" id="recurUntil">
                              <xsl:if test="form/recurring/until">
                                <xsl:attribute name="checked">checked</xsl:attribute>
                              </xsl:if>
                            </input>
                            <xsl:copy-of select="$bwStr-AEEF-Until"/>
                            <span id="untilHolder">
                              <input type="hidden" name="bwEventUntilDate" id="bwEventUntilDate" size="10"/>
                              <input type="text" name="bwEventWidgetUntilDate" id="bwEventWidgetUntilDate" size="10" onfocus="selectRecurCountUntil('recurUntil')"/>
                              <script type="text/javascript">
                                <xsl:comment>
                                /*$("#bwEventWidgetUntilDate").datepicker({
                                  <xsl:choose>
                                    <xsl:when test="form/recurrence/until">
                                      defaultDate: new Date(<xsl:value-of select="substring(form/recurrence/until,1,4)"/>, <xsl:value-of select="number(substring(form/recurrence/until,5,2)) - 1"/>, <xsl:value-of select="substring(form/recurrence/until,7,2)"/>),
                                    </xsl:when>
                                    <xsl:otherwise>
                                      defaultDate: new Date(<xsl:value-of select="form/start/yearText/input/@value"/>, <xsl:value-of select="number(form/start/month/select/option[@selected = 'selected']/@value) - 1"/>, <xsl:value-of select="form/start/day/select/option[@selected = 'selected']/@value"/>),
                                    </xsl:otherwise>
                                  </xsl:choose>
                                  altField: "#bwEventUntilDate",
                                  altFormat: "yymmdd"
                                }).attr("readonly", "readonly");
                                $("#bwEventWidgetUntilDate").val('<xsl:value-of select="substring-before(form/start/rfc3339DateTime,'T')"/>');*/
                                </xsl:comment>
                              </script>
                            </span>
                          </p>
                        </div>
                      </td>
                    </tr>
                    <tr>
                      <td id="advancedRrules" class="invisible">
                        <!-- hourly -->
                        <div id="hourlyRecurrenceRules" class="invisible">
                          <p>
                            <em><xsl:copy-of select="$bwStr-AEEF-Interval"/><xsl:text> </xsl:text></em>
                            <xsl:copy-of select="$bwStr-AEEF-Every"/>
                            <input type="text" name="hourlyInterval" size="2" value="1">
                              <xsl:if test="form/recurrence/interval">
                                <xsl:attribute name="value"><xsl:value-of select="form/recurrence/interval"/></xsl:attribute>
                              </xsl:if>
                            </input>
                            <xsl:copy-of select="$bwStr-AEEF-Hour"/>
                          </p>
                        </div>
                        <!-- daily -->
                        <div id="dailyRecurrenceRules" class="invisible">
                          <p>
                            <em><xsl:copy-of select="$bwStr-AEEF-Interval"/><xsl:text> </xsl:text></em>
                            <xsl:copy-of select="$bwStr-AEEF-Every"/>
                            <input type="text" name="dailyInterval" size="2" value="1">
                              <xsl:if test="form/recurrence/interval">
                                <xsl:attribute name="value"><xsl:value-of select="form/recurrence/interval"/></xsl:attribute>
                              </xsl:if>
                            </input>
                            <xsl:copy-of select="$bwStr-AEEF-Day"/>
                          </p>
                          <p>
                            <input type="checkbox" name="swapDayMonthCheckBoxList" value="" onclick="swapVisible(this,'dayMonthCheckBoxList')"/>
                            <xsl:copy-of select="$bwStr-AEEF-InTheseMonths"/>
                            <div id="dayMonthCheckBoxList" class="invisible">
                              <xsl:for-each select="/bedework/monthlabels/val">
                                <xsl:variable name="pos"><xsl:value-of select="position()"/></xsl:variable>
                                <span class="chkBoxListItem">
                                  <input type="checkbox" name="dayMonths">
                                    <xsl:attribute name="value"><xsl:value-of select="/bedework/monthvalues/val[position() = $pos]"/></xsl:attribute>
                                  </input>
                                  <xsl:value-of select="."/>
                                </span>
                                <xsl:if test="$pos mod 6 = 0"><br/></xsl:if>
                              </xsl:for-each>
                            </div>
                          </p>
                          <!--<p>
                            <input type="checkbox" name="swapDaySetPos" value="" onclick="swapVisible(this,'daySetPos')"/>
                            limit to:
                            <div id="daySetPos" class="invisible">
                            </div>
                          </p>-->
                        </div>
                        <!-- weekly -->
                        <div id="weeklyRecurrenceRules" class="invisible">
                          <p>
                            <em><xsl:copy-of select="$bwStr-AEEF-Interval"/></em>
                            <xsl:copy-of select="$bwStr-AEEF-Every"/>
                            <input type="text" name="weeklyInterval" size="2" value="1">
                              <xsl:if test="form/recurrence/interval">
                                <xsl:attribute name="value"><xsl:value-of select="form/recurrence/interval"/></xsl:attribute>
                              </xsl:if>
                            </input>
                            <xsl:copy-of select="$bwStr-AEEF-WeekOn"/>
                          </p>
                          <div id="weekRecurFields">
                            <xsl:call-template name="byDayChkBoxList">
                              <xsl:with-param name="name">byDayWeek</xsl:with-param>
                            </xsl:call-template>
                          </div>
                          <p class="weekRecurLinks">
                            <a href="javascript:recurSelectWeekdays('weekRecurFields')"><xsl:copy-of select="$bwStr-AEEF-SelectWeekdays"/></a> |
                            <a href="javascript:recurSelectWeekends('weekRecurFields')"><xsl:copy-of select="$bwStr-AEEF-SelectWeekends"/></a>
                          </p>
                          <p>
                            <xsl:copy-of select="$bwStr-AEEF-WeekStart"/>
                            <select name="weekWkst">
                              <xsl:for-each select="/bedework/shortdaynames/val">
                                <xsl:variable name="pos" select="position()"/>
                                <option>
                                  <xsl:attribute name="value"><xsl:value-of select="/bedework/recurdayvals/val[position() = $pos]"/></xsl:attribute>
                                  <xsl:value-of select="."/>
                                </option>
                              </xsl:for-each>
                            </select>
                          </p>
                        </div>
                        <!-- monthly -->
                        <div id="monthlyRecurrenceRules" class="invisible">
                          <p>
                            <em><xsl:copy-of select="$bwStr-AEEF-Interval"/></em>
                            <xsl:copy-of select="$bwStr-AEEF-Every"/>
                            <input type="text" name="monthlyInterval" size="2" value="1">
                              <xsl:if test="form/recurrence/interval">
                                <xsl:attribute name="value"><xsl:value-of select="form/recurrence/interval"/></xsl:attribute>
                              </xsl:if>
                            </input>
                            <xsl:copy-of select="$bwStr-AEEF-Month"/>
                          </p>
                          <div id="monthRecurFields">
                            <div id="monthRecurFields1">
                              <xsl:copy-of select="$bwStr-AEEF-On"/>
                              <select name="bymonthposPos1" onchange="changeClass('monthRecurFields2','shown')">
                                <xsl:call-template name="recurrenceDayPosOptions"/>
                              </select>
                              <xsl:call-template name="byDayChkBoxList"/>
                            </div>
                            <xsl:call-template name="buildRecurFields">
                              <xsl:with-param name="current">2</xsl:with-param>
                              <xsl:with-param name="total">10</xsl:with-param>
                              <xsl:with-param name="name">month</xsl:with-param>
                            </xsl:call-template>
                          </div>
                          <p>
                            <input type="checkbox" name="swapMonthDaysCheckBoxList" value="" onclick="swapVisible(this,'monthDaysCheckBoxList')"/>
                            <xsl:copy-of select="$bwStr-AEEF-OnTheseDays"/><br/>
                            <div id="monthDaysCheckBoxList" class="invisible">
                              <!-- static html here is more efficient for XSLT than building with a template -->
                              <span class="chkBoxListItem">
                                <input name="monthDayBoxes" value="1" type="checkbox"/>1</span>
                              <span class="chkBoxListItem">
                                <input name="monthDayBoxes" value="2" type="checkbox"/>2</span>
                              <span class="chkBoxListItem">
                                <input name="monthDayBoxes" value="3" type="checkbox"/>3</span>
                              <span class="chkBoxListItem">
                                <input name="monthDayBoxes" value="4" type="checkbox"/>4</span>
                              <span class="chkBoxListItem">
                                <input name="monthDayBoxes" value="5" type="checkbox"/>5</span>
                              <span class="chkBoxListItem">
                                <input name="monthDayBoxes" value="6" type="checkbox"/>6</span>
                              <span class="chkBoxListItem">
                                <input name="monthDayBoxes" value="7" type="checkbox"/>7</span>
                              <span class="chkBoxListItem">
                                <input name="monthDayBoxes" value="8" type="checkbox"/>8</span>
                              <span class="chkBoxListItem">
                                <input name="monthDayBoxes" value="9" type="checkbox"/>9</span>
                              <span class="chkBoxListItem">
                                <input name="monthDayBoxes" value="10" type="checkbox"/>10</span>
                              <br/>
                              <span class="chkBoxListItem">
                                <input name="monthDayBoxes" value="11" type="checkbox"/>11</span>
                              <span class="chkBoxListItem">
                                <input name="monthDayBoxes" value="12" type="checkbox"/>12</span>
                              <span class="chkBoxListItem">
                                <input name="monthDayBoxes" value="13" type="checkbox"/>13</span>
                              <span class="chkBoxListItem">
                                <input name="monthDayBoxes" value="14" type="checkbox"/>14</span>
                              <span class="chkBoxListItem">
                                <input name="monthDayBoxes" value="15" type="checkbox"/>15</span>
                              <span class="chkBoxListItem">
                                <input name="monthDayBoxes" value="16" type="checkbox"/>16</span>
                              <span class="chkBoxListItem">
                                <input name="monthDayBoxes" value="17" type="checkbox"/>17</span>
                              <span class="chkBoxListItem">
                                <input name="monthDayBoxes" value="18" type="checkbox"/>18</span>
                              <span class="chkBoxListItem">
                                <input name="monthDayBoxes" value="19" type="checkbox"/>19</span>
                              <span class="chkBoxListItem">
                                <input name="monthDayBoxes" value="20" type="checkbox"/>20</span>
                              <br/>
                              <span class="chkBoxListItem">
                                <input name="monthDayBoxes" value="21" type="checkbox"/>21</span>
                              <span class="chkBoxListItem">
                                <input name="monthDayBoxes" value="22" type="checkbox"/>22</span>
                              <span class="chkBoxListItem">
                                <input name="monthDayBoxes" value="23" type="checkbox"/>23</span>
                              <span class="chkBoxListItem">
                                <input name="monthDayBoxes" value="24" type="checkbox"/>24</span>
                              <span class="chkBoxListItem">
                                <input name="monthDayBoxes" value="25" type="checkbox"/>25</span>
                              <span class="chkBoxListItem">
                                <input name="monthDayBoxes" value="26" type="checkbox"/>26</span>
                              <span class="chkBoxListItem">
                                <input name="monthDayBoxes" value="27" type="checkbox"/>27</span>
                              <span class="chkBoxListItem">
                                <input name="monthDayBoxes" value="28" type="checkbox"/>28</span>
                              <span class="chkBoxListItem">
                                <input name="monthDayBoxes" value="29" type="checkbox"/>29</span>
                              <span class="chkBoxListItem">
                                <input name="monthDayBoxes" value="30" type="checkbox"/>30</span>
                              <br/>
                              <span class="chkBoxListItem">
                                <input name="monthDayBoxes" value="31" type="checkbox"/>31</span>
                              <br/>
                            </div>
                          </p>
                        </div>
                        <!-- yearly -->
                        <div id="yearlyRecurrenceRules" class="invisible">
                          <p>
                            <em><xsl:copy-of select="$bwStr-AEEF-Interval"/></em>
                            <xsl:copy-of select="$bwStr-AEEF-Every"/>
                            <input type="text" name="yearlyInterval" size="2" value="1">
                              <xsl:if test="form/recurrence/interval">
                                <xsl:attribute name="value"><xsl:value-of select="form/recurrence/interval"/></xsl:attribute>
                              </xsl:if>
                            </input>
                            <xsl:copy-of select="$bwStr-AEEF-Year"/>
                          </p>
                          <div id="yearRecurFields">
                            <div id="yearRecurFields1">
                              <xsl:copy-of select="$bwStr-AEEF-On"/>
                              <select name="byyearposPos1" onchange="changeClass('yearRecurFields2','shown')">
                                <xsl:call-template name="recurrenceDayPosOptions"/>
                              </select>
                              <xsl:call-template name="byDayChkBoxList"/>
                            </div>
                            <xsl:call-template name="buildRecurFields">
                              <xsl:with-param name="current">2</xsl:with-param>
                              <xsl:with-param name="total">10</xsl:with-param>
                              <xsl:with-param name="name">year</xsl:with-param>
                            </xsl:call-template>
                          </div>
                          <p>
                            <input type="checkbox" id="swapYearMonthCheckBoxList" name="swapYearMonthCheckBoxList" value="" onclick="swapVisible(this,'yearMonthCheckBoxList')"/>
                            <label for="swapYearMonthCheckBoxList"><xsl:copy-of select="$bwStr-AEEF-InTheseMonths"/></label>
                            <div id="yearMonthCheckBoxList" class="invisible">
                              <xsl:for-each select="/bedework/monthlabels/val">
                                <xsl:variable name="pos"><xsl:value-of select="position()"/></xsl:variable>
                                <span class="chkBoxListItem">
                                  <input type="checkbox" name="yearMonths">
                                    <xsl:attribute name="value"><xsl:value-of select="/bedework/monthvalues/val[position() = $pos]"/></xsl:attribute>
                                  </input>
                                  <xsl:value-of select="."/>
                                </span>
                                <xsl:if test="$pos mod 6 = 0"><br/></xsl:if>
                              </xsl:for-each>
                            </div>
                          </p>
                          <p>
                            <input type="checkbox" id="swapYearMonthDaysCheckBoxList" name="swapYearMonthDaysCheckBoxList" value="" onclick="swapVisible(this,'yearMonthDaysCheckBoxList')"/>
                            <label for="swapYearMonthDaysCheckBoxList"><xsl:copy-of select="$bwStr-AEEF-OnTheseDaysOfTheMonth"/></label><br/>
                            <div id="yearMonthDaysCheckBoxList" class="invisible">
                              <!-- static html here is more efficient for XSLT than building with a template -->
                              <span class="chkBoxListItem">
                                <input name="yearMonthDayBoxes" value="1" type="checkbox"/>1</span>
                              <span class="chkBoxListItem">
                                <input name="yearMonthDayBoxes" value="2" type="checkbox"/>2</span>
                              <span class="chkBoxListItem">
                                <input name="yearMonthDayBoxes" value="3" type="checkbox"/>3</span>
                              <span class="chkBoxListItem">
                                <input name="yearMonthDayBoxes" value="4" type="checkbox"/>4</span>
                              <span class="chkBoxListItem">
                                <input name="yearMonthDayBoxes" value="5" type="checkbox"/>5</span>
                              <span class="chkBoxListItem">
                                <input name="yearMonthDayBoxes" value="6" type="checkbox"/>6</span>
                              <span class="chkBoxListItem">
                                <input name="yearMonthDayBoxes" value="7" type="checkbox"/>7</span>
                              <span class="chkBoxListItem">
                                <input name="yearMonthDayBoxes" value="8" type="checkbox"/>8</span>
                              <span class="chkBoxListItem">
                                <input name="yearMonthDayBoxes" value="9" type="checkbox"/>9</span>
                              <span class="chkBoxListItem">
                                <input name="yearMonthDayBoxes" value="10" type="checkbox"/>10</span>
                              <br/>
                              <span class="chkBoxListItem">
                                <input name="yearMonthDayBoxes" value="11" type="checkbox"/>11</span>
                              <span class="chkBoxListItem">
                                <input name="yearMonthDayBoxes" value="12" type="checkbox"/>12</span>
                              <span class="chkBoxListItem">
                                <input name="yearMonthDayBoxes" value="13" type="checkbox"/>13</span>
                              <span class="chkBoxListItem">
                                <input name="yearMonthDayBoxes" value="14" type="checkbox"/>14</span>
                              <span class="chkBoxListItem">
                                <input name="yearMonthDayBoxes" value="15" type="checkbox"/>15</span>
                              <span class="chkBoxListItem">
                                <input name="yearMonthDayBoxes" value="16" type="checkbox"/>16</span>
                              <span class="chkBoxListItem">
                                <input name="yearMonthDayBoxes" value="17" type="checkbox"/>17</span>
                              <span class="chkBoxListItem">
                                <input name="yearMonthDayBoxes" value="18" type="checkbox"/>18</span>
                              <span class="chkBoxListItem">
                                <input name="yearMonthDayBoxes" value="19" type="checkbox"/>19</span>
                              <span class="chkBoxListItem">
                                <input name="yearMonthDayBoxes" value="20" type="checkbox"/>20</span>
                              <br/>
                              <span class="chkBoxListItem">
                                <input name="yearMonthDayBoxes" value="21" type="checkbox"/>21</span>
                              <span class="chkBoxListItem">
                                <input name="yearMonthDayBoxes" value="22" type="checkbox"/>22</span>
                              <span class="chkBoxListItem">
                                <input name="yearMonthDayBoxes" value="23" type="checkbox"/>23</span>
                              <span class="chkBoxListItem">
                                <input name="yearMonthDayBoxes" value="24" type="checkbox"/>24</span>
                              <span class="chkBoxListItem">
                                <input name="yearMonthDayBoxes" value="25" type="checkbox"/>25</span>
                              <span class="chkBoxListItem">
                                <input name="yearMonthDayBoxes" value="26" type="checkbox"/>26</span>
                              <span class="chkBoxListItem">
                                <input name="yearMonthDayBoxes" value="27" type="checkbox"/>27</span>
                              <span class="chkBoxListItem">
                                <input name="yearMonthDayBoxes" value="28" type="checkbox"/>28</span>
                              <span class="chkBoxListItem">
                                <input name="yearMonthDayBoxes" value="29" type="checkbox"/>29</span>
                              <span class="chkBoxListItem">
                                <input name="yearMonthDayBoxes" value="30" type="checkbox"/>30</span>
                              <br/>
                              <span class="chkBoxListItem">
                                <input name="yearMonthDayBoxes" value="31" type="checkbox"/>31</span>
                              <br/>
                            </div>
                          </p>
                          <p>
                            <input type="checkbox" id="swapYearWeeksCheckBoxList" name="swapYearWeeksCheckBoxList" value="" onclick="swapVisible(this,'yearWeeksCheckBoxList')"/>
                            <label for="swapYearWeeksCheckBoxList"><xsl:copy-of select="$bwStr-AEEF-InTheseWeeksOfTheYear"/></label><br/>
                            <div id="yearWeeksCheckBoxList" class="invisible">
                              <!-- static html here is more efficient for XSLT than building with a template -->
                              <span class="chkBoxListItem">
                                <input name="yearWeekBoxes" value="1" type="checkbox"/>1</span>
                              <span class="chkBoxListItem">
                                <input name="yearWeekBoxes" value="2" type="checkbox"/>2</span>
                              <span class="chkBoxListItem">
                                <input name="yearWeekBoxes" value="3" type="checkbox"/>3</span>
                              <span class="chkBoxListItem">
                                <input name="yearWeekBoxes" value="4" type="checkbox"/>4</span>
                              <span class="chkBoxListItem">
                                <input name="yearWeekBoxes" value="5" type="checkbox"/>5</span>
                              <span class="chkBoxListItem">
                                <input name="yearWeekBoxes" value="6" type="checkbox"/>6</span>
                              <span class="chkBoxListItem">
                                <input name="yearWeekBoxes" value="7" type="checkbox"/>7</span>
                              <span class="chkBoxListItem">
                                <input name="yearWeekBoxes" value="8" type="checkbox"/>8</span>
                              <span class="chkBoxListItem">
                                <input name="yearWeekBoxes" value="9" type="checkbox"/>9</span>
                              <span class="chkBoxListItem">
                                <input name="yearWeekBoxes" value="10" type="checkbox"/>10</span>
                              <br/>
                              <span class="chkBoxListItem">
                                <input name="yearWeekBoxes" value="11" type="checkbox"/>11</span>
                              <span class="chkBoxListItem">
                                <input name="yearWeekBoxes" value="12" type="checkbox"/>12</span>
                              <span class="chkBoxListItem">
                                <input name="yearWeekBoxes" value="13" type="checkbox"/>13</span>
                              <span class="chkBoxListItem">
                                <input name="yearWeekBoxes" value="14" type="checkbox"/>14</span>
                              <span class="chkBoxListItem">
                                <input name="yearWeekBoxes" value="15" type="checkbox"/>15</span>
                              <span class="chkBoxListItem">
                                <input name="yearWeekBoxes" value="16" type="checkbox"/>16</span>
                              <span class="chkBoxListItem">
                                <input name="yearWeekBoxes" value="17" type="checkbox"/>17</span>
                              <span class="chkBoxListItem">
                                <input name="yearWeekBoxes" value="18" type="checkbox"/>18</span>
                              <span class="chkBoxListItem">
                                <input name="yearWeekBoxes" value="19" type="checkbox"/>19</span>
                              <span class="chkBoxListItem">
                                <input name="yearWeekBoxes" value="20" type="checkbox"/>20</span>
                              <br/>
                              <span class="chkBoxListItem">
                                <input name="yearWeekBoxes" value="21" type="checkbox"/>21</span>
                              <span class="chkBoxListItem">
                                <input name="yearWeekBoxes" value="22" type="checkbox"/>22</span>
                              <span class="chkBoxListItem">
                                <input name="yearWeekBoxes" value="23" type="checkbox"/>23</span>
                              <span class="chkBoxListItem">
                                <input name="yearWeekBoxes" value="24" type="checkbox"/>24</span>
                              <span class="chkBoxListItem">
                                <input name="yearWeekBoxes" value="25" type="checkbox"/>25</span>
                              <span class="chkBoxListItem">
                                <input name="yearWeekBoxes" value="26" type="checkbox"/>26</span>
                              <span class="chkBoxListItem">
                                <input name="yearWeekBoxes" value="27" type="checkbox"/>27</span>
                              <span class="chkBoxListItem">
                                <input name="yearWeekBoxes" value="28" type="checkbox"/>28</span>
                              <span class="chkBoxListItem">
                                <input name="yearWeekBoxes" value="29" type="checkbox"/>29</span>
                              <span class="chkBoxListItem">
                                <input name="yearWeekBoxes" value="30" type="checkbox"/>30</span>
                              <br/>
                              <span class="chkBoxListItem">
                                <input name="yearWeekBoxes" value="31" type="checkbox"/>31</span>
                              <span class="chkBoxListItem">
                                <input name="yearWeekBoxes" value="32" type="checkbox"/>32</span>
                              <span class="chkBoxListItem">
                                <input name="yearWeekBoxes" value="33" type="checkbox"/>33</span>
                              <span class="chkBoxListItem">
                                <input name="yearWeekBoxes" value="34" type="checkbox"/>34</span>
                              <span class="chkBoxListItem">
                                <input name="yearWeekBoxes" value="35" type="checkbox"/>35</span>
                              <span class="chkBoxListItem">
                                <input name="yearWeekBoxes" value="36" type="checkbox"/>36</span>
                              <span class="chkBoxListItem">
                                <input name="yearWeekBoxes" value="37" type="checkbox"/>37</span>
                              <span class="chkBoxListItem">
                                <input name="yearWeekBoxes" value="38" type="checkbox"/>38</span>
                              <span class="chkBoxListItem">
                                <input name="yearWeekBoxes" value="39" type="checkbox"/>39</span>
                              <span class="chkBoxListItem">
                                <input name="yearWeekBoxes" value="40" type="checkbox"/>40</span>
                              <br/>
                              <span class="chkBoxListItem">
                                <input name="yearWeekBoxes" value="41" type="checkbox"/>41</span>
                              <span class="chkBoxListItem">
                                <input name="yearWeekBoxes" value="42" type="checkbox"/>42</span>
                              <span class="chkBoxListItem">
                                <input name="yearWeekBoxes" value="43" type="checkbox"/>43</span>
                              <span class="chkBoxListItem">
                                <input name="yearWeekBoxes" value="44" type="checkbox"/>44</span>
                              <span class="chkBoxListItem">
                                <input name="yearWeekBoxes" value="45" type="checkbox"/>45</span>
                              <span class="chkBoxListItem">
                                <input name="yearWeekBoxes" value="46" type="checkbox"/>46</span>
                              <span class="chkBoxListItem">
                                <input name="yearWeekBoxes" value="47" type="checkbox"/>47</span>
                              <span class="chkBoxListItem">
                                <input name="yearWeekBoxes" value="48" type="checkbox"/>48</span>
                              <span class="chkBoxListItem">
                                <input name="yearWeekBoxes" value="49" type="checkbox"/>49</span>
                              <span class="chkBoxListItem">
                                <input name="yearWeekBoxes" value="50" type="checkbox"/>50</span>
                              <br/>
                              <span class="chkBoxListItem">
                                <input name="yearWeekBoxes" value="51" type="checkbox"/>51</span>
                              <span class="chkBoxListItem">
                                <input name="yearWeekBoxes" value="52" type="checkbox"/>52</span>
                              <span class="chkBoxListItem">
                                <input name="yearWeekBoxes" value="53" type="checkbox"/>53</span>
                              <br/>
                            </div>
                          </p>
                          <p>
                            <input type="checkbox" name="swapYearDaysCheckBoxList" id="swapYearDaysCheckBoxList" value="" onclick="swapVisible(this,'yearDaysCheckBoxList')"/>
                            <label for="swapYearDaysCheckBoxList"><xsl:copy-of select="$bwStr-AEEF-OnTheseDaysOfTheYear"/></label><br/>
                            <!-- static html here is more efficient for XSLT than building with a template -->
                            <div id="yearDaysCheckBoxList" class="invisible">
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="1" name="yearDayBoxes"/>1</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="2" name="yearDayBoxes"/>2</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="3" name="yearDayBoxes"/>3</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="4" name="yearDayBoxes"/>4</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="5" name="yearDayBoxes"/>5</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="6" name="yearDayBoxes"/>6</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="7" name="yearDayBoxes"/>7</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="8" name="yearDayBoxes"/>8</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="9" name="yearDayBoxes"/>9</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="10" name="yearDayBoxes"/>10</span>
                              <br/>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="11" name="yearDayBoxes"/>11</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="12" name="yearDayBoxes"/>12</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="13" name="yearDayBoxes"/>13</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="14" name="yearDayBoxes"/>14</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="15" name="yearDayBoxes"/>15</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="16" name="yearDayBoxes"/>16</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="17" name="yearDayBoxes"/>17</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="18" name="yearDayBoxes"/>18</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="19" name="yearDayBoxes"/>19</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="20" name="yearDayBoxes"/>20</span>
                              <br/>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="21" name="yearDayBoxes"/>21</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="22" name="yearDayBoxes"/>22</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="23" name="yearDayBoxes"/>23</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="24" name="yearDayBoxes"/>24</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="25" name="yearDayBoxes"/>25</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="26" name="yearDayBoxes"/>26</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="27" name="yearDayBoxes"/>27</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="28" name="yearDayBoxes"/>28</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="29" name="yearDayBoxes"/>29</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="30" name="yearDayBoxes"/>30</span>
                              <br/>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="31" name="yearDayBoxes"/>31</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="32" name="yearDayBoxes"/>32</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="33" name="yearDayBoxes"/>33</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="34" name="yearDayBoxes"/>34</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="35" name="yearDayBoxes"/>35</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="36" name="yearDayBoxes"/>36</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="37" name="yearDayBoxes"/>37</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="38" name="yearDayBoxes"/>38</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="39" name="yearDayBoxes"/>39</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="40" name="yearDayBoxes"/>40</span>
                              <br/>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="41" name="yearDayBoxes"/>41</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="42" name="yearDayBoxes"/>42</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="43" name="yearDayBoxes"/>43</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="44" name="yearDayBoxes"/>44</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="45" name="yearDayBoxes"/>45</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="46" name="yearDayBoxes"/>46</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="47" name="yearDayBoxes"/>47</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="48" name="yearDayBoxes"/>48</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="49" name="yearDayBoxes"/>49</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="50" name="yearDayBoxes"/>50</span>
                              <br/>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="51" name="yearDayBoxes"/>51</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="52" name="yearDayBoxes"/>52</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="53" name="yearDayBoxes"/>53</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="54" name="yearDayBoxes"/>54</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="55" name="yearDayBoxes"/>55</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="56" name="yearDayBoxes"/>56</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="57" name="yearDayBoxes"/>57</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="58" name="yearDayBoxes"/>58</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="59" name="yearDayBoxes"/>59</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="60" name="yearDayBoxes"/>60</span>
                              <br/>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="61" name="yearDayBoxes"/>61</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="62" name="yearDayBoxes"/>62</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="63" name="yearDayBoxes"/>63</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="64" name="yearDayBoxes"/>64</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="65" name="yearDayBoxes"/>65</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="66" name="yearDayBoxes"/>66</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="67" name="yearDayBoxes"/>67</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="68" name="yearDayBoxes"/>68</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="69" name="yearDayBoxes"/>69</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="70" name="yearDayBoxes"/>70</span>
                              <br/>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="71" name="yearDayBoxes"/>71</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="72" name="yearDayBoxes"/>72</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="73" name="yearDayBoxes"/>73</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="74" name="yearDayBoxes"/>74</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="75" name="yearDayBoxes"/>75</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="76" name="yearDayBoxes"/>76</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="77" name="yearDayBoxes"/>77</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="78" name="yearDayBoxes"/>78</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="79" name="yearDayBoxes"/>79</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="80" name="yearDayBoxes"/>80</span>
                              <br/>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="81" name="yearDayBoxes"/>81</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="82" name="yearDayBoxes"/>82</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="83" name="yearDayBoxes"/>83</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="84" name="yearDayBoxes"/>84</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="85" name="yearDayBoxes"/>85</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="86" name="yearDayBoxes"/>86</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="87" name="yearDayBoxes"/>87</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="88" name="yearDayBoxes"/>88</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="89" name="yearDayBoxes"/>89</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="90" name="yearDayBoxes"/>90</span>
                              <br/>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="91" name="yearDayBoxes"/>91</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="92" name="yearDayBoxes"/>92</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="93" name="yearDayBoxes"/>93</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="94" name="yearDayBoxes"/>94</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="95" name="yearDayBoxes"/>95</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="96" name="yearDayBoxes"/>96</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="97" name="yearDayBoxes"/>97</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="98" name="yearDayBoxes"/>98</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="99" name="yearDayBoxes"/>99</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="100" name="yearDayBoxes"/>100</span>
                              <br/>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="101" name="yearDayBoxes"/>101</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="102" name="yearDayBoxes"/>102</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="103" name="yearDayBoxes"/>103</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="104" name="yearDayBoxes"/>104</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="105" name="yearDayBoxes"/>105</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="106" name="yearDayBoxes"/>106</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="107" name="yearDayBoxes"/>107</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="108" name="yearDayBoxes"/>108</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="109" name="yearDayBoxes"/>109</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="110" name="yearDayBoxes"/>110</span>
                              <br/>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="111" name="yearDayBoxes"/>111</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="112" name="yearDayBoxes"/>112</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="113" name="yearDayBoxes"/>113</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="114" name="yearDayBoxes"/>114</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="115" name="yearDayBoxes"/>115</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="116" name="yearDayBoxes"/>116</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="117" name="yearDayBoxes"/>117</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="118" name="yearDayBoxes"/>118</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="119" name="yearDayBoxes"/>119</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="120" name="yearDayBoxes"/>120</span>
                              <br/>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="121" name="yearDayBoxes"/>121</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="122" name="yearDayBoxes"/>122</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="123" name="yearDayBoxes"/>123</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="124" name="yearDayBoxes"/>124</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="125" name="yearDayBoxes"/>125</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="126" name="yearDayBoxes"/>126</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="127" name="yearDayBoxes"/>127</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="128" name="yearDayBoxes"/>128</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="129" name="yearDayBoxes"/>129</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="130" name="yearDayBoxes"/>130</span>
                              <br/>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="131" name="yearDayBoxes"/>131</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="132" name="yearDayBoxes"/>132</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="133" name="yearDayBoxes"/>133</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="134" name="yearDayBoxes"/>134</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="135" name="yearDayBoxes"/>135</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="136" name="yearDayBoxes"/>136</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="137" name="yearDayBoxes"/>137</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="138" name="yearDayBoxes"/>138</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="139" name="yearDayBoxes"/>139</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="140" name="yearDayBoxes"/>140</span>
                              <br/>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="141" name="yearDayBoxes"/>141</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="142" name="yearDayBoxes"/>142</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="143" name="yearDayBoxes"/>143</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="144" name="yearDayBoxes"/>144</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="145" name="yearDayBoxes"/>145</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="146" name="yearDayBoxes"/>146</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="147" name="yearDayBoxes"/>147</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="148" name="yearDayBoxes"/>148</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="149" name="yearDayBoxes"/>149</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="150" name="yearDayBoxes"/>150</span>
                              <br/>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="151" name="yearDayBoxes"/>151</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="152" name="yearDayBoxes"/>152</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="153" name="yearDayBoxes"/>153</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="154" name="yearDayBoxes"/>154</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="155" name="yearDayBoxes"/>155</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="156" name="yearDayBoxes"/>156</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="157" name="yearDayBoxes"/>157</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="158" name="yearDayBoxes"/>158</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="159" name="yearDayBoxes"/>159</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="160" name="yearDayBoxes"/>160</span>
                              <br/>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="161" name="yearDayBoxes"/>161</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="162" name="yearDayBoxes"/>162</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="163" name="yearDayBoxes"/>163</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="164" name="yearDayBoxes"/>164</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="165" name="yearDayBoxes"/>165</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="166" name="yearDayBoxes"/>166</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="167" name="yearDayBoxes"/>167</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="168" name="yearDayBoxes"/>168</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="169" name="yearDayBoxes"/>169</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="170" name="yearDayBoxes"/>170</span>
                              <br/>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="171" name="yearDayBoxes"/>171</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="172" name="yearDayBoxes"/>172</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="173" name="yearDayBoxes"/>173</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="174" name="yearDayBoxes"/>174</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="175" name="yearDayBoxes"/>175</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="176" name="yearDayBoxes"/>176</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="177" name="yearDayBoxes"/>177</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="178" name="yearDayBoxes"/>178</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="179" name="yearDayBoxes"/>179</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="180" name="yearDayBoxes"/>180</span>
                              <br/>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="181" name="yearDayBoxes"/>181</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="182" name="yearDayBoxes"/>182</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="183" name="yearDayBoxes"/>183</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="184" name="yearDayBoxes"/>184</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="185" name="yearDayBoxes"/>185</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="186" name="yearDayBoxes"/>186</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="187" name="yearDayBoxes"/>187</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="188" name="yearDayBoxes"/>188</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="189" name="yearDayBoxes"/>189</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="190" name="yearDayBoxes"/>190</span>
                              <br/>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="191" name="yearDayBoxes"/>191</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="192" name="yearDayBoxes"/>192</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="193" name="yearDayBoxes"/>193</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="194" name="yearDayBoxes"/>194</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="195" name="yearDayBoxes"/>195</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="196" name="yearDayBoxes"/>196</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="197" name="yearDayBoxes"/>197</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="198" name="yearDayBoxes"/>198</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="199" name="yearDayBoxes"/>199</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="200" name="yearDayBoxes"/>200</span>
                              <br/>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="201" name="yearDayBoxes"/>201</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="202" name="yearDayBoxes"/>202</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="203" name="yearDayBoxes"/>203</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="204" name="yearDayBoxes"/>204</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="205" name="yearDayBoxes"/>205</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="206" name="yearDayBoxes"/>206</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="207" name="yearDayBoxes"/>207</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="208" name="yearDayBoxes"/>208</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="209" name="yearDayBoxes"/>209</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="210" name="yearDayBoxes"/>210</span>
                              <br/>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="211" name="yearDayBoxes"/>211</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="212" name="yearDayBoxes"/>212</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="213" name="yearDayBoxes"/>213</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="214" name="yearDayBoxes"/>214</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="215" name="yearDayBoxes"/>215</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="216" name="yearDayBoxes"/>216</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="217" name="yearDayBoxes"/>217</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="218" name="yearDayBoxes"/>218</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="219" name="yearDayBoxes"/>219</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="220" name="yearDayBoxes"/>220</span>
                              <br/>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="221" name="yearDayBoxes"/>221</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="222" name="yearDayBoxes"/>222</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="223" name="yearDayBoxes"/>223</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="224" name="yearDayBoxes"/>224</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="225" name="yearDayBoxes"/>225</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="226" name="yearDayBoxes"/>226</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="227" name="yearDayBoxes"/>227</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="228" name="yearDayBoxes"/>228</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="229" name="yearDayBoxes"/>229</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="230" name="yearDayBoxes"/>230</span>
                              <br/>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="231" name="yearDayBoxes"/>231</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="232" name="yearDayBoxes"/>232</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="233" name="yearDayBoxes"/>233</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="234" name="yearDayBoxes"/>234</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="235" name="yearDayBoxes"/>235</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="236" name="yearDayBoxes"/>236</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="237" name="yearDayBoxes"/>237</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="238" name="yearDayBoxes"/>238</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="239" name="yearDayBoxes"/>239</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="240" name="yearDayBoxes"/>240</span>
                              <br/>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="241" name="yearDayBoxes"/>241</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="242" name="yearDayBoxes"/>242</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="243" name="yearDayBoxes"/>243</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="244" name="yearDayBoxes"/>244</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="245" name="yearDayBoxes"/>245</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="246" name="yearDayBoxes"/>246</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="247" name="yearDayBoxes"/>247</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="248" name="yearDayBoxes"/>248</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="249" name="yearDayBoxes"/>249</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="250" name="yearDayBoxes"/>250</span>
                              <br/>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="251" name="yearDayBoxes"/>251</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="252" name="yearDayBoxes"/>252</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="253" name="yearDayBoxes"/>253</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="254" name="yearDayBoxes"/>254</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="255" name="yearDayBoxes"/>255</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="256" name="yearDayBoxes"/>256</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="257" name="yearDayBoxes"/>257</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="258" name="yearDayBoxes"/>258</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="259" name="yearDayBoxes"/>259</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="260" name="yearDayBoxes"/>260</span>
                              <br/>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="261" name="yearDayBoxes"/>261</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="262" name="yearDayBoxes"/>262</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="263" name="yearDayBoxes"/>263</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="264" name="yearDayBoxes"/>264</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="265" name="yearDayBoxes"/>265</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="266" name="yearDayBoxes"/>266</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="267" name="yearDayBoxes"/>267</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="268" name="yearDayBoxes"/>268</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="269" name="yearDayBoxes"/>269</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="270" name="yearDayBoxes"/>270</span>
                              <br/>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="271" name="yearDayBoxes"/>271</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="272" name="yearDayBoxes"/>272</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="273" name="yearDayBoxes"/>273</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="274" name="yearDayBoxes"/>274</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="275" name="yearDayBoxes"/>275</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="276" name="yearDayBoxes"/>276</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="277" name="yearDayBoxes"/>277</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="278" name="yearDayBoxes"/>278</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="279" name="yearDayBoxes"/>279</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="280" name="yearDayBoxes"/>280</span>
                              <br/>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="281" name="yearDayBoxes"/>281</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="282" name="yearDayBoxes"/>282</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="283" name="yearDayBoxes"/>283</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="284" name="yearDayBoxes"/>284</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="285" name="yearDayBoxes"/>285</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="286" name="yearDayBoxes"/>286</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="287" name="yearDayBoxes"/>287</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="288" name="yearDayBoxes"/>288</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="289" name="yearDayBoxes"/>289</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="290" name="yearDayBoxes"/>290</span>
                              <br/>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="291" name="yearDayBoxes"/>291</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="292" name="yearDayBoxes"/>292</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="293" name="yearDayBoxes"/>293</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="294" name="yearDayBoxes"/>294</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="295" name="yearDayBoxes"/>295</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="296" name="yearDayBoxes"/>296</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="297" name="yearDayBoxes"/>297</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="298" name="yearDayBoxes"/>298</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="299" name="yearDayBoxes"/>299</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="300" name="yearDayBoxes"/>300</span>
                              <br/>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="301" name="yearDayBoxes"/>301</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="302" name="yearDayBoxes"/>302</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="303" name="yearDayBoxes"/>303</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="304" name="yearDayBoxes"/>304</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="305" name="yearDayBoxes"/>305</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="306" name="yearDayBoxes"/>306</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="307" name="yearDayBoxes"/>307</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="308" name="yearDayBoxes"/>308</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="309" name="yearDayBoxes"/>309</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="310" name="yearDayBoxes"/>310</span>
                              <br/>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="311" name="yearDayBoxes"/>311</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="312" name="yearDayBoxes"/>312</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="313" name="yearDayBoxes"/>313</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="314" name="yearDayBoxes"/>314</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="315" name="yearDayBoxes"/>315</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="316" name="yearDayBoxes"/>316</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="317" name="yearDayBoxes"/>317</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="318" name="yearDayBoxes"/>318</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="319" name="yearDayBoxes"/>319</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="320" name="yearDayBoxes"/>320</span>
                              <br/>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="321" name="yearDayBoxes"/>321</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="322" name="yearDayBoxes"/>322</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="323" name="yearDayBoxes"/>323</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="324" name="yearDayBoxes"/>324</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="325" name="yearDayBoxes"/>325</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="326" name="yearDayBoxes"/>326</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="327" name="yearDayBoxes"/>327</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="328" name="yearDayBoxes"/>328</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="329" name="yearDayBoxes"/>329</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="330" name="yearDayBoxes"/>330</span>
                              <br/>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="331" name="yearDayBoxes"/>331</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="332" name="yearDayBoxes"/>332</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="333" name="yearDayBoxes"/>333</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="334" name="yearDayBoxes"/>334</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="335" name="yearDayBoxes"/>335</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="336" name="yearDayBoxes"/>336</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="337" name="yearDayBoxes"/>337</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="338" name="yearDayBoxes"/>338</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="339" name="yearDayBoxes"/>339</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="340" name="yearDayBoxes"/>340</span>
                              <br/>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="341" name="yearDayBoxes"/>341</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="342" name="yearDayBoxes"/>342</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="343" name="yearDayBoxes"/>343</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="344" name="yearDayBoxes"/>344</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="345" name="yearDayBoxes"/>345</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="346" name="yearDayBoxes"/>346</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="347" name="yearDayBoxes"/>347</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="348" name="yearDayBoxes"/>348</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="349" name="yearDayBoxes"/>349</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="350" name="yearDayBoxes"/>350</span>
                              <br/>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="351" name="yearDayBoxes"/>351</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="352" name="yearDayBoxes"/>352</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="353" name="yearDayBoxes"/>353</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="354" name="yearDayBoxes"/>354</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="355" name="yearDayBoxes"/>355</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="356" name="yearDayBoxes"/>356</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="357" name="yearDayBoxes"/>357</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="358" name="yearDayBoxes"/>358</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="359" name="yearDayBoxes"/>359</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="360" name="yearDayBoxes"/>360</span>
                              <br/>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="361" name="yearDayBoxes"/>361</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="362" name="yearDayBoxes"/>362</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="363" name="yearDayBoxes"/>363</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="364" name="yearDayBoxes"/>364</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="365" name="yearDayBoxes"/>365</span>
                              <span class="chkBoxListItem">
                                <input type="checkbox" value="366" name="yearDayBoxes"/>366</span>
                              <br/>
                            </div>
                          </p>
                          <p>
                            <xsl:copy-of select="$bwStr-AEEF-WeekStart"/>
                            <select name="yearWkst">
                              <xsl:for-each select="/bedework/shortdaynames/val">
                                <xsl:variable name="pos" select="position()"/>
                                <option>
                                  <xsl:attribute name="value"><xsl:value-of select="/bedework/recurdayvals/val[position() = $pos]"/></xsl:attribute>
                                  <xsl:value-of select="."/>
                                </option>
                              </xsl:for-each>
                            </select>
                          </p>
                        </div>
                      </td>
                    </tr>
                  </table>
                  <h4>
                    <xsl:if test="$canEdit = 'false'"><xsl:attribute name="class">invisible</xsl:attribute></xsl:if>
                    <xsl:copy-of select="$bwStr-AEEF-RecurrenceAndExceptionDates"/>
                  </h4>
                  <div id="raContent">
                    <div class="dateStartEndBox" id="rdatesFormFields">
                      <xsl:if test="$canEdit = 'false'"><xsl:attribute name="class">invisible</xsl:attribute></xsl:if>
                      <!--
                        <input type="checkbox" name="dateOnly" id="rdateDateOnly" onclick="swapRdateAllDay(this)" value="true"/>
                        all day
                        <input type="checkbox" name="floating" id="rdateFloating" onclick="swapRdateFloatingTime(this)" value="true"/>
                        floating
                        store time as coordinated universal time (UTC)
                        <input type="checkbox" name="storeUTC" id="rdateStoreUTC" onclick="swapRdateStoreUTC(this)" value="true"/>
                        store as UTC<br/>-->
                      <div class="dateFields">
                        <!-- input name="eventRdate.date"
                                 dojoType="dropdowndatepicker"
                                 formatLength="medium"
                                 value="today"
                                 saveFormat="yyyyMMdd"
                                 id="bwEventWidgeRdate"
                                 iconURL="{$resourcesRoot}/images/calIcon.gif"/-->
                        <input type="text" name="eventRdate.date" id="bwEventWidgetRdate" size="10"/>
                        <script type="text/javascript">
                          <xsl:comment>
                            /*$("#bwEventWidgetRdate").datepicker({
                              defaultDate: new Date(<xsl:value-of select="form/start/yearText/input/@value"/>, <xsl:value-of select="number(form/start/month/select/option[@selected = 'selected']/@value) - 1"/>, <xsl:value-of select="form/start/day/select/option[@selected = 'selected']/@value"/>),
                              dateFormat: "yymmdd"
                            }).attr("readonly", "readonly");
                            $("#bwEventWidgetRdate").val('<xsl:value-of select="substring-before(form/start/rfc3339DateTime,'T')"/>');*/
                          </xsl:comment>
                        </script>
                      </div>
                      <div id="rdateTimeFields" class="timeFields">
                        <select name="eventRdate.hour" id="eventRdateHour">
                          <option value="00">00</option>
                          <option value="01">01</option>
                          <option value="02">02</option>
                          <option value="03">03</option>
                          <option value="04">04</option>
                          <option value="05">05</option>
                          <option value="06">06</option>
                          <option value="07">07</option>
                          <option value="08">08</option>
                          <option value="09">09</option>
                          <option value="10">10</option>
                          <option value="11">11</option>
                          <option value="12" selected="selected">12</option>
                          <option value="13">13</option>
                          <option value="14">14</option>
                          <option value="15">15</option>
                          <option value="16">16</option>
                          <option value="17">17</option>
                          <option value="18">18</option>
                          <option value="19">19</option>
                          <option value="20">20</option>
                          <option value="21">21</option>
                          <option value="22">22</option>
                          <option value="23">23</option>
                        </select>
                        <select name="eventRdate.minute" id="eventRdateMinute">
                          <option value="00" selected="selected">00</option>
                          <option value="05">05</option>
                          <option value="10">10</option>
                          <option value="15">15</option>
                          <option value="20">20</option>
                          <option value="25">25</option>
                          <option value="30">30</option>
                          <option value="35">35</option>
                          <option value="40">40</option>
                          <option value="45">45</option>
                          <option value="50">50</option>
                          <option value="55">55</option>
                        </select>
                        <xsl:text> </xsl:text>
                        <img src="{$resourcesRoot}/images/clockIcon.gif" width="16" height="15" id="bwRecExcClock" alt="*"/>

                        <select name="tzid" id="rdateTzid" class="timezones">
                          <xsl:if test="form/floating/input/@checked='checked'"><xsl:attribute name="disabled">disabled</xsl:attribute></xsl:if>
                          <option value=""><xsl:copy-of select="$bwStr-AEEF-SelectTimezone"/></option>
                          <xsl:variable name="rdateTzId" select="/bedework/now/defaultTzid"/>
                          <xsl:for-each select="/bedework/timezones/timezone">
                            <option>
                              <xsl:attribute name="value"><xsl:value-of select="id"/></xsl:attribute>
                              <xsl:if test="$rdateTzId = id"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
                              <xsl:value-of select="name"/>
                            </option>
                          </xsl:for-each>
                        </select>
                      </div>
                      <xsl:text> </xsl:text>
                      <!--bwRdates.update() accepts: date, time, allDay, floating, utc, tzid-->
                      <span>
                        <xsl:if test="$canEdit = 'false'"><xsl:attribute name="class">invisible</xsl:attribute></xsl:if>
                        <input type="button" name="rdate" value="{$bwStr-AEEF-AddRecurance}" onclick="bwRdates.update(this.form['eventRdate.date'].value,this.form['eventRdate.hour'].value + this.form['eventRdate.minute'].value,false,false,false,this.form.tzid.value)"/>
                        <!-- input type="button" name="exdate" value="add exception" onclick="bwExdates.update(this.form['eventRdate.date'].value,this.form['eventRdate.hour'].value + this.form['eventRdate.minute'].value,false,false,false,this.form.tzid.value)"/-->
                      </span>
                      <br class="clear"/>

                      <input type="hidden" name="rdates" value="" id="bwRdatesField"/>
                      <!-- if there are no recurrence dates, the following table will show -->
                      <table cellspacing="0" class="invisible" id="bwCurrentRdatesNone">
                        <tr><th><xsl:copy-of select="$bwStr-AEEF-RecurrenceDates"/></th></tr>
                        <tr><td><xsl:copy-of select="$bwStr-AEEF-NoRecurrenceDates"/></td></tr>
                      </table>

                      <!-- if there are recurrence dates, the following table will show -->
                      <table cellspacing="0" class="invisible" id="bwCurrentRdates">
                        <tr>
                          <th colspan="4"><xsl:copy-of select="$bwStr-AEEF-RecurrenceDates"/></th>
                        </tr>
                        <tr class="colNames">
                          <td><xsl:copy-of select="$bwStr-AEEF-Date"/></td>
                          <td><xsl:copy-of select="$bwStr-AEEF-TIME"/></td>
                          <td><xsl:copy-of select="$bwStr-AEEF-TZid"/></td>
                          <td></td>
                        </tr>
                      </table>

                      <input type="hidden" name="exdates" value="" id="bwExdatesField"/>
                      <!-- if there are no exception dates, the following table will show -->
                      <table cellspacing="0" class="invisible" id="bwCurrentExdatesNone">
                        <tr><th><xsl:copy-of select="$bwStr-AEEF-ExceptionDates"/></th></tr>
                        <tr><td><xsl:copy-of select="$bwStr-AEEF-NoExceptionDates"/></td></tr>
                      </table>

                      <!-- if there are exception dates, the following table will show -->
                      <table cellspacing="0" class="invisible" id="bwCurrentExdates">
                        <tr>
                          <th colspan="4"><xsl:copy-of select="$bwStr-AEEF-NoExceptionDates"/></th>
                        </tr>
                        <tr class="colNames">
                          <td><xsl:copy-of select="$bwStr-AEEF-Date"/></td>
                          <td><xsl:copy-of select="$bwStr-AEEF-TIME"/></td>
                          <td><xsl:copy-of select="$bwStr-AEEF-TZid"/></td>
                          <td></td>
                        </tr>
                      </table>
                      <p>
                        <xsl:copy-of select="$bwStr-AEEF-ExceptionDatesMayBeCreated"/>
                      </p>
                    </div>
                  </div>
                </div>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <!--  Status  -->
        <tr>
          <td class="fieldName">
            <xsl:copy-of select="$bwStr-AEEF-Status"/>
          </td>
          <td>
            <span>
              <xsl:if test="$canEdit = 'false'"><xsl:attribute name="class">invisible</xsl:attribute></xsl:if>
              <input type="radio" name="eventStatus" id="bwStatusConfirmedButton" value="CONFIRMED" checked="checked">
                <xsl:if test="form/status = 'CONFIRMED'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
              </input>
              <label for="bwStatusConfirmedButton">
                <xsl:copy-of select="$bwStr-AEEF-Confirmed"/>
              </label>
              <input type="radio" name="eventStatus" id="bwStatusTentativeButton" value="TENTATIVE">
                <xsl:if test="form/status = 'TENTATIVE'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
              </input>
              <label for="bwStatusTentativeButton">
                <xsl:copy-of select="$bwStr-AEEF-Tentative"/>
              </label>
              <input type="radio" name="eventStatus" id="bwStatusCancelledButton" value="CANCELLED">
                <xsl:if test="form/status = 'CANCELLED'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
              </input>
              <label for="bwStatusCancelledButton">
                <xsl:copy-of select="$bwStr-AEEF-Canceled"/>
              </label>
            </span>
            <xsl:if test="$canEdit = 'false'">
              <xsl:value-of select="form/status"/>
            </xsl:if>
          </td>
        </tr>
        <!--  Transparency  --><!-- let's not set this in the public client, and let the defaults hold
        <tr>
          <xsl:if test="$canEdit = 'false'"><xsl:attribute name="class">invisible</xsl:attribute></xsl:if>
          <td class="fieldName">
            <xsl:copy-of select="$bwStr-AEEF-AffectsFreeBusy"/>
          </td>
          <td align="left" class="padMeTop">
            <input type="radio" value="OPAQUE" name="transparency">
              <xsl:if test="form/transparency = 'OPAQUE' or not(form/transparency)"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
            </input>
            <xsl:copy-of select="$bwStr-AEEF-YesOpaque"/>

            <input type="radio" value="TRANSPARENT" name="transparency">
              <xsl:if test="form/transparency = 'TRANSPARENT'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
            </input>
            <xsl:copy-of select="$bwStr-AEEF-NoTransparent"/>
          </td>
        </tr> --><!--  Description  -->
        <tr>
          <td class="fieldName">
            <xsl:copy-of select="$bwStr-AEEF-Description"/>
          </td>
          <td>
            <textarea name="description" id="description" cols="80" rows="8" placeholder="{$bwStr-AEEF-EnterPertientInfo}" required="required">
              <xsl:if test="$canEdit = 'false'"><xsl:attribute name="class">invisible</xsl:attribute></xsl:if>
              <xsl:value-of select="form/desc/textarea"/>
              <xsl:if test="form/desc/textarea = ''"><xsl:text> </xsl:text></xsl:if>
            </textarea>
            <div class="fieldInfo">
              <xsl:if test="$canEdit = 'false'"><xsl:attribute name="class">invisible</xsl:attribute></xsl:if>
              <span class="maxCharNotice"><xsl:value-of select="form/descLength"/><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-AEEF-CharsMax"/></span>
              <span id="remainingChars">&#160;</span>
            </div>
            <xsl:if test="$canEdit = 'false'">
              <div class="bwHighlightBox">
                <xsl:value-of select="form/desc/textarea"/>
              </div>
            </xsl:if>
          </td>
        </tr>
        <!-- Cost -->
        <tr class="optional">
          <xsl:if test="$canEdit = 'false'"><xsl:attribute name="class">invisible</xsl:attribute></xsl:if>
          <td class="fieldName">
            <xsl:copy-of select="$bwStr-AEEF-Cost"/>
          </td>
          <td>
            <input type="text" size="80" name="eventCost" placeholder="{$bwStr-AEEF-OptionalPlaceToPurchaseTicks}">
              <xsl:attribute name="value"><xsl:value-of select="form/cost/input/@value"/></xsl:attribute>
            </input>
          </td>
        </tr>
        <!-- Url -->
        <tr class="optional">
          <xsl:if test="$canEdit = 'false'"><xsl:attribute name="class">invisible</xsl:attribute></xsl:if>
          <td class="fieldName">
            <xsl:copy-of select="$bwStr-AEEF-EventURL"/>
          </td>
          <td>
            <input type="text" name="eventLink" size="80" placeholder="{$bwStr-AEEF-OptionalMoreEventInfo}">
              <xsl:attribute name="value"><xsl:value-of select="form/link/input/@value"/></xsl:attribute>
              <!-- xsl:if test="$canEdit = 'false'"><xsl:attribute name="disabled">disabled</xsl:attribute></xsl:if-->
            </input>
          </td>
        </tr>
        <!-- Image Url -->
        <tr class="optional" id="bwImageUrl">
          <xsl:if test="$canEdit = 'false'"><xsl:attribute name="class">invisible</xsl:attribute></xsl:if>
          <td class="fieldName">
            <xsl:copy-of select="$bwStr-AEEF-Image"/>
          </td>
          <td>
            <xsl:if test="form/xproperties/node()[name()='X-BEDEWORK-IMAGE'] or form/xproperties/node()[name()='X-BEDEWORK-THUMB-IMAGE']">
              <xsl:variable name="imgPrefix">
                <xsl:choose>
                  <xsl:when test="starts-with(form/xproperties/node()[name()='X-BEDEWORK-IMAGE']/values/text,'http') or
                                  starts-with(form/xproperties/node()[name()='X-BEDEWORK-IMAGE']/values/text,'https')"></xsl:when>
                  <xsl:otherwise><xsl:value-of select="$bwEventImagePrefix"/></xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              <xsl:variable name="imgThumbPrefix">
                <xsl:choose>
                  <xsl:when test="starts-with(form/xproperties/node()[name()='X-BEDEWORK-THUMB-IMAGE']/values/text,'http') or
                                  starts-with(form/xproperties/node()[name()='X-BEDEWORK-THUMB-IMAGE']/values/text,'https')"></xsl:when>
                  <xsl:otherwise><xsl:value-of select="$bwEventImagePrefix"/></xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              <div id="eventFormImage">
                <xsl:if test="form/xproperties/node()[name()='X-BEDEWORK-IMAGE']">
                  <img class="fullImage">
                    <xsl:attribute name="src"><xsl:value-of select="$imgPrefix"/><xsl:value-of select="normalize-space(form/xproperties/node()[name()='X-BEDEWORK-IMAGE']/values/text)"/></xsl:attribute>
                    <xsl:attribute name="alt"><xsl:value-of select="form/title/input/@value"/></xsl:attribute>
                  </img>
                </xsl:if>
                <xsl:if test="form/xproperties/node()[name()='X-BEDEWORK-THUMB-IMAGE']">
                  <img class="thumbImage">
                    <xsl:attribute name="src"><xsl:value-of select="$imgThumbPrefix"/><xsl:value-of select="normalize-space(form/xproperties/node()[name()='X-BEDEWORK-THUMB-IMAGE']/values/text)"/></xsl:attribute>
                    <xsl:attribute name="alt"><xsl:value-of select="form/title/input/@value"/></xsl:attribute>
                  </img>
                </xsl:if>
              </div>
            </xsl:if>
            <label class="interiorLabel" for="xBwImageHolder">
              <xsl:copy-of select="$bwStr-AEEF-ImageURL"/>
            </label>
            <xsl:text> </xsl:text>
            <input type="text" name="xBwImageHolder" id="xBwImageHolder" value="" size="60" placeholder="{$bwStr-AEEF-OptionalEventImage}">
              <xsl:attribute name="value"><xsl:value-of select="form/xproperties/node()[name()='X-BEDEWORK-IMAGE']/values/text" disable-output-escaping="yes"/></xsl:attribute>
            </input>
            <br/>
            <label class="interiorLabel" for="xBwImageThumbHolder">
              <xsl:copy-of select="$bwStr-AEEF-ImageThumbURL"/>
            </label>
            <xsl:text> </xsl:text>
            <input type="text" name="xBwImageThumbHolder" id="xBwImageThumbHolder" value="" size="60" placeholder="{$bwStr-AEEF-OptionalEventThumbImage}">
              <xsl:attribute name="value"><xsl:value-of select="form/xproperties/node()[name()='X-BEDEWORK-THUMB-IMAGE']/values/text" disable-output-escaping="yes"/></xsl:attribute>
            </input>
            <br/>
            <xsl:if test="/bedework/imageUploadDirectory">
              <label class="interiorLabel" for="eventImageUpload">
                <xsl:copy-of select="$bwStr-AEEF-ImageUpload"/>
              </label>
              <xsl:text> </xsl:text>
              <input type="file" name="eventImageUpload" id="eventImageUpload" size="45"/>
              <input type="checkbox" name="replaceImage" id="replaceImage" value="true"/><label for="replaceImage"><xsl:copy-of select="$bwStr-AEEF-Overwrite"/></label>
              <!-- button name="eventImageUseExisting" id="eventImageUseExisting"><xsl:copy-of select="$bwStr-AEEF-UseExisting"/></button-->
              <br/>
              <div class="fieldInfoAlone">
                <xsl:copy-of select="$bwStr-AEEF-OptionalImageUpload"/>
              </div>
            </xsl:if>
            <label class="interiorLabel" for="xBwImageDescHolder">
              <xsl:copy-of select="$bwStr-AEEF-ImageDesc"/>
            </label>
            <xsl:text> </xsl:text>
            <input type="text" name="xBwImageDescHolder" id="xBwImageDescHolder" value="" size="60">
              <xsl:attribute name="value"><xsl:value-of select="form/xproperties/node()[name()='X-BEDEWORK-IMAGE']/parameters/node()[name()='X-BEDEWORK-PARAM-DESCRIPTION']"/></xsl:attribute>
            </input>
            <br/>
            <label class="interiorLabel" for="xBwImageAltHolder">
              <xsl:copy-of select="$bwStr-AEEF-ImageAlt"/>
            </label>
            <xsl:text> </xsl:text>
            <input type="text" name="xBwImageAltHolder" id="xBwImageAltHolder" value="" size="60">
              <xsl:attribute name="value"><xsl:value-of select="form/xproperties/node()[name()='X-BEDEWORK-IMAGE']/parameters/node()[name()='X-BEDEWORK-PARAM-ALT']"/></xsl:attribute>
            </input>
            <xsl:if test="/bedework/creating = 'false' and form/xproperties/node()[name()='X-BEDEWORK-IMAGE']">
              <div class="fieldInfoAlone">
                <button id="eventImageRemoveButton" onclick="removeEventImage(this.form.xBwImageHolder,this.form.xBwImageThumbHolder,this.form.xBwImageDescHolder,this.form.xBwImageAltHolder);return false;"><xsl:copy-of select="$bwStr-AEEF-RemoveImages"/></button>
              </div>
            </xsl:if>
          </td>
        </tr>
        <!-- Location -->
        <tr>
          <td class="fieldName">
            <xsl:copy-of select="$bwStr-AEEF-Location"/>
          </td>
          <td id="bwLocationsCell">
            <div id="bwLocationsFormContainer">
              <xsl:if test="$canEdit = 'false'">
                <xsl:attribute name="class">invisible</xsl:attribute>
              </xsl:if>
              <input type="hidden" name="allLocationId" id="bwLocation">
                <xsl:attribute name="value"><xsl:value-of select="form/location/all/select/option[@selected='selected']/@value"/></xsl:attribute>
              </input>
              <div id="bwLocationsPrimaryContainer">
                <label for="bwLocationsPrimary">
                  <xsl:value-of select="$bwStr-AEEF-AddressPrimary"/>
                </label>
                <select id="bwLocationsPrimary">
                  <option class="bwSelectTopOption"></option>
                </select>
              </div>
              <div id="bwLocationsSecondaryContainer">
                <label for="bwLocationsSecondary">
                  <xsl:value-of select="$bwStr-AEEF-AddressSecondary"/>
                </label>
                <select id="bwLocationsSecondary">
                  <option class="bwSelectTopOption"><xsl:value-of select="$bwStr-AEEF-None"/></option>
                </select>
                <a href="#bwAddRoomContainer" id="bwAddRoomLink" onclick="return bwCheckPrimaryLoc();">
                  <xsl:attribute name="title"><xsl:value-of select="$bwStr-AEEF-AddSecAddress"/></xsl:attribute>
                  <xsl:if test="not(form/location/all/select/option[@selected='selected'])">
                    <xsl:attribute name="class">disabled</xsl:attribute>
                  </xsl:if>
                  <xsl:value-of select="$bwStr-AEEF-Add"/>
                </a>
              </div>
            </div>
            <xsl:if test="$canEdit = 'false'">
              <xsl:value-of select="form/location/all/select/option[@selected]"/>
            </xsl:if>
          </td>
        </tr>

        <!-- Contact -->
        <tr>
          <td class="fieldName">
            <xsl:copy-of select="$bwStr-AEEF-Contact"/>
          </td>
          <td>
            <input type="hidden" name="allContactId" id="bwContact">
              <xsl:attribute name="value"><xsl:value-of select="form/contact/all/select/option[@selected='selected']/@value"/></xsl:attribute>
            </input>
            <input type="hidden" name="prefContactId" id="bwPrefContact">
              <xsl:attribute name="value"><xsl:value-of select="form/contact/preferred/select/option[@selected='selected']/@value"/></xsl:attribute>
            </input>
            <div id="bwContactsFormContainer">
              <xsl:if test="$canEdit = 'false'"><xsl:attribute name="class">invisible</xsl:attribute></xsl:if>
              <xsl:variable name="showAllContactsListOnFirstLoad">
                <xsl:choose>
                  <xsl:when test="not(form/contact/preferred/select/option) or
                                  (not(form/contact/preferred/select/option/@selected) and form/contact/all/select/option/@selected) or
                                  (form/contact/all/select/option[@selected='selected']/@value != form/contact/preferred/select/option[@selected='selected']/@value)">true</xsl:when>
                  <xsl:otherwise>false</xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              <xsl:if test="form/contact/preferred/select/option">
                <xsl:if test="$showAllContactsListOnFirstLoad = 'true'">
                  <xsl:attribute name="class">invisible</xsl:attribute>
                </xsl:if>
                <div id="bwPrefContactContainer">
                  <select name="prefContactHolder" id="bwPreferredContactList">
                    <option value="">
                      <xsl:copy-of select="$bwStr-AEEF-SelectColon"/>
                    </option>
                    <xsl:copy-of select="form/contact/preferred/select/*"/>
                  </select>
                </div>
              </xsl:if>
              <div id="bwAllContactContainer">
                <xsl:if test="$showAllContactsListOnFirstLoad = 'false'">
                  <xsl:attribute name="class">invisible</xsl:attribute>
                </xsl:if>
                <select name="allContactHolder" id="bwAllContactList">
                  <option value="">
                    <xsl:copy-of select="$bwStr-AEEF-SelectColon"/>
                  </option>
                  <xsl:choose>
                    <xsl:when test="$showAllContactsListOnFirstLoad = 'true'">
                      <xsl:copy-of select="form/contact/all/select/*"/>
                    </xsl:when>
                    <xsl:otherwise> <!-- reconstruct all list - strip out "selected" attribute -->
                      <xsl:for-each select="form/contact/all/select/option">
                        <option>
                          <xsl:attribute name="value"><xsl:value-of select="@value"/></xsl:attribute>
                          <xsl:value-of select="."/>
                        </option>
                      </xsl:for-each>
                    </xsl:otherwise>
                  </xsl:choose>
                </select>
              </div>
              <xsl:text> </xsl:text>
              <!-- allow for toggling between the preferred and all contacts listings if preferred
                   contacts exist -->
              <xsl:if test="form/contact/preferred/select/option">
                <div class="container">
                  <input type="radio" name="toggleContactLists" id="bwContactPreferredButton" value="preferred" onclick="changeClass('bwPrefContactContainer','shown');changeClass('bwAllContactContainer','invisible');">
                    <xsl:if test="$showAllContactsListOnFirstLoad = 'false'">
                      <xsl:attribute name="checked">checked</xsl:attribute>
                    </xsl:if>
                  </input>
                  <label for="bwContactPreferredButton">
                    <xsl:copy-of select="$bwStr-AEEF-Preferred"/>
                  </label>
                  <input type="radio" name="toggleContactLists" id="bwContactAllButton" value="all" onclick="changeClass('bwPrefContactContainer','invisible');changeClass('bwAllContactContainer','shown');">
                    <xsl:if test="$showAllContactsListOnFirstLoad = 'true'">
                      <xsl:attribute name="checked">checked</xsl:attribute>
                    </xsl:if>
                  </input>
                  <label for="bwContactAllButton">
                    <xsl:copy-of select="$bwStr-AEEF-All"/>
                  </label>
                </div>
              </xsl:if>
            </div>
            <xsl:if test="$canEdit = 'false'">
              <xsl:value-of select="form/contact/all/select/option[@selected]"/>
            </xsl:if>
          </td>
        </tr>

        <xsl:if test="$canEdit = 'false'">
          <tr>
            <td class="fieldName">
              <xsl:copy-of select="$bwStr-AEEF-Creator"/>
            </td>
            <td>
              <xsl:call-template name="substring-afterLastInstanceOf">
                <xsl:with-param name="string" select="creator"/>
                <xsl:with-param name="char">/</xsl:with-param>
              </xsl:call-template>
            </td>
          </tr>
        </xsl:if>

        <!-- Registration settings --><!-- Display and use only if we've set an event reg admin token in the admin web client's system parameters -->
        <xsl:if test="eventRegAdminToken != ''">
          <tr class="optional">
            <xsl:if test="$canEdit = 'false'"><xsl:attribute name="class">invisible</xsl:attribute></xsl:if>
            <td class="fieldName"><xsl:copy-of select="$bwStr-AEEF-Registration"/></td>
            <td>
              <xsl:variable name="hasForm">
                <xsl:choose>
                  <xsl:when test="form/xproperties/node()[name()='X-BEDEWORK-REGISTRATION-FORM']/values/text">true</xsl:when>
                  <xsl:otherwise>false</xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              <input type="checkbox" id="bwIsRegisterableEvent" name="bwIsRegisterableEvent" onclick="showRegistrationFields(this,{$hasForm});">
                <xsl:if test="form/xproperties/node()[name()='X-BEDEWORK-MAX-TICKETS']">
                  <xsl:attribute name="checked">checked</xsl:attribute>
                  <xsl:attribute name="disabled">disabled</xsl:attribute>
                  <xsl:if test="$hasForm = 'false'">
                    <!-- On update, request custom fields from registration system IF no form is already defined;
                         On a new event, we retrieve these when clicking the checkbox above; on update, we
                         don't need (or want) them if a form is already defined -->
                    <script type="text/javascript">
                      $(document).ready(function() {
                        getCustomFields();
                      });
                    </script>
                  </xsl:if>
                </xsl:if>
              </input>
              <label for="bwIsRegisterableEvent"><xsl:copy-of select="$bwStr-AEEF-UsersMayRegister"/></label>

              <div id="bwRegistrationFields">
                <xsl:attribute name="class">
                  <xsl:choose>
                    <xsl:when test="form/xproperties/node()[name()='X-BEDEWORK-MAX-TICKETS']">visible</xsl:when>
                    <xsl:otherwise>invisible</xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
                <xsl:if test="/bedework/registrationsExternal = 'true'">
                  <!-- Expose the internal/external checkboxes - internal defaults to true -->
                  <input type="checkbox" id="bwRegisterableInternal" checked="checked" />
                  <label for="bwRegisterableInternal"><xsl:copy-of select="$bwStr-AEEF-InternalUsersMayRegister"/></label>
                  <input type="checkbox" id="bwRegisterableExternal" />
                  <label for="bwRegisterableExternal"><xsl:copy-of select="$bwStr-AEEF-ExternalUsersMayRegister"/></label>
                </xsl:if>
                <xsl:if test="/bedework/registrationsExternal = 'false'">
                  <input type="hidden" id="bwRegisterableNoExternal" value="true" />
                </xsl:if>
                <br/>

                <xsl:if test="form/xproperties/node()[name()='X-BEDEWORK-MAX-TICKETS']"><xsl:attribute name="class">visible</xsl:attribute></xsl:if>

                <label for="xBwMaxTicketsHolder" class="interiorLabel"><xsl:copy-of select="$bwStr-AEEF-MaxTickets"/></label>
                <input type="text" name="xBwMaxTicketsHolder" id="xBwMaxTicketsHolder" size="3">
                  <xsl:if test="form/xproperties/node()[name()='X-BEDEWORK-MAX-TICKETS']">
                    <xsl:attribute name="value"><xsl:value-of select="form/xproperties/node()[name()='X-BEDEWORK-MAX-TICKETS']/values/text"/></xsl:attribute>
                  </xsl:if>
                </input>
                <xsl:text> </xsl:text><span class="fieldInfo"><xsl:copy-of select="$bwStr-AEEF-MaxTicketsInfo"/></span><br/>

                <label for="xBwMaxTicketsPerUserHolder" class="interiorLabel"><xsl:copy-of select="$bwStr-AEEF-TicketsAllowed"/></label>
                <input type="text" name="xBwMaxTicketsPerUserHolder" id="xBwMaxTicketsPerUserHolder" value="1" size="3">
                  <xsl:if test="form/xproperties/node()[name()='X-BEDEWORK-MAX-TICKETS-PER-USER']">
                    <xsl:attribute name="value"><xsl:value-of select="form/xproperties/node()[name()='X-BEDEWORK-MAX-TICKETS-PER-USER']/values/text"/></xsl:attribute>
                  </xsl:if>
                </input>
                <xsl:text> </xsl:text><span class="fieldInfo"><xsl:copy-of select="$bwStr-AEEF-TicketsAllowedInfo"/></span><br/>

                <label for="xBwMaxWaitListHolder" class="interiorLabel"><xsl:copy-of select="$bwStr-AEEF-MaxWaitList"/></label>
                <input type="text" name="xBwMaxWaitListHolder" id="xBwMaxWaitListHolder" value="" size="4">
                  <xsl:if test="form/xproperties/node()[name()='X-BEDEWORK-WAIT-LIST-LIMIT']">
                    <xsl:attribute name="value"><xsl:value-of select="form/xproperties/node()[name()='X-BEDEWORK-WAIT-LIST-LIMIT']/values/text"/></xsl:attribute>
                  </xsl:if>
                </input>
                <xsl:text> </xsl:text><span class="fieldInfo"><xsl:copy-of select="$bwStr-AEEF-MaxWaitListInfo"/></span><br/>

                <label for="xBwRegistrationOpensDate" class="interiorLabel"><xsl:copy-of select="$bwStr-AEEF-RegistrationOpens"/></label>
                <div class="dateFields">
                  <input type="text" name="xBwRegistrationOpensDate" id="xBwRegistrationOpensDate" size="10"/>
                </div>
                <div class="timeFields" id="xBwRegistrationOpensTimeFields">
                  <select name="xBwRegistrationOpens.hour" id="xBwRegistrationOpensHour">
                    <xsl:copy-of select="form/start/hour/select/*"/>
                  </select>
                  <select name="xBwRegistrationOpens.minute" id="xBwRegistrationOpensMinute">
                    <xsl:copy-of select="form/start/minute/select/*"/>
                  </select>
                  <xsl:if test="form/start/ampm">
                    <select name="xBwRegistrationOpens.ampm" id="xBwRegistrationOpensAmpm">
                      <xsl:copy-of select="form/start/ampm/select/*"/>
                    </select>
                  </xsl:if>
                  <xsl:text> </xsl:text>
                  <img src="{$resourcesRoot}/images/clockIcon.gif" width="16" height="15" id="xBwRegistrationOpensClock" alt="*"/>

                  <select name="xBwRegistrationOpens.tzid" id="xBwRegistrationOpensTzid" class="timezones">
                    <xsl:if test="form/floating/input/@checked='checked'"><xsl:attribute name="disabled">disabled</xsl:attribute></xsl:if>
                    <option value="-1"><xsl:copy-of select="$bwStr-AEEF-SelectTimezone"/></option>
                    <xsl:variable name="xBwRegistrationOpensTzId" select="form/start/tzid"/>
                    <xsl:for-each select="/bedework/timezones/timezone">
                      <option>
                        <xsl:attribute name="value"><xsl:value-of select="id"/></xsl:attribute>
                        <xsl:if test="$xBwRegistrationOpensTzId = id"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
                        <xsl:value-of select="name"/>
                      </option>
                    </xsl:for-each>
                  </select>
                </div>
                <xsl:text> </xsl:text><span class="fieldInfo"><xsl:copy-of select="$bwStr-AEEF-RegistrationOpensInfo"/></span><br/>
                <!-- Set the registration start date/time fields if populated  -->
                <xsl:if test="form/xproperties/node()[name()='X-BEDEWORK-REGISTRATION-START']">
                  <script type="text/javascript">
                    $(document).ready(function() {
                      $("#xBwRegistrationOpensDate").val("<xsl:value-of select="substring(form/xproperties/node()[name()='X-BEDEWORK-REGISTRATION-START']/values/text,1,4)"/>-<xsl:value-of select="substring(form/xproperties/node()[name()='X-BEDEWORK-REGISTRATION-START']/values/text,5,2)"/>-<xsl:value-of select="substring(form/xproperties/node()[name()='X-BEDEWORK-REGISTRATION-START']/values/text,7,2)"/>");
                    <xsl:choose>
                      <xsl:when test="form/start/ampm"><!-- we're in am/pm mode -->
                      $("#xBwRegistrationOpensHour").val(function() {
                        return hour24ToAmpm("<xsl:value-of select="substring(form/xproperties/node()[name()='X-BEDEWORK-REGISTRATION-START']/values/text,10,2)"/>");
                      });
                      $("#xBwRegistrationOpensMinute").val(function() {
                        return timeString2Int("<xsl:value-of select="substring(form/xproperties/node()[name()='X-BEDEWORK-REGISTRATION-START']/values/text,12,2)"/>");
                      });
                      $("#xBwRegistrationOpensAmpm").val(function() {
                        return hour24GetAmpm("<xsl:value-of select="substring(form/xproperties/node()[name()='X-BEDEWORK-REGISTRATION-START']/values/text,10,2)"/>");
                      });
                      </xsl:when>
                      <xsl:otherwise>
                      $("#xBwRegistrationOpensHour").val(function() {
                        return timeString2Int("<xsl:value-of select="substring(form/xproperties/node()[name()='X-BEDEWORK-REGISTRATION-START']/values/text,10,2)"/>");
                      });
                      $("#xBwRegistrationOpensMinute").val(function() {
                        return timeString2Int("<xsl:value-of select="substring(form/xproperties/node()[name()='X-BEDEWORK-REGISTRATION-START']/values/text,12,2)"/>");
                      });
                      </xsl:otherwise>
                    </xsl:choose>
                       $("#xBwRegistrationOpensTzid").val("<xsl:value-of select="form/xproperties/node()[name()='X-BEDEWORK-REGISTRATION-START']/parameters/TZID"/>");
                    });
                  </script>
                </xsl:if>

                <label for="xBwRegistrationClosesDate" class="interiorLabel"><xsl:copy-of select="$bwStr-AEEF-RegistrationCloses"/></label>
                <div class="dateFields">
                  <input type="text" name="xBwRegistrationClosesDate" id="xBwRegistrationClosesDate" size="10"/>
                </div>
                <div class="timeFields" id="xBwRegistrationClosesTimeFields">
                  <select name="xBwRegistrationCloses.hour" id="xBwRegistrationClosesHour">
                    <xsl:copy-of select="form/start/hour/select/*"/>
                  </select>
                  <select name="xBwRegistrationCloses.minute" id="xBwRegistrationClosesMinute">
                    <xsl:copy-of select="form/start/minute/select/*"/>
                  </select>
                  <xsl:if test="form/start/ampm">
                    <select name="xBwRegistrationCloses.ampm" id="xBwRegistrationClosesAmpm">
                      <xsl:copy-of select="form/start/ampm/select/*"/>
                    </select>
                  </xsl:if>
                  <xsl:text> </xsl:text>
                  <img src="{$resourcesRoot}/images/clockIcon.gif" width="16" height="15" id="xBwRegistrationClosesClock" alt="*"/>

                  <select name="xBwRegistrationCloses.tzid" id="xBwRegistrationClosesTzid" class="timezones">
                    <xsl:if test="form/floating/input/@checked='checked'"><xsl:attribute name="disabled">disabled</xsl:attribute></xsl:if>
                    <option value="-1"><xsl:copy-of select="$bwStr-AEEF-SelectTimezone"/></option>
                    <xsl:variable name="xBwRegistrationClosesTzId" select="form/start/tzid"/>
                    <xsl:for-each select="/bedework/timezones/timezone">
                      <option>
                        <xsl:attribute name="value"><xsl:value-of select="id"/></xsl:attribute>
                        <xsl:if test="$xBwRegistrationClosesTzId = id"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
                        <xsl:value-of select="name"/>
                      </option>
                    </xsl:for-each>
                  </select>
                </div>
                <xsl:text> </xsl:text><span class="fieldInfo"><xsl:copy-of select="$bwStr-AEEF-RegistrationClosesInfo"/></span><br/>
                <!-- Set the registration end date/time fields if populated  -->
                <xsl:if test="form/xproperties/node()[name()='X-BEDEWORK-REGISTRATION-END']">
                  <script type="text/javascript">
                    $(document).ready(function() {
                      $("#xBwRegistrationClosesDate").val("<xsl:value-of select="substring(form/xproperties/node()[name()='X-BEDEWORK-REGISTRATION-END']/values/text,1,4)"/>-<xsl:value-of select="substring(form/xproperties/node()[name()='X-BEDEWORK-REGISTRATION-END']/values/text,5,2)"/>-<xsl:value-of select="substring(form/xproperties/node()[name()='X-BEDEWORK-REGISTRATION-END']/values/text,7,2)"/>");
                    <xsl:choose>
                      <xsl:when test="form/start/ampm"><!-- we're in am/pm mode -->
                      $("#xBwRegistrationClosesHour").val(function() {
                        return hour24ToAmpm("<xsl:value-of select="substring(form/xproperties/node()[name()='X-BEDEWORK-REGISTRATION-END']/values/text,10,2)"/>");
                      });
                      $("#xBwRegistrationClosesMinute").val(function() {
                        return timeString2Int("<xsl:value-of select="substring(form/xproperties/node()[name()='X-BEDEWORK-REGISTRATION-END']/values/text,12,2)"/>");
                      });
                      $("#xBwRegistrationClosesAmpm").val(function() {
                        return hour24GetAmpm("<xsl:value-of select="substring(form/xproperties/node()[name()='X-BEDEWORK-REGISTRATION-END']/values/text,10,2)"/>");
                      });
                      </xsl:when>
                      <xsl:otherwise>
                      $("#xBwRegistrationClosesHour").val(function() {
                        return timeString2Int("<xsl:value-of select="substring(form/xproperties/node()[name()='X-BEDEWORK-REGISTRATION-END']/values/text,10,2)"/>");
                      });
                      $("#xBwRegistrationClosesMinute").val(function() {
                        return timeString2Int("<xsl:value-of select="substring(form/xproperties/node()[name()='X-BEDEWORK-REGISTRATION-END']/values/text,12,2)"/>");
                      });
                      </xsl:otherwise>
                    </xsl:choose>
                      $("#xBwRegistrationClosesTzid").val("<xsl:value-of select="form/xproperties/node()[name()='X-BEDEWORK-REGISTRATION-END']/parameters/TZID"/>");
                    });
                  </script>
                </xsl:if>

                <!-- Custom Field Collections  -->
                <div id="customFieldsContainer">
                  <label for="xbwCustomFieldCollections" class="interiorLabel"><xsl:copy-of select="$bwStr-AEEF-CustomFields"/></label>
                  <div class="customFields">
                    <xsl:if test="form/xproperties/node()[name()='X-BEDEWORK-REGISTRATION-FORM']/values/text">
                      <!-- a form is attached to the event : display it -->
                      <div id="xbwCustomFieldCurrentFormHolder">
                        <strong><xsl:value-of select="substring-after(form/xproperties/node()[name()='X-BEDEWORK-REGISTRATION-FORM']/values/text,'|')"/></strong>
                        <a href="#" onclick="removeCustomFields();return false;" title="remove">
                          <span class="ui-icon 	ui-icon-close"><xsl:text> </xsl:text></span>
                          <xsl:copy-of select="$bwStr-AEEF-CustomFieldsRemove"/>
                        </a>
                      </div>
                    </xsl:if>
                    <div id="xbwCustomFieldCollectionsHolder">
                      <xsl:if test="form/xproperties/node()[name()='X-BEDEWORK-REGISTRATION-FORM']/values/text">
                        <xsl:attribute name="style">display: none;</xsl:attribute>
                      </xsl:if>
                      <select id="xbwCustomFieldCollections" onchange="toggleSuggestions(this.options[this.selectedIndex].getAttribute('class'))">
                        <option value=""><xsl:copy-of select="$bwStr-AEEF-CustomFieldsBlank"/></option>
                      </select>
                      <a href="#" onclick="getCustomFields();return false;" title="refresh">
                        <span class="ui-icon ui-icon-refresh"><xsl:text> </xsl:text></span>
                        <xsl:copy-of select="$bwStr-AEEF-CustomFieldsRefresh"/>
                      </a>
                    </div>
                    <xsl:variable name="listCustomFieldsUrl"><xsl:value-of select="$bwRegistrationRoot"/>/admin/listForms.do?calsuite=/principals/users/<xsl:value-of
                            select="/bedework/userInfo/user"/><![CDATA[&]]>atkn=<xsl:value-of
                            select="eventRegAdminToken"/></xsl:variable>
                    <a href="#" onclick="launchSizedWindow('{$listCustomFieldsUrl}', '1000', '600');return false;">
                      <span class="ui-icon ui-icon-gear"><xsl:text> </xsl:text></span><xsl:copy-of select="$bwStr-AEEF-CustomFieldsManage"/>
                    </a>
                  </div>
                  <xsl:text> </xsl:text>
                  <span class="fieldInfo">
                    <xsl:copy-of select="$bwStr-AEEF-CustomFieldsInfo"/>
                    <span id="bwToggleUnpublishedCustFieldsHolder">
                      <xsl:if test="form/xproperties/node()[name()='X-BEDEWORK-REGISTRATION-FORM']/values/text">
                         <xsl:attribute name="style">display:none</xsl:attribute>
                      </xsl:if>
                      <input type="checkbox" name="bwToggleUnpublishedCustFields"
                             id="bwToggleUnpublishedCustFields"
                             onclick="toggleUnpublishedCustomFields(this.checked)"/>
                      <label for="bwToggleUnpublishedCustFields">
                        <xsl:copy-of select="$bwStr-AEEF-CustomFieldsShowUnpublished"/>
                      </label>
                    </span>
                  </span>
                </div>
                <!-- Set the custom field names if any exist -->
                <xsl:variable name="getCustomFieldsUrl"><xsl:value-of select="$bwRegistrationRoot"/>/admin/selectForms.do?calsuite=/principals/users/<xsl:value-of
                        select="/bedework/userInfo/user"/><![CDATA[&]]>atkn=<xsl:value-of
                        select="eventRegAdminToken"/></xsl:variable>
                <script type="text/javascript">
                  function getCustomFields(noSet) {
                    var setIndex = true;
                    if (noSet != undefined) {
                      if(noSet) {
                        setIndex = false;
                      }
                    }
                    var customFieldsUrl = "<xsl:value-of select="$getCustomFieldsUrl" disable-output-escaping="yes"/>";
                    $.ajax({
                      method: "GET",
                      url: customFieldsUrl,
                      cache: false,
                      dataType: 'json'
                    })
                    .done(function(data) {
                      if (data.bwforms.length) {
                        var bwformsOptions = '<option value=""><xsl:copy-of select="$bwStr-AEEF-CustomFieldsSelect"/></option>';
                        var calsuitePrefix = '/principals/users/<xsl:value-of select="/bedework/userInfo/user"/>|';
                        $.each(data.bwforms, function( index, value ) {
                          if (value.status != 'disabled') {
                            bwformsOptions += '<option value="' + calsuitePrefix + value.name + '" class="' + value.status + '">' + value.name + '</option>';
                          }
                        });
                        $("#xbwCustomFieldCollections").html(bwformsOptions);
                        if($("#bwToggleUnpublishedCustFields").prop("checked")) {
                          $("#xbwCustomFieldCollections option.unpublished").show();
                        }
                        if (setIndex) {
                          $("#xbwCustomFieldCollections").val("<xsl:value-of select="form/xproperties/node()[name()='X-BEDEWORK-REGISTRATION-FORM']/values/text"/>");
                        }
                      }
                    })
                    .error(function(msg) {
                      <xsl:if test="$eventRegSsoEnabled = 'false'">
                        <!-- XXX A quick expedient - we'll want to do better (!) -->
                        <!-- We should not get here if SSO is enabled, the iframe below should authenticate the user -->
                        alert("You are not authenticated to the event registration system yet.\nPlease click 'add/manage' to authenticate.");
                      </xsl:if>
                    });
                  }
                </script>
                <xsl:if test="$eventRegSsoEnabled = 'true'">
                  <!-- single sign on for eventreg - connect to the service under the hood to allow authentication -->
                  <iframe style="display: none;" height="1" width="1">
                    <xsl:attribute name="src"><xsl:value-of select="$bwRegistrationRoot"/>/admin/auth.do?atkn=<xsl:value-of select="eventRegAdminToken"/></xsl:attribute>
                    <xsl:text> </xsl:text>
                  </iframe>
                </xsl:if>
                <xsl:if test="/bedework/creating = 'false'">
                  <p>
                    <xsl:variable name="registrationsHref"><xsl:value-of select="$bwRegistrationRoot"/>/admin/adminAgenda.do?href=<xsl:value-of select="form/calendar/event/encodedPath"/>/<xsl:value-of select="name"/>&amp;calsuite=/principals/users/<xsl:value-of
                            select="/bedework/userInfo/user"/>&amp;atkn=<xsl:value-of select="eventRegAdminToken"/><xsl:if
                            test="form/xproperties/node()[name()='X-BEDEWORK-REGISTRATION-FORM']">&amp;formName=<xsl:value-of select="substring-after(form/xproperties/node()[name()='X-BEDEWORK-REGISTRATION-FORM']/values/text,'|')"/></xsl:if></xsl:variable>
                    <xsl:variable name="registrationsDownloadHref"><xsl:value-of select="$bwRegistrationRoot"/>/admin/download.do?href=<xsl:value-of select="form/calendar/event/encodedPath"/>/<xsl:value-of select="name"/>&amp;calsuite=/principals/users/<xsl:value-of
                            select="/bedework/userInfo/user"/>&amp;atkn=<xsl:value-of select="eventRegAdminToken"/><xsl:if
                            test="form/xproperties/node()[name()='X-BEDEWORK-REGISTRATION-FORM']">&amp;formName=<xsl:value-of select="substring-after(form/xproperties/node()[name()='X-BEDEWORK-REGISTRATION-FORM']/values/text,'|')"/></xsl:if></xsl:variable>
                    <button onclick="launchSizedWindow('{$registrationsHref}', '1000', '600');return false;"><xsl:copy-of select="$bwStr-AEEF-ViewRegistrations"/></button>
                    <xsl:text> </xsl:text>
                    <!--<button onclick="location.href='{$registrationsDownloadHref}';return false;"><xsl:copy-of select="$bwStr-AEEF-DownloadRegistrations"/></button>-->
                  </p>
                </xsl:if>
              </div>
            </td>
          </tr>
        </xsl:if>

        <!-- Topical area  --><!-- By selecting one or more of these, appropriate categories will be set on the event -->
        <xsl:variable name="taCount" select="count(form/subscriptions/calsuite/calendars/calendar/calendar[isTopicalArea])"/>
        <tr id="bwTopicalAreas">
          <td class="fieldName">
            <xsl:copy-of select="$bwStr-AEEF-TopicalArea"/>
          </td>
          <td>
            <ul class="bwColumn aliasTree">
              <xsl:apply-templates select="form/subscriptions/calsuite/calendars/calendar/calendar[isTopicalArea = 'true' and (position() &lt; ceiling($taCount div 2))]" mode="showEventFormAliases">
                <xsl:with-param name="root">false</xsl:with-param>
              </xsl:apply-templates>
            </ul>
            <ul class="bwColumn aliasTree">
              <xsl:apply-templates select="form/subscriptions/calsuite/calendars/calendar/calendar[isTopicalArea = 'true' and (position() &gt;= ceiling($taCount div 2))]" mode="showEventFormAliases">
                <xsl:with-param name="root">false</xsl:with-param>
              </xsl:apply-templates>
            </ul>
          </td>
        </tr>

        <!-- Suggestions  -->
        <xsl:if test="/bedework/suggestionEnabled = 'true' and
                      $modEventSuggestionQueue = 'false' and
                      /bedework/userInfo/approverUser = 'true' and
                      $canEdit = 'true' and
                      recurrenceId = ''">
          <xsl:variable name="calsuiteHref"><xsl:value-of select="/bedework/currentCalSuite/groupHref"/></xsl:variable>
          <tr class="optional">
            <td class="fieldName">
              <xsl:value-of select="$bwStr-AEEF-SuggestTo"/>
            </td>
            <td>
              <div id="bwSuggestions">
                <xsl:if test="form/suggestTo/preferred/group">
                  <div class="bwPrefAllControls">
                    <input type="radio" name="suggestTo" id="bwSuggestToPreferredButton" value="preferred" checked="checked" onclick="changeClass('preferredsuggestTo','shown');changeClass('allsuggestTo','invisible');"/>
                    <label for="bwSuggestToPreferredButton">preferred</label>
                    <input type="radio" name="suggestTo" id="bwSuggestToAllButton" value="all" onclick="changeClass('preferredsuggestTo','invisible');changeClass('allsuggestTo','shown')"/>
                    <label for="bwSuggestToAllButton">all</label>
                  </div>
                  <xsl:variable name="prefGroupCount" select="count(form/suggestTo/preferred/group)"/>
                  <div id="preferredsuggestTo">
                    <xsl:choose>
                      <xsl:when test="$prefGroupCount = 1">
                        <ul class="aliasTree">
                          <xsl:apply-templates mode="suggestions" select="form/suggestTo/preferred/group[not(href = $calsuiteHref)]">
                            <xsl:sort select="value" order="ascending"/>
                            <xsl:with-param name="type">Pref</xsl:with-param>
                          </xsl:apply-templates>
                        </ul>
                      </xsl:when>
                      <xsl:otherwise>
                        <ul class="bwColumn aliasTree">
                          <xsl:apply-templates mode="suggestions" select="form/suggestTo/preferred/group[(position() &lt;= ceiling($prefGroupCount div 2)) and not(href = $calsuiteHref)]">
                            <xsl:sort select="value" order="ascending"/>
                            <xsl:with-param name="type">Pref</xsl:with-param>
                          </xsl:apply-templates>
                        </ul>
                        <ul class="bwColumn aliasTree">
                          <xsl:apply-templates mode="suggestions" select="form/suggestTo/preferred/group[(position() &gt; ceiling($prefGroupCount div 2)) and not(href = $calsuiteHref)]">
                            <xsl:sort select="value" order="ascending"/>
                            <xsl:with-param name="type">Pref</xsl:with-param>
                          </xsl:apply-templates>
                        </ul>
                      </xsl:otherwise>
                    </xsl:choose>
                  </div>
                </xsl:if>
                <div id="allsuggestTo">
                  <xsl:if test="form/suggestTo/preferred/group">
                    <xsl:attribute name="class">invisible</xsl:attribute>
                  </xsl:if>
                  <xsl:variable name="groupCount" select="count(form/suggestTo/all/group)-1"/><!-- subtract one: we always hide the current calsuite -->
                  <xsl:choose>
                    <xsl:when test="$groupCount = 0">No groups</xsl:when>
                    <xsl:when test="$groupCount = 1">
                      <ul class="aliasTree">
                        <xsl:apply-templates mode="suggestions" select="form/suggestTo/all/group[not(href = $calsuiteHref)]"/>
                      </ul>
                    </xsl:when>
                    <xsl:otherwise>
                      <ul class="bwColumn aliasTree">
                        <xsl:apply-templates mode="suggestions" select="form/suggestTo/all/group[(position() &lt;= ceiling($groupCount div 2)) and not(href = $calsuiteHref)]"/>
                      </ul>
                      <ul class="bwColumn aliasTree">
                        <xsl:apply-templates mode="suggestions" select="form/suggestTo/all/group[(position() &gt; ceiling($groupCount div 2)) and not(href = $calsuiteHref)]"/>
                      </ul>
                    </xsl:otherwise>
                  </xsl:choose>
                </div>
              </div>
            </td>
          </tr>
        </xsl:if>
        <!-- note --><!-- let's shut this off for now - needs rewriting if we keep it at all
        <tr>
          <td colspan="2" style="padding-top: 1em;">
            <span class="fieldInfo">
              <strong>If "preferred values" are enabled</strong>
              by your administrator, the calendar, category, location, and contact lists will
              contain only those value you've used previously.  If you don't find the value
              you need in one of these lists, use the "all" list adjacent to each
              of these fields.  The event you select from the "all" list will be added
              to your preferred list from that point on.  <strong>Note: if you don't
              find a location or contact at all, you can add a new one from the
              <a href="{$setup}">main menu</a>.</strong>
              Only administrators can create calendars, however.
              To make sure you've used the
              correct calendar, please see the
              <a href="" target="_blank">Calendar Definitions</a>
            </span>
          </td>
        </tr> -->

        <xsl:if test="form/contact/name and $canEdit = 'true'">
          <tr>
            <td class="fieldName" colspan="2">
              <span class="std-text">
                <span class="bold">or</span> add</span>
            </td>
          </tr>
          <tr>
            <td class="fieldName">
              <xsl:copy-of select="$bwStr-AEEF-ContactName"/>
            </td>
            <td>
              <xsl:copy-of select="form/contact/name/*"/>
            </td>
          </tr>
          <tr class="optional">
            <td class="fieldName">
              <xsl:copy-of select="$bwStr-AEEF-ContactPhone"/>
            </td>
            <td>
              <xsl:copy-of select="form/contact/phone/*"/>
              <xsl:text> </xsl:text>
              <span class="fieldInfo"><xsl:copy-of select="$bwStr-AEEF-Optional"/></span>
            </td>
          </tr>
          <tr class="optional">
            <td class="fieldName">
              <xsl:copy-of select="$bwStr-AEEF-ContactURL"/>
            </td>
            <td>
              <xsl:copy-of select="form/contact/link/*"/>
              <xsl:text> </xsl:text>
              <span class="fieldInfo"><xsl:copy-of select="$bwStr-AEEF-Optional"/></span>
            </td>
          </tr>
          <tr class="optional">
            <td class="fieldName">
              <xsl:copy-of select="$bwStr-AEEF-ContactEmail"/>
            </td>
            <td>
              <xsl:copy-of select="form/contact/email/*"/>
              <xsl:text> </xsl:text>
              <span class="fieldInfo"><xsl:copy-of select="$bwStr-AEEF-Optional"/></span> test
              <div id="contactEmailAlert">&#160;</div>
              <!-- space for email warning -->
            </td>
          </tr>
        </xsl:if>
      </table>
      <!-- Show bottom submit buttons if not a pending event or if no submissions calendar exists. -->
      <xsl:if test="not(starts-with(form/calendar/event/path,$submissionsRootUnencoded)) or $submissionsRootUnencoded = ''">
        <!-- don't create two instances of the submit buttons on pending events;
             the publishing buttons require numerous unique ids -->
        <xsl:call-template name="submitEventButtons">
          <xsl:with-param name="eventTitle" select="$eventTitle"/>
          <xsl:with-param name="eventUrlPrefix" select="$eventUrlPrefix"/>
          <xsl:with-param name="canEdit" select="$canEdit"/>
          <xsl:with-param name="modEventApprovalQueue" select="$modEventApprovalQueue"/>
          <xsl:with-param name="modEventSuggestionQueue" select="$modEventSuggestionQueue"/>
          <xsl:with-param name="actionPrefix"><xsl:value-of select="$suggest-setStatusForUpdate"/>&amp;calPath=<xsl:value-of select="$calPath"/>&amp;guid=<xsl:value-of select="$guid"/>&amp;recurrenceId=<xsl:value-of select="$recurrenceId"/></xsl:with-param>
          <xsl:with-param name="calPath" select="form/calendar/event/path"/>
          <xsl:with-param name="guid" select="guid"/>
          <xsl:with-param name="recurrenceId" select="recurrenceId"/>
        </xsl:call-template>
      </xsl:if>
    </form>


    <!-- Add room to existing location -->
    <div id="bwAddRoomContainer" class="popup invisible">
        <h2><xsl:copy-of select="$bwStr-AEEF-AddRoom"/></h2>
        <!-- the address (display) and the uid are inserted with JavaScript -->
        <div class="container">
          <xsl:copy-of select="$bwStr-AEEF-To"/><xsl:text> </xsl:text>
          <span id="bwAddRoomAddress"><xsl:text> </xsl:text></span>
          <input type="hidden" id="bwAddRoomUid" name="uid" value=""/>
        </div>
        <div id="bwAddRoomFields" class="container">
          <!-- "sub" is the room/suite/area to add -->
          <xsl:copy-of select="$bwStr-AEEF-AddC"/><xsl:text> </xsl:text>
          <input type="text" name="sub" id="bwAddRoomName" value="" size="40">
            <xsl:attribute name="placeholder"><xsl:copy-of select="$bwStr-AEEF-RoomSuiteArea"/></xsl:attribute>
          </input>
          <button type="button" onclick="bwAddRoom();"><xsl:copy-of select="$bwStr-AEEF-Add"/></button>
        </div>
    </div>

  </xsl:template>

  <xsl:template match="calendar" mode="showEventFormAliases">
    <xsl:param name="root">false</xsl:param>
    <xsl:variable name="virtualPath">/user<xsl:for-each select="ancestor-or-self::calendar/name">/<xsl:value-of select="."/></xsl:for-each></xsl:variable>
    <xsl:variable name="checkedStatus">
      <xsl:choose>
        <!-- test to see if this has been checked by this calendar suite (or matches a submitted event) -->
        <xsl:when test="$virtualPath = /bedework/formElements/form/xproperties//X-BEDEWORK-ALIAS/values/text or
                                path = /bedework/formElements/form/xproperties//X-BEDEWORK-SUBMIT-ALIAS/values/text or
                               /bedework/formElements/form/xproperties//X-BEDEWORK-SUBMIT-ALIAS/values/text = substring-after(aliasUri,'bwcal://')">isChecked</xsl:when>
        <!-- if not, test to see if the underlying alias has been checked by a different calendar suite - if there is a match,
             use styling to let the user know, but don't actually check the checkbox -->
        <xsl:when test="path = /bedework/formElements/form/xproperties//X-BEDEWORK-PARAM-PATH or
                                  path = /bedework/formElements/form/xproperties//X-BEDEWORK-PARAM-ALIASPATH">isCheckedByOtherGroup</xsl:when>
        <xsl:otherwise>isNotChecked</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <li>
      <xsl:if test="$checkedStatus = 'isCheckedByOtherGroup'">
        <xsl:attribute name="class">checkedByOtherGroup</xsl:attribute>
      </xsl:if>
      <xsl:if test="$root != 'true'">
        <!-- hide the root calendar. -->
        <xsl:choose>
          <xsl:when test="calType = '7' or calType = '8'">
            <!-- we've hit an unresolvable alias; stop descending -->
            <input type="checkbox" id="{generate-id(path)}" name="forDiplayOnly" disabled="disabled"/>
            <label for="{generate-id(path)}"><em><xsl:value-of select="summary"/>?</em></label>
          </xsl:when>
          <xsl:when test="calType = '0'">
            <!-- no direct selecting of folders or folder aliases: we only want users to select the
                 underlying calendar aliases -->
            <img src="{$resourcesRoot}/images/catIcon.gif" width="13" height="13" alt="folder" class="folderForAliasTree"/>
            <xsl:value-of select="summary"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:variable name="path" select="path"/>
            <xsl:variable name="displayName" select="summary"/>
            <xsl:variable name="isSubmitted">
              <xsl:choose>
                <xsl:when test="/bedework/formElements/form/xproperties/X-BEDEWORK-SUBMIT-ALIAS">true</xsl:when>
                <xsl:otherwise>false</xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <input type="checkbox" name="alias" id="{generate-id(path)}" onclick="toggleBedeworkTopicalArea('{$displayName}','{$virtualPath}',this.checked,{$isSubmitted},'{$path}','{substring-after(aliasUri,'bwcal://')}')">
              <xsl:attribute name="value"><xsl:value-of select="$virtualPath"/></xsl:attribute>
              <xsl:if test="$checkedStatus = 'isChecked'">
                <xsl:attribute name="checked">checked</xsl:attribute>
              </xsl:if>
            </input>
            <label for="{generate-id(path)}">
              <xsl:choose>
                <xsl:when test="$virtualPath = /bedework/formElements/form/xproperties//X-BEDEWORK-ALIAS/values/text">
                  <strong><xsl:value-of select="summary"/></strong>
                </xsl:when>
                <xsl:when test="path = /bedework/formElements/form/xproperties//X-BEDEWORK-SUBMIT-ALIAS/values/text">
                  <strong><xsl:value-of select="summary"/></strong>
                </xsl:when>
                <xsl:when test="/bedework/formElements/form/xproperties//X-BEDEWORK-SUBMIT-ALIAS/values/text = substring-after(aliasUri,'bwcal://')">
                  <strong><xsl:value-of select="summary"/></strong>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="summary"/>
                </xsl:otherwise>
              </xsl:choose>
            </label>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>

      <!-- Return topical areas and all underlying calendars.
           Check for topical areas only if the subscription is owned by the calendar suite:
           If the subscription points out to a calendar or folder in another tree,
           return the branch regardless of the topical area setting.  -->
      <xsl:if test="calendar[(isSubscription = 'true' or calType = '0') and ((isTopicalArea = 'true' and  starts-with(path,/bedework/currentCalSuite/resourcesHome)) or not(starts-with(path,/bedework/currentCalSuite/resourcesHome)))]">
        <ul>
          <xsl:apply-templates select="calendar[(isSubscription = 'true' or calType = '0') and ((isTopicalArea = 'true' and  starts-with(path,/bedework/currentCalSuite/resourcesHome)) or not(starts-with(path,/bedework/currentCalSuite/resourcesHome)))]" mode="showEventFormAliases"/>
        </ul>
      </xsl:if>
    </li>
  </xsl:template>

  <xsl:template name="submitEventButtons">
    <xsl:param name="eventTitle"/>
    <xsl:param name="eventUrlPrefix"/>
    <xsl:param name="canEdit"/>
    <xsl:param name="modEventApprovalQueue"/>
    <xsl:param name="modEventSuggestionQueue"/>
    <xsl:param name="actionPrefix"/>
    <xsl:param name="calPath" select="form/calendar/event/path"/>
    <xsl:param name="guid" select="guid"/>
    <xsl:param name="recurrenceId" select="recurrenceId"/>

    <xsl:variable name="escapedTitle"><xsl:call-template name="escapeJson"><xsl:with-param name="string" select="$eventTitle"/></xsl:call-template></xsl:variable>
    <div class="submitBox">
      <xsl:choose>
        <!-- xsl:when test="starts-with(form/calendar/event/path,$submissionsRootUnencoded)"-->
        <xsl:when test="/bedework/page = 'modEventPending'">
          <div class="right">
            <input type="submit" name="delete" value="{$bwStr-SEBu-DeleteEvent}" class="noFocus"/>
          </div>
          <!-- no need for a publish box in the single calendar model unless we have more than one calendar; -->
          <xsl:choose>
            <xsl:when test="count(form/calendar/all/select/option) &gt; 1"><!-- test for the presence of more than one publishing calendar -->
              <div id="publishBox" class="invisible">
                <div id="publishBoxCloseButton">
                  <a href="javascript:resetPublishBox('calendarId')">
                    <img src="{$resourcesRoot}/images/closeIcon.gif" width="20" height="20" alt="close"/>
                  </a>
                </div>
                <strong><xsl:copy-of select="$bwStr-SEBu-SelectPublishCalendar"/></strong><br/>
                <select name="calendarId" id="calendarId" onchange="this.form.newCalPath.value = this.value;">
                  <option>
                    <xsl:attribute name="value"><xsl:value-of select="form/calendar/path"/></xsl:attribute>
                    <xsl:copy-of select="$bwStr-SEBu-Select"/>
                  </option>
                  <xsl:for-each select="form/calendar/all/select/option">
                    <xsl:sort select="." order="ascending"/>
                    <option>
                      <xsl:attribute name="value"><xsl:value-of select="@value"/></xsl:attribute>
                      <xsl:if test="@selected"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
                      <xsl:choose>
                        <xsl:when test="starts-with(node(),/bedework/submissionsRoot/unencoded)">
                          <xsl:copy-of select="$bwStr-SEBu-SubmittedEvents"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="substring-after(node(),'/public/')"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </option>
                  </xsl:for-each>
                </select>
                <input type="submit" name="publishEvent" value="{$bwStr-SEBu-PublishEvent}" class="noFocus">
                  <xsl:attribute name="onclick">doPublishEvent(this.form.newCalPath.value,"<xsl:value-of select="$escapedTitle"/>","<xsl:value-of select="$eventUrlPrefix"/>",this.form);changeClass('publishBox','invisible');</xsl:attribute>
                </input>
                <xsl:if test="$portalFriendly = 'false'">
                  <br/>
                  <span id="calDescriptionsLink">
                    <a href="javascript:launchSimpleWindow('{$calendar-fetchDescriptions}')"><xsl:copy-of select="$bwStr-SEBu-CalendarDescriptions"/></a>
                  </span>
                </xsl:if>
              </div>
              <input type="submit" name="updateSubmitEvent" value="{$bwStr-SEBu-UpdateEvent}" class="noFocus"/>
              <input type="button" name="publishEvent" value="{$bwStr-SEBu-PublishEvent}" onclick="changeClass('publishBox','visible')" class="noFocus"/>
              <input type="button" name="cancelled" onclick="location.href='{$setup}'" value="{$bwStr-SEBu-Cancel}" class="noFocus"/>
            </xsl:when>
            <xsl:otherwise>
              <!-- we are using the single calendar model for public events -->
              <input type="submit" name="updateSubmitEvent" value="{$bwStr-SEBu-UpdateEvent}" class="noFocus"/>
              <input type="submit" name="publishEvent" value="{$bwStr-SEBu-PublishEvent}" class="noFocus">
                <xsl:attribute name="onclick">doPublishEvent("<xsl:value-of select="form/calendar/all/select/option/@value"/>","<xsl:value-of select="$escapedTitle"/>","<xsl:value-of select="$eventUrlPrefix"/>",this.form);</xsl:attribute>
              </input>
              <input type="button" name="cancelled" onclick="location.href='{$setup}'" value="{$bwStr-SEBu-Cancel}" class="noFocus"/>
            </xsl:otherwise>
          </xsl:choose>
          <span class="claimButtons">
            <xsl:choose>
              <xsl:when test="form/xproperties/X-BEDEWORK-SUBMISSION-CLAIMANT/values/text = /bedework/userInfo/group">
                <input type="submit" name="updateSubmitEvent" value="{$bwStr-SEBu-ReleaseEvent}" onclick="releasePendingEvent();" class="noFocus"/>
              </xsl:when>
              <xsl:otherwise>
                <input type="submit" name="updateSubmitEvent" value="{$bwStr-SEBu-ClaimEvent}" class="noFocus">
                  <xsl:attribute name="onclick">claimPendingEvent('<xsl:value-of select="/bedework/userInfo/group"/>','<xsl:value-of select="/bedework/userInfo/currentUser"/>');</xsl:attribute>
                </input>
              </xsl:otherwise>
            </xsl:choose>
          </span>
        </xsl:when>
        <xsl:when test="$modEventSuggestionQueue = 'true'">
          <xsl:variable name="suggestedListType">
            <xsl:choose>
              <xsl:when test="/bedework/appvar[key='suggestType']/value = 'A'">A</xsl:when>
              <xsl:when test="/bedework/appvar[key='suggestType']/value = 'R'">R</xsl:when>
              <xsl:otherwise>P</xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:variable name="backToListLink"><xsl:value-of select="$initSuggestionQueueTab"/>&amp;listMode=true&amp;sg=true&amp;start=<xsl:value-of select="$curListDate"/>&amp;fexpr=(colPath="/public/cals/MainCal" and (entity_type="event"|entity_type="todo") and suggested-to="<xsl:value-of select="$suggestedListType"/>:<xsl:value-of select="/bedework/currentCalSuite/groupHref"/>")&amp;sort=dtstart.utc:asc&amp;master=true&amp;setappvar=suggestType(<xsl:value-of select="$suggestedListType"/>)</xsl:variable>
          <xsl:variable name="reloadEventLink"><xsl:value-of select="$event-fetchForUpdateSuggestionQueue"/>&amp;calPath=<xsl:value-of select="$calPath"/>&amp;guid=<xsl:value-of select="$guid"/>&amp;recurrenceId=<xsl:value-of select="$recurrenceId"/></xsl:variable>
          <input type="button" name="updateEvent" value="{$bwStr-SEBu-AcceptEvent}" class="noFocus" onclick="setSuggestionStatus('accept','{$actionPrefix}','')"/><!-- accept and update -->
          <input type="button" name="rejectEvent" value="{$bwStr-SEBu-RejectEvent}" class="noFocus" onclick="setSuggestionStatus('reject','{$actionPrefix}','{$backToListLink}')"/>
          <input type="button" name="returnToList" value="{$bwStr-SEBu-ReturnToList}" onclick="location.href='{$backToListLink}'" class="noFocus"/>
        </xsl:when>
        <xsl:when test="($modEventApprovalQueue = 'true') and (($superUser = 'true') or ($approverUser = 'true'))">
          <div class="right">
            <input type="submit" name="delete" value="{$bwStr-SEBu-DeleteEvent}" class="noFocus"/>
          </div>
          <!-- no need for a publish box in the single calendar model unless we have more than one calendar; -->
          <xsl:choose>
            <xsl:when test="count(form/calendar/all/select/option) &gt; 1"><!-- test for the presence of more than one publishing calendar -->
              <div id="publishBox" class="invisible">
                <div id="publishBoxCloseButton">
                  <a href="javascript:resetPublishBox('calendarId')">
                    <img src="{$resourcesRoot}/images/closeIcon.gif" width="20" height="20" alt="close"/>
                  </a>
                </div>
                <strong><xsl:copy-of select="$bwStr-SEBu-SelectPublishCalendar"/></strong><br/>
                <select name="calendarId" id="calendarId" onchange="this.form.newCalPath.value = this.value;">
                  <option>
                    <xsl:attribute name="value"><xsl:value-of select="form/calendar/path"/></xsl:attribute>
                    <xsl:copy-of select="$bwStr-SEBu-Select"/>
                  </option>
                  <xsl:for-each select="form/calendar/all/select/option">
                    <xsl:sort select="." order="ascending"/>
                    <option>
                      <xsl:attribute name="value"><xsl:value-of select="@value"/></xsl:attribute>
                      <xsl:if test="@selected"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
                      <xsl:choose>
                        <xsl:when test="starts-with(node(),/bedework/submissionsRoot/unencoded)">
                          <xsl:copy-of select="$bwStr-SEBu-SubmittedEvents"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="substring-after(node(),'/public/')"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </option>
                  </xsl:for-each>
                </select>
                <input type="submit" name="approveEvent" value="{$bwStr-SEBu-ApproveEvent}" class="noFocus">
                  <xsl:attribute name="onclick">doApproveEvent(this.form.newCalPath.value,"<xsl:value-of select="$escapedTitle"/>","<xsl:value-of select="$eventUrlPrefix"/>",this.form);changeClass('publishBox','invisible');</xsl:attribute>
                </input>
                <xsl:if test="$portalFriendly = 'false'">
                  <br/>
                  <span id="calDescriptionsLink">
                    <a href="javascript:launchSimpleWindow('{$calendar-fetchDescriptions}')"><xsl:copy-of select="$bwStr-SEBu-CalendarDescriptions"/></a>
                  </span>
                </xsl:if>
              </div>
              <input type="submit" name="updateApproveEvent" value="{$bwStr-SEBu-UpdateEvent}" class="noFocus"/>
              <input type="button" name="approveEvent" value="{$bwStr-SEBu-ApproveEvent}" onclick="changeClass('publishBox','visible')" class="noFocus"/>
              <input type="button" name="cancelled" onclick="location.href='{$setup}'" value="{$bwStr-SEBu-Cancel}" class="noFocus"/>
            </xsl:when>
            <xsl:otherwise>
              <!-- we are using the single calendar model for public events -->
              <input type="submit" name="updateApproveEvent" value="{$bwStr-SEBu-UpdateEvent}" class="noFocus"/>
              <input type="submit" name="approveEvent" value="{$bwStr-SEBu-ApproveEvent}" class="noFocus">
                <xsl:attribute name="onclick">doApproveEvent("<xsl:value-of select="form/calendar/all/select/option/@value"/>","<xsl:value-of select="$escapedTitle"/>","<xsl:value-of select="$eventUrlPrefix"/>",this.form);</xsl:attribute>
              </input>
              <input type="button" name="cancelled" onclick="location.href='{$setup}'" value="{$bwStr-SEBu-Cancel}" class="noFocus"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="/bedework/creating='true'">
              <input type="submit" name="addEvent" value="{$bwStr-SEBu-AddEvent}" class="noFocus"/>
              <input type="button" name="cancelled" onclick="location.href='{$setup}'" value="{$bwStr-SEBu-Cancel}" class="noFocus"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:if test="$canEdit = 'true'">
                <xsl:choose>
                  <xsl:when test="(/bedework/eventInfo.currentAccess/current-user-privilege-set/privilege/unbind) or ($superUser = 'true')">
                    <div class="right">
                      <input type="submit" name="delete" value="{$bwStr-SEBu-DeleteEvent}" class="noFocus"/>
                    </div>
                  </xsl:when>
                </xsl:choose>
                <div class="right">
                  <input type="submit" name="markDeleted" value="{$bwStr-SEBu-MarkEventDeleted}" class="noFocus"/>
                </div>
              </xsl:if>
              <input type="submit" name="updateEvent" value="{$bwStr-SEBu-UpdateEvent}" class="noFocus">
                <!--xsl:if test="$modEventSuggestionQueue = 'true'">
                  <xsl:attribute name="value"><xsl:value-of select="$bwStr-SEBu-AcceptEvent"/></xsl:attribute>
                </xsl:if-->
              </input>
              <xsl:if test="recurrenceId = '' and $canEdit = 'true'">
                <!-- Cannot duplicate recurring instances. -->
                <input type="button" name="copy" value="{$bwStr-SEBu-CopyEvent}" class="noFocus">
                  <xsl:attribute name="onclick">location.href='<xsl:value-of select="$event-fetchForUpdate"/>&amp;calPath=<xsl:value-of select="$calPath"/>&amp;guid=<xsl:value-of select="$guid"/>&amp;copy=true'</xsl:attribute>
                </input>
              </xsl:if>
              <xsl:choose>
                <xsl:when test="$modEventApprovalQueue = 'true'">
                  <xsl:variable name="backToListLink">location.href='<xsl:value-of select="$initApprovalQueueTab"/>&amp;start=<xsl:value-of select="/bedework/currentdate/date"/>&amp;listMode=true&amp;fexpr=(colPath="<xsl:value-of select="$workflowRootEncoded"/>")&amp;sort=dtstart.utc:asc'</xsl:variable>
                  <input type="button" name="returnToList" value="{$bwStr-SEBu-ReturnToList}" onclick="{$backToListLink}" class="noFocus"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:variable name="backToListLink">location.href='<xsl:value-of select="$event-initUpdateEvent"/>&amp;start=<xsl:value-of select="/bedework/currentdate/date"/>&amp;listMode=true&amp;fexpr=(colPath="/public/cals/MainCal" and (entity_type="event"|entity_type="todo"))&amp;sort=dtstart.utc:asc'</xsl:variable>
                  <input type="button" name="returnToList" value="{$bwStr-SEBu-ReturnToList}" onclick="{$backToListLink}" class="noFocus"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </div>
  </xsl:template>

  <xsl:template match="val" mode="weekMonthYearNumbers">
    <xsl:if test="position() != 1 and position() = last()"> and </xsl:if>
    <xsl:value-of select="."/><xsl:choose>
      <xsl:when test="substring(., string-length(.)-1, 2) = '11' or
                      substring(., string-length(.)-1, 2) = '12' or
                      substring(., string-length(.)-1, 2) = '13'">th</xsl:when>
      <xsl:when test="substring(., string-length(.), 1) = '1'">st</xsl:when>
      <xsl:when test="substring(., string-length(.), 1) = '2'">nd</xsl:when>
      <xsl:when test="substring(., string-length(.), 1) = '3'">rd</xsl:when>
      <xsl:otherwise>th</xsl:otherwise>
    </xsl:choose>
    <xsl:if test="position() != last()">, </xsl:if>
  </xsl:template>

  <xsl:template name="byDayChkBoxList">
    <xsl:param name="name"/>
    <xsl:for-each select="/bedework/shortdaynames/val">
      <xsl:variable name="pos" select="position()"/>
      <input type="checkbox">
        <xsl:attribute name="value"><xsl:value-of select="/bedework/recurdayvals/val[position() = $pos]"/></xsl:attribute>
        <xsl:attribute name="name"><xsl:value-of select="$name"/></xsl:attribute>
      </input>
      <xsl:value-of select="."/>
    </xsl:for-each>
  </xsl:template>

  <!-- this template is deprecated in favor of static html -->
  <xsl:template name="buildCheckboxList">
    <xsl:param name="current"/>
    <xsl:param name="end"/>
    <xsl:param name="name"/>
    <xsl:param name="splitter">10</xsl:param>
    <span class="chkBoxListItem">
      <input type="checkbox">
        <xsl:attribute name="name"><xsl:value-of select="$name"/></xsl:attribute>
        <xsl:attribute name="value"><xsl:value-of select="$current"/></xsl:attribute>
      </input>
      <xsl:value-of select="$current"/>
    </span>
    <xsl:if test="$current mod $splitter = 0"><br/></xsl:if>
    <xsl:if test="$current = $end"><br/></xsl:if>
    <xsl:if test="$current &lt; $end">
      <xsl:call-template name="buildCheckboxList">
        <xsl:with-param name="current"><xsl:value-of select="$current + 1"/></xsl:with-param>
        <xsl:with-param name="end"><xsl:value-of select="$end"/></xsl:with-param>
        <xsl:with-param name="name"><xsl:value-of select="$name"/></xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="recurrenceDayPosOptions">
    <option value="0"><xsl:copy-of select="$bwStr-RCPO-None"/></option>
    <option value="1"><xsl:copy-of select="$bwStr-RCPO-TheFirst"/></option>
    <option value="2"><xsl:copy-of select="$bwStr-RCPO-TheSecond"/></option>
    <option value="3"><xsl:copy-of select="$bwStr-RCPO-TheThird"/></option>
    <option value="4"><xsl:copy-of select="$bwStr-RCPO-TheFourth"/></option>
    <option value="5"><xsl:copy-of select="$bwStr-RCPO-TheFifth"/></option>
    <option value="-1"><xsl:copy-of select="$bwStr-RCPO-TheLast"/></option>
    <option value=""><xsl:copy-of select="$bwStr-RCPO-Every"/></option>
  </xsl:template>

  <xsl:template name="buildRecurFields">
    <xsl:param name="current"/>
    <xsl:param name="total"/>
    <xsl:param name="name"/>
    <div class="invisible">
      <xsl:attribute name="id"><xsl:value-of select="$name"/>RecurFields<xsl:value-of select="$current"/></xsl:attribute>
      <xsl:copy-of select="$bwStr-BuRF-And"/>
      <select>
        <xsl:attribute name="name">by<xsl:value-of select="$name"/>posPos<xsl:value-of select="$current"/></xsl:attribute>
        <xsl:if test="$current != $total">
          <xsl:attribute name="onchange">changeClass('<xsl:value-of select="$name"/>RecurFields<xsl:value-of select="$current+1"/>','shown')</xsl:attribute>
        </xsl:if>
        <xsl:call-template name="recurrenceDayPosOptions"/>
      </select>
      <xsl:call-template name="byDayChkBoxList"/>
    </div>
    <xsl:if test="$current &lt; $total">
      <xsl:call-template name="buildRecurFields">
        <xsl:with-param name="current"><xsl:value-of select="$current+1"/></xsl:with-param>
        <xsl:with-param name="total"><xsl:value-of select="$total"/></xsl:with-param>
        <xsl:with-param name="name"><xsl:value-of select="$name"/></xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="buildNumberOptions">
    <xsl:param name="current"/>
    <xsl:param name="total"/>
    <option value="{$current}"><xsl:value-of select="$current"/></option>
    <xsl:if test="$current &lt; $total">
      <xsl:call-template name="buildNumberOptions">
        <xsl:with-param name="current"><xsl:value-of select="$current+1"/></xsl:with-param>
        <xsl:with-param name="total"><xsl:value-of select="$total"/></xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template match="group" mode="suggestions">
    <xsl:param name="type">All</xsl:param>
    <xsl:variable name="href" select="href"/>
    <xsl:variable name="idSuffix" select="translate(href,'/','')"/>
    <xsl:variable name="curStatus">
      <xsl:for-each select="/bedework/suggestions/suggestion[suggestedByHref = /bedework/currentCalSuite/groupHref]">
        <xsl:if test="$href = groupHref"><xsl:value-of select="status"/></xsl:if>
      </xsl:for-each>
    </xsl:variable>

    <li class="{$curStatus}">
      <input type="checkbox" name="groupHref">
        <xsl:attribute name="value"><xsl:value-of select="href"/></xsl:attribute>
        <xsl:attribute name="id">bwSuggest<xsl:value-of select="$type"/>-<xsl:value-of select="$idSuffix"/></xsl:attribute>
        <xsl:choose>
          <xsl:when test="$type = 'All'">
            <xsl:attribute name="onclick">setCollChBx('bwSuggestAll-<xsl:value-of select="$idSuffix"/>','bwSuggestPref-<xsl:value-of select="$idSuffix"/>')</xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="onclick">setCollChBx('bwSuggestPref-<xsl:value-of select="$idSuffix"/>','bwSuggestAll-<xsl:value-of select="$idSuffix"/>')</xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:for-each select="/bedework/suggestions/suggestion[suggestedByHref = /bedework/currentCalSuite/groupHref]">
          <xsl:if test="$curStatus != ''">
            <xsl:attribute name="checked">checked</xsl:attribute>
          </xsl:if>
        </xsl:for-each>
      </input>
      <label>
        <xsl:attribute name="for">bwSuggest<xsl:value-of select="$type"/>-<xsl:value-of select="$idSuffix"/></xsl:attribute>
        <xsl:choose>
          <xsl:when test="$type = 'All'">
            <xsl:value-of select="description"/>
          </xsl:when>
          <xsl:otherwise>
            <!-- this is the preferred list: lookup the desc from the all list -->
            <xsl:choose>
              <xsl:when test="/bedework/formElements/form/suggestTo/all/group[href=$href]">
                <xsl:value-of select="/bedework/formElements/form/suggestTo/all/group[href=$href]/description"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:choose>
                  <xsl:when test="substring-after(name,'bwadmin/calsuite-') = ''">
                    <xsl:value-of select="name"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="substring-after(name,'bwadmin/calsuite-')"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>

          </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
          <xsl:when test="$curStatus = 'A'">
            <span class="suggestion-accepted"><xsl:value-of select="$bwStr-TaAQ-Accepted"/></span>
          </xsl:when>
          <xsl:when test="$curStatus = 'R'">
            <span class="suggestion-rejected"><xsl:value-of select="$bwStr-TaAQ-Rejected"/></span>
          </xsl:when>
        </xsl:choose>
      </label>
    </li>
  </xsl:template>

</xsl:stylesheet>