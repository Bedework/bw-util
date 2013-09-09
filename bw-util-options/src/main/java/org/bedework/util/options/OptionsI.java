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
package org.bedework.util.options;

import java.io.InputStream;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collection;

/** An interface delivering properties in an xml format.
 *
 * <p>The file we parse is resource on some provided path e.g.
 * "/properties/options.xml".
 *
 * <p>The approach is to allow something like:
 *
 * <pre>
 *   &lt;outer-tag-1&gt;
 *     &lt;org&gt;
 *       &lt;bedework&gt;
 *         &lt;global&gt;
 *           &lt;module&gt;
 *             &lt;user-ldap-group classname="org.bedework.calcore.ldap.LdapConfigProperties"&gt;
 *               &lt;initialContextFactory&gt;com.sun.jndi.ldap.LdapCtxFactory&lt;/initialContextFactory&gt;
 *               ...
 *             &lt;/user-ldap-group&gt;
 *           &lt;/module&gt;
 *         &lt;/global&gt;
 *         &lt;app&gt;
 *           ...
 *         &lt;/app&gt;
 *       &lt;/bedework&gt;
 *     &lt;/org&gt;
 *   &lt;/outer-tag-1&gt;
 * </pre>
 *
 * <p>The outer-tag name is provided as a parameter.
 *
 * <p>Then a call on get option for "org.bedework.module.user-ldap-group"
 * would return an object of class org.bedework.calcore.ldap.LdapConfigProperties.
 *
 * <p>Currently only String, int, Integer, boolean and Boolean parameter types
 * are supported for the setters.
 *
 * <p>Currently we're not supporting nested class definitions though it's not
 * such a stretch.
 *
 * @author Mike Douglass    douglm @ bedework.edu
 *
 */
public interface OptionsI extends Serializable {
  /** Called after object is created
   *
   * @param globalPrefix
   * @param appPrefix
   * @param optionsFile - path to file e.g. /properties/calendar/options.xml
   * @param outerTagName - surrounding tag in options file e.g. bedework-options
   * @throws OptionsException
   */
  public void init(String globalPrefix,
                   String appPrefix,
                   String optionsFile,
                   String outerTagName) throws OptionsException;

  /** Called after object is created
   *
   * @param globalPrefix
   * @param appPrefix
   * @param optionsFileStream -
   * @param outerTagName - surrounding tag in options file e.g. bedework-options
   * @throws OptionsException
   */
  public void init(String globalPrefix,
                   String appPrefix,
                   InputStream optionsFileStream,
                   String outerTagName) throws OptionsException;

  /** Just a restatement of the xml element
   *
   * @author Mike Douglass
   */
  public static class OptionElement {
    /** */
    public String name;

    /** */
    public boolean isValue;
    /** */
    public Object val;

    /** */
    public ArrayList<OptionElement> children;

    /**
     * @return Collection
     */
    public Collection<OptionElement> getChildren() {
      if (children == null) {
        children = new ArrayList<OptionElement>();
      }
      return children;
    }

    /** Add a child
     *
     * @param val OptionElement
     */
    public void addChild(final OptionElement val) {
      getChildren().add(val);
    }
  }

  /** Get names of children nodes -assumes unique path
   *
   * @param name String property name prefix
   * @return Collection<String>
   * @throws OptionsException
   */
  public Collection<String> getNames(String name) throws OptionsException;

  /** For a local object only return the parsed options.
   *
   * @return OptionElement
   */
  public OptionElement getOptions();

  /** Return current app prefix
   *
   * @return String app prefix
   */
  public String getAppPrefix();

  /** Get required property, throw exception if absent
   *
   * @param name String property name
   * @return Object value
   * @throws OptionsException
   */
  public Object getProperty(String name) throws OptionsException;

  /** Get optional property.
   *
   * @param name String property name
   * @return Object value
   * @throws OptionsException
   */
  public Object getOptProperty(String name) throws OptionsException;

  /** Return the String value of the named property.
   *
   * @param name String property name
   * @return String value of property
   * @throws OptionsException
   */
  public String getStringProperty(String name) throws OptionsException;

  /** Get optional property.
   *
   * @param name String property name
   * @return String value
   * @throws OptionsException
   */
  public String getOptStringProperty(String name) throws OptionsException;

  /** Return the value of the named property.
   *
   * @param name String property name
   * @return boolean value of property
   * @throws OptionsException
   */
  public boolean getBoolProperty(String name) throws OptionsException;

  /** Return the value of the named property.
   *
   * @param name String property name
   * @return int value of property
   * @throws OptionsException
   */
  public int getIntProperty(String name) throws OptionsException;

  /* ====================================================================
   *                 Methods returning global properties.
   * ==================================================================== */

  /** Get required global property, throw exception if absent
   *
   * @param name String property name
   * @return Object value
   * @throws OptionsException
   */
  public Object getGlobalProperty(String name) throws OptionsException;

  /** Get required global property, throw exception if absent
   *
   * @param name String property name
   * @return String value
   * @throws OptionsException
   */
  public String getGlobalStringProperty(String name) throws OptionsException;

  /** Return the value of the named property or false if absent.
   *
   * @param name String unprefixed name
   * @return boolean value of global property
   * @throws OptionsException
   */
  public boolean getGlobalBoolProperty(String name) throws OptionsException;

  /** Return the value of the named property.
   *
   * @param name String unprefixed name
   * @return int value of global property
   * @throws OptionsException
   */
  public int getGlobalIntProperty(String name) throws OptionsException;

  /* ====================================================================
   *                 Methods returning application properties.
   * ==================================================================== */

  /** Get required app property, throw exception if absent
   *
   * @param name String property name
   * @return Object value
   * @throws OptionsException
   */
  public Object getAppProperty(String name) throws OptionsException;

  /** Get required app property, throw exception if absent
   *
   * @param name String property name
   * @return String value
   * @throws OptionsException
   */
  public String getAppStringProperty(String name) throws OptionsException;

  /** Get optional app property.
   *
   * @param name String property name
   * @return Object value or null
   * @throws OptionsException
   */
  public Object getAppOptProperty(String name) throws OptionsException;

  /** Get optional app property.
   *
   * @param name String property name
   * @return String value or null
   * @throws OptionsException
   */
  public String getAppOptStringProperty(String name) throws OptionsException;

  /** Return the value of the named property or false if absent.
   *
   * @param name String unprefixed name
   * @return boolean value of global property
   * @throws OptionsException
   */
  public boolean getAppBoolProperty(String name) throws OptionsException;

  /** Return the value of the named property.
   *
   * @param name String unprefixed name
   * @return int value of global property
   * @throws OptionsException
   */
  public int getAppIntProperty(String name) throws OptionsException;

  /** For a local object only set the value in the named option object.
   *
   * @param optionObjectName
   * @param optionName
   * @param val
   * @throws OptionsException
   */
  public void setValue(String optionObjectName,
                       String optionName,
                       Object val) throws OptionsException;

  /** For a local object only get the value from the named option object.
   *
   * @param optionObjectName
   * @param optionName
   * @return Object
   * @throws OptionsException
   */
  public Object getValue(String optionObjectName,
                         String optionName) throws OptionsException;
}
