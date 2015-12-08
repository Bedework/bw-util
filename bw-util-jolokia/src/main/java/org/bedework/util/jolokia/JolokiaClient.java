/* ********************************************************************
    Appropriate copyright notice
*/
package org.bedework.util.jolokia;

import org.jolokia.client.J4pClient;
import org.jolokia.client.request.J4pReadRequest;
import org.jolokia.client.request.J4pReadResponse;

/**
 * User: mike Date: 12/3/15 Time: 00:32
 */
public class JolokiaClient {
  private final String url;
  private J4pClient client;

  /**
   *
   * @param url Usually something like "http://localhost:8080/hawtio/jolokia"
   */
  public JolokiaClient(final String url) {
    this.url = url;
  }

  public J4pClient getClient() {
    if (client != null) {
      return client;
    }

    client = new J4pClient(url);

    return client;
  }

  public Object getMemory() throws Throwable {
    final J4pReadRequest request =
            new J4pReadRequest("java.lang:type=Memory", "HeapMemoryUsage");
    request.setPath("used");
    final J4pReadResponse response = getClient().execute(request);
    return response.getValue();
  }
}
