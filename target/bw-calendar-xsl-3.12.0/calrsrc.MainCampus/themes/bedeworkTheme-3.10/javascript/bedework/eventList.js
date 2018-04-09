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


// Bedework Event List

/* An event list - for use in the Bedework Public Client
 * outputContainerId    String - id of output container
 * dataType             String - the kind of widget we are requesting,
 *                               either "html" or "json".
 *
 *    If json, additional formatting options (beyond those set in
 *    the themeSettings.xsl file) can be supplied when the list object
 *    is created. Json formatting and options are defined at the bottom
 *    of this file in the insertBwEvents() function.
 *
 *    If html, formatting options are set only by the themeSettings.xsl file,
 *    and formatting is defined in the widgetEventList.xsl file.
 *
 * options              Object - json list of options for display
 *                               (can be empty for html dataType)
 *
 * startDate            String - the initial start date for the list - passed
 *                               in from Bedework global state to more easily
 *                               move between list and day/week/month views
 * filterPrefix         String - pass in any fexpr filters when first creating
 *                               the object, esp. the ongoing events expression
 * filterPaths          Array  - 2D array of existing filter paths from which we
 *                               build a filter expression on first load - for
 *                               maintaining state if they already exist
 * query                String - pass in an existing query string if it exists
 * fetchUri             URI    - the URI for the primary ajax request
 * fetchNextUri         URI    - the URI to fetch the next page of event via ajax
 *
 *    The fetchUri and fetchNextUri values must be passed in - each list to be
 *    rendered must use its own back-end client, and you must create new paths
 *    in the web client's struts-config.xml file to create new clients (which
 *    requires a full rebuild).  At this time, only the main listing and the
 *    ongoing lists are supported.  We hope to make this more flexible in time.
 *
 * htmlDateContainerId  String - id of container for display of starting date at
 *                               the top of the html list; we get the fully
 *                               internationalized start date from the Bedework
 *                               back-end.
 * htmlCountContainerId String - id of container to display number of events returned
 */
