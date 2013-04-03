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
import edu.rpi.sss.util.xml.XmlEmit.NameSpace;
import edu.rpi.sss.util.xml.XmlUtil;
import edu.rpi.sss.util.xml.tagdefs.BedeworkServerTags;

import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import java.io.InputStream;
import java.io.StringWriter;

import javax.xml.namespace.QName;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

/** Class to represent a configuration encoded as XML. There are 0-n elements
 * in a configuration and each element may contain 0-n elements or be a value.
 *
 * <p>Elements are identified by a QName and may be single valued or multi-valued.
 *
 * @author Mike Douglass douglm
 */
public class ConfigurationType extends ConfigurationListValueType {
  private String name;

  /**
   * @param val String used as a resource name
   */
  public void setName(final String val) {
    name = val;
  }

  /**
   * @return a String to use as a resource name
   */
  public String getName() {
    return name;
  }

  /** Identify a multi-valued element by name and position
   *
   */
  public class ElementId {
    private QName name;
    private int index;

    /**
     * @param name
     */
    public ElementId(final QName name) {
      this.name = name;
    }

    /**
     * @param name
     * @param index
     */
    public ElementId(final QName name,
                     final int index) {
      this(name);
      this.index = index;
    }

    /**
     * @return QName of element
     */
    public QName getName() {
      return name;
    }

    /**
     * @return 0 for first or only
     */
    public int getIndex() {
      return index;
    }
  }

  /* * An object of this kind is used to locate elements
   * /
  public class ElementLocator {
    /* *
     * @return list
     * /
    public abstract List<ElementId> getPath();
  }*/

  /**
   * @param configName
   */
  public ConfigurationType(final QName configName) {
    super(configName);
  }

  /**
   * @param is
   * @return parsed notification or null
   * @throws ConfigException
   */
  public static ConfigurationType fromXml(final InputStream is) throws ConfigException {
    try {
      Document doc = parseXmlString(is);

      if (doc == null) {
        return null;
      }

      Node nd = doc.getDocumentElement();

      ConfigurationType conf = new ConfigurationType(XmlUtil.fromNode(nd));

      conf.valueFromXml(nd);

      return conf;
    } catch (ConfigException ce) {
      throw ce;
    } catch (Throwable t) {
      throw new ConfigException(t);
    }
  }

  /**
   * @param is
   * @return parsed Document
   * @throws ConfigException
   */
  public static Document parseXmlString(final InputStream is) throws ConfigException {
    if (is == null) {
      return null;
    }

    try {
      DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
      factory.setNamespaceAware(true);

      DocumentBuilder builder = factory.newDocumentBuilder();

      return builder.parse(new InputSource(is));
    } catch (SAXException e) {
      throw new ConfigException(e);
    } catch (Throwable t) {
      throw new ConfigException(t);
    }
  }

  /**
   * @return XML version of config
   * @throws ConfigException
   */
  public String toXml() throws ConfigException {
    try {
      StringWriter str = new StringWriter();
      XmlEmit xml = new XmlEmit();

      xml.addNs(new NameSpace(BedeworkServerTags.bedeworkSystemNamespace, "BWS"), true);

      xml.startEmit(str);
      toXml(xml);

      return str.toString();
    } catch (Throwable t) {
      throw new ConfigException(t);
    }
  }
}
