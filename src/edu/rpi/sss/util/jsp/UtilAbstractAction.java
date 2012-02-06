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
package edu.rpi.sss.util.jsp;

import edu.rpi.sss.util.Util;
import edu.rpi.sss.util.log.HttpAppLogger;
import edu.rpi.sss.util.servlets.HttpServletUtils;
import edu.rpi.sss.util.servlets.PresentationState;

import org.apache.log4j.Logger;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessages;
import org.apache.struts.config.ActionConfig;
import org.apache.struts.util.MessageResources;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.ObjectOutputStream;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Enumeration;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Abstract implementation of <strong>Action</strong> which sets up frequently
 * required fields then calls an abstract method to do the work.
 *
 * <p>If the abstract action method returns null or throws an exception the
 * struts action method will forward to "error".
 *
 * <p>An invalid form of request parameter (for those recognized by the
 * abstract action) will cause a forward to "badRequest"..
 *
 * <p>Otherwise we forward to the result from the abstract action.
 *
 * <p>This action also checks for a number of request parameters, mostly
 * related to presentation of data but some related to debugging.
 *
 * <p>Debugging actions:<ul>
 * <li><em>debug=yes|no</em> Set the debugging mode</li>
 * <li><em>seralize=anything</em> Try to serialize all session attributes
 *      and log the result. Only when debugging on.</li>
 * </ul>
 * <p>The following are related to presentation of data. They are often
 * useful when debugging xslt but can be used to force content types.
 * <ul>
 * <li><em>browserType=!</em> Reset to normal dynamic behaviour,
 *                            that is browser type reset every request.</li>
 * <li><em>browserType=string</em> Set the browser type for one request</li>
 * <li><em>browserTypeSticky=!</em> Reset to normal dynamic behaviour,
 *                                  that is reset browser type every request.
 * </li>
 * <li><em>browserTypeSticky=string</em> Set the browser type permanently
 *                                          - browser type set until
 *                                          next explicit setting.</li>
 * </ul><p>
 * Set the 'skinName' - maybe change the look and feel or e.g. provide
 * printer friendly output:
 * <p><ul>
 * <li><em>skinName=!</em> Reset to normal dynamic behaviour,
 *                            that is reset every request.
 * </li>
 * <li><em>skinName=string</em> Set the skin name for one request
 * </li>
 * <li><em>skinNameSticky=!</em> Reset to normal dynamic behaviour,
 *                                  that is reset every request.
 * </li>
 * <li><em>skinNameSticky=string</em> Set the skin name permanently
 * </li>
 * </ul><p>
 * Allow user to set the content type explicitly. Used mainly for
 * debugging. The incoming request may contain the following:
 * <p><ul>
 * <li><em>contentType=!</em> Reset to normal dynamic behaviour,
 *                            that is reset every request.
 * </li>
 * <li><em>contentType=string</em> Set the Content type
 * </li>
 * <li><em>contentTypeSticky=!</em> Reset to normal dynamic behaviour,
 *                                  that is reset every request.
 * </li>
 * <li><em>contentTypeSticky=string</em> Set the Content type permanently
 * </li>
 * </ul><p>
 * Allow user to indicate if we should refresh the xslt once, every time
 * or only when something changes. Used mainly for
 * debugging. The incoming request may contain the following:
 * <p><ul>
 * <li><em>refreshXslt=!</em> Reset to normal dynamic behaviour,
 *                            that is reset every request.
 * </li>
 * <li><em>refreshXslt=yes</em> One shot refresh
 * </li>
 * <li><em>refreshxslt=always</em> Refresh every request.
 * </li>
 * </ul><p>
 * Some misc actions:
 * <p><ul>
 * <li><em>forwardto=name</em> Just does a forward to that name. Used to
 *                            provide a null action with arbitrary forward
 *                            configured in struts-config.xml
 * <li><em>noxslt=anything</em> Suppress XSLT transform for one request.
 *                              Used for debugging - provides the raw xml.
 * </li>
 *
 * </ul>
 * <p>A combination of the above can allow us to dump the output in a file,
 * <br /><em>contentType=text/text&amp;noxslt=yes</em>
 */
