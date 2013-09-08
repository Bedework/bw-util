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
package org.bedework.util.struts;

import java.io.Serializable;
import java.text.DateFormatSymbols;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

/** Class to help in formatting of time and date strings. Allows callers to set
 *  the current date/time format.
 *
 * @author Mike Douglass douglm@rpi.edu
 * @version 1.0
 */

public class TimeDateFormatter implements Serializable {
  private SimpleDateFormat formatter;
  private Locale curLocale;
  private int curStyle;
  private boolean usingStyle;

  /** */
  public final static int time = 0;
  /** */
  public final static int date = 1;
  /** */
  public final static int timeDate = 2;
  /** */
  public final static int dateTime = 3;
  /** */
  public final static int timeShort = 4;
  /** */
  public final static int dateShort = 5;
  /** */
  public final static int timeDateShort = 6;
  /** */
  public final static int dateTimeShort = 7;

  /** */
  public final static int dflt = dateTime;

  private String timePattern = "h:mm a";
  private String datePattern = "MMM d, yyyy";
  private String timeDatePattern = timePattern + " " + datePattern;
  private String dateTimePattern = datePattern + " " + timePattern;
  private String timeShortPattern = "h:mm a";
  private String dateShortPattern = "M/d/yyyy";
  private String timeDateShortPattern = timeShortPattern + " " + dateShortPattern;
  private String dateTimeShortPattern = dateShortPattern + " " + timeShortPattern;

  private String defaultPattern = dateTimePattern;

  /**
   *
   */
  public TimeDateFormatter() {
    this(dflt);
  }

  /**
   * @param style
   */
  public TimeDateFormatter(int style) {
    this(style, Locale.getDefault());
  }

  /**
   * @param style
   * @param l
   */
  public TimeDateFormatter(int style, Locale l) {
    getFormatter(style, l);
  }

  /**
   * @param pattern
   */
  public TimeDateFormatter(String pattern) {
    this(pattern, Locale.getDefault());
  }

  /**
   * @param pattern
   * @param l
   */
  public TimeDateFormatter(String pattern, Locale l) {
    getFormatter(pattern, l);
  }

  /** Return a text representation of the Date object
   *
   * @param val Date
   * @return text representation of the Date object
   */
  public String format(Date val) {
    return formatter.format(val);
  }

  /**
   * @param val
   * @return parsed parameter
   * @throws Exception
   */
  public Date parse(String val) throws Exception {
    if (val == null) return null;

    return formatter.parse(val);
  }

  /**
   * @param style
   */
  public void setStyle(int style) {
    getFormatter(style, curLocale);
  }

  /**
   * @param style
   * @param pattern
   */
  public void setStylePattern(int style, String pattern) {
    if (style == time) {
      timePattern = pattern;
    } else if (style == date) {
      datePattern = pattern;
    } else if (style == timeDate) {
      timeDatePattern = pattern;
    } else if (style == timeDate) {
      dateTimePattern = pattern;
    } else if (style == timeShort) {
      timeShortPattern = pattern;
    } else if (style == dateShort) {
      dateShortPattern = pattern;
    } else if (style == timeDateShort) {
      timeDateShortPattern = pattern;
    } else if (style == timeDateShort) {
      dateTimeShortPattern = pattern;
    }

    if (usingStyle) {
      getFormatter(curStyle, curLocale);
    }
  }

  /**
   * @param pattern
   */
  public void setPattern(String pattern) {
    getFormatter(pattern, curLocale);
  }

  private void getFormatter(int style, Locale l) {
    String pattern = defaultPattern;
    curLocale = l;
    curStyle = style;
    usingStyle = true;

    if (style == time) {
      pattern = timePattern;
    } else if (style == date) {
      pattern = datePattern;
    } else if (style == timeDate) {
      pattern = timeDatePattern;
    } else if (style == timeDate) {
      pattern = dateTimePattern;
    } else if (style == timeShort) {
      pattern = timeShortPattern;
    } else if (style == dateShort) {
      pattern = dateShortPattern;
    } else if (style == timeDateShort) {
      pattern = timeDateShortPattern;
    } else if (style == timeDateShort) {
      pattern = dateTimeShortPattern;
    }

    formatter = new SimpleDateFormat(pattern, new DateFormatSymbols(l));
  }

  private void getFormatter(String pattern, Locale l) {
    curLocale = l;
    usingStyle = false;
    formatter = new SimpleDateFormat(pattern, new DateFormatSymbols(l));
  }

}
