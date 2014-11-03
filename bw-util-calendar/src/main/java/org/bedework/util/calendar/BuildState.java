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
package org.bedework.util.calendar;

import net.fortuna.ical4j.data.ContentHandler;
import net.fortuna.ical4j.model.Calendar;
import net.fortuna.ical4j.model.Component;
import net.fortuna.ical4j.model.Property;
import net.fortuna.ical4j.model.TimeZoneRegistry;

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

/** Track the state while building calendars.
 *
 * @author douglm
 *
 */
public class BuildState {
  private ContentHandler handler;

  private TimeZoneRegistry tzRegistry;

  /**
   * The calendar instance(s) created by the builder.
   */
  private List<Calendar> calendars = new ArrayList<>();

  /**
   * The current calendar instance being created by the builder.
   */
  private Calendar calendar;

  /**
   * The current component instances created by the builder.
   */
  private LinkedList<Component> components = new LinkedList<>();

  /**
   * The current property instance created by the builder.
   */
  private Property property;

  private List<Property> datesMissingTimezones = new ArrayList<>();

  /**Constructor
   *
   * @param tzRegistry
   */
  public BuildState(final TimeZoneRegistry tzRegistry) {
    this.tzRegistry = tzRegistry;
  }

  /**
   * @param val
   */
  public void setContentHandler(final ContentHandler val) {
    handler = val;
  }

  /**
   *
   * @return current registry
   */
  public TimeZoneRegistry getTzRegistry() {
    return tzRegistry;
  }

  /**
   * @return the handler
   */
  public ContentHandler getContentHandler() {
    return handler;
  }

  /**
   * @param val - the calendar
   */
  public void setCalendar(Calendar val) {
    calendar = val;
  }

  /**
   * @return the result
   */
  public Calendar getCalendar() {
    return calendar;
  }

  /**
   *
   * @return list of calendars - never null
   */
  public List<Calendar> getCalendars() {
    return calendars;
  }

  public Component getComponent() {
    if (components.size() == 0) {
      return null;
    }
    return components.peek();
  }

  public Component getSubComponent() {
    if (components.size() < 2) {
      return null;
    }
    return components.get(1);
  }

  public void startComponent(final Component component) {
    components.push(component);
  }

  public void endComponent() {
    components.pop();
  }

  public Property getProperty() {
    return property;
  }

  public void setProperty(final Property property) {
    this.property = property;
  }

  public List<Property> getDatesMissingTimezones() {
    return datesMissingTimezones;
  }
}
