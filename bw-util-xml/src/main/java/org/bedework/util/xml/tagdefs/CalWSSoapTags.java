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

/** Define CalWS tags for XMlEmit.
 *
 * @see "http://docs.oasis-open.org/xri/xrd/v1.0/xrd-1.0.html"
 *
 * @author Mike Douglass   douglm - rpi.edu
 */
public class CalWSSoapTags {
  /** */
  public static final String namespace = "http://docs.oasis-open.org/ns/wscal/calws-soap";

  /**   */
  public static final QName childCollection = new QName(namespace,
                                                        "childCollection");

  /**   */
  public static final QName creationDateTime = new QName(namespace,
                                                         "creationDateTime");

  /**   */
  public static final QName displayName = new QName(namespace,
                                                         "displayName");

  /**   */
  public static final QName lastModifiedDateTime = new QName(namespace,
                                                         "lastModifiedDateTime");

  /**   */
  public static final QName maxAttendeesPerInstance = new QName(namespace,
                                                         "maxAttendeesPerInstance");

  /**   */
  public static final QName maxDateTime = new QName(namespace,
                                                         "maxDateTime");

  /**   */
  public static final QName maxInstances = new QName(namespace,
                                                         "maxInstances");

  /**   */
  public static final QName maxResourceSize = new QName(namespace,
                                                         "maxResourceSize");

  /**   */
  public static final QName minDateTime = new QName(namespace,
                                                    "minDateTime");

  /**   */
  public static final QName principalHome = new QName(namespace,
                                                      "principalHome");

  /**   */
  public static final QName resourceDescription = new QName(namespace,
                                                            "resourceDescription");

  /**   */
  public static final QName resourceOwner = new QName(namespace,
                                                      "resourceOwner");

  /**   */
  public static final QName resourceType = new QName(namespace,
                                                         "resourceType");

  /**   */
  public static final QName resourceTimezoneId = new QName(namespace,
                                                           "resourceTimezoneId");

  /**   */
  public static final QName supportedCalendarComponentSet = new QName(namespace,
                                                         "supportedCalendarComponentSet");

  /**   */
  public static final QName supportedFeatures = new QName(namespace,
                                                         "supportedFeatures");

  /**   */
  public static final QName timezoneServer = new QName(namespace,
                                                       "timezoneServer");

  /* ========================================================================
   *                       Error tags
   * ======================================================================== */

  /**   */
  public static final QName unsupportedCalendarComponent = new QName(namespace,
                                                                     "unsupportedCalendarComponent");

  /* ========================================================================
   *                       Incorrect Error tags - fix these or remove
   * ======================================================================== */

  /**   */
  public static final QName beforeMinDateTime = new QName(namespace, "before-min-date-time");

  /**   */
  public static final QName error = new QName(namespace, "error");

  /**   */
  public static final QName exceedsMaxResourceSize = new QName(namespace, "exceeds-max-resource-size");

  /**   */
  public static final QName invalidCalendarCollectionLocation = new QName(namespace, "invalid-calendar-collection-location");

  /**   */
  public static final QName invalidCalendarData = new QName(namespace, "invalid-calendar-data");

  /**   */
  public static final QName invalidCalendarObjectResource = new QName(namespace, "invalid-calendar-object-resource");

  /**   */
  public static final QName notCalendarData = new QName(namespace, "not-calendar-data");

  /**   */
  public static final QName targetExists = new QName(namespace, "target-exists");

  /**   */
  public static final QName tooManyAttendeesPerInstance = new QName(namespace, "too-many-attendees-per-instance");

  /**   */
  public static final QName tooManyInstances = new QName(namespace, "too-many-instances");

  /**   */
  public static final QName uidConflict = new QName(namespace, "uid-conflict");

  /* ========================================================================
   *                       Other tags
   * ======================================================================== */

  /**   */
  public static final QName description = new QName(namespace, "description");

  /**   */
  public static final QName href = new QName(namespace, "href");
}
