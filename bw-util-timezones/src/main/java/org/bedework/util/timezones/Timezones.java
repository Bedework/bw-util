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

import org.bedework.util.logging.Logged;
import org.bedework.util.timezones.model.TimezoneListType;

import net.fortuna.ical4j.model.TimeZone;
import net.fortuna.ical4j.model.TimeZoneRegistry;

import java.io.Serializable;
import java.util.Collection;

/** Handle caching, retrieval and registration of timezones. Timezones are
 * generally retrieved from some outside source, that is a timezone service.
 *
 * @author Mike Douglass
 *
 */
public abstract class Timezones implements Logged, Serializable {
  private final static ThreadLocal<String> threadTzid =
    new ThreadLocal<>();

  private static Timezones tzs;

  private static class TzRegistry implements TimeZoneRegistry {
    @Override
    public void register(final TimeZone timezone) {
      // Do nothing
    }

    @Override
    public void register(final TimeZone timezone, final boolean update) {
      // Do nothing
    }

    @Override
    public void clear() {
      // Do nothing
    }

    @Override
    public TimeZone getTimeZone(final String id) {
      try {
        return Timezones.getTimezones().getTimeZone(id);
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  private final static TimeZoneRegistry tzRegistry = new TzRegistry();

  /**
   * @return a registry for fetching timezones.
   */
  public static TimeZoneRegistry getTzRegistry() {
    return tzRegistry;
  }

  /* ====================================================================
   *                   Static methods
   * ==================================================================== */

  /** Initialize the timezones system.
   *
   * @param serverUrl url of timezone server
   * @throws TimezonesException on error
   */
  public static void initTimezones(final String serverUrl) throws TimezonesException {
    try {
      if (tzs == null) {
        tzs = (Timezones)Class.forName("org.bedework.util.timezones.TimezonesImpl").newInstance();
      }

      tzs.init(serverUrl);
    } catch (final TimezonesException te) {
      throw te;
    } catch (final Throwable t) {
      throw new TimezonesException(t);
    }
  }

  /**
   * @return a Timezones object
   */
  public static Timezones getTimezones() {
    if (tzs == null) {
      throw new RuntimeException("Timezones not initialized");
    }

    return tzs;
  }

  /** Set the default timezone id for this system.
   *
   * @param id timezone id e.g. America/New_York
   * @throws TimezonesException on error
   */
  public static void setSystemDefaultTzid(final String id) throws TimezonesException {
    getTimezones().setDefaultTimeZoneId(id);
  }

  /** Get the default timezone id for this system.
   *
   * @return String id
   * @throws TimezonesException on error
   */
  public static String getSystemDefaultTzid() throws TimezonesException {
    return getTimezones().getDefaultTimeZoneId();
  }

  /** Set the default timezone id for this thread.
   *
   * @param id timezone id e.g. America/New_York
   * @throws TimezonesException on error
   */
  public static void setThreadDefaultTzid(final String id) throws TimezonesException {
    threadTzid.set(id);
  }

  /** Get the default timezone id for this thread.
   *
   * @return String id
   * @throws TimezonesException on error
   */
  public static String getThreadDefaultTzid() throws TimezonesException {
    final String id = threadTzid.get();

    if (id != null) {
      return id;
    }
    return getSystemDefaultTzid();
  }

  /** Get the default timezone for this system.
   *
   * @return default TimeZone or null for none set.
   * @throws TimezonesException on error
   */
  public static TimeZone getDefaultTz() throws TimezonesException {
    return getTz(getThreadDefaultTzid());
  }

  /** Get a timezone object given the id. This will return transient objects
   * registered in the timezone directory
   *
   * @param id timezone id e.g. America/New_York
   * @return TimeZone with id or null
   * @throws TimezonesException on error
   */
   public static TimeZone getTz(final String id) throws TimezonesException {
     return getTimezones().getTimeZone(id);
   }

  /** Given a String time value and a possibly null tzid,
   *  will return a UTC formatted value. The supplied time should be of the
   *  form yyyyMMdd or yyyyMMddThhmmss or yyyyMMddThhmmssZ
   *
   *  <p>The last form will be returned untouched, it's already UTC.
   *
   *  <p>the first will have T000000 appended to the parameter value then the
   *  first and second will be converted to the equivalent UTC time.
   *
   *  <p>The returned value is used internally as a value for indexes and
   *  recurrence ids.
   *
   *  <p>tz null mean this is local or floating time
   *
   * @param time  String time to convert.
   * @param tzid  String tzid.
   * @return String always of form yyyyMMddThhmmssZ
   * @throws TimezonesException for bad parameters or timezone
   */
  public static String getUtc(final String time,
                              final String tzid) throws TimezonesException {
    return getTimezones().calculateUtc(time, tzid);
  }

  /** Register a timezone object in the current session.
   *
   * @param id timezone id e.g. America/New_York
   * @param timezone object
   * @throws TimezonesException on error
   */
  public static void registerTz(final String id, final TimeZone timezone)
          throws TimezonesException {
    /* We don't allow ical to change our timezones. */
    //getTimezones().registerTimeZone(id, timezone);
  }

  /** Get an unmodifiable list of timezone names
   *
   * @return Collection of timezone names
   * @throws TimezonesException on error
   */
  public static Collection<TimeZoneName> getTzNames() throws TimezonesException {
    return getTimezones().getTimeZoneNames();
  }

  /** Refresh the timezone table - presumably after a call to clearPublicTimezones.
   * and many calls to saveTimeZone.
   *
   * @throws TimezonesException on error
   */
  public static void refreshTzs() throws TimezonesException {
    getTimezones().refreshTimezones();
  }

  /* ====================================================================
   *                   Abstract methods
   * ==================================================================== */

  /** Initialise the object supplying the url of the timezones server.
   *
   * @param serverUrl the url
   * @throws TimezonesException on error
   */
  public abstract void init(String serverUrl) throws TimezonesException;

  /** Get a timezone object given the id. This method will attempt to retrieve
   * a cached timezone and if that fails a will try to fetch the tz from the
   * store by calling fetchTimeZone.
   *
   * @param id timezone id e.g. America/New_York
   * @return TimeZone with id or null
   * @throws TimezonesException on error
   */
  public abstract TimeZone getTimeZone(String id) throws TimezonesException;

  /** A non-null object means tz exists. A null tz means that it has identical
   * etags.
   *
   * @author douglm
   */
  public static class TaggedTimeZone {
    /** server etag */
    public String etag;

    /** null if etags matched */
    public String vtz;

    /** null if etags matched */
    public TimeZone tz;

    /**
     * @param etag http etag
     */
    public TaggedTimeZone(final String etag) {
      this.etag = etag;
    }

    /**
     * @param etag http etag
     * @param vtz VTIMEZONE
     */
    public TaggedTimeZone(final String etag,
                          final String vtz) {
      this.etag = etag;
      this.vtz = vtz;
    }
  }

  /** Get a timezone object given the id and etag. This method will bypass the
   * cach and call a remote service directly.
   *
   * @param id timezone id e.g. America/New_York
   * @param etag - null for unconditional fetch
   * @return TaggedTimeZone or null
   * @throws TimezonesException on error
   */
  public abstract TaggedTimeZone getTimeZone(String id,
                                             String etag) throws TimezonesException;

  /** Get an unmodifiable list of timezone names
   *
   * @return Collection of timezone names
   * @throws TimezonesException on error
   */
  public abstract Collection<TimeZoneName> getTimeZoneNames()
      throws TimezonesException;

  /** Get timezone list as defined by spec.
   *
   * @param changedSince if non-null is XML formatted UTC datetime indicating
   *                     last dtstamp received by caller
   * @return Collection of timezone names
   * @throws TimezonesException on error
   */
  public abstract TimezoneListType getList(String changedSince) throws TimezonesException;

  /** Refresh the timezone table - usually after timezones have changed..
   *
   * @throws TimezonesException on error
   */
  public abstract void refreshTimezones() throws TimezonesException;

  /**
   * @param tzid timezone id e.g. America/New_York
   * @return String
   * @throws TimezonesException on error
   */
  public abstract String unalias(String tzid) throws TimezonesException;

  /**
   * @param id timezone id e.g. America/New_York
   * @throws TimezonesException on error
   */
  public abstract void setDefaultTimeZoneId(String id) throws TimezonesException;

  /** Get the default timezone id for this system.
   *
   * @return String id
   * @throws TimezonesException on error
   */
  public abstract String getDefaultTimeZoneId() throws TimezonesException;

  /** Get the default timezone for this system.
   *
   * @return default TimeZone or null for none set.
   * @throws TimezonesException on error
   */
  public abstract TimeZone getDefaultTimeZone() throws TimezonesException;

  /** Register a timezone object in the current session.
   *
   * @param id timezone id e.g. America/New_York
   * @param timezone the timezone object
   * @throws TimezonesException on error
   */
  public abstract void register(String id,
                                TimeZone timezone)
           throws TimezonesException;

  /** Given a String time value and a possibly null tzid
   *  will return a UTC formatted value. The supplied time should be of the
   *  form yyyyMMdd or yyyyMMddThhmmss or yyyyMMddThhmmssZ
   *
   *  <p>The last form will be returned untouched, it's already UTC.
   *
   *  <p>the others will be converted to the equivalent UTC time.
   *
   *  <p>The returned value is used internally as a value for indexes and
   *  recurrence ids.
   *
   *  <p>tzid null mean this is local or floating time
   *
   * @param time  String time to convert.
   * @param tzid  String tzid.
   * @return String always of form yyyyMMddThhmmssZ
   * @throws TimezonesException for bad parameters or timezone
   */
  public abstract String calculateUtc(String time,
                                      String tzid) throws TimezonesException;

  /**
   * @return Number of utc values cached
   */
  public abstract long getDatesCached();

  /**
   * @return date cache hits
   */
  public abstract long getDateCacheHits();

  /**
   * @return data cache misses.
   */
  public abstract long getDateCacheMisses();
}
