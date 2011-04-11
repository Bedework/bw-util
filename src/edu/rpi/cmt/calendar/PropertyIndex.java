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
    UNKNOWN_PROPERTY(null, IS_SINGLE, noComponent),

    /** */
    CLASS("CLASS", IS_SINGLE, event_Todo_Journal),

    /** */
    CREATED("CREATED", DataType.DATE_TIME,
            IS_SINGLE, event_Todo_Journal_Freebusy),

    /** */
    DESCRIPTION("DESCRIPTION", IS_SINGLE, IS_MULTI, event_Todo_Journal_Alarm),

    /** */
    DTSTAMP("DTSTAMP", DataType.DATE_TIME,
            IS_SINGLE, event_Todo_Journal_Freebusy,
            NOT_PARAM, NOT_IMMUTABLE),

    /** */
    DTSTART("DTSTART", DataType.DATE_TIME,
            IS_SINGLE, notAlarm),

    /** */
    DURATION("DURATION", DataType.DURATION,
             IS_SINGLE, event_Todo_Freebusy),

    /** */
    GEO("GEO", IS_SINGLE, event_Todo),

    /** */
    LAST_MODIFIED("LAST-MODIFIED", DataType.DATE_TIME,
                  IS_SINGLE, event_Todo_Journal_Timezone,
                  NOT_PARAM, NOT_IMMUTABLE),

    /** */
    LOCATION("LOCATION", IS_SINGLE, event_Todo),

    /** */
    ORGANIZER("ORGANIZER", DataType.CUA,
              IS_SINGLE, event_Todo_Journal_Freebusy),

    /** */
    PRIORITY("PRIORITY", DataType.INTEGER,
             IS_SINGLE, event_Todo),

    /** */
    RECURRENCE_ID("RECURRENCE-ID", DataType.DATE_TIME,
                  IS_SINGLE, event_Todo_Journal_Freebusy),

    /** */
    SEQUENCE("SEQUENCE", DataType.INTEGER,
             IS_SINGLE, event_Todo_Journal,
             NOT_PARAM, NOT_IMMUTABLE),

    /** */
    STATUS("STATUS", IS_SINGLE, event_Todo_Journal),

    /** */
    SUMMARY("SUMMARY", IS_SINGLE, IS_MULTI, event_Todo_Journal_Alarm),

    /** */
    UID("UID", IS_SINGLE, event_Todo_Journal_Freebusy),

    /** */
    URL("URL", DataType.URI,
        IS_SINGLE, event_Todo_Journal_Freebusy),

    /* Event only */

    /** */
    DTEND("DTEND", DataType.DATE_TIME,
          IS_SINGLE, event_Freebusy),

    /** */
    TRANSP("TRANSP", IS_SINGLE, eventOnly),

    /* Todo only */

    /** */
    COMPLETED("COMPLETED", DataType.DATE_TIME,
              IS_SINGLE, todoOnly),

    /** */
    DUE("DUE", DataType.DATE_TIME,
        IS_SINGLE, todoOnly),

    /** */
    PERCENT_COMPLETE("PERCENT-COMPLETE", IS_SINGLE, todoOnly),

    /* ---------------------------- Multi valued --------------- */

    /* Event and Todo */

    /** */
    ATTACH("ATTACH", DataType.SPECIAL,
           IS_MULTI, event_Todo_Journal_Alarm),

    /** */
    ATTENDEE("ATTENDEE", DataType.CUA,
             IS_MULTI, notTimezone),

    /** */
    CATEGORIES("CATEGORIES", IS_MULTI, event_Todo_Journal_Alarm),

    /** */
    COMMENT("COMMENT", IS_MULTI, notAlarm),

    /** */
    CONTACT("CONTACT", IS_MULTI, event_Todo_Journal_Freebusy),

    /** */
    EXDATE("EXDATE", DataType.DATE_TIME,
           IS_MULTI, event_Todo_Journal_Timezone),

    /** */
    EXRULE("EXRULE", DataType.RECUR,
           IS_MULTI, event_Todo_Journal_Timezone),

    /** */
    REQUEST_STATUS("REQUEST-STATUS", IS_MULTI, event_Todo_Journal_Freebusy),

    /** */
    RELATED_TO("RELATED-TO", IS_MULTI, event_Todo_Journal),

    /** */
    RESOURCES("RESOURCES", IS_MULTI, event_Todo),

    /** */
    RDATE("RDATE", DataType.DATE_TIME,
          IS_MULTI, event_Todo_Journal_Timezone),

    /** */
    RRULE ("RRULE", DataType.RECUR,
           IS_MULTI, event_Todo_Journal_Timezone),

    /* -------------- Other non-event, non-todo ---------------- */

    /** */
    FREEBUSY("FREEBUSY", DataType.PERIOD,
             IS_SINGLE, freebusyOnly),

    /** */
    BUSYTYPE("BUSYTYPE", IS_SINGLE, vavailabilityOnly),

    /** */
    TZID("TZID", IS_SINGLE, timezoneOnly),

    /** */
    TZNAME("TZNAME", IS_SINGLE, timezoneOnly),

    /** */
    TZOFFSETFROM("TZOFFSETFROM", DataType.UTC_OFFSET,
                 IS_SINGLE, timezoneOnly),

    /** */
    TZOFFSETTO("TZOFFSETTO", DataType.UTC_OFFSET,
               IS_SINGLE, timezoneOnly),

    /** */
    TZURL("TZURL", DataType.URI,
          IS_SINGLE, timezoneOnly),

    /** */
    ACTION("ACTION", IS_SINGLE, alarmOnly),

    /** */
    REPEAT("REPEAT", DataType.INTEGER,
           IS_SINGLE, alarmOnly),

    /** */
    TRIGGER("TRIGGER", DataType.DURATION,
            IS_SINGLE, alarmOnly),

    /* -------------- Non-ical ---------------- */

    /** non ical */
    CREATOR("CREATOR", DataType.HREF, IS_SINGLE, event_Todo_Journal,
            NOT_PARAM, IS_IMMUTABLE),

    /** non ical */
    OWNER("OWNER", DataType.HREF, IS_SINGLE, event_Todo_Journal,
          NOT_PARAM, IS_IMMUTABLE),

    /** non ical */
    END_TYPE("END-TYPE", IS_SINGLE, event_Todo_Journal),

    /** non ical */
    COST("COST", IS_SINGLE, event_Todo),

    /** non ical */
    CTAG("CTAG", DataType.TEXT, IS_SINGLE, noComponent,
         NOT_PARAM, IS_IMMUTABLE),

    /** non ical */
    DELETED("DELETED", IS_SINGLE, event_Todo),

    /** non ical */
    ETAG("ETAG", DataType.TEXT, IS_SINGLE, noComponent,
         NOT_PARAM, IS_IMMUTABLE),

    /** non ical */
    COLLECTION("COLLECTION", IS_SINGLE, event_Todo_Journal),

    /** non ical */
    ENTITY_TYPE("ENTITY_TYPE", DataType.INTEGER,
                IS_SINGLE, event_Todo_Journal,
                NOT_PARAM, IS_IMMUTABLE),

    /** treat VALARM sub-component as a property */
    VALARM("VALARM", IS_MULTI, notAlarm),

    /** treat x-properties as a single multi-valued property */
    XPROP("XPROP", IS_MULTI, allComponents),

    /** ----------------------------- Following are parameters ----------- */

    /** */
    LANG("LANGUAGE", DataType.TEXT, IS_SINGLE, noComponent,
         IS_PARAM, NOT_IMMUTABLE),

    /** */
    TZIDPAR("TZID", DataType.TEXT, IS_SINGLE, noComponent,
            IS_PARAM, NOT_IMMUTABLE),
            ;

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

    static {
      for (PropertyInfoIndex pii: values()) {
        String pname = pii.getPname();

        if (pname != null) {
          pname = pname.toLowerCase();
        }
        pnameLookup.put(pname, pii);
      }
    }

    PropertyInfoIndex(final String pname, final boolean multiValued,
                      final ComponentFlags components) {
      this.pname = pname;
      this.components = components;
      this.multiValued = multiValued;
      dbMultiValued = multiValued;
    }

    PropertyInfoIndex(final String pname,
                      final DataType ptype, final boolean multiValued,
                      final ComponentFlags components) {
      this(pname, multiValued, components);
      this.ptype = ptype;
    }

    PropertyInfoIndex(final String pname, final boolean multiValued,
                      final boolean dbMultiValued,
                      final ComponentFlags components) {
      this(pname, DataType.TEXT, multiValued, components,
           NOT_PARAM, NOT_IMMUTABLE);
      this.dbMultiValued = dbMultiValued;
    }

    PropertyInfoIndex(final String pname,
                      final DataType ptype,
                      final boolean multiValued,
                      final ComponentFlags components,
                      final boolean param,
                      final boolean immutable) {
      this(pname, multiValued, components);
      this.ptype = ptype;
      this.param = param;
      this.immutable = immutable;
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
  }
}
