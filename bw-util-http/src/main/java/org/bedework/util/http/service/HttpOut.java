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
package org.bedework.util.http.service;

import org.bedework.util.http.PooledHttpClient;
import org.bedework.util.jmx.ConfBase;
import org.bedework.util.logging.BwLogger;

import org.apache.http.pool.PoolStats;

/**
 * @author douglm
 *
 */
public class HttpOut extends ConfBase<HttpConfigImpl>
        implements HttpOutMBean {
  /**
   * @param confuriPname
   * @param domain e.g. org.bedework.bwengine
   * @param serviceName
   */
  public HttpOut(final String confuriPname,
                 final String domain,
                 final String serviceName) {
    super();

    setConfigName(serviceName);

    setConfigPname(confuriPname);
    setServiceName(domain + ":service=" + serviceName);
  }

  @Override
  public void setMaxConnections(final int val) {
    getConfig().setMaxConnections(val);
    PooledHttpClient.setMaxConnections(val);
  }

  @Override
  public int getMaxConnections() {
    return PooledHttpClient.getMaxConnections();
  }

  @Override
  public void setDefaultMaxPerRoute(final int val) {
    getConfig().setDefaultMaxPerRoute(val);
    PooledHttpClient.setDefaultMaxPerRoute(val);
  }

  @Override
  public int getDefaultMaxPerRoute() {
    return PooledHttpClient.getDefaultMaxPerRoute();
  }

  @Override
  public void disableSSL() {
/*    try {
      new PooledHttpClient(0).disableSSL();
    } catch (Throwable t) {
      error(t);
    }*/
  }

  /*
  @Override
  public void setDefaultMaxPerHost(final int val) {
    PooledHttpClient.setDefaultMaxPerHost(val);
  }

  /* *
   * @return max
   * /
  @Override
  public int getDefaultMaxPerHost() {
    return PooledHttpClient.getDefaultMaxPerHost();
  }

  @Override
  public long getCreated() {
    return PooledHttpClient.getCreated();
  }

  @Override
  public long getDeleted() {
    return PooledHttpClient.getDeleted();
  }

  @Override
  public List<String> getLimits() {
    return PooledHttpClient.getCurrentLimits();
  }
  */

  /* ========================================================================
   * Operations
   * ======================================================================== */

  @Override
  public PoolStats getConnStats() {
    return PooledHttpClient.getConnStats();
  }

  /*
  @Override
  public void setHostLimit(final String host, final int max) {
    PooledHttpClient.setHostLimit(fromUrl(host), max);
  }

  @Override
  public int getHostLimit(final String host) {
    return PooledHttpClient.getHostLimit(fromUrl(host));
  }

  @Override
  public void addHost(final String host, final int limit) {
  }

  @Override
  public void deleteHost(final String val) {
  }
  */

  @Override
  public String loadConfig() {
    String res = loadConfig(HttpConfigImpl.class);

    refresh();

    return res;
  }

  /* ====================================================================
   *                   Private methods
   * ==================================================================== */

  private void refresh() {
    PooledHttpClient.setMaxConnections(getConfig().getMaxConnections());
    PooledHttpClient.setDefaultMaxPerRoute(getConfig().getDefaultMaxPerRoute());
  }

  /* ====================================================================
   *                   Logged methods
   * ==================================================================== */

  private BwLogger logger = new BwLogger();

  @Override
  public BwLogger getLogger() {
    if ((logger.getLoggedClass() == null) && (logger.getLoggedName() == null)) {
      logger.setLoggedClass(getClass());
    }

    return logger;
  }
}
