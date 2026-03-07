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
package org.bedework.util.properties.test;

import org.bedework.util.properties.PlaceHolderProperties;
import org.bedework.util.properties.PropertyFetcher;

import org.junit.jupiter.api.Test;

import static org.bedework.util.properties.PropertyUtil.propertyReplace;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.fail;

/** Test the misc Util classes
 *
 * @author Mike Douglass       douglm@bedework.edu
   @version 1.0
 */
public class PlaceHolderPropertiesTest {
  private record NamedValue(String name,
                            String val) {}

  private static class Pfetcher
          implements PropertyFetcher {
    final NamedValue[] tokens;

    private Pfetcher(final NamedValue[] tokens) {
      this.tokens = tokens;
    }
    @Override
    public String get(final String name) {
      if (tokens == null) {
        return null;
      }

      for (final NamedValue n : tokens) {
        if (n.name.equals(name)) {
          return n.val;
        }
      }

      return null;
    }
  }

  private record BeforeAfter(String before,
                             NamedValue[] tokens,
                             String after) {}

  private static final BeforeAfter[] propReplaceValues = {
      new BeforeAfter("1. Test the misc Util classes",
                      null,
                      "1. Test the misc Util classes"),

      new BeforeAfter("2. Test the misc ${name1} classes",
                      new NamedValue[] {
                          new NamedValue("name1",
                                         "utility"),
                          },
                      "2. Test the misc utility classes"),

      new BeforeAfter("3. Test the misc ${name2} classes",
                      null,
                      "3. Test the misc ${name2} classes"),

      new BeforeAfter("4. Test the misc ${name3} classes",
                      new NamedValue[] {
                          new NamedValue("name3",
                                         "u${name4}y"),
                          new NamedValue("name4",
                                         "tilit"),
                          },
                      "4. Test the misc utility classes"),

      new BeforeAfter("5. Test the misc ${n${name6}5} classes",
                      new NamedValue[] {
                          new NamedValue("name5",
                                         "utility"),
                          new NamedValue("name6",
                                         "ame"),
                          },
                      "5. Test the misc utility classes"),

      new BeforeAfter("6. Test the misc ${n${name6 classes",
                      new NamedValue[] {
                          new NamedValue("name5",
                                         "utility"),
                          new NamedValue("name6",
                                         "ame"),
                          },
                      "6. Test the misc ${n${name6 classes")
  };

  /**
   *
   */
  @Test
  public void testPropertyReplace() {
    try {
      for (final var prv: propReplaceValues) {
        final var pfetcher = new Pfetcher(prv.tokens);
        assertEquals(prv.after(),
                     propertyReplace(prv.before,
                                          pfetcher),
                     "Invalid replacement");
      }

    } catch (final Throwable t) {
      fail("Exception testing propertyReplace: " + t.getMessage());
    }
  }

  @Test
  public void testPropertyParents() {
    try {
      final var props = PlaceHolderProperties.loadWithSuperProperties("src/test/resources/child.properties");

      assertEquals("This is property a set by the child",
                   props.getProperty("a"));
      assertEquals("b set by grandparent",
                   props.getProperty("b"));
      assertEquals("c set by parent",
                   props.getProperty("c"));
      assertEquals("d set by parent",
                   props.getProperty("d"));
      assertEquals("e set by child",
                   props.getProperty("e"));
      assertEquals("f set by grandparent",
                   props.getProperty("f"));
    } catch (final Throwable t) {
      t.printStackTrace();
      fail("Exception testing propertyParents: " + t.getMessage());
    }
  }

  private void log(final String msg) {
    System.out.println(this.getClass().getName() + ": " + msg);
  }
}

