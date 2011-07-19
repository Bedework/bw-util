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

import edu.rpi.sss.util.Util;
import edu.rpi.sss.util.xml.NsContext;

import org.oasis_open.docs.ns.wscal.calws_soap.SelectElementType;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.xml.bind.JAXBElement;
import javax.xml.namespace.QName;

/** This class wraps a property.
 *
 * <p>The mappedName handles cases where we preserve a value with an x-property.
 *
 * <p>MS adds an organizer to events - even if it's not a meeting, which is out
 * of spec. We preserve that value in an x-property. The real name is the name
 * of the x-property. The mappedName is "organizer". This allows comparisons to work
 * OK and we can manufacture the correct update from the property.
 *
 * @author Mike Douglass
 *
 * @param <T>
 * @param <ParentT>
 * @param <EntityT>
 */
abstract class BaseEntityWrapper<T extends BaseEntityWrapper,
                                 ParentT extends BaseWrapper, EntityT>
        extends BaseWrapper<ParentT> {
  private QName mappedName;

  /* The entity we want to change */
  private EntityT entity;

  private boolean add;
  private boolean delete;

  private T diffVal;

  public static class ValueTypeEntry implements Comparable<ValueTypeEntry> {
    public QName typeElement;
    public String value;

    public ValueTypeEntry(final QName typeElement,
                          final String value) {
      this.typeElement = typeElement;
      this.value = value;
    }

    public String toString(final NsContext nsContext) {
      StringBuilder sb = new StringBuilder();

      sb.append("<");
      nsContext.appendNsName(sb, typeElement);
      sb.append(">");
      sb.append(value);
      sb.append("</");
      nsContext.appendNsName(sb, typeElement);
      sb.append(">");

      return sb.toString();
    }

    @Override
    public String toString() {
      StringBuilder sb = new StringBuilder();

      sb.append(typeElement);
      sb.append(value);

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

      return value.compareTo(o.value);
    }

    @Override
    public boolean equals(final Object o) {
      return compareTo((ValueTypeEntry)o) == 0;
    }
  }

  public static class ValueType implements Comparable<ValueType> {
    public List<ValueTypeEntry> vtes = new ArrayList<ValueTypeEntry>();

    public ValueType() {}

    public ValueType(final QName typeElement,
                     final String value) {
      vtes.add(new ValueTypeEntry(typeElement, value));
    }

    public String toString(final NsContext nsContext) {
      StringBuilder sb = new StringBuilder();

      for (ValueTypeEntry vte: vtes) {
        sb.append(vte.toString(nsContext));
      }

      return sb.toString();
    }

    @Override
    public String toString() {
      StringBuilder sb = new StringBuilder();

      for (ValueTypeEntry vte: vtes) {
        sb.append(vte.toString());
      }

      return sb.toString();
    }

    public int compareTo(final ValueType o) {
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
    public boolean equals(final Object o) {
      return compareTo((ValueType)o) == 0;
    }
  }

  BaseEntityWrapper(final ParentT parent,
                    final QName name,
                    final EntityT entity) {
    super(parent, name);
    this.entity = entity;

    mappedName = getMappedName(name);

    if (mappedName == null) {
      mappedName = name;
    }
  }

  QName getMappedName() {
    return mappedName;
  }

  EntityT getEntity() {
    return entity;
  }

  @SuppressWarnings("unchecked")
  JAXBElement<? extends EntityT> getJaxbElement() {
    return new JAXBElement<EntityT>(getName(),
                                    (Class<EntityT>)entity.getClass(),
                                    getEntity());
  }

  /**
   * @param name
   * @return null for no mapping.
   */
  abstract QName getMappedName(QName name);

  /** Get the value used for an update
   * @return ValueType
   */
  abstract ValueType getUpdateValue();

  /** For example, two events objects represent the same entity if the uid and
   * recurrence-ids match.
   *
   * @param val - the other wrapped entity
   * @return true if this represents the same (but possibly altered) entity.
   */
  abstract boolean sameEntity(BaseEntityWrapper val);

  /**
   * @return SelectElementType representing the selection or change
   */
  abstract SelectElementType getChange();

  /**
   * @param val
   */
  public void setAdd(final boolean val) {
    add = val;
  }

  /**
   * @return true if we should add this to the target
   */
  public boolean getAdd() {
    return add;
  }

  /**
   * @param val
   */
  public void setDelete(final boolean val) {
    delete = val;
  }

  /**
   * @return true if we should delete this from the target
   */
  public boolean getDelete() {
    return delete;
  }

  /**
   * @param val needed to change to match the original
   */
  public void setDiffVal(final T val) {
    diffVal = val;
  }

  /**
   * @return value needed to change to match the original
   */
  public T getDiffVal() {
    return diffVal;
  }

  public int compareNames(final BaseEntityWrapper that) {
    QName thatN = that.getMappedName();

    int res = getMappedName().getNamespaceURI().compareTo(thatN.getNamespaceURI());
    if (res != 0) {
      return res;
    }

    return getMappedName().getLocalPart().compareTo(thatN.getLocalPart());
  }

  public int compareNameClass(final BaseEntityWrapper that) {
    int res = compareNames(that);
    if (res != 0) {
      return res;
    }

    return getEntity().getClass().getName().compareTo(that.getEntity().getClass().getName());
  }

  public int compareTo(final BaseEntityWrapper o) {
    int res = Util.compareStrings(getName().getLocalPart(),
                              o.getName().getLocalPart());

    if (res != 0) {
      return res;
    }

    return Util.compareStrings(getName().getNamespaceURI(),
                               o.getName().getNamespaceURI());
  }

  @Override
  protected void toStringSegment(final StringBuilder sb) {
    super.toStringSegment(sb);

    if (!mappedName.equals(getName())) {
      sb.append(", mappedName=");
      sb.append(mappedName);
    }

    if (add) {
      sb.append(", add");
    } else if (delete) {
      sb.append(", delete");
    }
  }
}
