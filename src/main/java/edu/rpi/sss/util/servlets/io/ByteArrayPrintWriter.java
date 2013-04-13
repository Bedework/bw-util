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

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;

import javax.servlet.ServletOutputStream;

/** PrintWriter which uses an underlying ByteArrayOutputStream
 *
 * @author Mike Douglass  douglm @ rpi.edu
 */
public class ByteArrayPrintWriter {
  private PooledBufferedOutputStream pbos = new PooledBufferedOutputStream();

  /* Try this to get a dump of all the output
  private ByteArrayOutputStream baos = new ByteArrayOutputStream() {
    public void write(int val) {
      System.out.write(val);
      super.write(val);
    }

    public void write(byte[] b, int off, int len) {
      System.out.write(b, off, len);
      super.write(b, off, len);
    }

    public void write(byte[] b) throws IOException {
      System.out.write(b);
      super.write(b);
    }
  };
  */

  private PrintWriter pw;
  private ServletOutputStream sos;

  /**
   * @return PrintWriter for this object
   */
  public PrintWriter getWriter() {
    if (pw == null) {
      pw = new PrintWriter(pbos);
    }
    return pw;
  }

  /**
   * @return a ServletOutputStream
   */
  public ServletOutputStream getStream() {
    if (sos == null) {
      sos = new ByteArrayServletStream(pbos);
    }
    return sos;
  }

  /** Get an InputStream for the bytes in the buffer. No guarantees if writes
   * take place after this is called.
   *
   * @return InputStream
   * @throws IOException
   */
  public synchronized InputStream getInputStream() throws IOException {
    return pbos.getInputStream();
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
    pbos.writeTo(out);
  }

  /**
   * Returns the current size of the buffer.
   *
   * @return  the value of the <code>count</code> field, which is the number
   *          of valid bytes in this output stream.
   * @see     java.io.ByteArrayOutputStream#count
   */
  public synchronized int size() {
    return pbos.size();
  }

  byte[] toByteArray() {
    return pbos.toByteArray();
  }

  /** Release the resources
   *
   * @throws IOException
   */
  public void release() throws IOException {
    if (pbos != null) {
      try {
        pbos.release();
      } catch (Exception bae) {}
    }
  }

  void close() {
    if (pbos != null) {
      try {
        pbos.close();
      } catch (Exception bae) {}
    }
    if (pw != null) {
      try {
        pw.close();
      } catch (Exception bae) {}
    }
    if (sos != null) {
      try {
        sos.close();
      } catch (Exception bae) {}
    }
    pbos = null;
    pw = null;
    sos = null;
  }
}

