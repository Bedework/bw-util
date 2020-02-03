/* ********************************************************************
    Appropriate copyright notice
*/
package org.bedework.util.xml.diff;

import org.bedework.util.misc.Util;
import org.bedework.util.xml.XmlUtil;

import org.w3c.dom.Node;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import javax.xml.namespace.QName;

/** Provides a way to compare nodes. After a compare there will be a
 * hierarchy of these objects built which can be used to determine
 * and differences.
 *
 * User: mike Date: 2/2/20 Time: 11:33
 */
public class NodeWrapper implements Comparable<NodeWrapper> {
  private final Node theNode;

  /* This will be in increasing order
   */
  private List<NodeWrapper> children;

  public NodeWrapper(final Node theNode) {
    this.theNode = theNode;
  }

  public Node getNode() {
    return theNode;
  }

  public boolean hasChildren() {
    return XmlUtil.hasChildren(theNode);
  }

  public boolean hasContent() {
    return XmlUtil.hasContent(theNode);
  }

  public String getContent() {
    return XmlUtil.getElementContent(theNode);
  }

  public QName getName() {
    return new QName(theNode.getNamespaceURI(),
            theNode.getLocalName());
  }

  public List<NodeWrapper> getChildWrappers() {
    if (children != null) {
      return children;
    }

    if (!XmlUtil.hasChildren(theNode)) {
      children = Collections.emptyList();
      return children;
    }

    children = new ArrayList<>();

    for (final Node nd: XmlUtil.getNodes(theNode)) {
      children.add(new NodeWrapper(nd));
    }

    /* Now sort it. This will cause a recursive build of the structure
     */

    Collections.sort(children);

    return children;
  }

  /** Does not compare the children in any way - only names and any
   * content
   *
   * @param o the other node
   * @return a negative integer, zero, or a positive integer as this object
   *          is less than, equal to, or greater than the specified object.
   */
  public int shallowCompare(final NodeWrapper o) {
    int res = theNode.getNamespaceURI()
                     .compareTo(o.theNode.getNamespaceURI());

    if (res != 0) {
      return res;
    }

    res = theNode.getLocalName()
                 .compareTo(o.theNode.getLocalName());

    if (res != 0) {
      return res;
    }

    if (!hasChildren()) {
      if (o.hasChildren()) {
        return -1;
      }

      return Util.compareStrings(getContent(), o.getContent());
    }

    return 0;
  }

  @Override
  public int compareTo(final NodeWrapper o) {
    int res = shallowCompare(o);
    if (res != 0) {
      return res;
    }

    List<NodeWrapper> theirChildren = getChildWrappers();
    int index = 0;

    for (final NodeWrapper nw: getChildWrappers()) {
      if (index == theirChildren.size()) {
        // We have more children
        return 1;
      }

      res = compareTo(theirChildren.get(index));
      if (res != 0) {
        return res;
      }

      index++;
    }

    if (index < theirChildren.size()) {
      // They have more children
      return -1;
    }

    return 0;
  }

  @Override
  public int hashCode() {
    // This is imperfect
    return theNode.getNamespaceURI().hashCode() ^ theNode.getLocalName().hashCode();
  }

  @Override
  public boolean equals(final Object o) {
    if (o == null) {
      return false;
    }

    if (o instanceof NodeWrapper) {
      return compareTo((NodeWrapper)o) == 0;
    }

    return false;
  }
}
