/* ********************************************************************
    Appropriate copyright notice
*/
package org.bedework.util.config;

/** A holder for a defaulted value
 *
 * User: mike Date: 12/26/18 Time: 16:06
 */
public class Defaulted<T> {
  private final T defVal;
  private T value;

  public Defaulted(final T defVal) {
    this.defVal = defVal;
  }

  public void set(final T val) {
    value = val;
  }

  public T get() {
    if (value != null) {
      return value;
    }

    return defVal;
  }
}

