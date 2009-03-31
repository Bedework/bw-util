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

/** Possibly temporary home for definitions that need to be global.
 *
 * @author douglm
 *
 */
public class IcalDefs {
  /** */
  public enum IcalComponentType {
    /** */
    none,

    /** */
    event,

    /** */
    todo,

    /** */
    journal,

    /** */
    freebusy,

    /** */
    vavailability,

    /** */
    mixed}

  /* ----------------------------------------------------------------------
   *        status we can set fro scheduling requests
   * ---------------------------------------------------------------------- */

  /** Deferred till later e.g. needs mailing */
  public static final String requestStatusDeferred = "1.0;Deferred";

  /**  */
  public static final String requestStatusOK = "2.0;Success";

  /** Append property name */
  public static final String requestStatusInvalidProperty =
           "3.0;Invalid Property Name:";

  /**  */
  public static final String requestStatusUnsupportedCapability =
           "3.14;Unsupported capability";

  /** */
  public static final String requestStatusNoAccess =
           "4.2;No Access";
}
