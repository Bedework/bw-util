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

