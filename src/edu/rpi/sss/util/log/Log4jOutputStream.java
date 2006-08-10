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

package edu.rpi.sss.util.log;

import java.io.ByteArrayOutputStream;
import java.io.IOException;

import org.apache.log4j.Logger;

/**
 * An OutputStream which writes to log4j.
 *
 * @author Mike Douglass  douglm@rpi.edu
 */
public class Log4jOutputStream extends ByteArrayOutputStream {
  /** We're not supposed to allow operations on a closed stream.
   */
  private boolean closed;

  private Logger log;

  /** Constructor
   *
   */
  public Log4jOutputStream() {
    super();
  }

  /** Constructor
  *
   * @param log
   */
  public Log4jOutputStream(Logger log) {
    super();
    this.log = log;
  }

  public void close() throws IOException {
    try {
      flush();
    } catch (IOException ioe) {
      closed = true;
      throw ioe;
    }
  }

  public void flush() throws IOException {
    if (closed) {
      throw new IOException("The stream is closed");
    }

    String s = toString();
    getLog().info(s);

    reset();
  }

  private Logger getLog() {
    if (log != null) {
      return log;
    }

    log = Logger.getLogger(this.getClass());
    return log;
  }
}

