package org.bedework.util.deployment;

import org.w3c.dom.Element;

import java.io.File;
import java.io.FileOutputStream;
import java.util.List;

/** Represent a jboss-deployment-structure.xml file.
 *
 * @author douglm
 */
public class JbossDeploymentStructureXml extends XmlFile {
  private static final String jbossAllTemplate =
        "<jboss-deployment-structure xmlns=\"urn:jboss:deployment-structure:1.3\">\n" +
        "    <deployment>\n" +
        //"        <exclusions>\n" +
        //"            <module name=\"org.javassist\" />\n" +
        //"        </exclusions>\n" +
        "    </deployment>\n" +
        "</jboss-deployment-structure>\n" +
        "\n";

  private final PropertiesChain props;

  public static void generate(final File earMeta) throws Throwable {
    // Generate a jboss-all.xml
    final File jbossAllF = new File(earMeta.getAbsolutePath(),
                                    "jboss-deployment-structure.xml");

    final FileOutputStream fos = new FileOutputStream(jbossAllF, false);
    fos.write(jbossAllTemplate.getBytes());
    fos.close();
  }

  public JbossDeploymentStructureXml(final Utils utils,
                                     final File metaInf,
                                     final PropertiesChain props) throws Throwable {
    super(utils, metaInf, "jboss-deployment-structure.xml", false);
    this.props = props;
  }

  public void update() throws Throwable {
    utils.debug("Update " + theXml.getAbsolutePath());

    final List<String> earExclusions = 
            props.listProperty("app.ear.exclusions");

    if (earExclusions != null) {
      for (final String ed: earExclusions) {
        addExclusion(ed);
      }
    }
  }

  public void addExclusion(final String exc) throws Throwable {
    final Element depNode = findElement(root, "deployment");
    if (depNode == null) {
      utils.error("Cannot locate node deployment");
      return;
    }

    Element excsNode = findElement(depNode, "exclusions");
    if (excsNode == null) {
      excsNode = doc.createElement("exclusions");
      depNode.appendChild(excsNode);
    }

    final Element mdlNode = doc.createElement("module");
    mdlNode.setAttribute("name", exc);

    excsNode.appendChild(mdlNode);

    updated = true;
  }
}
