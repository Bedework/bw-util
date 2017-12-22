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

import org.bedework.util.xml.tagdefs.BedeworkServerTags;
import org.bedework.util.xml.tagdefs.WebdavTags;
import org.bedework.util.xml.tagdefs.XcalTags;

import ietf.params.xml.ns.icalendar_2.AcceptResponsePropType;
import ietf.params.xml.ns.icalendar_2.ActionPropType;
import ietf.params.xml.ns.icalendar_2.AttachPropType;
import ietf.params.xml.ns.icalendar_2.AttendeePropType;
import ietf.params.xml.ns.icalendar_2.BusytypePropType;
import ietf.params.xml.ns.icalendar_2.CalscalePropType;
import ietf.params.xml.ns.icalendar_2.CategoriesPropType;
import ietf.params.xml.ns.icalendar_2.ClassPropType;
import ietf.params.xml.ns.icalendar_2.CommentPropType;
import ietf.params.xml.ns.icalendar_2.CompletedPropType;
import ietf.params.xml.ns.icalendar_2.ContactPropType;
import ietf.params.xml.ns.icalendar_2.CreatedPropType;
import ietf.params.xml.ns.icalendar_2.DescriptionPropType;
import ietf.params.xml.ns.icalendar_2.DtendPropType;
import ietf.params.xml.ns.icalendar_2.DtstampPropType;
import ietf.params.xml.ns.icalendar_2.DtstartPropType;
import ietf.params.xml.ns.icalendar_2.DuePropType;
import ietf.params.xml.ns.icalendar_2.DurationPropType;
import ietf.params.xml.ns.icalendar_2.ExdatePropType;
import ietf.params.xml.ns.icalendar_2.ExrulePropType;
import ietf.params.xml.ns.icalendar_2.FreebusyPropType;
import ietf.params.xml.ns.icalendar_2.GeoPropType;
import ietf.params.xml.ns.icalendar_2.LanguageParamType;
import ietf.params.xml.ns.icalendar_2.LastModifiedPropType;
import ietf.params.xml.ns.icalendar_2.LocationPropType;
import ietf.params.xml.ns.icalendar_2.MethodPropType;
import ietf.params.xml.ns.icalendar_2.OrganizerPropType;
import ietf.params.xml.ns.icalendar_2.PercentCompletePropType;
import ietf.params.xml.ns.icalendar_2.PollItemIdPropType;
import ietf.params.xml.ns.icalendar_2.PollModePropType;
import ietf.params.xml.ns.icalendar_2.PollPropertiesPropType;
import ietf.params.xml.ns.icalendar_2.PriorityPropType;
import ietf.params.xml.ns.icalendar_2.ProdidPropType;
import ietf.params.xml.ns.icalendar_2.RdatePropType;
import ietf.params.xml.ns.icalendar_2.RecurrenceIdPropType;
import ietf.params.xml.ns.icalendar_2.RelatedToPropType;
import ietf.params.xml.ns.icalendar_2.RepeatPropType;
import ietf.params.xml.ns.icalendar_2.RequestStatusPropType;
import ietf.params.xml.ns.icalendar_2.ResourcesPropType;
import ietf.params.xml.ns.icalendar_2.RrulePropType;
import ietf.params.xml.ns.icalendar_2.SequencePropType;
import ietf.params.xml.ns.icalendar_2.StatusPropType;
import ietf.params.xml.ns.icalendar_2.SummaryPropType;
import ietf.params.xml.ns.icalendar_2.TranspPropType;
import ietf.params.xml.ns.icalendar_2.TriggerPropType;
import ietf.params.xml.ns.icalendar_2.TzidParamType;
import ietf.params.xml.ns.icalendar_2.TzidPropType;
import ietf.params.xml.ns.icalendar_2.TznamePropType;
import ietf.params.xml.ns.icalendar_2.TzoffsetfromPropType;
import ietf.params.xml.ns.icalendar_2.TzoffsettoPropType;
import ietf.params.xml.ns.icalendar_2.TzurlPropType;
import ietf.params.xml.ns.icalendar_2.UidPropType;
import ietf.params.xml.ns.icalendar_2.UrlPropType;
import ietf.params.xml.ns.icalendar_2.ValarmType;
import ietf.params.xml.ns.icalendar_2.VersionPropType;
import ietf.params.xml.ns.icalendar_2.VeventType;
import ietf.params.xml.ns.icalendar_2.VfreebusyType;
import ietf.params.xml.ns.icalendar_2.VjournalType;
import ietf.params.xml.ns.icalendar_2.VoterPropType;
import ietf.params.xml.ns.icalendar_2.VtimezoneType;
import ietf.params.xml.ns.icalendar_2.VtodoType;
import ietf.params.xml.ns.icalendar_2.XBedeworkCostPropType;
import ietf.params.xml.ns.icalendar_2.XBwCategoriesPropType;
import ietf.params.xml.ns.icalendar_2.XBwContactPropType;
import ietf.params.xml.ns.icalendar_2.XBwLocationPropType;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;

import javax.xml.namespace.QName;

/** Define an (arbitrary) index associated with calendar properties
 *
 * @author Mike Douglass   douglm  rpi.edu
 */
public class PropertyIndex implements Serializable {
  private PropertyIndex() {}

  static class ComponentFlags {
    private boolean vcalendarProperty;

    private boolean eventProperty;
    private boolean todoProperty;
    private boolean journalProperty;
    private boolean freeBusyProperty;
    private boolean timezoneProperty;
    private boolean alarmProperty;
    private boolean vavailabilityProperty;
    private boolean availableProperty;
    private boolean vpollProperty;

