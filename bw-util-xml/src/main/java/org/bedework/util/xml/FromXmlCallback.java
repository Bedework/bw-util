/* ********************************************************************
    Appropriate copyright notice
*/
package org.bedework.util.xml;

import org.w3c.dom.Element;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;

/**
 * User: mike
 * Date: 10/25/16
 * Time: 15:41
 */
@SuppressWarnings({"UnusedParameters", "unused"})
public class FromXmlCallback {
  private final Map<String, Class> classForName = new HashMap<>();

  private final Set<String> skipThese = new TreeSet<>();

  private final Map<String, String> mapFields = new HashMap<>();

  /** Called to get the object for a complex element.
   *
   * @param el element representing object
   * @return Class of object to restore
   * @throws Throwable on error
   */
  public Class forElement(final Element el) throws Throwable {
    return classForName.get(el.getTagName());
  }

  public void addClassForName(final String name,
                              final Class cl) {
    classForName.put(name, cl);
  }

  public void addMapField(final String from,
                          final String to) {
    mapFields.put(from, to);
  }
  
  public String mappedField(final String from) {
    return mapFields.get(from);
  }

  /**
   *
   * @param cl of Value we are restoring
   * @param val String representation of the value
   * @return Object of given class or null
   * @throws Throwable opn error
   */
  public Object simpleValue(final Class cl,
                            final String val) throws Throwable {
    return null;
  }

  /** Called to check if element should be skipped. This implementation
   * presumes we are ignoring namespaces.
   *
   * @param el the element
   * @return true to skip this one
   * @throws Throwable on error
   */
  public boolean skipElement(final Element el) throws Throwable {
    return skipThese.contains(el.getTagName());
  }

  public void addSkips(final String... names) {
    Collections.addAll(skipThese, names);
  }

  /** Called to get the field name given the element, e.g
   * an element with name the-field may be for a field with 
   * the name theField
   *
   * @param el element representing object
   * @return String name or null for default
   * @throws Throwable on error
   */
  public String getFieldlName(final Element el) throws Throwable {
    return mappedField(el.getNodeName());
  }

  /** Save the value in the object. Return false for default
   * behavior. Only called for object classes not recognized
   * or for which no setter can be found.
   *
   * @param el XML element
   * @param theObject to save into 
   * @param theValue to be saved
   * @return true if saved
   * @throws Throwable on erro
   */
  public boolean save(final Element el,
                      final Object theObject,
                      final Object theValue) throws Throwable {
    return false;
  }
}
