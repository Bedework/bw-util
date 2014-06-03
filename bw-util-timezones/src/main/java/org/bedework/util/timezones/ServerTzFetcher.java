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

import net.fortuna.ical4j.model.TimeZone;
import net.fortuna.ical4j.model.component.VTimeZone;

import java.util.ArrayList;
import java.util.List;

/** Class that fetches VTimeZones from a server
 */
public class ServerTzFetcher implements TzFetcher {
  private final Timezones tzs = new TimezonesImpl();

  /**
   * @param tzsvrUri - the uri
   */
  public ServerTzFetcher(final String tzsvrUri) throws TimezonesException {
    tzs.init(tzsvrUri);
  }

  @Override
  public VTimeZone getTz(final String tzid) throws TimezonesException {
    final TimeZone tz = tzs.getTimeZone(tzid);

    if (tz == null) {
      return null;
    }

    return tz.getVTimeZone();
  }

  @Override
  public List<String> getTzids() throws TimezonesException {
    final List<String> ids = new ArrayList<>();
    for (final TimeZoneName tzn: tzs.getTimeZoneNames()) {
      ids.add(tzn.getId());
    }

    return ids;
  }

  @Override
  public void close() throws Exception {
  }
}


