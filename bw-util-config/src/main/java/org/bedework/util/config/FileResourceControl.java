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

import org.bedework.util.misc.Util;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Locale;
import java.util.PropertyResourceBundle;
import java.util.ResourceBundle;
import java.util.ResourceBundle.Control;

/** This allows us to load bundles from the configuration hierarchy.
 *
 * @author Mike Douglass
 *
 */
public class FileResourceControl extends Control {
  private final String dirPath;

  FileResourceControl(final String dirPath) throws ConfigException {
    try {
      final File f = new File(dirPath);

      if (!f.isDirectory()) {
        throw new ConfigException(dirPath + " is not a directory");
      }

      this.dirPath = f.getCanonicalPath() + File.separator;
    } catch (final ConfigException ce) {
      throw ce;
    } catch (final Throwable t) {
      throw new ConfigException(t);
    }
  }

  @Override
  public ResourceBundle newBundle(final String baseName,
                                  final Locale locale,
                                  final String format,
                                  final ClassLoader loader,
                                  final boolean reload)
          throws IllegalAccessException, InstantiationException, IOException {
    if (!format.equals("java.properties")) {
      throw new IllegalArgumentException("unknown format: " + format);
    }

    final String bundleName = toBundleName(baseName, locale);

    final String resourceName = toResourceName(bundleName, "properties");

    final ResourceBundle bundle;
    try (InputStream stream = new FileInputStream(Util.buildPath(false,
                                                                 dirPath,
                                                                 "/",
                                                                 resourceName))) {
      bundle = new PropertyResourceBundle(stream);
    }

    return bundle;
  }
}
