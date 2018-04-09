//! moment-tzdist.js
//! version : 0.1
//! author : Mike Douglass
//! license : Apache 2

(function (root, factory) {
	"use strict";

	/*global define*/
	if (typeof define === 'function' && define.amd) {
		define(['moment'], factory);                 // AMD
	} else if (typeof exports === 'object') {
		module.exports = factory(require('moment')); // Node
	} else {
		factory(root.moment);                        // Browser
	}
}(this, function (moment) {
	"use strict";

	// Do not load moment-tzdist a second time.
	if (moment.tz !== undefined) { return moment; }

	var VERSION = "0.1",
      zones = {},
      links = {},

      momentVersion = moment.version.split('.'),
      major = +momentVersion[0],
      minor = +momentVersion[1];

	// Moment.js version check
	if (major < 2 || (major === 2 && minor < 6)) {
		logError('Moment Tzdist requires Moment.js >= 2.6.0. You are using Moment.js ' + moment.version + '. See momentjs.com');
	}
	/************************************
		Zone object
	************************************/

	function Zone(name) {
		if (name) {
			this._set(name);
		}
	}

	Zone.prototype = {
		_set : function (name) {
			this.name = name;
		},

		parse : function (timestamp) {
      return tzs.getOffset(timestamp, this.name);
		},

		abbr : function (mom) {
			return this.name; // TODO need a abbreviated name
		},

		offset : function (mom) {
			return this.parse(mom.format("YYYY-MM-DDTHH:mm:ss"));
		}
	};

	/************************************
		Global Methods
	************************************/

	function getZone(name) {
		return new Zone(name);
	}

	function getNames() {
		var i, out = [];

		for (i in zones) {
			if (zones.hasOwnProperty(i) && zones[i]) {
				out.push(zones[i].name);
			}
		}

		return out.sort();
	}

	function needsOffset (m) {
		return !!(m._a && (m._tzm === undefined));
	}

	function logError (message) {
		if (typeof console !== 'undefined' && typeof console.error === 'function') {
			console.error(message);
		}
	}

	/************************************
		moment.tz namespace
	************************************/

	function tz() {
		var args = Array.prototype.slice.call(arguments, 0, -1),
			name = arguments[arguments.length - 1],
			zone = getZone(name),
			out  = moment.utc.apply(null, args);

		if (zone && needsOffset(out)) {
      /* Note the oddity with sign of timezone offset and
       UTC offset
       http://stackoverflow.com/questions/22275025/inverted-zone-in-moment-timezone
       */
			out.add(-zone.parse(out.format("YYYY-MM-DDTHH:mm:ss")), 'minutes');
		}

		out.tz(name);

		return out;
	}

	tz.version      = VERSION;
	tz.dataVersion  = '';
	tz._zones       = zones;
	tz._links       = links;
	tz.names        = getNames;
	tz.Zone         = Zone;
	tz.needsOffset  = needsOffset;
	tz.moveInvalidForward   = true;
	tz.moveAmbiguousForward = false;

	/************************************
		Interface with Moment.js
	************************************/

	var fn = moment.fn;

	moment.tz = tz;

	moment.updateOffset = function(mom, keepTime) {
		var offset;
		if (mom._tzid) {
			offset = -tzs.getOffset(mom.format("YYYY-MM-DDTHH:mm:ss"), mom._tzid);
			if (Math.abs(offset) < 16) {
				offset = offset / 60;
			}
			mom.zone(offset, keepTime);
		}
	};

	fn.tz = function(name) {
		if (name) {
			this._tzid = name;
			if (this._tzid) {
				moment.updateOffset(this);
			} else {
				logError("Moment Timezone has no data for " + name + ". See http://momentjs.com/timezone/docs/#/data-loading/.");
			}
			return this;
		}
		if (this._tzid) {
      return this._tzid;
    }
	};

	function abbrWrap (old) {
		return function () {
			if (this._tzid) { return this._tzid; }
			return old.call(this);
		};
	}

	function resetZoneWrap (old) {
		return function () {
			this._tzid = null;
			return old.apply(this, arguments);
		};
	}

	fn.zoneName = abbrWrap(fn.zoneName);
	fn.zoneAbbr = abbrWrap(fn.zoneAbbr);
	fn.utc      = resetZoneWrap(fn.utc);

	// Cloning a moment should include the _tzid property.
	var momentProperties = moment.momentProperties;
	if (Object.prototype.toString.call(momentProperties) === '[object Array]') {
		// moment 2.8.1+
		momentProperties.push('_tzid');
		momentProperties.push('_a');
	} else if (momentProperties) {
		// moment 2.7.0
		momentProperties._tzid = null;
	}

	// INJECT DATA

	return moment;
}));