    ComponentFlags(final boolean eventProperty,
                   final boolean todoProperty,
                   final boolean journalProperty,
                   final boolean freeBusyProperty,
                   final boolean timezoneProperty,
                   final boolean alarmProperty,
                   final boolean vavailabilityProperty,
                   final boolean availableProperty,
                   final boolean vpollProperty) {
      this.eventProperty = eventProperty;
      this.todoProperty = todoProperty;
      this.journalProperty = journalProperty;
      this.freeBusyProperty = freeBusyProperty;
      this.timezoneProperty = timezoneProperty;
      this.alarmProperty = alarmProperty;
      this.vavailabilityProperty = vavailabilityProperty;
      this.availableProperty = availableProperty;
      this.vpollProperty = vpollProperty;
    }

    ComponentFlags(final boolean vcalendarProperty) {
      this.vcalendarProperty = vcalendarProperty;
    }
  }

  static final ComponentFlags noComponent =
     new ComponentFlags(false, false, false, false, false, false, false, false, false);

  static final ComponentFlags eventOnly =
     new ComponentFlags(true, false, false, false, false, false, false, false, false);

  static final ComponentFlags todoOnly =
     new ComponentFlags(false, true, false, false, false, false, false, false, false);

  static final ComponentFlags freebusyOnly =
     new ComponentFlags(false, false, false, true, false, false, false, false, false);

  static final ComponentFlags timezoneOnly =
     new ComponentFlags(false, false, false, false, true, false, false, false, false);

  static final ComponentFlags alarmOnly =
     new ComponentFlags(false, false, false, false, false, true, false, false, false);

  static final ComponentFlags vavailabilityOnly =
     new ComponentFlags(false, false, false, false, false, false, true, false, false);

  static final ComponentFlags availableOnly =
    new ComponentFlags(false, false, false, false, false, false, false, true, false);

  static final ComponentFlags vpollOnly =
    new ComponentFlags(false, false, false, false, false, false, false, false, true);

  static final ComponentFlags event_Todo =
     new ComponentFlags(true, true, false, false, false, false, false, false, false);

  static final ComponentFlags event_Todo_Journal =
     new ComponentFlags(true, true, true, false, false, false, false, false, false);

  static final ComponentFlags event_Todo_Freebusy_Alarm =
     new ComponentFlags(true, true, false, true, false, true, false, false, false);

  static final ComponentFlags event_Todo_Freebusy =
     new ComponentFlags(true, true, false, true, false, false, false, false, false);

  static final ComponentFlags event_Freebusy =
     new ComponentFlags(true, false, false, true, false, false, false, false, false);

  static final ComponentFlags event_Todo_Journal_Freebusy =
     new ComponentFlags(true, true, true, true, false, false, false, false, false);

  static final ComponentFlags event_Todo_Journal_Timezone =
     new ComponentFlags(true, true, true, false, true, false, false, false, false);

  static final ComponentFlags event_Todo_Journal_Alarm =
     new ComponentFlags(true, true, true, false, false, true, false, false, false);

  static final ComponentFlags notTimezone =
     new ComponentFlags(true, true, true, true, false, true, false, false, false);

  static final ComponentFlags notAlarm =
     new ComponentFlags(true, true, true, true, true, false, false, false, true);

  static final ComponentFlags allComponents =
     new ComponentFlags(true, true, true, true, true, true, false, false, true);

  static final ComponentFlags vcalendarOnly =
          new ComponentFlags(true);

  private static final boolean IS_MULTI = true;

  private static final boolean IS_SINGLE = false;

  private static final boolean IS_PARAM = true;

  private static final boolean NOT_PARAM = false;

  private static final boolean IS_IMMUTABLE = true;

  private static final boolean NOT_IMMUTABLE = false;

  /** */
  public static enum ComponentInfoIndex {
    /** */
    UNKNOWN_COMPONENT(null, null, null),

    /** */
    VALARM(XcalTags.valarm, "VALARM", ValarmType.class),

    /** */
    VEVENT(XcalTags.vevent, "VEVENT", VeventType.class),

    /** */
    VFREEBUSY(XcalTags.vfreebusy, "VFREEBUSY", VfreebusyType.class),

    /** */
    VJOURNAL(XcalTags.vjournal, "VJOURNAL", VjournalType.class),

    /** */
    VTIMEZONE(XcalTags.vtimezone, "VTIMEZONE", VtimezoneType.class),

    /** */
    VTODO(XcalTags.vtodo, "VTODO", VtodoType.class),
    ;

    private final QName qname;

    private final String pname;

    private String pnameLC;

    private String jname;

    private final Class xmlClass;

    private final static Map<String, ComponentInfoIndex> pnameLookup =
            new HashMap<>();

    private final static Map<QName, ComponentInfoIndex> qnameLookup =
            new HashMap<>();

    private final static Map<Class, ComponentInfoIndex> xmlClassLookup =
            new HashMap<>();

    static {
      for (final ComponentInfoIndex cii: values()) {
        final String pname = cii.getPnameLC();

        pnameLookup.put(pname, cii);

        qnameLookup.put(cii.getQname(), cii);

        xmlClassLookup.put(cii.xmlClass, cii);
      }
    }

