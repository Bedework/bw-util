package org.bedework.util.timezones;

import org.bedework.util.http.BasicHttpClient;
import org.bedework.util.timezones.Timezones.TaggedTimeZone;
import org.bedework.util.timezones.model.CapabilitiesType;
import org.bedework.util.timezones.model.TimezoneListType;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.http.Header;
import org.apache.http.message.BasicHeader;
import org.apache.http.util.EntityUtils;
import org.apache.log4j.Logger;

import java.io.InputStream;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

/** CLass to allow us to call the server
 */
public class TzServer {
  private transient Logger log;

  protected boolean debug;

  private static String tzserverUri;

  private CapabilitiesType capabilities;

  private final ObjectMapper om;

  private BasicHttpClient client;
  private int status;

  /**
   * @param uri the uri
   * @throws TimezonesException on error
   */
  public TzServer(final String uri) throws TimezonesException {
    debug = getLogger().isDebugEnabled();
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
  public TaggedTimeZone getTz(final String id,
                              final String etag) throws TimezonesException {
    try {
      doCall("action=get&tzid=" +
        URLEncoder.encode(id, "UTF-8"), etag);
//        doCall("action=get&tzid=" + id, etag);

      if (status == HttpServletResponse.SC_NO_CONTENT) {
        return new TaggedTimeZone(etag);
      }

      if (status != HttpServletResponse.SC_OK) {
        return null;
      }

      final String respEtag = client.getFirstHeaderValue("Etag");
      if (respEtag == null) {
        // Not valid but keep calm and carry on
        return new TaggedTimeZone("--No etag--",
                                  EntityUtils.toString(client.getResponseEntity()));
      }
      return new TaggedTimeZone(respEtag,
                                EntityUtils.toString(client.getResponseEntity()));
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
   * @throws TimezonesException on error unmarshalling
   */
  public TimezoneListType getList(final String changedSince) throws TimezonesException {
    String req = "action=list";

    if (changedSince != null) {
      req = req + "&changedsince=" + changedSince;
    }

    return getJson(req, TimezoneListType.class);
  }

  /**
   * @return Input stream of alias data
   * @throws TimezonesException on error
   */
  public InputStream getAliases() throws TimezonesException {
    return callForStream("aliases");
  }

  /**
   * @return capabilities obtained at discovery phase
   */
  public CapabilitiesType getCapabilities() {
    return capabilities;
  }

  /**
   * @throws TimezonesException on error
   */
  public void close() throws TimezonesException {
    try {
      if (client == null) {
        return;
      }

      client.release();
    } catch (final Throwable t) {
      throw new TimezonesException(t);
    }
  }

  /* ====================================================================
   *                   protected methods
   * ==================================================================== */

  protected <T> T getJson(final String req,
                       final Class<T> valueType) throws TimezonesException {
    InputStream is = null;
    try {
      is = callForStream(req);

      if ((is == null) || (status != HttpServletResponse.SC_OK)) {
        return null;
      }

      synchronized (this) {
        return om.readValue(is, valueType);
      }
    } catch (final TimezonesException cfe) {
      throw cfe;
    } catch (final Throwable t) {
      throw new TimezonesException(t);
    } finally {
      if (is != null) {
        try {
          is.close();
        } catch (final Throwable ignored) {}
      }
    }
  }

  /**
   * @param req request
   * @return input stream from response
   * @throws TimezonesException on error
   */
  protected InputStream callForStream(final String req) throws TimezonesException {
    try {
      doCall(req, null);

      if (status != HttpServletResponse.SC_OK) {
        return null;
      }

      return client.getResponseBodyAsStream();
    } catch (final TimezonesException cfe) {
      throw cfe;
    } catch (final Throwable t) {
      throw new TimezonesException(t);
    }
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
   * @param url the servicen url
   * @return discovered url
   * @throws TimezonesException
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

    try {
      client = new BasicHttpClient(30 * 1000,
                                   false);  // followRedirects
      for (int redirects = 0; redirects < 10; redirects++) {
        status = client.sendRequest("GET",
                                    realUrl + "?action=capabilities",
                                    null,
                                    "application/json",
                                    0,
                                    null);

        if ((status == HttpServletResponse.SC_MOVED_PERMANENTLY) ||
            (status == HttpServletResponse.SC_MOVED_TEMPORARILY) ||
            (status == HttpServletResponse.SC_TEMPORARY_REDIRECT)) {
          //boolean permanent = rcode == HttpServletResponse.SC_MOVED_PERMANENTLY;

          final String newLoc = client.getFirstHeaderValue("location");
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

            client.release();

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
          capabilities = om.readValue(client.getResponseEntity().getContent(),
                                      CapabilitiesType.class);
        } catch (final Throwable t) {
          // Bad data - we'll just go with the url for the moment?
          error(t);
        }

        return realUrl;
      }

      if (debug) {
        error("Too many redirects: Got response " + status +
              ", from " + realUrl);
      }

      throw new TimezonesException("Too many redirects on " + realUrl);
    } catch (final TimezonesException tze) {
      throw tze;
    } catch (final Throwable t) {
      if (debug) {
        error(t);
      }

      throw new TimezonesException(t);
    } finally {
      try {
        if (client != null) {
          client.release();
        }
      } catch (final Throwable ignored) {
      }
    }
  }

  private void doCall(final String req,
                      final String etag) throws TimezonesException {
    try {
      if (tzserverUri == null) {
        throw new TimezonesException("No timezones server URI defined");
      }

      if (client == null) {
        client = new BasicHttpClient(30 * 1000, false);
      }

      final List<Header> hdrs = new ArrayList<>();
      hdrs.add( new BasicHeader("If-None-Match", etag));

      status = client.sendRequest("GET",
                                  tzserverUri + "?" + req,
                                  hdrs,
                                  "application/json",
                                  0,
                                  null);
    } catch (final TimezonesException cfe) {
      throw cfe;
    } catch (final Throwable t) {
      throw new TimezonesException(t);
    }
  }

  /* Get a logger for messages
   */
  private Logger getLogger() {
    if (log == null) {
      log = Logger.getLogger(this.getClass());
    }

    return log;
  }

  private void error(final Throwable t) {
    getLogger().error(this, t);
  }

  private void error(final String msg) {
    getLogger().error(msg);
  }

  private void debug(final String msg) {
    getLogger().debug(msg);
  }
}
