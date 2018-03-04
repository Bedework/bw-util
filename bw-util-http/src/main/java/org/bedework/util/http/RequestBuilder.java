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
package org.bedework.util.http;

import org.bedework.util.misc.Util;

import java.util.List;

/** Build a request.
 *
 * @author douglm
 */
public class RequestBuilder {
  final StringBuilder req = new StringBuilder();

  String delim = "?";

  public RequestBuilder(final String path) {
    req.append(path);
  }

  public void par(final String name,
                  final String value) {
    req.append(delim);
    delim = "&";
    req.append(name);
    req.append("=");
    req.append(value);
  }

  public void par(final String name,
                  final int value) {
    par(name, String.valueOf(value));
  }

  public void par(final String name,
                  final List<String> value) {
    if (Util.isEmpty(value)) {
      return;
    }

    req.append(delim);
    delim = "&";
    req.append(delim);
    req.append(name);
    req.append("=");
    req.append(String.join(",", value));
  }

  public String toString() {
    return req.toString();
  }
}
