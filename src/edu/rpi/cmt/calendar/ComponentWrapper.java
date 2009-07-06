/*
 Copyright (c) 2000-2005 University of Washington.  All rights reserved.

 Redistribution and use of this distribution in source and binary forms,
 with or without modification, are permitted provided that:

   The above copyright notice and this permission notice appear in
   all copies and supporting documentation;

   The name, identifiers, and trademarks of the University of Washington
   are not used in advertising or publicity without the express prior
   written permission of the University of Washington;

   Recipients acknowledge that this distribution is made available as a
   research courtesy, "as is", potentially with defects, without
   any obligation on the part of the University of Washington to
   provide support, services, or repair;

   THE UNIVERSITY OF WASHINGTON DISCLAIMS ALL WARRANTIES, EXPRESS OR
   IMPLIED, WITH REGARD TO THIS SOFTWARE, INCLUDING WITHOUT LIMITATION
   ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
   PARTICULAR PURPOSE, AND IN NO EVENT SHALL THE UNIVERSITY OF
   WASHINGTON BE LIABLE FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL
   DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR
   PROFITS, WHETHER IN AN ACTION OF CONTRACT, TORT (INCLUDING
   NEGLIGENCE) OR STRICT LIABILITY, ARISING OUT OF OR IN CONNECTION WITH
   THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */
/* **********************************************************************
    Copyright 2005 Rensselaer Polytechnic Institute. All worldwide rights reserved.

    Redistribution and use of this distribution in source and binary forms,
    with or without modification, are permitted provided that:
       The above copyright notice and this permission notice appear in all
        copies and supporting documentation;

        The name, identifiers, and trademarks of Rensselaer Polytechnic
        Institute are not used in advertising or publicity without the
        express prior written permission of Rensselaer Polytechnic Institute;

    DISCLAIMER: The software is distributed" AS IS" without any express or
    implied warranty, including but not limited to, any implied warranties
    of merchantability or fitness for a particular purpose or any warrant)'
    of non-infringement of any current or pending patent rights. The authors
    of the software make no representations about the suitability of this
    software for any particular purpose. The entire risk as to the quality
    and performance of the software is with the user. Should the software
    prove defective, the user assumes the cost of all necessary servicing,
    repair or correction. In particular, neither Rensselaer Polytechnic
    Institute, nor the authors of the software are liable for any indirect,
    special, consequential, or incidental damages related to the software,
    to the maximum extent the law permits.
*/

package edu.rpi.cmt.calendar;

import net.fortuna.ical4j.model.Component;
import net.fortuna.ical4j.model.Property;
//import net.fortuna.ical4j.model.property.Categories;
//import net.fortuna.ical4j.model.property.Clazz;
//import net.fortuna.ical4j.model.property.Contact;
//import net.fortuna.ical4j.model.property.Created;
//import net.fortuna.ical4j.model.property.Description;
import net.fortuna.ical4j.model.property.DtEnd;
//import net.fortuna.ical4j.model.property.DtStamp;
//import net.fortuna.ical4j.model.property.DtStart;
//import net.fortuna.ical4j.model.property.Due;
//import net.fortuna.ical4j.model.property.ExDate;
//import net.fortuna.ical4j.model.property.ExRule;
//import net.fortuna.ical4j.model.property.LastModified;
//import net.fortuna.ical4j.model.property.Location;
//import net.fortuna.ical4j.model.property.Organizer;
//import net.fortuna.ical4j.model.property.ProdId;
//import net.fortuna.ical4j.model.property.RDate;
//import net.fortuna.ical4j.model.property.RRule;
import net.fortuna.ical4j.model.property.Sequence;
//import net.fortuna.ical4j.model.property.Summary;
//import net.fortuna.ical4j.model.property.Uid;
//import net.fortuna.ical4j.model.property.Url;
//import net.fortuna.ical4j.model.property.Version;
import net.fortuna.ical4j.model.PropertyList;

import java.sql.Timestamp;

