/*
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
*/

/* NOTE: this file is different between Bedework web applications and is
   therefore not currently interchangable between apps.  This will be normalized
   in the coming versions, but for now don't try to exchange them. */

// jQuery stuff for the calendar grid.
// These functions support contextual menus for events and day cells in the
// week and month calendar grids

$(document).ready(function() {

  // an active day in the calendar grid
  $("td.bwActiveDay").click (
    function (event) {
      // only activate if we've clicked the table cell itself
      var $targ = $(event.target);
      if ($targ.is("td")) {
        $(this).children("div").children("div.bwActionIcons").css({
          "left" : event.pageX,
          "top" : event.pageY
        });

        $(this).children("div").children("div.bwActionIcons").toggle();
      }
    }
  );

  // hover effects to auto-hide the action icons;
  // do this on both the actions and table cells.
  $("td.bwActiveDay").hover (
    function() {
      // do nothing on mouseover
    },
    function () {
      $("div.bwActionIcons").hide();
    }
  );
  $("div.bwActionIcons").hover (
    function() {
      // do nothing on mouseover
    },
    function () {
      $("div.bwActionIcons").hide();
    }
  );

  $("div.listAdd").hover (
    function () {
      $(this).children("div.bwActionIcons").show("fast");
    },
    function () {
      $(this).children("div.bwActionIcons").hide("fast");
    }
  );

  // EVENT MENUS and TOOLTIPS

  $("li.event").hover (
    function () {
      $(this).children("div.eventTip").show();
    },
    function () {
      $(this).children("div.eventTip").hide();
    }
  );

  $("div.eventTip").click (
    function () {
      $(this).slideUp("fast");
    }
  );


});

