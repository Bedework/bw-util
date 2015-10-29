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

/**
 *
 *         Useful messages SHOULD be returned as an error element.
 *
 * <pre>
   ; root object

   root = {
     error,
     ?description
   }

   ; Error code
   error "error" : string

   ; Description of the error
   description "description" : string
 * </pre>
 *
 */
public class ErrorResponseType {
  protected String error;
  protected String description;

  /**
   * @param error the error code
   * @param description a description
   */
  public ErrorResponseType(final String error,
                           final String description) {
    this.error = error;
    this.description = description;
  }

  /**
   * Gets the value of the error property.
   *
   * @return String
   */
  public String getError() {
      return error;
  }

  /**
   * Sets the value of the error property.
   *
   * @param value String code
   */
  public void setError(final String value) {
    error = value;
  }

  /**
   * Gets the value of the description property.
   *
   * @return
   *     possible object is
   *     {@link String }
   *
   */
  public String getDescription() {
      return description;
  }

  /**
   * Sets the value of the description property.
   *
   * @param value
   *     allowed object is
   *     {@link String }
   *
   */
  public void setDescription(final String value) {
      description = value;
  }

  @Override
  public String toString() {
    ToString ts = new ToString(this);

    ts.append("error", getError());
    ts.append("description", getDescription());

    return ts.toString();
  }
}
