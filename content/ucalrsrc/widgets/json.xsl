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
  xmlns="http://www.w3.org/1999/xhtml">
  
  <xsl:template match="/">
	  <xsl:choose>
	    <xsl:when test="/bedework/page='attendeeWidget'">
	      <!-- generate json list of attendees after modifying the scheduling widget -->
	      {
	        "attendees" : [
  	        <xsl:apply-templates select="/bedework/attendees/attendee" mode="loadBwGrid">
	            <xsl:sort select="attendeeUri"/>
	          </xsl:apply-templates>
	        ]
	      }
	    </xsl:when>
	    <xsl:otherwise>
	      <!-- not found -->
	      {
	        "errors" : [ "404" ]
	      }
	    </xsl:otherwise>
	  </xsl:choose>
	</xsl:template>
  
  <!-- Transform the attendees into an array of json objects 
       for use in the BwGrid.  This is called on edit event and after each update to 
       the attendees using xml from the attendee widget.  -->
  <xsl:template match="attendee" mode="loadBwGrid">
    {
      "name" : "<xsl:value-of select="cn"/>",
      "uid" : "<xsl:value-of select="attendeeUri"/>",
      "role" : "<xsl:value-of select="role"/>",
      "status" : "<xsl:value-of select="partstat"/>",
      "type" : "<xsl:value-of select="cuType"/>"
    }<xsl:if test="position()!=last()">,</xsl:if>
  </xsl:template>
  
</xsl:stylesheet>