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

import org.bedework.util.config.ConfigBase;
import org.bedework.util.config.ConfigException;
import org.bedework.util.config.ConfigurationFileStore;
import org.bedework.util.config.ConfigurationStore;
import org.bedework.util.misc.Logged;
import org.bedework.util.misc.Util;

import org.apache.log4j.Logger;

import java.io.File;
import java.io.FileReader;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;
import java.util.concurrent.CopyOnWriteArraySet;

import javax.management.MalformedObjectNameException;
import javax.management.ObjectName;

/** A configuration has a name and a location. The location can be specified in
 * a number of ways: <ul>
 * <li>An absolute path to the directory containing the config</li>
 * <li>Through definitions in a property file</li>
 * </ul>
 *
 * <p>The property file approach uses the system property <br/>
 * <em>org.bedework.config.pfile</em><br/>
 * which provides
 * the absolute path to a property file which may be fetched via http or
 * read as a local file.
 * </p>
 *
 * <p>
 *   This file has properties defined for each configuration and
 *   some global to all<ul>
 * <li><em>org.bedework.config.base</em> if provided defines a base for
 * all configs which will be prepended</li>
 * <li><em>One or more config paths</em>The name of each is specified
 * by the configPname field for the mbean. If a config base is provided
 * this will be appended to that to give a absolute path</li>
 * </ul>
 * </p>
 *
 * <p>An example file may look like:
 * <pre>
 org.bedework.config.base=file://$JBOSS_SERVER_DIR/conf/bedework/

 #         Calendar clients config dir
 org.bedework.clients.confuri=client-configs

 #         Calendar core config dir
 org.bedework.bwcore.confuri=bwcore

 #         Calendar engine config dir
 org.bedework.bwengine.confuri=bwengine

 #         carddav conf dir
 org.bedework.carddav.confuri=carddavConfig

 #         hosts conf dir
 org.bedework.hosts.confuri=hosts

 #         selfreg conf dir
 org.bedework.selfreg.confuri=selfreg

 #         synch conf dir
 org.bedework.synch.confuri=synch

 #         tzsvr conf dir
 org.bedework.tzs.confuri=tzsvr

 * </pre>
 *
 * </p>
 *
 * <p>Each may be augmented by providing a path suffix - used to add additional
 * path elements to the base path.
 *
 * @author douglm
 * @param <T>
 *
 */
