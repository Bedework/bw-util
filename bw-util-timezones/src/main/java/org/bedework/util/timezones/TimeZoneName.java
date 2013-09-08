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
package org.bedework.util.timezones;

import java.io.Serializable;

/** Printable (language specific) name + internal id
 */
public class TimeZoneName implements Comparable<TimeZoneName>, Serializable {
  /** Name for timezone */
  public String name;
  /** Id for timezone */
  public String id;

  /**
   * @param name
   */
  public TimeZoneName(final String name) {
    this.name = name;
    id = name;
  }

  /**
   * @return tz name
   */
  public String getName() {
    return name;
  }

  /**
   * @return tz id
   */
  public String getId() {
    return id;
  }

  @Override
  public int compareTo(final TimeZoneName that) {
    if (that == this) {
      return 0;
    }

    return name.compareTo(that.name);
  }

  @Override
  public boolean equals(final Object o) {
    return compareTo((TimeZoneName)o) == 0;
  }

  @Override
  public int hashCode() {
    return name.hashCode();
  }
}
