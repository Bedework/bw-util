package org.bedework.util.deployment;

import java.io.File;

import static org.bedework.util.deployment.Utils.SplitName;

/** Represent a versioned file for deployment.
 *
 * @author douglm
 */
public class VersionedFile {
  protected final SplitName sn;
  protected final PropertiesChain props;

  protected final File theFile;

  public VersionedFile(final String path,
                       final SplitName sn,
                       final PropertiesChain props,
                       final String propFilterVal) throws Throwable {
    this.sn = sn;
    this.props = props.copy();
    this.props.pushFiltered(propFilterVal, "app.");

    theFile = Utils.subDirectory(path, sn.name);
  }

  public SplitName getSplitName() {
    return sn;
  }
}
