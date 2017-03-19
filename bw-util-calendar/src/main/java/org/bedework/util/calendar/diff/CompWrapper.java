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

import org.bedework.util.calendar.XcalUtil;
import org.bedework.util.xml.tagdefs.XcalTags;

import ietf.params.xml.ns.icalendar_2.ActionPropType;
import ietf.params.xml.ns.icalendar_2.ArrayOfProperties;
import ietf.params.xml.ns.icalendar_2.BaseComponentType;
import ietf.params.xml.ns.icalendar_2.UidPropType;
import ietf.params.xml.ns.icalendar_2.VcalendarType;
import org.oasis_open.docs.ws_calendar.ns.soap.ComponentReferenceType;
import org.oasis_open.docs.ws_calendar.ns.soap.ComponentSelectionType;
import org.oasis_open.docs.ws_calendar.ns.soap.ComponentsSelectionType;
import org.oasis_open.docs.ws_calendar.ns.soap.PropertiesSelectionType;

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

  CompWrapper(final CompsWrapper parent,
              final QName name,
              final BaseComponentType c) {
    super(parent, name, c);

    if (c.getProperties() != null) {
      props = new PropsWrapper(this, c.getProperties().getBasePropertyOrTzid());
    }
    comps = new CompsWrapper(this, XcalUtil.getComponents(c));

    kind = XcalUtil.getCompKind(name);
  }

  CompWrapper(final XmlIcalCompare.Globals globals,
              final QName name,
              final BaseComponentType c) {
    super(null, name, c);

    setGlobals(globals);

    if (c.getProperties() != null) {
      props = new PropsWrapper(this, c.getProperties().getBasePropertyOrTzid());
    }
    comps = new CompsWrapper(this, XcalUtil.getComponents(c));

    kind = XcalUtil.getCompKind(name);
  }

  @Override
  QName getMappedName(final QName name) {
    return null;
  }

  @SuppressWarnings("unchecked")
  ComponentReferenceType makeRef(final boolean forRemove) {
    ComponentReferenceType r = new ComponentReferenceType();

    boolean wholeComponent = !forRemove;

    if (kind == XcalUtil.AlarmKind) {
      /* XXX This could be done by providing just enough to identify a single
       * alarm. The properties we need to test in order are:
       *
       * for all: action, trigger, duration, repeat
       * !audio: description
       * then: attach, summary, attendees
       *
       * After the first 4 it might just as well be the whole thing.
       */
      wholeComponent = true;
    }

    if (wholeComponent) {
      // Put the whole entity in there
      r.setBaseComponent(getJaxbElement());
      return r;
    }

    // Just enough information to identify the entity, e.g. uid and recurrence-id

    Class cl = getEntity().getClass();

    try {
      BaseComponentType copy = (BaseComponentType)cl.newInstance();

      copy.setProperties(new ArrayOfProperties());

      r.setBaseComponent(new JAXBElement<BaseComponentType>(getName(),
          (Class<BaseComponentType>)copy.getClass(),
          copy));

      if ((kind == XcalUtil.TzDaylight) ||
          (kind == XcalUtil.TzStandard)) {
        // DTSTART is the identifier
        PropWrapper dts = props.find(XcalTags.dtstart);

        if (dts == null) {
          throw new RuntimeException("No DTSTART for reference");
        }

        copy.getProperties().getBasePropertyOrTzid().add(dts.getJaxbElement());
        return r;
      }

      if (kind == XcalUtil.TzKind) {
        // TZid is the identifier
        PropWrapper tzidw = props.find(XcalTags.tzid);

        if (tzidw == null) {
          throw new RuntimeException("No tzid for reference");
        }

        copy.getProperties().getBasePropertyOrTzid().add(tzidw.getJaxbElement());
        return r;
      }

      PropWrapper uidw = props.find(XcalTags.uid);

      if (uidw == null) {
        throw new RuntimeException("No uid for reference");
      }

      copy.getProperties().getBasePropertyOrTzid().add(uidw.getJaxbElement());

      if (kind == XcalUtil.UidKind) {
        return r;
      }

      PropWrapper ridw = props.find(XcalTags.recurrenceId);
      if (ridw != null) {
        copy.getProperties().getBasePropertyOrTzid().add(ridw.getJaxbElement());
      }

      return r;
    } catch (Throwable t) {
      throw new RuntimeException(t);
    }
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

    if (kind == XcalUtil.OuterKind) {
      return true;
    }

    if ((kind == XcalUtil.TzKind) ||
        (kind == XcalUtil.TzDaylight) ||
        (kind == XcalUtil.TzStandard)) {
      // Not dealing with that
      return true;
    }

    if (kind == XcalUtil.AlarmKind) {
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

    if (kind == XcalUtil.UidKind) {
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

    return thatRidw.compareTo(thisRidw);
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
    if (kind != XcalUtil.OuterKind) {
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

    if ((kind == XcalUtil.OuterKind) ||
        (kind == XcalUtil.TzKind) ||
        (kind == XcalUtil.TzDaylight) ||
        (kind == XcalUtil.TzStandard)) {
      return sel;
    }

    /* Add extra information to identify the component */

    BaseComponentType bct = sel.getBaseComponent().getValue();
    ArrayOfProperties bprops = new ArrayOfProperties();
    bct.setProperties(bprops);

    if (kind == XcalUtil.AlarmKind) {
      PropWrapper pw = props.find(XcalTags.action);

      bprops.getBasePropertyOrTzid().add(pw.getJaxbElement());

      bprops.getBasePropertyOrTzid().add(pw.getJaxbElement());

      return sel;
    }

    PropWrapper pw = props.find(XcalTags.uid);
    bprops.getBasePropertyOrTzid().add(pw.getJaxbElement());

    if (kind == XcalUtil.UidKind) {
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

    if ((kind == XcalUtil.OuterKind) ||
        (kind == XcalUtil.TzKind) ||
        (kind == XcalUtil.TzDaylight) ||
        (kind == XcalUtil.TzStandard)) {
      return props.compareTo(o.props);
    }

    if (kind == XcalUtil.AlarmKind) {
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

    if (kind == XcalUtil.UidKind) {
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
}
