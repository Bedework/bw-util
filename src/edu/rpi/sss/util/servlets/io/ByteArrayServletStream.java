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
import java.io.IOException;
import javax.servlet.ServletOutputStream;

/** Useful I/O classes for filtering etc.
 *
 * @author Mike Douglass douglm@rpi.edu.
 */
public class ByteArrayServletStream extends ServletOutputStream {
  ByteArrayOutputStream baos;

  /** Constructor
   *
   * @param baos
   */
  public ByteArrayServletStream(ByteArrayOutputStream baos) {
    this.baos = baos;
  }

  public void write(int param) throws IOException {
    baos.write(param);
  }

  public void close() {
    if (baos != null) {
      try {
        baos.close();
      } catch (Exception bae) {}
    }

    try {
      super.close();
    } catch (Exception sce) {}
  }
}

