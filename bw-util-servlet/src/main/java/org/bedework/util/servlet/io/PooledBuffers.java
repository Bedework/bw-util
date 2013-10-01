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

import org.bedework.util.jmx.ConfBase;

import java.io.IOException;

/** See if we can't manage buffers better than the standard java classes - at
 * least for the specific use we have. We are generating a lot of output and
 * causing a lot of expansion and copying.
 *
 * <P>This may result in a lot of JVM churn. See if a pool of buffers can
 * improve matters.
 *
 * @author Mike Douglass
 */
public class PooledBuffers extends ConfBase<PooledBuffersPropertiesImpl>
        implements PooledBuffersMBean {
  /* Name of the property holding the location of the config data */
  public static final String confuriPname = "org.bedework.io.confuri";

  private static BufferPool smallBufferPool;
  private static BufferPool mediumBufferPool;
  private static BufferPool largeBufferPool;

  private static PooledBuffersProperties staticConf;

  private final static String nm = "pooledBuffers";

  /**
   * Creates a new pooled buffered output stream.
   */
  public PooledBuffers() {
    super(getServiceName(nm));

    setConfigName(nm);

    setConfigPname(confuriPname);

    loadConfig();

    smallBufferPool = new BufferPool(getConfig().getSmallBufferSize(),
                                     getConfig().getSmallBufferPoolSize());
    mediumBufferPool = new BufferPool(getConfig().getMediumBufferSize(),
                                      getConfig().getMediumBufferPoolSize());
    largeBufferPool = new BufferPool(getConfig().getLargeBufferSize(),
                                     getConfig().getLargeBufferPoolSize());
  }

  /**
   * @param name
   * @return object name value for the mbean with this name
   */
  public static String getServiceName(final String name) {
    return "org.bedework.io:service=" + name;
  }

  @Override
  public String loadConfig() {
    String res = loadConfig(PooledBuffersPropertiesImpl.class);
    staticConf = getConfig();

    return res;
  }

  /* ====================================================================
   *                   Package methods
   * ==================================================================== */

  /** Release a buffer back to the pool. MUST be called to gain the
   * benefit of pooling.
   *
   * @param buff - the buffer
   * @throws java.io.IOException
   */
  static void release(BufferPool.Buffer buff) throws IOException {
    if (buff.buf.length == staticConf.getSmallBufferSize()) {
      smallBufferPool.put(buff);
    } else if (buff.buf.length == staticConf.getMediumBufferSize()) {
      mediumBufferPool.put(buff);
    } else if (buff.buf.length == staticConf.getLargeBufferSize()) {
      largeBufferPool.put(buff);
    }
  }

  static BufferPool.Buffer getSmallBuffer() {
    return smallBufferPool.get();
  }

  static BufferPool.Buffer getMediumBuffer() {
    return mediumBufferPool.get();
  }

  static BufferPool.Buffer getLargeBuffer() {
    return largeBufferPool.get();
  }

  /* ====================================================================
   *                   MBean methods
   * ==================================================================== */

  @Override
  public int getSmallBufferSize() {
    return getConfig().getSmallBufferSize();
  }

  @Override
  public void setSmallBufferSize(final int val) {
    getConfig().setSmallBufferSize(val);
    smallBufferPool.setBufferSize(val);
  }

  @Override
  public int getMediumBufferSize() {
    return getConfig().getMediumBufferSize();
  }

  @Override
  public void setMediumBufferSize(final int val) {
    getConfig().setMediumBufferSize(val);
    mediumBufferPool.setBufferSize(val);
  }

  @Override
  public int getLargeBufferSize() {
    return getConfig().getLargeBufferSize();
  }

  @Override
  public void setLargeBufferSize(final int val) {
    getConfig().setLargeBufferSize(val);
    largeBufferPool.setBufferSize(val);
  }

  @Override
  public int getSmallBufferPoolSize() {
    return getConfig().getSmallBufferPoolSize();
  }

  @Override
  public void setSmallBufferPoolSize(final int val) {
    getConfig().setSmallBufferPoolSize(val);
    smallBufferPool.setPoolMaxSize(val);
  }

  @Override
  public int getMediumBufferPoolSize() {
    return getConfig().getMediumBufferPoolSize();
  }

  @Override
  public void setMediumBufferPoolSize(final int val) {
    getConfig().setMediumBufferPoolSize(val);
    mediumBufferPool.setPoolMaxSize(val);
  }

  @Override
  public int getLargeBufferPoolSize() {
    return getConfig().getLargeBufferPoolSize();
  }

  @Override
  public void setLargeBufferPoolSize(final int val) {
    getConfig().setLargeBufferPoolSize(val);
    largeBufferPool.setPoolMaxSize(val);
  }

  @Override
  public String getSmallBufferPoolStats() {
    return smallBufferPool.getStats();
  }

  @Override
  public String getMediumBufferPoolStats() {
    return mediumBufferPool.getStats();
  }

  @Override
  public String getLargeBufferPoolStats() {
    return largeBufferPool.getStats();
  }
}

