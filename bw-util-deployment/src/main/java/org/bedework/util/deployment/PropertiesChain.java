package org.bedework.util.deployment;

import org.bedework.util.misc.Util;

import java.util.ArrayDeque;
import java.util.Arrays;
import java.util.Deque;
import java.util.Iterator;
import java.util.List;
import java.util.Properties;
import java.util.Set;

/** Allow stacking of Property objects. Generally the bottom of the
 * stack is the full set of unmodified properties.
 *
 * <p>Further up are properties created by filtering the level below</p>
 *
 * <p>The second level will be ear specific and the third level will
 * be webapp specific</p>
 *
 * <p>The property name prefixes are
 * <ol>
 *   <li>org.bedework. - general global values</li>
 *   <li>org.bedework.global. - global values for ears/apps etc</li>
 *   <li>org.bedework.app.ear-name. - values for ears</li>
 *   <li>org.bedework.app.ear-name.webapp-name - values for webapps</li>
 * </ol></p>
 *
 * <p>To push a ear level set of properties we filter out all the
 * properties prefixed with "org.bedework.app.ear-name." and replace
 * that name substring with "app." </p>
 *
 * <p>To create a webapp level we filter the second level and add
 * every property matching "app.ear-name.webapp-name." to the new
 * collection with a name prefixed with "app."</p>
 *
 * <p>The "getExtended" method makes use of this structure. For example,
 * if we are setting the "security-domain" property in a file, that
 * file will have the property replacement pattern "${app.security-domain}"</p>
 *
 * <p>Assume we ae processing application caladmin in ear bwcal. If we
 * defined a property <br/>
 * org.bedework.app.bwcal.caladmin.security-domain=demo<br/>
 * This will be in the 3rd level set of properties as <br/>
 * app.security-domain=demo<br/>
 * and will match immediately.</p>
 *
 * <p>If in the properties we had defined a ear specific property<br/>
 * org.bedework.app.bwcal.security-domain=demo<br/>
 * that would have been translated into "app,security-domain" at
 * the second level so a match would be found there.
 * </p>
 *
 * <p>If no match is found at that level we replace the leading
 * "app." with "org.bedework.global." to search for the property
 * "org.bedework.global.security-domain"</p>
 *
 * <p>In this was we can define properties that are scoped to any level
 * </p>
 *
 * @author douglm
 */
public class PropertiesChain implements Util.PropertyFetcher {
  private final Deque<Properties> pstack = new ArrayDeque<>();

  public PropertiesChain copy() {
    final PropertiesChain pc = new PropertiesChain();

    final Iterator<Properties> i = pstack.descendingIterator();
    while (i.hasNext()) {
      pc.push(i.next());
    }

    return pc;
  }

  public void push(final Properties props) {
    pstack.push(props);
  }

  public void pop() {
    pstack.pop();
  }

  public Set<String> topNames() {
    return pstack.peek().stringPropertyNames();
  }

  @Override
  public String get(final String name) {
    String pname = name;
    int level = pstack.size();

    for (final Properties props: pstack) {
      if ((level == 1) && pname.startsWith("app.")) {
        pname = "org.bedework.global" + pname.substring(3);
      }

      final String s = props.getProperty(pname);
      if (s != null) {
        return Util.propertyReplace(s, this);
      }

      level--;
    }

    // Try for a system property

    return System.getProperty(name);
  }

  @SuppressWarnings("unused")
  public String getDeep(final String name) {
    for (final Properties props: pstack) {
      final String s = props.getProperty(name);
      if (s != null) {
        return Util.propertyReplace(s, this);
      }
    }

    return null;
  }

  public List<String> listProperty(final String pname) {
    final String pval = get(pname);

    if (pval == null) {
      return null;
    }

    final String[] pvals = pval.split(",");

    if (pvals.length == 0) {
      return null;
    }

    return Arrays.asList(pvals);
  }

  public String replace(final String s) {
    if (s == null) {
      return null;
    }

    return Util.propertyReplace(s, this);
  }

  public void pushFiltered(final String prefix,
                           final String newPrefix) {
    push(Utils.filter(pstack.peek(), prefix, newPrefix));
  }
}
