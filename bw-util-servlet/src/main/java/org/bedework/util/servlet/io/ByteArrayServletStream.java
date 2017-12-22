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
package org.bedework.util.servlet.io;

import java.io.IOException;

import javax.servlet.ServletOutputStream;

/** Useful I/O classes for filtering etc.
 *
 * @author Mike Douglass douglm@rpi.edu.
 */
public class ByteArrayServletStream extends ServletOutputStream {
  PooledBufferedOutputStream pbos;

  /** Constructor
   *
   * @param pbos
   */
  public ByteArrayServletStream(final PooledBufferedOutputStream pbos) {
    this.pbos = pbos;
  }

  @Override
  public void write(final int param) throws IOException {
    pbos.write(param);
  }

  @Override
  public void close() {
    if (pbos != null) {
      try {
        pbos.close();
      } catch (Exception bae) {}
    }

    try {
      super.close();
    } catch (Exception sce) {}
  }
}

