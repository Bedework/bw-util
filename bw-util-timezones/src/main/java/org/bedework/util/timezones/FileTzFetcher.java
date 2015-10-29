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

import net.fortuna.ical4j.data.CalendarBuilder;
import net.fortuna.ical4j.model.Calendar;
import net.fortuna.ical4j.model.component.VTimeZone;

import java.io.File;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/** Class that fetches VTimeZones from a server
 */
public class FileTzFetcher implements TzFetcher {
  private final Map<String, VTimeZone> tzs = new HashMap<>();

  /**
   * @param path - to a directory.
   * @throws TimezonesException on error
   */
  public FileTzFetcher(final String path) throws TimezonesException {
    /* Search recursively for all ics files. */
    try {
      final File dir = new File(path);

      if (!dir.isDirectory()) {
        throw new TimezonesException(path + " is not a directory");
      }

      processDir(dir);
    } catch (final Throwable t) {
      throw new TimezonesException(t);
    }
  }

  @Override
  public VTimeZone getTz(final String tzid) throws TimezonesException {
    return tzs.get(tzid);
  }

  @Override
  public List<String> getTzids() throws TimezonesException {
    return new ArrayList<>(tzs.keySet());
  }

  private void processDir(final File dir) throws TimezonesException {
    try {
      //noinspection ConstantConditions
      for (final File f: dir.listFiles()) {
        if (f.isDirectory()) {
          processDir(f);
        } else if (f.isFile()) {
          processFile(f);
        }
      }
    } catch (final Throwable t) {
      throw new TimezonesException(t);
    }
  }

  private void processFile(final File f) throws TimezonesException {
    try {
      if (!f.getName().endsWith(".ics")) {
        return;
      }

      final CalendarBuilder cb = new CalendarBuilder();

      final Calendar c = cb.build(new FileReader(f));

      for (final Object o: c.getComponents()) {
        if (o instanceof VTimeZone) {
          final VTimeZone vt = (VTimeZone)o;

          tzs.put(vt.getTimeZoneId().getValue(), vt);
        }
      }
    } catch (final Throwable t) {
      throw new TimezonesException(t);
    }
  }

  @Override
  public void close() throws Exception {

  }
}


