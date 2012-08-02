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


/** Help with ToString. And yes I know there's an Apache Commons one but I want
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

  /** Create an instance for the given object
   *
   * @param o
   */
  public ToString(final Object o) {
    sb = new StringBuilder(o.getClass().getSimpleName()).append("{");
  }

  /** Create an instance for the given object and indentation
   *
   * @param o
   * @param indent
   */
  public ToString(final Object o, final String indent) {
    sb = new StringBuilder(indent);
    sb.append(o.getClass().getSimpleName()).append("{");
    this.indent = indent;
  }

  /**
   * @return the StringBuilder we use
   */
  public StringBuilder getSb() {
    return sb;
  }

  /** add list delimiter
   *
   * @return this
   */
  public ToString delimit() {
    sb.append(delim);
    delim = ", ";
    if (sb.length() > maxLen) {
      sb.append("\n");
      sb.append(indent);
      sb.append(indentVal);
    }

    return this;
  }

  /** add new line and list delimiter
   *
   * @return this
   */
  public ToString newLine() {
    sb.append(delim);
    delim = "";
    sb.append("\n");
    sb.append(indent);
    sb.append(indentVal);

    return this;
  }

  /**
   * @param value to append
   * @return this object
   */
  public ToString append(final String value) {
    delimit();
    sb.append(value);

    return this;
  }

  /**
   * @param value to append
   * @return this object
   */
  public ToString append(final Object value) {
    delimit();
    sb.append(String.valueOf(value));

    return this;
  }

  /**
   * @param name
   * @param value
   * @return this object
   */
  public ToString append(final String name, final String value) {
    delimit();
    sb.append(name);
    sb.append("=");
    sb.append(value);

    return this;
  }

  /**
   * @param name
   * @param value
   * @return this object
   */
  public ToString append(final String name, final Long value) {
    delimit();
    sb.append(name);
    sb.append("=");
    sb.append(value);

    return this;
  }

  /**
   * @param name
   * @param value - list of values
   * @return this object
   */
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

  /**
   * @param name
   * @param value boolean
   * @return this object
   */
  public ToString append(final String name, final boolean value) {
    return append(name, String.valueOf(value));
  }

  /**
   * @param name
   * @param value int
   * @return this object
   */
  public ToString append(final String name, final int value) {
    return append(name, String.valueOf(value));
  }

  /**
   * @param t - throwable to output
   * @return this object
   */
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
