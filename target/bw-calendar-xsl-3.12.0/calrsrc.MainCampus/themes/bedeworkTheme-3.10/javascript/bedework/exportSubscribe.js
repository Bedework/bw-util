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

/* Bedework Calendar Export / Subscribe Pop-up Form
 This assumes the existence of bwQuery, bwFilters, bwFilterPaths and
 other variables derived from Bedework's jsp/xml layer and established
 in head.xsl. It also depends on functions found in navigation.js. */

// use JQuery UI slider widget for number of events
$(function() {
  $("#bwExpCountSlider").slider({
    range: "min",
    min: 1,
    max: 200,
    value: 10,
    slide: function(event, ui) {
      $("#bwExpEventCount").val(ui.value);
      updateUrlDisplay();
    }
  });
  $("#bwExpEventCount").val($("#bwExpCountSlider").slider("value"));
});

// use JQuery UI slider widget for number of days
$(function() {
  $("#bwExpSlider").slider({
    range: "min",
    min: 0,
    max: 31,
    value: 3,
    slide: function(event, ui) {
      $("#bwExpNumDays").val(ui.value);
      updateUrlDisplay();
    }
  });
  $("#bwExpNumDays").val($("#bwExpSlider").slider("value"));
});

// use JQuery UI datepicker widget for start date and end date
$(function() {
  $("#bwExpStartDate").datepicker({
    dateFormat: 'yymmdd',
    onSelect: function(dateText, inst) {
      updateUrlDisplay();
    }
  });
});

$(function() {
  $("#bwExpEndDate").datepicker({
    dateFormat: 'yymmdd',
    minDate: $('#bwExpStartDate').datepicker('getDate'),
    onSelect: function(dateText, inst) {
      updateUrlDisplay();
    }
  });
});

function constructURL() {

  var contentType = "";
  var outputType = "";
  var skin = "";
  var timeframe = "";
  var count = "&count=5";
  var htmlListDownloadLink = false;
  var constructedURL = "";

  // get the event count - remember: the count is a hard limit that might
  // truncate events within a given date range
  var countInput = parseInt(document.getElementById('bwExpEventCount').value,10);
  if (countInput != NaN) {
    count = "&count=" + countInput;
  }

  // get the timeframe, if any
  if (document.getElementById('bwExpNumberOfDays').checked == true) {
    timeframe = "&days=" + document.getElementById('bwExpNumDays').value;
  } else if (document.getElementById('bwExpStartEndDates').checked == true) {
    var startDate = document.getElementById('bwExpStartDate').value;
    var endDate = document.getElementById('bwExpEndDate').value;
    timeframe = "&start=" + startDate + '&end=' + endDate;
    // disallow empty start and end dates - just fall back to defaults in this case
    if (startDate == "" || endDate == "") {
      timeframe = "";
    }
  }

  // Content Type:
  // Did user request ics,jcal, or xcal?
  // If yes, set the content type.  No skin is needed - transform is handled by back-end.
  // If no, just set the skin for standard XSL transform handled by front-end.
  if (document.getElementById('bwExpIcs').checked == true) {
    contentType = "text/calendar";
  } else if (document.getElementById('bwExpJcal').checked == true) {
    contentType = "application/calendar%2Bjson";
  } else if (document.getElementById('bwExpXcal').checked == true) {
    contentType = "application/calendar%2Bxml";
  } else {
    outputType = $("input[name='bwExpDataType']:checked").val();
    skin = '&skinName=list-' + outputType;
  }

  // Widget?  set skin explicitly and include bwObject name.
  if (document.getElementById('bwExpWidget').checked == true) {
    skin = "&skinName=list-json&setappvar=objName(bwObject)";
  }

  // HTML List with a download link? Include an appvar for the transform
  if (document.getElementById('bwExpHtml').checked == true) {
    if (document.getElementById('bwHtmlListDownloadTrue').checked == true) {
      skin += "&setappvar=dl(true)";
    } else {
      skin += "&setappvar=dl(false)"; // set it explicitly
    }

    if (document.getElementById('bwHtmlDetailsTrue').checked == true) {
      skin += "&setappvar=details(true)";
    } else {
      skin += "&setappvar=details(false)"; // set it explicitly
    }
  }


  // Assemble the full URL.
  if (contentType != "") {
    constructedURL = getEventListCacheUrl("eventsFeed.gdo") + "&format=" + contentType + count + timeframe;
  } else {
    constructedURL = getEventListCacheUrl("eventsFeed.do") +  skin + count + timeframe;
  }

  return constructedURL;
}

