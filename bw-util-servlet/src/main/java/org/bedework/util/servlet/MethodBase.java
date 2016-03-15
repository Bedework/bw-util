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
package org.bedework.util.servlet;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.log4j.Logger;

import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.URLDecoder;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/** Base class for servlet methods.
 */
public abstract class MethodBase {
  protected boolean debug;

  protected boolean dumpContent;

  protected transient Logger log;

  /** Called at each request
   *
   * @throws ServletException
   */
  public abstract void init() throws ServletException;

  private final SimpleDateFormat httpDateFormatter =
          new SimpleDateFormat("E, dd MMM yyyy HH:mm:ss ");

  /**
   * 
   * @return mapper used to handle json content
   */
  public abstract ObjectMapper getMapper();

  /**
   * @param req the request
   * @param resp and response
   * @throws ServletException
   */
  public abstract void doMethod(HttpServletRequest req,
                                HttpServletResponse resp)
          throws ServletException;

  /** Allow servlet to create method.
   */
  public static class MethodInfo {
    private final Class<? extends MethodBase> methodClass;

    private final boolean requiresAuth;

    /**
     * @param methodClass the class
     * @param requiresAuth true for auth needed
     */
    public MethodInfo(final Class<? extends MethodBase> methodClass,
                      final boolean requiresAuth) {
      this.methodClass = methodClass;
      this.requiresAuth = requiresAuth;
    }

    /**
     * @return Class for this method
     */
    public Class<? extends MethodBase> getMethodClass() {
      return methodClass;
    }

    /** Called when servicing a request to determine if this method requires
     * authentication. Allows the servlet to reject attempts to change state
     * while unauthenticated.
     *
     * @return boolean true if authentication required.
     */
    public boolean getRequiresAuth() {
      return requiresAuth;
    }
  }

  protected String hrefFromPath(final List<String> path,
                                final int start) {
    // Need exactly 3 elements from start
    final int sz = path.size();

    if (start == sz) {
      return null;
    }

    final StringBuilder sb = new StringBuilder();

    for (int i = start; i < sz; i++) {
      sb.append("/");
      sb.append(path.get(i));
    }

    sb.append("/");

    return sb.toString();
  }

  protected void write(final String s,
                       final HttpServletResponse resp) throws ServletException {
    if (s == null) {
      resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
      return;
    }

    try {
      final PrintWriter pw = resp.getWriter();

      pw.write(s);
      pw.flush();
    } catch (final Throwable t) {
      throw new ServletException(t);
    }
    resp.setStatus(HttpServletResponse.SC_OK);
  }

  protected void writeJson(final Object o,
                           final HttpServletResponse resp) throws ServletException {
    if (o == null) {
      resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
      return;
    }

    try {
      getMapper().writeValue(resp.getWriter(), o);
    } catch (final Throwable t) {
      throw new ServletException(t);
    }
    resp.setStatus(HttpServletResponse.SC_OK);
  }

  /** Get the decoded and fixed resource URI. This calls getServletPath() to
   * obtain the path information. The description of that method is a little
   * obscure in it's meaning. In a request of this form:<br/><br/>
   * "GET /ucaldav/user/douglm/calendar/1302064354993-g.ics HTTP/1.1[\r][\n]"<br/><br/>
   * getServletPath() will return <br/><br/>
   * /user/douglm/calendar/1302064354993-g.ics<br/><br/>
   * that is the context has been removed. In addition this method will URL
   * decode the path. getRequestUrl() does neither.
   *
   * @param req      Servlet request object
   * @return List    Path elements of fixed up uri
   * @throws ServletException
   */
  public List<String> getResourceUri(final HttpServletRequest req)
          throws ServletException {
    String uri = req.getServletPath();

    if ((uri == null) || (uri.length() == 0)) {
      /* No path specified - set it to root. */
      uri = "/";
    }

    return fixPath(uri);
  }

  /** Return a path, broken into its elements, after "." and ".." are removed.
   * If the parameter path attempts to go above the root we return null.
   *
   * Other than the backslash thing why not use URI?
   *
   * @param path      String path to be fixed
   * @return String[]   fixed path broken into elements
   * @throws ServletException
   */
  public static List<String> fixPath(final String path) throws ServletException {
    if (path == null) {
      return null;
    }

    String decoded;
    try {
      decoded = URLDecoder.decode(path, "UTF8");
    } catch (Throwable t) {
      throw new ServletException("bad path: " + path);
    }

    if (decoded == null) {
      return (null);
    }

    /** Make any backslashes into forward slashes.
     */
    if (decoded.indexOf('\\') >= 0) {
      decoded = decoded.replace('\\', '/');
    }

    /** Ensure a leading '/'
     */
    if (!decoded.startsWith("/")) {
      decoded = "/" + decoded;
    }

    /** Remove all instances of '//'.
     */
    while (decoded.contains("//")) {
      decoded = decoded.replaceAll("//", "/");
    }

    /** Somewhere we may have /./ or /../
     */

    final StringTokenizer st = new StringTokenizer(decoded, "/");

    ArrayList<String> al = new ArrayList<String>();
    while (st.hasMoreTokens()) {
      String s = st.nextToken();

      if (s.equals(".")) {
        // ignore
      } else if (s.equals("..")) {
        // Back up 1
        if (al.size() == 0) {
          // back too far
          return null;
        }

        al.remove(al.size() - 1);
      } else {
        al.add(s);
      }
    }

    return al;
  }