public abstract class ConfBase<T extends ConfigBase> extends Logged
        implements ConfBaseMBean {
  public static final String statusDone = "Done";
  public static final String statusFailed = "Failed";
  public static final String statusRunning = "Running";
  public static final String statusStopped = "Stopped";
  public static final String statusTimedout = "Timedout";
  public static final String statusInterrupted = "Interrupted";
  public static final String statusUnknown = "Unknown";

  protected T cfg;

  private String configName;

  /* The absolute path to the directory */
  private String configuri;

  private String status = statusUnknown;

  private static volatile Object pfileLock = new Object();

  private static Properties pfile;

  private final static String pfilePname = "org.bedework.config.pfile";

  private final static String configBasePname = "org.bedework.config.base";

  /* From the pfile */
  private static String configBase;
  private static boolean configBaseIsFile;
  private static boolean configBaseIsHttp;

  private static final List<String> httpSchemes;

  static {
    List<String> hs = new ArrayList<>();

    hs.add("http");
    hs.add("https");

    httpSchemes = Collections.unmodifiableList(hs);
  }

  /* The property which defines the path - possibly relative */
  private String configPname;

  private String pathSuffix;

  private static Set<ObjectName> registeredMBeans = new CopyOnWriteArraySet<ObjectName>();

  private static ManagementContext managementContext;

  private String serviceName;

  private ConfigurationStore store;

  /** At least setServiceName MUST be called
   *
   */
  protected ConfBase() {
  }

  protected ConfBase(final String serviceName) {
    this.serviceName = serviceName;
  }

  /**
   * @param val IDENTICAL to that defined for service.
   */
  public void setServiceName(final String val) {
    serviceName = val;
  }

  @Override
  public String getServiceName() {
    return serviceName;
  }

  /**
   * @param val a status.
   */
  public void setStatus(final String val) {
    status = val;
  }

  @Override
  public String getStatus() {
    return status;
  }

  @Override
  public void start() {
  }

  @Override
  public void stop() {
  }

  @Override
  public boolean isRunning() {
    return true;
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
      getPfile();

      String configPname = getConfigPname();

      if (configPname == null) {
        throw new ConfigException("Either a uri or property name must be specified");
      }

      uriStr = pfile.getProperty(configPname);
      if (uriStr == null) {
        /* If configPname ends with ".confuri" we'll take the 
           preceding segment as a possible directory
         */
        if (configPname.endsWith(".confuri")) {
          final int lastDotpos = configPname.length() - 8;
          final int pos = configPname
                  .lastIndexOf('.', lastDotpos - 1);
          if (pos > 0) {
            uriStr = configPname.substring(pos + 1, lastDotpos);
          }
        }
      }
      
      if (uriStr == null) {
        throw new ConfigException("No property with name \"" +
                                          configPname + "\"");
      }
    }

    try {
      URI uri= new URI(uriStr);

      String scheme = uri.getScheme();

      if (scheme == null) {
        // Possible non-absolute path
        String path = uri.getPath();

        File f = new File(path);
        if (!f.isAbsolute() && configBase != null) {
          path = configBase + path;
        }

        uri= new URI(path);
        scheme = uri.getScheme();
      }

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
    } catch (URISyntaxException use) {
      throw new ConfigException(use);
    }
  }

  /**
   * @return the object we are managing
   */
  public T getConfig() {
    return cfg;
  }

  /** (Re)load the configuration
   *
   * @return status
   */
  @MBeanInfo("(Re)load the configuration")
  public abstract String loadConfig();

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
      T config = getConfig();
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

  private void getPfile() throws ConfigException {
    if (pfile != null) {
      return;
    }

    String pfileUri = System.getProperty(pfilePname);

    if (pfileUri == null) {
      throw new ConfigException("No property with name \"" +
                                        pfilePname + "\"");
    }

    try {
/*
      URI uri;
      uri = new URI(pfileUri);

      String scheme = uri.getScheme();

      if ((scheme == null) || (scheme.equals("file"))) {
        */
      String path = pfileUri;
      File f = new File(path);
      if (!f.exists()) {
        throw new ConfigException("No configuration pfile at " + path);
      }

      if (!f.isFile()) {
        throw new ConfigException(path + " is not a file");
      }

      final Util.PropertiesPropertyFetcher ppf =
              new Util.PropertiesPropertyFetcher(System.getProperties());

        synchronized (pfileLock) {
          if (pfile != null) {
            // Someone beat us to it
            return;
          }

          pfile = new Properties();
          pfile.load(new FileReader(f));

          /* Do any property replacement on values */
          Set pfileNames = pfile.keySet();

          for (Object o: pfileNames) {
            pfile.put(o, Util.propertyReplace(pfile.getProperty((String)o),
                                              ppf));
          }

          configBase = pfile.getProperty(configBasePname);

          URI uri = new URI(configBase);
          String scheme = uri.getScheme();

          if ((scheme == null) || (scheme.equals("file"))) {
            configBase = uri.getPath();
            configBaseIsFile = true;
          } else if (httpSchemes.contains(scheme)) {
            configBaseIsHttp = true;
          } else {
            throw new ConfigException("Unsupported scheme in " + uri);
          }
        }

/*        return;
      }

      throw new ConfigException("Unsupported configuration pfile: " + uri);
      */
    } catch (ConfigException ce) {
      throw ce;
    } catch (Throwable t) {
      throw new ConfigException(t);
    }
  }

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
   * @return config identified by current config name
   */
  protected T getConfigInfo(final Class<T> cl)throws ConfigException  {
    return getConfigInfo(getStore(), getConfigName(), cl);
  }

  /**
   * @return current state of config
   */
  protected T getConfigInfo(final String configName,
                            final Class<T> cl)throws ConfigException  {
    return getConfigInfo(getStore(), configName, cl);
  }

  @SuppressWarnings("unchecked")
  protected T getConfigInfo(final ConfigurationStore cfs,
                            final String configName,
                            final Class<T> cl) throws ConfigException  {
    try {
      /* Try to load it */

      return (T)cfs.getConfig(configName, cl);
    } catch (ConfigException cfe) {
      throw cfe;
    } catch (Throwable t) {
      throw new ConfigException(t);
    }
  }

  /**
   * @param cl
   * @return config identified by current config name
   */
  protected String loadConfig(final Class<T> cl) {
    try {
      /* Load up the config */

      cfg = getConfigInfo(cl);

      if (cfg == null) {
        return "Unable to read configuration";
      }

      return "OK";
    } catch (Throwable t) {
      error("Failed to load configuration: " + t.getLocalizedMessage());
      error(t);
      return "failed";
    }
  }

  /** Load the configuration if we only expect one and we don't care or know
   * what it's called.
   *
   * @param cl
   * @return null for success or an error message (logged already)
   */
  protected String loadOnlyConfig(final Class<T> cl) {
    try {
      /* Load up the config */

      ConfigurationStore cs = getStore();

      List<String> configNames = cs.getConfigs();

      if (configNames.isEmpty()) {
        error("No configuration on path " + cs.getLocation());
        return "No configuration on path " + cs.getLocation();
      }

      if (configNames.size() != 1) {
        error("1 and only 1 configuration allowed");
        return "1 and only 1 configuration allowed";
      }

      String configName = configNames.iterator().next();

      cfg = getConfigInfo(cs, configName, cl);

      if (cfg == null) {
        error("Unable to read configuration");
        return "Unable to read configuration";
      }

      setConfigName(configName);

      return null;
    } catch (Throwable t) {
      error("Failed to load configuration: " + t.getLocalizedMessage());
      error(t);
      return "failed";
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
      warn("Failed to register MBean: " + key + ": " + e.getLocalizedMessage());
      if (debug) {
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
        if (debug) {
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
      /* Try to find the jboss mbean server * /

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
      */
      managementContext = new ManagementContext(ManagementContext.DEFAULT_DOMAIN);
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
}
