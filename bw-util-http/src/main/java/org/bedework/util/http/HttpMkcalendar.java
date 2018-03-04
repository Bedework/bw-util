/* ********************************************************************
    Appropriate copyright notice
*/
package org.bedework.util.http;

import org.apache.http.client.methods.HttpRequestBase;

import java.net.URI;

/**
 * User: mike Date: 11/8/17 Time: 13:54
 */
public class HttpMkcalendar extends HttpRequestBase {
  public static final String METHOD_NAME = "MKCALENDAR";

  public HttpMkcalendar() {
  }

  public HttpMkcalendar(URI uri) {
    this.setURI(uri);
  }

  public HttpMkcalendar(String uri) {
    this.setURI(URI.create(uri));
  }

  public String getMethod() {
    return METHOD_NAME;
  }
}

