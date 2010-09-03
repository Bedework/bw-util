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


/** Define CalWS xrd link reltypes and property types for XMlEmit.
 *
 * @see "http://docs.oasis-open.org/xri/xrd/v1.0/xrd-1.0.html"
 *
 * @author Mike Douglass   douglm - rpi.edu
 */
public class CalWSXrdDefs {
  /** */
  public static final String namespace = "http://docs.oasis-open.org/ns/wscal/calws";

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
}
