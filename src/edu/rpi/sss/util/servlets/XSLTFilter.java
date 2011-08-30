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

import edu.rpi.sss.util.servlets.io.ByteArrayWrappedResponse;

import org.apache.log4j.Logger;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Properties;

import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.xml.transform.SourceLocator;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

/** Class to implement a basic XSLT filter. The final configuration of this
 *  object can be carried out by overriding init.
 *  <p>Loosely based on some public example of filter code.</p>
 */
public class XSLTFilter extends AbstractFilter {
  /** A transformer is identified by a path like key of locale + browser +
   * skin name (with path delimiters).
   *
   * <p>Thsi may not be the actual path as components may be defaulted.
   * pathMap maps the 'ideal' path on to the actual path to the skin.
   */
  private static HashMap<String, String> pathMap = new HashMap<String, String>();

  private static HashMap<String, Transformer> transformers =
    new HashMap<String, Transformer>();

  /** This can be set in the web.xml configuration to run with a single
   * transformer
   */
  private String configUrl;

  private boolean ignoreContentType;

  private TransformerFactory tf = TransformerFactory.newInstance();

  /** globals
   *
   */
  public static class XsltGlobals extends AbstractFilter.FilterGlobals {
    /** Url for the next transform.
     */
    public String url;

    /** Reason we had a problem
     */
    public String reason = null;
  }

  /**
   * @param req
   * @return our globals
   */
  public XsltGlobals getXsltGlobals(final HttpServletRequest req) {
    return (XsltGlobals)getGlobals(req);
  }

  /* (non-Javadoc)
   * @see edu.rpi.sss.util.servlets.AbstractFilter#newFilterGlobals()
   */
  @Override
  public AbstractFilter.FilterGlobals newFilterGlobals() {
    return new XsltGlobals();
  }

  /** Set the url to be used for the next transform.
   *
   * @param req
   * @param ideal
   */
  public void setUrl(final HttpServletRequest req, final String ideal) {
    getXsltGlobals(req).url = ideal;
  }

  /** Get the url to be used for the next transform.
   *
   * @param req
   * @return url
   */
  public String getUrl(final HttpServletRequest req) {
    return getXsltGlobals(req).url;
  }

  /** Set ideal to actual mapping.
   *
   * @param ideal
   * @param actual
   */
  public void setPath(final String ideal, final String actual) {
    synchronized (transformers) {
      pathMap.put(ideal, actual);
    }
  }

  /** Get the url to be used for the next transform after mapping with pathMap.
   *
   * @param ideal
   * @return url
   */
  public String lookupPath(final String ideal) {
    return pathMap.get(ideal);
  }

  /** Flush all the transformers - for ALL clients
   */
  public static void flushXslt() {
    synchronized (transformers) {
      transformers.clear();
      pathMap.clear();
    }
  }

  /** This method will only do something if there is no current XML transformer.
   *  A previous call to setXslt will discard any previous transformer.
   *  <p>Subclasses could call setXslt then call this method to check that the
   *  stylesheet is valid. A TransformerException provides inforamtion about
   *  where any error occuured.
   *
   * @param ideal          'ideal' path of the stylesheet
   * @return  Transformer  Existing or new XML transformer
   * @throws TransformerException
   * @throws ServletException
   * @throws FileNotFoundException
   */
  public Transformer getXmlTransformer(final String ideal)
      throws TransformerException, ServletException, FileNotFoundException {
    String url = lookupPath(ideal);
    if (debug) {
      getLogger().debug("getXmlTransformer: ideal = " + ideal +
                        " actual = " + url);
    }
    Transformer trans = transformers.get(url);

    if (trans != null) {
      return trans;
    }

    try {
      trans = tf.newTransformer(new StreamSource(url));
    } catch (TransformerConfigurationException tce) {
      /** Work our way down the chain to see if we have an embedded file
       * not found. If so, throw that to let the caller try another path.
       */
      Throwable cause = tce.getCause();
      while (cause instanceof TransformerException) {
        cause = ((TransformerException)cause).getCause();
      }

      if (!(cause instanceof FileNotFoundException)) {
        throw tce;
      }

      throw (FileNotFoundException)cause;
    } catch (Exception e) {
      getLogger().error("Could not initialize transform for " + url, e);
      throw new ServletException("Could not initialize transform for " + url, e);
    } finally {
  /*    if (is != null) {
        try {
          is.close();
        } catch (Exception fe) {}
      } */
    }

    synchronized (transformers) {
      Transformer trans2 = transformers.get(url);

      if (trans2 != null) {
        // somebody beat us to it.
        return trans2;
      }

      transformers.put(url, trans);
    }

    return trans;
  }

