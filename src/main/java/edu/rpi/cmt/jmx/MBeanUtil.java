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
package edu.rpi.cmt.jmx;

import javax.management.JMX;
import javax.management.MBeanAttributeInfo;
import javax.management.MBeanServer;
import javax.management.MBeanServerFactory;
import javax.management.ObjectName;

/**
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
  @SuppressWarnings("unchecked")
  public static Object getMBean(final Class c,
                                final String name) throws Throwable {
    MBeanServer server = getMbeanServer();

//    return MBeanProxyExt.create(c, name, server);
    return JMX.newMBeanProxy(server, new ObjectName(name), c);
  }

  /**
   * @param name
   * @param desc
   * @return MBeanAttributeInfo for a string
   */
  public static MBeanAttributeInfo stringAttrInfo(final String name,
                                                  final String desc) {
    return new MBeanAttributeInfo(name,
                                  "java.lang.String",
                                  desc,
                                  true,   // isReadable
                                  true,   // isWritable
                                  false); // isIs;
  }

  /**
   * @param name
   * @param desc
   * @return MBeanAttributeInfo for a boolean value
   */
  public static MBeanAttributeInfo boolAttrInfo(final String name,
                                                final String desc) {
    return new MBeanAttributeInfo(name,
                                  "boolean",
                                  desc,
                                  true,   // isReadable
                                  true,   // isWritable
                                  false); // isIs;
  }

  private static MBeanServer getMbeanServer() {
    synchronized (synchThis) {
      if (mbeanServer != null) {
        return mbeanServer;
      }

//      mbeanServer = MBeanServerLocator.locate();
      mbeanServer = MBeanServerFactory.findMBeanServer(null).iterator().next();
    }

    return mbeanServer;
  }
}
