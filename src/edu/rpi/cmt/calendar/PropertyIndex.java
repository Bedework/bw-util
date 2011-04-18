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
package edu.rpi.cmt.calendar;

import edu.rpi.sss.util.xml.tagdefs.BedeworkServerTags;
import edu.rpi.sss.util.xml.tagdefs.XcalTags;

import java.io.Serializable;
import java.util.HashMap;

import javax.xml.namespace.QName;

/** Define an (arbitrary) index associated with calendar properties
 *
 * @author Mike Douglass   douglm@rpi.edu
 */
public class PropertyIndex implements Serializable {
  private PropertyIndex() {};

  static class ComponentFlags {
    private boolean eventProperty;
    private boolean todoProperty;
    private boolean journalProperty;
    private boolean freeBusyProperty;
    private boolean timezoneProperty;
    private boolean alarmProperty;
    private boolean vavailabilityProperty;
    private boolean availableProperty;

    ComponentFlags(final boolean eventProperty,
                   final boolean todoProperty,
                   final boolean journalProperty,
                   final boolean freeBusyProperty,
                   final boolean timezoneProperty,
                   final boolean alarmProperty,
                   final boolean vavailabilityProperty,
                   final boolean availableProperty) {
      this.eventProperty = eventProperty;
      this.todoProperty = todoProperty;
      this.journalProperty = journalProperty;
      this.freeBusyProperty = freeBusyProperty;
      this.timezoneProperty = timezoneProperty;
      this.alarmProperty = alarmProperty;
      this.vavailabilityProperty = vavailabilityProperty;
      this.availableProperty = availableProperty;
    }
  }

  static final ComponentFlags noComponent =
     new ComponentFlags(false, false, false, false, false, false, false, false);

  static final ComponentFlags eventOnly =
     new ComponentFlags(true, false, false, false, false, false, false, false);

  static final ComponentFlags todoOnly =
     new ComponentFlags(false, true, false, false, false, false, false, false);

  static final ComponentFlags freebusyOnly =
     new ComponentFlags(false, false, false, true, false, false, false, false);

  static final ComponentFlags timezoneOnly =
     new ComponentFlags(false, false, false, false, true, false, false, false);

  static final ComponentFlags alarmOnly =
     new ComponentFlags(false, false, false, false, false, true, false, false);

  static final ComponentFlags vavailabilityOnly =
     new ComponentFlags(false, false, false, false, false, false, true, false);

  static final ComponentFlags availableOnly =
    new ComponentFlags(false, false, false, false, false, false, false, true);

  static final ComponentFlags event_Todo =
     new ComponentFlags(true, true, false, false, false, false, false, false);

  static final ComponentFlags event_Todo_Journal =
     new ComponentFlags(true, true, true, false, false, false, false, false);

  static final ComponentFlags event_Todo_Freebusy =
     new ComponentFlags(true, true, false, true, false, false, false, false);

  static final ComponentFlags event_Freebusy =
     new ComponentFlags(true, false, false, true, false, false, false, false);

  static final ComponentFlags event_Todo_Journal_Freebusy =
     new ComponentFlags(true, true, true, true, false, false, false, false);

  static final ComponentFlags event_Todo_Journal_Timezone =
     new ComponentFlags(true, true, true, false, true, false, false, false);

  static final ComponentFlags event_Todo_Journal_Alarm =
     new ComponentFlags(true, true, true, false, false, true, false, false);

  static final ComponentFlags notTimezone =
     new ComponentFlags(true, true, true, true, false, true, false, false);

  static final ComponentFlags notAlarm =
     new ComponentFlags(true, true, true, true, true, false, false, false);

  static final ComponentFlags allComponents =
     new ComponentFlags(true, true, true, true, true, true, false, false);

  private static boolean IS_MULTI = true;

  private static boolean IS_SINGLE = false;

  private static boolean IS_PARAM = true;

  private static boolean NOT_PARAM = false;

  private static boolean IS_IMMUTABLE = true;

  private static boolean NOT_IMMUTABLE = false;

  /** */
  public static enum DataType {
    /** */
    BINARY(XcalTags.binaryVal),

    /** */
    BOOLEAN(XcalTags.booleanVal),

    /** */
    CUA(XcalTags.calAddressVal),

    /** */
    DATE(XcalTags.dateVal),

    /** */
    DATE_TIME(XcalTags.dateTimeVal),

    /** */
    DURATION(XcalTags.duration),

    /** */
    FLOAT(XcalTags.floatVal),

