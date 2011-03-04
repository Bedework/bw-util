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
package edu.rpi.cmt.security.pki;

import org.apache.commons.codec.binary.Base64;
import org.apache.log4j.Logger;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.security.Key;
import java.security.KeyFactory;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.PrivateKey;
import java.security.Provider;
import java.security.SecureRandom;
import java.security.Security;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;

import javax.crypto.Cipher;

/** Tools to implement public key encryption.
 *  Modified by Mike Douglass to incorporate into CVS repository and then for
 *  bedework.
 *
 * <p>Multiple keys are stored in 2 key files (public/private). The encrypted
 * value is stored with a key number which is used to select the key for
 * en/decryption.
 *
 * <p>If it is feared that the keys have been compromised, or perhaps simply as
 * a regular precaution, a new pair of keys can be created and appended to the
 * key files.
 *
 * <p>New uses will use the latest pair of keys.
 *
 *  User a encrypts with user b's public key.
 *  User b decrypts with their private key.
 *
 *  @author Alan Powell (powela rpi.edu)
 *  @author Mike Douglass (douglm rpi.edu)
 *  @version 1.02
 */
public class PKITools {
  private boolean debug;
  private boolean verbose;
  private Base64 b64 = new Base64();

  protected transient Logger log;

  private static class Schema {
    Provider p;
    String pName;
    String algorithm;
    String keyFactory;

    Schema(final Provider p, final String pName, final String algorithm,
           final String keyFactory) {
      this.p = p;
      this.pName = pName;
      this.algorithm = algorithm;
      this.keyFactory = keyFactory;
    }
  }

  Schema[] schemas = {
      new Schema(null, null, "RSA", "RSA"),
      // new Schema(new BouncyCastleProvider(), "BC", "RSA/ECB/PKCS1Padding", "RSA"),
  };

  Schema curSchema;

  /**
   * @author douglm
   *
   */
  public static class PKIException extends Throwable {
    /**
     * @param t
     */
    public PKIException(final Throwable t) {
      super(t);
    }

    /**
     * @param s
     */
    public PKIException(final String s) {
      super(s);
    }
  }

  /**
   * Constructor
   */
  public PKITools() {
    this(true, false);
  }

  /**
   * Constructor
   *
   * @param verbose
   * @param debug
   */
  public PKITools(final boolean verbose, final boolean debug) {
    this.verbose = verbose;
    this.debug = debug;

    curSchema = schemas[0];
    if (curSchema.p != null) {
      Security.addProvider(curSchema.p);
    }
  }

  /**
   */
  public class RSAKeys {
    /** */
    public byte[] privateKey;
    /** */
    public byte[] publicKey;
  }

  /**
   * @param privKeyFile
   * @param pubKeyFile
   * @param append     true to add the key to the files.
   * @return RSAKeys
   * @throws PKIException
   */
  public RSAKeys genRSAKeysIntoFiles(final String privKeyFile,
                                     final String pubKeyFile,
                                     final boolean append) throws PKIException {
    RSAKeys keys = genRSAKeys();

    if (keys == null) {
      return null;
    }

    try {
      // write the encoded key to a file
      writeFile(pubKeyFile, b64.encode(keys.publicKey), append);

      if (debug & verbose) {
        trace("Saving Private Key...");
      }

      // write the encoded key to a file
      writeFile(privKeyFile, b64.encode(keys.privateKey), append);

      return keys;
    } catch(Throwable t) {
      throw new PKIException(t);
    }
  }

  /**
   * @return RSAKeys
   * @throws PKIException
   */
  public RSAKeys genRSAKeys() throws PKIException {
    RSAKeys keys = new RSAKeys();

    try {
      SecureRandom secureRandom = new SecureRandom();
      secureRandom.nextBytes(new byte[1]);
      KeyPairGenerator rsaKeyGen;

      if (curSchema.pName == null) {
        rsaKeyGen = KeyPairGenerator.getInstance(curSchema.keyFactory);
      } else {
        rsaKeyGen = KeyPairGenerator.getInstance(curSchema.keyFactory,
                                                 curSchema.pName);
      }

      rsaKeyGen.initialize(1024, secureRandom);

      if (verbose) {
        trace("Generating keys...");
      }

      KeyPair rsaKeyPair = rsaKeyGen.generateKeyPair();

      if (verbose) {
        trace("Saving Public Key...");
      }

      keys.privateKey = rsaKeyPair.getPrivate().getEncoded();
      keys.publicKey = rsaKeyPair.getPublic().getEncoded();

      if (verbose) {
        trace("Done...");
      }

      return keys;
    } catch(Throwable t) {
      throw new PKIException(t);
    }
  }

  /**
   * @param pubKeyFile
   * @param item
   * @param keyNum
   * @return encrypted value
   * @throws PKIException
   */
  public String encryptWithKeyFile(final String pubKeyFile,
                                   final String item,
                                   final int keyNum) throws PKIException {
    try {
      if (verbose) {
        trace("Reading Public Key from file...");
      }

      return encrypt(b64.decode(getEncryptedKey(pubKeyFile, keyNum)), item);
    } catch(Throwable t) {
      throw new PKIException(t);
    }
  }

