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
/**
 * Copyright (c) 2010, Ben Fortuna
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 *  o Redistributions of source code must retain the above copyright
 * notice, this list of conditions and the following disclaimer.
 *
 *  o Redistributions in binary form must reproduce the above copyright
 * notice, this list of conditions and the following disclaimer in the
 * documentation and/or other materials provided with the distribution.
 *
 *  o Neither the name of Ben Fortuna nor the names of any other contributors
 * may be used to endorse or promote products derived from this software
 * without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
package edu.rpi.cmt.calendar;

import edu.rpi.sss.util.xml.XmlUtil;
import edu.rpi.sss.util.xml.tagdefs.XcalTags;

import net.fortuna.ical4j.data.ContentHandler;
import net.fortuna.ical4j.data.ParserException;
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
import net.fortuna.ical4j.model.TimeZoneRegistry;
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

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.net.URISyntaxException;
import java.nio.charset.Charset;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

/**
 * Parses and builds an iCalendar model from an xml input stream.
 * Note that this class is not thread-safe.
 *
 * @version 1.0
 * @author Mike Douglass
 *
 * Created: Sept 8, 2010
 *
 */
public class XmlCalendarBuilder {
  private static final Charset DEFAULT_CHARSET = Charset.forName("UTF-8");

  //private Logger log = Logger.getLogger(XmlCalendarBuilder.class);

  private final TimeZoneRegistry tzRegistry;

  /**
   * @author douglm
   */
  public static class BuildState {
    ContentHandler handler;

    TimeZoneRegistry tzRegistry;

    /**
     * The calendar instance(s) created by the builder.
     */
    List<Calendar> calendars = new ArrayList<Calendar>();

    /**
     * The current calendar instance being created by the builder.
     */
    Calendar calendar;

    /**
     * The current component instance created by the builder.
     */
    Component component;

    /**
     * The current sub-component instance created by the builder.
     */
    Component subComponent;

    /**
     * The current property instance created by the builder.
     */
    Property property;

    List<Property> datesMissingTimezones = new ArrayList<Property>();

    public BuildState(final TimeZoneRegistry tzRegistry) {
      this.tzRegistry = tzRegistry;
    }

    public void setContentHandler(final ContentHandler val) {
      handler = val;
    }

    public ContentHandler getContentHandler() {
      return handler;
    }

    public Calendar getCalendar() {
      return calendar;
    }
  }

  /**
   * @param tzRegistry a custom timezone registry
   */
  public XmlCalendarBuilder(final TimeZoneRegistry tzRegistry) {
    this.tzRegistry = tzRegistry;
  }

  /**
   * Builds an iCalendar model from the specified input stream.
   * @param in an input stream to read calendar data from
   * @return a calendar parsed from the specified input stream
   * @throws IOException where an error occurs reading data from the specified stream
   * @throws ParserException where an error occurs parsing data from the stream
   */
  public Calendar build(final InputStream in) throws IOException,
  ParserException {
    return build(new InputStreamReader(in, DEFAULT_CHARSET));
  }

  /**
   * Build an iCalendar model by parsing data from the specified reader.
   *
   * @param in an unfolding reader to read data from
   * @return a calendar parsed from the specified reader
   * @throws IOException where an error occurs reading data from the specified reader
   * @throws ParserException where an error occurs parsing data from the reader
   */
  public Calendar build(final Reader in) throws IOException,
  ParserException {
    BuildState bs = new BuildState(tzRegistry);

    bs.setContentHandler(new ContentHandlerImpl(bs));

    try {
      DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
      factory.setNamespaceAware(true);

      DocumentBuilder builder = factory.newDocumentBuilder();

      Document doc = builder.parse(new InputSource(in));

      process(doc, bs);
    } catch (SAXException e) {
      throw new ParserException(e.getMessage(), 0, e);
    } catch (Throwable t) {
      throw new ParserException(t.getMessage(), 0, t);
    }

    if ((bs.datesMissingTimezones.size() > 0) && (tzRegistry != null)) {
      resolveTimezones(bs);
    }

    return bs.calendars.iterator().next();
  }

