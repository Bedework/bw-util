/* **********************************************************************
    Copyright 2008 Rensselaer Polytechnic Institute. All worldwide rights reserved.

    Redistribution and use of this distribution in source and binary forms,
    with or without modification, are permitted provided that:
       The above copyright notice and this permission notice appear in all
        copies and supporting documentation;

        The name, identifiers, and trademarks of Rensselaer Polytechnic
        Institute are not used in advertising or publicity without the
        express prior written permission of Rensselaer Polytechnic Institute;

    DISCLAIMER: The software is distributed" AS IS" without any express or
    implied warranty, including but not limited to, any implied warranties
    of merchantability or fitness for a particular purpose or any warrant)'
    of non-infringement of any current or pending patent rights. The authors
    of the software make no representations about the suitability of this
    software for any particular purpose. The entire risk as to the quality
    and performance of the software is with the user. Should the software
    prove defective, the user assumes the cost of all necessary servicing,
    repair or correction. In particular, neither Rensselaer Polytechnic
    Institute, nor the authors of the software are liable for any indirect,
    special, consequential, or incidental damages related to the software,
    to the maximum extent the law permits.
*/
package edu.rpi.sss.util;

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
 * @author Mike Douglass    douglm @ rpi.edu
 *
 */
public interface OptionsI extends Serializable {
  /** Called after object is created
   *
   * @param globalPrefix
   * @param appPrefix
   * @param optionsFile - path to file e.g. /properties/calendar/options.xml
   * @param outerTagName - surrounding tag in options file e.g. bedework-options
   * @param debug
   * @throws OptionsException
   */
  public void init(String globalPrefix,
                   String appPrefix,
                   String optionsFile,
                   String outerTagName,
                   boolean debug) throws OptionsException;

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
    public void addChild(OptionElement val) {
      getChildren().add(val);
    }
  }

  /**
   * @param is
   * @throws OptionsException
   */
  public void initFromStream(InputStream is) throws OptionsException;

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
