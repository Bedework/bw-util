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
import java.util.ArrayDeque;
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
public class BufferPool {
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