  private void process(final Document doc,
                       final BuildState bs) throws ParserException {
    // start = element icalendar { vcalendar+ }

    Element root = doc.getDocumentElement();

    if (!XmlUtil.nodeMatches(root, XcalTags.icalendar)) {
      // error
      throw new ParserException("Expected " + XcalTags.icalendar +
                                " found " + root, 0);
    }

    for (Element el: getChildren(root)) {
      // Expect vcalendar

      if (!XmlUtil.nodeMatches(el, XcalTags.vcalendar)) {
        // error
        throw new ParserException("Expected " + XcalTags.vcalendar +
                                  " found " + el, 0);
      }

      bs.calendar = null;
      processVcalendar(el, bs);

      if (bs.calendar != null) {
        bs.calendars.add(bs.calendar);
      }
    }
  }

  private void processVcalendar(final Element el,
                                final BuildState bs) throws ParserException {
    bs.handler.startCalendar();

    try {
      Collection<Element> els = XmlUtil.getElements(el);
      /*
          vcalendar = element vcalendar {
            type-calprops,
            type-component
          }
       */
      Iterator<Element> elit = els.iterator();

      Element vcel = null;

      if (elit.hasNext()) {
        vcel = elit.next();
      }

      /*
        type-calprops = element properties {
            property-prodid &
            property-version &
            property-calscale? &
            property-method?
        }
       */
      if (XmlUtil.nodeMatches(vcel, XcalTags.properties)) {
        processProperties(vcel, bs);

        if (elit.hasNext()) {
          vcel = elit.next();
        } else {
          vcel = null;
        }
      }

      if (XmlUtil.nodeMatches(vcel, XcalTags.components)) {
        processCalcomps(vcel, bs);

        if (elit.hasNext()) {
          vcel = elit.next();
        } else {
          vcel = null;
        }
      }

      if (vcel != null) {
        throw new ParserException("Unexpected element: found " + vcel, 0);
      }
    } catch (SAXException e) {
      throw new ParserException(e.getMessage(), 0, e);
    }
  }

  private void processProperties(final Element el,
                                 final BuildState bs) throws ParserException {
    try {
      for (Element e: XmlUtil.getElements(el)) {
        processProperty(e, bs);
      }
    } catch (SAXException e) {
      throw new ParserException(e.getMessage(), 0, e);
    }
  }

  private void processCalcomps(final Element el,
                               final BuildState bs) throws ParserException {
    /*
      type-component = element components {
          (
              component-vevent |
              component-vtodo |
              component-vjournal |
              component-vfreebusy |
              component-vtimezone
          )*
      }
     */
    try {
      for (Element e: XmlUtil.getElements(el)) {
        processComponent(e, bs);
      }
    } catch (SAXException e) {
      throw new ParserException(e.getMessage(), 0, e);
    }
  }

  private void processComponent(final Element el,
                                final BuildState bs) throws ParserException {
    try {
      bs.handler.startComponent(el.getLocalName().toUpperCase());

      for (Element e: XmlUtil.getElements(el)) {
        if (XmlUtil.nodeMatches(e, XcalTags.properties)) {
          processProperties(e, bs);
        } else if (XmlUtil.nodeMatches(e, XcalTags.components)) {
          for (Element ce: XmlUtil.getElements(e)) {
            processComponent(ce, bs);
          }
        } else {
          throw new ParserException("Unexpected element: found " + e, 0);
        }
      }

      bs.handler.endComponent(el.getLocalName().toUpperCase());
    } catch (SAXException e) {
      throw new ParserException(e.getMessage(), 0, e);
    }
  }

  private void processProperty(final Element el,
                               final BuildState bs) throws ParserException {
    try {
      bs.handler.startProperty(el.getLocalName());

      for (Element e: XmlUtil.getElements(el)) {
        if (XmlUtil.nodeMatches(e, XcalTags.parameters)) {
          for (Element par: XmlUtil.getElements(e)) {
            bs.handler.parameter(par.getLocalName(),
                                 XmlUtil.getElementContent(par));
          }
        }

        if (!processValue(e, bs)) {
          throw new ParserException("Bad property " + el, 0);
        }
      }

      bs.handler.endProperty(el.getLocalName());
    } catch (SAXException e) {
      throw new ParserException(e.getMessage(), 0, e);
    } catch (URISyntaxException e) {
      throw new ParserException(e.getMessage(), 0, e);
    }
  }

