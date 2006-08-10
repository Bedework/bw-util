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

import java.io.CharArrayWriter;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletOutputStream;
import org.apache.log4j.Logger;

/** This class provides a useful form of the wrapped response.
 */
public class CharArrayWrappedResponse extends WrappedResponse {
  final CharArrayWriter caw = new CharArrayWriter();

  /** Constructor
   *
   * @param response
   * @param debug
   */
  public CharArrayWrappedResponse(HttpServletResponse response,
                                  boolean debug) {
    super(response, debug);
  }

  /** Constructor
   *
   * @param response
   * @param log
   * @param debug
   */
  public CharArrayWrappedResponse(HttpServletResponse response,
                                  Logger log,
                                  boolean debug) {
    super(response, log, debug);
  }

  /* (non-Javadoc)
   * @see javax.servlet.ServletResponse#getWriter()
   */
  public PrintWriter getWriter() {
    if (debug) {
      getLogger().debug("getWriter called");
    }

    return new PrintWriter(caw);
  }

  /* (non-Javadoc)
   * @see javax.servlet.ServletResponse#getOutputStream()
   */
  public ServletOutputStream getOutputStream() throws IOException {
    if (debug) {
      getLogger().debug("getOutputStream called");
    }

    throw new IOException("Unsupported operation: getOutputStream()");
  }

  /* (non-Javadoc)
   * @see java.lang.Object#toString()
   */
  public String toString() {
    if (caw == null) {
      return null;
    }

    return caw.toString();
  }
}

