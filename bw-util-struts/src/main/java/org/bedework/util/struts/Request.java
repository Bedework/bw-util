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
package org.bedework.util.struts;

import org.bedework.util.servlet.MessageEmit;
import org.bedework.util.servlet.ReqUtil;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/** Class to handle the incoming request.
 *
 * @author Mike Douglass
 */
public class Request extends ReqUtil {
  protected UtilActionForm form;
  protected Action action;

  protected ActionMapping mapping;

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
  /** */
  public static final String actionTypeKey = "actionType=";
  /** */
  public static final String conversationKey = "conversation=";
  /** */
  public static final String refreshIntervalKey = "refinterval=";
  /** */
  public static final String refreshActionKey = "refaction=";

  /** In the absence of a conversation parameter we assume that a conversation
   * starts with actionType=action and ends with actionType=render.
   *
   * Conversations are related to the persistence framework and allow us to keep
   * a persistence engine session running until the sequence of actions is
   * completed.
   */
  public final static int conversationTypeUnknown = 0;

  /** start of a multi-request conversation */
  public final static int conversationTypeStart = 1;

  /** part-way through a multi-request conversation */
  public final static int conversationTypeContinue = 2;

  /** end of a multi-request conversation */
  public final static int conversationTypeEnd = 3;

  /** if a conversation is started, end it on entry with no
   * processing of changes. Start a new conversation which we will end on exit.
   */
  public final static int conversationTypeOnly = 4;

  /** If a conversation is already started on entry, process changes and end it.
   * Start a new conversation which we will end on exit.
   */
  public final static int conversationTypeProcessAndOnly = 5;

  /** */
  public final static String[] conversationTypes = {"unknown",
                                                    "start",
                                                    "continue",
                                                    "end",
                                                    "only",
                                                    "processAndOnly"};

  protected int conversationType;

  /** Request parameter to specify which module */
  public final static String moduleNamePar = "mdl";

  /** May be specified as an action parameter or overriddem by the
   * request parameter.
   */
  protected String moduleName;

  /**
   * @param request
   * @param response
   * @param form
   * @param action
   */
  public Request(final HttpServletRequest request,
                 final HttpServletResponse response,
                 final UtilActionForm form,
                 final Action action,
                 final ActionMapping mapping) {
    super(request, response);
    this.form = form;
    this.action = action;
    this.mapping = mapping;

    String at = getStringActionPar(actionTypeKey);
    if (at != null) {
      for (int ati = 0; ati < actionTypes.length; ati++) {
        if (Request.actionTypes[ati].equals(at)) {
          actionType = ati;
          break;
        }
      }
    }

    String convType = getStringActionPar(conversationKey);
    if (convType != null) {
      for (int ati = 0; ati < Request.conversationTypes.length; ati++) {
        if (Request.conversationTypes[ati].equals(convType)) {
          conversationType = ati;
          break;
        }
      }
    }

    moduleName = getStringActionPar(Request.moduleNamePar);
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
    return mapping;
  }

  /**
   * @return MessageEmit
   */
  public MessageEmit getErr() {
    errFlag = true;
    return form.getErr();
  }

  /**
   * @return MessageEmit
   */
  public MessageEmit getMsg() {
    return form.getMsg();
  }

  /**
   * @return boolean
   */
  public boolean getErrorsEmitted() {
    return errFlag || form.getErrorsEmitted();
  }

  /**
   * @return int
   */
  public int getActionType() {
    return actionType;
  }

  /**
   * @return the part of the URL that identifies the action.
   */
  public String getActionPath() {
    return mapping.getPath();
  }

  /**
   * @return the action parameter if any.
   */
  public String getActionParameter() {
    return mapping.getParameter();
  }

  /**
   * @return int
   */
  public int getConversationType() {
    return conversationType;
  }

  /**
   * @return String
   */
  public String getModuleName() {
    String nm = getReqPar(moduleNamePar);

    if (nm == null) {
      nm = moduleName;
    }

    return nm;
  }

  public Integer getRefreshInt() {
    return getIntActionPar(refreshIntervalKey);
  }

  public String getRefreshAction() {
    return getStringActionPar(refreshActionKey);
  }

  /** Get an Integer request parameter or null. Emit error for non-null and
   * non integer
   *
   * @param name    name of parameter
   * @param errProp
   * @return  Integer   value or null
   * @throws Throwable
   */
  public Integer getIntReqPar(final String name,
                              final String errProp) throws Throwable {
    try {
      return super.getIntReqPar(name);
    } catch (Throwable t) {
      getErr().emit(errProp, getReqPar(name));
      return null;
    }
  }

  protected Integer getIntActionPar(final String name) {
    return getIntActionPar(name, getActionParameter());
  }

  protected String getStringActionPar(final String name) {
    return getStringActionPar(name, getActionParameter());
  }

  protected Integer getIntActionPar(final String name,
                                    final String par) {
    if (par == null) {
      return null;
    }

    try {
      int pos = par.indexOf(name);
      if (pos < 0) {
        return null;
      }

      pos += name.length();
      int epos = par.indexOf(";", pos);
      if (epos < 0) {
        epos = par.length();
      }

      return Integer.valueOf(par.substring(pos, epos));
    } catch (Throwable t) {
      form.getErr().emit("edu.rpi.bad.actionparameter", par);
      return null;
    }
  }

  public String getStringActionPar(final String name,
                                   final String par) {
    if (par == null) {
      return null;
    }

    try {
      int pos = par.indexOf(name);
      if (pos < 0) {
        return null;
      }

      pos += name.length();
      int epos = par.indexOf(";", pos);
      if (epos < 0) {
        epos = par.length();
      }

      return par.substring(pos, epos);
    } catch (Throwable t) {
      form.getErr().emit("edu.rpi.bad.actionparameter", par);
      return null;
    }
  }
}
