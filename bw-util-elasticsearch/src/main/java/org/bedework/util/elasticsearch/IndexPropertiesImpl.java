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

import org.bedework.util.config.ConfInfo;
import org.bedework.util.config.ConfigBase;
import org.bedework.util.misc.ToString;

/** These are the system properties that the server needs to know about, either
 * because it needs to apply these limits or just to report them to clients.
 *
 * @author douglm
 *
 */
@ConfInfo(elementName = "index-properties",
          type = "org.bedework.util.elasticsearch.IndexProperties")
public class IndexPropertiesImpl
        extends ConfigBase<IndexPropertiesImpl>
        implements IndexProperties {
  private String indexerURL;

  private boolean embeddedIndexer;

  private boolean httpEnabled;

  private String clusterName;

  private String nodeName;

  private String dataDir;

  @Override
  public void setIndexerURL(final String val) {
    indexerURL = val;
  }

  @Override
  public String getIndexerURL() {
    return indexerURL;
  }

  @Override
  public void setEmbeddedIndexer(final boolean val) {
    embeddedIndexer = val;
  }

  @Override
  public boolean getEmbeddedIndexer() {
    return embeddedIndexer;
  }

  @Override
  public void setHttpEnabled(final boolean val) {
    httpEnabled = val;
  }

  @Override
  public boolean getHttpEnabled() {
    return httpEnabled;
  }

  @Override
  public void setClusterName(final String val) {
    clusterName = val;
  }

  @Override
  public String getClusterName() {
    return clusterName;
  }

  @Override
  public void setNodeName(final String val) {
    nodeName = val;
  }

  @Override
  public String getNodeName() {
    return nodeName;
  }

  @Override
  public void setDataDir(final String val) {
    dataDir = val;
  }

  @Override
  public String getDataDir() {
    return dataDir;
  }

  /* ====================================================================
   *                   Object methods
   * ==================================================================== */

  @Override
  public String toString() {
    final ToString ts = new ToString(this);

    ts.append("indexerURL", getIndexerURL());
    ts.append("embeddedIndexer", getEmbeddedIndexer());
    ts.append("httpEnabled", getHttpEnabled());
    ts.append("clusterName", getClusterName());
    ts.append("nodeName", getNodeName());
    ts.append("dataDir", getDataDir());

    return ts.toString();
  }
}
