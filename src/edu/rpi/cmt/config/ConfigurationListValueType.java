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
package edu.rpi.cmt.config;

import edu.rpi.sss.util.Util;
import edu.rpi.sss.util.xml.XmlEmit;
import edu.rpi.sss.util.xml.XmlUtil;
import edu.rpi.sss.util.xml.tagdefs.BedeworkServerTags;

import org.w3c.dom.Node;

import java.util.ArrayList;
import java.util.List;

import javax.xml.namespace.QName;

/** Class to represent a List<ConfigurationElementType> value in a configuration.
 *
 * @author Mike Douglass douglm
 */
public class ConfigurationListValueType
    extends ConfigurationValueType<List<ConfigurationElementType>,
    ConfigurationListValueType> {
  private QName elementName;
  private List<ConfigurationElementType> value;

  /**
   * @param elementName
   */
  public ConfigurationListValueType(final QName elementName) {
    this.elementName = elementName;
  }

  @Override
  public QName getElementName() {
    return elementName;
  }

  @Override
  public String getElementType() {
    return ConfigurationTypes.typeList;
  }

  @Override
  public void setValue(final List<ConfigurationElementType> val) throws ConfigException {
    value = val;
  }

  @Override
  public List<ConfigurationElementType> getValue() throws ConfigException {
    if (value == null) {
      value = new ArrayList<ConfigurationElementType>();
    }

    return value;
  }

  @Override
  public void valueFromXml(final Node nd) throws ConfigException {
    try {
      List<ConfigurationElementType> els = new ArrayList<ConfigurationElementType>();

      for (Node cnd: XmlUtil.getElementsArray(nd)) {
        ConfigurationElementType ce = fromXml(cnd);

        if (ce != null) {
          els.add(ce);
        }
      }

      setValue(els);
    } catch (Throwable t) {
      throw new ConfigException(t);
    }
  }

  @Override
  public void valueToXml(final XmlEmit xml) throws ConfigException {
    try {
      xml.newline();
      for (ConfigurationElementType ce: getValue()) {
        ce.toXml(xml);
      }
    } catch (Throwable t) {
      throw new ConfigException(t);
    }
  }

  /** Find first (or only) element with given name
   *
   * @param name
   * @return element or null
   * @throws ConfigException
   */
  public ConfigurationElementType find(final QName name) throws ConfigException {
    for (ConfigurationElementType ce: getValue()) {
      if (ce.getElementName().equals(name)) {
        return ce;
      }
    }

    return null;
  }

  /** Find all elements with given name
   *
   * @param name
   * @return list of elements - never null
   * @throws ConfigException
   */
  public List<ConfigurationElementType> findAll(final QName name) throws ConfigException {
    List<ConfigurationElementType> els = new ArrayList<ConfigurationElementType>();

    for (ConfigurationElementType ce: getValue()) {
      if (ce.getElementName().equals(name)) {
        els.add(ce);
      }
    }

    return els;
  }

  /**
   * @param name
   * @return list of values
   * @throws ConfigException
   */
  public List<String> getAll(final QName name) throws ConfigException {
    List<ConfigurationElementType> els = findAll(name);
    List<String> vals = new ArrayList<String>();

    if (els.isEmpty()) {
      return vals;
    }

    for (ConfigurationElementType ce: els) {
      if (!(ce instanceof ConfigurationValueType)) {
        continue;
      }

      vals.add(((ConfigurationValueType)ce).getValue().toString());
    }

    return vals;
  }

  /** Add a property
   *
   * @param name
   * @param value
   * @throws ConfigException
   */
  public void addProperty(final QName name,
                          final String value) throws ConfigException {
    ConfigurationStringValueType cv = new ConfigurationStringValueType(name);
    cv.setValue(value);
    getValue().add(cv);
  }

  /**
   * @param name
   * @param value
   * @return true if removed
   * @throws ConfigException
   */
  public boolean removeProperty(final QName name,
                                final String value) throws ConfigException {
    ConfigurationStringValueType cv = new ConfigurationStringValueType(name);
    cv.setValue(value);
    return removeProperty(cv);
  }

  /**
   * @param val
   * @return true if removed
   * @throws ConfigException
   */
  public boolean removeProperty(final ConfigurationElementType val) throws ConfigException {
    return getValue().remove(val);
  }

  /**
   * @param name
   * @return element or null
   * @throws ConfigException if more than one value found
   */
  public ConfigurationElementType findSingleValueProperty(final QName name) throws ConfigException {
    List<ConfigurationElementType> ps = findAll(name);

    if (ps.size() == 0) {
      return null;
    }

    if (ps.size() > 1) {
      throw new ConfigException("Multiple values for single valued property " + name);
    }

    return ps.get(0);
  }

  /** Set the single valued property
  *
  * @param name
  * @param value
   * @throws ConfigException if more than one value found
  */
  public void setProperty(final QName name,
                          final String value) throws ConfigException {
    ConfigurationElementType ce = findSingleValueProperty(name);

    if (ce == null) {
      addString(name, value);
      return;
    }

    ConfigurationStringValueType p = (ConfigurationStringValueType)ce;

    if (!p.getValue().equals(value)) {
      p.setValue(value);
    }
  }

  /**
   * @param name
   * @return single value of valued property with given name
   * @throws ConfigException if more than one value found
   */
  public String getPropertyValue(final QName name) throws ConfigException {
    ConfigurationElementType ce = findSingleValueProperty(name);

    if (ce == null) {
      return null;
    }

    return ((ConfigurationStringValueType)ce).getValue();
  }

  /** Set the single valued property
   *
   * @param name
   * @param value
   * @throws ConfigException if more than one value found
   */
  public void setBooleanProperty(final QName name,
                                 final Boolean value) throws ConfigException {
    ConfigurationElementType ce = findSingleValueProperty(name);

    if (ce == null) {
      addBoolean(name, value);
      return;
    }

    ConfigurationBooleanValueType p = (ConfigurationBooleanValueType)ce;

    if (!p.getValue().equals(value)) {
      p.setValue(value);
    }
  }

  /**
   * @param name
   * @return single value of valued property with given name
   * @throws ConfigException if more than one value found
   */
  public Boolean getBooleanPropertyValue(final QName name) throws ConfigException {
    ConfigurationElementType ce = findSingleValueProperty(name);

    if (ce == null) {
      return false;
    }

    Boolean bval = ((ConfigurationBooleanValueType)ce).getValue();

    if (bval == null) {
      return false;
    }

    return bval;
  }

  /** Set the single valued property
  *
  * @param name
  * @param value
   * @throws ConfigException if more than one value found
  */
  public void setIntegerProperty(final QName name,
                                 final Integer value) throws ConfigException {
    ConfigurationElementType ce = findSingleValueProperty(name);

    if (ce == null) {
      addInteger(name, value);
      return;
    }

    ConfigurationIntegerValueType p = (ConfigurationIntegerValueType)ce;

    if (!p.getValue().equals(value)) {
      p.setValue(value);
    }
  }

  /**
   * @param name
   * @return single value of valued property with given name
   * @throws ConfigException if more than one value found
   */
  public Integer getIntegerPropertyValue(final QName name) throws ConfigException {
    ConfigurationElementType ce = findSingleValueProperty(name);

    if (ce == null) {
      return null;
    }

    return ((ConfigurationIntegerValueType)ce).getValue();
  }

  /** Add a Boolean value in the default namespace
   * @param localName
   * @param val
   * @return config element
   * @throws ConfigException
   */
  public ConfigurationBooleanValueType addBoolean(final String localName,
                                                  final Boolean val) throws ConfigException {
    return addBoolean(new QName(BedeworkServerTags.bedeworkSystemNamespace,
                           localName), val);
  }

  /** Add a Boolean value in the default namespace
   * @param name
   * @param val
   * @return config element
   * @throws ConfigException
   */
  public ConfigurationBooleanValueType addBoolean(final QName name,
                                                  final Boolean val) throws ConfigException {
    ConfigurationBooleanValueType cv = new ConfigurationBooleanValueType(name);
    cv.setValue(val);

    getValue().add(cv);

    return cv;
  }

  /** Add a Integer value in the default namespace
   * @param localName
   * @param val
   * @return config element
   * @throws ConfigException
   */
  public ConfigurationIntegerValueType addInteger(final String localName,
                                                  final Integer val) throws ConfigException {
    return addInteger(new QName(BedeworkServerTags.bedeworkSystemNamespace,
                           localName), val);
  }

  /** Add a Integer value in the default namespace
   * @param name
   * @param val
   * @return config element
   * @throws ConfigException
   */
  public ConfigurationIntegerValueType addInteger(final QName name,
                                                  final Integer val) throws ConfigException {
    ConfigurationIntegerValueType cv = new ConfigurationIntegerValueType(name);
    cv.setValue(val);

    getValue().add(cv);

    return cv;
  }

  /** Add a Long value in the default namespace
   * @param localName
   * @param val
   * @return config element
   * @throws ConfigException
   */
  public ConfigurationLongValueType addLong(final String localName,
                                            final Long val) throws ConfigException {
    QName name = new QName(BedeworkServerTags.bedeworkSystemNamespace,
                           localName);

    ConfigurationLongValueType cv = new ConfigurationLongValueType(name);
    cv.setValue(val);

    getValue().add(cv);

    return cv;
  }

  /** Add an empty List value in the default namespace
   * @param localName
   * @return config element
   * @throws ConfigException
   */
  public ConfigurationListValueType addList(final String localName) throws ConfigException {
    QName name = new QName(BedeworkServerTags.bedeworkSystemNamespace,
                           localName);

    ConfigurationListValueType cv = new ConfigurationListValueType(name);

    getValue().add(cv);

    return cv;
  }

  /** Add a String value in the default namespace
   * @param localName
   * @param val
   * @return config element
   * @throws ConfigException
   */
  public ConfigurationStringValueType addString(final String localName,
                                                final String val) throws ConfigException {
    return addString(new QName(BedeworkServerTags.bedeworkSystemNamespace,
                               localName),
                     val);
  }

  /** Add a String value in the default namespace
   * @param name
   * @param val
   * @return config element
   * @throws ConfigException
   */
  public ConfigurationStringValueType addString(final QName name,
                                                final String val) throws ConfigException {
    ConfigurationStringValueType cv = new ConfigurationStringValueType(name);
    cv.setValue(val);

    getValue().add(cv);

    return cv;
  }

  @Override
  public int compareTo(final ConfigurationElementType that) {
    try {
      if (that instanceof ConfigurationListValueType) {
        return Util.cmpObjval(getValue(),
                              ((ConfigurationListValueType)that).getValue());
      }

      return getClass().getName().compareTo(that.getClass().getName());
    } catch (Throwable t) {
      throw new RuntimeException(t);
    }
  }
}
