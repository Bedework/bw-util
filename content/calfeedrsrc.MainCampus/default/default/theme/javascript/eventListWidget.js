//
//  Licensed to Jasig under one or more contributor license
//  agreements. See the NOTICE file distributed with this work
//  for additional information regarding copyright ownership.
//  Jasig licenses this file to you under the Apache License,
//  Version 2.0 (the "License"); you may not use this file
//  except in compliance with the License. You may obtain a
//  copy of the License at:
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing,
//  software distributed under the License is distributed on
//  an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
//  KIND, either express or implied. See the License for the
// specific language governing permissions and limitations
// under the License.
//

/* Insert Bedework calendar events list from a json feed.

 NOTE: No jQuery or other library dependencies should be used in this file
 because it is used both by the public Bedework web client and
 by javascript widgets embedded on other sites. It should stand alone.

 */

function insertBwEvents(outputContainerID,bwObject,options) {
  var outputContainer = document.getElementById(outputContainerID);
  var output = "";
  var eventlist = new Array();
  var eventIndex = 0;
  var bwListOptions;

  var defaults = {
    title: 'Upcoming Events',
    showTitle: true,
    showCount: true,
    displayDescription: false,
    calendarServer: '',
    calSuiteContext: '/cal',
    listMode: 'byTitle', // values: 'byDate' or 'byTitle' - highlights the date or title first (sort is always by date)
    displayDayNameInList: false, // display Monday, Tuesday, Wednesday, etc.
    displayDayNameTruncated: true, // shorten day names to three characters 'Mon','Tue','Wed' etc
    displayEndDateInList: true,
    suppressStartDateInList: false,
    suppressEndDateInList: false,
    untilText: 'Ends',
    displayTimeInList: true,
    displayLocationInList: false,
    locationTitle: 'Location:',
    displayTopicalAreasInList: false,
    topicalAreasTitle: 'Topical Areas:',
    displayThumbnailInList: false,
    thumbWidth: 80,
    useFullImageThumbs: true,
    usePlaceholderThumb: false,
    eventImagePrefix: '/pubcaldav',
    resourcesRoot: '',
    displayEventDetailsInline: false,
    displayContactInDetails: true,
    displayCostInDetails: true,
    displayTagsInDetails: true,
    displayTimezoneInDetails: true,
    displayNoEventText: true,
    showTitleWhenNoEvents: true,
    noEventsText: 'No events to display',
    limitList: false,
    limit: 5
  };

  // merge in user-defined options
  if (typeof options == "object") {
    for(var key in options) {
      if(options.hasOwnProperty(key))
        defaults[key] = options[key];
    }
  }

  bwListOptions = defaults;


  // Check first to see if whe have events:
  if ((bwObject == undefined) ||
      (bwObject.bwEventList == undefined) ||
      (bwObject.bwEventList.events == undefined) ||
      (bwObject.bwEventList.events.length == 0)) {

    if (bwListOptions.showTitleWhenNoEvents) {
      output += "<h3 class=\"bwEventsTitle\">" + bwListOptions.title + "</h3>";
    }
    if (bwListOptions.displayNoEventText) {
      output += "<ul class=\"bwEventList\"><li>" + bwListOptions.noEventsText + "</li></ul>";
    }

  } else {
    // get events
    for (i = 0; i < bwObject.bwEventList.events.length; i++) {
      eventlist[eventIndex] = i;
      eventIndex++;
    }

    // GENERATE OUTPUT
    // This is where you may wish to customize the output.  To see what
    // fields are available for events, look at the json source file included
    // by the widget code.  The core formatting is done in formatDateTime()
    // and formatSummary()

    // The title is included because you may wish to hide it when
    // no events are present.
    if (bwListOptions.showTitle) {
      output += "<h3 class=\"bwEventsTitle\">";
      if (bwListOptions.showCaret) {
        output += "<span class=\"caret caret-right\"> </span>";
      }
      output += bwListOptions.title;
      if (bwListOptions.showCount) {
        output += " <span class=\"bwEventsCount\">(" + bwObject.bwEventList.resultSize + ")</span>";
      }
      output += "</h3>";
    }

    // Output the list
    output += "<ul class=\"bwEventList\">";

    // Now, iterate over the events:
    for(var i in eventlist){
      // stop if we've reached a limit on the number of events
      if(bwListOptions.limitList && bwListOptions.limit == i) {
        break;
      }

      // provide a shorthand reference to the event:
      var event = bwObject.bwEventList.events[eventlist[i]];

      // create the list item:
      if (event.status == "CANCELLED") {
        output += '<li class="bwStatusCancelled">';
      } else if (event.status == "TENTATIVE") {
        output += '<li class="bwStatusTentative">';
      } else {
        output += "<li>";
      }

      // event thumbnail
      if (bwListOptions.displayThumbnailInList) {
        output += formatBwThumbnail(event,bwListOptions);
      }

      // output date and summary either byDate first or byTitle first
      if (bwListOptions.listMode == 'byDate') {
        output += formatBwDateTime(event,bwListOptions);
        output += "<br/>"
        output += formatBwSummary(event,outputContainerID,i,bwListOptions);
      } else {
        output += formatBwSummary(event,outputContainerID,i,bwListOptions);
        output += "<br/>"
        output += formatBwDateTime(event,bwListOptions);
      }

      // add locations
      if (bwListOptions.displayLocationInList) {
        output += "<div class=\"bwLoc\">";
        output += "<span class=\"bwLocTitle\">" + bwListOptions.locationTitle + "</span> ";
        output += event.location.address + "</div>";
      }

      // add full description
      if (bwListOptions.displayDescription) {
        output += "<div class=\"bwEventDescription\"><p>";
        output += event.description.replace(/\n/g,'<br />');
        output += "</p></div>";
      }

      // add topical areas
      if (bwListOptions.displayTopicalAreasInList) {
        output += "<div class=\"bwTopicalAreas\">";
        output += "<span class=\"bwTaTitle\">" + bwListOptions.topicalAreasTitle + "</span> ";
        // iterate over the x-properties and pull out the aliases
        for (var j in event.xproperties) {
          if (event.xproperties[j]["X-BEDEWORK-ALIAS"] != undefined) {
            if (event.xproperties[j]["X-BEDEWORK-ALIAS"].parameters["X-BEDEWORK-PARAM-DISPLAYNAME"] != undefined) {
              output +=  event.xproperties[j]["X-BEDEWORK-ALIAS"].parameters["X-BEDEWORK-PARAM-DISPLAYNAME"];
              output += ", ";
            }
          }
        }
        // trim off the final ", " if we have one
        if (output.substr(output.length-2) == ", ") {
          output = output.substr(0,output.length-2);
        }
        output += "</div>";
      }
      output += "</li>";
    }
    output += "</ul>";
  }
  // Finally, send the output to the container:
  outputContainer.innerHTML = output;
}

