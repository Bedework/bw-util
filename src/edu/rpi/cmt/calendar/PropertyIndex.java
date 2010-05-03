/* **********************************************************************
    Copyright 2009 Rensselaer Polytechnic Institute. All worldwide rights reserved.

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

import java.io.Serializable;
import java.util.HashMap;

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

    ComponentFlags(final boolean eventProperty,
                   final boolean todoProperty,
                   final boolean journalProperty,
                   final boolean freeBusyProperty,
                   final boolean timezoneProperty,
                   final boolean alarmProperty) {
      this.eventProperty = eventProperty;
      this.todoProperty = todoProperty;
      this.journalProperty = journalProperty;
      this.freeBusyProperty = freeBusyProperty;
      this.timezoneProperty = timezoneProperty;
      this.alarmProperty = alarmProperty;
    }
  }

  static final ComponentFlags noComponent =
     new ComponentFlags(false, false, false, false, false, false);

  static final ComponentFlags eventOnly =
     new ComponentFlags(true, false, false, false, false, false);

  static final ComponentFlags todoOnly =
     new ComponentFlags(false, true, false, false, false, false);

  static final ComponentFlags freebusyOnly =
     new ComponentFlags(false, false, false, true, false, false);

  static final ComponentFlags timezoneOnly =
     new ComponentFlags(false, false, false, false, true, false);

  static final ComponentFlags alarmOnly =
     new ComponentFlags(false, false, false, false, false, true);

  static final ComponentFlags event_Todo =
     new ComponentFlags(true, true, false, false, false, false);

  static final ComponentFlags event_Todo_Journal =
     new ComponentFlags(true, true, true, false, false, false);

  static final ComponentFlags event_Todo_Freebusy =
     new ComponentFlags(true, true, false, true, false, false);

  static final ComponentFlags event_Freebusy =
     new ComponentFlags(true, false, false, true, false, false);

  static final ComponentFlags event_Todo_Journal_Freebusy =
     new ComponentFlags(true, true, true, true, false, false);

  static final ComponentFlags event_Todo_Journal_Timezone =
     new ComponentFlags(true, true, true, false, true, false);

  static final ComponentFlags event_Todo_Journal_Alarm =
     new ComponentFlags(true, true, true, false, false, true);

  static final ComponentFlags notTimezone =
     new ComponentFlags(true, true, true, true, false, true);

  static final ComponentFlags notAlarm =
     new ComponentFlags(true, true, true, true, true, false);

  static final ComponentFlags allComponents =
     new ComponentFlags(true, true, true, true, true, true);

  private static boolean IS_MULTI = true;

  private static boolean IS_SINGLE = false;

  private static boolean IS_PARAM = true;

  private static boolean NOT_PARAM = false;

  private static boolean IS_IMMUTABLE = true;

  private static boolean NOT_IMMUTABLE = false;

  private static boolean IS_SCHEDULING_SIGNIFICANT = true;

  private static boolean NOT_SCHEDULING_SIGNIFICANT = false;


  /** */
  public static enum PropertyInfoIndex {
    /** */
    UNKNOWN_PROPERTY(null, IS_SINGLE, noComponent),

    /** */
    CLASS("CLASS", IS_SINGLE, event_Todo_Journal),

    /** */
    CREATED("CREATED", IS_SINGLE, event_Todo_Journal_Freebusy),

    /** */
    DESCRIPTION("DESCRIPTION", IS_SINGLE, IS_MULTI, event_Todo_Journal_Alarm),

    /** */
    DTSTAMP("DTSTAMP", IS_SINGLE, event_Todo_Journal_Freebusy,
            NOT_PARAM, NOT_IMMUTABLE, NOT_SCHEDULING_SIGNIFICANT),

    /** */
    DTSTART("DTSTART", IS_SINGLE, notAlarm),

    /** */
    DURATION("DURATION", IS_SINGLE, event_Todo_Freebusy),

    /** */
    GEO("GEO", IS_SINGLE, event_Todo),

    /** */
    LAST_MODIFIED("LAST-MODIFIED", IS_SINGLE, event_Todo_Journal_Timezone,
                  NOT_PARAM, NOT_IMMUTABLE, NOT_SCHEDULING_SIGNIFICANT),

    /** */
    LOCATION("LOCATION", IS_SINGLE, event_Todo),

    /** */
    ORGANIZER("ORGANIZER", IS_SINGLE, event_Todo_Journal_Freebusy),

    /** */
    PRIORITY("PRIORITY", IS_SINGLE, event_Todo),

    /** */
    RECURRENCE_ID("RECURRENCE-ID", IS_SINGLE, event_Todo_Journal_Freebusy),

    /** */
    SEQUENCE("SEQUENCE", IS_SINGLE, event_Todo_Journal,
             NOT_PARAM, NOT_IMMUTABLE, NOT_SCHEDULING_SIGNIFICANT),

    /** */
    STATUS("STATUS", IS_SINGLE, event_Todo_Journal),

    /** */
    SUMMARY("SUMMARY", IS_SINGLE, IS_MULTI, event_Todo_Journal_Alarm),

    /** */
    UID("UID", IS_SINGLE, event_Todo_Journal_Freebusy),

    /** */
    URL("URL", IS_SINGLE, event_Todo_Journal_Freebusy),

    /* Event only */

    /** */
    DTEND("DTEND", IS_SINGLE, event_Freebusy),

    /** */
    TRANSP("TRANSP", IS_SINGLE, eventOnly),

    /* Todo only */

    /** */
    COMPLETED("COMPLETED", IS_SINGLE, todoOnly),

    /** */
    DUE("DUE", IS_SINGLE, todoOnly),

    /** */
    PERCENT_COMPLETE("PERCENT-COMPLETE", IS_SINGLE, todoOnly),

    /* ---------------------------- Multi valued --------------- */

    /* Event and Todo */

    /** */
    ATTACH("ATTACH", IS_MULTI, event_Todo_Journal_Alarm),

    /** */
    ATTENDEE("ATTENDEE", IS_MULTI, notTimezone),

    /** */
    CATEGORIES("CATEGORIES", IS_MULTI, event_Todo_Journal_Alarm),

    /** */
    COMMENT("COMMENT", IS_MULTI, notAlarm),

    /** */
    CONTACT("COMMENT", IS_MULTI, event_Todo_Journal_Freebusy),

    /** */
    EXDATE("EXDATE", IS_MULTI, event_Todo_Journal_Timezone),

    /** */
    EXRULE("EXRULE", IS_MULTI, event_Todo_Journal_Timezone),

    /** */
    REQUEST_STATUS("REQUEST-STATUS", IS_MULTI, event_Todo_Journal_Freebusy),

    /** */
    RELATED_TO("RELATED-TO", IS_MULTI, event_Todo_Journal),

    /** */
    RESOURCES("RESOURCES", IS_MULTI, event_Todo),

    /** */
    RDATE("RDATE", IS_MULTI, event_Todo_Journal_Timezone),

    /** */
    RRULE ("RRULE", IS_MULTI, event_Todo_Journal_Timezone),

    /* -------------- Other non-event, non-todo ---------------- */

    /** */
    FREEBUSY("FREEBUSY", IS_SINGLE, freebusyOnly),

    /** */
    TZID("TZID", IS_SINGLE, timezoneOnly),

    /** */
    TZNAME("TZNAME", IS_SINGLE, timezoneOnly),

    /** */
    TZOFFSETFROM("TZOFFSETFROM", IS_SINGLE, timezoneOnly),

    /** */
    TZOFFSETTO("TZOFFSETTO", IS_SINGLE, timezoneOnly),

    /** */
    TZURL("TZURL", IS_SINGLE, timezoneOnly),

    /** */
    ACTION("ACTION", IS_SINGLE, alarmOnly),

    /** */
    REPEAT("REPEAT", IS_SINGLE, alarmOnly),

    /** */
    TRIGGER("TRIGGER", IS_SINGLE, alarmOnly),

    /* -------------- Non-ical ---------------- */

    /** non ical */
    CREATOR("CREATOR", IS_SINGLE, event_Todo_Journal,
            NOT_PARAM, IS_IMMUTABLE, NOT_SCHEDULING_SIGNIFICANT),

    /** non ical */
    OWNER("OWNER", IS_SINGLE, event_Todo_Journal,
          NOT_PARAM, IS_IMMUTABLE, NOT_SCHEDULING_SIGNIFICANT),

    /** non ical */
    END_TYPE("END-TYPE", IS_SINGLE, event_Todo_Journal),

    /** non ical */
    COST("COST", IS_SINGLE, event_Todo),

    /** non ical */
    CTAG("CTAG", IS_SINGLE, noComponent,
         NOT_PARAM, IS_IMMUTABLE, NOT_SCHEDULING_SIGNIFICANT),

    /** non ical */
    DELETED("DELETED", IS_SINGLE, event_Todo),

    /** non ical */
    ETAG("ETAG", IS_SINGLE, noComponent,
         NOT_PARAM, IS_IMMUTABLE, NOT_SCHEDULING_SIGNIFICANT),

    /** non ical */
    COLLECTION("COLLECTION", IS_SINGLE, event_Todo_Journal),

    /** non ical */
    ENTITY_TYPE("ENTITY_TYPE", IS_SINGLE, event_Todo_Journal,
                NOT_PARAM, IS_IMMUTABLE, NOT_SCHEDULING_SIGNIFICANT),

    /** treat VALARM sub-component as a property */
    VALARM("VALARM", IS_MULTI, notAlarm),

    /** treat x-properties as a single multi-valued property */
    XPROP("XPROP", IS_MULTI, allComponents),

    /** ----------------------------- Following are parameters ----------- */

    /** */
    LANG("LANGUAGE", IS_SINGLE, noComponent,
         IS_PARAM, NOT_IMMUTABLE, IS_SCHEDULING_SIGNIFICANT),

    /** */
    TZIDPAR("TZID", IS_SINGLE, noComponent,
            IS_PARAM, NOT_IMMUTABLE, IS_SCHEDULING_SIGNIFICANT),
            ;

    private String pname;

    /* true if the standard says it's multi */
    private boolean multiValued;

    /* true if we store multi - e.g. multi-language */
    private boolean dbMultiValued;

    private boolean param; /* It's a parameter   */

    private boolean immutable;

    private boolean schedulingSignificant;

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

    PropertyInfoIndex(final String pname, final boolean multiValued,
                      final boolean dbMultiValued,
                      final ComponentFlags components) {
      this(pname, multiValued, components,
           NOT_PARAM, NOT_IMMUTABLE, IS_SCHEDULING_SIGNIFICANT);
      this.dbMultiValued = dbMultiValued;
    }

    PropertyInfoIndex(final String pname, final boolean multiValued,
                      final ComponentFlags components,
                      final boolean param,
                      final boolean immutable,
                      final boolean schedulingSignificant) {
      this(pname, multiValued, components);
      this.param = param;
      this.immutable = immutable;
      this.schedulingSignificant = schedulingSignificant;
    }

    /** get the property name
     *
     * @return property name
     */
    public String getPname() {
      return pname;
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

    /** True if a change is significant for scheduling
     *
     * @return boolean
     */
    public boolean getSchedulingSignificant() {
      return schedulingSignificant;
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