function updateUrlDisplay() {
  if (document.getElementById('bwExpWidget').checked == true) {
    // build and display the widget code
    var url = constructURL();
    var bwCalendarServer = document.location.origin;
    var bwJsLoc = bwUrls.feedResources + "/javascript/eventListWidget.js";
    var jsHtml = '<textarea name="functions" id="bwExpFunctions" rows="20" cols="78">';
    jsHtml += '<div id="bwOutput"></div>\n';
    jsHtml += '<script type="text/javascript" src="' + bwJsLoc + '"> </script>\n';
    jsHtml += '<script type="text/javascript" src="' + url + '"> </script>\n';
    jsHtml += '<script type="text/javascript">\n'
    jsHtml += 'var bwJsWidgetOptions = {\n';
    jsHtml += '  title: ' + JSON.stringify($("input[name='jsTitleName']").val()) + ',\n';
    jsHtml += '  showTitle: ' + $("input[name='jsShowTitle']:checked").val() + ',\n';
    jsHtml += '  displayDescription: ' + $("input[name='jsDisplayDescription']:checked").val() + ',\n';
    jsHtml += '  calendarServer: "' + bwCalendarServer + '",\n';
    jsHtml += '  resourcesRoot: "' + bwUrls.feedResources + '",\n';
    jsHtml += '  limitList: ' + $("input[name='jsLimitList']:checked").val() + ',\n';
    jsHtml += '  limit: ' + $("input[name='jsLimit']").val() + ',\n';
    //jsHtml += '  displayEventDetailsInline: ' + $("input[name='jsDisplayInline']:checked").val() + ',\n';
    jsHtml += '  displayStartDateOnlyInList: ' + $("input[name='jsDisplayEndDate']:checked").val() + ',\n';
    jsHtml += '  displayTimeInList: ' + $("input[name='jsDisplayTime']:checked").val() + ',\n';
    jsHtml += '  displayLocationInList: ' + $("input[name='jsDisplayLocation']:checked").val() + ',\n';
    jsHtml += '  listMode: "' + $("input[name='jsDisplayDateOrTitle']:checked").val() + '",\n';
    //jsHtml += '  displayContactInDetails: ' + $("input[name='jsDisplayContactInDetails']:checked").val() + ',\n';
    //jsHtml += '  displayCostInDetails: ' + $("input[name='jsDisplayCostInDetails']:checked").val() + ',\n';
    //jsHtml += '  displayTagsInDetails: ' + $("input[name='jsDisplayTags']:checked").val() + ',\n';
    //jsHtml += '  displayTimezoneInDetails: ' + $("input[name='jsDisplayTimezone']:checked").val() + '\n';
    jsHtml += '};\n';
    jsHtml += '  insertBwEvents("bwOutput",bwObject,bwJsWidgetOptions);\n'
    jsHtml += '</script>\n';
    jsHtml += '</textarea>';
    document.getElementById('bwExpCodeBoxOutput').innerHTML = jsHtml;
  } else {
    // just display the raw feed url
    document.getElementById('bwExpUrlBox').innerHTML = constructURL();
    document.getElementById('bwExpUrlBox').href = constructURL();
  }
}

function uncheckAll(checkList) {
  $("input[name=$checkList]:checked").each(function() {
    $(this).removeAttr("checked");
  });
  updateUrlDisplay();
}


/* Return an encoded URL for use with the export/subscribe feature.
   Depends on js/bedework/navigation.js */
function getEventListCacheUrl(action) {
  bwFilterPaths = buildFilterPaths(); // global
  var fexpr = bwMainEventList.getFilterExpression(bwFilterPaths);
  var query = bwMainEventList.getQuery();

  /* Comment out appvar calls but keep them here for now - this, and those
     commented blocks that follow are used to restore state to the theme.
     They might be useful in the feeds, though they are not yet used. */
  // var bwFiltersStr = buildFilterString();

  // build up a query string for full GET request against the cache
  var qstring = "&sort=dtstart.utc:asc"  // always sort by date for now
  if (fexpr.length) {
    qstring += "&fexpr=" + fexpr;
  }
  if (query.length) {
    qstring += "&query=" + query;
    // as above, keep the following for now:
    // qstring += "&setappvar=bwQuery(" + query + ")";
  }
  // as above, keep the following for now:
  //if (bwFiltersStr.length) {
  //  qstring += "&setappvar=bwFilters(" + bwFiltersStr + ")";
  //}

  // return the prefix and the query string, encoded for use in a GET request
  if (qstring.length) {
    return encodeURI(bwUrls.feedPrefix + "/feeder/main/" + action + "?f=y" + qstring);
  }

  // no query string - just return the prefix ...maybe not valid;
  // perhaps return error, null, or empty string?
  return encodeURI(bwUrls.feedPrefix + "/feeder/main/" + action);
}