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

import org.apache.struts.action.ActionMessage;
import org.apache.struts.action.ActionMessages;
import org.apache.struts.util.MessageResources;

/** This class allows informational message generation in the struts world.
 *
 * @author Mike Douglass douglm@rpi.edu
 * @version 1.0
 */
public class MessageEmitSvlt extends ErrorEmitSvlt {
  transient private ActionMessages msgs;

  /**
   *
   */
  public MessageEmitSvlt() {
    this(false);
  }

  /**
   * @param debug
   */
  public MessageEmitSvlt(boolean debug) {
    this.debug = debug;
  }

  /** Generation of errors in the servlet world means adding them to the
   *  errors object. We need to call this routine on every entry to the
   *  application
   *
   * @param id       An identifying name
   * @param caller   Used for log4j identification
   * @param messages Resources
   * @param msgs     Error message will be appended on failure.
   * @param exceptionPname Property name for exceptions
   * @param clear
   */
  public void reinit(String id,
                     Object caller,
                     MessageResources messages,
                     ActionMessages msgs,
                     String exceptionPname,
                     boolean clear) {
    super.reinit(id, caller, messages, null, exceptionPname, clear);
    this.msgs = msgs;
  }

  public void emit(String pname) {
    if (debug) {
      debugMsg(pname, null, null);
    }

    msgList.add(new Msg(messages, pname));

    if ((messages == null) || !haveOutputObject()) {
      return;
    }

    try {
      msgs.add(id, new ActionMessage(pname));
    } catch (Throwable t) {
      logError(className() + ": exception adding Action message", t);
    }
  }

  public void emit(String pname, Object o){
    if (debug) {
      debugMsg(pname, "object", String.valueOf(o));
    }

    msgList.add(new Msg(messages, pname, o));

    if ((messages == null) || !haveOutputObject()) {
      return;
    }

    try {
      msgs.add(id, new ActionMessage(pname, o));
    } catch (Throwable t) {
      logError(className() + ": exception adding Action message", t);
    }
  }

  public void emit(String pname, Object o1, Object o2){
    if (debug) {
      debugMsg(pname, "2objects",
               String.valueOf(o1) + "; " +
               String.valueOf(o2));
    }

    msgList.add(new Msg(messages, pname, o1, o2));

    if ((messages == null) || !haveOutputObject()) {
      return;
    }

    try {
      msgs.add(id, new ActionMessage(pname, o1, o2));
    } catch (Throwable t) {
      logError(className() + ": exception adding Action message", t);
    }
  }

  public void emit(String pname, Object o1, Object o2, Object o3){
    if (debug) {
      debugMsg(pname, "2objects",
               String.valueOf(o1) + "; " +
               String.valueOf(o2) + "; " +
               String.valueOf(o3));
    }

    msgList.add(new Msg(messages, pname, o1, o2, o3));

    if ((messages == null) || !haveOutputObject()) {
      return;
    }

    try {
      msgs.add(id, new ActionMessage(pname, o1, o2, o3));
    } catch (Throwable t) {
      logError(className() + ": exception adding Action message", t);
    }
  }

  /* (non-Javadoc)
   * @see edu.rpi.sss.util.log.MessageEmit#messagesEmitted()
   */
  public boolean messagesEmitted() {
    return !msgs.isEmpty();
  }

  /**
   * @return messages
   */
  public ActionMessages getMessages() {
    return msgs;
  }

  protected String className() {
    return "MessageEmitSvlt";
  }

  protected boolean haveOutputObject() {
    return msgs != null;
  }
}

