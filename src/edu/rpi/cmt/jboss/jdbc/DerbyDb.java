/* **********************************************************************
    Copyright 2010 Rensselaer Polytechnic Institute. All worldwide rights reserved.

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
package edu.rpi.cmt.jboss.jdbc;

import org.apache.derby.drda.NetworkServerControl;
import org.apache.log4j.Logger;

import java.net.InetAddress;

/** Run derby as a service with remote connections.
 * @author douglm
 *
 */
public class DerbyDb implements DerbyDbMBean {
  private transient Logger log;

  private boolean running;

  protected String account = "sa";

  protected String pw = "";

  protected String dbName;

  protected int port = 1527;

  protected int maxThreads;

  protected int minThreads;

  /* Properties we can set
   *  derby.drda.host property
   *  derby.drda.keepAlive property
   *  derby.drda.logConnections property
   *  derby.drda.maxThreads property
 derby.drda.minThreads property
 derby.drda.portNumber property
 derby.drda.securityMechanism property
 derby.drda.sslMode property
 derby.drda.startNetworkServer property
 derby.drda.streamOutBufferSize property
 derby.drda.timeSlice property
 derby.drda.traceAll property
 derby.drda.traceDirectory property
   */
  /*
  private class ProcessorThread extends Thread {
    boolean showedTrace;

    /**
     * @param name - for the thread
     * /
    public ProcessorThread(final String name) {
      super(name);
    }
    @ Override
    public void run() {
      while (running) {
        try {
          InetAddress addr = InetAddress.getByName("localhost");
          NetworkServerControl server = new NetworkServerControl(addr,
                                                                 port,
                                                                 account,
                                                                 pw);

          server.start(null);
        } catch (InterruptedException ie) {
          break;
        } catch (Throwable t) {
          if (!showedTrace) {
            error(t);
            showedTrace = true;
          } else {
            error(t.getMessage());
          }
        } finally {
          // close();
        }
      }
    }
  }

  private ProcessorThread processor;
  */

  public String getName() {
    /* This apparently must be the same as the name attribute in the
     * jboss service definition
     */
    return "org.bedework:service=DerbyDb";
  }

  public void setAccount(final String val) {
    account = val;
  }

  public String getAccount() {
    return account;
  }

  public void setPw(final String val) {
    pw = val;
  }

  public String getPw() {
    return pw;
  }

  public void setDbName(final String val) {
    dbName = val;
  }

  public String getDbName() {
    return dbName;
  }

  public void setPort(final int val) {
    port = val;
  }

  public int getPort() {
    return port;
  }

  /* (non-Javadoc)
   * @see org.bedework.indexer.BwIndexerMBean#isStarted()
   */
  public boolean isStarted() {
    return running;
//    return (processor != null) && processor.isAlive();
  }

  /* (non-Javadoc)
   * @see org.bedework.indexer.BwIndexerMBean#start()
   */
  public synchronized void start() {
    if (running) {
      error("Already started");
      return;
    }

    info("************************************************************");
    info(" * Starting " + getName());
    info("************************************************************");

    try {
      InetAddress addr = InetAddress.getByName("localhost");
      NetworkServerControl server = new NetworkServerControl(addr,
                                                             port,
                                                             account,
                                                             pw);

      server.start(null);
    } catch (Throwable t) {
      error("Error starting server");
      error(t);
    }

    running = true;

//    processor = new ProcessorThread(getName());
//    processor.start();
  }

  /* (non-Javadoc)
   * @see org.bedework.indexer.BwIndexerMBean#stop()
   */
  public synchronized void stop() {
    if (!running) {
      error("Already stopped");
      return;
    }

    info("************************************************************");
    info(" * Stopping " + getName());
    info("************************************************************");

    try {
      NetworkServerControl server = new NetworkServerControl(account, pw);
      server.shutdown();
    } catch (Throwable t) {
      error("Error shutting down server");
      error(t);
    }

    running = false;

    /*
    processor.interrupt();
    try {
      processor.join(20 * 1000);
    } catch (InterruptedException ie) {
    } catch (Throwable t) {
      error("Error waiting for processor termination");
      error(t);
    }

    processor = null;
    */

    info("************************************************************");
    info(" * " + getName() + " terminated");
    info("************************************************************");
  }

  /* ====================================================================
   *                   Protected methods
   * ==================================================================== */

  protected void info(final String msg) {
    getLogger().info(msg);
  }

  protected void trace(final String msg) {
    getLogger().debug(msg);
  }

  protected void warn(final String msg) {
    getLogger().warn(msg);
  }

  protected void error(final Throwable t) {
    getLogger().error(t);
  }

  protected void error(final String msg) {
    getLogger().error(msg);
  }

  /* Get a logger for messages
   */
  protected Logger getLogger() {
    if (log == null) {
      log = Logger.getLogger(this.getClass());
    }

    return log;
  }
}
