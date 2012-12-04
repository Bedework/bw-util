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

import java.util.ArrayList;
import java.util.List;

/**
 *
 *         The element used as the container for information defining an
 *         operation and its parameters.
 *
 *
 * <p>Java class for CapabilitiesOperationType complex type.
 *
 * <pre>
   ; Name of the action
   action_name "name" : string

   ; Array of request-URI query parameters supported by the action
   action_params = "parameters" : [ * parameter ]

   ; Object defining an action parameter
   parameter = {
     param_name,
     ?param_required,
     ?param_multi,
     ?param_values
   }

   ; Name of the parameter
   param_name  "name" : string

   ; If true the parameter has to be present in the request-URI
   ; default is false
   param_required "required" : boolean

   ; If true the parameter can occur more than once in the request-URI
   ; default is false
   param_multi "multi" : boolean,

   ; An array that defines the allowed set of values for the parameter
   ; In the absence of this member, any string value is acceptable
   param_values "values" : [ * : string ]
 * </pre>
 *
 */
public class CapabilitiesActionType {
  protected String action;
  protected String description;
  protected List<CapabilitiesAcceptParameterType> parameters;

  /**
   * Gets the value of the action property.
   *
   * @return
   *     possible object is
   *     {@link String }
   *
   */
  public String getAction() {
    return action;
  }

  /**
   * Sets the value of the action property.
   *
   * @param value
   *     allowed object is
   *     {@link String }
   *
   */
  public void setAction(final String value) {
    action = value;
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

  /**
   * Gets the value of the acceptParameter property.
   *
   * <p>
   * This accessor method returns a reference to the live list,
   * not a snapshot. Therefore any modification you make to the
   * returned list will be present inside the JAXB object.
   * This is why there is not a <CODE>set</CODE> method for the acceptParameter property.
   *
   * <p>
   * For example, to add a new item, do as follows:
   * <pre>
   *    getAcceptParameter().add(newItem);
   * </pre>
   *
   *
   * <p>
   * Objects of the following type(s) are allowed in the list
   * {@link CapabilitiesAcceptParameterType }
   * @return list of parameters
   *
   *
   */
  public List<CapabilitiesAcceptParameterType> getParameters() {
    if (parameters == null) {
      parameters = new ArrayList<CapabilitiesAcceptParameterType>();
    }
    return parameters;
  }

}
