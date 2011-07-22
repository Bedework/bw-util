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
import org.oasis_open.docs.ns.wscal.calws_soap.NewValueType;
import org.oasis_open.docs.ns.wscal.calws_soap.RemoveType;
import org.oasis_open.docs.ns.wscal.calws_soap.ReplaceType;
import org.oasis_open.docs.ns.wscal.calws_soap.SelectElementType;

import ietf.params.xml.ns.icalendar_2.BaseParameterType;

import javax.xml.bind.JAXBElement;
import javax.xml.namespace.QName;

/** This class wraps a parameter.
 *
 * @author Mike Douglass
 */
class ParamWrapper extends BaseEntityWrapper<ParamWrapper,
                                             ParamsWrapper,
                                             BaseParameterType>
                   implements Comparable<ParamWrapper> {
  private ValueMatcher matcher;

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

  @Override
  public JAXBElement<? extends BaseUpdateType> getUpdate() {
    if (getDelete()) {
      RemoveType r = new RemoveType();

      r.setSelect(getSelect());

      return of.createRemove(r);
    }

    if (getAdd()) {
      AddType a = new AddType();

      a.setNewValue(new NewValueType());
      a.getNewValue().setBaseParameter(getJaxbElement());
      return of.createAdd(a);
    }

    /* Need to distinguish between change and replace
     */

    ReplaceType r = new ReplaceType();

    r.setSelect(getSelect());
    r.setNewValue(new NewValueType());
    r.getNewValue().setBaseParameter(getJaxbElement());
    return of.createReplace(r);
  }

  /* create a SelectElementType with a selection for this property
   */
  private SelectElementType getSelect() {
    SelectElementType sel = new SelectElementType();

    sel.setBaseParameter(getJaxbElement());

    return sel;
  }

  /** Return a SelectElementType if the values differ. This object
   * represents the new state
   *
   * @param that - the old version
   * @return SelectElementType
   */
  public SelectElementType diff(final ParamWrapper that) {
    SelectElementType sel = null;

    if (!equalValue(that)) {
      sel = that.getSelect();
      ChangeType ct = new ChangeType();

      ct.setNewValue(new NewValueType());
      ct.getNewValue().setBaseParameter(getJaxbElement());

      sel.getBaseUpdate().add(of.createChange(ct));
    }

    return sel;
  }

  public boolean equalValue(final ParamWrapper that) {
    return getMatcher().equals(that.getMatcher());
  }

  public int compareValue(final ParamWrapper that) {
    return getMatcher().compareTo(that.getMatcher());
  }

  ValueMatcher getMatcher() {
    if (matcher == null) {
      matcher = new ValueMatcher(getEntity());
    }

    return matcher;
  }

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
    return getName().hashCode() * getMatcher().hashCode();
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
    sb.append(getMatcher());
    sb.append("\"");

    sb.append("}");

    return sb.toString();
  }
}
