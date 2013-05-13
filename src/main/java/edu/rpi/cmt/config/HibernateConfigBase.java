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

import edu.rpi.sss.util.ToString;

import java.util.ArrayList;
import java.util.List;

/** Used by configuration classes that want to save a set of hibernate properties.
 *
 * @author Mike Douglass
 */
public class HibernateConfigBase<T extends ConfigBase> extends ConfigBase<T> {
  private List<String> hibernateProperties;

  /**
   *
   * @param val
   */
  public void setHibernateProperties(final List<String> val) {
    hibernateProperties = val;
  }

  /**
   *
   * @return String val
   */
  @ConfInfo(collectionElementName = "hibernateProperty")
  public List<String> getHibernateProperties() {
    return hibernateProperties;
  }

  /**
   * @param val
   */
  public void setHibernateDialect(final String val) {
    setHibernateProperty("hibernate.dialect", val);
  }

  /**
   * @return current setting for hibernate dialect
   */
  @ConfInfo(dontSave = true)
  public String getHibernateDialect() {
    return getHibernateProperty("hibernate.dialect");
  }

  /** Add a hibernate property
   *
   * @param name
   * @param val
   */
  public void addHibernateProperty(final String name,
                                   final String val) {
    List<String> p = getHibernateProperties();
    if (p == null) {
      p = new ArrayList<String>();
      setHibernateProperties(p);
    }
    p.add(name + "=" + val);
  }

  /** Get a hibernate property
   *
   * @param val
   * @return value or null
   */
  @ConfInfo(dontSave = true)
  public String getHibernateProperty(final String val) {
    List<String> ps = getHibernateProperties();

    String key = val + "=";
    for (String p: ps) {
      if (p.startsWith(key)) {
        return p.substring(key.length());
      }
    }

    return null;
  }

  /** Remove a hibernate property
   *
   * @param name
   */
  public void removeHibernateProperty(final String name) {
    try {
      String v = getHibernateProperty(name);

      if (v == null) {
        return;
      }

      getHibernateProperties().remove(name + "=" + v);
    } catch (Throwable t) {
      throw new RuntimeException(t);
    }
  }

  /** Set a hibernate property
   *
   * @param name
   * @param val
   */
  public void setHibernateProperty(final String name,
                                   final String val) {
    try {
      removeHibernateProperty(name);
      addHibernateProperty(name, val);
    } catch (Throwable t) {
      throw new RuntimeException(t);
    }
  }

  @Override
  public void toStringSegment(final ToString ts) {
    super.toStringSegment(ts);

    ts.append("hibernateProperties", getHibernateProperties());
  }

  @Override
  public String toString() {
    ToString ts = new ToString(this);

    toStringSegment(ts);

    return ts.toString();
  }
}
