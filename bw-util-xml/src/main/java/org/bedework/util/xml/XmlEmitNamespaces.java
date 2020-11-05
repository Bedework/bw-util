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

import org.bedework.util.xml.XmlEmit.NameSpace;
import org.bedework.util.xml.XmlEmit.XmlUtilException;

import java.io.IOException;
import java.io.Writer;
import java.util.HashMap;
import java.util.Stack;

/** Class to handle namespaces when emitting xml
 *
 * @author Mike Douglass  douglm@rpi.edu
 */
public class XmlEmitNamespaces {
  private boolean mustEmitNS; // Emit this scopes namespaces.

  private int scopeLevel; // So we can pop namespaces

  private final Stack<NameSpace> namespaces = new Stack<>();

  /** We need to map the namespaces onto a set of reasonable abbreviations
   * for the generated xml. New set created each request
   */
  private final HashMap<String, NameSpace> nsMap;

  private int nsIndex;

  private String defaultNs;

  /** construct an object which will be used to collect namespace names
   * during the first phase and emit xml after startEmit is called.
   */
  public XmlEmitNamespaces() {
    nsMap = new HashMap<>();
  }

  /**
   *
   * @param val name space
   * @param makeDefaultNs - true => make this the default
   * @throws XmlUtilException on fatal error
   */
  public void addNs(final NameSpace val,
                    final boolean makeDefaultNs) {
    if (val.abbrev == null) {
      val.abbrev = "ns" + nsIndex;
      nsIndex++;
    }

    val.level = scopeLevel;
    val.defaultNs = makeDefaultNs;

    for (final NameSpace ns: nsMap.values()) {
      if (val.equals(ns)) {
        continue;
      }

      if ((val.level == ns.level) && val.abbrev.equals(ns.abbrev)) {
        throw new XmlUtilException("Duplicate namespace alias for " + val.ns);
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
      final NameSpace ns = namespaces.peek();

      if (ns.level < scopeLevel) {
        //popped enough
        break;
      }

      namespaces.pop();
    }

    // Rebuild the map.
    nsMap.clear();

    for (int i = 0; i < namespaces.size(); i++) {
      final NameSpace ns = namespaces.elementAt(i);

      nsMap.put(ns.ns, ns);
    }

    scopeLevel--;
  }

  /**
   * @param ns string name
   * @return NameSpace if present
   */
  public NameSpace getNameSpace(final String ns) {
    return nsMap.get(ns);
  }

  /**
   * @param ns string name
   * @return namespace abbrev
   */
  public String getNsAbbrev(final String ns) {
    final NameSpace n = nsMap.get(ns);

    if (n == null) {
      return null;
    }

    return n.abbrev;
  }

  /**
   * @param ns - full namespace from qname
   * @param wtr - the writer
   * @throws XmlUtilException on fatal error
   */
  public void emitNsAbbr(final String ns,
                         final Writer wtr) {
    if ((ns == null) || ns.equals(defaultNs)) {
      return;
    }

    final String abbr = getNsAbbrev(ns);

    if (abbr != null) {
      try {
        wtr.write(abbr);
        wtr.write(":");
      } catch (final IOException ie) {
        throw new XmlUtilException(ie);
      }
    }
  }

  /**
   * @param wtr the writer
   * @throws XmlUtilException on fatal eror
   */
  public void emitNs(final Writer wtr) {
    if (!mustEmitNS) {
      return;
    }

    try {
      /* First tag so emit the name space declarations.
       */
      String delim = "";

      for (final String nsp: nsMap.keySet()) {
        wtr.write(delim);
        delim = "\n             ";

        wtr.write(" xmlns");

        final String abbr = getNsAbbrev(nsp);

        if ((abbr != null) && !nsp.equals(defaultNs)) {
          wtr.write(":");
          wtr.write(abbr);
        }

        wtr.write("=\"");
        wtr.write(nsp);
        wtr.write("\"");
      }
    } catch (final IOException ie) {
      throw new XmlUtilException(ie);
    }

    mustEmitNS = false;
  }
}
