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
package edu.rpi.cct.misc.indexing;

/** Pass back an exception from the indexing classes.
 *  The object will contain a property name and optionally one of an
 *  exception object representing some underlying cause or a string value for
 *  insertion in the message.
 *  <p>If a call on getCause returns a non-null result, the cause of the
 *  exception is some underlying exception.
 *  <p>Otherwise the property name and possibly the reason will be set.
 */
public class IndexException extends Exception {
  /** Exception property names.
   */

  /** "No files found - probably needs create" */
  public final static String noFiles = "edu.rpi.sss.indexing.exc.nofiles";

  /** "No base path specified" */
  public final static String noBasePath = "edu.rpi.sss.indexing.exc.nobasepath";

  /** "Insufficient access to create an index" */
  public final static String noIdxCreateAccess = "edu.rpi.sss.indexing.exc.noIdxCreateAccess";

  /** "Non-unique key term {0}" */
  public final static String dupKey = "edu.rpi.sss.indexing.exc.dupkey";

  /** "Insufficient access" */
  public final static String noAccess = "edu.rpi.sss.indexing.exc.noaccess";

  /** "Application error: Unknown record type {0}" */
  public final static String unknownRecordType = "edu.rpi.sss.indexing.exc.unknownrecordtype";

  /** "Exception occurred" */
  public final static String errException = "edu.rpi.sss.indexing.exc.exception";

  private String reason1;

  /**
   */
  public IndexException() {
    super();
  }

  /**
   * @param cause
   */
  public IndexException(Throwable cause) {
    super(cause);
  }

  /**
   * @param pr
   */
  public IndexException(String pr) {
    super(pr);
  }

  /**
   * @param pr
   * @param reason1
   */
  public IndexException(String pr, String reason1) {
    super(pr);
    this.reason1 = reason1;
  }

  /**
   * @return  String rason1
   */
  public String getReason1() {
    return reason1;
  }
}