  /*
  protected void addStatus(final int status,
                           final String message) throws ServletException {
    try {
      if (message == null) {
//        message = WebdavStatusCode.getMessage(status);
      }

      property(WebdavTags.status, "HTTP/1.1 " + status + " " + message);
    } catch (ServletException wde) {
      throw wde;
    } catch (Throwable t) {
      throw new ServletException(t);
    }
  }
  */

  protected void addHeaders(final HttpServletResponse resp) throws ServletException {
    // This probably needs changes
/*
    StringBuilder methods = new StringBuilder();
    for (String name: getSyncher().getMethodNames()) {
      if (methods.length() > 0) {
        methods.append(", ");
      }

      methods.append(name);
    }

    resp.addHeader("Allow", methods.toString());
    */
    resp.addHeader("Allow", "POST, GET");
  }

  /** Parse the request body, and return the object.
   *
   * @param is         Input stream for content
   * @param cl         The class we expect
   * @param resp       for status
   * @return Object    Parsed body or null for no body
   * @exception ServletException Some error occurred.
   */
  protected Object readJson(final InputStream is,
                            final Class cl,
                            final HttpServletResponse resp) throws ServletException {
    if (is == null) {
      return null;
    }

    try {
      return getMapper().readValue(is, cl);
    } catch (Throwable t) {
      resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
      if (debug) {
        error(t);
      }
      throw new ServletException(t);
    }
  }

  /** Parse the request body, and return the object.
   *
   * @param is         Input stream for content
   * @param tr         For the class we expect
   * @param resp       for status
   * @return Object    Parsed body or null for no body
   * @exception ServletException Some error occurred.
   */
  protected Object readJson(final InputStream is,
                            final TypeReference tr,
                            final HttpServletResponse resp) throws ServletException {
    if (is == null) {
      return null;
    }

    try {
      return getMapper().readValue(is, tr);
    } catch (final Throwable t) {
      resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
      if (debug) {
        error(t);
      }
      throw new ServletException(t);
    }
  }

  protected void sendJsonError(final HttpServletResponse resp,
                               final String msg) {
    try {
      resp.setStatus(HttpServletResponse.SC_OK);
      resp.setContentType("application/json; charset=UTF-8");

      final String json = "{\"status\": \"failed\", \"msg\": \"" + msg + "\"}";

      resp.setContentType("application/json; charset=UTF-8");

      final OutputStream os = resp.getOutputStream();

      final byte[] bytes = json.getBytes();

      resp.setContentLength(bytes.length);
      os.write(bytes);
      os.close();
    } catch (final Throwable ignored) {
      // Pretty much screwed if we get here
      if (debug) {
        debugMsg("Unable to send error: " + msg);
      }
    }
  }

  protected void sendOkJsonData(final HttpServletResponse resp) {
    final String json = "{\"status\": \"ok\"}";

    sendOkJsonData(resp, json);
  }

  protected void sendOkJsonData(final HttpServletResponse resp,
                                final String data) {
    try {
      resp.setStatus(HttpServletResponse.SC_OK);
      resp.setContentType("application/json; charset=UTF-8");

      final OutputStream os = resp.getOutputStream();

      final byte[] bytes = data.getBytes();

      resp.setContentLength(bytes.length);
      os.write(bytes);
      os.close();
    } catch (final Throwable ignored) {
      // Pretty much screwed if we get here
    }
  }

  protected String formatHTTPDate(final Timestamp val) {
    if (val == null) {
      return null;
    }

    synchronized (httpDateFormatter) {
      return httpDateFormatter.format(val) + "GMT";
    }
  }

  /** ===================================================================
   *                   Logging methods
   *  =================================================================== */

  /**
   * @return Logger
   */
  protected Logger getLogger() {
    if (log == null) {
      log = Logger.getLogger(this.getClass());
    }

    return log;
  }

  protected void debugMsg(final String msg) {
    getLogger().debug(msg);
  }

  protected void error(final Throwable t) {
    getLogger().error(this, t);
  }

  protected void error(final String msg) {
    getLogger().error(msg);
  }

  protected void warn(final String msg) {
    getLogger().warn(msg);
  }

  protected void logIt(final String msg) {
    getLogger().info(msg);
  }

  protected void trace(final String msg) {
    getLogger().debug(msg);
  }
}

