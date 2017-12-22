package org.bedework.util.timezones;

import org.bedework.util.http.HttpUtil;
import org.bedework.util.misc.Logged;
import org.bedework.util.timezones.model.CapabilitiesType;
import org.bedework.util.timezones.model.TimezoneListType;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.http.NameValuePair;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.utils.URIBuilder;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.message.BasicHeader;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;

import java.io.InputStream;
import java.net.URI;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import javax.servlet.http.HttpServletResponse;

/** CLass to allow us to call the server
 */
public class TzServer extends Logged implements AutoCloseable {
  private static String tzserverUri;

  private CapabilitiesType capabilities;

  private final ObjectMapper om;

  private CloseableHttpClient client;
  private int status;

  /**
   * @param uri the uri
   * @throws TimezonesException on discovery failure
   */
  public TzServer(final String uri) throws TimezonesException {
    om = new ObjectMapper();

    /* Don't use dates in json - still issues with timezones ironically */
    //DateFormat df = new SimpleDateFormat("yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'");

    //om.setDateFormat(df);

    om.setSerializationInclusion(JsonInclude.Include.NON_NULL);
    tzserverUri = discover(uri);
  }

  /**
   * @param id the tz id
   * @param etag from last time
   * @return fetch timezone if etag is old
   * @throws TimezonesException on error
   */
  public Timezones.TaggedTimeZone getTz(final String id,
                                        final String etag) throws TimezonesException {
    try (CloseableHttpResponse hresp =
      doCall(etag,
             new BasicNameValuePair("action", "get"),
             new BasicNameValuePair("tzid", id))) {
      if (status == HttpServletResponse.SC_NO_CONTENT) {
        return new Timezones.TaggedTimeZone(etag);
      }

      if (status != HttpServletResponse.SC_OK) {
        return null;
      }

      final String respEtag = HttpUtil.getFirstHeaderValue(hresp, "Etag");
      if (respEtag == null) {
        // Not valid but keep calm and carry on
        return new Timezones.TaggedTimeZone("--No etag--",
                                            EntityUtils.toString(hresp.getEntity()));
      }
      return new Timezones.TaggedTimeZone(respEtag,
                                          EntityUtils.toString(hresp.getEntity()));
    } catch (final TimezonesException cfe) {
      throw cfe;
    } catch (final Throwable t) {
      throw new TimezonesException(t);
    }
  }

  /* Not used - remove from server
  public String getNames() throws TimezonesException {
    return call("names");
  }*/

  /**
   * @param changedSince datestamp
   * @return List of timezone information
   * @throws TimezonesException on error
   */
  public TimezoneListType getList(final String changedSince) throws TimezonesException {
    final List<NameValuePair> pars = new ArrayList<>();

    pars.add(new BasicNameValuePair("action", "list"));

    if (changedSince != null) {
      pars.add(new BasicNameValuePair("changedsince", changedSince));
    }

    final NameValuePair[] parsArray = pars.toArray(new NameValuePair[0]);

    try (CloseableHttpResponse hresp =
                 doCall(null,
                        parsArray)) {
      if (status != HttpServletResponse.SC_OK) {
        return null;
      }

      final InputStream is = hresp.getEntity().getContent();

      return om.readValue(is,  TimezoneListType.class);
    } catch (final Throwable t) {
      error("getList error: " + t.getMessage());
      t.printStackTrace();
      return null;
    }
  }

  /**
   * @return populated Properties object with alias data
   * @throws TimezonesException on error
   */
  public Properties getAliases() throws TimezonesException {
    try (CloseableHttpResponse hresp =
                 doCall(null,
                        new BasicNameValuePair("aliases", null))) {
      if (status != HttpServletResponse.SC_OK) {
        return null;
      }

      final Properties a = new Properties();

      final InputStream is = hresp.getEntity().getContent();

      a.load(is);

      return a;
    } catch (final Throwable t) {
      error("getAliases error: " + t.getMessage());
      t.printStackTrace();
      return null;
    }
  }

  /**
   * @return capabilities obtained at discovery phase
   */
  public CapabilitiesType getCapabilities() {
    return capabilities;
  }

  /**
   */
  public void close() {
  }

  /* ====================================================================
   *                   private methods
   * ==================================================================== */

