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

/** Scheduling messages can have one of the following states
 *
 * @author douglm
 *
 */
public interface ScheduleStates extends Serializable {
  /** Unprocessed */
  public final static int scheduleUnprocessed = -1;

  /** Added to users inbox */
  public final static int scheduleOk = 0;

  /** */
  public final static int scheduleNoAccess = 1;

  /** User is external - will be contacted */
  public final static int scheduleDeferred = 2;

  /** Earlier request so ignored */
  public final static int scheduleIgnored = 3;

  /** Failed to send */
  public final static int scheduleError = 4;
}
