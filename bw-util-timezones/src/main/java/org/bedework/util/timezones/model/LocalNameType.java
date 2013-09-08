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

import com.fasterxml.jackson.annotation.JsonFormat;

/**
 *
 *         Defines one or more localized names that are used when a
 *         timezone identifier needs to be presented to a user.
 *         The lang element is used to indicate the language
 *         associated with each value.
 *         If multiple names are provided for the same locale the preferred
 *         name can be flagged with the pref attribute.
 *
 *
 * <p>Java class for LocalNameType complex type.
 *
 * <pre>
   ; An array that lists the set of timezone identifier aliases
   ; available for the corresponding timezone
   local_names "local-names" : [ * local_name ]

   local_name = [lang, lname, ?pref]

   ; Language tag for the language of the associated name
   lang : string

   ; Localized name
   lname : string

   ; Indicates whether this is the preferred name for the associated
   ; language default: false
   pref : boolean
 * </pre>
 *
 *
 */
@JsonFormat(shape=JsonFormat.Shape.ARRAY)
public class LocalNameType {
  protected String value;
  protected String lang;
  protected Boolean pref;

  /**
   * Gets the value of the value property.
   *
   * @return
   *     possible object is
   *     {@link String }
   *
   */
  public String getValue() {
    return value;
  }

  /**
   * Sets the value of the value property.
   *
   * @param value
   *     allowed object is
   *     {@link String }
   *
   */
  public void setValue(final String value) {
    this.value = value;
  }

  /**
   * Gets the value of the lang property.
   *
   * @return
   *     possible object is
   *     {@link String }
   *
   */
  public String getLang() {
    return lang;
  }

  /**
   * Sets the value of the lang property.
   *
   * @param value
   *     allowed object is
   *     {@link String }
   *
   */
  public void setLang(final String value) {
    lang = value;
  }

  /**
   * Gets the value of the pref property.
   *
   * @return
   *     possible object is
   *     {@link Boolean }
   *
   */
  public boolean isPref() {
    if (pref == null) {
      return false;
    } else {
      return pref;
    }
  }

  /**
   * Sets the value of the pref property.
   *
   * @param value
   *     allowed object is
   *     {@link Boolean }
   *
   */
  public void setPref(final Boolean value) {
    pref = value;
  }

  @Override
  public String toString() {
    ToString ts = new ToString(this);

    ts.append("value", getValue());
    ts.append("lang", getLang());
    ts.append("pref", isPref());

    return ts.toString();
  }
}
