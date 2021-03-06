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
package org.bedework.util.jms.listeners;

import org.bedework.util.jms.NotificationException;
import org.bedework.util.jms.events.SysEvent;

/** Listener class registered with the notifications handler to listen for
 * various types of event.
 *
 * @author Mike Douglass
 */
public abstract class SysEventListener {
  /** Set name of action class.
   *
   * @param className
   * @throws NotificationException on fatal error
   */
  public abstract void setActionClassName(String className) throws NotificationException;

  /** Supply action object - will set class name.
   *
   * @param actionObject
   * @throws NotificationException on fatal error
   */
  public abstract void setActionObject(SysEventActionClass actionObject) throws NotificationException;

  /** Called whenever a matching event occurs. Will call the action class.
   *
   * @param ev
   * @throws NotificationException on fatal error
   */
  public abstract void action(SysEvent ev) throws NotificationException;

  /** Create a string representation.
   *
   * @return String
   * @throws NotificationException on fatal error
   */
  public abstract String toXml() throws NotificationException;
}