    ComponentInfoIndex(final QName qname,
                       final String pname,
                       final Class xmlClass) {
      this.qname = qname;
      this.pname = pname;
      this.xmlClass = xmlClass;

      if (pname != null) {
        pnameLC = pname.toLowerCase();
      }

      if (jname == null) {
        this.jname = pnameLC;
      }
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

    /** get the java style name
     *
     * @return parameter name
     */
    public String getJname() {
      return jname;
    }

    /** get the property name lower cased
     *
     * @return property name
     */
    public String getPnameLC() {
      return pnameLC;
    }

    /** get the XML class
     *
     * @return class
     */
    public Class getXmlClass() {
      return xmlClass;
    }

    /** get the index given the XML class
     * @param cl the class
     * @return ComponentInfoIndex
     */
    public static ComponentInfoIndex fromXmlClass(final Class cl) {
      return xmlClassLookup.get(cl);
    }

    /** get the index given the property name
     *
     * @param val the name
     * @return ComponentInfoIndex
     */
    public static ComponentInfoIndex lookupPname(final String val) {
      return pnameLookup.get(val.toLowerCase());
    }

    /** get the index given the qname
     *
     * @param val the qname
     * @return ComponentInfoIndex
     */
    public static ComponentInfoIndex lookupQname(final QName val) {
      return qnameLookup.get(val);
    }
  }

  /** */
  public static enum DataType {
    /** */
    BINARY(XcalTags.binaryVal, "binary"),

    /** */
    BOOLEAN(XcalTags.booleanVal, "boolean"),

    /** */
    CUA(XcalTags.calAddressVal, "cal-address"),

    /** */
    DATE(XcalTags.dateVal, "date"),

    /** */
    DATE_TIME(XcalTags.dateTimeVal, "date-time"),

    /** */
    DURATION(XcalTags.duration, "duration"),

    /** */
    FLOAT(XcalTags.floatVal, "float"),

    /** */
    INTEGER(XcalTags.integerVal, "integer"),

    /** */
    PERIOD(XcalTags.periodVal, "period"),

    /** */
    RECUR(XcalTags.recurVal, "recur"),

    /** */
    TEXT(XcalTags.textVal, "text"),

    /** */
    TIME(XcalTags.timeVal, "time"),

    /** */
    URI(XcalTags.uriVal, "uri"),

    /** */
    UTC_OFFSET(XcalTags.utcOffsetVal, "utc-offset"),

    /** More work */
    SPECIAL(null, null),

    /** Non-ical */
    HREF(null, null);

    private final QName xcalType;

    private final String jsonType;

    DataType(final QName xcalType, final String jsonType) {
      this.xcalType = xcalType;
      this.jsonType = jsonType;
    }

    /**
     * @return type or null
     */
    public QName getXcalType() {
      return xcalType;
    }

    /**
     * @return type or null
     */
    public String getJsonType() {
      return jsonType;
    }
  }

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
    DELEGATED_FROM("DELEGATED-FROM", "delegatedFrom"),

    /**
     * Delegatee.
     */
    DELEGATED_TO("DELEGATED-TO", "delegatedTo"),

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
    SCHEDULE_AGENT("SCHEDULE-AGENT", "scheduleAgent"),

    /**
     * Schedule status.
     */
    SCHEDULE_STATUS("SCHEDULE-STATUS", "scheduleStatus"),

    /**
     * Sent by.
     */
    SENT_BY("SENT-BY", "sentBy"),

    /**
     * Type.
     */
    STAY_INFORMED("STAY-INFORMED", "stayInformed"),

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
    VALUE("VALUE"),

    /**
     * Bedework only.
     */
    UID("UID");

    private final String pname;

    private String pnameLC;

    private String jname;

    private final DataType ptype;

    private final static HashMap<String, ParameterInfoIndex> pnameLookup =
            new HashMap<>();

    static {
      for (final ParameterInfoIndex pii: values()) {
        final String pname = pii.getPnameLC();
        pnameLookup.put(pname, pii);
      }
    }

    ParameterInfoIndex(final String pname) {
      this(pname, null, DataType.TEXT);
    }

    ParameterInfoIndex(final String pname,
                       final String jname) {
      this(pname, jname, DataType.TEXT);
    }

    ParameterInfoIndex(final String pname,
                       final String jname,
                       final DataType ptype) {
      this.pname = pname;
      this.jname = jname;
      this.ptype = ptype;

      if (pname != null) {
        pnameLC = pname.toLowerCase();
      }

      if (jname == null) {
        this.jname = pnameLC;
      }
    }

    /** get the parameter name
     *
     * @return parameter name
     */
    public String getPname() {
      return pname;
    }

    /** get the java style name
     *
     * @return parameter name
     */
    public String getJname() {
      return jname;
    }

    /** get the property name lower cased
     *
     * @return property name
     */
    public String getPnameLC() {
      return pnameLC;
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
     * @param val name
     * @return ParameterInfoIndex
     */
    public static ParameterInfoIndex lookupPname(final String val) {
      return pnameLookup.get(val.toLowerCase());
    }
  }

  /** */
  public static enum PropertyInfoIndex {
    /** */
    UNKNOWN_PROPERTY(null, null,
                     IS_SINGLE, noComponent),

    /** Alarm only: action */
    ACTION(XcalTags.action,
           ActionPropType.class,
           IS_SINGLE, alarmOnly),

    /** Multi-valued attachment */
    ATTACH(XcalTags.attach,
           AttachPropType.class,
           DataType.SPECIAL,
           IS_MULTI, event_Todo_Journal_Alarm),

    /** attendee */
    ATTENDEE(XcalTags.attendee,
             AttendeePropType.class,
             DataType.CUA,
             IS_MULTI, notTimezone),

