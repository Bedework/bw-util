package org.bedework.util.deployment;

import org.w3c.dom.Element;
import org.w3c.dom.Node;

import java.io.File;
import java.util.List;

/** Represent a jboss-web.xml file.
 *
 * @author douglm
 */
public class JbossAllXml extends XmlFile {
  private final PropertiesChain props;
  private final String version;

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
    
    final Node depNode = doc.createElement("dependency");
    final Node textNode = doc.createTextNode(dep + "-" + version + ".ear");

    depNode.appendChild(textNode);
    el.appendChild(depNode);

    updated = true;
  }
}
