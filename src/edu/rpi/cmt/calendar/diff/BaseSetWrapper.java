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
package edu.rpi.cmt.calendar.diff;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;

import javax.xml.namespace.QName;

/** This class wraps an array of components.
 *
 * @author Mike Douglass
 */
abstract class BaseSetWrapper<T extends BaseWrapper,
                              ParentT extends BaseWrapper, ListT>
        extends BaseWrapper<ParentT> {
  private Set<T> els = new TreeSet<T>();

  private T[] tarray;

  BaseSetWrapper(final ParentT parent,
                 final QName name) {
    super(parent, name);
  }

  protected void init() {
    List<ListT> l = getListT();

    for (ListT el: l) {
      T t = getWrapped(el);

      if (t == null) {
        // Skip this one
        continue;
      }

      els.add(t);
    }

    /* The set is ordered - use that to produce ordered array */

    tarray = getTarray(l.size());
    int i = 0;

    for (T t: els) {
      getTarray()[i] = t;
      i++;
    }
  }

  abstract T getWrapped(ListT el);

  abstract T[] getTarray(int len);

  abstract List<ListT> getListT();

  Set<T> getEls() {
    return els;
  }

  int size() {
    return els.size();
  }

  public T[] getTarray() {
    return tarray;
  }

  T find(final QName nm) {
    for (T t: els) {
      if (t.getName().equals(nm)) {
        return t;
      }
    }

    return null;
  }

  List<T> findAll(final QName nm) {
    List<T> found = new ArrayList<T>();

    for (T t: els) {
      if (t.getName().equals(nm)) {
        found.add(t);
      }
    }

    return found;
  }

  @Override
  protected void toStringSegment(final StringBuilder sb) {
    sb.append("size=");
    sb.append(size());

    for (T t: els) {
      sb.append(",\n   ");
      sb.append(t.toString());
    }
  }
}
