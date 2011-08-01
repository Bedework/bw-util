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
package edu.rpi.cmt.calendar.diff;

import edu.rpi.cmt.calendar.XcalUtil;
import edu.rpi.sss.util.xml.NsContext;
import edu.rpi.sss.util.xml.tagdefs.XcalTags;

import ietf.params.xml.ns.icalendar_2.ActionPropType;
import ietf.params.xml.ns.icalendar_2.AttachPropType;
import ietf.params.xml.ns.icalendar_2.CalAddressListParamType;
import ietf.params.xml.ns.icalendar_2.CalAddressParamType;
import ietf.params.xml.ns.icalendar_2.CalAddressPropertyType;
import ietf.params.xml.ns.icalendar_2.CalscalePropType;
import ietf.params.xml.ns.icalendar_2.CutypeParamType;
import ietf.params.xml.ns.icalendar_2.DateDatetimePropertyType;
import ietf.params.xml.ns.icalendar_2.DatetimePropertyType;
import ietf.params.xml.ns.icalendar_2.DurationPropType;
import ietf.params.xml.ns.icalendar_2.EncodingParamType;
import ietf.params.xml.ns.icalendar_2.FbtypeParamType;
import ietf.params.xml.ns.icalendar_2.FreebusyPropType;
import ietf.params.xml.ns.icalendar_2.GeoPropType;
import ietf.params.xml.ns.icalendar_2.IntegerPropertyType;
import ietf.params.xml.ns.icalendar_2.PartstatParamType;
import ietf.params.xml.ns.icalendar_2.PeriodType;
import ietf.params.xml.ns.icalendar_2.RangeParamType;
import ietf.params.xml.ns.icalendar_2.RecurPropertyType;
import ietf.params.xml.ns.icalendar_2.RecurType;
import ietf.params.xml.ns.icalendar_2.RelatedParamType;
import ietf.params.xml.ns.icalendar_2.ReltypeParamType;
import ietf.params.xml.ns.icalendar_2.RequestStatusPropType;
import ietf.params.xml.ns.icalendar_2.RoleParamType;
import ietf.params.xml.ns.icalendar_2.RsvpParamType;
import ietf.params.xml.ns.icalendar_2.ScheduleAgentParamType;
import ietf.params.xml.ns.icalendar_2.ScheduleForceSendParamType;
import ietf.params.xml.ns.icalendar_2.StatusPropType;
import ietf.params.xml.ns.icalendar_2.TextListPropertyType;
import ietf.params.xml.ns.icalendar_2.TextParameterType;
import ietf.params.xml.ns.icalendar_2.TextPropertyType;
import ietf.params.xml.ns.icalendar_2.TranspPropType;
import ietf.params.xml.ns.icalendar_2.TriggerPropType;
import ietf.params.xml.ns.icalendar_2.UriParameterType;
import ietf.params.xml.ns.icalendar_2.UriPropertyType;
import ietf.params.xml.ns.icalendar_2.UtcDatetimePropertyType;
import ietf.params.xml.ns.icalendar_2.UtcOffsetPropertyType;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.xml.namespace.QName;

/** This class allows comparison of calendaring values. Each value is
 * represented by an iCalendar value-type element (e.g. text, integer).
 *
 * They can be added to the ValueMatcher object and then that object can be
 * compared to another to determine if the values are equal.
 *
 * @author Mike Douglass
 *
 */
public class ValueMatcher implements Comparable<ValueMatcher> {
  /**
   * @author douglm
   */
  public interface ValueConverter {
    /** Called to convert an object of a registered class. Converter implementing
     * this interface are registered with a value matcher
     *
     * Note that standard value types (those defined in the standard schema)
     * are all registered once only at system initialization.
     *
     * @param matcher
     * @param val
     */
    void convert(ValueMatcher matcher, Object val);

    /** Called to get a property or parameter object containing only the value.
     * The property or parameter object is a new instance. Its value is copied.
     *
     * @param val
     * @return property object containing value only
     */
    Object getElementAndValue(Object val);
  }

  private static class ValueMatcherRegistry {
    private static Map<Class, ValueConverter> standardConverters =
        new HashMap<Class, ValueConverter>();

    private Map<Class, ValueConverter> nonStandardConverters;

