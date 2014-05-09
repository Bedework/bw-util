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

import org.apache.http.HttpException;
import org.apache.http.HttpVersion;
import org.apache.http.StatusLine;
import org.apache.http.message.BasicStatusLine;

import java.io.Serializable;

import javax.servlet.http.HttpServletResponse;

/** Provide a way to get named values.
 *
 * @author douglm
 */
public class HttpUtil implements Serializable {
  private HttpUtil() {
  }

  /**
   * @return Status line
   */
  public static StatusLine getHttpStatus(final String statusLine) throws HttpException {
    final String[] splits = statusLine.split("\\s+");

    if ((splits.length < 2) ||
         (!splits[0].startsWith("HTTP/"))) {
      throw new HttpException("Bad status line: " + statusLine);
    }

    final String[] version = splits[0].substring(5).split(".");

    if (version.length != 2) {
      throw new HttpException("Bad status line: " + statusLine);
    }

    final HttpVersion hv = new HttpVersion(Integer.valueOf(version[0]),
                                           Integer.valueOf(version[1]));

    final int status = Integer.valueOf(splits[1]);

    final String reason;

    if (splits.length < 3) {
      reason = null;
    } else {
      reason = splits[2];
    }

    return new BasicStatusLine(hv, status, reason);
  }

  /**
   * @param status the code
   * @param reason some text
   * @return Correctly formatted string
   */
  public static String makeHttpStatus(final int status,
                                      final String reason) {
    return "HTTP/1.1 " + status + reason;
  }

  /**
   * @return Correctly formatted string
   */
  public static String makeOKHttpStatus() {
    return makeHttpStatus(HttpServletResponse.SC_OK, "OK");
  }
}
