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
package edu.rpi.sss.util.servlets.io;

import org.apache.log4j.Logger;

import java.io.PrintWriter;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

/** This class provides a useful form of the wrapped response.
 */
public class ByteArrayWrappedResponse extends WrappedResponse {
  ByteArrayPrintWriter pw = new ByteArrayPrintWriter();

  /** Constructor
   *
   * @param response
   */
  public ByteArrayWrappedResponse(final HttpServletResponse response) {
    super(response);
  }

  /** Constructor
   *
   * @param response
   * @param log
   */
  public ByteArrayWrappedResponse(final HttpServletResponse response,
                                  final Logger log) {
    super(response, log);
  }

  /* (non-Javadoc)
   * @see javax.servlet.ServletResponse#getWriter()
   */
  @Override
  public PrintWriter getWriter() {
    if (debug) {
      getLogger().debug("getWriter called");
    }

    return pw.getWriter();
  }

  /* (non-Javadoc)
   * @see javax.servlet.ServletResponse#getOutputStream()
   */
  @Override
  public ServletOutputStream getOutputStream() {
    if (debug) {
      getLogger().debug("getOutputStream called");
    }

    return pw.getStream();
  }

  /**
   * @return resulting byte array
   */
  public byte[] toByteArray() {
    if (pw == null) {
      return null;
    }

    return pw.toByteArray();
  }

  /**
   *
   */
  @Override
  public void close() {
    if (pw != null) {
      try {
        pw.close();
      } catch (Exception bae) {}
    }
    pw = null;
    super.close();
  }
}
