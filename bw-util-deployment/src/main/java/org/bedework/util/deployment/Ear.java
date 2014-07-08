package org.bedework.util.deployment;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import static org.bedework.util.deployment.Utils.SplitName;

/** Represent a ear for deployment.
 *
 * @author douglm
 */
public class Ear {
  private final Properties earAppProps;

  final Map<String, War> wars = new HashMap<>();

  public Ear(final String path,
             final SplitName sn,
             final Properties props) throws Throwable {
    earAppProps = Utils.filter(props,
                               "org.bedework.app." + sn.prefix + ".",
                               "app.");

    final Path earPath = Paths.get(path, sn.name);
    final File ear = Utils.subDirectory(path, sn.name);

    final File earMeta = Utils.subDirectory(ear, "META-INF");

    final ApplicationXml appXml = new ApplicationXml(earMeta);

    Utils.info("Web modules");

    for (final String wm: appXml.getWebModulesNames()) {
      final SplitName wsn = SplitName.testName(wm);

      Utils.info("   " + wm);

      final War war = new War(earPath.toFile().getAbsolutePath(),
                              wsn, earAppProps);

      wars.put(wsn.name, war);
    }
  }

  public void update() throws Throwable {
    for (final War war: wars.values()) {
      war.update();
    }
  }
}
