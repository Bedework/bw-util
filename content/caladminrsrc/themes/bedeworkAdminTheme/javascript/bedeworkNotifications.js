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

/**
 * Remove a notification from the notification menu.
 * @param {string} url              - The constructed URL including action and notification id.
 * @param {string} id               - Id of the notification in the DOM.
 * @param {boolean} isDirectRemove  - true if we should immediately hide the notification client-side;
 *                                    set to false (or don't supply) if we are launching another page.
 */
function bwRemoveNotification(url,id,isDirectRemove) {
  if(isDirectRemove) {
    // hide the removed link and decrease the notification count
    $("#" + id).hide();
    $(".notificationCount").text($("#notificationMessages li").filter(":visible").length);
  }
  $.ajax({
    type: "POST",
    url: url
  });

}