/** Wrap an ical4j object so we can easily access properties
 *
 * <pre>Properties not yet dealt with:
 *
static java.lang.String   ACTION
static java.lang.String   ATTACH
static java.lang.String   ATTENDEE
static java.lang.String   CALSCALE
static java.lang.String   CATEGORIES
static java.lang.String   COMMENT
static java.lang.String   COMPLETED
static java.lang.String   CONTACT
static java.lang.String   DTSTAMP
static java.lang.String   EXDATE
static java.lang.String   EXRULE
static java.lang.String   FREEBUSY
static java.lang.String   GEO
static java.lang.String   LOCATION
static java.lang.String   METHOD
static java.lang.String   ORGANIZER
static java.lang.String   PERCENT_COMPLETE
static java.lang.String   PRIORITY
static java.lang.String   PRODID
static java.lang.String   RDATE
static java.lang.String   RECURRENCE_ID
static java.lang.String   RELATED_TO
static java.lang.String   REPEAT
static java.lang.String   REQUEST_STATUS
static java.lang.String   RESOURCES
static java.lang.String   RRULE
static java.lang.String   RSTATUS
static java.lang.String   TRIGGER
static java.lang.String   TZID
static java.lang.String   TZNAME
static java.lang.String   TZOFFSETFROM
static java.lang.String   TZOFFSETTO
static java.lang.String   TZURL
static java.lang.String   URL
static java.lang.String   VERSION</pre>
  */
public class ComponentWrapper {
//  private Component comp;

  private PropertyList pl;

  /** Constructor
   *
   * @param comp  wrapped component
   */
  public ComponentWrapper(Component comp) {
//    this.comp = comp;
    pl = comp.getProperties();
  }

  /**
   * CLASS
   *
   * @return value
   */
  public boolean getPublic() {
    return "PUBLIC".equals(getPval(Property.CLASS));
  }

  /**
   * CREATED
   *
   * @return value
   */
  public String getCreated() {
    return getPval(Property.CREATED);
  }

  /**
   * DESCRIPTION
   *
   * @return value
   */
  public String getDescription() {
    return getPval(Property.DESCRIPTION);
  }

  /**
   * DTEND
   *
   * @return value
   */
  public Timestamp getDtend() {
    Property prop = getProp(Property.DTEND);

    if (prop == null) {
      return null;
    }

    return makeSqlTimestamp(((DtEnd)prop).getDate());
  }

  /**
   * DTSTAMP
   *
   * @return value
   */
  public String getDtStamp() {
    return getPval(Property.DTSTAMP);
  }

  /**
   * DTSTART
   *
   * @return value
   */
  public String getDtstart() {
    return getPval(Property.DTSTART);
  }

  /**
   * DUE
   *
   * @return value
   */
  public String getDue() {
    return getPval(Property.DUE);
  }

  /**
   * DURATION
   *
   * @return value
   */
  public String getDuration() {
    return getPval(Property.DURATION);
  }

  /**
   * LAST_MODIFIED
   *
   * @return value
   */
  public String getLastModified() {
    return getPval(Property.CREATED);
  }

  /**
   * SEQUENCE
   *
   * @return value
   */
  public Integer getSequence() {
    Property prop = getProp(Property.SEQUENCE);

    if (prop == null) {
      return null;
    }

    return new Integer(((Sequence)prop).getSequenceNo());
  }

  /**
   * STATUS
   *
   * @return value
   */
  public String getStatus() {
    return getPval(Property.STATUS);
  }

  /**
   * SUMMARY
   *
   * @return value
   */
  public String getSummary() {
    return getPval(Property.SUMMARY);
  }

  /**
   * TRANSP
   *
   * @return value
   */
  public String getTransp() {
    return getPval(Property.TRANSP);
  }

  /**
   * UID
   *
   * @return value
   */
  public String getUid() {
    return getPval(Property.UID);
  }

  /* ====================================================================
   *                   Private methods
   * ==================================================================== */

  private Property getProp(String name) {
    if (pl == null) {
      // Empty Component
      return null;
    }

    return pl.getProperty(name);
  }

  private String getPval(String name) {
    Property prop = getProp(name);

    if (prop == null) {
      return null;
    }

    return prop.getValue();
  }

  /* Get a sql timestamp object from a date-time */
  private Timestamp makeSqlTimestamp(java.util.Date dtTm) {
    return new Timestamp(dtTm.getTime());
  }
}

