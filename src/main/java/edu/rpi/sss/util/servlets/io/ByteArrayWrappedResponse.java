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

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
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
   * Returns the current size of the buffer.
   *
   * @return  the value of the <code>count</code> field, which is the number
   *          of valid bytes in this output stream.
   * @see     java.io.ByteArrayOutputStream#count
   */
  public synchronized int size() {
    return pw.size();
  }

  /** Get an InputStream for the bytes in the buffer. No guarantees if writes
   * take place after this is called.
   *
   * @return InputStream
   * @throws IOException
   */
  public synchronized InputStream getInputStream() throws IOException {
    return pw.getInputStream();
  }

  /**
   * Writes the complete contents of this byte array output stream to
   * the specified output stream argument, as if by calling the output
   * stream's write method using <code>out.write(buf, 0, count)</code>.
   *
   * @param      out   the output stream to which to write the data.
   * @exception  IOException  if an I/O error occurs.
   */
  public synchronized void writeTo(final OutputStream out) throws IOException {
    pw.writeTo(out);
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

  /** Release the resources
  *
  * @throws IOException
  */
  public void release() throws IOException {
    if (pw != null) {
      try {
        pw.release();
      } catch (Exception bae) {}
    }
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
