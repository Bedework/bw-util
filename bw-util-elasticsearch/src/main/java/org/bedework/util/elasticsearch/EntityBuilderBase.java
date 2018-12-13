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
package org.bedework.util.elasticsearch;

import org.bedework.util.indexing.IndexException;
import org.bedework.util.logging.BwLogger;
import org.bedework.util.logging.Logged;
import org.bedework.util.misc.Util;

import org.elasticsearch.index.get.GetField;

import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Date;
import java.util.Deque;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;

/** Build entities from ElasticSearch documents
 *
 * @author Mike Douglass douglm - rpi.edu
 *
 */
public class EntityBuilderBase implements Logged {
  private final Deque<Map<String, Object>> fieldStack = new ArrayDeque<>();

  private final long version;

  /** Constructor - 1 use per entity
   *
   * @param fields map of fields from index
   * @param version of document
   */
  protected EntityBuilderBase(final Map<String, ?> fields,
                    final long version) throws IndexException {
    pushFields(fields);

    this.version = version;
  }

  /* ========================================================================
   *                   public methods
   * ======================================================================== */

  public String getDoctype() throws IndexException {
    return String.valueOf(getFirstValue("docType"));
  }


  /* ========================================================================
   *                   protected methods
   * ======================================================================== */

  protected boolean pushFields(final String id) throws IndexException {
    return pushFields(getFirstValue(id));
  }

  protected boolean pushFields(final Object objFlds) throws IndexException {
    if (objFlds == null) {
      return false;
    }

        /* Should be a Map of fields. */

    if (!(objFlds instanceof Map)) {
      throw new IndexException("indexIllegalObjectClass");
    }

    //noinspection unchecked
    fieldStack.push((Map<String, Object>)objFlds);
    return true;
  }

  protected void popFields() {
    fieldStack.pop();
  }

  protected List<Object> getFieldValues(final String name) {
    final Object val = fieldStack.peek().get(name);

    if (val == null) {
      return null;
    }

    if (val instanceof List) {
      return (List<Object>)val;
    }

    if (val instanceof GetField) {
      return ((GetField)val).getValues();
    }

    final List<Object> vals = new ArrayList<>();
    vals.add(val);

    return vals;
  }

  protected Set<String> getStringSet(final String id) {
    final List<Object> l = getFieldValues(id);

    if (Util.isEmpty(l)) {
      return null;
    }

    final TreeSet<String> ts = new TreeSet<>();

    for (final Object o: l) {
      ts.add((String)o);
    }

    return ts;
  }

  protected List<String> getStringList(final String id) {
    final List<Object> l = getFieldValues(id);

    if (Util.isEmpty(l)) {
      return null;
    }

    final List<String> ss = new ArrayList<>();

    for (final Object o: l) {
      ss.add((String)o);
    }

    return ss;
  }

  protected Object getFirstValue(final String id) {
    final Object val = fieldStack.peek().get(id);

    if (val == null) {
      return null;
    }

    final List vals;

    if (val instanceof GetField) {
      vals = ((GetField)val).getValues();
    } else if (val instanceof List) {
      vals = (List)val;
    } else {
      return val;
    }

    if (Util.isEmpty(vals)) {
      return null;
    }

    return vals.get(0);
  }

  protected Boolean getBoolean(final String id) {
    final String s = (String)getFirstValue(id);

    if (s == null) {
      return null;
    }

    return Boolean.valueOf(s);
  }

  protected Boolean getBooleanNotNull(final String id) {
    final Boolean b = getBoolean(id);

    if (b == null) {
      return Boolean.FALSE;
    }

    return b;
  }

  protected boolean getBool(final String id) {
    final Boolean b = getBoolean(id);

    if (b == null) {
      return false;
    }

    return b;
  }

  protected Date getDate(final String pi) {
    final Long l = (Long)getFirstValue(pi);

    if (l == null) {
      return null;
    }

    return new Date(l);
  }

  protected Integer getInteger(final String id) {
    final String s = (String)getFirstValue(id);

    if (s == null) {
      return null;
    }

    return Integer.valueOf(s);
  }

  protected Long getLong(final String name) {
    final Object o = getFirstValue(name);

    if (o == null) {
      return null;
    }

    if (o instanceof Integer) {
      return ((Integer)o).longValue();
    }

    if (o instanceof Long) {
      return (Long)o;
    }

    final String s = (String)o;

    return Long.valueOf(s);
  }

  protected float getFloat(final String id) {
    final Object o = getFirstValue(id);

    if (o == null) {
      return 0;
    }

    if (o instanceof Integer) {
      return (float)o;
    }

    if (o instanceof Float) {
      return (Float)o;
    }

    final String s = (String)o;

    return Float.valueOf(s);
  }

  protected int getInt(final String id) {
    final Integer i = (Integer)getFirstValue(id);

    if (i == null) {
      return 0;
    }

    return i;
  }

  protected String getString(final String id) {
    return (String)getFirstValue(id);
  }

  /* ====================================================================
   *                   Logged methods
   * ==================================================================== */

  private BwLogger logger = new BwLogger();

  @Override
  public BwLogger getLogger() {
    if ((logger.getLoggedClass() == null) && (logger.getLoggedName() == null)) {
      logger.setLoggedClass(getClass());
    }

    return logger;
  }
}
