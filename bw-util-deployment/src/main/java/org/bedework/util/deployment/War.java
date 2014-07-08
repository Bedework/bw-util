package org.bedework.util.deployment;

import java.io.File;
import java.util.List;
import java.util.Properties;

import static org.bedework.util.deployment.Utils.SplitName;

/** Represent a ear for deployment.
 *
 * @author douglm
 */
public class War {
  private final Properties appProps;

  final JbossWebXml jbwXml;

  public War(final String path,
             final SplitName sn,
             final Properties props) throws Throwable {
    appProps = Utils.filter(props,
                               "app." + sn.prefix + ".",
                               "app.");

    final File war = Utils.subDirectory(path, sn.name);

    final File webInf = Utils.subDirectory(war, "WEB-INF");

    jbwXml = new JbossWebXml(webInf);
  }

  public void update() throws Throwable {
    final List<String> vhosts = Utils.listProperty(appProps,
                                                   "app.virtual-hosts");

    if (vhosts != null) {
      for (final String vh: vhosts) {
        jbwXml.addVirtualHost(vh);
      }

      jbwXml.output();
    }
  }
}
