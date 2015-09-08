package org.bedework.util.deployment;

import org.bedework.util.xml.XmlUtil;

import org.w3c.dom.Element;
import org.w3c.dom.Node;

import java.io.File;
import java.util.List;

/** Represent a jboss-web.xml file.
 *
 * @author douglm
 */
public class JbossWebXml extends XmlFile {
  private final PropertiesChain props;

  public JbossWebXml(final File webInf,
                     final PropertiesChain props) throws Throwable {
    super(webInf, "jboss-web.xml", false);
    this.props = props;
  }

  public void update() throws Throwable {
    Utils.debug("Update " + theXml.getAbsolutePath());

    final List<String> vhosts = props.listProperty("app.virtual-hosts");

    if (vhosts != null) {
      for (final String vh: vhosts) {
        addVirtualHost(vh);
      }
    }

    setJndiNames();
    setSecurityDomain();
  }

  public void addVirtualHost(final String host) {
    final Node vh = doc.createElement("virtual-host");
    final Node textNode = doc.createTextNode(host);

    vh.appendChild(textNode);

    final Node child = root.getFirstChild();
    root.insertBefore(vh, child);
    updated = true;
  }

  public void setSecurityDomain() throws Throwable {
    propsReplaceContent(root, "security-domain", props);
  }

  public void setJndiNames() throws Throwable {
    for (final Element el: XmlUtil.getElements(root)) {
      if (!"resource-ref".equals(el.getTagName())) {
        continue;
      }

      propsReplaceContent(el, "jndi-name", props);
    }
  }
}
