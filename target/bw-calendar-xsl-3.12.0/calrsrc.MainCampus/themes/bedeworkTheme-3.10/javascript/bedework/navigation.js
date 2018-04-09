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

/* Bedework Calendar Subscription Explorer Navigation
   This assumes the existence of bwQuery, bwFilters, bwFilterPaths and
   other variables derived from Bedework's jsp/xml layer and established
   in head.xsl and bedework.js */

// NAVIGATIONAL ELEMENTS ACTIONS:
$(document).ready(function() {

  /* CALENDARS EXPLORER MENU
   * The click action for the navigation tree
   * for filtering the center event list.
   * This is fired when a user clicks a calendar in the explorer
   * navigation in the left column. */
  $(".bwMenuTree a").click(function (event) {
    event.preventDefault();
    var curFilter = $(this).attr("id");
    // get the index held in the ID and the name of the group:
    var navIndex = $(this).closest(".bwMenu").attr("id").slice(-1);
    var navName = $("#bwNav" + navIndex + " .bwMenuTitle").text().trim();
    var itemIndex = $.inArray(curFilter, bwFilters[navIndex]);
    if (bwJsDebug) {
      console.log("Nav index: " + navIndex);
      console.log("Nav name: " + navName);
      console.log("Item index: " + itemIndex);
      console.log("Item id: " + curFilter);
    }
    if (itemIndex != -1) {
      bwFilters[navIndex].splice(itemIndex, 1);
      $(this).css("font-weight", "normal").attr("aria-selected","false");
    } else {
      bwFilters[navIndex].push(curFilter);
      $(this).css("font-weight", "bold").attr("aria-selected","true");
    }

    refreshFilterList(navIndex,navName);
    reloadMainEventList();

    if (isTiny) {
      // toggle off the mobile menu in tiny mode.
      $("#mobileMenu").click();
    }
  });

  /* Open and close the views (by clicking the caret or the text  */
  /* Default state is open */
  $(".bwMenuTitle").click(function(){
    //$(this).next(".bwMenuTree").toggle(100);
    //$(this).find(".caret").toggleClass("caret-right");
    var curItem = $(this).parent("div");
    $(curItem).children(".bwMenuTree").slideToggle(100, function () {
      if ($(this).is(":hidden")) {
        $(curItem).find(".caret").addClass("caret-right");
        closedViews.push($(curItem).attr("id"));
      } else {
        var itemIndex = $.inArray($(curItem).attr("id"), openCals);
        $(curItem).find(".caret").removeClass("caret-right");
        closedViews.splice(itemIndex, 1);
      }

      sendAjax("setappvar=closedViews(" + closedViews.toString() + ")");

    });
  });

  /* Open and close the calendar subtree (by clicking the + or -) */
  /* Default state is closed */
  $(".bwMenuTree .menuTreeToggle").click(function () {
    var curItem = $(this).parent("li");
    $(curItem).children("ul").slideToggle("fast", function () {
      if ($(this).is(":visible")) {
        $(this).parent("li").children("span.menuTreeToggle").html("-");
        openCals.push($(curItem).attr("id"));
      } else {
        var itemIndex = $.inArray($(curItem).attr("id"), openCals);
        $(this).parent("li").children("span.menuTreeToggle").html("+");
        openCals.splice(itemIndex, 1);
      }

      sendAjax("setappvar=opencals(" + openCals.toString() + ")");

    });
  });

  /* Open and close the mobile menu */
  $("#mobileMenu").click(function(){
    $("#bwDatePickerLinks").toggle(100);
    $("#bwBasicSearch").toggle(100);
    $("#bwViewList").toggle(100);
    /*$(".bwMenu").toggle(100, function() {
      if ($(this).find(".bwMenuTree").is(":visible")) {
        $(this).find(".caret").removeClass("caret-right");
      } else {
        $(this).find(".caret").addClass("caret-right");
      }
    });*/
    $("#ongoing").toggle(100);
  });

  /* Add the click handler to filters that are generated on first page load.  */
  $(".eventFilterInfo").on("click", ".bwfilter a", bwFilterClickHandler);

  /* Add a click handler to the "back to events" link. */
  $("#eventIcons").on("click", "a.linkBack", bwRangeClickHandler);

  /* Add a click handler to day/week/month links. (If the links are present.) */
  $("#bwDatePickerRangeLinks").on("click", "a.bwRangeLink", bwRangeClickHandler);

  /* Add a click handler to the upcoming link, to pick up the start date from the
     date picker. (If the upcoming link is present.)*/
  $("#bwDatePickerRangeLinks").on("click", "a.bwUpcomingLink", bwUpcomingClickHandler);

});

