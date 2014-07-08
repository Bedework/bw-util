package org.bedework.util.deployment;

import org.bedework.util.xml.XmlUtil;

import org.w3c.dom.Element;

import java.io.File;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

/** Represent a ear for deployment.
 *
 * @author douglm
 */
public class ApplicationXml extends XmlFile {
  private final Map<String, Element> webModules = new HashMap<>();

  public ApplicationXml(final File meta) throws Throwable {
    super(meta, "application.xml");

    final Element[] modules = XmlUtil.getElementsArray(root);

    for (final Element module : modules) {
      if (!"module".equals(module.getTagName())) {
        continue;
      }

      final Element el = XmlUtil.getOnlyElement(module);

      if ((el == null) || !"web".equals(el.getTagName())) {
        continue;
      }

      final Element webUriEl = findElement(el, "web-uri");

      if (webUriEl == null) {
        continue;
      }

      webModules.put(XmlUtil.getElementContent(webUriEl),
                     module);
    }
  }

  public Set<String> getWebModulesNames() {
    return webModules.keySet();
  }
}
