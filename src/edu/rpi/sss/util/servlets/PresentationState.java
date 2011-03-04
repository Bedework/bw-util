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

import org.apache.log4j.Logger;

import java.io.Serializable;

import javax.servlet.http.HttpServletRequest;

/** This class holds the presentation state of servlet sessions.
 * We assume that we will want the same information for most of the
 * applications we build.
 *
 * @author Mike Douglass douglm@rpi.edu
 * @version 1.2 April 15th 2005
 */
public class PresentationState implements Serializable {
  /** Applications will save this in the session with this name
   */
  public static final String presentationAttrName =
           "edu.rpi.sss.util.action.presentationstate";

  /** The request name we expect. */
  private String appRootRequestName = "appRoot";

  /** appRoot is where we find web related static info used by the program,
     such as XSLT stylesheets.
   * This must be set to some valid value.
   */
  private String appRoot;

  /** browserResourceRoot is where we find web related static info used by the program,
     such as XSLT stylesheets.
   * This must be set to some valid value.
   */
  private String browserResourceRoot;

  /** The requet name we expect. */
  private String browserTypeRequestName = "browserType";

  /** Set to the current or preferred browser type.
   * If browserTypeSticky is true we set the form browser type from this.
   * Otherwise we set this field from the form.
   */
  private String browserType;

  /** The requet name we expect. */
  private String browserTypeStickyRequestName = "browserTypeSticky";

  /** If true we set the form browser type from the browserType here.
   * Otherwise we set the browser type here from the form.
   */
  private boolean browserTypeSticky;

  /** The requet name we expect. */
  private String contentTypeRequestName = "contentType";

  /** One shot content type.
   */
  private String contentType;

  /** The requet name we expect. */
  private String contentTypeStickyRequestName = "contentTypeSticky";

  /** If true we set the content type from the contentType here.
   * Otherwise we set it according to the real type.
   */
  private boolean contentTypeSticky;

  /** The requet name we expect. */
  private String contentNameRequestName = "contentName";

  /** One shot content name.
   */
  private String contentName;

  /** The requet name we expect. */
  private String skinNameRequestName = "skinName";

  /** This should probably be a user and/or application attribute of some kind
   */
  private String skinName = "default";

  /** The requet name we expect. */
  private String skinNameStickyRequestName = "skinNameSticky";

  /** If true we set the skin-name from the skinName here.
   */
  private boolean skinNameSticky;

  /** Refresh xslt will be determined by the calue of this parameter
   */
  private String refreshXSLTRequestName = "refreshXslt";

  /** true to force one shot refresh
   */
  private boolean forceXSLTRefresh = false;

  /** true to force refresh every time
   */
  private boolean forceXSLTRefreshAlways = false;

  /** The requet name we expect. */
  private String noXSLTRequestName = "noxslt";

  /** true to force one shot no xslt
   */
  private boolean noXSLT = false;

  /** The requet name we expect. */
  private String noXSLTStickyRequestName = "noxsltSticky";

  /** true to force no xslt
   */
  private boolean noXSLTSticky = false;

  /* ====================================================================
             Properties methods
     ==================================================================== */

  /** Set the name
   *
   * @param val   String request name
   */
  public void setAppRootRequestName(final String val) {
    appRootRequestName = val;
  }

  /** get the name
   *
   * @return String    request name
   */
  public String getAppRootRequestName() {
    return appRootRequestName;
  }

  /**
   * @param val
   */
  public void setAppRoot(final String val) {
    appRoot = val;
  }

  /**
   * @return where we find the stylesheets
   */
  public String getAppRoot() {
    return appRoot;
  }

  /**
   * @param val
   */
  public void setBrowserResourceRoot(final String val) {
    browserResourceRoot = val;
  }

  /**
   * @return where we find the css etc
   */
  public String getBrowserResourceRoot() {
    return browserResourceRoot;
  }

  /* ====================================================================
             Browser type methods
     ==================================================================== */

  /** Set the name
   *
   * @param val   String request name
   */
  public void setBrowserTypeRequestName(final String val) {
    browserTypeRequestName = val;
  }

  /** get the name
   *
   * @return String    request name
   */
  public String getBrowserTypeRequestName() {
    return browserTypeRequestName;
  }

  /**
   * @param val
   */
  public void setBrowserType(final String val) {
    browserType = val;
  }

  /**
   * @return type of browser
   */
  public String getBrowserType() {
    return browserType;
  }

  /** Set the name
   *
   * @param val   String request name
   */
  public void setBrowserTypeStickyRequestName(final String val) {
    browserTypeStickyRequestName = val;
  }

  /** get the name
   *
   * @return String    request name
   */
  public String getBrowserTypeStickyRequestName() {
    return browserTypeStickyRequestName;
  }

  /**
   * @param val
   */
  public void setBrowserTypeSticky(final boolean val) {
    browserTypeSticky = val;
  }

  /**
   * @return sticky browser type
   */
  public boolean getBrowserTypeSticky() {
    return browserTypeSticky;
  }

