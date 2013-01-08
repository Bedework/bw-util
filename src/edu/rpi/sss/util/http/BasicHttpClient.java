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
package edu.rpi.sss.util.http;

import org.apache.http.Header;
import org.apache.http.HeaderElement;
import org.apache.http.HeaderElementIterator;
import org.apache.http.HttpEntity;
import org.apache.http.HttpException;
import org.apache.http.HttpHost;
import org.apache.http.HttpResponse;
import org.apache.http.auth.AuthScope;
import org.apache.http.auth.Credentials;
import org.apache.http.auth.UsernamePasswordCredentials;
import org.apache.http.client.methods.HttpDelete;
import org.apache.http.client.methods.HttpEntityEnclosingRequestBase;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpHead;
import org.apache.http.client.methods.HttpOptions;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.methods.HttpPut;
import org.apache.http.client.methods.HttpRequestBase;
import org.apache.http.client.params.ClientPNames;
import org.apache.http.conn.ConnectionKeepAliveStrategy;
import org.apache.http.conn.routing.HttpRoute;
import org.apache.http.conn.scheme.PlainSocketFactory;
import org.apache.http.conn.scheme.Scheme;
import org.apache.http.conn.scheme.SchemeRegistry;
import org.apache.http.conn.ssl.SSLSocketFactory;
import org.apache.http.entity.ByteArrayEntity;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.impl.conn.PoolingClientConnectionManager;
import org.apache.http.message.BasicHeaderElementIterator;
import org.apache.http.params.CoreConnectionPNames;
import org.apache.http.params.HttpParams;
import org.apache.http.pool.PoolStats;
import org.apache.http.protocol.HTTP;
import org.apache.http.protocol.HttpContext;
import org.apache.http.util.EntityUtils;
import org.apache.log4j.Logger;

import java.io.InputStream;
import java.net.URI;

import javax.servlet.http.HttpServletResponse;

/** A dav client
*
* @author Mike Douglass  douglm @ rpi.edu
*/
public class BasicHttpClient extends DefaultHttpClient {
  protected boolean debug;

  private transient Logger log;

  private static PoolingClientConnectionManager connManager;

  static {
    SchemeRegistry sr = new SchemeRegistry();
    sr.register(new Scheme("http", 80, PlainSocketFactory.getSocketFactory()));
    sr.register(new Scheme("https", 443, SSLSocketFactory.getSocketFactory()));

    sr.register(new Scheme("webcal", 80, PlainSocketFactory.getSocketFactory()));
    sr.register(new Scheme("webcals", 443, SSLSocketFactory.getSocketFactory()));

    connManager = new PoolingClientConnectionManager(sr);

 // Increase max total connection to 200
    connManager.setMaxTotal(200);
    // Increase default max connection per route to 20
    connManager.setDefaultMaxPerRoute(20);
    // Increase max connections for localhost:80 to 50
    HttpHost localhost = new HttpHost("localhost", 80);
    connManager.setMaxPerRoute(new HttpRoute(localhost), 50);
  }

  private HttpRequestBase method;

  private HttpResponse response;

  private AuthScope authScope;

  private ConnectionKeepAliveStrategy kas = new ConnectionKeepAliveStrategy() {

    @Override
    public long getKeepAliveDuration(final HttpResponse response,
                                     final HttpContext context) {
      // Honor 'keep-alive' header
      HeaderElementIterator it =
          new BasicHeaderElementIterator(response.headerIterator(HTTP.CONN_KEEP_ALIVE));
      while (it.hasNext()) {
        HeaderElement he = it.nextElement();
        String param = he.getName();
        String value = he.getValue();
        if ((value != null) && param.equalsIgnoreCase("timeout")) {
          try {
            return Long.parseLong(value) * 1000;
          } catch(NumberFormatException ignore) {
          }
        }
      }

      // keep alive for 30 seconds
      return 30 * 1000;
    }
  };

  private int status;

  private Credentials credentials;

  /**
   * @param timeOut - millisecs, 0 for no timeout
   * @throws HttpException
   */
  public BasicHttpClient(final int timeOut) throws HttpException {
    this(null, -1, null, timeOut, true);
  }

  /**
   * @param timeOut - millisecs, 0 for no timeout
   * @param followRedirects true for auto handling
   * @throws HttpException
   */
  public BasicHttpClient(final int timeOut,
                   final boolean followRedirects) throws HttpException {
    this(null, -1, null, timeOut, followRedirects);
  }

  /**
   * @param host default host or null
   * @param port default port if host supplied or -1 for default
   * @param scheme default scheme if host supplied or null for default
   * @param timeOut - millisecs, 0 for no timeout
   * @throws HttpException
   */
  public BasicHttpClient(final String host,
                   final int port,
                   final String scheme,
                   final int timeOut) throws HttpException {
    this(host, port, scheme, timeOut, true);
  }

