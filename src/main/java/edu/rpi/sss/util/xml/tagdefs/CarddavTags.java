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

import java.util.HashMap;

import javax.xml.namespace.QName;

/** Define Carddav tags for XMlEmit
 *
 * @author Mike Douglass douglm@rpi.edu
 */
public class CarddavTags {
  /** Namespace for these tags
   */
  public static final String namespace = "urn:ietf:params:xml:ns:carddav";

  /** Tables of QNames indexed by name
   */
  public final static HashMap<String, QName> qnames = new HashMap<String, QName>();

  /** */
  public static final QName addressbook = makeQName("addressbook");

  /** */
  public static final QName addressbookDescription = makeQName("addressbook-description");

  /** */
  public static final QName addressbookHomeSet = makeQName("addressbook-home-set");

  /** */
  public static final QName addressbookCollectionLocationOk =
              makeQName("addressbook-collection-location-ok");

  /**   */
  public static final QName addressbookMultiget = makeQName("addressbook-multiget");

  /** */
  public static final QName addressbookQuery = makeQName("addressbook-query");

  /** */
  public static final QName addressData = makeQName("address-data");

  /** */
  public static final QName addressDataType = makeQName("address-data-type");

  /** */
  public static final QName allprop = makeQName("allprop");

  /**   */
  public static final QName directory = makeQName("directory");

  /**   */
  public static final QName filter = makeQName("filter");

  /**   */
  public static final QName isNotDefined = makeQName("is-not-defined");

  /**   */
  public static final QName limit = makeQName("limit");

  /**   */
  public static final QName maxResourceSize = makeQName("max-resource-size");

  /**   */
  public static final QName noUidConflict = makeQName("no-uid-conflict");
  /**   */
  public static final QName nresults = makeQName("nresults");

  /**   */
  public static final QName paramFilter = makeQName("param-filter");

  /** */
  public static final QName principalAddress = makeQName("principal-address");

  /**   */
  public static final QName prop = makeQName("prop");

  /**   */
  public static final QName propFilter = makeQName("prop-filter");

  /** */
  public static final QName supportedAddressData = makeQName("supported-address-data");

  /** */
  public static final QName supportedCollation = makeQName("supported-collation");

  /** */
  public static final QName validAddressData = makeQName("valid-address-data");

  /**   */
  public static final QName textMatch = makeQName("text-match");

  private static QName makeQName(final String name) {
    QName q = new QName(namespace, name);
    qnames.put(name, q);

    return q;
  }
}

