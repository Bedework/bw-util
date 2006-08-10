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

package edu.rpi.sss.util.log;

import java.io.Serializable;

/** This object allows context free error message generation.
 *  At the point messages are generated we might be called from the web
 *  world or from an application world.
 *
 * <p>Each method takes a property name as the first parameter.
 * Optional arguments follow.
 *
 * <p>The implementation is of course free to interpret the first parameter
 * any way it wants. The assumption though, is that rather than providing
 * the actual message text the pname acts as a reference.
 *
 * @author Mike Douglass douglm@rpi.edu
 * @version 1.0
 */
public interface MessageEmit extends Serializable {
  /** We define a number of message emit methods.
   */

  /** Emit message with given property name
   *
   * @param pname
   */
  public void emit(String pname);

  /** Emit message with given property name and int value
   *
   * @param pname
   * @param num
   */
  public void emit(String pname, int num);

  /** Set the property name of the default exception message
   *
   * @param pname
   */
  public void setExceptionPname(String pname);

  /** Emit an exception message
   *
   * @param t
   */
  public void emit(Throwable t);

  /** Emit message with given property name and Object value
   *
   * @param pname
   * @param o
   */
  public void emit(String pname, Object o);

  /** Emit message with given property name and Object values
   *
   * @param pname
   * @param o1
   * @param o2
   */
  public void emit(String pname, Object o1, Object o2);

  /** Emit message with given property name and Object values
   *
   * @param pname
   * @param o1
   * @param o2
   * @param o3
   */
  public void emit(String pname, Object o1, Object o2, Object o3);

  /** Indicate no messages emitted.
   */
  public void clear();

  /** @return true if any messages emitted
   */
  public boolean messagesEmitted();
}

