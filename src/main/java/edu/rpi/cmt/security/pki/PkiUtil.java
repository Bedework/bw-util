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

/**
 * This program helps create keys and encrypt/decrypt data
 *
 * @author Mike Douglass
 */
public class PkiUtil {
  private boolean debug = false;
  private boolean verbose = false;

  protected transient Logger log;

  private boolean genKeys = false; // generate keys
  private boolean encrypt = false; // Encrypt a file
  private boolean decrypt = false; // Decrypt a file
  private boolean dumppublic = false; // Dump the public key as text

  private String privKeyFileName;
  private String pubKeyFileName;
  private boolean append = true;

  private String inFileName;
  private String outFileName;

  //private PropertyUtil pr; // properties used throughout
  private PKITools pki;

  /** Following is some random text which we encode and decode to ensure
   *  generated keys work
   */
  String testText =
    "A variable of array type holds a reference to an object. ";/* +
    "Declaring a variable of array type does not create an array object \n" +
    "or allocate any space for array components. It creates only the \n" +
    "variable itself, which can contain a reference to an array. However, \n" +
    "the initializer part of a declarator (§8.3) may create an array, a \n" +
    "reference to which then becomes the initial value of the variable.\n";/* +
    " \n" +
    "Because an array's length is not part of its type, a single variable \n" +
    "of array type may contain references to arrays of different lengths.\n" +
    "\n" +
    "Here are examples of declarations of array variables that do not \n" +
    "create arrays:\n" +
    "\n" +
    "    int[] ai;    // array of int\n" +
    "    short[][] as;    // array of array of short\n" +
    "    Object[]    ao,    // array of Object\n" +
    "           otherAo;  // array of Object\n" +
    "    short  s,    // scalar short \n" +
    "           aas[][];  // array of array of short";
    */

  String getInFileName() {
    return inFileName;
  }

  String getOutFileName() {
    return outFileName;
  }

  boolean getDebug() {
    return debug;
  }

  boolean getGenKeys() {
    return genKeys;
  }

  boolean getEncrypt() {
    return encrypt;
  }

  boolean getDecrypt() {
    return decrypt;
  }

  void processArgs(final String[] args) throws Exception {
    if (args == null) {
      return;
    }

    for (int i = 0; i < args.length; i++) {
      if (args[i].equals("-genkeys")) {
        genKeys = true;
      } else if (args[i].equals("-encrypt")) {
        encrypt = true;
        decrypt = false;
      } else if (args[i].equals("-decrypt")) {
        encrypt = false;
        decrypt = true;
      } else if (args[i].equals("-verbose")) {
        verbose = true;
      } else if (args[i].equals("-nverbose")) {
        verbose = false;
      } else if (args[i].equals("-append")) {
        append = true;
      } else if (args[i].equals("-nappend")) {
        append= false;
      } else if (args[i].equals("-debug")) {
        debug = true;
      } else if (args[i].equals("-ndebug")) {
        debug = false;
      } else if (args[i].equals("-dumppublic")) {
        dumppublic = true;
      } else if (argpar("-in", args, i)) {
        i++;
        inFileName = args[i];
      } else if (argpar("-out", args, i)) {
        i++;
        outFileName = args[i];
      } else if (argpar("-key", args, i)) {
        i++;
        privKeyFileName = args[i];
      } else if (argpar("-privkey", args, i)) {
        i++;
        privKeyFileName = args[i];
      } else if (argpar("-pubkey", args, i)) {
        i++;
        pubKeyFileName = args[i];
      }
    }
  }

  boolean argpar(final String n, final String[] args, final int i) throws Exception {
    if (!args[i].equals(n)) {
      return false;
    }

    if ((i + 1) == args.length) {
      throw new Exception("Invalid arguments");
    }

    return true;
  }

  boolean doGenKeys() throws Throwable {
    if (privKeyFileName == null) {
      error("Must provide a -privkey <file> parameter");
      return false;
    }

    if (pubKeyFileName == null) {
      error("Must provide a -pubkey <file> parameter");
      return false;
    }

    PKITools.RSAKeys keys = pki.genRSAKeysIntoFiles(privKeyFileName,
                                                    pubKeyFileName,
                                                    append);
    if (keys == null) {
      error("Generation of keys failed");
      return false;
    }

    if (dumppublic) {
      if (!dumpKey(keys.publicKey)) {
        return false;
      }
    }

    // Now try the keys on the test text.

    int numKeys = pki.countKeys(privKeyFileName);

    if (debug) {
      debugMsg("Number of keys: " + numKeys);
    }

    System.out.println("test with---->" + testText);
    String etext = pki.encryptWithKeyFile(pubKeyFileName, testText, numKeys - 1);
    System.out.println("encrypts to-->" + etext);
    String detext = pki.decryptWithKeyFile(privKeyFileName, etext, numKeys - 1);
    System.out.println("decrypts to-->" + detext);

    if (!testText.equals(detext)) {
      error("Validity check failed: encrypt/decrypt failure");
    }

    return true;
  }

  boolean doit(final String[] args) throws Throwable {
    processArgs(args);

    pki = new PKITools(verbose);

    if (getGenKeys()) {
      return doGenKeys();
    }

    return false;
  }

  /** Dump a byte array as a base 64 encoded value. We also check that the
   *  form we emit can be decoded and produce an identical key.
   *  <p>
   *  We then go on to encode and decode our testText to see if they match.
   *
   * @param key
   * @return boolean
   * @throws Exception
   */
  private boolean dumpKey(final byte[] key) throws Exception {
    byte[] encoded = Base64.encodeBase64Chunked(key);
    String encText = new String(encoded);

    System.out.println("Copy the text between the delimiters");
    System.out.println("Take all below this line ----------------------->");
    System.out.println(encText);
    System.out.println("<--------------- up to and not including this line");

    // See if it decodes
    byte[] decoded = Base64.encodeBase64Chunked(encText.getBytes());

    if (decoded.length != key.length) {
      error("Validity check failed: lengths not equal " +
           "(decoded=" + decoded.length + " key=" + key.length + ")");
      dumpHex(decoded);
      error(" ");
      dumpHex(key);
      return false;
    }

    for (int i = 0; i < decoded.length; i++) {
      if (decoded[i] != key[i]) {
        error("Validity check failed: byte at position " + i + " not equal");
        dumpHex(decoded);
        error(" ");
        dumpHex(key);

        return false;
      }
    }

    return true;
  }

  private void dumpHex(final byte[] hex) {
    StringBuffer sb = new StringBuffer();

    for (int i = 0; i < hex.length; i++) {
      sb.append(toHex(hex[i]));
      // string += toHex(byteArray[i]) + " ";
    }

    int pos = 0;
    int seglen = 50;
    while (pos < sb.length()) {
      int len = Math.min(seglen, sb.length() - pos);

      error(" " + sb.substring(pos, pos + len));

      pos += len;
    }
  }

  private static String toHex(final byte b) {
    int i = (b >> 4) & 0x0F;
    String tmp;

    if (i < 10) {
      tmp = Integer.toString(i);
    } else {
      tmp = new Character((char)(('A'+i)-10)).toString();
    }

    i = b & 0x0F;

    if (i < 10) {
      tmp += Integer.toString(i);
    } else {
      tmp += new Character((char)('A'+(i-10))).toString();
    }

    return tmp;
  }

  /**
   * @param args
   */
  public static void main(final String[] args) {
    PkiUtil pkiu = new PkiUtil();

    try {
      pkiu.doit(args);
    } catch (Throwable t) {
      t.printStackTrace();
    }
  }

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

