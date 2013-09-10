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

  /** Specify which client */
  public final static String clientNamePar = "cl";

  /**
   * @param request
   * @param response
   * @param form
   * @param action
   */
  public Request(final HttpServletRequest request,
                 final HttpServletResponse response,
                 final UtilActionForm form,
                 final Action action) {
    super(request, response);
    this.form = form;
    this.action = action;
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
   * @param val
   */
  public void setActionType(final int val) {
    actionType = val;
  }

  /**
   * @return int
   */
  public int getActionType() {
    return actionType;
  }

  /**
   * @param val
   */
  public void setConversationType(final int val) {
    conversationType = val;
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
  public String getClientName() {
    return getReqPar(clientNamePar);
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
}
