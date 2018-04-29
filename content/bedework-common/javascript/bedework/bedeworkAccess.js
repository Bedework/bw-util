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

/* Bedework Access control form functions

   Bedework sets access control by building a javascript object representing
   the acls on an item (e.g. an event), manipulating the object with the GUI, and
   sending all the acls in a single request parameter.  We would like to replace
   this approach with wizards that ask the user what they want to do (and hide
   the acls).

*/

// ========================================================================
//   Default strings are English (en_US).  Tranlations are found in 
//   the sibling directory lang/ and are included as overrides based on the localeSettings.xsl
//   file for each web client (that uses a localeSettings file, e.g. the personal 
//   and public web clients

var authenticatedStr = "authenticated";
var unauthenticatedStr = "unauthenticated";
var ownerStr = "owner";
var otherStr = "other";
var grantStr = "grant";
var denyStr = "deny"
var allStr = "all";

var bwAclWidgetDeleteStr = "remove";
var bwAclWidgetEntryStr = "Entry";
var bwAclWidgetAccessStr = "Access";
var bwAclWidgetInheritedStr = "Inherited from";

// note that resourcesRoot is passed in from the html head section defined in the xslt
var trashIcon = '<img src="' + imagesRoot + '/trashIcon.gif" width="13" height="13" border="0" alt="remove"/>';
var userIcon = '<img src="' + imagesRoot + '/userIcon.gif" width="13" height="13" border="0" alt="user"/>';
var groupIcon = '<img src="' + imagesRoot + '/groupIcon.gif" width="13" height="13" border="0" alt="group"/>';

// How granted accesses appear
var howAllVal = "all";

var howReadVal = "read";
var howReadAclVal = "read-acl";
var howReadCurPrivSetVal = "read-curprivset";
var howReadFreebusyVal = "read-freebusy ";

var howWriteVal = "write";
var howWriteAclVal = "write-acl";
var howWritePropertiesVal = "write-properties";
var howWriteContentVal = "write-content";

var howBindVal = "create";

/* Old scheduling */
var howScheduleVal = "schedule";
var howScheduleRequestVal = "schedule-request";
var howScheduleReplyVal = "schedule-reply";
var howScheduleFreebusyVal = "schedule-freebusy";

var howUnbindVal = "delete";

var howUnlockVal = "unlock";

var howScheduleDeliverVal = "schedule-deliver";
var howScheduleDeliverInviteVal = "schedule-deliver-invite";
var howScheduleDeliverReplyVal = "schedule-deliver-reply";
var howScheduleQueryFreebusyVal = "schedule-query-freebusy";

var howScheduleSendVal = "schedule-send";
var howScheduleSendInviteVal = "schedule-send-invite";
var howScheduleSendReplyVal = "schedule-send-reply";
var howScheduleSendFreebusyVal = "schedule-send-freebusy";

// How denied accesses appear
var howDenyAllVal = "none";

var howDenyReadVal = "not-read";
var howDenyReadAclVal = "not-read-acl";
var howDenyReadCurPrivSetVal = "not-read-curprivset";
var howDenyReadFreebusyVal = "not-read-freebusy ";

var howDenyWriteVal = "not-write";
var howDenyWriteAclVal = "not-write-acl";
var howDenyWritePropertiesVal = "not-write-properties";
var howDenyWriteContentVal = "not-write-content";

var howDenyBindVal = "not-create";
var howDenyScheduleVal = "not-schedule";
var howDenyScheduleRequestVal = "not-schedule-request";
var howDenyScheduleReplyVal = "not-schedule-reply";
var howDenyScheduleFreebusyVal = "not-schedule-freebusy";

var howDenyUnbindVal = "not-delete";

var howDenyUnlockVal = "not-unlock";

var howDenyScheduleDeliverVal = "not-schedule-deliver";
var howDenyScheduleDeliverInviteVal = "not-schedule-deliver-invite";
var howDenyScheduleDeliverReplyVal = "not-schedule-deliver-reply";
var howDenyScheduleQueryFreebusyVal = "not-schedule-query-freebusy";

