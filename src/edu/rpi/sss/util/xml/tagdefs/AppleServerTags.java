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