  /* (non-Javadoc)
   * @see javax.servlet.Filter#init(javax.servlet.FilterConfig)
   */
  @Override
  public void init(final FilterConfig filterConfig) throws ServletException {
    super.init(filterConfig);

    configUrl = filterConfig.getInitParameter("xslt");

    if ((configUrl != null) && debug) {
      getLogger().debug("Filter " + filterConfig.getFilterName() +
                                        " using xslt " + configUrl);
    }

    String temp = filterConfig.getInitParameter("ignoreContentType");

    ignoreContentType = "true".equals(temp);
  }

  @Override
  public void doFilter(final ServletRequest req,
                       final ServletResponse response,
                       final FilterChain filterChain)
         throws IOException, ServletException {
    HttpServletRequest hreq = (HttpServletRequest)req;
    final HttpServletResponse resp = (HttpServletResponse)response;
    long startTime = System.currentTimeMillis();

    XsltGlobals glob = getXsltGlobals(hreq);

    glob.reason = null;

    if (debug) {
      getLogger().debug("XSLTFilter: Accessing filter for " +
                        HttpServletUtils.getReqLine(hreq) + " " +
                        hreq.getMethod() +
                        " response class: " + resp.getClass().getName());
      getLogger().debug("XSLTFilter: response: " + resp);
    }

    ByteArrayOutputStream baos = new ByteArrayOutputStream();

    WrappedResponse wrappedResp = new WrappedResponse(resp, hreq, getLogger());

    filterChain.doFilter(req, wrappedResp);

    /* We don't get a session till we've been through to the servlet.
     */
    HttpSession sess = hreq.getSession(false);
    String sessId;
    if (sess == null) {
      sessId = "NONE";
    } else {
      sessId = sess.getId();
    }

    logTime("PRETRANSFORM", sessId,
            System.currentTimeMillis() - startTime);

    /** Ensure we're all set up to handle content
     */
    doPreFilter(hreq);

    byte[] bytes = wrappedResp.toByteArray();
    if ((bytes == null) || (bytes.length == 0)) {
      if (debug) {
        getLogger().debug("No content");
      }

//      xformNeeded[0] = false;
      wrappedResp.setTransformNeeded(false);
      glob.reason = "No content";
    }

    try {
      if ((!glob.dontFilter) && (wrappedResp.getTransformNeeded())) {
        if (debug) {
          getLogger().debug("+*+*+*+*+*+*+*+*+*+*+* about to transform: len=" +
                            bytes.length);
        }
        //getLogger().debug(new String(bytes));

        TransformerException te = null;
        Transformer xmlt = null;

        try {
          xmlt = getXmlTransformer(glob.url);
        } catch (TransformerException te1) {
          te = te1;
        }

        if (xmlt == null) {
          outputErrorMessage("No xml transformer",
                             "Unable to obtain an XML transformer probably " +
                                 "due to a previous error. Server logs may " +
                                 "help determine the cause.",
                             baos);
          glob.contentType = "text/html";
        } else if (te != null) {
          /** We had an exception getting the transformer.
              Output error information instead of the transformed output
           */

          outputInitErrorInfo(te, baos);
          glob.contentType = "text/html";
        } else {
          /** We seem to be getting invalid bytes occassionally
          for (int i = 0; i < bytes.length; i++) {
            if ((bytes[i] & 0x0ff) > 128) {
              getLogger().warn("Found byte > 128 at " + i +
                             " bytes = " + (bytes[i] & 0x0ff));
              bytes[i] = (int)('?');
            }
          }
          The above commented out. It breaks Unicode characters
           */
          /** Managed to get a transformer. Do the thing.
            */
          try {
            /* The choice is a pool of transformers per thread or to
               synchronize during the transform.

               Transforms appear to be fast, for a dynamic site they take a
               small proportiuon of the response time. Try synch for now.
             */
            synchronized (xmlt) {
              xmlt.transform(
                  new StreamSource(
                       new InputStreamReader(new ByteArrayInputStream(bytes),
                                             "UTF-8")),
                            new StreamResult(baos));
            }
          } catch (TransformerException e) {
            outputTransformErrorInfo(e, baos);
            glob.contentType = "text/html";
          }

          if (debug) {
            Properties pr = xmlt.getOutputProperties();
            if (pr != null) {
              Enumeration en = pr.propertyNames();
              while (en.hasMoreElements()) {
                String key = (String)en.nextElement();
                getLogger().debug("--------- xslt-output property " +
                                key + "=" + pr.getProperty(key));
              }
            }
          }
        }

        if (glob.contentType != null) {
          /** Set explicitly by caller.
           */
          resp.setContentType(glob.contentType);
        } else {
          /** The encoding and media type should be available from the
           *  Transformer. Letting the stylesheet dictate the media-type
           *  is the right thing to do as only the stylesheet knows what
           *  it's producing.
           */
          Properties pr = xmlt.getOutputProperties();
          if (pr != null) {
            String encoding = pr.getProperty("encoding");
            String mtype = pr.getProperty("media-type");

            if (mtype != null) {
              if (debug) {
                getLogger().debug("Stylesheet set media-type to " + mtype);
              }
              if (encoding != null) {
                resp.setContentType(mtype + ";charset=" + encoding);
              } else {
                resp.setContentType(mtype);
              }
            }
          }
        }

        byte[] xformBytes = baos.toByteArray();

        resp.setContentLength(xformBytes.length);
        resp.getOutputStream().write(xformBytes);

        if (debug) {
          getLogger().debug("XML -> HTML conversion completed");
        }
        xformBytes = null;
      } else {
        if (debug) {
          if (glob.dontFilter) {
            glob.reason = "dontFilter";
          }

          if (glob.reason == null) {
            glob.reason = "Unknown";
          }

          getLogger().debug("+*+*+*+*+*+*+*+*+*+*+* transform suppressed" +
                          " reason = " + glob.reason);
        }
        resp.setContentLength(bytes.length);
        resp.getOutputStream().write(bytes);
        if (glob.contentType != null) {
          /** Set explicitly by caller.
           */
          resp.setContentType(glob.contentType);
        }
      }
    } catch (Throwable t) {
      /** We're seeing tomcat specific exceptions here when the client aborts.
          Try to detect these without making this code tomcat specific.
       */
      if ("org.apache.catalina.connector.ClientAbortException".equals(t.getClass().getName())) {
        getLogger().warn("ClientAbortException: dropping response");
      } else {
        getLogger().error("Unable to transform document", t);
        throw new ServletException("Unable to transform document", t);
      }
    } finally {
      if (wrappedResp != null) {
        wrappedResp.close();
      }
      wrappedResp = null;
      if (baos != null) {
        try {
          baos.close();
        } catch (Exception bae) {}
      }

      baos = null;
      bytes = null;
    }

    logTime("POSTTRANSFORM", sessId,
            System.currentTimeMillis() - startTime);
  }

