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

import edu.rpi.sss.util.fmt.TimeDateFormatter;
import edu.rpi.sss.util.log.MessageEmit;
import edu.rpi.sss.util.servlets.PresentationState;
import edu.rpi.sss.util.Util;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.Set;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;

/**
 * This class provides some convenience methods for use by ActionForm objects.
 *
 * @author Mike Douglass
 */
public class UtilActionForm extends ActionForm {
  /** Are we debugging?
   */
  protected boolean debug;

  /** Have we initialised?
   */
  protected boolean initialised;

  /* ..................... fields associated with locking ............... */

  /** Requests waiting */
  private int waiters;

  private boolean inuse;

  /** Is nocache on?
   */
  protected boolean nocache;

  /** Current presentation state
   */
  protected PresentationState ps;

  protected transient Logger log;

  /** An error object reinitialised at each entry to the abstract action
   */
  protected transient MessageEmit err;

  /** A message object reinitialised at each entry to the abstract action
   */
  protected transient MessageEmit msg;

  /** So we can get hold of properties
   */
  protected MessageResources mres;

  protected ActionMapping mapping;

  /** Application variables. These can be set with request parameters and
   * dumped into the page for use by jsp and xslt.
   */
  protected HashMap appVars;

  /** One shot content name.
   */
  protected String contentName;

  /** Incoming URL.
   */
  protected String url;

  /* URL Components are here for the benefit of jsp to avoid cluttering up
     pages with code.
   */
  /** First part of URL. Allows us to target services on same host.
   */
  protected String schemeHostPort;

  protected String actionPath;

  private String actionParameter;

  /** The part of the URL that identifies the application -
   * Of the form "/" + name-of-app, e.g. /kiosk
   */
  protected String context;

  /** scheme + host + port part of the url together with the context.
   */
  protected String urlPrefix;

  /**
   * The current authenticated user. May be null
   */
  protected String currentUser;

  /**
   * Session id -
   */
  protected String sessionId;

  /**
   * Confirmation id - require this on forms
   */
  protected String confirmationId;

  /**
   * General yes/no answer
   */
  protected String yesno;

  /**
   * Browser type
   */
  protected String browserType = "default";

  /** We accumulate errors in this Collection as the form is processed.
   * We use processErrors to emit actual messages
   */
  private Collection<IntValError> valErrors = new ArrayList<IntValError>();

  /**
   * Value error
   */
  public static class ValError {
    /** */
    public String fldName;
    /** */
    public String badVal;

    /**
     * @param fldName
     * @param badVal
     */
    public ValError(String fldName, String badVal) {
      this.fldName = fldName;
      this.badVal = badVal;
    }
  }

  /**
   * ????
   */
  public static class IntValError extends ValError {
    /**
     * @param fldName
     * @param badVal
     */
    public IntValError(String fldName, String badVal) {
      super(fldName, badVal);
    }
  }

  /** Inc waiting for resource
   *
   */
  public void incWaiters() {
    waiters++;
  }

  /** Dec waiting for resource
   *
   */
  public void decWaiters() {
    waiters--;
  }

  /** Get waiting for resource
   *
   * @return num waiting for resource
   */
  public int getWaiters() {
    return waiters;
  }

  /** Set inuse flag
   *
   * @param val
   */
  public void assignInuse(boolean val) {
    inuse = val;
  }

  /**
   * @return boolean value of inuse flag
   */
  public boolean getInuse() {
    return inuse;
  }

  /** ================ Properties methods ============== */

  /**
   * @param val
   */
  public void setDebug(boolean val) {
    debug = val;
  }

  /**
   * @return true for debugging on
   */
  public boolean getDebug() {
    return debug;
  }

  /** Set initialised state
   *
   * @param val
   */
  public void setInitialised(boolean val) {
    initialised = val;
  }

  /**
   * @return initialised state
   */
  public boolean getInitialised() {
    return initialised;
  }

  /**
   * @param val
   */
  public void setNocache(boolean val) {
    nocache = val;
  }

  /**
   * @return boolean true for nocache
   */
  public boolean getNocache() {
    return nocache;
  }

  /**
   * @param val
   */
  public void setPresentationState(PresentationState val) {
    ps = val;
  }

  /**
   * @return PresentationState
   */
  public PresentationState getPresentationState() {
    return ps;
  }

  /** Returns a base for use in urls within generated pages.
   * If no presentation state is present, or the app root is null we return
   * a zero length string - this will make the resulting url relative to the
   * application.
   *
   * <p>Otherwise we return the app root, appending a path separator if not
   * present.
   *
   * @return  String     base for urls.
   */
  public String getAppBase() {
    if ((ps == null) || (ps.getAppRoot() == null)) {
      return "";
    }

    String ar = ps.getAppRoot();

    if (!ar.endsWith("/")) {
      return ar + "/";
    }

    return ar;
  }

