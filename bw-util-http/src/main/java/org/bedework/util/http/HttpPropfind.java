/* ********************************************************************
    Appropriate copyright notice
*/
package org.bedework.util.http;

import org.apache.http.client.methods.HttpEntityEnclosingRequestBase;

import java.net.URI;

/**
 * User: mike Date: 11/8/17 Time: 13:54
 */
public class HttpPropfind extends HttpEntityEnclosingRequestBase {
  public static final String METHOD_NAME = "PROPFIND";

  public HttpPropfind() {
  }

  public HttpPropfind(URI uri) {
    this.setURI(uri);
  }

  public HttpPropfind(String uri) {
    this.setURI(URI.create(uri));
  }

  public String getMethod() {
    return METHOD_NAME;
  }
}

