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
 *
 *         This defines the root (top-level) element used as the container
 *         for expanded timezone data.
 *
 *
 */
public class ExpandedTimezoneType extends BaseResultType {
  protected String tzid;
  protected String dtstamp;
  protected List<ObservanceType> observances;

  /**
   * Gets the value of the tzid property.
   *
   * @return
   *     possible object is
   *     {@link String }
   *
   */
  public String getTzid() {
    return tzid;
  }

  /**
   * Sets the value of the tzid property.
   *
   * @param value
   *     allowed object is
   *     {@link String }
   *
   */
  public void setTzid(final String value) {
    tzid = value;
  }

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
   * Gets the value of the observances property.
   *
   * @return list of observances
   */
  public List<ObservanceType> getObservances() {
    return observances;
  }

  /**
   * Sets the value of the observances property.
   *
   * @param val list of observances
   */
  public void setObservances(final List<ObservanceType> val) {
    observances = val;
  }

  @Override
  public String toString() {
    final ToString ts = new ToString(this);

    ts.append("dtstamp", getDtstamp());
    ts.append("tzid", getTzid());
    ts.append("observances", getObservances(), true);

    return ts.toString();
  }
}
