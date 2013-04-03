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

import edu.rpi.sss.util.http.BasicHttpClient;

import org.apache.http.HttpHost;
import org.apache.http.pool.PoolStats;
import org.apache.log4j.Logger;

import java.net.URI;

/**
 * @author douglm
 *
 */
public class HttpOut implements HttpOutMBean {
  private transient Logger log;

  @Override
  public void setMaxConnections(final int val) {
    BasicHttpClient.setMaxConnections(val);
  }

  @Override
  public int getMaxConnections() {
    return BasicHttpClient.getMaxConnections();
  }

  @Override
  public PoolStats getConnStats() {
    return BasicHttpClient.getConnStats();
  }

  @Override
  public void setDefaultMaxPerRoute(final int val) {
    BasicHttpClient.setDefaultMaxPerRoute(val);
  }

  @Override
  public int getDefaultMaxPerRoute() {
    return BasicHttpClient.getDefaultMaxPerRoute();
  }

  /*
  @Override
  public void setDefaultMaxPerHost(final int val) {
    BasicHttpClient.setDefaultMaxPerHost(val);
  }

  /* *
   * @return max
   * /
  @Override
  public int getDefaultMaxPerHost() {
    return BasicHttpClient.getDefaultMaxPerHost();
  }

  @Override
  public long getCreated() {
    return BasicHttpClient.getCreated();
  }

  @Override
  public long getDeleted() {
    return BasicHttpClient.getDeleted();
  }

  @Override
  public List<String> getLimits() {
    return BasicHttpClient.getCurrentLimits();
  }
  */

  /* ========================================================================
   * Operations
   * ======================================================================== */

  /*
  @Override
  public void setHostLimit(final String host, final int max) {
    BasicHttpClient.setHostLimit(fromUrl(host), max);
  }

  @Override
  public int getHostLimit(final String host) {
    return BasicHttpClient.getHostLimit(fromUrl(host));
  }

  @Override
  public void addHost(final String host, final int limit) {
  }

  @Override
  public void deleteHost(final String val) {
  }
  */

  /* ========================================================================
   * Lifecycle
   * ======================================================================== */

  @Override
  public synchronized void start() {
  }

  @Override
  public synchronized void stop() {
  }

  @Override
  public boolean isStarted() {
    return true;
  }

  /* ====================================================================
   *                   Private methods
   * ==================================================================== */

  private HttpHost fromUrl(final String val) {
    URI uri = URI.create(val);

    return new HttpHost(uri.getHost(), uri.getPort(), uri.getScheme());
  }

  /* ====================================================================
   *                   Protected methods
   * ==================================================================== */

  protected void info(final String msg) {
    getLogger().info(msg);
  }

  protected void trace(final String msg) {
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
