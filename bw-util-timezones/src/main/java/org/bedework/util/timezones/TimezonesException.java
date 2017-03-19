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
package org.bedework.util.timezones;

/** Identify our exceptions.
 * @author douglm
 *
 */
public class TimezonesException extends Throwable {
  /** */
  public static String unknownTimezone = "org.bedework.timezones.exc.unknownTimezone";

  /** Implementation error */
  public static String cacheError = "org.bedework.timezones.exc.cacheerror";

  /** */
  public static String badDate = "org.bedework.timezones.exc.baddate";

  private String extra;

  /**
   */
  public TimezonesException() {
    super();
  }

  /**
   * @param t cause
   */
  public TimezonesException(final Throwable t) {
    super(t);
  }

  /**
   * @param msg the message
   */
  public TimezonesException(final String msg) {
    super(msg);
  }

  /**
   * @param msg the message
   * @param extra an extra message
   */
  public TimezonesException(final String msg, final String extra) {
    super(msg);
    this.extra = extra;
  }

  /**
   * @return String
   */
  public String getExtra() {
    return extra;
  }

  @Override
  public String toString() {
    StringBuilder sb = new StringBuilder(super.toString());
    if (extra != null) {
      sb.append(": ");
      sb.append(extra);
    }

    return sb.toString();
  }
}
