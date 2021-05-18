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

import java.util.Properties;

import javax.jms.JMSException;
import javax.jms.MessageProducer;
import javax.jms.ObjectMessage;

/**
 * This is the implementation of a notifications handler which sends jms
 * messages.
 *
 * @author Mike Douglass douglm - rpi.edu
 */
public class JmsNotificationsHandlerImpl extends NotificationsHandler
        implements Logged {
  /* Default sysevents queue - everything goes here */

  private final JmsConnectionHandler conn;

  private final MessageProducer sender;

  /*
   * We could use the activemq camel support (I think) to filter out certain
   * events and send them on to another queue.
   */

  /**
   *
   * @param queueName our queue
   * @param pr jms properties
   * @throws NotificationException on fatal error
   */
  public JmsNotificationsHandlerImpl(final String queueName,
                                     final Properties pr) throws NotificationException {
    conn = new JmsConnectionHandler(pr);

    conn.open(queueName);

    sender = conn.getProducer();
  }

  @SuppressWarnings("unused")
  private static long sends = 0;
  @SuppressWarnings("unused")
  private static long sendTime = 0;

  @Override
  public void post(final SysEvent ev) throws NotificationException {
    if (debug()) {
      debug(ev.toString());
    }

    try {
      final ObjectMessage msg = conn.getSession().createObjectMessage();

      msg.setObject(ev);

      for (final SysEvent.Attribute attr: ev.getMessageAttributes()) {
        msg.setStringProperty(attr.name, attr.value);
      }

      final long start = System.currentTimeMillis();
      sender.send(msg);
      sends++;
      sendTime += System.currentTimeMillis() - start;

//      if ((sends % 100) == 0) {
//        System.out.println("Sends: " + sends + " avg: " + sendTime / sends);
//      }
    } catch (final JMSException je) {
      throw new NotificationException(je);
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
