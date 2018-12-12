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
package org.bedework.util.jolokia;

import org.bedework.util.jmx.ConfBase;
import org.bedework.util.logging.Logged;

import org.jolokia.client.BasicAuthenticator;
import org.jolokia.client.J4pClient;
import org.jolokia.client.request.J4pExecRequest;
import org.jolokia.client.request.J4pReadRequest;
import org.jolokia.client.request.J4pReadResponse;
import org.jolokia.client.request.J4pResponse;
import org.jolokia.client.request.J4pWriteRequest;

import java.util.List;

/**
 * User: mike Date: 12/3/15 Time: 00:32
 */
public class JolokiaClient implements Logged {
  private final String url;
  private final String id;
  private final String pw;
  private J4pClient client;

  /**
   *
   * @param url Usually something like "http://localhost:8080/hawtio/jolokia"
   */
  public JolokiaClient(final String url) {
    this.url = url;
    this.id = null;
    this.pw = null;
  }

  /**
   *
   * @param url Usually something like "http://localhost:8080/hawtio/jolokia"
   */
  public JolokiaClient(final String url,
                       final String id,
                       final String pw) {
    this.url = url;
    this.id = id;
    this.pw = pw;
  }

  public J4pClient getClient() {
    if (client != null) {
      return client;
    }

    if (id == null) {
      client = J4pClient.url(url).build();

      return client;
    }

    client = J4pClient.url(url)
                      .user(id)
                      .password(pw)
                      .authenticator(new BasicAuthenticator().preemptive())
                      .connectionTimeout(3000)
                      .build();

    return client;
  }

  public void writeVal(final String objectName,
                       final String name,
                       final Object val) throws Throwable {
    final J4pWriteRequest request =
            new J4pWriteRequest(objectName, name, val);
    getClient().execute(request);
  }

  public String readString(final String objectName,
                           final String name) throws Throwable {
    final J4pReadRequest request =
            new J4pReadRequest(objectName, name);
    final J4pReadResponse response = getClient().execute(request);
    return response.getValue();
  }

  /**
   *
   * @param objectName of mbean
   * @param operation that returns a list
   * @return the list
   * @throws Throwable on error
   */
  public List<String> execStringList(final String objectName,
                                     final String operation) throws Throwable {
      final J4pExecRequest execRequest =
              new J4pExecRequest(objectName, operation);
      final J4pResponse response = getClient().execute(execRequest);
      return (List<String>)response.getValue();
  }

  /**
   *
   * @param objectName of mbean
   * @param operation that returns a string
   * @return the string
   * @throws Throwable on error
   */
  public String execString(final String objectName,
                           final String operation,
                           final Object... args) throws Throwable {
    final J4pExecRequest execRequest =
            new J4pExecRequest(objectName, operation, args);
    final J4pResponse response = getClient().execute(execRequest);
    return (String)response.getValue();
  }

  /**
   *
   * @param objectName of mbean
   * @param operation that returns a string
   * @return the object
   * @throws Throwable on error
   */
  public Object exec(final String objectName,
                     final String operation,
                     final Object... args) throws Throwable {
    final J4pExecRequest execRequest =
            new J4pExecRequest(objectName, operation, args);
    final J4pResponse response = getClient().execute(execRequest);
    return response.getValue();
  }

  public void execute(final String objectName,
                      final String operation,
                      final Object... args) throws Throwable {
    final J4pExecRequest execRequest =
            new J4pExecRequest(objectName, operation, args);
    getClient().execute(execRequest);
  }

  /**
   *
   * @param objectName of mbean that has a String Status attribute
   * @return the current status
   * @throws Throwable on error
   */
  public String getStatus(final String objectName) throws Throwable {
    return readString(objectName, "Status");
  }

  public String getMemory() throws Throwable {
    return execString("java.lang:type=Memory", "HeapMemoryUsage");
  }

  /**
   *
   * @param objectName of mbean
   * @return String ending status - "Done" or success
   */
  public String waitCompletion(final String objectName) {
    return waitCompletion(objectName, 60, 10);
  }

  /**
   *
   * @param objectName of mbean
   * @param waitSeconds how long we wait in total
   * @param pollSeconds poll interval
   * @return String ending status - "Done" or success
   */
  public String waitCompletion(final String objectName,
                               final long waitSeconds,
                               final long pollSeconds) {
    /* The process will start off in stopped state.
       If we see it stopped it's because it hasn't got going yet.
     */
    try {
      final long start = System.currentTimeMillis();
      double curSecs;
      final long pollWait = pollSeconds * 1000;

      boolean starting = true;

      do {
        final String status = getStatus(objectName);

        if (status == null) {
          return null;
        }

        if (starting && status.equals(ConfBase.statusStopped)) {
          info("Waiting for process to start");
        } else {
          starting = false;

          if (status.equals(ConfBase.statusDone)) {
            info("Received status Done");
            return status;
          }

          if (!status.equals(ConfBase.statusRunning)) {
            error("Status is " + status);
            return status;
          }
        }

        info("Still running...");

        final long now = System.currentTimeMillis();
        curSecs = (now - start) / 1000;

        synchronized (this) {
          this.wait(pollWait);
        }
      } while (curSecs < waitSeconds);

      error("Timedout waiting for completion");
      return ConfBase.statusTimedout;
    } catch (final Throwable t) {
      error(t);
      return ConfBase.statusFailed;
    }
  }

  protected void multiLine(final List<String> resp) {
    if (resp == null) {
      info("Null response");
      return;
    }

    for (final String s: resp) {
      info(s);
    }
  }
}
