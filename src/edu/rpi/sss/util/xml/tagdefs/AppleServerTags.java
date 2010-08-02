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

/** Apple specific tags.
 *
 * @author douglm
 *
 */
public class AppleServerTags {
  /** */
  public static final String appleCaldavNamespace = "http://calendarserver.org/ns/";

  /**   */
  public static final QName action = new QName(appleCaldavNamespace,
                                               "action");

  /**   */
  public static final QName attendee = new QName(appleCaldavNamespace,
                                                 "attendee");

  /**   */
  public static final QName cancel = new QName(appleCaldavNamespace,
                                               "cancel");

  /**   */
  public static final QName changedProperty = new QName(appleCaldavNamespace,
                                                        "changed-property");

  /**   */
  public static final QName changes = new QName(appleCaldavNamespace,
                                                "changes");

  /**   */
  public static final QName create = new QName(appleCaldavNamespace,
                                               "create");

  /**   */
  public static final QName dtstamp = new QName(appleCaldavNamespace,
                                                "dtstamp");

  /**   */
  public static final QName getctag = new QName(appleCaldavNamespace,
                                                "getctag");

  /**   */
  public static final QName master = new QName(appleCaldavNamespace,
                                               "master");

  /**   */
  public static final QName partstat = new QName(appleCaldavNamespace,
                                                 "partstat");

  /**   */
  public static final QName privateComment = new QName(appleCaldavNamespace,
                                                       "private-comment");

  /**   */
  public static final QName recurrence = new QName(appleCaldavNamespace,
                                                   "recurrence");

  /**   */
  public static final QName recurrenceid = new QName(appleCaldavNamespace,
                                                     "recurrenceid");

  /**   */
  public static final QName reply = new QName(appleCaldavNamespace,
                                              "reply");

  /**   */
  public static final QName scheduleChanges = new QName(appleCaldavNamespace,
                                                        "schedule-changes");

  /**   */
  public static final QName update = new QName(appleCaldavNamespace,
                                               "update");
}
