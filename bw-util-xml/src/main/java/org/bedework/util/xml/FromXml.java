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

import org.bedework.base.exc.BedeworkException;
import org.bedework.util.logging.BwLogger;
import org.bedework.util.logging.Logged;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.xml.sax.InputSource;

import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.lang.reflect.Method;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.Collection;
import java.util.TreeSet;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

/** Methods for restoring classes from XML
 *
 * @author Mike Douglass
 */
public class FromXml implements Logged {
  private FromXmlCallback cb;
  
  /**
   * @param is input stream
   * @param cl class of object we want to restore
   * @return parsed object or null
   */
  public <T>T fromXml(final InputStream is,
                      final Class<T> cl,
                      final FromXmlCallback cb) {
    return fromXml(parseXml(is).getDocumentElement(), cl, cb);
  }

  public <T>T fromXml(final Element rootEl,
                      final Class<T> cl,
                      final FromXmlCallback cb) {
    try {
      if (cb == null) {
        this.cb = new FromXmlCallback();
      } else {
        this.cb = cb;
      }
      
      final Object o = fromClass(cl);

      if (o == null) {
        // Can't do this
        return null;
      }

      for (final Element el: XmlUtil.getElementsArray(rootEl)) {
        populate(el, o, null, null);
      }

      return (T)o;
    } catch (final Throwable t) {
      if (debug()) {
        error(t);
      }
      throw new BedeworkException(t);
    }
  }

  public static Document parseXml(final InputStream is) {
    return parseXml(new InputStreamReader(is));
  }

  public static Document parseXml(final Reader in) {
    final DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
    factory.setNamespaceAware(true);

    try {
      final DocumentBuilder builder = factory.newDocumentBuilder();

      return builder.parse(new InputSource(in));
    } catch (final Throwable t) {
      throw new BedeworkException(t);
    }
  }

  /* ========================================================
   *                   Private from xml methods
   * ======================================================== */

  private Object fromClass(final Class<?> cl) {
    if (cl == null) {
      error("Must supply a class or have type attribute");
      return null;
    }

    try {
      return cl.getConstructor().newInstance();
    } catch (final Throwable t) {
      throw new BedeworkException(t);
    }
  }

  /** Populate either the object o via setters or the Collection col by adding
   * elements of type cl
   *
   * @param o the object
   * @param subroot of XML data
   * @param col a collection
   * @param cl the class
   */
  private void populate(final Element subroot,
                        final Object o,
                        final Collection<Object> col,
                        final Class<?> cl) {
    if (cb.skipElement(subroot)) {
      return;
    }
    
    Method meth = null;

    var elClass = cb.forElement(subroot);

    if (col == null) {
      /* We must have a setter */
      meth = findSetter(o, subroot);

      if (meth == null) {
        error("No setter for " + subroot);

        return;
      }

      /* We require a single parameter */

      final var parClasses = meth.getParameterTypes();
      if (parClasses.length != 1) {
        error("Invalid setter method " + subroot);
        throw new BedeworkException(
            "Invalid setter method " + subroot);
      }

      elClass = parClasses[0];
    } else if (cl != null) {
      elClass = cl;
    }

    if (elClass == null) {
      error("No class for element " + subroot);
      return;
    }
    
    if (!XmlUtil.hasChildren(subroot)) {
      /* A primitive value for which we should have a setter */

      final Object val = simpleValue(elClass, subroot);
      if (val == null) {
        error("Unsupported par class " + elClass +
              " for field " + subroot);
        throw new BedeworkException(
            "Unsupported par class " + elClass +
                " for field " + subroot);
      }

      assign(val, subroot, col, o, meth);

      return;
    }

    /* There are children to this element. It either represents a complex type
     * or a collection.
     */

    if (Collection.class.isAssignableFrom(elClass)) {
      final Collection<Object> colVal;

      switch (elClass.getName()) {
        case "java.util.Set" -> colVal = new TreeSet<>();
        case "java.util.List", "java.util.Collection" ->
            colVal = new ArrayList<>();
        default -> {
          error("Unsupported element class " + elClass +
                    " for field " + subroot);
          return;
        }
      }

      assign(colVal, subroot, col, o, meth);

      // Figure out the class of the elements
      /* I thought I might be able to extract it from the generic info -
       * Doesn't appear to be the case.
       */

      final Type[] gpts = meth.getGenericParameterTypes();

      /* Should only be one parameter */
      if (gpts.length != 1) {
        error("Unsupported type " + elClass +
                      " with name " + subroot);
        return;
      }

      final var gpt = gpts[0];

      if (!(gpt instanceof final ParameterizedType aType)) {
        error("Unsupported type " + elClass +
                      " with name " + subroot);
        return;
      }

      final var parameterArgTypes = aType.getActualTypeArguments();

      /* Should only be one arg */
      if (parameterArgTypes.length != 1) {
        error("Unsupported type " + elClass +
                      " with name " + subroot);
        return;
      }

      final var parameterArgType = parameterArgTypes[0];

      final var colElType = (Class<?>)parameterArgType;
      /*/
      ConfInfo ci = meth.getAnnotation(ConfInfo.class);

      String colElTypeName;

      if (ci == null) {
        colElTypeName = "java.lang.String";
      } else {
        colElTypeName = ci.elementType();
      }
      */

      for (final var el: XmlUtil.getElementsArray(subroot)) {
        populate(el, o, colVal, /*Class.forName(colElTypeName)*/colElType);
      }

      return;
    }

    /* Asssume a complex type */

    final Object val = fromClass(elClass);

    assign(val, subroot, col, o, meth);

    for (final var el: XmlUtil.getElementsArray(subroot)) {
      populate(el, val, null, null);
    }
  }

