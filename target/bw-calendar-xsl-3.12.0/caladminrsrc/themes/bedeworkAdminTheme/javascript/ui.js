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

var ae = "";

window.onload = function() {
  initUI();

  /* Calendar.setup(
    {
      inputMonth  : "startMonth",         // ID of the input field
      inputDay  : "startDay",         // ID of the input field
      inputYear  : "startYear",         // ID of the input field
      inputHour  : "startHour",         // ID of the input field
      inputMins  : "startMins",         // ID of the input field

      ifFormat    : "%m,%d,%Y,%H,%M",    // the date format
      button      : "startDate",      // ID of the button
      showsTime   : "true",
      timeFormat  : "24"
    }
  );


 Calendar.setup(
    {
      inputMonth  : "endMonth",         // ID of the input field
    inputDay  : "endDay",         // ID of the input field
    inputYear  : "endYear",         // ID of the input field
    inputHour  : "endHour",         // ID of the input field
    inputMins  : "endMins",         // ID of the input field

      ifFormat    : "%m,%d,%Y,%H,%M",    // the date format
      button      : "endDate",      // ID of the button
    showsTime   : "true",
    timeFormat  : "24"
    }
  ); */

}

//Load the sponsors array
 function loadSponsor(data) {
  sponsors = data;
 }

//Load the sponsors array
 function loadLocation(data) {
    locations = data;
 }


/*
 * Usable UI Elements
 * All Credits to Thomas Baekdal
 * http://www.baekdal.com
 */
 function initUI() {

    var ae = "";
    var av = "";
    var ct = 1;

  var vTitleId = document.getElementById('iTitle')
    if (vTitleId != null) {
      vTitleId.onfocus = function () { cclick(this);  }
      vTitleId.onblur = function () { cblur(this);  }
      vTitleId.onmouseover = function () { cmover(this);  }
      vTitleId.onmouseout = function () { cmout(this);  }
    }

  var vDescId = document.getElementById('iDesc')
    if (vDescId != null) {
      vDescId.onfocus = function () { cclick(this);  }
      vDescId.onblur = function () { cblur(this);  }
      vDescId.onmouseover = function () { cmover(this);  }
      vDescId.onmouseout = function () { cmout(this);  }
    }

  var vCostId = document.getElementById('iCost')
    if (vCostId != null) {
      vCostId.onfocus = function () { cclick(this);  }
      vCostId.onblur = function () { cblur(this);  }
      vCostId.onmouseover = function () { cmover(this);  }
      vCostId.onmouseout = function () { cmout(this);  }
    }

  var vLinkId = document.getElementById('iLink')
    if (vLinkId != null) {
      vLinkId.onfocus = function () { cclick(this);  }
      vLinkId.onblur = function () { cblur(this);  }
      vLinkId.onmouseover = function () { cmover(this);  }
      vLinkId.onmouseout = function () { cmout(this);  }
    }

  var vAreaCodeId = document.getElementById('iAreaCode')
    if (vAreaCodeId != null) {
      vAreaCodeId.onfocus = function () { cclick(this);  }
      vAreaCodeId.onblur = function () { cblur(this);  }
      vAreaCodeId.onmouseover = function () { cmover(this);  }
      vAreaCodeId.onmouseout = function () { cmout(this);  }
    }

  var vPhoneAId = document.getElementById('iPhoneA')
    if (vPhoneAId != null) {
      vPhoneAId.onfocus = function () { cclick(this);  }
      vPhoneAId.onblur = function () { cblur(this);  }
      vPhoneAId.onmouseover = function () { cmover(this);  }
      vPhoneAId.onmouseout = function () { cmout(this);  }
    }

  var vPhoneBId = document.getElementById('iPhoneB')
    if (vPhoneBId != null) {
      vPhoneBId.onfocus = function () { cclick(this);  }
      vPhoneBId.onblur = function () { cblur(this);  }
      vPhoneBId.onmouseover = function () { cmover(this);  }
      vPhoneBId.onmouseout = function () { cmout(this);  }
    }

  var vCLinkId = document.getElementById('iCLink')
    if (vCLinkId != null) {
      vCLinkId.onfocus = function () { cclick(this);  }
      vCLinkId.onblur = function () { cblur(this);  }
      vCLinkId.onmouseover = function () { cmover(this);  }
      vCLinkId.onmouseout = function () { cmout(this);  }
    }

  var vEmailId = document.getElementById('iEmail')
    if (vEmailId != null) {
      vEmailId.onfocus = function () { cclick(this);  }
      vEmailId.onblur = function () { cblur(this);  }
      vEmailId.onmouseover = function () { cmover(this);  }
      vEmailId.onmouseout = function () { cmout(this);  }
    }

  var vAddPhoneId = document.getElementById('iAddPhone')
    if (vAddPhoneId != null) {
      vAddPhoneId.onfocus = function () { cclick(this);  }
      vAddPhoneId.onblur = function () { cblur(this);  }
      vAddPhoneId.onmouseover = function () { cmover(this);  }
      vAddPhoneId.onmouseout = function () { cmout(this);  }
    }

  var vLocLinkId = document.getElementById('iLocLink')
    if (vLocLinkId != null) {
      vLocLinkId.onfocus = function () { cclick(this);  }
      vLocLinkId.onblur = function () { cblur(this);  }
      vLocLinkId.onmouseover = function () { cmover(this);  }
      vLocLinkId.onmouseout = function () { cmout(this);  }
    }
 }


 function cclick(e) {
  e.style.border = "1px solid black";
  e.style.background = "#FFDF9D";
  e.style.zIndex = "100"
  ae = e.id;
  av = e.value;
 }

