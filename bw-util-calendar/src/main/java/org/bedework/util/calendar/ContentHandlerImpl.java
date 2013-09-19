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
import net.fortuna.ical4j.model.CalendarException;
import net.fortuna.ical4j.model.Component;
import net.fortuna.ical4j.model.ComponentFactory;
import net.fortuna.ical4j.model.Escapable;
import net.fortuna.ical4j.model.Parameter;
import net.fortuna.ical4j.model.ParameterFactory;
import net.fortuna.ical4j.model.ParameterFactoryImpl;
import net.fortuna.ical4j.model.ParameterFactoryRegistry;
import net.fortuna.ical4j.model.ParameterList;
import net.fortuna.ical4j.model.Property;
import net.fortuna.ical4j.model.PropertyFactory;
import net.fortuna.ical4j.model.PropertyFactoryRegistry;
import net.fortuna.ical4j.model.TimeZone;
import net.fortuna.ical4j.model.component.VAvailability;
import net.fortuna.ical4j.model.component.VEvent;
import net.fortuna.ical4j.model.component.VTimeZone;
import net.fortuna.ical4j.model.component.VToDo;
import net.fortuna.ical4j.model.parameter.TzId;
import net.fortuna.ical4j.model.property.DateListProperty;
import net.fortuna.ical4j.model.property.DateProperty;
import net.fortuna.ical4j.util.CompatibilityHints;
import net.fortuna.ical4j.util.Constants;
import net.fortuna.ical4j.util.Strings;

import java.io.IOException;
import java.net.URISyntaxException;
import java.text.ParseException;

/** Track the state while building calendars.
 *
 * @author douglm
 *
 */
public class ContentHandlerImpl implements ContentHandler {
  private BuildState bs;

  private final ComponentFactory componentFactory;

  private final PropertyFactory propertyFactory;

  private final ParameterFactory parameterFactory;

  /**
   * @param bs
   */
  public ContentHandlerImpl(final BuildState bs) {
    this.bs = bs;
    componentFactory = ComponentFactory.getInstance();
    propertyFactory = new PropertyFactoryRegistry();
    parameterFactory = new ParameterFactoryRegistry();
  }

  @Override
  public void endCalendar() {
    // do nothing..
  }

  @Override
  public void endComponent(final String name) {
    assertComponent(bs.getComponent());

    if (bs.getSubComponent() != null) {
      if (bs.getComponent() instanceof VTimeZone) {
        ((VTimeZone) bs.getComponent()).getObservances().add(bs.getSubComponent());
      }
      else if (bs.getComponent() instanceof VEvent) {
        ((VEvent) bs.getComponent()).getAlarms().add(bs.getSubComponent());
      }
      else if (bs.getComponent() instanceof VToDo) {
        ((VToDo) bs.getComponent()).getAlarms().add(bs.getSubComponent());
      }
      else if (bs.getComponent() instanceof VAvailability) {
        ((VAvailability) bs.getComponent()).getAvailable().add(bs.getSubComponent());
      }
      bs.setSubComponent(null);
    }
    else {
      bs.getCalendar().getComponents().add(bs.getComponent());
      if ((bs.getComponent() instanceof VTimeZone) && (bs.getTzRegistry() != null)) {
        // register the timezone for use with iCalendar objects..
        bs.getTzRegistry().register(new TimeZone((VTimeZone) bs.getComponent()));
      }
      bs.setComponent(null);
    }
  }

  @Override
  public void endProperty(final String name) {
    assertProperty(bs.getProperty());

    // replace with a constant instance if applicable..
    bs.setProperty(Constants.forProperty(bs.getProperty()));
    if (bs.getComponent() != null) {
      if (bs.getSubComponent() != null) {
        bs.getSubComponent().getProperties().add(bs.getProperty());
      }
      else {
        bs.getComponent().getProperties().add(bs.getProperty());
      }
    }
    else if (bs.getCalendar() != null) {
      bs.getCalendar().getProperties().add(bs.getProperty());
    }

    bs.setProperty(null);
  }

  @Override
  public void parameter(final String name, final String value) throws URISyntaxException {
    assertProperty(bs.getProperty());

    // parameter names are case-insensitive, but convert to upper case to simplify further processing
    final Parameter param = parameterFactory.createParameter(name.toUpperCase(), value);
    bs.getProperty().getParameters().add(param);
    if ((param instanceof TzId) && (bs.getTzRegistry() != null)) {
      final TimeZone timezone = bs.getTzRegistry().getTimeZone(param.getValue());
      if (timezone != null) {
        updateTimeZone(bs.getProperty(), timezone);

          /* Bedework - for the moment switch ids if they differ */

        if (!timezone.getID().equals(param.getValue())) {
            /* Fetched timezone has a different id */

          ParameterList pl = bs.getProperty().getParameters();

          pl.replace(ParameterFactoryImpl.getInstance().
                  createParameter(Parameter.TZID, timezone.getID()));
        }
      } else {
        // VTIMEZONE may be defined later, so so keep
        // track of dates until all components have been
        // parsed, and then try again later
        bs.getDatesMissingTimezones().add(bs.getProperty());
      }
    }
  }

  /**
   * {@inheritDoc}
   */
  @Override
  public void propertyValue(final String value) throws URISyntaxException,
          ParseException, IOException {

    assertProperty(bs.getProperty());

    if (bs.getProperty() instanceof Escapable) {
      bs.getProperty().setValue(Strings.unescape(value));
    }
    else {
      bs.getProperty().setValue(value);
    }
  }

  /**
   * {@inheritDoc}
   */
  @Override
  public void startCalendar() {
    bs.setCalendar(new Calendar());
  }

  /**
   * {@inheritDoc}
   */
  @Override
  public void startComponent(final String name) {
    if (bs.getComponent() != null) {
      bs.setSubComponent(componentFactory.createComponent(name));
    }
    else {
      bs.setComponent(componentFactory.createComponent(name));
    }
  }

  /**
   * {@inheritDoc}
   */
  @Override
  public void startProperty(final String name) {
    // property names are case-insensitive, but convert to upper case to simplify further processing
    bs.setProperty(propertyFactory.createProperty(name.toUpperCase()));
  }

  private void assertComponent(final Component component) {
    if (component == null) {
      throw new CalendarException("Expected component not initialised");
    }
  }

  private void assertProperty(final Property property) {
    if (property == null) {
      throw new CalendarException("Expected property not initialised");
    }
  }

  private void updateTimeZone(final Property property, final TimeZone timezone) {
    try {
      ((DateProperty) property).setTimeZone(timezone);
    }
    catch (ClassCastException e) {
      try {
        ((DateListProperty) property).setTimeZone(timezone);
      }
      catch (ClassCastException e2) {
        if (CompatibilityHints.isHintEnabled(
                CompatibilityHints.KEY_RELAXED_PARSING)) {
//            log.warn("Error setting timezone [" + timezone.getID()
//                     + "] on property [" + property.getName()
//                     + "]", e);
//          }
        } else {
          throw e2;
        }
      }
    }
  }
}
