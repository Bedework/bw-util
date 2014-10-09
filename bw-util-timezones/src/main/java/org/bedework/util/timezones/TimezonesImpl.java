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

import org.bedework.util.caching.FlushMap;
import org.bedework.util.timezones.DateTimeUtil.BadDateException;
import org.bedework.util.timezones.model.TimezoneListType;
import org.bedework.util.timezones.model.TimezoneType;

import net.fortuna.ical4j.data.CalendarBuilder;
import net.fortuna.ical4j.data.UnfoldingReader;
import net.fortuna.ical4j.model.Component;
import net.fortuna.ical4j.model.TimeZone;
import net.fortuna.ical4j.model.component.VTimeZone;
import net.fortuna.ical4j.util.TimeZones;
import org.apache.log4j.Logger;

import java.io.InputStream;
import java.io.StringReader;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Collection;
import java.util.Collections;
import java.util.Properties;
import java.util.TreeSet;

/** Handle caching, retrieval and registration of timezones.
 *
 * <p>As there is a limited set of timezones used we can cache most or all of them.
 *
 * @author Mike Douglass
 *
 */
public class TimezonesImpl extends Timezones {
  private transient Logger log;

  protected boolean debug;

  private String serverUrl;

  protected String defaultTimeZoneId;
  protected transient TimeZone defaultTimeZone;

  private static final FlushMap<String, TzServer> tzServers =
      new FlushMap<>();

  /* TimezoneInfo cache */
  protected FlushMap<String, TimeZone> timezones =
      new FlushMap<>(60 * 1000 * 60, // 1 hour
                     100); // 100 timezones

  protected static volatile Collection<TimeZoneName> timezoneNames;

  /* Cache date only UTC values - we do a lot of those but the number of
   * different dates should be limited.
   *
   * We have one cache per timezone - we preserve the default timezone entries.
   */

  private static class UTCDateCache extends FlushMap<String, String> {
    String tzid;
    TimeZone tz;

    private UTCDateCache(final String tzid,
                         final TimeZone tz) {
      super(100, 0, 1000);

      this.tzid = tzid;
      this.tz = tz;
    }
  }

  /** A flushed map that preserves the values for the default system timezone
   *
   */
  private class UTCDateCaches extends FlushMap<String, UTCDateCache> {
    private UTCDateCache defaultDateCache;

    private boolean isDefault(final String tzid) {
      return (defaultTimeZoneId != null) && defaultTimeZoneId.equals(tzid);
    }

    @Override
    public boolean containsKey(final Object key) {
      if (isDefault((String)key)) {
        return defaultDateCache != null;
      }

      return super.containsKey(key);
    }

    @Override
    public synchronized UTCDateCache put(final String key,
                                         final UTCDateCache val) {
      if (!isDefault(key)) {
        return super.put(key, val);
      }

      final UTCDateCache cache = defaultDateCache;

      defaultDateCache = val;
      return cache;
    }

    @Override
    public UTCDateCache get(final Object key) {
      if (!isDefault((String)key)) {
        return super.get(key);
      }

      return defaultDateCache;
    }
  }

  private final UTCDateCaches dateCaches = new UTCDateCaches();

  private static Properties aliases;

  private long datesCached;
  private long dateCacheHits;
  private long dateCacheMisses;

  /**
   *
   */
  public TimezonesImpl() {
  }

  @Override
  public void init(final String serverUrl) throws TimezonesException {
    this.serverUrl = serverUrl;
    debug = getLogger().isDebugEnabled();
  }

  /* (non-Javadoc)
   * @see org.bedework.calfacade.timezones.CalTimezones#getTimeZone(java.lang.String)
   */
  @Override
  public TimeZone getTimeZone(final String id) throws TimezonesException {
    //id = unalias(id);

    TimeZone tz = timezones.get(id);
    if (tz != null) {
      return tz;
    }

    tz = fetchTimeZone(id);
    register(id, tz);

    return tz;
  }

  @Override
  public TaggedTimeZone getTimeZone(final String id,
                                    final String etag) throws TimezonesException {
    return fetchTimeZone(id, etag);
  }

  @Override
  public Collection<TimeZoneName> getTimeZoneNames() throws TimezonesException {
    if (timezoneNames != null) {
      return timezoneNames;
    }

    final TzServer server = getTzServer(serverUrl);

    try {
      final TimezoneListType tzlist = server.getList(null);

      final Collection<TimeZoneName> ids = new TreeSet<>();

      for (final TimezoneType s: tzlist.getTimezones()) {
        ids.add(new TimeZoneName(s.getTzid()));
      }

      timezoneNames = Collections.unmodifiableCollection(ids);

      return timezoneNames;
    } finally {
      server.close();
    }
  }

