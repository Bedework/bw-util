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
package org.bedework.util.calendar.diff;

import org.bedework.util.misc.Util;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.xml.namespace.QName;

/** This class allows comparison of calendaring values. They are gernated by
 * the ValueMatcher object and can be compared to another to determine if the
 * values are equal.
 *
 * @author Mike Douglass
 *
 */
public class ValueComparator implements Comparable<ValueComparator> {
  private static class ValueTypeEntry implements Comparable<ValueTypeEntry> {
    QName typeElement;
    String value;

    public ValueTypeEntry(final QName typeElement,
                          final String value) {
      this.typeElement = typeElement;
      this.value = value;
    }

    @Override
    public String toString() {
      StringBuilder sb = new StringBuilder();

      sb.append(" (");
      sb.append(typeElement);
      sb.append(", ");
      sb.append(value);
      sb.append(")");

      return sb.toString();
    }

    public int compareTo(final ValueTypeEntry o) {
      int res = typeElement.getNamespaceURI().compareTo(o.typeElement.getNamespaceURI());
      if (res != 0) {
        return res;
      }

      res = typeElement.getLocalPart().compareTo(o.typeElement.getLocalPart());
      if (res != 0) {
        return res;
      }

      return Util.compareStrings(value, o.value);
    }

    @Override
    public int hashCode() {
      return typeElement.hashCode() * value.hashCode();
    }

    @Override
    public boolean equals(final Object o) {
      return compareTo((ValueTypeEntry)o) == 0;
    }
  }

  private List<ValueTypeEntry> vtes = new ArrayList<ValueTypeEntry>();

  /**
   */
  public ValueComparator() {
  }

  /**
   * @param typeElement
   * @param value
   */
  void addValue(final QName typeElement,
                final String value) {
    vtes.add(new ValueTypeEntry(typeElement, value));
  }

  @Override
  public String toString() {
    StringBuilder sb = new StringBuilder();

    for (ValueTypeEntry vte: vtes) {
      sb.append(vte.toString());
    }

    return sb.toString();
  }

  public int compareTo(final ValueComparator o) {
    Integer thisSz = vtes.size();
    Integer thatSz = o.vtes.size();

    int res = thisSz.compareTo(thatSz);
    if (res != 0) {
      return res;
    }

    Iterator<ValueTypeEntry> thatIt = o.vtes.iterator();

    for (ValueTypeEntry vte: vtes) {
      ValueTypeEntry thatVte = thatIt.next();

      res = vte.compareTo(thatVte);
      if (res != 0) {
        return res;
      }
    }

    return 0;
  }

  @Override
  public int hashCode() {
    int res = vtes.size();

    for (ValueTypeEntry vte: vtes) {
      res *= vte.hashCode();
    }

    return res;
  }

  @Override
  public boolean equals(final Object o) {
    return compareTo((ValueComparator)o) == 0;
  }
}