  private class WrappedResponse extends ByteArrayWrappedResponse {
    /* For xslt transformations */
    protected boolean transformNeeded = false;
    protected HttpServletRequest req;

    /**
     * @param response
     * @param req
     * @param log
     */
    public WrappedResponse(final HttpServletResponse response,
                           final HttpServletRequest req,
                           final Logger log) {
      super(response, log);
      this.req = req;
    }

    /**
     * @param val
     */
    public void setTransformNeeded(final boolean val) {
      transformNeeded = val;
    }

    /**
     * @return true for need to transform
     */
    public boolean getTransformNeeded() {
      return transformNeeded;
    }

    @Override
    public void setContentType(final String type) {
      XsltGlobals glob = getXsltGlobals(req);

      if (ignoreContentType) {
        transformNeeded = true;
      } else if ((type.startsWith("text/xml")) ||
                 (type.startsWith("application/xml"))) {
        if (debug) {
          getLogger().debug("XSLTFilter: Converting xml to html");
        }
        transformNeeded = true;
      } else {
        super.setContentType(type);
        if (debug) {
          glob.reason = "Content-type = " + type;
        }
      }
    }
  }

  @Override
  public void destroy() {
    super.destroy();
  }

  private void outputInitErrorInfo(final TransformerException te, final ByteArrayOutputStream wtr) {
    PrintWriter pw = new PrintWriter(wtr);

    outputErrorHtmlHead(pw, "XSLT initialization errors");
    pw.println("<body>");

    SourceLocator sl = te.getLocator();

    if (sl != null) {
      pw.println("<table>");
      outputErrorTr(pw, "Line", "" + sl.getLineNumber());
      outputErrorTr(pw, "Column", "" + sl.getColumnNumber());
      pw.println("</table>");
    }

    outputErrorException(pw, te.getCause());

    pw.println("</body>");
    pw.println("</html>");
  }

