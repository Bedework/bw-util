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
package edu.rpi.sss.util.servlets;

import org.apache.log4j.Logger;

import java.io.IOException;
import java.io.LineNumberReader;
import java.io.Serializable;
import java.io.StringReader;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

/** An abstract filter class to help build filters.
 *  <p>We provide abstract methods for the three required filter methods,
 *  init, destroy and doFilter.
 *  We also provide an additional method, doPreFilter, which should be
 *  called by the doFilter method at entry.
 *  </p>
 *
 * @author  Mike Douglass douglm@rpi.edu
 */
public abstract class AbstractFilter implements Filter {
  protected ServletContext ctx;

  protected boolean debug = false;

  private transient Logger log;
  /** One per session
   */
  public static class FilterGlobals implements Serializable {
    /** Set true if we don't want filtering to take place. This can be
     *  used to get a dump of the stream.
     */
    protected boolean dontFilter = false;

    /** If non-null we might want to set from here
     */
    protected String contentType;
  }

  private static final String globalsName =
        "edu.rpi.sss.util.servlets.AbstractFilter.FilterGlobals";

  /**
   */
  public AbstractFilter() {
    debug = getLogger().isDebugEnabled();
  }

  /** Get the globals from the session
   *
   * @param req
   * @return globals object
   */
  public FilterGlobals getGlobals(final HttpServletRequest req) {
    HttpSession sess = req.getSession();

    if (sess == null) {
      // We're screwed
      return null;
    }

    Object o = sess.getAttribute(globalsName);
    FilterGlobals fg;

    if (o == null) {
      fg = newFilterGlobals();
      sess.setAttribute(globalsName, fg);

      if (debug) {
        getLogger().debug("Created new FilterGlobals from session " + sess.getId());
      }
    } else {
      fg = (FilterGlobals)o;
      //if (debug) {
      //  getLogger().debug("Obtained FilterGlobals from session with id " +
      //                    sess.getId());
      //}
    }

    return fg;
  }

  /**
   * @return new globals object. THis can be overridden to return subclasses
   */
  public FilterGlobals newFilterGlobals() {
    return new FilterGlobals();
  }

  /* (non-Javadoc)
   * @see javax.servlet.Filter#init(javax.servlet.FilterConfig)
   */
  @Override
  public void init(final FilterConfig filterConfig) throws ServletException {
    ctx = filterConfig.getServletContext();
  }

  @Override
  public abstract void doFilter(ServletRequest req,
                                ServletResponse response,
                                FilterChain filterChain)
         throws IOException, ServletException;

  @Override
  public void destroy() {
    if ((debug) && (ctx != null)) {
      ctx.log("Destroying filter...");
    }
  }

  /** This method can be overridden to allow a subclass to set up ready for a
   *  transformation.
   *
   * @param   request    Incoming HttpServletRequest object
   * @throws ServletException
   */
  public void doPreFilter(final HttpServletRequest request)
    throws ServletException {
  }

  /** Set the content type for the request
   *
   * @param req
   * @param val
   */
  public void setContentType(final HttpServletRequest req, final String val) {
    getGlobals(req).contentType = val;
  }

  /**
   * @param req
   * @return current content type
   */
  public String getContentType(final HttpServletRequest req) {
    return getGlobals(req).contentType;
  }

  /** Turn filtering on/off
   *
   * @param req
   * @param val
   */
  public void setDontFilter(final HttpServletRequest req, final boolean val) {
    getGlobals(req).dontFilter = val;
  }

  /**
   * @param req
   * @return true for no filtering
   */
  public boolean getDontFilter(final HttpServletRequest req) {
    return getGlobals(req).dontFilter;
  }

  /**
   * @param val
   */
  public void setDebug(final boolean val) {
    debug = val;
  }

  /**
   * @return boolean debug state
   */
  public boolean getDebug() {
    return debug;
  }

  /** Get a logger for messages
   *
   * @return Logger
   */
  public Logger getLogger() {
    if (log == null) {
      log = Logger.getLogger(this.getClass());
    }

    return log;
  }

  /** A debugging dump routine
   *
   * @param val
   * @param log
   */
  public static void dumpIt(final String val, final Logger log) {
    StringReader dsr = new StringReader(val);
    LineNumberReader dlnr = new LineNumberReader(dsr);
    int i = 1;

    try {
      while (dlnr.ready()) {
        String s = dlnr.readLine();

        if (s == null) {
          break;
        }

        log.debug(i + ": " + s);
        i++;
      }
    } catch (Exception e) {
      log.debug(e.getMessage());
    }
  }
}
