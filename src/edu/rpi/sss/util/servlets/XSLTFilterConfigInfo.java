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
package edu.rpi.sss.util.servlets;

import java.io.Serializable;
import java.util.Locale;

/** This is what affects the state of ConfiguredXSLTFilter.
 *
 * @author Mike Douglass douglm@rpi.edu
 * @version June 18th 2003
 */
public class XSLTFilterConfigInfo implements Serializable {
  /** appRoot does not get reset when the filter tries a default path.
   * This must be set to some valid value.
   */
  private String appRoot;

  /** Default values (for some)
   */

  /** Use this if we can't derive it from the system.
   */
  private static final String localeInfoDefaultDefault = "default";

  /** Try to obtain from Locale.getDefault()
   */
  private static final Locale localeDefault = Locale.getDefault();
  private static final String langDefault;
  private static final String countryDefault;

  //private static final String localeInfoDefault;
  static {
    langDefault = localeDefault.getLanguage();
    countryDefault = localeDefault.getCountry();

    //localeInfoDefault = makeLocale(langDefault, countryDefault);
  }

  private static final String localeInfoDefault = "default";
  private static final String browserTypeDefault = "default";
  private static final String skinNameDefault = "default";

  private String localeInfo = localeInfoDefault;
  private String browserType = browserTypeDefault;
  private String skinName = skinNameDefault;

  /** These don't take part in equality checks.
   */
  private boolean dontFilter;

  /** Should be set during call to obtainConfigInfo to force a reload
   * of the transformer
   */
  private boolean forceReload;

  private boolean reloadAlways;

  /** Will be set on call to updatedConfigInfo if the filter forced us
   * back to default locale.
   *
   * <p>The superclass should respond by preserving the values and
   * representing them on the next call to obtainConfigInfo.
   */
  private boolean forceDefaultLocale;

  /** Will be set on call to updatedConfigInfo if the filter forced us
   * back to default browser type.
   *
   * <p>The superclass should respond by preserving the values and
   * representing them on the next call to obtainConfigInfo.
   */
  private boolean forceDefaultBrowserType;

  /** Will be set on call to updatedConfigInfo if the filter forced us
   * back to default skin name.
   *
   * <p>The superclass should respond by preserving the values and
   * representing them on the next call to obtainConfigInfo.
   */
  private boolean forceDefaultSkinName;

  /** Content type may be set to force the content type to a certain value.
   * Normally it will be set by the transform.
   */
  private String contentType;

  /** Reset all defaults, used before setting current values.
   */
  public void reset() {
    localeInfo = localeInfoDefault;
    browserType = browserTypeDefault;
    skinName = skinNameDefault;
  }

  /**
   *
   */
  public void resetBrowserType() {
    browserType = browserTypeDefault;
  }

  /**
   *
   */
  public void resetSkinName() {
    skinName = skinNameDefault;
  }

  /* ====================================================================
             Properties methods
     ==================================================================== */

  /**
   * @param val
   */
  public void setAppRoot(String val) {
    appRoot = val;
  }

  /**
   * @return String app root for stylesheets
   */
  public String getAppRoot() {
    return appRoot;
  }

  /**
   * @param val
   */
  public void setLocaleInfo(String val) {
    localeInfo = val;
  }

  /**
   * @return locale
   */
  public String getLocaleInfo() {
    if (getForceDefaultLocale()) {
      return localeInfoDefault;
    }
    return localeInfo;
  }

  /**
   * @return default locale
   */
  public String getDefaultLocaleInfo() {
    return localeInfoDefault;
  }

  /**
   * @return default language
   */
  public String getDefaultLang() {
    return langDefault;
  }

  /**
   * @return default country
   */
  public String getDefaultCountry() {
    return countryDefault;
  }

  /**
   * @param val
   */
  public void setBrowserType(String val) {
    browserType = val;
  }

