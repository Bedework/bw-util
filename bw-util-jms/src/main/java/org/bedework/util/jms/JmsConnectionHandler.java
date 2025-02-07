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

import org.bedework.util.logging.BwLogger;
import org.bedework.util.logging.Logged;
import org.bedework.util.misc.Util;

import java.util.Properties;

import jakarta.jms.Connection;
import jakarta.jms.ConnectionFactory;
import jakarta.jms.JMSException;
import jakarta.jms.Message;
import jakarta.jms.MessageConsumer;
import jakarta.jms.MessageProducer;
import jakarta.jms.Queue;
import jakarta.jms.Session;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;

/** This is a class to ease setting up of JMS connections..
 *
 * @author Mike Douglass
 */
public class JmsConnectionHandler implements Logged {
  /** */
  public static int ackMode = Session.AUTO_ACKNOWLEDGE;

  /** */
  public static final boolean useTransactions = false;

  private final Properties pr;

  private Connection connection;

  private Queue ourQueue;

  private Session session;

  private MessageConsumer consumer;

  /**
   */
  public JmsConnectionHandler(final Properties pr) {
    this.pr = pr;
  }

  /** Open a connection to the named queue ready to create a producer or
   * consumer.
   *
   * @param queueName the queue
   * @throws NotificationException on fatal error
   */
  public void open(final String queueName) throws NotificationException {
    try {
      final ConnectionFactory connFactory;

      final Context ctx = new InitialContext(pr);
      /*
      try {
        Context jcectx = (Context)ctx.lookup("java:comp/env/");

        // Still here - use that
        if (jcectx != null) {
          ctx = jcectx;
        }
      } catch (NamingException nfe) {
        // Stay with root
      }
      */

      try {
        connFactory = (ConnectionFactory)ctx.lookup(
                    pr.getProperty("org.bedework.connection.factory.name"));

//        connFactory = (ConnectionFactory)ctx.lookup(connFactoryName);

        connection = connFactory.createConnection();

      } catch (final Throwable t) {
        if (debug()) {
          error(t);
        }
        throw new NotificationException(t);
      }

      try {
        /* Session is not transacted,
        * uses AUTO_ACKNOWLEDGE for message
        * acknowledgement
        */
        session = connection.createSession(useTransactions, ackMode);
        if (session == null) {
          throw new NotificationException("No session created");
        }
        final String qn = pr.getProperty("org.bedework.jms.queue.prefix") +
                queueName;

        try {
          ourQueue =  (Queue)new InitialContext().lookup(qn);
        } catch (final NamingException ne) {
          // Try again with our own context
          ourQueue =  (Queue)ctx.lookup(qn);
        }
      } catch (final Throwable t) {
        if (debug()) {
          error(t);
        }
        throw new NotificationException(t);
      }
    } catch (final NotificationException ne) {
      throw ne;
    } catch (final Throwable t) {
      if (debug()) {
        error(t);
      }
      throw new NotificationException(t);
    }
  }

  /**
   *
   */
  public void close() {
    try {
      if (session != null) {
        session.close();
      }
    } catch (final Throwable t) {
      warn(t.getMessage());
    }
  }

  /**
   * @return jms session
   */
  public Session getSession() {
    return session;
  }

  /**
   * @return a message producer
   * @throws NotificationException on fatal error
   */
  public MessageProducer getProducer() throws NotificationException {
    try {
      final MessageProducer sender = session.createProducer(ourQueue);

      connection.start();

      return sender;
    } catch (final JMSException je) {
      throw new NotificationException(je);
    }
  }

  /**
   * @return a message consumer
   * @throws NotificationException on fatal error
   */
  public MessageConsumer getConsumer() throws NotificationException {
    try {
      consumer = session.createConsumer(ourQueue);

      connection.start();

      return consumer;
    } catch (final JMSException je) {
      throw new NotificationException(je);
    }
  }

  /**
   * @return next message
   * @throws NotificationException on fatal error
   */
  public Message receive() throws NotificationException {
    try {
      return consumer.receive();
    } catch (final JMSException je) {
      if (Util.causeIs(je, InterruptedException.class)) {
        warn("Received interrupted exception");
        return null;
      }
      
      throw new NotificationException(je);
    }
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
