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

import org.bedework.util.xml.tagdefs.XcalTags;

import ietf.params.xml.ns.icalendar_2.BaseComponentType;
import org.oasis_open.docs.ws_calendar.ns.soap.ComponentReferenceType;
import org.oasis_open.docs.ws_calendar.ns.soap.ComponentSelectionType;
import org.oasis_open.docs.ws_calendar.ns.soap.ComponentsSelectionType;

import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;

import javax.xml.bind.JAXBElement;

/** This class wraps an array of components.
 *
 * @author Mike Douglass
 */
class CompsWrapper extends BaseSetWrapper<CompWrapper, CompWrapper,
                                          JAXBElement<? extends BaseComponentType>>
                   implements Comparable<CompsWrapper> {
  CompsWrapper(final CompWrapper parent,
               final List<JAXBElement<? extends BaseComponentType>> clist) {
    super(parent, XcalTags.components, clist);
  }

  @Override
  CompWrapper[] getTarray(final int len) {
    return new CompWrapper[len];
  }

  @Override
  Set<CompWrapper> getWrapped(final JAXBElement<? extends BaseComponentType> el) {
    Set<CompWrapper> res = new TreeSet<CompWrapper>();

    res.add(new CompWrapper(this, el.getName(), el.getValue()));

    return res;
  }

  public ComponentsSelectionType diff(final CompsWrapper that) {
    ComponentsSelectionType sel = null;

    int thatI = 0;
    int thisI = 0;

    while ((thisI < size()) && (thatI < that.size())) {
      CompWrapper thisOne = getTarray()[thisI];
      CompWrapper thatOne = that.getTarray()[thatI];

      if (thisOne.sameEntity(thatOne)) {
        // For events for example that would be uid and recurrence id match

        ComponentSelectionType csel = thisOne.diff(thatOne);
        if (csel != null) {
          sel = select(sel, csel);
        }

        thisI++;
        thatI++;
        continue;
      }

      /* We can make use of special knowledge e.g components can only contain
       * alarms.
       *
       * This will probably break when we get other component types, e.g VPOLL
       */

      /* Scan down that side to see if we can find a matching
       * component. All the intermediate ones we find would then be marked for
       * deletion.
       *
       * If that doesn't find a match, scan down this side to see if we can
       * match thatOne. If we find a match the intermediate ones would then be
       * marked for addition.
       *
       * We only need to scan so far. The items are all ordered so we should be
       * able to do a simple comparison as an initial test.
       *
       * A value change is an update to the property, a parameter change might
       * be an add, update or mod.
       */

      int cmp = thisOne.compareTo(thatOne);

      if (cmp < 0) {
        // Add this side entry

        sel = add(sel, thisOne.makeRef(false));
        thisI++;
        continue;
      }

      if (cmp == 0) {
        // Screwed up somewhere
        throw new RuntimeException("Comparison == 0: that's not right");
      }

      // Extra ones in the target

      sel = remove(sel, thatOne.makeRef(true));
      thatI++;
    }

    while (thisI < size()) {
      // Extra ones in the source

      CompWrapper thisOne = getTarray()[thisI];
      sel = add(sel, thisOne.makeRef(false));
      thisI++;
    }

    while (thatI < that.size()) {
      // Extra ones in the target

      CompWrapper thatOne = that.getTarray()[thatI];
      sel = remove(sel, thatOne.makeRef(true));
      thatI++;
    }

    return sel;
  }

  ComponentsSelectionType getSelect(final ComponentsSelectionType val) {
    if (val != null) {
      return val;
    }

    ComponentsSelectionType sel = new ComponentsSelectionType();

    return sel;
  }

  ComponentsSelectionType add(final ComponentsSelectionType sel,
                              final ComponentReferenceType val) {
    ComponentsSelectionType csel = getSelect(sel);

    csel.getAdd().add(val);

    return csel;
  }

  ComponentsSelectionType remove(final ComponentsSelectionType sel,
                                 final ComponentReferenceType val) {
    ComponentsSelectionType csel = getSelect(sel);

    csel.getRemove().add(val);

    return csel;
  }

  ComponentsSelectionType select(final ComponentsSelectionType sel,
                                 final ComponentSelectionType val) {
    ComponentsSelectionType csel = getSelect(sel);

    csel.getComponent().add(val);

    return csel;
  }

  @Override
  public int compareTo(final CompsWrapper that) {
    if (size() < that.size()) {
      return -1;
    }

    if (size() > that.size()) {
      return 1;
    }

    Iterator<CompWrapper> it = that.getEls().iterator();

    for (CompWrapper c: getEls()) {
      CompWrapper thatC = it.next();

      int res = c.compareTo(thatC);

      if (res != 0) {
        return res;
      }
    }

    return 0;
  }

  @Override
  public String toString() {
    StringBuilder sb = new StringBuilder("CompsWrapper{");

    super.toStringSegment(sb);
    sb.append("}");

    return sb.toString();
  }
}
