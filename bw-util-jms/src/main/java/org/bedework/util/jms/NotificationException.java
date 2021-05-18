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

/** Exception for notifications classes
 *
 * @author Mike Douglass
 */
public class NotificationException extends Throwable {
  /** */
  public static final String noActionClassName =
    "org.bedework.exception.noactionclassname";

  /** */
  public static final String noActionClass =
    "org.bedework.exception.noactionclass";

  /** */
  public static final String notActionClass =
    "org.bedework.exception.notactionclass";

  private String extra;

  /**
   * @param code an identifier
   */
  public NotificationException(final String code) {
    super(code);
  }

  /**
   * @param code  - retrieve with getMessage(), property ame
   * @param extra String extra text
   */
  public NotificationException(final String code, final String extra) {
    super(code);
    this.extra = extra;
  }

  /**
   * @param t the exception
   */
  public NotificationException(final Throwable t) {
    super(t);
  }

  /**
   * @return String extra text
   */
  public String getExtra() {
    return extra;
  }

  /**
   * @return String message and 'extra'
   */
  public String getMessageExtra() {
    if (getExtra() != null) {
      return super.getMessage() + "\t" + getExtra();
    }

    return super.getMessage();
  }
}
