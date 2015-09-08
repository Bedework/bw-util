package org.bedework.util.deployment;

import org.bedework.util.xml.XmlUtil;

import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import java.io.File;

/** Represent a web.xml file.
 *
 * @author douglm
 */
public class WebXml extends XmlFile {
  private final PropertiesChain props;

  public WebXml(final File webInf,
                final PropertiesChain props) throws Throwable {
    super(webInf, "web.xml", false);
    this.props = props;
  }

  public void update() throws Throwable {
    setConfigName();
    setTransportGuarantee();
    setSecurityDomain();
    addFilter();
    addFilterMapping();
    addListener();
  }

  public void setConfigName() throws Throwable {
    findBwappname:
    for (final Element el : XmlUtil.getElementsArray(root)) {
      if (!"context-param".equals(el.getNodeName())) {
        continue findBwappname;
      }

      final Node pn = XmlUtil.getOneTaggedNode(el, "param-name");

      if (pn == null) {
        continue findBwappname;
      }

      final String pname = XmlUtil.getElementContent((Element)pn);

      if (!"bwappname".equals(pname)) {
        continue findBwappname;
      }

      propsReplaceContent(el, "param-value", props);
    }
  }

  public void setTransportGuarantee() throws Throwable {
    final NodeList children = root.getChildNodes();

    for (int i = 0; i < children.getLength(); i++) {
      final Node n = children.item(i);

      if (!"security-constraint".equals(n.getNodeName())) {
        continue;
      }

      final Node udc = XmlUtil.getOneTaggedNode(n, "user-data-constraint");

      if (udc == null) {
        continue;
      }

      propsReplaceContent((Element)udc, "transport-guarantee", props);
    }
  }

  public void setSecurityDomain() throws Throwable {
    final Node n = XmlUtil.getOneTaggedNode(root, "login-config");

    if (n == null) {
      return;
    }

    propsReplaceContent((Element)n, "realm-name", props);
  }

  public void addFilter() throws Throwable {
    final String fltr = props.get("app.filter");

    if (fltr == null) {
      return;
    }

    try {
      final XmlFile fltrDefs = new XmlFile(fltr, false);

      final Element filtersEl = fltrDefs.root;

      /* if we already have a filter def insert in front */
      Node insertAt = XmlUtil.getOneTaggedNode(root, "filter");

      if (insertAt == null) {
        // then try for listener
        insertAt = XmlUtil.getOneTaggedNode(root, "listener");
      }

      if (insertAt == null) {
        // Bad web.xml?
        throw new Exception("Cannot locate place to insert filter");
      }

      for (final Element el: XmlUtil.getElements(filtersEl)) {
        root.insertBefore(doc.importNode(el, true), insertAt);
      }
    } catch (final Throwable t) {
      Utils.error("Unable to open/process file " + fltr);
      throw t;
    }
  }

  public void addFilterMapping() throws Throwable {
    final String fltr = props.get("app.filter-mapping");

    if (fltr == null) {
      return;
    }

    try {
      final XmlFile fltrDefs = new XmlFile(fltr, false);

      final Element filtersEl = fltrDefs.root;

      /* if we already have a filter def insert in front */
      Node insertAt = XmlUtil.getOneTaggedNode(root, "filter-mapping");

      if (insertAt == null) {
        // then try for listener
        insertAt = XmlUtil.getOneTaggedNode(root, "listener");
      }

      if (insertAt == null) {
        // Bad web.xml?
        throw new Exception("Cannot locate place to insert filter-mapping");
      }

      for (final Element el: XmlUtil.getElements(filtersEl)) {
        root.insertBefore(doc.importNode(el, true), insertAt);
      }
    } catch (final Throwable t) {
      Utils.error("Unable to open/process file " + fltr);
      throw t;
    }
  }

  public void addListener() throws Throwable {
    final String fltr = props.get("app.listener");

    if (fltr == null) {
      return;
    }

    try {
      final XmlFile fltrDefs = new XmlFile(fltr, false);

      final Element filtersEl = fltrDefs.root;

      /* Insert in front current listener */
      final Node insertAt = XmlUtil.getOneTaggedNode(root, "listener");

      if (insertAt == null) {
        // Bad web.xml?
        throw new Exception("Cannot locate place to insert listener");
      }

      for (final Element el: XmlUtil.getElements(filtersEl)) {
        root.insertBefore(doc.importNode(el, true), insertAt);
      }
    } catch (final Throwable t) {
      Utils.error("Unable to open/process file " + fltr);
      throw t;
    }
  }
}
