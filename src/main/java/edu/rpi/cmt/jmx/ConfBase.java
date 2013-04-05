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

import java.io.File;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.CopyOnWriteArraySet;

import javax.management.MBeanServer;
import javax.management.MBeanServerFactory;
import javax.management.MalformedObjectNameException;
import javax.management.ObjectName;

import org.apache.log4j.Logger;

import edu.rpi.cmt.config.ConfigBase;
import edu.rpi.cmt.config.ConfigException;
import edu.rpi.cmt.config.ConfigurationFileStore;
import edu.rpi.cmt.config.ConfigurationStore;
import edu.rpi.cmt.config.ConfigurationType;

/** A configuration has a name and a location. The location can be specified in
 * a number of ways: <ul>
 * <li>An absolute path to the directory containing the config</li>
 * <li>An http url(soon)</li>
 * <li>A system property name</li>
 * </ul>
 *
 * <p>Each may be augmented by providing a path suffix - used to add additional
 * path elements to the base path.
 *
 * @author douglm
 * @param <T>
 *
 */
public abstract class ConfBase<T extends ConfigBase> implements ConfBaseMBean {
  private transient Logger log;

  protected boolean debug;

  private String configName;

  private String configuri;

  private String configPname;

  private String pathSuffix;

  private static Set<ObjectName> registeredMBeans = new CopyOnWriteArraySet<ObjectName>();

  private static ManagementContext managementContext;

  private ConfigurationType config;

  private String serviceName;

  private ConfigurationStore store;

  protected ConfBase(final String serviceName) {
    this.serviceName = serviceName;
    debug = getLogger().isDebugEnabled();
  }

  /**
   * @return name IDENTICAL to that defined for service.
   */
  public String getServiceName() {
    return serviceName;
  }

  /** Specify the absolute path to the configuration directory.
   *
   * @param val
   */
  public void setConfigUri(final String val) {
    configuri = val;
    store = null;
  }

  /**
   * @return String path to configs
   */
  public String getConfigUri() {
    return configuri;
  }

  /** Specify a system property giving the absolute path to the configuration directory.
   *
   * @param val
   */
  public void setConfigPname(final String val) {
    configPname = val;
    store = null;
  }

  /**
   * @return String name of system property
   */
  public String getConfigPname() {
    return configPname;
  }

  /** Specify a suffix to the path to the configuration directory.
   *
   * @param val
   */
  public void setPathSuffix(final String val) {
    pathSuffix = val;
    store = null;
  }

  /**
   * @return String path suffix to configs
   */
  public String getPathSuffix() {
    return pathSuffix;
  }

  /** Set a ConfigurationStore
   *
   * @param val
   */
  public void setStore(final ConfigurationStore val) {
    store = val;
  }

  /** Get a ConfigurationStore based on the uri or property value.
   *
   * @return store
   * @throws ConfigException
   */
  public ConfigurationStore getStore() throws ConfigException {
    if (store != null) {
      return store;
    }

    String uriStr = getConfigUri();

    if (uriStr == null) {
      if (getConfigPname() == null) {
        throw new ConfigException("Either a uri or property name must be specified");
      }

      uriStr = System.getProperty(getConfigPname());
      if (uriStr == null) {
        throw new ConfigException("No property with name \"" + getConfigPname() + "\"");
      }
    }

    URI uri;
    try {
      uri = new URI(uriStr);
    } catch (URISyntaxException use) {
      throw new ConfigException(use);
    }

    String scheme = uri.getScheme();

    if ((scheme == null) || (scheme.equals("file"))) {
      String path = uri.getPath();

      if (getPathSuffix() != null) {
        if (!path.endsWith(File.separator)) {
          path += File.separator;
        }

        path += getPathSuffix() + File.separator;
      }

      store = new ConfigurationFileStore(path);
      return store;
    }

    throw new ConfigException("Unsupported ConfigurationStore: " + uri);
  }

  /**
   * @return the object we are managing
   */
  public abstract ConfigurationType getConfigObject();

  protected Set<ObjectName> getRegisteredMBeans() {
    return registeredMBeans;
  }

  /* ========================================================================
   * Attributes
   * ======================================================================== */

  @Override
  public void setConfigName(final String val) {
    configName = val;
  }

  @Override
  public String getConfigName() {
    return configName;
  }

  /* ========================================================================
   * Operations
   * ======================================================================== */

