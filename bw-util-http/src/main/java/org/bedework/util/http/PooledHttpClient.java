/* ********************************************************************
    Appropriate copyright notice
*/
package org.bedework.util.http;

import org.bedework.util.http.HttpUtil.HeadersFetcher;
import org.bedework.util.misc.Util;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.http.HttpEntity;
import org.apache.http.HttpException;
import org.apache.http.HttpHost;
import org.apache.http.NameValuePair;
import org.apache.http.client.CredentialsProvider;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.utils.URIUtils;
import org.apache.http.conn.routing.HttpRoute;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.impl.conn.PoolingHttpClientConnectionManager;
import org.apache.http.pool.PoolStats;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.StringWriter;
import java.net.URI;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.concurrent.TimeUnit;

import javax.servlet.http.HttpServletResponse;

/**
 * Carry out all communications with web service
 *
 * User: mikeD
 */
public class PooledHttpClient {
  private static final PoolingHttpClientConnectionManager connManager;

  public static class IdleConnectionMonitorThread extends Thread {

    private final PoolingHttpClientConnectionManager connMgr;
    private volatile boolean shutdown;

    public IdleConnectionMonitorThread(
            final PoolingHttpClientConnectionManager connMgr) {
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
      } catch (final InterruptedException ex) {
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

  static {
    connManager = new PoolingHttpClientConnectionManager();

    // Increase max total connection to 200
    connManager.setMaxTotal(200);
    // Increase default max connection per route to 20
    connManager.setDefaultMaxPerRoute(20);

    // Increase max connections for localhost:80 to 50
    final HttpHost localhost = new HttpHost("localhost", 80);
    connManager.setMaxPerRoute(new HttpRoute(localhost), 50);

    // Increase max connections for localhost:8080 to 50
    final HttpHost localhost8080 = new HttpHost("localhost", 8080);
    connManager.setMaxPerRoute(new HttpRoute(localhost8080), 50);

    idleConnectionMonitor = new IdleConnectionMonitorThread(connManager);
    idleConnectionMonitor.start();
  }

  private final CloseableHttpClient http;
  private final ObjectMapper om;
  private final URI baseUri;
  private HeadersFetcher headersFetcher;

  public interface ProcessResponse {
    /**
     *
     * @param path from call
     * @param resp from request
     * @return http status code
     */
    ResponseHolder process(String path,
                           CloseableHttpResponse resp);
  }

  public PooledHttpClient(final URI uri) {
    this(uri, null);
  }

  public PooledHttpClient(final URI uri,
                          final ObjectMapper om) {
    this.om = om;
    baseUri = uri;

    http = HttpClients.custom()
                      .setConnectionManager(connManager)
                      .setConnectionManagerShared(true)
                      .build();
  }

  public PooledHttpClient(final URI uri,
                          final ObjectMapper om,
                          final CredentialsProvider credsProvider) {
    this.om = om;
    baseUri = uri;

    HttpClientBuilder builder = HttpClients.custom()
                                   .setConnectionManager(connManager)
                                   .setConnectionManagerShared(true);

    if (credsProvider != null) {
      builder.setDefaultCredentialsProvider(credsProvider);
    }

    http = builder.build();
  }

  public void setHeadersFetcher(final HeadersFetcher headersFetcher) {
    this.headersFetcher = headersFetcher;
  }

  /*
   *
   * @return headers for the request
   */
  //public abstract Headers getHeaders();

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
   * @param host the host
   * @param port the port number
   * @param max number connections
   */
  public static void setHostLimit(final String host,
                                  final int port,
                                  final int max) {
    final HttpHost hostPort = new HttpHost(host, port);
    connManager.setMaxPerRoute(new HttpRoute(hostPort), max);
  }

  /**
   *
   * @param request the path and request
   * @param valueTypeRef for jackson mapper
   * @param <T> class of response
   * @return Object of class t
   * @throws HttpException on fatal error
   */
  public <T> T getJson(final String request,
                       final TypeReference<T> valueTypeRef) throws HttpException {
    try (CloseableHttpResponse hresp =
                 HttpUtil.doGet(http,
                                resolve(request),
                                headersFetcher,
                                "application/json")) {
      final InputStream is = hresp.getEntity().getContent();

      if (is == null) {
        return null;
      }

      return om.readValue(is, valueTypeRef);
    } catch (final Throwable t) {
      throw new HttpException(t.getMessage(), t);
    }
  }

  /**
   *
   * @param request the path and request
   * @param valueType for jackson mapper
   * @param <T> class of response
   * @return Object of class t
   * @throws HttpException on fatal error
   */
  public <T> T getJson(final String request,
                       final Class<T> valueType) throws HttpException {
    try (CloseableHttpResponse hresp =
                 HttpUtil.doGet(http,
                                resolve(request),
                                headersFetcher,
                                "application/json")) {
      final InputStream is = hresp.getEntity().getContent();

      if (is == null) {
        return null;
      }

      return om.readValue(is, valueType);
    } catch (final Throwable t) {
      throw new HttpException(t.getMessage(), t);
    }
  }

  public Long getLong(final String request) throws HttpException {
    try (CloseableHttpResponse hresp =
                 HttpUtil.doGet(http,
                                resolve(request),
                                headersFetcher,
                                "text/text")) {
      final InputStream is = hresp.getEntity().getContent();

      if (is == null) {
        return null;
      }

      final int bufSize = 2048;
      final byte[] buf = new byte[bufSize];
      int pos = 0;
      while (true) {
        final int len = is.read(buf, pos, bufSize - pos);
        if (len == -1) {
          break;
        }

        pos += len;

        if (pos >= bufSize) {
          return null;
        }
      }

      return Long.valueOf(new String(buf, 0, pos));
    } catch (final Throwable t) {
      throw new HttpException(t.getMessage(), t);
    }
  }

  public boolean getBinary(final String request,
                           final OutputStream out) throws HttpException {
    try (CloseableHttpResponse hresp =
                 HttpUtil.doGet(http,
                                resolve(request),
                                headersFetcher,
                                "application/binary")) {
      final InputStream is = hresp.getEntity().getContent();

      if (is == null) {
        return false;
      }

      final int bufSize = 2048;
      final byte[] buf = new byte[bufSize];
      while (true) {
        final int len = is.read(buf, 0, bufSize);
        if (len == -1) {
          break;
        }
        out.write(buf, 0, len);
      }

      return true;
    } catch (final Throwable t) {
      throw new HttpException(t.getMessage(), t);
    }
  }

  public String getString(final String request,
                          final String acceptContentType) throws HttpException {
    try (CloseableHttpResponse hresp =
                 HttpUtil.doGet(http,
                                resolve(request),
                                headersFetcher,
                                acceptContentType)) {
      final InputStream is = hresp.getEntity().getContent();

      if (is == null) {
        return null;
      }

      final ByteArrayOutputStream baos = new ByteArrayOutputStream();

      final int bufSize = 2048;
      final byte[] buf = new byte[bufSize];
      while (true) {
        final int len = is.read(buf, 0, bufSize);
        if (len == -1) {
          break;
        }

        baos.write(buf, 0, len);
      }

      return baos.toString(StandardCharsets.UTF_8);
    } catch (final Throwable t) {
      throw new HttpException(t.getMessage(), t);
    }
  }

  /** Do a get on a url
   *
   * @param request to be resolved
   * @param acceptContentType of response
   * @param responseProcessor handle response
   * @return Response for status
   * @throws HttpException on fatal error
   */
  public ResponseHolder get(final String request,
                            final String acceptContentType,
                            final ProcessResponse responseProcessor) throws HttpException {
    try (CloseableHttpResponse hresp =
                 HttpUtil.doGet(http,
                                resolve(request),
                                headersFetcher,
                                acceptContentType)) {
      final int status = HttpUtil.getStatus(hresp);

      if (status != HttpServletResponse.SC_OK) {
        return new ResponseHolder(status,
                                  "Failed response from server");
      }

      if (responseProcessor == null) {
        return new ResponseHolder(null);
      }

      return responseProcessor.process(request, hresp);
    } catch (final Throwable t) {
      throw new HttpException(t.getMessage(), t);
    }
  }

  public static class ResponseHolder<T> {
    public boolean failed;

    public int status;

    public String message;

    public T response;

    /** Constructor for bad status
     *
     * @param status - http status
     */
    public ResponseHolder(final int status,
                          final String message) {
      this.status = status;
      this.message = message;
      failed = true;
    }

    public ResponseHolder(final T response) {
      this.response = response;
      failed = false;
    }
  }

  public <T> ResponseHolder<T> postJson(final String path,
                                        final String content,
                                        final Class<T> resultType) throws HttpException {
    try (CloseableHttpResponse hresp =
                 HttpUtil.doPost(http,
                                 resolve(path),
                                 headersFetcher,
                                 "application/json",
                                 content)) {
      final int status = HttpUtil.getStatus(hresp);

      if (status != HttpServletResponse.SC_OK) {
        return new ResponseHolder<>(status, "Failed response from server");
      }

      final InputStream is = hresp.getEntity().getContent();

      if (is == null) {
        return new ResponseHolder<>(status, "No content");
      }

      return new ResponseHolder<>(om.readValue(is, resultType));
    } catch (final Throwable t) {
      throw new HttpException(t.getMessage(), t);
    }
  }

  public ResponseHolder postXml(final String path,
                                final String xml) throws HttpException {
    try (CloseableHttpResponse hresp =
                 HttpUtil.doPost(http,
                                 resolve(path),
                                 headersFetcher,
                                 "application/xml",
                                 xml)) {
      final int status = HttpUtil.getStatus(hresp);

      if (status != HttpServletResponse.SC_OK) {
        return new ResponseHolder(status,
                                  "Failed response from server");
      }

      //noinspection unchecked
      return new ResponseHolder(null);
    } catch (final Throwable t) {
      throw new HttpException(t.getMessage(), t);
    }
  }

  public ResponseHolder post(final String path,
                             final HttpEntity entity,
                             final ProcessResponse responseProcessor) throws HttpException {
    try (CloseableHttpResponse hresp =
                 HttpUtil.doPost(http,
                                 resolve(path),
                                 headersFetcher,
                                 entity)) {
      if (responseProcessor == null) {
        return new ResponseHolder(null);
      }

      return responseProcessor.process(path, hresp);
    } catch (final Throwable t) {
      throw new HttpException(t.getMessage(), t);
    }
  }

  public <T> ResponseHolder<T> postJson(final String path,
                                        final Object content,
                                        final Class<T> resultType) throws HttpException {
    final String scontent;
    if (content == null) {
      scontent = null;
    } else {
      final StringWriter sw = new StringWriter();
      try {
        om.writeValue(sw, content);
      } catch (final Throwable t) {
        throw new HttpException(t.getMessage(), t);
      }
      scontent = sw.toString();
    }

    return postJson(path, scontent, resultType);
  }

  /**
   *
   * @param path of resource
   * @param content - assumed to be json
   * @return status
   * @throws HttpException on fatal error
   */
  public int postJson(final String path,
                      final String content) throws HttpException {
    try (CloseableHttpResponse hresp =
                 HttpUtil.doPost(http,
                                 resolve(path),
                                 headersFetcher,
                                 "application/json",
                                 content)) {
      return HttpUtil.getStatus(hresp);
    } catch (final Throwable t) {
      throw new HttpException(t.getMessage(), t);
    }
  }

  /**
   *
   * @param path of resource
   * @param content to put
   * @param contentType of content
   * @return status
   * @throws HttpException on fatal error
   */
  public int put(final String path,
                 final String content,
                 final String contentType) throws HttpException {
    try (CloseableHttpResponse hresp =
                 HttpUtil.doPut(http,
                                 resolve(path),
                                 headersFetcher,
                                 contentType,
                                 content)) {
      return HttpUtil.getStatus(hresp);
    } catch (final Throwable t) {
      throw new HttpException(t.getMessage(), t);
    }
  }

  public <T> ResponseHolder<T> postForm(final String path,
                                        final List<NameValuePair> nvps,
                                        final Class<T> resultType) throws HttpException {
    final String scontent;

    try {
      String delim = "";

      if (!Util.isEmpty(nvps)) {
        final StringBuilder content = new StringBuilder();

        for (final NameValuePair nvp : nvps) {
          content.append(delim);
          delim = "&";
          content.append(nvp.getName());
          content.append("=");
          content.append(encode(nvp.getValue()));

        }

        scontent = content.toString();
      } else {
        scontent = null;
      }
    } catch (final Throwable t) {
      throw new HttpException(t.getMessage(), t);
    }

    try (CloseableHttpResponse hresp =
                 HttpUtil.doPost(http,
                                 resolve(path),
                                 headersFetcher,
                                 "application/x-www-form-urlencoded",
                                 scontent)) {
      final int status = HttpUtil.getStatus(hresp);

      if (status != HttpServletResponse.SC_OK) {
        return new ResponseHolder<>(status, "Failed response from server");
      }

      final InputStream is = hresp.getEntity().getContent();

      if (is == null) {
        return new ResponseHolder<>(status, "No content");
      }

      return new ResponseHolder<>(om.readValue(is, resultType));
    } catch (final Throwable t) {
      throw new HttpException(t.getMessage(), t);
    }
  }

  public ResponseHolder report(final String path,
                               final String depth,
                               final String content,
                               final ProcessResponse responseProcessor) throws HttpException {
    try (CloseableHttpResponse hresp =
                 HttpUtil.doReport(http,
                                 resolve(path),
                                 headersFetcher,
                                 depth,
                                 "text/xml",
                                 content)) {

      return responseProcessor.process(path, hresp);
    } catch (final Throwable t) {
      throw new HttpException(t.getMessage(), t);
    }
  }

  public ResponseHolder propfind(final String path,
                                 final String depth,
                                 final String content,
                                 final ProcessResponse responseProcessor) throws HttpException {
    try (CloseableHttpResponse hresp =
                 HttpUtil.doPropfind(http,
                                     resolve(path),
                                     headersFetcher,
                                     depth,
                                     "text/xml",
                                     content)) {

      return responseProcessor.process(path, hresp);
    } catch (final Throwable t) {
      throw new HttpException(t.getMessage(), t);
    }
  }

  /**
   *
   * @param path of resource to delete
   * @return response hiolder with status or null object
   * @throws HttpException on fatal error
   */
  public ResponseHolder delete(final String path) throws HttpException {
    if (path == null) {
      return null;
    }

    try (CloseableHttpResponse hresp =
                 HttpUtil.doDelete(http,
                                   resolve(path),
                                   headersFetcher,
                                   "application/json")) {
      final int status = HttpUtil.getStatus(hresp);

      if (status != HttpServletResponse.SC_OK) {
        return new ResponseHolder(status,
                                  "Failed response from server");
      }

      //noinspection unchecked
      return new ResponseHolder(null);
    } catch (final Throwable t) {
      throw new HttpException(t.getMessage(), t);
    }
  }

  public void release() {
    try {
      http.close();
    } catch (final Throwable t) {
      throw new RuntimeException(t.getMessage(), t);
    }
  }

  private String encode(final String val) throws HttpException {
    try {
      return URLEncoder.encode(val, StandardCharsets.UTF_8);
    } catch (final Throwable t) {
      throw new HttpException(t.getMessage(), t);
    }
  }

  private URI resolve(final String request) {
    return URIUtils.resolve(baseUri, request);
  }

  private static Headers ensureHeaders(final Headers hdrs) {
    if (hdrs == null) {
      return new Headers();
    }
    return hdrs;
  }
}
