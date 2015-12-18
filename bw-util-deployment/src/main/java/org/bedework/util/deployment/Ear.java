package org.bedework.util.deployment;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;
import java.util.jar.Attributes;
import java.util.jar.Manifest;

/** Represent a ear for deployment.
 *
 * @author douglm
 */
public class Ear extends VersionedFile {
  private final ApplicationXml appXml;

  final Map<String, War> wars = new HashMap<>();

  public Ear(final Utils utils,
             final String path,
             final SplitName sn,
             final PropertiesChain props) throws Throwable {
    super(utils, path, sn, props, "org.bedework.app." + sn.prefix + ".");

    final File earMeta = utils.subDirectory(theFile, "META-INF");

    if (Boolean.valueOf(props.get("org.bedework.for.wildfly"))) {
      final File jbossService = utils.file(earMeta, "jboss-service.xml");

      if (jbossService.exists()) {
        if (!jbossService.delete()) {
          utils.warn("Unable to delete " + jbossService);
        }
      }
    }

    final String dependencies = this.props.get("app.dependencies");

    if (dependencies != null) {
      final File manifest = new File(earMeta.getAbsolutePath(),
                                     "MANIFEST.MF");

      final Manifest mf;
      final Attributes mainAttrs;

      if (!manifest.exists()) {
        utils.warn("No MANIFEST.MF");
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

    appXml = new ApplicationXml(utils, earMeta);

    utils.info("Web modules");

    for (final String wm: appXml.getWebModulesNames()) {
      final SplitName wsn = SplitName.testName(wm);

      if (wsn == null) {
        utils.error("Bad ear name " + wm);
        return;
      }

      utils.info("   " + wm);

      final War war = new War(utils,
                              theFile.getAbsolutePath(),
                              wsn, appXml, this.props);

      wars.put(wsn.name, war);
    }
  }

  public void update() throws Throwable {
    utils.debug("Update ear: " + getSplitName());

    /* See if we have any wars to copy */
    copyWars();

    for (final War war: wars.values()) {
      war.update();
    }

    if (appXml.getUpdated()) {
      appXml.output();
    }

    /* Any jars to add */

    final String jarlib = this.props.get("app.jars");

    utils.debug("jarlib is " + jarlib);

    if (jarlib == null) {
      return;
    }

    final File lib = utils.subDirectory(theFile, "lib");
    final Path fromLib = Paths.get(jarlib);

    utils.copy(fromLib, Paths.get(lib.getAbsolutePath()), true);
  }

  public War findWar(final String prefix) {
    for (final War war: wars.values()) {
      if (prefix.equals(war.getSplitName().prefix)) {
        return war;
      }
    }
    return null;
  }

  private void copyWars() throws Throwable {
    for (final String pn: props.topNames()) {
      if (!pn.startsWith("app.copy.")) {
        continue;
      }

      final String toName = pn.substring("app.copy.".length());
      final War war = findWar(props.get(pn));

      if (war == null) {
        utils.error("No war to copy for " + pn + "=" + props.get(pn));
        continue;
      }

      copyWar(war, toName);
    }
  }

  private void copyWar(final War war,
                       final String toPrefix) throws Throwable {
    final String toName = toPrefix + "-" +
            war.getSplitName().version + ".war";
    final SplitName toSn = new SplitName(toName, toPrefix);

    utils.info("Copy war " + war.getSplitName().name + " to " + toName);

    toSn.version = war.getSplitName().version;
    toSn.suffix = "war";

    final File newWarDir = new File(theFile.getAbsolutePath(), toName);

    if (!newWarDir.mkdir()) {
      utils.error("Unable to create new war " + toName);
      return;
    }

    final Path inPath = Paths.get(war.theFile.getAbsolutePath());
    final Path outPath = Paths.get(newWarDir.getAbsolutePath());

    utils.copy(inPath, outPath, true);

    final War newWar = new War(utils,
                               theFile.getAbsolutePath(),
                               toSn, appXml, props);

    wars.put(toSn.name, newWar);

    appXml.addWebModule(toName);
  }
}
