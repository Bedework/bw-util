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

/** Allow monitoring and manipulation of the pooled buffer settings..
 *
 * @author Mike Douglass
 */
public interface PooledBufferedOutputStreamMBean {
  /** Name apparently must be the same as the name attribute in the
   * jboss service definition
   *
   * @return Name
   */
  public String getName();

  /**
   * @return the size of each byte buffer
   */
  int getSmallBufferSize();

  /**
   * @param val the size of each byte buffer
   */
  void setSmallBufferSize(int val);

  /**
   * @return the size of each byte buffer
   */
  int getMediumBufferSize();

  /**
   * @param val the size of each byte buffer
   */
  void setMediumBufferSize(int val);

  /**
   * @return the size of each byte buffer
   */
  int getLargeBufferSize();

  /**
   * @param val the size of each byte buffer
   */
  void setLargeBufferSize(int val);

  /**
   * @return the max number of buffers
   */
  int getSmallBufferPoolSize();

  /**
   * @param val the max number of buffers
   */
  void setSmallBufferPoolSize(int val);

  /**
   * @return the max number of buffers
   */
  int getMediumBufferPoolSize();

  /**
   * @param val the max number of buffers
   */
  void setMediumBufferPoolSize(int val);

  /**
   * @return the max number of buffers
   */
  int getLargeBufferPoolSize();

  /**
   * @param val the max number of buffers
   */
  void setLargeBufferPoolSize(int val);

  /**
   * @return buffer usage stats
   */
  String getSmallBufferPoolStats();

  /**
   * @return buffer usage stats
   */
  String getMediumBufferPoolStats();

  /**
   * @return buffer usage stats
   */
  String getLargeBufferPoolStats();

  /** Lifecycle
   *
   */
  public void start();

  /** Lifecycle
   *
   */
  public void stop();

  /** Lifecycle
   *
   * @return true if started
   */
  public boolean isStarted();
}
