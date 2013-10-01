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
package org.bedework.util.servlet.io;

import org.bedework.util.config.ConfInfo;
import org.bedework.util.jmx.MBeanInfo;

/** These are the properties that the pooled buffer module needs to know about.
 *
 * <p>Annotated to allow use by mbeans
 *
 * @author douglm
 *
 */
@ConfInfo(elementName = "pooled-buffers-properties")
public interface PooledBuffersProperties {
  /**
   * @param val the size of each byte buffer
   */
  void setSmallBufferSize(int val);

  /**
   * @return the size of each byte buffer
   */
  @MBeanInfo("Small buffer size")
  int getSmallBufferSize();

  /**
   * @param val the size of each byte buffer
   */
  void setMediumBufferSize(int val);

  /**
   * @return the size of each byte buffer
   */
  @MBeanInfo("Medium buffer size")
  int getMediumBufferSize();

  /**
   * @param val the size of each byte buffer
   */
  void setLargeBufferSize(int val);

  /**
   * @return the size of each byte buffer
   */
  @MBeanInfo("Large buffer size")
  int getLargeBufferSize();

  /**
   * @param val the max number of buffers
   */
  void setSmallBufferPoolSize(int val);

  /**
   * @return the max number of buffers
   */
  @MBeanInfo("Small buffer pool size")
  int getSmallBufferPoolSize();

  /**
   * @param val the max number of buffers
   */
  void setMediumBufferPoolSize(int val);

  /**
   * @return the max number of buffers
   */
  @MBeanInfo("Medium buffer pool size")
  int getMediumBufferPoolSize();

  /**
   * @param val the max number of buffers
   */
  void setLargeBufferPoolSize(int val);

  /**
   * @return the max number of buffers
   */
  @MBeanInfo("Large buffer pool size")
  int getLargeBufferPoolSize();
}
