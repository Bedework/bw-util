/* **********************************************************************
    Copyright 2010 Rensselaer Polytechnic Institute. All worldwide rights reserved.

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

package edu.rpi.cmt.db.hibernate;

import javax.servlet.http.HttpServletResponse;
import javax.xml.namespace.QName;

/** Base exception thrown by hibernate classes
 *
 *   @author Mike Douglass   douglm  rpi.edu
 */
public class HibException extends Throwable {
  /** > 0 if set
   */
  int statusCode = -1;
  QName errorTag;

  /** Constructor
   *
   * @param s
   */
  public HibException(final String s) {
    super(s);
    if (statusCode < 0) {
      statusCode = HttpServletResponse.SC_INTERNAL_SERVER_ERROR;
    }
  }

  /** Constructor
   *
   * @param t
   */
  public HibException(final Throwable t) {
    super(t);
    if (statusCode < 0) {
      statusCode = HttpServletResponse.SC_INTERNAL_SERVER_ERROR;
    }
  }

  /** Constructor
   *
   * @param st
   */
  public HibException(final int st) {
    statusCode = st;
  }

  /** Constructor
   *
   * @param st
   * @param msg
   */
  public HibException(final int st, final String msg) {
    super(msg);
    statusCode = st;
  }

  /** Constructor
   *
   * @param st
   * @param errorTag
   */
  public HibException(final int st, final QName errorTag) {
    statusCode = st;
    this.errorTag = errorTag;
  }

  /** Constructor
   *
   * @param st
   * @param errorTag
   * @param msg
   */
  public HibException(final int st, final QName errorTag, final String msg) {
    super(msg);
    statusCode = st;
    this.errorTag = errorTag;
  }

  /** Set the status
   * @param val int status
   */
  public void setStatusCode(final int val) {
    statusCode = val;
  }

  /** Get the status
   *
   * @return int status
   */
  public int getStatusCode() {
    return statusCode;
  }

  /** Get the errorTag
   *
   * @return QName
   */
  public QName getErrorTag() {
    return errorTag;
  }
}
