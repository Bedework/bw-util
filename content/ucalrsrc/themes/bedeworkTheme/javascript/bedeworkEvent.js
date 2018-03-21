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

// jQuery stuff for the detailed event view.
// These functions support edit and download menuing for recurring events.
// All recurring events have two actions: one that can be performed on the
// master event and one that can be performed on the instance.

$(document).ready(function() {

  // edit button
  $("#bwEditRecurButton").hover(
    function () {
      $("#bwEditRecurWidget").show();
    },
    function () {
      $("#bwEditRecurWidget").hide();
    }
  );

  // download button
  $("#bwDownloadButton").hover(
    function () {
      $("#bwDownloadWidget").show();
    },
    function () {
      $("#bwDownloadWidget").hide();
    }
  );

  // copy button
  $("#bwCopyRecurButton").hover(
    function () {
      $("#bwCopyRecurWidget").show();
    },
    function () {
      $("#bwCopyRecurWidget").hide();
    }
  );

  // delete button
  $("#bwDeleteRecurButton").hover(
    function () {
      $("#bwDeleteRecurWidget").show();
    },
    function () {
      $("#bwDeleteRecurWidget").hide();
    }
  );

  // link button
  $("#bwLinkRecurButton").hover(
    function () {
      $("#bwLinkRecurWidget").show();
    },
    function () {
      $("#bwLinkRecurWidget").hide();
    }
  );

});

