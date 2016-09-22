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


/** Define CalWS-REST xrd link reltypes and property types for XMlEmit.
 *
 * @see "http://docs.oasis-open.org/xri/xrd/v1.0/xrd-1.0.html"
 *
 * @author Mike Douglass   douglm - rpi.edu
 */
public class CalWSXrdDefs {
  /** */
  public static final String namespace = "http://docs.oasis-open.org/ws-calendar/ns/rest";

  /* ====================================================================
   *                   Property types
   * ==================================================================== */

  /** property */
  public static final String supportedFeatures = namespace + "/" +
                                                 "supported-features";

  //public static final String supportedFeatures = namespace + "/" +
  //                                               "calendarFreeBusySet";

  /** property */
  public static final String maxAttendeesPerInstance = namespace + "/" +
                                                 "max-attendees-per-instance";

  /** property */
  public static final String maxDateTime = namespace + "/" +
                                                 "max-date-time";

  /** property */
  public static final String maxInstances = namespace + "/" +
                                                 "max-instances";

  /** property */
  public static final String maxResourceSize = namespace + "/" +
                                                 "max-resource-size";

  /** property */
  public static final String minDateTime = namespace + "/" +
                                                 "min-date-time";

  /* ====================================================================
   *                   Link relations
   * ==================================================================== */

  /** Link */
  public static final String childCollection = namespace + "/" + "child-collection";

  /** Link */
  public static final String currentPrincipalFreebusy = namespace + "/" +
                                                        "current-principal-freebusy";

  /** Link */
  public static final String principalFreebusy = namespace + "/" + "principal-freebusy";

  /** Link */
  public static final String principalHome = namespace + "/" + "principal-home";

  /** Link */
  public static final String timezoneService = namespace + "/" + "timezone-service";

  /* ====================================================================
   *                   Link Properties
   * ==================================================================== */

  /** Link property */
  public static final String calendarCollection = namespace + "/" + "calendar-collection";

  /** Link property */
  public static final String collection = namespace + "/" + "collection";

  /** Link property */
  public static final String created = namespace + "/" + "created";

  /** Link property */
  public static final String description = namespace + "/" + "description";

  /** Link property */
  public static final String displayname = namespace + "/" + "displayname";

  /** Link property */
  public static final String inbox = namespace + "/" + "inbox";

  /** Link property */
  public static final String lastModified = namespace + "/" + "last-modified";

  /** Link property */
  public static final String outbox = namespace + "/" + "outbox";

  /** Link property */
  public static final String owner = namespace + "/" + "owner";

  /** Link property */
  public static final String timezone = namespace + "/" + "timezone";

  /** Link property */
  public static final String supportedCalendarComponentSet =
    namespace + "/" + "supported-calendar-component-set";
}
