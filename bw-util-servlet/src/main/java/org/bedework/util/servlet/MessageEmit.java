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

import java.io.Serializable;

/** This object allows context free error message generation.
 *  At the point messages are generated we might be called from the web
 *  world or from an application world.
 *
 * <p>Each method takes a property name as the first parameter.
 * Optional arguments follow.
 *
 * <p>The implementation is of course free to interpret the first parameter
 * any way it wants. The assumption though, is that rather than providing
 * the actual message text the pname acts as a reference.
 *
 * @author Mike Douglass douglm@rpi.edu
 * @version 1.0
 */
public interface MessageEmit extends Serializable {
  /** We define a number of message emit methods.
   */

  /** Emit message with given property name
   *
   * @param pname
   */
  public void emit(String pname);

  /** Emit message with given property name and int value
   *
   * @param pname
   * @param num
   */
  public void emit(String pname, int num);

  /** Set the property name of the default exception message
   *
   * @param pname
   */
  public void setExceptionPname(String pname);

  /** Emit an exception message
   *
   * @param t
   */
  public void emit(Throwable t);

  /** Emit message with given property name and Object value
   *
   * @param pname
   * @param o
   */
  public void emit(String pname, Object o);

  /** Emit message with given property name and Object values
   *
   * @param pname
   * @param o1
   * @param o2
   */
  public void emit(String pname, Object o1, Object o2);

  /** Emit message with given property name and Object values
   *
   * @param pname
   * @param o1
   * @param o2
   * @param o3
   */
  public void emit(String pname, Object o1, Object o2, Object o3);

  /** Indicate no messages emitted.
   */
  public void clear();

  /** @return true if any messages emitted
   */
  public boolean messagesEmitted();
}

