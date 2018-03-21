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
<xsl:output
  method="html"
  indent="yes"
  media-type="text/html"
  doctype-public="-//W3C//DTD HTML 3.2 Final//EN"
  standalone="yes"
/>
  <!-- ================ -->
  <!--  PDA STYLESHEET -->
  <!-- ================  -->
  <!-- DEFINE GLOBAL CONSTANTS -->
  <!-- URL of html resources (images, css, other html); by default this is
       set to the application root, but for the personal calendar
       this should be changed to point to a
       web server over https to avoid mixed content errors, e.g.,
  <xsl:variable name="resourcesRoot" select="'https://mywebserver.edu/myresourcesdir'"/>
    -->
  <xsl:variable name="resourcesRoot" select="/ucalendar/browserResourceRoot"/>

  <!-- URL of the XSL template directory -->
  <!-- The approot is an appropriate place to put
       included stylesheets and xml fragments. These are generally
       referenced relatively (like errors.xsl and messages.xsl above);
       this variable is here for your convenience if you choose to
       reference it explicitly.  It is not used in this stylesheet, however,
       and can be safely removed if you so choose. -->
  <xsl:variable name="appRoot" select="/ucalendar/approot"/>

  <!-- URL of the web application - includes web context -->
  <xsl:variable name="urlPrefix" select="/ucalendar/urlprefix"/>

  <xsl:variable name="prevdate" select="/ucalendar/previousdate"/>
  <xsl:variable name="nextdate" select="/ucalendar/nextdate"/>
  <xsl:variable name="curdate" select="/ucalendar/currentdate"/>

  <!-- MAIN TEMPLATE -->
  <xsl:template match="/">
    <html lang="en">
      <head>
        <title>Bedework Calendar of Events</title>
      </head>
      <body>
        <xsl:call-template name="headBar"/>
        <!-- <xsl:call-template name="alerts"/> -->
        <xsl:choose>
          <xsl:when test="/ucalendar/page='event'">
            <!-- show an event -->
            <xsl:apply-templates select="/ucalendar/event"/>
          </xsl:when>
          <xsl:when test="/ucalendar/page='calendars'">
            <!-- show a list of all calendars -->
            <xsl:apply-templates select="/ucalendar/calendars"/>
          </xsl:when>
          <xsl:otherwise>
            <!-- otherwise, show the eventsCalendar -->
            <!-- main eventCalendar content -->
            <xsl:call-template name="listView"/>
          </xsl:otherwise>
        </xsl:choose>
        <!-- <xsl:if test="/ucalendar/periodname!='Year' and /ucalendar/periodname!='Day'">
          <p align="center">
            <xsl:call-template name="searchBar"/>
            <xsl:call-template name="navigation"/>
          </p>
        </xsl:if>-->
        <!-- footer -->
        <xsl:call-template name="footer"/>
      </body>
    </html>
  </xsl:template>

  <!--==== SINGLE EVENT ====-->
  <xsl:template match="event">
    <table id="eventTable" cellpadding="0" cellspacing="0">
      <tr>
        <th align="left" valign="top">Event:</th>
        <th align="left" valign="top">
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
        </th>
      </tr>
      <tr>
        <td valign="top">When:</td>
        <td valign="top">
          <!-- was using abbrev dayname: substring(start/dayname,1,3) -->
          <xsl:value-of select="start/dayname"/>, <xsl:value-of select="start/longdate"/><xsl:text> </xsl:text>
          <span class="time"><xsl:value-of select="start/time"/></span>
          <xsl:if test="end/time != '' or end/longdate != start/longdate"> - </xsl:if>
          <xsl:if test="end/longdate != start/longdate"><xsl:value-of select="substring(end/dayname,1,3)"/>, <xsl:value-of select="end/longdate"/><xsl:text> </xsl:text></xsl:if>
          <xsl:if test="end/time != ''"><span class="time"><xsl:value-of select="end/time"/></span></xsl:if>
        </td>
      </tr>
      <tr>
        <td valign="top">Where:</td>
        <td valign="top">
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
        <td valign="top">Desc:</td>
        <td valign="top">
          <xsl:value-of select="description"/>
        </td>
      </tr>
       <xsl:if test="cost!=''">
        <tr>
          <td valign="top">Cost:</td>
          <td colspan="2" valign="top"><xsl:value-of select="cost"/></td>
        </tr>
      </xsl:if>
      <xsl:if test="link != ''">
        <tr>
          <td valign="top">See:</td>
          <td valign="top">
            <xsl:variable name="link" select="link"/>
            <a href="{$link}"><xsl:value-of select="link"/></a>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="sponsor/name!='none'">
        <tr>
          <td valign="top">Contact:</td>
          <td valign="top">
            <xsl:choose>
              <xsl:when test="sponsor/link=''">
                <xsl:value-of select="sponsor/name"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:variable name="sponsorLink" select="sponsor/link"/>
                <a href="{$sponsorLink}">
                  <xsl:value-of select="sponsor/name"/>
                </a>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="sponsor/phone!=''">
              <br /><xsl:value-of select="sponsor/phone"/>
            </xsl:if>
          </td>
        </tr>
      </xsl:if>
    </table>
    <p align="center">
      <xsl:variable name="id" select="id"/>
      <xsl:variable name="icalName" select="concat($id,'.ics')"/>
      <b>
        <a href="{$urlPrefix}/eventView.do?eventId={$id}&amp;nocache=no&amp;skinName=ical&amp;contentType=text/calendar&amp;contentName={$icalName}" title="Download event as ical - for Outlook, PDAs, iCal, and other desktop calendars">
          Download this Event
        </a>
      </b>
    </p>
  </xsl:template>

  <!--==== LIST VIEW  (for day, week, and month) ====-->
  <xsl:template name="listView">
    <xsl:choose>
      <xsl:when test="count(/ucalendar/eventscalendar/year/month/week/day/event)=0">
        There are no events posted
        <xsl:choose>
          <xsl:when test="/ucalendar/periodname='Day'">
            today<xsl:if test="/ucalendar/title!=''"> for <strong><xsl:value-of select="/ucalendar/title"/></strong></xsl:if><xsl:if test="/ucalendar/search!=''"> for search term <strong>"<xsl:value-of select="/ucalendar/search"/>"</strong></xsl:if>.
          </xsl:when>
          <xsl:when test="/ucalendar/periodname='Month'">
            this month<xsl:if test="/ucalendar/title!=''"> for <strong><xsl:value-of select="/ucalendar/title"/></strong></xsl:if><xsl:if test="/ucalendar/search!=''"> for search term <strong>"<xsl:value-of select="/ucalendar/search"/>"</strong></xsl:if>.
          </xsl:when>
          <xsl:otherwise>
            this week<xsl:if test="/ucalendar/title!=''"> for <strong><xsl:value-of select="/ucalendar/title"/></strong></xsl:if><xsl:if test="/ucalendar/search!=''"> for search term <strong>"<xsl:value-of select="/ucalendar/search"/>"</strong></xsl:if>.
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="/ucalendar/eventscalendar/year/month/week/day[count(event)!=0]">
          <xsl:if test="/ucalendar/periodname='Week' or /ucalendar/periodname='Month' or /ucalendar/periodname=''">
            <h3>
              <xsl:variable name="date" select="date"/>
              <a href="{$urlPrefix}/setView.do?viewType=dayView&amp;date={$date}">
                <xsl:value-of select="name"/>, <xsl:value-of select="longdate"/>
              </a>
            </h3>
          </xsl:if>
          <xsl:for-each select="event">
            <xsl:variable name="id" select="id"/>
            <dl>
              <dt>
                <xsl:choose>
                  <xsl:when test="start/time!=''">
                    <a href="{$urlPrefix}/eventView.do?eventId={$id}">
                    <xsl:choose>
                      <xsl:when test="parent::day/shortdate != start/shortdate">
                        <span class="littleArrow">&#171;</span>&#160;
                        <xsl:value-of select="start/month"/>/<xsl:value-of select="start/day"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="start/time"/>
                      </xsl:otherwise>
                    </xsl:choose>
                    </a>
                  </xsl:when>
                  <xsl:otherwise>
                    <a href="{$urlPrefix}/eventView.do?eventId={$id}">
                      All day
                    </a>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:choose>
                  <xsl:when test="end/time!=''">
                    <a href="{$urlPrefix}/eventView.do?eventId={$id}">-</a>
                  </xsl:when>
                  <xsl:otherwise>
                    &#160;
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:choose>
                  <xsl:when  test="end/time!=''">
                    <a href="{$urlPrefix}/eventView.do?eventId={$id}">
                    <xsl:choose>
                      <xsl:when test="parent::day/shortdate != end/shortdate">
                        <xsl:value-of select="end/month"/>/<xsl:value-of select="end/day"/>
                        &#160;<span class="littleArrow">&#187;</span>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="end/time"/>
                      </xsl:otherwise>
                    </xsl:choose>
                    </a>
                  </xsl:when>
                  <xsl:otherwise>
                    &#160;
                  </xsl:otherwise>
                </xsl:choose>
              </dt>
              <dd>
                <xsl:choose>
                  <xsl:when test="/ucalendar/appvar[key='summaryMode']/value='details'">
                    <a href="{$urlPrefix}/eventView.do?eventId={$id}">
                      <strong><xsl:value-of select="summary"/>: </strong>
                      <xsl:value-of select="description"/>&#160;
                      <em>
                        <xsl:value-of select="location/address"/>
                        <xsl:if test="location/subaddress != ''">
                          , <xsl:value-of select="location/subaddress"/>
                        </xsl:if>.&#160;
                        <xsl:if test="cost!=''">
                          <xsl:value-of select="cost"/>.&#160;
                        </xsl:if>
                        <xsl:if test="sponsor/name!='none'">
                          Contact: <xsl:value-of select="sponsor/name"/>
                        </xsl:if>
                      </em>
                    </a>
                    <xsl:if test="link != ''">
                      <xsl:variable name="link" select="link"/>
                      <a href="{$link}" class="moreLink"><xsl:value-of select="link"/></a>
                    </xsl:if>
                  </xsl:when>
                  <xsl:otherwise>
                    <a href="{$urlPrefix}/eventView.do?eventId={$id}">
                      <xsl:value-of select="summary"/>, <xsl:value-of select="location/address"/>
                    </a>
                  </xsl:otherwise>
                </xsl:choose>
              </dd>
            </dl>
          </xsl:for-each>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--==== CALENDARS PAGE ====-->
  <xsl:template match="calendars">
    <xsl:variable name="topLevelCalCount" select="count(/ucalendar/calendars/calendar)"/>
    <p><b>All Calendars</b><br />
    Select a calendar from the list below to see only that calendar's events.</p>
    <xsl:apply-templates select="calendar"/>
  </xsl:template>

  <xsl:template match="calendar">
    <xsl:variable name="id" select="id"/>
    <h2><a href="{$urlPrefix}/selectCalendar.do?calId={$id}"><xsl:value-of select="title"/></a></h2>
    <ul>
      <xsl:for-each select="calendar">
        <xsl:sort select="title" order="ascending" case-order="upper-first"/>
        <xsl:variable name="id" select="id"/>
        <li><a href="{$urlPrefix}/selectCalendar.do?calId={$id}"><xsl:value-of select="title"/></a></li>
      </xsl:for-each>
    </ul>
  </xsl:template>

  <!--==== BLOCK (named) TEMPLATES and NAVIGATION  ====-->
  <!-- these templates are separated out for convenience and to simplify the default template -->

  <xsl:template name="headBar">
    <p align="center">
      <b>Bedework Events Calendar</b><br />
      <xsl:if test="/ucalendar/page!='calendars' and /ucalendar/page!='event'">
        <a href="{$urlPrefix}/setView.do?date={$prevdate}"><img src="{$resourcesRoot}/std-arrow-left.gif" alt="previous" width="13" height="16" class="prevImg" border="0"/></a>
        <xsl:text> </xsl:text>
        <xsl:choose>
          <xsl:when test="/ucalendar/periodname='Day'">
            <xsl:value-of select="substring(/ucalendar/eventscalendar/year/month/week/day/name,1,3)"/>, <xsl:value-of select="/ucalendar/eventscalendar/year/month/shortname"/>&#160;<xsl:value-of select="/ucalendar/eventscalendar/year/month/week/day/value"/>, <xsl:value-of select="/ucalendar/eventscalendar/year/value"/>
          </xsl:when>
          <xsl:when test="/ucalendar/periodname='Week' or /ucalendar/periodname=''">
            Week of <xsl:value-of select="/ucalendar/eventscalendar/year/month/shortname"/>&#160;<xsl:value-of select="/ucalendar/eventscalendar/year/month/week/day/value"/>, <xsl:value-of select="/ucalendar/eventscalendar/year/value"/>
          </xsl:when>
          <xsl:when test="/ucalendar/periodname='Month'">
            <xsl:value-of select="/ucalendar/eventscalendar/year/month/longname"/>, <xsl:value-of select="/ucalendar/eventscalendar/year/value"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="/ucalendar/eventscalendar/year/value"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:text> </xsl:text>
        <a href="{$urlPrefix}/setView.do?date={$nextdate}"><img src="{$resourcesRoot}/std-arrow-right.gif" alt="next" width="13" height="16" class="nextImg" border="0"/></a><br />
      </xsl:if>
      <xsl:choose>
        <xsl:when test="/ucalendar/page='eventscalendar'">
          <xsl:choose>
            <xsl:when test="/ucalendar/periodname='Day'">
              day
            </xsl:when>
            <xsl:otherwise>
              <a href="{$urlPrefix}/setView.do?viewType=dayView&amp;date={$curdate}">day</a>
            </xsl:otherwise>
          </xsl:choose> |
          <xsl:choose>
            <xsl:when test="/ucalendar/periodname='Week' or /ucalendar/periodname=''">
              week
             </xsl:when>
            <xsl:otherwise>
              <a href="{$urlPrefix}/setView.do?viewType=weekView&amp;date={$curdate}">week</a>
             </xsl:otherwise>
          </xsl:choose> |
          <xsl:choose>
            <xsl:when test="/ucalendar/periodname='Month'">
              month
            </xsl:when>
            <xsl:otherwise>
              <a href="{$urlPrefix}/setView.do?viewType=monthView&amp;date={$curdate}">month</a>
            </xsl:otherwise>
          </xsl:choose> |
        </xsl:when>
        <xsl:otherwise>
          <a href="{$urlPrefix}/setView.do?viewType=dayView&amp;date={$curdate}">day</a> |
          <a href="{$urlPrefix}/setView.do?viewType=weekView&amp;date={$curdate}">week</a> |
          <a href="{$urlPrefix}/setView.do?viewType=monthView&amp;date={$curdate}">month</a> |
        </xsl:otherwise>
      </xsl:choose>
      <a href="{$urlPrefix}/setView.do?viewType=todayView&amp;date={$curdate}">
        today
      </a><br />
      <xsl:choose>
         <xsl:when test="/ucalendar/title!=''">
           Calendar: <xsl:value-of select="/ucalendar/title"/><xsl:text> </xsl:text>
           [<a href="{$urlPrefix}/selectCalendar.do?calId=">clear</a>]
         </xsl:when>
         <xsl:when test="/ucalendar/search!=''">
           Current search: <xsl:value-of select="/ucalendar/search"/><xsl:text> </xsl:text>
           [<a href="{$urlPrefix}/selectCalendar.do?calId=">clear</a>]
         </xsl:when>
         <xsl:otherwise>
           Current calendar: All [<a href="{$urlPrefix}/showCals.do">select</a>]
         </xsl:otherwise>
      </xsl:choose>
    </p>
  </xsl:template>

  <xsl:template name="alerts">
    <table id="alertsTable">
      <tr>
        <td>
          I'm an alert
        </td>
      </tr>
    </table>
  </xsl:template>

  <!-- <xsl:template name="searchBar">
    <form name="calForm" method="post" action="{$urlPrefix}/selectCalendar.do">Search: <input type="text" name="searchString" size="30" value=""/><input type="submit" value="go"/></form>
  </xsl:template> -->

  <xsl:template name="dateSelect">
    <form name="calForm" method="post" action="{$urlPrefix}/setView.do">
      <table border="0" cellpadding="0" cellspacing="0">
        <tr>
          <xsl:if test="/ucalendar/periodname!='Year'">
            <td>
              <select name="viewStartDate.month">
                <xsl:for-each select="/ucalendar/monthvalues/val">
                  <xsl:variable name="temp" select="."/>
                  <xsl:variable name="pos" select="position()"/>
                  <xsl:choose>
                    <xsl:when test="/ucalendar/monthvalues[start=$temp]">
                      <option value="{$temp}" selected="selected">
                        <xsl:value-of select="/ucalendar/monthlabels/val[position()=$pos]"/>
                      </option>
                    </xsl:when>
                    <xsl:otherwise>
                      <option value="{$temp}">
                        <xsl:value-of select="/ucalendar/monthlabels/val[position()=$pos]"/>
                      </option>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:for-each>
              </select>
            </td>
            <xsl:if test="/ucalendar/periodname!='Month'">
              <td>
                <select name="viewStartDate.day">
                  <xsl:for-each select="/ucalendar/dayvalues/val">
                    <xsl:variable name="temp" select="."/>
                    <xsl:variable name="pos" select="position()"/>
                    <xsl:choose>
                      <xsl:when test="/ucalendar/dayvalues[start=$temp]">
                        <option value="{$temp}" selected="selected">
                          <xsl:value-of select="/ucalendar/daylabels/val[position()=$pos]"/>
                        </option>
                      </xsl:when>
                      <xsl:otherwise>
                        <option value="{$temp}">
                          <xsl:value-of select="/ucalendar/daylabels/val[position()=$pos]"/>
                        </option>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:for-each>
                </select>
              </td>
            </xsl:if>
          </xsl:if>
          <td>
            <xsl:variable name="temp" select="/ucalendar/yearvalues/start"/>
            <input type="text" name="viewStartDate.year" maxlength="4" size="4" value="{$temp}"/>
          </td>
          <td>
            <input name="submit" type="submit" value="go"/>
          </td>
        </tr>
      </table>
    </form>
  </xsl:template>

  <xsl:template name="footer">
    <p align="center">
	  <!-- use to point them back to a portable site, perhaps-->
      <a href="http://localhost:8080/ucal/">Return to your calendar</a><br />
    </p>
  </xsl:template>
</xsl:stylesheet>