// DATE PICKER FUNCTIONS:
// The date picker was used to set a start date
function changeStartDate(formObj,eventListObj) {
  formObj.setappvar.value = "navDate(" + formObj.start.value + ")";
  if (eventListObj != undefined){
    // We have an eventList object.
    // Check to see if we are on a page that uses it.
    // If so, update the object and do an ajax call.
    // Do not submit the form.
    var outputContainer = document.getElementById(eventListObj.outputContainerId);
    if (outputContainer != null) {
      eventListObj.setRequestData("start",formObj.start.value);
      eventListObj.setRequestData("setappvar","navDate(" + formObj.start.value + ")");
      eventListObj.display();
      return false;
    }
  }
  // No eventList object was sent or there is no output container: do a normal form submit.
  formObj.submit();
  return true;
}

// SEARCH FUNCTIONS
function bwSearch(val) {
  bwMainEventList.setQuery(val);
  refreshQuery(bwQueryName,bwClearQueryMarkup);
  reloadMainEventList();
  if (isTiny) {
    // toggle off the mobile menu in tiny mode.
    $("#mobileMenu").click();
  }
  return false;
}

function bwClearSearch() {
  bwMainEventList.setQuery("");
  $("#bwBasicSearchInput").val("");
  refreshQuery(bwQueryName,bwClearQueryMarkup);
  reloadMainEventList();
}

/* Refresh the search query displayed above the main column */
function refreshQuery(bwQueryName,bwClearQueryMarkup) {
  var curQuery = bwMainEventList.getQuery();
  if(curQuery == "") {
    $("#bwQueryContainer").empty();
  } else {
    $("#bwQueryContainer").html('<div id="bwQuery" class="eventFilterInfo"><span class="bwQueryText"><span class="bwQueryTitle">' + bwQueryName + "</span> <strong class=\"bwQueryQuery\">\"" + curQuery + "\"</strong></span> " + bwClearQueryMarkup + '</div>');
  }
}

// CALENDAR FILTER FUNCTIONS
/* Clear a set of calendar filters. */
function bwClearFilters(navIndex) {
  bwFilters[navIndex].length = 0;
  bwFilterPaths[navIndex].length = 0;
  refreshFilterList(navIndex);
  $("#bwNav" + navIndex +  " .bwMenuTree a").css("font-weight", "normal").attr("aria-selected","false");
  reloadMainEventList();
}

/* Clear all filters. */
function bwClearAllFilters() {
  $.each(bwFilters, function (i) {
    bwFilters[i].length = 0; // clear the inner arrays, but leave them in place.
    bwFilterPaths[i].length = 0; // same goes for the filter paths.
    $("#calFilterContainer" + i).empty();
  });
  $(".bwMenuTree a").css("font-weight", "normal");
  reloadMainEventList();
}

/* Clear everything */
function bwClearAll() {
  // clear all filters
  $.each(bwFilters, function (i) {
    bwFilters[i].length = 0; // clear the inner arrays, but leave them in place.
    bwFilterPaths[i].length = 0; // same goes for the filter paths.
    $("#calFilterContainer" + i).empty();
  });
  $(".bwMenuTree a").css("font-weight", "normal");
  $(".bwMenuTree a").css("background", "none");
  // clear the query
  bwMainEventList.setQuery("");
  $("#bwBasicSearchInput").val("");
  refreshQuery(bwQueryName,bwClearQueryMarkup);
  // reload
  reloadMainEventList();
}

/* Replace all filters (and queries) with a new filter */
function bwReplaceFilters(filterPath) {
  // clear everything:
  $.each(bwFilters, function (i) {
    bwFilters[i].length = 0; // clear the inner arrays, but leave them in place.
    bwFilterPaths[i].length = 0; // same goes for the filter paths.
    $("#calFilterContainer" + i).empty();
  });
  $(".bwMenuTree a").css("font-weight", "normal");
  bwMainEventList.setQuery("");
  $("#bwBasicSearchInput").val("");
  refreshQuery(bwQueryName,bwClearQueryMarkup);

  // Look up the new filter by finding href="path" in the navigation tree.
  // XXX  This is not appropriate - the filter may not exist in the tree.
  /*var filterId = $(".bwMenu a[href='" + filterPath +  "']").attr("id");
  console.log("filterId = " + filterId);
  if (filterId == undefined) {
    filterId = "empty";
  }
  // set the new filter:
  bwFilters[0][0] = filterId;
  bwFilterPaths[0][0] = filterPath;*/

  reloadMainEventList();
}

/* Refresh the list of filters displayed above the main column */
function refreshFilterList(navIndex, navName) {
  if(bwFilters[navIndex].length) {
    $("#calFilterContainer" + navIndex).html('<div id="bwFilterList' + navIndex +  '" class="eventFilterInfo"></div>');
    displayFilters(bwFilters[navIndex],navIndex,navName);
    $("#calFilterContainer" + navIndex).show();
  } else {
    $("#calFilterContainer" + navIndex).hide();
    $("#calFilterContainer" + navIndex).empty();
  }
}

