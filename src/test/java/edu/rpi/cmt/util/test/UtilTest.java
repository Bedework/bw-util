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

import edu.rpi.sss.util.Util;

import java.util.Arrays;
import junit.framework.TestCase;

/** Test the Util class
 */
public class UtilTest extends TestCase {
  /**
   *
   */
  public void testEncodeDecodeArray() {
    String[] testcase1 = {
      "element with spaces",
      null,
      "element\twith\na number of odd characters",
      "An element with unicode \u2297"
    };

    String[] testcase2 = null;

    String[] testcase3 = {};

    doEqualTest("testcase1", testcase1);
    doEqualTest("testcase2", testcase2);
    doEqualTest("testcase3", testcase3);
  }

  private void doEqualTest(String name, String[] val) {
    String encoded = Util.encodeArray(val);

    String[] decoded = Util.decodeArray(encoded);

    assertTrue(name, Arrays.equals(val, decoded));
  }
}