function formatBwThumbnail(event,bwListOptions) {

  var output = "";
  var bwEventLink = "";
  var imgPrefix = "";
  var imgSrc = "";
  var imgObj;
  var thumbObj;

  // iterate over the x-properties to see if we have an image or a thumbnail
  for (var i in event.xproperties) {
    if (event.xproperties[i]["X-BEDEWORK-THUMB-IMAGE"] != undefined) {
      thumbObj = event.xproperties[i]["X-BEDEWORK-THUMB-IMAGE"];
    }
    if (event.xproperties[i]["X-BEDEWORK-IMAGE"] != undefined) {
      imgObj = event.xproperties[i]["X-BEDEWORK-IMAGE"];
    }
  }

  if (thumbObj != undefined) {
    // use the thumbnail image
    if (!thumbObj.values.text.startsWith('http')) {
      imgPrefix = bwListOptions.eventImagePrefix;
    }
    imgSrc = imgThumbPrefix + thumbObj.values.text;
  } else if (imgObj != undefined && bwListOptions.useFullImageThumbs) {
    // use the full image for thumbnail
    if (!imgObj.values.text.startsWith('http')) {
      imgPrefix = bwListOptions.eventImagePrefix;
    }
    imgSrc = imgPrefix + imgObj.values.text;
  } else if(bwListOptions.usePlaceholderThumb) {
    // use a placeholder thumbnail
    imgSrc = bwListOptions.resourcesRoot + "/images/placeholder.png";
  }

  // did we end up with an image?
  if (imgSrc != "") {
    bwEventLink = getBwEventLink(event,bwListOptions);
    output += "<a href=\"" + bwEventLink + "\">";
    output += "<img class=\"eventThumb img-responsive\" width=\"" + bwListOptions.thumbWidth + "\" src=\"" + imgSrc + "\" alt=\" + event.summary + \"/>";
    output += "</a>";
  }

  return output;
}

