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
package org.bedework.util.struts;

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

    /**
     *
     * @param name of header to log
     */
    public abstract void header(String name);

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
   * @throws Throwable on error
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

