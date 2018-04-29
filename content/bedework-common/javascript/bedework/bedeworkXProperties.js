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

// Bedework x-property functions

// ========================================================================
// Bedework specific x-properties
// ========================================================================

var bwXPropertyAlias = "X-BEDEWORK-ALIAS";
var bwXPropertyImage = "X-BEDEWORK-IMAGE";
var bwXPropertyThumbImage = "X-BEDEWORK-THUMB-IMAGE";
var bwXPropertySubmittedBy = "X-BEDEWORK-SUBMITTEDBY";
var bwXPropertyLocation = "X-BEDEWORK-LOCATION";
var bwXPropertyContact = "X-BEDEWORK-CONTACT";
var bwXPropertyCategories = "X-BEDEWORK-CATEGORIES";
var bwXPropertySubmitAlias = "X-BEDEWORK-SUBMIT-ALIAS";
var bwXPropertySubmitComment = "X-BEDEWORK-SUBMIT-COMMENT";
var bwXPropertySubmitStatus = "X-BEDEWORK-SUBMIT-STATUS";
var bwXPropertySubmitterEmail = "X-BEDEWORK-SUBMITTER-EMAIL";
var bwXPropertySubmissionClaimant = "X-BEDEWORK-SUBMISSION-CLAIMANT";
var bwXPropertyMaxTickets = "X-BEDEWORK-MAX-TICKETS";
var bwXPropertyMaxTicketsPerUser = "X-BEDEWORK-MAX-TICKETS-PER-USER";
var bwXPropertyMaxWaitList = "X-BEDEWORK-WAIT-LIST-LIMIT";

var bwXPropertyRegistrationStart = "X-BEDEWORK-REGISTRATION-START";
var bwXPropertyRegistrationEnd = "X-BEDEWORK-REGISTRATION-END";
var bwXPropertyRegistrationForm = "X-BEDEWORK-REGISTRATION-FORM";
var bwXPropertyRegistrationInternal = "X-BEDEWORK-REGISTRATION-INTERNAL";
var bwXPropertyRegistrationExternal = "X-BEDEWORK-REGISTRATION-EXTERNAL";
var bwXPropertyInstanceOnly = "X-BEDEWORK-INSTANCE-ONLY";


var bwXParamDisplayName = "X-BEDEWORK-PARAM-DISPLAYNAME";
var bwXParamPath = "X-BEDEWORK-PARAM-PATH";
var bwXParamAliasPath = "X-BEDEWORK-PARAM-ALIASPATH";
var bwXParamDescription = "X-BEDEWORK-PARAM-DESCRIPTION";
var bwXParamAlt = "X-BEDEWORK-PARAM-ALT";
var bwXParamWidth = "X-BEDEWORK-PARAM-WIDTH";
var bwXParamHeight = "X-BEDEWORK-PARAM-HEIGHT";
var bwXParamSubAddress = "X-BEDEWORK-PARAM-SUBADDRESS";
var bwXParamURL = "X-BEDEWORK-PARAM-URL";
var bwXParamPhone = "X-BEDEWORK-PARAM-PHONE";
var bwXParamEmail = "X-BEDEWORK-PARAM-EMAIL";
var bwXParamClaimantUser = "X-BEDEWORK-SUBMISSION-CLAIMANT-USER";


// ========================================================================
// x-property functions
// ========================================================================

var bwXProps = new BwXProperties();

/* An xproperty
 * name:   String - name of x-property, e.g. "X-BEDEWORK-IMAGE"
 * params: 2-D Array of parameter name/value pairs,
 *         e.g. params[0] = ["X-BEDEWORK-PARAM-DESCRIPTION","a lovely image"]
 * value:  String - value of x-property
 */
function BwXProperty(name, params, value) {
  this.name = name;
  this.params = params;
  this.value = value;

  this.format = function() {
    var curXparams = "";
    if (this.params.length) {
      for (var i = 0; i < this.params.length; i++) {
        if (this.params[i][1] != "") {
          curXparams += ";" + this.params[i][0];
          // if parameter values contain ";" or ":" or "," they must be quoted
          if (this.params[i][1].indexOf(":") != -1 || this.params[i][1].indexOf(";") != -1 || this.params[i][1].indexOf(",") != -1) {
            curXparams += "=\"" + this.params[i][1] + "\"";
          } else {
            curXparams += "=" + this.params[i][1];
          }
        }
      }
    }
    return this.name + curXparams + ":" + this.value;
  }
}

function BwXProperties() {
  var xproperties = new Array();

  this.init = function(name, params, value) {
     var xprop = new BwXProperty(name, params, value);
     xproperties.push(xprop);
  }

  // update an xproperty
  // isUnique - only one xproperty of the given name should exist
  // isUniqueByValue - only one xproperty with name and value pair should exist 
  this.update = function(name, params, value, isUnique, isUniqueByValue) {
    // strip out any double quotes in the parameter values:
    if (params.length) {
      for (var i = 0; i < params.length; i++) {
        var strippedParamValue = "";
        for (var j = 0; j < params[i][1].length; j++) {
          var currWord = params[i][1];
          var c = currWord.charAt(j); // Helps IE to get the desired character at the specified position.
          if (c != '"') {
            strippedParamValue += c;
          }
        }
        params[i][1] = strippedParamValue;
      }
    }

    // add or update the xproperty:
    var xprop = new BwXProperty(name, params, value);
    if (isUniqueByValue) {
      // If it doesn't exist add it.  If it already exists do nothing.
      index = this.getIndexByValue(name,value);
      if (index < 0) {
        xproperties.push(xprop);
      }
    } else if (isUnique) {
      // If it doesn't exist add it.  Otherwise, update it.
      index = this.getIndex(name);
      if (index < 0) {
        xproperties.push(xprop);
      } else {
        xproperties.splice(index,1,xprop);
      }
    } else {
      xproperties.push(xprop);
    }
  }

  this.remove = function(name) {
    index = this.getIndex(name);
    if (index > -1) {
      xproperties.splice(index,1);
    }
  }

  this.removeByValue = function(name, value) {
    index = this.getIndexByValue(name, value);
    if (index > -1) {
      xproperties.splice(index,1);
    }
  }

  this.getIndex = function(name) {
    for (var i = 0; i < xproperties.length; i++) {
      var curXprop = xproperties[i];
      if (curXprop.name == name) {
        return i;
      }
    }
    return -1;
  }

  this.getIndexByValue = function(name,value) {
    for (var i = 0; i < xproperties.length; i++) {
      var curXprop = xproperties[i];
      if (curXprop.name == name) {
        if (curXprop.value == value) {
          return i;
        }
      }
    }
    return -1;
  }

  this.display = function(formObj) { // for debugging
    var textOutput = '';
    for (var i = 0; i < xproperties.length; i++) {
      textOutput += xproperties[i].format() + "\n";
    }
    return textOutput;
  } 

  this.generate = function(formObj) {
    for (var i = 0; i < xproperties.length; i++) {
      var xpropField = document.createElement("input");
      xpropField.type = "hidden"; // change type prior to appending to DOM
      formObj.appendChild(xpropField);
      xpropField.name = "xproperty";
      xpropField.value = xproperties[i].format();
    }
  }

}
