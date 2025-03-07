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

import org.bedework.util.logging.BwLogger;
import org.bedework.util.logging.Logged;

import javax.naming.NameNotFoundException;

/** Something to help the handling and graceful shutdown of processes.
 *
 * @author douglm
 *
 */
public abstract class AbstractProcessorThread extends Thread
    implements Logged {
  public static final String statusDone = "Done";
  public static final String statusFailed = "Failed";
  public static final String statusRunning = "Running";
  public static final String statusStopped = "Stopped";

  /** cannot stop the thread */
  public static final String statusUnstoppable = "Unstoppable";

  private String status = statusStopped;

  protected boolean running;

  private boolean showedTrace;

  /**
   *
   * @param name for the thread
   */
  public AbstractProcessorThread(final String name) {
    super(name);
  }

  /** Called to initialise at start of run. We've already output the
   * start of the startup message. This can add more info.
   */
  public abstract void runInit();

  /** called at end - allows output of termination messsages
   * @param msg an info message
   */
  public abstract void end(String msg);

  /** Do whatever we're supposed to be doing.
   * @throws Throwable on fatal error
   */
  public abstract void runProcess() throws Throwable;

  /** Close the processor.
   */
  public abstract void close();

  /** Override to handle certain exception types.
   * .
   * @param val the exception
   * @return false if we did nothing
   */
  public boolean handleException(final Throwable val) {
    if (Util.causeIs(val, NameNotFoundException.class)) {
      // jmx shutting down?
      error("Looks like JMX shut down.");
      error(val);
      running = false;
      return true;
    }

    return false;
  }

  public String getStatus() {
    return status;
  }

  public void setStatus(final String val) {
    status = val;
  }

  /** Set the running flag
   *
   * @param val the flag
   */
  public void setRunning(final boolean val) {
    running = val;
  }

  /**
   *
   * @return the running flag
   */
  public boolean getRunning() {
    return running;
  }

  /** Check for processor started
   *
   * @param processor to check
   * @return status string.
   */
  public static String checkStarted(final AbstractProcessorThread processor) {
    if (processor == null) {
      return statusStopped;
    }

    if (!processor.isAlive()) {
      return statusStopped;
    }

    if (processor.running) {
      return statusRunning;
    }

    /* Kill it and return false */
    processor.interrupt();
    try {
      processor.join(5000);
    } catch (final Throwable ignored) {}

    if (!processor.isAlive()) {
      return statusStopped;
    }

    return statusUnstoppable;
  }

  @Override
  public void run() {
    info("************************************************************");
    info(" * Starting " + getName());

    runInit();

    info("************************************************************");

    long lastErrorTime = 0;
    final long errorResetTime = 1000 * 60 * 5;  // 5 minutes since last error
    int errorCt = 0;
    final int maxErrorCt = 5;

    /* The point of the loop is to restart if we get some
       sort of exception. Normal returns are termination.
     */
    while (running) {
      try {
        runProcess();
        running = false;
      } catch (final InterruptedException ie) {
        running = false;
        break;
      } catch (final Throwable t) {
        if (!handleException(t)) {
          if (System.currentTimeMillis() - lastErrorTime > errorResetTime) {
            errorCt = 0;
          }

          if (errorCt > maxErrorCt) {
            error("Too many errors: stopping");
            running = false;
            break;
          }

          lastErrorTime = System.currentTimeMillis();
          errorCt++;

          if (!showedTrace) {
            error(t);
  //            showedTrace = true;
          } else {
            error(t.getMessage());
          }
        }
      } finally {
        close();
      }

      info("****************************************************");
      info(" * " + getName() + " terminated");
      if (running) {
        info(" * Will restart the process.");
      }
      info("****************************************************");
    }
  }

  /** Shut down a running process.
   *
   * @param proc the thread process
   * @return false for exception or timeout
   */
  public static boolean stopProcess(final AbstractProcessorThread proc) {
    if (proc == null) {
      return true;
    }

    proc.info("************************************************************");
    proc.info(" * Stopping " + proc.getName());
    proc.info("************************************************************");

    proc.setRunning(false);

    proc.interrupt();

    boolean ok = true;

    try {
      proc.join(20 * 1000);
    } catch (final InterruptedException ignored) {
    } catch (final Throwable t) {
      proc.error("Error waiting for processor termination");
      proc.error(t);
      ok = false;
    }

    proc.info("************************************************************");
    proc.info(" * " + proc.getName() + " terminated");
    proc.info("************************************************************");

    return ok;
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

