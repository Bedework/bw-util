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
package org.bedework.util.misc;

import org.apache.log4j.Logger;

import java.util.HashMap;
import java.util.Map;

/** This class provides basic logging support. It also allows for some
 * log messages to be output to multiple loggers.
 *
 * Each stream will be for this class possible prefixed by name + ".".
 * 
 * @author douglm
 */
public class Logged {
  protected boolean debug;

  private transient Logger log;
  
  private final Map<String, Logger> loggers = new HashMap<>(5);
  
  public final String errorLoggerName = "errors";
  public final String auditLoggerName = "audit"; // INFO only
  public final String metricsLoggerName = "metrics"; // INFO only

  protected Logged() {
    debug = getLogger().isDebugEnabled();
  }

  /**
   * @return Logger
   */
  protected Logger getLogger() {
    if (log == null) {
      log = Logger.getLogger(this.getClass());
    }

    return log;
  }

  /**
   * @return Logger
   */
  protected Logger getLogger(final String name) {
    Logger theLogger = loggers.get(name);
    if (theLogger != null) {
      return theLogger;
    }
    
    theLogger = Logger.getLogger(name + "." + this.getClass().getName());

    loggers.put(name, theLogger);
    
    return theLogger;
  }
  
  @SuppressWarnings("unused")
  protected void enableErrorLogger() {
    getLogger(errorLoggerName);
  }

  @SuppressWarnings("unused")
  protected void enableAuditLogger() {
    getLogger(auditLoggerName);
  }

  @SuppressWarnings("unused")
  protected void enableMetricsLogger() {
    getLogger(metricsLoggerName);
  }

  @SuppressWarnings("unused")
  protected boolean isErrorLoggerEnabled() {
    return getLogger(errorLoggerName) != null;
  }

  @SuppressWarnings("unused")
  protected boolean isAuditLoggerEnabled() {
    return getLogger(auditLoggerName) != null;
  }

  @SuppressWarnings("unused")
  protected boolean isMetricsLoggerEnabled() {
    return getLogger(metricsLoggerName) != null;
  }

  protected Logger getErrorLoggerIfEnabled() {
    return loggers.get(errorLoggerName);
  }

  @SuppressWarnings("unused")
  protected Logger getAuditLoggerIfEnabled() {
    return loggers.get(auditLoggerName);
  }

  @SuppressWarnings("unused")
  protected Logger getMetricsLoggerIfEnabled() {
    return loggers.get(metricsLoggerName);
  }

  /**
   * @param t exception
   */
  protected void error(final Throwable t) {
    getLogger().error(this, t);

    final Logger errorLogger = getErrorLoggerIfEnabled();
    
    if (errorLogger != null) {
      errorLogger.error(this, t);
    }
  }

  /**
   * @param msg to output
   */
  protected void error(final String msg) {
    getLogger().error(msg);

    final Logger errorLogger = getErrorLoggerIfEnabled();

    if (errorLogger != null) {
      errorLogger.error(msg);
    }
  }

  /**
   * @param msg to output
   */
  protected void warn(final String msg) {
    getLogger().warn(msg);
  }

  /**
   * @param msg to output
   */
  protected void info(final String msg) {
    getLogger().info(msg);
  }

  /**
   * @param msg to output
   */
  @SuppressWarnings("unused")
  protected void audit(final String msg) {
    if (isAuditLoggerEnabled()) {
      getLogger(auditLoggerName).info(msg);
    }
  }

  /**
   * @param msg to output
   */
  @SuppressWarnings("unused")
  protected void metrics(final String msg) {
    if (isMetricsLoggerEnabled()) {
      getLogger(metricsLoggerName).info(msg);
    }
  }

  /**
   * @param msg to output
   */
  protected void debug(final String msg) {
    getLogger().debug(msg);
  }
}