  /**
   * @return browser type
   */
  public String getBrowserType() {
    if (getForceDefaultBrowserType()) {
      return browserTypeDefault;
    }
    return browserType;
  }

  /**
   * @return default browser type
   */
  public String getDefaultBrowserType() {
    return browserTypeDefault;
  }

  /**
   * @param val
   */
  public void setSkinName(String val) {
    skinName = val;
  }

  /**
   * @return skin name
   */
  public String getSkinName() {
    if (getForceDefaultSkinName()) {
      return skinNameDefault;
    }
    return skinName;
  }

  /**
   * @return String default skin name
   */
  public String getDefaultSkinName() {
    return skinNameDefault;
  }

  /**
   * @param val
   */
  public void setDontFilter(boolean val) {
    dontFilter = val;
  }

  /**
   * @return true for no filtering
   */
  public boolean getDontFilter() {
    return dontFilter;
  }

  /**
   * @param val
   */
  public void setForceReload(boolean val) {
    forceReload = val;
  }

  /**
   * @return true to force reload
   */
  public boolean getForceReload() {
    return forceReload;
  }

  /**
   * @param val
   */
  public void setReloadAlways(boolean val) {
    reloadAlways = val;
  }

  /**
   * @return true to force reload always
   */
  public boolean getReloadAlways() {
    return reloadAlways;
  }

  /**
   * @param val
   */
  public void setForceDefaultLocale(boolean val) {
    forceDefaultLocale = val;
  }

  /**
   * @return true to force default locale
   */
  public boolean getForceDefaultLocale() {
    return forceDefaultLocale;
  }

  /**
   * @param val
   */
  public void setForceDefaultBrowserType(boolean val) {
    forceDefaultBrowserType = val;
  }

  /**
   * @return default browser type
   */
  public boolean getForceDefaultBrowserType() {
    return forceDefaultBrowserType;
  }

  /**
   * @param val
   */
  public void setForceDefaultSkinName(boolean val) {
    forceDefaultSkinName = val;
  }

  /**
   * @return default skin name
   */
  public boolean getForceDefaultSkinName() {
    return forceDefaultSkinName;
  }

  /**
   * @param val
   */
  public void setContentType(String val) {
    contentType = val;
  }

  /**
   * @return content type
   */
  public String getContentType() {
    return contentType;
  }

  /**
   * @param that
   */
  public void updateFrom(XSLTFilterConfigInfo that) {
    contentType = that.getContentType();
    appRoot = that.getAppRoot();
    localeInfo = that.getLocaleInfo();
    browserType = that.getBrowserType();
    skinName = that.getSkinName();
  }

  public int hashCode() {
    int i = String.valueOf(appRoot).hashCode() +
            String.valueOf(localeInfo).hashCode() +
            String.valueOf(browserType).hashCode() +
            String.valueOf(skinName).hashCode();

    return i;
  }

  /** If either the lang or country is null we provide a default value for
   * the whole locale. Otherwise we construct one.
   *
   * @param lang
   * @param country
   * @return locale
   */
  public static String makeLocale(String lang, String country) {
    if ((lang == null) || (lang.length() == 0)) {
      return localeInfoDefaultDefault;
    }

    if ((country == null) || (country.length() == 0)) {
      return localeInfoDefaultDefault;
    }

    return lang + "_" + country;
  }

  public boolean equals(Object o) {
    if (!(o instanceof XSLTFilterConfigInfo)) {
      return false;
    }

    if (o.hashCode() != this.hashCode()) {
      return false;
    }

    XSLTFilterConfigInfo that = (XSLTFilterConfigInfo)o;

    return isEqual(appRoot, that.appRoot) &&
           isEqual(localeInfo, that.localeInfo) &&
           isEqual(browserType, that.browserType) &&
           isEqual(skinName, that.skinName);
  }

  private boolean isEqual(String a, String b) {
    if (a == null) {
      return (b == null);
    }

    if (b == null) {
      return false;
    }

    return a.equals(b);
  }
}

