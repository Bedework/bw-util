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

  <!--+++++++++++++++ Locations ++++++++++++++++++++-->
  <!-- templates:
         - locationList
         - modLocation (add/edit location form)
         - deleteLocationConfirm
         - locationReferenced (displayed when trying to delete a location in use)
   -->

  <!-- Locations listing -->
  <xsl:template name="locationList">
    <div class="mgmtHeading">
      <h2><xsl:copy-of select="$bwStr-LoLi-ManageLocations"/></h2>
      <input type="button" name="return" value="{$bwStr-LoLi-AddNewLocation}" onclick="javascript:location.replace('{$location-initAdd}')"/>
      <p>
        <xsl:copy-of select="$bwStr-LoLi-SelectLocationToUpdate"/>
      </p>
    </div>

    <table id="commonListTable">
      <tr>
        <th><xsl:copy-of select="$bwStr-LoLi-Name"/></th>
        <th><xsl:copy-of select="$bwStr-LoLi-Room"/></th>
        <th><xsl:copy-of select="$bwStr-LoLi-Address"/></th>
        <th><xsl:copy-of select="$bwStr-LoLi-URL"/></th>
        <xsl:if test="/bedework/userInfo/superUser = 'true'">
          <th><xsl:copy-of select="$bwStr-LoLi-Status"/></th>
        </xsl:if>
      </tr>

      <xsl:for-each select="/bedework/locations/location">
        <xsl:variable name="statusVal">
          <xsl:choose>
            <xsl:when test="status='deleted'">archived</xsl:when>
            <xsl:otherwise><xsl:value-of select="status"/></xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <tr>
          <xsl:if test="position() mod 2 = 0"><xsl:attribute name="class">even</xsl:attribute></xsl:if>
          <td>
            <xsl:copy-of select="address/*"/>
          </td>
          <td>
            <xsl:value-of select="roomField"/>
          </td>
          <td>
            <xsl:value-of select="street"/><xsl:if test="city != ''">, <xsl:value-of select="city"/></xsl:if><xsl:if test="state != ''">, <xsl:value-of select="state"/></xsl:if>
            <xsl:if test="zip != ''"><xsl:text> </xsl:text><xsl:value-of select="zip"/></xsl:if>
          </td>
          <td>
            <xsl:variable name="link" select="link" />
            <a href="{$link}" target="linktest">
              <xsl:value-of select="link" />
            </a>
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

  <!-- Locations add/modify form -->
  <xsl:template name="modLocation">
    <xsl:choose>
      <xsl:when test="/bedework/creating='true'">
        <h2><xsl:copy-of select="$bwStr-MoLo-AddLocation"/></h2>
      </xsl:when>
      <xsl:otherwise>
        <h2><xsl:copy-of select="$bwStr-MoLo-UpdateLocation"/></h2>
      </xsl:otherwise>
    </xsl:choose>

    <form action="{$location-update}" id="bwModLocationForm" method="post">
      <table class="commonFormTable">
        <tr>
          <td class="fieldName">
            <label for="locationAddressField"><xsl:copy-of select="$bwStr-MoLo-Name"/></label>
          </td>
          <td>
            <input type="text" name="location.addressField" id="locationAddressField" size="40" value="">
              <xsl:attribute name="value"><xsl:value-of select="/bedework/formElements/form/addressField/input/@value"/></xsl:attribute>
              <xsl:attribute name="placeholder"><xsl:value-of select="$bwStr-MoLo-Address-Placeholder"/></xsl:attribute>
            </input>
            <span class="fieldInfo"><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-MoLo-Address-Info"/></span>
          </td>
        </tr>
        <tr class="optional">
          <td class="fieldName">
            <label for="locationRoomField"><xsl:copy-of select="$bwStr-MoLo-Room"/></label>
          </td>
          <td>
            <input type="text" name="location.roomField" id="locationRoomField" size="40" value="">
              <xsl:attribute name="value"><xsl:value-of select="/bedework/formElements/form/roomField/input/@value"/></xsl:attribute>
              <xsl:attribute name="placeholder"><xsl:value-of select="$bwStr-MoLo-Room-Placeholder"/></xsl:attribute>
            </input>
            <span class="fieldInfo"><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-MoLo-Optional"/></span>
          </td>
        </tr>
        <!--
        <tr class="optional">
          <td>
            <label for="locationSubAddress"><xsl:copy-of select="$bwStr-MoLo-SubAddress"/></label>
          </td>
          <td>
            <input type="text" name="locationSubaddress.value" id="locationSubAddress2" size="40">
              <xsl:attribute name="value"><xsl:value-of select="/bedework/formElements/form/subaddress/input/@value"/></xsl:attribute>
              <xsl:attribute name="placeholder"><xsl:value-of select="$bwStr-MoLo-SubAddress-Placeholder"/></xsl:attribute>
            </input>
            <span class="fieldInfo"><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-MoLo-Optional"/></span>
          </td>
        </tr>
        -->

        <tr id="bw-location-address" class="optional">
          <td class="fieldName">
            <xsl:copy-of select="$bwStr-MoLo-Address"/>
          </td>
          <td>
            <fieldset>
              <label for="locationStreet"><xsl:copy-of select="$bwStr-MoLo-Street"/></label>
              <input type="text" name="location.street" id="locationStreet" size="40">
                <xsl:attribute name="value"><xsl:value-of select="/bedework/formElements/form/street/input/@value"/></xsl:attribute>
                <xsl:attribute name="placeholder"><xsl:value-of select="$bwStr-MoLo-Street-Placeholder"/></xsl:attribute>
              </input>
              <span class="fieldInfo"><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-MoLo-Optional"/></span>

              <br/>

              <label for="locationCity"><xsl:copy-of select="$bwStr-MoLo-City"/></label>
              <input type="text" name="location.city" id="locationCity" size="40">
                <xsl:attribute name="value"><xsl:value-of select="/bedework/formElements/form/city/input/@value"/></xsl:attribute>
                <xsl:attribute name="placeholder"><xsl:value-of select="$bwStr-MoLo-City-Placeholder"/></xsl:attribute>
              </input>

              <br/>

              <label for="locationState"><xsl:copy-of select="$bwStr-MoLo-State"/></label>
              <input type="text" name="location.state" id="locationState" size="2">
                <xsl:attribute name="value"><xsl:value-of select="/bedework/formElements/form/state/input/@value"/></xsl:attribute>
                <xsl:attribute name="placeholder"><xsl:value-of select="$bwStr-MoLo-State-Placeholder"/></xsl:attribute>
              </input>
              <label for="locationPostalCode" class="inline"><xsl:copy-of select="$bwStr-MoLo-PostalCode"/></label>
              <input type="text" name="location.zip" id="locationPostalCode" size="10">
                <xsl:attribute name="value"><xsl:value-of select="/bedework/formElements/form/zip/input/@value"/></xsl:attribute>
                <xsl:attribute name="placeholder"><xsl:value-of select="$bwStr-MoLo-PostalCode-Placeholder"/></xsl:attribute>
              </input>
            </fieldset>

          </td>
        </tr>


        <!-- Alternate address -->
        <tr class="optional">
          <td class="fieldName">
            <label for="alternateAddress"><xsl:copy-of select="$bwStr-MoLo-AlternateAddress"/></label>
          </td>
          <td>
            <input type="text" name="location.alternateAddress" id="alternateAddress" size="40">
              <xsl:attribute name="value"><xsl:value-of select="/bedework/formElements/form/alternateAddress/input/@value"/></xsl:attribute>
              <xsl:attribute name="placeholder"><xsl:value-of select="$bwStr-MoLo-AlternateAddress-Placeholder"/></xsl:attribute>
            </input>
            <span class="fieldInfo"><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-MoLo-Optional"/></span>
          </td>
        </tr>
        <!-- Code - used for location's organizational identifier or code -->
        <tr class="optional">
          <td class="fieldName">
            <label for="locationCode"><xsl:copy-of select="$bwStr-MoLo-Code"/></label>
          </td>
          <td>
            <input type="text" name="location.code" id="locationCode" size="40">
              <xsl:attribute name="value"><xsl:value-of select="/bedework/formElements/form/code/input/@value"/></xsl:attribute>
              <xsl:attribute name="placeholder"><xsl:value-of select="$bwStr-MoLo-Code-Placeholder"/></xsl:attribute>
            </input>
            <span class="fieldInfo"><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-MoLo-Optional"/></span>
          </td>
        </tr>
        <!-- Subfield2 - used by default for full URL to Map -->
        <tr class="optional">
          <td class="fieldName">
            <label for="locationSubField2"><xsl:copy-of select="$bwStr-MoLo-SubField2"/></label>
          </td>
          <td>
            <input type="text" name="location.subField2" id="locationSubField2" size="40">
              <xsl:attribute name="value"><xsl:value-of select="/bedework/formElements/form/subField2/input/@value"/></xsl:attribute>
              <xsl:attribute name="placeholder"><xsl:value-of select="$bwStr-MoLo-SubField2-Placeholder"/></xsl:attribute>
            </input>
            <span class="fieldInfo"><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-MoLo-Optional"/></span>
          </td>
        </tr>
        <tr class="optional">
          <td class="fieldName">
            <label for="locationUrl"><xsl:copy-of select="$bwStr-MoLo-LocationURL"/></label>
          </td>
          <td>
            <input type="text" name="location.link" id="locationUrl" size="40">
              <xsl:attribute name="value"><xsl:value-of select="/bedework/formElements/form/link/input/@value"/></xsl:attribute>
              <xsl:attribute name="placeholder"><xsl:value-of select="$bwStr-MoLo-LocationURL-Placeholder"/></xsl:attribute>
            </input>
            <span class="fieldInfo"><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-MoLo-Optional"/></span>
          </td>
        </tr>
        <tr class="optional">
          <td class="fieldName">
            <label for="geoUri"><xsl:copy-of select="$bwStr-MoLo-GeoUri"/></label>
          </td>
          <td>
            <input type="text" name="location.geouri" id="geoUri" size="40">
              <xsl:attribute name="value"><xsl:value-of select="/bedework/formElements/form/geouri/input/@value"/></xsl:attribute>
              <xsl:attribute name="placeholder"><xsl:value-of select="$bwStr-MoLo-GeoUri-Placeholder"/></xsl:attribute>
            </input>
            <span class="fieldInfo"><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-MoLo-Optional"/></span>
          </td>
        </tr>
        <tr class="optional">
          <td>
          </td>
          <td>
            <input type="hidden" name="location.accessible" id="locationAccessible" value="false">
              <xsl:if test="/bedework/formElements/form/accessible/input/@checked = 'checked'">
                <xsl:attribute name="value">true</xsl:attribute>
              </xsl:if>
            </input>
            <input type="checkbox" name="location-accessible-holder" id="locationAccessibleHolder">
              <xsl:if test="/bedework/formElements/form/accessible/input/@checked = 'checked'">
                <xsl:attribute name="checked">checked</xsl:attribute>
              </xsl:if>
            </input>
            <label for="locationAccessibleHolder"><xsl:copy-of select="$bwStr-MoLo-LocationAccessible"/></label>
            <span class="fieldInfo"><xsl:text> </xsl:text><xsl:copy-of select="$bwStr-MoLo-Optional"/></span>

            <script type="text/javascript">
              $("#locationAccessibleHolder").click(function() {
                if (this.checked) {
                  $("#locationAccessible").val(true);
                } else {
                  $("#locationAccessible").val(false);
                }
              });
            </script>

          </td>
        </tr>
        <xsl:if test="/bedework/userInfo/superUser = 'true'">
          <tr>
            <td>
              <label for="locDeleted"><xsl:copy-of select="$bwStr-MoLo-Deleted"/></label>
            </td>
            <td>
              <input type="checkbox" name="deleted" id="locDeleted" value="true">
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
            <input type="submit" name="addLocation" value="{$bwStr-MoLo-AddLocation}"/>
            <input type="submit" name="cancelled" value="{$bwStr-MoLo-Cancel}"/>
          </xsl:when>
          <xsl:otherwise>
            <input type="submit" name="updateLocation" value="{$bwStr-MoLo-UpdateLocation}"/>
            <input type="submit" name="cancelled" value="{$bwStr-MoLo-Cancel}"/>
            <div class="right">
              <input type="submit" name="delete" value="{$bwStr-MoLo-DeleteLocation}"/>
            </div>
          </xsl:otherwise>
        </xsl:choose>
      </div>
    </form>
  </xsl:template>

  <!-- Locations deletion confirmation page -->
  <xsl:template name="deleteLocationConfirm">
    <h2><xsl:copy-of select="$bwStr-DeLC-OkDeleteLocation"/></h2>
    <p id="confirmButtons">
      <xsl:copy-of select="/bedework/formElements/*"/>
    </p>

    <table class="commonFormTable">
      <tr>
        <td class="fieldName">
            <xsl:copy-of select="$bwStr-DeLC-Address"/>
          </td>
        <td>
          <xsl:value-of select="/bedework/location/address"/>
        </td>
      </tr>
      <tr class="optional">
        <td class="fieldName">
            <xsl:copy-of select="$bwStr-DeLC-SubAddress"/>
          </td>
        <td>
          <xsl:value-of select="/bedework/location/subaddress"/>
        </td>
      </tr>
      <tr class="optional">
        <td class="fieldName">
            <xsl:copy-of select="$bwStr-DeLC-LocationURL"/>
          </td>
        <td>
          <xsl:variable name="link" select="/bedework/location/link"/>
          <a href="{$link}">
            <xsl:value-of select="/bedework/location/link"/>
          </a>
        </td>
      </tr>
    </table>
  </xsl:template>

  <!-- Locations referenced notice -->
  <xsl:template name="locationReferenced">
    <h2><xsl:copy-of select="$bwStr-DeLR-LocationInUse"/></h2>
    <p id="confirmButtons">
      <xsl:copy-of select="/bedework/formElements/*"/>
    </p>

    <table class="eventFormTable">
      <tr>
        <td class="fieldName">
            <xsl:copy-of select="$bwStr-DeLC-Address"/>
          </td>
        <td>
          <xsl:value-of select="/bedework/location/address"/>
        </td>
      </tr>
      <tr class="optional">
        <td>
            <xsl:copy-of select="$bwStr-DeLC-SubAddress"/>
          </td>
        <td>
          <xsl:value-of select="/bedework/location/subaddress"/>
        </td>
      </tr>
      <tr class="optional">
        <td>
            <xsl:copy-of select="$bwStr-DeLC-LocationURL"/>
          </td>
        <td>
          <xsl:variable name="link" select="/bedework/location/link"/>
          <a href="{$link}">
            <xsl:value-of select="/bedework/location/link"/>
          </a>
        </td>
      </tr>
    </table>

    <p>
      <xsl:copy-of select="$bwStr-DeLR-LocationInUseBy"/>
    </p>

    <xsl:if test="/bedework/userInfo/superUser = 'true'">
      <div class="suTitle"><xsl:copy-of select="$bwStr-DeLR-SuperUserMsg"/></div>
      <div id="superUserMenu">
        <!-- List collections that reference the location -->
        <xsl:if test="/bedework/propRefs/propRef[isCollection = 'true']">
          <h4><xsl:copy-of select="$bwStr-DeLR-Collections"/></h4>
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
        <!-- List events that reference the location -->
        <xsl:if test="/bedework/propRefs/propRef[isCollection = 'false']">
          <h4><xsl:copy-of select="$bwStr-DeLR-Events"/></h4>
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
