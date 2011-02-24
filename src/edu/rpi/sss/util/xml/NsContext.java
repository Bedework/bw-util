package edu.rpi.sss.util.xml;

import edu.rpi.sss.util.xml.tagdefs.XcalTags;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;

import javax.xml.XMLConstants;
import javax.xml.namespace.NamespaceContext;
import javax.xml.namespace.QName;

/** Class used for diff, xpaths etc etc.
 * @author douglm
 *
 */
public class NsContext implements NamespaceContext {
  private static Map<String, String> keyPrefix = new HashMap<String, String>();
  private static Map<String, String> keyUri = new HashMap<String, String>();

  static {
    addToMap("D", "DAV");
    addToMap("C", "urn:ietf:params:xml:ns:caldav");
    addToMap("X", XcalTags.namespace);
    addToMap("df", "urn:ietf:params:xml:ns:pidf-diff");
    addToMap("xml", XMLConstants.XML_NS_URI);
    addToMap("xmlns", XMLConstants.XMLNS_ATTRIBUTE_NS_URI);
  }

  private String defaultNS;

  /** Constructor
   *
   * @param defaultNS
   */
  public NsContext(final String defaultNS) {
    this.defaultNS = defaultNS;
  }

  /**
   * @return default ns or null
   */
  public String getDefaultNS() {
    return defaultNS;
  }

  public String getNamespaceURI(final String prefix) {
    if ((prefix != null) && prefix.equals(XMLConstants.DEFAULT_NS_PREFIX)) {
      return defaultNS;
    }

    String uri = keyPrefix.get(prefix);

    if (uri == null) {
      return XMLConstants.NULL_NS_URI;
    }

    return uri;
  }

  public Iterator<String> getPrefixes(final String val) {
    String prefix = keyUri.get(val);
    Set<String> pfxs = new TreeSet<String>();

    if (prefix != null) {
      pfxs.add(prefix);
    }
    return pfxs.iterator();
  }

  /**
   * @return all prefixes
   */
  public Set<String> getPrefixes() {
    return keyPrefix.keySet();
  }

  /** Clear all items
   *
   */
  public void clear() {
    keyPrefix.clear();
    keyUri.clear();
    defaultNS = null;
  }

  /** Add a namespace to the maps
   *
   * @param prefix
   * @param uri
   */
  public void add(final String prefix, final String uri) {
    if (prefix == null) {
      defaultNS = uri;
    }

    addToMap(prefix, uri);
  }

  public String getPrefix(final String uri) {
    if ((defaultNS != null) && uri.equals(defaultNS)) {
      return XMLConstants.DEFAULT_NS_PREFIX;
    }

    return keyUri.get(uri);
  }

  /** Append the name with abbreviated namespace.
   *
   * @param sb
   * @param nm
   */
  public void appendNsName(final StringBuilder sb,
                           final QName nm) {
    String uri = nm.getNamespaceURI();
    String abbr;

    if ((defaultNS != null) && uri.equals(defaultNS)) {
      abbr = null;
    } else {
      abbr = keyUri.get(uri);
      if (abbr == null) {
        abbr = uri;
      }
    }

    if (abbr != null) {
      sb.append(abbr);
      sb.append(":");
    }

    sb.append(nm.getLocalPart());
  }

  private static void addToMap(final String prefix, final String uri) {
    keyPrefix.put(prefix, uri);
    keyUri.put(uri, prefix);
  }
}
