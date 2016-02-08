package org.bedework.util.deployment;

/** Represents a split name in a directory.
 *
 * @author douglm
 */
public class PathAndName {
  private final String path;
  private final SplitName splitName;

  public PathAndName(final String path,
                     final SplitName splitName) {
    this.path = path;
    this.splitName = splitName;
  }

  /** The directory path.
   */
  public String getPath() {
    return path;
  }

  public SplitName getSplitName() {
    return splitName;
  }
}
