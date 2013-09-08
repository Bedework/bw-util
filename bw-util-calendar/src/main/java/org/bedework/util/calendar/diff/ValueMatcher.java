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
package org.bedework.util.calendar.diff;

import org.bedework.util.calendar.XcalUtil;
import org.bedework.util.xml.tagdefs.XcalTags;

import ietf.params.xml.ns.icalendar_2.ActionPropType;
import ietf.params.xml.ns.icalendar_2.AttachPropType;
import ietf.params.xml.ns.icalendar_2.CalAddressListParamType;
import ietf.params.xml.ns.icalendar_2.CalAddressParamType;
import ietf.params.xml.ns.icalendar_2.CalAddressPropertyType;
import ietf.params.xml.ns.icalendar_2.CalscalePropType;
import ietf.params.xml.ns.icalendar_2.CategoriesPropType;
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
 */
public class ValueMatcher {
  /**
   * @author douglm
   *
   * @param <T>
   */
  public interface ValueConverter<T> {
    /** Called to convert an object of a registered class. Converters implementing
     * this interface are registered with a value matcher
     *
     * Note that standard value types (those defined in the standard schema)
     * are all registered once only at system initialization.
     *
     * @param val
     * @return a ValueComparator
     */
    ValueComparator convert(T val);

    /** Called to get a property or parameter object containing only the value.
     * The property or parameter object is a new instance. Its value is copied.
     *
     * @param val
     * @return property object containing value only
     */
    T getElementAndValue(T val);

    /** Return either a single valued set or a set with the values split into
     * separate objects
     *
     * @param val
     * @return set containing the object or the split object
     */
    List<T> getNormalized(T val);
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

  /**
   */
  public ValueMatcher() {
  }

  /**
   * @param val - value to match
   * @return comparator
   */
  @SuppressWarnings("unchecked")
  public ValueComparator getComparator(final Object val) {
    return getConverter(val).convert(val);
  }

  /** Called to get a property or parameter object containing only the value.
   * The property or parameter object is a new instance. Its value is copied.
   *
   * @param val
   * @return property object containing value only
   */
  @SuppressWarnings("unchecked")
  public Object getElementAndValue(final Object val) {
    return getConverter(val).getElementAndValue(val);
  }

