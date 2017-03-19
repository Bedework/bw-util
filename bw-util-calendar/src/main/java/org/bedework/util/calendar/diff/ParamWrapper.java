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
package org.bedework.util.calendar.diff;

import ietf.params.xml.ns.icalendar_2.BaseParameterType;
import org.oasis_open.docs.ws_calendar.ns.soap.ParameterReferenceType;
import org.oasis_open.docs.ws_calendar.ns.soap.ParameterSelectionType;

import javax.xml.namespace.QName;

/** This class wraps a parameter.
 *
 * @author Mike Douglass
 */
class ParamWrapper extends BaseEntityWrapper<ParamWrapper,
                                             ParamsWrapper,
                                             BaseParameterType>
                   implements Comparable<ParamWrapper> {
  private ValueComparator comparator;

  ParamWrapper(final ParamsWrapper parent,
               final QName name,
               final BaseParameterType p) {
    super(parent, name, p);
  }

  @Override
  QName getMappedName(final QName name) {
    return null;
  }

  @Override
  boolean sameEntity(final BaseEntityWrapper val) {
    int res = super.compareNameClass(val);
    if (res != 0) {
      return false;
    }

    return true;
  }

  ParameterReferenceType makeRef() {
    ParameterReferenceType r = new ParameterReferenceType();

    r.setBaseParameter(getJaxbElement());
    return r;
  }

  ParameterSelectionType getSelect(final ParameterSelectionType val) {
    if (val != null) {
      return val;
    }

    ParameterSelectionType sel = new ParameterSelectionType();

    sel.setBaseParameter(getJaxbElement());

    return sel;
  }

  /** Return a SelectElementType if the values differ. This object
   * represents the new state
   *
   * @param that - the old version
   * @return ParameterSelectionType
   */
  public ParameterSelectionType diff(final ParamWrapper that) {
    ParameterSelectionType sel = null;

    if (!equalValue(that)) {
      sel = that.getSelect(sel);
      ParameterReferenceType ct = new ParameterReferenceType();

      ct.setBaseParameter(getJaxbElement());

      sel.setChange(ct);
    }

    return sel;
  }

  public boolean equalValue(final ParamWrapper that) {
    return getComparator().equals(that.getComparator());
  }

  public int compareValue(final ParamWrapper that) {
    return getComparator().compareTo(that.getComparator());
  }

  ValueComparator getComparator() {
    if (comparator == null) {
      comparator = globals.matcher.getComparator(getEntity());
    }

    return comparator;
  }

  @Override
  public int compareTo(final ParamWrapper o) {
    int res = super.compareTo(o);
    if (res != 0) {
      return res;
    }

    res = getEntity().getClass().getName().compareTo(o.getEntity().getClass().getName());

    if (res != 0) {
      return res;
    }

    return compareValue(o);
  }

  @Override
  public int hashCode() {
    return getName().hashCode() * getComparator().hashCode();
  }

  @Override
  public boolean equals(final Object o) {
    return compareTo((ParamWrapper)o) == 0;
  }

  @Override
  public String toString() {
    StringBuilder sb = new StringBuilder("ParamWrapper{");

    super.toStringSegment(sb);

    sb.append(", matcher=\"");
    sb.append(getComparator());
    sb.append("\"");

    sb.append("}");

    return sb.toString();
  }
}