    /** */
    INTEGER(XcalTags.integerVal),

    /** */
    PERIOD(XcalTags.periodVal),

    /** */
    RECUR(XcalTags.recurVal),

    /** */
    TEXT(XcalTags.textVal),

    /** */
    TIME(XcalTags.timeVal),

    /** */
    URI(XcalTags.uriVal),

    /** */
    UTC_OFFSET(XcalTags.utcOffsetVal),

    /** More work */
    SPECIAL(null),

    /** Non-ical */
    HREF(null);

    private QName xcalType;

    DataType(final QName xcalType) {
      this.xcalType = xcalType;
    }

    /**
     * @return type or null
     */
    public QName getXcalType() {
      return xcalType;
    }
  };

  /** */
  public static enum ParameterInfoIndex {
    /** */
    UNKNOWN_PARAMETER(null),

    /**
     * Region abbreviation.
     */
    ABBREV("ABBREV"),

    /**
     * Alternate text representation.
     */
    ALTREP("ALTREP"),

    /**
     * Common name.
     */
    CN("CN"),

    /**
     * Calendar user type.
     */
    CUTYPE("CUTYPE"),

    /**
     * Delegator.
     */
    DELEGATED_FROM("DELEGATED-FROM"),

    /**
     * Delegatee.
     */
    DELEGATED_TO("DELEGATED-TO"),

    /**
     * Directory entry.
     */
    DIR("DIR"),

    /**
     * Inline encoding.
     */
    ENCODING("ENCODING"),

    /**
     * Format type.
     */
    FMTTYPE("FMTTYPE"),

    /**
     * Free/busy time type.
     */
    FBTYPE("FBTYPE"),

    /**
     * Language for text.
     */
    LANGUAGE("LANGUAGE"),

    /**
     * Group or list membership.
     */
    MEMBER("MEMBER"),

    /**
     * Participation status.
     */
    PARTSTAT("PARTSTAT"),

    /**
     * Recurrence identifier range.
     */
    RANGE("RANGE"),

    /**
     * Alarm trigger relationship.
     */
    RELATED("RELATED"),

    /**
     * Relationship type.
     */
    RELTYPE("RELTYPE"),

    /**
     * Participation role.
     */
    ROLE("ROLE"),

    /**
     * RSVP expectation.
     */
    RSVP("RSVP"),

    /**
     * Schedule agent.
     */
    SCHEDULE_AGENT("SCHEDULE-AGENT"),

    /**
     * Schedule status.
     */
    SCHEDULE_STATUS("SCHEDULE-STATUS"),

    /**
     * Sent by.
     */
    SENT_BY("SENT-BY"),

    /**
     * Type.
     */
    TYPE("TYPE"),

    /**
     * Reference to time zone object.
     */
    TZID("TZID"),

    /**
     * Property value data type.
     */
    VALUE("VALUE");

    private String pname;

    private DataType ptype;

    private static HashMap<String, ParameterInfoIndex> pnameLookup =
      new HashMap<String, ParameterInfoIndex>();

    static {
      for (ParameterInfoIndex pii: values()) {
        String pname = pii.getPname();

        if (pname != null) {
          pname = pname.toLowerCase();
        }
        pnameLookup.put(pname, pii);
      }
    }

    ParameterInfoIndex(final String pname) {
      this(pname, DataType.TEXT);
    }

    ParameterInfoIndex(final String pname,
                      final DataType ptype) {
      this.pname = pname;
      this.ptype = ptype;
    }

    /** get the parameter name
     *
     * @return parameter name
     */
    public String getPname() {
      return pname;
    }

    /** get the parameter type
     *
     * @return parameter type
     */
    public DataType getPtype() {
      return ptype;
    }

    /** get the index given the parameter name
     *
     * @param val
     * @return ParameterInfoIndex
     */
    public static ParameterInfoIndex lookupPname(final String val) {
      return pnameLookup.get(val.toLowerCase());
    }
  }

  /** */
  public static enum PropertyInfoIndex {
    /** */
    UNKNOWN_PROPERTY(null, null, IS_SINGLE, noComponent),

    /** */
    CLASS(XcalTags._class, "CLASS", IS_SINGLE, event_Todo_Journal),

    /** */
    CREATED(XcalTags.created, "CREATED", DataType.DATE_TIME,
            IS_SINGLE, event_Todo_Journal_Freebusy),

    /** */
    DESCRIPTION(XcalTags.description, "DESCRIPTION",
                IS_SINGLE, IS_MULTI, event_Todo_Journal_Alarm),

