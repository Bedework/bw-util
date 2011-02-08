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
package edu.rpi.sss.util.xml.tagdefs;

import javax.xml.namespace.QName;

/** Define tags for icalendar in XML.
 *
 * @author Mike Douglass   douglm - rpi.edu
 */
public class XcalTags {
  /** */
  public static final String namespace = "urn:ietf:params:xml:ns:icalendar-2.0";

  /** */
  public static final String mimetype = "application/calendar+xml";

  /* =====================================================================
                              Structural
     ===================================================================== */

  /**   */
  public static final QName icalendar = new QName(namespace, "icalendar");

  /**   */
  public static final QName components = new QName(namespace, "components");

  /**   */
  public static final QName parameters = new QName(namespace, "parameters");

  /**   */
  public static final QName properties = new QName(namespace, "properties");

  /* =====================================================================
                             components
     ===================================================================== */

  /** */
  public static final QName vcalendar = new QName(namespace, "vcalendar");

  /** */
  public static final QName vtodo = new QName(namespace, "vtodo");

  /** */
  public static final QName vjournal = new QName(namespace, "vjournal");

  /** */
  public static final QName vevent = new QName(namespace, "vevent");

  /** */
  public static final QName vfreebusy = new QName(namespace, "vfreebusy");

  /** */
  public static final QName valarm = new QName(namespace, "valarm");

  /** */
  public static final QName standard = new QName(namespace, "standard");

  /** */
  public static final QName vtimezone = new QName(namespace, "vtimezone");

  /** */
  public static final QName daylight = new QName(namespace, "daylight");

  /* =====================================================================
                              value types
     ===================================================================== */

  /**   */
  public static final QName binaryVal = new QName(namespace, "binary");

  /**   */
  public static final QName booleanVal = new QName(namespace, "boolean");

  /**   */
  public static final QName calAddressVal = new QName(namespace, "cal-address");

  /**   */
  public static final QName dateVal = new QName(namespace, "date");

  /**   */
  public static final QName dateTimeVal = new QName(namespace, "date-time");

  /**   */
  public static final QName durationVal = new QName(namespace, "duration");

  /**   */
  public static final QName floatVal = new QName(namespace, "float");

  /**   */
  public static final QName integerVal = new QName(namespace, "integer");

  /**   */
  public static final QName periodVal = new QName(namespace, "period");

  /**   */
  public static final QName textVal = new QName(namespace, "text");

  /**   */
  public static final QName timeVal = new QName(namespace, "time");

  /**   */
  public static final QName uriVal = new QName(namespace, "uri");

  /** */
  public static final QName utcDateTimeVal = new QName(namespace, "utc-date-time");

  /**   */
  public static final QName utcOffsetVal = new QName(namespace, "utc-offset");

  /* =====================================================================
                              geo
     ===================================================================== */

  /** */
  public static final QName latitudeVal = new QName(namespace, "latitude");

  /** */
  public static final QName longitudeVal = new QName(namespace, "longitude");

  /* =====================================================================
                    Request status value elements
     ===================================================================== */

  /** */
  public static final QName codeVal = new QName(namespace, "code");

  /** */
  public static final QName descriptionVal = new QName(namespace, "description");

  /** */
  public static final QName extdataVal = new QName(namespace, "extdata");

  /* =====================================================================
                              recur
     ===================================================================== */

  /** */
  public static final QName recurVal = new QName(namespace, "recur");

  /**   */
  public static final QName freq = new QName(namespace, "freq");

  /**   */
  public static final QName until = new QName(namespace, "until");

  /**   */
  public static final QName count = new QName(namespace, "count");

  /**   */
  public static final QName interval = new QName(namespace, "interval");

  /**   */
  public static final QName bysecond = new QName(namespace, "bysecond");

  /**   */
  public static final QName byminute = new QName(namespace, "byminute");

  /**   */
  public static final QName byhour = new QName(namespace, "byhour");

  /**   */
  public static final QName byday = new QName(namespace, "byday");

  /**   */
  public static final QName bymonthday = new QName(namespace, "bymonthday");

  /**   */
  public static final QName byyearday = new QName(namespace, "byyearday");

  /**   */
  public static final QName byweekno = new QName(namespace, "byweekno");

  /**   */
  public static final QName bymonth = new QName(namespace, "bymonth");

  /**   */
  public static final QName bysetpos = new QName(namespace, "bysetpos");

  /**   */
  public static final QName wkst = new QName(namespace, "wkst");

  /* =====================================================================
                              properties
     ===================================================================== */

  /**     *     *     *        *            *   VALARM */
  public static final QName action = new QName(namespace, "action");

  /** VEVENT VTODO VJOURNAL    *            *   VALARM */
  public static final QName attach = new QName(namespace, "attach");

  /** VEVENT VTODO VJOURNAL VFREEBUSY       *   VALARM */
  public static final QName attendee = new QName(namespace, "attendee");

  /**     *     *     *        *            *     *    CALENDAR*/
  public static final QName calscale = new QName(namespace, "calscale");

  /** VEVENT VTODO VJOURNAL */
  public static final QName categories = new QName(namespace, "categories");

  /** VEVENT VTODO VJOURNAL */
  public static final QName _class = new QName(namespace, "class");

