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

/** Bedework server specific tags.
 *
 * @author douglm
 *
 */
public class BedeworkServerTags {
  /** */
  public static final String bedeworkSystemNamespace = "http://bedework.org/ns/";

  /** */
  public static final String bedeworkCaldavNamespace = "http://bedeworkcalserver.org/ns/";

  /** */
  public static final String bedeworkCarddavNamespace = "http://bedeworkcardserver.org/ns/";

  /**   */
  public static final QName adminContact = new QName(bedeworkCaldavNamespace,
                                                     "admin-contact");

  /**   */
  public static final QName dataFrom = new QName(bedeworkCaldavNamespace,
                                                         "dataFrom");

  /**   */
  public static final QName dataTo = new QName(bedeworkCaldavNamespace,
                                                         "dataTo");

  /**   */
  public static final QName defaultFBPeriod = new QName(bedeworkCaldavNamespace,
                                                         "defaultFBPeriod");

  /**   */
  public static final QName defaultWebCalPeriod = new QName(bedeworkCaldavNamespace,
                                                         "defaultWebCalPeriod");

  /**   */
  public static final QName defaultPageSize = new QName(bedeworkCaldavNamespace,
                                                        "defaultPageSize");

  /** boolean value */
  public static final QName externalUser = new QName(bedeworkCaldavNamespace,
                                                        "externalUser");

  /**   */
  public static final QName isTopicalArea = new QName(bedeworkCaldavNamespace,
                                                "isTopicalArea");

  /**   */
  public static final QName maxAttendees = new QName(bedeworkCaldavNamespace,
                                                     "maxAttendees");

  /**   */
  public static final QName maxFBPeriod = new QName(bedeworkCaldavNamespace,
                                                         "maxFBPeriod");

  /**   */
  public static final QName maxWebCalPeriod = new QName(bedeworkCaldavNamespace,
                                                         "maxWebCalPeriod");

  /**   */
  public static final QName synchAdminCreateEpropsProperty =
          new QName(bedeworkCaldavNamespace,
                    "org.bedework.synchAdminCreateEprops");

  /**   */
  public static final QName synchXcategories =
          new QName(bedeworkCaldavNamespace,
                    "org.bedework.synchXcategories");

  /**   */
  public static final QName synchXlocXcontacts =
          new QName(bedeworkCaldavNamespace,
                    "org.bedework.synchXlocXcontacts");

  /* used for property index */

  /**   */
  public static final QName creator = new QName(bedeworkCaldavNamespace,
                                                     "creator");

  /**   */
  public static final QName owner = new QName(bedeworkCaldavNamespace,
                                                     "owner");

  /**   */
  public static final QName published = new QName(bedeworkCaldavNamespace,
                                                  "published");

  /**   */
  public static final QName endType = new QName(bedeworkCaldavNamespace,
                                                     "end-type");

  /**   */
  public static final QName cost = new QName(bedeworkCaldavNamespace,
                                                     "cost");

  /**   */
  public static final QName ctag = new QName(bedeworkCaldavNamespace,
                                                     "ctag");

  /**   */
  public static final QName deleted = new QName(bedeworkCaldavNamespace,
                                                     "deleted");

  /**   */
  public static final QName etag = new QName(bedeworkCaldavNamespace,
                                                     "etag");

  /**   */
  public static final QName collection = new QName(bedeworkCaldavNamespace,
                                                     "collection");

  /**   */
  public static final QName entityType = new QName(bedeworkCaldavNamespace,
                                                     "entity-type");

  /**   */
  public static final QName language = new QName(bedeworkCaldavNamespace,
                                                     "language");

  /**   */
  public static final QName name = new QName(bedeworkCaldavNamespace,
                                                     "name");

  /** Apple notification extension  */
  public static final QName processor = new QName(bedeworkSystemNamespace,
                                             "processor");

  /** Apple notification extension  */
  public static final QName processors = new QName(bedeworkSystemNamespace,
                                                  "processors");

  /** Apple notification extension  */
  public static final QName type = new QName(bedeworkSystemNamespace,
                                                  "type");

  /** Apple notification extension for public events */
  public static final QName suggest = new QName(bedeworkSystemNamespace,
                                                  "suggest");

  /** Apple notification extension for public events */
  public static final QName suggesterHref = new QName(bedeworkSystemNamespace,
                                                "suggesterHref");

  /** Apple notification extension for public events */
  public static final QName suggesteeHref = new QName(bedeworkSystemNamespace,
                                                      "suggesteeHref");

  /** Apple notification extension for public events */
  public static final QName comment = new QName(bedeworkSystemNamespace,
                                                      "comment");

  /** Apple notification extension for public events */
  public static final QName accepted = new QName(bedeworkSystemNamespace,
                                                "accepted");

  /** Apple notification extension for public events */
  public static final QName suggestReply = new QName(bedeworkSystemNamespace,
                                                "suggestReply");

  /**   */
  public static final QName xprop = new QName(bedeworkCaldavNamespace,
                                                     "xprop");

  /**   */
  public static final QName emailProp = new QName(bedeworkCarddavNamespace,
                                             "email");

  /**   */
  public static final QName aliasUri = new QName(bedeworkCaldavNamespace,
                                                "aliasUri");

  /**   */
  public static final QName remoteId = new QName(bedeworkCaldavNamespace,
                                                "remoteId");

 /**   */
  public static final QName remotePw = new QName(bedeworkCaldavNamespace,
                                                "remotePw");

  /* =============================================================
            Notifications
   */

  /** Values provided by notification system to templates.
   * DO NOT use this in any generated XML
   */
  public static final QName notifyValues =
          new QName(bedeworkSystemNamespace,
                    "notifyValues");

  /* =============================================================
            Event administration
   */

  /** event in pending queue */
  public static final QName awaitingApproval =
          new QName(bedeworkSystemNamespace,
                    "awaitingApproval");

  /** administrator accept/reject */
  public static final QName approvalResponse =
          new QName(bedeworkSystemNamespace,
                    "approvalResponse");

  /** calendar suite group principal URL */
  public static final QName calsuiteURL =
          new QName(bedeworkSystemNamespace,
                    "calsuiteURL");

  /* =============================================================
            Notification subscriptions
   */

  /** subscribe for notifications */
  public static final QName notifySubscribe =
          new QName(bedeworkSystemNamespace,
                    "notifySubscribe");

  /** action */
  public static final QName action =
          new QName(bedeworkSystemNamespace,
                    "action");

  /** email */
  public static final QName email =
          new QName(bedeworkSystemNamespace,
                    "email");

  /* =============================================================
            Event registration
   */

  /** cancelled */
  public static final QName eventregCancelled =
          new QName(bedeworkSystemNamespace,
                    "eventregCancelled");

  /** registered */
  public static final QName eventregRegistered =
          new QName(bedeworkSystemNamespace,
                    "eventregRegistered");

  /** Number tickets assigned */
  public static final QName eventregNumTickets =
          new QName(bedeworkSystemNamespace,
                    "eventregNumTickets");

  /** Number tickets requested */
  public static final QName eventregNumTicketsRequested =
          new QName(bedeworkSystemNamespace,
                    "eventregNumTicketsRequested");
}
