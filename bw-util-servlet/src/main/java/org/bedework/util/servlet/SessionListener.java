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
package org.bedework.util.servlet;

import org.apache.log4j.Logger;

import java.util.HashMap;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

/** A class to listen for session start and end. Note this may not work too
 * well in a clustered environment because the counts should be shared.
 */
public class SessionListener implements HttpSessionListener {
  private static class Counts {
    int activeSessions = 0;
    long totalSessions = 0;
  }

  private static volatile HashMap<String, Counts> countsMap =
    new HashMap<String, Counts>();
  private static boolean logActive = true;

  /** Name of the init parameter holding our name */
  private static final String appNameInitParameter = "rpiappname";

  /**
   */
  public SessionListener() {}

  /* (non-Javadoc)
   * @see javax.servlet.http.HttpSessionListener#sessionCreated(javax.servlet.http.HttpSessionEvent)
   */
  public void sessionCreated(final HttpSessionEvent se) {
    HttpSession session = se.getSession();
    ServletContext sc = session.getServletContext();
    String appname = getAppName(session);
    Counts ct = getCounts(appname);

    ct.activeSessions++;
    ct.totalSessions++;

    if (logActive) {
      logSessionCounts(session, true);
      sc.log("========= New session(" + appname +
             "): " + ct.activeSessions + " active, " +
             ct.totalSessions + " total. vm(used, max)=(" +
            Runtime.getRuntime().freeMemory()/(1024 * 1024) + "M, " +
            Runtime.getRuntime().totalMemory()/(1024 * 1024) + "M)");
    }

    /*
    if (false) {
      Enumeration en = session.getAttributeNames();

      while (en.hasMoreElements()) {
        String s = (String)en.nextElement();
        Object o = session.getAttribute(s);

        sc.log("New session: attribute name " + s);
      }
    }*/
  }

  /* (non-Javadoc)
   * @see javax.servlet.http.HttpSessionListener#sessionDestroyed(javax.servlet.http.HttpSessionEvent)
   */
  public void sessionDestroyed(final HttpSessionEvent se) {
    HttpSession session = se.getSession();
    ServletContext sc = session.getServletContext();
    String appname = getAppName(session);
    Counts ct = getCounts(appname);

    if (ct.activeSessions > 0) {
      ct.activeSessions--;
    }

    if (logActive) {
      logSessionCounts(session, false);
      sc.log("========= Session destroyed(" + appname +
             "): " + ct.activeSessions + " active. vm(used, max)=(" +
            Runtime.getRuntime().freeMemory()/(1024 * 1024) + "M, " +
            Runtime.getRuntime().totalMemory()/(1024 * 1024) + "M)");
    }
  }

  /**
   * @param val
   */
  public static void setLogActive(final boolean val) {
    logActive = val;
  }

  /** Log the session counters for applications that maintain them.
   *
   * @param sess       HttpSession for the session id
   * @param start      true for session start
   */
  protected void logSessionCounts(final HttpSession sess,
                                  final boolean start) {
    Logger log = Logger.getLogger(this.getClass());
    StringBuffer sb;
    String appname = getAppName(sess);
    Counts ct = getCounts(appname);

    if (start) {
      sb = new StringBuffer("SESSION-START:");
    } else {
      sb = new StringBuffer("SESSION-END:");
    }

    sb.append(getSessionId(sess));
    sb.append(":");
    sb.append(appname);
    sb.append(":");
    sb.append(ct.activeSessions);
    sb.append(":");
    sb.append(ct.totalSessions);
    sb.append(":");
    sb.append(Runtime.getRuntime().freeMemory()/(1024 * 1024));
    sb.append("M:");
    sb.append(Runtime.getRuntime().totalMemory()/(1024 * 1024));
    sb.append("M");

    log.info(sb.toString());
  }

  private Counts getCounts(final String name) {
    try {
      synchronized (countsMap) {
        Counts c = countsMap.get(name);

        if (c == null) {
          c = new Counts();
          countsMap.put(name, c);
        }

        return c;
      }
    } catch (Throwable t) {
      return new Counts();
    }
  }

  private String getAppName(final HttpSession sess) {
    ServletContext sc = sess.getServletContext();

    String appname = sc.getInitParameter(appNameInitParameter);
    if (appname == null) {
      appname = "?";
    }

    return appname;
  }

  /** Get the session id for the loggers.
   *
   * @param sess
   * @return  String    session id
   */
  private String getSessionId(final HttpSession sess) {
    try {
      if (sess == null) {
        return "NO-SESSIONID";
      } else {
        return sess.getId();
      }
    } catch (Throwable t) {
      return "SESSION-ID-EXCEPTION";
    }
  }
}