    /** Register a non-standard converter. This can override standard converters.
     *
     * @param cl
     * @param vc
     */
    public void registerConverter(final Class cl, final ValueConverter vc) {
      if (nonStandardConverters != null) {
        nonStandardConverters = new HashMap<Class, ValueConverter>();
      }

      nonStandardConverters.put(cl, vc);
    }

    private void registerStandardConverter(final Class cl,
                                           final ValueConverter vc) {
      standardConverters.put(cl, vc);
    }

    private ValueConverter getConverter(final Object o) {
      ValueConverter vc;
      Class cl = o.getClass();

      if (nonStandardConverters != null) {
        vc = findConverter(cl, nonStandardConverters);

        if (vc != null) {
          return vc;
        }
      }

      vc = findConverter(cl, standardConverters);
      if (vc == null) {
        throw new RuntimeException("ValueMatcher: No converter for class " + cl);
      }

      return vc;
    }

    static ValueConverter findConverter(final Class cl,
                                        final Map<Class, ValueConverter> converters) {
      Class lcl = cl;

      while (lcl != null) {
        ValueConverter vc = converters.get(lcl);

        if (vc != null) {
          return vc;
        }

        lcl = lcl.getSuperclass();
      }

      return null;
    }
  }

  private static ValueMatcherRegistry registry = new ValueMatcherRegistry();

  private Map<Class, ValueConverter> instanceConverters;

  private static class ValueTypeEntry implements Comparable<ValueTypeEntry> {
    QName typeElement;
    String value;

    public ValueTypeEntry(final QName typeElement,
                          final String value) {
      this.typeElement = typeElement;
      this.value = value;
    }

    public String toString(final NsContext nsContext) {
      StringBuilder sb = new StringBuilder();

      sb.append("<");
      nsContext.appendNsName(sb, typeElement);
      sb.append(">");
      sb.append(value);
      sb.append("</");
      nsContext.appendNsName(sb, typeElement);
      sb.append(">");

      return sb.toString();
    }

    @Override
    public String toString() {
      StringBuilder sb = new StringBuilder();

      sb.append(" (");
      sb.append(typeElement);
      sb.append(", ");
      sb.append(value);
      sb.append(")");

      return sb.toString();
    }

    public int compareTo(final ValueTypeEntry o) {
      int res = typeElement.getNamespaceURI().compareTo(o.typeElement.getNamespaceURI());
      if (res != 0) {
        return res;
      }

      res = typeElement.getLocalPart().compareTo(o.typeElement.getLocalPart());
      if (res != 0) {
        return res;
      }

      return value.compareTo(o.value);
    }

    @Override
    public int hashCode() {
      return typeElement.hashCode() * value.hashCode();
    }

    @Override
    public boolean equals(final Object o) {
      return compareTo((ValueTypeEntry)o) == 0;
    }
  }

  private List<ValueTypeEntry> vtes = new ArrayList<ValueTypeEntry>();

  private Object theObject;

  private ValueConverter converter;

  /**
   * @param val - value to match
   */
  public ValueMatcher(final Object val) {
    converter = getConverter(val);
    theObject = val;
    converter.convert(this, val);
  }

  /** Called to get a property or parameter object containing only the value.
   * The property or parameter object is a new instance. Its value is copied.
   *
   * @return property object containing value only
   */
  public Object getElementAndValue() {
    return converter.getElementAndValue(theObject);
  }

  /**
   * @param typeElement
   * @param value
   */
  void addValue(final QName typeElement,
                       final String value) {
    vtes.add(new ValueTypeEntry(typeElement, value));
  }

  /** Register a converter used by all instances of the value matcher.
   *
   * @param cl
   * @param vc
   */
  public static void registerGlobalConverter(final Class cl,
                                             final ValueConverter vc) {
    registry.registerConverter(cl, vc);
  }

  /** Register a converter used only by this instance of the value matcher.
   *
   * @param cl
   * @param vc
   */
  public void registerInstanceConverter(final Class cl,
                                        final ValueConverter vc) {
    if (instanceConverters != null) {
      instanceConverters = new HashMap<Class, ValueConverter>();
    }

    instanceConverters.put(cl, vc);
  }

