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

/** Bedework server specific tags.
 *
 * @author douglm
 *
 */
public class BedeworkServerTags {
  /** */
  public static final String bedeworkCaldavNamespace = "http://bedeworkcalserver.org/ns/";

  /**   */
  public static final QName isTopicalArea = new QName(bedeworkCaldavNamespace,
                                                "isTopicalArea");

  /**   */
  public static final QName systemIndexingOn = new QName(bedeworkCaldavNamespace,
                                                         "systemIndexingOn");

  /**   */
  public static final QName defaultFBPeriod = new QName(bedeworkCaldavNamespace,
                                                         "defaultFBPeriod");

  /**   */
  public static final QName maxFBPeriod = new QName(bedeworkCaldavNamespace,
                                                         "maxFBPeriod");

  /**   */
  public static final QName defaultWebCalPeriod = new QName(bedeworkCaldavNamespace,
                                                         "defaultWebCalPeriod");

  /**   */
  public static final QName maxWebCalPeriod = new QName(bedeworkCaldavNamespace,
                                                         "maxWebCalPeriod");

  /**   */
  public static final QName maxAttendees = new QName(bedeworkCaldavNamespace,
                                                     "maxAttendees");

  /**   */
  public static final QName adminContact = new QName(bedeworkCaldavNamespace,
                                                     "admin-contact");
}
