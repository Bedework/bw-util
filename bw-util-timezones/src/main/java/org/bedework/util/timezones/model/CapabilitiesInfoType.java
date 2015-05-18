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

/**
 *
 *         The element used as the container for information about the
 *         servers source of data and contacts.
 *
 * <pre>
   info "info" : {
     primary_source / secondary_source,
     contacts
   }

   ; The source of the timezone data provided by a "primary" server
   primary_source "primary-source" : string

   ; The timezone server from which data is provided by a "secondary"
   ; server
   secondary_source "secondary-source" : uri

   ; Array of URIs providing contact details for the server
   ; administrator
   contacts "contacts" : [ * :uri ]
 * </pre>
 *
 *
 */
@SuppressWarnings("UnusedDeclaration")
public class CapabilitiesInfoType {
  protected String source;
  protected String primarySource;
  protected List<String> formats;
  protected CapabilitiesTruncatedType truncated;
  protected List<String> contacts;

  /**
   * Gets the value of the source property.
   *
   * @return
   *     possible object is
   *     {@link String }
   *
   */
  public String getSource() {
    return source;
  }

  /**
   * Sets the value of the source property.
   *
   * @param value
   *     allowed object is
   *     {@link String }
   *
   */
  public void setSource(final String value) {
    source = value;
  }

  /**
   * Gets the value of the primarySource property.
   *
   * @return
   *     possible object is
   *     {@link String }
   *
   */
  public String getPrimarySource() {
    return primarySource;
  }

  /**
   * Sets the value of the primarySource property.
   *
   * @param value
   *     allowed object is
   *     {@link String }
   *
   */
  public void setPrimarySource(final String value) {
    primarySource = value;
  }

  /**
   * Gets the value of the contact property.
   *
   * <p>
   * This accessor method returns a reference to the live list,
   * not a snapshot. Therefore any modification you make to the
   * returned list will be present inside the Json object.
   * This is why there is not a <CODE>set</CODE> method for the contacts property.
   *
   * <p>
   * For example, to add a new item, do as follows:
   * <pre>
   *    getContacts().add(newItem);
   * </pre>
   *
   *
   * <p>
   * Objects of the following type(s) are allowed in the list
   * {@link String }
   * @return list of contacts
   */
  public List<String> getFormats() {
    if (formats == null) {
      formats = new ArrayList<>();
    }
    return formats;
  }

  /**
   * Gets the value of the truncated property.
   *
   * @return
   *     possible object is
   *     {@link CapabilitiesTruncatedType }
   *
   */
  public CapabilitiesTruncatedType getTruncated() {
    return truncated;
  }

  /**
   * Sets the value of the truncated property.
   *
   * @param value
   *     allowed object is
   *     {@link CapabilitiesTruncatedType }
   *
   */
  public void setTruncated(final CapabilitiesTruncatedType value) {
    truncated = value;
  }

  /**
   * Gets the value of the contact property.
   *
   * <p>
   * This accessor method returns a reference to the live list,
   * not a snapshot. Therefore any modification you make to the
   * returned list will be present inside the Json object.
   * This is why there is not a <CODE>set</CODE> method for the contacts property.
   *
   * <p>
   * For example, to add a new item, do as follows:
   * <pre>
   *    getContacts().add(newItem);
   * </pre>
   *
   *
   * <p>
   * Objects of the following type(s) are allowed in the list
   * {@link String }
   * @return list of contacts
   */
  public List<String> getContacts() {
    if (contacts == null) {
      contacts = new ArrayList<>();
    }
    return contacts;
  }

  @Override
  public String toString() {
    final ToString ts = new ToString(this);

    ts.append("source", getSource());
    ts.append("primarySource", getPrimarySource());
    ts.append("formats", getFormats());
    ts.append("truncated", getTruncated());
    ts.append("contacts", getContacts(), true);

    return ts.toString();
  }
}