  /**
   * @param nsContext
   * @return String representation
   */
  public String toString(final NsContext nsContext) {
    StringBuilder sb = new StringBuilder();

    for (ValueTypeEntry vte: vtes) {
      sb.append(vte.toString(nsContext));
    }

    return sb.toString();
  }

  @Override
  public String toString() {
    StringBuilder sb = new StringBuilder();

    for (ValueTypeEntry vte: vtes) {
      sb.append(vte.toString());
    }

    return sb.toString();
  }

  public int compareTo(final ValueMatcher o) {
    Integer thisSz = vtes.size();
    Integer thatSz = o.vtes.size();

    int res = thisSz.compareTo(thatSz);
    if (res != 0) {
      return res;
    }

    Iterator<ValueTypeEntry> thatIt = o.vtes.iterator();

    for (ValueTypeEntry vte: vtes) {
      ValueTypeEntry thatVte = thatIt.next();

      res = vte.compareTo(thatVte);
      if (res != 0) {
        return res;
      }
    }

    return 0;
  }

  @Override
  public int hashCode() {
    int res = vtes.size();

    for (ValueTypeEntry vte: vtes) {
      res *= vte.hashCode();
    }

    return res;
  }

  @Override
  public boolean equals(final Object o) {
    return compareTo((ValueMatcher)o) == 0;
  }

  private ValueConverter getConverter(final Object o) {
    ValueConverter vc;
    Class cl = o.getClass();

    if (instanceConverters != null) {
      vc = ValueMatcherRegistry.findConverter(cl, instanceConverters);

      if (vc != null) {
        return vc;
      }
    }

    return registry.getConverter(o);
  }

  static {
    /* ======================================================================
     *          Register property values
     * ====================================================================== */

    registry.registerStandardConverter(ActionPropType.class,
                           new ActionPropConverter());

    registry.registerStandardConverter(FreebusyPropType.class,
                           new FreebusyPropConverter());

    registry.registerStandardConverter(RequestStatusPropType.class,
                           new RequestStatusPropConverter());

    registry.registerStandardConverter(GeoPropType.class,
                           new GeoPropConverter());

    registry.registerStandardConverter(StatusPropType.class,
                           new StatusPropConverter());

    registry.registerStandardConverter(TranspPropType.class,
                           new TranspPropConverter());

    registry.registerStandardConverter(CalscalePropType.class,
                           new CalscalePropConverter());

    registry.registerStandardConverter(TriggerPropType.class,
                           new TriggerPropConverter());

    registry.registerStandardConverter(DurationPropType.class,
                           new DurationPropConverter());

    registry.registerStandardConverter(AttachPropType.class,
                           new AttachPropConverter());

    registry.registerStandardConverter(DateDatetimePropertyType.class,
                           new DateDatetimePropConverter());

    registry.registerStandardConverter(DatetimePropertyType.class,
                           new DatetimePropConverter());

    registry.registerStandardConverter(UtcDatetimePropertyType.class,
                           new UtcDatetimePropConverter());

    registry.registerStandardConverter(CalAddressPropertyType.class,
                           new CalAddressPropConverter());

    registry.registerStandardConverter(UtcOffsetPropertyType.class,
                           new UtcOffsetPropConverter());

    registry.registerStandardConverter(TextListPropertyType.class,
                           new TextListPropConverter());

    registry.registerStandardConverter(TextPropertyType.class,
                           new TextPropConverter());

    registry.registerStandardConverter(RecurPropertyType.class,
                           new RecurPropConverter());

    registry.registerStandardConverter(IntegerPropertyType.class,
                           new IntegerPropConverter());

    registry.registerStandardConverter(UriPropertyType.class,
                           new UriPropConverter());

    /* ========================================================================
     *          Parameter values
     * ======================================================================== */

    registry.registerStandardConverter(CalAddressParamType.class,
                           new CalAddressParamConverter());

    registry.registerStandardConverter(CalAddressListParamType.class,
                           new CalAddressListParamConverter());

    registry.registerStandardConverter(TextParameterType.class,
                           new TextParamConverter());

    registry.registerStandardConverter(UriParameterType.class,
                           new UriParamConverter());

    registry.registerStandardConverter(CutypeParamType.class,
                           new CutypeParamConverter());

    registry.registerStandardConverter(EncodingParamType.class,
                           new EncodingParamConverter());

    registry.registerStandardConverter(FbtypeParamType.class,
                           new FbtypeParamConverter());

    registry.registerStandardConverter(PartstatParamType.class,
                           new PartstatParamConverter());

    registry.registerStandardConverter(RangeParamType.class,
                           new RangeParamConverter());

    registry.registerStandardConverter(RelatedParamType.class,
                           new RelatedParamConverter());

    registry.registerStandardConverter(ReltypeParamType.class,
                           new ReltypeParamConverter());

    registry.registerStandardConverter(RoleParamType.class,
                           new RoleParamConverter());

    registry.registerStandardConverter(RsvpParamType.class,
                           new RsvpParamConverter());

    registry.registerStandardConverter(ScheduleAgentParamType.class,
                           new ScheduleAgentParamConverter());

    registry.registerStandardConverter(ScheduleForceSendParamType.class,
                           new ScheduleForceSendParamConverter());
  }

