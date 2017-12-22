package org.bedework.util.deployment;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;

/** Represent a war for deployment.
 *
 * @author douglm
 */
public class War extends DeployableResource implements Updateable {
  private final ApplicationXml appXml;

  private final JbossWebXml jbwXml;

  private final WebXml wXml;

  private final boolean warsonly;

  public War(final Utils utils,
             final String path,
             final SplitName sn,
             final ApplicationXml appXml,
             final PropertiesChain props) throws Throwable {
    super(utils, path, sn, props, "app." + sn.prefix + ".");

    warsonly = Boolean.valueOf(props.get(Process.propWarsOnly));
    this.appXml = appXml;

    final File webInf = utils.subDirectory(theFile, "WEB-INF", true);

    jbwXml = new JbossWebXml(utils, webInf, this.props);
    wXml = new WebXml(utils, webInf, this.props);
  }

  @Override
  public void update() throws Throwable {
    utils.debug("Update war " + getSplitName());

    copyDocs();
    copyResources();
    processWsdls();

    if (appXml != null) {
      appXml.setContext(sn.name, props);
    }

    jbwXml.update();

    if (jbwXml.getUpdated()) {
      jbwXml.output();
    }

    wXml.update();

    if (wXml.getUpdated()) {
      wXml.output();
    }

    updateLib(warsonly);
  }

  private void copyDocs() throws Throwable {
    final String fromName = props.get("app.moredocs");
    if (fromName == null) {
      return;
    }

    final File docs = utils.subDirectory(theFile, "docs", true);

    final Path outPath = Paths.get(docs.getAbsolutePath());
    final Path inPath = Paths.get(fromName);

    utils.debug("Copy from " + inPath + " to " + outPath);

    utils.copy(inPath, outPath, true);
  }

  private void copyResources() throws Throwable {
    if (utils.debug()) {
      utils.debug("before push");
      for (final String pname : props.topNames()) {
        utils.debug(pname);
      }
    }
    props.pushFiltered("app.copy.resource.", "copy.");

    if (utils.debug()) {
      utils.debug("after push");
      for (final String pname : props.topNames()) {
        utils.debug(pname);
      }
    }
    try {
      for (final String pname: props.topNames()) {
        final String toName = pname.substring("copy.".length());
        final String fromName = props.get(pname);

        final Path outPath =
                Paths.get(props.get("org.bedework.server.resource.root.dir"),
                          toName);

        final Path inPath =
                Paths.get(props.get("org.bedework.postdeploy.resource.base"),
                          fromName);

        final File outFile = outPath.toFile();

        if (outFile.exists()) {
          utils.deleteAll(outPath);
        }
        
        if (!outFile.mkdirs()) {
          utils.error("Unable to create output directory " + outPath);
        }

        utils.info("Copy " + inPath + " to " + outPath);

        utils.copy(inPath, outPath, false);
      }
    } finally {
      props.pop();
    }
  }

  private void processWsdls() throws Throwable {
    if (utils.debug()) {
      utils.debug("About to do wsdl");
    }
    props.pushFiltered("app.wsdl.", "wsdl.");

    try {
      for (final String pname: props.topNames()) {
        utils.info("About to do wsdsl - pname " + pname);
        // Get name of folder containing wsdl
        final String folderName = pname.substring("wsdl.".length());

        final File folder = utils.subDirectory(this.theFile,
                                               folderName,
                                               true);

        // Value is name of wsdl
        final String wsdlName = props.get(pname);

        final Wsdl wsdl = new Wsdl(utils, folder, wsdlName, props);

        wsdl.update();

        if (wsdl.getUpdated()) {
          wsdl.output();
        }
      }
    } finally {
      props.pop();
    }
  }
}
