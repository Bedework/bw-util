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

import org.bedework.util.misc.Util;
import org.bedework.util.servlet.MessageEmit;

import org.apache.struts.action.ActionForm;
import org.apache.struts.util.MessageResources;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;
import java.util.Set;

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

  private Locale currentLocale;

  /* ..................... fields associated with locking ............... */

  /** Requests waiting */
  private int waiters;

  private boolean inuse;

  /** Is nocache on?
   */
  protected boolean nocache;

  /** An error object reinitialised at each entry to the abstract action
   */
  protected transient MessageEmit err;

  /** A message object reinitialised at each entry to the abstract action
   */
  protected transient MessageEmit msg;

  /** So we can get hold of properties
   */
  protected MessageResources mres;

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
  public void setCurrentLocale(Locale val) {
    currentLocale = val;
  }

  /**
   * @return current locale
   */
  public Locale getCurrentLocale() {
    if (currentLocale == null) {
      return Locale.getDefault();
    }
    return currentLocale;
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
    return new TimeDateFormatter(TimeDateFormatter.time,
                                 getCurrentLocale()).format(new Date());
  }

  /**
   * @return String
   */
  public String getCurDate() {
    return new TimeDateFormatter(TimeDateFormatter.date,
                                 getCurrentLocale()).format(new Date());
  }

  /**
   * @return String
   */
  public String getCurDateTime() {
    return new TimeDateFormatter(TimeDateFormatter.timeDate,
                                 getCurrentLocale()).format(new Date());
  }

  /**
   * @return String
   */
  public String getCurShortDate() {
    return new TimeDateFormatter(TimeDateFormatter.dateShort,
                                 getCurrentLocale()).format(new Date());
  }

  /**
   * @return String
   */
  public String getCurShortDateTime() {
    return new TimeDateFormatter(TimeDateFormatter.dateTimeShort,
                                 getCurrentLocale()).format(new Date());
  }
}

