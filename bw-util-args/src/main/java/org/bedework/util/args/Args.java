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
package org.bedework.util.args;

import java.io.Serializable;

/** Class to help handling of Main method arguments.
 *
 * @author Mike Douglass
 */
public class Args implements Serializable {
  private final String[] args;
  private int pos;

  /**
   * @param args command line arguments
   */
  public Args(final String[] args) {
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

  /** Check there are sufficient arguments left.
   *
   * @param numargs number of args we need
   * @return true if that many args are available
   */
  public boolean test(final int numargs) {
    return (pos + numargs) <= args.length;
  }

  /**
   * @return true, if the current arg starts with "-"
   */
  public boolean isMinusArg() {
    return more() && current().startsWith("-");
  }

  /**
   * @param val to match
   * @return true if the next arg matches the string
   * @throws Exception
   */
  public boolean ifMatch(final String val) throws Exception {
    return ifMatch(val, 1);
  }

  /**
   * @param val to match
   * @param numargs number of args we need
   * @return true if the next arg matches the string and has a sufficient number
   *     of parameters
   * @throws Exception
   */
  public boolean ifMatch(final String val,
                         final int numargs) throws Exception {
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