  /**
   * @param val
   * @return normalized set of objects
   */
  @SuppressWarnings("unchecked")
  public List getNormalized(final Object val) {
    return getConverter(val).getNormalized(val);
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

  private static abstract class DefaultConverter<T> implements ValueConverter<T> {
    @Override
    public List<T> getNormalized(final T val) {
      List<T> res = new ArrayList<T>();

      res.add(val);

      return res;
    }
  }

  /* ========================================================================
   *          Property values
   * ======================================================================== */

  private static class ActionPropConverter extends DefaultConverter<ActionPropType> {
    @Override
    public ValueComparator convert(final ActionPropType val) {
      ValueComparator vc = new ValueComparator();

      vc.addValue(XcalTags.textVal,
                       val.getText().toString());

      return vc;
    }

    @Override
    public ActionPropType getElementAndValue(final ActionPropType val) {
      try {
        ActionPropType prop = val.getClass().newInstance();

        prop.setText(val.getText());

        return prop;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  private static class FreebusyPropConverter implements ValueConverter<FreebusyPropType> {
    @Override
    public ValueComparator convert(final FreebusyPropType val) {
      List<PeriodType> ps = val.getPeriod();
      ValueComparator vc = new ValueComparator();

      for (PeriodType p: ps) {
        StringBuilder sb = new StringBuilder(p.getStart().toXMLFormat());
        sb.append("\t");
        if (p.getDuration() != null) {
          sb.append(p.getDuration());
        } else {
          sb.append(p.getEnd().toXMLFormat());
        }
        vc.addValue(XcalTags.periodVal, sb.toString());
      }

      return vc;
    }

    @Override
    public FreebusyPropType getElementAndValue(final FreebusyPropType val) {
      try {
        FreebusyPropType prop = val.getClass().newInstance();

        List<PeriodType> ps = val.getPeriod();

        for (PeriodType p: ps) {
          prop.getPeriod().add(p);
        }

        return prop;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }

    @Override
    public List<FreebusyPropType> getNormalized(final FreebusyPropType val) {
      try {
        List<FreebusyPropType> res = new ArrayList<FreebusyPropType>();
        List<PeriodType> ps = val.getPeriod();

        for (PeriodType p: ps) {
          FreebusyPropType prop = val.getClass().newInstance();
          prop.getPeriod().add(p);
          res.add(prop);
          prop.setParameters(val.getParameters());
        }

        return res;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  private static class RequestStatusPropConverter extends DefaultConverter<RequestStatusPropType> {
    @Override
    public ValueComparator convert(final RequestStatusPropType val) {
      RequestStatusPropType rs = val;
      ValueComparator vc = new ValueComparator();

      vc.addValue(XcalTags.codeVal, rs.getCode());

      if (rs.getDescription() != null) {
        vc.addValue(XcalTags.descriptionVal, rs.getDescription());
      }

      if (rs.getExtdata() != null) {
        vc.addValue(XcalTags.extdataVal, rs.getExtdata());
      }

      return vc;
    }

    @Override
    public RequestStatusPropType getElementAndValue(final RequestStatusPropType val) {
      try {
        RequestStatusPropType prop = val.getClass().newInstance();
        RequestStatusPropType rs = val;

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

  private static class GeoPropConverter extends DefaultConverter<GeoPropType> {
    @Override
    public ValueComparator convert(final GeoPropType val) {
      GeoPropType gp = val;
      ValueComparator vc = new ValueComparator();

      vc.addValue(XcalTags.latitudeVal,
                       String.valueOf(gp.getLatitude()));
      vc.addValue(XcalTags.longitudeVal,
                       String.valueOf(gp.getLongitude()));

      return vc;
    }

    @Override
    public GeoPropType getElementAndValue(final GeoPropType val) {
      try {
        GeoPropType prop = val.getClass().newInstance();
        GeoPropType gp = val;

        prop.setLatitude(gp.getLatitude());
        prop.setLongitude(gp.getLongitude());

        return prop;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  private static class StatusPropConverter extends DefaultConverter<StatusPropType> {
    @Override
    public ValueComparator convert(final StatusPropType val) {
      ValueComparator vc = new ValueComparator();

      vc.addValue(XcalTags.textVal, val.getText().toString());

      return vc;
    }

    @Override
    public StatusPropType getElementAndValue(final StatusPropType val) {
      try {
        StatusPropType prop = val.getClass().newInstance();

        prop.setText(val.getText());

        return prop;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  private static class TranspPropConverter extends DefaultConverter<TranspPropType> {
    @Override
    public ValueComparator convert(final TranspPropType val) {
      ValueComparator vc = new ValueComparator();

      vc.addValue(XcalTags.textVal,
                       val.getText().toString());

      return vc;
    }

    @Override
    public TranspPropType getElementAndValue(final TranspPropType val) {
      try {
        TranspPropType prop = val.getClass().newInstance();

        prop.setText(val.getText());

        return prop;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  private static class CalscalePropConverter extends DefaultConverter<CalscalePropType> {
    @Override
    public ValueComparator convert(final CalscalePropType val) {
      ValueComparator vc = new ValueComparator();

      vc.addValue(XcalTags.textVal,
                       val.getText().toString());

      return vc;
    }

    @Override
    public CalscalePropType getElementAndValue(final CalscalePropType val) {
      try {
        CalscalePropType prop = val.getClass().newInstance();

        prop.setText(val.getText());

        return prop;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  private static class TriggerPropConverter extends DefaultConverter<TriggerPropType> {
    @Override
    public ValueComparator convert(final TriggerPropType val) {
      TriggerPropType tp = val;
      ValueComparator vc = new ValueComparator();

      if (tp.getDuration() != null) {
        vc.addValue(XcalTags.durationVal,
                         tp.getDuration().toString());
      } else {
        vc.addValue(XcalTags.dateTimeVal,
                         tp.getDateTime().toString());
      }

      return vc;
    }

    @Override
    public TriggerPropType getElementAndValue(final TriggerPropType val) {
      try {
        TriggerPropType prop = val.getClass().newInstance();
        TriggerPropType tp = val;

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

  private static class DurationPropConverter extends DefaultConverter<DurationPropType> {
    @Override
    public ValueComparator convert(final DurationPropType val) {
      ValueComparator vc = new ValueComparator();

      vc.addValue(XcalTags.durationVal,
                       val.getDuration().toString());

      return vc;
    }

    @Override
    public DurationPropType getElementAndValue(final DurationPropType val) {
      try {
        DurationPropType prop = val.getClass().newInstance();

        prop.setDuration(val.getDuration());

        return prop;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  private static class AttachPropConverter extends DefaultConverter<AttachPropType> {
    @Override
    public ValueComparator convert(final AttachPropType val) {
      AttachPropType ap = val;
      ValueComparator vc = new ValueComparator();

      if (ap.getBinary() !=  null) {
        vc.addValue(XcalTags.binaryVal, ap.getBinary());
      } else {
        vc.addValue(XcalTags.uriVal, ap.getUri());
      }

      return vc;
    }

    @Override
    public AttachPropType getElementAndValue(final AttachPropType val) {
      try {
        AttachPropType prop = val.getClass().newInstance();
        AttachPropType ap = val;

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

  private static class DateDatetimePropConverter extends DefaultConverter<DateDatetimePropertyType> {
    @Override
    public ValueComparator convert(final DateDatetimePropertyType val) {
      XcalUtil.DtTzid dtTzid = XcalUtil.getDtTzid(val);
      ValueComparator vc = new ValueComparator();

      if (dtTzid.dateOnly) {
        vc.addValue(XcalTags.dateVal, dtTzid.dt);
      } else {
        vc.addValue(XcalTags.dateTimeVal, dtTzid.dt);
      }

      /* Note we deal with tzid separately as a parameter */

      return vc;
    }

    @Override
    public DateDatetimePropertyType getElementAndValue(final DateDatetimePropertyType val) {
      try {
        DateDatetimePropertyType prop = val.getClass().newInstance();
        DateDatetimePropertyType dt = val;

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

  private static class DatetimePropConverter extends DefaultConverter<DatetimePropertyType> {
    @Override
    public ValueComparator convert(final DatetimePropertyType val) {
      ValueComparator vc = new ValueComparator();

      vc.addValue(XcalTags.dateTimeVal,
                       XcalUtil.getIcalFormatDateTime(
                         val.getDateTime().toString()));

      return vc;
    }

    @Override
    public DatetimePropertyType getElementAndValue(final DatetimePropertyType val) {
      try {
        DatetimePropertyType prop = val.getClass().newInstance();

        prop.setDateTime(val.getDateTime());

        return prop;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  private static class UtcDatetimePropConverter extends DefaultConverter<UtcDatetimePropertyType> {
    @Override
    public ValueComparator convert(final UtcDatetimePropertyType val) {
      ValueComparator vc = new ValueComparator();

      vc.addValue(XcalTags.utcDateTimeVal,
                XcalUtil.getIcalFormatDateTime(
                    val.getUtcDateTime().toString()));

      return vc;
    }

    @Override
    public UtcDatetimePropertyType getElementAndValue(final UtcDatetimePropertyType val) {
      try {
        UtcDatetimePropertyType prop = val.getClass().newInstance();

        prop.setUtcDateTime(val.getUtcDateTime());

        return prop;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  private static class CalAddressPropConverter extends DefaultConverter<CalAddressPropertyType> {
    @Override
    public ValueComparator convert(final CalAddressPropertyType val) {
      ValueComparator vc = new ValueComparator();

      vc.addValue(XcalTags.calAddressVal, val.getCalAddress());

      return vc;
    }

    @Override
    public CalAddressPropertyType getElementAndValue(final CalAddressPropertyType val) {
      try {
        CalAddressPropertyType prop = val.getClass().newInstance();

        prop.setCalAddress(val.getCalAddress());

        return prop;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  private static class UtcOffsetPropConverter extends DefaultConverter<UtcOffsetPropertyType> {
    @Override
    public ValueComparator convert(final UtcOffsetPropertyType val) {
      ValueComparator vc = new ValueComparator();

      vc.addValue(XcalTags.utcOffsetVal,
                       val.getUtcOffset());

      return vc;
    }

    @Override
    public UtcOffsetPropertyType getElementAndValue(final UtcOffsetPropertyType val) {
      try {
        UtcOffsetPropertyType prop = val.getClass().newInstance();

        prop.setUtcOffset(val.getUtcOffset());

        return prop;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  private static class TextListPropConverter extends DefaultConverter<TextListPropertyType> {
    @Override
    public ValueComparator convert(final TextListPropertyType val) {
      List<String> ss = val.getText();
      ValueComparator vc = new ValueComparator();

      for (String s: ss) {
        vc.addValue(XcalTags.textVal, s);
      }

      return vc;
    }

    @Override
    public TextListPropertyType getElementAndValue(final TextListPropertyType val) {
      try {
        TextListPropertyType prop = val.getClass().newInstance();
        List<String> ss = val.getText();

        for (String s: ss) {
          prop.getText().add(s);
        }

        return prop;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }

    @Override
    public List<TextListPropertyType> getNormalized(final TextListPropertyType val) {
      if (!(val instanceof CategoriesPropType)) {
        return super.getNormalized(val);
      }

      try {
        List<TextListPropertyType> res = new ArrayList<TextListPropertyType>();

        for (String s: val.getText()) {
          TextListPropertyType prop = val.getClass().newInstance();
          prop.getText().add(s);
          res.add(prop);
          prop.setParameters(val.getParameters());
        }

        return res;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  private static class TextPropConverter extends DefaultConverter<TextPropertyType> {
    @Override
    public ValueComparator convert(final TextPropertyType val) {
      ValueComparator vc = new ValueComparator();

      vc.addValue(XcalTags.textVal, val.getText());

      return vc;
    }

    @Override
    public TextPropertyType getElementAndValue(final TextPropertyType val) {
      try {
        TextPropertyType prop = val.getClass().newInstance();

        prop.setText(val.getText());

        return prop;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  private static class RecurPropConverter extends DefaultConverter<RecurPropertyType> {
    @Override
    public ValueComparator convert(final RecurPropertyType val) {
      RecurType r = val.getRecur();
      ValueComparator vc = new ValueComparator();

      append(vc, XcalTags.freq, r.getFreq().toString());
      append(vc, XcalTags.count, r.getCount());
      append(vc, XcalTags.until, r.getUntil());
      append(vc, XcalTags.interval, r.getInterval());
      append(vc, XcalTags.bysecond, r.getBysecond());
      append(vc, XcalTags.byminute, r.getByminute());
      append(vc, XcalTags.byhour, r.getByhour());
      append(vc, XcalTags.byday, r.getByday());
      append(vc, XcalTags.byyearday, r.getByyearday());
      append(vc, XcalTags.bymonthday, r.getBymonthday());
      append(vc, XcalTags.byweekno, r.getByweekno());
      append(vc, XcalTags.bymonth, r.getBymonth());
      append(vc, XcalTags.bysetpos, r.getBysetpos());

      if (r.getWkst() != null) {
        append(vc, XcalTags.wkst, r.getWkst().toString());
      }

      return vc;
    }

    @Override
    public RecurPropertyType getElementAndValue(final RecurPropertyType val) {
      try {
        RecurPropertyType prop = val.getClass().newInstance();

        prop.setRecur(val.getRecur());

        return prop;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }

    private void append(final ValueComparator vc,
                        final QName nm,
                        final List val) {
      if (val == null) {
        return;
      }

      for (Object o: val) {
        append(vc, nm, o);
      }
    }

    private void append(final ValueComparator vc,
                        final QName nm,
                        final Object val) {
      if (val == null) {
        return;
      }

      vc.addValue(nm, String.valueOf(val));
    }
  }

  private static class IntegerPropConverter extends DefaultConverter<IntegerPropertyType> {
    @Override
    public ValueComparator convert(final IntegerPropertyType val) {
      ValueComparator vc = new ValueComparator();

      vc.addValue(XcalTags.integerVal,
                       String.valueOf(val.getInteger()));

      return vc;
    }

    @Override
    public IntegerPropertyType getElementAndValue(final IntegerPropertyType val) {
      try {
        IntegerPropertyType prop = val.getClass().newInstance();

        prop.setInteger(val.getInteger());

        return prop;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  private static class UriPropConverter extends DefaultConverter<UriPropertyType> {
    @Override
    public ValueComparator convert(final UriPropertyType val) {
      ValueComparator vc = new ValueComparator();

      vc.addValue(XcalTags.uriVal, val.getUri());

      return vc;
    }

    @Override
    public UriPropertyType getElementAndValue(final UriPropertyType val) {
      try {
        UriPropertyType prop = val.getClass().newInstance();

        prop.setUri(val.getUri());

        return prop;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  /* ========================================================================
   *          Parameter values
   * ======================================================================== */

  private static class CalAddressParamConverter extends DefaultConverter<CalAddressParamType> {
    @Override
    public ValueComparator convert(final CalAddressParamType val) {
      ValueComparator vc = new ValueComparator();

      vc.addValue(XcalTags.calAddressVal, val.getCalAddress());

      return vc;
    }

    @Override
    public CalAddressParamType getElementAndValue(final CalAddressParamType val) {
      try {
        CalAddressParamType param = val.getClass().newInstance();

        param.setCalAddress(val.getCalAddress());

        return param;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  private static class CalAddressListParamConverter extends DefaultConverter<CalAddressListParamType> {
    @Override
    public ValueComparator convert(final CalAddressListParamType val) {
      List<String> ss = val.getCalAddress();
      ValueComparator vc = new ValueComparator();

      for (String s: ss) {
        vc.addValue(XcalTags.calAddressVal, s);
      }

      return vc;
    }

    @Override
    public CalAddressListParamType getElementAndValue(final CalAddressListParamType val) {
      try {
        CalAddressListParamType param = val.getClass().newInstance();
        List<String> ss = val.getCalAddress();

        for (String s: ss) {
          param.getCalAddress().add(s);
        }

        return param;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  private static class TextParamConverter extends DefaultConverter<TextParameterType> {
    @Override
    public ValueComparator convert(final TextParameterType val) {
      ValueComparator vc = new ValueComparator();

      vc.addValue(XcalTags.textVal, val.getText());

      return vc;
    }

    @Override
    public TextParameterType getElementAndValue(final TextParameterType val) {
      try {
        TextParameterType param = val.getClass().newInstance();

        param.setText(val.getText());

        return param;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  private static class UriParamConverter extends DefaultConverter<UriParameterType> {
    @Override
    public ValueComparator convert(final UriParameterType val) {
      ValueComparator vc = new ValueComparator();

      vc.addValue(XcalTags.uriVal, val.getUri());

      return vc;
    }

    @Override
    public UriParameterType getElementAndValue(final UriParameterType val) {
      try {
        UriParameterType param = val.getClass().newInstance();

        param.setUri(val.getUri());

        return param;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  private static class CutypeParamConverter extends DefaultConverter<CutypeParamType> {
    @Override
    public ValueComparator convert(final CutypeParamType val) {
      ValueComparator vc = new ValueComparator();

      vc.addValue(XcalTags.textVal, val.getText());

      return vc;
    }

    @Override
    public CutypeParamType getElementAndValue(final CutypeParamType val) {
      try {
        CutypeParamType param = val.getClass().newInstance();

        param.setText(val.getText());

        return param;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  private static class EncodingParamConverter extends DefaultConverter<EncodingParamType> {
    @Override
    public ValueComparator convert(final EncodingParamType val) {
      ValueComparator vc = new ValueComparator();

      vc.addValue(XcalTags.textVal, val.getText());

      return vc;
    }

    @Override
    public EncodingParamType getElementAndValue(final EncodingParamType val) {
      try {
        EncodingParamType param = val.getClass().newInstance();

        param.setText(val.getText());

        return param;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  private static class FbtypeParamConverter extends DefaultConverter<FbtypeParamType> {
    @Override
    public ValueComparator convert(final FbtypeParamType val) {
      ValueComparator vc = new ValueComparator();

      vc.addValue(XcalTags.textVal, val.getText());

      return vc;
    }

    @Override
    public FbtypeParamType getElementAndValue(final FbtypeParamType val) {
      try {
        FbtypeParamType param = val.getClass().newInstance();

        param.setText(val.getText());

        return param;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  private static class PartstatParamConverter extends DefaultConverter<PartstatParamType> {
    @Override
    public ValueComparator convert(final PartstatParamType val) {
      ValueComparator vc = new ValueComparator();

      vc.addValue(XcalTags.textVal, val.getText());

      return vc;
    }

    @Override
    public PartstatParamType getElementAndValue(final PartstatParamType val) {
      try {
        PartstatParamType param = val.getClass().newInstance();

        param.setText(val.getText());

        return param;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  private static class RangeParamConverter extends DefaultConverter<RangeParamType> {
    @Override
    public ValueComparator convert(final RangeParamType val) {
      ValueComparator vc = new ValueComparator();

      vc.addValue(XcalTags.textVal,
                       val.getText().toString());

      return vc;
    }

    @Override
    public RangeParamType getElementAndValue(final RangeParamType val) {
      try {
        RangeParamType param = val.getClass().newInstance();

        param.setText(val.getText());

        return param;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  private static class RelatedParamConverter extends DefaultConverter<RelatedParamType> {
    @Override
    public ValueComparator convert(final RelatedParamType val) {
      ValueComparator vc = new ValueComparator();

      vc.addValue(XcalTags.textVal, val.getText());

      return vc;
    }

    @Override
    public RelatedParamType getElementAndValue(final RelatedParamType val) {
      try {
        RelatedParamType param = val.getClass().newInstance();

        param.setText(val.getText());

        return param;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  private static class ReltypeParamConverter extends DefaultConverter<ReltypeParamType> {
    @Override
    public ValueComparator convert(final ReltypeParamType val) {
      ValueComparator vc = new ValueComparator();

      vc.addValue(XcalTags.textVal, val.getText().toString());

      return vc;
    }

    @Override
    public ReltypeParamType getElementAndValue(final ReltypeParamType val) {
      try {
        ReltypeParamType param = val.getClass().newInstance();

        param.setText(val.getText());

        return param;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  private static class RoleParamConverter extends DefaultConverter<RoleParamType> {
    @Override
    public ValueComparator convert(final RoleParamType val) {
      ValueComparator vc = new ValueComparator();

      vc.addValue(XcalTags.textVal, val.getText());

      return vc;
    }

    @Override
    public RoleParamType getElementAndValue(final RoleParamType val) {
      try {
        RoleParamType param = val.getClass().newInstance();

        param.setText(val.getText());

        return param;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  private static class RsvpParamConverter extends DefaultConverter<RsvpParamType> {
    @Override
    public ValueComparator convert(final RsvpParamType val) {
      ValueComparator vc = new ValueComparator();

      vc.addValue(XcalTags.booleanVal,
                       String.valueOf(val.isBoolean()));

      return vc;
    }

    @Override
    public RsvpParamType getElementAndValue(final RsvpParamType val) {
      try {
        RsvpParamType param = val.getClass().newInstance();

        param.setBoolean(val.isBoolean());

        return param;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  private static class ScheduleAgentParamConverter extends DefaultConverter<ScheduleAgentParamType> {
    @Override
    public ValueComparator convert(final ScheduleAgentParamType val) {
      ValueComparator vc = new ValueComparator();

      vc.addValue(XcalTags.textVal, val.getText());

      return vc;
    }

    @Override
    public ScheduleAgentParamType getElementAndValue(final ScheduleAgentParamType val) {
      try {
        ScheduleAgentParamType param = val.getClass().newInstance();

        param.setText(val.getText());

        return param;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  private static class ScheduleForceSendParamConverter extends DefaultConverter<ScheduleForceSendParamType> {
    @Override
    public ValueComparator convert(final ScheduleForceSendParamType val) {
      ValueComparator vc = new ValueComparator();

      vc.addValue(XcalTags.textVal, val.getText());

      return vc;
    }

    @Override
    public ScheduleForceSendParamType getElementAndValue(final ScheduleForceSendParamType val) {
      try {
        ScheduleForceSendParamType param = val.getClass().newInstance();

        param.setText(val.getText());

        return param;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }
}
