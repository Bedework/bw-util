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

import java.util.ArrayList;
import java.util.List;

import javax.xml.datatype.XMLGregorianCalendar;

/**
 *
 *         In an expanded timezone, the observance element specifies a
 *         single timezone observance.
 *
 *         The utc-offset-from element defines the UTC offset in hours
 *         and minutes before the start of this observance.
 *
 *         The utc-offset-to element defines the UTC offset in hours and
 *         minutes at and after the start of this observance.
 *
 *
 * <pre>
   ; Information about a timezone available on the server
   observance : {
     oname,
     ?olocal_names,
     onset,
     utc_offset_from,
     utc_offset_to
   }

   ; Observance name
   oname "name" : string

   ; Array of localized observance names
   olocal_names "local-names" : [ * :string]

   ; The local time at which the observance takes effect
   ; [RFC3339] value modified to exclude "time-offset" part
   onset "onset" : date-time

   ; The UTC offset in seconds before the start of this observance
   utc_offset_from "utc-offset-from" : integer

   ; The UTC offset in seconds at and after the start of this observance
   utc_offset_to "utc-offset-to" : integer

 * </pre>
 *
 *
 */
public class ObservanceType {
  protected String name;
  protected List<LocalNameType> localName;
  protected String onset;
  protected String utcOffsetFrom;
  protected String utcOffsetTo;

  /**
   * Gets the value of the name property.
   *
   * @return
   *     possible object is
   *     {@link String }
   *
   */
  public String getName() {
    return name;
  }

  /**
   * Sets the value of the name property.
   *
   * @param value
   *     allowed object is
   *     {@link String }
   *
   */
  public void setName(final String value) {
    name = value;
  }

  /**
   * Gets the value of the localName property.
   *
   * <p>
   * For example, to add a new item, do as follows:
   * <pre>
   *    getLocalName().add(newItem);
   * </pre>
   *
   *
   * <p>
   * Objects of the following type(s) are allowed in the list
   * {@link LocalNameType }
   * @return A a reference to the live list,
   * not a snapshot. Therefore any modification you make to the
   * returned list will be present inside the JAXB object.
   * This is why there is not a <CODE>set</CODE> method for the localName property.
   *
   *
   */
  public List<LocalNameType> getLocalName() {
    if (localName == null) {
      localName = new ArrayList<LocalNameType>();
    }
    return localName;
  }

  /**
   * Gets the value of the onset property.
   *
   * @return
   *     possible object is
   *     {@link XMLGregorianCalendar }
   *
   */
  public String getOnset() {
    return onset;
  }

  /**
   * Sets the value of the onset property.
   *
   * @param value
   *     allowed object is
   *     {@link XMLGregorianCalendar }
   *
   */
  public void setOnset(final String value) {
    onset = value;
  }

  /**
   * Gets the value of the utcOffsetFrom property.
   *
   * @return
   *     possible object is
   *     {@link String }
   *
   */
  public String getUtcOffsetFrom() {
    return utcOffsetFrom;
  }

  /**
   * Sets the value of the utcOffsetFrom property.
   *
   * @param value
   *     allowed object is
   *     {@link String }
   *
   */
  public void setUtcOffsetFrom(final String value) {
    utcOffsetFrom = value;
  }

  /**
   * Gets the value of the utcOffsetTo property.
   *
   * @return
   *     possible object is
   *     {@link String }
   *
   */
  public String getUtcOffsetTo() {
    return utcOffsetTo;
  }

  /**
   * Sets the value of the utcOffsetTo property.
   *
   * @param value
   *     allowed object is
   *     {@link String }
   *
   */
  public void setUtcOffsetTo(final String value) {
    utcOffsetTo = value;
  }

  @Override
  public String toString() {
    ToString ts = new ToString(this);

    ts.append("name", getName());
    ts.append("onset", getOnset());
    ts.append("offset-from", getUtcOffsetFrom());
    ts.append("offset-to", getUtcOffsetTo());

    return ts.toString();
  }

}