  /** Allow user to explicitly set the browser type.
   *
   * @param request  Needed to locate parameters
   */
  public void checkBrowserType(final HttpServletRequest request) {
    String reqpar = request.getParameter(getBrowserTypeRequestName());

    if (reqpar != null) {
      if (reqpar.equals("!")) {
        // Go back to unsticky browser type
        setBrowserTypeSticky(false);
      } else {
        setBrowserType(reqpar);
        setBrowserTypeSticky(false);
      }
    }

    reqpar = request.getParameter(getBrowserTypeStickyRequestName());
    if (reqpar != null) {
      if (reqpar.equals("!")) {
        // Go back to unsticky browser type
        setBrowserTypeSticky(false);
      } else {
        setBrowserType(reqpar);
        setBrowserTypeSticky(true);
      }
    }
  }

  /* ====================================================================
             Content type methods
     ==================================================================== */

  /** Set the name
   *
   * @param val   String request name
   */
  public void setContentTypeRequestName(final String val) {
    contentTypeRequestName = val;
  }

  /** get the name
   *
   * @return String    request name
   */
  public String getContentTypeRequestName() {
    return contentTypeRequestName;
  }

  /**
   * @param val
   */
  public void setContentType(final String val) {
    contentType = val;
  }

  /**
   * @return current content type
   */
  public String getContentType() {
    return contentType;
  }

  /** Set the name
   *
   * @param val   String request name
   */
  public void setContentTypeStickyRequestName(final String val) {
    contentTypeStickyRequestName = val;
  }

  /** get the name
   *
   * @return String    request name
   */
  public String getContentTypeStickyRequestName() {
    return contentTypeStickyRequestName;
  }

  /**
   * @param val
   */
  public void setContentTypeSticky(final boolean val) {
    contentTypeSticky = val;
  }

  /**
   * @return sticky (permanent) content type
   */
  public boolean getContentTypeSticky() {
    return contentTypeSticky;
  }

  /** Allow user to explicitly set the content type.
   *
   * @param request  Needed to locate session
   */
  public void checkContentType(final HttpServletRequest request) {
    String reqpar = request.getParameter(getContentTypeRequestName());

    if (reqpar != null) {
      if (reqpar.equals("!")) {
        // Go back to unsticky content type
        setContentTypeSticky(false);
      } else {
        setContentType(reqpar);
        setContentTypeSticky(false);
      }
    }

    reqpar = request.getParameter(getContentTypeStickyRequestName());
    if (reqpar != null) {
      if (reqpar.equals("!")) {
        // Go back to unsticky content type
        setContentTypeSticky(false);
      } else {
        setContentType(reqpar);
        setContentTypeSticky(true);
      }
    }
  }

  /* ====================================================================
             Content name methods
     ==================================================================== */

  /** Set the name
   *
   * @param val   String request name
   */
  public void setContentNameRequestName(final String val) {
    contentNameRequestName = val;
  }

  /** get the name
   *
   * @return String    request name
   */
  public String getContentNameRequestName() {
    return contentNameRequestName;
  }

  /**
   * @param val
   */
  public void setContentName(final String val) {
    contentName = val;
  }

  /**
   * @return name for downloaded content
   */
  public String getContentName() {
    return contentName;
  }

  /** Allow user to explicitly set the filename of the content.
   *
   * @param request  Needed to locate session
   */
  public void checkContentName(final HttpServletRequest request) {
    String reqpar = request.getParameter(getContentNameRequestName());

    // Set to null if not found.
    setContentName(reqpar);
  }

  /* ====================================================================
             Skin name methods
     ==================================================================== */

  /** Set the name
   *
   * @param val   String request name
   */
  public void setSkinNameRequestName(final String val) {
    skinNameRequestName = val;
  }

  /** get the name
   *
   * @return String    request name
   */
  public String getSkinNameRequestName() {
    return skinNameRequestName;
  }

  /**
   * @param val
   */
  public void setSkinName(final String val) {
    skinName = val;
  }

  /**
   * @return skin name
   */
  public String getSkinName() {
    return skinName;
  }

  /** Set the name
   *
   * @param val   String request name
   */
  public void setSkinNameStickyRequestName(final String val) {
    skinNameStickyRequestName = val;
  }

  /** get the name
   *
   * @return String    request name
   */
  public String getSkinNameStickyRequestName() {
    return skinNameStickyRequestName;
  }

  /**
   * @param val
   */
  public void setSkinNameSticky(final boolean val) {
    skinNameSticky = val;
  }

  /**
   * @return sticky skin name
   */
  public boolean getSkinNameSticky() {
    return skinNameSticky;
  }

  /** Allow user to explicitly set the skin name.
   *
   * @param request  Needed to locate session
   */
  public void checkSkinName(final HttpServletRequest request) {
    String reqpar = request.getParameter(getSkinNameRequestName());

    if (reqpar != null) {
      if (reqpar.equals("!")) {
        // Go back to unsticky SkinName
        setSkinNameSticky(false);
      } else {
        setSkinName(reqpar);
        setSkinNameSticky(false);
      }
    }

    reqpar = request.getParameter(getSkinNameStickyRequestName());
    if (reqpar != null) {
      if (reqpar.equals("!")) {
        // Go back to unsticky SkinName
        setSkinNameSticky(false);
      } else {
        setSkinName(reqpar);
        setSkinNameSticky(true);
      }
    }
  }

