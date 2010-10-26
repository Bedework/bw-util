/* **********************************************************************
    Copyright 2008 Rensselaer Polytechnic Institute. All worldwide rights reserved.

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
