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
public class XmlFile extends BaseClass {
  protected final Document doc;
  protected final File theXml;
  protected final Element root;

  protected boolean updated;

  public XmlFile(final Utils utils,
                 final File dir,
                 final String name,
                 final boolean nameSpaced) throws Throwable {
    super(utils);
    theXml = utils.file(dir, name, true);

    doc = utils.parseXml(new FileReader(theXml),
                         nameSpaced);

    root = doc.getDocumentElement();
  }

  public XmlFile(final Utils utils,
                 final String path,
                 final boolean nameSpaced) throws Throwable {
    super(utils);
    theXml = utils.file(path);

    doc = utils.parseXml(new FileReader(theXml),
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
   * @param props to lookup new value
   * @param tagnames path to element to set content for
   * @throws Throwable
   */
  protected void propsReplaceContent(final Element root,
                                     final PropertiesChain props,
                                     final String... tagnames) throws Throwable {
    Element el = root;
    if (tagnames != null) {
      for (final String nm: tagnames) {
        el = findElement(el, nm);
        if (el == null) {
          return;
        }
      }
    }

    final String s = XmlUtil.getElementContent(el);

    final String newS = props.replace(s);

    if (s.equals(newS)) {
      return;
    }

    XmlUtil.setElementContent(el, newS);
    updated = true;
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
      //utils.info("no element with name " + tagname);
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
