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

import org.bedework.util.logging.Logged;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

/**
 * Interface defining some logging methods for http applications.
 *
 * <p>getLogEntry, logInfo, logRequest, logSessionCounts provide information
 * for usage statistics of web applications.
 *
 * @author Mike Douglass  douglm@rpi.edu
 */
public interface HttpAppLogger extends Logged {
  /**
   *
   */
  class LogEntry {
    final HttpServletRequest request;
    StringBuffer sb;
    HttpAppLogger logger;

    public LogEntry(final HttpServletRequest request,
                    final StringBuffer sb,
                    final HttpAppLogger logger){
      this.request = request;
      this.sb = sb;
      this.logger = logger;

      sb.append(":");
      sb.append(logger.getSessionId(request));
      sb.append(":");
      sb.append(logger.getLogPrefix(request));
      sb.append(":charset=");
      sb.append(request.getCharacterEncoding());
    }

    /** Append to a log entry. Value should not contain colons or should be
     * the last element.
     *
     * @param val    String element to append
     */
    public void append(final String val) {
      sb.append(":");
      sb.append(val);
    }

    /** Concatenate some info without a delimiter.
     *
     * @param val    String to concat
     */
    public void concat(final String val) {
      sb.append(val);
    }

    public void header(final String name) {
      String val = request.getHeader(name);
      if (val == null) {
        val = "NONE";
      }

      sb.append(" - ");
      sb.append(name);
      sb.append(":");
      sb.append(val);
    }

    /** Emit the log entry
     */
    public void emit() {
      logger.emitLogEntry(this);
    }

    @Override
    public String toString() {
      return sb.toString();
    }
  }

  /** Return a LogEntry containing the start of a log entry.
   *
   * @param request    HttpServletRequest
   * @param logname    String name for the log entry
   * @return LogEntry    containing prefix
   */
  default LogEntry getLogEntry(final HttpServletRequest request,
                               final String logname) {
    return new LogEntry(request, new StringBuffer(logname), this);
  }

  /** Log some information.
   *
   * @param request    HttpServletRequest
   * @param logname    String name for the log entry
   * @param info       String information to log
   */
  default  void logInfo(final HttpServletRequest request,
                        final String logname,
                        final String info) {
    LogEntry le = getLogEntry(request, logname);

    le.append(info);

    le.emit();
  }

  /** Log the request - virtual domains can make it difficult to
   *  distinguish applications.
   *
   * @param request    HttpServletRequest
   * @throws Throwable on error
   */
  default void logRequest(final HttpServletRequest request)
          throws Throwable {
    LogEntry le = getLogEntry(request, "REQUEST");

    le.append(request.getRemoteAddr());
    le.append(HttpServletUtils.getUrl(request));

    String q = request.getQueryString();

    if (q != null) {
      le.concat("?");
      le.concat(q);
    }

    le.header("Referer");
    le.header("X-Forwarded-For");

    le.emit();
  }

  /** Log the request on the way out.
   *
   * @param request    HttpServletRequest
   * @throws Throwable on error
   */
  default void logRequestOut(final HttpServletRequest request)
          throws Throwable {
    LogEntry le = getLogEntry(request, "REQUEST-OUT");

    le.append(request.getRemoteAddr());
    le.append(HttpServletUtils.getUrl(request));

    String q = request.getQueryString();

    if (q != null) {
      le.concat("?");
      le.concat(q);
    }

    le.header("Referer");
    le.header("X-Forwarded-For");

    le.emit();
  }

  /** Log the session counters for applications that maintain them.
   *
   * @param request    HttpServletRequest
   * @param start      true for session start
   * @param sessionNum long number of session
   * @param sessions   long number of concurrent sessions
   */
  default void logSessionCounts(final HttpServletRequest request,
                                final boolean start,
                                final long sessionNum,
                                final long sessions) {
    LogEntry le;

    if (start) {
      le = getLogEntry(request, "SESSION-START");
    } else {
      le = getLogEntry(request, "SESSION-END");
    }

    le.append(String.valueOf(sessionNum));
    le.append(String.valueOf(sessions));

    le.emit();
  }

  /** Get a prefix for the loggers.
   *
   * @param request    HttpServletRequest
   * @return  String    log prefix
   */
  String getLogPrefix(HttpServletRequest request);

  /** Get the session id for the loggers.
   *
   * @param request the incoming request to log
   * @return  String    session id
   */
  default String getSessionId(final HttpServletRequest request) {
    try {
      HttpSession sess = request.getSession(false);

      if (sess == null) {
        return "NO-SESSIONID";
      } else {
        return sess.getId();
      }
    } catch (Throwable t) {
      error(t);
      return "SESSION-ID-EXCEPTION";
    }
  }

  /** Emit the log entry
   */
  default void emitLogEntry(LogEntry entry) {
    info(entry.toString());
  }
}

