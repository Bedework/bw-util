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
import edu.rpi.sss.util.xml.NsContext;
import edu.rpi.sss.util.xml.tagdefs.XcalTags;

import ietf.params.xml.ns.icalendar_2.BaseComponentType;
import ietf.params.xml.ns.icalendar_2.DaylightType;
import ietf.params.xml.ns.icalendar_2.StandardType;
import ietf.params.xml.ns.icalendar_2.ValarmType;
import ietf.params.xml.ns.icalendar_2.VcalendarType;
import ietf.params.xml.ns.icalendar_2.VeventType;
import ietf.params.xml.ns.icalendar_2.VfreebusyType;
import ietf.params.xml.ns.icalendar_2.VjournalType;
import ietf.params.xml.ns.icalendar_2.VtimezoneType;
import ietf.params.xml.ns.icalendar_2.VtodoType;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.xml.namespace.QName;

/** This class wraps a property.
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
    props = new PropsWrapper(this, c.getProperties().getBasePropertyOrTzid());
    comps = new CompsWrapper(this, XcalUtil.getComponents(c));

    kind = compKinds.get(name);
  }

  @Override
  QName getMappedName(final QName name) {
    return null;
  }

  @Override
  ValueType getUpdateValue() {
    return null;
  }


  @Override
  public void appendXpathElement(final StringBuilder sb,
                                 final NsContext nsContext) {
    appendNsName(sb, nsContext);

    if ((kind == OuterKind) || (kind == TzKind)) {
      return;
    }

    if (kind == AlarmKind) {
      sb.append("[");

      PropWrapper pw = props.find(XcalTags.action);

      props.appendXpathElement(sb, nsContext);
      sb.append("/");
      pw.appendXpathElement(sb, nsContext);

      sb.append(" and ");

      pw = props.find(XcalTags.trigger);

      props.appendXpathElement(sb, nsContext);
      sb.append("/");
      pw.appendXpathElement(sb, nsContext);

      sb.append("]");

      return;
    }

    sb.append("[");

    PropWrapper pw = props.find(XcalTags.uid);

    props.appendXpathElement(sb, nsContext);
    sb.append("/");
    pw.appendXpathElement(sb, nsContext);

    if (kind == UidKind) {
      sb.append("]");

      return;
    }

    sb.append(" and ");

    pw = props.find(XcalTags.recurrenceId);

    if (pw != null) {
      props.appendXpathElement(sb, nsContext);
      sb.append("/");
      pw.appendXpathElement(sb, nsContext);
    } else {
      sb.append("not (");
      props.appendXpathElement(sb, nsContext);
      sb.append("/");
      nsContext.appendNsName(sb, XcalTags.recurrenceId);
      sb.append(")");
    }

    sb.append("]");
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

      if (!thatw.getValue().equals(thisw.getValue())) {
        return false;
      }

      return true;
    }

    // Get uid and see if it matches.
    PropWrapper thatUidw = that.props.find(XcalTags.uid);
    PropWrapper thisUidw = props.find(XcalTags.uid);

    if (!thatUidw.getValue().equals(thisUidw.getValue())) {
      return false;
    }

    if (kind == UidKind) {
      return true;
    }

    PropWrapper thatRidw = that.props.find(XcalTags.recurrenceId);
    PropWrapper thisRidw = props.find(XcalTags.recurrenceId);

    if ((thisRidw == null) && (thatRidw == null)) {
      return true;
    }

    if ((thisRidw == null) || (thatRidw == null)) {
      return false;
    }

    return thatRidw.getValue().equals(thisRidw.getValue());
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

  /** Creates a diff value if the values differ. Sets that.diffVal
   *
   * @param that
   * @return List<BaseEntityWrapper>
   */
  public List<BaseEntityWrapper> diff(final CompWrapper that) {
    List<BaseEntityWrapper> u = props.diff(that.props);
    u.addAll(comps.diff(that.comps));

    return u;
  }

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

    res = o.props.find(XcalTags.uid).compareTo(props.find(XcalTags.uid));
    if (res != 0) {
      return res;
    }

    PropWrapper thatRidw = o.props.find(XcalTags.recurrenceId);
    PropWrapper thisRidw = props.find(XcalTags.recurrenceId);

    if ((thisRidw == null) && (thatRidw == null)) {
      res = 0;
    } else if (thisRidw == null) {
      res = -1;
    } else if (thatRidw == null) {
      res = 1;
    } else {
      res = thisRidw.getValue().compareTo(thatRidw.getValue());
    }

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
