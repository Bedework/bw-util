package org.bedework.util.deployment;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.jar.Attributes;
import java.util.jar.Manifest;

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

    utils.copy(fromLib, Paths.get(lib.getAbsolutePath()), true, null);
  }

  /** Do the dependencies on other ears, exclusions and dependencies on
   * modules.
   *
   */
  public void doDependecies(final File meta) throws Throwable {
    doEarDependencies(meta);
    doEarExclusions(meta);
    doModuleDependencies(meta);
  }

  public void doEarDependencies(final File meta) throws Throwable {
    if (utils.debug()) {
      utils.debug("before push");
      for (final String pname : props.topNames()) {
        utils.debug(pname);
      }
    }
    final String earDependencies = props.get("app.ear.dependencies");
    if (earDependencies != null) {
      // Generate a jboss-all.xml
      utils.debug("About to generate jboss-all in " + meta.getAbsolutePath());
      JbossAllXml.generate(meta);

      // Now update it
      final JbossAllXml jbossAll = new JbossAllXml(utils,
                                                   meta,
                                                   sn.version,
                                                   props);
      jbossAll.update();
      jbossAll.output();
    }
  }

  public void doEarExclusions(final File meta) throws Throwable {
    final String earExclusions = props.get("app.ear.exclusions");

    if (earExclusions == null) {
      return;
    }

    // Generate a jboss-deployment-structure.xml
    JbossDeploymentStructureXml.generate(meta);

    // Now update it
    final JbossDeploymentStructureXml jbossDsx =
            new JbossDeploymentStructureXml(utils,
                                            meta,
                                            props);
    jbossDsx.update();
    jbossDsx.output();
  }

  public void doModuleDependencies(final File meta) throws Throwable {
    final String dependencies = props.get("app.dependencies");

    if (dependencies == null) {
      return;
    }

    final File manifest = new File(meta.getAbsolutePath(),
                                   "MANIFEST.MF");

    final Manifest mf;
    final Attributes mainAttrs;

    if (!manifest.exists()) {
      //utils.warn("No MANIFEST.MF");
      mf = new Manifest();
      mainAttrs = mf.getMainAttributes();
      mainAttrs.putValue("Manifest-Version", "1.0");
    } else {
      mf = new Manifest(new FileInputStream(manifest));
      mainAttrs = mf.getMainAttributes();
    }

    final String dep = mainAttrs.getValue("Dependencies");

    if (dep != null) {
      mainAttrs.putValue("Dependencies", dep + "," + dependencies);
    } else {
      mainAttrs.putValue("Dependencies", dependencies);
    }

    final FileOutputStream fos = new FileOutputStream(manifest, false);
    mf.write(fos);
    fos.close();
  }
}
