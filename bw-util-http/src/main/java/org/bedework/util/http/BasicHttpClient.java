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
package org.bedework.util.http;

import org.bedework.util.logging.BwLogger;
import org.bedework.util.logging.Logged;
import org.bedework.util.misc.Util;

import org.apache.http.Header;
import org.apache.http.HeaderElement;
import org.apache.http.HeaderElementIterator;
import org.apache.http.HttpEntity;
import org.apache.http.HttpException;
import org.apache.http.HttpHost;
import org.apache.http.HttpResponse;
import org.apache.http.StatusLine;
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

import java.io.InputStream;
import java.net.URI;
import java.security.SecureRandom;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;
import java.util.List;
import java.util.concurrent.TimeUnit;

import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;
import javax.servlet.http.HttpServletResponse;

/** A dav client
*
* @author Mike Douglass  douglm @ rpi.edu
*/
public class BasicHttpClient extends DefaultHttpClient 
        implements Logged {
  private static PoolingClientConnectionManager connManager;

  public static class IdleConnectionMonitorThread extends Thread {

    private final PoolingClientConnectionManager connMgr;
    private volatile boolean shutdown;

    public IdleConnectionMonitorThread(PoolingClientConnectionManager connMgr) {
      super();
      this.connMgr = connMgr;
    }

    @Override
    public void run() {
      try {
        while (!shutdown) {
          synchronized (this) {
            wait(5000);
            // Close expired connections
            connMgr.closeExpiredConnections();
            // Optionally, close connections
            // that have been idle longer than 30 sec
            connMgr.closeIdleConnections(30, TimeUnit.SECONDS);
          }
        }
      } catch (InterruptedException ex) {
        // terminate
      }
    }

    public void shutdown() {
      shutdown = true;
      synchronized (this) {
        notifyAll();
      }
    }
  }

  private static final IdleConnectionMonitorThread idleConnectionMonitor;

  private final static SchemeRegistry sr = new SchemeRegistry();

  protected static boolean sslDisabled = Boolean.getBoolean("org.bedework.disable.ssl");

  static {
    sr.register(new Scheme("http", 80, PlainSocketFactory.getSocketFactory()));
    sr.register(new Scheme("https", 443, getSslSocketFactory()));

    sr.register(new Scheme("webcal", 80, PlainSocketFactory.getSocketFactory()));
    sr.register(new Scheme("webcals", 443, getSslSocketFactory()));

    connManager = new PoolingClientConnectionManager(sr);

 // Increase max total connection to 200
    connManager.setMaxTotal(200);
    // Increase default max connection per route to 20
    connManager.setDefaultMaxPerRoute(20);

    // Increase max connections for localhost:80 to 50
    HttpHost localhost = new HttpHost("localhost", 80);
    connManager.setMaxPerRoute(new HttpRoute(localhost), 50);

    // Increase max connections for localhost:8080 to 50
    HttpHost localhost8080 = new HttpHost("localhost", 8080);
    connManager.setMaxPerRoute(new HttpRoute(localhost8080), 50);

    idleConnectionMonitor = new IdleConnectionMonitorThread(connManager);
    idleConnectionMonitor.start();
  }

  private HttpRequestBase method;

  private HttpResponse response;

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

  private boolean hostSpecified;

  private String baseURIValue;

  private URI baseURI;

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
    setKeepAliveStrategy(kas);

    if (sslDisabled) {
      warn("*******************************************************");
      warn(" SSL disabled");
      warn("*******************************************************");
    }

    final HttpParams params = getParams();

    if (host != null) {
      hostSpecified = true;
      final HttpHost httpHost = new HttpHost(host, port, scheme);
      params.setParameter(ClientPNames.DEFAULT_HOST,
                          httpHost);
    }

    params.setIntParameter(CoreConnectionPNames.CONNECTION_TIMEOUT,
                           timeOut);

    // XXX Should have separate value for this.
    params.setIntParameter(CoreConnectionPNames.SO_TIMEOUT,
                           timeOut * 2);

    params.setBooleanParameter(ClientPNames.HANDLE_REDIRECTS,
                               followRedirects);
  }

  /** Allow testing of features when we don't have any valid certs.
   *
   * @return socket factory.
   */
  public static SSLSocketFactory getSslSocketFactory() {
    if (!sslDisabled) {
      return SSLSocketFactory.getSocketFactory();
    }

    try {
      final X509Certificate[] _AcceptedIssuers = new X509Certificate[] {};

      final SSLContext ctx = SSLContext.getInstance("TLS");
      final X509TrustManager tm = new X509TrustManager() {
        @Override
        public X509Certificate[] getAcceptedIssuers() {
          return _AcceptedIssuers;
        }
        @Override
        public void checkServerTrusted(final X509Certificate[] chain,
                                       final String authType) throws CertificateException {
        }
        @Override
        public void checkClientTrusted(final X509Certificate[] chain,
                                       final String authType) throws CertificateException {
        }
      };
      ctx.init(null, new TrustManager[] { tm }, new SecureRandom());

      return new SSLSocketFactory(ctx,
                                  SSLSocketFactory.ALLOW_ALL_HOSTNAME_VERIFIER);
    } catch (final Throwable t) {
      throw new RuntimeException(t);
    }
  }

  /**
   * @param val the base URI to be used to resolve non-absolute URIs
   */
  public void setBaseURIValue(final String val) {
    baseURIValue = val;
    baseURI = null;
  }

  /**
   * @param val the base URI to be used to resolve non-absolute URIs
   */
  public void setBaseURI(final URI val) {
    baseURIValue = null;
    baseURI = val;
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
   * @param val max per route
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
  */

  /**
   * @param host the host
   * @param port the port number
   * @param max number connections
   */
  public static void setHostLimit(final String host,
                                  final int port,
                                  final int max) {
    HttpHost hostPort = new HttpHost(host, port);
    connManager.setMaxPerRoute(new HttpRoute(hostPort), max);
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
  }*/

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
   * @param method the method, GET, PUT etc
   * @param url the url
   * @param hdrs may be null
   * @return int    status code
   * @throws HttpException
   */
  public int sendRequest(final String method, final String url,
                         final List<Header> hdrs) throws HttpException {
    return sendRequest(method, url, hdrs, null, 0, null);
  }

  /** Send a request to the server
   *
   * @param methodName the method, GET, PUT etc
   * @param url the url
   * @param hdrs may be null
   * @param contentType
   * @param contentLen
   * @param content
   * @return int    status code
   * @throws HttpException
   */
  public int sendRequest(final String methodName,
                         final String url,
                         final List<Header> hdrs,
                         final String contentType, final int contentLen,
                         final byte[] content) throws HttpException {
    return sendRequest(methodName, url, hdrs,
                       contentType, contentLen, content, null);
  }

  /** Send a request to the server
   *
   * @param methodName
   * @param url
   * @param hdrs
   * @param contentType
   * @param contentLen
   * @param content
   * @param params
   * @return int    status code
   * @throws HttpException
   */
  public int sendRequest(final String methodName,
                         final String url,
                         final List<Header> hdrs,
                         String contentType, final int contentLen,
                         final byte[] content,
                         final HttpParams params) throws HttpException {
    int sz = 0;
    if (content != null) {
      sz = content.length;
    }

    if (debug()) {
      debug("About to send request: method=" + methodName +
                    " url=" + url +
                    " contentLen=" + contentLen +
                    " content.length=" + sz +
                    " contentType=" + contentType);
    }

    try {
      URI u = new URI(url);

      if (!hostSpecified && (u.getHost() == null)) {
        if ((baseURI == null) && (baseURIValue != null)) {
          baseURI = new URI(baseURIValue);
        }

        if (baseURI == null) {
          throw new HttpException("No base URI specified for non-absolute URI " + url);
        }

        if (baseURI.getHost() == null) {
          throw new HttpException("Base URI must be absolute: " + baseURI);
        }

        u = baseURI.resolve(u);
      }

      if (debug()) {
        debug("      url resolves to " + u);
      }

      method = findMethod(methodName, u);

      if (credentials != null) {
        getCredentialsProvider().setCredentials(new AuthScope(u.getHost(),
                                                              u.getPort()),
                                                credentials);
      }

      if (!Util.isEmpty(hdrs)) {
        for (final Header hdr: hdrs) {
          method.addHeader(hdr);
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

      if (params != null) {
        method.setParams(params);
      }

      response = execute(method);
    } catch (final HttpException he) {
      throw he;
    } catch (final Throwable t) {
      throw new HttpException(t.getLocalizedMessage(), t);
    }
    status = response.getStatusLine().getStatusCode();

    return status;
  }

  public InputStream post(final String url,
                          final List<Header> hdrs,
                          final HttpEntity entity) throws HttpException {
    final HttpPost poster = new HttpPost(url);

    poster.setEntity(entity);

    try {
      // Make the request
      response = execute(poster);

      status = response.getStatusLine().getStatusCode();

      return getResponseBodyAsStream();
    } catch (final HttpException he) {
      throw he;
    } catch (final Throwable t) {
      throw new HttpException(t.getLocalizedMessage(), t);
    }
  }

  /** Send content
   *
   * @param content the content as bytes
   * @param contentType its type
   * @throws HttpException
   */
  public void setContent(final byte[] content,
                         final String contentType) throws HttpException {
    if (!(method instanceof HttpEntityEnclosingRequestBase)) {
      throw new HttpException("Invalid operation for method " +
                               method.getMethod());
    }

    final HttpEntityEnclosingRequestBase eem = (HttpEntityEnclosingRequestBase)method;

    ByteArrayEntity entity = new ByteArrayEntity(content);
    entity.setContentType(contentType);
    eem.setEntity(entity);
  }

  /**
   * @author douglm
   */
  public class HttpMkcalendar extends HttpEntityEnclosingRequestBase {
    /**
     */
    public static final String METHOD_NAME = "MKCALENDAR";

    /**
     * @param uri
     */
    public HttpMkcalendar(final URI uri) {
      setURI(uri);
    }

    /**
     * @param uri
     * @throws IllegalArgumentException if the uri is invalid.
     */
    public HttpMkcalendar(final String uri) {
      super();
      setURI(URI.create(uri));
    }

    @Override
    public String getMethod() {
      return METHOD_NAME;
    }
  }

  /**
   * @author douglm
   */
  public class HttpMkcol extends HttpEntityEnclosingRequestBase {
    /**
     */
    public static final String METHOD_NAME = "MKCOL";

    /**
     * @param uri
     */
    public HttpMkcol(final URI uri) {
      setURI(uri);
    }

    /**
     * @param uri
     * @throws IllegalArgumentException if the uri is invalid.
     */
    public HttpMkcol(final String uri) {
      super();
      setURI(URI.create(uri));
    }

    @Override
    public String getMethod() {
      return METHOD_NAME;
    }
  }

  /**
   * @author douglm
   */
  public class HttpPropfind extends HttpEntityEnclosingRequestBase {
    /**
     */
    public static final String METHOD_NAME = "PROPFIND";

    /**
     * @param uri
     */
    public HttpPropfind(final URI uri) {
      setURI(uri);
    }

    /**
     * @param uri
     * @throws IllegalArgumentException if the uri is invalid.
     */
    public HttpPropfind(final String uri) {
      super();
      setURI(URI.create(uri));
    }

    @Override
    public String getMethod() {
      return METHOD_NAME;
    }
  }

  /**
   * @author douglm
   */
  public class HttpReport extends HttpEntityEnclosingRequestBase {
    /**
     */
    public static final String METHOD_NAME = "REPORT";

    /**
     * @param uri
     */
    public HttpReport(final URI uri) {
      setURI(uri);
    }

    /**
     * @param uri
     * @throws IllegalArgumentException if the uri is invalid.
     */
    public HttpReport(final String uri) {
      super();
      setURI(URI.create(uri));
    }

    @Override
    public String getMethod() {
      return METHOD_NAME;
    }
  }

  /** Specify the next method by name.
   *
   * @param name of the method
   * @param uri target
   * @return method object
   * @throws HttpException
   */
  protected HttpRequestBase findMethod(final String name,
                                       final URI uri) throws HttpException {
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

    if ("PROPFIND".equals(nm)) {
      return new HttpPropfind(uri);
    }

    if ("MKCALENDAR".equals(nm)) {
      return new HttpMkcalendar(uri);
    }

    if ("MKCOL".equals(nm)) {
      return new HttpMkcol(uri);
    }

    if ("OPTIONS".equals(nm)) {
      return new HttpOptions(uri);
    }

    if ("REPORT".equals(nm)) {
      return new HttpReport(uri);
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
    if (debug()) {
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
   * @return response code
   * @throws HttpException
   */
  public int delete(final String path,
                    final List<Header> hdrs) throws HttpException {
    int respCode = sendRequest("DELETE",
                               path,
                               hdrs,
                               null,
                               0,
                               null);    //content

    if (debug()) {
      debug("response code " + respCode);
    }

    return respCode;
  }

  /**
   * @param path
   * @param o
   * @param contentType
   * @return response code
   * @throws HttpException
   */
  public int putObject(final String path, final Object o,
                       final String contentType) throws HttpException {
    return putObject(path, null, o, contentType);
  }

  /**
   * @param path
   * @param hdrs extra headers or null
   * @param o
   * @param contentType
   * @return response code
   * @throws HttpException
   */
  public int putObject(final String path,
                       final List<Header> hdrs,
                       final Object o,
                       final String contentType) throws HttpException {
    String content = String.valueOf(o);
    int respCode = sendRequest("PUT",
                               path,
                               hdrs,
                               contentType,
                               content.length(),
                               content.getBytes());    //content

    if (debug()) {
      debug("response code " + respCode);
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
   * @return response status line
   * @throws HttpException
   */
  public StatusLine getResponseStatusLine() throws HttpException {
    if (response == null) {
      return null;
    }

    return response.getStatusLine();
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
   * @return headers or null
   * @throws HttpException
   */
  public Header[] getHeaders() throws HttpException {
    if (response == null) {
      return null;
    }

    return response.getAllHeaders();
  }

  /**
   * @param name
   * @return header or null
   * @throws HttpException
   */
  public Header getFirstHeader(final String name) throws HttpException {
    if (response == null) {
      return null;
    }

    return response.getFirstHeader(name);
  }

  /**
   * @param name
   * @return value of header or null
   * @throws HttpException
   */
  public String getFirstHeaderValue(final String name) throws HttpException {
    Header h = getFirstHeader(name);

    if (h == null) {
      return null;
    }

    return h.getValue();
  }

  /**
   * @param path  to resource
   * @return InputStream
   * @throws HttpException
   */
  public InputStream get(final String path) throws HttpException {
    return get(path, "application/text", null);
  }

  /**
   * @param path  to resource
   * @param contentType  - valid type
   * @param hdrs - may be null
   * @return InputStream
   * @throws HttpException
   */
  public InputStream get(final String path,
                         final String contentType,
                         final List<Header> hdrs) throws HttpException {
    final int respCode = sendRequest("GET",
                                     path,
                                     hdrs,
                                     contentType,
                                     0, // contentLen
                                     null);    //content

    if (debug()) {
      debug("getFile: response code " + respCode);
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
    try {
      release();
    } catch (final Throwable ignored) {
    }
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