/* Generate an individual filter list. */
function displayFilters(bwFilterSet, navIndex, navName) {
  var filterList = "<span class=\"bwFilterText\">";
  filterList += "<span class=\"bwFilterName\">" + navName + "</span>: ";
  $.each(bwFilterSet, function (i, value) {
    filterList += renderFilter(value);
  });
  filterList += "</span>";
  filterList += " <a href=\"javascript:bwClearFilters(" + navIndex + ")\" class=\"bwClearCalFilters\">" + bwClearFilterStr + "</a>";
  // Write the list back to the screen
  $("#bwFilterList" + navIndex).html(filterList);
  // Add click handlers to the list items
  $("#bwFilterList" + navIndex + " .bwfilter a").click(bwFilterClickHandler);
}

/* Generate every filter list.  This is called when constructing the pages. */
function displayAllFilters(bwFilters) {
  if (bwFilters.length) {
    $.each(bwFilters, function (i, value) {
      if (value.length) {
        if(bwPage == "eventList" || bwPage == "eventscalendar") {
          // only construct filter listings on these two views.
          var navId = value[0].substr(0,value[0].indexOf("-"));
          var navName = $("#" + navId + " .bwMenuTitle").text().trim();
          refreshFilterList(i,navName);
        }
        // make our selected navigational items bold on every page
        $.each(value, function (j, val) {
          $("#" + val).css("font-weight","bold").attr("aria-selected","true");
        });
      }
    });
  }
}

/* Generate an individual filter */
function renderFilter(id) {
  var anchorId = "f" + id;
  var filterPath = $("#" + id).attr("href");
  var label = $("#" + id).text();
  return '<span class="bwfilter"><span class="bwFilterItemName">' + label + '</span><a href="' + filterPath + '" id="' + anchorId + '">x</a></span> ';
}

/* Construct the filter paths by looking up the IDs in bwFilters (global) */
/* Return a two-dimensional array of filter paths; one set per navigation block */
/* If the filters are empty, return empty arrays. */
function buildFilterPaths() {
  var filterPaths = new Array();
  $.each(bwFilters, function (i,filterSet) {
    filterPaths[i] = new Array();
    if (filterSet.length) {
      $.each(filterSet, function (j, value) {
        path = $("#" + value).attr("href");
        filterPaths[i].push(path);
      });
    }
  });
  return filterPaths;
}



// PRIMARY NAVIGATION FUNCTIONS:
function reloadMainEventList() {
  bwFilterPaths = buildFilterPaths(); // global
  var fexpr = bwMainEventList.getFilterExpression(bwFilterPaths);
  var query = bwMainEventList.getQuery();
  var bwFiltersStr = buildFilterString();

  var qstring = new Array();
  qstring.push("setappvar=bwFilters(" + bwFiltersStr + ")");
  qstring.push("setappvar=bwQuery(" + query + ")");

  if (bwPage == "eventList") {
    // we're on the eventList - use ajax directly
    var reqData = new Object;
    reqData.fexpr = fexpr;
    reqData.query = query;
    launchAjax(bwMainEventList, reqData);
    sendAjax(qstring);
  } else {
    // build up a query string for full request / response
    qstring.push("fexpr=" + fexpr);
    qstring.push("start=" + bwMainEventList.startDate.replace(/-/g,""));
    if (query != "") {
      qstring.push("query=" + query);
    }
    if (bwPage == "eventscalendar" || bwListPage == "eventscalendar") {
      launch(bwUrls.setSelection, qstring);
    } else {
      launch(bwUrls.setSelectionList, qstring);
    }
  }
}

function buildFilterString() {
  // turn the filter array into a simple string for transport
  var filterString = "";
  var filterDelimiter = "";
  for (i=0; i<bwFilters.length; i++) {
    filterString += filterDelimiter + bwFilters[i].toString();
    filterDelimiter = "|";
  }
  return filterString;
}

// Restore filters from an appvar string
function restoreFilters(rawFilters) {
  var filters = new Array();
  var filtersHolder = new Array();
  filtersHolder = rawFilters.split("|");
  for (i = 0; i < filtersHolder.length; i++) {
    filters[i] = new Array();
    if (filtersHolder[i] != "") {
      filters[i] = filtersHolder[i].split(",");
    }
  }
  return filters;
}

/* Update an event list object from the server */
function launchAjax(listObj,reqData) {
  if (reqData != undefined) {
    $.each(reqData, function (key, value) {
      listObj.setRequestData(key,value);
    });
  }
  listObj.display();
}

/* General purpose ajax send: allows us to place multiple parameters of the
   same name in a query string (e.g. setappvar).
   val can be a string or a simple array of key=value pairs,
   e.g. string: "key=value&key=value&key=value"
      or array: ["key=value","key=value","key=value"] */