    /** */
    BUSYTYPE(XcalTags.busytype,
             BusytypePropType.class,
             IS_SINGLE, vavailabilityOnly),

    /** String names */
    CATEGORIES(XcalTags.categories,
              CategoriesPropType.class,
               IS_MULTI, event_Todo_Journal_Alarm),

    X_BEDEWORK_CATEGORIES(XcalTags.xBedeworkCategories,
                          XBwCategoriesPropType.class,
                          IS_MULTI, event_Todo_Journal_Alarm),

    /** classification */
    CLASS(XcalTags._class,
          ClassPropType.class, null,
          IS_SINGLE, event_Todo_Journal),

    /** String comment */
    COMMENT(XcalTags.comment,
            CommentPropType.class,
            IS_MULTI, notAlarm),

    /** date/date-time completed */
    COMPLETED(XcalTags.completed,
              CompletedPropType.class,
              DataType.DATE_TIME,
              IS_SINGLE, todoOnly),

    /** String contact */
    CONTACT(XcalTags.contact,
            ContactPropType.class,
            IS_MULTI, event_Todo_Journal_Freebusy),

    /** Moved String contact */
    X_BEDEWORK_CONTACT(XcalTags.xBedeworkContact,
                       XBwContactPropType.class,
                       IS_MULTI, event_Todo_Journal_Freebusy),

    /** UTC datetime */
    CREATED(XcalTags.created,
            CreatedPropType.class,
            DataType.DATE_TIME,
            IS_SINGLE, event_Todo_Journal_Freebusy),

    /** long description */
    DESCRIPTION(XcalTags.description,
                DescriptionPropType.class,
                IS_SINGLE, IS_MULTI, event_Todo_Journal_Alarm),

    /** Event only: end date */
    DTEND(XcalTags.dtend,
          DtendPropType.class,
          DataType.DATE_TIME,
          IS_SINGLE, event_Freebusy),

    /** date stamp */
    DTSTAMP(XcalTags.dtstamp,
            DtstampPropType.class,
            DataType.DATE_TIME,
            IS_SINGLE, event_Todo_Journal_Freebusy,
            NOT_PARAM, NOT_IMMUTABLE),

    /** start date/time */
    DTSTART(XcalTags.dtstart,
            DtstartPropType.class,
            DataType.DATE_TIME,
            IS_SINGLE, notAlarm),

    /** tod-: due time */
    DUE(XcalTags.due,
        DuePropType.class,
        DataType.DATE_TIME,
        IS_SINGLE, todoOnly),

    /** Duration of event/task etc */
    DURATION(XcalTags.duration,
             DurationPropType.class,
             DataType.DURATION,
             IS_SINGLE, event_Todo_Freebusy_Alarm),

    /** Exception date */
    EXDATE(XcalTags.exdate,
           ExdatePropType.class,
           DataType.DATE_TIME,
           IS_MULTI, event_Todo_Journal_Timezone),

    /** Exception rule */
    EXRULE(XcalTags.exrule,
           ExrulePropType.class,
           DataType.RECUR,
           IS_MULTI, event_Todo_Journal_Timezone),

    /** */
    FREEBUSY(XcalTags.freebusy,
             FreebusyPropType.class,
             DataType.PERIOD,
             IS_SINGLE, freebusyOnly),

    /** Geographic location */
    GEO(XcalTags.geo,
        GeoPropType.class,
        IS_SINGLE, event_Todo),

    /** UTC */
    LAST_MODIFIED(XcalTags.lastModified,
                  LastModifiedPropType.class,
                  DataType.DATE_TIME,
                  IS_SINGLE, event_Todo_Journal_Timezone,
                  NOT_PARAM, NOT_IMMUTABLE),

    /** simple location value */
    LOCATION(XcalTags.location,
             LocationPropType.class,
             IS_SINGLE, event_Todo),

    /** moved simple location value */
    X_BEDEWORK_LOCATION(XcalTags.xBedeworkLocation,
                        XBwLocationPropType.class,
                        IS_SINGLE, event_Todo),

    /** meeting organizer */
    ORGANIZER(XcalTags.organizer,
              OrganizerPropType.class,
              DataType.CUA,
              IS_SINGLE, event_Todo_Journal_Freebusy),

    /** % complete */
    PERCENT_COMPLETE(XcalTags.percentComplete,
                     PercentCompletePropType.class,
                     IS_SINGLE, todoOnly),

    /** Priority */
    PRIORITY(XcalTags.priority,
             PriorityPropType.class,
             DataType.INTEGER,
             IS_SINGLE, event_Todo),

    /** A (shorter?) url used to reference the entity */
    PUBLISH_URL(XcalTags.url,
        UrlPropType.class,
        DataType.URI,
        IS_SINGLE, event_Todo_Journal_Freebusy),

    /** recurrence date/time */
    RDATE(XcalTags.rdate,
          RdatePropType.class,
          DataType.DATE_TIME,
          IS_MULTI, event_Todo_Journal_Timezone),

    /** recurrenceId */
    RECURRENCE_ID(XcalTags.recurrenceId,
                  RecurrenceIdPropType.class,
                  DataType.DATE_TIME,
                  IS_SINGLE, event_Todo_Journal_Freebusy),

    /** Establish relationship */
    RELATED_TO(XcalTags.relatedTo,
               RelatedToPropType.class,
               IS_MULTI, event_Todo_Journal),

    /** Alarm: repeat time */
    REPEAT(XcalTags.repeat,
           RepeatPropType.class,
           DataType.INTEGER,
           IS_SINGLE, alarmOnly),

