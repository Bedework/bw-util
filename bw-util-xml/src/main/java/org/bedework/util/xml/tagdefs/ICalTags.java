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
package org.bedework.util.xml.tagdefs;

import javax.xml.namespace.QName;

/** Define ICal tags for XMlEmit.
 *
 * @author Mike Douglass   douglm@bedework.edu
 */
public class ICalTags {
  /** */
  public static final String namespace = CaldavDefs.icalNamespace;

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