  private Method findSetter(final Object val,
                            final Element el) {
    String name = cb.getFieldlName(el);
    if (name == null) {
      name = el.getNodeName();
    } 

    final String methodName = "set" + name.substring(0, 1).toUpperCase() +
                        name.substring(1);
    final Method[] meths = val.getClass().getMethods();
    Method meth = null;

    for (final Method m : meths) {
      if (m.getName().equals(methodName)) {
        if (meth != null) {
          throw new BedeworkException(
                  "Multiple setters for field " + el);
        }
        meth = m;
      }
    }

    if (meth == null) {
      error("No setter method for property " + el +
                    " for class " + val.getClass().getName());
      return null;
    }

    return meth;
  }

  /** Assign a value - either to collection col or to a setter of o defined by meth
   * 
   * @param val the value
   * @param el the element for the current node
   * @param col - if non-null add to this.
   * @param o the object
   * @param meth the method
   */
  private void assign(final Object val,
                             final Element el,
                             final Collection<Object> col,
                             final Object o,
                             final Method meth)  {
    if (col != null) {
      col.add(val);
    } else if (!cb.save(el, o, val)) {
      try {
        meth.invoke(o, val);
      } catch (final Throwable t) {
        throw new BedeworkException(t);
      }
    }
  }

  private Object simpleValue(final Class<?> cl,
                             final Element el) {
    if (!XmlUtil.hasChildren(el)) {
      /* A primitive value for which we should have a setter */
      final String ndval = XmlUtil.getElementContent(el);

      return switch (cl.getName()) {
        case "java.lang.String" -> ndval;
        case "int", "java.lang.Integer" -> Integer.valueOf(ndval);
        case "long", "java.lang.Long" -> Long.valueOf(ndval);
        case "boolean", "java.lang.Boolean" -> Boolean.valueOf(ndval);
        default ->
          // XXX Should do byte, char, short, float, and double.
            cb.simpleValue(cl, ndval);
      };

    }

    // Complex value
    return null;
  }

  /* ====================================================================
   *                   Logged methods
   * ==================================================================== */

  private final BwLogger logger = new BwLogger();

  @Override
  public BwLogger getLogger() {
    if ((logger.getLoggedClass() == null) && (logger.getLoggedName() == null)) {
      logger.setLoggedClass(getClass());
    }

    return logger;
  }
}
