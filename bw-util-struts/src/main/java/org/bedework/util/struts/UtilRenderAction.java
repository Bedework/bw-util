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

import org.bedework.util.logging.BwLogger;
import org.bedework.util.servlet.filters.PresentationState;

import org.apache.struts.util.MessageResources;

/** This class is almost a null class to carry out render actions for
   applications. The struts redirect loses request parameters so we need
   to reinstate the action by saving them in the form and using them on
   the way out.

   @author Mike Douglass    douglm rpi.edu
 */
public class UtilRenderAction extends UtilAbstractAction {
  public String getId() {
    return "UtilRenderAction";
  }

  public String performAction(Request request,
                              MessageResources messages)
               throws Throwable {
    return "success";
  }

  @Override
  public String getContentName(final Request req) throws Throwable {
    UtilActionForm form = req.getForm();
    PresentationState ps = getPresentationState(req);
    String contentName = ps.getContentName();

    if (contentName != null) {
      form.setContentName(contentName);
    } else {
      contentName = form.getContentName();
      form.setContentName(null);  // It's a one shot and we're about to render
    }

    return contentName;
  }

  /* ====================================================================
   *                   Logged methods
   * ==================================================================== */

  private BwLogger logger = new BwLogger();

  @Override
  public BwLogger getLogger() {
    if ((logger.getLoggedClass() == null) && (logger.getLoggedName() == null)) {
      logger.setLoggedClass(getClass());
    }

    return logger;
  }
}

