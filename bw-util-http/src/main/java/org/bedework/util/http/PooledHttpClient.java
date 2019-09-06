/* ********************************************************************
    Appropriate copyright notice
*/
package org.bedework.util.http;

import org.bedework.util.http.HttpUtil.HeadersFetcher;
import org.bedework.util.misc.Util;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.http.HttpException;
import org.apache.http.HttpHost;
import org.apache.http.NameValuePair;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.utils.URIUtils;
import org.apache.http.conn.routing.HttpRoute;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.impl.conn.PoolingHttpClientConnectionManager;
import org.apache.http.pool.PoolStats;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.StringWriter;
import java.net.URI;
import java.net.URLEncoder;
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

  public PooledHttpClient(final URI uri) throws HttpException {
    this(uri, null);
  }

  public PooledHttpClient(final URI uri,
                          final ObjectMapper om) throws HttpException {
    this.om = om;
    baseUri = uri;

    http = HttpClients.custom()
                      .setConnectionManager(connManager)
                      .build();
  }

  public void setHeadersFetcher(final HeadersFetcher headersFetcher) {
    this.headersFetcher = headersFetcher;
  }

  /**
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
                       final TypeReference valueTypeRef) throws HttpException {
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
    } catch (final HttpException he) {
      throw he;
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
    } catch (final HttpException he) {
      throw he;
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
    } catch (final HttpException he) {
      throw he;
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
    } catch (final HttpException he) {
      throw he;
    } catch (final Throwable t) {
      throw new HttpException(t.getMessage(), t);
    }
  }

  public String getString(final String request,
                          final String contentType) throws HttpException {
    try (CloseableHttpResponse hresp =
                 HttpUtil.doGet(http,
                                resolve(request),
                                headersFetcher,
                                contentType)) {
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

      return baos.toString("UTF-8");
    } catch (final HttpException he) {
      throw he;
    } catch (final Throwable t) {
      throw new HttpException(t.getMessage(), t);
    }
  }

  public class ResponseHolder<T> {
    public boolean failed;

    public int status;

    public String message;

    public T response;

    /** Constructor for bad status
     *
     * @param status - http status
     */
    ResponseHolder(final int status,
                   final String message) {
      this.status = status;
      this.message = message;
      failed = true;
    }

    ResponseHolder(final T response) {
      this.response = response;
      failed = false;
    }
  }

  public <T> ResponseHolder<T> post(final String path,
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
        return new ResponseHolder<T>(status, "Failed response from server");
      }

      final InputStream is = hresp.getEntity().getContent();

      if (is == null) {
        return new ResponseHolder<T>(status, "No content");
      }

      return new ResponseHolder<T>(om.readValue(is, resultType));
    } catch (final HttpException he) {
      throw he;
    } catch (final Throwable t) {
      throw new HttpException(t.getMessage(), t);
    }
  }

  public <T> ResponseHolder<T> post(final String path,
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

    return post(path, scontent, resultType);
  }

  /**
   *
   * @param path of resource
   * @param content - assumed to be json
   * @return status
   * @throws HttpException on fatal error
   */
  public int post(final String path,
                  final String content) throws HttpException {
    try (CloseableHttpResponse hresp =
                 HttpUtil.doPost(http,
                                 resolve(path),
                                 headersFetcher,
                                 "application/json",
                                 content)) {
      return HttpUtil.getStatus(hresp);
    } catch (final HttpException he) {
      throw he;
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
        return new ResponseHolder<T>(status, "Failed response from server");
      }

      final InputStream is = hresp.getEntity().getContent();

      if (is == null) {
        return new ResponseHolder<T>(status, "No content");
      }

      return new ResponseHolder<T>(om.readValue(is, resultType));
    } catch (final HttpException he) {
      throw he;
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
    } catch (final HttpException he) {
      throw he;
    } catch (final Throwable t) {
      throw new HttpException(t.getMessage(), t);
    }
  }

  public void release() throws HttpException {
    try {
      http.close();
    } catch (final Throwable t) {
      throw new HttpException(t.getMessage(), t);
    }
  }

  private String encode(final String val) throws HttpException {
    try {
      return URLEncoder.encode(val, "UTF-8");
    } catch (final Throwable t) {
      throw new HttpException(t.getMessage(), t);
    }
  }

  private URI resolve(final String request) throws HttpException {
    return URIUtils.resolve(baseUri, request);
  }

  private static Headers ensureHeaders(final Headers hdrs) {
    if (hdrs == null) {
      return new Headers();
    }
    return hdrs;
  }
}
