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

  <!--+++++++++++++++ Resources ++++++++++++++++++++-->
  <!-- templates:
         - listResources
  -->

  <!-- List all resources -->
  <xsl:template name="listResources">
    <xsl:param name="global" select="'false'"/>
    <xsl:variable name="add-link">
      <xsl:choose>
        <xsl:when test="$global = 'true'">
          <xsl:copy-of select="$global-resources-add"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="$calsuite-resources-add"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <h2>
      <xsl:choose>
        <xsl:when test="$global = 'true'">
          <xsl:copy-of select="$bwStr-Resource-ManageResources-Global"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="$bwStr-Resource-ManageResources"/>
        </xsl:otherwise>
      </xsl:choose>
    </h2>
    <p>
      <xsl:choose>
        <xsl:when test="$global = 'true'">
          <xsl:copy-of select="$bwStr-Resource-ResourcesAre-Global"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="$bwStr-Resource-ResourcesAre"/>
        </xsl:otherwise>
      </xsl:choose>
    </p>

    <h4><xsl:copy-of select="$bwStr-Resource-AddNewResource"/></h4>
    <div class="addResourceForm" style="border: 1px solid grey; padding: 10px; display: table;">
	    <form name="addResource" action="{$add-link}" method="post">
        <label for="resName">
          <xsl:value-of select="$bwStr-Resource-NameLabel"/>
        </label>
	      <input type="text" name="name" id="resName" size="60"/>
	      <br/>

        <label for="resCt">
          <xsl:value-of select="$bwStr-Resource-ContentTypeLabel"/>
        </label>
	      <select name="ct" id="resCt">
	      	<option value="text/plain" selected="true">
	      	  <xsl:value-of select="$bwStr-Resource-Text"/>
          </option>
	      	<option value="application/xml">XML</option>
	      	<option value="text/css">CSS</option>
	      	<option value="image/png">PNG (Image)</option>
	      	<option value="image/jpeg">JPEG (Image)</option>
	      	<option value="image/gif">GIF (Image)</option>
	      </select>
	      <br/>

        <label for="resType">
          <xsl:value-of select="$bwStr-Resource-ResourceTypeLabel"/>
        </label>
	      <input type="text" name="type" id="resType" size="40"/>
	      <br/>

	      <xsl:choose>
	       <xsl:when test="$global = 'true'">
          <input type="hidden" name="class" value="global"/>
	       </xsl:when>
	       <xsl:when test="/bedework/userInfo/superUser = 'true'">
		       <label for="resClass">
		         <xsl:value-of select="$bwStr-Resource-ClassLabel"/>
		       </label>
	         <select name="class" id="resClass">
	           <option value="calsuite" selected="true">
	             <xsl:value-of select="$bwStr-Resource-CalendarSuite"/>
	           </option>
	           <option value="admin">
               <xsl:value-of select="$bwStr-Resource-Admin"/>
             </option>
	         </select>
           <br/>
	       </xsl:when>
	       <xsl:otherwise>
          <input type="hidden" name="class" value="calsuite"/>
	       </xsl:otherwise>
	      </xsl:choose>
	      <input type="submit" value="{$bwStr-Resource-AddNewResource}" name="addresource"/>
	    </form>
	  </div>

    <!-- The table of resources -->
    <h4><xsl:copy-of select="$bwStr-Resource-Resources"/></h4>
    <table id="commonListTable" class="resourcesTable">
      <tr>
        <th><xsl:copy-of select="$bwStr-Resource-NameCol"/></th>
        <th><xsl:copy-of select="$bwStr-Resource-ContentTypeCol"/></th>
        <th><xsl:copy-of select="$bwStr-Resource-ResourceTypeCol"/></th>
        <xsl:if test="$global = 'false' and /bedework/userInfo/superUser = 'true'">
          <th><xsl:copy-of select="$bwStr-Resource-ResourceClassCol"/></th>
        </xsl:if>
        <th> </th>
      </tr>
      <xsl:for-each select="/bedework/resources/resource">
        <xsl:sort select="name" order="ascending" case-order="upper-first"/>
        <xsl:variable name="resName" select="name"/>
        <xsl:variable name="resContentType" select="content-type"/>
        <xsl:variable name="resType" select="type"/>
        <xsl:variable name="resClass" select="class"/>
        <xsl:variable name="downloadLink" select="concat('/pubcaldav', path)"/>
        <xsl:variable name="edit-link">
		      <xsl:choose>
		        <xsl:when test="$global = 'true'">
		          <xsl:copy-of select="$global-resources-edit"/>
		        </xsl:when>
		        <xsl:otherwise>
		          <xsl:copy-of select="$calsuite-resources-edit"/>
		        </xsl:otherwise>
		      </xsl:choose>
        </xsl:variable>
        <tr>
          <xsl:if test="position() mod 2 = 0"><xsl:attribute name="class">even</xsl:attribute></xsl:if>
          <td>
            <a href="{$edit-link}&amp;name={$resName}&amp;class={$resClass}&amp;mod=true">
              <xsl:value-of select="$resName"/>
            </a>
          </td>
          <td>
          	<xsl:value-of select="$resContentType"/>
          </td>
          <td>
          	<xsl:value-of select="$resType"/>
          </td>
	        <xsl:if test="$global = 'false' and /bedework/userInfo/superUser = 'true'">
	          <td>
	            <xsl:value-of select="$resClass"/>
	          </td>
	        </xsl:if>
          <td>
            <a href="{$downloadLink}" target="bwResource">
              <xsl:copy-of select="$bwStr-Resource-ResourceURL"/>
            </a>
          </td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <!-- Add or Edit a resource -->
  <xsl:template name="modResource">
    <xsl:variable name="isCreating" select="/bedework/creating"/>
    <xsl:variable name="resource" select="/bedework/currentResource"/>
    <xsl:variable name="global" select="$resource/class = 'global'"/>
    <xsl:variable name="isText">
      <xsl:choose>
        <xsl:when test="$resource/content-type = 'text/plain'">true</xsl:when>
        <xsl:when test="$resource/content-type = 'text/css'">true</xsl:when>
        <xsl:when test="$resource/content-type = 'application/xml'">true</xsl:when>
        <xsl:otherwise>false</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="downloadLink" select="concat('/pubcaldav', $resource/path)"/>

    <xsl:choose>
      <xsl:when test="$resource/type = 'FeaturedEvents'">
        <!-- specialized resource handling for Featured Events images --><!-- note: we will never be creating when we edit this form -->
        <h2><xsl:value-of select="$bwStr-ModRes-FeaturedEventsAdmin"/></h2>
        <div id="modFeaturedEventsForm">
          <xsl:variable name="update-link">
            <xsl:choose>
              <xsl:when test="$global = 'true'">
                <xsl:copy-of select="$global-resources-update"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:copy-of select="$calsuite-resources-update"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>

          <script type="text/javascript">
            <xsl:text>
              $(document).ready(function() {
            </xsl:text>
            <xsl:text>$.ajax({url: "</xsl:text>
            <xsl:value-of select="$downloadLink"/>
            <xsl:text>",
               error: function() { $("#resourceContent").val("-- Failed to retrieve resource content! --"); },
               dataFilter: function(data, type) { return data; },
               success: function(data) { $("#resourceContent").val(data); },
               cache: false,
               dataType: "text"});
              });
            </xsl:text>
          </script>

          <xsl:apply-templates select="document($downloadLink)/featuredEvents"/>

          <form name="modResource" action="{$update-link}" method="post" enctype="multipart/form-data" onsubmit="return writeFeaturedEventsXml();">
            <input type="hidden" name="name" value="{$resource/name}"/>
            <input type="hidden" name="ct" value="{$resource/content-type}"/>
            <input type="hidden" name="type" value="{$resource/type}"/>
            <input type="hidden" name="class" value="{$resource/class}"/>

            <!-- trade the following two fields to see the featured events content
                 rendered in a textarea -->
            <input type="hidden" name="content" id="resourceContent"/>
            <!-- textarea name="content" rows="20" cols="120" id="resourceContent" style="display:block;"></textarea-->

            <input type="submit" name="update" value="{$bwStr-ModRes-UpdateFeaturedEvents}"/>
            <input type="submit" name="remove" value="{$bwStr-ModRes-RemoveFeaturedEvents}"/>
            <span> - OR - </span>
            <input type="submit" name="cancel" value="{$bwStr-ModRes-BackToList}"/>
          </form>

        </div>
      </xsl:when>
      <xsl:otherwise>
        <!-- normal resource handling  -->
        <xsl:choose>
		      <xsl:when test="$isCreating = 'true'">
		        <h2>
		          <xsl:value-of select="concat($bwStr-ModRes-AddResource, ' - ', $resource/name)"/>
		        </h2>
		      </xsl:when>
		      <xsl:otherwise>
		        <h2>
		          <xsl:value-of select="concat($bwStr-ModRes-EditResource, ' - ', $resource/name)"/>
		        </h2>
		      </xsl:otherwise>
		    </xsl:choose>
		    <br/>

		    <xsl:if test="$isCreating = 'false' and $isText = 'false'">
		      <a href="{$downloadLink}">
		        <xsl:value-of select="$bwStr-ModRes-ClickToDownload"/>
		      </a>
		      <br/>
		      <br/>
		    </xsl:if>

		    <div class="modResourceForm">
		      <xsl:variable name="update-link">
		        <xsl:choose>
		          <xsl:when test="$global = 'true'">
		            <xsl:copy-of select="$global-resources-update"/>
		          </xsl:when>
		          <xsl:otherwise>
		            <xsl:copy-of select="$calsuite-resources-update"/>
		          </xsl:otherwise>
		        </xsl:choose>
		      </xsl:variable>
		      <form name="modResource" action="{$update-link}" method="post" enctype="multipart/form-data">
		        <span class="resFormLabel">
		          <xsl:value-of select="$bwStr-ModRes-NameLabel"/>
		        </span>
		        <input type="hidden" name="name" value="{$resource/name}"/>
		        <span class="resFormField">
		          <xsl:value-of select="$resource/name"/>
		        </span>
		        <br/>

		        <span class="resFormLabel">
		          <xsl:value-of select="$bwStr-ModRes-ContentTypeLabel"/>
		        </span>
		        <input type="hidden" name="ct" value="{$resource/content-type}"/>
		        <span class="resFormField">
		          <xsl:value-of select="$resource/content-type"/>
		        </span>
		        <br/>

		        <span class="resFormLabel">
		          <xsl:value-of select="$bwStr-ModRes-ResourceTypeLabel"/>
		        </span>
		        <input type="hidden" name="type" value="{$resource/type}"/>
		        <span class="resFormField">
		          <xsl:value-of select="$resource/type"/>
		        </span>
		        <br/>

		        <xsl:if test="/bedework/userInfo/superUser = 'true' and global != 'true'">
			        <span class="resFormLabel">
			          <xsl:value-of select="$bwStr-ModRes-ClassLabel"/>
			        </span>
			        <span class="resFormField">
			          <xsl:value-of select="$resource/class"/>
			        </span>
			        <br/>
		        </xsl:if>
		        <input type="hidden" name="class" value="{$resource/class}"/>

		        <xsl:if test="$isText = 'true'">
			        <span class="resFormLabel">
			          <xsl:value-of select="$bwStr-ModRes-ResourceContentLabel"/>
			        </span>
		          <br/>
		          <textarea name="content" rows="20" cols="120" id="resourceContent" style="display:block;"><xsl:text> </xsl:text></textarea>
		          <xsl:if test="$isCreating = 'false'">
		            <script type="text/javascript">
		              <xsl:text>
		                $(document).ready(function() {
		              </xsl:text>
		              <xsl:text>$.ajax({url: "</xsl:text>
		              <xsl:value-of select="$downloadLink"/>
		              <xsl:text>",
		                  error: function() { $("#resourceContent").val("-- Failed to retrieve resource content! --"); },
		                  dataFilter: function(data, type) { return data; },
		                  success: function(data) { $("#resourceContent").val(data); },
		                  cache: false,
		                  dataType: "text"});</xsl:text>
		              <xsl:text>
		                });
		              </xsl:text>
		            </script>
		          </xsl:if>
		        </xsl:if>
		        <xsl:if test="$isText = 'false'">
			        <label for="resFile" class="resFormLabel">
			          <xsl:value-of select="$bwStr-ModRes-UploadLabel"/>
			        </label>
		          <input type="file" name="uploadFile" id="resFile" size="60"/>
		          <br/>
		        </xsl:if>

		        <br/>
		        <input type="submit" name="update">
		          <xsl:attribute name="value">
						    <xsl:choose>
						      <xsl:when test="$isCreating = 'true'">
		  		          <xsl:value-of select="$bwStr-ModRes-AddResource"/>
						      </xsl:when>
						      <xsl:otherwise>
		                <xsl:value-of select="$bwStr-ModRes-UpdateResource"/>
						      </xsl:otherwise>
						    </xsl:choose>
		          </xsl:attribute>
		        </input>
		        <xsl:if test="$isCreating != 'true'">
		          <input type="submit" name="remove" value="{$bwStr-ModRes-RemoveResource}"/>
		          <span> - OR - </span>
		          <input type="submit" name="cancel" value="{$bwStr-ModRes-BackToList}"/>
		        </xsl:if>
		      </form>
		    </div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Confirmation of resource deletion -->
  <xsl:template name="deleteResourceConfirm">
    <xsl:variable name="global" select="/bedework/currentResource/class = 'global'"/>
    <xsl:variable name="remove-link">
      <xsl:choose>
        <xsl:when test="$global = 'true'">
          <xsl:copy-of select="$global-resources-remove"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="$calsuite-resources-remove"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <h2><xsl:copy-of select="$bwStr-DelRes-RemoveResource"/></h2>

    <p>
      <xsl:copy-of select="$bwStr-DelRes-TheResource"/>
      <xsl:text> </xsl:text>
      <strong><xsl:value-of select="/bedework/currentResource/name"/></strong>
      <xsl:text> </xsl:text>
      <xsl:copy-of select="$bwStr-DelRes-WillBeRemoved"/>
    </p>
    <p class="note">
      <xsl:copy-of select="$bwStr-DelRes-BeForewarned"/>
    </p>

    <p><xsl:copy-of select="$bwStr-DelRes-Continue"/></p>

    <form name="removeResource" action="{$remove-link}" method="post">
      <input type="hidden" name="name" value="{/bedework/currentResource/name}"/>
      <input type="hidden" name="class" value="{/bedework/currentResource/class}"/>
      <input type="submit" name="delete" value="{$bwStr-DelRes-YesRemoveView}"/>
      <input type="submit" name="cancelled" value="{$bwStr-DelRes-Cancel}"/>
    </form>
  </xsl:template>

  <xsl:template match="featuredEvents">
    <div id="featuredEventsForm">

	    <fieldset>
	      <div class="formData">
	        <div class="controlBox">
	          <xsl:value-of select="$bwStr-ModRes-FeaturedEvents"/><br/>
	          <input type="radio" name="enabled" id="enabledOn" value="true">
	            <xsl:if test="featuresOn = 'true'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
	          </input>
	          <label for="enabledOn"><xsl:value-of select="$bwStr-ModRes-FeEnabled"/></label><br/>

	          <input type="radio" name="enabled" id="enabledOff" value="false">
	            <xsl:if test="featuresOn = 'false'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
	          </input>
	          <label for="enabledOff"><xsl:value-of select="$bwStr-ModRes-FeDisabled"/></label>
	        </div>
	        <div class="controlBox">
	          <xsl:value-of select="$bwStr-ModRes-FeMode"/><br/>
	          <input type="radio" name="singleMode" id="singleModeOff" value="false">
	            <xsl:if test="singleMode = 'false'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
	          </input>
	          <label for="singleModeOff"><xsl:value-of select="$bwStr-ModRes-FeTriptychMode"/></label><br/>

	          <input type="radio" name="singleMode" id="singleModeOn" value="true">
	            <xsl:if test="singleMode = 'true'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
	          </input>
	          <label for="singleModeOn"><xsl:value-of select="$bwStr-ModRes-FeSingleMode"/></label>
	        </div>

	        <h3>
            <xsl:if test="featuresOn = 'true' and singleMode = 'false'">
              <xsl:attribute name="class">active</xsl:attribute>
              <div id="activeLabel"><xsl:value-of select="$bwStr-ModRes-FeActive"/></div>
            </xsl:if>
	          <xsl:value-of select="$bwStr-ModRes-FePanels"/>
	        </h3>
	        <xsl:for-each select="features/group/image">
	          <xsl:variable name="index"><xsl:value-of select="position()"/></xsl:variable>
		        <div class="fieldGroup">
		          <a target="bwFeature">
		            <xsl:attribute name="href"><xsl:value-of select="link"/></xsl:attribute>
		            <img width="100">
		              <xsl:attribute name="src"><xsl:value-of select="name"/></xsl:attribute>
		              <xsl:attribute name="alt"><xsl:value-of select="toolTip"/></xsl:attribute>
		            </img>
		          </a>
		          <label class="field" for="image{$index}-name"><xsl:value-of select="$bwStr-ModRes-FeImageUrl"/></label>
		          <div class="value">
		            <input type="text" size="83" name="image{$index}-name" id="image{$index}-name">
		              <xsl:attribute name="value"><xsl:value-of select="name"/></xsl:attribute>
		            </input>
		          </div>
		          <label class="field" for="image{$index}-link"><xsl:value-of select="$bwStr-ModRes-FeLink"/></label>
		          <div class="value">
		            <input type="text" size="83" name="image{$index}-link" id="image{$index}-link">
	                <xsl:attribute name="value"><xsl:value-of select="link"/></xsl:attribute>
	              </input>
		          </div>
		          <label class="field" for="image{$index}-toolTip"><xsl:value-of select="$bwStr-ModRes-FeTooltip"/></label>
		          <div class="value">
		            <input type="text" size="83" name="image{$index}-toolTip" id="image{$index}-toolTip">
	                <xsl:attribute name="value"><xsl:value-of select="toolTip"/></xsl:attribute>
		            </input>
		          </div>
		        </div>
	        </xsl:for-each>

	        <h3>
            <xsl:if test="featuresOn = 'true' and singleMode = 'true'">
              <xsl:attribute name="class">active</xsl:attribute>
              <div id="activeLabel"><xsl:value-of select="$bwStr-ModRes-FeActive"/></div>
            </xsl:if>
	          <xsl:value-of select="$bwStr-ModRes-FeSinglePanel"/>
	        </h3>
	        <div class="fieldGroup">
	          <a target="bwFeature">
	            <xsl:attribute name="href"><xsl:value-of select="features/single/image/link"/></xsl:attribute>
	            <img width="300">
	              <xsl:attribute name="src"><xsl:value-of select="features/single/image/name"/></xsl:attribute>
	              <xsl:attribute name="alt"><xsl:value-of select="features/single/image/toolTip"/></xsl:attribute>
	            </img>
	          </a>
	          <label class="field" for="singleImage-name"><xsl:value-of select="$bwStr-ModRes-FeImageUrl"/></label>
	          <div class="value">
	            <input type="text" size="50" name="singleImage-name" id="singleImage-name">
	              <xsl:attribute name="value"><xsl:value-of select="features/single/image/name"/></xsl:attribute>
	            </input>
	          </div>
	          <label class="field" for="singleImage-link"><xsl:value-of select="$bwStr-ModRes-FeLink"/></label>
	          <div class="value">
	            <input type="text" size="50" name="singleImage-link" id="singleImage-link">
	              <xsl:attribute name="value"><xsl:value-of select="features/single/image/link"/></xsl:attribute>
	            </input>
	          </div>
	          <label class="field" for="singleImage-toolTip"><xsl:value-of select="$bwStr-ModRes-FeTooltip"/></label>
	          <div class="value">
	            <input type="text" size="50" name="singleImage-toolTip" id="singleImage-toolTip">
	              <xsl:attribute name="value"><xsl:value-of select="features/single/image/toolTip"/></xsl:attribute>
	            </input>
	          </div>
	        </div>

	        <h3>
	          <xsl:if test="featuresOn = 'false'">
		          <xsl:attribute name="class">active</xsl:attribute>
		          <div id="activeLabel"><xsl:value-of select="$bwStr-ModRes-FeActive"/></div>
		        </xsl:if>
	          <xsl:value-of select="$bwStr-ModRes-FeGenericPanels"/>
	        </h3>
	        <xsl:for-each select="generics/group/image">
	          <xsl:variable name="index"><xsl:value-of select="position()"/></xsl:variable>
		        <div class="fieldGroup">
	            <img width="100">
	              <xsl:attribute name="src"><xsl:value-of select="name"/></xsl:attribute>
	              <xsl:attribute name="alt"><xsl:value-of select="tooltip"/></xsl:attribute>
	            </img>
	            <label class="field" for="genImage{$index}-name"><xsl:value-of select="$bwStr-ModRes-FeImageUrl"/></label>
		          <div class="value">
		            <input type="text" size="83" name="genImage{$index}-name" id="genImage{$index}-name">
	                <xsl:attribute name="value"><xsl:value-of select="name"/></xsl:attribute>
	              </input>
		          </div>
		          <label class="field" for="genImage{$index}-toolTip"><xsl:value-of select="$bwStr-ModRes-FeTooltip"/></label>
		          <div class="value">
		            <input type="text" size="83" name="genImage{$index}-toolTip" id="genImage{$index}-toolTip">
	                <xsl:attribute name="value"><xsl:value-of select="toolTip"/></xsl:attribute>
	              </input>
		          </div>
		        </div>
	        </xsl:for-each>

	      </div>
	    </fieldset>
	  </div>
  </xsl:template>
</xsl:stylesheet>