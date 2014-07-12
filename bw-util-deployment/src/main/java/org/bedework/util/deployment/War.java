package org.bedework.util.deployment;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;

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

  private void copyResources() throws Throwable {
    props.pushFiltered("app.copy.resource.", "copy.");

    try {
      for (final String pname: props.top().stringPropertyNames()) {
        final String toName = pname.substring("copy.".length());
        final String fromName = props.get(pname);

        Utils.info("Copy " + fromName + " to " + toName);

        final Path outPath =
                Paths.get(props.get("org.bedework.server.resource.root.dir"),
                          toName);

        final Path inPath =
                Paths.get(props.get("org.bedework.postdeploy.resource.base"),
                          fromName);

        final File outFile = outPath.toFile();

        if (outFile.exists()) {
          Utils.deleteAll(outPath);
        }

        Utils.copy(inPath, outPath, false);
      }
    } finally {
      props.pop();
    }
  }
}
