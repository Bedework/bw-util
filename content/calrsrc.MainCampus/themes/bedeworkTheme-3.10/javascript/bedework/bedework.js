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

/* javascript debugging switch for Bedework Public Client.  When true,
   debugging statements will be placed in console.log. If no console is
   available, force debugging off so we don't do any debug processing at all. */
var bwJsDebug = true;
if (!window.console) {
  bwJsDebug = false;
}

// Maintain a global variable determining the state of phone-sized layouts.
// Menus will have added behaviors in tiny mode.
var isTiny = false;
if (window.innerWidth < 768) {
  isTiny = true;
}

function changeClass(id, newClass) {
  identity = document.getElementById(id);
  identity.className=newClass;
}

function toggleVisibility(id) {
  var item = document.getElementById(id);
  if ( item.style.display != 'none' ) {
    item.style.display = 'none';
  }
  else {
    item.style.display = '';
  }
  return false;
}
function replaceAddressWithEventUrl(action,href) {
  var eventUrl = action + '&href=' + href;
  window.history.replaceState({}, null, eventUrl);
}
function fillExportFields(formObj) {
  var startDate = new Date();
  startDate = $("bwExportCalendarWidgetStartDate").datepicker("getDate");
  formObj["eventStartDate.year"].value = startDate.getFullYear();
  formObj["eventStartDate.month"].value = startDate.getMonth() + 1;
  formObj["eventStartDate.day"].value = startDate.getDate();

  var endDate = new Date();
  endDate = $("bwExportCalendarWidgetEndDate").datepicker("getDate");
  formObj["eventEndDate.year"].value = endDate.getFullYear();
  formObj["eventEndDate.month"].value = endDate.getMonth() + 1;
  formObj["eventEndDate.day"].value = endDate.getDate();
}
function showLink(urlString,title) {
  var linkWindow = window.open("", "linkWindow", "width=1100,height=100,scrollbars=yes,resizable=yes,alwaysRaised=yes,menubar=no,toolbar=no");
  linkWindow.document.open();
  linkWindow.document.writeln('<html><head><title>' + title + '</title>');
  linkWindow.document.writeln('<style type="text/css">body{padding: 1em; font-size: 12px; font-family: Arial,sans-serif;}th{text-align: left;}td{padding-left: 2em;}</style></head>');
  linkWindow.document.writeln('<body onload="document.getElementById(\'linkField\').select()"><strong>' + title + '</strong><br/>');
  linkWindow.document.writeln('<input type="text" value="' + urlString + '" size="170" id="linkField"/>');
  linkWindow.document.writeln('</body></html>');
  linkWindow.document.close();
  linkWindow.focus();
}
function sortList(list) {
  $(list).children("li").sort(function(a, b) {
    var x = $(a).find('a').text().toUpperCase();
    var y = $(b).find('a').text().toUpperCase();
    return (x < y) ? -1 : (x > y) ? 1 : 0;
  }).appendTo(list);
}
// add some resize handling
$(document).ready(function(){

  window.onresize = function () {
    // force show or hide of menus if a browser is scaled
    // between mobile and desktop sizes.  Required because the
    // user can toggle the menus, and we need to recover.
    if (window.innerWidth > 767) {
      isTiny = false;
      $("#bwDatePickerLinks").show();
      $("#bwBasicSearch").show();
      $("#bwViewList").show();
      $("#ongoing").show();
      $("#ongoing .bwEventList").show();
      $("#ongoing .bwEventsTitle .caret").removeClass("caret-right");
    }

    if (window.innerWidth < 768 && !isTiny) {
      isTiny = true;
      $("#bwDatePickerLinks").hide(100);
      $("#bwBasicSearch").hide(100);
      $("#bwViewList").hide(100);
      $("#ongoing").hide(100);
      $("#ongoing .bwEventsTitle .caret").addClass("caret-right");
    }
  };
});