function formatBwDateTime(event,bwListOptions) {

  var output = "";
  output += "<span class=\"bwDateTime\">";

  if (bwListOptions.listMode == 'byDate') {
    output +="<strong>";
  }

  if (!bwListOptions.suppressStartDateInList) {
    // display the start date
    if (bwListOptions.displayDayNameInList) {
      if (bwListOptions.displayDayNameTruncated) {
        output += event.start.dayname.substr(0,3);
      } else {
        output += event.start.dayname;
      }
      output += ", ";
    }

    output += event.start.longdate;
    if ((event.start.allday == 'false') && bwListOptions.displayTimeInList) {
      output += " " + event.start.time;
    }
  }
  if (!bwListOptions.suppressEndDateInList) {
    if(bwListOptions.suppressStartDateInList) {
      output += bwListOptions.untilText + " ";
    }
    if (bwListOptions.displayEndDateInList) {
      if (event.start.shortdate != event.end.shortdate || bwListOptions.suppressStartDateInList) {
        if(!bwListOptions.suppressStartDateInList) {
          output += " - ";
        }
        if (bwListOptions.displayDayNameInList) {
          if (bwListOptions.displayDayNameTruncated) {
            output += event.end.dayname.substr(0,3);
          } else {
            output += event.end.dayname;
          }
          output += ", ";
        }
        output += event.end.longdate;
        if ((event.start.allday == 'false') && bwListOptions.displayTimeInList) {
          output += " " + event.end.time;
        }
      } else if ((event.start.allday == 'false') &&
          bwListOptions.displayTimeInList &&
          (event.start.time != event.end.time)) {
        // same date, different times
        output += " - " + event.end.time;
      }
    }
  }

  if (bwListOptions.listMode == 'byDate') {
    output +="</strong>";
  }
  output += "</span>";

  return output;
}

function formatBwSummary(event,outputContainerID,i,bwListOptions) {

  var output = "";
  output += "<span class=\"bwSummary\">";

  if (bwListOptions.listMode == 'byTitle') {
    output +="<strong>";
  }

  if (bwListOptions.displayEventDetailsInline) {
    // don't link back to the calendar - display event details in the widget
    output += "<a href=\"javascript:showBwEvent('" + outputContainerID + "'," + i + ");\">" + event.summary + "</a>";

  } else {
    // link back to the calendar
    var bwEventLink = getBwEventLink(event,bwListOptions);

    output += "<a href=\"" + bwEventLink + "\">" + event.summary + "</a>";
  }

  if (bwListOptions.listMode == 'byTitle') {
    output +="</strong>";
  }
  output += "</span>";

  return output;
}

