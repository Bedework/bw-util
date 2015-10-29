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
package org.bedework.util.vcard;

import org.bedework.util.xml.tagdefs.BedeworkServerTags;
import org.bedework.util.xml.tagdefs.XcardTags;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;

import javax.xml.namespace.QName;

/** Define an (arbitrary) index associated with vcard properties
 *
 * @author Mike Douglass   douglm  rpi.edu
 */
public class CardPropertyIndex implements Serializable {
  private CardPropertyIndex() {};

  private static final boolean IS_MULTI = true;

  private static final boolean IS_SINGLE = false;

  private static final boolean IS_PARAM = true;

  private static final boolean NOT_PARAM = false;

  private static final boolean IS_IMMUTABLE = true;

  private static final boolean NOT_IMMUTABLE = false;

  /** */
  public static enum DataType {
    /** */
    BINARY(XcardTags.binaryVal, "binary"),

    /** */
    BOOLEAN(XcardTags.booleanVal, "boolean"),

    /** */
    CUA(XcardTags.calAddressVal, "cal-address"),

    /** */
    DATE(XcardTags.dateVal, "date"),

    /** */
    DATE_TIME(XcardTags.dateTimeVal, "date-time"),

    /** */
    DATE_AND_OR_TIME(XcardTags.dateAndOrTimeTimeVal, "date-and-or-time"),

    /** */
    FLOAT(XcardTags.floatVal, "float"),

    /** */
    INTEGER(XcardTags.integerVal, "integer"),

    /** */
    PERIOD(XcardTags.periodVal, "period"),

    /** */
    TEXT(XcardTags.textVal, "text"),

    /** */
    TIME(XcardTags.timeVal, "time"),

    /** */
    URI(XcardTags.uriVal, "uri"),

    /** */
    UTC_OFFSET(XcardTags.utcOffsetVal, "utc-offset"),

    /** More work */
    SPECIAL(null, null),

    /** Non-ical */
    HREF(null, null);

    private final QName xcalType;

    private final String jsonType;

    DataType(final QName xcalType, final String jsonType) {
      this.xcalType = xcalType;
      this.jsonType = jsonType;
    }

    /**
     * @return type or null
     */
    public QName getXcalType() {
      return xcalType;
    }

    /**
     * @return type or null
     */
    public String getJsonType() {
      return jsonType;
    }
  }

  /** */
  public static enum ParameterInfoIndex {
    /** */
    UNKNOWN_PARAMETER(null),

    /**
     */
    ALTID("ALTID"),

    /**
     */
    CALSCALE("CALSCALE"),

    /**
     */
    GEO("GEO"),

    /**
     */
    LANGUAGE("LANGUAGE"),

    /**
     */
    MEDIATYPE("MEDIATYPE"),

    /**
     */
    PID("PID"),

    /**
     */
    PREF("PREF", "pref", DataType.INTEGER),

    /**
     */
    SORT_AS("SORT-AS", "sort-as"),

    /**
     */
    TYPE("TYPE"),

    /**
     */
    TZ("TZ"),

    /**
     */
    VALUE("VALUE");

    private final String pname;

    private String pnameLC;

    private String jname;

    private final DataType ptype;

    private static final HashMap<String, ParameterInfoIndex> pnameLookup =
            new HashMap<>();

    static {
      for (final ParameterInfoIndex pii: values()) {
        final String pname = pii.getPnameLC();
        pnameLookup.put(pname, pii);
      }
    }

    ParameterInfoIndex(final String pname) {
      this(pname, null, DataType.TEXT);
    }

    ParameterInfoIndex(final String pname,
                       final String jname) {
      this(pname, jname, DataType.TEXT);
    }

    ParameterInfoIndex(final String pname,
                       final String jname,
                       final DataType ptype) {
      this.pname = pname;
      this.jname = jname;
      this.ptype = ptype;

      if (pname != null) {
        pnameLC = pname.toLowerCase();
      }

      if (jname == null) {
        this.jname = pnameLC;
      }
    }

