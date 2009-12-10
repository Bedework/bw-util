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

/** Define Caldav tags for XMlEmit.
 *
 * @author Mike Douglass   douglm@rpi.edu
 */
public class IscheduleTags implements CaldavDefs {
  /** */
  public static final String ischeduleNamespace = "urn:ietf:params:xml:ns:ischedule";

  /**   */
  public static final QName administrator = new QName(ischeduleNamespace,
                                                      "administrator");

  /**   */
  public static final QName calendarData = new QName(ischeduleNamespace,
                                                     "calendar-data");

  /**   */
  public static final QName capabilitySet = new QName(ischeduleNamespace,
                                                      "capability-set");

  /**   */
  public static final QName comp = new QName(ischeduleNamespace,
                                             "comp");

  /**   */
  public static final QName externalAttachment = new QName(ischeduleNamespace,
                                                        "external-attachment");

  /**   */
  public static final QName inlineAttachment = new QName(ischeduleNamespace,
                                                         "inline-attachment");

  /**   */
  public static final QName maxContentLength = new QName(ischeduleNamespace,
                                                         "max-content-length");

  /**   */
  public static final QName maxDateTime = new QName(ischeduleNamespace,
                                                    "max-date-time");

  /**   */
  public static final QName maxInstances = new QName(ischeduleNamespace,
                                                     "max-instances");

  /**   */
  public static final QName maxRecipients = new QName(ischeduleNamespace,
                                                     "max-recipients");

  /**   */
  public static final QName method = new QName(ischeduleNamespace,
                                               "method");

  /**   */
  public static final QName minDateTime = new QName(ischeduleNamespace,
                                                    "min-date-time");

  /**   */
  public static final QName queryResult = new QName(ischeduleNamespace,
                                                    "query-result");

  /**   */
  public static final QName scheme = new QName(ischeduleNamespace,
                                               "scheme");

  /**   */
  public static final QName supportedAttachmentValues = new QName(ischeduleNamespace,
                                                      "supported-attachment-values");

  /**   */
  public static final QName supportedCalendarData = new QName(ischeduleNamespace,
                                                      "supported-calendar-data");

  /**   */
  public static final QName supportedRecipientUriSchemeSet = new QName(ischeduleNamespace,
                                       "supported-recipient-uri-scheme-set");

  /**   */
  public static final QName supportedSchedulingMessageSet = new QName(ischeduleNamespace,
                                              "supported-scheduling-message-set");

  /**   */
  public static final QName supportedVersionSet = new QName(ischeduleNamespace,
                                                      "supported-version-set");

  /**   */
  public static final QName version = new QName(ischeduleNamespace, "version");

}