public abstract class UtilAbstractAction extends Action
         implements HttpAppLogger {
  /** */
  public static final String refreshIntervalKey = "refinterval=";
  /** */
  public static final String refreshActionKey = "refaction=";
  /** */
  public static final String actionTypeKey = "actionType=";
  /** */
  public static final String conversationKey = "conversation=";

  /** true for debugging on */
  public boolean debug;

  protected transient Logger log;

  transient MessageResources messages;

  private transient String logPrefix;

  protected String requestLogout = "logout";

  /** Forward to here for logged out
   */
  public final String forwardLoggedOut = "loggedOut";

  private boolean noActionErrors = false;

  protected boolean isPortlet;

  /** This is the routine which does the work.
   *
   * @param request  Provide http request/response and form
   * @param messages Resources
   * @return String  forward name
   * @throws Throwable
   */
  public abstract String performAction(Request request,
                                       MessageResources messages)
               throws Throwable;

  @SuppressWarnings("deprecation")
  @Override
  public ActionForward execute(final ActionMapping mapping,
                               final ActionForm frm,
                               final HttpServletRequest request,
                               final HttpServletResponse response)
                               throws IOException, ServletException {
    ErrorEmitSvlt err = null;
    MessageEmitSvlt msg = null;

    String forward = "success";
    UtilActionForm form = (UtilActionForm)frm;

    try {
      messages = getResources(request);

      debug = getLogger().isDebugEnabled();

      isPortlet = isPortletRequest(request);

      noActionErrors = JspUtil.getProperty(messages,
                                "edu.rpi.sss.util.action.noactionerrors",
                                "no").equals("yes");

      err = getErrorObj(request, messages);
      msg = getMessageObj(request, messages);

      /** Log the request - virtual domains can make it difficult to
       *  distinguish applications.
       */
      logRequest(request);

      if (debug) {
        debugOut("entry");
        debugOut("================================");
        debugOut("isPortlet=" + isPortlet);

        Enumeration en = servlet.getInitParameterNames();

        while (en.hasMoreElements()) {
          debugOut("attr name=" + en.nextElement());
        }
        debugOut("================================");

        dumpRequest(request);
      }

      if (!form.getInitialised()) {
        // Do one time settings
        form.setNocache(
            JspUtil.getProperty(messages,
                                "edu.rpi.sss.util.action.nocache",
                                "no").equals("yes"));

        form.setInitialised(true);
      }

      form.setLog(getLogger());
      form.setDebug(debug);
      form.setMres(messages);
      form.setBrowserType(JspUtil.getBrowserType(request));
      form.assignCurrentUser(request.getRemoteUser());
      form.setUrl(JspUtil.getUrl(request));
      form.setSchemeHostPort(JspUtil.getURLshp(request));
      form.setContext(JspUtil.getContext(request));
      form.setUrlPrefix(JspUtil.getURLPrefix(request));
      form.setActionPath(mapping.getPath());
      form.setMapping(mapping);
      form.setActionParameter(mapping.getParameter());
      form.setErr(err);
      form.setMsg(msg);
      form.assignSessionId(getSessionId(request));

      checkNocache(request, response, form);

      String defaultContentType =
          JspUtil.getProperty(messages,
                              "edu.rpi.sss.util.action.contenttype",
                              "text/html");

      Request req = new Request(request, response, form, this);

      String actionType = getStringActionPar(actionTypeKey, form);
      if (actionType != null) {
        for (int ati = 0; ati < Request.actionTypes.length; ati++) {
          if (Request.actionTypes[ati].equals(actionType)) {
            req.setActionType(ati);
            break;
          }
        }
      }

      String convType = getStringActionPar(conversationKey, form);
      if (convType != null) {
        for (int ati = 0; ati < Request.conversationTypes.length; ati++) {
          if (Request.conversationTypes[ati].equals(convType)) {
            req.setConversationType(ati);
            break;
          }
        }
      }

      /** Set up presentation values from request
       */
      doPresentation(req, form);

      String contentName = getContentName(form);

      if (contentName != null) {
        /* Indicate we have a file attachment with the given name
         */

        response.setHeader("Content-Disposition",
                           "Attachment; Filename=\"" + contentName + "\"");
      }

      // Debugging action to test session serialization
      if (debug) {
        checkSerialize(request);
      }

      String appRoot = form.getPresentationState().getAppRoot();

      if (appRoot != null) {
        // Embed in request for pages that cannot access the form (loggedOut)
        request.setAttribute("edu.rpi.sss.util.action.approot", appRoot);
      }

      /* ----------------------------------------------------------------
         Everything is set up and ready to go. Execute something
         ---------------------------------------------------------------- */

      if (!isPortlet) {
        forward = checkLogOut(request, form);
      } else {
        forward = null;
      }

      if (forward != null) {
        // Disable xslt filters
        response.setContentType("text/html");
      } else {
        if (!isPortlet) {
          response.setContentType(defaultContentType);
        }
        forward = checkVarReq(req, form);

        if (forward == null) {
          forward = checkForwardto(request);
        }

        if (forward == null) {
          forward = performAction(req, messages);
        }
      }

      if (forward == null) {
        getLogger().warn("Forward = null");
        err.emit("edu.rpi.sss.util.nullforward");
        forward = "error";
      } else if (forward.equals("FORWARD-NULL")) {
        forward = null;
      }

      if (err == null) {
        getLogger().warn("No errors object");
      } else if (err.messagesEmitted()) {
        if (noActionErrors) {
        } else {
          ActionErrors aes = err.getErrors();
          saveErrors(request, aes);
        }

        if (debug) {
          getLogger().debug(err.getMsgList().size() + " errors emitted");
        }
      } else if (debug) {
        getLogger().debug("No errors emitted");
      }

      if (msg == null) {
        getLogger().warn("No messages object");
      } else if (msg.messagesEmitted()) {
        ActionMessages ams = msg.getMessages();
        saveMessages(request, ams);

        if (debug) {
          getLogger().debug(ams.size() + " messages emitted");
        }
      } else if (debug) {
        getLogger().debug("No messages emitted");
      }

      if (debug) {
        getLogger().debug("exit to " + forward);
      }
    } catch (Throwable t) {
      if (debug) {
        getLogger().debug("Action exception: ", t);
      }

      err.emit(t);
      forward = "error";
    }

    if (forward == null) {
      return null;
    }

    return (mapping.findForward(forward));
  }

  private static Logger confLog =
      Logger.getLogger(UtilAbstractAction.class.getName() + ".traceConfig");

  protected void traceConfig(final Request req) {


    if (!confLog.isDebugEnabled()) {
      return;
    }

    ActionConfig[] actions = req.getMapping().getModuleConfig().findActionConfigs();

    confLog.debug("========== Action configs ===========");

    for (ActionConfig aconfig: actions) {
      StringBuilder sb = new StringBuilder();

      sb.append(aconfig.getPath());

      String param = aconfig.getParameter();

      boolean noActionType = traceConfigParam(sb,
                                              actionTypeKey,
                                              param,
                                              req.getForm()) == null;
      traceConfigParam(sb, conversationKey, param, req.getForm());

      traceConfigParam(sb, refreshIntervalKey, param, req.getForm());
      traceConfigParam(sb, refreshActionKey, param, req.getForm());

      confLog.debug(sb.toString());

      if (noActionType) {
        confLog.debug("***** Warning: no action type specified ****");
      }
    }
  }

  private String traceConfigParam(final StringBuilder sb,
                                  final String name, final String param,
                                  final UtilActionForm form) {
    String res = getStringActionPar(name, param, form);
    if (res == null) {
      return null;
    }

    sb.append(",\t");
    sb.append(name);

    sb.append(res);

    return res;
  }

  /** Override this to get the contentName from different sources
   *
   * @param form
   * @return String name of content
   */
  public String getContentName(final UtilActionForm form) {
    String contentName = form.getPresentationState().getContentName();

    form.setContentName(contentName);

    return contentName;
  }

  /** Set the global id to some name for logging
   *
   * @return String id
   */
  public abstract String getId();

  /** In a portlet environment a render action should override this to return
   * false to preserve messages.
   *
   * @return boolean   true to clear messages
   */
  public boolean clearMessages() {
    return true;
  }

  /** Override to return the name of the error object session attribute.
   *
   * @return String   request attribute name. Null to suppress.
   */
  public String getErrorObjAttrName() {
    return "edu.rpi.sss.util.errorobj";
  }

  /** Override to return the name of the messages object session attribute.
   *
   * @return String   request attribute name. Null to suppress.
   */
  public String getMessageObjAttrName() {
    return "edu.rpi.sss.util.messageobj";
  }

  /** Override to return a different name for the error exception property.
   * This must return non-null if getErrorObjAttrName returns a value.
   *
   * @return error exception property name
   */
  public String getErrorObjErrProp() {
    return "edu.rpi.sss.util.error.exc";
  }

  /** Overide this to set the value or turn off presentation support
   * by returning null or the value "NONE".
   *
   * @return presentation attr name
   */
  public String getPresentationAttrName() {
    return PresentationState.presentationAttrName;
  }

  /**
   * @return message resources
   */
  public MessageResources getMessages() {
    return messages;
  }

  /**
   * @param name
   * @return message identified by name
   */
  public String getMessage(final String name) {
    return messages.getMessage(name);
  }

  /* ====================================================================
   *               Log request
   * ==================================================================== */

  class LogEntryImpl extends LogEntry {
    StringBuffer sb;
    HttpAppLogger logger;

    LogEntryImpl(final StringBuffer sb,
                 final HttpAppLogger logger){
      this.sb = sb;
      this.logger = logger;
    }

    /** Append to a log entry. Value should not contain colons or should be
     * the last element.
     *
     * @param val    String element to append
     */
    @Override
    public void append(final String val) {
      sb.append(":");
      sb.append(val);
    }

    /** Concatenate some info without a delimiter.
     *
     * @param val    String to concat
     */
    @Override
    public void concat(final String val) {
      sb.append(val);
    }

    /** Emit the log entry
     */
    @Override
    public void emit() {
      logger.logIt(sb.toString());
    }
  }

  /** Return a LogEntry containing the start of a log entry.
   *
   * @param request    HttpServletRequest
   * @param logname    String name for the log entry
   * @return LogEntry    containing prefix
   */
  @Override
  public LogEntry getLogEntry(final HttpServletRequest request,
                              final String logname) {
    StringBuffer sb = new StringBuffer(logname);

    sb.append(":");
    sb.append(getSessionId(request));
    sb.append(":");
    sb.append(getLogPrefix(request));

    return new LogEntryImpl(sb, this);
  }

  /** Log some information.
   *
   * @param request    HttpServletRequest
   * @param logname    String name for the log entry
   * @param info       String information to log
   */
  @Override
  public void logInfo(final HttpServletRequest request,
                      final String logname,
                      final String info) {
    LogEntry le = getLogEntry(request, logname);

    le.append(info);

    le.emit();
  }

  /* (non-Javadoc)
   * @see edu.rpi.sss.util.log.HttpAppLogger#logRequest(javax.servlet.http.HttpServletRequest)
   */
  @Override
  public void logRequest(final HttpServletRequest request) throws Throwable {
    LogEntry le = getLogEntry(request, "REQUEST");

    le.append(request.getRemoteAddr());
    le.append(HttpServletUtils.getUrl(request));

    String q = request.getQueryString();

    if (q != null) {
      le.concat("?");
      le.concat(q);
    }

    le.emit();

    String referrer = request.getHeader("Referer");
    if (referrer == null) {
      referrer = "NONE";
    }

    logInfo(request, "REFERRER", referrer);
  }

  /** Log the session counters for applications that maintain them.
   *
   * @param request    HttpServletRequest
   * @param start      true for session start
   * @param sessionNum long number of session
   * @param sessions   long number of concurrent sessions
   */
  @Override
  public void logSessionCounts(final HttpServletRequest request,
                               final boolean start,
                               final long sessionNum,
                               final long sessions) {
    LogEntry le;

    if (start) {
      le = getLogEntry(request, "SESSION-START");
    } else {
      le = getLogEntry(request, "SESSION-END");
    }

    le.append(String.valueOf(sessionNum));
    le.append(String.valueOf(sessions));

    le.emit();
  }

  @Override
  public void debugOut(final String msg) {
    getLogger().debug(msg);
  }

  @Override
  public void logIt(final String msg) {
    getLogger().info(msg);
  }

  /** Get a prefix for the loggers.
   *
   * @param request    HttpServletRequest
   * @return  String    log prefix
   */
  protected String getLogPrefix(final HttpServletRequest request) {
    try {
      if (logPrefix == null) {
        logPrefix = JspUtil.getProperty(getMessages(),
                                        "edu.rpi.sss.util.action.logprefix",
                                        "unknown");
      }

      return logPrefix;
    } catch (Throwable t) {
      error(t);
      return "LOG-PREFIX-EXCEPTION";
    }
  }

  /** Get the session id for the loggers.
   *
   * @param request
   * @return  String    session id
   */
  private String getSessionId(final HttpServletRequest request) {
    try {
      HttpSession sess = request.getSession(false);

      if (sess == null) {
        return "NO-SESSIONID";
      } else {
        return sess.getId();
      }
    } catch (Throwable t) {
      error(t);
      return "SESSION-ID-EXCEPTION";
    }
  }

  /* ====================================================================
   *               Check logout
   * ==================================================================== */

  /** Clean up - we're about to logout
   *
   * @param request    HttpServletRequest
   * @param form
   * @return boolean true for OK to log out. False - not allowed - ignore it.
   */
  protected boolean logOutCleanup(final HttpServletRequest request,
                                  final UtilActionForm form) {
    return true;
  }

  /** Check for logout request.
   *
   * @param request    HttpServletRequest
   * @param form
   * @return null for continue, forwardLoggedOut to end session.
   * @throws Throwable
   */
  protected String checkLogOut(final HttpServletRequest request,
                               final UtilActionForm form)
               throws Throwable {
    String temp = request.getParameter(requestLogout);
    if (temp != null) {
      HttpSession sess = request.getSession(false);

      if ((sess != null) && logOutCleanup(request, form)) {
        sess.invalidate();
      }
      return forwardLoggedOut;
    }

    return null;
  }

  /* ====================================================================
   *               Check nocache
   * ==================================================================== */

  /* We handle our own nocache headers instead of letting struts do it.
   * Struts does it on every response but, if we are running with nocache,
   * we need to be able to disable it for the occassional response.
   *
   * <p>This gets around an IE problem when attempting to deliver files.
   * IE requires caching on or it is unable to locate the file it is
   * supposed to be delivering.
   *
   */
  private void checkNocache(final HttpServletRequest request,
                            final HttpServletResponse response,
                            final UtilActionForm form) {
    String reqpar = request.getParameter("nocacheSticky");

    if (reqpar != null) {
      /* (re)set the default */
      form.setNocache(reqpar.equals("yes"));
    }

    /** Look for a one-shot setting
     */

    reqpar = request.getParameter("nocache");

    if ((reqpar == null) && (!form.getNocache())) {
      return;
    }

    /** If we got a request parameter it overrides the default
     */
    boolean nocache = form.getNocache();

    if (reqpar != null) {
      nocache = reqpar.equals("yes");
    }

    if (nocache) {
      response.setHeader("Pragma", "No-cache");
      response.setHeader("Cache-Control", "no-cache");
      response.setDateHeader("Expires", 1);
    }
  }

  /* ====================================================================
   *               Check serialization
   * ==================================================================== */

  /* Debugging routine to see if we can serialize the session.
   * We see session serialization errors in the web container if an
   * unserializable object class gets embedded in the session somewhere
   */
  private void checkSerialize(final HttpServletRequest request) {
    String reqpar = request.getParameter("serialize");

    if (reqpar == null) {
      return;
    }

    HttpSession sess = request.getSession(false);
    Enumeration en = sess.getAttributeNames();

    while (en.hasMoreElements()) {
      String attrname = (String)en.nextElement();
      ObjectOutputStream oo = null;

      logIt("Attempt to serialize attr " + attrname);
      Object o = sess.getAttribute(attrname);

      try {
        ByteArrayOutputStream bo = new ByteArrayOutputStream();
        oo = new ObjectOutputStream(bo);
        oo.writeObject(o);
        oo.flush();

        logIt("Serialized object " + attrname + " has size: " + bo.size());
      } catch (Throwable t) {
        t.printStackTrace();
      } finally {
        if (oo != null) {
          try {
            oo.close();
          } catch (Throwable t) {}
        }
      }
    }
  }

  /* ====================================================================
   *                       Response methods
   * ==================================================================== */

  /** Check request for refresh interval
   *
   * @param request
   * @param response
   * @param refreshInterval
   * @param refreshAction
   * @param form
   */
  public void setRefreshInterval(final HttpServletRequest request,
                                 final HttpServletResponse response,
                                 final int refreshInterval,
                                 final String refreshAction,
                                 final UtilActionForm form) {
    if (refreshInterval != 0) {
      StringBuilder sb = new StringBuilder(250);

      sb.append(refreshInterval);
      sb.append("; URL=");
      sb.append(form.getUrlPrefix());
      if (!refreshAction.startsWith("/")) {
        sb.append("/");
      }
      sb.append(refreshAction);
      response.setHeader("Refresh", sb.toString());
    }
  }

  protected Integer getRefreshInt(final UtilActionForm form) {
    return getIntActionPar(refreshIntervalKey, form);
  }

  protected String getRefreshAction(final UtilActionForm form) {
    return getStringActionPar(refreshActionKey, form);
  }

  protected Integer getIntActionPar(final String name, final UtilActionForm form) {
    return getIntActionPar(name, form.getActionParameter(), form);
  }

  protected String getStringActionPar(final String name, final UtilActionForm form) {
    return getStringActionPar(name, form.getActionParameter(), form);
  }

  protected Integer getIntActionPar(final String name, final String par,
                                    final UtilActionForm form) {
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

  protected String getStringActionPar(final String name, final String par,
                                      final UtilActionForm form) {
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

  /* ====================================================================
   *                  Application variable methods
   * ==================================================================== */

  /**
   * @param request
   * @return app vars
   */
  @SuppressWarnings("unchecked")
  public HashMap<String, String> getAppVars(final Request request) {
    Object o = request.getSessionAttr("edu.rpi.sss.util.UtilAbstractAction.appVars");
    if ((o == null) || (!(o instanceof HashMap))) {
      o = new HashMap<String, String>();
      request.setSessionAttr("edu.rpi.sss.util.UtilAbstractAction.appVars", o);
    }

    return (HashMap<String, String>)o;
  }

  private static final int maxAppVars = 50; // Stop screwing around.

  /** Check for action setting a variable
   * We expect the request parameter to be of the form<br/>
   * setappvar=name(value) or <br/>
   * setappvar=name{value}<p>.
   *  Currently we're not escaping characters so if you want both right
   *  terminators in the value you're out of luck - actually we cheat a bit
   *  We just look at the last char and then look for that from the start.
   *
   * @param request  Needed to locate session
   * @param form     Action form
   * @return String  forward to here. null if no error found.
   * @throws Throwable
   */
  private String checkVarReq(final Request request,
                             final UtilActionForm form) throws Throwable {
    Collection<String> avs = request.getReqPars("setappvar");
    if (avs == null) {
      return null;
    }

    HashMap<String, String> appVars = getAppVars(request);

    for (String reqpar: avs) {
      int start;

      if (reqpar.endsWith("}")) {
        start = reqpar.indexOf('{');
      } else if (reqpar.endsWith(")")) {
        start = reqpar.indexOf('(');
      } else {
        return "badRequest";
      }

      if (start < 0) {
        return "badRequest";
      }

      String varName = reqpar.substring(0, start);
      String varVal = reqpar.substring(start + 1, reqpar.length() - 1);

      if (varVal.length() == 0) {
        varVal = null;
      }

      if (!setAppVar(varName, varVal, appVars)) {
        return "badRequest";
      }
    }

    form.setAppVarsTbl(appVars);

    return null;
  }

  /** Called to set an application variable to a value
   *
   * @param   name     name of variable
   * @param   val      new value of variable - null means remove.
   * @param appVars
   * @return  boolean  True if ok - false for too many vars
   */
  public boolean setAppVar(final String name, final String val,
                           final HashMap<String, String> appVars) {
    if (val == null) {
      appVars.remove(name);
      return true;
    }

    if (appVars.size() > maxAppVars) {
      return false;
    }

    appVars.put(name, val);
    return true;
  }

  /* ====================================================================
   *               Forward methods
   * ==================================================================== */

  /** Check for action forwarding
   * We expect the request parameter to be of the form<br/>
   * forward=name<p>.
   *
   * @param request  Needed to locate session
   * @return String  forward to here. null if no forward found.
   * @throws Throwable
   */
  private String checkForwardto(final HttpServletRequest request) throws Throwable {
    String reqpar = request.getParameter("forwardto");
    return reqpar;
  }

  /* ====================================================================
   *               Confirmation id methods
   * ==================================================================== */

  /** Check for a confirmation id. This is a random string embedded
   * in some requests to confirm that the incoming request came from a page
   * we generated. Not all pages will have such an id but if we do it must
   * match.
   *
   * We expect the request parameter to be of the form<br/>
   * confirmationid=id<p>.
   *
   * @param request  Needed to locate session
   * @param form
   * @return String  forward to here on error. null for OK.
   * @throws Throwable
   */
  protected String checkConfirmationId(final HttpServletRequest request,
                                       final UtilActionForm form)
          throws Throwable {
    String reqpar = request.getParameter("confirmationid");

    if (reqpar == null) {
      return null;
    }

    if (!reqpar.equals(form.getConfirmationId())) {
      return "badConformationId";
    }

    return null;
  }

  /** Require a confirmation id. This is a random string embedded
   * in some requests to confirm that the incoming request came from a page
   * we generated. Not all pages will have such an id but if we do it must
   * match.
   *
   * We expect the request parameter to be of the form<br/>
   * confirmationid=id<p>.
   *
   * @param request  Needed to locate session
   * @param form
   * @return String  forward to here on error. null for OK.
   * @throws Throwable
   */
  protected String requireConfirmationId(final HttpServletRequest request,
                                         final UtilActionForm form)
          throws Throwable {
    String reqpar = request.getParameter("confirmationid");

    if (reqpar == null) {
      return "missingConformationId";
    }

    if (!reqpar.equals(form.getConfirmationId())) {
      return "badConformationId";
    }

    return null;
  }

  /* ====================================================================
   *               Presentation state methods
   * ==================================================================== */

  /**
   * @param request
   * @param form
   */
  public void doPresentation(final Request request,
                             final UtilActionForm form) {
    PresentationState ps = getPresentationState(request, form);

    if (ps == null) {
      if (debug) {
        debugOut("No presentation state");
      }
      return;
    }

    if (debug) {
      debugOut("Set presentation state");
    }

    HttpServletRequest req = request.getRequest();

    ps.checkBrowserType(req);
    ps.checkContentType(req);
    ps.checkContentName(req);
    ps.checkNoXSLT(req);
    ps.checkRefreshXslt(req);
    ps.checkSkinName(req);

    form.setPresentationState(ps);
    request.setSessionAttr(getPresentationAttrName(), ps);

    if (debug) {
      ps.debugDump("action", getLogger());
    }
  }

  /**
   * @param request
   * @param form
   * @return PresentationState
   */
  public PresentationState getPresentationState(final Request request,
                                                final UtilActionForm form) {
    String attrName = getPresentationAttrName();

    if ((attrName == null) || (attrName.equals("NONE"))) {
      return null;
    }

    Object o = request.getSessionAttr(attrName);

    if ((o == null) || (!(o instanceof PresentationState))) {
      PresentationState ps = new PresentationState();
      ps.setBrowserType(form.getBrowserType());

      try {
        ps.setNoXSLTSticky(JspUtil.getProperty(messages,
                                  "edu.rpi.sss.util.action.noxslt",
                                  "no").equals("yes"));
      } catch (Throwable t) {
        t.printStackTrace();
      }

      request.setSessionAttr(attrName, ps);

      return  ps;
    }

    return (PresentationState)o;
  }

  /* ==================================================================
                Various utility methods
     ================================================================== */

  /* * Set the value of a named session attribute.
   *
   * @param request     Needed to locate session
   * @param attrName    Name of the attribute
   * @param val         Object
   * /
  public void setSessionAttr(HttpServletRequest request,
                             String attrName,
                             Object val) {
    HttpSession sess = request.getSession(false);

    if (sess == null) {
      return;
    }

    sess.setAttribute(attrName, val);
  }

  /* * Return the value of a named session attribute.
   *
   * @param request     Needed to locate session
   * @param attrName    Name of the attribute
   * @return Object     Attribute value or null
   * /
  public Object getSessionAttr(HttpServletRequest request,
                               String attrName) {
    HttpSession sess = request.getSession(false);

    if (sess == null) {
      return null;
    }

    return sess.getAttribute(attrName);
  } */

  /** Return the value of a required named resource.
   *
   * @param resName     Name of the property
   * @return String     Resource value or null
   * @throws Throwable
   */
  public String getReqRes(final String resName) throws Throwable {
    return JspUtil.getReqProperty(messages, resName);
  }

  /**
   * @param req
   * @return boolean true for portlet
   */
  public boolean isPortletRequest(final HttpServletRequest req) {
    // JSR 168 requires this attribute be present
    return req.getAttribute("javax.portlet.request") != null;
  }

  /** Get a request parameter stripped of white space. Return null for zero
   * length.
   *
   * @param req
   * @param name    name of parameter
   * @return  String   value
   * @throws Throwable
   */
  protected String getReqPar(final HttpServletRequest req, final String name) throws Throwable {
    return Util.checkNull(req.getParameter(name));
  }

  /** Get a multi-valued request parameter stripped of white space.
   * Return null for zero length.
   *
   * @param req
   * @param name    name of parameter
   * @return  Collection<String> or null
   * @throws Throwable
   */
  protected Collection<String> getReqPars(final HttpServletRequest req,
                                          final String name) throws Throwable {
    String[] s = req.getParameterValues(name);
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

  /* * Get an Integer request parameter or null.
   *
   * @param req
   * @param name    name of parameter
   * @return  Integer   value or null
   * @throws Throwable
   * /
  protected Integer getIntReqPar(HttpServletRequest req,
                                 String name) throws Throwable {
    String reqpar = getReqPar(req, name);

    if (reqpar == null) {
      return null;
    }

    return Integer.valueOf(reqpar);
  }

  /* * Get an Integer request parameter or null. Emit error for non-null and
   * non integer
   *
   * @param req
   * @param name    name of parameter
   * @param err     name of parameter
   * @param errProp
   * @return  Integer   value or null
   * @throws Throwable
   * /
  protected Integer getIntReqPar(HttpServletRequest req,
                                 String name,
                                 MessageEmit err,
                                 String errProp) throws Throwable {
    String reqpar = getReqPar(req, name);

    if (reqpar == null) {
      return null;
    }

    try {
      return Integer.valueOf(reqpar);
    } catch (Throwable t) {
      err.emit(errProp, reqpar);
      return null;
    }
  }

  /* * Get an integer valued request parameter.
   *
   * @param req
   * @param name    name of parameter
   * @param defaultVal
   * @return  int   value
   * @throws Throwable
   * /
  protected int getIntReqPar(HttpServletRequest req, String name,
                             int defaultVal) throws Throwable {
    String reqpar = req.getParameter(name);

    if (reqpar == null) {
      return defaultVal;
    }

    try {
      return Integer.parseInt(reqpar);
    } catch (Throwable t) {
      return defaultVal; // XXX exception?
    }
  }

  /* * Get a Long request parameter or null.
   *
   * @param req
   * @param name    name of parameter
   * @return  Long   value or null
   * @throws Throwable
   * /
  protected Long getLongReqPar(HttpServletRequest req,
                               String name) throws Throwable {
    String reqpar = getReqPar(req, name);

    if (reqpar == null) {
      return null;
    }

    return Long.valueOf(reqpar);
  }

  /* * Get an long valued request parameter.
   *
   * @param req
   * @param name    name of parameter
   * @param defaultVal
   * @return  long  value
   * @throws Throwable
   * /
  protected long getLongReqPar(HttpServletRequest req, String name,
                             long defaultVal) throws Throwable {
    String reqpar = req.getParameter(name);

    if (reqpar == null) {
      return defaultVal;
    }

    try {
      return Long.parseLong(reqpar);
    } catch (Throwable t) {
      return defaultVal; // XXX exception?
    }
  }

  /* * Get a boolean valued request parameter.
   *
   * @param req
   * @param name    name of parameter
   * @return  Boolean   value or null for absent parameter
   * @throws Throwable
   * /
  protected Boolean getBooleanReqPar(HttpServletRequest req, String name)
               throws Throwable {
    String reqpar = req.getParameter(name);

    if (reqpar == null) {
      return null;
    }

    try {
      return Boolean.valueOf(reqpar);
    } catch (Throwable t) {
      return null; // XXX exception?
    }
  }

  /* * Get a boolean valued request parameter giving a default value.
   *
   * @param req
   * @param name    name of parameter
   * @param defVal default value for absent parameter
   * @return  boolean   value
   * @throws Throwable
   * /
  protected boolean getBooleanReqPar(HttpServletRequest req, String name,
                                     boolean defVal) throws Throwable {
    boolean val = defVal;
    Boolean valB = getBooleanReqPar(req, name);
    if (valB != null) {
      val = valB.booleanValue();
    }

    return val;
  }
  */

  /* ==================================================================
                Private methods
     ================================================================== */

  /** Get the error object. If we haven't already got one and
   * getErrorObjAttrName returns non-null create one and implant it in
   * the session.
   *
   * @param request  Needed to locate session
   * @param messages Resources
   * @return ErrorEmitSvlt
   */
  private ErrorEmitSvlt getErrorObj(final HttpServletRequest request,
                                    final MessageResources messages) {
    return (ErrorEmitSvlt)JspUtil.getErrorObj(getId(), this, request,
                                              messages,
                                              getErrorObjAttrName(),
                                              getErrorObjErrProp(),
                                              noActionErrors,
                                              clearMessages());
  }

  /** Get the message object. If we haven't already got one and
   * getMessageObjAttrName returns non-null create one and implant it in
   * the session.
   *
   * @param request  Needed to locate session
   * @param messages Resources
   * @return MessageEmitSvlt
   */
  private MessageEmitSvlt getMessageObj(final HttpServletRequest request,
                                        final MessageResources messages) {
    return (MessageEmitSvlt)JspUtil.getMessageObj(getId(), this, request,
                                                  messages,
                                                  getMessageObjAttrName(),
                                                  getErrorObjErrProp(),
                                                  clearMessages());
  }

  /**
   * @param req
   */
  public void dumpRequest(final HttpServletRequest req) {
    Logger log = getLogger();

    try {
      Enumeration names = req.getParameterNames();

      String title = "Request parameters";

      log.debug(title + " - global info and uris");
      log.debug("getRequestURI = " + req.getRequestURI());
      log.debug("getRemoteUser = " + req.getRemoteUser());
      log.debug("getRequestedSessionId = " + req.getRequestedSessionId());
      log.debug("HttpUtils.getRequestURL(req) = " + req.getRequestURL());
      log.debug("query=" + req.getQueryString());
      log.debug("contentlen=" + req.getContentLength());
      log.debug("request=" + req);
      log.debug("parameters:");

      log.debug(title);

      while (names.hasMoreElements()) {
        String key = (String)names.nextElement();
        String[] vals = req.getParameterValues(key);
        for (String val: vals) {
          log.debug("  " + key + " = \"" + val + "\"");
        }
      }
    } catch (Throwable t) {
    }
  }

  /**
   * @return Logger
   */
  public Logger getLogger() {
    if (log == null) {
      log = Logger.getLogger(this.getClass());
    }

    return log;
  }

  /** Info message
   *
   * @param msg
   */
  public void info(final String msg) {
    getLogger().info(msg);
  }

  /** Warning message
   *
   * @param msg
   */
  public void warn(final String msg) {
    getLogger().warn(msg);
  }

  /**
   * @param msg
   */
  public void debugMsg(final String msg) {
    getLogger().debug(msg);
  }

  /**
   * @param t
   */
  public void error(final Throwable t) {
    getLogger().error(this, t);
  }
}
