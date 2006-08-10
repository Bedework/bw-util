/* **********************************************************************
    Copyright 2006 Rensselaer Polytechnic Institute. All worldwide rights reserved.

    Redistribution and use of this distribution in source and binary forms,
    with or without modification, are permitted provided that:
       The above copyright notice and this permission notice appear in all
        copies and supporting documentation;

        The name, identifiers, and trademarks of Rensselaer Polytechnic
        Institute are not used in advertising or publicity without the
        express prior written permission of Rensselaer Polytechnic Institute;

    DISCLAIMER: The software is distributed" AS IS" without any express or
    implied warranty, including but not limited to, any implied warranties
    of merchantability or fitness for a particular purpose or any warrant)'
    of non-infringement of any current or pending patent rights. The authors
    of the software make no representations about the suitability of this
    software for any particular purpose. The entire risk as to the quality
    and performance of the software is with the user. Should the software
    prove defective, the user assumes the cost of all necessary servicing,
    repair or correction. In particular, neither Rensselaer Polytechnic
    Institute, nor the authors of the software are liable for any indirect,
    special, consequential, or incidental damages related to the software,
    to the maximum extent the law permits.
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
  }
}

