/* ********************************************************************
    Appropriate copyright notice
*/
package org.bedework.util.xml.diff;

import org.bedework.util.misc.Util;

import org.w3c.dom.Node;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import javax.xml.namespace.QName;

/**
 * User: mike Date: 2/2/20 Time: 12:33
 */
public class NodeDiff {
  public static class DiffNode {
    final List<Node> pathTo;
    final NodeWrapper left;
    final NodeWrapper right;

    /** Attempt to do a comparison of the structure pointed to by
     * left and right.
     *
     * NOTE: this may be an incomplete comparison. At the moment the
     * emphasis is on flagging inequalities and attempting to show
     * where. It remains to be seen how well it codes with added and
     * deleted nodes.
     *
     * @param pathTo the left and/or right
     * @param left node or null if right was added
     * @param right node or null if left was added
     */
    public DiffNode(final List<Node> pathTo,
                    final NodeWrapper left,
                    final NodeWrapper right) {
      this.pathTo = pathTo;
      this.left = left;
      this.right = right;
    }

    public String toString() {
      final StringBuilder sb = new StringBuilder();

      sb.append("Path: ");
      if (Util.isEmpty(pathTo)) {
        sb.append("<empty>");
      } else {
        String delim = "";
        for (final Node n: pathTo) {
          sb.append(delim);
          delim = " -> ";

          sb.append(new QName(n.getNamespaceURI(), n.getLocalName()));
        }
      }

      sb.append("\n");
      sb.append("left: ");
      outNw(sb, left);
      sb.append("right: ");
      outNw(sb, right);

      return sb.toString();
    }

    private void outNw(final StringBuilder sb,
                         final NodeWrapper nw) {
      if (left == null) {
        sb.append("null ");
        return;
      }

      sb.append(nw.getName());
      sb.append(" ");
      if (nw.hasContent()) {
        sb.append(nw.getContent());
        sb.append(" ");
      }
    }
  }

  /**
   *
   * @param left node to compare
   * @param right node to compare
   * @return a list of differing nodes at or below left and right
   */
  public static List<DiffNode> diff(final Node left,
                                    final Node right) {
    return diff(new ArrayList<>(0), left, right);
  }

  /**
   *
   * @param pathTo the left and right
   * @param left node to compare
   * @param right node to compare
   * @return a list of differing nodes at or below left and right
   */
  public static List<DiffNode> diff(final List<Node> pathTo,
                                    final Node left,
                                    final Node right) {
    if (left == null) {
      if (right != null) {
        return Collections.singletonList(
                new DiffNode(pathTo, null, new NodeWrapper(right)));
      }
      return Collections.emptyList();
    }

    if (right == null) {
      return Collections.singletonList(
              new DiffNode(pathTo, new NodeWrapper(left), null));
    }

    // Both non-null

    return diff(Collections.emptyList(),
                new NodeWrapper(left),
                new NodeWrapper(right));
  }


  /**
   *
   * @param pathTo the left and right
   * @param leftNw node to compare
   * @param rightNw node to compare
   * @return a list of differing nodes at or below left and right
   */
  public static List<DiffNode> diff(final List<Node> pathTo,
                                    final NodeWrapper leftNw,
                                    final NodeWrapper rightNw) {
    final List<DiffNode> result = new ArrayList<>();


    if (leftNw.compareTo(rightNw) == 0) {
      return result;
    }

    // Do shallow compare - compares content.
    if (leftNw.shallowCompare(rightNw) != 0) {
      result.add(new DiffNode(pathTo, leftNw, rightNw));
      return result;
    }

    final List<Node> npathTo = new ArrayList<>(pathTo);
    npathTo.add(leftNw.getNode());

    // Children may differ
    List<NodeWrapper> leftChildren = leftNw.getChildWrappers();
    List<NodeWrapper> rightChildren = rightNw.getChildWrappers();

    if (Util.isEmpty(leftChildren)) {
      if (!Util.isEmpty(rightChildren)) {
        for (final NodeWrapper nw: rightChildren) {
          result.add(new DiffNode(npathTo, null, nw));
        }
      }
      return result;
    }

    if (Util.isEmpty(rightChildren)) {
      for (final NodeWrapper nw: leftChildren) {
        result.add(new DiffNode(npathTo, nw, null));
      }
      return result;
    }

    int lefti = 0;
    int righti = 0;

    doDiff:
    do {
      final NodeWrapper lnw = leftChildren.get(lefti);
      final NodeWrapper rnw = rightChildren.get(righti);

      if (lnw.equals(rnw)) {
        lefti++;
        righti++;
        continue doDiff;
      }

      // See if there is a subsequent node in the right that matches
      final List<DiffNode> skipped = new ArrayList<>();

      int testi = righti + 1;

      while (testi < rightChildren.size()) {
        final NodeWrapper testnw = rightChildren.get(testi);

        int cmp = lnw.compareTo(testnw);
        if (cmp == 0) {
          result.addAll(skipped);
          righti = testi;
          continue doDiff;
        }

        if (cmp > 0) {
          break;
        }

        skipped.addAll(diff(npathTo, lnw, testnw));
        testi++;
      }

      // Didn't find any. Try the other side
      skipped.clear();

      testi = lefti + 1;

      while (testi < leftChildren.size()) {
        final NodeWrapper testnw = leftChildren.get(testi);

        int cmp = rnw.compareTo(testnw);
        if (cmp == 0) {
          // Node and subtrees match
          result.addAll(skipped);
          lefti = testi;
          continue doDiff;
        }

        if (cmp > 0) {
          break;
        }

        skipped.addAll(diff(npathTo, testnw, rnw));
        testi++;
      }

      // No match either side.

      if (lnw.shallowCompare(rnw) != 0) {
        result.add(new DiffNode(npathTo, lnw, rnw));
      } else {
        // Element itself matches - must be the children
        skipped.addAll(diff(npathTo, lnw, rnw));
      }

      lefti++;
      righti++;
    } while ((lefti < leftChildren.size()) &&
            (righti < rightChildren.size()));

    return result;
  }
}
