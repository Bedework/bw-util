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
public class ConfigurationListValueType extends ConfigurationValueType<List<ConfigurationElementType>> {
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
}
