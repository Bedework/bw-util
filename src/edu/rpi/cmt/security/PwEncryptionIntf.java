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
package edu.rpi.cmt.security;

import java.io.Serializable;

/** Interface for classes which encrypt and decrypt passwords
 *
 * @author Mike Douglass
 */
public interface PwEncryptionIntf extends Serializable {
  /** Bad stored password format */
  public static final String badPwFormat =
      "org.bedework.exception.security.badpwformat";

  /** Call before any other method.
   *
   * @param privKeys
   * @param pubKeys
   * @throws Throwable
   */
  public void init (final String privKeys,
                    final String pubKeys) throws Throwable;

  /** Encrypt the password and return the result.
   *
   * @param val
   * @return String
   * @throws Throwable
   */
  public String encrypt(String val) throws Throwable;

  /** Match the encrypted password - that is, encrypt the plain text and
   * compare.
   *
   * @param plain
   * @param encrypted
   * @return boolean true for a match
   * @throws Throwable
   */
  public boolean match(String plain,
                       String encrypted) throws Throwable;

  /** Decrypt the value
   *
   * @param encrypted
   * @return String plain text.
   * @throws Throwable
   */
  public String decrypt(String encrypted) throws Throwable;
}
