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

