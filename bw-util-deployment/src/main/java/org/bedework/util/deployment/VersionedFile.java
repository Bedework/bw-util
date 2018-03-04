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

    /*
    if (utils.debug()) {
      utils.debug("before push");
      for (final String pname : props.topNames()) {
        utils.debug(pname);
      }
    }*/
    this.props.pushFiltered(propFilterVal, "app.");
    if (utils.debug()) {
      utils.debug("after push with filter " + propFilterVal);
      for (final String pname : this.props.topNames()) {
        utils.debug(pname);
      }
    }

    theFile = utils.subDirectory(path, sn.name);
  }

  public SplitName getSplitName() {
    return sn;
  }
}
