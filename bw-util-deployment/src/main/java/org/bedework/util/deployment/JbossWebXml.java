package org.bedework.util.deployment;

import org.w3c.dom.Node;

import java.io.File;

/** Represent a jboss-web.xml file.
 *
 * @author douglm
 */
public class JbossWebXml extends XmlFile {
  public JbossWebXml(final File webInf) throws Throwable {
    super(webInf, "jboss-web.xml");
  }

  public void addVirtualHost(final String host) {
    final Node vh = doc.createElement("virtual-host");
    final Node textNode = doc.createTextNode(host);

    vh.appendChild(textNode);

    final Node child = root.getFirstChild();
    root.insertBefore(vh, child);
  }
}
