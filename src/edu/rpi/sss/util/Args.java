/* **********************************************************************
    Copyright 2009 Rensselaer Polytechnic Institute. All worldwide rights reserved.

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
package edu.rpi.sss.util;

import java.io.Serializable;

/** Class to help handling of Main method arguments.
 *
 * @author Mike Douglass
 */
public class Args implements Serializable {
  private String[] args;
  private int pos;

  /**
   * @param args
   */
  public Args(String[] args) {
    this.args = args;
  }

  /** Get the current argument without advancing
   *
   * @return String
   */
  public String current() {
    return args[pos];
  }

  /** Get the current argument and advance the index
   *
   * @return String
   */
  public String next() {
    pos++;
    return args[pos - 1];
  }

  /**
   * @return true if more args
   */
  public boolean more() {
    return pos < args.length;
  }

  /**
   * @param numargs
   * @return true if that may args are available
   */
  public boolean test(int numargs) {
    return (pos + numargs) <= args.length;
  }

  /**
   * @return true if the current arg starts with "-"
   */
  public boolean isMinusArg() {
    return more() && current().startsWith("-");
  }

  /**
   * @param val
   * @return true if the next arg matches the string
   * @throws Exception
   */
  public boolean ifMatch(String val) throws Exception {
    return ifMatch(val, 1);
  }

  /**
   * @param val
   * @param numargs
   * @return true if the next arg matches the string and has a sufficient number
   *     of parameters
   * @throws Exception
   */
  public boolean ifMatch(String val, int numargs) throws Exception {
    if (!current().equals(val)) {
      return false;
    }

    if (!test(numargs)) {
      throw new Exception("Invalid args");
    }

    pos++;
    return true;
  }
}
