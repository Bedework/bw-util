/* ********************************************************************
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
package org.bedework.util.calendar;

import net.fortuna.ical4j.model.Component;
import net.fortuna.ical4j.model.Property;
import net.fortuna.ical4j.model.PropertyList;
import net.fortuna.ical4j.model.property.DtEnd;
import net.fortuna.ical4j.model.property.Sequence;

import java.sql.Timestamp;

//import net.fortuna.ical4j.model.property.Categories;
//import net.fortuna.ical4j.model.property.Clazz;
//import net.fortuna.ical4j.model.property.Contact;
//import net.fortuna.ical4j.model.property.Created;
//import net.fortuna.ical4j.model.property.Description;
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
//import net.fortuna.ical4j.model.property.Summary;
//import net.fortuna.ical4j.model.property.Uid;
//import net.fortuna.ical4j.model.property.Url;
//import net.fortuna.ical4j.model.property.Version;

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

