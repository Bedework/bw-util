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
package edu.rpi.cmt.util.test;

import edu.rpi.cmt.config.ConfigBase;

import org.junit.Test;

import java.io.StringBufferInputStream;
import java.io.StringWriter;
import java.util.ArrayList;

import junit.framework.TestCase;

/** Test the Util class
 */
public class ConfigTest extends TestCase {
  /**
   */
  @Test
  public void testConfig() {
    AnObject ao = new AnObject();
    ao.setA("value for A");
    ao.setName("Value for name");
    ao.setB(1234);
    ao.setC(true);

    ao.setProps(new ArrayList<String>());
    ao.getProps().add("p1=a");
    ao.getProps().add("p2=b");
    ao.getProps().add("p3=c");
    ao.getProps().add("p4=d");

    ao.setNums(new ArrayList<Integer>());
    ao.getNums().add(1);
    ao.getNums().add(2);
    ao.getNums().add(3);
    ao.getNums().add(4);

    StringWriter sw = new StringWriter();

    try {
      ao.toXml(sw);

      String xmlFormat1 = sw.toString();

      // Read it back

      StringBufferInputStream sbis = new StringBufferInputStream(xmlFormat1);

      ConfigBase cb = ConfigBase.fromXml(sbis, AnObject.class);

      sw = new StringWriter();

      cb.toXml(sw);

      //System.out.println("After rereading");

      String xmlFormat2 = sw.toString();

      assertEquals(xmlFormat1, xmlFormat2);
    } catch (Throwable t) {
      fail(t.getMessage());
    }
  }
}

