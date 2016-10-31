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
import java.io.FileFilter;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.ResourceBundle;
import java.util.ResourceBundle.Control;

/** A configuration file store holds configurations in files within a directory.
 *
 * @author Mike Douglass douglm
 */
public class ConfigurationFileStore implements ConfigurationStore {
  private String dirPath;

  private Control resourceControl;

  /**
   * @param dirPath location of config
   * @throws ConfigException on error
   */
  public ConfigurationFileStore(final String dirPath) throws ConfigException {
    try {
      this.dirPath = dirPath;

      final File f = new File(dirPath);

      if (!f.exists()) {
        if (!f.mkdir()) {
          throw new ConfigException("Unable to create directory " + dirPath);
        }
      }

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
  public boolean readOnly() {
    return false;
  }

  @Override
  public String getLocation() throws ConfigException {
    return dirPath;
  }

  @Override
  public void saveConfiguration(final ConfigBase config) throws ConfigException {
    try {
      File f = new File(dirPath + config.getName() + ".xml");

      FileWriter fw = new FileWriter(f);

      config.toXml(fw);

      fw.close();
    } catch (ConfigException ce) {
      throw ce;
    } catch (Throwable t) {
      throw new ConfigException(t);
    }
  }

  @Override
  public ConfigBase getConfig(final String name) throws ConfigException {
    return getConfig(name, null);
  }

  @Override
  public ConfigBase getConfig(final String name,
                              final Class cl) throws ConfigException {
    FileInputStream fis = null;

    try {
      File f = new File(dirPath + name + ".xml");

      if (!f.exists()) {
        return null;
      }

      fis = new FileInputStream(f);

      ConfigBase config = ConfigBase.fromXml(fis, cl);

      return config;
    } catch (ConfigException ce) {
      throw ce;
    } catch (Throwable t) {
      throw new ConfigException(t);
    } finally {
      if (fis != null) {
        try {
          fis.close();
        } catch (Throwable t) {}
      }
    }
  }

  private static class FilesOnly implements FileFilter {
    @Override
    public boolean accept(final File pathname) {
      if (!pathname.isFile()) {
        return false;
      }

      return pathname.getName().endsWith(".xml");
    }
  }

  @Override
  public List<String> getConfigs() throws ConfigException {
    try {
      File dir = new File(dirPath);

      File[] files = dir.listFiles(new FilesOnly());

      List<String> names = new ArrayList<String>();

      for (File f: files) {
        String nm = f.getName();
        names.add(nm.substring(0, nm.indexOf(".xml")));
      }

      return names;
    } catch (Throwable t) {
      throw new ConfigException(t);
    }
  }

  private static class DirsOnly implements FileFilter {
    @Override
    public boolean accept(final File pathname) {
      return pathname.isDirectory();
    }
  }

  /** Get the named store. Create it if it does not exist
   *
   * @param name of config
   * @return store
   * @throws ConfigException
   */
  @Override
  public ConfigurationStore getStore(final String name) throws ConfigException {
    try {
      final File dir = new File(dirPath);
      final String newPath = dirPath + name;

      final File[] files = dir.listFiles(new DirsOnly());

      for (final File f: files) {
        if (f.getName().equals(name)) {
          return new ConfigurationFileStore(newPath);
        }
      }

      final File newDir = new File(newPath);
      if (!newDir.mkdir()) {
        throw new ConfigException("Unable to create directory " + newPath);
      }

      return new ConfigurationFileStore(newPath);
    } catch (final Throwable t) {
      throw new ConfigException(t);
    }
  }

  @Override
  public ResourceBundle getResource(final String name,
                                    final String locale) throws ConfigException {
    try {
      if (resourceControl == null) {
        resourceControl = new FileResourceControl(dirPath);
      }

      final Locale loc;

      if (locale == null) {
        loc = Locale.getDefault();
      } else {
        loc = Util.makeLocale(locale);
      }

      return ResourceBundle.getBundle(name, loc, resourceControl);
    } catch (final ConfigException ce) {
      throw ce;
    } catch (final Throwable t) {
      throw new ConfigException(t);
    }
  }
}
