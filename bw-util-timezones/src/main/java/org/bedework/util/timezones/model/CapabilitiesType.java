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
 *            The root (top-level) element used as the container for
 *            capabilities information.
 * <pre>
   JSON Content Rules for the JSON document returned for a
   "capabilities" action request.

   ; root object

   root = {
     info,
     actions
   }

   ; Array of actions supported by the server
   actions "actions" : [ * action ]

   ; An action supported by the server
   action : {
     action_name,
     action_params
   }
 * </pre>
 *
 *
 */
public class CapabilitiesType extends BaseResultType {
  protected int version;
  protected CapabilitiesInfoType info;
  protected List<CapabilitiesActionType> actions;

  /**
   * Sets the value of the version property.
   *
   * @param value version
   */
  public void setVersion(final int value) {
    version = value;
  }

  /**
   * Sets the value of the version property.
   *
   * @return int version
   */
  public int getVersion() {
    return version;
  }

  /**
   * Sets the value of the info property.
   *
   * @param value
   *     allowed object is
   *     {@link CapabilitiesInfoType }
   *
   */
  public void setInfo(final CapabilitiesInfoType value) {
    info = value;
  }

  /**
   * Gets the value of the info property.
   *
   * @return CapabilitiesInfoType
   */
  public CapabilitiesInfoType getInfo() {
    return info;
  }

  /**
   * Gets the value of the operation property.
   *
   * <p>
   * This accessor method returns a reference to the live list,
   * not a snapshot. Therefore any modification you make to the
   * returned list will be present inside the Json object.
   * This is why there is not a <CODE>set</CODE> method for the operation property.
   *
   * <p>
   * For example, to add a new item, do as follows:
   * <pre>
   *    getActions().add(newItem);
   * </pre>
   *
   *
   * <p>
   * Objects of the following type(s) are allowed in the list
   * {@link CapabilitiesActionType }
   * @return actions
   *
   */
  public List<CapabilitiesActionType> getActions() {
    if (actions == null) {
      actions = new ArrayList<>();
    }
    return actions;
  }

  @Override
  public String toString() {
    ToString ts = new ToString(this);

    ts.append("version", getVersion());
    ts.append("info", getInfo());
    ts.append("actions", getActions(), true);

    return ts.toString();
  }
}
