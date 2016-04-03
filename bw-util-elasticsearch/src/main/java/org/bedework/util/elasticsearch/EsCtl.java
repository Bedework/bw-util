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
package org.bedework.util.elasticsearch;

import org.bedework.util.jmx.ConfBase;
import org.bedework.util.misc.Util;

import java.util.List;
import java.util.Set;

/**
 * @author douglm
 *
 */
public class EsCtl extends ConfBase<IndexPropertiesImpl>
        implements EsCtlMBean {
  /* Name of the property holding the location of the config data */
  public static final String confuriPname = "org.bedework.esctl.confuri";

  public void runInit() {
    /* List the indexes in use - ensures we have an indexer early on */

    info(" * Current indexes: ");
    Set<IndexInfo> is = null;

    try {
      is = getEsUtil().getIndexInfo();
    } catch (Throwable t) {
      info(" * Exception getting index info:");
      info(" * " + t.getLocalizedMessage());
    }

    info(listIndexes(is));
  }

  private final static String nm = "esctl";

  private EsUtil esUtil;

  /**
   */
  public EsCtl() {
    super(getServiceName(nm));

    setConfigName(nm);

    setConfigPname(confuriPname);
  }

  /**
   * @param name of service
   * @return object name value for the mbean with this name
   */
  public static String getServiceName(final String name) {
    return EsCtlMBean.serviceName;
  }

  @Override
  public void setIndexerURL(final String val) {
    getConfig().setIndexerURL(val);
  }

  @Override
  public String getIndexerURL() {
    return getConfig().getIndexerURL();
  }

  @Override
  public void setEmbeddedIndexer(final boolean val) {
    getConfig().setEmbeddedIndexer(val);
  }

  @Override
  public boolean getEmbeddedIndexer() {
    return getConfig().getEmbeddedIndexer();
  }

  @Override
  public void setHttpEnabled(final boolean val) {
    getConfig().setHttpEnabled(val);
  }

  @Override
  public boolean getHttpEnabled() {
    return getConfig().getHttpEnabled();
  }

  @Override
  public void setClusterName(final String val) {
    getConfig().setClusterName(val);
  }

  @Override
  public String getClusterName() {
    return getConfig().getClusterName();
  }

  @Override
  public void setNodeName(final String val) {
    getConfig().setNodeName(val);
  }

  @Override
  public String getNodeName() {
    return getConfig().getNodeName();
  }

  @Override
  public void setDataDir(final String val) {
    getConfig().setDataDir(val);
  }

  @Override
  public String getDataDir() {
    return getConfig().getDataDir();
  }

  @Override
  public String listIndexes() {
    try {
      return listIndexes(getEsUtil().getIndexInfo());
    } catch (Throwable t) {
      return t.getLocalizedMessage();
    }
  }

  /* ========================================================================
   * Operations
   * ======================================================================== */

  @Override
  public synchronized void start() {
    runInit();
  }

  @Override
  public synchronized void stop() {
  }

  @Override
  public String loadConfig() {
    return loadConfig(IndexPropertiesImpl.class);
  }

  /* ========================================================================
   * Private methods
   * ======================================================================== */

  private String listIndexes(Set<IndexInfo> is) {
    if (Util.isEmpty(is)) {
      return "No indexes found";
    }

    StringBuilder res = new StringBuilder("Indexes");

    res.append("------------------------\n");

    for (IndexInfo ii: is) {
      res.append(ii.getIndexName());

      if (!Util.isEmpty(ii.getAliases())) {
        String delim = "<----";

        for (String a: ii.getAliases()) {
          res.append(delim);
          res.append(a);
          delim = ", ";
        }
      }

      res.append("\n");
    }

    return res.toString();
  }

  private void outLine(final List<String> res,
                       final String msg) {
    res.add(msg + "\n");
  }

  private EsUtil getEsUtil() {
    if (esUtil != null) {
      return esUtil;
    }

    esUtil = new EsUtil(getConfig());

    return esUtil;
  }
}
