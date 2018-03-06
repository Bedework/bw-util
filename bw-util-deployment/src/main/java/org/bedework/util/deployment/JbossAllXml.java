package org.bedework.util.deployment;

import org.w3c.dom.Element;

import java.io.File;
import java.io.FileOutputStream;
import java.util.List;

/** Represent a jboss-web.xml file.
 *
 * @author douglm
 */
public class JbossAllXml extends XmlFile {
  private static final String jbossAllTemplate =
          "<jboss xmlns=\"urn:jboss:1.0\">\n" +
                  "    <jboss-deployment-dependencies xmlns=\"urn:jboss:deployment-dependencies:1.0\">\n" +
                  "    </jboss-deployment-dependencies>\n" +
                  "</jboss>";

  private final PropertiesChain props;
  private final String version;
  
  public static void generate(final File earMeta) throws Throwable {
    // Generate a jboss-all.xml
    final File jbossAllF = new File(earMeta.getAbsolutePath(),
                                    "jboss-all.xml");

    final FileOutputStream fos = new FileOutputStream(jbossAllF, false);
    fos.write(jbossAllTemplate.getBytes());
    fos.close();
  }

  public JbossAllXml(final Utils utils,
                     final File metaInf,
                     final String version,
                     final PropertiesChain props) throws Throwable {
    super(utils, metaInf, "jboss-all.xml", false);
    this.version = version;
    this.props = props;
  }

  public void update() throws Throwable {
    utils.debug("Update " + theXml.getAbsolutePath());

    final List<String> earDependencies = 
            props.listProperty("app.ear.dependencies");

    if (earDependencies != null) {
      for (final String ed: earDependencies) {
        addDependency(ed);
      }
    }
  }

  public void addDependency(final String dep) throws Throwable {
    final Element el = findElement(root, "jboss-deployment-dependencies");
    if (el == null) {
      utils.error("Cannot locate jboss-deployment-dependencies");
      return;
    }

    props.debugList(utils, "Setting dependency version");

    final Element depNode = doc.createElement("dependency");
    depNode.setAttribute("name",
                         dep + "-" +
                                 getVersion(dep, version) +
                                 ".ear");

    el.appendChild(depNode);

    updated = true;
  }

  private String getVersion(final String name,
                            final String def) {
    final String version = utils.getVersionsProp("org.bedework.global.versions." + name);
    if (version != null) {
      return version;
    }

    return def;
  }
}
