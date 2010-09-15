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

import edu.rpi.sss.util.xml.XmlEmit.NameSpace;

import java.io.IOException;
import java.io.Writer;
import java.util.HashMap;
import java.util.Stack;

/** Class to handle namespaces when emitting xml
 *
 * @author Mike Douglass  douglm@rpi.edu
 */
class XmlEmitNamespaces {
  private boolean mustEmitNS; // Emit this scopes namespaces.

  private int scopeLevel; // So we can pop namespaces

  private Stack<NameSpace> namespaces = new Stack<NameSpace>();

  /** We need to map the namespaces onto a set of reasonable abbreviations
   * for the generated xml. New set created each request
   */
  private HashMap<String, NameSpace> nsMap;

  private int nsIndex;

  private String defaultNs;

  /** construct an object which will be used to collect namespace names
   * during the first phase and emit xml after startEmit is called.
   */
  public XmlEmitNamespaces() {
    nsMap = new HashMap<String, NameSpace>();
  }

  /**
   *
   * @param val
   * @param makeDefaultNs - true => make this the default
   * @throws IOException
   */
  public void addNs(final NameSpace val,
                    final boolean makeDefaultNs) throws IOException {
    if (val.abbrev == null) {
      val.abbrev = "ns" + nsIndex;
      nsIndex++;
    }

    val.level = scopeLevel;
    val.defaultNs = makeDefaultNs;

    for (NameSpace ns: nsMap.values()) {
      if (val.equals(ns)) {
        continue;
      }

      if ((val.level == ns.level) && val.abbrev.equals(ns.abbrev)) {
        throw new IOException("Duplicate namespace alias for " + val.ns);
      }
    }

    nsMap.put(val.ns, val);
    mustEmitNS = true;
    namespaces.push(val);

    if (makeDefaultNs) {
      defaultNs = val.ns;
    }
  }

  public void startScope() {
    scopeLevel++;
  }

  public void endScope() {
    while (!namespaces.empty()) {
      NameSpace ns = namespaces.peek();

      if (ns.level < scopeLevel) {
        //popped enough
        break;
      }

      namespaces.pop();
    }

    // Rebuild the map.
    nsMap.clear();

    for (int i = 0; i < namespaces.size(); i++) {
      NameSpace ns = namespaces.elementAt(i);

      nsMap.put(ns.ns, ns);
    }

    scopeLevel--;
  }

  /**
   * @param ns
   * @return NameSpace if present
   */
  public NameSpace getNameSpace(final String ns) {
    return nsMap.get(ns);
  }

  /**
   * @param ns
   * @return namespace abrev
   */
  public String getNsAbbrev(final String ns) {
    NameSpace n = nsMap.get(ns);

    if (n == null) {
      return null;
    }

    return n.abbrev;
  }

  /**
   * @param ns - full namespace from qname
   * @param wtr
   * @throws IOException
   */
  public void emitNsAbbr(final String ns,
                         final Writer wtr) throws IOException {
    if ((ns == null) || ns.equals(defaultNs)) {
      return;
    }

    String abbr = getNsAbbrev(ns);

    if (abbr != null) {
      wtr.write(abbr);
      wtr.write(":");
    }
  }

  /**
   * @param wtr
   * @throws IOException
   */
  public void emitNs(final Writer wtr) throws IOException {
    if (!mustEmitNS) {
      return;
    }

    /* First tag so emit the name space declarations.
     */
    String delim = "";

    for (String nsp: nsMap.keySet()) {
      wtr.write(delim);
      delim = "\n             ";

      wtr.write(" xmlns");

      String abbr = getNsAbbrev(nsp);

      if ((abbr != null) && !nsp.equals(defaultNs)) {
        wtr.write(":");
        wtr.write(abbr);
      }

      wtr.write("=\"");
      wtr.write(nsp);
      wtr.write("\"");
    }

    mustEmitNS = false;
  }
}
