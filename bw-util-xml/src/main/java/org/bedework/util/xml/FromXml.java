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

import org.bedework.util.misc.Logged;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import java.io.InputStream;
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
public class FromXml extends Logged {
  /**
   * @param is input stream
   * @param cl class of object we want to restore
   * @return parsed object or null
   * @throws org.xml.sax.SAXException
   */
  public Object fromXml(final InputStream is,
                        final Class cl) throws SAXException {
    try {
      final Document doc = parseXml(is);

      final Object o = fromClass(cl);

      if (o == null) {
        // Can't do this
        return null;
      }

      for (final Element el: XmlUtil.getElementsArray(doc.getDocumentElement())) {
        populate(el, o, null, null);
      }

      return o;
    } catch (final SAXException se) {
      if (debug) {
        error(se);
      }
      throw se;
    } catch (final Throwable t) {
      if (debug) {
        error(t);
      }
      throw new SAXException(t.getMessage());
    }
  }

  public Object fromXml(final Element rootEl,
                        final Class cl) throws SAXException {
    try {
      final Object o = fromClass(cl);

      if (o == null) {
        // Can't do this
        return null;
      }

      for (final Element el: XmlUtil.getElementsArray(rootEl)) {
        populate(el, o, null, null);
      }

      return o;
    } catch (final SAXException se) {
      if (debug) {
        error(se);
      }
      throw se;
    } catch (final Throwable t) {
      if (debug) {
        error(t);
      }
      throw new SAXException(t.getMessage());
    }
  }

  public Document parseXml(final InputStream is) throws Throwable {
    final DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
    factory.setNamespaceAware(true);

    final DocumentBuilder builder = factory.newDocumentBuilder();

    final Document doc = builder.parse(new InputSource(is));

    if (doc == null) {
      return null;
    }

    return doc;
  }

  /* ====================================================================
   *                   Private from xml methods
   * ==================================================================== */

  private Object fromClass(final Class cl) throws Throwable {
    if (cl == null) {
      error("Must supply a class or have type attribute");
      return null;
    }

    return cl.newInstance();
  }

  /** Populate either the object o via setters or the Collection col by adding
   * elements of type cl
   *
   * @param o the object
   * @param subroot of XML data
   * @param col a collection
   * @param cl the class
   * @throws Throwable
   */
  private void populate(final Element subroot,
                        final Object o,
                        final Collection<Object> col,
                        final Class cl) throws Throwable {
    final String name = subroot.getNodeName();

    Method meth = null;

    final Class elClass;

    if (col == null) {
      /* We must have a setter */
      meth = findSetter(o, name);

      if (meth == null) {
        error("No setter for " + name);

        return;
      }

      /* We require a single parameter */

      final Class[] parClasses = meth.getParameterTypes();
      if (parClasses.length != 1) {
        error("Invalid setter method " + name);
        throw new SAXException("Invalid setter method " + name);
      }

      elClass = parClasses[0];
    } else {
      elClass = cl;
    }

    if (!XmlUtil.hasChildren(subroot)) {
      /* A primitive value for which we should have a setter */

      final Object val = simpleValue(elClass, subroot);
      if (val == null) {
        error("Unsupported par class " + elClass +
              " for field " + name);
        throw new SAXException("Unsupported par class " + elClass +
                                  " for field " + name);
      }

      assign(val, col, o, meth);

      return;
    }

    /* There are children to this element. It either represents a complex type
     * or a collection.
     */

    if (Collection.class.isAssignableFrom(elClass)) {
      final Collection<Object> colVal;

      if (elClass.getName().equals("java.util.Set")) {
        colVal = new TreeSet<>();
      } else if (elClass.getName().equals("java.util.List")) {
        colVal = new ArrayList<>();
      } else {
        error("Unsupported element class " + elClass +
              " for field " + name);
        return;
      }

      assign(colVal, col, o, meth);

      // Figure out the class of the elements
      /* I thought I might be able to extract it from the generic info -
       * Doesn't appear to be the case.
       */

      final Type[] gpts = meth.getGenericParameterTypes();

      /* Should only be one parameter */
      if (gpts.length != 1) {
        error("Unsupported type " + elClass +
                      " with name " + name);
        return;
      }

      final Type gpt = gpts[0];

      if (!(gpt instanceof ParameterizedType)) {
        error("Unsupported type " + elClass +
                      " with name " + name);
        return;
      }

      final ParameterizedType aType = (ParameterizedType)gpt;

      final Type[] parameterArgTypes = aType.getActualTypeArguments();

      /* Should only be one arg */
      if (parameterArgTypes.length != 1) {
        error("Unsupported type " + elClass +
                      " with name " + name);
        return;
      }

      final Type parameterArgType = parameterArgTypes[0];

      final Class colElType = (Class)parameterArgType;
      /*/
      ConfInfo ci = meth.getAnnotation(ConfInfo.class);

      String colElTypeName;

      if (ci == null) {
        colElTypeName = "java.lang.String";
      } else {
        colElTypeName = ci.elementType();
      }
      */

      for (final Element el: XmlUtil.getElementsArray(subroot)) {
        populate(el, o, colVal, /*Class.forName(colElTypeName)*/colElType);
      }

      return;
    }

    /* Asssume a complex type */

    final Object val = fromClass(elClass);

    assign(val, col, o, meth);

    for (final Element el: XmlUtil.getElementsArray(subroot)) {
      populate(el, val, null, null);
    }
  }

  private Method findSetter(final Object val,
                            final String name) throws Throwable {
    final String methodName = "set" + name.substring(0, 1).toUpperCase() +
                        name.substring(1);
    final Method[] meths = val.getClass().getMethods();
    Method meth = null;

    for (final Method m : meths) {
      if (m.getName().equals(methodName)) {
        if (meth != null) {
          throw new SAXException(
                  "Multiple setters for field " + name);
        }
        meth = m;
      }
    }

    if (meth == null) {
      error("No setter method for property " + name +
                    " for class " + val.getClass().getName());
      return null;
    }

    return meth;
  }

  /** Assign a value - either to collection col or to a setter of o defined by meth
   * @param val the vlue
   * @param col - if non-null add to this.
   * @param o the object
   * @param meth the method
   * @throws Throwable
   */
  private static void assign(final Object val,
                             final Collection<Object> col,
                             final Object o,
                             final Method meth) throws Throwable {
    if (col != null) {
      col.add(val);
    } else {
      final Object[] pars = new Object[]{val};

      meth.invoke(o, pars);
    }
  }

  private static Object simpleValue(final Class cl,
                                    final Element el) throws Throwable {
    if (!XmlUtil.hasChildren(el)) {
      /* A primitive value for which we should have a setter */
      final String ndval = XmlUtil.getElementContent(el);

      if (cl.getName().equals("java.lang.String")) {
        return ndval;
      }

      if (cl.getName().equals("int") ||
          cl.getName().equals("java.lang.Integer")) {
        return Integer.valueOf(ndval);
      }

      if (cl.getName().equals("long") ||
          cl.getName().equals("java.lang.Long")) {
        return Long.valueOf(ndval);
      }

      if (cl.getName().equals("boolean") ||
          cl.getName().equals("java.lang.Boolean")) {
        return Boolean.valueOf(ndval);
      }


      // XXX Should do byte, char, short, float, and double.
      return null;
    }

    // Complex value
    return null;
  }
}
