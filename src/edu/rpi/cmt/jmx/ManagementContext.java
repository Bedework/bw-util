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
/**
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * Stripped down version from apache activemq
 */
package edu.rpi.cmt.jmx;

import org.apache.log4j.Logger;

import java.io.IOException;
import java.lang.reflect.Method;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.concurrent.atomic.AtomicBoolean;

import javax.management.JMException;
import javax.management.MBeanServer;
import javax.management.MBeanServerFactory;
import javax.management.MBeanServerInvocationHandler;
import javax.management.MalformedObjectNameException;
import javax.management.ObjectInstance;
import javax.management.ObjectName;
import javax.management.QueryExp;


/**
 * A Flow provides different dispatch policies within the NMR
 *
 * @org.apache.xbean.XBean
 * @version $Revision$
 */
public class ManagementContext {
  private transient Logger log;

  /**
   * Default activemq domain
   */
  public static final String DEFAULT_DOMAIN = "org.bedework";
  private MBeanServer beanServer;
  private String jmxDomainName = DEFAULT_DOMAIN;
  private boolean useMBeanServer = true;
  private boolean createMBeanServer = true;
  private boolean locallyCreateMBeanServer;
  private boolean findTigerMbeanServer = true;
  private int rmiServerPort;
  private AtomicBoolean started = new AtomicBoolean(false);
  private List<ObjectName> registeredMBeanNames = new CopyOnWriteArrayList<ObjectName>();

  /**
   *
   */
  public ManagementContext() {
    this(null);
  }

  /**
   * @param server
   */
  public ManagementContext(final MBeanServer server) {
    beanServer = server;
  }

  /**
   * @throws IOException
   */
  public void start() throws IOException {
    // lets force the MBeanServer to be created if needed
    if (started.compareAndSet(false, true)) {
      getMBeanServer();
    }
  }

  /**
   * @throws Exception
   */
  public void stop() throws Exception {
    if (started.compareAndSet(true, false)) {
      MBeanServer mbeanServer = getMBeanServer();
      if (mbeanServer != null) {
        for (Iterator<ObjectName> iter = registeredMBeanNames.iterator(); iter.hasNext();) {
          ObjectName name = iter.next();

          mbeanServer.unregisterMBean(name);

        }
      }
      registeredMBeanNames.clear();

      if (locallyCreateMBeanServer && (beanServer != null)) {
        // check to see if the factory knows about this server
        List list = MBeanServerFactory.findMBeanServer(null);
        if ((list != null) && !list.isEmpty() && list.contains(beanServer)) {
          MBeanServerFactory.releaseMBeanServer(beanServer);
        }
      }
      beanServer = null;
    }
  }

  /**
   * @return Returns the jmxDomainName.
   */
  public String getJmxDomainName() {
    return jmxDomainName;
  }

  /**
   * @param jmxDomainName The jmxDomainName to set.
   */
  public void setJmxDomainName(final String jmxDomainName) {
    this.jmxDomainName = jmxDomainName;
  }

  /**
   * Get the MBeanServer
   *
   * @return the MBeanServer
   */
  protected MBeanServer getMBeanServer() {
    if (beanServer == null) {
      beanServer = findMBeanServer();
    }
    return beanServer;
  }

  /**
   * Set the MBeanServer
   *
   * @param beanServer
   */
  public void setMBeanServer(final MBeanServer beanServer) {
    this.beanServer = beanServer;
  }

  /**
   * @return Returns the useMBeanServer.
   */
  public boolean isUseMBeanServer() {
    return useMBeanServer;
  }

  /**
   * @param useMBeanServer The useMBeanServer to set.
   */
  public void setUseMBeanServer(final boolean useMBeanServer) {
    this.useMBeanServer = useMBeanServer;
  }

  /**
   * @return Returns the createMBeanServer flag.
   */
  public boolean isCreateMBeanServer() {
    return createMBeanServer;
  }

  /**
   * @param enableJMX Set createMBeanServer.
   */
  public void setCreateMBeanServer(final boolean enableJMX) {
    createMBeanServer = enableJMX;
  }

  public boolean isFindTigerMbeanServer() {
    return findTigerMbeanServer;
  }

  /**
   * Enables/disables the searching for the Java 5 platform MBeanServer
   *
   * @param findTigerMbeanServer
   */
  public void setFindTigerMbeanServer(final boolean findTigerMbeanServer) {
    this.findTigerMbeanServer = findTigerMbeanServer;
  }

  /**
   * Formulate and return the MBean ObjectName of a custom control MBean
   *
   * @param type
   * @param name
   * @return the JMX ObjectName of the MBean, or <code>null</code> if
   *         <code>customName</code> is invalid.
   */
  public ObjectName createCustomComponentMBeanName(final String type, final String name) {
    ObjectName result = null;
    String tmp = jmxDomainName + ":" + "type=" + sanitizeString(type) + ",name=" + sanitizeString(name);
    try {
      result = new ObjectName(tmp);
    } catch (MalformedObjectNameException e) {
      error("Couldn't create ObjectName from: " + type + " , " + name);
    }
    return result;
  }

  /**
   * The ':' and '/' characters are reserved in ObjectNames
   *
   * @param in
   * @return sanitized String
   */
  private static String sanitizeString(final String in) {
    String result = null;
    if (in != null) {
      result = in.replace(':', '_');
      result = result.replace('/', '_');
      result = result.replace('\\', '_');
    }
    return result;
  }

