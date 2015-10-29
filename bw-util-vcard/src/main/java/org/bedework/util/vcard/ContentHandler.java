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

import net.fortuna.ical4j.vcard.Group;
import net.fortuna.ical4j.vcard.GroupRegistry;
import net.fortuna.ical4j.vcard.ParameterFactory;
import net.fortuna.ical4j.vcard.ParameterFactoryRegistry;
import net.fortuna.ical4j.vcard.Property;
import net.fortuna.ical4j.vcard.VCard;

import java.io.IOException;
import java.net.URISyntaxException;
import java.text.ParseException;

/** Track the state while building calendars.
 *
 * @author douglm
 *
 */
public class ContentHandler {
  private BuildState bs;

  private final ParameterFactoryRegistry parameterFactoryRegistry =
          new ParameterFactoryRegistry();

  private final GroupRegistry groupRegistry = new GroupRegistry();

  /**
   * @param bs build state
   */
  public ContentHandler(final BuildState bs) {
    this.bs = bs;
  }

  public void endCard() {
    // do nothing..
  }

  public void endProperty(final String name) {
    assertProperty(bs.getProperty());

    if (bs.getCard() != null) {
      bs.getCard().getProperties().add(bs.getProperty());
    }
  }

  public void parameter(final String name, final String value) throws URISyntaxException {
    final String ucname = name.toUpperCase();

    if ("GROUP".equals(ucname)) {
      Group g = groupRegistry.getGroup(ucname);

      if (g == null) {
        g = new Group(ucname);
        groupRegistry.register(ucname, g);
      }

      assertNoGroup();
      bs.setGroup(g);
      return;
    }

    final ParameterFactory parameterFactory = parameterFactoryRegistry.getFactory(name.toUpperCase());

    bs.addParameter(parameterFactory.createParameter(value));
  }

  public void propertyValue(final String value) throws URISyntaxException,
          ParseException, IOException {
    bs.setPropertyValue(value);
  }

  public void startCard() {
    bs.setCard(new VCard());
  }

  public void startProperty(final String name) {
    bs.startProperty(name.toUpperCase());
  }

  private void assertNoGroup() {
    if (bs.getGroup() != null) {
      throw new RuntimeException("Group already specified");
    }
  }

  private void assertProperty(final Property property) {
    if (property == null) {
      throw new RuntimeException("Expected property not initialised");
    }
  }
}