  /** VEVENT VTODO VJOURNAL VFREEBUSY VTIMEZONE */
  public static final QName comment = new QName(namespace, "comment");

  /**     *  VTODO */
  public static final QName completed = new QName(namespace, "completed");

  /** VEVENT VTODO VJOURNAL VFREEBUSY */
  public static final QName contact = new QName(namespace, "contact");

  /** VEVENT VTODO VJOURNAL */
  public static final QName created = new QName(namespace, "created");

  /** VEVENT VTODO VJOURNAL    *            *   VALARM */
  public static final QName description = new QName(namespace, "description");

  /** VEVENT    *     *     VFREEBUSY */
  public static final QName dtend = new QName(namespace, "dtend");

  /** VEVENT VTODO VJOURNAL VFREEBUSY */
  public static final QName dtstamp = new QName(namespace, "dtstamp");

  /** VEVENT VTODO    *     VFREEBUSY VTIMEZONE */
  public static final QName dtstart = new QName(namespace, "dtstart");

  /**     *  VTODO */
  public static final QName due = new QName(namespace, "due");

  /** VEVENT VTODO    *     VFREEBUSY       *   VALARM */
  public static final QName duration = new QName(namespace, "duration");

  /** VEVENT VTODO VJOURNAL    *      VTIMEZONE */
  public static final QName exdate = new QName(namespace, "exdate");

  /** VEVENT VTODO VJOURNAL */
  public static final QName exrule = new QName(namespace, "exrule");

  /**     *     *     *     VFREEBUSY */
  public static final QName freebusy = new QName(namespace, "freebusy");

  /** VEVENT VTODO */
  public static final QName geo = new QName(namespace, "geo");

  /** */
  public static final QName hasAlarm = new QName(namespace, "has-alarm");

  /** */
  public static final QName hasAttachment = new QName(namespace,
                                                      "has-attachment");

  /** */
  public static final QName hasRecurrence = new QName(namespace,
                                                      "has-recurrence");

  /** VEVENT VTODO VJOURNAL    *      VTIMEZONE */
  public static final QName lastModified = new QName(namespace,
                                                     "last-modified");

  /** VEVENT VTODO */
  public static final QName location = new QName(namespace, "location");

  /**     *     *     *                                CALENDAR*/
  public static final QName method = new QName(namespace, "method");

  /** VEVENT VTODO VJOURNAL VFREEBUSY */
  public static final QName organizer = new QName(namespace, "organizer");

  /**     *  VTODO */
  public static final QName percentComplete = new QName(namespace,
                                                        "percent-complete");

  /** VEVENT VTODO */
  public static final QName priority = new QName(namespace, "priority");

  /**     *     *     *                                CALENDAR*/
  public static final QName prodid = new QName(namespace, "prodid");

  /** VEVENT VTODO VJOURNAL    *      VTIMEZONE */
  public static final QName rdate = new QName(namespace, "rdate");

  /** VEVENT VTODO VJOURNAL    *      VTIMEZONE */
  public static final QName recurrenceId = new QName(namespace,
                                                     "recurrence-id");

  /** VEVENT VTODO VJOURNAL */
  public static final QName relatedTo = new QName(namespace,
                                                 "related-to");

  /**     *     *     *        *            *   VALARM */
  public static final QName repeat = new QName(namespace, "repeat");

  /** VEVENT VTODO */
  public static final QName resources = new QName(namespace, "resources");

  /** VEVENT VTODO VJOURNAL VFREEBUSY */
  public static final QName requestStatus = new QName(namespace,
                                                      "request-status");

  /** VEVENT VTODO VJOURNAL    *      VTIMEZONE */
  public static final QName rrule = new QName(namespace, "rrule");

  /** VEVENT VTODO VJOURNAL */
  public static final QName sequence = new QName(namespace, "sequence");

  /** VEVENT VTODO VJOURNAL */
  public static final QName status = new QName(namespace, "status");

  /** VEVENT VTODO VJOURNAL    *            *   VALARM */
  public static final QName summary = new QName(namespace, "summary");

  /** VEVENT */
  public static final QName transp = new QName(namespace, "transp");

  /** VEVENT VTODO    *        *            *   VALARM */
  public static final QName trigger = new QName(namespace, "trigger");

  /**     *     *     *        *      VTIMEZONE */
  public static final QName tzid = new QName(namespace, "tzid");

  /**     *     *     *               VTIMEZONE */
  public static final QName tzname = new QName(namespace, "tzname");

  /**     *     *     *        *      VTIMEZONE */
  public static final QName tzoffsetfrom = new QName(namespace, "tzoffsetfrom");

  /**     *     *     *        *      VTIMEZONE */
  public static final QName tzoffsetto = new QName(namespace, "tzoffsetto");

  /**     *     *     *        *      VTIMEZONE */
  public static final QName tzurl = new QName(namespace, "tzurl");

  /** VEVENT VTODO VJOURNAL VFREEBUSY */
  public static final QName uid = new QName(namespace, "uid");

  /** VEVENT VTODO VJOURNAL VFREEBUSY */
  public static final QName url = new QName(namespace, "url");

  /**     *     *     *        *            *          CALENDAR*/
  public static final QName version = new QName(namespace, "version");

}
