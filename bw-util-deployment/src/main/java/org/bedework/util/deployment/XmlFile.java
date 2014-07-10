package org.bedework.util.deployment;

import org.bedework.util.xml.XmlOutput;
import org.bedework.util.xml.XmlUtil;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;

import java.io.File;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.OutputStream;

/** Represent an xml file in a directory.
 *
 * @author douglm
 */
public class XmlFile {
  protected final Document doc;
  protected final File theXml;
  protected final Element root;

  protected boolean updated;

  public XmlFile(final File dir,
                 final String name,
                 final boolean nameSpaced) throws Throwable {
    theXml = Utils.file(dir, name);

    doc = Utils.parseXml(new FileReader(theXml),
                         nameSpaced);

    root = doc.getDocumentElement();
  }

  public boolean getUpdated() {
    return updated;
  }

  public void output() throws Throwable {
    final OutputStream out = new FileOutputStream(theXml, false);

    XmlOutput.printDocument(doc, out);
  }

  protected Element findElement(final Element root,
                                final String tagName) throws Throwable {
    for (final Element el: XmlUtil.getElementsArray(root)) {
      if (tagName.equals(el.getTagName())) {
        return el;
      }
    }

    return null;
  }

  /** Update the value if it has a property replacement pattern.
   * Set updated true if changed.
   *
   * @param root    search below this for named element
   * @param tagname element to set content for
   * @param props to lookup new value
   * @throws Throwable
   */
  protected void propsReplaceContent(final Element root,
                                     final String tagname,
                                     final PropertiesChain props) throws Throwable {
    final Node n = XmlUtil.getOneTaggedNode(root, tagname);

    if (n == null) {
      Utils.info("no element with name " + tagname);
      return;
    }

    final String s = XmlUtil.getElementContent((Element)n);

    final String newS = props.replace(s);

    if (s.equals(newS)) {
      return;
    }

    XmlUtil.setElementContent(n, newS);
    updated = true;
  }
}
