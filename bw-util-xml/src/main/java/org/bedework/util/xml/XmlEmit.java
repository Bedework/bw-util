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
package org.bedework.util.xml;

import java.io.IOException;
import java.io.Reader;
import java.io.Writer;
import java.util.Properties;

import javax.xml.namespace.QName;

/** Class to emit XML
 *
 * @author Mike Douglass  douglm@rpi.edu
 */
public class XmlEmit {
  private Writer wtr;

  private boolean forHtml = false;

  private final boolean noHeaders;

  private String dtd;

  private boolean started;

  private final XmlEmitNamespaces nameSpaces = new XmlEmitNamespaces();

  private Notifier notifier;

  private Properties props;

  public static class XmlUtilException extends RuntimeException {
    public XmlUtilException(final Throwable t) {
      super(t);
    }

    public XmlUtilException(final String msg) {
      super(msg);
    }
  }

  /** Called (frequently) if set. May be used to allow higher level to
   * carry out actions when some output happens, e.g. open surrounding elements.
   *
   * @author douglm
   */
  public static abstract class Notifier {
    /** Called on output if isEnabled returns false
     */
    public abstract void doNotification();

    /**
     * @return true if doNotification should be called
     */
    public abstract boolean isEnabled();
  }

  /**
   * @author douglm
   */
  public static class NameSpace {
    String ns;

    String abbrev;

    int level;

    boolean defaultNs;

    /**
     * @param ns name
     * @param abbrev abbreviation
     */
    public NameSpace(final String ns, final String abbrev) {
      this.ns = ns;
      this.abbrev = abbrev;
    }

    @Override
    public int hashCode() {
      return ns.hashCode();
    }

    @Override
    public boolean equals(final Object o) {
      if (!(o instanceof NameSpace)) {
        return false;
      }

      final NameSpace that = (NameSpace)o;
      return ns.equals(that.ns);
    }
  }

  /** The following allow us to tidy up the output a little.
   */
  int indent;
  private final String blank = "                                       " +
                                "                                       ";
  private final int blankLen = blank.length();

  /** construct an object which will be used to collect namespace names
   * during the first phase and emit xml after startEmit is called.
   */
  public XmlEmit() {
    this(false);
  }

  /** construct an object which will be used to collect namespace names
   * during the first phase and emit xml after startEmit is called.
   *
   * @param noHeaders    boolean true to suppress headers
   */
  public XmlEmit(final boolean noHeaders) {
    this.noHeaders = noHeaders;
  }

  /** construct an object which will be used to emit HTML.
   *
   */
  public static XmlEmit getHtmlEmitter() {
    final XmlEmit xml = new XmlEmit();
    xml.forHtml = true;
    
    return xml;
  }

  /** Allows applications to provide parameters to methods using this object class,
   *
   * <p>For example, a parameter "full" with value "true" might indicate a full
   * XML dump is required.
   *
   * @param name of property
   * @param val of property
   */
  public void setProperty(final String name, final String val) {
    if (props == null) {
      props = new Properties();
    }

    props.setProperty(name, val);
  }

  /**
   * @param name of property
   * @return value or null
   */
  public String getProperty(final String name) {
    if (props == null) {
      return null;
    }

    return props.getProperty(name);
  }

  /** Emit any headers and namespace declarations
   *
   * @param wtr a writer
   */
  public void startEmit(final Writer wtr) {
    this.wtr = wtr;
  }

  /** Emit any headers, dtd and namespace declarations
   *
   * @param wtr a writer
   * @param dtd uri
   */
  public void startEmit(final Writer wtr, final String dtd) {
    this.wtr = wtr;
    this.dtd = dtd;
  }

  /** At the moment fairly primitive - no stacking etc.
   * @param n notifier
   */
  public void setNotifier(final Notifier n) {
    notifier = n;
  }

  /* ===================================== Tag start ======================== */