  @Override
  public TimezoneListType getList(final String changedSince) throws TimezonesException {
    final TzServer server = getTzServer(serverUrl);

    try {
      return server.getList(changedSince);
    } finally {
      server.close();
    }
  }

  @Override
  public synchronized void refreshTimezones() throws TimezonesException {
    timezoneNames = null;
    timezones.clear();
  }

  @Override
  public String unalias(String tzid) throws TimezonesException {
    /* First transform the name if it follows a known pattern, for example
     * we used to get     /mozilla.org/20070129_1/America/New_York
     */

    tzid = transformTzid(tzid);

    // Allow chains of aliases

    String target = tzid;

    if (aliases == null) {
      loadAliases();
    }

    for (int i = 0; i < 100; i++) {   // Just in case we get a circular chain
      final String unaliased = aliases.getProperty(target);

      if (unaliased == null) {
        return target;
      }

      if (unaliased.equals(tzid)) {
        break;
      }

      target = unaliased;
    }

    error("Possible circular alias chain looking for " + tzid);

    return null;
  }

//  private static DateFormat formatTd  = new SimpleDateFormat("yyyyMMdd'T'HHmmss");
  private static final Calendar cal = Calendar.getInstance();
  private static final java.util.TimeZone utctz;

  static {
    try {
      utctz = TimeZone.getTimeZone(TimeZones.UTC_ID);
    } catch (final Throwable t) {
      throw new RuntimeException("Unable to initialise UTC timezone");
    }
    cal.setTimeZone(utctz);
  }

  @Override
  public void setDefaultTimeZoneId(final String id) throws TimezonesException {
    defaultTimeZone = null;
    defaultTimeZoneId = id;
  }

  @Override
  public String getDefaultTimeZoneId() throws TimezonesException {
    return defaultTimeZoneId;
  }

  @Override
  public TimeZone getDefaultTimeZone() throws TimezonesException {
    if ((defaultTimeZone == null) && (defaultTimeZoneId != null)) {
      defaultTimeZone = getTimeZone(defaultTimeZoneId);
    }

    return defaultTimeZone;
  }

  @Override
  public synchronized String calculateUtc(final String timePar,
                                          final String tzidPar) throws TimezonesException {
    try {
      //if (debug) {
      //  trace("Get utc for " + time + " tzid=" + tzid + " tz =" + tz);
      //}
      if (DateTimeUtil.isISODateTimeUTC(timePar)) {
        // Already UTC
        return timePar;
      }

      String time = timePar;
      String dateKey = null;
      String tzid = tzidPar;
      if (tzid == null) {
        tzid = getThreadDefaultTzid();
      }

      UTCDateCache cache = dateCaches.get(tzid);

      if ((time.length() == 8) && DateTimeUtil.isISODate(time)) {
        /* See if we have it cached */

        if (cache != null) {
          final String utc = cache.get(time);

          if (utc != null) {
            dateCacheHits++;
            return utc;
          }
        }

        /* Not in the cache - calculate it */

        dateCacheMisses++;
        dateKey = time;
        time += "T000000";
      } else if (!DateTimeUtil.isISODateTime(time)) {
        throw new BadDateException(time);
      }

      final TimeZone tz;

      if (cache != null) {
        // Sanity check
        if (!tzid.equals(cache.tzid)) {
          dateCaches.clear();  // Try to contain the error
          throw new TimezonesException(TimezonesException.cacheError, tzid);
        }

        tz = cache.tz;
      } else {
        tz = getTimeZone(tzid);

        if (tz == null) {
          throw new TimezonesException(TimezonesException.unknownTimezone, tzid);
        }

        cache = new UTCDateCache(tzid, tz);
        dateCaches.put(tzid, cache);
      }

      final DateFormat formatTd  = new SimpleDateFormat("yyyyMMdd'T'HHmmss");
      formatTd.setTimeZone(tz);

      final java.util.Date date = formatTd.parse(time);

      cal.clear();
      cal.setTime(date);

      //formatTd.setTimeZone(utctz);
      //trace("formatTd with utc: " + formatTd.format(date));

      final StringBuilder sb = new StringBuilder();
      digit4(sb, cal.get(Calendar.YEAR));
      digit2(sb, cal.get(Calendar.MONTH) + 1); // Month starts at 0
      digit2(sb, cal.get(Calendar.DAY_OF_MONTH));
      sb.append('T');
      digit2(sb, cal.get(Calendar.HOUR_OF_DAY));
      digit2(sb, cal.get(Calendar.MINUTE));
      digit2(sb, cal.get(Calendar.SECOND));
      sb.append('Z');

      final String utc = sb.toString();

      if (dateKey != null) {
        cache.put(dateKey, utc);
        datesCached++;
      }

      return utc;
    } catch (final TimezonesException cfe) {
      throw cfe;
    } catch (final BadDateException bde) {
      throw new TimezonesException(TimezonesException.badDate, timePar);
    } catch (final Throwable t) {
      //t.printStackTrace();
      throw new TimezonesException(t);
    }
  }

