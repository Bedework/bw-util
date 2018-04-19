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

package org.bedework.util.json;

import java.util.List;
import java.util.Map;

/**
 *
 * @author   Mike Douglass
 * @version  1.0
 *
 * A number of bitty utility routines.
 */
public class JsonUtil {
  private JsonUtil() {} // Don't instantiate this

  /** Encode a json string according to the statement:
   * <p>In JSON only the backslash, double quote and ASCII control characters
   * need to be escaped. Forward slashes may be escaped
   *
   * <p>I assume we also need to do the whitespace characters
   *
   * @param val
   * @return encoded String
   */
  public static String jsonEncode(final String val) {
    if ((val == null) || (val.length() == 0)) {
      return "\"\"";
    }

    StringBuilder sb = new StringBuilder();

    /* \n    newline
     * \t   tab
     * \b   backspace
     * \f   form feed
     * \r   return
     * \"   "   (double quote)
     * \\   \    (back slash)
     */

    sb.append('"');

    for (int i = 0; i < val.length(); i++) {
      char ch = val.charAt(i);

      switch (ch) {
      case '\n':
        sb.append("\\n");
        break;

      case '\t':
        sb.append("\\t");
        break;

      case '\b':
        sb.append("\\b");
        break;

      case '\f':
        sb.append("\\f");
        break;

      case '\r':
        sb.append("\\r");
        break;

      case '"':
      case '/':
      case '\\':
        sb.append('\\');
        sb.append(ch);
        break;

      case ' ':
        sb.append(" ");
        break;

      default:
        if (Character.isISOControl(ch)) {
          String str = Integer.toHexString(ch);
          sb.append("\\u");
          sb.append("0000".substring(str.length() - 4));
          sb.append(str);
        } else {
          sb.append(ch);
        }
      }
    }

    sb.append('"');
    return sb.toString();
  }

  /** Encode a json name and value for output
   *
   * @param indent initial space
   * @param name of field
   * @param val and value
   * @return encoded String
   */
  public static String jsonNameVal(final String indent, 
                                   final String name, 
                                   final String val) {
    StringBuilder sb = new StringBuilder();

    sb.append(indent);
    sb.append("\"");
    sb.append(name);
    sb.append("\": ");

    if (val != null) {
      sb.append(jsonEncode(val));
    }

    return sb.toString();
  }

  public static String must(final String name,
                            final Map theVals) throws Exception {
    Object val = theVals.get(name);

    if (val == null) {
      throw new Exception("missing value: " + name);
    }

    return (String)val;
  }

  public static String may(final String name,
                           final Map theVals) throws Exception {
    Object val = theVals.get(name);

    if (val == null) {
      return null;
    }

    return (String)val;
  }

  public static List mustList(final String name,
                              final Map theVals) throws Exception {
    Object val = theVals.get(name);

    if (val == null) {
      throw new Exception("missing value: " + name);
    }

    return (List)val;
  }

  public static List mayList(final String name,
                             final Map theVals) throws Exception {
    Object val = theVals.get(name);

    if (val == null) {
      return null;
    }

    return (List)val;
  }
}
