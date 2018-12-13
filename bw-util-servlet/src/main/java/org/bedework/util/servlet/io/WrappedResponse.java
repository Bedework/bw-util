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
package org.bedework.util.servlet.io;

import org.bedework.util.logging.BwLogger;
import org.bedework.util.logging.Logged;

import java.io.IOException;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServletResponseWrapper;

/** This class provides a useful form of the wrapped response.
 */
public class WrappedResponse extends HttpServletResponseWrapper
        implements Logged {
  /** Constructor
   *
   * @param response an http response
   */
  public WrappedResponse(final HttpServletResponse response) {
    super(response);
    setLoggerClass();
  }

  @Override
  public void sendError(final int sc) throws IOException {
    super.sendError(sc);
    if (debug()) {
      debug("sendError(" + sc + ")");
    }
  }

  @Override
  public void setStatus(final int sc) {
    super.setStatus(sc);
    if (debug()) {
      debug("setStatus(" + sc + ")");
    }
  }

  @Override
  public void addHeader(final String name, final String value) {
    super.addHeader(name, value);
    if (debug()) {
      debug("addHeader(\"" + name + "\", \"" + value + "\")");
    }
  }

  @Override
  public void setHeader(final String name, final String value) {
    super.setHeader(name, value);
    if (debug()) {
      debug("setHeader(\"" + name + "\", \"" + value + "\")");
    }
  }

  @Override
  public int getBufferSize() {
    return 0;
  }

  @Override
  public void flushBuffer() {
    if (debug()) {
      debug("flushBuffer called");
    }
  }

  /* We should probably have a setCharacterEncoding method as well and
   * subclasses can use the current character encoding to convert to String
   *
   * (non-Javadoc)
   * @see javax.servlet.ServletResponse#setContentType(java.lang.String)
   */
  @Override
  public void setContentType(final String type) {
    getResponse().setContentType(type);
    //if (debug) {
    //  getLogger().debug("setContentType(\"" + type + "\")");
    //}
  }

  /**
   *
   */
  public void close() {
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

