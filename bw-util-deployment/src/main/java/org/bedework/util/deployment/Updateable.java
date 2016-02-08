package org.bedework.util.deployment;

/** Represents a file or module that can be updated.
 *
 * @author douglm
 */
public interface Updateable {
  /** Upate this component according to properties.
   *
   * @throws Throwable if an error occurs.
   */
  void update() throws Throwable;
}