    /** Itip */
    REQUEST_STATUS(XcalTags.requestStatus,
                   RequestStatusPropType.class,
                   IS_MULTI, event_Todo_Journal_Freebusy),

    /** names of resources */
    RESOURCES(XcalTags.resources,
              ResourcesPropType.class,
              IS_MULTI, event_Todo),

    /** recurrence rule */
    RRULE (XcalTags.rrule,
           RrulePropType.class,
           DataType.RECUR,
           IS_MULTI, event_Todo_Journal_Timezone),

    /** itip sequence # */
    SEQUENCE(XcalTags.sequence,
             SequencePropType.class,
             DataType.INTEGER,
             IS_SINGLE, event_Todo_Journal,
             NOT_PARAM, NOT_IMMUTABLE),

    /** Event/task status */
    STATUS(XcalTags.status,
           StatusPropType.class,
           IS_SINGLE, event_Todo_Journal),

    /** short summary */
    SUMMARY(XcalTags.summary,
            SummaryPropType.class,
            IS_SINGLE, IS_MULTI, event_Todo_Journal_Alarm),

    /** Alarm trigger */
    TRIGGER(XcalTags.trigger,
            TriggerPropType.class,
            DataType.DURATION,
            IS_SINGLE, alarmOnly),

    /** Transparency */
    TRANSP(XcalTags.transp,
           TranspPropType.class,
           IS_SINGLE, eventOnly),

    /** */
    TZID(XcalTags.tzid,
         TzidPropType.class,
         IS_SINGLE, timezoneOnly),

    /** */
    TZNAME(XcalTags.tzname,
           TznamePropType.class,
           IS_SINGLE, timezoneOnly),

    /** */
    TZOFFSETFROM(XcalTags.tzoffsetfrom,
                 TzoffsetfromPropType.class,
                 DataType.UTC_OFFSET,
                 IS_SINGLE, timezoneOnly),

    /** */
    TZOFFSETTO(XcalTags.tzoffsetto,
               TzoffsettoPropType.class,
               DataType.UTC_OFFSET,
               IS_SINGLE, timezoneOnly),

    /** */
    TZURL(XcalTags.tzurl,
          TzurlPropType.class,
          DataType.URI,
          IS_SINGLE, timezoneOnly),

    /** Unique id */
    UID(XcalTags.uid,
        UidPropType.class,
        IS_SINGLE, event_Todo_Journal_Freebusy),

    /** link to some related resource */
    URL(XcalTags.url,
        UrlPropType.class,
        DataType.URI,
        IS_SINGLE, event_Todo_Journal_Freebusy),

    /** treat x-properties as a single multi-valued property */
    XPROP(BedeworkServerTags.xprop,
          null,
          IS_MULTI, allComponents),

    /** accept-response */
    ACCEPT_RESPONSE(XcalTags.acceptResponse,
                    AcceptResponsePropType.class,
                    IS_SINGLE, vpollOnly),

    /** Poll-winner */
    POLL_WINNER(BedeworkServerTags.xprop,
                 null,
                 DataType.INTEGER,
                 IS_SINGLE, vpollOnly),

    /** Poll-item-id */
    POLL_ITEM_ID(XcalTags.pollItemId,
                 PollItemIdPropType.class,
                 DataType.INTEGER,
        IS_SINGLE, event_Todo_Journal_Freebusy),

    /** Poll-item */
    POLL_ITEM(BedeworkServerTags.xprop,
              null,
              IS_MULTI, vpollOnly),

    /** vvoter component */
    VVOTER(BedeworkServerTags.xprop,
           null,
           IS_MULTI, vpollOnly),

    /** vote component */
    VOTE(BedeworkServerTags.xprop,
           null,
           IS_MULTI, vpollOnly),

    /** Poll-mode */
    POLL_MODE(XcalTags.pollMode,
              PollModePropType.class,
        IS_SINGLE, vpollOnly),

    /** Poll-properties */
    POLL_PROPERTIES(XcalTags.pollProperties,
                    PollPropertiesPropType.class,
                    IS_MULTI, vpollOnly),

    /** attendee */
    VOTER(XcalTags.voter,
          VoterPropType.class,
          DataType.CUA,
          IS_MULTI, notTimezone),

    /* -------------- Non-ical ---------------- */

    /** non ical */
    COLLECTION(BedeworkServerTags.collection,
               null,
               IS_SINGLE, event_Todo_Journal),

    /** non ical */
    COST(BedeworkServerTags.cost,
         null,
         IS_SINGLE, event_Todo),

    /** non ical */
    CREATOR(BedeworkServerTags.creator,
            null,
            DataType.HREF,
            IS_SINGLE, event_Todo_Journal,
            NOT_PARAM, IS_IMMUTABLE),

    /** non ical */
    DELETED(BedeworkServerTags.deleted,
            null,
            IS_SINGLE, event_Todo),

    /** non ical */
    END_TYPE(BedeworkServerTags.endType,
             null,
             IS_SINGLE, event_Todo_Journal),

    /** non ical */
    ETAG(BedeworkServerTags.etag,
         null,
         DataType.TEXT,
         IS_SINGLE, noComponent,
         NOT_PARAM, IS_IMMUTABLE),

    /** non ical */
    ENTITY_TYPE(BedeworkServerTags.entityType,
                null,
                DataType.INTEGER,
                IS_SINGLE, event_Todo_Journal,
                NOT_PARAM, IS_IMMUTABLE),