  /**
   * @param tag qname
   * @throws XmlUtilException on fatal eror
   */
  public void openTag(final QName tag) {
    blanks();
    openTagSameLine(tag);
    newline();
    indent += 2;
  }

  /** open with attribute
   *
   * @param tag qname
   * @param attrName string attribute name
   * @param attrVal attribute name
   * @throws XmlUtilException on fatal eror
   */
  public void openTag(final QName tag,
                      final String attrName,
                      final String attrVal) {
    blanks();
    openTagSameLine(tag, attrName, attrVal);
    newline();
    indent += 2;
  }

  /**
   * @param tag qname
   * @throws XmlUtilException on fatal eror
   */
  public void openTagNoNewline(final QName tag) {
    blanks();
    openTagSameLine(tag);
    indent += 2;
  }

  /**
   * @param tag qname
   * @param attrName string attribute name
   * @param attrVal attribute name
   * @throws XmlUtilException on fatal eror
   */
  @SuppressWarnings("unused")
  public void openTagNoNewline(final QName tag,
                               final String attrName,
                               final String attrVal) {
    blanks();
    openTagSameLine(tag, attrName, attrVal);
    indent += 2;
  }

  /**
   * @param tag qname
   * @throws XmlUtilException on fatal eror
   */
  public void openTagSameLine(final QName tag) {
    lb();
    emitQName(tag);
    endOpeningTag();
  }

  /** Emit an opening tag ready for nested values. No new line
   *
   * @param tag qname
   * @param attrName string attribute name
   * @param attrVal attribute name
   * @throws XmlUtilException on fatal eror
   */
  public void openTagSameLine(final QName tag,
                              final String attrName,
                              final String attrVal) {
    lb();
    emitQName(tag);
    attribute(attrName, attrVal);
    endOpeningTag();
  }

  /** Start tag ready for attributes
   *
   * @param tag qname
   * @throws XmlUtilException on fatal eror
   */
  public void startTag(final QName tag) {
    blanks();
    startTagSameLine(tag);
  }

  /** Start tag ready for attributes - new line and indent
   *
   * @param tag qname
   * @throws XmlUtilException on fatal eror
   */
  public void startTagIndent(final QName tag) {
    blanks();
    startTagSameLine(tag);
    indent += 2;
  }

  /** Start a tag ready for some attributes. No new line
   *
   * @param tag qname
   * @throws XmlUtilException on fatal eror
   */
  public void startTagSameLine(final QName tag) {
    lb();
    emitQName(tag);
  }

  /** End a tag we are opening
   *
   * @throws XmlUtilException on fatal eror
   */
  public void endOpeningTag() {
    scopeIn();
    rb();
  }

  /* ===================================== Attributes ======================= */

  /** Add an attribute
   *
   * @param attrName string attribute name
   * @param attrVal attribute name
   * @throws XmlUtilException on fatal eror
   */
  public void attribute(final String attrName, final String attrVal) {
    out(" ");
    out(attrName);
    out("=");
    quote(attrVal);
  }

  /** Add an attribute
   *
   * @param attr qname attribute name
   * @param attrVal attribute name
   * @throws XmlUtilException on fatal eror
   */
  public void attribute(final QName attr, final String attrVal) {
    out(" ");

    emitQName(attr);

    out("=");
    quote(attrVal);

    emitNs();
  }

  /* ===================================== Tag end ========================== */

  /**
   * @param tag qname
   * @throws XmlUtilException on fatal eror
   */
  public void closeTag(final QName tag) {
    indent -= 2;
    if (indent < 0) {
      indent = 0;
    }
    blanks();
    closeTagSameLine(tag);
    newline();
  }

  /**
   * @param tag qname
   * @throws XmlUtilException on fatal eror
   */
  public void closeTagNoblanks(final QName tag) {
    indent -= 2;
    if (indent < 0) {
      indent = 0;
    }
    closeTagSameLine(tag);
    newline();
  }

