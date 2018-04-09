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

function changeClass(id, newClass) {
  identity = document.getElementById(id);
  identity.className=newClass;
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
function displayView(action,view) {
  var fexpr = '&fexpr=(view="' + view + '")';
  var appvar = "&setappvar=curView(" + view + ")&setappvar=curCollection()";
  location.href = action + fexpr + appvar;
}
function displayCal(action,vpath,cal) {
  var fexpr = '&fexpr=(vpath="' + vpath + '")';
  var appvar = "&setappvar=curCollection(" + cal + ")&setappvar=curView()";
  location.href = action + fexpr + appvar;
}