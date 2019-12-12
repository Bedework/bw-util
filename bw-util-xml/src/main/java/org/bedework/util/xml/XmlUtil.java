/* ********************************************************************
    Licensed to Jasig under one or more contributor license
    agreements. See the NOTICE file distributed with this work
    for additional information regarding copyright ownership.
    Jasig licenses this file to you under the Apache License,
    Version 2.0 (the "License"); you may not use this file
    except in compliance with the License. You may obtain a
    copy of the License at:

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on
    an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
    KIND, either express or implied. See the License for the
    specific language governing permissions and limitations
    under the License.
*/
package org.bedework.util.xml;

import org.w3c.dom.Attr;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import javax.xml.namespace.QName;

/**
 * Utility routines associated with handling xml
 *
 * @author Mike Douglass   douglm rpi.edu
 */
public final class XmlUtil implements Serializable {
  /* * See if we have simple untagged text. At the moment this is a very
   *  simple check, if the first character after white-space is a less-than
   *  we assume tagged text.
   *
   * @param  val      The text to check
   * @return boolean  true if the text is apparently untagged
   * /
  private static boolean checkSimpleText(String val) {
    int i = skipWhite(val, 0);

    if (val.charAt(i) == '< ') {
      return false;
    }

    return true;
  }

  /** Convert simple untagged text to tagged text.
   * <p>We should check for special characters if this is untagged and
   * replace with the appropriate entities
   *
   * @param val      The text to check
   * @return String  modified text.
   * /
  private static String tagSimpleText(String val) {
    int i = skipWhite(val, 0);

    if (i == val.length()) {
      return "";
    }

    /** Assume we have non-html/xml. We should attempt to add paragraph tags
     * /

    StringReader sr = new StringReader(val);
    LineNumberReader lr = new LineNumberReader(sr);
    StringBuffer sb = new StringBuffer();

    sb.append("<p>\n");
    try {
      while (lr.ready()) {
        String l = lr.readLine();

        if (l == null) {
          break;
        }

        if (skipWhite(l, 0) == l.length()) {
          sb.append("</p>\n");
          sb.append("<p>\n");
        } else {
          sb.append(l);
          sb.append('\n');
        }
      }
      sb.append("</p>\n");

      return sb.toString();
    } catch (Exception e) {
      System.out.println("Exception in checkSimpleText(): " +
                         e.getMessage());
      e.printStackTrace();
      return val;
    }
  }

  private static int skipWhite(String val, int i) {
    while ((i < val.length()) && (Character.isWhitespace(val.charAt(i)))) {
      i++;
    }

    return i;
  }*/

  /** Get the single named element.
   *
   * @param el          Node
   * @param name        String tag name of required node
   * @return Node     node value or null
   * @throws SAXException
   */
  public static Node getOneTaggedNode(final Node el,
                                      final String name)
          throws SAXException {
    if (!el.hasChildNodes()) {
      return null;
    }

    final NodeList children = el.getChildNodes();

    for (int i = 0; i < children.getLength(); i++) {
      final Node n = children.item(i);

      if (name.equals(n.getNodeName())) {
        return n;
      }
    }

    return null;
  }

  /** Get the value of an element. We expect 0 or 1 child nodes.
   * For no child node we return null, for more than one we raise an
   * exception.
   *
   * @param el          Node whose value we want
   * @param name        String name to make exception messages more readable
   * @return String     node value or null
   * @throws SAXException
   */
  public static String getOneNodeVal(final Node el, final String name)
      throws SAXException {
    /* We expect one child of type text */

    if (!el.hasChildNodes()) {
      return null;
    }

    NodeList children = el.getChildNodes();
    if (children.getLength() > 1){
      throw new SAXException("Multiple property values: " + name);
    }

    Node child = children.item(0);
    return child.getNodeValue();
  }

  /** Get the value of an element. We expect 0 or 1 child nodes.
   * For no child node we return null, for more than one we raise an
   * exception.
   *
   * @param el          Node whose value we want
   * @return String     node value or null
   * @throws SAXException
   */
  public static String getOneNodeVal(final Node el) throws SAXException {
    return getOneNodeVal(el, el.getNodeName());
  }

  /** Get the value of an element. We expect 1 child node otherwise we raise an
   * exception.
   *
   * @param el          Node whose value we want
   * @param name        String name to make exception messages more readable
   * @return String     node value
   * @throws SAXException
   */
  public static String getReqOneNodeVal(final Node el, final String name)
      throws SAXException {
    String str = getOneNodeVal(el, name);

    if ((str == null) || (str.length() == 0)) {
      throw new SAXException("Missing property value: " + name);
    }

    return str;
  }

