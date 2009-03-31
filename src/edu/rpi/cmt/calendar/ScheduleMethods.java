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

package edu.rpi.cmt.calendar;

import java.io.Serializable;

/**
 * @author douglm
 *
 */
public interface ScheduleMethods extends Serializable {
  /** */
  public static final int methodTypeNone = 0;

  /** */
  public static final int methodTypePublish = 1;

  /** */
  public static final int methodTypeRequest = 2;

  /** */
  public static final int methodTypeReply = 3;

  /** */
  public static final int methodTypeAdd = 4;

  /** */
  public static final int methodTypeCancel = 5;

  /** */
  public static final int methodTypeRefresh = 6;

  /** */
  public static final int methodTypeCounter = 7;

  /** */
  public static final int methodTypeDeclineCounter = 8;

  /** */
  public static final int methodTypeUnknown = 99;

  /** RFC methods
   */
  public final static String[] methods = {
    null,
    "PUBLISH",
    "REQUEST",
    "REPLY",
    "ADD",
    "CANCEL",
    "REFRESH",
    "COUNTER",
    "DECLINECOUNTER",
  };
}
