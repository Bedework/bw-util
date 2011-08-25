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
package edu.rpi.cmt.jboss;

import org.jboss.mx.util.MBeanProxyExt;
import org.jboss.mx.util.MBeanServerLocator;

import javax.management.MBeanServer;

/** For the moment (?) this will be JBoss (5) specific. later we may manage to make
 * it less dependent on jboss.
 *
 * @author douglm
 *
 */
public class MBeanUtil {
  private static Object synchThis = new Object();

  private static MBeanServer mbeanServer;

  /** Create a proxy to the given mbean
   *
   * @param c
   * @param name
   * @return proxy to the mbean
   * @throws Throwable
   */
  public static Object getMBean(final Class c,
                                final String name) throws Throwable {
    MBeanServer server = getMbeanServer();

    return MBeanProxyExt.create(c, name, server);
  }

  private static MBeanServer getMbeanServer() {
    synchronized (synchThis) {
      if (mbeanServer != null) {
        return mbeanServer;
      }

      mbeanServer = MBeanServerLocator.locate();
    }

    return mbeanServer;
  }
}