  public static String encodeObjectNamePart(final String part) {
    // return ObjectName.quote(part);
    String answer = part.replaceAll("[\\:\\,\\'\\\"]", "_");
    answer = answer.replaceAll("\\?", "&qe;");
    answer = answer.replaceAll("=", "&amp;");
    answer = answer.replaceAll("\\*", "&ast;");
    return answer;
  }

  /**
   * Retrive an System ObjectName
   *
   * @param domainName
   * @param containerName
   * @param theClass
   * @return the ObjectName
   * @throws MalformedObjectNameException
   */
  public static ObjectName getSystemObjectName(final String domainName, final String containerName, final Class theClass) throws MalformedObjectNameException, NullPointerException {
    String tmp = domainName + ":" + "type=" + theClass.getName() + ",name=" + getRelativeName(containerName, theClass);
    return new ObjectName(tmp);
  }

  private static String getRelativeName(final String containerName, final Class theClass) {
    String name = theClass.getName();
    int index = name.lastIndexOf(".");
    if ((index >= 0) && ((index + 1) < name.length())) {
      name = name.substring(index + 1);
    }
    return containerName + "." + name;
  }

  /**
   * @param objectName
   * @param interfaceClass
   * @param notificationBroadcaster
   * @return new instance
   */
  @SuppressWarnings("unchecked")
  public Object newProxyInstance( final ObjectName objectName,
                                  final Class interfaceClass,
                                  final boolean notificationBroadcaster){
    return MBeanServerInvocationHandler.newProxyInstance(getMBeanServer(), objectName, interfaceClass, notificationBroadcaster);

  }

  /**
   * @param name
   * @param attribute
   * @return attribute
   * @throws Exception
   */
  public Object getAttribute(final ObjectName name, final String attribute) throws Exception{
    return getMBeanServer().getAttribute(name, attribute);
  }

  public ObjectInstance registerMBean(final Object bean, final ObjectName name) throws Exception{
    ObjectInstance result = getMBeanServer().registerMBean(bean, name);
    registeredMBeanNames.add(name);
    return result;
  }

  public Set queryNames(final ObjectName name, final QueryExp query) throws Exception{
    return getMBeanServer().queryNames(name, query);
  }

  /**
   * Unregister an MBean
   *
   * @param name
   * @throws JMException
   */
  public void unregisterMBean(final ObjectName name) throws JMException {
    if ((beanServer != null) && beanServer.isRegistered(name) && registeredMBeanNames.remove(name)) {
      beanServer.unregisterMBean(name);
    }
  }

  protected synchronized MBeanServer findMBeanServer() {
    MBeanServer result = null;
    // create the mbean server
    try {
      if (useMBeanServer) {
        if (findTigerMbeanServer) {
          result = findTigerMBeanServer();
        }
        if (result == null) {
          // lets piggy back on another MBeanServer -
          // we could be in an appserver!
          List list = MBeanServerFactory.findMBeanServer(null);
          if ((list != null) && (list.size() > 0)) {
            result = (MBeanServer)list.get(0);
          }
        }
      }
      if ((result == null) && createMBeanServer) {
        result = createMBeanServer();
      }
    } catch (NoClassDefFoundError e) {
      error(e);
    } catch (Throwable e) {
      // probably don't have access to system properties
      error(e);
    }
    return result;
  }

  public MBeanServer findTigerMBeanServer() {
    String name = "java.lang.management.ManagementFactory";
    Class type = loadClass(name, ManagementContext.class.getClassLoader());
    if (type != null) {
      try {
        Method method = type.getMethod("getPlatformMBeanServer", new Class[0]);
        if (method != null) {
          Object answer = method.invoke(null, new Object[0]);
          if (answer instanceof MBeanServer) {
            return (MBeanServer)answer;
          } else {
            warn("Could not cast: " + answer + " into an MBeanServer. There must be some classloader strangeness in town");
          }
        } else {
          warn("Method getPlatformMBeanServer() does not appear visible on type: " + type.getName());
        }
      } catch (Exception e) {
        error(e);
      }
    } else {
      debug("Class not found: " + name + " so probably running on Java 1.4");
    }
    return null;
  }

  private static Class loadClass(final String name, final ClassLoader loader) {
    try {
      return loader.loadClass(name);
    } catch (ClassNotFoundException e) {
      try {
        return Thread.currentThread().getContextClassLoader().loadClass(name);
      } catch (ClassNotFoundException e1) {
        return null;
      }
    }
  }

  /**
   * @return
   * @throws NullPointerException
   * @throws MalformedObjectNameException
   * @throws IOException
   */
  protected MBeanServer createMBeanServer() throws MalformedObjectNameException, IOException {
    MBeanServer mbeanServer = MBeanServerFactory.createMBeanServer(jmxDomainName);
    locallyCreateMBeanServer = true;

    return mbeanServer;
  }

  public int getRmiServerPort() {
    return rmiServerPort;
  }

  public void setRmiServerPort(final int rmiServerPort) {
    this.rmiServerPort = rmiServerPort;
  }

  protected void info(final String msg) {
    getLogger().info(msg);
  }

  protected void warn(final String msg) {
    getLogger().warn(msg);
  }

  protected void debug(final String msg) {
    getLogger().debug(msg);
  }

  protected void error(final Throwable t) {
    getLogger().error(this, t);
  }

  protected void error(final String msg) {
    getLogger().error(msg);
  }

  /* Get a logger for messages
   */
  protected Logger getLogger() {
    if (log == null) {
      log = Logger.getLogger(this.getClass());
    }

    return log;
  }
}
