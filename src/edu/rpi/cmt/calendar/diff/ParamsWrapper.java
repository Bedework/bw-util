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

import ietf.params.xml.ns.icalendar_2.BaseParameterType;
import ietf.params.xml.ns.icalendar_2.Parameters;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.xml.bind.JAXBElement;
import javax.xml.namespace.QName;

/** This class wraps an array of parameters.
 *
 * @author Mike Douglass
 */
class ParamsWrapper extends BaseSetWrapper<ParamWrapper, PropWrapper,
                                          JAXBElement<? extends BaseParameterType>>
                    implements Comparable<ParamsWrapper> {
  private Parameters aop;

  ParamsWrapper(final PropWrapper parent,
                final Parameters aop) {
    super(parent, new QName(icalendarNs, "parameters"));
    this.aop = aop;

    if (this.aop == null) {
      return;
    }

    init();
  }

  @Override
  List<JAXBElement<? extends BaseParameterType>> getListT() {
    return aop.getBaseParameters();
  }

  @Override
  ParamWrapper[] getTarray(final int len) {
    return new ParamWrapper[len];
  }

  @Override
  ParamWrapper getWrapped(final JAXBElement<? extends BaseParameterType> el) {
    return new ParamWrapper(this, el.getName(), el.getValue());
  }

  public List<BaseEntityWrapper> diff(final ParamsWrapper that) {
    List<BaseEntityWrapper> updates = new ArrayList<BaseEntityWrapper>();

    int thatI = 0;
    int thisI = 0;

    while ((thisI < size()) && (thatI < that.size())) {
      ParamWrapper thisOne = getTarray()[thisI];
      ParamWrapper thatOne = that.getTarray()[thatI];

      if (thisOne.equals(thatOne)) {
        thisI++;
        thatI++;
        continue;
      }

      /* I think it's true that we can only have a single occurence of a
       * parameter name. We can make use of that here
       */

      int ncmp = thisOne.compareNames(thatOne);

      if (ncmp == 0) {
        // Names match - it's a modify
        thisOne.diff(thatOne);
        updates.add(thatOne);
      } else if (ncmp < 0) {
        // in this but not that - addition
        thisOne.setAdd(true);
        updates.add(thisOne);
        thisI++;
      } else {
        // in that but not this - deletion
        thatOne.setDelete(true);
        updates.add(thatOne);
        thatI++;
      }
    }

    while (thisI < size()) {
      // Extra ones in the source

      ParamWrapper thisOne = getTarray()[thisI];
      thisOne.setAdd(true);
      updates.add(thisOne);
      thisI++;
    }

    while (thatI < that.size()) {
      // Extra ones in the target

      ParamWrapper thatOne = that.getTarray()[thatI];
      thatOne.setDelete(true);
      updates.add(thatOne);
      thatI++;
    }

    return updates;
  }

  public int compareTo(final ParamsWrapper that) {
    if (size() < that.size()) {
      return -1;
    }

    if (size() > that.size()) {
      return 1;
    }

    Iterator<ParamWrapper> it = that.getEls().iterator();

    for (ParamWrapper p: getEls()) {
      ParamWrapper thatP = it.next();

      int res = p.compareTo(thatP);

      if (res != 0) {
        return res;
      }
    }

    return 0;
  }

  @Override
  public String toString() {
    StringBuilder sb = new StringBuilder("ParamsWrapper{");

    super.toStringSegment(sb);
    sb.append("}");

    return sb.toString();
  }
}
