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

import java.util.List;

/** Used by configuration classes that want to save a set of hibernate properties.
 *
 * @author Mike Douglass
 */
public interface HibernateConfigI {
  /**
   *
   * @param val
   */
  void setHibernateProperties(final List<String> val);

  /**
   *
   * @return String val
   */
  @ConfInfo(collectionElementName = "hibernateProperty" ,
            elementType = "java.lang.String")
  List<String> getHibernateProperties();

  /**
   * @param val
   */
  void setHibernateDialect(final String val);

  /**
   * @return current setting for hibernate dialect
   */
  @ConfInfo(dontSave = true)
  String getHibernateDialect();

  /** Add a hibernate property
   *
   * @param name
   * @param val
   */
  void addHibernateProperty(final String name,
                            final String val);

  /** Get a hibernate property
   *
   * @param name
   * @return value or null
   */
  @ConfInfo(dontSave = true)
  String getHibernateProperty(final String name);

  /** Remove a hibernate property
   *
   * @param name
   */
  void removeHibernateProperty(final String name);

  /** Set a hibernate property
   *
   * @param name
   * @param val
   */
  @ConfInfo(dontSave = true)
  void setHibernateProperty(final String name,
                            final String val);
}
