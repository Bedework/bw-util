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

/** Define Caldav tags for XMlEmit.
 *
 * @author Mike Douglass   douglm rpi.edu
 */
public class CaldavTags implements CaldavDefs {
  /**   */
  public static final QName allcomp = new QName(caldavNamespace,
                                                "allcomp");

  /**   */
  public static final QName allprop = new QName(caldavNamespace,
                                                "allprop");

  /**   */
  public static final QName attendeeAllowed = new QName(caldavNamespace,
                                "allowed-attendee-scheduling-object-change");

  /** Specifies the resource type of a calendar collection.  */
  public static final QName calendar = new QName(caldavNamespace,
                                                 "calendar");

  /**   */
  public static final QName calendarCollectionLocationOk = new QName(caldavNamespace,
                                                     "calendar-collection-location-ok");

  /**   */
  public static final QName calendarData = new QName(caldavNamespace,
                                                     "calendar-data");

  /** Provides a human-readable description of the calendar collection.
   * NOT ALLPROP
   */
  public static final QName calendarDescription = new QName(caldavNamespace,
                                                            "calendar-description");

  /**   */
  public static final QName calendarFreeBusySet = new QName(caldavNamespace,
                                                            "calendar-free-busy-set");

  /**   */
  public static final QName calendarHomeSet = new QName(caldavNamespace,
                                                        "calendar-home-set");
  /**   */
  public static final QName calendarMultiget = new QName(caldavNamespace,
                                                         "calendar-multiget");

  /**   */
  public static final QName calendarOrder = new QName(caldavNamespace,
                                                      "calendar-order");

  /**   */
  public static final QName calendarQuery = new QName(caldavNamespace,
                                                      "calendar-query");

  /**   */
  public static final QName calendarTimezone = new QName(caldavNamespace,
                                                         "calendar-timezone");

  /**   */
  public static final QName calendarUserAddressSet = new QName(caldavNamespace,
                                                               "calendar-user-address-set");

  /**   */
  public static final QName comp = new QName(caldavNamespace,
                                             "comp");

  /**   */
  public static final QName compFilter = new QName(caldavNamespace,
                                                   "comp-filter");

  /**   */
  public static final QName defaultAlarmVeventDate = new QName(caldavNamespace,
      "default-alarm-vevent-date");

  /**   */
  public static final QName defaultAlarmVeventDatetime = new QName(caldavNamespace,
      "default-alarm-vevent-datetime");

  /**   */
  public static final QName defaultAlarmVtodoDate = new QName(caldavNamespace,
      "default-alarm-vtodo-date");

  /**   */
  public static final QName defaultAlarmVtodoDatetime = new QName(caldavNamespace,
      "default-alarm-vtodo-datetime");

  /**   */
  public static final QName expand = new QName(caldavNamespace,
                                               "expand");

  /**   */
  public static final QName filter = new QName(caldavNamespace,
                                               "filter");

  /**   */
  public static final QName freeBusyQuery = new QName(caldavNamespace,
                                                      "free-busy-query");

  /**   */
  public static final QName isNotDefined = new QName(caldavNamespace,
                                                     "is-not-defined");

  /**   */
  public static final QName limitFreebusySet = new QName(caldavNamespace,
                                                         "limit-freebusy-set");

  /**   */
  public static final QName limitRecurrenceSet = new QName(caldavNamespace,
                                                           "limit-recurrence-set");

  /**   */
  public static final QName mkcalendar = new QName(caldavNamespace,
                                                   "mkcalendar");

  /**   */
  public static final QName maxAttendeesPerInstance = new QName(caldavNamespace,
                                                    "max-attendees-per-instance");

  /**   */
  public static final QName maxDateTime = new QName(caldavNamespace,
                                                    "max-date-time");

  /**   */
  public static final QName maxInstances = new QName(caldavNamespace,
                                                     "max-instances");

  /**   */
  public static final QName maxResourceSize = new QName(caldavNamespace,
                                                        "max-resource-size");

  /**   */
  public static final QName minDateTime = new QName(caldavNamespace,
                                                    "min-date-time");

  /**   */
  public static final QName notProcessed = new QName(caldavNamespace,
                                                     "not-processed");

  /**   */
  public static final QName noUidConflict = new QName(caldavNamespace,
                                                     "no-uid-conflict");

  /**   */
  public static final QName opaque = new QName(caldavNamespace,
                                               "opaque");

  /**   */
  public static final QName organizerAllowed = new QName(caldavNamespace,
                           "allowed-organizer-scheduling-object-change");

  /**   */
  public static final QName originator = new QName(caldavNamespace,
                                                   "originator");

  /**   */
  public static final QName originatorAllowed = new QName(caldavNamespace,
                                                   "originator-allowed");

  /**   */
  public static final QName paramFilter = new QName(caldavNamespace,
                                                    "param-filter");

  /**   */
  public static final QName processed = new QName(caldavNamespace,
                                                  "processed");

  /**   */
  public static final QName prop = new QName(caldavNamespace,
                                             "prop");

  /**   */
  public static final QName propFilter = new QName(caldavNamespace,
                                                   "prop-filter");

  /**   */
  public static final QName readFreeBusy = new QName(caldavNamespace,
                                                     "read-free-busy");