    /** non ical */
    HREF(WebdavTags.href,
         null,
         DataType.HREF,
         IS_SINGLE, allComponents,
         NOT_PARAM, IS_IMMUTABLE),

    /** non ical */
    OWNER(BedeworkServerTags.owner,
          null,
          DataType.HREF,
          IS_SINGLE, event_Todo_Journal,
          NOT_PARAM, IS_IMMUTABLE),

    /** treat VALARM sub-component as a property */
    VALARM(XcalTags.valarm,
           ValarmType.class,
           IS_MULTI, notAlarm),

    /** ----------------------------- Following are parameters ----------- */

    /** */
    LANG(BedeworkServerTags.language,
         LanguageParamType.class,
         DataType.TEXT,
         IS_SINGLE, noComponent,
         IS_PARAM, NOT_IMMUTABLE),

    /** */
    RANGE(XcalTags.range,
         null,
         DataType.DURATION,
         IS_SINGLE, noComponent,
         IS_PARAM, NOT_IMMUTABLE),

    /** */
    TZIDPAR(XcalTags.tzid,
            TzidParamType.class,
            DataType.TEXT, IS_SINGLE, noComponent,
            IS_PARAM, NOT_IMMUTABLE),

    /** ----------------------------- X-properties in schema ----------- */

    /** Cost */
    XBEDEWORK_COST(XcalTags.xBedeworkCost,
                   XBedeworkCostPropType.class,
                   IS_SINGLE, event_Todo),

    /** ----------------------------- Vcalendar properties ----------- */

    /** Transparency */
    CALSCALE(XcalTags.calscale,
             CalscalePropType.class,
             IS_SINGLE, vcalendarOnly),

    /** Transparency */
    METHOD(XcalTags.method,
           MethodPropType.class,
           IS_SINGLE, vcalendarOnly),

    /** Transparency */
    PRODID(XcalTags.prodid,
           ProdidPropType.class,
           IS_SINGLE, vcalendarOnly),

    /** Transparency */
    VERSION(XcalTags.version,
            VersionPropType.class,
            IS_SINGLE, vcalendarOnly),

    /** ------------------------ Bedework only properties ----------- */

    /** ACL */
    ACL(BedeworkServerTags.xprop,
        null,
        IS_MULTI, allComponents),

    // Boolean flag
    AFFECTS_FREE_BUSY(BedeworkServerTags.xprop,
                      null,
                      IS_SINGLE, allComponents),

    // URI this is aliased to
    ALIAS_URI(BedeworkServerTags.xprop,
              null,
              IS_SINGLE, allComponents),

    ATTENDEE_SCHEDULING_OBJECT(BedeworkServerTags.xprop,
                               null,
                               IS_SINGLE, allComponents),

    // string - name of calsuite
    CALSUITE(BedeworkServerTags.xprop,
              null,
              IS_SINGLE, allComponents),

    CALTYPE(BedeworkServerTags.xprop,
            null,
            IS_SINGLE, allComponents),

    // Collection properties 
    COL_PROPERTIES(BedeworkServerTags.xprop,
                   null,
                   IS_SINGLE, allComponents),

    /** path to containing collection */
    COLPATH(BedeworkServerTags.xprop,
            null,
            IS_MULTI, allComponents),

    /* * UID for category * /
    CATUID(XcalTags.categories,
           "CATUID", "categoryUid",
           CategoriesPropType.class,
           IS_MULTI, allComponents),

    /* * Href for category * /
    CATEGORY_PATH(XcalTags.categories,
                  "CATEGORY_PATH", "categoryPath",
                  CategoriesPropType.class,
                  IS_MULTI, allComponents),
                  */

    /** non ical */
    CTAG(BedeworkServerTags.ctag,
         null,
         DataType.TEXT,
         IS_SINGLE, noComponent,
         NOT_PARAM, IS_IMMUTABLE),

    /** non ical */
    CTOKEN(BedeworkServerTags.xprop,
           null,
           DataType.TEXT,
           IS_SINGLE, noComponent,
           NOT_PARAM, IS_IMMUTABLE),

    DBID(BedeworkServerTags.xprop,
            null,
            IS_SINGLE, allComponents),

    // Boolean display flag
    DISPLAY(BedeworkServerTags.xprop,
            null,
            IS_SINGLE, allComponents),

    DOCTYPE(BedeworkServerTags.xprop,
            null,
            IS_SINGLE, allComponents),

    EVENTREG_END(BedeworkServerTags.xprop,
                 null,
                 IS_SINGLE, allComponents),

    EVENTREG_MAX_TICKETS(BedeworkServerTags.xprop,
                         null,
                         IS_SINGLE, allComponents),

    EVENTREG_MAX_TICKETS_PER_USER(BedeworkServerTags.xprop,
                                  null,
                                  IS_SINGLE, allComponents),

    EVENTREG_START(BedeworkServerTags.xprop,
                   null,
                   IS_SINGLE, allComponents),

    EVENTREG_WAIT_LIST_LIMIT(BedeworkServerTags.xprop,
                             null,
                             IS_SINGLE, allComponents),

    FILTER_EXPR(BedeworkServerTags.xprop,
                null,
                IS_SINGLE, allComponents),

    /** date/time - local */
    LOCAL(XcalTags.dtstart,
          null,
          DataType.DATE_TIME,
          IS_SINGLE, notAlarm),

    /** date/time - floating true/false */
    FLOATING(XcalTags.dtstart,
             null,
             DataType.DATE_TIME,
             IS_SINGLE, notAlarm),

