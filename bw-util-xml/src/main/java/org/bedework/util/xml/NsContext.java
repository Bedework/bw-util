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
package org.bedework.util.xml;

import org.bedework.util.xml.tagdefs.AppleServerTags;
import org.bedework.util.xml.tagdefs.BedeworkServerTags;
import org.bedework.util.xml.tagdefs.CaldavTags;
import org.bedework.util.xml.tagdefs.CarddavTags;
import org.bedework.util.xml.tagdefs.IscheduleTags;
import org.bedework.util.xml.tagdefs.XcalTags;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;

import javax.xml.XMLConstants;
import javax.xml.namespace.NamespaceContext;
import javax.xml.namespace.QName;

/** Class used for diff, xpaths etc etc.
 * @author douglm
 *
 */
public class NsContext implements NamespaceContext {
  private static Map<String, String> keyPrefix = new HashMap<>();
  private static Map<String, String> keyUri = new HashMap<>();

  static {
    addToMap("D", "DAV");
    addToMap("AS", AppleServerTags.appleCaldavNamespace);
    addToMap("BW", BedeworkServerTags.bedeworkSystemNamespace);
    addToMap("BWC", BedeworkServerTags.bedeworkCaldavNamespace);
    addToMap("BWCD", BedeworkServerTags.bedeworkCarddavNamespace);
    addToMap("C", CaldavTags.caldavNamespace);
    addToMap("CD", CarddavTags.namespace);
    addToMap("IS", IscheduleTags.namespace);
    addToMap("X", XcalTags.namespace);
    addToMap("df", "urn:ietf:params:xml:ns:pidf-diff");
    addToMap("xml", XMLConstants.XML_NS_URI);
    addToMap("xmlns", XMLConstants.XMLNS_ATTRIBUTE_NS_URI);
  }

  private String defaultNS;

  /** Constructor
   *
   * @param defaultNS the default namespace
   */
  public NsContext(final String defaultNS) {
    this.defaultNS = defaultNS;
  }

  /**
   * @return default ns or null
   */
  public String getDefaultNS() {
    return defaultNS;
  }

  public String getNamespaceURI(final String prefix) {
    if ((prefix != null) && prefix.equals(XMLConstants.DEFAULT_NS_PREFIX)) {
      return defaultNS;
    }

    String uri = keyPrefix.get(prefix);

    if (uri == null) {
      return XMLConstants.NULL_NS_URI;
    }

    return uri;
  }

  public Iterator<String> getPrefixes(final String val) {
    String prefix = keyUri.get(val);
    Set<String> pfxs = new TreeSet<>();

    if (prefix != null) {
      pfxs.add(prefix);
    }
    return pfxs.iterator();
  }

  /**
   * @return all prefixes
   */
  public Set<String> getPrefixes() {
    return keyPrefix.keySet();
  }

  /** Clear all items
   *
   */
  public void clear() {
    keyPrefix.clear();
    keyUri.clear();
    defaultNS = null;
  }

  /** Add a namespace to the maps
   *
   * @param prefix the prefix for generated xml
   * @param uri the namespace uri
   */
  public void add(final String prefix, final String uri) {
    if (prefix == null) {
      defaultNS = uri;
    }

    addToMap(prefix, uri);
  }

  public String getPrefix(final String uri) {
    if ((defaultNS != null) && uri.equals(defaultNS)) {
      return XMLConstants.DEFAULT_NS_PREFIX;
    }

    return keyUri.get(uri);
  }

  /** Append the name with abbreviated namespace.
   *
   * @param sb for result
   * @param nm QName object
   */
  public void appendNsName(final StringBuilder sb,
                           final QName nm) {
    String uri = nm.getNamespaceURI();
    String abbr;

    if ((defaultNS != null) && uri.equals(defaultNS)) {
      abbr = null;
    } else {
      abbr = keyUri.get(uri);
      if (abbr == null) {
        abbr = uri;
      }
    }

    if (abbr != null) {
      sb.append(abbr);
      sb.append(":");
    }

    sb.append(nm.getLocalPart());
  }

  private static void addToMap(final String prefix, final String uri) {
    if (keyPrefix.get(prefix) != null) {
      throw new RuntimeException("Attempt to replace namespace prefix");
    }
    if (keyUri.get(uri) != null) {
      throw new RuntimeException("Attempt to replace namespace");
    }
    keyPrefix.put(prefix, uri);
    keyUri.put(uri, prefix);
  }
}
