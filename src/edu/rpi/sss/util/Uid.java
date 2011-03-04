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
package edu.rpi.sss.util;

import java.net.InetAddress;

/** Generate unique uids.
 *
 * @author douglm
 *
 */
public class Uid {
  /*  ---------------- UID gen fields -------------------- */

  /* This should be the MAC address -
   * Java 6 java.net.NetworkInterface class now has method getHardwareAddress()
   */
  private static final int IP;
  static {
    int ipadd;
    try {
      ipadd = toInt(InetAddress.getLocalHost().getAddress());
    } catch (Exception e) {
      ipadd = 0;
    }
    IP = ipadd;
  }

  private static short counter = (short) 0;
  private static final int JVM = (int) ( System.currentTimeMillis() >>> 8 );

  private static String sep = "-";

  /*  ---------------- UID gen fields -------------------- */

  /** Code copied and modified from hibernate UUIDHexGenerator. Generates a
   * unique 36 character key of hex + separators.
   *
   * @return String uid.
   */
  public static String getUid() {
    /* Unique down to millisecond */
    short hiTime = (short)(System.currentTimeMillis() >>> 32);

    int loTime = (int)System.currentTimeMillis();

    int ct;

    synchronized(Uid.class) {
      if (counter < 0) {
        counter = 0;
      }

      ct = counter++;
    }

    return new StringBuilder(36).
            append(format(IP)).append(sep).
            append(format(JVM)).append(sep).
            append(format(hiTime)).append(sep).
            append(format(loTime)).append(sep).
            append(format(ct)).
            toString();
  }

  private static String format(int intval) {
    String formatted = Integer.toHexString(intval);
    StringBuilder buf = new StringBuilder("00000000");
    buf.replace(8 - formatted.length(), 8, formatted);

    return buf.toString();
  }

  private static String format(short shortval) {
    String formatted = Integer.toHexString(shortval);
    StringBuilder buf = new StringBuilder("0000");
    buf.replace(4 - formatted.length(), 4, formatted);

    return buf.toString();
  }

  /** From hibernate.util
   *
   * @param bytes
   * @return int
   */
  public static int toInt(byte[] bytes ) {
    int result = 0;
    for (int i = 0; i < 4; i++) {
      result = (result << 8) - Byte.MIN_VALUE + (int)bytes[i];
    }

    return result;
  }
}