    // Boolean flag
    IGNORE_TRANSP(BedeworkServerTags.xprop,
                  null,
                  IS_SINGLE, allComponents),

    IMAGE(BedeworkServerTags.xprop,
          null,
          IS_SINGLE, allComponents),

    /**  date/time utc value */
    INDEX_END(XcalTags.dtstart,
              null,
              DataType.DATE_TIME,
              IS_SINGLE, allComponents),

    /**  date/time utc value */
    INDEX_START(XcalTags.dtstart,
                null,
                DataType.DATE_TIME,
                IS_SINGLE, allComponents),

    /* For bedework annotations/overrides */
    INSTANCE(BedeworkServerTags.xprop,
             null,
             IS_SINGLE, allComponents),

    // string
    LAST_ETAG(BedeworkServerTags.xprop,
              null,
              IS_SINGLE, allComponents),

    // timestamp
    LAST_REFRESH(BedeworkServerTags.xprop,
                 null,
                 IS_SINGLE, allComponents),

    // string
    LAST_REFRESH_STATUS(BedeworkServerTags.xprop,
                        null,
                        IS_SINGLE, allComponents),

    /** location uid - saved in the index */
    LOCATION_UID(BedeworkServerTags.xprop,
                 null,
                 IS_SINGLE, event_Todo),

    /** location string value for the indexer */
    LOCATION_STR(BedeworkServerTags.xprop,
                 null,
                 IS_SINGLE, event_Todo),

    /* For bedework annotations/overrides */
    MASTER(BedeworkServerTags.xprop,
           null,
           IS_SINGLE, allComponents),

    /** name of entity */
    NAME(BedeworkServerTags.xprop,
         null,
         IS_SINGLE, allComponents),

    ORGANIZER_SCHEDULING_OBJECT(BedeworkServerTags.xprop,
                                null,
                                IS_SINGLE, allComponents),

    ORIGINATOR(BedeworkServerTags.xprop,
               null,
               IS_SINGLE, allComponents),

    /* For bedework annotations/overrides */
    OVERRIDE(BedeworkServerTags.xprop,
             null,
           IS_SINGLE, allComponents),

    PUBLIC(BedeworkServerTags.xprop,
           null,
               IS_SINGLE, allComponents),

    RECIPIENT(BedeworkServerTags.xprop,
              null,
              IS_SINGLE, allComponents),

    RECURRING(BedeworkServerTags.xprop,
              null,
              IS_SINGLE, allComponents),

    // int
    REFRESH_RATE(BedeworkServerTags.xprop,
                 null,
                 IS_SINGLE, allComponents),

    // string
    REMOTE_ID(BedeworkServerTags.xprop,
              null,
              IS_SINGLE, allComponents),

    // string
    REMOTE_PW(BedeworkServerTags.xprop,
              null,
              IS_SINGLE, allComponents),

    /** schedule method */
    SCHEDULE_METHOD(BedeworkServerTags.xprop,
                    null,
                    IS_SINGLE, allComponents),

    SCHEDULE_STATE(BedeworkServerTags.xprop,
                   null,
                   IS_SINGLE, allComponents),

    /** schedule tag */
    SCHEDULE_TAG(BedeworkServerTags.xprop,
                 null,
                 IS_SINGLE, allComponents),

    SUGGESTED_TO(BedeworkServerTags.xprop,
                 null,
                 IS_MULTI, allComponents),

    /* For bedework annotations/overrides */
    TARGET(BedeworkServerTags.xprop,
           null,
           IS_SINGLE, allComponents),

    /** Temp - we should do this as a type of image */
    THUMBIMAGE(BedeworkServerTags.xprop, null,
          IS_SINGLE, allComponents),

    TOPICAL_AREA(BedeworkServerTags.xprop,
                 null,
                 IS_SINGLE, allComponents),

    NEXT_TRIGGER_DATE_TIME(BedeworkServerTags.xprop,
                           null,
                           IS_SINGLE, allComponents),

    TRIGGER_DATE_TIME(BedeworkServerTags.xprop,
                      null,
                      IS_SINGLE, allComponents),

    // Boolean flag
    UNREMOVEABLE(BedeworkServerTags.xprop,
                 null,
                 IS_SINGLE, allComponents),

    /**  date/time utc value */
    UTC(XcalTags.dtstart,
        null,
        DataType.DATE_TIME,
        IS_SINGLE, notAlarm),

    /** Virtual path - only appears in unparsed/unresolved fexpr */
    VPATH(BedeworkServerTags.xprop,
          null,
          IS_SINGLE, allComponents),

    /** View - only appears in unparsed/unresolved fexpr */
    VIEW(BedeworkServerTags.xprop,
         null,
         IS_SINGLE, allComponents),

    PARAMETERS(BedeworkServerTags.xprop,
               null,
               IS_SINGLE, allComponents),

    /** Is start present? */
    NO_START(BedeworkServerTags.xprop,
             null,
             IS_SINGLE, allComponents),

    /** Special term for sorts */
    RELEVANCE(BedeworkServerTags.xprop,
              null,
              IS_SINGLE, allComponents),

    /** link to some related resource */
    URI(BedeworkServerTags.xprop,
        null,
        DataType.URI,
        IS_SINGLE, allComponents),

    VALUE(BedeworkServerTags.xprop,
          null,
          IS_SINGLE, allComponents),

    /** ------------------------ contacts ----------- */

    CN(BedeworkServerTags.xprop,
       null,
       IS_SINGLE, allComponents),

