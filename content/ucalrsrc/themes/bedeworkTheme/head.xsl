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

  <!--==== HEAD SECTION  ====-->
  <xsl:template name="head">
    <title><xsl:copy-of select="$bwStr-Head-PageTitle"/></title>
    <meta name="robots" content="noindex,nofollow"/>
    <meta content="text/html;charset=utf-8" http-equiv="Content-Type" />
    <link rel="stylesheet" href="{$resourcesRoot}/css/bedeworkTheme.css"/>
    <link rel="stylesheet" type="text/css" media="print" href="{$resourcesRoot}/css/print.css" />
    <link rel="icon" type="image/ico" href="{$resourcesRoot}/images/bedework.ico" />

    <!-- set globals that must be passed in from the XSLT -->
    <script type="text/javascript">
      <xsl:comment>
      var defaultTzid = '<xsl:value-of select="/bedework/now/defaultTzid"/>';
      var startTzid = "<xsl:value-of select="/bedework/formElements/form/start/tzid"/>";
      var endTzid = "<xsl:value-of select="/bedework/formElements/form/end/dateTime/tzid"/>";
      var resourcesRoot = "<xsl:value-of select="$resourcesRoot"/>";
      var imagesRoot = resourcesRoot + "/images";
      var hour24 = <xsl:value-of select="/bedework/hour24"/>;
      var preferredEndType = '<xsl:value-of select="/bedework/preferredEndType"/>';
      if (preferredEndType === "") {
        preferredEndType = "duration";
      }
      var currentLocale = "<xsl:value-of select="/bedework/currentLocale"/>";
      var reqUid = "<xsl:value-of select="/bedework/vpoll/uid"/>";
      var reqTab = "<xsl:value-of select="/bedework/vpoll/tab"/>";
      var defaultCalendarPath = "<xsl:value-of select="/bedework/vpoll/defaultCalendarPath"/>";

      </xsl:comment>
    </script>

    <!-- note: the non-breaking spaces in the script bodies below are to avoid
         losing the script closing tags (which avoids browser problems) -->
    <xsl:choose>
      <xsl:when test="/bedework/page='managePolls'">
        <script src="/approots/bedework-common/javascript/jquery/jquery-1.11.1.min.js">&#160;</script>
        <script src="/approots/bedework-common/javascript/jquery/jquery-ui-1.11.0.min.js">&#160;</script>
        <link rel="stylesheet" href="/approots/bedework-common/javascript/jquery/css/jquery-ui-1.11.0/jquery-ui.min.css"/>
        <script src="/approots/bedework-common/javascript/jquery/spin.min.js">&#160;</script>
        <link href="/approots/bedework-common/javascript/jquery/magnific/magnific-popup.css" rel="stylesheet"/>
        <script src="/approots/bedework-common/javascript/jquery/magnific/jquery.magnific-popup.min.js">&#160;</script>
        <link href="{$resourcesRoot}/poll/css/webpoll.css" rel="stylesheet"/>
        <script src="{$resourcesRoot}/poll/js/json2.js">&#160;</script>
        <script src="{$resourcesRoot}/poll/js/jsonTz.js">&#160;</script>
        <script src="{$resourcesRoot}/poll/js/utils.js">&#160;</script>
        <script src="{$resourcesRoot}/poll/js/bwutils.js">&#160;</script>
        <script src="{$resourcesRoot}/poll/js/jcal.js">&#160;</script>
        <script src="{$resourcesRoot}/poll/js/jcalDtTime.js">&#160;</script>
        <script src="{$resourcesRoot}/poll/js/calComp.js">&#160;</script>
        <script src="{$resourcesRoot}/poll/js/caldav.js">&#160;</script>
        <script src="{$resourcesRoot}/poll/js/webpoll.js">&#160;</script>
        <script src="{$resourcesRoot}/poll/js/poll.js">&#160;</script>
        <script src="{$resourcesRoot}/poll/js/moment-with-locales.2.8.1.js">&#160;</script>
        <script src="{$resourcesRoot}/poll/js/moment-tzdist.js">&#160;</script>
        <!--<script src="{$resourcesRoot}/poll/js/moment-timezone-with-data.js">&#160;</script>-->

        <!-- include the localized jQuery datepicker defaults -->
        <xsl:call-template name="jqueryDatepickerDefaults"/>
        <!-- now setup date and time pickers -->
        <script type="text/javascript">
          <xsl:comment>
          function bwSetupDatePickers() {
            var dateValString = "<xsl:value-of select="substring(/bedework/now/date,1,4)"/>-<xsl:value-of select="substring(/bedework/now/date,5,2)"/>-<xsl:value-of select="substring(/bedework/now/date,7,2)"/>";

            // startdate
            $("#bwEventWidgetStartDate").datepicker();
            $("#bwEventWidgetStartDate").val(dateValString);

            // starttime
            $("#bwStartClock").bwTimePicker({
              hour24: <xsl:value-of select="/bedework/hour24"/>,
              attachToId: "calWidgetStartTimeHider",
              hourIds: ["eventStartDateHour","eventStartDateSchedHour"],
              minuteIds: ["eventStartDateMinute","eventStartDateSchedMinute"],
              ampmIds: ["eventStartDateAmpm","eventStartDateSchedAmpm"],
              hourLabel: "<xsl:value-of select="$bwStr-Cloc-Hour"/>",
              minuteLabel: "<xsl:value-of select="$bwStr-Cloc-Minute"/>",
              amLabel: "<xsl:value-of select="$bwStr-Cloc-AM"/>",
              pmLabel: "<xsl:value-of select="$bwStr-Cloc-PM"/>"
            });

            // enddate
            $("#bwEventWidgetEndDate").datepicker();
            $("#bwEventWidgetEndDate").val(dateValString);

            // endtime
            $("#bwEndClock").bwTimePicker({
              hour24: <xsl:value-of select="/bedework/hour24"/>,
              attachToId: "calWidgetEndTimeHider",
              hourIds: ["eventEndDateHour"],
              minuteIds: ["eventEndDateMinute"],
              ampmIds: ["eventEndDateAmpm"],
              hourLabel: "<xsl:value-of select="$bwStr-Cloc-Hour"/>",
              minuteLabel: "<xsl:value-of select="$bwStr-Cloc-Minute"/>",
              amLabel: "<xsl:value-of select="$bwStr-Cloc-AM"/>",
              pmLabel: "<xsl:value-of select="$bwStr-Cloc-PM"/>"
            });

            // recurrence until
            $("#bwEventWidgetUntilDate").datepicker({
              altField: "#bwEventUntilDate",
              altFormat: "yymmdd"
            });
            $("#bwEventWidgetUntilDate").val(dateValString);

          }
          </xsl:comment>
        </script>
      </xsl:when>
      <xsl:otherwise>
        <script src="/approots/bedework-common/javascript/jquery/jquery-1.4.2.min.js">&#160;</script>
        <script src="/approots/bedework-common/javascript/jquery/jquery-ui-1.8.2.custom.min.js">&#160;</script>
        <link rel="stylesheet" href="/approots/bedework-common/javascript/jquery/css/bw-theme-3p7/jquery-ui-1.8.2.custom.css"/>
        <link rel="stylesheet" href="/approots/bedework-common/javascript/jquery/css/bw-theme-3p7/bedeworkJquery.css"/>
      </xsl:otherwise>
    </xsl:choose>

    <!-- load bedework personal client javascript libraries -->
    <script src="{$resourcesRoot}/javascript/bedework.js">&#160;</script>
    <script src="{$resourcesRoot}/javascript/bedeworkSetup.js">&#160;</script>

    <xsl:if test="/bedework/page='modSchedulingPrefs' or
                  /bedework/page='modPrefs' or
                  /bedework/page='attendeeRespond'">
      <script src="{$resourcesRoot}/javascript/bedeworkPrefs.js">&#160;</script>
    </xsl:if>

    <xsl:if test="/bedework/page='modCalendar' or
                  /bedework/page='modSchedulingPrefs'">
      <link rel="stylesheet" href="/approots/bedework-common/default/default/bedeworkAccess.css"/>
      <script src="/approots/bedework-common/javascript/bedework/bedeworkAccess.js">&#160;</script>
      <xsl:call-template name="bedeworkAccessStrings"/>
      <!-- initialize calendar acls, if present -->
      <xsl:if test="/bedework/currentCalendar/acl/ace">
        <script type="text/javascript">
          <xsl:apply-templates select="/bedework/currentCalendar/acl/ace" mode="initJS"/>
        </script>
      </xsl:if>
    </xsl:if>

    <xsl:if test="/bedework/page='modCalendar' or
                  /bedework/page='addCalendar'">
      <link rel="stylesheet" href="/approots/bedework-common/javascript/jquery/colorpicker/colorpicker.css"/>
      <script src="/approots/bedework-common/javascript/jquery/colorpicker/colorpicker.js">&#160;</script>
    </xsl:if>

    <xsl:if test="/bedework/page='attendees'">
      <!--  Note: this page is deprecated, but is still maintained for testing.
            The following files are included in the add/edit event pages now as well. -->
      <script src="/approots/bedework-common/javascript/jquery/autocomplete/bw-jquery.autocomplete.js">&#160;</script>
      <script src="/approots/bedework-common/javascript/jquery/autocomplete/jquery.bgiframe.min.js">&#160;</script>
      <script src="{$resourcesRoot}/javascript/bedeworkAttendees.js">&#160;</script>
      <link rel="stylesheet" type="text/css" href="/approots/bedework-common/javascript/jquery/autocomplete/jquery.autocomplete.css" />
    </xsl:if>

    <xsl:if test="/bedework/page='addEvent' or
                  /bedework/page='editEvent' or
                  /bedework/page='rdates' or
                  /bedework/page='calendarListForExport'">

      <xsl:choose>
        <xsl:when test="$portalFriendly = 'true'">
          <script src="{$resourcesRoot}/javascript/dynCalendarWidget.js">&#160;</script>
          <link rel="stylesheet" href="{$resourcesRoot}/css/dynCalendarWidget.css"/>
        </xsl:when>
        <xsl:otherwise>

          <!-- include the localized jQuery datepicker defaults -->
          <xsl:call-template name="jqueryDatepickerDefaults"/>

          <!-- now setup date and time pickers -->
          <script type="text/javascript">
            <xsl:comment>
            function bwSetupDatePickers() {
              // startdate
              $("#bwEventWidgetStartDate").datepicker({
                defaultDate: new Date(<xsl:value-of select="/bedework/formElements/form/start/yearText/input/@value"/>, <xsl:value-of select="number(/bedework/formElements/form/start/month/select/option[@selected = 'selected']/@value) - 1"/>, <xsl:value-of select="/bedework/formElements/form/start/day/select/option[@selected = 'selected']/@value"/>)
              });
              $("#bwEventWidgetStartDate").val('<xsl:value-of select="substring-before(/bedework/formElements/form/start/rfc3339DateTime,'T')"/>');

              // starttime
              $("#bwStartClock").bwTimePicker({
                hour24: <xsl:value-of select="/bedework/hour24"/>,
                attachToId: "calWidgetStartTimeHider",
                hourIds: ["eventStartDateHour","eventStartDateSchedHour"],
                minuteIds: ["eventStartDateMinute","eventStartDateSchedMinute"],
                ampmIds: ["eventStartDateAmpm","eventStartDateSchedAmpm"],
                hourLabel: "<xsl:value-of select="$bwStr-Cloc-Hour"/>",
                minuteLabel: "<xsl:value-of select="$bwStr-Cloc-Minute"/>",
					      amLabel: "<xsl:value-of select="$bwStr-Cloc-AM"/>",
					      pmLabel: "<xsl:value-of select="$bwStr-Cloc-PM"/>"
              });

              // enddate
              $("#bwEventWidgetEndDate").datepicker({
                defaultDate: new Date(<xsl:value-of select="/bedework/formElements/form/end/dateTime/yearText/input/@value"/>, <xsl:value-of select="number(/bedework/formElements/form/end/dateTime/month/select/option[@selected = 'selected']/@value) - 1"/>, <xsl:value-of select="/bedework/formElements/form/end/dateTime/day/select/option[@selected = 'selected']/@value"/>)
              });
              $("#bwEventWidgetEndDate").val('<xsl:value-of select="substring-before(/bedework/formElements/form/end/rfc3339DateTime,'T')"/>');

              // endtime
              $("#bwEndClock").bwTimePicker({
                hour24: <xsl:value-of select="/bedework/hour24"/>,
                attachToId: "calWidgetEndTimeHider",
                hourIds: ["eventEndDateHour"],
                minuteIds: ["eventEndDateMinute"],
                ampmIds: ["eventEndDateAmpm"],
                hourLabel: "<xsl:value-of select="$bwStr-Cloc-Hour"/>",
                minuteLabel: "<xsl:value-of select="$bwStr-Cloc-Minute"/>",
                amLabel: "<xsl:value-of select="$bwStr-Cloc-AM"/>",
                pmLabel: "<xsl:value-of select="$bwStr-Cloc-PM"/>"
              });

              // recurrence until
              $("#bwEventWidgetUntilDate").datepicker({
                <xsl:choose>
                  <xsl:when test="/bedework/formElements/form/recurrence/until">
                    defaultDate: new Date(<xsl:value-of select="substring(/bedework/formElements/form/recurrence/until,1,4)"/>, <xsl:value-of select="number(substring(/bedework/formElements/form/recurrence/until,5,2)) - 1"/>, <xsl:value-of select="substring(/bedework/formElements/form/recurrence/until,7,2)"/>),
                  </xsl:when>
                  <xsl:otherwise>
                    defaultDate: new Date(<xsl:value-of select="/bedework/formElements/form/start/yearText/input/@value"/>, <xsl:value-of select="number(/bedework/formElements/form/start/month/select/option[@selected = 'selected']/@value) - 1"/>, <xsl:value-of select="/bedework/formElements/form/start/day/select/option[@selected = 'selected']/@value"/>),
                  </xsl:otherwise>
                </xsl:choose>
                altField: "#bwEventUntilDate",
                altFormat: "yymmdd"
              });
              $("#bwEventWidgetUntilDate").val('<xsl:value-of select="substring-before(/bedework/formElements/form/start/rfc3339DateTime,'T')"/>');

              // rdates and xdates date picker
              $("#bwEventWidgetRdate").datepicker({
                defaultDate: new Date(<xsl:value-of select="/bedework/formElements/form/start/yearText/input/@value"/>, <xsl:value-of select="number(/bedework/formElements/form/start/month/select/option[@selected = 'selected']/@value) - 1"/>, <xsl:value-of select="/bedework/formElements/form/start/day/select/option[@selected = 'selected']/@value"/>),
                dateFormat: "yymmdd"
              });
              $("#bwEventWidgetRdate").val('<xsl:value-of select="substring(/bedework/formElements/form/start/rfc3339DateTime,1,4)"/><xsl:value-of select="substring(/bedework/formElements/form/start/rfc3339DateTime,6,2)"/><xsl:value-of select="substring(/bedework/formElements/form/start/rfc3339DateTime,9,2)"/>');

              // rdates and xdates times
              $("#bwRecExcClock").bwTimePicker({
                hour24: true,
                withPadding: true,
                attachToId: "rdateTimeFields",
                hourIds: ["eventRdateHour"],
                minuteIds: ["eventRdateMinute"],
                hourLabel: "<xsl:value-of select="$bwStr-Cloc-Hour"/>",
                minuteLabel: "<xsl:value-of select="$bwStr-Cloc-Minute"/>",
                amLabel: "<xsl:value-of select="$bwStr-Cloc-AM"/>",
                pmLabel: "<xsl:value-of select="$bwStr-Cloc-PM"/>"
              });

              // meeting startdate widget
              $("#bwEventWidgetStartDateSched").datepicker({
                defaultDate: new Date(<xsl:value-of select="/bedework/formElements/form/start/yearText/input/@value"/>, <xsl:value-of select="number(/bedework/formElements/form/start/month/select/option[@selected = 'selected']/@value) - 1"/>, <xsl:value-of select="/bedework/formElements/form/start/day/select/option[@selected = 'selected']/@value"/>)
              }).attr("readonly", "readonly");
              $("#bwEventWidgetStartDateSched").val('<xsl:value-of select="substring-before(/bedework/formElements/form/start/rfc3339DateTime,'T')"/>');

              // meeting starttime
              $("#bwSchedClock").bwTimePicker({
                hour24: <xsl:value-of select="/bedework/hour24"/>,
                attachToId: "schedTime",
                hourIds: ["eventStartDateSchedHour","eventStartDateHour"],
                minuteIds: ["eventStartDateSchedMinute","eventStartDateMinute"],
                ampmIds: ["eventStartDateSchedAmpm","eventStartDateAmpm"],
                hourLabel: "<xsl:value-of select="$bwStr-Cloc-Hour"/>",
                minuteLabel: "<xsl:value-of select="$bwStr-Cloc-Minute"/>",
                amLabel: "<xsl:value-of select="$bwStr-Cloc-AM"/>",
                pmLabel: "<xsl:value-of select="$bwStr-Cloc-PM"/>"
              });
            }
            </xsl:comment>
          </script>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>

    <xsl:if test="/bedework/page='addEvent' or
                  /bedework/page='editEvent'  or
                  /bedework/page='managePolls'">

      <!-- import the internationalized strings for the javascript widgets -->
      <xsl:call-template name="bedeworkEventJsStrings"/>

      <script src="/approots/bedework-common/javascript/bedework/bwClock.js">&#160;</script>
      <link rel="stylesheet" href="/approots/bedework-common/javascript/bedework/bwClock.css"/>

      <script src="{$resourcesRoot}/javascript/bedeworkEventForm.js">&#160;</script>

      <script src="/approots/bedework-common/javascript/bedework/bedeworkXProperties.js">&#160;</script>

    </xsl:if>

    <xsl:if test="/bedework/page='addEvent' or
                /bedework/page='editEvent'">"

      <script src="{$resourcesRoot}/javascript/bedeworkScheduling.js">&#160;</script>
      <script src="{$resourcesRoot}/javascript/jcard.js">&#160;</script>
      <link rel="stylesheet" href="{$resourcesRoot}/css/bwScheduling.css"/>

      <script src="/approots/bedework-common/javascript/bedework/bedeworkAccess.js">&#160;</script>
      <xsl:call-template name="bedeworkAccessStrings"/>
      <link rel="stylesheet" href="/approots/bedework-common/default/default/bedeworkAccess.css"/>

      <!-- initialize event acls, if present -->
      <xsl:if test="/bedework/editableAccess/access/acl/ace">
        <script type="text/javascript">
          <xsl:apply-templates select="/bedework/editableAccess/access/acl/ace" mode="initJS"/>
        </script>
      </xsl:if>

      <script type="text/javascript">
        <xsl:comment>
        // initialize the free/busy grid - values taken directly from the xml
        // send params: displayId, startRange, startHourRange, endHourRange, attendees, workday, zoom, browserResourcesRoot, fbUrl, organizerUri
        // example: var bwGrid = new bwSchedulingGrid("bwFreeBusyDisplay","May 5, 2010",8,17,[{name:"Venerable Bede",uid:"vbede@mysite.edu",role:"CHAIR",status:"ACCEPTED",type:"person"}],true,100,"<xsl:value-of select="$resourcesRoot"/>","<xsl:value-of select="$requestFreeBusy"/>","");

        var bwGridSDate = new Date("<xsl:value-of select="/bedework/formElements/form/start/yearText/input/@value"/>/<xsl:value-of select="/bedework/formElements/form/start/month/select/option[@selected = 'selected']/@value"/>/<xsl:value-of select="/bedework/formElements/form/start/day/select/option[@selected = 'selected']/@value"/>");
        var bwGridAttees = new Array(<xsl:apply-templates select="/bedework/formElements/form/attendees" mode="loadBwGrid"/>);
        var bwGridOrganizer = "<xsl:value-of select="/bedework/formElements/form/organizer/organizerUri"/>";
        var bwGridCurUser = "<xsl:value-of select="/bedework/userid"/>";
        var bwGrid = new bwSchedulingGrid("bwFreeBusyDisplay",bwGridSDate,8,17,bwGridAttees,true,100,"<xsl:value-of select="$resourcesRoot"/>","<xsl:value-of select="$requestFreeBusy"/>","<xsl:value-of select="$widget-attendees"/>",bwGridOrganizer,bwGridCurUser);

        // set the grid size
        function bwGridSetSize() {
          var fbWidth = $("#bwEventTab-Basic").width() - 52;
          $("#bwFreeBusyDisplay").css("width", fbWidth + "px");
        };
        </xsl:comment>
      </script>


    </xsl:if>
    <xsl:if test="/bedework/page='editEvent'">
      <script type="text/javascript">
        <xsl:comment>
        function initRXDates() {
          // return string values to be loaded into javascript for rdates
          <xsl:for-each select="/bedework/formElements/form/rdates/rdate">
            bwRdates.update('<xsl:value-of select="date"/>','<xsl:value-of select="time"/>',false,false,false,'<xsl:value-of select="tzid"/>');
          </xsl:for-each>
          // return string values to be loaded into javascript for rdates
          <xsl:for-each select="/bedework/formElements/form/exdates/rdate">
            bwExdates.update('<xsl:value-of select="date"/>','<xsl:value-of select="time"/>',false,false,false,'<xsl:value-of select="tzid"/>');
          </xsl:for-each>
        }
        function initXProperties() {
          <xsl:for-each select="/bedework/formElements/form/xproperties/node()[text()]">
            bwXProps.init("<xsl:value-of select="name()"/>",[<xsl:for-each select="parameters/node()">["<xsl:value-of select="name()"/>","<xsl:value-of select="node()"/>"]<xsl:if test="position() != last()">,</xsl:if></xsl:for-each>],"<xsl:call-template name="escapeJson"><xsl:with-param name="string"><xsl:value-of select="values/text"/></xsl:with-param></xsl:call-template>");
          </xsl:for-each>
        }
        </xsl:comment>
      </script>
    </xsl:if>

    <!-- page based jquery initializations -->
    <xsl:if test="/bedework/page='event'">
      <!-- jQuery functions for detailed event view -->
      <script src="{$resourcesRoot}/javascript/bedeworkEvent.js">&#160;</script>
    </xsl:if>
    <xsl:if test="/bedework/page='eventscalendar'">
      <!-- jQuery functions for detailed event view -->
      <script src="{$resourcesRoot}/javascript/bedeworkCalendarGrid.js">&#160;</script>
    </xsl:if>

    <script type="text/javascript">
      <xsl:comment>

      // focuses an element by id
      function focusElement(id) {
        document.getElementById(id).focus();
      }

      $(document).ready(function() {
         <xsl:if test="/bedework/page = 'addEvent' or bedework/page = 'editEvent'">
           focusElement('bwEventTitle');
           bwSetupDatePickers();
           bwGrid.init();
           bwGridSetSize();
         </xsl:if>
         <xsl:if test="/bedework/page = 'addEvent'">
           // trim the event description:
           $("#description").val($.trim($("#description").val()));
         </xsl:if>
         <xsl:if test="/bedework/page = 'editEvent'">
           <xsl:if test="/bedework/formElements/recurrenceId = ''">
             initRXDates();
           </xsl:if>
           initXProperties();
         </xsl:if>
         <xsl:if test="/bedework/page = 'attendees'">
           focusElement('bwRaUri');
         </xsl:if>
         <xsl:if test="/bedework/page = 'modLocation'">
           focusElement('bwLocMainAddress');
         </xsl:if>
         <xsl:if test="/bedework/page = 'modCalendar'">
           $("#modCalAdvancedSwitch").click(function(event) {
             event.preventDefault();
             $(".modCalAdvanced").show();
             $("#modCalBasicSwitch").show();
             $("#modCalAdvancedSwitch").hide();
           });
           $("#modCalBasicSwitch").click(function(event) {
             event.preventDefault();
             $(".modCalAdvanced").hide();
             $("#modCalBasicSwitch").hide();
             $("#modCalAdvancedSwitch").show();
           });

           $("#calAccessBoxToggle").click(function(event) {
             event.preventDefault();
             $("#accessBox").toggle();
             if($("#accessBox").is(":visible")) {
               $("#calAccessBoxToggle img").attr('src','<xsl:value-of select="$resourcesRoot"/>/images/minus.gif');
             } else {
               $("#calAccessBoxToggle img").attr('src','<xsl:value-of select="$resourcesRoot"/>/images/plus.gif');
             };
           });
         </xsl:if>
         <xsl:if test="/bedework/page='managePolls'">
           focusElement('bwEventTitle');
           bwSetupDatePickers();
         </xsl:if>
      });

      </xsl:comment>
    </script>

  </xsl:template>


</xsl:stylesheet>