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
package org.bedework.util.http.service;

import org.bedework.util.config.ConfInfo;
import org.bedework.util.config.ConfigBase;

/** Information for outbound http connections
 *
 * @author Mike Douglass
 */
@ConfInfo(elementName = "http-properties",
          type = "org.bedework.util.http.service.HttpConfig")
public class HttpConfigImpl
        extends ConfigBase<HttpConfigImpl>
        implements HttpConfig {
  private int maxConnections;

  private int defaultMaxPerRoute;

  @Override
  public void setMaxConnections(final int val) {
    maxConnections = val;
  }

  @Override
  public int getMaxConnections() {
    return maxConnections;
  }

  @Override
  public void setDefaultMaxPerRoute(final int val) {
    defaultMaxPerRoute = val;
  }

  @Override
  public int getDefaultMaxPerRoute() {
    return defaultMaxPerRoute;
  }

  @Override
  public void disableSSL() {
  }
}
