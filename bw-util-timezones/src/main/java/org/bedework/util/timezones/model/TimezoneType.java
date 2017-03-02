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

import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.Date;
import java.util.List;

/**
 *
 *         This defines the element that provides summary information for a
 *         timezone in the timezones list.
 *
 *
 * <p>Java class for SummaryType complex type.
 *
 * <p>The following schema fragment specifies the expected content contained within this class.
 *
 * <pre>
   ; Information about a timezone available on the server
   timezone : {
     tzid,
     last_modified,
     ?inactive,
     ?aliases,
     ?local_names,
   }

   ; Timezone identifier
   tzid "tzid" : string

   ; Date/time when the timezone data was last modified
   ; [RFC3339] UTC value
   last_modified "last-modified" : date-time

   ; Indicates whether the timerzone is an inactive timezone
   inactive "inactive" : boolean

   ; An array that lists the set of timezone identifier aliases
   ; available for the corresponding timezone
   aliases "aliases" : [ * : string ]
 * </pre>
 *
 *
 */
public class TimezoneType {
  protected String tzid;
  protected String etag;
  protected Date lastModified;
  protected Boolean inactive;
  protected List<String> aliases;
  protected List<LocalNameType> localNames;

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

  /** Etag value for last fetch from primary or load from data
   *
   * @param val the etag
   */
  public void setEtag(final String val) {
    etag = val;
  }

  /**
   * @return etag or null
   */
  public String getEtag() {
    return etag;
  }

  /**
   * Gets the value of the lastModified property.
   *
   * @return
   *     possible object is
   *     {@link Date }
   *
   */
  @JsonProperty("last-modified")
  public Date getLastModified() {
    return lastModified;
  }

  /**
   * Sets the value of the lastModified property.
   *
   * @param value
   *     allowed object is
   *     {@link Date }
   *
   */
  public void setLastModified(final Date value) {
    lastModified = value;
  }

  /**
   * Gets the value of the inactive property.
   *
   * @return
   *     possible object is
   *     {@link Boolean }
   *
   */
  public Boolean getInactive() {
    return inactive;
  }

  /**
   * Sets the value of the inactive property.
   *
   * @param value
   *     allowed object is
   *     {@link Boolean }
   *
   */
  public void setInactive(final Boolean value) {
    inactive = value;
  }

  /**
   * Gets the value of the aliases property.
   *
   * @return list of aliases or null
   */
  public List<String> getAliases() {
    return aliases;
  }

  /**
   * sets the value of the aliases property.
   * @param val list of aliases or null
   */
  public void setAliases(final List<String> val) {
    aliases = val;
  }

  /**
   * Gets the value of the localNames property.
   * @return list of names or null
   */
  @JsonProperty("local-names")
  public List<LocalNameType> getLocalNames() {
    return localNames;
  }

  /**
   * sets the value of the localNames property.
   * @param val list of names or null
   */
  public void setLocalNames(final List<LocalNameType> val) {
    localNames = val;
  }

  @Override
  public String toString() {
    ToString ts = new ToString(this);

    ts.append("tzid", getTzid());
    ts.append("etag", getEtag());
    ts.append("lastModified", getLastModified());
    ts.append("inactive", getInactive());
    ts.append("aliases", getAliases(), true);
    ts.append("localNames", getLocalNames(), true);

    return ts.toString();
  }
}
