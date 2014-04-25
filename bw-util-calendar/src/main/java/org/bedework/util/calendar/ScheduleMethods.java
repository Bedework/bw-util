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
package org.bedework.util.calendar;

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
  public static final int methodTypePollStatus = 9;

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
    "POLLSTATUS",
  };
}