  /**
   * @return MessageResources
   */
  public MessageResources getMres() {
    return mres;
  }

  /**
   * @param val
   */
  public void setMres(MessageResources val) {
    mres = val;
  }

  /**
   * @param val ActionMapping
   */
  public void setMapping(ActionMapping val) {
    mapping = val;
  }

  /**
   * @return ActionMapping
   */
  public ActionMapping getMapping() {
    return mapping;
  }

  /**
   * @param val
   */
  public void setLog(Logger val) {
    log = val;
  }

  /**
   * @return Logger
   */
  public Logger getLog() {
    if (log == null) {
      log = Logger.getLogger(this.getClass());
    }

    return log;
  }

  /**
   * @param val
   */
  public void setErr(MessageEmit val) {
    err = val;
  }

  /**
   * @return MessageEmit
   */
  public MessageEmit getErr() {
    return err;
  }

  /**
   * @return boolean
   */
  public boolean getErrorsEmitted() {
    return err.messagesEmitted();
  }

  /**
   * @param val
   */
  public void setMsg(MessageEmit val) {
    msg = val;
  }

  /**
   * @return boolean
   */
  public MessageEmit getMsg() {
    return msg;
  }

  /**
   * @return boolean
   */
  public boolean getMessagesEmitted() {
    return msg.messagesEmitted();
  }

  /** Can be called by a page to signal an exceptiuon
   *
   * @param t
   */
  public void setException(Throwable t) {
    if (err == null) {
      t.printStackTrace();
    } else {
      err.emit(t);
    }
  }

  /**
   * @param val
   */
  public void setAppVarsTbl(HashMap val) {
    appVars = val;
  }

  /**
   * @return Set
   */
  public Set getAppVars() {
    if (appVars == null) {
      return new HashMap().entrySet();
    }
    return appVars.entrySet();
  }

  /** Get a list of property values and return as a string array. The
   *  properties are stored with consectutively numbered names as in
   *  <pre>
   *     prop1=aval
   *     prop2=bval
   *  </pre>
   *  There can be no gaps in the sequence.
   *  setMres must have been called previously.
   *
   * @param prop       Property name
   * @return String[]  values as a String array
   */
  public String[] getVals(String prop) {
    return getVals(null, prop, null);
  }

  /** Get a list of property values and return as a string array. The
   *  properties are stored with consectutively numbered names as in
   *  <pre>
   *     prop1=aval
   *     prop2=bval
   *  </pre>
   *  There can be no gaps in the sequence.
   *  If pre or post are non-null they are the property names of values to
   *  be added to the beginning or end.
   *  setMres must have been called previously.
   *
   * @param pre        Property name of prefix
   * @param prop       Property name
   * @param post       Property name of postfix
   * @return String[]  values as a String array
   */
  public String[] getVals(String pre, String prop, String post) {
    ArrayList<String> al = new ArrayList<String>();

    if (pre != null) {
      // Add at the front.
      String s = mres.getMessage(pre);
      if (s != null) {
        al.add(s);
      }
    }

    int i = 1;

    for (;;) {
      String u = mres.getMessage(prop + i);
      if (u == null) {
        // No more
        break;
      }

      al.add(u);
      i++;
    }

    if (post != null) {
      // Add at the front.
      String s = mres.getMessage(post);
      if (s != null) {
        al.add(s);
      }
    }

    return (String[])al.toArray(new String[al.size()]);
  }

  /**
   * @param val
   */
  public void setContentName(String val) {
    contentName = val;
  }

  /**
   * @return String
   */
  public String getContentName() {
    return contentName;
  }

  /**
   * @param val
   */
  public void setUrl(String val) {
    url = val;
  }

  /**
   * @return String
   */
  public String getUrl() {
    return url;
  }

  /**
   * @param val
   */
  public void setSchemeHostPort(String val) {
    schemeHostPort = val;
  }

  /**
   * @return String
   */
  public String getSchemeHostPort() {
    return schemeHostPort;
  }

  /** Set the part of the URL that identifies the application.
   *
   * @param val       context path in form "/" + name-of-app, e.g. /kiosk
   */
  public void setContext(String val) {
    context = val;
  }

  /**
   * @return String
   */
  public String getContext() {
    return context;
  }

  /** Sets the scheme + host + port part of the url together with the
   *  path up to the servlet path. This allows us to append a new action to
   *  the end.
   *  <p>For example, we want val="http://myhost.com:8080/myapp"
   *
   *  @param  val   the URL prefix
   */
  public void setUrlPrefix(String val) {
    urlPrefix = val;
  }

