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
  private final Map<String, Module> webModules = new HashMap<>();

  public ApplicationXml(final File meta) throws Throwable {
    super(meta, "application.xml", false);

    final Element[] modules = XmlUtil.getElementsArray(root);

    for (final Element module : modules) {
      if (!"module".equals(module.getTagName())) {
        continue;
      }

      final Element el = XmlUtil.getOnlyElement(module);

      if ((el == null) || !"web".equals(el.getTagName())) {
        continue;
      }

      final Module mdl = new Module();

      mdl.moduleEl = module;
      mdl.webEl = el;

      final Element webUriEl = findElement(el, "web-uri");

      if (webUriEl == null) {
        continue;
      }

      mdl.webUriEl = webUriEl;

      webModules.put(XmlUtil.getElementContent(webUriEl),
                     mdl);
    }
  }

  private static class Module {
    Element moduleEl;
    Element webEl;
    Element webUriEl;
  }

  public Set<String> getWebModulesNames() {
    return webModules.keySet();
  }

  /** Update the context for the given module - value may reference a
   * proeprty.
   *
   * @param moduleName - the module
   * @param props for replacement value
   * @throws Throwable
   */
  public void setContext(final String moduleName,
                         final PropertiesChain props) throws Throwable {
    final Module module = webModules.get(moduleName);

    if (module == null) {
      Utils.error("Module " + moduleName + " not in application.xml");
      return;
    }

    propsReplaceContent(module.webEl, "context-root", props);
  }
}