function cblur(e) {
  ab = document.getElementById("sponsorEmailAlert");

  if (e.id != "iEmail" || (e.id == "iEmail" && checkEmailAddress(e))) {


    if (e.value != av) {
      ab.style.display = "none";
      e.style.background = "#FFFAE4 url('../../resources/check1.gif') no-repeat center right";
      e.style.border = "1px solid #888";
      e.style.zIndex = "1"
      ct = 1;
      setTimeout("checktimer('" + e.id + "')", 400);
    } else {
      e.style.border = "1px solid #ccc";
      e.style.background = "#f8f8f8";
      e.style.zIndex = "1"
      ae = "";
    }


  } else {
    ab.style.display = "block";
    e.focus();
    e.select();
  }

  //ae = "";
}

function cmover(e) {
  if (ae != e.id) {
    e.style.border = "1px solid #aaa";
    e.style.background = "#FFFFFF";
    e.style.zIndex = "99"
  }
}

function cmout(e) {
  if (ae != e.id) {
    e.style.border = "1px solid #ccc";
    e.style.background = "#F8F8F8";
    e.style.zIndex = "1"
  }
}

function checkEmailAddress(e) {
  var goodEmail = e.value.match(/\b(^(\S+@).+((\.com)|(\.biz)|(\.info)|(\.name)|(\.museum)|(\.net)|(\.edu)|(\.mil)|(\.gov)|(\.org)|(\..{2,2}))$)\b/gi);
  if (goodEmail){
    return true
  } else {
    return false
  }
}

function checktimer(te) {

  if (ct != 4) {
    ct = ct + 1;
    cta = document.getElementById(te)
    if (ct == 2) {
      cta.style.border = "1px solid #ddd";
      cta.style.background = "#FFFABE url(check" + ct + ".gif) no-repeat center right";
    } else if (ct == 3) {
      cta.style.border = "1px solid #f8f8f8";
      cta.style.background = "#FEF8B9 url(" + ct + ".gif) no-repeat center right";
    } else if (ct == 4) {
      cta.style.border = "1px solid #f8f8f8";
      cta.style.background = "#f8f8f8";
      ae = "";
    }
    setTimeout("checktimer('" + te + "')", 100);
  }
}
