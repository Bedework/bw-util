/* **********************************************************
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
package org.bedework.util.properties;

import org.bedework.base.exc.BedeworkException;

import java.util.Properties;

public class PropertyUtil {

  /** Replaces placeholders with a property value if it exists.
   * <h3>Examples:</h3>
   * <h4>Example: No placeHolders - returns unchanged</h4>
   * <pre>
   * x = Test the misc Util classes
   *</pre>
   * propertyReplace("x", ...) will return
   * <pre>
   * "Test the misc Util classes"
   *</pre>
   *
   * <h4>Example: Known placeHolder - returns with substitution</h4>
   * <pre>
   * name1 = utility
   * x = Test the misc ${name1} classes
   *</pre>
   * propertyReplace("x", ...) will return
   * <pre>
   * "Test the misc utility classes"
   *</pre>
   *
   * <h4>Example: Unknown placeHolder - returns unchanged</h4>
   * <p>
   *   Leaving unknown placeholders unchanged allows further token
   *   replacement at a later stage.
   * </p>
   * <pre>
   * x = Test the misc ${name2} classes
   *</pre>
   * propertyReplace("x", ...) will return
   * <pre>
   * "Test the misc ${name2} classes"
   *</pre>
   *
   * <h4>Example: Known placeHolders - returns with substitution</h4>
   * <p>In this case <em>${name3}</em> will be replaced to
   * create <em>u${name4}y</em>, then ${name4} will be
   * replaced.
   * </p>
   * <pre>
   * name3 = u${name4}y
   * name4 = tilit
   * x = Test the misc ${name3} classes
   *                           },
   *</pre>
   * propertyReplace("x", ...) will return
   * <pre>
   * "Test the misc utility classes"
   *</pre>
   *
   * <h4>Example: Known placeHolders - returns with substitution</h4>
   * <p>In this case <em>${name6}</em> will be replaced to
   * create <em>${name5}</em>, which in turn will be
   * replaced.
   * </p>
   * <pre>
   * name5 = utility
   * name6= ame
   * x = Test the misc ${n${name6}5} classes
   *</pre>
   * propertyReplace("x", ...) will return
   * <pre>
   * "Test the misc utility classes"
   *</pre>
   *
   * <h4>Example: No ending <em>}</em> to placeHolders - returns unchanged</h4>
   * <pre>
   * x = Test the misc ${n${name6 classes"
   * name5 = utility
   * name6 = ame
   *</pre>
   * propertyReplace("x", ...) will return
   * <pre>
   * "Test the misc ${n${name6 classes"
   *</pre>
   *
   * @param val with possible placeholders
   * @param props property fetcher
   * @return value with placeholders filled
   */
  public static String propertyReplace(final String val,
                                       final PropertyFetcher props) {
    if (val == null) {
      return null;
    }

    int pos = val.indexOf("${");

    if (pos < 0) {
      return val;
    }

    final var sb = new StringBuilder(val.length());
    var segStart = 0;
    var changed = false;

    do {
      if (pos > 0) {
        sb.append(val, segStart, pos);
      }

      final int end = val.indexOf("}", pos);

      if (end < 0) {
        //No matching close. Just append rest and return.
        sb.append(val.substring(pos));
        break;
      }

      final var tokenName = val.substring(pos + 2, end);
      final var pval = props.get(tokenName.trim());

      if (pval != null) {
        sb.append(pval);
        changed = true;
        segStart = end + 1;
      } else {
        if (tokenName.contains("${")) {
          segStart = pos + 2;
          sb.append("${");
        } else {
          sb.append("${").append(tokenName).append("}");
          segStart = end + 1;
        }
      }

      if (segStart <= val.length()) {
        pos = val.indexOf("${", segStart);
      }
    } while ((segStart <= val.length()) && (pos >= 0));

    if (pos < 0) {
      //Done.
      sb.append(val.substring(segStart));
    }

    final var res = sb.toString();

    if (!changed) {
      return res;
    }

    return propertyReplace(res, props);
  }

  /** Load a named resource as a Properties object
   *
   * @param name    String resource name
   * @return Properties populated from the resource
   */
  public static Properties getPropertiesFromResource(
      final String name) {
    final var pr = new Properties();

    // The jboss?? way - should work for others as well.
    final var cl = Thread.currentThread()
                         .getContextClassLoader();
    var in = cl.getResourceAsStream(name);
    if (in == null) {
      // Try another way
      in = PropertyUtil.class.getResourceAsStream(name);
    }

    if (in == null) {
      throw new BedeworkException(
          "Unable to load properties file" + name);
    }

    try (final var is = in) {
      pr.load(is);
      return pr;
    } catch (final Throwable t) {
      if (t instanceof BedeworkException) {
        throw (BedeworkException)t;
      }

      throw new BedeworkException(t);
    }
  }
}
