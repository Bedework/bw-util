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

import edu.rpi.cmt.calendar.XcalUtil;
import edu.rpi.sss.util.Util;
import edu.rpi.sss.util.xml.tagdefs.XcalTags;

import org.oasis_open.docs.ns.wscal.calws_soap.ComponentReferenceType;
import org.oasis_open.docs.ns.wscal.calws_soap.ComponentSelectionType;
import org.oasis_open.docs.ns.wscal.calws_soap.ComponentsSelectionType;
import org.oasis_open.docs.ns.wscal.calws_soap.ObjectFactory;
import org.oasis_open.docs.ns.wscal.calws_soap.PropertiesSelectionType;

import ietf.params.xml.ns.icalendar_2.ActionPropType;
import ietf.params.xml.ns.icalendar_2.ArrayOfProperties;
import ietf.params.xml.ns.icalendar_2.BaseComponentType;
import ietf.params.xml.ns.icalendar_2.DaylightType;
import ietf.params.xml.ns.icalendar_2.RecurrenceIdPropType;
import ietf.params.xml.ns.icalendar_2.StandardType;
import ietf.params.xml.ns.icalendar_2.UidPropType;
import ietf.params.xml.ns.icalendar_2.ValarmType;
import ietf.params.xml.ns.icalendar_2.VcalendarType;
import ietf.params.xml.ns.icalendar_2.VeventType;
import ietf.params.xml.ns.icalendar_2.VfreebusyType;
import ietf.params.xml.ns.icalendar_2.VjournalType;
import ietf.params.xml.ns.icalendar_2.VtimezoneType;
import ietf.params.xml.ns.icalendar_2.VtodoType;

import java.util.HashMap;
import java.util.Map;

import javax.xml.bind.JAXBElement;
import javax.xml.namespace.QName;

/** This class wraps a component.
 *
 * @author Mike Douglass
 */
