/* **********************************************************************
    Copyright 2007 Rensselaer Polytechnic Institute. All worldwide rights reserved.

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

import edu.rpi.sss.util.Util;
import edu.rpi.sss.util.log.MessageEmit;
import edu.rpi.sss.util.servlets.HttpServletUtils;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionMapping;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/** Class to handle the incoming request.
 *
 * @author Mike Douglass
 */
public class Request implements Serializable {
  protected HttpServletRequest request;
  protected HttpServletResponse response;
  protected UtilActionForm form;
  protected Action action;

  /** */
  public final static int actionTypeUnknown = 0;
  /** */
  public final static int actionTypeRender = 1;
  /** */
  public final static int actionTypeAction = 2;
  /** */
  public final static int actionTypeResource = 3;

  /** */
  public final static String[] actionTypes = {"unknown",
                                              "render",
                                              "action",
                                              "resource"};

  protected int actionType;

  protected boolean errFlag;

  /**
   * @param request
   * @param response
   * @param form
   * @param action
   */
  public Request(HttpServletRequest request,
                 HttpServletResponse response,
                 UtilActionForm form,
                 Action action) {
    this.request = request;
    this.response = response;
    this.form = form;
    this.action = action;
  }

  /**
   * @return HttpServletRequest
   */
  public HttpServletRequest getRequest() {
    return request;
  }

  /**
   * @return HttpServletResponse
   */
  public HttpServletResponse getResponse() {
    return response;
  }

  /**
   * @return UtilActionForm
   */
  public UtilActionForm getForm() {
    return form;
  }

  /**
   * @return Action
   */
  public Action getAction() {
    return action;
  }

  /**
   * @return ActionMapping
   */
  public ActionMapping getMapping() {
    return form.getMapping();
  }

  /**
   * @return MessageEmit
   */
  public MessageEmit getErr() {
    errFlag = true;
    return form.getErr();
  }

  /**
   * @return boolean
   */
  public boolean getErrorsEmitted() {
    return errFlag || form.getErrorsEmitted();
  }

  /**
   * @param val
   */
  public void setErrFlag(boolean val) {
    errFlag = val;
  }

  /**
   * @return boolean
   */
  public boolean getErrFlag() {
    return errFlag;
  }

  /**
   * @param val
   */
  public void setActionType(int val) {
    actionType = val;
  }

  /**
   * @return int
   */
  public int getActionType() {
    return actionType;
  }

  /** Get a request parameter stripped of white space. Return null for zero
   * length.
   *
   * @param name    name of parameter
   * @return  String   value
   * @throws Throwable
   */
  public String getReqPar(String name) throws Throwable {
    return Util.checkNull(request.getParameter(name));
  }

  /** See if a request parameter is present
   *
   * @param name    name of parameter
   * @return  boolean true for present
   * @throws Throwable
   */
  public boolean present(String name) throws Throwable {
    return request.getParameter(name) != null;
  }

  /** See if a request parameter is present and not null or empty
   *
   * @param name    name of parameter
   * @return  boolean true for present and not null
   * @throws Throwable
   */
  public boolean notNull(String name) throws Throwable {
    return getReqPar(name) != null;
  }

  /** Get a multi-valued request parameter stripped of white space.
   * Return null for zero length.
   *
   * @param name    name of parameter
   * @return  Collection<String> or null
   * @throws Throwable
   */
  public Collection<String> getReqPars(String name) throws Throwable {
    String[] s = request.getParameterValues(name);
    ArrayList<String> res = null;

    if ((s == null) || (s.length == 0)) {
      return null;
    }

    for (String par: s) {
      par = Util.checkNull(par);
      if (par != null) {
        if (res == null) {
          res = new ArrayList<String>();
        }

        res.add(par);
      }
    }

    return res;
  }

  /** Get an Integer request parameter or null.
   *
   * @param name    name of parameter
   * @return  Integer   value or null
   * @throws Throwable
   */
  public Integer getIntReqPar(String name) throws Throwable {
    String reqpar = getReqPar(name);

    if (reqpar == null) {
      return null;
    }

    return Integer.valueOf(reqpar);
  }

