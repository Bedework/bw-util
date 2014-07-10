package org.bedework.util.deployment;

import java.io.File;
import java.util.HashMap;
import java.util.Map;

import static org.bedework.util.deployment.Utils.SplitName;

/** Represent a ear for deployment.
 *
 * @author douglm
 */
public class Ear extends VersionedFile {
  private final ApplicationXml appXml;

  final Map<String, War> wars = new HashMap<>();

  public Ear(final String path,
             final SplitName sn,
             final PropertiesChain props) throws Throwable {
    super(path, sn, props, "org.bedework.app." + sn.prefix + ".");

    final File earMeta = Utils.subDirectory(theFile, "META-INF");

    appXml = new ApplicationXml(earMeta);

    Utils.info("Web modules");

    for (final String wm: appXml.getWebModulesNames()) {
      final SplitName wsn = SplitName.testName(wm);

      Utils.info("   " + wm);

      final War war = new War(theFile.getAbsolutePath(),
                              wsn, appXml, this.props);

      wars.put(wsn.name, war);
    }
  }

  public void update() throws Throwable {
    for (final War war: wars.values()) {
      war.update();
    }

    if (appXml.getUpdated()) {
      appXml.output();
    }
  }
}