  /* ====================================================================
             Refresh XSLT methods
     ==================================================================== */

  /** Set the name of refreshXslt request parameter
   *
   * @param val   String request name
   */
  public void setRefreshXSLTRequestName(final String val) {
    refreshXSLTRequestName = val;
  }

  /** get the name
   *
   * @return String    request name
   */
  public String getRefreshXSLTRequestName() {
    return refreshXSLTRequestName;
  }

  /** force xslt refresh on ALL clients
   *
   * @param val
   */
  public void setForceXSLTRefresh(final boolean val) {
    forceXSLTRefresh = val;
  }

  /**
   * @return current state of force xslt refresh
   */
  public boolean getForceXSLTRefresh() {
    return forceXSLTRefresh;
  }

  /** force xslt refresh on ALL clients EVERY request
   *
   * @param val
   */
  public void setForceXSLTRefreshAlways(final boolean val) {
    forceXSLTRefreshAlways = val;
  }

  /**
   * @return sticky force xslt refresh
   */
  public boolean getForceXSLTRefreshAlways() {
    return forceXSLTRefreshAlways;
  }

  /** Allow user to indicate how we should refresh the xslt.
   *
   * @param request  Needed to locate session
   */
  public void checkRefreshXslt(final HttpServletRequest request) {
    String reqpar = request.getParameter(getRefreshXSLTRequestName());

    if (reqpar == null) {
      return;
    }

    if (reqpar.equals("yes")) {
      setForceXSLTRefresh(true);
    }

    if (reqpar.equals("always")) {
      setForceXSLTRefreshAlways(true);
    }

    if (reqpar.equals("!")) {
      setForceXSLTRefreshAlways(false);
    }
  }

  /* ====================================================================
             No xslt methods
     ==================================================================== */

  /** Set the name
   *
   * @param val   String request name
   */
  public void setNoXSLTRequestName(final String val) {
    noXSLTRequestName = val;
  }

  /** get the name
   *
   * @return String    request name
   */
  public String getNoXSLTRequestName() {
    return noXSLTRequestName;
  }

  /**
   * @param val
   */
  public void setNoXSLT(final boolean val) {
    noXSLT = val;
  }

  /**
   * @return true for noxslt transforms
   */
  public boolean getNoXSLT() {
    return noXSLT;
  }

  /** Set the name
   *
   * @param val   String request name
   */
  public void setNoXSLTStickyRequestName(final String val) {
    noXSLTStickyRequestName = val;
  }

  /** get the name
   *
   * @return String    request name
   */
  public String getNoXSLTStickyRequestName() {
    return noXSLTStickyRequestName;
  }

  /**
   * @param val
   */
  public void setNoXSLTSticky(final boolean val) {
    noXSLTSticky = val;
  }

  /**
   * @return true for no xslt ever
   */
  public boolean getNoXSLTSticky() {
    return noXSLTSticky;
  }

  /** Allow user to suppress XSLT transform for one request.
   * Used for debugging - provides the raw xml.
   *
   * @param request  Needed to locate session
   */
  public void checkNoXSLT(final HttpServletRequest request) {
    String reqpar = request.getParameter(getNoXSLTRequestName());

    if (reqpar != null) {
      if (reqpar.equals("!")) {
        // Go back to unsticky noXslt
        setNoXSLTSticky(false);
      } else {
        setNoXSLT(true);
      }
    }

    reqpar = request.getParameter(getNoXSLTStickyRequestName());
    if (reqpar != null) {
      if (reqpar.equals("!")) {
        // Go back to unsticky noXslt
        setNoXSLTSticky(false);
      } else {
        setNoXSLT(true);
        setNoXSLTSticky(true);
      }
    }
  }

  /* ====================================================================
             Misc methods
     ==================================================================== */

  /**
   * @param title
   */
  public void debugDump(final String title) {
    debugDump(title, Logger.getLogger(this.getClass()));
  }

  /**
   * @param title
   * @param log
   */
  public void debugDump(final String title, final Logger log) {
    log.debug("------------- Presentation state: " + title +
                       " -------");
    log.debug("               AppRoot: " + appRoot);
    log.debug("   BrowserResourceRoot: " + browserResourceRoot);
    log.debug("           BrowserType: " + browserType);
    log.debug("           ContentType: " + contentType);
    log.debug("           ContentName: " + contentName);
    log.debug("                NoXSLT: " + noXSLT);
    log.debug("              SkinName: " + skinName);
    log.debug("      ForceXSLTRefresh: " + forceXSLTRefresh);
    log.debug("ForceXSLTRefreshAlways: " + forceXSLTRefreshAlways);

    log.debug("----------------------------------------");
  }
}