  /**
   * @param tag qname
   * @throws XmlUtilException on fatal eror
   */
  public void closeTagSameLine(final QName tag) {
    lb();
    out("/");
    emitQName(tag);
    rb();
    scopeOut();
  }

  /** End an empty tag
   *
   * @throws XmlUtilException on fatal eror
   */
  public void endEmptyTag() {
    out(" /");
    rb();
  }

  /* ===================================== Tag start and end ================ */

  /**
   * @param tag qname
   * @throws XmlUtilException on fatal eror
   */
  public void emptyTag(final QName tag) {
    blanks();
    emptyTagSameLine(tag);
    newline();
  }

  /**
   * @param tag qname
  * @param attrName String attribute name
  * @param attrVal attribute name
   * @throws XmlUtilException on fatal eror
   */
  public void emptyTag(final QName tag,
                       final String attrName,
                       final String attrVal) {
    blanks();
    lb();
    emitQName(tag);
    attribute(attrName, attrVal);
    out("/");
    rb();
    newline();
  }

  /**
   * @param tag qname
   * @throws XmlUtilException on fatal eror
   */
  public void emptyTagSameLine(final QName tag) {
    lb();
    emitQName(tag);
    out("/");
    rb();
  }

  /** Create the sequence<br>
   *  <tag>val</tag>
   *
   * @param tag qname
   * @param val string val
   * @throws XmlUtilException on fatal eror
   */
  public void property(final QName tag, final String val) {
    blanks();
    openTagSameLine(tag);
    value(val);
    closeTagSameLine(tag);
    newline();
  }

  /** Create the sequence<br>
   *  <tag>val</tag>
   *
   * @param tag qname
   * @param val string val
   * @throws XmlUtilException on fatal eror
   */
  public void cdataProperty(final QName tag, final String val) {
    blanks();
    openTagSameLine(tag);
    cdataValue(val);
    closeTagSameLine(tag);
    newline();
  }

  /** Create the sequence<br>
   *  <tag>val</tag> where val is represented by a Reader
   *
   * @param tag qname
   * @param val Reader
   * @throws XmlUtilException on fatal eror
   */
  public void property(final QName tag, final Reader val) {
    blanks();
    openTagSameLine(tag);
    writeContent(val, wtr);
    closeTagSameLine(tag);
    newline();
  }

  /** Create the sequence<br>
   *  <tag><tagVal></tag>
   *
   * @param tag qname
   * @param tagVal qname
   */
  public void propertyTagVal(final QName tag,
                             final QName tagVal) {
    blanks();
    openTagSameLine(tag);
    emptyTagSameLine(tagVal);
    closeTagSameLine(tag);
    newline();
  }

  /* ===================================== Values =========================== */

  /** Create the sequence<br>
   *  <tag>val</tag>
   *
   * @param val to write
   * @throws XmlUtilException on fatal eror
   */
  public void cdataValue(final String val) {
    if (val == null) {
      return;
    }

    int start = 0;

    while (start < val.length()) {
      final int end = val.indexOf("]]", start);
      final boolean lastSeg = end < 0;
      final String seg;

      if (lastSeg) {
        seg = val.substring(start);
      } else {
        seg = val.substring(start, end);
      }

      out("<![CDATA[");
      out(seg);
      out("]]>");

      if (lastSeg) {
        break;
      }

      out("]]");
      start = end + 2;
    }
  }

  /** Write out a value
   *
   * @param val to write
   * @throws XmlUtilException on fatal eror
   */
  public void value(final String val) {
    value(val, null);
  }

  /** Write out a value
   *
   * @param val to write
   * @param quoteChar for quoting
   * @throws XmlUtilException on fatal eror
   */
  private void value(final String val,
                     final String quoteChar) {
    if (val == null) {
      return;
    }

    String q = quoteChar;
    if (q == null) {
      q = "";
    }

    if ((val.indexOf('&') >= 0) ||
        (val.indexOf('<') >= 0)) {
      out("<![CDATA[");
      out(q);
      out(val);
      out(q);
      out("]]>");
    } else {
      out(q);
      out(val);
      out(q);
    }
  }