  @Override
  public String saveConfig() {
    try {
      ConfigurationType config = getConfigObject();
      if (config == null) {
        return "No configuration to save";
      }

      ConfigurationStore cs = getStore();

      config.setName(configName);

      cs.saveConfiguration(config);

      return "saved";
    } catch (Throwable t) {
      error(t);
      return t.getLocalizedMessage();
    }
  }

  /* ====================================================================
   *                   Private methods
   * ==================================================================== */

  /* ====================================================================
   *                   JMX methods
   * ==================================================================== */

  /* */
  private ObjectName serviceObjectName;

  protected void register(final String serviceType,
                       final String name,
                       final Object view) {
    try {
      ObjectName objectName = createObjectName(serviceType, name);
      register(objectName, view);
    } catch (Throwable t) {
      error("Failed to register " + serviceType + ":" + name);
      error(t);
    }
  }

  protected void unregister(final String serviceType,
                            final String name) {
    try {
      ObjectName objectName = createObjectName(serviceType, name);
      unregister(objectName);
    } catch (Throwable t) {
      error("Failed to unregister " + serviceType + ":" + name);
      error(t);
    }
  }

  protected ObjectName getServiceObjectName() throws MalformedObjectNameException {
    if (serviceObjectName == null) {
      serviceObjectName = new ObjectName(getServiceName());
    }

    return serviceObjectName;
  }

  protected ObjectName createObjectName(final String serviceType,
                                        final String name) throws MalformedObjectNameException {
    // Build the object name for the bean
    Map props = getServiceObjectName().getKeyPropertyList();
    ObjectName objectName = new ObjectName(getServiceObjectName().getDomain() + ":" +
        "service=" + props.get("service") + "," +
        "Type=" + ManagementContext.encodeObjectNamePart(serviceType) + "," +
        "Name=" + ManagementContext.encodeObjectNamePart(name));
    return objectName;
  }

  /* ====================================================================
   *                   Protected methods
   * ==================================================================== */

  /**
   * @return current state of config
   */
  protected synchronized T getConfigInfo(final ConfigurationStore cfs,
                                         final String configName,
                                         final Class<T> cl) {
    try {
      /* Try to load it */

      ConfigurationType config = cfs.getConfig(configName);

      if (config == null) {
        return null;
      }

      T cfg = (T)makeObject(cl.getCanonicalName());

      cfg.setConfig(config);

      return cfg;
    } catch (Throwable t) {
      error(t);
      return null;
    }
  }

  /**
   * @return current state of config
   */
  public synchronized ConfigurationType getConf() {
    try {
      if (config == null) {
        /* Try to load it */

        ConfigurationStore cs = getStore();

        config = cs.getConfig(getConfigName());
      }

      return config;
    } catch (Throwable t) {
      error(t);
      return null;
    }
  }

  /**
   * @param key
   * @param bean
   * @throws Exception
   */
  protected void register(final ObjectName key,
                          final Object bean) throws Exception {
    try {
      AnnotatedMBean.registerMBean(getManagementContext(), bean, key);
      getRegisteredMBeans().add(key);
    } catch (Throwable e) {
      warn("Failed to register MBean: " + key);
      if (getLogger().isDebugEnabled()) {
        error(e);
      }
    }
  }

  /**
   * @param key
   * @throws Exception
   */
  protected void unregister(final ObjectName key) throws Exception {
    if (getRegisteredMBeans().remove(key)) {
      try {
        getManagementContext().unregisterMBean(key);
      } catch (Throwable e) {
        warn("Failed to unregister MBean: " + key);
        if (getLogger().isDebugEnabled()) {
          error(e);
        }
      }
    }
  }

  /**
   * @return the management context.
   */
  public static ManagementContext getManagementContext() {
    if (managementContext == null) {
      /* Try to find the jboss mbean server */

      MBeanServer mbsvr = null;

      for (MBeanServer svr: MBeanServerFactory.findMBeanServer(null)) {
        if (svr.getDefaultDomain().equals("jboss")) {
          mbsvr = svr;
          break;
        }
      }

      if (mbsvr == null) {
        Logger.getLogger(ConfBase.class).warn("Unable to locate jboss mbean server");
      }
      managementContext = new ManagementContext(mbsvr);
    }
    return managementContext;
  }

  protected static Object makeObject(final String className) {
    try {
      Object o = Class.forName(className).newInstance();

      if (o == null) {
        Logger.getLogger(ConfBase.class).error("Class " + className + " not found");
        return null;
      }

      return o;
    } catch (Throwable t) {
      Logger.getLogger(ConfBase.class).error("Unable to make object ", t);
      return null;
    }
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
