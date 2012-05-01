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
import org.apache.struts.upload.MultipartRequestWrapper;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Enumeration;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;

/** Package of small useful methods
 *
 * @author Mike Douglass
 *
 */
public class HttpServletUtils {
  /** Had to have this because it's subclassed.
   *
   * @throws Exception
   */
  public HttpServletUtils() throws Exception {
    throw new Exception("Dont instantiate");
  }

  /** Return the browser type for the given request. We attempt to reduce the
   *  set of browsers to a more manageable number. The returned value is one of:
   * <ul>
   * <li>opera     The opera browser</li>
   * <li>MSIE      Microsoft Internet Explorer compatible</li>
   * <li>Netscape6 Netscape 6.x</li>
   * <li>Mozilla   Mozilla</li>
   * <li>Netscape4 Netscape 4.x compatible</li>
   * <li>default   none of the above</li>
   * </ul>
   *
   * @param   request Incoming HttpServletRequest object
   * @return  String  browser type
   */
  public static String getBrowserType(final HttpServletRequest request) {
    if (request == null) {
      return "default";
    }

    String userAgent = String.valueOf(
        request.getHeader("User-Agent")).toLowerCase();

    if ((userAgent.indexOf("aladdino") >= 0) ||
        (userAgent.indexOf("avantgo") >= 0) || // AvantGo service
        (userAgent.indexOf("docomo") >= 0) ||
        (userAgent.indexOf("Elaine") >= 0) || // this is the Palm
        (userAgent.indexOf("isilo") >= 0) ||
        (userAgent.indexOf("mazingo") >= 0) ||
        (userAgent.indexOf("mobipocket webcompanion") >= 0) ||
        (userAgent.indexOf("mobipocket+webcompanion") >= 0) ||
        (userAgent.indexOf("plucker") >= 0) ||
        (userAgent.indexOf("webwasher") >= 0)) {
      /**
       * The browser is a PDA
       */
      return "PDA";
    }

    if (userAgent.indexOf("opera") >= 0) {
      /**
       * Opera browser
       */
      return "Opera";
    }

    if (userAgent.indexOf("msie") >= 0) {
      /**
       * The browser is Microsoft Internet Explorer compatible
       */
      return "MSIE";
    }

    if (userAgent.indexOf("netscape6") >= 0) {
      /**
       *  The browser is Netscape 6.x
       */
      return "Netscape6";
    }

    if (userAgent.indexOf("gecko") >= 0) {
      /**
       *  The browser is Mozilla
       */
      return "Mozilla";
    }

    if ((userAgent.indexOf("mozilla/4") >= 0) &&
        (userAgent.indexOf("spoofer") == -1) &&
        (userAgent.indexOf("webtv") == -1)) {
      /**
       * The browser is Netscape 4.x compatible
       */
      return "Netscape4";
    }

    /**
     * Otherwise return a generic value
     */
    return "default";
  }

  /**
   * @param req
   * @return reconstructed request
   */
  public static String getReqLine(final HttpServletRequest req) {
    StringBuffer ret = new StringBuffer(getUrl(req));
    String query = req.getQueryString();

    if (query != null) {
      ret.append("?").append(query);
    }

    return ret.toString();
  }

  /** Returns the String url from the request.
   *
   *  @param   request     incoming request
   *  @return  String      url from the request
   */
  public static String getUrl(final HttpServletRequest request) {
    try {
      if (request instanceof MultipartRequestWrapper) {
        return ((MultipartRequestWrapper)request).getRequestURL().toString();
      }

      StringBuffer sb = request.getRequestURL();
      if (sb != null) {
        return sb.toString();
      }

      // Presumably portlet - see what happens with uri
      return request.getRequestURI();
    } catch (Throwable t) {
      Logger.getLogger(HttpServletUtils.class).warn(
          "Unable to get url from " + request, t);
      return "BogusURL.this.is.probably.a.portal";
    }
  }

  /** Returns the scheme + host + port part of the url.
   *  This allows us to link to services on the same machine.
   *  <p>For example, a URL of http://myhost.com:8080/myapp/doit.do will get a
   *  result "http://myhost.com:8080"
   *
   * @param request
   * @return scheme + host + port
   */
  public static String getURLshp(final HttpServletRequest request) {
    String scheme = request.getScheme();
    StringBuilder sb = new StringBuilder(scheme);

    sb.append("://");
    sb.append(request.getServerName());

    int port = request.getServerPort();

    if ("http".equalsIgnoreCase(scheme) && (port == 80)) {
      return sb.toString();
    }

    if ("https".equalsIgnoreCase(scheme) && (port == 443)) {
      return sb.toString();
    }

    sb.append(":");
    sb.append(port);

    return sb.toString();
  }

  /** Returns the scheme + host + port part of the url together with the
   *  path up to the servlet path. This allows us to append a new action to
   *  the end.
   *  <p>For example, a URL of http://myhost.com:8080/myapp/doit.do will get a
   *  result "http://myhost.com:8080/myapp"
   *
   * @param request
   * @return scheme + host + port + path
   */
  public static String getURLPrefix(final HttpServletRequest request) {
    return getURLshp(request) + getContext(request);
  }

  /** Returns the context path.
   *  <p>For example, a URL of http://myhost.com:8080/myapp/doit.do will get a
   *  result "/myapp"
   *
   * <p>Note: do we have to deal with MultipartRequestWrapper?
   *
   * @param request
   * @return context path
   */
  public static String getContext(final HttpServletRequest request) {
    String context = request.getContextPath();
    if ((context == null) || (context.equals("."))) {
      context = "";
    }

    return context;
  }

  /** Return a concatenated string of all the headers
   *
   * @param   req    Incoming HttpServletRequest object
   * @return  header values
   */
  public static String getHeaders(final HttpServletRequest req) {
    Enumeration en = req.getHeaderNames();
    StringBuffer sb = new StringBuffer();

    while (en.hasMoreElements()) {
      String name = (String) en.nextElement();
      sb.append(name);
      sb.append(": ");
      sb.append(req.getHeader(name));
      sb.append("\n");
    }
    return sb.toString();
  }

  /** Print all the headers
   *
   * @param   req    Incoming HttpServletRequest object
   * @param log
   */
  public static void dumpHeaders(final HttpServletRequest req, final Logger log) {
    Enumeration en = req.getHeaderNames();
    while (en.hasMoreElements()) {
      String name = (String) en.nextElement();
      log.debug(name + ": " + req.getHeader(name));
    }
  }

  /** If there is no Accept-Language header returns null, otherwise returns a
   * collection of Locales ordered with preferred first.
   *
   * @param req
   * @return Collection of locales or null
   */
  public static Collection<Locale> getLocales(final HttpServletRequest req) {
    if (req.getHeader("Accept-Language") == null) {
      return null;
    }

    @SuppressWarnings("unchecked")
    Enumeration<Locale> lcs = req.getLocales();
    ArrayList<Locale> locales = new ArrayList<Locale>();
    while (lcs.hasMoreElements()) {
      locales.add(lcs.nextElement());
    }

    return locales;
  }
}

