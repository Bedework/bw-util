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
package edu.rpi.cmt.timezones.model;

import edu.rpi.sss.util.ToString;

import java.util.Date;
import java.util.List;


/**
 *
 *         This defines the root (top-level) element used as the container
 *         for expanded timezone data.
 *
 *
 * <p>Java class for TimezonesType complex type.
 *
 * <p>The following schema fragment specifies the expected content contained within this class.
 *
 * <pre>
 * &lt;complexType name="TimezonesType">
 *   &lt;complexContent>
 *     &lt;extension base="{urn:ietf:params:xml:ns:timezone-service}BaseResultType">
 *       &lt;sequence>
 *         &lt;element name="dtstamp" type="{urn:ietf:params:xml:ns:timezone-service}DtstampType"/>
 *         &lt;element name="tzdata" type="{urn:ietf:params:xml:ns:timezone-service}TzdataType" maxOccurs="unbounded"/>
 *       &lt;/sequence>
 *     &lt;/extension>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 *
 *
 */
public class TimezonesType extends BaseResultType {
  protected Date dtstamp;
  protected List<TzdataType> tzdata;

  /**
   * Gets the value of the dtstamp property.
   *
   * @return
   *     possible object is
   *     {@link Date }
   *
   */
  public Date getDtstamp() {
    return dtstamp;
  }

  /**
   * Sets the value of the dtstamp property.
   *
   * @param value
   *     allowed object is
   *     {@link Date }
   *
   */
  public void setDtstamp(final Date value) {
    dtstamp = value;
  }

  /**
   * Gets the value of the tzdata property.
   * @return List of data
   *
   */
  public List<TzdataType> getTzdata() {
    return tzdata;
  }

  /**
   * Sets the value of the tzdata property.
   *
   * @param val List of data
   *
   */
  public void setTzdata(final List<TzdataType> val) {
    tzdata = val;
  }

  @Override
  public String toString() {
    ToString ts = new ToString(this);

    ts.append("dtstamp=", getDtstamp().toString());

    for (TzdataType tzd: getTzdata()){
      ts.newLine();
      ts.append(tzd);
    }

    return ts.toString();
  }
}
