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
package org.bedework.util.config;

import org.bedework.util.misc.ToString;

import java.util.List;

/** Used by configuration classes that want to save a set of hibernate properties.
 *
 * @author Mike Douglass
 * @param <T>
 */
public class HibernateConfigBase<T extends ConfigBase>
        extends ConfigBase<T> implements HibernateConfigI {
  private List<String> hibernateProperties;

  @Override
  public void setHibernateProperties(final List<String> val) {
    hibernateProperties = val;
  }

  @Override
  @ConfInfo(collectionElementName = "hibernateProperty" ,
            elementType = "java.lang.String")
  public List<String> getHibernateProperties() {
    return hibernateProperties;
  }

  @Override
  public void setHibernateDialect(final String val) {
    setHibernateProperty("hibernate.dialect", val);
  }

  @Override
  @ConfInfo(dontSave = true)
  public String getHibernateDialect() {
    return getHibernateProperty("hibernate.dialect");
  }

  @Override
  public void addHibernateProperty(final String name,
                                   final String val) {
    setHibernateProperties(addListProperty(getHibernateProperties(),
                                           name, val));
  }

  @Override
  @ConfInfo(dontSave = true)
  public String getHibernateProperty(final String name) {
    return getProperty(getHibernateProperties(), name);
  }

  @Override
  public void removeHibernateProperty(final String name) {
    removeProperty(getHibernateProperties(), name);
  }

  @Override
  @ConfInfo(dontSave = true)
  public void setHibernateProperty(final String name,
                                   final String val) {
    setHibernateProperties(setListProperty(getHibernateProperties(),
                                           name, val));
  }

  @Override
  public void toStringSegment(final ToString ts) {
    super.toStringSegment(ts);

    ts.append("hibernateProperties", getHibernateProperties());
  }

  @Override
  public String toString() {
    final ToString ts = new ToString(this);

    toStringSegment(ts);

    return ts.toString();
  }
}
