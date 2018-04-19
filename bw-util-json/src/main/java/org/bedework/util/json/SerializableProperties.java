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
package org.bedework.util.json;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.StringWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/** Serializable form of information.
 *
 */
public class SerializableProperties {
  private static final ObjectMapper om = new ObjectMapper();

  protected Map vals;

  public SerializableProperties() {
  }

  public void init(final Map vals) throws Exception {
    this.vals = vals;
  }

  public void setProperties(final String val) throws Exception {
    if (val == null) {
      vals = new HashMap();
    } else {
      vals = asMap(val);
    }
  }

  /** This will be called to serialize the values for the db.
   *
   * @return json serialized value
   * @throws Exception
   */
  @JsonIgnore
  public String getProperties() throws Exception {
    return asString();
  }

  /**
   *
   * @return Map representing extra properties.
   */
  @JsonIgnore
  public Map getVals() {
    if (vals == null) {
      vals = new HashMap();
    }

    return vals;
  }

  /* ==============================================================
   *                   Json methods
   * ============================================================== */

  public Map<?, ?> asMap(final String val) throws Exception {
    init((Map)om.readValue(val, Object.class));
    return vals;
  }

  public String asString() throws Exception {
    final StringWriter sw = new StringWriter();

    om.writeValue(sw, getVals());
    return sw.toString();
  }

  @JsonIgnore
  public Map<?, ?> getMap(final String name) throws Exception {
    final Object val = getVals().get(name);

    if (val == null) {
      throw new Exception("missing value: " + name);
    }

    return (Map)val;
  }

  /* ==============================================================
   *                   set methods
   * ============================================================== */

  public void setBoolean(final String name, final Boolean val) {
    getVals().put(name, val);
  }

  public void setInt(final String name, final Integer val) {
    getVals().put(name, val);
  }

  public void setLong(final String name, final Long val) {
    getVals().put(name, val);
  }

  public void setString(final String name, final String val) {
    if (val == null) {
      getVals().remove(name);
    } else {
      getVals().put(name, val);
    }
  }

  public void setObject(final String name, final Object val) {
    if (val == null) {
      getVals().remove(name);
    } else {
      getVals().put(name, val);
    }
  }

  /* ==============================================================
   *                   get methods
   * ============================================================== */

  public String must(final String name) throws Exception {
    return JsonUtil.must(name, getVals());
  }

  public List<String> mustList(final String name) throws Exception {
    //noinspection unchecked
    return JsonUtil.mustList(name, getVals());
  }

  public String may(final String name) throws Exception {
    return JsonUtil.may(name, getVals());
  }

  public List mayList(final String name) throws Exception {
    return JsonUtil.mayList(name, getVals());
  }

  public List mayList(final String name,
                      final Map theVals) throws Exception {
    return JsonUtil.mayList(name, theVals);
  }

  public int mayInt(final String name) throws Exception {
    final Object val = getVals().get(name);

    if (val == null) {
      return 0;
    }

    return (Integer)val;
  }

  public long mayLong(final String name) throws Exception {
    final Object val = getVals().get(name);

    if (val == null) {
      return 0;
    }

    return (Long)val;
  }

  public boolean mayBool(final String name) throws Exception {
    final Object val = getVals().get(name);

    if (val == null) {
      return false;
    }

    return (Boolean)val;
  }
}
