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

// populate timezone select boxes in event form
function setTimezones(timezones) {
  var tzList = timezones.split(/\n|\r/);
  tzList.sort();

  var defaultTzOptions = '<option value="-1">select timezone...</option>';

  // create the default options list
  for (i = 0; i < tzList.length; i++) {
    if (tzList[i] != "") {
      // defaultTzid is set in the xslt head
      if (defaultTzid == tzList[i]) {
        defaultTzOptions += '<option value="' + tzList[i] + '" selected="selected">' + tzList[i] + '</option>';
      } else {
        defaultTzOptions += '<option value="' + tzList[i] + '">' + tzList[i] + '</option>';
      }
    }
  }
  $('#defaultTzid').html(defaultTzOptions);
}

/* jQuery initialization */
// timezoneUrl supplied in bedework.js
jQuery(document).ready(function($) {
  // get the timezones from the timezone server
  $.ajax({
    type: "GET",
    url: timezoneUrl,
    dataType: "text",
    success: function(text){
      setTimezones(text);
    }
  });
});
