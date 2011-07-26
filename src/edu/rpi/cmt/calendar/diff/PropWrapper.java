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

import org.oasis_open.docs.ns.wscal.calws_soap.AddType;
import org.oasis_open.docs.ns.wscal.calws_soap.BaseUpdateType;
import org.oasis_open.docs.ns.wscal.calws_soap.ChangeType;
import org.oasis_open.docs.ns.wscal.calws_soap.SelectElementType;

import ietf.params.xml.ns.icalendar_2.BaseParameterType;
import ietf.params.xml.ns.icalendar_2.BasePropertyType;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.xml.bind.JAXBElement;
import javax.xml.namespace.QName;

/** This class wraps a property.
 *
 * @author Mike Douglass
 */
class PropWrapper extends BaseEntityWrapper<PropWrapper,
                                            PropsWrapper,
                                            BasePropertyType>
            implements Comparable<PropWrapper> {
  private ParamsWrapper params;

  private ValueMatcher matcher;

  /* Key is the real name of the property - result is null for no mapping or a
   * QName we treat it as for comparison.
   */
  private static Map<QName, QName> mappedNames = new HashMap<QName, QName>();

  static {
    final String ns = "urn:ietf:params:xml:ns:icalendar-2.0";

    mappedNames.put(new QName(ns, "x-bedework-exsynch-organizer"),
                    new QName(ns, "organizer"));
  }

  PropWrapper(final PropsWrapper parent,
              final QName name,
              final BasePropertyType p) {
    super(parent, name, p);

    List<JAXBElement<? extends BaseParameterType>> plist = null;

    if (p.getParameters() != null) {
      plist = p.getParameters().getBaseParameter();
    }
    params = new ParamsWrapper(this, plist);
  }

  @Override
  QName getMappedName(final QName name) {
    return mappedNames.get(name);
  }

  @Override
  boolean sameEntity(final BaseEntityWrapper val) {
    int res = super.compareNameClass(val);
    if (res != 0) {
      return false;
    }

    return true;
  }

  @Override
  JAXBElement<? extends BaseUpdateType> makeAdd() {
    AddType a = new AddType();

    a.setBaseProperty(getJaxbElement());
    return of.createAdd(a);
  }

  @Override
  SelectElementType getSelect(final SelectElementType val) {
    if (val != null) {
      return val;
    }

    SelectElementType sel = new SelectElementType();

    sel.setBaseProperty(getJaxbElement());

    return sel;
  }

  /** Return a SelectElementType if the values differ. This object
   * represents the new state
   *
   * @param that - the old version
   * @return SelectElementType
   */
  public SelectElementType diff(final PropWrapper that) {
    SelectElementType sel = null;

    if (params != null) {
      SelectElementType psel = params.diff(that.params);

      if (psel != null) {
        sel = that.getSelect(sel);

        sel.getSelect().add(psel);
      }
    }

    if (!equalValue(that)) {
      sel = that.getSelect(sel);
      ChangeType ct = new ChangeType();

      ct.setBaseProperty(getJaxbElement());

      sel.getBaseUpdate().add(of.createChange(ct));
    }

    return sel;
  }

  public boolean equalValue(final PropWrapper that) {
    return getMatcher().equals(that.getMatcher());
  }

  public int compareValue(final PropWrapper that) {
    return getMatcher().compareTo(that.getMatcher());
  }

  ValueMatcher getMatcher() {
    if (matcher == null) {
      matcher = new ValueMatcher(getEntity());
    }

    return matcher;
  }

  public int compareTo(final PropWrapper o) {
    int res = super.compareNameClass(o);
    if (res != 0) {
      return res;
    }

    res = compareValue(o);

    if (res != 0) {
      return res;
    }

    // Try params

    return params.compareTo(o.params);
  }

  @Override
  public int hashCode() {
    return getName().hashCode() * getMatcher().hashCode();
  }

  @Override
  public boolean equals(final Object o) {
    return compareTo((PropWrapper)o) == 0;
  }

  @Override
  public String toString() {
    StringBuilder sb = new StringBuilder("PropWrapper{");

    super.toStringSegment(sb);

    /* Just serialize the entity?
    if (params.size() > 0) {
      sb.append(", params=");
      sb.append(params);
    }

    sb.append(", value=\"");
    sb.append(getValue());
    sb.append("\"");
    */

    sb.append("}");

    return sb.toString();
  }
}
