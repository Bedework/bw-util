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

import ietf.params.xml.ns.icalendar_2.ArrayOfComponents;
import ietf.params.xml.ns.icalendar_2.ArrayOfProperties;
import ietf.params.xml.ns.icalendar_2.BaseComponentType;
import ietf.params.xml.ns.icalendar_2.BasePropertyType;
import ietf.params.xml.ns.icalendar_2.Icalendar;
import ietf.params.xml.ns.icalendar_2.Vcalendar;

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
  public static BaseComponentType findComponent(final Icalendar ical,
                                                final QName name) {
    for (Vcalendar v: ical.getVcalendars()) {
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

  /**
   * @param bcPar
   * @param name
   * @return null or first matching component
   */
  public static BaseComponentType findComponent(final BaseComponentType bcPar,
                                                final QName name) {
    ArrayOfComponents cs = bcPar.getComponents();
    if (cs == null) {
      return null;
    }

    for (JAXBElement<? extends BaseComponentType> bcel: cs.getBaseComponents()) {
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
  public static BaseComponentType findEntity(final Icalendar ical) {
    if (ical == null) {
      return null;
    }

    for (Vcalendar v: ical.getVcalendars()) {
      ArrayOfComponents cs = v.getComponents();
      if (cs == null) {
        continue;
      }

      for (JAXBElement<? extends BaseComponentType> bcel: cs.getBaseComponents()) {
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

    for (JAXBElement<? extends BasePropertyType> bpel: ps.getBaseProperties()) {
      if (bpel.getName().equals(name)) {
        return bpel.getValue();
      }
    }

    return null;
  }

}
