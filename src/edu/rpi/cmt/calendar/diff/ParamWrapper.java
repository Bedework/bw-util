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

import edu.rpi.sss.util.Util;
import edu.rpi.sss.util.xml.tagdefs.XcalTags;

import org.oasis_open.docs.ns.wscal.calws_soap.AddType;
import org.oasis_open.docs.ns.wscal.calws_soap.BaseUpdateType;
import org.oasis_open.docs.ns.wscal.calws_soap.ChangeType;
import org.oasis_open.docs.ns.wscal.calws_soap.NewValueType;
import org.oasis_open.docs.ns.wscal.calws_soap.RemoveType;
import org.oasis_open.docs.ns.wscal.calws_soap.ReplaceType;
import org.oasis_open.docs.ns.wscal.calws_soap.SelectElementType;

import ietf.params.xml.ns.icalendar_2.BaseParameterType;
import ietf.params.xml.ns.icalendar_2.CalAddressListParamType;
import ietf.params.xml.ns.icalendar_2.CalAddressParamType;
import ietf.params.xml.ns.icalendar_2.CutypeParamType;
import ietf.params.xml.ns.icalendar_2.EncodingParamType;
import ietf.params.xml.ns.icalendar_2.FbtypeParamType;
import ietf.params.xml.ns.icalendar_2.PartstatParamType;
import ietf.params.xml.ns.icalendar_2.RangeParamType;
import ietf.params.xml.ns.icalendar_2.RelatedParamType;
import ietf.params.xml.ns.icalendar_2.ReltypeParamType;
import ietf.params.xml.ns.icalendar_2.RoleParamType;
import ietf.params.xml.ns.icalendar_2.RsvpParamType;
import ietf.params.xml.ns.icalendar_2.ScheduleAgentParamType;
import ietf.params.xml.ns.icalendar_2.ScheduleForceSendParamType;
import ietf.params.xml.ns.icalendar_2.TextParameterType;
import ietf.params.xml.ns.icalendar_2.UriParameterType;

import java.util.List;

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

    if (!getValue().equals(that.getValue())) {
      sel = getSelect();
      ChangeType ct = new ChangeType();

      ct.setNewValue(new NewValueType());

      sel.getBaseUpdate().add(of.createChange(ct));
    }

    return sel;
  }

  ValueType getValue() {
    BaseParameterType p = getEntity();

    if (p instanceof CalAddressParamType) {
      return new ValueType(XcalTags.calAddressVal,
                           ((CalAddressParamType)p).getCalAddress());
    }

    if (p instanceof CalAddressListParamType) {
      List<String> ss = ((CalAddressListParamType)p).getCalAddress();

      ValueType vt = new ValueType();

      for (String s: ss) {
        vt.addValue(XcalTags.calAddressVal, s);
      }

      return vt;
    }

    if (p instanceof TextParameterType) {
      return new ValueType(XcalTags.textVal,
                           ((TextParameterType)p).getText());
    }

    if (p instanceof UriParameterType) {
      return new ValueType(XcalTags.uriVal,
                           ((UriParameterType)p).getUri());
    }

    /* Non subclassed */

    if (p instanceof CutypeParamType) {
      return new ValueType(XcalTags.textVal,
                           ((CutypeParamType)p).getText());
    }

    if (p instanceof EncodingParamType) {
      return new ValueType(XcalTags.textVal,
                           ((EncodingParamType)p).getText());
    }

    if (p instanceof FbtypeParamType) {
      return new ValueType(XcalTags.textVal,
                           ((FbtypeParamType)p).getText());
    }

    if (p instanceof PartstatParamType) {
      return new ValueType(XcalTags.textVal,
                           ((PartstatParamType)p).getText());
    }

    if (p instanceof RangeParamType) {
      return new ValueType(XcalTags.textVal,
                           ((RangeParamType)p).getText().toString());
    }

    if (p instanceof RelatedParamType) {
      return new ValueType(XcalTags.textVal,
                           ((RelatedParamType)p).getText());
    }

    if (p instanceof ReltypeParamType) {
      return new ValueType(XcalTags.textVal,
                           ((ReltypeParamType)p).getText().toString());
    }

    if (p instanceof RoleParamType) {
      return new ValueType(XcalTags.textVal,
                           ((RoleParamType)p).getText());
    }

    if (p instanceof RsvpParamType) {
      return new ValueType(XcalTags.booleanVal,
                           String.valueOf(((RsvpParamType)p).isBoolean()));
    }

    if (p instanceof ScheduleAgentParamType) {
      return new ValueType(XcalTags.textVal,
                           ((ScheduleAgentParamType)p).getText());
    }

    if (p instanceof ScheduleForceSendParamType) {
      return new ValueType(XcalTags.textVal,
                           ((ScheduleForceSendParamType)p).getText());
    }

    return null;
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

    return Util.cmpObjval(getValue(), o.getValue());
  }

  @Override
  public int hashCode() {
    return getName().hashCode() * getValue().hashCode();
  }

  @Override
  public boolean equals(final Object o) {
    return compareTo((ParamWrapper)o) == 0;
  }

  @Override
  public String toString() {
    StringBuilder sb = new StringBuilder("ParamWrapper{");

    super.toStringSegment(sb);

    sb.append(", value=\"");
    sb.append(getValue());
    sb.append("\"");

    sb.append("}");

    return sb.toString();
  }
}
