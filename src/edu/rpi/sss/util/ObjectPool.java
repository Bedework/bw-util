/* **********************************************************************
    Copyright 2006 Rensselaer Polytechnic Institute. All worldwide rights reserved.

    Redistribution and use of this distribution in source and binary forms,
    with or without modification, are permitted provided that:
       The above copyright notice and this permission notice appear in all
        copies and supporting documentation;

        The name, identifiers, and trademarks of Rensselaer Polytechnic
        Institute are not used in advertising or publicity without the
        express prior written permission of Rensselaer Polytechnic Institute;

    DISCLAIMER: The software is distributed" AS IS" without any express or
    implied warranty, including but not limited to, any implied warranties
    of merchantability or fitness for a particular purpose or any warrant)'
    of non-infringement of any current or pending patent rights. The authors
    of the software make no representations about the suitability of this
    software for any particular purpose. The entire risk as to the quality
    and performance of the software is with the user. Should the software
    prove defective, the user assumes the cost of all necessary servicing,
    repair or correction. In particular, neither Rensselaer Polytechnic
    Institute, nor the authors of the software are liable for any indirect,
    special, consequential, or incidental damages related to the software,
    to the maximum extent the law permits.
*/

package edu.rpi.sss.util;

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
  private WeakHashMap<T, SoftReference<T>> pool =
    new WeakHashMap<T, SoftReference<T>>();

  private static long refs;
  private static long hits;

  private transient Logger log;
  private boolean debug = false;

  /**
   * @param val
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
