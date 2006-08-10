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

package edu.rpi.sss.util.log;

import javax.servlet.http.HttpServletRequest;

/**
 * Interface defining some logging methods for http applications.
 *
 * <p>getLogEntry, logInfo, logRequest, logSessionCounts provide information
 * for usage statistics of web applications.
 *
 * @author Mike Douglass  douglm@rpi.edu
 */
public interface HttpAppLogger extends AppLogger {
  /**
   *
   */
  public static abstract class LogEntry {
    /** Append to a log entry. Value should not contain colons or should be
     * the last element.
     *
     * @param val    String element to append
     */
    public abstract void append(String val);

    /** Concatenate some info without a delimiter.
     *
     * @param val    String to concat
     */
    public abstract void concat(String val);

    /** Emit the log entry
     */
    public abstract void emit();
  }

  /** Return a LogEntry containing the start of a log entry.
   *
   * @param request    HttpServletRequest
   * @param logname    String name for the log entry
   * @return LogEntry    containing prefix
   */
  public LogEntry getLogEntry(HttpServletRequest request,
                              String logname);

  /** Log some information.
   *
   * @param request    HttpServletRequest
   * @param logname    String name for the log entry
   * @param info       String information to log
   */
  public void logInfo(HttpServletRequest request,
                      String logname,
                      String info);


  /** Log the request - virtual domains can make it difficult to
   *  distinguish applications.
   *
   * @param request    HttpServletRequest
   * @throws Throwable
   */
  public void logRequest(HttpServletRequest request)
               throws Throwable;

  /** Log the session counters for applications that maintain them.
   *
   * @param request    HttpServletRequest
   * @param start      true for session start
   * @param sessionNum long number of session
   * @param sessions   long number of concurrent sessions
   */
  public void logSessionCounts(HttpServletRequest request,
                               boolean start,
                               long sessionNum,
                               long sessions);
}

