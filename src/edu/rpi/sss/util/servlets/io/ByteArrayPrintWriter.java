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

import java.io.ByteArrayOutputStream;
import java.io.PrintWriter;
import javax.servlet.ServletOutputStream;

/** PrintWriter which uses an underlying ByteArrayOutputStream
 *
 * @author Mike Douglass  douglm @ rpi.edu
 */
public class ByteArrayPrintWriter {
  private ByteArrayOutputStream baos = new ByteArrayOutputStream();

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
      pw = new PrintWriter(baos);
    }
    return pw;
  }

  /**
   * @return a ServletOutputStream
   */
  public ServletOutputStream getStream() {
    if (sos == null) {
      sos = new ByteArrayServletStream(baos);
    }
    return sos;
  }

  byte[] toByteArray() {
    return baos.toByteArray();
  }

  void close() {
    if (baos != null) {
      try {
        baos.close();
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
    baos = null;
    pw = null;
    sos = null;
  }
}