    /** get the parameter name
     *
     * @return parameter name
     */
    public String getPname() {
      return pname;
    }

    /** get the java style name
     *
     * @return parameter name
     */
    public String getJname() {
      return jname;
    }

    /** get the property name lower cased
     *
     * @return property name
     */
    public String getPnameLC() {
      return pnameLC;
    }

    /** get the parameter type
     *
     * @return parameter type
     */
    public DataType getPtype() {
      return ptype;
    }

    /** get the index given the parameter name
     *
     * @param val parameter name
     * @return ParameterInfoIndex
     */
    public static ParameterInfoIndex lookupPname(final String val) {
      return pnameLookup.get(val.toLowerCase());
    }
  }

  /** */
  public static enum PropertyInfoIndex {
    /** */
    UNKNOWN_PROPERTY(null,
                     //null,
                     IS_SINGLE),

  /* =====================================================================
                             General
     ===================================================================== */

    /** */
    SOURCE(XcardTags.source,
//           ActionPropType.class,
           IS_SINGLE),

    /** */
    KIND(XcardTags.kind,
//           ActionPropType.class,
           IS_SINGLE),

  /* =====================================================================
                             Identification
     ===================================================================== */

    /** */
    FN(XcardTags.fn,
//           ActionPropType.class,
         IS_SINGLE),

    /** */
    N(XcardTags.n,
//           ActionPropType.class,
         IS_SINGLE),

    /** */
    NICKNAME(XcardTags.nickname,
//           ActionPropType.class,
         IS_SINGLE),

    /** */
    PHOTO(XcardTags.photo,
//           ActionPropType.class,
          DataType.URI,
          IS_MULTI),

    /**  */
    BDAY(XcardTags.bday,
//           AttachPropType.class,
           DataType.DATE_AND_OR_TIME,
           IS_SINGLE),

    /** */
    ANNIVERSARY(XcardTags.anniversary,
//             AttendeePropType.class,
             DataType.DATE_AND_OR_TIME,
             IS_SINGLE),

    /** */
    GENDER(XcardTags.gender,
//             BusytypePropType.class,
             IS_SINGLE),

  /* =====================================================================
                             Delivery Addressing
     ===================================================================== */

    /** */
    ADR(XcardTags.adr,
//           ActionPropType.class,
          IS_MULTI),

  /* =====================================================================
                             Communications
     ===================================================================== */

    /** */
    TEL(XcardTags.tel,
//           ActionPropType.class,
        IS_MULTI),

    /** */
    EMAIL(XcardTags.email,
//           ActionPropType.class,
        IS_MULTI),

    /** */
    IMPP(XcardTags.impp,
//           ActionPropType.class,
         DataType.URI,
          IS_MULTI),

    /** */
    LANG(XcardTags.lang,
//           ActionPropType.class,
          IS_MULTI),

  /* =====================================================================
                    Geographical
     ===================================================================== */

    /** */
    TZ(XcardTags.tz,
//           ActionPropType.class,
         IS_MULTI),

    /** */
    GEO(XcardTags.geo,
//           ActionPropType.class,
         DataType.URI,
         IS_MULTI),

  /* =====================================================================
                              Organizational
     ===================================================================== */

    /** */
    TITLE(XcardTags.title,
//           ActionPropType.class,
       IS_MULTI),

    /** */
    ROLE(XcardTags.role,
//           ActionPropType.class,
       IS_MULTI),

    /** */
    LOGO(XcardTags.logo,
//           ActionPropType.class,
        DataType.URI,
        IS_MULTI),

    /** */
    ORG(XcardTags.org,
//           ActionPropType.class,
       IS_MULTI),

    /** */
    MEMBER(XcardTags.member,
//           ActionPropType.class,
         DataType.URI,
         IS_MULTI),