    /** */
    DTSTAMP(XcalTags.dtstamp, "DTSTAMP", DataType.DATE_TIME,
            IS_SINGLE, event_Todo_Journal_Freebusy,
            NOT_PARAM, NOT_IMMUTABLE),

    /** */
    DTSTART(XcalTags.dtstart, "DTSTART", DataType.DATE_TIME,
            IS_SINGLE, notAlarm),

    /** */
    DURATION(XcalTags.duration, "DURATION", DataType.DURATION,
             IS_SINGLE, event_Todo_Freebusy),

    /** */
    GEO(XcalTags.geo, "GEO", IS_SINGLE, event_Todo),

    /** */
    LAST_MODIFIED(XcalTags.lastModified, "LAST-MODIFIED", DataType.DATE_TIME,
                  IS_SINGLE, event_Todo_Journal_Timezone,
                  NOT_PARAM, NOT_IMMUTABLE),

    /** */
    LOCATION(XcalTags.location, "LOCATION", IS_SINGLE, event_Todo),

    /** */
    ORGANIZER(XcalTags.organizer, "ORGANIZER", DataType.CUA,
              IS_SINGLE, event_Todo_Journal_Freebusy),

    /** */
    PRIORITY(XcalTags.priority, "PRIORITY", DataType.INTEGER,
             IS_SINGLE, event_Todo),

    /** */
    RECURRENCE_ID(XcalTags.recurrenceId, "RECURRENCE-ID", DataType.DATE_TIME,
                  IS_SINGLE, event_Todo_Journal_Freebusy),

    /** */
    SEQUENCE(XcalTags.sequence, "SEQUENCE", DataType.INTEGER,
             IS_SINGLE, event_Todo_Journal,
             NOT_PARAM, NOT_IMMUTABLE),

    /** */
    STATUS(XcalTags.status, "STATUS", IS_SINGLE, event_Todo_Journal),

    /** */
    SUMMARY(XcalTags.summary, "SUMMARY", IS_SINGLE, IS_MULTI, event_Todo_Journal_Alarm),

    /** */
    UID(XcalTags.uid, "UID", IS_SINGLE, event_Todo_Journal_Freebusy),

    /** */
    URL(XcalTags.url, "URL", DataType.URI,
        IS_SINGLE, event_Todo_Journal_Freebusy),

    /* Event only */

    /** */
    DTEND(XcalTags.dtend, "DTEND", DataType.DATE_TIME,
          IS_SINGLE, event_Freebusy),

    /** */
    TRANSP(XcalTags.transp, "TRANSP", IS_SINGLE, eventOnly),

    /* Todo only */

    /** */
    COMPLETED(XcalTags.completed, "COMPLETED", DataType.DATE_TIME,
              IS_SINGLE, todoOnly),

    /** */
    DUE(XcalTags.due, "DUE", DataType.DATE_TIME,
        IS_SINGLE, todoOnly),

    /** */
    PERCENT_COMPLETE(XcalTags.percentComplete, "PERCENT-COMPLETE",
                     IS_SINGLE, todoOnly),

    /* ---------------------------- Multi valued --------------- */

    /* Event and Todo */

    /** */
    ATTACH(XcalTags.attach, "ATTACH", DataType.SPECIAL,
           IS_MULTI, event_Todo_Journal_Alarm),

    /** */
    ATTENDEE(XcalTags.attendee, "ATTENDEE", DataType.CUA,
             IS_MULTI, notTimezone),

    /** */
    CATEGORIES(XcalTags.categories, "CATEGORIES",
               IS_MULTI, event_Todo_Journal_Alarm),

    /** */
    COMMENT(XcalTags.comment, "COMMENT",
            IS_MULTI, notAlarm),

    /** */
    CONTACT(XcalTags.contact, "CONTACT",
            IS_MULTI, event_Todo_Journal_Freebusy),

    /** */
    EXDATE(XcalTags.exdate, "EXDATE", DataType.DATE_TIME,
           IS_MULTI, event_Todo_Journal_Timezone),

    /** */
    EXRULE(XcalTags.exrule, "EXRULE", DataType.RECUR,
           IS_MULTI, event_Todo_Journal_Timezone),

    /** */
    REQUEST_STATUS(XcalTags.requestStatus, "REQUEST-STATUS",
                   IS_MULTI, event_Todo_Journal_Freebusy),

    /** */
    RELATED_TO(XcalTags.relatedTo, "RELATED-TO", IS_MULTI, event_Todo_Journal),