  /** See if we have a url for the service. If not discover the real one.
   *
   * <p>If the uri is parseable we won't even attempt the /.well-known approach.
   * It implies we have a scheme etc.
   *
   * <p>Otherwise we will assume it's a host attempt to discover it through
   * /.well-known
   *
   * @param url the service url
   * @return discovered url
   * @throws TimezonesException on error
   */
  private String discover(final String url) throws TimezonesException {
    /* For the moment we'll try to find it via .well-known. We may have to
     * use DNS SRV lookups
     */
//    String domain = hi.getHostname();

  //  int lpos = domain.lastIndexOf(".");
    //int lpos2 = domain.lastIndexOf(".", lpos - 1);

//    if (lpos2 > 0) {
  //    domain = domain.substring(lpos2 + 1);
    //}

    String realUrl;

    try {
      /* See if it's a real url */
      new URL(url);
      realUrl = url;
    } catch (final Throwable t) {
      realUrl = "https://" + url + "/.well-known/timezone";
    }

    for (int redirects = 0; redirects < 10; redirects++) {
      try (CloseableHttpResponse hresp =
                   doCall(realUrl,
                          (String)null,
                          new BasicNameValuePair("action",
                                                 "capabilities"))) {

        if ((status == HttpServletResponse.SC_MOVED_PERMANENTLY) ||
                (status == HttpServletResponse.SC_MOVED_TEMPORARILY) ||
                (status == HttpServletResponse.SC_TEMPORARY_REDIRECT)) {
          //boolean permanent = rcode == HttpServletResponse.SC_MOVED_PERMANENTLY;

          final String newLoc =
                  HttpUtil.getFirstHeaderValue(hresp,
                                               "location");
          if (newLoc != null) {
            if (debug) {
              debug("Got redirected to " + newLoc +
                            " from " + url);
            }

            final int qpos = newLoc.indexOf("?");

            if (qpos < 0) {
              realUrl = newLoc;
            } else {
              realUrl = newLoc.substring(0, qpos);
            }

            // Try again
            continue;
          }
        }

        if (status != HttpServletResponse.SC_OK) {
          // The response is invalid and did not provide the new location for
          // the resource.  Report an error or possibly handle the response
          // like a 404 Not Found error.
          if (debug) {
            error("Got response " + status +
                          ", from " + realUrl);
          }

          throw new TimezonesException("Got response " + status +
                                               ", from " + realUrl);
        }

        /* Should have a capabilities record. */
        try {
          capabilities = om.readValue(hresp.getEntity().getContent(),
                                      CapabilitiesType.class);
        } catch (final Throwable t) {
          // Bad data - we'll just go with the url for the moment?
          error(t);
        }

        return realUrl;
      } catch (final TimezonesException tze) {
        throw tze;
      } catch (final Throwable t) {
        if (debug) {
          error(t);
        }

        throw new TimezonesException(t);
      }
    }

    if (debug) {
      error("Too many redirects: Got response " + status +
                    ", from " + realUrl);
    }

    throw new TimezonesException("Too many redirects on " + realUrl);
  }

  private CloseableHttpResponse doCall(final String etag,
                                       final NameValuePair... params) throws TimezonesException {
    if (tzserverUri == null) {
      throw new TimezonesException("No timezones server URI defined");
    }

    return doCall(tzserverUri, etag, params);
  }

  private CloseableHttpResponse doCall(final String serverUrl,
                                       final String etag,
                                       final NameValuePair... params) throws TimezonesException {
    try {
      final URI tzUri = new URI(serverUrl);
      final URI uri = new URIBuilder()
              .setScheme(tzUri.getScheme())
              .setHost(tzUri.getHost())
              .setPort(tzUri.getPort())
              .setPath(tzUri.getPath())
              .setParameters(params)
              .build();

      final HttpGet httpGet = new HttpGet(uri);

      if (etag != null) {
        httpGet.addHeader(new BasicHeader("If-None-Match", etag));
        httpGet.addHeader(new BasicHeader("Accept", "application/json"));
      }

      final CloseableHttpResponse resp = getClient().execute(httpGet);

      status = HttpUtil.getStatus(resp);

      return resp;
    } catch (final Throwable t) {
      throw new TimezonesException(t);
    }
  }

  private CloseableHttpClient getClient() {
    if (client != null) {
      return client;
    }

    client = HttpUtil.getClient(true);

    return client;
  }
}
