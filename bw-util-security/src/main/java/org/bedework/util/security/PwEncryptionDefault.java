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
package org.bedework.util.security;

import org.bedework.util.logging.Logged;
import org.bedework.util.security.pki.PKITools;

import java.security.PrivateKey;

/**
 * @author Mike Douglass
 */
public class PwEncryptionDefault implements PwEncryptionIntf, Logged {
  private String privKeys;

  private String pubKeys;

  private PKITools pki;

  /**
   * @throws Throwable
   */
  public PwEncryptionDefault() throws Throwable {
    pki = new PKITools();
  }

  /**
   * @param privKeys
   * @param pubKeys
   * @throws Throwable
   */
  @Override
  public void init (final String privKeys,
                    final String pubKeys) throws Throwable {
    this.privKeys = privKeys;
    this.pubKeys = pubKeys;
  }

  @Override
  public String encrypt(final String val) throws Throwable {
    int numKeys = pki.countKeys(privKeys);

    if (debug()) {
      debug("Number of keys: " + numKeys);
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

  @Override
  public boolean match(final String plain,
                       final String encrypted) throws Throwable {
    return encrypt(plain).equals(encrypted);
  }

  @Override
  public String decrypt(final String encrypted) throws Throwable {
    int pos = encrypted.indexOf("{");

    if ((pos < 0) || (encrypted.lastIndexOf("}") != (encrypted.length() - 1))) {
      throw new Exception(badPwFormat);
    }

    int keyNum = Integer.valueOf(encrypted.substring(0, pos));
    return pki.decryptWithKeyFile(privKeys,
                                  encrypted.substring(pos + 1, encrypted.length() - 1),
                                  keyNum);
  }

  @Override
  public byte[] getPublicKey() throws Throwable {
    return pki.getPublicKey(pubKeys);
  }

  @Override
  public PrivateKey getPrivateKey() throws Throwable {
    return pki.getPrivateKey(privKeys);
  }
}
