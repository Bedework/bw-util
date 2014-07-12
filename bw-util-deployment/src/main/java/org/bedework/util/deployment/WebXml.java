package org.bedework.util.deployment;

import org.bedework.util.xml.XmlUtil;

import org.w3c.dom.Element;
import org.w3c.dom.Node;

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
  }

  public void setConfigName() throws Throwable {
    findBwappname:chrome://web-developer/content/generated/view-response-headers.html
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
    final Node sc = XmlUtil.getOneTaggedNode(root, "security-constraint");

    if (sc == null) {
      return;
    }

    final Node udc = XmlUtil.getOneTaggedNode(sc, "user-data-constraint");

    if (udc == null) {
      return;
    }

    propsReplaceContent((Element)udc, "transport-guarantee", props);
  }

  public void setSecurityDomain() throws Throwable {
    final Node n = XmlUtil.getOneTaggedNode(root, "login-config");

    if (n == null) {
      return;
    }

    propsReplaceContent((Element)n, "realm-name", props);
  }
}
