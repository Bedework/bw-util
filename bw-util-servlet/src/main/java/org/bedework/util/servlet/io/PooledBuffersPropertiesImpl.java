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
import org.bedework.util.config.ConfigBase;
import org.bedework.util.misc.ToString;

/**
 * @author douglm
 *
 */
@ConfInfo(elementName = "pooled-buffer-properties",
          type = "org.bedework.calfacade.configs.PooledBufferProperties")
public class PooledBuffersPropertiesImpl
        extends ConfigBase<PooledBuffersPropertiesImpl>
        implements PooledBuffersProperties {
  private int smallBufferSize;
  private int mediumBufferSize;
  private int largeBufferSize;

  private int smallBufferPoolSize;
  private int mediumBufferPoolSize;
  private int largeBufferPoolSize;

  /* ========================================================================
   * Attributes
   * ======================================================================== */

  @Override
  public int getSmallBufferSize() {
    return smallBufferSize;
  }

  @Override
  public void setSmallBufferSize(final int val) {
    smallBufferSize = val;
  }

  @Override
  public int getMediumBufferSize() {
    return mediumBufferSize;
  }

  @Override
  public void setMediumBufferSize(final int val) {
    mediumBufferSize = val;
  }

  @Override
  public int getLargeBufferSize() {
    return largeBufferSize;
  }

  @Override
  public void setLargeBufferSize(final int val) {
    largeBufferSize = val;
  }

  @Override
  public int getSmallBufferPoolSize() {
    return smallBufferPoolSize;
  }

  @Override
  public void setSmallBufferPoolSize(final int val) {
    smallBufferPoolSize = val;
  }

  @Override
  public int getMediumBufferPoolSize() {
    return mediumBufferPoolSize;
  }

  @Override
  public void setMediumBufferPoolSize(final int val) {
    mediumBufferPoolSize = val;
  }

  @Override
  public int getLargeBufferPoolSize() {
    return largeBufferPoolSize;
  }

  @Override
  public void setLargeBufferPoolSize(final int val) {
    largeBufferPoolSize = val;
  }

  /* ====================================================================
   *                   Object methods
   * ==================================================================== */

  @Override
  public String toString() {
    ToString ts = new ToString(this);

    ts.append("smallBufferSize", getSmallBufferSize());
    ts.append("mediumBufferSize", getMediumBufferSize());
    ts.append("largeBufferSize", getLargeBufferSize());
    ts.append("smallBufferPoolSize", getSmallBufferPoolSize());
    ts.append("mediumBufferPoolSize", getMediumBufferPoolSize());
    ts.append("largeBufferPoolSize", getLargeBufferPoolSize());

    return ts.toString();
  }
}
