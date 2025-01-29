package org.bedework.util.caching;

import org.bedework.util.logging.Logged;

import java.util.concurrent.ConcurrentLinkedQueue;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

/** Found at <a href="https://www.javacodegeeks.com/2013/08/simple-and-lightweight-pool-implementation.html">Simple and lightweight pool implementation</a>
 *<p>
 * Written by Oleg Varaksin
 *
 * @param <T>
 */
public abstract class NoSynchObjectPool<T> implements Logged {
  private ConcurrentLinkedQueue<T> pool;

  private ScheduledExecutorService executorService;

  /**
   * Creates the pool.
   *
   * @param minIdle minimum number of objects residing in the pool
   */
  public NoSynchObjectPool(final int minIdle) {
    // initialize pool
    initialize(minIdle);
  }

  /**
   * Creates the pool.
   *
   * @param minIdle            minimum number of objects residing in the pool
   * @param maxIdle            maximum number of objects residing in the pool
   * @param validationInterval time in seconds for periodical checking of minIdle / maxIdle conditions in a separate thread.
   *                           When the number of objects is less than minIdle, missing instances will be created.
   *                           When the number of objects is greater than maxIdle, too many instances will be removed.
   */
  public NoSynchObjectPool(final int minIdle,
                           final int maxIdle,
                           final long validationInterval) {
    // initialize pool
    initialize(minIdle);

    // check pool conditions in a separate thread
    executorService = Executors.newSingleThreadScheduledExecutor();
    executorService.scheduleWithFixedDelay(() -> {
      final int size = pool.size();
      if (size < minIdle) {
        final int sizeToBeAdded = minIdle - size;
        for (int i = 0; i < sizeToBeAdded; i++) {
          pool.add(createObject());
        }
      } else if (size > maxIdle) {
        final int sizeToBeRemoved = size - maxIdle;
        for (int i = 0; i < sizeToBeRemoved; i++) {
          pool.poll();
        }
      }
    }, validationInterval, validationInterval, TimeUnit.SECONDS);
  }

  /**
   * Gets the next free object from the pool. If the pool doesn't contain any objects,
   * a new object will be created and given to the caller of this method back.
   *
   * @return T borrowed object
   */
  public T borrowObject() {
    T object;
    if ((object = pool.poll()) == null) {
      object = createObject();
    }

    return object;
  }

  /**
   * Returns object back to the pool.
   *
   * @param object object to be returned
   */
  public void returnObject(final T object) {
    if (object == null) {
      return;
    }

    this.pool.offer(object);
  }

  /**
   * Shutdown this pool.
   */
  public void shutdown() {
    if (executorService != null) {
      executorService.shutdown();
    }
  }

  /**
   * Creates a new object.
   *
   * @return T new object
   */
  protected abstract T createObject();

  private void initialize(final int minIdle) {
    pool = new ConcurrentLinkedQueue<>();

    for (int i = 0; i < minIdle; i++) {
      pool.add(createObject());
    }
  }
}