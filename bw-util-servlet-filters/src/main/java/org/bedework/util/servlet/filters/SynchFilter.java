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
package org.bedework.util.servlet.filters;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

/** Class to force synchronization of requests.
 */
public class SynchFilter implements Filter {
  private ServletContext ctx;
  private boolean debug = false;

  /**
   * @param val
   */
  public void setDebug(boolean val) {
    debug = val;
  }

  /**
   * @return debug flag
   */
  public boolean getDebug() {
    return debug;
  }

  /* (non-Javadoc)
   * @see javax.servlet.Filter#init(javax.servlet.FilterConfig)
   */
  public void init(FilterConfig filterConfig) throws ServletException {
    ctx = filterConfig.getServletContext();
    String temp = filterConfig.getInitParameter("debug");
    debug = (String.valueOf(temp).equals("true"));
  }

  /** This method can be overridden to allow a subclass to set up ready for a
   *  transformation.
   *
   * @param   request    Incoming HttpServletRequest object
   * @throws ServletException
   */
  public void doPreFilter(HttpServletRequest request)
    throws ServletException {
  }

  public void doFilter(ServletRequest req,
                       ServletResponse response,
                       FilterChain filterChain)
         throws IOException, ServletException {
    HttpServletRequest hreq = (HttpServletRequest)req;

    synchronized (hreq.getSession()) {
      filterChain.doFilter(req, response);
    }
  }

  public void destroy() {
    if (debug) {
      ctx.log("Destroying filter...");
    }
  }

}

