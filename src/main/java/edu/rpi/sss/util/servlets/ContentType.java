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
package edu.rpi.sss.util.servlets;

import edu.rpi.sss.util.ToString;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/** Class to represent a content type.
 *
 * @author Mike Douglass
 */
public class ContentType implements Serializable {
  /** A content type parameter
   */
  public static class Param {
    private String name;
    private String value;

    /**
     * @param name
     * @param value
     */
    public Param(final String name,
                 final String value) {
      this.name = name;
      this.value = value;
    }

    /** Get parameter name.
     *
     * @return  String  name
     */
    public String getName() {
      return name;
    }

    /** Get parameter value.
     *
     * @return  String  value
     */
    public String getValue() {
      return value;
    }

    @Override
    public String toString() {
      return new ToString(this)
          .append("name", getName())
          .append("value", getValue())
          .toString();
    }
  }

  private String type;
  private List<Param> params;

  /**
   * @param type
   */
  public ContentType(final String type) {
    this(type, null);
  }

  /**
   * @param type
   * @param params
   */
  public ContentType(final String type,
                 final List<Param> params) {
    this.type = type;
    this.params = params;
  }

  /**
   * @return content type value
   */
  public String getType() {
    return type;
  }

  /**
   * @return params
   */
  public List<Param> getParams() {
    return params;
  }

  /**
   * @param val
   */
  public void addParam(final Param val) {
    if (params == null) {
      params = new ArrayList<Param>();
    }

    params.add(val);
  }

  /**
   * @return encoded value in form type *(";" param)
   */
  public String encode() {
    if (params == null) {
      return getType();
    }

    StringBuilder sb = new StringBuilder(getType());

    for (Param p: params) {
      sb.append("; ");
      sb.append(p.getName());
      sb.append("=");
      sb.append(p.getValue());
    }

    return sb.toString();
  }

  /**
   * @param val
   * @return parsed content type
   */
  public static ContentType decode(final String val) {
    String[] els = val.split(";");

    if (els[0] == null) {
      throw new RuntimeException("Invalid content type: " + val);
    }

    ContentType ct = new ContentType(els[0]);

    for (int i = 1; i < els.length; i++) {
      if (els[i] == null) {
        continue;
      }

      String[] sp = els[i].split("=");

      if (sp.length == 1) {
        ct.addParam(new Param(sp[0].trim(), ""));
      } else if (sp.length == 2) {
        ct.addParam(new Param(sp[0].trim(), sp[1].trim()));
      } else {
        throw new RuntimeException("Invalid content type: " + val);
      }
    }

    return ct;
  }

  @Override
  public String toString() {
    return new ToString(this)
        .append("type", getType())
        .append("params", getParams())
        .toString();
  }
}
