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
package org.bedework.util.caching;

import org.apache.log4j.Logger;

import java.io.Serializable;
import java.lang.ref.SoftReference;
import java.util.WeakHashMap;

/** Implement a pool of objects whose values appear frequently enough that pooling
 * will result in a substantial reduction in space and or cpu.
 *
 * <p>Objects pooled must be either immutable or sharable because they will be
 * shared.
 *
 * @author Mike Douglass
 *
 * @param <T>
 */
public class ObjectPool<T> implements Serializable {
  private final WeakHashMap<T, SoftReference<T>> pool =
    new WeakHashMap<>();

  private static long refs;
  private static long hits;

  private transient Logger log;
  private boolean debug = false;

  /**
   * @param val key
   * @return value in pool
   */
  public T get(T val) {
    if (debug &&
        ((refs % 500) == 0)) {
      getLogger().debug("pool refs " + refs + ": hits " + hits);
    }
    refs++;
    SoftReference<T> poolVal = pool.get(val);

    if (poolVal != null) {
      T tval = poolVal.get();
      if (tval != null) {
        hits++;
        return tval;
      }
    }

    synchronized (pool) {
      pool.put(val, new SoftReference<T>(val));
      return val;
    }
  }

  private Logger getLogger() {
    if (log == null) {
      log = Logger.getLogger(this.getClass());
    }

    return log;
  }
}
