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

import java.util.HashMap;

import javax.xml.namespace.QName;

/** Define Catdav tags
 *
 * @author Mike Douglass douglm@rpi.edu
 */
public class CatdavTags {
  /** Namespace for these tags
   */
  public static final String namespace = "http://www.bedework.org/ns/catdav";

  /** Tables of QNames indexed by name
   */
  public final static HashMap<String, QName> qnames = new HashMap<String, QName>();

  /** */
  public static final QName category = makeQName("category");

  /** */
  public static final QName categoryDescription = makeQName("category-description");

  /** */
  public static final QName categoriesHomeSet = makeQName("categories-home-set");

  /** */
  public static final QName addressbookCollectionLocationOk =
              makeQName("addressbook-collection-location-ok");

  /** */
  public static final QName allprop = makeQName("allprop");

  /**   */
  public static final QName categoriesMultiget = makeQName("categories-multiget");

  /** */
  public static final QName categorieskQuery = makeQName("categories-query");

  /** */
  public static final QName categoryData = makeQName("category-data");

  /** */
  public static final QName categoryDataType = makeQName("category-data-type");

  /** */
  public static final QName descriptions = makeQName("descriptions");

  /** */
  public static final QName displayNames = makeQName("display-names");

  /**   */
  public static final QName filter = makeQName("filter");

  /**   */
  public static final QName isNotDefined = makeQName("is-not-defined");

  /**   */
  public static final QName lastmod = makeQName("lastmod");

  /**   */
  public static final QName limit = makeQName("limit");

  /** */
  public static final QName locale = makeQName("locale");

  /** */
  public static final QName localizedText = makeQName("localized-text");

  /**   */
  public static final QName maxResourceSize = makeQName("max-resource-size");

  /**   */
  public static final QName name = makeQName("name");

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
  public static final QName supportedCategoryData = makeQName("supported-category-data");

  /** */
  public static final QName supportedCollation = makeQName("supported-collation");

  /** */
  public static final QName validCategoryData = makeQName("valid-category-data");

  /**   */
  public static final QName text = makeQName("text");

  /**   */
  public static final QName textMatch = makeQName("text-match");

  /**   */
  public static final QName uid = makeQName("uid");

  private static QName makeQName(final String name) {
    QName q = new QName(namespace, name);
    qnames.put(name, q);

    return q;
  }
}

