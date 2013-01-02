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

import org.w3c.dom.Element;
import org.w3c.dom.Node;

import java.util.List;

import javax.xml.namespace.QName;

/** Base class to represent one element in a configuration. The element may be a
 * complex object with one or multiple elements or a single value.
 *
 * <p>Each element is represented by an outer name element with a type
 * attribute enclosing a value. The type attribute value is a java class name.
 *
 * <p>The default is "java.lang.String" and may be omitted for that type.
 *
 * @author Mike Douglass douglm
 * @param <C>
 */
public abstract class ConfigurationElementType<C extends ConfigurationElementType>
    implements Comparable<ConfigurationElementType> {
  /**
   * @return a name to identify the element
   */
  public abstract QName getElementName();

  /**
   * @return a classname to identify the element type
   */
  public abstract String getElementType();

  /**
   */
  public static class AttributeType {
    private String name;
    private String value;

    /**
     * @param name
     * @param value
     */
    public AttributeType(final String name,
                         final String value) {
      this.name = name;
      this.value = value;
    }

    /**
     * @return the name
     */
    public String getName() {
      return name;
    }

    /**
     * @return the value
     */
    public String getValue() {
      return value;
    }
  }

  /**
   * @return null or a list of attributes attached to the value.
   */
  public List<AttributeType> getElementAttributes() {
    return null;
  }

  /** Convert the value part of the object from XML. The node is the type node
   * for this element.
   *
   * @param nd
   * @throws ConfigException
   */
  public abstract void valueFromXml(final Node nd) throws ConfigException;

  /**
   * @param nd
   * @return An object or null
   * @throws ConfigException
   */
  public static ConfigurationElementType fromXml(final Node nd) throws ConfigException {
    try {
      QName name = XmlUtil.fromNode(nd);

      /* Either has a type attribute or we assume String */

      String type = XmlUtil.getAttrVal((Element)nd, "type");

      ConfigurationElementType ce = null;

      if (type == null) {
        ce = new ConfigurationStringValueType(name);
      } else if (type.equals(ConfigurationTypes.typeBoolean)) {
        ce = new ConfigurationBooleanValueType(name);
      } else if (type.equals(ConfigurationTypes.typeInteger)) {
        ce = new ConfigurationIntegerValueType(name);
      } else if (type.equals(ConfigurationTypes.typeList)) {
        ce = new ConfigurationListValueType(name);
      } else if (type.equals(ConfigurationTypes.typeLong)) {
        ce = new ConfigurationLongValueType(name);
      } else if (type.equals(ConfigurationTypes.typeString)) {
        ce = new ConfigurationStringValueType(name);
      } else {
        ce = new ConfigurationObjectValueType(name, ConfigurationTypes.typeObject);
      }

      ce.valueFromXml(nd);

      return ce;
    } catch (Throwable t) {
      throw new ConfigException(t);
    }
  }

  /** Convert the value part of the object to XML via the parameter
   *
   * @param xml
   * @throws ConfigException
   */
  public abstract void valueToXml(final XmlEmit xml) throws ConfigException;

  /** Convert trhe object to an XML object via the parameter
   *
   * @param xml
   * @throws ConfigException
   */
  public void toXml(final XmlEmit xml) throws ConfigException {
    try {
      if (getElementType().equals(ConfigurationTypes.typeString)) {
        // Omit attribute
        xml.openTagNoNewline(getElementName());
      } else {
        xml.openTagNoNewline(getElementName(), "type", getElementType());
      }

      valueToXml(xml);

      xml.closeTagNoblanks(getElementName());
    } catch (Throwable t) {
      throw new ConfigException(t);
    }
  }

  @SuppressWarnings("unchecked")
  @Override
  public boolean equals(final Object o) {
    return compareTo((ConfigurationElementType)o) == 0;
  }
}