var howDenyScheduleSendVal = "not-schedule-send";
var howDenyScheduleSendInviteVal = "not-schedule-send-invite";
var howDenyScheduleSendReplyVal = "not-schedule-send-reply";
var howDenyScheduleSendFreebusy = "not-schedule-send-freebusy";

//var howNoneVal = "none";

/* We shouldn't use the word local - it probably doesn't mean too much and it might actually be
   inherited from something called /local for example */
var inheritedStr = "not inherited";

// **************************
// The prefixes come from the directory code so should be emitted by the jsp.
// We may have problems here as convertng from a user id to a principal might be
// awkward

var principalPrefix = "/principals/";
var userPrincipalPrefix = "/principals/users/";
var groupPrincipalPrefix = "/principals/groups/";
var resourcePrincipalPrefix = "/principals/resources/";

// ========================================================================
// ========================================================================

// .......................................................
// Some constants
// .......................................................

var xmlHeader = "<?xml version='1.0' encoding='utf-8'  ?>";
var nameSpaces = "xmlns:D='DAV:' " +
                 "xmlns:C='urn:ietf:params:xml:ns:caldav'";

var davNS = "D:";
var caldavNS = "C:";

/* Define how values,
    par: how,
    par: the contained hows
    par: dav element name
    par: display name */
function howVals(h, cont, davEl, dv, ddv) {
  var how;
  var contains;
  var davEl;
  var dispVal;
  var denyDispVal;

  this.how = h;
  this.contains = cont;
  this.davEl = davEl;
  this.dispVal = dv;
  this.denyDispVal = ddv;

  /* return true if ch is contained in this access */
  this.doesContain = function(ch) {
    return this.contains.match(ch) != null;
  }

  this.getDispVal = function(negated) {
    if (negated) {
      return this.denyDispVal;
    }

    return this.dispVal;
  }
}

var hows = new function() {
  var hv = new Array();

  hv.push(new howVals("A", "RrPFWapcbStysuNDieqTIEQ", "<D:all/>", howAllVal, howDenyAllVal));

  hv.push(new howVals("R", "rPF", "<D:read/>", howReadVal, howDenyReadVal));
  hv.push(new howVals("r", "", "<D:read-acl/>", howReadAclVal, howDenyReadAclVal));
  hv.push(new howVals("P", "", "<D:read-current-user-privilege-set/>", howReadCurPrivSetVal, howDenyReadCurPrivSetVal));
  hv.push(new howVals("F", "", "<C:read-free-busy/>", howReadFreebusyVal, howDenyReadFreebusyVal));

  hv.push(new howVals("W", "apcbStysuN", "<D:write/>", howWriteVal, howDenyWriteVal));
  hv.push(new howVals("a", "", "<D:write-acl/>", howWriteAclVal, howDenyWriteAclVal));
  hv.push(new howVals("p", "", "<D:write-properties/>", howWritePropertiesVal, howDenyWritePropertiesVal));
  hv.push(new howVals("c", "", "<D:write-content/>", howWriteContentVal, howDenyWriteContentVal));
  hv.push(new howVals("b", "Stys", "<D:bind/>", howBindVal, howDenyBindVal));

  /* Old caldav sched - should disallow use */
  hv.push(new howVals("S", "tys", "<C:schedule/>", howScheduleVal, howDenyScheduleVal));
  hv.push(new howVals("t", "", "<C:schedule-request/>", howScheduleRequestVal, howDenyScheduleRequestVal));
  hv.push(new howVals("y", "", "<C:schedule-reply/>", howScheduleReplyVal, howDenyScheduleReplyVal));
  hv.push(new howVals("s", "", "<C:schedule-free-busy/>", howScheduleFreebusyVal, howDenyScheduleFreebusyVal));

  hv.push(new howVals("u", "", "<D:unbind/>", howUnbindVal, howDenyUnbindVal));

  hv.push(new howVals("U", "", "<D:unlock/>", howUnlockVal, howDenyUnlockVal));

  hv.push(new howVals("D", "ieq", "<C:schedule-deliver/>",
      howScheduleDeliverVal, howDenyScheduleDeliverVal));
  hv.push(new howVals("i", "", "<C:schedule-deliver-invite/>",
      howScheduleDeliverInviteVal, howDenyScheduleDeliverInviteVal));
  hv.push(new howVals("e", "", "<C:schedule-deliver-reply/>",
      howScheduleDeliverReplyVal, howDenyScheduleDeliverReplyVal));
  hv.push(new howVals("q", "", "<C:schedule-query-freebusy/>",
      howScheduleQueryFreebusyVal, howDenyScheduleQueryFreebusyVal));

  hv.push(new howVals("T", "IEQ", "<C:schedule-send/>",
      howScheduleSendVal, howDenyScheduleSendVal));
  hv.push(new howVals("I", "", "<C:schedule-send-invite/>",
      howScheduleSendInviteVal, howDenyScheduleSendInviteVal));
  hv.push(new howVals("E", "", "<C:schedule-send-reply/>",
      howScheduleSendReplyVal, howDenyScheduleSendReplyVal));
  hv.push(new howVals("Q", "", "<C:schedule-send-freebusy/>",
      howScheduleSendFreebusyVal, howDenyScheduleSendFreebusy));

  //hv.push(new howVals("N", "rPFapcbStysu", "", howNoneVal)); // None is -A

  this.getHows = function(ch) {
    for (var i = 0; i < hv.length; i++) {
      if (hv[i].how == ch) {
        return hv[i];
      }
    }

    alert("No how values for how = " + ch);

    return null;
  }
}

