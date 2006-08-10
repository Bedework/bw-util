/* **********************************************************************
    Copyright 2006 Rensselaer Polytechnic Institute. All worldwide rights reserved.

    Redistribution and use of this distribution in source and binary forms,
    with or without modification, are permitted provided that:
       The above copyright notice and this permission notice appear in all
        copies and supporting documentation;

        The name, identifiers, and trademarks of Rensselaer Polytechnic
        Institute are not used in advertising or publicity without the
        express prior written permission of Rensselaer Polytechnic Institute;

    DISCLAIMER: The software is distributed" AS IS" without any express or
    implied warranty, including but not limited to, any implied warranties
    of merchantability or fitness for a particular purpose or any warrant)'
    of non-infringement of any current or pending patent rights. The authors
    of the software make no representations about the suitability of this
    software for any particular purpose. The entire risk as to the quality
    and performance of the software is with the user. Should the software
    prove defective, the user assumes the cost of all necessary servicing,
    repair or correction. In particular, neither Rensselaer Polytechnic
    Institute, nor the authors of the software are liable for any indirect,
    special, consequential, or incidental damages related to the software,
    to the maximum extent the law permits.
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

