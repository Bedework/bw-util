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
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Date Selection Form -->
  <xsl:template name="datePicker">
    <xsl:variable name="datePickerDate">
      <xsl:choose>
        <xsl:when test="/bedework/appvar[key='navDate']/value != ''">
          <xsl:choose>
            <xsl:when test="contains(/bedework/appvar[key='navDate']/value,'-')"><xsl:value-of select="/bedework/appvar[key='navDate']/value"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="substring(/bedework/appvar[key='navDate']/value,0,5)"/><xsl:text>-</xsl:text><xsl:value-of select="substring(/bedework/appvar[key='navDate']/value,5,2)"/><xsl:text>-</xsl:text><xsl:value-of select="substring(/bedework/appvar[key='navDate']/value,7,2)"/></xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise><xsl:value-of select="substring(/bedework/currentdate/date,0,5)"/><xsl:text>-</xsl:text><xsl:value-of select="substring(/bedework/currentdate/date,5,2)"/><xsl:text>-</xsl:text><xsl:value-of select="substring(/bedework/currentdate/date,7,2)"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="todayDate"><xsl:value-of select="substring(/bedework/now/date,0,5)"/><xsl:text>-</xsl:text><xsl:value-of select="substring(/bedework/now/date,5,2)"/><xsl:text>-</xsl:text><xsl:value-of select="substring(/bedework/now/date,7,2)"/></xsl:variable>

    <div id="bwDatePicker">
      <form name="calForm" method="post">
        <xsl:attribute name="onsubmit">return changeStartDate(this,bwMainEventList);</xsl:attribute><!-- only matters when a user hits enter key -->
        <xsl:choose>
          <xsl:when test="/bedework/page = 'eventscalendar' or /bedework/appvar[key='listPage']/value='eventscalendar'">
            <xsl:attribute name="action"><xsl:value-of select="$setSelection"/></xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="action"><xsl:value-of select="$setSelectionList"/></xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>
        <ul id="bwDatePickerTodayLink">
          <li>
            <xsl:if test="($useAdvancedDateRangeMenu = 'true')">
              <xsl:attribute name="class">last</xsl:attribute>
            </xsl:if>
            <a href="{$setSelectionList}&amp;start={$todayDate}&amp;listMode=true&amp;setappvar=navDate({$todayDate})">
              <xsl:if test="/bedework/page = 'eventscalendar' or /bedework/appvar[key='listPage']/value='eventscalendar'">
                <xsl:attribute name="href"><xsl:value-of select="$setViewPeriod"/>&amp;viewType=todayView&amp;setappvar=navDate(<xsl:value-of select="$todayDate"/>)</xsl:attribute>
              </xsl:if>
              <xsl:copy-of select="$bwStr-DatePicker-Today"/>
            </a>
          </li>
          <xsl:if test="$useAdvancedDateRangeMenu = 'false'">
            <li class="last">
              <a href="{$setSelectionList}&amp;listMode=true&amp;setappvar=listPage(upcoming)" class="bwUpcomingLink">
                <xsl:copy-of select="$bwStr-DatePicker-Upcoming"/>
              </a>
            </li>
          </xsl:if>
        </ul>
        <label for="bwDatePickerInput"><xsl:value-of select="$bwStr-DatePicker-StartDate"/></label>
        <div class="bwInputs">
          <input type="text" id="bwDatePickerInput" name="start" class="form-control">
            <xsl:attribute name="value"><xsl:value-of select="$datePickerDate"/></xsl:attribute>
            <xsl:attribute name="onchange">return changeStartDate(this.form,bwMainEventList);</xsl:attribute>
            <xsl:if test="$useHTML5DatePicker = 'true'">
              <xsl:attribute name="type">date</xsl:attribute>
            </xsl:if>
          </input>
          <input type="hidden" name="setappvar" value="navDate({$datePickerDate})"/>
          <input type="submit" value="go" class="btn btn-default sr-only"/>
        </div>
        <xsl:if test="$useAdvancedDateRangeMenu = 'true'">
          <div id="bwDatePickerLinks">
            <!-- NOTE: all links below have onclick handlers applied.  See javascript/navigation.js -->
            <ul id="bwDatePickerRangeLinks">
              <li>
                <a href="{$setSelectionList}&amp;listMode=true&amp;setappvar=listPage(upcoming)" class="bwUpcomingLink">
                  <xsl:copy-of select="$bwStr-DatePicker-Upcoming"/>
                </a>
              </li>
              <li>
                <a href="{$setViewPeriod}&amp;viewType=dayView&amp;setappvar=listPage(eventscalendar)" class="bwRangeLink">
                  <xsl:if test="/bedework/periodname='Day' and /bedework/page = 'eventscalendar'">
                    <xsl:attribute name="class">current bwRangeLink</xsl:attribute>
                  </xsl:if>
                  <xsl:copy-of select="$bwStr-DatePicker-Day"/>
                </a>
              </li>
              <li>
                <a href="{$setViewPeriod}&amp;viewType=weekView&amp;setappvar=listPage(eventscalendar)" class="bwRangeLink">
                  <xsl:if test="/bedework/periodname='Week' and /bedework/page = 'eventscalendar'">
                    <xsl:attribute name="class">current bwRangeLink</xsl:attribute>
                  </xsl:if>
                  <xsl:copy-of select="$bwStr-DatePicker-Week"/>
                </a>
              </li>
              <li class="last">
                <a href="{$setViewPeriod}&amp;viewType=monthView&amp;setappvar=listPage(eventscalendar)" class="bwRangeLink">
                  <xsl:if test="/bedework/periodname='Month' and /bedework/page = 'eventscalendar'">
                    <xsl:attribute name="class">current bwRangeLink</xsl:attribute>
                  </xsl:if>
                  <xsl:copy-of select="$bwStr-DatePicker-Month"/>
                </a>
              </li>
            </ul>
          </div>
        </xsl:if>
      </form>
    </div>

    <script type="text/javascript">
       $.datepicker.setDefaults({
         constrainInput: true,
         dateFormat: "yy-mm-dd",
         gotoCurrent: true,
         duration: ""
       });
       $(document).ready(function() {
       <xsl:choose>
         <xsl:when test="$useHTML5DatePicker = 'true'">
           if (Modernizr.inputtypes['date']) {
             // use HTML5 picker if available
             $("#bwDatePickerInput").attr("value","<xsl:value-of select="$datePickerDate"/>");
           } else {
             // use jQuery datepicker otherwise
             $("#bwDatePickerInput").datepicker({
                changeMonth: true,
                changeYear: true,
                setDate: "<xsl:value-of select="$datePickerDate"/>"
             });
           }
         </xsl:when>
         <xsl:otherwise>
           $("#bwDatePickerInput").datepicker({
              changeMonth: true,
              changeYear: true,
              setDate: "<xsl:value-of select="$datePickerDate"/>"
           });
         </xsl:otherwise>
       </xsl:choose>
       });
      </script>
      <noscript><xsl:copy-of select="$bwStr-Error-NoScript"/></noscript>
  </xsl:template>

  <!-- THE FOLLOWING CAN BE USED IN LIEU OF A JAVASCRIPT WIDGET -->
  <!-- Be forewarned however: this will cause multiple request / responses -
       one request to set the date and reload the page, and another to go
       fetch the events via ajax. -->
  <!--
  <xsl:template name="dateSelectForm">
    <form name="calForm" method="post" action="{$setViewPeriod}">
      <xsl:if test="/bedework/periodname!='Year'">
        <select name="viewStartDate.month">
          <xsl:for-each select="/bedework/monthvalues/val">
            <xsl:variable name="temp" select="." />
            <xsl:variable name="pos" select="position()" />
            <xsl:choose>
              <xsl:when
                test="/bedework/monthvalues[start=$temp]">
                <option value="{$temp}"
                  selected="selected">
                  <xsl:value-of
                    select="/bedework/monthlabels/val[position()=$pos]" />
                </option>
              </xsl:when>
              <xsl:otherwise>
                <option value="{$temp}">
                  <xsl:value-of
                    select="/bedework/monthlabels/val[position()=$pos]" />
                </option>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </select>
        <xsl:if test="/bedework/periodname!='Month'">
          <select name="viewStartDate.day">
            <xsl:for-each
              select="/bedework/dayvalues/val">
              <xsl:variable name="temp" select="." />
              <xsl:variable name="pos"
                select="position()" />
              <xsl:choose>
                <xsl:when
                  test="/bedework/dayvalues[start=$temp]">
                  <option value="{$temp}"
                    selected="selected">
                    <xsl:value-of
                      select="/bedework/daylabels/val[position()=$pos]" />
                  </option>
                </xsl:when>
                <xsl:otherwise>
                  <option value="{$temp}">
                    <xsl:value-of
                      select="/bedework/daylabels/val[position()=$pos]" />
                  </option>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:for-each>
          </select>
        </xsl:if>
      </xsl:if>
      <xsl:variable name="temp" select="/bedework/yearvalues/start" />
      <input type="text" name="viewStartDate.year" maxlength="4" size="4" value="{$temp}" />
      <input name="submit" type="submit" value="go" />
    </form>
  </xsl:template>
-->
</xsl:stylesheet>
