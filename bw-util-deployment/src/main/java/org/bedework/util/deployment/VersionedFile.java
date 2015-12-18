package org.bedework.util.deployment;

import java.io.File;

/** Represent a versioned file for deployment.
 *
 * @author douglm
 */
public class VersionedFile extends BaseClass {
  protected final SplitName sn;
  protected final PropertiesChain props;

  protected final File theFile;

  public VersionedFile(final Utils utils,
                       final String path,
                       final SplitName sn,
                       final PropertiesChain props,
                       final String propFilterVal) throws Throwable {
    super(utils);
    this.sn = sn;
    this.props = props.copy();
    this.props.pushFiltered(propFilterVal, "app.");

    theFile = utils.subDirectory(path, sn.name);
  }

  public SplitName getSplitName() {
    return sn;
  }
}
