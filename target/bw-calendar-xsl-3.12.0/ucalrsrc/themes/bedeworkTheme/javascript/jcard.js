/**
##
# Copyright (c) 2013-2014 Apple Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
##
*/

/* Copy of jcal.js modified to handle jcard */

jcalparser = {
	PARSER_ALLOW : 0, 	// Pass the "suspect" data through to the object model
	PARSER_IGNORE : 1, 	// Ignore the "suspect" data
	PARSER_FIX: 2, 		// Fix (or if not possible ignore) the "suspect" data
	PARSER_RAISE: 3 	// Raise an exception
}

// Some clients escape ":" - fix
jcalparser.INVALID_COLON_ESCAPE_SEQUENCE = jcalparser.PARSER_FIX;

// Other escape sequences - raise
jcalparser.INVALID_ESCAPE_SEQUENCES = jcalparser.PARSER_RAISE;

// Some client generate empty lines in the body of the data
jcalparser.BLANK_LINES_IN_DATA = jcalparser.PARSER_FIX;

// Some clients still generate vCard 2 parameter syntax
jcalparser.VCARD_2_NO_PARAMETER_VALUES = jcalparser.PARSER_ALLOW;

// Use this to fix v2 BASE64 to v3 ENCODING=b - only PARSER_FIX or PARSER_ALLOW
jcalparser.VCARD_2_BASE64 = jcalparser.PARSER_FIX;

// Allow DATE values when DATETIME specified (and vice versa)
jcalparser.INVALID_DATETIME_VALUE = jcalparser.PARSER_FIX;

// Allow slightly invalid DURATION values
jcalparser.INVALID_DURATION_VALUE = jcalparser.PARSER_FIX;

// Truncate over long ADR and N values
jcalparser.INVALID_ADR_N_VALUES = jcalparser.PARSER_FIX;

// REQUEST-STATUS values with \; as the first separator or single element
jcalparser.INVALID_REQUEST_STATUS_VALUE = jcalparser.PARSER_FIX;

// Remove \-escaping in URI values when parsing - only PARSER_FIX or PARSER_ALLOW
jcalparser.BACKSLASH_IN_URI_VALUE = jcalparser.PARSER_FIX;

/** This class represent a vcard object in json jcal.
 * The top level is represented by an array with 2 elements:
 *
 * 1.  A string with the name of the component, but in lowercase.
 *
 * 2.  An array of jCard properties as described in Section 3.4.
 *
 * @param carddata - the above 2 element array
 */
jcard = function(carddata) {
	this.carddata = carddata;
};

jcard.newCard = function() {
	var card = new jcard(["vcard", []]);
	card.newProperty("version", "3.0");
	return card;
};

jcard.fromString = function(data) {
	return new jcard($.parseJSON(data));
};

jcard.prototype.toString = function() {
	return JSON.stringify(this.carddata);
};

jcard.prototype.duplicate = function() {
	return new jcard($.parseJSON(this.toString()));
};

jcard.prototype.name = function() {
	return this.carddata[0];
};

function makejcard(name, defaultProperties) {
  var jcomp = new jcard([name.toLowerCase(), []]);
  if (defaultProperties) {
    // Add UID and DTSTAMP
    jcomp.newProperty("uid", generateUUID());
    jcomp.newProperty("dtstamp", jcalTimestamp(), {}, "date-time");
  }
  return jcomp;
}

jcard.prototype.newProperty = function(name, value, params, value_type) {
	var prop = [name.toLowerCase(), params === undefined ? {} : params, value_type == undefined ? "text" : value_type];
	if (value instanceof Array) {
		$.each(value, function(index, single) {
			prop.push(single);
		});
	} else {
		prop.push(value);
	}
	this.carddata[1].push(prop);
	return prop;
};

jcard.prototype.copyProperty = function(name, component) {
	var propdata = component.getProperty(name);
	this.carddata[1].push([propdata[0], propdata[1], propdata[2], propdata[3]]);
	return propdata;
};

jcard.prototype.hasProperty = function(name) {
	var result = false;
	name = name.toLowerCase();
	$.each(this.carddata[1], function(index, property) {
		if (property[0] === name) {
			result = true;
			return false;
		}
	});
	return result;
};

jcard.prototype.getProperty = function(name) {
	var result = null;
	name = name.toLowerCase();
	$.each(this.carddata[1], function(index, property) {
		if (property[0] === name) {
			result = property;
			return false;
		}
	});
	return result;
};

jcard.prototype.getPropertyValue = function(name) {
	var result = null;
	name = name.toLowerCase();
	$.each(this.carddata[1], function(index, propdata) {
		if (propdata[0] === name) {
			result = propdata[3];
			return false;
		}
	});
	return result;
};

jcard.prototype.updateProperty = function(name, value, params, valueType) {
	if (params === undefined) {
		params = {};
	}
	if (valueType === undefined) {
		valueType = "text";
	}
	var props = this.properties(name);
	if (props.length == 1) {
		props[0][1] = params;
		props[0][2] = valueType;
		props[0][3] = value;

		return props[0];
	}

  if (props.length == 0) {
		return this.newProperty(name, value, params, valueType);
	}
};

jcard.prototype.properties = function(name) {
	return $.grep(this.carddata[1], function(propdata, index) {
		return propdata[0] == name;
	});
};

jcard.prototype.removeProperties = function(name) {
	name = name.toLowerCase();
	this.carddata[1] = $.grep(this.carddata[1], function(propdata, index) {
		return propdata[0] != name;
	});
};

/**
 * remove nth (starting at 0) property with given name
 * @param name
 * @param index
 */
jcard.prototype.removePropertyMatching = function(name, indexToRemove) {
  name = name.toLowerCase();
  var i = 0;
  this.carddata[1] = $.grep(this.carddata[1], function(propdata, index) {
    if (propdata[0] !== name) {
      return true;
    }

    i++;

    return indexToRemove !== (i - 1);
  });
};

// Remove properties for which test() returns true
jcard.prototype.removePropertiesMatching = function(test) {
	this.carddata[1] = $.grep(this.carddata[1], function(propdata, index) {
		return !test(propdata);
	});
};

function digits2(val) {
  var i = parseInt(val);
  if (i > 9) {
    return val;
  }

  return "0" + i;
}

function digits4(val) {
  return ("000" + val).substr(-4);
}

function jcalTimestamp() {
  return new Date().toISOString().substr(0, 19) + "Z";
}