function BwEventList(outputContainerID,dataType,options,startDate,filterPrefix,filterPaths,query,fetchUri,fetchNextUri,htmlDateContainerId,htmlCountContainerId,eventCount) {
  this.outputContainerId = outputContainerID;
  this.dataType = dataType;
  this.options = options;
  this.startDate = startDate;
  this.fetchUri = fetchUri;
  this.fetchNextUri = fetchNextUri;
  this.htmlDateContainerId = htmlDateContainerId;
  this.htmlCountContainerId = htmlCountContainerId;
  this.skinName = "widget-html";
  this.events = "";
  this.fexprPrefix = filterPrefix;
  this.filterPaths = filterPaths;
  this.query = query;
  this.fexprSuffix = "(entity_type=\"event\"|entity_type=\"todo\")";
  this.fexpr = "";
  this.eventCount = eventCount;

  if (this.dataType == "json") {
    this.skinName = "widget-json-eventList";
  }

  /* Build the filter expression
   * filters:    an array of arrays - one array of paths for each filter set
   * operation:  string - "AND" or "OR" for combining the filter sets
   */
  this.getFilterExpression = function(filters,operation) {

    var fexpr = "";
    var filtersExist = false;
    var innerFilters = "";

    // if we've been passed filters, build the inner filter expression
    if (filters.length) { // we've got a 2D array

      /* Is our 2D array a set of empty arrays? */
      for (i=0; i < filters.length; i++) {
        if(filters[i].length) {
          filtersExist = true;
          break;
        }
      }

      if (filtersExist) {
        var op = "";
        innerFilters += "(";
        $.each(filters, function (i, value) {
          if (filters[i].length) { // does the array have anything in it?
            innerFilters += op + "(";

            op = " and "; // default operation between filter sets
            if (operation == "or") {
              op = " or ";
            }

            orOp = "";
            $.each(filters[i], function (j, value) {
              innerFilters += orOp + "(vpath=\"" + value + "\")";
              orOp = " or ";
            });
            innerFilters += ")";

          }
        });
        innerFilters += ")";
      }
    }

    // Build the full filter expression:
    // include the default filter prefix only if no query or filters exist
    if (this.fexprPrefix != "" && this.query == "" && !filtersExist) {
      fexpr += this.fexprPrefix + " and ";
    }
    if (filtersExist) {
      fexpr += innerFilters + " and ";
    }
    fexpr += this.fexprSuffix;

    return fexpr;
  }

  this.fexpr = this.getFilterExpression(this.filterPaths);

  // build the request data
  this.requestData = {
    skinNameSticky: this.skinName,
    start: this.startDate,
    sort: "dtstart.utc:asc",
    listMode: "true",
    fexpr: this.fexpr,
    setappvar: "navDate(" + this.startDate + ")",
    count: this.eventCount
  };

  // add the query if it exists
  if (this.query != "") {
    this.requestData["query"] = this.query;
  }

  this.display = function() {
    var me = this;

    /* start the spinner */
    var spinnerId = "bwSpinner" + this.outputContainerId;
    var spinnerDiv = '<div id="' + spinnerId + '"></div>';
    $("body").append(spinnerDiv);
    var bwSpinnerTarget = document.getElementById(spinnerId);
    var bwSpinner = new Spinner(this.bwSpinnerOpts).spin(bwSpinnerTarget);

    $.ajax({
      url: this.fetchUri,
      data: this.requestData,
      type: "POST",
      dataType: this.dataType
    })
    .done(function(eventListObject) {
      me.setEvents(eventListObject);
      me.render();
    })
    .always(function () {
      bwSpinner.stop();
    });
  }

  this.displayCount = function(countOutputId) {
    var list = this.events.bwEventList;
    //if ((list != undefined) && (list.resultSize != undefined)) {
      $(countOutputId).html("(" + list.resultSize + ")");
    //}
  }

  this.setEvents = function(eventsObj) {
    this.events = eventsObj;
  }

  this.appendEvents = function(dateSeparator) {
    // this is done synchronously to avoid race conditions
    var me = this;
    var appendReqData = this.requestData;
    appendReqData.next = "next";
    appendReqData.setappvar = "lastDateSeparatorInList(" + dateSeparator + ")";

    /* start the spinner */
    var spinnerId = "bwSpinner" + this.outputContainerId;
    var spinnerDiv = '<div id="' + spinnerId + '"></div>';
    $("body").append(spinnerDiv);
    var bwSpinnerTarget = document.getElementById(spinnerId);
    var bwSpinner = new Spinner(this.bwSpinnerOpts).spin(bwSpinnerTarget);

    $.ajax({
      url: this.fetchNextUri,
      data: appendReqData,
      type: "POST",
      async: false,
      dataType: this.dataType
    })
    .done(function(eventListObject) {
      me.setEvents(eventListObject);
      me.render("append");
    })
    .always(function () {
      bwSpinner.stop();
    });
  }

  this.setRequestData = function(key,val) {
    this.requestData[key] = val;
  }

  this.setFexprPrefix = function(val) {
    this.fexprPrefix = val;
  }

  this.getFexprPrefix = function() {
    return this.fexprPrefix;
  }

  this.setFexprSuffix = function(val) {
    this.fexprSuffix = val;
  }

  this.getFexprSuffix = function() {
    return this.fexprSuffix;
  }

  this.setQuery = function(val) {
    this.query = val;
  }

  this.getQuery = function() {
    return this.query;
  }

  /* action - optional string representing the kind of render we want.
              Values are "append" or "replace" (default action if not supplied) */
  this.render = function(action) {
    if (this.dataType == "html") {
      // we have an html data island
      insertBwHtmlEvents(this.outputContainerId,this.htmlDateContainerId,htmlCountContainerId,this.events,action);
    } else {
      // we have a json object - pass along javascript options and render it
      insertBwEvents(this.outputContainerId,this.events,this.options,action);
    }
  }

  this.bwSpinnerOpts = {
    lines: 13, // The number of lines to draw
    length: 20, // The length of each line
    width: 8, // The line thickness
    radius: 20, // The radius of the inner circle
    corners: 0.4, // Corner roundness (0..1)
    rotate: 0, // The rotation offset
    direction: 1, // 1: clockwise, -1: counterclockwise
    color: '#9FC6E2', // #rgb or #rrggbb or array of colors
    speed: 1.2, // Rounds per second
    trail: 60, // Afterglow percentage
    shadow: false, // Whether to render a shadow
    hwaccel: false, // Whether to use hardware acceleration
    className: 'spinner', // The CSS class to assign to the spinner
    zIndex: 100 // The z-index (defaults to 2000000000)
  };

}