function setupAccessForm(chkBoxObj, formObj) {
  var hvs;  // howVals

  /* If we checked/unchecked a value that contains other values we need
     to uncheck and disable the contained boxes. */

  hvs = hows.getHows(chkBoxObj.value);

  if (hvs.contains == "") {
    // Doesn't contain anything
    return;
  }

  for (i = 0; i < formObj.howItem.length; i++) {
    if (hvs.doesContain(formObj.howItem[i].value)) {
      if (chkBoxObj.checked == true) {
        formObj.howItem[i].checked = false;
        formObj.howItem[i].disabled = true;
        // now iterate over corresponding radio buttons for each howItem
        for (j = 0; j < formObj[formObj.howItem[i].id].length; j++) {
          formObj[formObj.howItem[i].id][j].disabled = true;
        }
      } else {
        formObj.howItem[i].disabled = false;
      }
    }
  }
}

// enable and disable corresponding allow/deny flags when a howItem checkbox is
// clicked
function toggleAllowDenyFlag(chkBoxObj,formObj) {
  if (chkBoxObj.checked == true) {
    activateAllowDenyFlag(chkBoxObj.id, formObj, false);
  } else {
    activateAllowDenyFlag(chkBoxObj.id, formObj, true);
  }
}

// iterate over the allow/deny radio buttons and set them to true or false
function activateAllowDenyFlag(val,formObj,disabledFlag) {
  for (i = 0; i < formObj[val].length; i++) {
    if (formObj[val][i].type == "radio") { //skip the checkbox with matching id
      formObj[val][i].disabled = disabledFlag;
    }
  }
}

