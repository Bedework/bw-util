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

  <!--++++++++++++++++++ Events List Common ++++++++++++++++++++-->
  <!--            included in most event listings               -->

  <xsl:template name="eventListCommon">
    <xsl:param name="pending">false</xsl:param>
    <xsl:param name="approvalQueue">false</xsl:param>
    <xsl:param name="suggestionQueue">false</xsl:param>
    <table id="commonListTable" title="event listing">
      <thead>
        <tr>
          <th><xsl:copy-of select="$bwStr-EvLC-Title"/></th>
          <xsl:if test="$pending = 'true'">
            <th><xsl:copy-of select="$bwStr-EvLC-CalSuite"/></th>
            <th><xsl:copy-of select="$bwStr-EvLC-ClaimedBy"/></th>
          </xsl:if>
          <th><xsl:copy-of select="$bwStr-EvLC-Start"/></th>
          <th><xsl:copy-of select="$bwStr-EvLC-End"/></th>
          <xsl:if test="$suggestionQueue = 'false'">
            <th class="calcat">
              <xsl:if test="$pending = 'true'"><xsl:copy-of select="$bwStr-EvLC-Suggested"/><xsl:text> </xsl:text></xsl:if>
              <xsl:copy-of select="$bwStr-EvLC-TopicalAreas"/>
            </th>
          </xsl:if>
          <xsl:if test="$pending = 'false'">
            <th class="calcat"><xsl:copy-of select="$bwStr-EvLC-Categories"/></th>
          </xsl:if>
          <th><xsl:copy-of select="$bwStr-EvLC-Author"/></th>
          <th><xsl:copy-of select="$bwStr-EvLC-Description"/></th>
          <xsl:if test="$suggestionQueue = 'true'">
            <th>Accept?</th>
          </xsl:if>
        </tr>
      </thead>
      <tbody>

        <xsl:apply-templates select="/bedework/events/event" mode="eventListCommon">
          <xsl:with-param name="pending"><xsl:value-of select="$pending"/></xsl:with-param>
          <xsl:with-param name="approvalQueue"><xsl:value-of select="$approvalQueue"/></xsl:with-param>
          <xsl:with-param name="suggestionQueue"><xsl:value-of select="$suggestionQueue"/></xsl:with-param>
        </xsl:apply-templates>

        <xsl:if test="not(/bedework/events/event)">
          <tr>
            <td colspan="7">
              <!--xsl:if test="$pending = 'true' or $approvalQueue = 'true' or $suggestionQueue = 'true'">
                <xsl:attribute name="colspan">7</xsl:attribute>
              </xsl:if-->
              <xsl:copy-of select="$bwStr-EvLC-NoEvents"/>
              (<xsl:value-of select="/bedework/maxdays"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="$bwStr-EvLC-DayWindow"/>)
            </td>
          </tr>
        </xsl:if>

      </tbody>
    </table>

    <xsl:if test="/bedework/events/event">
      <xsl:variable name="resultSize" select="/bedework/events/resultSize"/>
      <xsl:variable name="pageSize" select="/bedework/events/pageSize"/>
      <xsl:variable name="offset">
        <xsl:choose>
          <xsl:when test="/bedework/events/curOffset = $resultSize">0</xsl:when>
          <xsl:otherwise><xsl:value-of select="/bedework/events/curOffset"/></xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="totalPages"><xsl:value-of select="ceiling($resultSize div $pageSize)"/></xsl:variable>
      <xsl:variable name="curPage"><xsl:value-of select="floor($offset div $pageSize) + 1"/></xsl:variable>
      <xsl:variable name="firstOfOffset">
        <xsl:choose>
          <xsl:when test="$resultSize = 0">0</xsl:when>
          <xsl:otherwise><xsl:value-of select="$offset + 1"/></xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="lastOfOffset">
        <xsl:choose>
          <xsl:when test="$offset + $pageSize &gt; $resultSize"><xsl:value-of select="$resultSize"/></xsl:when>
          <xsl:otherwise><xsl:value-of select="$offset + $pageSize"/></xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <div id="eventListMetaData">
        <xsl:value-of select="$bwStr-EvLC-Page"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$curPage"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$bwStr-EvLC-Of"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$totalPages"/>,
        <xsl:text> </xsl:text>
        <xsl:value-of select="$bwStr-EvLC-Viewing"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$firstOfOffset"/>-<xsl:value-of select="$lastOfOffset"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$bwStr-EvLC-Of"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="/bedework/events/resultSize"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$bwStr-EvLC-EventsInA"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="/bedework/maxdays"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$bwStr-EvLC-DayWindow"/>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template match="event" mode="eventListCommon">
    <xsl:param name="pending">false</xsl:param>
    <xsl:param name="approvalQueue">false</xsl:param>
    <xsl:param name="suggestionQueue">false</xsl:param>
    <xsl:variable name="calPath" select="calendar/encodedPath"/>
    <xsl:variable name="guid" select="guid"/>
    <xsl:variable name="calSuite" select="calSuite"/>
    <xsl:variable name="recurrenceId" select="recurrenceId"/>
    <xsl:variable name="i" select="position()"/>
    <tr>
      <xsl:attribute name="id">suggestionRow<xsl:value-of select="$i"/></xsl:attribute>
      <xsl:if test="position() mod 2 = 0"><xsl:attribute name="class">even</xsl:attribute></xsl:if>
      <xsl:if test="$pending = 'true' and not(xproperties/X-BEDEWORK-SUBMISSION-CLAIMANT)">
        <xsl:attribute name="class">highlight</xsl:attribute>
      </xsl:if>
      <xsl:if test="status = 'TENTATIVE'">
        <xsl:attribute name="class">tentative</xsl:attribute>
      </xsl:if>
      <xsl:if test="status = 'CANCELLED'">
        <xsl:attribute name="class">cancelled</xsl:attribute>
      </xsl:if>
      <td>
        <xsl:choose>
          <xsl:when test="$pending = 'true'">
            <xsl:choose>
              <xsl:when test="xproperties/X-BEDEWORK-SUBMISSION-CLAIMANT and not(xproperties/X-BEDEWORK-SUBMISSION-CLAIMANT/values/text = /bedework/userInfo/group)">
                <xsl:choose>
                  <xsl:when test="summary != ''">
                    <xsl:value-of select="summary"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <em><xsl:copy-of select="$bwStr-EvLC-NoTitle"/></em>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:otherwise>
                <a>
                  <xsl:choose>
                    <xsl:when test="recurrenceId != ''">
                      <!-- recurrence instances should be updated like normal events - only master events should be published -->
                      <xsl:attribute name="href"><xsl:value-of select="$event-fetchForUpdate"/>&amp;calPath=<xsl:value-of select="$calPath"/>&amp;guid=<xsl:value-of select="$guid"/>&amp;recurrenceId=<xsl:value-of select="$recurrenceId"/></xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="href"><xsl:value-of select="$event-fetchForUpdatePending"/>&amp;calPath=<xsl:value-of select="$calPath"/>&amp;guid=<xsl:value-of select="$guid"/>&amp;recurrenceId=<xsl:value-of select="$recurrenceId"/></xsl:attribute>
                    </xsl:otherwise>
                  </xsl:choose>
                  <xsl:choose>
                    <xsl:when test="summary != ''">
                      <xsl:value-of select="summary"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <em><xsl:copy-of select="$bwStr-EvLC-NoTitle"/></em>
                    </xsl:otherwise>
                  </xsl:choose>
                </a>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="status = 'CANCELLED'"><strong><xsl:copy-of select="$bwStr-EvLC-Cancelled"/></strong><br/></xsl:when>
              <xsl:when test="status = 'TENTATIVE'"><xsl:copy-of select="$bwStr-EvLC-Tentative"/><br/></xsl:when>
            </xsl:choose>
            <a>
              <xsl:attribute name="title"><xsl:copy-of select="$bwStr-EvLC-EditEvent"/></xsl:attribute>
              <xsl:choose>
                <xsl:when test="$approvalQueue = 'true'">
                  <xsl:choose>
                    <xsl:when test="recurrenceId != ''">
                      <!-- recurrence instances should be updated like normal events - only master events should be published -->
                      <xsl:attribute name="href"><xsl:value-of select="$event-fetchForUpdate"/>&amp;calPath=<xsl:value-of select="$calPath"/>&amp;guid=<xsl:value-of select="$guid"/>&amp;recurrenceId=<xsl:value-of select="$recurrenceId"/></xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="href"><xsl:value-of select="$event-fetchForUpdateApprovalQueue"/>&amp;calPath=<xsl:value-of select="$calPath"/>&amp;guid=<xsl:value-of select="$guid"/>&amp;recurrenceId=<xsl:value-of select="$recurrenceId"/></xsl:attribute>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
                <xsl:when test="$suggestionQueue = 'true'">
                  <!-- only link to master events - do not link to recurrence instances -->
                  <xsl:attribute name="href"><xsl:value-of select="$event-fetchForUpdateSuggestionQueue"/>&amp;calPath=<xsl:value-of select="$calPath"/>&amp;guid=<xsl:value-of select="$guid"/></xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="href"><xsl:value-of select="$event-fetchForUpdate"/>&amp;calPath=<xsl:value-of select="$calPath"/>&amp;guid=<xsl:value-of select="$guid"/>&amp;recurrenceId=<xsl:value-of select="$recurrenceId"/></xsl:attribute>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:choose>
                <xsl:when test="summary != ''">
                  <xsl:value-of select="summary"/>
                </xsl:when>
                <xsl:otherwise>
                  <em><xsl:copy-of select="$bwStr-EvLC-NoTitle"/></em>
                </xsl:otherwise>
              </xsl:choose>
            </a>
            <xsl:if test="$approvalQueue = 'false'">
              <!-- generate a public link; for now always expose in the main suite. -->
              <a class="bwPublicLink" href="#bwPublicEventLinkBox">
                <xsl:attribute name="data-public-event-path">/cal/event/eventView.do?calPath=<xsl:value-of select="$calPath"/>&amp;guid=<xsl:value-of select="$guid"/>&amp;recurrenceId=<xsl:value-of select="$recurrenceId"/></xsl:attribute>
                <xsl:attribute name="data-public-event-summary"><xsl:value-of select="summary"/></xsl:attribute>
                <xsl:attribute name="title"><xsl:value-of select="$bwStr-EvLC-ShowPublicLink"/></xsl:attribute>
                <span class="ui-icon ui-icon-link"></span>
              </a>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <xsl:if test="$pending = 'true'">
        <td>
          <xsl:value-of select="calSuite"/>
        </td>
        <xsl:choose>
          <xsl:when test="xproperties/X-BEDEWORK-SUBMISSION-CLAIMANT">
            <td>
              <xsl:value-of select="xproperties/X-BEDEWORK-SUBMISSION-CLAIMANT/values/text"/>
              <xsl:text> </xsl:text>
              (<xsl:value-of select="xproperties/X-BEDEWORK-SUBMISSION-CLAIMANT/parameters/X-BEDEWORK-SUBMISSION-CLAIMANT-USER"/>)
            </td>
          </xsl:when>
          <xsl:otherwise>
            <td class="unclaimed"><xsl:copy-of select="$bwStr-EvLC-Unclaimed"/></td>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
      <td class="date">
        <xsl:value-of select="start/shortdate"/>
        <xsl:text> </xsl:text>
        <xsl:choose>
          <xsl:when test="start/allday = 'false'">
            <xsl:value-of select="start/time"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:copy-of select="$bwStr-AEEF-AllDay"/>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td class="date">
        <xsl:value-of select="end/shortdate"/>
        <xsl:text> </xsl:text>
        <xsl:choose>
          <xsl:when test="start/allday = 'false'">
            <xsl:value-of select="end/time"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:copy-of select="$bwStr-AEEF-AllDay"/>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <xsl:if test="$suggestionQueue = 'false'">
        <td class="calcat">
          <xsl:choose>
            <xsl:when test="$pending = 'true'">
              <xsl:if test="xproperties/X-BEDEWORK-SUBMIT-ALIAS">
                <ul>
                  <xsl:for-each select="xproperties/X-BEDEWORK-SUBMIT-ALIAS">
                    <li><xsl:value-of select="parameters/X-BEDEWORK-PARAM-DISPLAYNAME"/></li>
                  </xsl:for-each>
                </ul>
              </xsl:if>
            </xsl:when>
            <xsl:otherwise>
              <xsl:if test="xproperties/X-BEDEWORK-ALIAS[contains(values/text,/bedework/currentCalSuite/resourcesHome)]">
                <ul>
                  <xsl:for-each select="xproperties/X-BEDEWORK-ALIAS[contains(values/text,/bedework/currentCalSuite/resourcesHome)]">
                    <li><xsl:value-of select="substring-after(values/text,/bedework/currentCalSuite/resourcesHome)"/></li>
                  </xsl:for-each>
                </ul>
              </xsl:if>
              <xsl:if test="xproperties/X-BEDEWORK-ALIAS[not(contains(values/text,/bedework/currentCalSuite/resourcesHome))]">
                <xsl:variable name="tagsId">bwTags-<xsl:value-of select="guid"/></xsl:variable>
                <div class="bwEventListOtherGroupTags">
                  <div class="otherTagsControls">
                    <strong><xsl:copy-of select="$bwStr-EvLC-ThisEventCrossTagged"/></strong><br/>
                    <input type="checkbox" name="tagsToggle" id="tagsToggle-{$tagsId}" value="" onclick="toggleVisibility('{$tagsId}','bwOtherTags')"/>
                    <label for="tagsToggle-{$tagsId}"><xsl:copy-of select="$bwStr-EvLC-ShowTagsByOtherGroups"/></label>
                  </div>
                  <ul id="{$tagsId}" class="invisible">
                    <xsl:for-each select="xproperties/X-BEDEWORK-ALIAS[not(contains(values/text,/bedework/currentCalSuite/resourcesHome))]">
                      <li><xsl:value-of select="values/text"/></li>
                    </xsl:for-each>
                  </ul>
                </div>
              </xsl:if>
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </xsl:if>
      <xsl:if test="$pending = 'false'">
        <td class="calcat">
          <xsl:if test="categories/category">
            <ul>
              <xsl:for-each select="categories/category">
                <li><xsl:value-of select="value"/></li>
              </xsl:for-each>
            </ul>
          </xsl:if>
        </td>
      </xsl:if>
      <td>
        <xsl:choose>
          <xsl:when test="$pending = 'true'">
            <xsl:value-of select="xproperties/X-BEDEWORK-SUBMITTEDBY/values/text"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="substring-before(xproperties/X-BEDEWORK-SUBMITTEDBY/values/text,' ')"/>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:value-of select="description"/>
        <xsl:if test="recurring = 'true' or recurrenceId != ''">
          <div class="recurrenceEditLinks">
            <xsl:text> </xsl:text>
            <xsl:copy-of select="$bwStr-EvLC-RecurringEventEdit"/>
            <xsl:text> </xsl:text>
            <xsl:choose>
              <xsl:when test="$pending = 'true'">
                <!-- only master events can be published -->
                <a href="{$event-fetchForUpdatePending}&amp;calPath={$calPath}&amp;guid={$guid}">
                  <xsl:copy-of select="$bwStr-EvLC-Master"/>
                </a>
              </xsl:when>
              <xsl:when test="$approvalQueue = 'true'">
                <a href="{$event-fetchForUpdateApprovalQueue}&amp;calPath={$calPath}&amp;guid={$guid}">
                  <xsl:copy-of select="$bwStr-EvLC-Master"/>
                </a>
              </xsl:when>
              <xsl:otherwise>
                <a href="{$event-fetchForUpdate}&amp;calPath={$calPath}&amp;guid={$guid}">
                  <xsl:copy-of select="$bwStr-EvLC-Master"/>
                </a>
              </xsl:otherwise>
            </xsl:choose>
            <!-- recurrence instances can only be edited; and do not link to them in suggestion queue-->
            <xsl:if test="$suggestionQueue = 'false'">
            | <a href="{$event-fetchForUpdate}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}">
                <xsl:copy-of select="$bwStr-EvLC-Instance"/>
              </a>
            </xsl:if>
          </div>
        </xsl:if>

        <div class="created-modified">
          <xsl:if test="deleted = 'true'">
            <xsl:copy-of select="$bwStr-EvLC-EventDeleted"/>
            <br/>
          </xsl:if>
          <xsl:copy-of select="$bwStr-EvLC-Lastmod"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="substring(lastmod,1,4)"/>-<xsl:value-of select="substring(lastmod,5,2)"/>-<xsl:value-of select="substring(lastmod,7,2)"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="substring(lastmod,10,2)"/>:<xsl:value-of select="substring(lastmod,12,2)"/> utc
          <br/>
          <xsl:copy-of select="$bwStr-EvLC-Created"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="substring(created,1,4)"/>-<xsl:value-of select="substring(created,5,2)"/>-<xsl:value-of select="substring(created,7,2)"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="substring(created,10,2)"/>:<xsl:value-of select="substring(created,12,2)"/> utc
        </div>
      </td>
      <xsl:if test="$suggestionQueue = 'true'">
        <td>
          <xsl:variable name="actionPrefix"><xsl:value-of select="$suggest-setStatus"/>&amp;calPath=<xsl:value-of select="$calPath"/>&amp;guid=<xsl:value-of select="$guid"/>&amp;recurrenceId=<xsl:value-of select="$recurrenceId"/></xsl:variable>
          <button onclick="setSuggestionRowStatus('accept','{$actionPrefix}','suggestionRow{$i}','{$bwStr-EvLC-NoEvents}')">
            <xsl:value-of select="$bwStr-SEBu-Accept"/>
          </button>
          <button onclick="setSuggestionRowStatus('reject','{$actionPrefix}','suggestionRow{$i}','{$bwStr-EvLC-NoEvents}')">
            <xsl:value-of select="$bwStr-SEBu-Reject"/>
          </button>
        </td>
      </xsl:if>
    </tr>
  </xsl:template>

</xsl:stylesheet>