    /** */
    RELATED(XcardTags.related,
//           ActionPropType.class,
         DataType.URI,
         IS_MULTI),

  /* =====================================================================
                              Explanatory
     ===================================================================== */

    /** String names */
    CATEGORIES(XcardTags.categories,
//              CategoriesPropType.class,
               IS_MULTI),

    /** */
    NOTE(XcardTags.note,
//           ActionPropType.class,
        IS_MULTI),

    /** */
    PRODID(XcardTags.prodid,
//           ActionPropType.class,
        IS_SINGLE),

    /** date stamp */
    REV(XcardTags.rev,
//            DtstampPropType.class,
            DataType.DATE_TIME,
            IS_SINGLE),

    /** */
    SOUND(XcardTags.sound,
//           ActionPropType.class,
            DataType.URI,
            IS_MULTI),

    /** */
    UID(XcardTags.uid,
//           ActionPropType.class,
           IS_SINGLE),

    /** */
    CLIENTPIDMAP(XcardTags.clientpidmap,
//           ActionPropType.class,
         IS_MULTI),

    /** */
    URL(XcardTags.url,
//           ActionPropType.class,
          DataType.URI,
          IS_MULTI),

    /** */
    VERSION(XcardTags.version,
//           ActionPropType.class,
        IS_SINGLE),

  /* =====================================================================
                              Security
     ===================================================================== */

    /** */
    KEY(XcardTags.key,
//           ActionPropType.class,
                 IS_MULTI),

  /* =====================================================================
                              Calendar
     ===================================================================== */

    /** */
    FBURL(XcardTags.fburl,
//           ActionPropType.class,
        DataType.URI,
        IS_MULTI),

    /** */
    CALADRURL(XcardTags.caladrurl,
//           ActionPropType.class,
           DataType.URI,
           IS_MULTI),

    /** */
    CALURL(XcardTags.calurl,
//           ActionPropType.class,
          DataType.URI,
          IS_MULTI),

    /** non ical * /
    ETAG(BedeworkServerTags.etag,
         null,
         DataType.TEXT,
         IS_SINGLE,
         NOT_PARAM, IS_IMMUTABLE),

    /** non ical * /
    HREF(WebdavTags.href,
         null,
         DataType.HREF,
         IS_SINGLE,
         NOT_PARAM, IS_IMMUTABLE),

    /** non ical * /
    OWNER(BedeworkServerTags.owner,
          null,
          DataType.HREF,
          IS_SINGLE,
          NOT_PARAM, IS_IMMUTABLE),

    /** ------------------------ Bedework only properties ----------- */

    /** ACL */
    ACL(BedeworkServerTags.xprop,
        null,
        IS_MULTI),

    /** path to containing collection */
    COLPATH(BedeworkServerTags.xprop,
            null,
            IS_MULTI),

    /** non ical * /
    CTAG(BedeworkServerTags.ctag,
         null,
         DataType.TEXT,
         IS_SINGLE,
         NOT_PARAM, IS_IMMUTABLE),

    /** non ical * /
    CTOKEN(BedeworkServerTags.xprop,
           null,
           DataType.TEXT,
           IS_SINGLE,
           NOT_PARAM, IS_IMMUTABLE),

    /** */
    DBID(BedeworkServerTags.xprop,
            null,
            IS_SINGLE),

    DOCTYPE(BedeworkServerTags.xprop,
            null,
            IS_SINGLE),

    /** name of entity */
    NAME(BedeworkServerTags.xprop,
         null,
         IS_SINGLE),

    PUBLIC(BedeworkServerTags.xprop,
           null,
               IS_SINGLE),

    /* For bedework annotations/overrides */
    TARGET(BedeworkServerTags.xprop,
           null,
           IS_SINGLE),

    PARAMETERS(BedeworkServerTags.xprop,
               null,
               IS_SINGLE),

    /** Special term for sorts */
    RELEVANCE(BedeworkServerTags.xprop,
              null,
              IS_SINGLE),

