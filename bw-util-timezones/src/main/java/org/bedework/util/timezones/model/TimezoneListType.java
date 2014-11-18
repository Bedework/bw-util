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
package org.bedework.util.timezones.model;

import org.bedework.util.misc.ToString;

import java.util.List;

/**
   JSON Content Rules for the JSON document returned for a "list" action
   request.

 * <pre>
   ; root object

   root = {
     dtstamp,
     timezones
   }

 * </pre>
 *
 *
 */
public class TimezoneListType extends BaseResultType {
  protected String dtstamp;
  protected List<TimezoneType> timezones;

  /**
   * Gets the value of the dtstamp property.
   *
   * @return
   *     possible object is
   *     {@link String } Format is yyyy-MM-ddTHH:mm:ssZ
   *
   */
  public String getDtstamp() {
    return dtstamp;
  }

  /**
   * Sets the value of the dtstamp property.
   *
   * @param value
   *     allowed object is
   *     {@link String }
   *
   */
  public void setDtstamp(final String value) {
    dtstamp = value;
  }

  /**
   * Gets the value of the timezones property.
   *
   * @return List of timezone info
   */
  public List<TimezoneType> getTimezones() {
    return timezones;
  }

  /**
   * Gets the value of the timezones property.
   *
   * @param val List of timezone info
   */
  public void setTimezones(final List<TimezoneType> val) {
    timezones = val;
  }

  @Override
  public String toString() {
    final ToString ts = new ToString(this);

    ts.append("dtstamp", getDtstamp());
    ts.append("timezones", getTimezones(), true);

    return ts.toString();
  }
}
