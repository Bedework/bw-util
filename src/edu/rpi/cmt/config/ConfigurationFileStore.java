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

import java.io.File;
import java.io.FileFilter;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.util.ArrayList;
import java.util.List;

/** A configuration file store holds configurations in files within a given
 * directory.
 *
 * @author Mike Douglass douglm
 */
public class ConfigurationFileStore implements ConfigurationStore {
  private String dirPath;

  /**
   * @param dirPath
   * @throws ConfigException
   */
  public ConfigurationFileStore(final String dirPath) throws ConfigException {
    try {
      this.dirPath = dirPath;

      File f = new File(dirPath);

      if (!f.exists()) {
        if (!f.mkdir()) {
          throw new ConfigException("Unable to create directory " + dirPath);
        }
      }

      if (!f.isDirectory()) {
        throw new ConfigException(dirPath + " is not a directory");
      }

      this.dirPath = f.getCanonicalPath() + File.separator;
    } catch (ConfigException ce) {
      throw ce;
    } catch (Throwable t) {
      throw new ConfigException(t);
    }
  }

  @Override
  public String getPath() throws ConfigException {
    return dirPath;
  }

  @Override
  public void saveConfiguration(final ConfigurationType config) throws ConfigException {
    try {
      String xmlStr = config.toXml();

      File f = new File(dirPath + config.getName());

      FileWriter fw = new FileWriter(f);

      fw.write(xmlStr);

      fw.close();
    } catch (ConfigException ce) {
      throw ce;
    } catch (Throwable t) {
      throw new ConfigException(t);
    }
  }

  @Override
  public ConfigurationType getConfig(final String name) throws ConfigException {
    FileInputStream fis = null;

    try {
      File f = new File(dirPath + name);

      if (!f.exists()) {
        return null;
      }

      fis = new FileInputStream(f);

      ConfigurationType config = ConfigurationType.fromXml(fis);

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
      return pathname.isFile();
    }
  }

  @Override
  public List<String> getConfigs() throws ConfigException {
    try {
      File dir = new File(dirPath);

      File[] files = dir.listFiles(new FilesOnly());

      List<String> names = new ArrayList<String>();

      for (File f: files) {
        names.add(f.getName());
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
   * @param name
   * @return store
   * @throws ConfigException
   */
  @Override
  public ConfigurationStore getStore(final String name) throws ConfigException {
    try {
      File dir = new File(dirPath);
      String newPath = dirPath + name;

      File[] files = dir.listFiles(new DirsOnly());

      for (File f: files) {
        if (f.getName().equals(name)) {
          return new ConfigurationFileStore(newPath);
        }
      }

      File newDir = new File(newPath);
      if (!newDir.mkdir()) {
        throw new ConfigException("Unable to create directory " + newPath);
      }

      return new ConfigurationFileStore(newPath);
    } catch (Throwable t) {
      throw new ConfigException(t);
    }
  }
}
