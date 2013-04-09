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

import java.io.InputStream;
import java.net.URI;
import java.net.URL;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import edu.rpi.sss.util.DavUtil;
import edu.rpi.sss.util.DavUtil.DavChild;
import edu.rpi.sss.util.http.BasicHttpClient;

/** A configuration DAV store interacts with a DAV server to access
 * configurations. The remote end must support enough DAV to allow GET/PUT of
 * configurations and PROPFIND to discover child entities.
 *
 * @author Mike Douglass douglm
 */
public class ConfigurationDavStore implements ConfigurationStore {
  private String url;
  private BasicHttpClient cl;
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

      cl = new BasicHttpClient(u.getHost(), u.getPort(), u.getProtocol(),
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
  public void saveConfiguration(final ConfigurationType config) throws ConfigException {
    try {
      cl.putObject(path + config.getName() + ".xml",
                   config.toXml(),
                   "application/xml");
    } catch (ConfigException ce) {
      throw ce;
    } catch (Throwable t) {
      throw new ConfigException(t);
    }
  }

  @Override
  public ConfigurationType getConfig(final String name) throws ConfigException {
    InputStream is = null;

    try {
      is = cl.get(path + "/" + name + ".xml");

      ConfigurationType config = ConfigurationType.fromXml(is);

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
      Collection<DavChild> dcs = du.getChildrenUrls(cl, path, null);
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

      DavChild dc = du.getProps(cl, newPath, null);

      if (dc == null) {
        throw new ConfigException("mkcol not implemented");
      }

      URI parentUri = new URI(url);
      return new ConfigurationDavStore(parentUri.relativize(new URI(dc.uri)).toASCIIString());
    } catch (Throwable t) {
      throw new ConfigException(t);
    }
  }
}