// Gather up the how values on access form submission and return the value.
// If in "basic" mode:
//   Set the value of how to the value of the basicHowItem radio button.
// If in "advanced" mode:
//   Each howItem (checkbox) has a corresponding allow/deny flag (radio button)
//   named after the howItem's value (e.g. "A","R","F","N", etc).
//   The allow/deny flag contains the final values to be returned with
//   the "-" switch if we set the value to deny (e.g. "A" or "-A", "R" or "-R").
function setAccessHow(formObj) {
  var howString = "";
  if (formObj.setappvar[0].checked == true) { // "basic" mode is selected
    for (i = 0; i < formObj.basicHowItem.length; i++) {
      if (formObj.basicHowItem[i].checked == true) {
        howString = formObj.basicHowItem[i].value;
      }
    }
  } else { // "advanced" mode is selected
    for (i = 0; i < formObj.howItem.length; i++) {
      if (formObj.howItem[i].checked == true) {
        var howItemId = formObj.howItem[i].id; // get the howItem id and
        for (j = 0; j < formObj[howItemId].length; j++) { // look up the value from the corresponding allow/deny flag
          if ((formObj[howItemId][j].checked == true) && (formObj[howItemId][j].type == "radio")) {
            howString += formObj[howItemId][j].value;
          }
        }
      }
    }
  }
  return howString;
}

/* Information about a principal
 */
function bwPrincipal(who, whoType) {
  this.whoType = whoType;

  if ((whoType == "auth") ||
      (whoType == "unauth") ||
      (whoType == "owner") ||
      (whoType == "all") ||
      (whoType == "other")) {
    // Don't set who
  } else {
    this.who = who;

    // Don't touch email like addresses
//    if (who.indexOf("@") < 0) {
      // Normalize the who
      if (whoType == "user") {
        if (who.indexOf(principalPrefix) != "0") {
          who = userPrincipalPrefix + who;
        }
      } else if (whoType == "group") {
        if (who.indexOf(principalPrefix) != "0") {
          who = groupPrincipalPrefix + who;
        }
      } else if (whoType == "resource") {
        if (who.indexOf(principalPrefix) != "0") {
          who = resourcePrincipalPrefix + who;
        }
      }
  //  }
  }

  // format the who string for on-screen display
  this.format = function() {
    if (whoType == "user") {
      return userIcon + " " + who;
    }

    if (whoType == "group") {
      return groupIcon + " " + who;
    }

    if (whoType == "resource") {
      return who;
    }

    if (whoType == "auth") {
      return groupIcon + " " + authenticatedStr;
    }

    if (whoType == "unauth") {
      return groupIcon + " " + unauthenticatedStr;
    }

    if (whoType == "owner") {
      return userIcon + " " + ownerStr;
    }

    if (whoType == "other") {
      return groupIcon + " " + otherStr;
    }

    if (whoType == "all") {
      return groupIcon + " " + allStr;
    }

    return "***************" + whoType;
  }

  // format the who string for xml representation
  this.formatXml = function() {
    if (whoType == "user") {
      return who;
    }

    if (whoType == "group") {
      return who;
    }

    if (whoType == "resource") {
      return who;
    }

    if (whoType == "auth") {
      return authenticatedStr;
    }

    if (whoType == "unauth") {
      return unauthenticatedStr;
    }

    if (whoType == "owner") {
      return ownerStr;
    }

    if (whoType == "other") {
      return otherStr;
    }

    if (whoType == "all") {
      return allStr;
    }

    return "***************" + whoType;
  }

  this.toXml = function() {
    var w = this.formatXml();

    if (whoType == "other") {
      return "    <D:invert>\n        <D:principal><D:property><D:owner/></D:property></D:principal>\n      </D:invert>";
    }

    var res = "    <D:principal>\n";

    if (w.indexOf(principalPrefix) == "0") {
      res += "      <D:href>" + w + "</D:href>\n";
    } else if (whoType == "auth") {
      res += "      <D:authenticated/>\n";
    } else if (whoType == "unauth") {
      res += "      <D:unauthenticated/>\n";
    } else if (whoType == "all") {
      res += "      <D:all/>\n";
    } else if (whoType == "owner") {
      res += "    <D:property><D:owner/></D:property>\n";
    } else {
      res += "************??????" + whoType;
    }

    return res + "    </D:principal>\n";
  }

  this.toString = function() {
    return "bwPrincipal[who=" + this.who + ", whoType=" + this.whoType + "]";
  }

  this.equals = function(pr) {
    if (this.whoType != pr.whoType) {
      return false;
    }
    return this.who == pr.who;
  }
}

/* Access Control Entry (ACE) object
 */
