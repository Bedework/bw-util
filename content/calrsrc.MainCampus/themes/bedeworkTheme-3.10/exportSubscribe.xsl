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

  <xsl:template name="exportSubscribeJavascript">
    <xsl:param name="id"/>
    <script type="text/javascript">
      $(document).ready(function(){
        $('#<xsl:value-of select="$id"/>').magnificPopup({
          type:'inline',
          fixedBgPos: true,
          midClick: true,
          callbacks: {
            open: function() {
              <!-- set the initial URL display by clicking the feed button -->
              $("#bwExpFeed").click();

              <!-- grab the filter information right from the DOM and
                   redisplay it at the top of the pop-up -->
              $("#exportSubscribeFiltersBox").hide(); <!-- hide the filter display box by default -->
              $("#exportSubscribeFilters").html(""); <!-- clear out filter display -->

              if ($(".bwQueryText").length || $(".calFilterContainer .bwFilterName").length) {
                if ($(".bwQueryText").length) { <!-- do we have a query? -->
                  var queryText = '<div class="eventFilterInfo">';
                  queryText += '<span class="bwExpFilterName">' + $(".bwQueryText .bwQueryTitle").text() + "</span> ";
                  queryText += '<span class="bwExpFilterItems">' + $(".bwQueryText .bwQueryQuery").text() + "</span>";
                  queryText += "</div>";
                  $("#exportSubscribeFilters").append(queryText);
                }

                $(".calFilterContainer").each(function() {
                  if($(this).find(".bwFilterName").length) { <!-- do we have a filter? -->
                    var filterText = '<div class="eventFilterInfo">';
                    filterText += '<span class="bwExpFilterName">' + $(this).find(".bwFilterName").text() + ":</span> ";
                    var filterItemsLength = $(this).find(".bwFilterText .bwFilterItemName").length;
                    filterText += '<span class="bwExpFilterItems">';
                    $(this).find(".bwFilterText .bwFilterItemName").each(function(i) {
                      filterText += $(this).text();
                      if(i != filterItemsLength - 1) {
                        filterText += ", ";
                      }
                    });
                    filterText += "</span>";
                    filterText += "</div>";
                    $("#exportSubscribeFilters").append(filterText);
                  }
                });

                $("#exportSubscribeFiltersBox").show(); <!-- finally, show the box -->
              }
            }
          }
        });
      });
    </script>
  </xsl:template>

  <xsl:template name="exportSubscribe">
    <h2 id="exportSubscribeTitle"><xsl:copy-of select="$bwStr-exSu-ExportSubscribe"/></h2>
    <div id="exportSubscribeFiltersBox">
      <h3><xsl:copy-of select="$bwStr-exSu-CurrentFiltersColon"/></h3>
      <div id="exportSubscribeFilters"><xsl:text> </xsl:text></div>
    </div>
    <div id="exportSubscribeForm">
      <fieldset>
        <legend><xsl:copy-of select="$bwStr-exSu-FeedOrWidget"/></legend>
        <ul>
          <li>
            <input type="radio" onclick="updateUrlDisplay();" checked="checked" class="bwExpTrigger" id="bwExpFeed" name="feedOrWidget" value="feed"/>
            <label for="bwExpFeed"><xsl:copy-of select="$bwStr-exSu-Feed"/></label>
          </li>
          <li>
            <input type="radio" onclick="updateUrlDisplay();" class="bwExpTrigger" id="bwExpWidget" name="feedOrWidget" value="widget"/>
            <label for="bwExpWidget"><xsl:copy-of select="$bwStr-exSu-Widget"/></label>
          </li>
        </ul>
      </fieldset>

      <div id="bwExpDataFormat">
        <fieldset>
          <legend><xsl:copy-of select="$bwStr-exSu-DataFormat"/></legend>
          <ul>
            <li>
              <input type="radio" id="bwExpRss" class="bwExpDfTrigger" onclick='updateUrlDisplay()' name="bwExpDataType" value="rss" checked="checked"/>
              <label for="bwExpRss">RSS</label>
            </li>
            <li>
              <input type="radio" id="bwExpJson" class="bwExpDfTrigger" onclick='updateUrlDisplay()' name="bwExpDataType" value="json"/>
              <label for="bwExpJson">JSON</label>
            </li>
            <li>
              <input type="radio" id="bwExpXml" class="bwExpDfTrigger" onclick='updateUrlDisplay()' name="bwExpDataType" value="xml"/>
              <label for="bwExpXml">XML</label>
            </li>
            <li>
              <input type="radio" id="bwExpIcs" class="bwExpDfTrigger" onclick='updateUrlDisplay()' name="bwExpDataType" value="ics"/>
              <label for="bwExpIcs">iCal - iCalendar (<a href="http://tools.ietf.org/html/rfc5545" target="_blank">RFC5545</a>, .ics)</label>
            </li>
            <li>
              <input type="radio" id="bwExpJcal" class="bwExpDfTrigger" onclick='updateUrlDisplay()' name="bwExpDataType" value="ics"/>
              <label for="bwExpJcal">jCal - iCalendar JSON (<a href="http://tools.ietf.org/html/rfc7265" target="_blank">RFC7265</a>, .jcs)</label>
            </li>
            <li>
              <input type="radio" id="bwExpXcal" class="bwExpDfTrigger" onclick='updateUrlDisplay()' name="bwExpDataType" value="ics"/>
              <label for="bwExpXcal">xCal - iCalendar XML (<a href="http://tools.ietf.org/html/rfc6321" target="_blank">RFC6321</a>, .xcs)</label>
            </li>
            <li>
              <input type="radio" id="bwExpCsv" class="bwExpDfTrigger" onclick='updateUrlDisplay()' name="bwExpDataType" value="csv"/>
              <label for="bwExpCsv">CSV</label>
            </li>
            <li>
              <input type="radio" id="bwExpHtml" class="bwExpDfTrigger" onclick="updateUrlDisplay();" name="bwExpDataType" value="html"/>
              <label for="bwExpHtml"><xsl:copy-of select="$bwStr-exSu-HTMLList"/></label>
              <ul id="bwHtmlListOptions">
                <li>
                  <div class="bwExpOptionName"><xsl:copy-of select="$bwStr-exSu-IncludeDownloadLink"/></div>
                  <div class="bwExpOptionFields">
                    <input type="radio" id="bwHtmlListDownloadTrue" name="bwHtmlListDownloadLink" onclick="updateUrlDisplay();" value="true"/>
                    <label for="bwHtmlListDownloadTrue">
                      <xsl:copy-of select="$bwStr-exSu-True"/>
                    </label>
                    <input type="radio" id="bwHtmlListDownloadFalse" name="bwHtmlListDownloadLink" onclick="updateUrlDisplay();" value="false" checked="checked"/>
                    <label for="bwHtmlListDownloadFalse">
                      <xsl:copy-of select="$bwStr-exSu-False"/>
                    </label>
                  </div>
                </li>
                <li>
                  <div class="bwExpOptionName"><xsl:copy-of select="$bwStr-exSu-ShowDetailsOrSummary"/></div>
                  <div class="bwExpOptionFields">
                    <input type="radio" id="bwHtmlDetailsTrue" name="bwHtmlDetails" onclick="updateUrlDisplay();" value="true" checked="checked"/>
                    <label for="bwHtmlDetailsTrue">
                      <xsl:copy-of select="$bwStr-exSu-Details"/>
                    </label>
                    <input type="radio" id="bwHtmlDetailsFalse" name="bwHtmlDetails" onclick="updateUrlDisplay();" value="false"/>
                    <label for="bwHtmlDetailsFalse">
                      <xsl:copy-of select="$bwStr-exSu-Summary"/>
                    </label>
                  </div>
                </li>
              </ul>
            </li>
          </ul>
        </fieldset>
      </div>

      <div id="bwExpCount">
        <fieldset>
          <legend><xsl:copy-of select="$bwStr-exSu-EventCount"/></legend>
          <div id="bwExpCountWidget">
            <label for="bwExpEventCount"><xsl:copy-of select="$bwStr-exSu-EventCountTotal"/></label>
            <input type="text" value="10" size="3" id="bwExpEventCount" name="count" onchange="updateUrlDisplay();"/>
            <div class="bwExpSubField">
              <div id="bwExpCountSlider" class="bwSlider"><xsl:text> </xsl:text></div>
            </div>
          </div>
        </fieldset>
      </div>

      <div id="bwExpTimeframeUnit">
        <fieldset>
          <legend><xsl:copy-of select="$bwStr-exSu-Timeframe"/></legend>
          <ul id="bwExpTimeFrameWidgets">
            <li>
              <input type="radio" id="bwExpDaysDefault" name="timeframe" onclick="updateUrlDisplay();" value="default" checked="checked"/>
              <label for="bwExpDaysDefault"><xsl:copy-of select="$bwStr-exSu-Default"/></label>
            </li>
            <li>
              <input type="radio" id="bwExpNumberOfDays" name="timeframe" onclick="updateUrlDisplay();" value="days"/>
              <label for="bwExpNumberOfDays"><xsl:copy-of select="$bwStr-exSu-LimitTo"/><xsl:text> </xsl:text></label>
              <input class="slider" onclick="updateUrlDisplay();" type="text" size="3" id="bwExpNumDays"/><xsl:text> </xsl:text>
              <label for="bwExpNumDays"><xsl:copy-of select="$bwStr-exSu-DaysFromToday"/></label>
              <div class="bwExpSubField">
                <div id="bwExpSlider" class="bwSlider"><xsl:text> </xsl:text></div>
              </div>
            </li>
            <li>
              <input type="radio" id="bwExpStartEndDates" name="timeframe" onclick="updateUrlDisplay();" value="dates"/>
              <label for="bwExpStartEndDates"><xsl:copy-of select="$bwStr-exSu-DateRangeColon"/></label>
              <span class="bwExpSubField">
                <label for="bwExpStartDate"><xsl:copy-of select="$bwStr-exSu-StartDateColon"/></label><xsl:text> </xsl:text>
                <input size="8" class="datepicker" id="bwExpStartDate" onclick="updateUrlDisplay();" type="text"></input>
                <xsl:text> </xsl:text>
                <label for="bwExpEndDate"><xsl:copy-of select="$bwStr-exSu-EndDateColon"/></label><xsl:text> </xsl:text>
                <input size="8" class="datepicker" id="bwExpEndDate" onclick="updateUrlDisplay();" type="text"></input>
              </span>
              <br/>
              <span class="bwExpNote"><xsl:copy-of select="$bwStr-exSu-DateRangeNote"/></span>
            </li>
          </ul>
        </fieldset>
        <!-- timeframeWidgets -->
      </div>
      <!-- timeframeUnit -->

      <!-- JSON WIDGET OPTIONS -->
      <div id="bwExpJsWidgetOptions">

        <fieldset>
          <legend><xsl:copy-of select="$bwStr-exSu-WidgetOptions"/></legend>
          <ul id="bwJsWidgetOptionsGeneral">
            <li>
              <div class="bwExpOptionName"><xsl:copy-of select="$bwStr-exSu-LimitEvents"/></div>
              <div class="bwExpOptionFields">
                <input type="radio" id="bwExpJsShowLimitListTrue" class="bwExpTrigger" name="jsLimitList" onclick="updateUrlDisplay();" value="true"/>
                <label for="bwExpJsShowLimitListTrue"><xsl:copy-of select="$bwStr-exSu-True"/></label>
                <input type="radio" id="bwExpJsShowLimitListFalse" class="bwExpTrigger" name="jsLimitList" onclick="updateUrlDisplay();" value="false" checked="checked"/>
                <label for="bwExpJsShowLimitListFalse"><xsl:copy-of select="$bwStr-exSu-False"/></label>
                <em><xsl:copy-of select="$bwStr-exSu-DefaultFalse "/></em>
                <div id="bwExpWidgetLimit" class="bwExpSubField">
                  <label for="bwExpJsLimit"><xsl:copy-of select="$bwStr-exSu-LimitToColon"/></label>
                  <input onblur="updateUrlDisplay();" type="text" size="3" id="bwExpJsLimit" name="jsLimit" value="5"/>
                  <xsl:copy-of select="$bwStr-exSu-Events"/>
                </div>
              </div>
            </li>
            <li>
              <div class="bwExpOptionName"><xsl:copy-of select="$bwStr-exSu-ShowTitle"/></div>
              <div class="bwExpOptionFields">
                <input type="radio" id="bwExpJsShowTitleTrue" class="bwExpTrigger" name="jsShowTitle" onclick="updateUrlDisplay();" value="true" checked="checked"/>
                <label for="bwExpJsShowTitleTrue"><xsl:copy-of select="$bwStr-exSu-True"/></label>
                <input type="radio" id="bwExpJsShowTitleFalse" class="bwExpTrigger" name="jsShowTitle" onclick="updateUrlDisplay();" value="false"/>
                <label for="bwExpJsShowTitleFalse"><xsl:copy-of select="$bwStr-exSu-False"/></label>
                <em><xsl:copy-of select="$bwStr-exSu-DefaultTrue "/></em>
                <div id="bwExpJsSetTitle">
                  <label for="bwExpJsSetTitleName"><xsl:copy-of select="$bwStr-exSu-TitleColon"/></label>
                  <input size="20" id="bwExpJsSetTitleName" name="jsTitleName" onblur="updateUrlDisplay();" type="text" value="{$bwStr-exSu-UpcomingEvents}"/>
                  <em><xsl:copy-of select="$bwStr-exSu-DefaultUpcomingEvents"/></em>
                </div>
              </div>
            </li>
            <li>
              <div class="bwExpOptionName"><xsl:copy-of select="$bwStr-exSu-HighlightDatesOrTitles"/></div>
              <div class="bwExpOptionFields">
                <input type="radio" id="bwJsDisplayByTitle" name="jsDisplayDateOrTitle" onclick="updateUrlDisplay();" value="byTitle" checked="checked"/>
                <label for="bwJsDisplayByTitle"><xsl:copy-of select="$bwStr-exSu-ByTitle  "/></label>
                <input type="radio" id="bwJsDisplayByDate" name="jsDisplayDateOrTitle" onclick="updateUrlDisplay();" value="byDate"/>
                <label for="bwJsDisplayByDate"><xsl:copy-of select="$bwStr-exSu-ByDate   "/></label>
                <em><xsl:copy-of select="$bwStr-exSu-DefaultByTitle"/></em>
              </div>
            </li>
            <li>
              <div class="bwExpOptionName"><xsl:copy-of select="$bwStr-exSu-ShowDescription   "/></div>
              <div class="bwExpOptionFields">
                <input type="radio" id="bwJsDisplayDescriptionTrue" name="jsDisplayDescription" onclick="updateUrlDisplay();" value="true"/>
                <label for="bwJsDisplayDescriptionTrue"><xsl:copy-of select="$bwStr-exSu-True"/></label>
                <input type="radio" id="bwJsDisplayDescriptionFalse" name="jsDisplayDescription" onclick="updateUrlDisplay();" value="false" checked="checked"/>
                <label for="bwJsDisplayDescriptionFalse"><xsl:copy-of select="$bwStr-exSu-False"/></label>
                <em><xsl:copy-of select="$bwStr-exSu-DefaultFalse "/></em>
              </div>
            </li>
            <li>
              <div class="bwExpOptionName"><xsl:copy-of select="$bwStr-exSu-DisplayEndDate"/></div>
              <div class="bwExpOptionFields">
                <input type="radio" id="bwJsDisplayEndDateTrue" name="jsDisplayEndDate" onclick="updateUrlDisplay();" value="true" checked="checked"/>
                <label for="bwJsDisplayEndDateTrue"><xsl:copy-of select="$bwStr-exSu-True"/></label>
                <input type="radio" id="bwJsDisplayEndDateFalse" name="jsDisplayEndDate" onclick="updateUrlDisplay();" value="false"/>
                <label for="bwJsDisplayEndDateFalse"><xsl:copy-of select="$bwStr-exSu-False"/></label>
                <em><xsl:copy-of select="$bwStr-exSu-DefaultTrue "/></em>
              </div>
            </li>
            <li>
              <div class="bwExpOptionName"><xsl:copy-of select="$bwStr-exSu-DisplayTime"/></div>
              <div class="bwExpOptionFields">
                <input type="radio" id="bwJsDisplayTimeTrue" name="jsDisplayTime" onclick="updateUrlDisplay();" value="true" checked="checked"/>
                <label for="bwJsDisplayTimeTrue"><xsl:copy-of select="$bwStr-exSu-True"/></label>
                <input type="radio" id="bwJsDisplayTimeFalse" name="jsDisplayTime" onclick="updateUrlDisplay();" value="false"/>
                <label for="bwJsDisplayTimeFalse"><xsl:copy-of select="$bwStr-exSu-False"/></label>
                <em><xsl:copy-of select="$bwStr-exSu-DefaultTrue "/></em>
              </div>
            </li>
            <li>
              <div class="bwExpOptionName"><xsl:copy-of select="$bwStr-exSu-DisplayLocation"/></div>
              <div class="bwExpOptionFields">
                <input type="radio" id="bwJsDisplayLocationTrue" name="jsDisplayLocation" onclick="updateUrlDisplay();" value="true"/>
                <label for="bwJsDisplayLocationTrue"><xsl:copy-of select="$bwStr-exSu-True"/></label>
                <input type="radio" id="bwJsDisplayLocationFalse" name="jsDisplayLocation" onclick="updateUrlDisplay();" value="false" checked="checked"/>
                <label for="bwJsDisplayLocationFalse"><xsl:copy-of select="$bwStr-exSu-False"/></label>
                <em><xsl:copy-of select="$bwStr-exSu-DefaultFalse "/></em>
              </div>
            </li>
            <!--
            <li>
              <div class="bwExpOptionName"><xsl:copy-of select="$bwStr-exSu-DisplayDetailsInline"/></div>
              <div class="bwExpOptionFields">
                <input type="radio" id="bwJsDisplayInlineTrue" class="bwExpTrigger" name="jsDisplayInline" onclick="updateUrlDisplay();" value="true"/><xsl:copy-of select="$bwStr-exSu-True"/>
                <input type="radio" id="bwJsDisplayInlineFalse" class="bwExpTrigger" name="jsDisplayInline" onclick="updateUrlDisplay();" value="false" checked="checked"/><xsl:copy-of select="$bwStr-exSu-False"/>
                <em><xsl:copy-of select="$bwStr-exSu-DefaultFalse "/></em>
              </div>

              <ul id="bwJsWidgetOptionsInline">
                <li>
                  <div class="bwExpOptionName"><xsl:copy-of select="$bwStr-exSu-DisplayContact"/></div>
                  <div class="bwExpOptionFields">
                    <input type="radio" id="bwJsDisplayContactInDetailsTrue" name="jsDisplayContactInDetails" onclick="updateUrlDisplay();" value="true" checked="checked"/><xsl:copy-of select="$bwStr-exSu-True"/>
                    <input type="radio" id="bwJsDisplayContactInDetailsFalse" name="jsDisplayContactInDetails" onclick="updateUrlDisplay();" value="false"/><xsl:copy-of select="$bwStr-exSu-False"/>
                    <em><xsl:copy-of select="$bwStr-exSu-DefaultTrue "/></em>
                  </div>
                </li>
                <li>
                  <div class="bwExpOptionName"<xsl:copy-of select="$bwStr-exSu-DisplayCost"/></div>
                  <div class="bwExpOptionFields">
                    <input type="radio" id="bwJsDisplayCostInDetailsTrue" name="jsDisplayCostInDetails" onclick="updateUrlDisplay();" value="true" checked="checked"/><xsl:copy-of select="$bwStr-exSu-True"/>
                    <input type="radio" id="bwJsDisplayCostInDetailsFalse" name="jsDisplayCostInDetails" onclick="updateUrlDisplay();" value="false"/><xsl:copy-of select="$bwStr-exSu-False"/>
                    <em><xsl:copy-of select="$bwStr-exSu-DefaultTrue "/></em>
                  </div>
                </li>
                <li>
                  <div class="bwExpOptionName"><xsl:copy-of select="$bwStr-exSu-DisplayTags"/></div>
                  <div class="bwExpOptionFields">
                    <input type="radio" id="bwJsDisplayTagsTrue" name="jsDisplayTags" onclick="updateUrlDisplay();" value="true" checked="checked"/><xsl:copy-of select="$bwStr-exSu-True"/>
                    <input type="radio" id="bwJsDisplayTagsFalse" name="jsDisplayTags" onclick="updateUrlDisplay();" value="false"/><xsl:copy-of select="$bwStr-exSu-False"/>
                    <em><xsl:copy-of select="$bwStr-exSu-DefaultTrue "/></em>
                  </div>
                </li>
                <li>
                  <div class="bwExpOptionName"><xsl:copy-of select="$bwStr-exSu-DisplayTimeZone"/></div>
                  <div class="bwExpOptionFields">
                    <input type="radio" id="bwJsDisplayTimezoneTrue" name="jsDisplayTimezone" onclick="updateUrlDisplay();" value="true" checked="checked"/><xsl:copy-of select="$bwStr-exSu-True"/>
                    <input type="radio" id="bwJsDisplayTimezoneFalse" name="jsDisplayTimezone" onclick="updateUrlDisplay();" value="false"/><xsl:copy-of select="$bwStr-exSu-False"/>
                    <em><xsl:copy-of select="$bwStr-exSu-DefaultTrue "/></em>
                  </div>
                </li>
              </ul>
            </li>
            -->
          </ul>
        </fieldset>
      </div>
      <!--END JSON WIDGET OPTIONS -->

      <div id="bwExpURL">
        <p class="bwExpOutput">
          <xsl:copy-of select="$bwStr-exSu-URL"/>
          <a href="" id="bwExpUrlBox" target="_blank"><xsl:text>URL</xsl:text></a>
        </p>
      </div>

      <div id="bwExpCodeBox">
        <p class="bwExpOutput"><xsl:copy-of select="$bwStr-exSu-WidgetCode"/></p>
        <div id="bwExpCodeBoxOutput"><xsl:text> </xsl:text></div>
      </div>
    </div>

    <!-- setup the trigger actions -->
    <script type="text/javascript">
      $(document).ready(function(){
        // hide components:
        $('#bwExpCodeBox').hide();
        $('#bwHtmlListOptions').hide();
        $('#bwExpJsWidgetOptions').hide();
        $('#bwExpWidgetLimit').hide();
        $('#bwJsWidgetOptionsInline').hide();

        $(".bwExpTrigger").click(function() {
          switch ($(this).val()) {
            case "feed":
              $('#bwExpDataFormat').show('fast');
              $('#bwExpURL').show('fast');
              $('#bwExpCodeBox').hide('fast');
              $('#bwExpJsWidgetOptions').hide('fast');
              break;
            case "widget":
              $('#bwExpDataFormat').hide('fast');
              $('#bwExpURL').hide('fast');
              $('#bwExpCodeBox').show('fast');
              $('#bwExpJsWidgetOptions').show('fast');
              break;
            default:
              // show/hide widget options:
              if ($('#bwExpJsDisplayInlineTrue').prop('checked')) {
                $('#bwExpJsWidgetOptionsInline').show();
              } else {
                $('#bwExpJsWidgetOptionsInline').hide();
              }

              if ($('#bwExpJsShowTitleTrue').prop('checked')) {
                $('#bwExpJsSetTitle').show();
              } else {
                $('#bwExpJsSetTitle').hide();
              }

              if ($('#bwJsDisplayInlineTrue').prop('checked')) {
                $('#bwJsWidgetOptionsInline').show();
              } else {
                $('#bwJsWidgetOptionsInline').hide();
              }

              if ($('#bwExpJsShowLimitListTrue').prop('checked')) {
                $('#bwExpWidgetLimit').show();
              } else {
                $('#bwExpWidgetLimit').hide();
              }
          }
        });

        $(".bwExpDfTrigger").click(function() {
          // show/hide html list options
          if ($('#bwExpHtml').prop('checked')) {
            $('#bwHtmlListOptions').show();
          } else {
            $('#bwHtmlListOptions').hide();
          }
        });
      });
    </script>
  </xsl:template>

</xsl:stylesheet>
