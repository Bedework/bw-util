/* **********************************************************************
    Copyright 2006 Rensselaer Polytechnic Institute. All worldwide rights reserved.

    Redistribution and use of this distribution in source and binary forms,
    with or without modification, are permitted provided that:
       The above copyright notice and this permission notice appear in all
        copies and supporting documentation;

        The name, identifiers, and trademarks of Rensselaer Polytechnic
        Institute are not used in advertising or publicity without the
        express prior written permission of Rensselaer Polytechnic Institute;

    DISCLAIMER: The software is distributed" AS IS" without any express or
    implied warranty, including but not limited to, any implied warranties
    of merchantability or fitness for a particular purpose or any warrant)'
    of non-infringement of any current or pending patent rights. The authors
    of the software make no representations about the suitability of this
    software for any particular purpose. The entire risk as to the quality
    and performance of the software is with the user. Should the software
    prove defective, the user assumes the cost of all necessary servicing,
    repair or correction. In particular, neither Rensselaer Polytechnic
    Institute, nor the authors of the software are liable for any indirect,
    special, consequential, or incidental damages related to the software,
    to the maximum extent the law permits.
*/

package edu.rpi.sss.util.xml;

import org.w3c.dom.Node;

/** Class to represent an XML qualified name.
 * NOTE: This is defined in the j2ee world somewhere as javax.xml.namespace.QName
 * and we should use that when it appears in the appropriate libraries.
 *
 * <p>An xml name is represented by an optional namespace uri folllowed by a
 * localPart.
 * @author Mike Douglass  douglm@rpi.edu
 */
public class QName implements Comparable {
  private String namespaceURI;
  private String localPart;

  /** Constructor
   * @param namespaceURI
   * @param localPart
   */
  public QName(String namespaceURI, String localPart) {
    this.namespaceURI = namespaceURI;
    this.localPart = localPart;
  }

  /**
   * @return namespace uri
   */
  public String getNamespaceURI() {
    return namespaceURI;
  }

  /**
   * @return local part of name
   */
  public String getLocalPart() {
    return localPart;
  }

  public int compareTo(Object o) {
    if (this == o) {
      return 0;
    }

    if (!(o instanceof QName)) {
      return -1;
    }

    QName that = (QName)o;

    int res = compareStrings(getNamespaceURI(), that.getNamespaceURI());
    if (res != 0) {
      return res;
    }

    return compareStrings(getLocalPart(), that.getLocalPart());
  }

  public int hashCode() {
    int hc = 1;

    String ns = getNamespaceURI();
    if (ns != null) {
      hc *= ns.hashCode();
    }

    String lp = getLocalPart();
    if (lp != null) {
      hc *= lp.hashCode();
    }

    return hc;
  }

  public boolean equals(Object o) {
    return compareTo(o) == 0;
  }

  public String toString() {
    StringBuffer sb = new StringBuffer();

    String ns = getNamespaceURI();
    if (ns != null) {
      sb.append(ns);
      sb.append(":");
    }

    sb.append(getLocalPart());

    return sb.toString();
  }

  /**
   * @param nd
   * @return QName
   */
  public static QName from(Node nd) {
    return new QName(nd.getNamespaceURI(), nd.getLocalName());
  }

  private static int compareStrings(String s1, String s2) {
    if (s1 == null) {
      if (s2 != null) {
        return -1;
      }

      return 0;
    }

    if (s2 == null) {
      return 1;
    }

    return s1.compareTo(s2);
  }
}

