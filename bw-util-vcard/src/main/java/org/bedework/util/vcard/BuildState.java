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
package org.bedework.util.vcard;

import net.fortuna.ical4j.model.TimeZoneRegistry;
import net.fortuna.ical4j.util.Strings;
import net.fortuna.ical4j.vcard.Group;
import net.fortuna.ical4j.vcard.Parameter;
import net.fortuna.ical4j.vcard.Property;
import net.fortuna.ical4j.vcard.PropertyFactory;
import net.fortuna.ical4j.vcard.PropertyFactoryRegistry;
import net.fortuna.ical4j.vcard.VCard;
import net.fortuna.ical4j.vcard.property.Xproperty;
import net.fortuna.ical4j.vcard.property.Xproperty.ExtendedFactory;
import org.apache.commons.codec.DecoderException;

import java.net.URISyntaxException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;

/** Track the state while building vcards.
 *
 * @author douglm
 *
 */
public class BuildState {
  private final PropertyFactoryRegistry propertyFactoryRegistry =
          new PropertyFactoryRegistry();

  private ContentHandler handler;

  private TimeZoneRegistry tzRegistry;

  /**
   * The current card instance being created by the builder.
   */
  private VCard card;

  private PropertyFactory propertyFactory;

  private Group group;

  private List<Parameter> params;

  private Property property;

  private String propertyName;

  private List<Property> datesMissingTimezones = new ArrayList<>();

  /**Constructor
   *
   * @param tzRegistry the timezone registry
   */
  public BuildState(final TimeZoneRegistry tzRegistry) {
    this.tzRegistry = tzRegistry;
  }

  /**
   * @param val the content handler
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
   * @param val - the card
   */
  public void setCard(VCard val) {
    card = val;
  }

  /**
   * @return the result
   */
  public VCard getCard() {
    return card;
  }

  public Group getGroup() {
    return group;
  }

  public void setGroup(final Group val) {
    group = val;
  }

  public Property getProperty() {
    return property;
  }

  public void startProperty(final String name) {
    propertyName = name;
    propertyFactory = propertyFactoryRegistry.getFactory(
            name);

    if (propertyFactory == null) {
      propertyFactory = Xproperty.FACTORY;
    }

    property = null;
    params = null;
  }

  public String getPropertyName() {
    return propertyName;
  }

  public void addParameter(final Parameter val) {
    if (params == null) {
      params = new ArrayList<>();
    }

    params.add(val);
  }

  public void setPropertyValue(final String val)
          throws ParseException, URISyntaxException {
    final String value = Strings.unescape(val);

    try {
      if (params == null) {
        params = new ArrayList<>();
      }

      if (propertyFactory instanceof ExtendedFactory) {
        final ExtendedFactory xfactory = (ExtendedFactory)propertyFactory;

        if (group == null) {
          property = xfactory.createProperty(propertyName, params, value);
        } else {
          property = xfactory.createProperty(group, propertyName, params, value);
        }

        return;
      }

      if (group == null) {
        property = propertyFactory.createProperty(params, value);
      } else {
        property = propertyFactory.createProperty(group, params, value);
      }
    } catch (final DecoderException de) {
      throw new ParseException(de.getMessage(), 0);
    }
  }

  public List<Property> getDatesMissingTimezones() {
    return datesMissingTimezones;
  }
}
