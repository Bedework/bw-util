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
package org.bedework.util.config.http;

import org.bedework.util.config.ConfigBase;
import org.bedework.util.config.ConfigException;
import org.bedework.util.config.ConfigurationStore;
import org.bedework.util.dav.DavUtil;
import org.bedework.util.dav.DavUtil.DavChild;
import org.bedework.util.http.BasicHttpClient;

import java.io.InputStream;
import java.io.StringWriter;
import java.net.URI;
import java.net.URL;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.ResourceBundle;

/** A configuration DAV store interacts with a DAV server to access
 * configurations. The remote end must support enough DAV to allow GET/PUT of
 * configurations and PROPFIND to discover child entities.
 *
 * @author Mike Douglass douglm
 */
public class ConfigurationDavStore implements ConfigurationStore {
  private String url;
  private BasicHttpClient client;
  private DavUtil du = new DavUtil();

  private String path;

  /**
   * @param url
   * @throws ConfigException
   */
  public ConfigurationDavStore(final String url) throws ConfigException {
    try {
      this.url = url;

      if (!url.endsWith("/")) {
        this.url += "/";
      }

      URL u = new URL(url);

      client = new BasicHttpClient(u.getHost(), u.getPort(), u.getProtocol(),
                                   30 * 1000);

      path = u.getPath();
    } catch (Throwable t) {
      throw new ConfigException(t);
    }
  }

  @Override
  public boolean readOnly() {
    return false;
  }

  @Override
  public String getLocation() throws ConfigException {
    return url;
  }

  @Override
  public void saveConfiguration(final ConfigBase config) throws ConfigException {
    try {
      StringWriter sw = new StringWriter();

      config.toXml(sw);

      client.putObject(path + config.getName() + ".xml",
                       sw.toString(),
                       "application/xml");
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
    InputStream is = null;

    try {
      is = client.get(path + "/" + name + ".xml");

      ConfigBase config = new ConfigBase().fromXml(is, cl);

      return config;
    } catch (ConfigException ce) {
      throw ce;
    } catch (Throwable t) {
      throw new ConfigException(t);
    } finally {
      if (is != null) {
        try {
          is.close();
        } catch (Throwable t) {}
      }
    }
  }

  @Override
  public List<String> getConfigs() throws ConfigException {
    try {
      Collection<DavChild> dcs = du.getChildrenUrls(client, path, null);
      List<String> names = new ArrayList<String>();

      URI parentUri = new URI(url);
      for (DavChild dc: dcs) {
        if (dc.isCollection) {
          continue;
        }

        String child = parentUri.relativize(new URI(dc.uri)).getPath();

        if (!child.endsWith(".xml")){
          continue;
        }

        names.add(child.substring(0, child.indexOf(".xml")));
      }

      return names;
    } catch (Throwable t) {
      throw new ConfigException(t);
    }
  }

  @Override
  public ConfigurationStore getStore(final String name) throws ConfigException {
    try {
      String newPath = path + name;
      if (!newPath.endsWith("/")) {
        newPath += "/";
      }

      DavChild dc = du.getProps(client, newPath, null);

      if (dc == null) {
        throw new ConfigException("mkcol not implemented");
      }

      URI parentUri = new URI(url);
      return new ConfigurationDavStore(parentUri.relativize(new URI(dc.uri)).toASCIIString());
    } catch (Throwable t) {
      throw new ConfigException(t);
    }
  }

  @Override
  public ResourceBundle getResource(final String name,
                                    final String locale)
          throws ConfigException {
    return null;
  }
}
