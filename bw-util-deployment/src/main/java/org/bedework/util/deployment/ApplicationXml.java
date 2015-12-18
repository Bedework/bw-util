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

  public ApplicationXml(final Utils utils,
                        final File meta) throws Throwable {
    super(utils, meta, "application.xml", false);

    for (final Element module: XmlUtil.getElementsArray(root)) {
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

  /** Add a web module.
   *
   * @param moduleName - the module name
   * @throws Throwable
   */
  public void addWebModule(final String moduleName) throws Throwable {
    final Element mdlEl = doc.createElement("module");
    final Element webEl = doc.createElement("web");

    mdlEl.appendChild(webEl);

    final Element weburiEl = doc.createElement("web-uri");
    weburiEl.appendChild(doc.createTextNode(moduleName));
    webEl.appendChild(weburiEl);

    final Element contextEl = doc.createElement("context-root");
    contextEl.appendChild(doc.createTextNode("${app.context}"));
    webEl.appendChild(contextEl);

    /* Find the first module element. Note this won't work if there are
       no modules.
     */
    for (final Element module : XmlUtil.getElementsArray(root)) {
      if (!"module".equals(module.getTagName())) {
        continue;
      }

      root.insertBefore(mdlEl, module);
      updated = true;
      break;
    }

    final Module mdl = new Module();
    mdl.moduleEl = mdlEl;
    mdl.webEl = webEl;
    mdl.webUriEl = weburiEl;

    webModules.put(moduleName, mdl);
  }

  /** Update the context for the given module - value may reference a
   * property.
   *
   * @param moduleName - the module
   * @param props for replacement value
   * @throws Throwable
   */
  public void setContext(final String moduleName,
                         final PropertiesChain props) throws Throwable {
    final Module module = webModules.get(moduleName);

    if (module == null) {
      utils.error("Module " + moduleName + " not in application.xml");
      return;
    }

    propsReplaceContent(module.webEl, "context-root", props);
  }
}