  /**
   * @param pubKeyBytes
   * @param item
   * @return encrypted value
   * @throws PKIException
   */
  public String encrypt(final byte[] pubKeyBytes,
                        final String item) throws PKIException {
    byte[] encryptedItem = null;
    Cipher asymmetricCipher;

    try {
      X509EncodedKeySpec publicKeySpec = new X509EncodedKeySpec(pubKeyBytes);
      Key publicKey;

      if (curSchema.pName == null) {
        KeyFactory kf = KeyFactory.getInstance(curSchema.algorithm);
        publicKey = kf.generatePublic(publicKeySpec);

        asymmetricCipher = Cipher.getInstance(curSchema.algorithm);
      } else {
        KeyFactory kf = KeyFactory.getInstance(curSchema.algorithm,
                                               curSchema.pName);
        publicKey = kf.generatePublic(publicKeySpec);

        asymmetricCipher = Cipher.getInstance(curSchema.algorithm,
                                              curSchema.pName);
      }

      asymmetricCipher.init(Cipher.ENCRYPT_MODE, publicKey);
      encryptedItem = asymmetricCipher.doFinal(item.getBytes());
    } catch(Throwable t) {
      throw new PKIException(t);
    }

    return new String(b64.encode(encryptedItem));
  }

  /**
   * @param privKeyFile
   * @param hexVal
   * @param keyNum
   * @return Decrypted value
   * @throws PKIException
   */
  public String decryptWithKeyFile(final String privKeyFile,
                                   final String hexVal,
                                   final int keyNum) throws PKIException {
    try {
      return decrypt(b64.decode(getEncryptedKey(privKeyFile, keyNum)), hexVal);
    } catch(PKIException pe) {
      throw pe;
    } catch(Throwable t) {
      throw new PKIException(t);
    }
  }

  /**
   * @param privKeyBytes
   * @param hexVal
   * @return String decrypted value
   * @throws PKIException
   */
  public String decrypt(final byte[] privKeyBytes,
                        final String hexVal) throws PKIException {
    Cipher asymmetricCipher;

    try {
      byte[] eVal = b64.decode(hexVal.getBytes());

      PKCS8EncodedKeySpec privateKeySpec = new PKCS8EncodedKeySpec(privKeyBytes);
      PrivateKey privateKey;

      if (curSchema.pName == null) {
        KeyFactory kf = KeyFactory.getInstance(curSchema.algorithm);
        privateKey = kf.generatePrivate(privateKeySpec);

        asymmetricCipher = Cipher.getInstance(curSchema.algorithm);
      } else {
        KeyFactory kf = KeyFactory.getInstance(curSchema.algorithm,
                                               curSchema.pName);
        privateKey = kf.generatePrivate(privateKeySpec);

        asymmetricCipher = Cipher.getInstance(curSchema.algorithm,
                                              curSchema.pName);
      }

      asymmetricCipher.init(Cipher.DECRYPT_MODE, privateKey);
      byte[] decryptedItem = asymmetricCipher.doFinal(eVal);

      return new String(decryptedItem);
    } catch(Throwable t) {
      throw new PKIException(t);
    }
  }

  /**
   * @param fileName
   * @return number of keys in file.
   * @throws PKIException
   */
  public int countKeys(final String fileName) throws PKIException {
    byte[] keys = getKeys(fileName);

    int foundKeys = 0;
    for (int i = 0; i <keys.length; i++) {
      if (keys[i] != '\n') {
        continue;
      }

      foundKeys++;
    }

    return foundKeys;
  }

  /* *************************************************************************
   *                 Private methods
   * ************************************************************************ */

  private byte[] getEncryptedKey(final String fileName,
                                 final int keyNum) throws PKIException {
    byte[] keys = getKeys(fileName);

    int foundKeys = 0;
    int keyStart = 0;
    for (int i = 0; i <keys.length; i++) {
      if (keys[i] != '\n') {
        continue;
      }

      if (keyNum != foundKeys) {
        keyStart = i + 1;
        foundKeys++;
        continue;
      }

      // At end of our key

      int keyLen = i - keyStart;
      byte[] key = new byte[keyLen];
      System.arraycopy(keys, keyStart, key, 0, keyLen);

      return key;
    }

    throw new PKIException("Invalid key number");
  }

  private byte[] getKeys(final String fileName) throws PKIException {
    FileInputStream fstr = null;
    byte[] keys = null;

    try {
      fstr = new FileInputStream(fileName);
      keys = new byte[fstr.available()];
      fstr.read(keys);
    } catch(Throwable t) {
      throw new PKIException(t);
    } finally {
      if (fstr != null) {
        try {
          fstr.close();
        } catch (Throwable t) {}
      }
    }

    return keys;
  }

  /** Write a single string to a file. Used to write keys
   *
   * @param fileName   String file to write to
   * @param bs         bytes to write
   * @param append     true to add the key to the file.
   * @throws IOException
   */
  private void writeFile(final String fileName,
                         final byte[] bs,
                         final boolean append) throws IOException {
    FileOutputStream fstr = null;

    try {
      fstr = new FileOutputStream(fileName, append);
      fstr.write(bs);

      // Terminate key with newline
      fstr.write('\n');

      fstr.flush();
    } finally {
      if (fstr != null) {
        fstr.close();
      }
    }
  }

  /* *
   * @param val
   * @return byte[]
   * /
  public static byte[] fromHex(String val) {
    if ((val == null) || (val.length() == 0)) {
      return null;
    }

    int nBytes = val.length()/2;

    byte[] bytes = new byte[nBytes];
    int offset=0;

    for(int i = 0; i < nBytes; i++) {
      bytes[i] = (byte)(Integer.parseInt(val.substring(offset, offset + 2), 16) &
                      0x000000FF);
      offset += 2;
    }

    return bytes;
  }*/

  /**
   * @return Logger
   */
  protected Logger getLogger() {
    if (log == null) {
      log = Logger.getLogger(this.getClass());
    }

    return log;
  }

  protected void debugMsg(final String msg) {
    getLogger().debug(msg);
  }

  protected void error(final Throwable t) {
    getLogger().error(this, t);
  }

  protected void error(final String msg) {
    getLogger().error(msg);
  }

  protected void trace(final String msg) {
    getLogger().debug(msg);
  }
}
