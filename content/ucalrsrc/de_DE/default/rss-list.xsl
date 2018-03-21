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
  <xsl:output method="xml" omit-xml-declaration="no" indent="yes"
    media-type="text/xml" encoding="UTF-8" />

   <!-- =========================================================

                      BEDEWORK RSS FEED

     RSS for the Bedework events calendar.

     Call the feed with the listEvents action to return
     the discrete events in the next seven days (seven days is default):
     http://localhost:8080/cal/main/listEvents.do?setappvar=summaryMode(details)&skinName=rss-list

     _________________________________________________________
     Optional parameters that may be added to the query string:

     days=n    To return n days from today into the future add this to the paramater list: &days=5

     ===============================================================  -->

   <xsl:include href="strings.xsl"/>

   <xsl:template match="/">
     <rss version="2.0">
      <channel>
        <title>Bedework Events Calendar</title>
        <link><xsl:value-of select="/bedework/urlprefix"/></link>
        <description>
          <xsl:choose>
            <xsl:when test="/bedework/now/longdate = /bedework/events/event[position()=last()]/start/longdate"><xsl:value-of select="/bedework/now/longdate"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="/bedework/now/longdate"/> - <xsl:value-of select="/bedework/events/event[position()=last()]/start/longdate"/></xsl:otherwise>
          </xsl:choose>
        </description>
        <pubDate><!-- takes the form: 11 Jan 2008 17:00:00 UT (note - do not output dayname - we only provide dayname in local time).
          --><xsl:value-of select="substring(/bedework/now/utc,7,2)"/><xsl:text> </xsl:text><!--
          --><xsl:call-template name="monthNumToName"><xsl:with-param name="monthNum" select="substring(/bedework/now/utc,5,2)"/></xsl:call-template><xsl:text> </xsl:text><!--
          --><xsl:value-of select="substring(/bedework/now/utc,1,4)"/><xsl:text> </xsl:text><!--
          --><xsl:value-of select="substring(/bedework/now/utc,10,2)"/>:<xsl:value-of select="substring(/bedework/now/utc,12,2)"/>:00 UT</pubDate>
        <language>en-US</language>
        <copyright>Copyright <xsl:value-of select="substring(/bedework/now/utc,1,4)"/>, Bedework</copyright>
        <managingEditor>editor@mysite.edu (Editor Name)</managingEditor>
        <xsl:choose>
           <xsl:when test="/bedework/page='searchResult'">
             <xsl:apply-templates select="/bedework/searchResults/searchResult"/>
           </xsl:when>
           <xsl:otherwise>
             <xsl:apply-templates select="/bedework/events/event"/>
           </xsl:otherwise>
        </xsl:choose>
      </channel>
    </rss>
  </xsl:template>

  <xsl:template match="event">
    <item>
      <title><xsl:if test="status = 'CANCELLED'">CANCELED: </xsl:if><xsl:value-of select="summary"/> - <xsl:value-of select="substring(start/dayname,1,3)"/>, <xsl:value-of select="start/longdate"/></title>
      <link><xsl:value-of select="/bedework/urlprefix"/>/event/eventView.do?calPath=<xsl:value-of select="calendar/encodedPath"/>&amp;guid=<xsl:value-of select="guid"/>&amp;recurrenceId=<xsl:value-of select="recurrenceId"/></link>
      <guid><xsl:value-of select="/bedework/urlprefix"/>/event/eventView.do?calPath=<xsl:value-of select="calendar/encodedPath"/>&amp;guid=<xsl:value-of select="guid"/>&amp;recurrenceId=<xsl:value-of select="recurrenceId"/></guid>
      <pubDate><!-- takes the form: 11 Jan 2008 17:00:00 UT (note - do not output dayname - we only provide dayname in local time).
        --><xsl:value-of select="substring(start/utcdate,7,2)"/><xsl:text> </xsl:text><!--
        --><xsl:call-template name="monthNumToName"><xsl:with-param name="monthNum" select="substring(start/utcdate,5,2)"/></xsl:call-template><xsl:text> </xsl:text><!--
        --><xsl:value-of select="substring(start/utcdate,1,4)"/><xsl:text> </xsl:text><!--
        --><xsl:value-of select="substring(start/utcdate,10,2)"/>:<xsl:value-of select="substring(start/utcdate,12,2)"/>:00 UT</pubDate>
      <description>
        <xsl:value-of select="start/dayname" />,
        <xsl:value-of select="start/longdate" />
        <xsl:text> </xsl:text>
        <xsl:if test="start/allday = 'false'">
          <xsl:value-of select="start/time" />
        </xsl:if>
        <xsl:if
          test="(end/longdate != start/longdate) or
                ((end/longdate = start/longdate) and (end/time != start/time))">
          -
        </xsl:if>
        <xsl:if test="end/longdate != start/longdate">
          <xsl:value-of select="substring(end/dayname,1,3)" />
          ,
          <xsl:value-of select="end/longdate" />
          <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:choose>
          <xsl:when test="start/allday = 'true'">
            <xsl:copy-of select="$bwStr-SgEv-AllDay"/>
          </xsl:when>
          <xsl:when test="end/longdate != start/longdate">
            <xsl:value-of select="end/time" />
          </xsl:when>
          <xsl:when test="end/time != start/time">

              <xsl:value-of select="end/time" />

          </xsl:when>
        </xsl:choose>
        <!-- if timezones are not local, or if floating add labels: -->
        <xsl:if test="start/timezone/islocal = 'false' or end/timezone/islocal = 'false'">
          <xsl:text> </xsl:text>
          --
          <xsl:choose>
            <xsl:when test="start/floating = 'true'">
              <xsl:copy-of select="$bwStr-SgEv-FloatingTime"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:copy-of select="$bwStr-SgEv-LocalTime"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
        <!-- display in timezone if not local or floating time) -->
        <xsl:if test="(start/timezone/islocal = 'false' or end/timezone/islocal = 'false') and start/floating = 'false'">
          <xsl:choose>
            <xsl:when test="start/timezone/id != end/timezone/id">
              <!-- need to display both timezones if they differ from start to end -->
              <div class="tzdates">
                <xsl:copy-of select="$bwStr-SgEv-Start"/><xsl:text> </xsl:text>
                <xsl:choose>
                  <xsl:when test="start/timezone/islocal='true'">
                    <xsl:value-of select="start/dayname"/>,
                    <xsl:value-of select="start/longdate"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="start/time"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="start/timezone/dayname"/>,
                    <xsl:value-of select="start/timezone/longdate"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="start/timezone/time"/>
                  </xsl:otherwise>
                </xsl:choose>
                --
                <strong><xsl:value-of select="start/timezone/id"/></strong>
                <xsl:copy-of select="$bwStr-SgEv-End"/><xsl:text> </xsl:text>
                <xsl:choose>
                  <xsl:when test="end/timezone/islocal='true'">
                    <xsl:value-of select="end/dayname"/>,
                    <xsl:value-of select="end/longdate"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="end/time"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="end/timezone/dayname"/>,
                    <xsl:value-of select="end/timezone/longdate"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="end/timezone/time"/>
                  </xsl:otherwise>
                </xsl:choose>
                --
                <strong><xsl:value-of select="end/timezone/id"/></strong>
              </div>
            </xsl:when>
            <xsl:otherwise>
              <!-- otherwise, timezones are the same: display as a single line  -->
              <xsl:value-of select="start/timezone/dayname"/>, <xsl:value-of select="start/timezone/longdate"/><xsl:text> </xsl:text>
              <xsl:if test="start/allday = 'false'">
                <xsl:value-of select="start/timezone/time"/>
              </xsl:if>
              <xsl:if test="(end/timezone/longdate != start/timezone/longdate) or
                            ((end/timezone/longdate = start/timezone/longdate) and (end/timezone/time != start/timezone/time))"> - </xsl:if>
              <xsl:if test="end/timezone/longdate != start/timezone/longdate">
                <xsl:value-of select="substring(end/timezone/dayname,1,3)"/>, <xsl:value-of select="end/timezone/longdate"/><xsl:text> </xsl:text>
              </xsl:if>
              <xsl:choose>
                <xsl:when test="start/allday = 'true'">
                   <xsl:copy-of select="$bwStr-SgEv-AllDay"/>
                </xsl:when>
                <xsl:when test="end/timezone/longdate != start/timezone/longdate">
                  <xsl:value-of select="end/timezone/time"/>
                </xsl:when>
                <xsl:when test="end/timezone/time != start/timezone/time">
                  <xsl:value-of select="end/timezone/time"/>
                </xsl:when>
              </xsl:choose>
              <xsl:text> </xsl:text>
              --
              <strong><xsl:value-of select="start/timezone/id"/></strong>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>

        <![CDATA[
          <br/>
        ]]>

        <xsl:copy-of select="$bwStr-SgEv-Where"/><xsl:text> </xsl:text>
        <xsl:choose>
          <xsl:when test="location/link=''">
            <xsl:value-of select="location/address" />
            <xsl:text> </xsl:text>
            <xsl:if test="location/subaddress!=''">
              <xsl:text> </xsl:text>
              <xsl:value-of select="location/subaddress" />
            </xsl:if>
          </xsl:when>
          <xsl:otherwise>
            <a>
              <xsl:attribute name="href"><xsl:value-of select="location/link"/></xsl:attribute>
              <xsl:value-of select="location/address"/>
              <xsl:if test="location/subaddress!=''">
                <xsl:text> </xsl:text>
                <xsl:value-of select="location/subaddress" />
              </xsl:if>
            </a>
          </xsl:otherwise>
        </xsl:choose>

        <![CDATA[
          <br/>
        ]]>

        <xsl:if test="cost!=''">
          <xsl:copy-of select="$bwStr-SgEv-Cost"/><xsl:text> </xsl:text>
          <xsl:value-of select="cost" />
          <![CDATA[
            <br/>
          ]]>
        </xsl:if>

        <xsl:copy-of select="$bwStr-SgEv-Description"/><xsl:text> </xsl:text>
        <xsl:value-of select="description"/>

        <![CDATA[
          <br/>
        ]]>

        <xsl:if test="status !='' and status != 'CONFIRMED'">
          <xsl:copy-of select="$bwStr-SgEv-STATUS"/><xsl:text> </xsl:text>
          <xsl:value-of select="status" />
          <![CDATA[
            <br/>
          ]]>
        </xsl:if>

        <xsl:if test="contact/name!='None'">
          <xsl:copy-of select="$bwStr-SgEv-Contact"/><xsl:text> </xsl:text>
          <xsl:value-of select="contact/name" />
          <xsl:if test="contact/phone!=''">
            <xsl:text> </xsl:text>
            <xsl:value-of select="contact/phone" />
          </xsl:if>
          <![CDATA[
            <br/>
          ]]>
        </xsl:if>

        <xsl:if test="categories[1]/category">
          <xsl:copy-of select="$bwStr-SgEv-Categories"/><xsl:text> </xsl:text>
          <xsl:for-each select="categories/category">
            <xsl:value-of select="value"/><xsl:if test="position() != last()">, </xsl:if>
          </xsl:for-each>
          <![CDATA[
            <br/>
          ]]>
        </xsl:if>
      </description>
    </item>
  </xsl:template>

  <!-- convert 2-digit utc month numeric values to
       short month names as expected by RFC 822 -->
  <xsl:template name="monthNumToName">
    <xsl:param name="monthNum">00</xsl:param>
    <xsl:choose>
      <xsl:when test="$monthNum = '01'">Jan</xsl:when>
      <xsl:when test="$monthNum = '02'">Feb</xsl:when>
      <xsl:when test="$monthNum = '03'">Mar</xsl:when>
      <xsl:when test="$monthNum = '04'">Apr</xsl:when>
      <xsl:when test="$monthNum = '05'">May</xsl:when>
      <xsl:when test="$monthNum = '06'">Jun</xsl:when>
      <xsl:when test="$monthNum = '07'">Jul</xsl:when>
      <xsl:when test="$monthNum = '08'">Aug</xsl:when>
      <xsl:when test="$monthNum = '09'">Sep</xsl:when>
      <xsl:when test="$monthNum = '10'">Oct</xsl:when>
      <xsl:when test="$monthNum = '11'">Nov</xsl:when>
      <xsl:when test="$monthNum = '12'">Dec</xsl:when>
      <xsl:otherwise>badMonthNum</xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