    EMAIL(BedeworkServerTags.xprop,
          null,
          IS_SINGLE, allComponents),

    PHONE(BedeworkServerTags.xprop,
          null,
          IS_SINGLE, allComponents),

    /** ------------------------ locations ----------- */

    ADDRESS(BedeworkServerTags.xprop,
          null,
          IS_SINGLE, allComponents),

    SUBADDRESS(BedeworkServerTags.xprop,
          null,
          IS_SINGLE, allComponents),

    ADDRESS_FLD(BedeworkServerTags.xprop,
                null,
                IS_SINGLE, allComponents),

    ROOM_FLD(BedeworkServerTags.xprop,
                null,
                IS_SINGLE, allComponents),

    SUB1_FLD(BedeworkServerTags.xprop,
                null,
                IS_SINGLE, allComponents),

    SUB2_FLD(BedeworkServerTags.xprop,
                null,
                IS_SINGLE, allComponents),

    ACCESSIBLE_FLD(BedeworkServerTags.xprop,
                null,
                IS_SINGLE, allComponents),

    GEOURI_FLD(BedeworkServerTags.xprop,
                null,
                IS_SINGLE, allComponents),

    STREET_FLD(BedeworkServerTags.xprop,
                null,
                IS_SINGLE, allComponents),

    CITY_FLD(BedeworkServerTags.xprop,
                null,
                IS_SINGLE, allComponents),

    STATE_FLD(BedeworkServerTags.xprop,
                null,
                IS_SINGLE, allComponents),

    ZIP_FLD(BedeworkServerTags.xprop,
                null,
                IS_SINGLE, allComponents),

    ALTADDRESS_FLD(BedeworkServerTags.xprop,
                null,
                IS_SINGLE, allComponents),

    CODEIDX_FLD(BedeworkServerTags.xprop,
                null,
                IS_SINGLE, allComponents),

    LOC_KEYS_FLD(BedeworkServerTags.xprop,
                 null,
                 IS_SINGLE, allComponents),
    ;

    private final QName qname;

    private final Class xmlClass;

    private DataType ptype;

    /* true if the standard says it's multi */
    private final boolean multiValued;

    /* true if we store multi - e.g. multi-language */
    private boolean dbMultiValued;

    private boolean param; /* It's a parameter   */

    private boolean immutable;

    private final ComponentFlags components;

    private final static Map<QName, PropertyInfoIndex> qnameLookup =
            new HashMap<>();

    private final static Map<Class, PropertyInfoIndex> xmlClassLookup =
            new HashMap<>();

    static {
      for (final PropertyInfoIndex pii: values()) {
        qnameLookup.put(pii.getQname(), pii);

        xmlClassLookup.put(pii.xmlClass, pii);
      }
    }

    PropertyInfoIndex(final QName qname,
                      final Class xmlClass,
                      final boolean multiValued,
                      final ComponentFlags components) {
      this.qname = qname;
      this.xmlClass = xmlClass;
      this.components = components;
      this.multiValued = multiValued;
      dbMultiValued = multiValued;
    }

    PropertyInfoIndex(final QName qname,
                      final Class xmlClass,
                      final DataType ptype,
                      final boolean multiValued,
                      final ComponentFlags components) {
      this(qname, xmlClass, multiValued, components);
      this.ptype = ptype;
    }

    PropertyInfoIndex(final QName qname,
                      final Class xmlClass,
                      final boolean multiValued,
                      final boolean dbMultiValued,
                      final ComponentFlags components) {
      this(qname, xmlClass, DataType.TEXT,
           multiValued, components,
           NOT_PARAM, NOT_IMMUTABLE);
      this.dbMultiValued = dbMultiValued;
    }

    PropertyInfoIndex(final QName qname,
                      final Class xmlClass,
                      final DataType ptype,
                      final boolean multiValued,
                      final ComponentFlags components,
                      final boolean param,
                      final boolean immutable) {
      this(qname, xmlClass, multiValued, components);
      this.ptype = ptype;
      this.param = param;
      this.immutable = immutable;
    }

    /** Property names can have "-" in them. This method takes the
     * name, replaces any "-" with underscore and then tries valueOf.
     *
     * @param pname - any case
     * @return index or null if not found
     */
    public static PropertyInfoIndex fromName(final String pname) {
      final String name;

      if (!pname.contains("-")) {
        name = pname.toUpperCase();
      } else {
        name = pname.replace("-", "_").toUpperCase();
      }

      try {
        return PropertyInfoIndex.valueOf(name);
      } catch (final Throwable ignored) {
        return null;
      }
    }

    /** get the qname
     *
     * @return qname
     */
    public QName getQname() {
      return qname;
    }

    /** get the XML class
     *
     * @return class
     */
    public Class getXmlClass() {
      return xmlClass;
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

    /** True if it's a vcalendar property
     *
     * @return boolean
     */
    public boolean getVcalendarProperty() {
      return components.vcalendarProperty;
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

    /** True if it's a vpoll property
     *
     * @return boolean
     */
    public boolean getVpollProperty() {
      return components.vpollProperty;
    }

    /** get the index given the XML class
     * @param cl - class
     * @return PropertyInfoIndex
     */
    public static PropertyInfoIndex fromXmlClass(final Class cl) {
      return xmlClassLookup.get(cl);
    }

    /** get the index given the qname
     *
     * @param val the qname
     * @return PropertyInfoIndex
     */
    public static PropertyInfoIndex lookupQname(final QName val) {
      return qnameLookup.get(val);
    }
  }
}
