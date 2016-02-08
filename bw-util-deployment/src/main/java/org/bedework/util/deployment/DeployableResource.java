package org.bedework.util.deployment;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;

/** Represent a deployable resource with a possible "/lib",
 * META-INF etc.
 *
 * @author douglm
 */
public class DeployableResource extends VersionedFile {
  public DeployableResource(final Utils utils,
                            final String path,
                            final SplitName sn,
                            final PropertiesChain props,
                            final String propFilterVal) throws Throwable {
    super(utils, path, sn, props, propFilterVal);
  }

  public void updateLib(final boolean required) throws Throwable {
    /* Any jars to add */

    final String jarlib = this.props.get("app.jars");

    utils.debug("jarlib is " + jarlib);

    if (jarlib == null) {
      return;
    }

    final File lib = utils.subDirectory(theFile, "lib", required);
    final Path fromLib = Paths.get(jarlib);

    utils.copy(fromLib, Paths.get(lib.getAbsolutePath()), true);
  }
}
