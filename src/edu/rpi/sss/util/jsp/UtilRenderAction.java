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

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.struts.util.MessageResources;

/** This class is almost a null class to carry out render actions for
   applications. The struts redirect loses request parameters so we need
   to reinstate the action by saving them in the form and using them on
   the way out.

   @author Mike Douglass    douglm@rpi.edu
 */
public class UtilRenderAction extends UtilAbstractAction {
  /* (non-Javadoc)
   * @see edu.rpi.sss.util.jsp.UtilAbstractAction#getId()
   */
  public String getId() {
    return "UtilRenderAction";
  }

  /* (non-Javadoc)
   * @see edu.rpi.sss.util.jsp.UtilAbstractAction#performAction(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, edu.rpi.sss.util.jsp.UtilActionForm, org.apache.struts.util.MessageResources)
   */
  public String performAction(HttpServletRequest request,
                              HttpServletResponse response,
                              UtilActionForm frm,
                              MessageResources messages)
               throws Throwable {
    return "success";
  }

  /* (non-Javadoc)
   * @see edu.rpi.sss.util.jsp.UtilAbstractAction#getContentName(edu.rpi.sss.util.jsp.UtilActionForm)
   */
  public String getContentName(UtilActionForm form) {
    String contentName = form.getPresentationState().getContentName();

    if (contentName != null) {
      form.setContentName(contentName);
    } else {
      contentName = form.getContentName();
      form.setContentName(null);  // It's a one shot and we're about to render
    }

    return contentName;
  }
}

