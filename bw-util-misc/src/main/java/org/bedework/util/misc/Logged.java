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
package org.bedework.util.misc;

import org.apache.log4j.Logger;

/** This class provides support for diffing timezone data to determine if
 * updates need to be made to stored data.
 *
 * @author douglm
 */
public class Logged {
  protected boolean debug;

  private transient Logger log;

  protected Logged() {
    debug = getLogger().isDebugEnabled();
  }

  /**
   * @return Logger
   */
  protected Logger getLogger() {
    if (log == null) {
      log = Logger.getLogger(this.getClass());
    }

    return log;
  }

  /**
   * @param t exception
   */
  protected void error(final Throwable t) {
    getLogger().error(this, t);
  }

  /**
   * @param msg to output
   */
  protected void error(final String msg) {
    getLogger().error(msg);
  }

  /**
   * @param msg to output
   */
  protected void warn(final String msg) {
    getLogger().warn(msg);
  }

  /**
   * @param msg to output
   */
  protected void info(final String msg) {
    getLogger().info(msg);
  }

  /**
   * @param msg to output
   */
  protected void debug(final String msg) {
    getLogger().debug(msg);
  }
}
