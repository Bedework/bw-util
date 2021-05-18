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
package org.bedework.util.jms;

import org.bedework.util.jms.events.SysEvent;
import org.bedework.util.jms.listeners.SysEventListener;
import org.bedework.util.logging.BwLogger;
import org.bedework.util.logging.Logged;

/**
 * This is the implementation of a notifications handler.
 *
 * @author Mike Douglass douglm - rpi.edu
 */
class NotificationsHandlerImpl extends NotificationsHandler
        implements Logged {
  NotificationsHandlerImpl() {
  }

  @Override
  public void post(final SysEvent ev) {
    if (debug()) {
      debug(ev.toString());
    }
  }

  @Override
  public void registerListener(final SysEventListener l,
                               final boolean persistent) {

  }

  @Override
  public void removeListener(final SysEventListener l) {

  }

  /* ====================================================================
   *                   Logged methods
   * ==================================================================== */

  private final BwLogger logger = new BwLogger();

  @Override
  public BwLogger getLogger() {
    if ((logger.getLoggedClass() == null) && (logger.getLoggedName() == null)) {
      logger.setLoggedClass(getClass());
    }

    return logger;
  }
}