  private boolean processValue(final Element el,
                               final BuildState bs) throws ParserException {
    try {
      if (XmlUtil.nodeMatches(el, XcalTags.recurVal)) {
        /*
            value-recur = element recur {
              type-freq,
              (type-until | type-count)?,
              element interval  { text }?,
              element bysecond  { text }*,
              element byminute  { text }*,
              element byhour    { text }*,
              type-byday*,
              type-bymonthday*,
              type-byyearday*,
              type-byweekno*,
              element bymonth   { text }*,
              type-bysetpos*,
              element wkst { type-weekday }?
          }

         */
        StringBuilder sb = new StringBuilder();

        String delim = "";

        for (Element re: XmlUtil.getElements(el)) {
          sb.append(delim);
          delim = ";";
          sb.append(re.getLocalName().toUpperCase());
          sb.append("=");
          sb.append(XmlUtil.getElementContent(re));
        }

        bs.handler.propertyValue(sb.toString());

        return true;
      }

      if (XmlUtil.nodeMatches(el, XcalTags.binaryVal) ||
          XmlUtil.nodeMatches(el, XcalTags.booleanVal) ||
          XmlUtil.nodeMatches(el, XcalTags.calAddressVal) ||
          XmlUtil.nodeMatches(el, XcalTags.dateVal) ||
          XmlUtil.nodeMatches(el, XcalTags.dateTimeVal) ||
          XmlUtil.nodeMatches(el, XcalTags.durationVal) ||
          XmlUtil.nodeMatches(el, XcalTags.floatVal) ||
          XmlUtil.nodeMatches(el, XcalTags.integerVal) ||
          XmlUtil.nodeMatches(el, XcalTags.periodVal) ||
          XmlUtil.nodeMatches(el, XcalTags.textVal) ||
          XmlUtil.nodeMatches(el, XcalTags.timeVal) ||
          XmlUtil.nodeMatches(el, XcalTags.uriVal) ||
          XmlUtil.nodeMatches(el, XcalTags.utcOffsetVal)) {
        bs.handler.propertyValue(XmlUtil.getElementContent(el));
        return true;
      }

      return false;
    } catch (SAXException e) {
      throw new ParserException(e.getMessage(), 0, e);
    } catch (URISyntaxException e) {
      throw new ParserException(e.getMessage(), 0, e);
    } catch (ParseException e) {
      throw new ParserException(e.getMessage(), 0, e);
    } catch (IOException e) {
      throw new ParserException(e.getMessage(), 0, e);
    }
  }

  /**
   * @author douglm
   */
  public static class ContentHandlerImpl implements ContentHandler {
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
      assertComponent(bs.component);

      if (bs.subComponent != null) {
        if (bs.component instanceof VTimeZone) {
          ((VTimeZone) bs.component).getObservances().add(bs.subComponent);
        }
        else if (bs.component instanceof VEvent) {
          ((VEvent) bs.component).getAlarms().add(bs.subComponent);
        }
        else if (bs.component instanceof VToDo) {
          ((VToDo) bs.component).getAlarms().add(bs.subComponent);
        }
        else if (bs.component instanceof VAvailability) {
          ((VAvailability) bs.component).getAvailable().add(bs.subComponent);
        }
        bs.subComponent = null;
      }
      else {
        bs.calendar.getComponents().add(bs.component);
        if ((bs.component instanceof VTimeZone) && (bs.tzRegistry != null)) {
          // register the timezone for use with iCalendar objects..
          bs.tzRegistry.register(new TimeZone((VTimeZone) bs.component));
        }
        bs.component = null;
      }
    }

    @Override
    public void endProperty(final String name) {
      assertProperty(bs.property);

      // replace with a constant instance if applicable..
      bs.property = Constants.forProperty(bs.property);
      if (bs.component != null) {
        if (bs.subComponent != null) {
          bs.subComponent.getProperties().add(bs.property);
        }
        else {
          bs.component.getProperties().add(bs.property);
        }
      }
      else if (bs.calendar != null) {
        bs.calendar.getProperties().add(bs.property);
      }

      bs.property = null;
    }

