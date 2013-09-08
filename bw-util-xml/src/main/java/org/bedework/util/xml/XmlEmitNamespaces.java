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

  private Stack<XmlEmit.NameSpace> namespaces = new Stack<XmlEmit.NameSpace>();

  /** We need to map the namespaces onto a set of reasonable abbreviations
   * for the generated xml. New set created each request
   */
  private HashMap<String, XmlEmit.NameSpace> nsMap;

  private int nsIndex;

  private String defaultNs;

  /** construct an object which will be used to collect namespace names
   * during the first phase and emit xml after startEmit is called.
   */
  public XmlEmitNamespaces() {
    nsMap = new HashMap<String, XmlEmit.NameSpace>();
  }

  /**
   *
   * @param val
   * @param makeDefaultNs - true => make this the default
   * @throws IOException
   */
  public void addNs(final XmlEmit.NameSpace val,
                    final boolean makeDefaultNs) throws IOException {
    if (val.abbrev == null) {
      val.abbrev = "ns" + nsIndex;
      nsIndex++;
    }

    val.level = scopeLevel;
    val.defaultNs = makeDefaultNs;

    for (XmlEmit.NameSpace ns: nsMap.values()) {
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
      XmlEmit.NameSpace ns = namespaces.peek();

      if (ns.level < scopeLevel) {
        //popped enough
        break;
      }

      namespaces.pop();
    }

    // Rebuild the map.
    nsMap.clear();

    for (int i = 0; i < namespaces.size(); i++) {
      XmlEmit.NameSpace ns = namespaces.elementAt(i);

      nsMap.put(ns.ns, ns);
    }

    scopeLevel--;
  }

  /**
   * @param ns
   * @return NameSpace if present
   */
  public XmlEmit.NameSpace getNameSpace(final String ns) {
    return nsMap.get(ns);
  }

  /**
   * @param ns
   * @return namespace abrev
   */
  public String getNsAbbrev(final String ns) {
    XmlEmit.NameSpace n = nsMap.get(ns);

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
