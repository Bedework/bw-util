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

/** Define XRD tags for XMlEmit.
 *
 * @see "http://docs.oasis-open.org/xri/xrd/v1.0/xrd-1.0.html"
 *
 * @author Mike Douglass   douglm - rpi.edu
 */
public class XrdTags {
  /** */
  public static final String namespace = "http://docs.oasis-open.org/ns/xri/xrd-1.0";

  /**   */
  public static final QName alias = new QName(namespace, "Alias");

  /**   */
  public static final QName expires = new QName(namespace, "Expires");

  /**   */
  public static final QName link = new QName(namespace, "Link");

  /**   */
  public static final QName property = new QName(namespace, "Property");

  /**   */
  public static final QName subject = new QName(namespace, "Subject");

  /**   */
  public static final QName title = new QName(namespace, "Title");

  /**   */
  public static final QName xrd = new QName(namespace, "XRD");
}