    VALUE(BedeworkServerTags.xprop,
          null,
          IS_SINGLE);

    private QName qname;

    private String pname;

    private String pnameLC;

    private Class xmlClass;

    private DataType ptype;

    /* true if the standard says it's multi */
    private boolean multiValued;

    /* true if we store multi - e.g. multi-language */
    private boolean dbMultiValued;

    private boolean param; /* It's a parameter   */

    private boolean immutable;

    private static Map<QName, PropertyInfoIndex> qnameLookup =
            new HashMap<>();

    private static Map<Class, PropertyInfoIndex> xmlClassLookup =
            new HashMap<>();

    static {
      for (PropertyInfoIndex pii: values()) {
        qnameLookup.put(pii.getQname(), pii);

        xmlClassLookup.put(pii.xmlClass, pii);
      }
    }

    PropertyInfoIndex(final QName qname,
//                      final Class xmlClass,
                      final boolean multiValued) {
      this.qname = qname;
//      this.xmlClass = xmlClass;
      this.multiValued = multiValued;
      dbMultiValued = multiValued;
    }

    PropertyInfoIndex(final QName qname,
//                      final Class xmlClass,
                      final DataType ptype,
                      final boolean multiValued) {
      this(qname, /*xmlClass,*/ multiValued);
      this.ptype = ptype;
    }

    PropertyInfoIndex(final QName qname,
//                      final Class xmlClass,
                      final boolean multiValued,
                      final boolean dbMultiValued) {
      this(qname, /*xmlClass, */DataType.TEXT,
           multiValued,
           NOT_PARAM, NOT_IMMUTABLE);
      this.dbMultiValued = dbMultiValued;
    }

    PropertyInfoIndex(final QName qname,
//                      final Class xmlClass,
                      final DataType ptype,
                      final boolean multiValued,
                      final boolean param,
                      final boolean immutable) {
      this(qname, /*xmlClass, */multiValued);
      this.ptype = ptype;
      this.param = param;
      this.immutable = immutable;
    }

    /** Property names can have "-" in them. This method takes the
     * name, replaces any "-" with underscore and then tries valueOf.
     *
     * @param pname - any case
     * @return index or null if not found
     */
    public static PropertyInfoIndex fromName(final String pname) {
      final String name;

      if (!pname.contains("-")) {
        name = pname.toUpperCase();
      } else {
        name = pname.replace("-", "_").toUpperCase();
      }

      try {
        return PropertyInfoIndex.valueOf(name);
      } catch (final Throwable ignored) {
        return null;
      }
    }

    /** get the qname
     *
     * @return qname
     */
    public QName getQname() {
      return qname;
    }

    /** get the XML class
     *
     * @return class
     */
    public Class getXmlClass() {
      return xmlClass;
    }

    /** get the property type
     *
     * @return property type
     */
    public DataType getPtype() {
      return ptype;
    }

    /** May need some elaboration - this is for the standard
     *
     * @return boolean
     */
    public boolean getMultiValued() {
      return multiValued;
    }

    /** May need some elaboration - this is for the db
     *
     * @return boolean
     */
    public boolean getDbMultiValued() {
      return dbMultiValued;
    }

    /** True if it's a parameter
     *
     * @return boolean
     */
    public boolean getParam() {
      return param;
    }

    /** True if it's immutable
     *
     * @return boolean
     */
    public boolean getImmutable() {
      return immutable;
    }

    /** get the index given the XML class
     * @param cl - class
     * @return PropertyInfoIndex
     */
    public static PropertyInfoIndex fromXmlClass(final Class cl) {
      return xmlClassLookup.get(cl);
    }

    /** get the index given the qname
     *
     * @param val the qname
     * @return PropertyInfoIndex
     */
    public static PropertyInfoIndex lookupQname(final QName val) {
      return qnameLookup.get(val);
    }
  }
}
