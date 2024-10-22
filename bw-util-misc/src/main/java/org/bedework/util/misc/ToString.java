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
package org.bedework.util.misc;

import java.util.Collection;

/** Help with ToString. And yes I know there's an Apache Commons one but I want
 * easier formatting and this is trivial.
 *
 * @author douglm
 *
 */
public class ToString {
  private StringBuilder sb;
  private int indents;
  private String delim = "";

  private int lastNewLinePos = 0;

  private boolean valuesOnly;
  private boolean delimitersOn = true;

  private final static int maxLen = 80;
  private final static String indentVal = "  ";

  private int lineCt;
  private int objStartLineCt;

  /** Objects implementing this can be called with the
   * current ToString object.
   *
   */
  public interface ToStringProducer {
    void toStringWith(ToString ts);
  }

  /** Create an instance for the given object
   *
   * @param o the object
   */
  public ToString(final Object o) {
    sb = new StringBuilder(o.getClass().getSimpleName()).append("{");
    indents++;
  }

  private ToString() {
  }

  /**
   * @return ToString configured to output mostly just the values.
   */
  public static ToString valuesOnly() {
    final ToString ts = new ToString();

    ts.valuesOnly = true;
    ts.sb = new StringBuilder();

    return ts;
  }

  /** Create an instance for the given object and indentation
   *
   * @param o the object
   * @param indents number of indentVal spaces
   */
  public ToString(final Object o, final int indents) {
    sb = new StringBuilder();
    sb.append(indentVal.repeat(Math.max(0, indents)));
    sb.append(o.getClass().getSimpleName()).append("{");
    this.indents = Math.max(0, indents);
  }

  public ToString initClass(final Object o) {
    sb.append(o.getClass().getSimpleName()).append("{");
    clearDelim();
    indents++;
    objStartLineCt = lineCt;
    return this;
  }

  /**
   * @return the StringBuilder we use
   */
  public StringBuilder getSb() {
    return sb;
  }

  public ToString delimitersOn() {
    delimitersOn = true;

    return this;
  }

  public ToString delimitersOff() {
    delimitersOn = false;

    return this;
  }

  public ToString clearDelim() {
    delim = "";

    return this;
  }

  /** add list delimiter
   *
   * @return this
   */
  public ToString delimit() {
    if (delimitersOn) {
      sb.append(delim);
      delim = ", ";
    }
    if (lineLength() > maxLen) {
      outputNewLine();
    }

    return this;
  }

  public ToString indentIn() {
    indents++;
    return this;
  }

  public ToString indentOut() {
    if (indents > 0) {
      indents--;
    }

    return this;
  }

  /**
   *
   * @return length of current output line.
   */
  public int lineLength() {
    return sb.length() - lastNewLinePos;
  }

  /** add new line and list delimiter
   *
   * @return this
   */
  public ToString newLine() {
    sb.append(delim);
    delim = "";
    outputNewLine();

    return this;
  }

  /**
   * @param value to append quoted
   * @return this object
   */
  public ToString appendQ(final String value) {
    delimit();
    sb.append("\"")
      .append(value)
      .append("\"");

    return this;
  }

  /**
   * @param value to append in parentheses - no space or delim
   * @return this object
   */
  public ToString appendParen(final String value) {
    sb.append("(")
      .append(value)
      .append(")");

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
    return delimit()
            .appendObject(value);
  }

  /**
   * @param value to append
   * @return this object
   */
  public ToString appendObject(final Object value) {
    if (value instanceof ToStringProducer) {
      ((ToStringProducer)value).toStringWith(this);
    } else {
      sb.append(value);
    }

    return this;
  }

  /**
   * @param name of field
   * @param val iterable value to append
   * @param withNewLines true to add new line after each element
   * @return this object
   */
  public ToString append(final String name,
                         final Iterable<?> val,
                         final boolean withNewLines) {
    nameEquals(name);
    sb.append("[");

    if (val == null) {
      sb.append("]");
      return this;
    }

    indentIn();
    for (final Object o: val){
      if (withNewLines) {
        newLine();
      }

      append(o);
    }

    indentOut().newLine();
    sb.append("]");

    return this;
  }

  /**
   * @param name of field
   * @param value an object
   * @return this object
   */
  public ToString append(final String name,
                         final Object value) {
    return nameEquals(name)
            .appendObject(value);
  }

  /**
   * @param name of field
   * @param value Long
   * @return this object
   */
  public ToString append(final String name,
                         final Long value) {
    nameEquals(name);
    sb.append(value);

    return this;
  }

  /**
   * @param name of field
   * @param value - list of values
   * @return this object
   */
  public ToString append(final String name,
                         final Collection<?> value) {
    nameEquals(name);
    if (value == null) {
      sb.append("null");
      return this;
    }

    sb.append("[");

    final String saveDelim = delim;
    delim= "";

    for (final Object o: value) {
      append(o);
    }
    sb.append("]");

    delim = saveDelim;

    return this;
  }

  /**
   * @param name of field
   * @param value boolean
   * @return this object
   */
  public ToString append(final String name,
                         final boolean value) {
    return append(name, String.valueOf(value));
  }

  /**
   * @param name of field
   * @param value int
   * @return this object
   */
  public ToString append(final String name,
                         final int value) {
    return append(name, String.valueOf(value));
  }

  /**
   * @param t - throwable to output
   * @return this object
   */
  public ToString append(final Throwable t) {
    return append("Exception", t.getMessage());
  }

  public ToString nameEquals(final String name) {
    delimit();
    sb.append(name);
    sb.append("=");

    return this;
  }

  public ToString closeClass() {
    indentOut();
    if (objStartLineCt != lineCt) {
      outputNewLine();
    }
    if (!valuesOnly) {
      sb.append("}");
    }

    return this;
  }

  @Override
  public String toString() {
    return closeClass().getSb().toString();
  }

  private void outputNewLine() {
    sb.append("\n");
    lastNewLinePos = sb.length();
    lineCt++;
    sb.append(indentVal.repeat(indents));
  }
}
