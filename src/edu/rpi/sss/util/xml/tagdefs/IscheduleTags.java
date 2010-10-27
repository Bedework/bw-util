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
  public static final String namespace = "urn:ietf:params:xml:ns:ischedule";

  /**   */
  public static final QName administrator = new QName(namespace,
                                                      "administrator");

  /**   */
  public static final QName calendarData = new QName(namespace,
                                                     "calendar-data");

  /**   */
  public static final QName capabilitySet = new QName(namespace,
                                                      "capability-set");

  /**   */
  public static final QName comp = new QName(namespace,
                                             "comp");

  /**   */
  public static final QName externalAttachment = new QName(namespace,
                                                        "external-attachment");

  /**   */
  public static final QName inlineAttachment = new QName(namespace,
                                                         "inline-attachment");

  /**   */
  public static final QName maxContentLength = new QName(namespace,
                                                         "max-content-length");

  /**   */
  public static final QName maxDateTime = new QName(namespace,
                                                    "max-date-time");

  /**   */
  public static final QName maxInstances = new QName(namespace,
                                                     "max-instances");

  /**   */
  public static final QName maxRecipients = new QName(namespace,
                                                     "max-recipients");

  /**   */
  public static final QName method = new QName(namespace,
                                               "method");

  /**   */
  public static final QName minDateTime = new QName(namespace,
                                                    "min-date-time");

  /**   */
  public static final QName originatorSpecified = new QName(namespace,
                                                   "originator-specified");

  /**   */
  public static final QName queryResult = new QName(namespace,
                                                    "query-result");

  /**   */
  public static final QName recipient = new QName(namespace,
                                                  "recipient");

  /**   */
  public static final QName recipientPermissions = new QName(namespace,
                                                  "recipient-permissions");

  /**   */
  public static final QName recipientSpecified = new QName(namespace,
                                                  "recipient-specified");

  /**   */
  public static final QName requestStatus = new QName(namespace,
                                                      "request-status");

  /**   */
  public static final QName response = new QName(namespace,
                                                 "response");

  /**   */
  public static final QName scheduleResponse = new QName(namespace,
                                                         "schedule-response");

  /**   */
  public static final QName scheme = new QName(namespace,
                                               "scheme");

  /**   */
  public static final QName supportedAttachmentValues = new QName(namespace,
                                                      "supported-attachment-values");

  /**   */
  public static final QName supportedCalendarDataType = new QName(namespace,
                                                      "supported-calendar-data-type");

  /**   */
  public static final QName supportedRecipientUriSchemeSet = new QName(namespace,
                                       "supported-recipient-uri-scheme-set");

  /**   */
  public static final QName supportedSchedulingMessageSet = new QName(namespace,
                                              "supported-scheduling-message-set");

  /**   */
  public static final QName supportedVersionSet = new QName(namespace,
                                                      "supported-version-set");

  /**   */
  public static final QName validCalendarData = new QName(namespace,
                                                          "valid-calendar-data");

  /**   */
  public static final QName version = new QName(namespace, "version");

}