  @Override
  public long getDatesCached() {
    return datesCached;
  }

  @Override
  public long getDateCacheHits() {
    return dateCacheHits;
  }

  /**
   * @return data cache misses.
   */
  @Override
  public long getDateCacheMisses() {
    return dateCacheMisses;
  }

  /* ====================================================================
   *                   Protected methods
   * ==================================================================== */

  /** Fetch a timezone object from the server given the id.
   *
   * @param id the tzid
   * @return TimeZone with id or null
   * @throws TimezonesException
   */
  protected TimeZone fetchTimeZone(final String id) throws TimezonesException {
    final TaggedTimeZone ttz = fetchTimeZone(id, null);

    if (ttz == null) {
      return null;
    }

    register(id, ttz.tz);

    return ttz.tz;
  }

  protected TaggedTimeZone fetchTimeZone(final String id,
                                         final String etag) throws TimezonesException {
    final TzServer server = getTzServer(serverUrl);

    try {
      final TaggedTimeZone ttz = server.getTz(id, etag);

      if (ttz == null) {
        return null;
      }

      final CalendarBuilder cb = new CalendarBuilder();

      final UnfoldingReader ufrdr =
              new UnfoldingReader(new StringReader(ttz.vtz),
                                  true);

      final net.fortuna.ical4j.model.Calendar cal = cb.build(ufrdr);
      final VTimeZone vtz = (VTimeZone)cal.getComponents().getComponent(Component.VTIMEZONE);
      if (vtz == null) {
        throw new TimezonesException("Incorrectly stored timezone");
      }

      ttz.tz = new TimeZone(vtz);

      return ttz;
    } catch (final Throwable t) {
      throw new TimezonesException(t);
    } finally {
      server.close();
    }
  }

  @Override
  public synchronized void register(final String id,
                                    final TimeZone timezone)
          throws TimezonesException {
    timezones.put(id, timezone);
  }

  /* ====================================================================
   *                   private methods
   * ==================================================================== */

  private static TzServer getTzServer(final String url) throws TimezonesException {
    synchronized (tzServers) {
      TzServer svr = tzServers.get(url);

      if (svr != null) {
        return svr;
      }

      svr = new TzServer(url);
      tzServers.put(url, svr);

      return svr;
    }
  }

  private static String transformTzid(final String tzid) {
    final int len = tzid.length();

    if ((len > 13) && (tzid.startsWith("/mozilla.org/"))) {
      final int pos = tzid.indexOf('/', 13);

      if ((pos < 0) || (pos == (len - 1))) {
        return tzid;
      }
      return tzid.substring(pos + 1);
    }

    return tzid;
  }

  private void loadAliases() throws TimezonesException {
    final TzServer server = getTzServer(serverUrl);
    InputStream is = null;

    try {
      final Properties a = new Properties();

      is = server.getAliases();
      a.load(is);

      aliases = a;
    } catch (final Throwable t) {
      error("loadTimezones error: " + t.getMessage());
      t.printStackTrace();
    } finally {
      if (is != null) {
        try {
          is.close();
        } catch (final Throwable ignored) {}
      }

      server.close();
    }
  }


  private void digit2(final StringBuilder sb, final int val) throws BadDateException {
    if (val > 99) {
      throw new BadDateException();
    }
    if (val < 10) {
      sb.append("0");
    }
    sb.append(val);
  }

  private void digit4(final StringBuilder sb, final int val) throws BadDateException {
    if (val > 9999) {
      throw new BadDateException();
    }
    if (val < 10) {
      sb.append("000");
    } else if (val < 100) {
      sb.append("00");
    } else if (val < 1000) {
      sb.append("0");
    }
    sb.append(val);
  }

  /* Get a logger for messages
   */
  private Logger getLogger() {
    if (log == null) {
      log = Logger.getLogger(this.getClass());
    }

    return log;
  }

  private void error(final String msg) {
    getLogger().error(msg);
  }

  @SuppressWarnings("unused")
  private void trace(final String msg) {
    getLogger().debug(msg);
  }
}
