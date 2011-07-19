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
package edu.rpi.cmt.calendar.diff;

import edu.rpi.sss.util.xml.NsContext;

import javax.xml.namespace.QName;


/** This class allows us to build a hierarchy of named elements.
 *
 * @author Mike Douglass
 *
 * @param <ParentT>
 */
class BaseWrapper<ParentT extends BaseWrapper> {
  static final String icalendarNs = "urn:ietf:params:xml:ns:icalendar-2.0";

  private ParentT parent;

  private QName name;

  BaseWrapper(final ParentT parent,
              final QName name) {
    this.parent = parent;
    this.name = name;
  }

  ParentT getParent() {
    return parent;
  }

  QName getName() {
    return name;
  }

  void appendNsName(final StringBuilder sb,
                    final NsContext nsContext) {
    nsContext.appendNsName(sb, name);
  }

  void appendNsName(final StringBuilder sb,
                    final QName nm,
                    final NsContext nsContext) {
    nsContext.appendNsName(sb, nm);
  }

  /** Called to provide the path element which selects this node. When called
   * we are positioned at the parent of the node.
   *
   * <p>appendXPathPredicate may need to be called to add predicates to select a
   * unique instance from a number of nodes.
   *
   * @param sb
   * @param nsContext
   */
  void appendXpathElement(final StringBuilder sb,
                          final NsContext nsContext) {
    appendNsName(sb, nsContext);
  }

  protected void toStringSegment(final StringBuilder sb) {
    sb.append("name=");
    sb.append(name);
  }
}