  /* ========================================================================
   *          Property values
   * ======================================================================== */

  private static class ActionPropConverter implements ValueConverter {
    public void convert(final ValueMatcher matcher, final Object val) {
      matcher.addValue(XcalTags.textVal,
                       ((ActionPropType)val).getText().toString());
    }

    public Object getElementAndValue(final Object val) {
      try {
        ActionPropType prop = (ActionPropType)val.getClass().newInstance();

        prop.setText(((ActionPropType)val).getText());

        return prop;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  private static class FreebusyPropConverter implements ValueConverter {
    public void convert(final ValueMatcher matcher, final Object val) {
      List<PeriodType> ps = ((FreebusyPropType)val).getPeriod();

      for (PeriodType p: ps) {
        StringBuilder sb = new StringBuilder(p.getStart().toXMLFormat());
        sb.append("\t");
        if (p.getDuration() != null) {
          sb.append(p.getDuration());
        } else {
          sb.append(p.getEnd().toXMLFormat());
        }
        matcher.addValue(XcalTags.periodVal, sb.toString());
      }
    }

    public Object getElementAndValue(final Object val) {
      try {
        FreebusyPropType prop = (FreebusyPropType)val.getClass().newInstance();

        List<PeriodType> ps = ((FreebusyPropType)val).getPeriod();

        for (PeriodType p: ps) {
          prop.getPeriod().add(p);
        }

        return prop;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  private static class RequestStatusPropConverter implements ValueConverter {
    public void convert(final ValueMatcher matcher, final Object val) {
      RequestStatusPropType rs = (RequestStatusPropType)val;

      matcher.addValue(XcalTags.codeVal, rs.getCode());

      if (rs.getDescription() != null) {
        matcher.addValue(XcalTags.descriptionVal, rs.getDescription());
      }

      if (rs.getExtdata() != null) {
        matcher.addValue(XcalTags.extdataVal, rs.getExtdata());
      }
    }

    public Object getElementAndValue(final Object val) {
      try {
        RequestStatusPropType prop = (RequestStatusPropType)val.getClass().newInstance();
        RequestStatusPropType rs = (RequestStatusPropType)val;

        prop.setCode(rs.getCode());

        if (rs.getDescription() != null) {
          prop.setDescription(rs.getDescription());
        }

        if (rs.getExtdata() != null) {
          prop.setExtdata(rs.getExtdata());
        }

        return prop;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  private static class GeoPropConverter implements ValueConverter {
    public void convert(final ValueMatcher matcher, final Object val) {
      GeoPropType gp = (GeoPropType)val;

      matcher.addValue(XcalTags.latitudeVal,
                       String.valueOf(gp.getLatitude()));
      matcher.addValue(XcalTags.longitudeVal,
                       String.valueOf(gp.getLongitude()));
    }

    public Object getElementAndValue(final Object val) {
      try {
        GeoPropType prop = (GeoPropType)val.getClass().newInstance();
        GeoPropType gp = (GeoPropType)val;

        prop.setLatitude(gp.getLatitude());
        prop.setLongitude(gp.getLongitude());

        return prop;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  private static class StatusPropConverter implements ValueConverter {
    public void convert(final ValueMatcher matcher, final Object val) {
      matcher.addValue(XcalTags.textVal,
                       ((StatusPropType)val).getText().toString());
    }

    public Object getElementAndValue(final Object val) {
      try {
        StatusPropType prop = (StatusPropType)val.getClass().newInstance();

        prop.setText(((StatusPropType)val).getText());

        return prop;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  private static class TranspPropConverter implements ValueConverter {
    public void convert(final ValueMatcher matcher, final Object val) {
      matcher.addValue(XcalTags.textVal,
                       ((TranspPropType)val).getText().toString());
    }

    public Object getElementAndValue(final Object val) {
      try {
        TranspPropType prop = (TranspPropType)val.getClass().newInstance();

        prop.setText(((TranspPropType)val).getText());

        return prop;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  private static class CalscalePropConverter implements ValueConverter {
    public void convert(final ValueMatcher matcher, final Object val) {
      matcher.addValue(XcalTags.textVal,
                       ((CalscalePropType)val).getText().toString());
    }

    public Object getElementAndValue(final Object val) {
      try {
        CalscalePropType prop = (CalscalePropType)val.getClass().newInstance();

        prop.setText(((CalscalePropType)val).getText());

        return prop;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  private static class TriggerPropConverter implements ValueConverter {
    public void convert(final ValueMatcher matcher, final Object val) {
      TriggerPropType tp = (TriggerPropType)val;

      if (tp.getDuration() != null) {
        matcher.addValue(XcalTags.durationVal,
                         tp.getDuration().toString());
      } else {
        matcher.addValue(XcalTags.dateTimeVal,
                         tp.getDateTime().toString());
      }
    }

    public Object getElementAndValue(final Object val) {
      try {
        TriggerPropType prop = (TriggerPropType)val.getClass().newInstance();
        TriggerPropType tp = (TriggerPropType)val;

        if (tp.getDuration() != null) {
          prop.setDuration(tp.getDuration());
        } else {
          prop.setDateTime(tp.getDateTime());
        }

        return prop;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  private static class DurationPropConverter implements ValueConverter {
    public void convert(final ValueMatcher matcher, final Object val) {
      matcher.addValue(XcalTags.durationVal,
                       ((DurationPropType)val).getDuration().toString());
    }

    public Object getElementAndValue(final Object val) {
      try {
        DurationPropType prop = (DurationPropType)val.getClass().newInstance();

        prop.setDuration(((DurationPropType)val).getDuration());

        return prop;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  private static class AttachPropConverter implements ValueConverter {
    public void convert(final ValueMatcher matcher, final Object val) {
      AttachPropType ap = (AttachPropType)val;

      if (ap.getBinary() !=  null) {
        matcher.addValue(XcalTags.binaryVal, ap.getBinary());
      } else {
        matcher.addValue(XcalTags.uriVal, ap.getUri());
      }
    }

    public Object getElementAndValue(final Object val) {
      try {
        AttachPropType prop = (AttachPropType)val.getClass().newInstance();
        AttachPropType ap = (AttachPropType)val;

        if (ap.getBinary() !=  null) {
          prop.setBinary(ap.getBinary());
        } else {
          prop.setUri(ap.getUri());
        }

        return prop;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  private static class DateDatetimePropConverter implements ValueConverter {
    public void convert(final ValueMatcher matcher, final Object val) {
      XcalUtil.DtTzid dtTzid = XcalUtil.getDtTzid((DateDatetimePropertyType)val);

      if (dtTzid.dateOnly) {
        matcher.addValue(XcalTags.dateVal, dtTzid.dt);
      } else {
        matcher.addValue(XcalTags.dateTimeVal, dtTzid.dt);
      }

      /* Note we deal with tzid separately as a parameter */
    }

    public Object getElementAndValue(final Object val) {
      try {
        DateDatetimePropertyType prop = (DateDatetimePropertyType)val.getClass().newInstance();
        DateDatetimePropertyType dt = (DateDatetimePropertyType)val;

        if (dt.getDate() != null) {
          prop.setDate(dt.getDate());
        } else {
          prop.setDateTime(dt.getDateTime());
        }

        return prop;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  private static class DatetimePropConverter implements ValueConverter {
    public void convert(final ValueMatcher matcher, final Object val) {
      matcher.addValue(XcalTags.dateTimeVal,
                       XcalUtil.getIcalFormatDateTime(
                         ((DatetimePropertyType)val).getDateTime().toString()));
    }

    public Object getElementAndValue(final Object val) {
      try {
        DatetimePropertyType prop = (DatetimePropertyType)val.getClass().newInstance();

        prop.setDateTime(((DatetimePropertyType)val).getDateTime());

        return prop;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  private static class UtcDatetimePropConverter implements ValueConverter {
    public void convert(final ValueMatcher matcher, final Object val) {
      matcher.addValue(XcalTags.utcDateTimeVal,
                XcalUtil.getIcalFormatDateTime(
                    ((UtcDatetimePropertyType)val).getUtcDateTime().toString()));
    }

    public Object getElementAndValue(final Object val) {
      try {
        UtcDatetimePropertyType prop = (UtcDatetimePropertyType)val.getClass().newInstance();

        prop.setUtcDateTime(((UtcDatetimePropertyType)val).getUtcDateTime());

        return prop;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  private static class CalAddressPropConverter implements ValueConverter {
    public void convert(final ValueMatcher matcher, final Object val) {
      matcher.addValue(XcalTags.calAddressVal,
                       ((CalAddressPropertyType)val).getCalAddress());
    }

    public Object getElementAndValue(final Object val) {
      try {
        CalAddressPropertyType prop = (CalAddressPropertyType)val.getClass().newInstance();

        prop.setCalAddress(((CalAddressPropertyType)val).getCalAddress());

        return prop;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  private static class UtcOffsetPropConverter implements ValueConverter {
    public void convert(final ValueMatcher matcher, final Object val) {
      matcher.addValue(XcalTags.utcOffsetVal,
                       ((UtcOffsetPropertyType)val).getUtcOffset());
    }

    public Object getElementAndValue(final Object val) {
      try {
        UtcOffsetPropertyType prop = (UtcOffsetPropertyType)val.getClass().newInstance();

        prop.setUtcOffset(((UtcOffsetPropertyType)val).getUtcOffset());

        return prop;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  private static class TextListPropConverter implements ValueConverter {
    public void convert(final ValueMatcher matcher, final Object val) {
      List<String> ss = ((TextListPropertyType)val).getText();

      for (String s: ss) {
        matcher.addValue(XcalTags.textVal, s);
      }
    }

    public Object getElementAndValue(final Object val) {
      try {
        TextListPropertyType prop = (TextListPropertyType)val.getClass().newInstance();
        List<String> ss = ((TextListPropertyType)val).getText();

        for (String s: ss) {
          prop.getText().add(s);
        }

        return prop;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  private static class TextPropConverter implements ValueConverter {
    public void convert(final ValueMatcher matcher, final Object val) {
      matcher.addValue(XcalTags.textVal,
                       ((TextPropertyType)val).getText());
    }

    public Object getElementAndValue(final Object val) {
      try {
        TextPropertyType prop = (TextPropertyType)val.getClass().newInstance();

        prop.setText(((TextPropertyType)val).getText());

        return prop;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  private static class RecurPropConverter implements ValueConverter {
    public void convert(final ValueMatcher matcher, final Object val) {
      RecurType r = ((RecurPropertyType)val).getRecur();

      append(matcher, XcalTags.freq, r.getFreq().toString());
      append(matcher, XcalTags.count, r.getCount());
      append(matcher, XcalTags.until, r.getUntil());
      append(matcher, XcalTags.interval, r.getInterval());
      append(matcher, XcalTags.bysecond, r.getBysecond());
      append(matcher, XcalTags.byminute, r.getByminute());
      append(matcher, XcalTags.byhour, r.getByhour());
      append(matcher, XcalTags.byday, r.getByday());
      append(matcher, XcalTags.byyearday, r.getByyearday());
      append(matcher, XcalTags.bymonthday, r.getBymonthday());
      append(matcher, XcalTags.byweekno, r.getByweekno());
      append(matcher, XcalTags.bymonth, r.getBymonth());
      append(matcher, XcalTags.bysetpos, r.getBysetpos());
      append(matcher, XcalTags.wkst, r.getWkst().toString());
    }

    public Object getElementAndValue(final Object val) {
      try {
        RecurPropertyType prop = (RecurPropertyType)val.getClass().newInstance();

        prop.setRecur(((RecurPropertyType)val).getRecur());

        return prop;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }

    private void append(final ValueMatcher vt,
                        final QName nm,
                        final List val) {
      if (val == null) {
        return;
      }

      for (Object o: val) {
        append(vt, nm, o);
      }
    }

    private void append(final ValueMatcher vt,
                        final QName nm,
                        final Object val) {
      if (val == null) {
        return;
      }

      vt.addValue(nm, String.valueOf(val));
    }
  }

  private static class IntegerPropConverter implements ValueConverter {
    public void convert(final ValueMatcher matcher, final Object val) {
      matcher.addValue(XcalTags.integerVal,
                       String.valueOf(((IntegerPropertyType)val).getInteger()));
    }

    public Object getElementAndValue(final Object val) {
      try {
        IntegerPropertyType prop = (IntegerPropertyType)val.getClass().newInstance();

        prop.setInteger(((IntegerPropertyType)val).getInteger());

        return prop;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  private static class UriPropConverter implements ValueConverter {
    public void convert(final ValueMatcher matcher, final Object val) {
      matcher.addValue(XcalTags.uriVal,
                       ((UriPropertyType)val).getUri());
    }

    public Object getElementAndValue(final Object val) {
      try {
        UriPropertyType prop = (UriPropertyType)val.getClass().newInstance();

        prop.setUri(((UriPropertyType)val).getUri());

        return prop;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  /* ========================================================================
   *          Parameter values
   * ======================================================================== */

  private static class CalAddressParamConverter implements ValueConverter {
    public void convert(final ValueMatcher matcher, final Object val) {
      matcher.addValue(XcalTags.calAddressVal,
                       ((CalAddressParamType)val).getCalAddress());
    }

    public Object getElementAndValue(final Object val) {
      try {
        CalAddressParamType param = (CalAddressParamType)val.getClass().newInstance();

        param.setCalAddress(((CalAddressParamType)val).getCalAddress());

        return param;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  private static class CalAddressListParamConverter implements ValueConverter {
    public void convert(final ValueMatcher matcher, final Object val) {
      List<String> ss = ((CalAddressListParamType)val).getCalAddress();

      for (String s: ss) {
        matcher.addValue(XcalTags.calAddressVal, s);
      }
    }

    public Object getElementAndValue(final Object val) {
      try {
        CalAddressListParamType param = (CalAddressListParamType)val.getClass().newInstance();
        List<String> ss = ((CalAddressListParamType)val).getCalAddress();

        for (String s: ss) {
          param.getCalAddress().add(s);
        }

        return param;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  private static class TextParamConverter implements ValueConverter {
    public void convert(final ValueMatcher matcher, final Object val) {
      matcher.addValue(XcalTags.textVal,
                       ((TextParameterType)val).getText());
    }

    public Object getElementAndValue(final Object val) {
      try {
        TextParameterType param = (TextParameterType)val.getClass().newInstance();

        param.setText(((TextParameterType)val).getText());

        return param;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  private static class UriParamConverter implements ValueConverter {
    public void convert(final ValueMatcher matcher, final Object val) {
      matcher.addValue(XcalTags.uriVal,
                       ((UriParameterType)val).getUri());
    }

    public Object getElementAndValue(final Object val) {
      try {
        UriParameterType param = (UriParameterType)val.getClass().newInstance();

        param.setUri(((UriParameterType)val).getUri());

        return param;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  private static class CutypeParamConverter implements ValueConverter {
    public void convert(final ValueMatcher matcher, final Object val) {
      matcher.addValue(XcalTags.textVal,
                       ((CutypeParamType)val).getText());
    }

    public Object getElementAndValue(final Object val) {
      try {
        CutypeParamType param = (CutypeParamType)val.getClass().newInstance();

        param.setText(((CutypeParamType)val).getText());

        return param;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  private static class EncodingParamConverter implements ValueConverter {
    public void convert(final ValueMatcher matcher, final Object val) {
      matcher.addValue(XcalTags.textVal,
                       ((EncodingParamType)val).getText());
    }

    public Object getElementAndValue(final Object val) {
      try {
        EncodingParamType param = (EncodingParamType)val.getClass().newInstance();

        param.setText(((EncodingParamType)val).getText());

        return param;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  private static class FbtypeParamConverter implements ValueConverter {
    public void convert(final ValueMatcher matcher, final Object val) {
      matcher.addValue(XcalTags.textVal,
                       ((FbtypeParamType)val).getText());
    }

    public Object getElementAndValue(final Object val) {
      try {
        FbtypeParamType param = (FbtypeParamType)val.getClass().newInstance();

        param.setText(((FbtypeParamType)val).getText());

        return param;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  private static class PartstatParamConverter implements ValueConverter {
    public void convert(final ValueMatcher matcher, final Object val) {
      matcher.addValue(XcalTags.textVal,
                       ((PartstatParamType)val).getText());
    }

    public Object getElementAndValue(final Object val) {
      try {
        PartstatParamType param = (PartstatParamType)val.getClass().newInstance();

        param.setText(((PartstatParamType)val).getText());

        return param;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  private static class RangeParamConverter implements ValueConverter {
    public void convert(final ValueMatcher matcher, final Object val) {
      matcher.addValue(XcalTags.textVal,
                       ((RangeParamType)val).getText().toString());
    }

    public Object getElementAndValue(final Object val) {
      try {
        RangeParamType param = (RangeParamType)val.getClass().newInstance();

        param.setText(((RangeParamType)val).getText());

        return param;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  private static class RelatedParamConverter implements ValueConverter {
    public void convert(final ValueMatcher matcher, final Object val) {
      matcher.addValue(XcalTags.textVal,
                       ((RelatedParamType)val).getText());
    }

    public Object getElementAndValue(final Object val) {
      try {
        RelatedParamType param = (RelatedParamType)val.getClass().newInstance();

        param.setText(((RelatedParamType)val).getText());

        return param;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  private static class ReltypeParamConverter implements ValueConverter {
    public void convert(final ValueMatcher matcher, final Object val) {
      matcher.addValue(XcalTags.textVal,
                       ((ReltypeParamType)val).getText().toString());
    }

    public Object getElementAndValue(final Object val) {
      try {
        ReltypeParamType param = (ReltypeParamType)val.getClass().newInstance();

        param.setText(((ReltypeParamType)val).getText());

        return param;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  private static class RoleParamConverter implements ValueConverter {
    public void convert(final ValueMatcher matcher, final Object val) {
      matcher.addValue(XcalTags.textVal,
                       ((RoleParamType)val).getText());
    }

    public Object getElementAndValue(final Object val) {
      try {
        RoleParamType param = (RoleParamType)val.getClass().newInstance();

        param.setText(((RoleParamType)val).getText());

        return param;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  private static class RsvpParamConverter implements ValueConverter {
    public void convert(final ValueMatcher matcher, final Object val) {
      matcher.addValue(XcalTags.booleanVal,
                       String.valueOf(((RsvpParamType)val).isBoolean()));
    }

    public Object getElementAndValue(final Object val) {
      try {
        RsvpParamType param = (RsvpParamType)val.getClass().newInstance();

        param.setBoolean(((RsvpParamType)val).isBoolean());

        return param;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  private static class ScheduleAgentParamConverter implements ValueConverter {
    public void convert(final ValueMatcher matcher, final Object val) {
      matcher.addValue(XcalTags.textVal,
                       ((ScheduleAgentParamType)val).getText());
    }

    public Object getElementAndValue(final Object val) {
      try {
        ScheduleAgentParamType param = (ScheduleAgentParamType)val.getClass().newInstance();

        param.setText(((ScheduleAgentParamType)val).getText());

        return param;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  private static class ScheduleForceSendParamConverter implements ValueConverter {
    public void convert(final ValueMatcher matcher, final Object val) {
      matcher.addValue(XcalTags.textVal,
                       ((ScheduleForceSendParamType)val).getText());
    }

    public Object getElementAndValue(final Object val) {
      try {
        ScheduleForceSendParamType param = (ScheduleForceSendParamType)val.getClass().newInstance();

        param.setText(((ScheduleForceSendParamType)val).getText());

        return param;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }
}
