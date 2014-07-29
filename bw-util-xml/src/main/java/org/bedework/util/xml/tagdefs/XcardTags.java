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

/** Define tags for icalendar in XML.
 *
 * @author Mike Douglass   douglm - rpi.edu
 */
public class XcardTags {
  /** */
  public static final String namespace = "urn:ietf:params:xml:ns:vcard-4.0";

  /** */
  public static final String mimetype = "application/vcard+xml";

  /* =====================================================================
                              value types
     ===================================================================== */

  /**   */
  public static final QName binaryVal = new QName(namespace, "binary");

  /**   */
  public static final QName booleanVal = new QName(namespace, "boolean");

  /**   */
  public static final QName calAddressVal = new QName(namespace, "cal-address");

  /**   */
  public static final QName dateVal = new QName(namespace, "date");

  /**   */
  public static final QName dateAndOrTimeTimeVal = new QName(namespace, "date-and-or-time");

  /**   */
  public static final QName dateTimeVal = new QName(namespace, "date-time");

  /**   */
  public static final QName durationVal = new QName(namespace, "duration");

  /**   */
  public static final QName floatVal = new QName(namespace, "float");

  /**   */
  public static final QName integerVal = new QName(namespace, "integer");

  /**   */
  public static final QName periodVal = new QName(namespace, "period");

  /**   */
  public static final QName textVal = new QName(namespace, "text");

  /**   */
  public static final QName timeVal = new QName(namespace, "time");

  /**   */
  public static final QName uriVal = new QName(namespace, "uri");

  /** */
  public static final QName utcDateTimeVal = new QName(namespace, "utc-date-time");

  /**   */
  public static final QName utcOffsetVal = new QName(namespace, "utc-offset");

  /* =====================================================================
                              parameters
     ===================================================================== */

  /**   */
  public static final QName altid = new QName(namespace, "altid");

  /**   */
  public static final QName calscale = new QName(namespace, "calscale");

  /**   */
  public static final QName geoPar = new QName(namespace, "geo");

  /**   */
  public static final QName language = new QName(namespace, "language");

  /**   */
  public static final QName mediatype = new QName(namespace, "mediatype");

  /**   */
  public static final QName pid = new QName(namespace, "pid");

  /**   */
  public static final QName pref = new QName(namespace, "pref");

  /**   */
  public static final QName sortAs = new QName(namespace, "sort-as");

  /**   */
  public static final QName type = new QName(namespace, "type");

  /**   */
  public static final QName tzPar = new QName(namespace, "tz");

  /**   */
  public static final QName value = new QName(namespace, "value");

  /* =====================================================================
                              Structural
     ===================================================================== */

  /**   */
  public static final QName vcards = new QName(namespace, "vcards");

  /**   */
  public static final QName vcard = new QName(namespace, "vcard");

  /**   */
  public static final QName parameters = new QName(namespace, "parameters");

  /* =====================================================================
                             General
     ===================================================================== */

  /** */
  public static final QName source = new QName(namespace, "source");

  /** */
  public static final QName kind = new QName(namespace, "kind");

  /* =====================================================================
                             Identification
     ===================================================================== */

  /** */
  public static final QName fn = new QName(namespace, "fn");

  /** */
  public static final QName n = new QName(namespace, "n");

  /** */
  public static final QName nickname = new QName(namespace, "nickname");

  /** */
  public static final QName photo = new QName(namespace, "photo");

  /** */
  public static final QName bday = new QName(namespace, "bday");

  /** */
  public static final QName anniversary = new QName(namespace, "anniversary");

  /** */
  public static final QName gender = new QName(namespace, "gender");

  /* =====================================================================
                             Delivery Addressing
     ===================================================================== */

  /** */
  public static final QName adr = new QName(namespace, "adr");

  /* =====================================================================
                             Communications
     ===================================================================== */

  /** */
  public static final QName tel = new QName(namespace, "tel");

  /** */
  public static final QName email = new QName(namespace, "email");

  /** */
  public static final QName impp = new QName(namespace, "impp");

  /** */
  public static final QName lang = new QName(namespace, "lang");

  /* =====================================================================
                    Geographical
     ===================================================================== */

  /** */
  public static final QName tz = new QName(namespace, "tz");

  /** */
  public static final QName geo = new QName(namespace, "geo");

  /* =====================================================================
                              Organizational
     ===================================================================== */

  /** */
  public static final QName title = new QName(namespace, "title");

  /**   */
  public static final QName role = new QName(namespace, "role");

  /**   */
  public static final QName logo = new QName(namespace, "logo");

  /**   */
  public static final QName org = new QName(namespace, "org");

  /**   */
  public static final QName member = new QName(namespace, "member");

  /**   */
  public static final QName related = new QName(namespace, "related");

  /* =====================================================================
                              Explanatory
     ===================================================================== */

  /**  */
  public static final QName categories = new QName(namespace, "categories");

  /**  */
  public static final QName note = new QName(namespace, "note");

  /**  */
  public static final QName prodid = new QName(namespace, "prodid");

  /**  */
  public static final QName rev = new QName(namespace, "rev");

  /**  */
  public static final QName sound = new QName(namespace, "sound");

  /**  */
  public static final QName uid = new QName(namespace, "uid");

  /**  */
  public static final QName clientpidmap = new QName(namespace, "clientpidmap");

  /**  */
  public static final QName url = new QName(namespace, "url");

  /**  */
  public static final QName version= new QName(namespace, "version");

  /* =====================================================================
                              Security
     ===================================================================== */

  /**  */
  public static final QName key = new QName(namespace, "key");

  /* =====================================================================
                              Calendar
     ===================================================================== */

  /**  */
  public static final QName fburl = new QName(namespace, "fburl");

  /**  */
  public static final QName caladrurl = new QName(namespace, "caladrurl");

  /**  */
  public static final QName calurl = new QName(namespace, "calurl");

  /* =====================================================================
                        x-properties in the schema
     ===================================================================== */

  /**   */
  public static final QName xBedeworkPrincipalHref =
          new QName(namespace, "x-bw-principalhref");
}