    /** */
    RESOURCES(XcalTags.resources, "RESOURCES", IS_MULTI, event_Todo),

    /** */
    RDATE(XcalTags.rdate, "RDATE", DataType.DATE_TIME,
          IS_MULTI, event_Todo_Journal_Timezone),

    /** */
    RRULE (XcalTags.rrule, "RRULE", DataType.RECUR,
           IS_MULTI, event_Todo_Journal_Timezone),

    /* -------------- Other non-event, non-todo ---------------- */

    /** */
    FREEBUSY(XcalTags.freebusy, "FREEBUSY", DataType.PERIOD,
             IS_SINGLE, freebusyOnly),

    /** */
    BUSYTYPE(XcalTags.busytype, "BUSYTYPE", IS_SINGLE, vavailabilityOnly),

    /** */
    TZID(XcalTags.tzid, "TZID", IS_SINGLE, timezoneOnly),

    /** */
    TZNAME(XcalTags.tzname, "TZNAME", IS_SINGLE, timezoneOnly),

    /** */
    TZOFFSETFROM(XcalTags.tzoffsetfrom, "TZOFFSETFROM", DataType.UTC_OFFSET,
                 IS_SINGLE, timezoneOnly),

    /** */
    TZOFFSETTO(XcalTags.tzoffsetto, "TZOFFSETTO", DataType.UTC_OFFSET,
               IS_SINGLE, timezoneOnly),

    /** */
    TZURL(XcalTags.tzurl, "TZURL", DataType.URI,
          IS_SINGLE, timezoneOnly),

    /** */
    ACTION(XcalTags.action, "ACTION", IS_SINGLE, alarmOnly),

    /** */
    REPEAT(XcalTags.repeat, "REPEAT", DataType.INTEGER,
           IS_SINGLE, alarmOnly),

    /** */
    TRIGGER(XcalTags.trigger, "TRIGGER", DataType.DURATION,
            IS_SINGLE, alarmOnly),

    /* -------------- Non-ical ---------------- */

    /** non ical */
    CREATOR(BedeworkServerTags.creator, "CREATOR", DataType.HREF,
            IS_SINGLE, event_Todo_Journal,
            NOT_PARAM, IS_IMMUTABLE),

    /** non ical */
    OWNER(BedeworkServerTags.owner, "OWNER", DataType.HREF,
          IS_SINGLE, event_Todo_Journal,
          NOT_PARAM, IS_IMMUTABLE),

    /** non ical */
    END_TYPE(BedeworkServerTags.endType, "END-TYPE",
             IS_SINGLE, event_Todo_Journal),

    /** non ical */
    COST(BedeworkServerTags.cost, "COST",
         IS_SINGLE, event_Todo),

    /** non ical */
    CTAG(BedeworkServerTags.ctag, "CTAG", DataType.TEXT,
         IS_SINGLE, noComponent,
         NOT_PARAM, IS_IMMUTABLE),

    /** non ical */
    DELETED(BedeworkServerTags.deleted, "DELETED",
            IS_SINGLE, event_Todo),

    /** non ical */
    ETAG(BedeworkServerTags.etag, "ETAG", DataType.TEXT,
         IS_SINGLE, noComponent,
         NOT_PARAM, IS_IMMUTABLE),

    /** non ical */
    COLLECTION(BedeworkServerTags.collection, "COLLECTION",
               IS_SINGLE, event_Todo_Journal),

    /** non ical */
    ENTITY_TYPE(BedeworkServerTags.entityType, "ENTITY_TYPE", DataType.INTEGER,
                IS_SINGLE, event_Todo_Journal,
                NOT_PARAM, IS_IMMUTABLE),

    /** treat VALARM sub-component as a property */
    VALARM(XcalTags.valarm, "VALARM", IS_MULTI, notAlarm),

    /** treat x-properties as a single multi-valued property */
    XPROP(BedeworkServerTags.xprop, "XPROP", IS_MULTI, allComponents),

    /** ----------------------------- Following are parameters ----------- */

    /** */
    LANG(BedeworkServerTags.language, "LANGUAGE", DataType.TEXT,
         IS_SINGLE, noComponent,
         IS_PARAM, NOT_IMMUTABLE),

    /** */
    TZIDPAR(XcalTags.tzid, "TZID", DataType.TEXT, IS_SINGLE, noComponent,
            IS_PARAM, NOT_IMMUTABLE),
            ;

    private QName qname;

    private String pname;