/* Insert Bedework calendar events list from an HTML data island.
   We simply embed what the server provides as a raw HTML widget.
   Includes social media icons and internationalization strings.
   ThemeSettings options are honored on the server before being delivered,
   although a few strings are passed into JavaScript variables in themeSettings.xsl
   for use below. */
function insertBwHtmlEvents(outputContainerID,dateContainerId,countContainerId,bwObject,action) {
  var outputContainer = document.getElementById(outputContainerID);
  var eventList = $(bwObject).find("div.bwWidgetBody");
  // Send the html object to the container:
  if (action == "append") {
    $(outputContainer).append(eventList);
  } else {
    // Full replacement
    $(outputContainer).html(eventList);
    // Set the starting date above the list
    var displayDate = $(bwObject).find("div.bwWidgetGlobals ul.bwwgCurrentDate li.bwwgCdLongDate").html();
    $("#" + dateContainerId).html(displayDate);
    var resultSize = $(bwObject).find("div.bwWidgetHeader span.bwwhResultSize").html();
    var resultSizeInt = Number(resultSize);
    var eventStr = bwStrEvents; // bwStrEvent comes from themeSettings.xsl
    if (resultSizeInt == 1) {
      eventStr = bwStrEvent;
    }
    $("#" + countContainerId).html(resultSize + " " + eventStr);
    $("#" + countContainerId).show();
  }
  // add a click handler for events in the list so that the entire event element
  // is clickable - this is particularly good for touch screens
  $(outputContainer).on("click", ".eventListContent", bwListedEventClickHandler);
}

function insertBwEvents(outputContainerID,bwObject,options,action) {
  var outputContainer = document.getElementById(outputContainerID);
  var output = "";
  var eventlist = new Array();
  var eventIndex = 0;
  var bwListOptions;

  var defaults = {
    title: 'Upcoming Events',
    showTitle: true,
    showCount: true,
    showCaret: false, // when true, a caret will appear to the left of the title, and the title will become a toggleable link
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
      if (bwListOptions.displayLocationInList && event.location.address != 'deleted') {
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
  if (action == "append") {
    $(outputContainer).append(output);
  } else {
    outputContainer.innerHTML = output;
  }

  if (bwListOptions.showCaret) {
    /* Add the click handler to filters that are generated on first page load.  */
    $("#ongoing").on("click", ".bwEventsTitle", bwOngoingClickHandler);
  }
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
    output += "<a href=\"" + bwEventLink + "\" class=\"eventThumbLink\">";
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
  eventQueryString += "&amp;href=" + event.encodedHref;
  //eventQueryString += "&amp;guid=" + event.guid;
  //eventQueryString += "&amp;recurrenceId=" + event.recurrenceId;

  return urlPrefix + eventQueryString;
}


function setBwContinueFromMarkup(outputId,continueText,continueDate,todayText,todayDate) {
  var continueFromMarkup = "";
  continueFromMarkup += '<a href="' + bwUrls.setSelectionList + '&amp;start=' + continueDate + '&amp;listMode=true&amp;setappvar=navDate(' + continueDate + ')">';
  continueFromMarkup += continueText + ' ' + continueDate;
  continueFromMarkup += '</a> | ';
  continueFromMarkup += '<a href="' +  bwUrls.setSelectionList + '&amp;start=' + todayDate + '&amp;listMode=true&amp;setappvar=navDate(' + todayDate + ')">';
  continueFromMarkup += todayText;
  continueFromMarkup += '</a>';
  $(outputId).html(continueFromMarkup).removeClass("invisible");

}