  /** Returns the scheme + host + port part of the url together with the
   *  path up to the servlet path. This allows us to append a new action to
   *  the end.
   *
   *  @return  String   the URL prefix
   */
  public String getUrlPrefix() {
    return urlPrefix;
  }

  /** Set the part of the URL that identifies the action.
   *
   * @param val       path in form "/" + action, e.g. /update.do
   */
  public void setActionPath(String val) {
    actionPath = val;
  }

  /**
   * @return String
   */
  public String getActionPath() {
    return actionPath;
  }

  /** Set the action parameter if any.
   *
   * @param val       String action parameter
   */
  public void setActionParameter(String val) {
    actionParameter = val;
  }

  /**
   * @return String
   */
  public String getActionParameter() {
    return actionParameter;
  }

  /** This should not be setCurrentUser as that exposes it to the incoming
   * request.
   *
   * @param val      String user id
   */
  public void assignCurrentUser(String val) {
    currentUser = val;
  }

  /**
   * @return String
   */
  public String getCurrentUser() {
    return currentUser;
  }

  /** This should not be setSessionId as that exposes it to the incoming
   * request.
   *
   * @param val      String session id
   */
  public void assignSessionId(String val) {
    sessionId = val;
  }

  /**
   * @return String
   */
  public String getSessionId() {
    return sessionId;
  }

  /** This should not be setConfirmationId as that exposes it to the incoming
   * request.
   *
   * @param val      String confirmation id
   */
  public void assignConfirmationId(String val) {
    confirmationId = val;
  }

  /**
   * @return String
   */
  public String getConfirmationId() {
    if (confirmationId == null) {
      confirmationId = Util.makeRandomString(16, 35);
    }

    return confirmationId;
  }

  /**
   * @param val
   */
  public void setYesno(String val) {
    yesno = val;
  }

  /**
   * @return String
   */
  public String getYesno() {
    return yesno;
  }

  /**
   * @return String
   */
  public boolean isYes() {
    return ((yesno != null) && (yesno.equalsIgnoreCase("yes")));
  }

  /**
   * @param val
   */
  public void setBrowserType(String val) {
    browserType = val;
  }

  /**
   * @return String
   */
  public String getBrowserType() {
    return browserType;
  }

  /** ----------------------------------------------------------------
   *      <center>Value conversion and error processing.</center>
   *  ---------------------------------------------------------------- */

  /** Convert a string parameter so we can add an
   * error message for incorrect formats (instead of relying on Struts).
   *
   * <p>Struts tends to return 0 or null for illegal values, e.g., alpha
   * characters for a number.
   *
   * @param newVal
   * @param curVal
   * @param name
   * @return String
   */
  public int intVal(String newVal, int curVal, String name) {
    int newInt;

    try {
      newInt = Integer.parseInt(newVal);
    } catch (Exception e) {
      valErrors.add(new IntValError(name, newVal));
      newInt = curVal;
    }

    return newInt;
  }

  /** processErrors is called to determine if there were any errors.
   * If so processError is called for each error adn the errors vector
   * is cleared.
   * Override the processError method to emit custom messages.
   *
   * @param err      MessageEmit object
   * @return boolean True if there were errors
   */
  public boolean processErrors(MessageEmit err) {
    if (valErrors.size() == 0) {
      return false;
    }

    for (ValError ve: valErrors) {
      processError(err, ve);
    }

    valErrors.clear();
    return true;
  }

  /** Override this to emit messages
   *
   * @param err
   * @param ve
   */
  public void processError(MessageEmit err, ValError ve) {
  }

  /* Current time and date formatting
   */

  /**
   * @return String
   */
  public String getCurTime() {
    return new TimeDateFormatter(TimeDateFormatter.time).format(new Date());
  }

  /**
   * @return String
   */
  public String getCurDate() {
    return new TimeDateFormatter(TimeDateFormatter.date).format(new Date());
  }

  /**
   * @return String
   */
  public String getCurDateTime() {
    return new TimeDateFormatter(TimeDateFormatter.timeDate).format(new Date());
  }

  /**
   * @return String
   */
  public String getCurShortDate() {
    return new TimeDateFormatter(TimeDateFormatter.dateShort).format(new Date());
  }

  /**
   * @return String
   */
  public String getCurShortDateTime() {
    return new TimeDateFormatter(TimeDateFormatter.dateTimeShort).format(new Date());
  }

  /**
   * @param val
   */
  public void debugMsg(String val) {
    getLog().debug(val);
  }
}

