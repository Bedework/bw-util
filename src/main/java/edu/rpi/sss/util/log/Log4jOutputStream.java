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

  private transient Logger log;

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