function bwAce(who, whoType, how, inherited, invert) {
  this.principal = new bwPrincipal(who, whoType);
  this.how = how;
  this.inherited = inherited;
  this.invert = invert; // boolean

  this.equals = function(ace) {
    return this.principal.equals(ace.principal);
  }

  // format the who string for on-screen display
  this.formatWho = function() {
    return this.principal.format();
  }

  // format the how string for on-screen display
  this.formatHow = function() {
    var formattedHow = "";

    for (var i = 0; i < how.length; i++) {
      var h = how.charAt(i);
      var negated = false;
      var grantDenyStr = grantStr;
      if (h == "-") {
        negated = true;
        grantDenyStr = denyStr;
        i++;
        h = how.charAt(i);
      }

      formattedHow += '<span class="' + grantDenyStr + '">' + hows.getHows(h).getDispVal(negated) + '</span>';
      if (i != how.length-1) {
        formattedHow += ', ';
      }
    }

    return formattedHow;
  }

  this.formatInherited = function() {
    if (inherited != "") {
      return inherited;
    }

    return inheritedStr;
  }

  this.howsToXml = function(doGrants) {
    var open = false;
    var res = "";

    for (var hi = 0; hi < how.length; hi++) {
      var h = how.charAt(hi);

      if (doGrants && (h == "-")) {
        // skip
        hi++;
      } else if (!doGrants && (h != "-")) {
        // skip
      } else {
        if (h == "-") {
          hi++;
          h = how.charAt(hi);
        }

        var hvs = hows.getHows(h);

        if (!open) {
          if (doGrants) {
            res += "    <D:grant>\n";
          } else {
            res += "    <D:deny>\n";
          }

          open = true;
        }

        res += "      <D:privilege>" + hvs.davEl + "</D:privilege>\n";
      }
    }

    if (open) {
      if (doGrants) {
        res += "    </D:grant>\n";
      } else {
        res += "    </D:deny>\n";
      }
    }

    return res;
  }

  this.toXml = function() {
    if (this.inherited != "") {
      return ""; // Should not emit inherited aces
    }
    
    var res = "  <D:ace>\n" + this.principal.toXml();

    res += this.howsToXml(true);
    res += this.howsToXml(false);

    //if (this.inherited != "") {
    //  res += "    <D:inherited><D:href>" + this.inherited + "</D:href></D:inherited>";
    //}

    return res + "  </D:ace>\n";
  }

  // row: current row in table
  // aceI: index of the ace
  // id: id of widget output block in the html
  this.toFormRow = function(row, aceI, id) {
    var td_0 = row.insertCell(0);
    td_0.innerHTML = this.principal.format();
    var td_1 = row.insertCell(1);
    td_1.innerHTML = this.formatHow();
    row.insertCell(2).appendChild(document.createTextNode(this.formatInherited()));
    var td_3 = row.insertCell(3);
    if (this.inherited == "") {
      td_3.innerHTML = "<a href=\"javascript:bwAcl.deleteAce('" + aceI + "','" + id + "')\">" + trashIcon + " " + bwAclWidgetDeleteStr + "</a>";
    }
  }
}