    private DataType ptype;

    /* true if the standard says it's multi */
    private boolean multiValued;

    /* true if we store multi - e.g. multi-language */
    private boolean dbMultiValued;

    private boolean param; /* It's a parameter   */

    private boolean immutable;

    private ComponentFlags components;

    private static HashMap<String, PropertyInfoIndex> pnameLookup =
      new HashMap<String, PropertyInfoIndex>();

    private static HashMap<QName, PropertyInfoIndex> qnameLookup =
      new HashMap<QName, PropertyInfoIndex>();

    static {
      for (PropertyInfoIndex pii: values()) {
        String pname = pii.getPname();

        if (pname != null) {
          pname = pname.toLowerCase();
        }
        pnameLookup.put(pname, pii);

        QName qname = pii.getQname();

        qnameLookup.put(qname, pii);
      }
    }

    PropertyInfoIndex(final QName qname,
                      final String pname,
                      final boolean multiValued,
                      final ComponentFlags components) {
      this.qname = qname;
      this.pname = pname;
      this.components = components;
      this.multiValued = multiValued;
      dbMultiValued = multiValued;
    }

    PropertyInfoIndex(final QName qname,
                      final String pname,
                      final DataType ptype, final boolean multiValued,
                      final ComponentFlags components) {
      this(qname, pname, multiValued, components);
      this.ptype = ptype;
    }

    PropertyInfoIndex(final QName qname,
                      final String pname,
                      final boolean multiValued,
                      final boolean dbMultiValued,
                      final ComponentFlags components) {
      this(qname, pname, DataType.TEXT, multiValued, components,
           NOT_PARAM, NOT_IMMUTABLE);
      this.dbMultiValued = dbMultiValued;
    }

    PropertyInfoIndex(final QName qname,
                      final String pname,
                      final DataType ptype,
                      final boolean multiValued,
                      final ComponentFlags components,
                      final boolean param,
                      final boolean immutable) {
      this(qname, pname, multiValued, components);
      this.ptype = ptype;
      this.param = param;
      this.immutable = immutable;
    }

    /** get the qname
     *
     * @return qname
     */
    public QName getQname() {
      return qname;
    }

    /** get the property name
     *
     * @return property name
     */
    public String getPname() {
      return pname;
    }

    /** get the property type
     *
     * @return property type
     */
    public DataType getPtype() {
      return ptype;
    }

    /** May need some elaboration - this is for the standard
     *
     * @return boolean
     */
    public boolean getMultiValued() {
      return multiValued;
    }

    /** May need some elaboration - this is for the db
     *
     * @return boolean
     */
    public boolean getDbMultiValued() {
      return dbMultiValued;
    }

    /** True if it's a parameter
     *
     * @return boolean
     */
    public boolean getParam() {
      return param;
    }

    /** True if it's immutable
     *
     * @return boolean
     */
    public boolean getImmutable() {
      return immutable;
    }

    /** True if it's an event property
     *
     * @return boolean
     */
    public boolean getEventProperty() {
      return components.eventProperty;
    }

    /** True if it's a todo property
     *
     * @return boolean
     */
    public boolean getTodoProperty() {
      return components.todoProperty;
    }

    /** True if it's a journal property
     *
     * @return boolean
     */
    public boolean getJournalProperty() {
      return components.journalProperty;
    }

    /** True if it's a freebusy property
     *
     * @return boolean
     */
    public boolean getFreeBusyProperty() {
      return components.freeBusyProperty;
    }

    /** True if it's a timezone property
     *
     * @return boolean
     */
    public boolean getTimezoneProperty() {
      return components.timezoneProperty;
    }

    /** True if it's an alarm property
     *
     * @return boolean
     */
    public boolean getAlarmProperty() {
      return components.alarmProperty;
    }

    /** True if it's a vavailability property
     *
     * @return boolean
     */
    public boolean getVavailabilityProperty() {
      return components.vavailabilityProperty;
    }

    /** True if it's an available property
     *
     * @return boolean
     */
    public boolean getAvailableProperty() {
      return components.availableProperty;
    }

    /** get the index given the property name
     *
     * @param val
     * @return PropertyInfoIndex
     */
    public static PropertyInfoIndex lookupPname(final String val) {
      return pnameLookup.get(val.toLowerCase());
    }

    /** get the index given the qname
     *
     * @param val
     * @return PropertyInfoIndex
     */
    public static PropertyInfoIndex lookupQname(final QName val) {
      return qnameLookup.get(val);
    }
  }
}