class CompWrapper extends BaseEntityWrapper<CompWrapper,
                                            CompsWrapper,
                                            BaseComponentType> implements Comparable<CompWrapper> {
  private PropsWrapper props;
  private CompsWrapper comps;

  private Integer kind;

  static Map<Class, QName> compNames = new HashMap<Class, QName>();

  public static final Integer OuterKind = 0;
  public static final Integer RecurringKind = 1;
  public static final Integer UidKind = 2;
  public static final Integer AlarmKind = 3;
  public static final Integer TzKind = 4;

  static Map<QName, Integer> compKinds = new HashMap<QName, Integer>();

  static {
    // Outer container
    addInfo(XcalTags.vcalendar,
            OuterKind,
            VcalendarType.class);

    // Recurring style uid + optional recurrence id
    addInfo(XcalTags.vtodo,
            RecurringKind,
            VtodoType.class);
    addInfo(XcalTags.vjournal,
            RecurringKind,
            VjournalType.class);
    addInfo(XcalTags.vevent,
            RecurringKind,
            VeventType.class);

    // Uid only
    addInfo(XcalTags.vfreebusy,
            UidKind,
            VfreebusyType.class);

    addInfo(XcalTags.valarm,
            AlarmKind,
            ValarmType.class);

    // Timezones
    addInfo(XcalTags.standard,
            TzKind,
            StandardType.class);
    addInfo(XcalTags.vtimezone,
            TzKind,
            VtimezoneType.class);
    addInfo(XcalTags.daylight,
            TzKind,
            DaylightType.class);
  }

  CompWrapper(final CompsWrapper parent,
              final QName name,
              final BaseComponentType c) {
    super(parent, name, c);

    if (c.getProperties() != null) {
      props = new PropsWrapper(this, c.getProperties().getBasePropertyOrTzid());
    }
    comps = new CompsWrapper(this, XcalUtil.getComponents(c));

    kind = compKinds.get(name);
  }

  CompWrapper(final ObjectFactory of,
              final ValueMatcher matcher,
              final QName name,
              final BaseComponentType c) {
    super(null, name, c);

    setObjectFactory(of);
    setMatcher(matcher);

    if (c.getProperties() != null) {
      props = new PropsWrapper(this, c.getProperties().getBasePropertyOrTzid());
    }
    comps = new CompsWrapper(this, XcalUtil.getComponents(c));

    kind = compKinds.get(name);
  }

  @Override
  QName getMappedName(final QName name) {
    return null;
  }

  ComponentReferenceType makeRef() {
    ComponentReferenceType r = new ComponentReferenceType();

    r.setBaseComponent(getJaxbElement());
    return r;
  }

  @Override
  boolean sameEntity(final BaseEntityWrapper val) {
    int res = super.compareNameClass(val);
    if (res != 0) {
      return false;
    }

    CompWrapper that = (CompWrapper)val;

    if (!kind.equals(that.kind)) {
      return false;
    }

    if (kind == OuterKind) {
      return true;
    }

    if (kind == TzKind) {
      // Not dealing with that
      return true;
    }

    if (kind == AlarmKind) {
      PropWrapper thatw = that.props.find(XcalTags.action);
      PropWrapper thisw = props.find(XcalTags.action);

      String thatAction = ((ActionPropType)thatw.getEntity()).getText();
      String thisAction = ((ActionPropType)thisw.getEntity()).getText();

      if (!thatAction.equals(thisAction)) {
        return false;
      }

      return true;
    }

    // Get uid and see if it matches.
    PropWrapper thatUidw = that.props.find(XcalTags.uid);
    PropWrapper thisUidw = props.find(XcalTags.uid);

    String thatUid = ((UidPropType)thatUidw.getEntity()).getText();
    String thisUid = ((UidPropType)thisUidw.getEntity()).getText();

    if (!thatUid.equals(thisUid)) {
      return false;
    }

    if (kind == UidKind) {
      return true;
    }

    return cmpRids(that) == 0;
  }

  private int cmpRids(final CompWrapper that) {
    PropWrapper thatRidw = that.props.find(XcalTags.recurrenceId);
    PropWrapper thisRidw = props.find(XcalTags.recurrenceId);

    if ((thisRidw == null) && (thatRidw == null)) {
      return 0;
    }

    if (thisRidw == null) {
      return -1;
    }

    if (thatRidw == null) {
      return 1;
    }

    RecurrenceIdPropType thatRid = (RecurrenceIdPropType)thatRidw.getEntity();
    RecurrenceIdPropType thisRid = (RecurrenceIdPropType)thisRidw.getEntity();

    XcalUtil.DtTzid thatDtTzid = XcalUtil.getDtTzid(thatRid);
    XcalUtil.DtTzid thisDtTzid = XcalUtil.getDtTzid(thisRid);

    int res = thatDtTzid.dt.compareTo(thisDtTzid.dt);

    if (res != 0) {
      return res;
    }

    return Util.cmpObjval(thisDtTzid.tzid, thatDtTzid.tzid);
  }

  /**
   * @return props wrapper
   */
  public PropsWrapper getProps() {
    return props;
  }

  /**
   * @return comps wrapper
   */
  public CompsWrapper getComps() {
    return comps;
  }

  /** Return a SelectElementType if the values differ. This object
   * represents the new state
   *
   * @param that - the old version
   * @return SelectElementType
   */
  public ComponentSelectionType diff(final CompWrapper that) {
    ComponentSelectionType sel = null;

    if (props != null) {
      PropertiesSelectionType psel = props.diff(that.props);

      if (psel != null) {
        sel = that.getSelect(sel);

        sel.setProperties(psel);
      }
    }

    ComponentsSelectionType csel = comps.diff(that.comps);

    if (csel != null) {
      sel = that.getSelect(sel);

      sel.setComponents(csel);
    }

    return sel;
  }

  @Override
  @SuppressWarnings("unchecked")
  JAXBElement<? extends BaseComponentType> getJaxbElement() {
    if (kind != OuterKind) {
      return super.getJaxbElement();
    }

    /* Only want the outer element for this class */
    BaseComponentType bct = new VcalendarType();
    return new JAXBElement<BaseComponentType>(getName(),
        (Class<BaseComponentType>)bct.getClass(),
                                    bct);
  }

  ComponentSelectionType getSelect(final ComponentSelectionType val) {
    if (val != null) {
      return val;
    }

    ComponentSelectionType sel = new ComponentSelectionType();

    sel.setBaseComponent(getJaxbElement());

    if ((kind == OuterKind) || (kind == TzKind)) {
      return sel;
    }

    /* Add extra information to identify the component */

    BaseComponentType bct = sel.getBaseComponent().getValue();
    ArrayOfProperties bprops = new ArrayOfProperties();
    bct.setProperties(bprops);

    if (kind == AlarmKind) {
      PropWrapper pw = props.find(XcalTags.action);

      bprops.getBasePropertyOrTzid().add(pw.getJaxbElement());

      bprops.getBasePropertyOrTzid().add(pw.getJaxbElement());

      return sel;
    }

    PropWrapper pw = props.find(XcalTags.uid);
    bprops.getBasePropertyOrTzid().add(pw.getJaxbElement());

    if (kind == UidKind) {
      return sel;
    }

    pw = props.find(XcalTags.recurrenceId);

    if (pw != null) {
      bprops.getBasePropertyOrTzid().add(pw.getJaxbElement());
    }

    return sel;
  }

  @Override
  public int compareTo(final CompWrapper o) {
    int res = super.compareTo(o);
    if (res != 0) {
      return res;
    }

    res = getEntity().getClass().getName().compareTo(o.getEntity().getClass().getName());

    if (res != 0) {
      return res;
    }

    /* We want to guarantee a certain ordering for components so that we can
     * make appropriate assumptions when diffing. For Events, ToDos and Journals
     * we need to order by uid then recurrence-id and finally by the (other)
     * properties.
     *
     * For Alarms we order by time.
     */

    res = kind.compareTo(o.kind);
    if (res != 0) {
      return res;
    }

    if ((kind == OuterKind) || (kind == TzKind)) {
      return props.compareTo(o.props);
    }

    if (kind == AlarmKind) {
      res = o.props.find(XcalTags.action).compareTo(props.find(XcalTags.action));
      if (res != 0) {
        return res;
      }

      res = o.props.find(XcalTags.trigger).compareTo(props.find(XcalTags.trigger));
      if (res != 0) {
        return res;
      }

      return props.compareTo(o.props);
    }

    res = o.props.find(XcalTags.uid).compareTo(props.find(XcalTags.uid));
    if (res != 0) {
      return res;
    }

    if (kind == UidKind) {
      return props.compareTo(o.props);
    }

    res = cmpRids(o);

    if (res != 0) {
      return res;
    }

    return props.compareTo(o.props);
  }

  @Override
  public int hashCode() {
    return getName().hashCode() * props.hashCode();
  }

  @Override
  public boolean equals(final Object o) {
    return compareTo((CompWrapper)o) == 0;
  }

  @Override
  public String toString() {
    StringBuilder sb = new StringBuilder("CompWrapper{");

    super.toStringSegment(sb);

    sb.append(", props=");
    sb.append(props);
    sb.append("\n, comps=");
    sb.append(comps);

    sb.append("}");

    return sb.toString();
  }

  private static void addInfo(final QName nm, final Integer kind, final Class cl) {
    compNames.put(cl, nm);
    compKinds.put(nm, kind);
  }
}
