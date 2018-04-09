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

/* DEPRECATED - now using the jQuery UI's built in Autocomplete 
 * See: bedeworkScheduling.js
 */

var bwAutoCompleteOptions = {
  minChars: 0,
  width: 310,
  matchContains: false,
  autoFill: false,

  extraParams: {
    format: 'json',
    addrbook: function() { return $("#bwCardDavBookPath").val(); }
  },

  dataType: 'json',

  /* override the parse function to map
     our carddav json object to the expected data
     structure for use with autocomplete */
  parse: function(data) {
    var parsed = [];
    if (data.microformats != undefined && data.microformats.vcard != undefined) {
      data = data.microformats.vcard;
      for (var i = 0; i < data.length; i++) {
        
        // pick out the best uri if one is available
        // caladruri is first choice, email second
        var cururi = "";
        if (data[i].caladruri != undefined && data[i].caladruri.value != undefined) {
          cururi = data[i].caladruri.value;
        }
        if (cururi == "" && data[i].email != undefined && data[i].email[0] != undefined && data[i].email[0].value != undefined) {
          var curEmail = data[i].email[0].value;
          if (curEmail != "") {
            cururi = "mailto:" + curEmail;
          }
        }      
        // check for the existence of fn
        var curfn = "";
        if (data[i].fn != undefined && data[i].fn.value != undefined) {
          curfn = data[i].fn.value;
        }
        
        // check for the existence of kind
        var curkind = "";
        if (data[i].kind != undefined && data[i].kind.value != undefined) {
          curkind = data[i].kind.value;
        }
        
        // skip if no uri 
        if (cururi != "") {
          dataRow = {
            fn: curfn,
            uri: cururi, 
            type: curkind
          };
          parsed[i] = {
            data: dataRow,
            value: curfn,
            result: cururi
          };
        }
      }
    }
    return parsed;
  },
  formatItem: function(item) {
      return " " + item.fn + " - " + item.uri.substring(7);
  },

  formatMatch: function(item) {
      return " " + item.fn + " - " + item.uri.substring(7);
  },
  formatResult: function(item) {
    return item.uri;
  }
};
