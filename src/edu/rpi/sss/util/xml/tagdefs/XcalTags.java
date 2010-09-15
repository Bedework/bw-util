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
                              values
     ===================================================================== */

  /**   */
  public static final QName binary = new QName(namespace, "binary");

  /**   */
  public static final QName _boolean = new QName(namespace, "boolean");

  /**   */
  public static final QName calAddress = new QName(namespace, "cal-address");

  /**   */
  public static final QName date = new QName(namespace, "date");

  /**   */
  public static final QName dateTime = new QName(namespace, "date-time");

  /**   */
  public static final QName duration = new QName(namespace, "duration");

  /**   */
  public static final QName _float = new QName(namespace, "float");

  /**   */
  public static final QName integer = new QName(namespace, "integer");

  /**   */
  public static final QName period = new QName(namespace, "period");

  /**   */
  public static final QName recur = new QName(namespace, "recur");

  /**   */
  public static final QName text = new QName(namespace, "text");

  /**   */
  public static final QName time = new QName(namespace, "time");

  /**   */
  public static final QName uri = new QName(namespace, "uri");

  /**   */
  public static final QName utcOffset = new QName(namespace, "utc-offset");

  /* =====================================================================
                              recur
     ===================================================================== */

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
                              Structural
     ===================================================================== */

  /**   */
  public static final QName components = new QName(namespace, "components");

  /**   */
  public static final QName icalendar = new QName(namespace, "icalendar");

  /**   */
  public static final QName parameters = new QName(namespace, "parameters");

  /**   */
  public static final QName properties = new QName(namespace, "properties");

  /**   */
  public static final QName vcalendar = new QName(namespace, "vcalendar");

  /* =====================================================================
                              properties
     ===================================================================== */

  /**   */
  public static final QName prodid = new QName(namespace, "prodid");

  /**   */
  public static final QName version = new QName(namespace, "version");
}