  /* ===================================== Misc ============================= */

  /** Return the underlying writer. Should only be used to emit values.
   *
   * @return - the writer
   */
  public Writer getWriter() {
    return wtr;
  }

  /**
   * @throws XmlUtilException on fatal eror
   */
  public void flush() {
    try {
      wtr.flush();
    } catch (final IOException ie) {
      throw new XmlUtilException(ie);
    }
  }

  /** Called before we start to emit any tags.
   *
   * @param val namespace
   * @param makeDefaultNs - true => make this the default
   * @throws XmlUtilException on fatal eror
   */
  public void addNs(final NameSpace val,
                    final boolean makeDefaultNs) {
    nameSpaces.addNs(val, makeDefaultNs);
  }

  /**
   * @param ns name
   * @return NameSpace if present
   */
  public NameSpace getNameSpace(final String ns) {
    return nameSpaces.getNameSpace(ns);
  }

  /**
   * @param ns name
   * @return namespace abrev
   */
  public String getNsAbbrev(final String ns) {
    return nameSpaces.getNsAbbrev(ns);
  }

  /** Write a new line
   *
   * @throws XmlUtilException on fatal eror
   */
  public void newline() {
    out("\n");
  }

  /* ====================================================================
   *                         Private methods
   * ==================================================================== */

  private void quote(final String val) {
    if (!val.contains("\"")) {
      value(val, "\"");
    } else {
      value(val, "'");
    }
  }

  /* Write out the tag name, adding the ns abbreviation.
   * Also add the namespace declarations if this is the first tag
   *
   * @param tag
   * @throws IOException
   */
  private void emitQName(final QName tag) {
    nameSpaces.emitNsAbbr(tag.getNamespaceURI(), wtr);

    out(tag.getLocalPart());

    emitNs();
  }

  private void emitNs() {
    if (forHtml) {
      return;
    }
    
    nameSpaces.emitNs(wtr);
  }

  private void blanks() {
    if (indent >= blankLen) {
      out(blank);
    } else {
      out(blank.substring(0, indent));
    }
  }

  private void lb() {
    out("<");
  }

  private void rb() {
    out(">");
  }

  /* size of buffer used for copying content to response.
   */
  private static final int bufferSize = 4096;

  private void writeContent(final Reader in, final Writer out) {
    try {
      try (in; out) {
        final char[] buff = new char[bufferSize];
        int len;

        while (true) {
          len = in.read(buff);

          if (len < 0) {
            break;
          }

          out.write(buff, 0, len);
        }
      }
    } catch (final IOException ie) {
      throw new XmlUtilException(ie);
    }
  }

  private void scopeIn() {
    nameSpaces.startScope();
  }

  private void scopeOut() {
    nameSpaces.endScope();
  }

  private void out(final String val) {
    if ((notifier != null) && notifier.isEnabled()){
      notifier.doNotification();
    }

    try {
      if (!started) {
        started = true;

        if (!noHeaders) {
          writeHeader(dtd);
          wtr.write("\n");
        }
      }

      wtr.write(val);
    } catch (final IOException ie) {
      throw new XmlUtilException(ie);
    }
  }

  /* Write out the xml header
   */
  private void writeHeader(final String dtd) {
    try {
      if (forHtml) {
        wtr.write(
                "<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\">");
        return;
      }

      wtr.write("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\n");

      if (dtd == null) {
        return;
      }

      wtr.write("<!DOCTYPE properties SYSTEM \"");
      wtr.write(dtd);
      wtr.write("\">\n");
    } catch (final IOException ie) {
      throw new XmlUtilException(ie);
    }
  }
}