  /**
   * @param host default host or null
   * @param port default port if host supplied or -1 for default
   * @param scheme default scheme if host supplied or null for default
   * @param timeOut - millisecs, 0 for no timeout
   * @param followRedirects true for auto handling
   * @throws HttpException
   */
  public BasicHttpClient(final String host,
                   final int port,
                   final String scheme,
                   final int timeOut,
                   final boolean followRedirects) throws HttpException {
    super(connManager, null);

    debug = getLogger().isDebugEnabled();

    HttpParams params = getParams();

    if (host != null) {
      HttpHost httpHost = new HttpHost(host, port, scheme);
      params.setParameter(ClientPNames.DEFAULT_HOST,
                          httpHost);
    }

    params.setIntParameter(CoreConnectionPNames.CONNECTION_TIMEOUT,
                           timeOut);

    // XXX Should have separate value for this.
    params.setIntParameter(CoreConnectionPNames.SO_TIMEOUT,
                           timeOut * 2);

    params.setBooleanParameter(ClientPNames.HANDLE_REDIRECTS,
                               Boolean.valueOf(followRedirects));
  }

  /**
   * @param val maximum allowable overall
   */
  public static void setMaxConnections(final int val) {
    connManager.setMaxTotal(val);
  }

  /**
   * @return maximim allowable overall
   */
  public static int getMaxConnections() {
    return connManager.getMaxTotal();
  }

  /**
   * @return current active
   */
  public static PoolStats getConnStats() {
    return connManager.getTotalStats();
  }

  /**
   * @param val
   */
  public static void setDefaultMaxPerRoute(final int val) {
    connManager.setDefaultMaxPerRoute(val);
  }

  /**
   * @return current default
   */
  public static int getDefaultMaxPerRoute() {
    return connManager.getDefaultMaxPerRoute();
  }

  /* *
   * @param val
   * /
  public static void setDefaultMaxPerHost(final int val) {
    connManager.setDefaultMaxPerHost(val);
  }

  /* *
   * @return max
   * /
  public static int getDefaultMaxPerHost() {
    return connManager.getDefaultMaxPerHost();
  }

  /* *
   * @param host
   * @param max
   * /
  public static void setHostLimit(final HttpHost host, final int max) {
    connManager.setHostLimit(host, max);
  }

  /* *
   * @param host
   * @return max
   * /
  public static int getHostLimit(final HttpHost host) {
    return connManager.getHostLimit(host);
  }

  /* *
   * @return best we can offer
   * /
  public static List<String> getCurrentLimits() {
    return connManager.getCurrentLimits();
  }

  /* *
   * @return ct of created pool entries
   * /
  public static long getCreated() {
    return connManager.getCreated();
  }

  /* *
   * @return ct of deleted pool entries
   * /
  public static long getDeleted() {
    return connManager.getDeleted();
  }

  /** Set the credentials. user == null for unauthenticated.
   *
   * @param user
   * @param pw
   */
  public void setCredentials(final String user, final String pw) {
    if (user == null) {
      credentials = null;
    } else {
      credentials = new UsernamePasswordCredentials(user, pw);
    }
  }

  /** Send a (simple) request to the server
   *
   * @param method
   * @param url
   * @param hdrs
   * @return int    status code
   * @throws HttpException
   */
  public int sendRequest(final String method, final String url,
                         final Header[] hdrs) throws HttpException {
    return sendRequest(method, url, hdrs, null, null, 0, null);
  }

  /** Send a request to the server
   *
   * @param methodName
   * @param url
   * @param hdrs
   * @param depth
   * @param contentType
   * @param contentLen
   * @param content
   * @return int    status code
   * @throws HttpException
   */
  public int sendRequest(final String methodName,
                         final String url,
                         final Header[] hdrs, final String depth,
                         String contentType, final int contentLen,
                         final byte[] content) throws HttpException {
    int sz = 0;
    if (content != null) {
      sz = content.length;
    }

    if (debug) {
      debugMsg("About to send request: method=" + methodName +
               " url=" + url +
               " contentLen=" + contentLen +
               " content.length=" + sz +
               " contentType=" + contentType);
    }

    method = findMethod(methodName, url);

    URI u = method.getURI();

    if (credentials != null) {
      getCredentialsProvider().setCredentials(new AuthScope(u.getHost(),
                                                            u.getPort()),
                                              credentials);
    }

    if (hdrs != null) {
      for (int i = 0; i < hdrs.length; i++) {
        method.addHeader(hdrs[i]);
      }
    }

    if (method instanceof HttpEntityEnclosingRequestBase) {
      if (contentType == null) {
        contentType = "text/xml";
      }

      if (content != null) {
        setContent(content, contentType);
      }
    }

    try {
      response = execute(method);
    } catch (Throwable t) {
      throw new HttpException(t.getLocalizedMessage(), t);
    }
    status = response.getStatusLine().getStatusCode();

    return status;
  }