  /** Get the value of an element. We expect 1 child node otherwise we raise an
   * exception.
   *
   * @param el          Node whose value we want
   * @return String     node value
   * @throws SAXException
   */
  public static String getReqOneNodeVal(final Node el) throws SAXException {
    return getReqOneNodeVal(el, el.getNodeName());
  }

  /** Return the value of the named attribute of the given element.
   *
   * @param el          Element
   * @param name        String name of desired attribute
   * @return String     attribute value or null
   * @throws SAXException
   */
  public static String getAttrVal(final Element el, final String name)
      throws SAXException {
    Attr at = el.getAttributeNode(name);
    if (at == null) {
      return null;
    }

    return at.getValue();
  }

  /** Return the required value of the named attribute of the given element.
   *
   * @param el          Element
   * @param name        String name of desired attribute
   * @return String     attribute value
   * @throws SAXException
   */
  public static String getReqAttrVal(final Element el, final String name)
      throws SAXException {
    String str = getAttrVal(el, name);

    if ((str == null) || (str.length() == 0)) {
      throw new SAXException("Missing attribute value: " + name);
    }

    return str;
  }

  /** Return the attribute value of the named attribute from the given map.
   *
   * @param nnm         NamedNodeMap
   * @param name        String name of desired attribute
   * @return String     attribute value or null
   */
  public static String getAttrVal(final NamedNodeMap nnm, final String name) {
    Node nmAttr = nnm.getNamedItem(name);

    if ((nmAttr == null) || (absent(nmAttr.getNodeValue()))) {
      return null;
    }

    return nmAttr.getNodeValue();
  }

  /** The attribute value of the named attribute in the given map must be
   * absent or "yes" or "no".
   *
   * @param nnm         NamedNodeMap
   * @param name        String name of desired attribute
   * @return Boolean    attribute value or null
   * @throws SAXException
   */
  public static Boolean getYesNoAttrVal(final NamedNodeMap nnm, final String name)
      throws SAXException {
    String val = getAttrVal(nnm, name);

    if (val == null) {
      return null;
    }

    if ((!"yes".equals(val)) && (!"no".equals(val))) {
      throw new SAXException("Invalid attribute value: " + val);
    }

    return new Boolean("yes".equals(val));
  }

  /**
   * @param nd
   * @return int number of attributes
   */
  public static int numAttrs(final Node nd) {
    NamedNodeMap nnm = nd.getAttributes();

    if (nnm == null) {
      return 0;
    }

    return nnm.getLength();
  }

  /** All the children must be elements or white space text nodes.
   *
   * @param nd
   * @return Collection   element nodes. Always non-null
   * @throws SAXException
   */
  public static List<Element> getElements(final Node nd) throws SAXException {
    final List<Element> al = new ArrayList<>();

    NodeList children = nd.getChildNodes();

    for (int i = 0; i < children.getLength(); i++) {
      Node curnode = children.item(i);

      if (curnode.getNodeType() == Node.TEXT_NODE) {
        String val = curnode.getNodeValue();

        if (val != null) {
          for (int vi= 0; vi < val.length(); vi++) {
            if (!Character.isWhitespace(val.charAt(vi))) {
              throw new SAXException("Non-whitespace text in element body for " +
                                     nd.getLocalName() +
                                     "\n text=" + val);
            }
          }
        }
      } else if (curnode.getNodeType() == Node.COMMENT_NODE) {
        // Ignore
      } else if (curnode.getNodeType() == Node.ELEMENT_NODE) {
        al.add((Element)curnode);
      } else {
        throw new SAXException("Unexpected child node " + curnode.getLocalName() +
                               " for " + nd.getLocalName());
      }
    }

    return al;
  }

  /** Return the content for the current element. All leading and trailing
   * whitespace and embedded comments will be removed.
   *
   * <p>This is only intended for an element with no child elements.
   *
   * @param el
   * @param trim true to trim surrounding white-space
   * @return element content
   * @throws SAXException
   */
  public static String getElementContent(final Element el,
                                         final boolean trim) throws SAXException {
    StringBuilder sb = new StringBuilder();

    NodeList children = el.getChildNodes();

    for (int i = 0; i < children.getLength(); i++) {
      Node curnode = children.item(i);

      if (curnode.getNodeType() == Node.TEXT_NODE) {
        sb.append(curnode.getNodeValue());
      } else if (curnode.getNodeType() == Node.CDATA_SECTION_NODE) {
        sb.append(curnode.getNodeValue());
      } else if (curnode.getNodeType() == Node.COMMENT_NODE) {
        // Ignore
      } else {
        throw new SAXException("Unexpected child node " + curnode.getLocalName() +
                               " for " + el.getLocalName());
      }
    }

    if (!trim) {
      return sb.toString();
    }

    return sb.toString().trim();
  }

