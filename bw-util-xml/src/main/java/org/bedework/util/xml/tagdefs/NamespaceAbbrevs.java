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
import java.util.Map;

import javax.xml.namespace.QName;

/** A set of 'standard' abbreviations - useful when storing properties. There is
 * no such thing as a standard abbereviation. These are for internal use.
 *
 * @author douglm
 *
 */
public class NamespaceAbbrevs {
  private static final Map<String, String> namespacesToAbbrevs =
      new HashMap<String, String>();

  static {
    namespacesToAbbrevs.put(AppleIcalTags.appleIcalNamespace, "AICAL");

    namespacesToAbbrevs.put(AppleServerTags.appleCaldavNamespace, "CS");

    namespacesToAbbrevs.put(BedeworkServerTags.bedeworkCaldavNamespace, "BWS");

    namespacesToAbbrevs.put(CaldavDefs.caldavNamespace, "C");

    namespacesToAbbrevs.put(CaldavDefs.icalNamespace, "IC");

    namespacesToAbbrevs.put(CarddavTags.namespace, "CARD");

    namespacesToAbbrevs.put(IscheduleTags.namespace, "ISCH");

    namespacesToAbbrevs.put(WebdavTags.namespace, "DAV");
  }


  /**
   * @param ns
   * @return abbrev or null
   */
  public static String namespaceToAbbrev(final String ns) {
    if (ns == null) {
      return null;
    }

    return namespacesToAbbrevs.get(ns);
  }

  /**
   * @param qn
   * @return abbrev or null
   */
  public static String qnameToAbbrev(final QName qn) {
    return namespaceToAbbrev(qn.getNamespaceURI());
  }

  /**
   * @param qn
   * @return namespace:localPart
   */
  public static String prefixed(final QName qn) {
    return prefixed(qn.getNamespaceURI(), qn.getLocalPart());
  }

  /**
   * @param namespace
   * @param localPart
   * @return namespace:localPart
   */
  public static String prefixed(final String namespace, final String localPart) {
    String nsAbbrev = namespaceToAbbrev(namespace);
    if (nsAbbrev != null) {
      return nsAbbrev + ":" + localPart;
    }

    return localPart;
  }
}