  /** Get an Integer request parameter or null. Emit error for non-null and
   * non integer
   *
   * @param name    name of parameter
   * @param errProp
   * @return  Integer   value or null
   * @throws Throwable
   */
  public Integer getIntReqPar(String name,
                              String errProp) throws Throwable {
    String reqpar = getReqPar(name);

    if (reqpar == null) {
      return null;
    }

    try {
      return Integer.valueOf(reqpar);
    } catch (Throwable t) {
      getErr().emit(errProp, reqpar);
      return null;
    }
  }

  /** Get an integer valued request parameter.
   *
   * @param name    name of parameter
   * @param defaultVal
   * @return  int   value
   * @throws Throwable
   */
  public int getIntReqPar(String name,
                          int defaultVal) throws Throwable {
    String reqpar = getReqPar(name);

    if (reqpar == null) {
      return defaultVal;
    }

    try {
      return Integer.parseInt(reqpar);
    } catch (Throwable t) {
      return defaultVal; // XXX exception?
    }
  }

  /** Get a Long request parameter or null.
   *
   * @param name    name of parameter
   * @return  Long   value or null
   * @throws Throwable
   */
  public Long getLongReqPar(String name) throws Throwable {
    String reqpar = getReqPar(name);

    if (reqpar == null) {
      return null;
    }

    return Long.valueOf(reqpar);
  }

  /** Get an long valued request parameter.
   *
   * @param name    name of parameter
   * @param defaultVal
   * @return  long  value
   * @throws Throwable
   */
  public long getLongReqPar(String name,
                            long defaultVal) throws Throwable {
    String reqpar = getReqPar(name);

    if (reqpar == null) {
      return defaultVal;
    }

    try {
      return Long.parseLong(reqpar);
    } catch (Throwable t) {
      return defaultVal; // XXX exception?
    }
  }

  /** Get a boolean valued request parameter.
   *
   * @param name    name of parameter
   * @return  Boolean   value or null for absent parameter
   * @throws Throwable
   */
  public Boolean getBooleanReqPar(String name) throws Throwable {
    String reqpar = getReqPar(name);

    if (reqpar == null) {
      return null;
    }

    try {
      return Boolean.valueOf(reqpar);
    } catch (Throwable t) {
      return null; // XXX exception?
    }
  }

  /** Get a boolean valued request parameter giving a default value.
   *
   * @param name    name of parameter
   * @param defVal default value for absent parameter
   * @return  boolean   value
   * @throws Throwable
   */
  public boolean getBooleanReqPar(String name,
                                  boolean defVal) throws Throwable {
    boolean val = defVal;
    Boolean valB = getBooleanReqPar(name);
    if (valB != null) {
      val = valB.booleanValue();
    }

    return val;
  }

  /** Set the value of a named session attribute.
   *
   * @param attrName    Name of the attribute
   * @param val         Object
   */
  public void setSessionAttr(String attrName,
                             Object val) {
    HttpSession sess = request.getSession(false);

    if (sess == null) {
      return;
    }

    sess.setAttribute(attrName, val);
  }

  /** Return the value of a named session attribute.
   *
   * @param attrName    Name of the attribute
   * @return Object     Attribute value or null
   */
  public Object getSessionAttr(String attrName) {
    HttpSession sess = request.getSession(false);

    if (sess == null) {
      return null;
    }

    return sess.getAttribute(attrName);
  }

  /**
   * @return String remoe address
   */
  public String getRemoteAddr() {
    return request.getRemoteAddr();
  }

  /**
   * @return String remote host
   */
  public String getRemoteHost() {
    return request.getRemoteHost();
  }

  /**
   * @return int remote port
   */
  public int getRemotePort() {
    return request.getRemotePort();
  }

  /** If there is no Accept-Language header returns null, otherwise returns a
   * collection of Locales ordered with preferred first.
   *
   * @return Collection of locales or null
   */
  public Collection<Locale> getLocales() {
    return HttpServletUtils.getLocales(request);
  }
}
