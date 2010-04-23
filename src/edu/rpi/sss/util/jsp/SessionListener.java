/* **********************************************************************
    Copyright 2006 Rensselaer Polytechnic Institute. All worldwide rights reserved.

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

package edu.rpi.sss.util.jsp;

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

