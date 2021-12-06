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
package org.bedework.util.jms.listeners;

import org.bedework.util.jms.JmsConnectionHandler;
import org.bedework.util.jms.NotificationException;
import org.bedework.util.jms.events.SysEvent;
import org.bedework.util.logging.BwLogger;
import org.bedework.util.logging.Logged;
import org.bedework.util.misc.Util;

import java.io.InvalidClassException;
import java.util.Properties;

import javax.jms.ExceptionListener;
import javax.jms.JMSException;
import javax.jms.Message;
import javax.jms.MessageConsumer;
import javax.jms.MessageListener;
import javax.jms.ObjectMessage;

/** Listener class which receives messages from JMS.
 *
 * @author Mike Douglass
 */
public abstract class JmsSysEventListener
    implements Logged, MessageListener, ExceptionListener {
  private JmsConnectionHandler conn;

  private MessageConsumer consumer;

  private boolean running = true;

  /**
   * @param queueName queue to listen on
   * @param pr        jms properties
   * @throws NotificationException on fatal error
   */
  public void open(final String queueName,
                   final Properties pr) throws NotificationException {
    conn = new JmsConnectionHandler(pr);

    conn.open(queueName);

    consumer = conn.getConsumer();
  }

  /**
   * Close and release resources.
   */
  public void close() {
    if (consumer != null) {
      try {
        consumer.close();
      } catch (final Throwable t) {
        warn(t.getMessage());
      }
    }

    conn.close();
  }

  /**
   * For asynch we do the onMessage listener style. Otherwise we wait
   * synchronously for incoming messages.
   *
   * @param asynch true if we just want to set the listener
   * @throws NotificationException on fatal error
   */
  public void process(final boolean asynch)
          throws NotificationException {
    if (asynch) {
      try {
        consumer.setMessageListener(this);
        return;
      } catch (final JMSException je) {
        throw new NotificationException(je);
      }
    }

    while (running) {
      final Message m = conn.receive();

      if (m == null) {
        running = false;
        return;
      }
      onMessage(m);
    }
  }

  @Override
  public void onMessage(final Message message) {
    try {
      if (message instanceof ObjectMessage) {
        final SysEvent ev = (SysEvent)((ObjectMessage)message).getObject();

        action(ev);
      }
    } catch (final NotificationException ne) {
      ne.printStackTrace();
    } catch (final JMSException je) {
      if (Util.causeIs(je, InvalidClassException.class)) {
        /* Probably an old message - just ignore it. */
        warn("Ignoring message of unknown class");
      }
      error(je);
    }
  }

  public synchronized void onException(final JMSException ex) {
  }

  /**
   * Called whenever a matching event occurs.
   *
   * @param ev the event
   * @throws NotificationException on fatal error
   */
  public abstract void action(SysEvent ev)
          throws NotificationException;

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