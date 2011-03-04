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
package edu.rpi.sss.util.xml.tagdefs;

import javax.xml.namespace.QName;

/** Define CalWS tags for XMlEmit.
 *
 * @see "http://docs.oasis-open.org/xri/xrd/v1.0/xrd-1.0.html"
 *
 * @author Mike Douglass   douglm - rpi.edu
 */
public class CalWSTags {
  /** */
  public static final String namespace = "http://docs.oasis-open.org/ns/wscal/calws";

  /**   */
  public static final QName afterMaxDateTime = new QName(namespace, "after-max-date-time");

  /**   */
  public static final QName beforeMinDateTime = new QName(namespace, "before-min-date-time");

  /**   */
  public static final QName description = new QName(namespace, "description");

  /**   */
  public static final QName error = new QName(namespace, "error");

  /**   */
  public static final QName exceedsMaxResourceSize = new QName(namespace, "exceeds-max-resource-size");

  /**   */
  public static final QName href = new QName(namespace, "href");

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

  /**   */
  public static final QName unsupportedCalendarComponent = new QName(namespace, "unsupported-calendar-component");
}