  /**   */
  public static final QName recipient = new QName(caldavNamespace,
                                                  "recipient");

  /**   */
  public static final QName recipientPermissions = new QName(caldavNamespace,
                                                  "recipient-permissions");

  /**   */
  public static final QName requestStatus = new QName(caldavNamespace,
                                                      "request-status");

  /**   */
  public static final QName response = new QName(caldavNamespace,
                                                 "response");

  /**   */
  public static final QName returnContentType = new QName(caldavNamespace,
                                                          "return-content-type");

  /**   */
  public static final QName schedule = new QName(caldavNamespace,
                                                 "schedule");

  /**   */
  public static final QName scheduleCalendarTransp = new QName(caldavNamespace,
                                                      "schedule-calendar-transp");

  /**   */
  public static final QName scheduleDefaultCalendarURL = new QName(caldavNamespace,
                                             "schedule-default-calendar-URL");

  /**   */
  public static final QName scheduleDeliver = new QName(caldavNamespace,
                                                        "schedule-deliver");

  /**   */
  public static final QName scheduleDeliverInvite = new QName(caldavNamespace,
                                                     "schedule-deliver-invite");

  /**   */
  public static final QName scheduleDeliverReply = new QName(caldavNamespace,
                                                      "schedule-deliver-reply");

  /**   */
  public static final QName scheduleFreeBusy = new QName(caldavNamespace,
                                                         "schedule-free-busy");

  /**   */
  public static final QName scheduleInbox = new QName(caldavNamespace,
                                                      "schedule-inbox");

  /**   */
  public static final QName scheduleInboxURL = new QName(caldavNamespace,
                                                         "schedule-inbox-URL");

  /**   */
  public static final QName scheduleOutbox = new QName(caldavNamespace,
                                                       "schedule-outbox");

  /**   */
  public static final QName scheduleOutboxURL = new QName(caldavNamespace,
                                                          "schedule-outbox-URL");

  /**   */
  public static final QName scheduleQueryFreebusy = new QName(caldavNamespace,
                                                     "schedule-query-freebusy");

  /**   */
  public static final QName scheduleReply = new QName(caldavNamespace,
                                                      "schedule-reply");

  /**   */
  public static final QName scheduleRequest = new QName(caldavNamespace,
                                                        "schedule-request");

  /**   */
  public static final QName scheduleResponse = new QName(caldavNamespace,
                                                         "schedule-response");

  /**   */
  public static final QName scheduleSend = new QName(caldavNamespace,
                                                     "schedule-send");

  /**   */
  public static final QName scheduleSendFreebusy = new QName(caldavNamespace,
                                                             "schedule-send-freebusy");

                                                                                                                          /**   */
  public static final QName scheduleSendInvite = new QName(caldavNamespace,
                                                           "schedule-send-invite");

                                                                                                                                                                                        /**   */
  public static final QName scheduleSendReply = new QName(caldavNamespace,
                                                          "schedule-send-reply");

  /**   */
  public static final QName scheduleTag = new QName(caldavNamespace,
                                                    "schedule-tag");

  /* * removed  * /
  public static final QName scheduleState = new QName(caldavNamespace,
                                                      "schedule-state");
                                                      */

  /**   */
  public static final QName supportedCalendarComponentSet = new QName(caldavNamespace,
                                            "supported-calendar-component-set");

  /**   */
  public static final QName supportedCalendarData = new QName(caldavNamespace,
                                                      "supported-calendar-data");

  /**   */
  public static final QName supportedFilter = new QName(caldavNamespace,
                                                        "supported-filter");

  /**   */
  public static final QName textMatch = new QName(caldavNamespace,
                                                  "text-match");

  /**   */
  public static final QName timeRange = new QName(caldavNamespace,
                                                  "time-range");

  /**   */
  public static final QName timezone = new QName(caldavNamespace, "timezone");

  /**   */
  public static final QName timezoneServiceSet =
          new QName(caldavNamespace, "timezone-service-set");

  /**   */
  public static final QName transparent = new QName(caldavNamespace,
                                                    "transparent");

  /**   */
  public static final QName validCalendarData = new QName(caldavNamespace,
                                                          "valid-calendar-data");

  /**   */
  public static final QName validCalendarObjectResource = new QName(caldavNamespace,
                                                "valid-calendar-object-resource");

  /**   */
  public static final QName validFilter = new QName(caldavNamespace,
                                                    "valid-filter");

  /**   */
  public static final QName vpollMaxActive = new QName(caldavNamespace,
                                            "vpoll-max-active");

  /**   */
  public static final QName vpollMaxItems = new QName(caldavNamespace,
                                            "vpoll-max-items");

  /**   */
  public static final QName vpollMaxVoters = new QName(caldavNamespace,
                                            "vpoll-max-voters");

  /**   */
  public static final QName vpollSupportedComponentSet = new QName(caldavNamespace,
                                            "vpoll-supported-component-set");

  /* ---------------- isched - delete thede ------------------------------- */

  /** isched  */
  public static final QName originatorSpecified = new QName(caldavNamespace,
                                                   "originator-specified");

  /**   */
  public static final QName recipientSpecified = new QName(caldavNamespace,
                                                  "recipient-specified");
}

