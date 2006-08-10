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

