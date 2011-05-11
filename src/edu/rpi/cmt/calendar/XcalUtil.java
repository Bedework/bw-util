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
package edu.rpi.cmt.calendar;

import edu.rpi.sss.util.xml.tagdefs.XcalTags;

import ietf.params.xml.ns.icalendar_2.ArrayOfProperties;
import ietf.params.xml.ns.icalendar_2.ArrayOfVcalendarContainedComponents;
import ietf.params.xml.ns.icalendar_2.AvailableType;
import ietf.params.xml.ns.icalendar_2.BaseComponentType;
import ietf.params.xml.ns.icalendar_2.BasePropertyType;
import ietf.params.xml.ns.icalendar_2.DaylightType;
import ietf.params.xml.ns.icalendar_2.EventTodoComponentType;
import ietf.params.xml.ns.icalendar_2.IcalendarType;
import ietf.params.xml.ns.icalendar_2.StandardType;
import ietf.params.xml.ns.icalendar_2.ValarmType;
import ietf.params.xml.ns.icalendar_2.VavailabilityType;
import ietf.params.xml.ns.icalendar_2.VcalendarType;
import ietf.params.xml.ns.icalendar_2.VeventType;
import ietf.params.xml.ns.icalendar_2.VtimezoneType;
import ietf.params.xml.ns.icalendar_2.VtodoType;

import java.util.ArrayList;
import java.util.List;

import javax.xml.bind.JAXBElement;
import javax.xml.namespace.QName;

/**
 * @author douglm
 *
 */
public class XcalUtil {
  /**
   * @param ical
   * @param name
   * @return null or first matching component
   */
  public static BaseComponentType findComponent(final IcalendarType ical,
                                                final QName name) {
    for (VcalendarType v: ical.getVcalendar()) {
      if (name.equals(XcalTags.vcalendar)) {
        return v;
      }

      BaseComponentType bc = findComponent(v, name);
      if (bc != null) {
        return bc;
      }
    }

    return null;
  }

  /** Get enclosed components for the supplied component.
   *
   * @param c
   * @return list of components or null for none or unrecognized class.
   */
  public static List<JAXBElement<? extends BaseComponentType>> getComponents(final BaseComponentType c) {
    if (c instanceof VcalendarType) {
      VcalendarType vc = (VcalendarType)c;

      if (vc.getComponents() == null) {
        return null;
      }

      return new ArrayList<JAXBElement<? extends BaseComponentType>>(
        vc.getComponents().getVcalendarContainedComponent());
    }

    if ((c instanceof VeventType) ||
        (c instanceof VtodoType)) {
      EventTodoComponentType etc = (EventTodoComponentType)c;

      if ((etc.getComponents() == null) ||
          (etc.getComponents().getValarm().size() == 0)) {
        return null;
      }

      ArrayList<JAXBElement<? extends BaseComponentType>> res =
        new ArrayList<JAXBElement<? extends BaseComponentType>>();

      for (ValarmType va: etc.getComponents().getValarm()) {
        res.add(new JAXBElement<ValarmType>(XcalTags.valarm,
            ValarmType.class, va));
      }

      return res;
    }

    if (c instanceof VavailabilityType) {
      VavailabilityType vav = (VavailabilityType)c;

      if ((vav.getComponents() == null) ||
          (vav.getComponents().getAvailable().size() == 0)) {
        return null;
      }

      ArrayList<JAXBElement<? extends BaseComponentType>> res =
        new ArrayList<JAXBElement<? extends BaseComponentType>>();

      for (AvailableType a: vav.getComponents().getAvailable()) {
        res.add(new JAXBElement<AvailableType>(XcalTags.available,
            AvailableType.class, a));
      }

      return res;
    }

    if (c instanceof VtimezoneType) {
      VtimezoneType etc = (VtimezoneType)c;

      if ((etc.getComponents() == null) ||
          (etc.getComponents().getStandardOrDaylight().size() == 0)) {
        return null;
      }

      ArrayList<JAXBElement<? extends BaseComponentType>> res =
        new ArrayList<JAXBElement<? extends BaseComponentType>>();

      for (BaseComponentType bc: etc.getComponents().getStandardOrDaylight()) {
        QName nm;
        if (bc instanceof DaylightType) {
          nm = XcalTags.daylight;
        } else if (bc instanceof StandardType) {
          nm = XcalTags.standard;
        } else {
          continue;
        }

        res.add(new JAXBElement<BaseComponentType>(nm,
            (Class<BaseComponentType>)bc.getClass(), bc));
      }

      return res;
    }

    return null;
  }

  /**
   * @param bcPar
   * @param name
   * @return null or first matching component
   */
  public static BaseComponentType findComponent(final BaseComponentType bcPar,
                                                final QName name) {
    List<JAXBElement<? extends BaseComponentType>> cs = getComponents(bcPar);
    if (cs == null) {
      return null;
    }

    for (JAXBElement<? extends BaseComponentType> bcel: cs) {
      if (bcel.getName().equals(name)) {
        return bcel.getValue();
      }

      BaseComponentType bc = findComponent(bcel.getValue(), name);
      if (bc != null) {
        return bc;
      }
    }

    return null;
  }

  /**
   * @param ical
   * @return null or first contained entity
   */
  public static BaseComponentType findEntity(final IcalendarType ical) {
    if (ical == null) {
      return null;
    }

    for (VcalendarType v: ical.getVcalendar()) {
      ArrayOfVcalendarContainedComponents cs = v.getComponents();
      if (cs == null) {
        continue;
      }

      for (JAXBElement<? extends BaseComponentType> bcel: cs.getVcalendarContainedComponent()) {
        return bcel.getValue();
      }
    }

    return null;
  }

  /** Searches this entity for the named property. Does not recurse down.
   *
   * @param bcPar
   * @param name
   * @return null or first matching property
   */
  public static BasePropertyType findProperty(final BaseComponentType bcPar,
                                              final QName name) {
    if (bcPar == null) {
      return null;
    }

    ArrayOfProperties ps = bcPar.getProperties();
    if (ps == null) {
      return null;
    }

    for (JAXBElement<? extends BasePropertyType> bpel: ps.getBaseProperty()) {
      if (bpel.getName().equals(name)) {
        return bpel.getValue();
      }
    }

    return null;
  }

}
