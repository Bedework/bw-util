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

import java.util.List;


/** Help with ToString. And yes I know there's an APache Commons one but I want
 * easier formatting and this is trivial.
 *
 * @author douglm
 *
 */
public class ToString {
  private StringBuilder sb;
  private String indent = "";
  private String delim = "";

  private final static int maxLen = 80;
  private final static String indentVal = "  ";

  public ToString(final Object o) {
    sb = new StringBuilder(o.getClass().getSimpleName()).append("{");
  }

  public ToString(final Object o, final String indent) {
    sb = new StringBuilder(indent);
    sb.append(o.getClass().getSimpleName()).append("{");
    this.indent = indent;
  }

  public StringBuilder getSb() {
    return sb;
  }

  public ToString delimit() {
    sb.append(delim);
    delim = ", ";
    if (sb.length() > maxLen) {
      sb.append(",");
      sb.append(indent);
      sb.append(indentVal);
    }

    return this;
  }

  public ToString append(final String value) {
    delimit();
    sb.append(value);

    return this;
  }

  public ToString append(final String name, final String value) {
    delimit();
    sb.append(name);
    sb.append("=");
    sb.append(value);

    return this;
  }

  public ToString append(final String name, final List value) {
    delimit();
    sb.append(name);
    sb.append("=[");

    String saveDelim = delim;
    delim= "";

    for (Object o: value) {
      delimit();
      sb.append(o);
    }
    sb.append("]");

    delim = saveDelim;

    return this;
  }

  public ToString append(final String name, final boolean value) {
    return append(name, String.valueOf(value));
  }

  public ToString append(final String name, final int value) {
    return append(name, String.valueOf(value));
  }

  public ToString append(final Throwable t) {
    append("Exception building toString");
    return append(t.getMessage());
  }

  @Override
  public String toString() {
    sb.append("}");

    return sb.toString();
  }
}