// Access Control List (ACL) object - an array of ACEs
// The bwAcl object is initialized during the XSLT transform.
var bwAcl = new function() {
  var aces = new Array();

  /* If we delete an ace we need to reinstate any inherited access for the same principal
   */
  var savedInherited = new Array();

  // Initialize the list.
  // The function expects a comma-separated list of arguments grouped
  // into the five ACE properties.
  this.init = function(who, whoType, how, inherited, invert) {
    var newAce = new bwAce(who, whoType, how, inherited, invert);
    aces.push(newAce);
    if (inherited != "") {
      savedInherited.push(newAce);
    }
  }

  // Add or update an ace
  this.addAce = function(newAce) {
    // expects a bwAce object as parameter
    for (var i = 0; i < aces.length; i++) {
      if (aces[i].equals(newAce)) {
        // replace an existing ace
        aces[i] = newAce;
        return;
      }
    }
    // not found: add ace to end of array
    aces.push(newAce);
  }

  // Update the list - expects the browser form object
  this.update = function(formObj,id) {
    // get the type of ace being set
    var type;
    for (i = 0; i < formObj.whoType.length; i++) {
      if (formObj.whoType[i].checked == true) {
        type = formObj.whoType[i].value;
      }
    }

    // validate for user or group
    if ((type == 'user' || type == 'group') && formObj.who.value == '') {
      alert("you must enter a user or group name");
      formObj.who.focus();
      return;
    }

    // get the how string from the form
    var how = setAccessHow(formObj);

    //alert("About to update who=" + formObj.who.value +
    //       "\ntype= " + type + "\nhow=" + how);

    this.addAce(new bwAce(formObj.who.value, type, how, "" , false));
    formObj.who.value = "";

    // update the acl form field
    var formAcl = document.getElementById("bwCurrentAcl");
    formAcl.value = this.toXml();

    // redraw the display
    this.display(id);
  }

  this.deleteAce = function(index,id) {
    var ace = aces[index];
    var replace = false;

    for (var si = 0; si < savedInherited.length; si++) {
      if (savedInherited[si].equals(ace)) {
        ace = savedInherited[si];
        replace = true;
        break;
      }
    }

    if (replace) {
      aces[index] = ace;
    } else {
      aces.splice(index, 1);
    }

    // update the acl form field
    var formAcl = document.getElementById("bwCurrentAcl");
    formAcl.value = this.toXml();

    // redraw the display
    this.display(id);
  }

  // build the ACL widget displayed on screen in the given id
  this.display = function(id) {
    try {

      // get the aclWidget and throw out the existing contents
      var aclWidget = document.getElementById(id);
      aclWidget.removeChild(aclWidget.firstChild);

      var bwCurrentAccess = document.createElement("table");
      bwCurrentAccess.className = "common scheduling";
      bwCurrentAccess.id = "bwCurrentAccess";
      bwCurrentAccess.createTHead();
      bwCurrAccessHead = bwCurrentAccess.tHead.insertRow(0);
      // build the th row using the DOM to avoid IE8 issues (i.e. avoid innerHTML)
      var th1 = document.createElement("th");
      var txt1 = document.createTextNode(bwAclWidgetEntryStr);
      var th2 = document.createElement("th");
      var txt2 = document.createTextNode(bwAclWidgetAccessStr);
      var th3 = document.createElement("th");
      var txt3 = document.createTextNode(bwAclWidgetInheritedStr);
      var th4 = document.createElement("th");
      th1.appendChild(txt1);
      th2.appendChild(txt2);
      th3.appendChild(txt3);
      bwCurrAccessHead.appendChild(th1);
      bwCurrAccessHead.appendChild(th2);
      bwCurrAccessHead.appendChild(th3);
      bwCurrAccessHead.appendChild(th4);

      var bwCurrAccessTBody = document.createElement("tbody");
      bwCurrentAccess.appendChild(bwCurrAccessTBody);

      // finally, write the table back to the display
      aclWidget.appendChild(bwCurrentAccess);

      // get the table body
      var aclTableBody = document.getElementById("bwCurrentAccess").tBodies[0];

      // remove existing rows
      //for (i = aclTableBody.rows.length - 1; i >= 0; i--) {
      //  aclTableBody.deleteRow(i);
      //}

      // create the table rows
      for (var j = 0; j < aces.length; j++) {
        var curAce = aces[j];
        var tr = aclTableBody.insertRow(j);

        curAce.toFormRow(tr, j, id);
      }

    } catch (e) {
      alert(e);
    }
  }

  // generate webDAV ACl XML output
  this.toXml = function() {
    var res = xmlHeader + "\n<D:acl " + nameSpaces + " >\n";

    for (var j = 0; j < aces.length; j++) {
      res += aces[j].toXml();
    }

    return res + "</D:acl>";
  }
}

