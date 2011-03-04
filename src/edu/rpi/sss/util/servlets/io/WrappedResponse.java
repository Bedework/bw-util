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
package edu.rpi.sss.util.servlets.io;

import java.io.IOException;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServletResponseWrapper;
import org.apache.log4j.Logger;

/** This class provides a useful form of the wrapped response.
 */
public class WrappedResponse extends HttpServletResponseWrapper {
  protected boolean debug = false;

  private transient Logger log;

  /** Constructor
   *
   * @param response
   * @param debug
   */
  public WrappedResponse(HttpServletResponse response,
                         boolean debug) {
    this(response, null, debug);
  }

  /** Constructor
   *
   * @param response
   * @param log
   * @param debug
   */
  public WrappedResponse(HttpServletResponse response,
                         Logger log,
                         boolean debug) {
    super(response);
    this.log = log;
    this.debug = debug;
  }

  /* (non-Javadoc)
   * @see javax.servlet.http.HttpServletResponse#sendError(int)
   */
  public void sendError(int sc) throws IOException {
    super.sendError(sc);
    if (debug) {
      getLogger().debug("sendError(" + sc + ")");
    }
  }

  /* (non-Javadoc)
   * @see javax.servlet.http.HttpServletResponse#setStatus(int)
   */
  public void setStatus(int sc) {
    super.setStatus(sc);
    if (debug) {
      getLogger().debug("setStatus(" + sc + ")");
    }
  }

  /* (non-Javadoc)
   * @see javax.servlet.http.HttpServletResponse#addHeader(java.lang.String, java.lang.String)
   */
  public void addHeader(String name, String value) {
    super.addHeader(name, value);
    if (debug) {
      getLogger().debug("addHeader(\"" + name + "\", \"" + value + "\")");
    }
  }

  /* (non-Javadoc)
   * @see javax.servlet.http.HttpServletResponse#setHeader(java.lang.String, java.lang.String)
   */
  public void setHeader(String name, String value) {
    super.setHeader(name, value);
    if (debug) {
      getLogger().debug("setHeader(\"" + name + "\", \"" + value + "\")");
    }
  }

  /* (non-Javadoc)
   * @see javax.servlet.ServletResponse#getBufferSize()
   */
  public int getBufferSize() {
    return 0;
  }

  /* (non-Javadoc)
   * @see javax.servlet.ServletResponse#flushBuffer()
   */
  public void flushBuffer() {
    if (debug) {
      getLogger().debug("flushBuffer called");
    }
  }

  /* We should probably have a setCharacterEncoding method as well and
   * subclasses can use the current character encoding to convert to String
   *
   * (non-Javadoc)
   * @see javax.servlet.ServletResponse#setContentType(java.lang.String)
   */
  public void setContentType(String type) {
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

  /** Get a logger for messages
   *
   * @return Logger
   */
  protected Logger getLogger() {
    if (log == null) {
      log = Logger.getLogger(this.getClass());
    }

    return log;
  }
}

