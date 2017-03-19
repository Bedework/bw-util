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
package org.bedework.util.cli;

import org.apache.log4j.Logger;

import java.io.IOException;
import java.io.Reader;
import java.io.StreamTokenizer;

/**
 * @author douglm
 *
 */
public class SfpTokenizer extends StreamTokenizer {
  private transient Logger log;

  private final boolean debug;

  private static final int WORD_CHAR_START = 32;

  private static final int WORD_CHAR_END = 255;

  private static final int WHITESPACE_CHAR_START = 0;

  private static final int WHITESPACE_CHAR_END = ' ';

  public static class ParseException extends Throwable {
    ParseException(final String msg) {
      super(msg);
    }

    ParseException(final Throwable t) {
      super(t);
    }
  }

  /**
   * @param rdr for our data
   */
  public SfpTokenizer(final Reader rdr) {
    super(rdr);

    debug = getLogger().isDebugEnabled();

    lowerCaseMode(false);
    wordChars(WORD_CHAR_START, WORD_CHAR_END);
    whitespaceChars(WHITESPACE_CHAR_START,
                              WHITESPACE_CHAR_END);
    ordinaryChar('.');
    ordinaryChar(':');
    ordinaryChar(';');
    ordinaryChar(',');
    ordinaryChar('~');
    ordinaryChar('=');
    ordinaryChar('!');
    ordinaryChar('>');
    ordinaryChar('<');
    ordinaryChar('&');
    ordinaryChar('|');
    ordinaryChar('(');
    ordinaryChar(')');
    ordinaryChar('\t');
    eolIsSignificant(false);
    whitespaceChars(0, 0);

    quoteChar('"');
    quoteChar('\'');
  }

  /**
   * @return int
   * @throws ParseException
   */
  public int next() throws ParseException {
    try {
      return nextToken();
    } catch (IOException e) {
      throw new ParseException(e);
    }
  }

  /**
   * Asserts that the next token in the stream matches the specified token.
   *
   * @param token expected token
   * @throws ParseException
   */
  public void assertToken(final int token) throws ParseException {
    try {
      if (nextToken() != token) {
        throw new ParseException("Expected [" + token + "], read [" +
                                  ttype + "] at " + lineno());
      }

      if (debug) {
        if (token > 0) {
          debugMsg("[" + (char)token + "]");
        } else {
          debugMsg("[" + token + "]");
        }
      }
    } catch (IOException e) {
      throw new ParseException(e);
    }
  }

  /**
   * @throws ParseException
   */
  public void assertWord() throws ParseException {
    assertToken(StreamTokenizer.TT_WORD);
  }

  /**
   * @throws ParseException
   */
  public void assertString() throws ParseException {
    if (testToken('"') || testToken('\'')) {
      return;
    }

    throw new ParseException("Expected <quoted-string>, read [" +
                                  ttype + "] at " + lineno());
  }

  /**
   * @return true if it's a quoted string
   * @throws ParseException
   */
  public boolean testString() throws ParseException {
    return testToken('"') || testToken('\'');
  }

  /**
   * Asserts that the next token in the stream matches the specified token.
   * This method is case-sensitive.
   *
   * @param token
   * @throws ParseException
   */
  public void assertToken(final String token) throws ParseException {
    assertToken(token, false);
  }

  /**
   * Asserts that the next token in the stream matches the specified token.
   *
   * @param token expected token
   * @param ignoreCase
   * @throws ParseException
   */
  public void assertToken(final String token, final boolean ignoreCase) throws ParseException {
    // ensure next token is a word token..
    assertWord();

    if (ignoreCase) {
      if (!token.equalsIgnoreCase(sval)) {
        throw new ParseException("Expected [" + token + "], read [" +
                                  sval + "] at " + lineno());
      }
    } else if (!token.equals(sval)) {
      throw new ParseException( "Expected [" + token + "], read [" +
                                sval + "] at " + lineno());
    }

    if (debug) {
      debugMsg("[" + token + "]");
    }
  }

  /**
   * @return boolean true if eof flagged
   * @throws ParseException
   */
  public boolean atEof() throws ParseException {
    return ttype == StreamTokenizer.TT_EOF;
  }

  /**
   * Tests that the next token in the stream matches the specified token.
   * This method is case-sensitive.
   *
   * @param token to match
   * @return boolean
   * @throws ParseException
   */
  public boolean testToken(final int token) throws ParseException {
    try {
      final boolean res = nextToken() == token;

      if (!res) {
        pushBack();
        return false;
      }

      return true;
    } catch (final IOException e) {
      throw new ParseException(e);
    }
  }

  /**
   * Tests if the next token in the stream matches the specified token.
   *
   * @param token expected token
   * @return int
   * @throws ParseException
   */
  public boolean testToken(final String token) throws ParseException {
    return testToken(token, true);
  }

  /**
   * Tests if the next token in the stream matches the specified token.
   *
   * @param token expected token
   * @param ignoreCase if it doesn't matter
   * @return boolean
   * @throws ParseException
   */
  public boolean testToken(final String token, final boolean ignoreCase) throws ParseException {
    // ensure next token is a word token..
    if (!testToken(StreamTokenizer.TT_WORD)) {
      return false;
    }

    if (ignoreCase) {
      if (!token.equalsIgnoreCase(sval)) {
        pushBack();
        return false;
      }
    } else if (!token.equals(sval)) {
      pushBack();
      return false;
    }

    return true;
  }

  /**
   * Absorbs extraneous newlines.
   * @throws ParseException
   */
  public void skipWhitespace() throws ParseException {
    while (true) {
      assertToken(StreamTokenizer.TT_EOL);
    }
  }

  protected Logger getLogger() {
    if (log == null) {
      log = Logger.getLogger(this.getClass());
    }

    return log;
  }

  protected void error(final Throwable t) {
    getLogger().error(this, t);
  }

  protected void warn(final String msg) {
    getLogger().warn(msg);
  }

  protected void debugMsg(final String msg) {
    getLogger().debug(msg);
  }

  protected void logIt(final String msg) {
    getLogger().info(msg);
  }

}
