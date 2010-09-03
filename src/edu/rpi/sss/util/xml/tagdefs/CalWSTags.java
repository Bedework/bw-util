/* **********************************************************************
    Copyright 2010 Rensselaer Polytechnic Institute. All worldwide rights reserved.

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
