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
 <xsl:template match="event">
   <xsl:variable name="calPath" select="calendar/encodedPath"/>
   <xsl:variable name="guid" select="guid"/>
   <xsl:variable name="recurrenceId" select="recurrenceId"/>
   <xsl:variable name="statusClass">
     <xsl:choose>
       <xsl:when test="status='CANCELLED'">bwStatusCancelled</xsl:when>
       <xsl:when test="status='TENTATIVE'">bwStatusTentative</xsl:when>
       <xsl:otherwise>bwStatusConfirmed</xsl:otherwise>
     </xsl:choose>
   </xsl:variable>
   <h2 class="{$statusClass}">
     <a id="linkToEvent" href="javascript:showLink('{$bwCacheHostUrl}/v1.0/event/list-html/{$recurrenceId}/{$guid}')" title="{$bwStr-SgEv-GenerateLinkToThisEvent}">
      <xsl:copy-of select="$bwStr-SgEv-LinkToThisEvent"/>
    </a>
     <xsl:if test="status='CANCELLED'"><xsl:copy-of select="$bwStr-SgEv-Canceled"/><xsl:text> </xsl:text></xsl:if>
     <xsl:choose>
       <xsl:when test="link != ''">
         <xsl:variable name="link" select="link"/>
         <a href="{$link}">
           <xsl:value-of select="summary"/>
         </a>
       </xsl:when>
       <xsl:otherwise>
         <xsl:value-of select="summary"/>
       </xsl:otherwise>
     </xsl:choose>
   </h2>
   <table id="eventTable" cellpadding="0" cellspacing="0">
     <tr>
       <td class="fieldname"><xsl:copy-of select="$bwStr-SgEv-When"/></td>
       <td class="fieldval">
         <!-- always display local time -->
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
             <span class="time"><em><xsl:copy-of select="$bwStr-SgEv-AllDay"/></em></span>
           </xsl:when>
           <xsl:when test="end/longdate != start/longdate">
             <span class="time"><xsl:value-of select="end/time"/></span>
           </xsl:when>
           <xsl:when test="end/time != start/time">
             <span class="time"><xsl:value-of select="end/time"/></span>
           </xsl:when>
         </xsl:choose>
         <!-- if timezones are not local, or if floating add labels: -->
         <xsl:if test="start/timezone/islocal = 'false' or end/timezone/islocal = 'false'">
           <xsl:text> </xsl:text>
           --
           <strong>
             <xsl:choose>
               <xsl:when test="start/floating = 'true'">
                 <xsl:copy-of select="$bwStr-SgEv-FloatingTime"/>
               </xsl:when>
               <xsl:otherwise>
                 <xsl:copy-of select="$bwStr-SgEv-LocalTime"/>
               </xsl:otherwise>
             </xsl:choose>
           </strong>
           <br/>
         </xsl:if>
         <!-- display in timezone if not local or floating time) -->
         <xsl:if test="(start/timezone/islocal = 'false' or end/timezone/islocal = 'false') and start/floating = 'false'">
           <xsl:choose>
             <xsl:when test="start/timezone/id != end/timezone/id">
               <!-- need to display both timezones if they differ from start to end -->
               <table border="0" cellspacing="0" id="tztable">
                 <tr>
                   <td>
                     <strong><xsl:copy-of select="$bwStr-SgEv-Start"/></strong>
                   </td>
                   <td>
                     <xsl:choose>
                       <xsl:when test="start/timezone/islocal='true'">
                         <xsl:value-of select="start/dayname"/>,
                         <xsl:value-of select="start/longdate"/>
                         <xsl:text> </xsl:text>
                         <span class="time"><xsl:value-of select="start/time"/></span>
                       </xsl:when>
                       <xsl:otherwise>
                         <xsl:value-of select="start/timezone/dayname"/>,
                         <xsl:value-of select="start/timezone/longdate"/>
                         <xsl:text> </xsl:text>
                         <span class="time"><xsl:value-of select="start/timezone/time"/></span>
                       </xsl:otherwise>
                     </xsl:choose>
                   </td>
                   <td>
                     --
                     <strong><xsl:value-of select="start/timezone/id"/></strong>
                   </td>
                 </tr>
                 <tr>
                   <td>
                     <strong><xsl:copy-of select="$bwStr-SgEv-End"/></strong>
                   </td>
                   <td>
                     <xsl:choose>
                       <xsl:when test="end/timezone/islocal='true'">
                         <xsl:value-of select="end/dayname"/>,
                         <xsl:value-of select="end/longdate"/>
                         <xsl:text> </xsl:text>
                         <span class="time"><xsl:value-of select="end/time"/></span>
                       </xsl:when>
                       <xsl:otherwise>
                         <xsl:value-of select="end/timezone/dayname"/>,
                         <xsl:value-of select="end/timezone/longdate"/>
                         <xsl:text> </xsl:text>
                         <span class="time"><xsl:value-of select="end/timezone/time"/></span>
                       </xsl:otherwise>
                     </xsl:choose>
                   </td>
                   <td>
                     --
                     <strong><xsl:value-of select="end/timezone/id"/></strong>
                   </td>
                 </tr>
               </table>
             </xsl:when>
             <xsl:otherwise>
               <!-- otherwise, timezones are the same: display as a single line  -->
               <xsl:value-of select="start/timezone/dayname"/>, <xsl:value-of select="start/timezone/longdate"/><xsl:text> </xsl:text>
               <xsl:if test="start/allday = 'false'">
                 <span class="time"><xsl:value-of select="start/timezone/time"/></span>
               </xsl:if>
               <xsl:if test="(end/timezone/longdate != start/timezone/longdate) or
                             ((end/timezone/longdate = start/timezone/longdate) and (end/timezone/time != start/timezone/time))"> - </xsl:if>
               <xsl:if test="end/timezone/longdate != start/timezone/longdate">
                 <xsl:value-of select="substring(end/timezone/dayname,1,3)"/>, <xsl:value-of select="end/timezone/longdate"/><xsl:text> </xsl:text>
               </xsl:if>
               <xsl:choose>
                 <xsl:when test="start/allday = 'true'">
                   <span class="time"><em> <xsl:copy-of select="$bwStr-SgEv-AllDay"/></em></span>
                 </xsl:when>
                 <xsl:when test="end/timezone/longdate != start/timezone/longdate">
                   <span class="time"><xsl:value-of select="end/timezone/time"/></span>
                 </xsl:when>
                 <xsl:when test="end/timezone/time != start/timezone/time">
                   <span class="time"><xsl:value-of select="end/timezone/time"/></span>
                 </xsl:when>
               </xsl:choose>
               <xsl:text> </xsl:text>
               --
               <strong><xsl:value-of select="start/timezone/id"/></strong>
             </xsl:otherwise>
           </xsl:choose>
         </xsl:if>
       </td>
       <th class="icalIcon" rowspan="2">
         <div id="eventIcons">
           <a href="{$privateCal}/event/addEventRef.do?calPath={$calPath}&amp;guid={$guid}&amp;recurrenceId={$recurrenceId}" title="{$bwStr-SgEv-AddEventToMyCalendar}" target="myCalendar">
             <img class="addref" src="{$resourcesRoot}/images/add2mycal-icon.gif" width="20" height="26" border="0" alt="Add event to MyCalendar"/>
             <xsl:copy-of select="$bwStr-SgEv-AddToMyCalendar"/>
           </a>
           <xsl:variable name="eventIcalName" select="concat($guid,'.ics')"/>
           <a href="{$bwCacheHostUrl}/v1.0/download/{$recurrenceId}/{$guid}/{$eventIcalName}" title="{$bwStr-SgEv-DownloadEvent}">
             <img src="{$resourcesRoot}/images/std-ical_icon.gif" width="20" height="26" border="0" alt="Download this event"/>
             <xsl:copy-of select="$bwStr-SgEv-Download"/>
           </a>
         </div>
       </th>
     </tr>
     <tr>
       <td class="fieldname"><xsl:copy-of select="$bwStr-SgEv-Where"/></td>
       <td class="fieldval">
         <xsl:choose>
           <xsl:when test="location/link=''">
             <xsl:value-of select="location/address"/>
           </xsl:when>
           <xsl:otherwise>
             <xsl:variable name="locationLink" select="location/link"/>
             <a href="{$locationLink}">
               <xsl:value-of select="location/address"/>
             </a>
           </xsl:otherwise>
         </xsl:choose>
         <xsl:if test="location/subaddress!=''">
           <br/><xsl:value-of select="location/subaddress"/>
         </xsl:if>
       </td>
     </tr>
     <tr>
       <td class="fieldname"><xsl:copy-of select="$bwStr-SgEv-Description"/></td>
       <td colspan="2" class="fieldval description">
         <xsl:if test="xproperties/node()[name()='X-BEDEWORK-IMAGE']">
           <xsl:variable name="bwImage"><xsl:value-of select="xproperties/node()[name()='X-BEDEWORK-IMAGE']/values/text"/></xsl:variable>
           <img src="{$bwImage}" class="bwEventImage"/>
         </xsl:if>
         <xsl:call-template name="replace">
           <xsl:with-param name="string" select="description"/>
           <xsl:with-param name="pattern" select="'&#xA;'"/>
           <xsl:with-param name="replacement"><br/></xsl:with-param>
         </xsl:call-template>
       </td>
     </tr>
     <xsl:if test="status !='' and status != 'CONFIRMED'">
       <tr>
         <td class="fieldname"><xsl:copy-of select="$bwStr-SgEv-STATUS"/></td>
         <td class="fieldval">
           <xsl:value-of select="status"/>
         </td>
       </tr>
     </xsl:if>
     <xsl:if test="cost!=''">
       <tr>
         <td class="fieldname"><xsl:copy-of select="$bwStr-SgEv-Cost"/></td>
         <td colspan="2" class="fieldval"><xsl:value-of select="cost"/></td>
       </tr>
     </xsl:if>
     <xsl:if test="link != ''">
       <tr>
         <td class="fieldname"><xsl:copy-of select="$bwStr-SgEv-See"/></td>
         <td colspan="2" class="fieldval">
           <xsl:variable name="link" select="link"/>
           <a href="{$link}"><xsl:value-of select="link"/></a>
         </td>
       </tr>
     </xsl:if>
     <xsl:if test="contact/name!='none'">
       <tr>
         <td class="fieldname"><xsl:copy-of select="$bwStr-SgEv-Contact"/></td>
         <td colspan="2" class="fieldval">
           <xsl:choose>
             <xsl:when test="contact/link=''">
               <xsl:value-of select="contact/name"/>
             </xsl:when>
             <xsl:otherwise>
               <xsl:variable name="sponsorLink" select="contact/link"/>
               <a href="{$sponsorLink}">
                 <xsl:value-of select="contact/name"/>
               </a>
             </xsl:otherwise>
           </xsl:choose>
           <xsl:if test="contact/phone!=''">
             <br /><xsl:value-of select="contact/phone"/>
           </xsl:if>
           <!-- If you want to display email addresses, uncomment the
                following 8 lines. -->
           <!-- <xsl:if test="contact/email!=''">
             <br />
             <xsl:variable name="email" select="contact/email"/>
             <xsl:variable name="subject" select="summary"/>
             <a href="mailto:{$email}&amp;subject={$subject}">
               <xsl:value-of select="contact/email"/>
             </a>
           </xsl:if> -->
         </td>
       </tr>
     </xsl:if>
     <xsl:if test="comments/comment">
       <tr>
         <td class="fieldname"><xsl:copy-of select="$bwStr-SgEv-Comments"/></td>
         <td class="fieldval comments">
           <xsl:for-each select="comments/comment">
             <p><xsl:value-of select="value"/></p>
           </xsl:for-each>
         </td>
       </tr>
     </xsl:if>
     <xsl:if test="xproperties/X-BEDEWORK-ALIAS">
       <tr>
         <td class="fieldname"><xsl:copy-of select="$bwStr-SgEv-TopicalArea"/></td>
         <td class="fieldval">
           <xsl:for-each select="xproperties/X-BEDEWORK-ALIAS">
             <xsl:variable name="calUrl" select="values/text"/>
               <xsl:call-template name="substring-afterLastInstanceOf">
                 <xsl:with-param name="string" select="values/text"/>
                 <xsl:with-param name="char">/</xsl:with-param>
               </xsl:call-template>
             <xsl:if test="position()!=last()">, </xsl:if>
           </xsl:for-each>
         </td>
       </tr>
     </xsl:if>
     <xsl:if test="categories/category">
       <tr>
         <td class="fieldname"><xsl:copy-of select="$bwStr-SgEv-Categories"/></td>
         <td class="fieldval">
           <xsl:for-each select="categories/category">
             <xsl:value-of select="value"/><xsl:if test="position() != last()">, </xsl:if>
           </xsl:for-each>
         </td>
       </tr>
     </xsl:if>
     <!--  xsl:if test="calendar/path!=''">
       <tr>
         <td class="fieldname">Calendar:</td>
         <td class="fieldval">
           <xsl:variable name="calUrl" select="calendar/encodedPath"/>
           <a href="{$setSelection}&amp;calUrl={$calUrl}">
             <xsl:value-of select="calendar/summary"/>
           </a>
         </td>
       </tr>
     </xsl:if-->
   </table>
 </xsl:template>
</xsl:stylesheet>