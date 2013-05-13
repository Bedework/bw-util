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

import java.util.List;

/** A configuration store holds configurations, each identified by a unique name,
 *
 * <p>In addition it may contain sub-stores.
 *
 * <p>Not surprisingly this looks like a file system with one file per config
 * and directories representing the stores.
 *
 * <p>A store may be read-only or read-write. If read-write it may require
 * credentials.
 *
 * @author Mike Douglass douglm
 */
public interface ConfigurationStore {
  /**
   * @return true for a read-only store.
   */
  boolean readOnly();

  /**
   * @return path for this store
   * @throws ConfigException
   */
  String getLocation() throws ConfigException;

  /**
   * @param config
   * @throws ConfigException
   */
  void saveConfiguration(ConfigBase config) throws ConfigException;

  /** Stored config must indicate class of object as an attribute
   *
   * @param name
   * @return config or null
   * @throws ConfigException
   */
  ConfigBase getConfig(String name) throws ConfigException;

  /**
   * @param name
   * @param cl - class of config object
   * @return config or null
   * @throws ConfigException
   */
  ConfigBase getConfig(String name,
                       Class cl) throws ConfigException;

  /** List the configurations in the store
   *
   * @return list of configurations
   * @throws ConfigException
   */
  List<String> getConfigs() throws ConfigException;

  /** Get the named child store. Create it if it does not exist
   *
   * @param name
   * @return store
   * @throws ConfigException
   */
  ConfigurationStore getStore(String name) throws ConfigException;
}
