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
package edu.rpi.sss.util.servlets.io;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Deque;

/** See if we can't manage buffers better than the standard java classes - at
 * least for the specific use we have. We are generating a lot of output and
 * causing a lot of expansion and copying.
 *
 * <P>This may result in a lot of JVM churn. See if a pool of buffers can
 * improve matters.
 *
 * @author Mike Douglass
 */
public class PooledBufferedOutputStream extends OutputStream
        implements PooledBufferedOutputStreamMBean {
  static class Buffer {
    // Offset in the complete data
    int startPos;

    // Offset of next unused byte in this buffer - i.e. first byte is 0 always
    int pos;

    byte buf[];

    int getRemainingCount() {
      return buf.length - pos;
    }

    /**
     * @param i
     * @return true if offset i is in the bytes in this buffer
     */
    boolean contains(final int i) {
      if (i < startPos) {
        return false;
      }

      if (i < (startPos + pos)) {
        return true;
      }

      return false;
    }

    /** return true if offset i is the next free byte in this buffer.
     *
     * @param i
     * @return true if offset i is the next free byte in this buffer
     */
    boolean at(final int i) {
      if (i < startPos) {
        return false;
      }

      if (i == (startPos + pos)) {
        return !full();
      }

      return false;
    }

    boolean full() {
      return pos == buf.length;
    }

    int getByte(final int at) throws IOException {
      int i = at - startPos;

      if ((i < 0) || (i >= pos)) {
        throw new IOException("Bad offsets at: " + at +
                              " startPos: " + startPos +
                              " pos: " + pos);
      }

      return buf[i];
    }

    boolean putByte(final int b) {
      if (getRemainingCount() == 0) {
        return false;
      }

      buf[pos] = (byte)b;
      pos++;
      return true;
    }

    /** Put as many bytes into the buffer as possible and return the count of
     * remaining bytes,
     *
     * @param bytes
     * @param offset
     * @param len - number of bytes to put
     * @return count remaining
     */
    int putBytes(final byte bytes[],
                 final int offset,
                 final int len) throws IOException {
      int toCopy = len;
      if (getRemainingCount() < toCopy) {
        toCopy = getRemainingCount();
      }

      if (toCopy > 0) {
        try {
          System.arraycopy(bytes, offset, buf, pos, toCopy);
        } catch (Throwable t) {
          throw new IOException("Logic error in putBytes toCopy: " + toCopy +
                              " startPos: " + startPos +
                              " pos: " + pos);
        }
      }

      pos += toCopy;
      return len - toCopy;
    }
  }

  private static class BufferPool {
    private int bufferSize;
    private int poolMaxSize;

    private Deque<Buffer> pool = new ArrayDeque<Buffer>();

    /* usage stats */
    private long gets;
    private long puts;
    private long discards;
    private long creates;

    BufferPool(final int bufferSize,
               final int poolMaxSize) {
      this.bufferSize = bufferSize;
      this.poolMaxSize = poolMaxSize;
    }

    synchronized Buffer get() {
      Buffer buff = null;
      gets++;

      if (pool.size() > 0) {
        buff = pool.remove();
      }

      if ((buff == null) || (buff.buf.length != bufferSize)) {
        creates++;
        buff = new Buffer();
        buff.buf = new byte[bufferSize];
      }

      buff.pos = 0;
      buff.startPos = -1;
      return buff;
    }

    synchronized void put(final Buffer buff) {
      puts++;

      if ((pool.size() < poolMaxSize) &&
          (buff.buf.length == bufferSize)) {
        pool.add(buff);
      } else {
        discards++;
      }
    }

    int getBufferSize() {
      return bufferSize;
    }

    void setBufferSize(final int val) {
      bufferSize = val;
    }

    int getPoolMaxSize() {
      return poolMaxSize;
    }

    void setPoolMaxSize(final int val) {
      poolMaxSize = val;
    }


    String getStats() {
      StringBuffer sb = new StringBuffer();

      statline(sb, "bufferSize", bufferSize);
      statline(sb, "poolMaxSize", poolMaxSize);
      statline(sb, "poolCurSize", pool.size());
      statline(sb, "gets", gets);
      statline(sb, "puts", puts);
      statline(sb, "discards", discards);
      statline(sb, "creates", creates);

      return sb.toString();
    }

    private void statline(final StringBuffer sb,
                          final String name, final long val) {
      sb.append(name);
      sb.append(": ");
      sb.append(val);
      sb.append("\n");
    }
  }

  /**
   * The number of valid bytes in the virtual buffer.
   */
  protected int count;

  /* Buffers obtained from the pool. */
  private ArrayList<Buffer> buffers = new ArrayList<Buffer>();

  private Buffer curBuffer;

  private static int smallBufferSize = 250;
  private static int mediumBufferSize = 4096;
  private static int largeBufferSize = 1000000;

  private static int smallBufferPoolSize = 20;
  private static int mediumBufferPoolSize = 20;
  private static int largeBufferPoolSize = 60;

  private static BufferPool smallBufferPool = new BufferPool(smallBufferSize,
                                                             smallBufferPoolSize);
  private static BufferPool mediumBufferPool = new BufferPool(mediumBufferSize,
                                                              mediumBufferPoolSize);
  private static BufferPool largeBufferPool = new BufferPool(largeBufferSize,
                                                             largeBufferPoolSize);

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
    Buffer buff = getBuffer(count, false);

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
      Buffer buff = getBuffer(count, false);

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
    for (Buffer b: buffers) {
      out.write(b.buf, 0, b.pos);
    }
  }

  private class PooledBuffersInputStream extends InputStream {
    int pos;

    @Override
    public int read() throws IOException {
      Buffer b = getBuffer(pos, true);

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

     for (Buffer b: buffers) {
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
    for (Buffer b: buffers) {
      if (b.buf.length == smallBufferSize) {
        smallBufferPool.put(b);
      } else if (b.buf.length == mediumBufferSize) {
        mediumBufferPool.put(b);
      } else if (b.buf.length == largeBufferSize) {
        largeBufferPool.put(b);
      }
    }

    buffers.clear();
    count = 0;
  }

  /* ====================================================================
   *                   MBean methods
   * ==================================================================== */

  @Override
  public int getSmallBufferSize() {
    return smallBufferPool.getBufferSize();
  }

  @Override
  public void setSmallBufferSize(final int val) {
    smallBufferPool.setBufferSize(val);
  }

  @Override
  public int getMediumBufferSize() {
    return mediumBufferPool.getBufferSize();
  }

  @Override
  public void setMediumBufferSize(final int val) {
    mediumBufferPool.setBufferSize(val);
  }

  @Override
  public int getLargeBufferSize() {
    return largeBufferPool.getBufferSize();
  }

  @Override
  public void setLargeBufferSize(final int val) {
    largeBufferPool.setBufferSize(val);
  }

  @Override
  public int getSmallBufferPoolSize() {
    return smallBufferPool.getPoolMaxSize();
  }

  @Override
  public void setSmallBufferPoolSize(final int val) {
    smallBufferPool.setPoolMaxSize(val);
  }

  @Override
  public int getMediumBufferPoolSize() {
    return mediumBufferPool.getPoolMaxSize();
  }

  @Override
  public void setMediumBufferPoolSize(final int val) {
    mediumBufferPool.setPoolMaxSize(val);
  }

  @Override
  public int getLargeBufferPoolSize() {
    return largeBufferPool.getPoolMaxSize();
  }

  @Override
  public void setLargeBufferPoolSize(final int val) {
    largeBufferPool.setPoolMaxSize(val);
  }

  @Override
  public String getSmallBufferPoolStats() {
    return smallBufferPool.getStats();
  }

  @Override
  public String getMediumBufferPoolStats() {
    return mediumBufferPool.getStats();
  }

  @Override
  public String getLargeBufferPoolStats() {
    return largeBufferPool.getStats();
  }

  @Override
  public String getName() {
    /* This apparently must be the same as the name attribute in the
     * jboss service definition
     */
    return "org.bedework:service=PooledBuffers";
  }

  /* (non-Javadoc)
   * @see org.bedework.indexer.BwIndexerMBean#isStarted()
   */
  @Override
  public boolean isStarted() {
    return true;
  }

  /* (non-Javadoc)
   * @see org.bedework.indexer.BwIndexerMBean#start()
   */
  @Override
  public void start() {
  }

  /* (non-Javadoc)
   * @see org.bedework.indexer.BwIndexerMBean#stop()
   */
  @Override
  public void stop() {
  }

  /* ====================================================================
   *                   Private methods
   * ==================================================================== */

  private Buffer getBuffer(final int pos,
                           final boolean forRead) {
    if ((curBuffer != null) && curBuffer.contains(pos)){
      return curBuffer;
    }

    for (Buffer b: buffers) {
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

  private Buffer newBuffer() {
    int numBuffers = buffers.size();

    if (numBuffers == 0) {
      curBuffer = smallBufferPool.get();
    } else if (numBuffers == 1) {
      curBuffer = mediumBufferPool.get();
    } else {
      curBuffer = largeBufferPool.get();
    }

    buffers.add(curBuffer);
    curBuffer.startPos = count;
    curBuffer.pos = 0;

    return curBuffer;
  }
}