function getBwEventLink(event,bwListOptions) {

  // Include the urlPrefix for links back to events in the calendar.
  var urlPrefix = bwListOptions.calendarServer + bwListOptions.calSuiteContext + "/event/eventView.do";

  // generate the query string parameters that get us back to the
  // event in the calendar:
  var eventQueryString = "?subid=" + event.subscriptionId;
  eventQueryString += "&amp;calPath=" + event.calPath;
  eventQueryString += "&amp;guid=" + event.guid;
  eventQueryString += "&amp;recurrenceId=" + event.recurrenceId;

  return urlPrefix + eventQueryString;
}

/* Display an event inline: DEPRECATED */
function showBwEvent(outputContainerID,eventId,displayContact,displayCost,displayTags,displayTimezone) {
  // Style further with CSS

  // Rudimentary options (this should be improved by turning the entire list
  // into an object with a method to get the options.  This will do for now.)
  var displayContactInDetails = true;
  var displayCostInDetails = true;
  var displayTagsInDetails = true;
  var displayTimezoneInDetails = true;

  if (displayContact != undefined && displayContact.length) displayContactInDetails = displayContact;
  if (displayCost != undefined && displayCost.length) displayCostInDetails = displayCost;
  if (displayTags != undefined && displayTags.length) displayTagsInDetails = displayTags;
  if (displayTimezone != undefined && displayTimezone.length) displayTimezoneInDetails = displayTimezone;

  var outputContainer = document.getElementById(outputContainerID);
  var output = "";
  // provide a shorthand reference to the event:
  var event = bwObject.bwEventList.events[eventId];

  // create the event
  output += "<h3 class=\"bwEventsTitle\">" + event.summary + "</h3>";

  output += "<div class=\"bwEventLogistics\">";

  // output date/time
  output += "<div class=\"bwEventDateTime\">";
  output += event.start.longdate;
  if (event.start.allday == 'false') {
    output += " " + event.start.time;
    if ((event.start.timezone != event.end.timezone) && displayTimezoneInDetails) {
      output += " " + event.start.timezone;
    }
  }
  if (event.start.shortdate != event.end.shortdate) {
    output += " - ";
    output += event.end.longdate;
    if (event.start.allday == 'false') {
      output += " " + event.end.time;
      if (displayTimezoneInDetails) {
        output += " " + event.end.timezone;
      }
    }
  } else if ((event.start.allday == 'false') &&
      (event.start.time != event.end.time)) {
    // same date, different times
    output += " - " + event.end.time;
    if (displayTimezoneInDetails) {
      output += " " + event.end.timezone;
    }
  }
  output += "</div>";

  // output location
  output += "<div class=\"bwEventLoc\">";
  if (event.location.link != "") {
    output += "<a href=\""+ event.location.link + "\">" + event.location.address + "</a>";
  } else {
    output += event.location.address;
  }
  output += "</div>";

  // output description
  output += "<div class=\"bwEventDesc\">";
  output += event.description.replace(/\n/g,'<br />');
  output += "</div>";

  // output contact
  if (displayContactInDetails) {
    output += "<div class=\"bwEventContact\">";
    if (event.contact.link != "") {
      output += "Contact: <a href=\"" + event.contact.link + "\">" + event.contact.name + "</a>";
    } else {
      output += "Contact: " + event.contact.name;
    }
    output += "</div>";
  }

  // output cost
  if (event.cost != "" && displayCostInDetails) {
    output += "<div class=\"bwEventCost\">";
    output += "Cost: " + event.cost;
    output += "</div>";
  }

  // output tags (categories)
  if (event.categories != "" && displayTagsInDetails) {
    output += "<div class=\"bwEventCats\">";
    output += "Tags: " + event.categories;
    output += "</div>";
  }

  // output link
  if (event.link != "") {
    output += "<div class=\"bwEventLink\">";
    output += "See: <a href=\"" + event.link + "\">" + event.link + "</a>";
    output += "</div>";
  }
  output += "</div>";

  // create a link back to the main view
  output += "<p class=\"bwEventsListLink\"><a href=\"javascript:insertBwEvents('" + outputContainerID + "')\">Return</a>";

  // Send the output to the container:
  outputContainer.innerHTML = output;
}