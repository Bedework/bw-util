/* **********************************************************
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
package org.bedework.util.properties;

import org.bedework.base.exc.BedeworkException;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import static java.lang.String.format;

/**
 * @author mike douglass
 */
public class PlaceHolderProperties extends Properties {
  public static final String defaultSuperPropertyName = "super";

  private String superPropertyName = defaultSuperPropertyName;

  private PropertiesPropertyFetcher pfetcher;

  /**
   * Creates an empty PlaceHolderProperties instance.
   */
  public PlaceHolderProperties() {
    super();
  }

  /**
   * Creates a PlaceHolderProperties instance loaded with the given
   * properties.
   */
  public PlaceHolderProperties(final Properties defaults) {
    super(defaults);
  }

  /** Will recursively load all parent property files.
   * These are loaded in reverse order so that the highest parent is
   * loaded first and the children override the parent.
   * <p>
   *   Parents are defined by the property with a name given by the
   *   current value of the superPropertyName field.
   * The chain terminates when the property is empty or unchanged
   *
   * @param path to child
   * @return PlaceHolderProperties
   */
  public static PlaceHolderProperties loadWithSuperProperties(
      final String path) {
    return loadWithSuperProperties(loadPropertyFile(path));
  }

  /** Will recursively load all parents
   *
   * @param props child properties file
   * @return parent properties overridden by the child.
   */
  public static PlaceHolderProperties loadWithSuperProperties(
      final PlaceHolderProperties props) {
    final var superPath = props.getProperty("super");
    if ((superPath == null) || superPath.isEmpty()) {
      return props;
    }

    final var parent = loadPropertyFile(superPath);
    final var newSuperPath = parent.getProperty("super");

    log(format("superPath: %s newSuperPath: %s",
               superPath, newSuperPath));
    parent.putAll(props);

    if ((newSuperPath == null) || newSuperPath.isEmpty()
        || newSuperPath.equals(superPath)) {
      return parent;
    }

    parent.setProperty("super", newSuperPath);

    return loadWithSuperProperties(parent);
  }

  public static PlaceHolderProperties loadPropertyFile(
      final String path) {
    final var props = new PlaceHolderProperties();

    try (final InputStream stream = new FileInputStream(path)) {
      props.load(stream);
    } catch (final IOException e) {
      throw new BedeworkException(e);
    }

    return props;
  }

  public void setSuperPropertyName(final String val) {
    superPropertyName = val;
  }

  public String getProperty(final String propName) {
    return PropertyUtil.propertyReplace(
        super.getProperty(propName),
        getPropertyFetcher());
  }

  public void setPropertyFetcher(final PropertiesPropertyFetcher val) {
    pfetcher = val;
  }

  private PropertyFetcher getPropertyFetcher() {
    if (pfetcher == null) {
      pfetcher = new PropertiesPropertyFetcher(this);
    }
    return pfetcher;
  }

  private static void log(final String msg) {
    System.out.println(PlaceHolderProperties.class.getName() + ": " + msg);
  }
}
