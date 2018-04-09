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

  <!--==== Head Section ====-->
  <xsl:template name="head">
      <head>
        <title><xsl:copy-of select="$bwStr-Root-PageTitle"/></title>
        <meta http-equiv="Content-Type" content="text/html;charset=UTF-8"/>
        <link rel="stylesheet" href="{$resourcesRoot}/css/default.css"/>
        <link rel="stylesheet" href="/bedework-common/default/default/subColors.css"/>

        <!-- set globals that must be passed in from the XSLT -->
        <script type="text/javascript">
          var defaultTzid = "<xsl:value-of select="/bedework/now/defaultTzid"/>";
          var startTzid = "<xsl:value-of select="/bedework/formElements/form/start/tzid"/>";
          var endTzid = "<xsl:value-of select="/bedework/formElements/form/end/dateTime/tzid"/>";
          var resourcesRoot = "<xsl:value-of select="$resourcesRoot"/>";
          var imagesRoot = resourcesRoot + "/images";
        </script>

        <!-- load jQuery -->
        <script type="text/javascript" src="/bedework-common/javascript/jquery/jquery-1.11.3.min.js">/* jQuery */</script>
        <script type="text/javascript" src="/bedework-common/javascript/jquery/jquery-ui-1.11.4.min.js">/* jQuery UI */</script>
        <link rel="stylesheet" href="/bedework-common/javascript/jquery/css/jquery-ui-1.11.0/jquery-ui.min.css"/>
        <link rel="stylesheet" href="/bedework-common/javascript/jquery/css/jquery-ui-1.11.0/jquery-ui.theme.min.css"/>

        <!-- Global Javascript (every page): -->
        <script type="text/javascript" src="/bedework-common/javascript/bedework/bedeworkUtil.js">/* Bedework Utilities */</script>
        <script type="text/javascript" src="{$resourcesRoot}/javascript/bedeworkNotifications.js">/* Bedework Notifications */</script>

        <!-- include the localized jQuery datepicker defaults -->
        <xsl:call-template name="jqueryDatepickerDefaults"/>
        <script type="text/javascript">
          $(document).ready(function(){
            // focus first visible,enabled form element:
            $(':input[type=text]:visible:enabled:first:not(.noFocus)').focus();
          });

          // hold the most recent search query, start date, and scope
          function setBwQuery(formObj,dateString,submit) {
            if (trim(formObj.query.value) != "") {
              var date = dateString;
              var scope = "local";
              if (date == "today" || date == undefined || date == "") {
                date = "<xsl:value-of select="substring(/bedework/now/date,1,4)"/>-<xsl:value-of select="substring(/bedework/now/date,5,2)"/>-<xsl:value-of select="substring(/bedework/now/date,7,2)"/>";
                formObj.start.value = date;
              }
              if (formObj.fexpr[1].checked) {
                scope = "mine";
              }
              if (formObj.fexpr[2].checked) {
                scope = "all";
              }
              formObj.setappvar.value = "bwQuery(" + date + "|" + formObj.query.value  + "|" + scope + ")";
              if (submit == true) {
                formObj.submit();
              }
              return true;
            }
            return false;
          }
        </script>

        <!-- conditional javascript and css only for modifying events -->
        <xsl:if test="/bedework/page='modEvent' or
                      /bedework/page='modEventPending' or
                      /bedework/page='modEventApprovalQueue' or
                      /bedework/page='modEventSuggestionQueue'">
          <!-- import the internationalized strings for the javascript widgets -->
          <xsl:call-template name="bedeworkEventJsStrings"/>

          <!-- load libraries -->
          <script type="text/javascript" src="/bedework-common/javascript/jquery/autocomplete/select2.min.js">/* Autocomplete combobox */</script>
          <link rel="stylesheet" href="/bedework-common/javascript/jquery/autocomplete/select2.min.css"/>
          <script type="text/javascript" src="/bedework-common/javascript/jquery/magnific/jquery.magnific-popup.min.js">/* for export/subscribe lightbox */</script>
          <link rel="stylesheet" type="text/css" media="screen" href="/bedework-common/javascript/jquery/magnific/magnific-popup.css" />

          <!-- load the bedework event form scripts -->
          <script type="text/javascript" src="{$resourcesRoot}/javascript/bedework.js">/* Bedework */</script>
          <script type="text/javascript" src="{$resourcesRoot}/javascript/bedeworkEventForm.js">/* Bedework Event Form Functions */</script>
          <script type="text/javascript" src="/bedework-common/javascript/bedework/bedeworkXProperties.js">/* Bedework X-Property Handling */</script>
          <script type="text/javascript" src="/bedework-common/javascript/bedework/bwClock.js">/* Bedework clock widget */</script>
          <link rel="stylesheet" href="/bedework-common/javascript/bedework/bwClock.css"/>

          <!-- include the localized jQuery datepicker defaults -->
          <xsl:call-template name="jqueryDatepickerDefaults"/>

          <!-- now setup date and time pickers -->
          <script type="text/javascript">
            function bwSetupDatePickers() {
              // startdate
              $("#bwEventWidgetStartDate").datepicker({
                <xsl:if test="/bedework/formElements/eventRegAdminToken != '' and (/bedework/creating = 'true' or (translate(/bedework/formElements/form/start/rfc3339DateTime,'-:','') = /bedework/formElements/form/xproperties/X-BEDEWORK-REGISTRATION-END/values/text))">altField: "#xBwRegistrationClosesDate",</xsl:if><!--
             -->defaultDate: new Date(<xsl:value-of select="/bedework/formElements/form/start/yearText/input/@value"/>, <xsl:value-of select="number(/bedework/formElements/form/start/month/select/option[@selected = 'selected']/@value) - 1"/>, <xsl:value-of select="/bedework/formElements/form/start/day/select/option[@selected = 'selected']/@value"/>)
              }).attr("readonly", "readonly");
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
              }).attr("readonly", "readonly");
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
              }).attr("readonly", "readonly");
              $("#bwEventWidgetUntilDate").val('<xsl:value-of select="substring-before(/bedework/formElements/form/start/rfc3339DateTime,'T')"/>');

              // rdates and xdates
              $("#bwEventWidgetRdate").datepicker({
                defaultDate: new Date(<xsl:value-of select="/bedework/formElements/form/start/yearText/input/@value"/>, <xsl:value-of select="number(/bedework/formElements/form/start/month/select/option[@selected = 'selected']/@value) - 1"/>, <xsl:value-of select="/bedework/formElements/form/start/day/select/option[@selected = 'selected']/@value"/>),
                dateFormat: "yymmdd"
              }).attr("readonly", "readonly");
              $("#bwEventWidgetRdate").val('<xsl:value-of select="substring-before(/bedework/formElements/form/start/rfc3339DateTime,'T')"/>');

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

              <!-- setup the event registration components if registration is in use -->
              <xsl:if test="/bedework/formElements/eventRegAdminToken != ''">
                // registration open dates
                $("#xBwRegistrationOpensDate").datepicker().attr("readonly", "readonly");
                $("#xBwRegistrationOpensDate").val('<xsl:value-of select="substring-before(/bedework/formElements/form/start/rfc3339DateTime,'T')"/>');

                // registration open time
                $("#xBwRegistrationOpensClock").bwTimePicker({
                  hour24: <xsl:value-of select="/bedework/hour24"/>,
                  attachToId: "xBwRegistrationOpensTimeFields",
                  hourIds: ["xBwRegistrationOpensHour"],
                  minuteIds: ["xBwRegistrationOpensMinute"],
                  ampmIds: ["xBwRegistrationOpensAmpm"],
                  hourLabel: "<xsl:value-of select="$bwStr-Cloc-Hour"/>",
                  minuteLabel: "<xsl:value-of select="$bwStr-Cloc-Minute"/>",
                  amLabel: "<xsl:value-of select="$bwStr-Cloc-AM"/>",
                  pmLabel: "<xsl:value-of select="$bwStr-Cloc-PM"/>"
                });

                // registration close dates
                $("#xBwRegistrationClosesDate").datepicker().attr("readonly", "readonly");
                $("#xBwRegistrationClosesDate").val('<xsl:value-of select="substring-before(/bedework/formElements/form/start/rfc3339DateTime,'T')"/>');

                // registration close time
                $("#xBwRegistrationClosesClock").bwTimePicker({
                  hour24: <xsl:value-of select="/bedework/hour24"/>,
                  attachToId: "xBwRegistrationClosesTimeFields",
                  hourIds: ["xBwRegistrationClosesHour"],
                  minuteIds: ["xBwRegistrationClosesMinute"],
                  ampmIds: ["xBwRegistrationClosesAmpm"],
                  hourLabel: "<xsl:value-of select="$bwStr-Cloc-Hour"/>",
                  minuteLabel: "<xsl:value-of select="$bwStr-Cloc-Minute"/>",
                  amLabel: "<xsl:value-of select="$bwStr-Cloc-AM"/>",
                  pmLabel: "<xsl:value-of select="$bwStr-Cloc-PM"/>"
                });
              </xsl:if>
            }

            <!-- set up recurrence and exception dates if this is a recurring event -->
            function initRXDates() {
              // return string values to be loaded into javascript for rdates
              <xsl:for-each select="/bedework/formElements/form/rdates/rdate">
                bwRdates.update('<xsl:value-of select="date"/>','<xsl:value-of select="time"/>',false,false,false,'<xsl:value-of select="tzid"/>');
              </xsl:for-each>
              // return string values to be loaded into javascript for exdates
              <xsl:for-each select="/bedework/formElements/form/exdates/rdate">
                bwExdates.update('<xsl:value-of select="date"/>','<xsl:value-of select="time"/>',false,false,false,'<xsl:value-of select="tzid"/>');
              </xsl:for-each>
            }

            <!-- initialize all X-Properties contained in the event -->
            function initXProperties() {
              <xsl:for-each select="/bedework/formElements/form/xproperties/*">
                bwXProps.init("<xsl:value-of select="name()"/>",[<xsl:for-each select="parameters/node()">["<xsl:value-of select="name()"/>","<xsl:value-of select="node()" disable-output-escaping="yes"/>"]<xsl:if test="position() != last()">,</xsl:if></xsl:for-each>],"<xsl:call-template name="escapeJson"><xsl:with-param name="string"><xsl:value-of select="values/text" disable-output-escaping="yes"/></xsl:with-param></xsl:call-template>");
              </xsl:for-each>
            }

            <!-- set up calendar selections -->
            function bwSetupCalendars() {
              $("#bwPreferredCalendars").select2();
              $("#bwAllCalendars").select2();
            }

            <!-- load locations -->
            function bwSetupLocations(selLocUid) {
              var selectedLocUid = selLocUid;
              var bwLocXhr = $.getJSON("/caladmin/location/all.gdo")
              .done(function(data) {
                // setup the primary location
                var selectOrSearchStr = "<xsl:value-of select="$bwStr-AEEF-SelectOrSearch"/>";
                var locOptionsPrimary = processLocationsPrimary(data.locations,selectedLocUid);
                $("#bwLocationsPrimary").append(locOptionsPrimary);

                // setup the secondary locations
                var locKey = $("#bwLocationsPrimary option:selected").text();
                var locEmptyStr = "<xsl:value-of select="$bwStr-AEEF-None"/>";
                var locOptionsSecondary = processLocationsSecondary(data.locations,locKey,locEmptyStr,selectedLocUid);
                $("#bwLocationsSecondary").html(locOptionsSecondary);

                // turn both select boxes into select/search combos
                $("#bwLocationsPrimary").select2({
                  placeholder: selectOrSearchStr,
                  width: "600"
                });
                $("#bwLocationsSecondary").select2({
                  placeholder: selectOrSearchStr,
                  width: "600"
                });

                // add the onchange handlers
                $("#bwLocationsPrimary").on("change",function() {
                  var locKey = $("#bwLocationsPrimary option:selected").text();
                  var locEmptyStr = "<xsl:value-of select="$bwStr-AEEF-None"/>";
                  var locOptionsSecondary = processLocationsSecondary(data.locations,locKey,locEmptyStr,selectedLocUid);
                  $("#bwLocationsSecondary").html(locOptionsSecondary);
                  $("#bwLocationsSecondary").select2("destroy"); // destroy and re-init to reset the options
                  $("#bwLocationsSecondary").select2({
                    placeholder: selectOrSearchStr,
                    width: "600"
                  });
                  $("#bwLocation").val($("#bwLocationsSecondary option:selected").val());
                  $("#bwLocationsSecondaryContainer").show();
                  $("#bwAddRoomLink").removeClass("disabled");
                });
                $("#bwLocationsSecondary").on("change",function() {
                  $("#bwLocation").val($(this).val());
                });
              })
              .fail(function(jqxhr, textStatus, error ) {
                if (bwJsDebug) {
                  var err = textStatus + ", " + error;
                  console.log( "Request for locations failed: " + err );
                }
              });
            }

            <!-- set up contact selections -->
            function bwSetupContacts() {
              var selectOrSearchStr = "<xsl:value-of select="$bwStr-AEEF-SelectOrSearch"/>";
              $("#bwPreferredContactList").select2({
                placeholder: selectOrSearchStr,
                width: "600"
              });
              $("#bwAllContactList").select2({
                placeholder: selectOrSearchStr,
                width: "600"
              });
              // add the onchange handlers
              $("#bwPreferredContactList").on("change",function() {
                $("#bwPrefContact").val($(this).val());
              });
              $("#bwAllContactList").on("change",function() {
                $("#bwContact").val($(this).val());
              });
            }

            <!-- put it all together on load -->
            $(document).ready(function(){
              <xsl:comment>
                <xsl:if test="/bedework/formElements/recurrenceId = ''">
                  initRXDates();
                </xsl:if>

                initXProperties();
                bwSetupDatePickers();
                bwSetupLocations("<xsl:value-of select="/bedework/formElements/form/location/all/select/option[@selected='selected']/@value"/>");
                bwSetupContacts();

                // trim the event description:
                $("#description").val($.trim($("#description").val()));

                // limit the event description to maxPublicDescriptionLength as configured in cal.options.xml
                $("#description").keyup(function(){
                  var maxDescLength = parseInt(<xsl:value-of select="/bedework/formElements/form/descLength"/>);
                  var desc = $(this).val();
                  var remainingChars = maxDescLength - desc.length;
                  if (remainingChars &lt; 0) {
                    remainingChars = 0;
                  }
                  $("#remainingChars").html(remainingChars + " <xsl:value-of select="$bwStr-AEEF-CharsRemaining"/>");
                  if(desc.length > maxDescLength){
                    var truncDesc = desc.substr(0, maxDescLength);
                    $(this).val(truncDesc);
                  };
                });

                // add room form
                $("#bwAddRoomLink").magnificPopup({
                  type:'inline',
                  fixedBgPos: true,
                  midClick: true,
                  callbacks: {
                    open: function() {
                      if (!bwCheckPrimaryLoc()) {
                        this.close();
                      } else {
                        bwAddRoomInit();
                      }
                    }
                  }
                });

                // If you wish to collapse specific topical areas, you can specify them here:
                // (note that this will be managed from the admin client in time)
                // $("ul.aliasTree > li:eq(4) > ul").hide();
                // $("ul.aliasTree > li:eq(11) > ul").hide();
                // $("ul.aliasTree > li:eq(13) > ul").hide();
                $("ul.aliasTree > li > img.folderForAliasTree").attr("src", '<xsl:value-of select="$resourcesRoot"/>/images/catExpander.gif');
                $("ul.aliasTree > li > img.folderForAliasTree").css("cursor","pointer");
                $("ul.aliasTree > li > img.folderForAliasTree").click(function(){
                  $(this).next("ul.aliasTree > li > ul").slideToggle("slow");
                });

              });
            </xsl:comment>
          </script>
        </xsl:if>
        <xsl:if test="/bedework/page='tabSuggestionQueueEvents' or /bedework/page='modEventSuggestionQueue'">
          <script type="text/javascript" src="{$resourcesRoot}/javascript/suggestions.js">/* Suggestion queue */</script>
        </xsl:if>
        <xsl:if test="/bedework/page='eventList' or
                      /bedework/page='tabPendingEvents' or
                      /bedework/page='tabSuggestionQueueEvents' or
                      /bedework/page='tabApprovalQueueEvents'">
          <script type="text/javascript" src="/bedework-common/javascript/jquery/magnific/jquery.magnific-popup.min.js">/* for export/subscribe lightbox */</script>
          <link rel="stylesheet" type="text/css" media="screen" href="/bedework-common/javascript/jquery/magnific/magnific-popup.css" />
          <!-- now setup date and time pickers -->
          <script type="text/javascript">
            <xsl:comment>
            $(document).ready(function(){
              // startdate for list
              $("#bwListWidgetStartDate").datepicker({
                showOn: "button",
                defaultDate: new Date(<xsl:value-of select="substring(/bedework/now/date,1,4)"/>, <xsl:value-of select="number(substring(/bedework/now/date,5,2)) - 1"/>, <xsl:value-of select="substring(/bedework/now/date,7,2)"/>)
              });
              <xsl:choose>
                <xsl:when test="/bedework/appvar[key='curListDate']">
                  $("#bwListWidgetStartDate").val('<xsl:value-of select="/bedework/appvar[key='curListDate']/value"/>');
                </xsl:when>
                <xsl:otherwise>
                  $("#bwListWidgetStartDate").val('<xsl:value-of select="$curListDate"/>');
                </xsl:otherwise>
              </xsl:choose>

              // generate a public events link in the listing
              $(".bwPublicLink").magnificPopup({
                type:'inline',
                fixedBgPos: true,
                midClick: true,
                callbacks: {
                  open: function() {
                    var site = window.location;
                    var sitePrefix = site.protocol + "//" + site.hostname;
                    if (site.port != "" || site.port != "80" || site.port != "443") {
                      sitePrefix += ":" + site.port;
                    }
                    var url = sitePrefix + $(this.st.el).attr("data-public-event-path");
                    var summary = $(this.st.el).attr("data-public-event-summary");
                    var link = document.createElement('a');
                    link.setAttribute('href', url);
                    link.setAttribute('target', 'publicClient');
                    link.setAttribute('title','public url');
                    link.innerHTML = summary;
                    $("#bwPublicEventLink").html(link);
                    $("#bwPublicEventLinkInput").attr("value",url);
                    $("#bwPublicEventLinkBox").removeClass("invisible");
                    $("#bwPublicEventLinkInput").click(function() {
                      this.select();
                    });
                  }
                }
              });

            });
            </xsl:comment>
          </script>
        </xsl:if>
        <xsl:if test="/bedework/page='searchResult'">
          <!-- now setup date and time pickers -->
          <script type="text/javascript">
            <xsl:comment>
            $(document).ready(function(){
              // startdate for search
              $("#bwSearchWidgetStartDate").datepicker({
                showOn: "button",
                defaultDate: new Date(<xsl:value-of select="substring(/bedework/now/date,1,4)"/>, <xsl:value-of select="number(substring(/bedework/now/date,5,2)) - 1"/>, <xsl:value-of select="substring(/bedework/now/date,7,2)"/>)
              });
              <xsl:choose>
                <xsl:when test="/bedework/appvar[key='bwQuery']">
                  $("#bwSearchWidgetStartDate").val('<xsl:value-of select="substring-before(/bedework/appvar[key='bwQuery']/value,'|')"/>');
                </xsl:when>
                <xsl:otherwise>
                  $("#bwSearchWidgetStartDate").val('<xsl:value-of select="$curListDate"/>');
                </xsl:otherwise>
              </xsl:choose>

            });
            </xsl:comment>
          </script>
        </xsl:if>
        <xsl:if test="/bedework/page='modCalendar' or
                      /bedework/page='modCalSuite' or
                      /bedework/page='modSubscription'">
          <script type="text/javascript" src="{$resourcesRoot}/javascript/bedework.js">/* Bedework */</script>
          <link rel="stylesheet" href="/bedework-common/default/default/bedeworkAccess.css"/>
          <script type="text/javascript" src="/bedework-common/javascript/bedework/bedeworkAccess.js">/* Bedework Access Control handling */</script>
          <xsl:call-template name="localeAccessStringsJsInclude"></xsl:call-template>

          <!-- initialize calendar acls, if present -->
          <xsl:if test="/bedework/currentCalendar/acl/ace">
            <script type="text/javascript">
              <xsl:apply-templates select="/bedework/currentCalendar/acl/ace" mode="initJS"/>
            </script>
          </xsl:if>
          <xsl:if test="/bedework/calSuite/acl/ace">
            <script type="text/javascript">
              <xsl:apply-templates select="/bedework/calSuite/acl/ace" mode="initJS"/>
            </script>
          </xsl:if>
        </xsl:if>
        <xsl:if test="/bedework/page='calSuitePrefs'">
          <script type="text/javascript" src="/bedework-common/javascript/jquery/jquery-1.3.2.min.js">/* jQuery */</script>
          <script type="text/javascript" src="{$resourcesRoot}/javascript/bedework.js">/* Bedework */</script>
          <script type="text/javascript" src="{$resourcesRoot}/javascript/bedeworkPrefs.js">/* Bedework User/Calsuite Preferences */</script>
        </xsl:if>
        <xsl:if test="/bedework/page='upload' or
                      /bedework/page='selectCalForEvent' or
                      /bedework/page='deleteEventConfirmPending' or
                      /bedework/page='addFilter' or
                      /bedework/page='calSuitePrefs' or
                      /bedework/page='eventList' or
                      /bedework/page='tabPendingEvents' or
                      /bedework/page='tabSuggestionQueueEvents' or
                      /bedework/page='tabApprovalQueueEvents'">
          <script type="text/javascript" src="{$resourcesRoot}/javascript/bedework.js">/* Bedework */</script>
          <script type="text/javascript" src="{$resourcesRoot}/javascript/bedeworkEventForm.js">/* Bedework Event Form Functions */</script>
          <script type="text/javascript" src="/bedework-common/javascript/bedework/bedeworkUtil.js">/* Bedework Utilities */</script>
        </xsl:if>
        <xsl:if test="/bedework/page='calendarDescriptions' or /bedework/page='displayCalendar'">
          <link rel="stylesheet" href="{$resourcesRoot}/css/calendarDescriptions.css"/>
        </xsl:if>
        <xsl:if test="/bedework/page='modResource'">
          <script type="text/javascript" src="{$resourcesRoot}/javascript/modResources.js">/* Bedework Resource Handling */</script>
          <link rel="stylesheet" href="{$resourcesRoot}/css/featuredEventsForm.css"/>
        </xsl:if>
        <link rel="icon" type="image/ico" href="{$resourcesRoot}/images/bedework.ico" />
      </head>
  </xsl:template>

</xsl:stylesheet>
