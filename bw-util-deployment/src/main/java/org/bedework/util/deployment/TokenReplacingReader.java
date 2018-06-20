/* ********************************************************************
    Appropriate copyright notice
*/
package org.bedework.util.deployment;

import java.io.IOException;
import java.io.PushbackReader;
import java.nio.CharBuffer;
import java.io.Reader;

/**
 * Token replacement code based on http://tutorials.jenkov.com/java-howto/replace-strings-in-streams-arrays-files.html
 * User: mike Date: 6/19/18 Time: 23:00
 */
public class TokenReplacingReader extends Reader {
  private PushbackReader pushbackReader = null;
  private ITokenResolver tokenResolver = null;
  private final StringBuilder tokenNameBuffer = new StringBuilder();
  private String tokenValue = null;
  private int tokenValueIndex = 0;

  public TokenReplacingReader(final Reader source,
                              final ITokenResolver resolver) {
    this.pushbackReader = new PushbackReader(source, 2);
    this.tokenResolver = resolver;
  }

  public int read(final CharBuffer target) throws IOException {
    throw new RuntimeException("Operation Not Supported");
  }

  public int read() throws IOException {
    if (this.tokenValue != null) {
      if (this.tokenValueIndex < this.tokenValue.length()) {
        return this.tokenValue.charAt(this.tokenValueIndex++);
      }
      if (this.tokenValueIndex == this.tokenValue.length()) {
        this.tokenValue = null;
        this.tokenValueIndex = 0;
      }
    }

    int data = this.pushbackReader.read();
    if (data != '$') {
      return data;
    }

    data = this.pushbackReader.read();
    if (data != '{') {
      this.pushbackReader.unread(data);
      return '$';
    }
    this.tokenNameBuffer.delete(0, this.tokenNameBuffer.length());

    data = this.pushbackReader.read();
    while (data != '}') {
      this.tokenNameBuffer.append((char)data);
      data = this.pushbackReader.read();
    }

    this.tokenValue = this.tokenResolver
            .resolveToken(this.tokenNameBuffer.toString());

    if (this.tokenValue == null) {
      this.tokenValue = "${" + this.tokenNameBuffer.toString() + "}";
    }
    if (this.tokenValue.length() == 0) {
      return read();
    }
    return this.tokenValue.charAt(this.tokenValueIndex++);

  }

  public int read(final char cbuf[]) throws IOException {
    return read(cbuf, 0, cbuf.length);
  }

  public int read(final char cbuf[],
                  final int off,
                  final int len) throws IOException {
    int charsRead = 0;
    for (int i = 0; i < len; i++) {
      final int nextChar = read();
      if (nextChar == -1) {
        if (charsRead == 0) {
          charsRead = -1;
        }
        break;
      }
      charsRead = i + 1;
      cbuf[off + i] = (char)nextChar;
    }
    return charsRead;
  }

  public void close() throws IOException {
    this.pushbackReader.close();
  }

  public long skip(final long n) throws IOException {
    throw new RuntimeException("Operation Not Supported");
  }

  public boolean ready() throws IOException {
    return this.pushbackReader.ready();
  }

  public boolean markSupported() {
    return false;
  }

  public void mark(final int readAheadLimit) throws IOException {
    throw new RuntimeException("Operation Not Supported");
  }

  public void reset() throws IOException {
    throw new RuntimeException("Operation Not Supported");
  }
}