  private void outputTransformErrorInfo(final Exception e,
                                        final ByteArrayOutputStream wtr) {
    PrintWriter pw = new PrintWriter(wtr);

    outputErrorHtmlHead(pw, "XSLT transform error");
    pw.println("<body>");

    outputErrorPara(pw, "There was an error transforming content.");
    outputErrorPara(pw, "This is possibly due to incorrectly formatted " +
                        "content.");
    outputErrorPara(pw, "Following is a trace to help us locate the cause.");

    outputErrorException(pw, e);

    pw.println("</body>");
    pw.println("</html>");
  }

  private void outputErrorMessage(final String title, final String para,
                                  final ByteArrayOutputStream wtr) {
    PrintWriter pw = new PrintWriter(wtr);

    outputErrorHtmlHead(pw, title);
    pw.println("<body>");

    outputErrorPara(pw, para);
    pw.println("</body>");
    pw.println("</html>");
  }

  private void outputErrorHtmlHead(final PrintWriter pw, final String head) {
    pw.println("<html>");
    pw.println("<head>");
    pw.println("<title>" + head + "</title>");
    pw.println("</head>");
  }

  private void outputErrorTr(final PrintWriter pw, final String s1, final String s2) {
    pw.println("<tr>");
    pw.println("<td>" + s1 + "</td>");
    pw.println("<td>" + s2 + "</td>");
    pw.println("</tr>");
  }

  private void outputErrorPara(final PrintWriter pw, final String s) {
    pw.println("<p>");
    pw.println(s);
    pw.println("</p>");
  }

  private void outputErrorException(final PrintWriter pw, final Throwable e) {
    pw.println("<h2>Cause:</h2>");

    if (e == null) {
      pw.println("<br />********Unknown<br />");
    } else {
      pw.println("<pre>");
      e.printStackTrace(pw);
      pw.println("</pre>");
    }
  }

  private void logTime(final String recId, final String sessId, final long timeVal) {
    StringBuffer sb = new StringBuffer(recId);

    sb.append(":");
    sb.append(sessId);
    sb.append(":");
    sb.append(timeVal);

    getLogger().info(sb.toString());
  }
}

