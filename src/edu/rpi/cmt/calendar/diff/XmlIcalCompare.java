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

import org.apache.log4j.Logger;
import org.oasis_open.docs.ns.wscal.calws_soap.ComponentSelectionType;
import org.oasis_open.docs.ns.wscal.calws_soap.ObjectFactory;

import ietf.params.xml.ns.icalendar_2.IcalendarType;
import ietf.params.xml.ns.icalendar_2.VcalendarType;

/** This class compares 2 components.
*
* @author Mike Douglass
*/
public class XmlIcalCompare {
  protected transient Logger log;

  private ValueMatcher matcher;

  /**
   */
  public XmlIcalCompare() {
    matcher = new ValueMatcher();
  }

  /**
   * @return object used to match values.
   */
  public ValueMatcher getMatcher() {
    return matcher;
  }

  /** Compare the parameters. Return null for equal or a select element.
   *
   * @param newval
   * @param oldval
   * @return SelectElementType if val1 and val2 differ else null.
   */
  public ComponentSelectionType diff(final IcalendarType newval,
                                     final IcalendarType oldval) {
    VcalendarType nv = newval.getVcalendar().get(0);
    VcalendarType ov = oldval.getVcalendar().get(0);

    ObjectFactory of = new ObjectFactory();

    CompWrapper ncw = new CompWrapper(of, getMatcher(),
                                      CompWrapper.compNames.get(nv.getClass()),
                                      nv);
    CompWrapper ocw = new CompWrapper(of, getMatcher(),
                                      CompWrapper.compNames.get(ov.getClass()),
                                      ov);

    return ncw.diff(ocw);
  }

  private Logger getLogger() {
    if (log == null) {
      log = Logger.getLogger(this.getClass());
    }

    return log;
  }

  @SuppressWarnings("unused")
  private void trace(final String msg) {
    getLogger().debug(msg);
  }
}
