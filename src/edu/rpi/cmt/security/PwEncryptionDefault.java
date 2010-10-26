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

import edu.rpi.cmt.security.pki.PKITools;

import org.apache.log4j.Logger;

/**
 * @author Mike Douglass
 */
public class PwEncryptionDefault implements PwEncryptionIntf {
  private boolean debug;

  private String privKeys;

  private String pubKeys;

  private PKITools pki;

  private transient Logger log;

  /**
   * @throws Throwable
   */
  public PwEncryptionDefault() throws Throwable {
    debug = getLog().isDebugEnabled();
    pki = new PKITools(false /*verbose*/, debug);
  }

  /**
   * @param privKeys
   * @param pubKeys
   * @throws Throwable
   */
  public void init (final String privKeys,
                    final String pubKeys) throws Throwable {
    this.privKeys = privKeys;
    this.pubKeys = pubKeys;
  }

  public String encrypt(final String val) throws Throwable {
    int numKeys = pki.countKeys(privKeys);

    if (debug) {
      debugMsg("Number of keys: " + numKeys);
    }

    int keyNum = numKeys - 1;

    String etext = pki.encryptWithKeyFile(pubKeys,
                                          val, keyNum);

    StringBuilder sb = new StringBuilder();

    sb.append(keyNum);
    sb.append("{");
    sb.append(etext);
    sb.append("}");

    return sb.toString();
  }

  public boolean match(final String plain,
                       final String encrypted) throws Throwable {
    return encrypt(plain).equals(encrypted);
  }

  public String decrypt(final String encrypted) throws Throwable {
    int pos = encrypted.indexOf("{");

    if ((pos < 0) || (encrypted.lastIndexOf("}") != encrypted.length() - 1)) {
      throw new Exception(badPwFormat);
    }

    int keyNum = Integer.valueOf(encrypted.substring(0, pos));
    return pki.decryptWithKeyFile(privKeys,
                                  encrypted.substring(pos + 1, encrypted.length() - 1),
                                  keyNum);
  }

  private Logger getLog() {
    if (log == null) {
      log = Logger.getLogger(this.getClass());
    }

    return log;
  }

  private void debugMsg(final String msg) {
    getLog().debug(msg);
  }
}
