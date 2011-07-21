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
import org.oasis_open.docs.ns.wscal.calws_soap.ObjectFactory;
import org.oasis_open.docs.ns.wscal.calws_soap.SelectElementType;

import ietf.params.xml.ns.icalendar_2.IcalendarType;
import ietf.params.xml.ns.icalendar_2.VcalendarType;

/** This class compares 2 components.
*
* @author Mike Douglass
*/
public class XmlIcalCompare {
  protected transient Logger log;

  /**
   */
  public XmlIcalCompare() {
  }

  /** Compare the parameters. Return null for equal or a select element.
   *
   * @param of - so we can get soap elements
   * @param newval
   * @param oldval
   * @return SelectElementType if val1 and val2 differ else null.
   */
  public SelectElementType diff(final ObjectFactory of,
                                final IcalendarType newval,
                                final IcalendarType oldval) {
    VcalendarType nv = newval.getVcalendar().get(0);
    VcalendarType ov = oldval.getVcalendar().get(0);

    CompWrapper ncw = new CompWrapper(of,
                                      CompWrapper.compNames.get(nv.getClass()),
                                      nv);
    CompWrapper ocw = new CompWrapper(of,
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

  private void trace(final String msg) {
    getLogger().debug(msg);
  }
}
