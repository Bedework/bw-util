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
 *         This element specifies expanded timezone data for the range
 *         specified in a request.
 *
 *
 * <p>Java class for TzdataType complex type.
 *
 * <p>The following schema fragment specifies the expected content contained within this class.
 *
 * <pre>
 * &lt;complexType name="TzdataType">
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element name="tzid" type="{urn:ietf:params:xml:ns:timezone-service}TzidType"/>
 *         &lt;element name="calscale" type="{urn:ietf:params:xml:ns:timezone-service}CalscaleType"/>
 *         &lt;element name="observance" type="{urn:ietf:params:xml:ns:timezone-service}ObservanceType" maxOccurs="unbounded"/>
 *       &lt;/sequence>
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 *
 *
 */
public class TzdataType {
  protected String tzid;
  protected String calscale;
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
   * Gets the value of the calscale property.
   *
   * @return
   *     possible object is
   *     {@link String }
   *
   */
  public String getCalscale() {
    return calscale;
  }

  /**
   * Sets the value of the calscale property.
   *
   * @param value
   *     allowed object is
   *     {@link String }
   *
   */
  public void setCalscale(final String value) {
    calscale = value;
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
    ToString ts = new ToString(this);

    ts.append("tzid", getTzid());
    ts.append("observances", getObservances(), true);

    return ts.toString();
  }
}
