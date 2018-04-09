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

  <!--+++++++++++++++ Contacts ++++++++++++++++++++--><!-- templates:
         - contactList
         - modContact (add/edit contact form)
         - deleteContactConfirm
         - contactReferenced (displayed when trying to delete a contact in use)
   -->

  <xsl:template name="contactList">
    <div class="mgmtHeading">
      <h2><xsl:copy-of select="$bwStr-Cont-ManageContacts"/></h2>
      <input type="button" name="return" value="{$bwStr-Cont-AddNewContact}" onclick="javascript:location.replace('{$contact-initAdd}')"/>
      <p>
        <xsl:copy-of select="$bwStr-Cont-SelectContact"/>
      </p>
    </div>

    <table id="commonListTable" title="{$bwStr-Cont-ListOfContacts}">
      <tr>
        <th><xsl:copy-of select="$bwStr-Cont-Name"/></th>
        <th><xsl:copy-of select="$bwStr-Cont-Phone"/></th>
        <th><xsl:copy-of select="$bwStr-Cont-Email"/></th>
        <th><xsl:copy-of select="$bwStr-Cont-URL"/></th>
        <xsl:if test="/bedework/userInfo/superUser = 'true'">
          <th><xsl:copy-of select="$bwStr-Cont-Status"/></th>
        </xsl:if>
      </tr>

      <xsl:for-each select="/bedework/contacts/contact">
        <xsl:variable name="statusVal">
          <xsl:choose>
            <xsl:when test="status='deleted'">archived</xsl:when>
            <xsl:otherwise><xsl:value-of select="status"/></xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <tr>
          <xsl:if test="position() mod 2 = 0"><xsl:attribute name="class">even</xsl:attribute></xsl:if>
          <td>
            <xsl:copy-of select="name/node()"/>
          </td>
          <td>
            <xsl:value-of select="phone"/>
          </td>
          <td>
            <xsl:if test="email">
              <xsl:variable name="email" select="email"/>
              <a href="mailto:{$email}">
                <xsl:value-of select="email"/>
              </a>
            </xsl:if>
          </td>
          <td>
            <xsl:if test="link">
              <xsl:variable name="link" select="link"/>
              <a href="{$link}" target="linktest">
                <xsl:value-of select="link"/>
              </a>
            </xsl:if>
          </td>
          <xsl:if test="/bedework/userInfo/superUser = 'true'">
            <td>
              <xsl:value-of select="$statusVal"/>
            </td>
          </xsl:if>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <xsl:template name="modContact">
    <form action="{$contact-update}" method="post">
      <h2><xsl:copy-of select="$bwStr-MdCo-ContactInfo"/></h2>

      <table id="eventFormTable">
        <tr>
          <td class="fieldName">
            <label for="contactName"><xsl:copy-of select="$bwStr-MdCo-ContactName"/></label>
          </td>
          <td>
            <input type="text" name="contactName.value" id="contactName" size="40">
              <xsl:attribute name="value"><xsl:value-of select="/bedework/formElements/form/name/input/@value"/></xsl:attribute>
            </input>
            <span class="fieldInfo"><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-MdCo-ContactName-Placeholder"/></span>
          </td>
        </tr>
        <tr>
          <td class="fieldName">
            <label for="contactPhone"><xsl:copy-of select="$bwStr-MdCo-ContactPhone"/></label>
          </td>
          <td>
            <input type="text" name="contact.phone" id="contactPhone" size="40">
              <xsl:attribute name="value"><xsl:value-of select="/bedework/formElements/form/phone/input/@value"/></xsl:attribute>
              <xsl:attribute name="placeholder"><xsl:value-of select="$bwStr-MdCo-ContactPhone-Placeholder"/></xsl:attribute>
            </input>
            <span class="fieldInfo"><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-MdCo-Optional"/></span>
          </td>
        </tr>
        <tr class="optional">
          <td>
            <label for="contactUrl"><xsl:copy-of select="$bwStr-MdCo-ContactURL"/></label>
          </td>
          <td>
            <input type="text" name="contact.link" id="contactUrl" size="40">
              <xsl:attribute name="value"><xsl:value-of select="/bedework/formElements/form/link/input/@value"/></xsl:attribute>
              <xsl:attribute name="placeholder"><xsl:value-of select="$bwStr-MdCo-ContactURL-Placeholder"/></xsl:attribute>
            </input>
            <span class="fieldInfo"><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-MdCo-Optional"/></span>
          </td>
        </tr>
        <tr class="optional">
          <td>
            <label for="contactEmail"><xsl:copy-of select="$bwStr-MdCo-ContactEmail"/></label>
          </td>
          <td>
            <input type="text" name="contact.email" id="contactEmail" size="40">
              <xsl:attribute name="value"><xsl:value-of select="/bedework/formElements/form/email/input/@value"/></xsl:attribute>
            </input>
            <span class="fieldInfo"><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-MdCo-Optional"/></span>
          </td>
        </tr>
        <xsl:if test="/bedework/userInfo/superUser = 'true'">
          <tr>
            <td>
              <label for="contactDeleted"><xsl:copy-of select="$bwStr-MdCo-ContactDeleted"/></label>
            </td>
            <td>
              <input type="checkbox" name="deleted" id="contactDeleted" value="true">
                <xsl:if test="/bedework/formElements/form/status/input/@value = 'deleted'">
                  <xsl:attribute name="checked">true</xsl:attribute>
                </xsl:if>
              </input>
            </td>
          </tr>
        </xsl:if>
      </table>

      <div class="submitBox">
        <xsl:choose>
          <xsl:when test="/bedework/creating='true'">
            <input type="submit" name="addContact" value="{$bwStr-DCoC-AddContact}"/>
            <input type="submit" name="cancelled" value="{$bwStr-DCoC-Cancel}"/>
          </xsl:when>
          <xsl:otherwise>
            <input type="submit" name="updateContact" value="{$bwStr-DCoC-UpdateContact}"/>
            <input type="submit" name="cancelled" value="{$bwStr-DCoC-Cancel}"/>
            <div class="right">
              <input type="submit" name="delete" value="{$bwStr-DCoC-DeleteContact}"/>
            </div>
          </xsl:otherwise>
        </xsl:choose>
      </div>
    </form>
  </xsl:template>

  <xsl:template name="deleteContactConfirm">
    <h2><xsl:copy-of select="$bwStr-DCoC-OKToDelete"/></h2>
    <p id="confirmButtons">
      <xsl:copy-of select="/bedework/formElements/*"/>
    </p>

    <table class="eventFormTable">
      <tr>
        <th><xsl:copy-of select="$bwStr-DCoC-Name"/></th>
        <td>
          <xsl:value-of select="/bedework/contact/name"/>
        </td>
      </tr>
      <tr>
        <th><xsl:copy-of select="$bwStr-DCoC-Phone"/></th>
        <td>
          <xsl:value-of select="/bedework/contact/phone"/>
        </td>
      </tr>
      <tr>
        <th><xsl:copy-of select="$bwStr-DCoC-Email"/></th>
        <td>
          <xsl:value-of select="/bedework/contact/email"/>
        </td>
      </tr>
      <tr>
        <th><xsl:copy-of select="$bwStr-DCoC-URL"/></th>
        <td>
          <xsl:value-of select="/bedework/contact/link"/>
        </td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template name="contactReferenced">
    <h2><xsl:copy-of select="$bwStr-DCoR-ContactInUse"/></h2>

    <table class="eventFormTable">
      <tr>
        <th><xsl:copy-of select="$bwStr-DCoC-Name"/></th>
        <td>
          <xsl:value-of select="/bedework/contact/name"/>
        </td>
      </tr>
      <tr>
        <th><xsl:copy-of select="$bwStr-DCoC-Phone"/></th>
        <td>
          <xsl:value-of select="/bedework/contact/phone"/>
        </td>
      </tr>
      <tr>
        <th><xsl:copy-of select="$bwStr-DCoC-Email"/></th>
        <td>
          <xsl:value-of select="/bedework/contact/email"/>
        </td>
      </tr>
      <tr>
        <th><xsl:copy-of select="$bwStr-DCoC-URL"/></th>
        <td>
          <xsl:value-of select="/bedework/contact/link"/>
        </td>
      </tr>
    </table>

    <p>
      <xsl:copy-of select="$bwStr-DCoR-ContactInUseBy"/>
    </p>

    <xsl:if test="/bedework/userInfo/superUser = 'true'">
      <div class="suTitle"><xsl:copy-of select="$bwStr-DCoR-SuperUserMsg"/></div>
      <div id="superUserMenu">
        <!-- List collections that reference the contact -->
        <xsl:if test="/bedework/propRefs/propRef[isCollection = 'true']">
          <h4><xsl:copy-of select="$bwStr-DCoR-Collections"/></h4>
          <ul>
            <xsl:for-each select="/bedework/propRefs/propRef[isCollection = 'true']">
              <li>
                <xsl:variable name="calPath" select="path"/>
                <a href="{$calendar-fetchForUpdate}&amp;calPath={$calPath}">
                  <xsl:value-of select="path"/>
                </a>
              </li>
            </xsl:for-each>
          </ul>
        </xsl:if>
        <!-- List events that reference the contact -->
        <xsl:if test="/bedework/propRefs/propRef[isCollection = 'false']">
          <h4><xsl:copy-of select="$bwStr-DCoR-Events"/></h4>
          <ul>
            <xsl:for-each select="/bedework/propRefs/propRef[isCollection = 'false']">
              <li>
                <xsl:variable name="calPath" select="path"/>
                <xsl:variable name="guid" select="uid"/>
                <!-- only returns the master event -->
                <a href="{$event-fetchForUpdate}&amp;calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId=">
                  <xsl:value-of select="uid"/>
                </a>
              </li>
            </xsl:for-each>
          </ul>
        </xsl:if>
      </div>
    </xsl:if>

  </xsl:template>

</xsl:stylesheet>