/* **********************************************************************
    Copyright 2006 Rensselaer Polytechnic Institute. All worldwide rights reserved.

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

package edu.rpi.sss.util.jsp;

import edu.rpi.sss.util.log.MessageEmit;
import edu.rpi.sss.util.servlets.HttpServletUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.apache.log4j.Logger;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMessages;
import org.apache.struts.util.MessageResources;

/**
 * This class provides some convenience methods for use by ActionForm objects.
 * It shoudl really be called StrutsUtil
 *
 * @author Mike Douglass
 */
public class JspUtil extends HttpServletUtils {
  private JspUtil() throws Exception {} // No instantiation

  /** ================ Properties methods ============== */

  /** Return a property value or the default
   *
   * @param msg      MessageResources object
   * @param pname    String name of the property
   * @param def      String default value
   * @return String  property value or default (may be null)
   * @throws Throwable
   */
  public static String getProperty(MessageResources msg,
                                   String pname,
                                   String def) throws Throwable {
    String p = msg.getMessage(pname);
    if (p == null) {
      return def;
    }

    return p;
  }

  /** Return a required property value
   *
   * @param msg      MessageResources object
   * @param pname    name of the property
   * @return String  property value
   * @throws Throwable
   */
  public static String getReqProperty(MessageResources msg,
                                      String pname) throws Throwable {
    String p = getProperty(msg, pname, null);
    if (p == null) {
      getLogger().error("No definition for property " + pname);

      throw new Exception(": No definition for property " + pname);
    }

    return p;
  }

  /** Return a boolean property value or the default
   *
   * @param msg      MessageResources object
   * @param pname    String name of the property
   * @param def      boolean default value
   * @return boolean property value or default
   * @throws Throwable
   */
  public static boolean getBoolProperty(MessageResources msg,
                                        String pname,
                                        boolean def) throws Throwable {
    String p = msg.getMessage(pname);
    if (p == null) {
      return def;
    }

    return Boolean.valueOf(p).booleanValue();
  }

  /** Return an int property value or the default
   *
   * @param msg      MessageResources object
   * @param pname    String name of the property
   * @param def      int default value
   * @return int     property value or default
   * @throws Throwable
   */
  public static int getIntProperty(MessageResources msg,
                                   String pname,
                                   int def) throws Throwable {
    String p = msg.getMessage(pname);
    if (p == null) {
      return def;
    }

    return Integer.valueOf(p).intValue();
  }

  /* ==================================================================
                      Error object
     ================================================================== */

  /** Get the error object. If we haven't already got one and
   * getErrorObjAttrName returns non-null create one and implant it in
   * the session.
   *
   * @param id       Identifying string for messages
   * @param caller   Used for log4j identification
   * @param request  Needed to locate session
   * @param messages MessageResources object for creating new object
   * @param errorObjAttrName  name of session attribute
   * @param errProp  name of exception message property
   * @param noActionErrors
   * @param clear
   * @param debug
   * @return MessageEmit null on failure
   */
  public static MessageEmit getErrorObj(String id,
                                        Object caller,
                                        HttpServletRequest request,
                                        MessageResources messages,
                                        String errorObjAttrName,
                                        String errProp,
                                        boolean noActionErrors,
                                        boolean clear,
                                        boolean debug) {
    if (errorObjAttrName == null) {
      // don't set
      return null;
    }

    HttpSession sess = request.getSession(false);

    if (sess == null) {
      getLogger().error("No session!!!!!!!");
      return null;
    }

    Object o = sess.getAttribute(errorObjAttrName);
    MessageEmit err = null;

    // Ensure it's initialised correctly
    if ((o != null) && (o instanceof ErrorEmitSvlt)) {
      if (noActionErrors || (((ErrorEmitSvlt)o).getErrors() != null)) {
        err = (MessageEmit)o;
      }
    }

    if (err == null) {
      err = new ErrorEmitSvlt(debug);
    }

    ActionErrors ae = null;
    if (!noActionErrors) {
      ae = new ActionErrors();
    }

    ((ErrorEmitSvlt)err).reinit(id, caller, messages, ae, errProp, clear);

    // Implant in session

    sess.setAttribute(errorObjAttrName, err);

    return err;
  }

  /** Get the existing error object from the session or null.
   *
   * @param request  Needed to locate session
   * @param errorObjAttrName  name of session attribute
   * @return MessageEmit null on none found
   */
  public static MessageEmit getErrorObj(HttpServletRequest request,
                                        String errorObjAttrName) {
    if (errorObjAttrName == null) {
      // don't set
      return null;
    }

    HttpSession sess = request.getSession(false);

    if (sess == null) {
      getLogger().error("No session!!!!!!!");
      return null;
    }

    Object o = sess.getAttribute(errorObjAttrName);
    if ((o != null) && (o instanceof MessageEmit)) {
      return (MessageEmit)o;
    }

    return null;
  }

  /* ==================================================================
                      Message object
     ================================================================== */

  /** Get the message object. If we haven't already got one and
   * getMessageObjAttrName returns non-null create one and implant it in
   * the session.
   *
   * @param id                Identifying string for messages
   * @param caller            Used for log4j identification
   * @param request           Needed to locate session
   * @param messages           MessageResources object for creating new object
   * @param messageObjAttrName  name of session attribute
   * @param errProp           name of exception message property
   * @param clear
   * @param debug
   * @return MessageEmit      null on failure
   */
  public static MessageEmit getMessageObj(String id,
                                          Object caller,
                                          HttpServletRequest request,
                                          MessageResources messages,
                                          String messageObjAttrName,
                                          String errProp,
                                          boolean clear,
                                          boolean debug) {
    if (messageObjAttrName == null) {
      // don't set
      return null;
    }

    HttpSession sess = request.getSession(false);

    if (sess == null) {
      getLogger().error("No session!!!!!!!");
      return null;
    }

    Object o = sess.getAttribute(messageObjAttrName);
    MessageEmit msg = null;

    // Ensure it's initialised correctly
    if ((o != null) && (o instanceof MessageEmitSvlt)) {
      if (((MessageEmitSvlt)o).getMessages() != null) {
        msg = (MessageEmit)o;
      }
    }

    if (msg == null) {
      msg = new MessageEmitSvlt(debug);
    }

    ((MessageEmitSvlt)msg).reinit(id, caller, messages, new ActionMessages(),
                                  errProp, clear);

    // Implant in session

    sess.setAttribute(messageObjAttrName, msg);

    return msg;
  }

  /** Get the existing message object from the session or null.
   *
   * @param request  Needed to locate session
   * @param messageObjAttrName  name of session attribute
   * @return MessageEmit null on none found
   */
  public static MessageEmit getMessageObj(HttpServletRequest request,
                                          String messageObjAttrName) {
    if (messageObjAttrName == null) {
      // don't set
      return null;
    }

    HttpSession sess = request.getSession(false);

    if (sess == null) {
      getLogger().error("No session!!!!!!!");
      return null;
    }

    Object o = sess.getAttribute(messageObjAttrName);
    if ((o != null) && (o instanceof MessageEmit)) {
      return (MessageEmit)o;
    }

    return null;
  }

  /**
   * @return Logger
   */
  public static Logger getLogger() {
    return Logger.getLogger(JspUtil.class);
  }
}

