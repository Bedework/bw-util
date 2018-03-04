/* ********************************************************************
    Appropriate copyright notice
*/
package org.bedework.util.http;

import org.apache.http.Header;
import org.apache.http.message.BasicHeader;

import java.util.ArrayList;

/**
 * User: mike Date: 11/25/17 Time: 23:50
 */
public class Headers extends ArrayList<Header> {
  public Headers add(final String name,
                     final String val) {
    add(new BasicHeader(name, val));

    return this;
  }

  public Header[] asArray() {
    return toArray(new Header[size()]);
  }
}
