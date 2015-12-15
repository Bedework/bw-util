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
package org.bedework.util.jmx;

/** Base class for JMX configuration beans
 *
 * @author douglm
 */
public interface BaseMBean {
  /* ========================================================================
   * Attributes
   * ======================================================================== */

  /**
   * @return name defined for service.
   */
  @MBeanInfo("Service name: used to register this service")
  String getServiceName();

  /**
   *
   * @return "Done", "Failed", "Running", "Stopped"
   */
  @MBeanInfo("Current status code")
  String getStatus();

  /* ========================================================================
   * Operations
   * ======================================================================== */

   /** Lifecycle
   *
   */
  @MBeanInfo("Start the service")
  void start();

  /** Lifecycle
   *
   */
  @MBeanInfo("Stop the service")
  void stop();

  /** Lifecycle
   *
   * @return true if service running
   */
  @MBeanInfo("Show if service is running")
  boolean isRunning();
}
