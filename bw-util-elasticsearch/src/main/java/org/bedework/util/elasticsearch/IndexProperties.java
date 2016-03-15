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
import org.bedework.util.jmx.MBeanInfo;

/** These are the properties that the indexer needs to know about.
 *
 * <p>Annotated to allow use by mbeans
 *
 * @author douglm
 *
 */
@ConfInfo(elementName = "index-properties")
public interface IndexProperties {
  /**
   *
   * @param val the indexer url
   */
  void setIndexerURL(String val);

  /** Get the indexer url
   *
   * @return url of server
   */
  @MBeanInfo("Non-embedded indexer url")
  String getIndexerURL();

  /**
   *
   * @param val true if we run an embedded indexer
   */
  void setEmbeddedIndexer(boolean val);

  /** Do we run an embedded indexer?
   *
   * @return flag
   */
  @MBeanInfo("Do we run an embedded indexer?")
  boolean getEmbeddedIndexer();

  /** 
   *
   * @param val true if we run indexer with http enabled
   */
  void setHttpEnabled(boolean val);

  /** Do we run indexer with http enabled?
   *
   * @return flag
   */
  @MBeanInfo("Do we run indexer with http enabled?")
  boolean getHttpEnabled();

  /**
   *
   * @param val the cluster name
   */
  void setClusterName(String val);

  /** Get the cluster name
   *
   * @return name
   */
  @MBeanInfo("cluster name")
  String getClusterName();

  /** 
   *
   * @param val the node name
   */
  void setNodeName(String val);

  /** Get the node name
   *
   * @return name
   */
  @MBeanInfo("node name")
  String getNodeName();

  /** 
   *
   * @param val  the data directory for embedded
   */
  void setDataDir(String val);

  /** Get the data directory for embedded
   *
   * @return name
   */
  @MBeanInfo("data directory for embedded")
  String getDataDir();
}