  /** Send content
   *
   * @param content
   * @param contentType
   * @throws HttpException
   */
  public void setContent(final byte[] content,
                         final String contentType) throws HttpException {
    if (!(method instanceof HttpEntityEnclosingRequestBase)) {
      throw new HttpException("Invalid operation for method " +
                               method.getMethod());
    }

    HttpEntityEnclosingRequestBase eem = (HttpEntityEnclosingRequestBase)method;

    ByteArrayEntity entity = new ByteArrayEntity(content);
    entity.setContentType(contentType);
    eem.setEntity(entity);
  }

  /** Specify the next method by name.
   *
   * @param name
   * @param uri
   * @return method object
   * @throws HttpException
   */
  public HttpRequestBase findMethod(final String name,
                                    final String uri) throws HttpException {
    String nm = name.toUpperCase();

    if ("PUT".equals(nm)) {
      return new HttpPut(uri);
    }

    if ("GET".equals(nm)) {
      return new HttpGet(uri);
    }

    if ("DELETE".equals(nm)) {
      return new HttpDelete(uri);
    }

    if ("POST".equals(nm)) {
      return new HttpPost(uri);
    }

    if ("OPTIONS".equals(nm)) {
      return new HttpOptions(uri);
    }

    if ("HEAD".equals(nm)) {
      return new HttpHead(uri);
    }

    throw new HttpException("Illegal method: " + name);
  }

  /* * Send a request to the server
   *
   * @param method
   * @param url
   * @param hdrs
   * @param parameters
   * @return int    status code
   * @throws Throwable
   *
  public int sendRequest(final String method, final String url,
                         final Header[] hdrs,
                         final NameValuePair[] parameters) throws Throwable {
    if (debug) {
       debugMsg("About to send request: method=" + method +
                " url=" + url + parameters);
    }

    client.setMethod(method, url);

    HttpRequestBase meth = client.getMethod();

    meth.setQueryString(parameters);

    if (credentials != null) {
      client.getCredentialsProvider().setCredentials(client.getAuthScope(),
                                                     credentials);
    }

    if (hdrs != null) {
      for (int i = 0; i < hdrs.length; i++) {
        meth.addHeader(hdrs[i]);
      }
    }

    status = client.executeMethod();

    return status;
  }*/

  /**
   * @param path
   * @param o
   * @param contentType
   * @return response code
   * @throws HttpException
   */
  public int putObject(final String path, final Object o,
                       final String contentType) throws HttpException {
    String content = String.valueOf(o);
    int respCode = sendRequest("PUT",
                               path,
                               null,
                               "0",
                               contentType,
                               content.length(),
                               content.getBytes());    //content

    if (debug) {
      debugMsg("response code " + respCode);
    }

    return respCode;
  }

  /**
   * @return String content type
   * @throws HttpException
   */
  public String getResponseContentType() throws HttpException {
    HttpEntity ent = getResponseEntity();

    if (ent == null) {
      return null;
    }

    Header hdr = ent.getContentType();
    if (hdr == null) {
      return null;
    }

    return hdr.getValue();
  }

  /**
   * @return the response entity or null
   */
  public HttpEntity getResponseEntity() {
    if (response == null) {
      return null;
    }

    return response.getEntity();
  }

  /**
   * @return long content length
   * @throws HttpException
   */
  public long getResponseContentLength() throws HttpException {
    HttpEntity ent = getResponseEntity();

    if (ent == null) {
      return 0;
    }

    return ent.getContentLength();
  }

  /**
   * @return String response character set
   * @throws HttpException
   */
  public String getResponseCharSet() throws HttpException {
    HttpEntity ent = getResponseEntity();

    if (ent == null) {
      return null;
    }

    return EntityUtils.getContentCharSet(ent);
  }

  /**
   * Returns the response body of the HTTP method, if any, as an {@link InputStream}.
   * If response body is not available, returns <tt>null</tt>
   *
   * @return InputStream    response body
   * @throws HttpException
   */
  public InputStream getResponseBodyAsStream() throws HttpException {
    try {
      HttpEntity ent = getResponseEntity();

      if (ent == null) {
        return null;
      }

      return ent.getContent();
    } catch (Throwable t) {
      throw new HttpException(t.getLocalizedMessage(), t);
    }
  }

  /**
   * @param path
   * @return InputStream
   * @throws HttpException
   */
  public InputStream get(final String path) throws HttpException {
    int respCode = sendRequest("GET",
                               path,
                               null,
                               null,
                               "application/text",
                               0, // contentLen
                               null);    //content

    if (debug) {
      debugMsg("getFile: response code " + respCode);
    }

    if (respCode != HttpServletResponse.SC_OK) {
      return null;
    }

    return getResponseBodyAsStream();
  }

  /** Release the connection
   *
   * @throws HttpException
   */
  public void release() throws HttpException {
    try {
      HttpEntity ent = getResponseEntity();

      if (ent != null) {
        InputStream is = ent.getContent();
        is.close();
      }
    } catch (Throwable t) {
      throw new HttpException(t.getLocalizedMessage(), t);
    }
  }

  /**
   *
   */
  public void close() {
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
