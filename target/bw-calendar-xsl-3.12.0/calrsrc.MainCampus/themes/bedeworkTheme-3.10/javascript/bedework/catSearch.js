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
 * @author jeremy
 */
function initCat() {
  var handleForm = new CatForm;
  handleForm.validForm();
  handleForm.searchField();

  return handleForm.retVal;
}

function CatForm() {
  this.retVal = true;
  this.myCatStr = '';
  this.theForm = document.getElementById('advSearchForm');
}

CatForm.prototype.validForm = function() {
  var currForm = this.theForm;
  for (var i = 0; i < currForm.elements.length; i++) {
    if(currForm.elements[i].type === "checkbox" && currForm.elements[i].checked) {
      this.myCatStr += "category: " + currForm.elements[i].value + " ";
    }
  }

  return;
}
CatForm.prototype.searchField = function() {
  var searchVal = this.theForm.query.value;
  var trimmed = searchVal.replace(/^\s+|\s+$/g, '') ;
  if(trimmed === '') {
    if (this.myCatStr === '') {
      this.retVal = false;
    } else {
      this.theForm.query.value = this.myCatStr;
    }
  } else {
    if(this.myCatStr != '') {
      this.theForm.query.value = this.theForm.query.value + " AND " + this.myCatStr;
    } else {
      return false;
    }
  }

  return;
}
