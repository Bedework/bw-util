package org.bedework.util.deployment;

import org.bedework.util.xml.XmlUtil;

import org.w3c.dom.Document;
import org.w3c.dom.Element;

import java.util.HashMap;
import java.util.Map;

/** Represent a ear for deployment.
 *
 * @author douglm
 */
public class WebModule {
  private final Document doc;
  private final Element mdlRoot;

  private String name;
  private String type;
  private String context;

  private final Map<String, Element> webModules = new HashMap<>();

  /**
   * @param doc the application.xml doc
   * @param mdlRoot possible web module
   * @return null if not a web module otherwise an object.
   * @throws Throwable
   */
  public static WebModule testWebModule(final Document doc,
                                        final Element mdlRoot) throws Throwable {
    final Element el = XmlUtil.getOnlyElement(mdlRoot);

    if ((el == null) || !"web".equals(el.getLocalName())) {
      return null;
    }

    return new WebModule(doc, mdlRoot);
  }

  private WebModule(final Document doc,
                    final Element mdlRoot) throws Throwable {
    this.doc = doc;
    this.mdlRoot = mdlRoot;

    final Element mdType = XmlUtil.getOnlyElement(mdlRoot);

    for (final Element el : XmlUtil.getElementsArray(mdType)) {
      if ("web-uri".equals(el.getLocalName())) {
        name = XmlUtil.getElementContent(el);
        continue;
      }

      if ("context-root".equals(el.getLocalName())) {
        context = XmlUtil.getElementContent(el);
      }
    }
  }

  public void setName(final String val) {
    this.name = val;
  }

  public String getName() {
    return name;
  }

  public void setType(final String val) {
    this.type = val;
  }

  public String getType() {
    return type;
  }

  public void setContext(final String val) {
    this.context = val;
  }

  public String getContext() {
    return context;
  }
}
