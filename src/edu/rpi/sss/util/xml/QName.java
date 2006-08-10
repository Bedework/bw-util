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
public class QName {
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
    if (o == this) {
      return true;
    }

    if (!(o instanceof QName)) {
      return false;
    }

    QName that = (QName)o;

    String ns = getNamespaceURI();
    if (ns == null) {
      if (that.getNamespaceURI() != null) {
        return false;
      }
    } else if (!ns.equals(that.getNamespaceURI())) {
      return false;
    }

    String lp = getLocalPart();
    if (lp == null) {
      if (that.getLocalPart() != null) {
        return false;
      }
    } else if (!lp.equals(that.getLocalPart())) {
      return false;
    }

    return true;
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

  /** See if node matches tag
   *
   * @param nd
   * @return boolean true for match
   */
  public boolean nodeMatches(Node nd) {
    String ns = nd.getNamespaceURI();

    if (ns == null) {
      if (getNamespaceURI() != null) {
        return false;
      }
    } else if (!ns.equals(getNamespaceURI())) {
      return false;
    }

    String ln = nd.getLocalName();

    if (ln == null) {
      if (getLocalPart() != null) {
        return false;
      }
    } else if (!ln.equals(getLocalPart())) {
      return false;
    }

    return true;
  }
}