    @Override
    public void parameter(final String name, final String value) throws URISyntaxException {
      assertProperty(bs.property);

      // parameter names are case-insensitive, but convert to upper case to simplify further processing
      final Parameter param = parameterFactory.createParameter(name.toUpperCase(), value);
      bs.property.getParameters().add(param);
      if ((param instanceof TzId) && (bs.tzRegistry != null)) {
        final TimeZone timezone = bs.tzRegistry.getTimeZone(param.getValue());
        if (timezone != null) {
          updateTimeZone(bs.property, timezone);

          /* Bedework - for the moment switch ids if they differ */

          if (!timezone.getID().equals(param.getValue())) {
            /* Fetched timezone has a different id */

            ParameterList pl = bs.property.getParameters();

            pl.replace(ParameterFactoryImpl.getInstance().
                       createParameter(Parameter.TZID, timezone.getID()));
          }
        } else {
          // VTIMEZONE may be defined later, so so keep
          // track of dates until all components have been
          // parsed, and then try again later
          bs.datesMissingTimezones.add(bs.property);
        }
      }
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void propertyValue(final String value) throws URISyntaxException,
           ParseException, IOException {

      assertProperty(bs.property);

      if (bs.property instanceof Escapable) {
        bs.property.setValue(Strings.unescape(value));
      }
      else {
        bs.property.setValue(value);
      }
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void startCalendar() {
      bs.calendar = new Calendar();
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void startComponent(final String name) {
      if (bs.component != null) {
        bs.subComponent = componentFactory.createComponent(name);
      }
      else {
        bs.component = componentFactory.createComponent(name);
      }
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void startProperty(final String name) {
      // property names are case-insensitive, but convert to upper case to simplify further processing
      bs.property = propertyFactory.createProperty(name.toUpperCase());
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
          if (CompatibilityHints.isHintEnabled(CompatibilityHints.KEY_RELAXED_PARSING)) {
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

  /**
   * Returns the timezone registry used in the construction of calendars.
   * @return a timezone registry
   */
  public final TimeZoneRegistry getRegistry() {
    return tzRegistry;
  }

  private void resolveTimezones(final BuildState bs) throws IOException {

    // Go through each property and try to resolve the TZID.
    for (final Property property: bs.datesMissingTimezones) {
      final Parameter tzParam = property.getParameter(Parameter.TZID);

      // tzParam might be null:
      if (tzParam == null) {
        continue;
      }

      //lookup timezone
      final TimeZone timezone = tzRegistry.getTimeZone(tzParam.getValue());

      // If timezone found, then update date property
      if (timezone != null) {
        // Get the String representation of date(s) as
        // we will need this after changing the timezone
        final String strDate = property.getValue();

        // Change the timezone
        if(property instanceof DateProperty) {
          ((DateProperty) property).setTimeZone(timezone);
        }
        else if(property instanceof DateListProperty) {
          ((DateListProperty) property).setTimeZone(timezone);
        }

        // Reset value
        try {
          property.setValue(strDate);
        } catch (ParseException e) {
          // shouldn't happen as its already been parsed
          throw new CalendarException(e);
        } catch (URISyntaxException e) {
          // shouldn't happen as its already been parsed
          throw new CalendarException(e);
        }
      }
    }
  }

  /* ====================================================================
   *                   XmlUtil wrappers
   * ==================================================================== */

  boolean icalElement(final Element el) {
    if (el == null) {
      return false;
    }

    String ns = el.getNamespaceURI();

    if ((ns == null) || !ns.equals(XcalTags.namespace)) {
      return false;
    }

    return true;
  }

  boolean icalElement(final Element el, final String name) {
    if (!icalElement(el)) {
      return false;
    }

    String ln = el.getLocalName();

    if (ln == null) {
      return false;
    }

    return ln.equals(name);
  }

  protected Collection<Element> getChildren(final Node nd) throws ParserException {
    try {
      return XmlUtil.getElements(nd);
    } catch (Throwable t) {
      throw new ParserException(t.getMessage(), 0);
    }
  }

  protected Element[] getChildrenArray(final Node nd) throws ParserException {
    try {
      return XmlUtil.getElementsArray(nd);
    } catch (Throwable t) {
      throw new ParserException(t.getMessage(), 0);
    }
  }

  protected Element getOnlyChild(final Node nd) throws ParserException {
    try {
      return XmlUtil.getOnlyElement(nd);
    } catch (Throwable t) {
      throw new ParserException(t.getMessage(), 0);
    }
  }

  protected String getElementContent(final Element el) throws ParserException {
    try {
      return XmlUtil.getElementContent(el);
    } catch (Throwable t) {
      throw new ParserException(t.getMessage(), 0);
    }
  }

  protected boolean isEmpty(final Element el) throws ParserException {
    try {
      return XmlUtil.isEmpty(el);
    } catch (Throwable t) {
      throw new ParserException(t.getMessage(), 0);
    }
  }
}
