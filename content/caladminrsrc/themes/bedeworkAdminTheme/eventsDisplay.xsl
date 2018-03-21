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

  <!--+++++++++++++ Display Single Event (e.g from a search) ++++++++++-->
  <xsl:template match="event" mode="displayEvent">
    <xsl:variable name="calPath" select="calendar/path"/>
    <xsl:variable name="guid" select="guid"/>
    <xsl:variable name="recurrenceId" select="recurrenceId"/>

    <xsl:choose>
      <xsl:when test="/bedework/page='deleteEventConfirm' or /bedework/page='deleteEventConfirmPending' or /bedework/page='deleteEventConfirmApprovalQueue'">
        <h2><xsl:copy-of select="$bwStr-DsEv-OkayToDelete"/></h2>

        <xsl:if test="/bedework/page='deleteEventConfirm'">
          <p style="width: 400px;"><xsl:copy-of select="$bwStr-DsEv-NoteDontEncourageDeletes"/></p>
        </xsl:if>
        <xsl:variable name="deleteConfirmValue">
          <xsl:choose>
            <xsl:when test="/bedework/markDeleted = 'true'"><xsl:copy-of select="$bwStr-DsEv-YesMarkDeleted"/></xsl:when>
            <xsl:otherwise><xsl:copy-of select="$bwStr-DsEv-YesDeleteEvent"/></xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <xsl:variable name="eventDatesForEmail">
          <xsl:value-of select="start/dayname"/>, <xsl:value-of select="start/longdate"/><xsl:text> </xsl:text><!--
       --><xsl:if test="start/allday = 'false'"><xsl:value-of select="start/time"/></xsl:if><!--
       --><xsl:if test="(end/longdate != start/longdate) or
                        ((end/longdate = start/longdate) and (end/time != start/time))"> - </xsl:if><!--
       --><xsl:if test="end/longdate != start/longdate"><xsl:value-of select="substring(end/dayname,1,3)"/>, <xsl:value-of select="end/longdate"/><xsl:text> </xsl:text></xsl:if><!--
       --><xsl:choose>
            <xsl:when test="start/allday = 'true'"><xsl:copy-of select="$bwStr-DsEv-AllDay"/></xsl:when>
            <xsl:when test="end/longdate != start/longdate"><xsl:value-of select="end/time"/></xsl:when>
            <xsl:when test="end/time != start/time"><xsl:value-of select="end/time"/></xsl:when>
          </xsl:choose><!--
     --></xsl:variable>

        <div id="confirmButtons">
          <form method="post">
            <xsl:choose>
              <xsl:when test="/bedework/page = 'deleteEventConfirmPending'">
                <xsl:attribute name="action"><xsl:value-of select="$event-deletePending"/></xsl:attribute>
                <xsl:attribute name="onsubmit">doRejectEvent(this,'<xsl:value-of select="summary"/>','<xsl:value-of select="$eventDatesForEmail"/>');</xsl:attribute>
                <!-- Setup email notification fields -->
                <input type="hidden" id="submitNotification" name="submitNotification" value="true"/>
                <!-- "from" should be a preference: hard code it for now -->
                <input type="hidden" id="snfrom" name="snfrom" value="bedework@yoursite.edu"/>
                <input type="hidden" id="snsubject" name="snsubject" value=""/>
                <input type="hidden" id="sntext" name="sntext" value=""/>
                <div id="bwEmailBox">
                  <p>
                    <strong><xsl:copy-of select="$bwStr-DsEv-YouDeletingPending"/></strong><br/>
                    <input type="checkbox" name="notifyFlag" checked="checked" onclick="toggleVisibility('bwRejectEventReasonBox','visible');"/>
                    <xsl:copy-of select="$bwStr-DsEv-SendNotification"/>
                  </p>
                  <div id="bwRejectEventReasonBox">
                    <p><xsl:copy-of select="$bwStr-DsEv-Reason"/><br/>
                      <textarea name="reason" rows="4" cols="60">
                        <xsl:text> </xsl:text>
                      </textarea>
                    </p>
                  </div>
                </div>
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="action"><xsl:value-of select="$event-delete"/></xsl:attribute>
              </xsl:otherwise>
            </xsl:choose>
            <input type="submit" name="delete" value="{$deleteConfirmValue}"/>
            <input type="submit" name="cancelled" value="{$bwStr-DsEv-Cancel}"/>
            <input type="hidden" name="calPath" value="{$calPath}"/>
            <input type="hidden" name="guid" value="{$guid}"/>
            <input type="hidden" name="recurrenceId" value="{$recurrenceId}"/>
          </form>
        </div>
      </xsl:when>
      <xsl:otherwise>
        <h2><xsl:copy-of select="$bwStr-DsEv-EventInfo"/></h2>
      </xsl:otherwise>
    </xsl:choose>

    <table class="eventFormTable">
      <tr>
        <th>
          <xsl:copy-of select="$bwStr-DsEv-Title"/>
        </th>
        <td>
          <strong><xsl:value-of select="summary"/></strong>
        </td>
      </tr>

      <tr>
        <th>
          <xsl:copy-of select="$bwStr-DsEv-When"/>
        </th>
        <td>
          <xsl:value-of select="start/dayname"/>, <xsl:value-of select="start/longdate"/><xsl:text> </xsl:text>
          <xsl:if test="start/allday = 'false'">
            <span class="time"><xsl:value-of select="start/time"/></span>
          </xsl:if>
          <xsl:if test="(end/longdate != start/longdate) or
                        ((end/longdate = start/longdate) and (end/time != start/time))"> - </xsl:if>
          <xsl:if test="end/longdate != start/longdate">
            <xsl:value-of select="substring(end/dayname,1,3)"/>, <xsl:value-of select="end/longdate"/><xsl:text> </xsl:text>
          </xsl:if>
          <xsl:choose>
            <xsl:when test="start/allday = 'true'">
              <span class="time"><em><xsl:copy-of select="$bwStr-DsEv-AllDay"/></em></span>
            </xsl:when>
            <xsl:when test="end/longdate != start/longdate">
              <span class="time"><xsl:value-of select="end/time"/></span>
            </xsl:when>
            <xsl:when test="end/time != start/time">
              <span class="time"><xsl:value-of select="end/time"/></span>
            </xsl:when>
          </xsl:choose>
        </td>
      </tr>

      <!--  Description  -->
      <tr>
        <th>
          <xsl:copy-of select="$bwStr-DsEv-Description"/>
        </th>
        <td>
          <xsl:value-of select="description"/>
        </td>
      </tr>

      <!-- Cost -->
      <xsl:if test="cost and cost != ''">
        <tr class="optional">
          <th>
            <xsl:copy-of select="$bwStr-DsEv-Price"/>
          </th>
          <td>
            <xsl:value-of select="cost"/>
          </td>
        </tr>
      </xsl:if>

      <!-- Url -->
      <xsl:if test="link and link != ''">
        <tr class="optional">
          <th>
            <xsl:copy-of select="$bwStr-DsEv-URL"/>
          </th>
          <td>
            <xsl:variable name="eventLink" select="link"/>
            <a href="{$eventLink}">
              <xsl:value-of select="link"/>
            </a>
          </td>
        </tr>
      </xsl:if>

      <!-- Location -->
      <tr>
        <th>
          <xsl:copy-of select="$bwStr-DsEv-Location"/>
        </th>
        <td>
          <xsl:value-of select="location/address"/><br/>
          <xsl:value-of select="location/subaddress"/>
        </td>
      </tr>

      <!-- Contact -->
      <tr>
        <th>
          <xsl:copy-of select="$bwStr-DsEv-Contact"/>
        </th>
        <td>
          <xsl:value-of select="contact/name"/><br/>
          <xsl:value-of select="contact/phone"/><br/>
          <xsl:variable name="mailto" select="email"/>
          <a href="mailto:{$mailto}"><xsl:value-of select="email"/></a>
          <xsl:variable name="contactLink" select="link"/>
          <a href="mailto:{$contactLink}"><xsl:value-of select="contact/link"/></a>
        </td>
      </tr>

      <!-- Owner -->
      <tr>
        <th>
          <xsl:copy-of select="$bwStr-DsEv-Owner"/>
        </th>
        <td>
          <strong><xsl:value-of select="creator"/></strong>
        </td>
      </tr>

      <!-- Submitter -->
      <xsl:if test="xproperties/X-BEDEWORK-SUBMITTEDBY">
        <tr>
          <th>
            <xsl:copy-of select="$bwStr-DsEv-Submitter"/>
          </th>
          <td>
            <strong><xsl:value-of select="xproperties/X-BEDEWORK-SUBMITTEDBY/values/text"/></strong>
          </td>
        </tr>
      </xsl:if>

      <tr>
        <th>
          <xsl:copy-of select="$bwStr-DsEv-Calendar"/>
        </th>
        <td>
          <xsl:value-of select="calendar/path"/>
        </td>
      </tr>

      <tr>
        <th>
          <xsl:copy-of select="$bwStr-DsEv-TopicalAreas"/>
        </th>
        <td>
           <xsl:for-each select="xproperties/X-BEDEWORK-ALIAS">
             <xsl:sort order="ascending" select="parameters/X-BEDEWORK-PARAM-DISPLAYNAME"/>
             <xsl:value-of select="parameters/X-BEDEWORK-PARAM-DISPLAYNAME"/><br/>
           </xsl:for-each>
        </td>
      </tr>

      <!--  Categories  -->
      <tr>
        <th>
          <xsl:copy-of select="$bwStr-DsEv-Categories"/>
        </th>
        <td>
          <xsl:for-each select="categories/category">
            <xsl:sort order="ascending" select="value"/>
            <xsl:value-of select="value"/><br/>
          </xsl:for-each>
        </td>
      </tr>

    </table>

    <xsl:if test="/bedework/page != 'deleteEventConfirmPending'">
      <p>
        <xsl:variable name="userPath"><xsl:value-of select="/bedework/syspars/userPrincipalRoot"/>/<xsl:value-of select="/bedework/userInfo/user"/></xsl:variable>
        <input type="button" name="return" onclick="javascript:location.replace('{$event-fetchForUpdate}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}')">
          <xsl:choose>
            <xsl:when test="$userPath = creator or /bedework/userInfo/superUser = 'true'">
              <xsl:attribute name="value">Edit event</xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="value"><xsl:copy-of select="$bwStr-DsEv-TagEvent"/></xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
        </input>
        <input type="button" name="return" value="Back" onclick="javascript:history.back()"/>
     </p>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>