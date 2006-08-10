/* **********************************************************************
    Copyright 2006 Rensselaer Polytechnic Institute. All worldwide rights reserved.

    Redistribution and use of this distribution in source and binary forms,
    with or without modification, are permitted provided that:
       The above copyright notice and this permission notice appear in all
        copies and supporting documentation;

        The name, identifiers, and trademarks of Rensselaer Polytechnic
        Institute are not used in advertising or publicity without the
        express prior written permission of Rensselaer Polytechnic Institute;

    DISCLAIMER: The software is distributed" AS IS" without any express or
    implied warranty, including but not limited to, any implied warranties
    of merchantability or fitness for a particular purpose or any warrant)'
    of non-infringement of any current or pending patent rights. The authors
    of the software make no representations about the suitability of this
    software for any particular purpose. The entire risk as to the quality
    and performance of the software is with the user. Should the software
    prove defective, the user assumes the cost of all necessary servicing,
    repair or correction. In particular, neither Rensselaer Polytechnic
    Institute, nor the authors of the software are liable for any indirect,
    special, consequential, or incidental damages related to the software,
    to the maximum extent the law permits.
*/

package edu.rpi.sss.util.servlets;

import java.io.IOException;
import java.io.LineNumberReader;
import java.io.Serializable;
import java.io.StringReader;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import org.apache.log4j.Logger;

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

  /** Get the globals from the session
   *
   * @param req
   * @return globals object
   */
  public FilterGlobals getGlobals(HttpServletRequest req) {
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
  public void init(FilterConfig filterConfig) throws ServletException {
    ctx = filterConfig.getServletContext();
    String temp = filterConfig.getInitParameter("debug");

    try {
      int debugVal = Integer.parseInt(temp);

      debug = (debugVal > 2);
    } catch (Exception e) {}
  }

  public abstract void doFilter(ServletRequest req,
                                ServletResponse response,
                                FilterChain filterChain)
         throws IOException, ServletException;

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
  public void doPreFilter(HttpServletRequest request)
    throws ServletException {
  }

  /** Set the content type for the request
   *
   * @param req
   * @param val
   */
  public void setContentType(HttpServletRequest req, String val) {
    getGlobals(req).contentType = val;
  }

  /**
   * @param req
   * @return current content type
   */
  public String getContentType(HttpServletRequest req) {
    return getGlobals(req).contentType;
  }

  /** Turn filtering on/off
   *
   * @param req
   * @param val
   */
  public void setDontFilter(HttpServletRequest req, boolean val) {
    getGlobals(req).dontFilter = val;
  }

  /**
   * @param req
   * @return true for no filtering
   */
  public boolean getDontFilter(HttpServletRequest req) {
    return getGlobals(req).dontFilter;
  }

  /**
   * @param val
   */
  public void setDebug(boolean val) {
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
  public static void dumpIt(String val, Logger log) {
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
