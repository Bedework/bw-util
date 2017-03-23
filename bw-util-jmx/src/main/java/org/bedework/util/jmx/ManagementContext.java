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
 *
 * Stripped down version from apache activemq
 */
package org.bedework.util.jmx;

import org.bedework.util.misc.Util;

import org.apache.log4j.Logger;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.concurrent.atomic.AtomicBoolean;

import javax.management.JMException;
import javax.management.MBeanServer;
import javax.management.MBeanServerFactory;
import javax.management.MBeanServerInvocationHandler;
import javax.management.MalformedObjectNameException;
import javax.management.ObjectName;
import javax.management.QueryExp;

/**
 * Heavily modified version from activemq.
 *
 */
public class ManagementContext {
  private transient Logger log;

  /** Default jmx domain
   */
  public static final String DEFAULT_DOMAIN =
          System.getProperty("org.bedework.jmx.defaultdomain");

  /** I think we need this for the class loading
   */
  public static final boolean isJboss5 =
          Boolean.getBoolean("org.bedework.jmx.isJboss5");

  final static String JMI_DOMAIN = "JMImplementation";
  final static String MBEAN_REGISTRY = JMI_DOMAIN + ":type=MBeanRegistry";
  final static String CLASSLOADER =
          System.getProperty("org.bedework.jmx.classloader");

  private MBeanServer beanServer;
  private String jmxDomainName = DEFAULT_DOMAIN;
  private boolean useDomainSpecifiedForServer = false;

  private boolean useMBeanServer = true;
  private boolean createMBeanServer = true;
  private boolean locallyCreateMBeanServer;
  private AtomicBoolean started = new AtomicBoolean(false);
  private List<ObjectName> registeredMBeanNames =
          new CopyOnWriteArrayList<>();

  /**
   *
   */
  public ManagementContext() {
  }

  /**
   * @param domain name or null
   */
  public ManagementContext(final String domain) {
    setJmxDomainName(domain);
    useDomainSpecifiedForServer = domain != null;
  }

  /**
   * @param server an mbean server
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
        for (ObjectName name: registeredMBeanNames) {
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
   * @param val The jmxDomainName to set.
   */
  public void setJmxDomainName(final String val) {
    jmxDomainName = val;
  }

  /**
   * @return the jmxDomainName.
   */
  public String getJmxDomainName() {
    return jmxDomainName;
  }

