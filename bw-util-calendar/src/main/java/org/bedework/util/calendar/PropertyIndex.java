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

import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;

import javax.xml.namespace.QName;

/** Define an (arbitrary) index associated with calendar properties
 *
 * @author Mike Douglass   douglm  rpi.edu
 */
public class PropertyIndex implements Serializable {
  private PropertyIndex() {};

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

  private static boolean IS_MULTI = true;

  private static boolean IS_SINGLE = false;

  private static boolean IS_PARAM = true;

  private static boolean NOT_PARAM = false;

  private static boolean IS_IMMUTABLE = true;

  private static boolean NOT_IMMUTABLE = false;

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

    private QName qname;

    private String pname;

    private String pnameLC;

    private String jname;

    private Class xmlClass;

    private static Map<String, ComponentInfoIndex> pnameLookup =
            new HashMap<>();

    private static Map<QName, ComponentInfoIndex> qnameLookup =
            new HashMap<>();

    private static Map<Class, ComponentInfoIndex> xmlClassLookup =
            new HashMap<>();

    static {
      for (ComponentInfoIndex cii: values()) {
        String pname = cii.getPnameLC();

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
     * @param cl
     * @return ComponentInfoIndex
     */
    public static ComponentInfoIndex fromXmlClass(final Class cl) {
      return xmlClassLookup.get(cl);
    }

    /** get the index given the property name
     *
     * @param val
     * @return ComponentInfoIndex
     */
    public static ComponentInfoIndex lookupPname(final String val) {
      return pnameLookup.get(val.toLowerCase());
    }

    /** get the index given the qname
     *
     * @param val
     * @return ComponentInfoIndex
     */
    public static ComponentInfoIndex lookupQname(final QName val) {
      return qnameLookup.get(val);
    }
  }

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

    private String pname;

    private String pnameLC;

    private String jname;

    private DataType ptype;

    private static HashMap<String, ParameterInfoIndex> pnameLookup =
            new HashMap<>();

    static {
      for (ParameterInfoIndex pii: values()) {
        String pname = pii.getPnameLC();
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
    UNKNOWN_PROPERTY(null, null, null, null,
                     IS_SINGLE, noComponent),

    /** Alarm only: action */
    ACTION(XcalTags.action, "ACTION", null,
           ActionPropType.class,
           IS_SINGLE, alarmOnly),

    /** Multi-valued attachment */
    ATTACH(XcalTags.attach, "ATTACH", null, AttachPropType.class,
           DataType.SPECIAL,
           IS_MULTI, event_Todo_Journal_Alarm),

    /** attendee */
    ATTENDEE(XcalTags.attendee, "ATTENDEE", null,
             AttendeePropType.class,
             DataType.CUA,
             IS_MULTI, notTimezone),

    /** */
    BUSYTYPE(XcalTags.busytype,
             "BUSYTYPE", null,
             BusytypePropType.class,
             IS_SINGLE, vavailabilityOnly),

    /** String names */
    CATEGORIES(XcalTags.categories, "CATEGORIES", null,
              CategoriesPropType.class,
               IS_MULTI, event_Todo_Journal_Alarm),

    /** classification */
    CLASS(XcalTags._class, "CLASS", null, ClassPropType.class, null,
          IS_SINGLE, event_Todo_Journal),

    /** String comment */
    COMMENT(XcalTags.comment, "COMMENT", null,
            CommentPropType.class,
            IS_MULTI, notAlarm),

    /** date/date-time completed */
    COMPLETED(XcalTags.completed, "COMPLETED", null,
              CompletedPropType.class,
              DataType.DATE_TIME,
              IS_SINGLE, todoOnly),

    /** String contact */
    CONTACT(XcalTags.contact, "CONTACT", null,
            ContactPropType.class,
            IS_MULTI, event_Todo_Journal_Freebusy),

    /** UTC datetime */
    CREATED(XcalTags.created, "CREATED", null, CreatedPropType.class,
            DataType.DATE_TIME,
            IS_SINGLE, event_Todo_Journal_Freebusy),

    /** long description */
    DESCRIPTION(XcalTags.description, "DESCRIPTION", null,
                DescriptionPropType.class,
                IS_SINGLE, IS_MULTI, event_Todo_Journal_Alarm),

    /** Event only: end date */
    DTEND(XcalTags.dtend, "DTEND", null, DtendPropType.class,
          DataType.DATE_TIME,
          IS_SINGLE, event_Freebusy),

    /** date stamp */
    DTSTAMP(XcalTags.dtstamp, "DTSTAMP", null,
            DtstampPropType.class,
            DataType.DATE_TIME,
            IS_SINGLE, event_Todo_Journal_Freebusy,
            NOT_PARAM, NOT_IMMUTABLE),

    /** start date/time */
    DTSTART(XcalTags.dtstart, "DTSTART", null,
            DtstartPropType.class,
            DataType.DATE_TIME,
            IS_SINGLE, notAlarm),

    /** tod-: due time */
    DUE(XcalTags.due, "DUE", null, DuePropType.class,
        DataType.DATE_TIME,
        IS_SINGLE, todoOnly),

    /** Duration of event/task etc */
    DURATION(XcalTags.duration, "DURATION", null,
             DurationPropType.class,
             DataType.DURATION,
             IS_SINGLE, event_Todo_Freebusy_Alarm),

    /** Exception date */
    EXDATE(XcalTags.exdate, "EXDATE", null, ExdatePropType.class,
           DataType.DATE_TIME,
           IS_MULTI, event_Todo_Journal_Timezone),

    /** Exception rule */
    EXRULE(XcalTags.exrule, "EXRULE", null, ExrulePropType.class,
           DataType.RECUR,
           IS_MULTI, event_Todo_Journal_Timezone),

    /** */
    FREEBUSY(XcalTags.freebusy, "FREEBUSY", null, FreebusyPropType.class,
             DataType.PERIOD,
             IS_SINGLE, freebusyOnly),

    /** Geographic location */
    GEO(XcalTags.geo, "GEO", null,
        GeoPropType.class,
        IS_SINGLE, event_Todo),

    /** UTC */
    LAST_MODIFIED(XcalTags.lastModified, "LAST-MODIFIED", "lastModified",
                  LastModifiedPropType.class,
                  DataType.DATE_TIME,
                  IS_SINGLE, event_Todo_Journal_Timezone,
                  NOT_PARAM, NOT_IMMUTABLE),

    /** simple location value */
    LOCATION(XcalTags.location, "LOCATION", null,
             LocationPropType.class,
             IS_SINGLE, event_Todo),

    /** meeting organizer */
    ORGANIZER(XcalTags.organizer, "ORGANIZER", null,
              OrganizerPropType.class,
              DataType.CUA,
              IS_SINGLE, event_Todo_Journal_Freebusy),

    /** % complete */
    PERCENT_COMPLETE(XcalTags.percentComplete,
                     "PERCENT-COMPLETE", "percentComplete",
                     PercentCompletePropType.class,
                     IS_SINGLE, todoOnly),

    /** Priority */
    PRIORITY(XcalTags.priority, "PRIORITY", null, PriorityPropType.class,
             DataType.INTEGER,
             IS_SINGLE, event_Todo),

    /** recurrence date/time */
    RDATE(XcalTags.rdate, "RDATE", null, RdatePropType.class,
          DataType.DATE_TIME,
          IS_MULTI, event_Todo_Journal_Timezone),

    /** recurrenceId */
    RECURRENCE_ID(XcalTags.recurrenceId,
                  "RECURRENCE-ID", "recurrenceId",
                  RecurrenceIdPropType.class,
                  DataType.DATE_TIME,
                  IS_SINGLE, event_Todo_Journal_Freebusy),

    /** Establish relationship */
    RELATED_TO(XcalTags.relatedTo, "RELATED-TO", "relatedTo",
               RelatedToPropType.class,
               IS_MULTI, event_Todo_Journal),

    /** Alarm: repeat time */
    REPEAT(XcalTags.repeat, "REPEAT", null, RepeatPropType.class,
           DataType.INTEGER,
           IS_SINGLE, alarmOnly),

    /** Itip */
    REQUEST_STATUS(XcalTags.requestStatus,
                   "REQUEST-STATUS", "requestStatus",
                   RequestStatusPropType.class,
                   IS_MULTI, event_Todo_Journal_Freebusy),

    /** names of resources */
    RESOURCES(XcalTags.resources, "RESOURCES", null,
              ResourcesPropType.class,
              IS_MULTI, event_Todo),

    /** recurrence rule */
    RRULE (XcalTags.rrule, "RRULE", null, RrulePropType.class,
           DataType.RECUR,
           IS_MULTI, event_Todo_Journal_Timezone),

    /** itip sequence # */
    SEQUENCE(XcalTags.sequence, "SEQUENCE", null,
             SequencePropType.class,
             DataType.INTEGER,
             IS_SINGLE, event_Todo_Journal,
             NOT_PARAM, NOT_IMMUTABLE),

    /** Event/task status */
    STATUS(XcalTags.status, "STATUS", null,
           StatusPropType.class,
           IS_SINGLE, event_Todo_Journal),

    /** short summary */
    SUMMARY(XcalTags.summary, "SUMMARY", null,
            SummaryPropType.class,
            IS_SINGLE, IS_MULTI, event_Todo_Journal_Alarm),

    /** Alarm trigger */
    TRIGGER(XcalTags.trigger, "TRIGGER", null, TriggerPropType.class,
            DataType.DURATION,
            IS_SINGLE, alarmOnly),

    /** Transparency */
    TRANSP(XcalTags.transp, "TRANSP", null,
           TranspPropType.class,
           IS_SINGLE, eventOnly),

    /** */
    TZID(XcalTags.tzid, "TZID", null,
         TzidPropType.class,
         IS_SINGLE, timezoneOnly),

    /** */
    TZNAME(XcalTags.tzname, "TZNAME", null,
           TznamePropType.class,
           IS_SINGLE, timezoneOnly),

    /** */
    TZOFFSETFROM(XcalTags.tzoffsetfrom, "TZOFFSETFROM", null,
                 TzoffsetfromPropType.class,
                 DataType.UTC_OFFSET,
                 IS_SINGLE, timezoneOnly),

    /** */
    TZOFFSETTO(XcalTags.tzoffsetto, "TZOFFSETTO", null,
               TzoffsettoPropType.class,
               DataType.UTC_OFFSET,
               IS_SINGLE, timezoneOnly),

    /** */
    TZURL(XcalTags.tzurl, "TZURL", null, TzurlPropType.class,
          DataType.URI,
          IS_SINGLE, timezoneOnly),

    /** Unique id */
    UID(XcalTags.uid, "UID", null,
        UidPropType.class,
        IS_SINGLE, event_Todo_Journal_Freebusy),

    /** link to some related resource */
    URL(XcalTags.url, "URL", null, UrlPropType.class,
        DataType.URI,
        IS_SINGLE, event_Todo_Journal_Freebusy),

    /** treat x-properties as a single multi-valued property */
    XPROP(BedeworkServerTags.xprop, "XPROP", null, null,
          IS_MULTI, allComponents),

    /** accept-response */
    ACCEPT_RESPONSE(XcalTags.acceptResponse,
                    "ACCEPT-RESPONSE", "acceptResponse",
                    AcceptResponsePropType.class,
                    IS_SINGLE, vpollOnly),

    /** Poll-item-id */
    POLL_ITEM_ID(XcalTags.pollItemId, "POLL-ITEM-ID", "pollItemId",
                 PollItemIdPropType.class,
        IS_SINGLE, event_Todo_Journal_Freebusy),

    /** Poll-mode */
    POLL_MODE(XcalTags.pollMode, "POLL_MODE", "pollMode",
              PollModePropType.class,
        IS_SINGLE, vpollOnly),

    /** Poll-properties */
    POLL_PROPERTIES(XcalTags.pollProperties,
                    "POLL_PROPERTIES", "pollProperties",
                    PollPropertiesPropType.class,
                    IS_MULTI, vpollOnly),

    /** attendee */
    VOTER(XcalTags.voter, "VOTER", null, VoterPropType.class,
          DataType.CUA,
          IS_MULTI, notTimezone),

    /* -------------- Non-ical ---------------- */

    /** non ical */
    COLLECTION(BedeworkServerTags.collection,
               "COLLECTION", null, null,
               IS_SINGLE, event_Todo_Journal),

    /** non ical */
    COST(BedeworkServerTags.cost, "COST", null, null,
         IS_SINGLE, event_Todo),

    /** non ical */
    CREATOR(BedeworkServerTags.creator, "CREATOR", null,
            null,
            DataType.HREF,
            IS_SINGLE, event_Todo_Journal,
            NOT_PARAM, IS_IMMUTABLE),

    /** non ical */
    DELETED(BedeworkServerTags.deleted, "DELETED", null, null,
            IS_SINGLE, event_Todo),

    /** non ical */
    END_TYPE(BedeworkServerTags.endType, "END-TYPE", "endType", null,
             IS_SINGLE, event_Todo_Journal),

    /** non ical */
    ETAG(BedeworkServerTags.etag, "ETAG", null, null,
         DataType.TEXT,
         IS_SINGLE, noComponent,
         NOT_PARAM, IS_IMMUTABLE),

    /** non ical */
    ENTITY_TYPE(BedeworkServerTags.entityType,
                "ENTITY_TYPE", "entityType", null,
                DataType.INTEGER,
                IS_SINGLE, event_Todo_Journal,
                NOT_PARAM, IS_IMMUTABLE),

    /** non ical */
    HREF(WebdavTags.href, "HREF", "href", null,
         DataType.HREF,
         IS_SINGLE, allComponents,
         NOT_PARAM, IS_IMMUTABLE),

    /** non ical */
    OWNER(BedeworkServerTags.owner, "OWNER", null, null,
          DataType.HREF,
          IS_SINGLE, event_Todo_Journal,
          NOT_PARAM, IS_IMMUTABLE),

    /** treat VALARM sub-component as a property */
    VALARM(XcalTags.valarm, "VALARM", null,
           ValarmType.class,
           IS_MULTI, notAlarm),

    /** ----------------------------- Following are parameters ----------- */

    /** */
    LANG(BedeworkServerTags.language, "LANGUAGE", null,
         LanguageParamType.class,
         DataType.TEXT,
         IS_SINGLE, noComponent,
         IS_PARAM, NOT_IMMUTABLE),

    /** */
    TZIDPAR(XcalTags.tzid, "TZID", null, TzidParamType.class,
            DataType.TEXT, IS_SINGLE, noComponent,
            IS_PARAM, NOT_IMMUTABLE),

    /** ----------------------------- X-properties in schema ----------- */

    /** Cost */
    XBEDEWORK_COST(XcalTags.xBedeworkCost,
                   "X-BEDEWORK-COST", "xBedeworkCost",
                   XBedeworkCostPropType.class,
                   IS_SINGLE, event_Todo),

    /** ----------------------------- Vcalendar properties ----------- */

    /** Transparency */
    CALSCALE(XcalTags.calscale, "CALSCALE", null,
             CalscalePropType.class,
             IS_SINGLE, vcalendarOnly),

    /** Transparency */
    METHOD(XcalTags.method, "METHOD", null,
           MethodPropType.class,
           IS_SINGLE, vcalendarOnly),

    /** Transparency */
    PRODID(XcalTags.transp, "PRODID", null,
           ProdidPropType.class,
           IS_SINGLE, vcalendarOnly),

    /** Transparency */
    VERSION(XcalTags.transp, "VERSION", null,
            VersionPropType.class,
            IS_SINGLE, vcalendarOnly),

    /** ------------------------ Bedework only properties ----------- */

    /** ACL */
    ACL(BedeworkServerTags.xprop, "ACL", null, null,
        IS_MULTI, allComponents),

    ATTENDEE_SCHEDULING_OBJECT(BedeworkServerTags.xprop,
                               "ATTENDEE-SCHEDULING-OBJECT",
                               "attendeeSchedulingObject",
                               null,
                               IS_SINGLE, allComponents),

    /** path to containing collection */
    COLPATH(BedeworkServerTags.xprop, "COLPATH", null, null,
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
    CTAG(BedeworkServerTags.ctag, "CTAG", null, null,
         DataType.TEXT,
         IS_SINGLE, noComponent,
         NOT_PARAM, IS_IMMUTABLE),

    /** non ical */
    CTOKEN(BedeworkServerTags.xprop, "CTOKEN", null, null,
           DataType.TEXT,
           IS_SINGLE, noComponent,
           NOT_PARAM, IS_IMMUTABLE),

    EVENTREG_END(BedeworkServerTags.xprop,
                 "eventregEnd", null, null,
                 IS_SINGLE, allComponents),

    EVENTREG_MAX_TICKETS(BedeworkServerTags.xprop,
                         "eventregMaxTickets", null, null,
                 IS_SINGLE, allComponents),

    EVENTREG_MAX_TICKETS_PER_USER(BedeworkServerTags.xprop,
                                  "eventregMaxTicketsPerUser", null, null,
                                  IS_SINGLE, allComponents),

    EVENTREG_START(BedeworkServerTags.xprop,
                   "eventregStart", null, null,
                   IS_SINGLE, allComponents),

    /**  date/time utc value */
    UTC(XcalTags.dtstart, "UTC", null,
        DtstartPropType.class,
        DataType.DATE_TIME,
        IS_SINGLE, notAlarm),

    /** date/time - local */
    LOCAL(XcalTags.dtstart, "LOCAL", null,
          DtstartPropType.class,
          DataType.DATE_TIME,
          IS_SINGLE, notAlarm),

    /** date/time - floating true/false */
    FLOATING(XcalTags.dtstart, "FLOATING", null,
             DtstartPropType.class,
             DataType.DATE_TIME,
             IS_SINGLE, notAlarm),

    IMAGE(BedeworkServerTags.xprop, "IMAGE", null, null,
               IS_SINGLE, allComponents),

    /** location uid */
    LOCATION_UID(XcalTags.location, "LOCATION_UID", "locationUid",
                 LocationPropType.class,
                 IS_SINGLE, event_Todo),

    /** location string value */
    LOCATION_STR(XcalTags.location, "LOCATION_STR", "locationStr",
                 LocationPropType.class,
                 IS_SINGLE, event_Todo),

    /** name of entity */
    NAME(BedeworkServerTags.xprop, "NAME", null, null,
         IS_SINGLE, allComponents),

    ORGANIZER_SCHEDULING_OBJECT(BedeworkServerTags.xprop,
                                "ORGANIZER-SCHEDULING-OBJECT",
                                "organizerSchedulingObject",
                                null,
                                IS_SINGLE, allComponents),

    ORIGINATOR(BedeworkServerTags.xprop, "ORIGINATOR", null, null,
               IS_SINGLE, allComponents),

    PUBLIC(BedeworkServerTags.xprop, "PUBLIC", null, null,
               IS_SINGLE, allComponents),

    RECIPIENT(BedeworkServerTags.xprop, "RECIPIENT", null, null,
              IS_SINGLE, allComponents),

    RECURRING(BedeworkServerTags.xprop, "RECURRING", null, null,
              IS_SINGLE, allComponents),

    /** schedule method */
    SCHEDULE_METHOD(BedeworkServerTags.xprop,
                    "SCHEDULE-METHOD", "scheduleMethod", null,
                    IS_SINGLE, allComponents),

    SCHEDULE_STATE(BedeworkServerTags.xprop,
                   "SCHEDULE-STATE", "scheduleState", null,
                   IS_SINGLE, allComponents),

    /** schedule tag */
    SCHEDULE_TAG(BedeworkServerTags.xprop,
                 "SCHEDULE-TAG", "scheduleTag", null,
                 IS_SINGLE, allComponents),

    /** Temp - we should do this as a type of image */
    THUMBIMAGE(BedeworkServerTags.xprop, "THUMBIMAGE", null, null,
          IS_SINGLE, allComponents),

    TOPICAL_AREA(BedeworkServerTags.xprop, "topicalArea", null, null,
                 IS_SINGLE, allComponents),

    TRIGGER_DATE_TIME(BedeworkServerTags.xprop,
                      "TRIGGER-DATE-TIME", "triggerDateTime", null,
                      IS_SINGLE, allComponents),

    /** Virtual path - only appears in unparsed/unresolved fexpr */
    VPATH(BedeworkServerTags.xprop, "VPATH", null, null,
          IS_SINGLE, allComponents),

    /** View - only appears in unparsed/unresolved fexpr */
    VIEW(BedeworkServerTags.xprop, "VIEW", null, null,
         IS_SINGLE, allComponents),

    PARAMETERS(BedeworkServerTags.xprop,
               "PARAMETERS", "pars", null,
               IS_SINGLE, allComponents),

    /** Is start present? */
    START_PRESENT(BedeworkServerTags.xprop,
                  "START_PRESENT", "startPresent", null,
                  IS_SINGLE, allComponents),

    /** Special term for sorts */
    RELEVANCE(BedeworkServerTags.xprop, "RELEVANCE", null, null,
              IS_SINGLE, allComponents),

    /** link to some related resource */
    URI(BedeworkServerTags.xprop, "URI", null, UrlPropType.class,
        DataType.URI,
        IS_SINGLE, allComponents),

    VALUE(BedeworkServerTags.xprop,
          "VALUE", "value", null,
          IS_SINGLE, allComponents),

    /** ------------------------ contacts ----------- */

    CN(BedeworkServerTags.xprop,
       "CN", null, null,
       IS_SINGLE, allComponents),

    EMAIL(BedeworkServerTags.xprop,
          "EMAIL", null, null,
          IS_SINGLE, allComponents),

    PHONE(BedeworkServerTags.xprop,
          "PHONE", null, null,
          IS_SINGLE, allComponents),

    /** ------------------------ locations ----------- */

    ADDRESS(BedeworkServerTags.xprop,
          "ADDRESS", null, null,
          IS_SINGLE, allComponents),

    SUBADDRESS(BedeworkServerTags.xprop,
          "SUBADDRESS", null, null,
          IS_SINGLE, allComponents),
    ;

    private QName qname;

    private String pname;

    private String jname;

    private String pnameLC;

    private Class xmlClass;

    private DataType ptype;

    /* true if the standard says it's multi */
    private boolean multiValued;

    /* true if we store multi - e.g. multi-language */
    private boolean dbMultiValued;

    private boolean param; /* It's a parameter   */

    private boolean immutable;

    private ComponentFlags components;

    private static Map<String, PropertyInfoIndex> pnameLookup =
            new HashMap<>();

    private static Map<QName, PropertyInfoIndex> qnameLookup =
            new HashMap<>();

    private static Map<Class, PropertyInfoIndex> xmlClassLookup =
            new HashMap<>();

    static {
      for (PropertyInfoIndex pii: values()) {
        String pname = pii.getPnameLC();
        pnameLookup.put(pname, pii);

        qnameLookup.put(pii.getQname(), pii);

        xmlClassLookup.put(pii.xmlClass, pii);
      }
    }

    PropertyInfoIndex(final QName qname,
                      final String pname,
                      final String jname,
                      final Class xmlClass,
                      final boolean multiValued,
                      final ComponentFlags components) {
      this.qname = qname;
      this.pname = pname;
      this.jname = jname;
      this.xmlClass = xmlClass;
      this.components = components;
      this.multiValued = multiValued;
      dbMultiValued = multiValued;

      if (pname != null) {
        pnameLC = pname.toLowerCase();
      }

      if (jname == null) {
        this.jname = pnameLC;
      }
    }

    PropertyInfoIndex(final QName qname,
                      final String pname,
                      final String jname,
                      final Class xmlClass,
                      final DataType ptype,
                      final boolean multiValued,
                      final ComponentFlags components) {
      this(qname, pname, jname, xmlClass, multiValued, components);
      this.ptype = ptype;
    }

    PropertyInfoIndex(final QName qname,
                      final String pname,
                      final String jname,
                      final Class xmlClass,
                      final boolean multiValued,
                      final boolean dbMultiValued,
                      final ComponentFlags components) {
      this(qname, pname, jname, xmlClass, DataType.TEXT,
           multiValued, components,
           NOT_PARAM, NOT_IMMUTABLE);
      this.dbMultiValued = dbMultiValued;
    }

    PropertyInfoIndex(final QName qname,
                      final String pname,
                      final String jname,
                      final Class xmlClass,
                      final DataType ptype,
                      final boolean multiValued,
                      final ComponentFlags components,
                      final boolean param,
                      final boolean immutable) {
      this(qname, pname, jname, xmlClass, multiValued, components);
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
     * @param cl
     * @return PropertyInfoIndex
     */
    public static PropertyInfoIndex fromXmlClass(final Class cl) {
      return xmlClassLookup.get(cl);
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
