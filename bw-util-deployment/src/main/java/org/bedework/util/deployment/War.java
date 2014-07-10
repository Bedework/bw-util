package org.bedework.util.deployment;

import java.io.File;

import static org.bedework.util.deployment.Utils.SplitName;

/** Represent a ear for deployment.
 *
 * @author douglm
 */
public class War extends VersionedFile {
  private final ApplicationXml appXml;

  private final JbossWebXml jbwXml;

  private final WebXml wXml;

  public War(final String path,
             final SplitName sn,
             final ApplicationXml appXml,
             final PropertiesChain props) throws Throwable {
    super(path, sn, props, "app." + sn.prefix + ".");
    this.appXml = appXml;

    final File webInf = Utils.subDirectory(theFile, "WEB-INF");

    jbwXml = new JbossWebXml(webInf, this.props);
    wXml = new WebXml(webInf, this.props);
  }

  public void update() throws Throwable {
    appXml.setContext(sn.name, props);

    jbwXml.update();

    if (jbwXml.getUpdated()) {
      jbwXml.output();
    }

    wXml.update();

    if (wXml.getUpdated()) {
      wXml.output();
    }
  }
}