  /**
   * Set the MBeanServer
   *
   * @param val the server
   */
  public void setMBeanServer(final MBeanServer val) {
    beanServer = val;
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
    String tmp = jmxDomainName + ":" +
                 "type=" + sanitizeString(type) +
                 ",name=" + sanitizeString(name);
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

  /**
   * @param part
   * @return encoded object name part
   */
  public static String encodeObjectNamePart(final String part) {
    // return ObjectName.quote(part);
    String answer = part.replaceAll("[\\:\\,\\'\\\"]", "_");
    answer = answer.replaceAll("\\?", "&qe;");
    answer = answer.replaceAll("=", "&amp;");
    answer = answer.replaceAll("\\*", "&ast;");
    return answer;
  }

  /**
   * Retrieve a System ObjectName
   *
   * @param domainName
   * @param containerName
   * @param theClass
   * @return the ObjectName
   * @throws MalformedObjectNameException
   */
  public static ObjectName getSystemObjectName(final String domainName,
                                               final String containerName,
                                               final Class theClass) throws MalformedObjectNameException {
    String tmp = domainName + ":" +
                 "type=" + theClass.getName() +
                 ",name=" + getRelativeName(containerName, theClass);
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
    return MBeanServerInvocationHandler.newProxyInstance(getMBeanServer(),
                                                         objectName,
                                                         interfaceClass,
                                                         notificationBroadcaster);

  }

  /**
   * @param name
   * @param attribute
   * @return attribute
   * @throws Exception
   */
  public Object getAttribute(final ObjectName name,
                             final String attribute) throws Exception {
    return getMBeanServer().getAttribute(name, attribute);
  }

  /**
   * @param bean to register
   * @param name its name
   * @throws Exception on error
   */
  public void registerMBean(final Object bean,
                            final ObjectName name) throws Exception {
    if (!isJboss5) {
      getMBeanServer().registerMBean(bean, name);
      registeredMBeanNames.add(name);
      return;
    }

    // See https://groups.google.com/forum/#!topic/mobicents-public/yiDzhnbQNvI
    final Map<String, Object> values = new HashMap<>();
    final ClassLoader classLoader = getClass().getClassLoader();
    info(String.format("Registering " + name +
                               " to JMX with classLoader [%s]",
                       classLoader.toString()));
    values.put(CLASSLOADER, classLoader);

    getMBeanServer().invoke(
            new ObjectName(MBEAN_REGISTRY),
            "registerMBean",
            new Object[] {bean,
                          name,
                          values },
            new String[] {Object.class.getName(),
                          ObjectName.class.getName(),
                          Map.class.getName() }
    );

    registeredMBeanNames.add(name);
  }

  /** Gets the names of MBeans controlled by the MBean server. This method enables any of the
   * following to be obtained: <ul>
   * <li>The names of all MBeans, </li>
   * <li>the names of a set of MBeans specified by pattern matching on the ObjectName and/or a Query expression, </li>
   * <li>a specific MBean name (equivalent to testing whether an MBean is registered).</li>
   * </ul>
   *
   * <p> When the object name is null or no domain and key properties are specified,
   * all objects are selected (and filtered if a query is specified). It returns the set of
   * ObjectNames for the MBeans selected.
   *
   * @param name
   * @param query
   * @return A set containing the ObjectNames for the MBeans selected. If no MBean
   *             satisfies the query, an empty list is returned.
   * @throws Exception
   */
  public Set queryNames(final ObjectName name,
                        final QueryExp query) throws Exception{
    return getMBeanServer().queryNames(name, query);
  }

  /**
   * Unregister an MBean
   *
   * @param name of mbean
   * @throws JMException
   */
  public void unregisterMBean(final ObjectName name) throws JMException {
    if ((beanServer != null) &&
        beanServer.isRegistered(name) &&
        registeredMBeanNames.remove(name)) {
      beanServer.unregisterMBean(name);
    }
  }

  protected synchronized MBeanServer findMBeanServer() {
    MBeanServer result = null;
    // create the mbean server
    try {
      if (useMBeanServer) {
        List<MBeanServer> list = MBeanServerFactory.findMBeanServer(null);
        if (!Util.isEmpty(list)) {
          // See if our domain is there
          MBeanServer mbsvr = null;

          for (MBeanServer svr: list) {
            if (jmxDomainName == null) {
              // Take first?
              return svr;
            }

            String svrDomain = svr.getDefaultDomain();
            if ((svrDomain != null) && svrDomain.equals(jmxDomainName)) {
              return svr;
            }
          }

          // Didn't find a match - can we use the default

          warn("Unable to locate mbean server for domain " +
              jmxDomainName);

          if (!useDomainSpecifiedForServer) {
            return list.get(0);
          }
        }
      }

      // Didn't find a match - can we create?

      if (createMBeanServer) {
        return createMBeanServer();
      }

      // Out of luck
    } catch (NoClassDefFoundError e) {
      error(e);
    } catch (Throwable e) {
      // probably don't have access to system properties
      error(e);
    }

    return null;
  }

  /**
   * @return a server
   * @throws NullPointerException
   * @throws MalformedObjectNameException
   * @throws IOException
   */
  protected MBeanServer createMBeanServer()
          throws MalformedObjectNameException, IOException {
    MBeanServer mbeanServer = MBeanServerFactory.createMBeanServer(jmxDomainName);
    locallyCreateMBeanServer = true;

    return mbeanServer;
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