  /** Replace the content for the current element.
   *
   * @param n element
   * @param s string content
   * @throws SAXException
   */
  public static void setElementContent(final Node n,
                                       final String s) throws SAXException {
    NodeList children = n.getChildNodes();

    for (int i = 0; i < children.getLength(); i++) {
      Node curnode = children.item(i);

      n.removeChild(curnode);
    }

    Document d = n.getOwnerDocument();

    final Node textNode = d.createTextNode(s);

    n.appendChild(textNode);
  }

  /** Return the content for the current element. All leading and trailing
   * whitespace and embedded comments will be removed.
   *
   * <p>This is only intended for an element with no child elements.
   *
   * @param el
   * @return element content
   * @throws SAXException
   */
  public static String getElementContent(final Element el) throws SAXException {
    return getElementContent(el, true);
  }

  /** Return true if the current element has non zero length content.
   *
   * @param el
   * @return boolean
   * @throws SAXException
   */
  public static boolean hasContent(final Element el) throws SAXException {
    String s = getElementContent(el);

    return (s != null) && (s.length() > 0);
  }

  /** See if this node has any children
   *
   * @param el
   * @return boolean   true for any child elements
   * @throws SAXException
   */
  public static boolean hasChildren(final Element el) throws SAXException {
    NodeList children = el.getChildNodes();

    for (int i = 0; i < children.getLength(); i++) {
      Node curnode = children.item(i);

      short ntype =  curnode.getNodeType();
      if ((ntype != Node.TEXT_NODE) &&
          (ntype != Node.CDATA_SECTION_NODE) &&
          (ntype != Node.COMMENT_NODE)) {
        return true;
      }
    }

    return false;
  }

  public static void clear(final Node nd) {
    NodeList children = nd.getChildNodes();

    for (int i = 0; i < children.getLength(); i++) {
      nd.removeChild(children.item(i));
    }
  }

  /** See if this node is empty
   *
   * @param el
   * @return boolean   true for empty
   * @throws SAXException
   */
  public static boolean isEmpty(final Element el) throws SAXException {
    return !hasChildren(el) && !hasContent(el);
  }

  /**
   * @param nd
   * @return element array from node
   * @throws SAXException
   */
  public static Element[] getElementsArray(final Node nd) throws SAXException {
    Collection<Element> al = getElements(nd);

    return al.toArray(new Element[al.size()]);
  }

  /** See if node matches tag
   *
   * @param nd
   * @param tag
   * @return boolean true for match
   */
  public static boolean nodeMatches(final Node nd, final QName tag) {
    if (tag == null) {
      return false;
    }

    String ns = nd.getNamespaceURI();

    if (ns == null) {
      /* It appears a node can have a NULL namespace but a QName has a zero length
       */
      if ((tag.getNamespaceURI() != null) && (!"".equals(tag.getNamespaceURI()))) {
        return false;
      }
    } else if (!ns.equals(tag.getNamespaceURI())) {
      return false;
    }

    String ln = nd.getLocalName();

    if (ln == null) {
      if (tag.getLocalPart() != null) {
        return false;
      }
    } else if (!ln.equals(tag.getLocalPart())) {
      return false;
    }

    return true;
  }

  /** Return a QName for the node
   *
   * @param nd
   * @return boolean true for match
   */
  public static QName fromNode(final Node nd) {
    String ns = nd.getNamespaceURI();

    if (ns == null) {
      /* It appears a node can have a NULL namespace but a QName has a zero length
       */
      ns = "";
    }

    return new QName(ns, nd.getLocalName());
  }

  /**
   * @param nd
   * @return only child node
   * @throws SAXException  if not exactly one child elemnt
   */
  public static Element getOnlyElement(final Node nd) throws SAXException {
    Element[] els = getElementsArray(nd);

    if (els.length != 1) {
      throw new SAXException("Expected exactly one child node for " +
                              nd.getLocalName());
    }

    return els[0];
  }

  private static boolean absent(final String val) {
    return (val == null) || (val.length() == 0);
  }
}

