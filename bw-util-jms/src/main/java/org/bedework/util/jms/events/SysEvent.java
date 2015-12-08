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
package org.bedework.util.jms.events;

import org.bedework.util.jms.NotificationException;
import org.bedework.util.misc.ToString;
import org.bedework.util.misc.Util;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * A system event - like adding something, updating something, startup, shutdown
 * etc.
 * <p>
 * The Notifications interface uses these to carry information about system
 * events. Listeners can be registered for particular system event types.
 * <p>
 * sub-classes should define the compareTo() and hashCode methods. They should
 * also define fields and methods appropriate to the type of event.
 * <p>
 * For example, the ENTITY_UPDATE event should contain enough information to
 * identify the entity, e.g. the path for a calendar or a uid for the event. It
 * is probably NOT a good idea to have a reference to the actual entity.
 * <p>
 * Some of these events may be persisted to ensure their survival across system
 * restarts and their generation is considered part of the operation.
 * <p>
 * Note that we do not modify system events once they are persisted. We retrieve
 * them and delete them from the database.
 *
 * @author Mike Douglass
 */
public class SysEvent implements Serializable, Comparable<SysEvent> {
  /* Predefined system codes */

  public final static String syscodeStats = "STATS";

  public final static String syscodeTimedEvent = "TIMED_EVENT";

  private static final long serialVersionUID = 1L;

  private final String sysCode;

  private SysEvent related;

  /** UTC datetime */
  private String dtstamp;

  /**
   * Ensure uniqueness - dtstamp only down to second.
   */
  private int sequence;

  /** An attribute for the JMX message header
   *
   */
  public static class Attribute {
    public String name;
    public String value;

    public Attribute(final String name,
                     final String value) {
      this.name = name;
      this.value = value;
    }
  }

  /**
   * Constructor
   *
   * @param sysCode the system event code
   */
  public SysEvent(final String sysCode) {
    this.sysCode = sysCode;

    updateDtstamp();
  }

  /**
   *
   * @return the system event code
   */
  public String getSysCode() {
    return sysCode;
  }

  /** Override this to add extra attributes
   *
   * @param attrs  List of attributes for the JMX message header
   */
  public void addMessageAttributes(final List<Attribute> attrs) {
    attrs.add(new Attribute("syscode", getSysCode()));
  }

  /**
   *
   * @return List of attributes for the JMX message header
   */
  public List<Attribute> getMessageAttributes() {
    final List<Attribute> attrs = new ArrayList<>();

    addMessageAttributes(attrs);

    return attrs;
  }

  /**
   * @param val a date stamp
   */
  public void setDtstamp(final String val) {
    dtstamp = val;
  }

  /**
   * @return String dtstamp
   */
  public String getDtstamp() {
    return dtstamp;
  }

  /**
   * Set the sequence
   *
   * @param val
   *          sequence number
   */
  public void setSequence(final int val) {
    sequence = val;
  }

  /**
   * Get the sequence
   *
   * @return int the sequence
   */
  public int getSequence() {
    return sequence;
  }

  /**
   * This allows for linking together related events. For example a calendar
   * change event might be triggered by an event being added.
   *
   * @param val the related system event
   */
  public void setRelated(final SysEvent val) {
    related = val;
  }

  /**
   * @return  the related system event
   */
  public SysEvent getRelated() {
    return related;
  }

  /*
   * ====================================================================
   * Factory methods
   * ====================================================================
   */

  /**
   * @param label a useful label
   * @param millisecs - time for stats
   * @return SysEvent
   * @throws NotificationException
   */
  public static SysEvent makeTimedEvent(final String label,
                                        final long millisecs) throws NotificationException {
    return new TimedEvent(syscodeTimedEvent,
                          label, millisecs);
  }

  /* *
   * @param name for the event
   * @param strValue a string value
   * @return SysEvent
   * @throws NotificationException
   * /
  public static SysEvent makeStatsEvent(final String name,
                                        final String strValue)
                                            throws NotificationException {
    return new StatsEvent(name, strValue);
  }*/

  /**
   * @param name for the event
   * @param longValue a value - often a time
   * @return SysEvent
   * @throws NotificationException
   */
  public static SysEvent makeStatsEvent(final String name,
                                        final Long longValue)
          throws NotificationException {
    return new StatsEvent(name, longValue);
  }

  /**
   * Update last mod fields
   */
  private void updateDtstamp() {
    setDtstamp(Util.icalUTCTimestamp());
    setSequence(getSequence() + 1);
  }

  /*
   * ==================================================================== Object
   * methods
   * ====================================================================
   */

  @Override
  public int compareTo(final SysEvent val) {
    if (val == null) {
      return 1;
    }
    return (sysCode.compareTo(val.sysCode));
  }

  @Override
  public int hashCode() {
    return sysCode.hashCode();
  }

  /** Add our stuff to the ToString object
  *
  * @param ts    ToString for result
  */
 public void toStringSegment(final ToString ts) {
   ts.append("sysCode", String.valueOf(getSysCode()));
   ts.append("dtstamp", getDtstamp());
   ts.append("sequence", getSequence());
 }

  @Override
  public String toString() {
    final ToString ts = new ToString(this);

    toStringSegment(ts);

    return ts.toString();
  }
}
