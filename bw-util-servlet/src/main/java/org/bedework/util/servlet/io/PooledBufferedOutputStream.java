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
package org.bedework.util.servlet.io;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;

/** See if we can't manage buffers better than the standard java classes - at
 * least for the specific use we have. We are generating a lot of output and
 * causing a lot of expansion and copying.
 *
 * <P>This may result in a lot of JVM churn. See if a pool of buffers can
 * improve matters.
 *
 * @author Mike Douglass
 */
public class PooledBufferedOutputStream extends OutputStream {
    /**
   * The number of valid bytes in the virtual buffer.
   */
  protected int count;

  /* Buffers obtained from the pool. */
  private ArrayList<BufferPool.Buffer> buffers = new ArrayList<>();

  private BufferPool.Buffer curBuffer;

  /**
   * Creates a new pooled buffered output stream.
   */
  public PooledBufferedOutputStream() {
  }

  /**
   * Writes the specified byte to this byte array output stream.
   *
   * @param   b   the byte to be written.
   */
  @Override
  public synchronized void write(final int b) {
    BufferPool.Buffer buff = getBuffer(count, false);

    if (buff == null) {
      buff = newBuffer();
    }

    if (!buff.putByte(b)) {
      buff = newBuffer();
      if (!buff.putByte(b)) {
        throw new RuntimeException("Logic error in write(b)");
      }
    }

    count++;
  }

  @Override
  public synchronized void write(final byte b[],
                                 final int off,
                                 final int len) throws IOException {
    if (len == 0) {
      return;
    }

    int srcoffset = off;
    int srclen = len;

    for (;;) {
      BufferPool.Buffer buff = getBuffer(count, false);

      if (buff == null) {
        buff = newBuffer();
      }

      int remaining = buff.putBytes(b, srcoffset, srclen);

      int moved = srclen - remaining;
      if (moved == 0) {
        buff = newBuffer();
      }

      count += moved;

      if (remaining == 0) {
        break;
      }

      srcoffset += moved;
      srclen -= moved;
    }
  }

  /**
   * Writes the complete contents of this byte array output stream to
   * the specified output stream argument, as if by calling the output
   * stream's write method using <code>out.write(buf, 0, count)</code>.
   *
   * @param      out   the output stream to which to write the data.
   * @exception  IOException  if an I/O error occurs.
   */
  public synchronized void writeTo(final OutputStream out) throws IOException {
    for (BufferPool.Buffer b: buffers) {
      out.write(b.buf, 0, b.pos);
    }
  }

  private class PooledBuffersInputStream extends InputStream {
    int pos;

    @Override
    public int read() throws IOException {
      BufferPool.Buffer b = getBuffer(pos, true);

      if (b == null) {
        return -1;
      }

      int res = b.getByte(pos);
      pos++;

      return res;
    }
  }

  /** Get an InputStream for the bytes in the buffer. No guarantees if writes
   * take place after this is called.
   *
   * @return InputStream
   * @throws IOException
   */
  public synchronized InputStream getInputStream() throws IOException {
    return new PooledBuffersInputStream();
  }

  /**
   * Creates a newly allocated byte array. Its size is the current
   * size of this output stream and the valid contents of the buffer
   * have been copied into it.
   *
   * @return  the current contents of this output stream, as a byte array.
   * @see     java.io.ByteArrayOutputStream#size()
   */
  public synchronized byte[] toByteArray() {
     byte[] outBuff = new byte[count];
     int pos = 0;

     for (BufferPool.Buffer b: buffers) {
       System.arraycopy(b.buf, 0, outBuff, pos, b.pos);
       pos += b.pos;
     }

     return outBuff;
  }

  /**
   * Returns the current size of the buffer.
   *
   * @return  the value of the <code>count</code> field, which is the number
   *          of valid bytes in this output stream.
   * @see     java.io.ByteArrayOutputStream#count
   */
  public synchronized int size() {
    return count;
  }

  /**
   * Converts the buffer's contents into a string decoding bytes using the
   * platform's default character set. The length of the new <tt>String</tt>
   * is a function of the character set, and hence may not be equal to the
   * size of the buffer.
   *
   * <p> This method always replaces malformed-input and unmappable-character
   * sequences with the default replacement string for the platform's
   * default character set. The {@linkplain java.nio.charset.CharsetDecoder}
   * class should be used when more control over the decoding process is
   * required.
   *
   * @return String decoded from the buffer's contents.
   * @since  JDK1.1
   */
  @Override
  public synchronized String toString() {
    return new String(toByteArray());
  }

  /**
   * Converts the buffer's contents into a string by decoding the bytes using
   * the specified {@link java.nio.charset.Charset charsetName}. The length of
   * the new <tt>String</tt> is a function of the charset, and hence may not be
   * equal to the length of the byte array.
   *
   * <p> This method always replaces malformed-input and unmappable-character
   * sequences with this charset's default replacement string. The {@link
   * java.nio.charset.CharsetDecoder} class should be used when more control
   * over the decoding process is required.
   *
   * @param  charsetName  the name of a supported
   *        {@linkplain java.nio.charset.Charset </code>charset<code>}
   * @return String decoded from the buffer's contents.
   * @exception  UnsupportedEncodingException
   *             If the named charset is not supported
   * @since   JDK1.1
   */
  public synchronized String toString(final String charsetName)
      throws UnsupportedEncodingException {
    return new String(toByteArray(), 0, count, charsetName);
  }

  /**
   * Closing can have no effect as we need to access the buffers afterwards.
   * The methods in this class can be called after the stream has been closed without
   * generating an <tt>IOException</tt>.
   *
   * <p>The release method MUST be called for this class to release the buffers.
   *
   */
  @Override
  public void close() throws IOException {
  }

  /** This really release buffers back to the pool. MUST be called to gain the
   * benefit of pooling.
   *
   * @throws IOException
   */
  public void release() throws IOException {
    for (BufferPool.Buffer b: buffers) {
      PooledBuffers.release(b);
    }

    buffers.clear();
    count = 0;
  }

  /* ====================================================================
   *                   Private methods
   * ==================================================================== */

  private BufferPool.Buffer getBuffer(final int pos,
                           final boolean forRead) {
    if ((curBuffer != null) && curBuffer.contains(pos)){
      return curBuffer;
    }

    for (BufferPool.Buffer b: buffers) {
      if (forRead) {
        if (b.contains(pos)) {
          curBuffer = b;
          return b;
        }

        continue;
      }

      if ((b.at(pos))) {
        curBuffer = b;
        return b;
      }
    }

    return null;
  }

  private BufferPool.Buffer newBuffer() {
    int numBuffers = buffers.size();

    if (numBuffers == 0) {
      curBuffer = PooledBuffers.getSmallBuffer();
    } else if (numBuffers == 1) {
      curBuffer = PooledBuffers.getMediumBuffer();
    } else {
      curBuffer = PooledBuffers.getLargeBuffer();
    }

    buffers.add(curBuffer);
    curBuffer.startPos = count;
    curBuffer.pos = 0;

    return curBuffer;
  }
}