function sendAjax(val) {
  var qstring = "";
  if ($.isArray(val)) {
    if ((val != undefined) && (val.length > 0)) {
      for (var i=0; i < val.length; i++) {
        qstring += "&" + val[i];
      }
    }
  } else if (typeof val == 'string') {
    qstring = val;
  }

  if (qstring != "") {
    // only send if we have we have some data to send
    $.ajax({
      type: "POST",
      url: bwUrls.async,
      data: qstring,
      dataType: 'html'
    });
  }
}

/* JavaScript href redirect for a full request/response; used
 * in the day / week / month views. */
function launch(loc,qstringArray) {
  var url = loc;
  if ((qstringArray != undefined) && (qstringArray.length > 0)) {
    for (var i=0; i < qstringArray.length; i++) {
      url += "&" + qstringArray[i];
    }
  }
  window.location.href = url;
}

/* The generic click handler for main navigation links that should have filters
 * dynamically appended to them. */
function bwRangeClickHandler(event) {
  event.preventDefault();
  bwFilterPaths = buildFilterPaths();
  var href = $(this).attr("href");
  href += "&date=" + $("#bwDatePickerInput").val().replace(/-/g,"");
  href += "&fexpr=" + bwMainEventList.getFilterExpression(bwFilterPaths);
  launch(href);
}

/* The click handler for the upcoming link. */
function bwUpcomingClickHandler(event) {
  event.preventDefault();
  var href = $(this).attr("href");
  href += "&start=" + $("#bwDatePickerInput").val().replace(/-/g,"");
  launch(href);
}

/* The click handler for filters in the filter list.
   Allows us to remove filters from the list when a user clicks "x" */
function bwFilterClickHandler(event) {
  event.preventDefault();
  var curFilter = $(this).attr("id").substr(1); // strip off the first character ("f") to get the same ID as found in the menu anchor
  var navIndex = $(this).attr("id").substr(6,1); // get the nav index from the ID
  var navName = $("#bwNav" + navIndex + " .bwMenuTitle").text().trim();
  var itemIndex = $.inArray(curFilter, bwFilters[navIndex]);
  if (itemIndex != -1) {
    bwFilters[navIndex].splice(itemIndex, 1);
    bwFilterPaths[navIndex].splice(itemIndex, 1);
  }
  var bwFiltersStr = buildFilterString();

  // save the new state information:
  var qstring = new Array();
  qstring.push("setappvar=bwFilters(" + bwFiltersStr + ")");

  // retrieve the filter expression:
  bwFilterPaths = buildFilterPaths();
  var fexpr = bwMainEventList.getFilterExpression(bwFilterPaths);

  // refresh the list for the filters we have
  if (bwPage == "eventList") {
    refreshFilterList(navIndex,navName);
    $("#" + curFilter).css("font-weight", "normal");
    var reqData = new Object;  // for refreshing the center event list
    reqData.fexpr = fexpr;
    sendAjax(qstring); // pass back the state parameters
    launchAjax(bwMainEventList, reqData); // refresh the bwMainEventList display
  } else { // day, week, month views
    if (bwFilters[navIndex].length == 0) { // we have no more filters
      qstring.push("viewName=All");
    } else { // we have filters
      qstring.push("fexpr=" + fexpr);
    }
    launch(bwUrls.setSelection, qstring); // full request / response - includes state parameters
  }
}

// pass in an ID to click
function bwClick(itemId) {
  $(itemId).click();
}

function addCalFilter(filterId) {
  // user clicked on a topical area within an event
  // or a calendar from full listing
  var curFilter = filterId;
  var itemIndex = $.inArray(curFilter, bwFilters);
  if (itemIndex != -1) {
    // it's already there; ignore.
  } else {
    bwFilters.push(curFilter);
  }
  var qstring = new Array();
  $.each(bwFilters, function (i, value) {
    var filter = $("#" + value).attr("href");
    qstring.push("vpath=" + filter);
  });
  qstring.push("setappvar=bwFilters(" + bwFilters.toString() + ")");
  launch(bwUrls.setSelectionList, qstring);
}

/* EVENT HANDLING */
/* List related browser event handling */
function bwScroll() {
  // append events if we scroll to the last pixel on the page
  if ($(window).scrollTop() > ($(document).height() - $(window).height() - 1)) {
    bwMainEventList.appendEvents(bwLastDateSeparatorInList);
  }
}

function bwOngoingClickHandler(event) {
  $(this).next(".bwEventList").toggle("fast");
  $(this).find(".caret").toggleClass("caret-right");
};

function bwListedEventClickHandler(event) {
  // highlight the list element briefly and then go to the event
  $(this).closest("li").addClass("clickedEvent");
  location.href = ($(this).find(".bwSummary > a").attr("href"));
}