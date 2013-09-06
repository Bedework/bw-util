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
package edu.rpi.sss.util.http.service;

import edu.rpi.cmt.config.ConfInfo;
import edu.rpi.cmt.jmx.MBeanInfo;

import java.io.Serializable;

/** Information to access the synch engine
 *
 * @author Mike Douglass
 */
@ConfInfo(elementName = "synch")
public interface HttpConfig extends Serializable {
  /**
   * @param val maximum allowable overall
   */
  void setMaxConnections(int val);

  /**
   * @return maximim allowable overall
   */
  @MBeanInfo("Max connections.")
  int getMaxConnections();

  /**
   * @param val maximum allowable per route
   */
  void setDefaultMaxPerRoute(final int val);

  /**
   * @return current default
   */
  @MBeanInfo("Maximum allowable per route.")
  int getDefaultMaxPerRoute();
}
