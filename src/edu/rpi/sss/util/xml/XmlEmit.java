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
package edu.rpi.sss.util.xml;

import java.io.IOException;
import java.io.Reader;
import java.io.Writer;

import javax.xml.namespace.QName;

/** Class to emit XML
 *
 * @author Mike Douglass  douglm@rpi.edu
 */
public class XmlEmit {
  private Writer wtr;

  private boolean noHeaders = false;

  private String dtd;

  private boolean started;

  private XmlEmitNamespaces nameSpaces = new XmlEmitNamespaces();

  private Notifier notifier;

  /** Called (frequently) if set. May be used to allow higher level to
   * carry out actions when some output happens, e.g. open surrounding elements.
   *
   * @author douglm
   */
  public static abstract class Notifier {
    /** Called on output if isEnabled returns false
     *
     * @throws Throwable
     */
    public abstract void doNotification() throws Throwable;

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
     * @param ns
     * @param abbrev
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
      NameSpace that = (NameSpace)o;
      return ns.equals(that.ns);
    }
  }

  /** The following allow us to tidy up the output a little.
   */
  int indent;
  private String blank = "                                       " +
                                "                                       ";
  private int blankLen = blank.length();

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

  /** Emit any headers and namespace declarations
   *
   * @param wtr
   * @throws IOException
   */
  public void startEmit(final Writer wtr) throws IOException {
    this.wtr = wtr;
  }

  /** Emit any headers, dtd and namespace declarations
   *
   * @param wtr
   * @param dtd
   * @throws IOException
   */
  public void startEmit(final Writer wtr, final String dtd) throws IOException {
    this.wtr = wtr;
    this.dtd = dtd;
  }

  /** At the moment fairly primitive - no stacking etc.
   * @param n
   */
  public void setNotifier(final Notifier n) {
    notifier = n;
  }

  /* ===================================== Tag start ======================== */

  /**
   * @param tag
   * @throws IOException
   */
  public void openTag(final QName tag) throws IOException {
    blanks();
    openTagSameLine(tag);
    newline();
    indent += 2;
  }

  /** open with attribute
   *
   * @param tag
   * @param attrName
   * @param attrVal
   * @throws IOException
   */
  public void openTag(final QName tag,
                      final String attrName,
                      final String attrVal) throws IOException {
    blanks();
    openTagSameLine(tag, attrName, attrVal);
    newline();
    indent += 2;
  }

  /**
   * @param tag
   * @throws IOException
   */
  public void openTagNoNewline(final QName tag) throws IOException {
    blanks();
    openTagSameLine(tag);
    indent += 2;
  }

  /**
   * @param tag
   * @param attrName
   * @param attrVal
   * @throws IOException
   */
  public void openTagNoNewline(final QName tag,
                               final String attrName,
                               final String attrVal) throws IOException {
    blanks();
    openTagSameLine(tag, attrName, attrVal);
    indent += 2;
  }

  /**
   * @param tag
   * @throws IOException
   */
  public void openTagSameLine(final QName tag) throws IOException {
    lb();
    emitQName(tag);
    endOpeningTag();
  }

  /** Emit an opening tag ready for nested values. No new line
   *
   * @param tag
   * @param attrName
   * @param attrVal
   * @throws IOException
   */
  public void openTagSameLine(final QName tag,
                              final String attrName,
                              final String attrVal) throws IOException {
    lb();
    emitQName(tag);
    attribute(attrName, attrVal);
    endOpeningTag();
  }

  /** Start tag ready for attributes
   *
   * @param tag
   * @throws IOException
   */
  public void startTag(final QName tag) throws IOException {
    blanks();
    startTagSameLine(tag);
  }

  /** Start tag ready for attributes - new line and indent
   *
   * @param tag
   * @throws IOException
   */
  public void startTagIndent(final QName tag) throws IOException {
    blanks();
    startTagSameLine(tag);
    indent += 2;
  }

  /** Start a tag ready for some attributes. No new line
   *
   * @param tag
   * @throws IOException
   */
  public void startTagSameLine(final QName tag) throws IOException {
    lb();
    emitQName(tag);
  }

  /** End a tag we are opening
   *
   * @throws IOException
   */
  public void endOpeningTag() throws IOException {
    scopeIn();
    rb();
  }

  /* ===================================== Attributes ======================= */

  /** Add an attribute
   *
   * @param attrName
   * @param attrVal
   * @throws IOException
   */
  public void attribute(final String attrName, final String attrVal) throws IOException {
    out(" ");
    out(attrName);
    out("=");
    quote(attrVal);
  }

  /** Add an attribute
   *
   * @param attr
   * @param attrVal
   * @throws IOException
   */
  public void attribute(final QName attr, final String attrVal) throws IOException {
    out(" ");

    emitQName(attr);

    out("=");
    quote(attrVal);

    emitNs();
  }

  /* ===================================== Tag end ========================== */

  /**
   * @param tag
   * @throws IOException
   */
  public void closeTag(final QName tag) throws IOException {
    indent -= 2;
    if (indent < 0) {
      indent = 0;
    }
    blanks();
    closeTagSameLine(tag);
    newline();
  }

  /**
   * @param tag
   * @throws IOException
   */
  public void closeTagNoblanks(final QName tag) throws IOException {
    indent -= 2;
    if (indent < 0) {
      indent = 0;
    }
    closeTagSameLine(tag);
    newline();
  }

  /**
   * @param tag
   * @throws IOException
   */
  public void closeTagSameLine(final QName tag) throws IOException {
    lb();
    out("/");
    emitQName(tag);
    rb();
    scopeOut();
  }

  /** End an empty tag
   *
   * @throws IOException
   */
  public void endEmptyTag() throws IOException {
    out(" /");
    rb();
  }

  /* ===================================== Tag start and end ================ */

  /**
   * @param tag
   * @throws IOException
   */
  public void emptyTag(final QName tag) throws IOException {
    blanks();
    emptyTagSameLine(tag);
    newline();
  }

  /**
   * @param tag
  * @param attrName
  * @param attrVal
   * @throws IOException
   */
  public void emptyTag(final QName tag,
                       final String attrName,
                       final String attrVal) throws IOException {
    blanks();
    lb();
    emitQName(tag);
    attribute(attrName, attrVal);
    out("/");
    rb();
    newline();
  }

  /**
   * @param tag
   * @throws IOException
   */
  public void emptyTagSameLine(final QName tag) throws IOException {
    lb();
    emitQName(tag);
    out("/");
    rb();
  }

  /** Create the sequence<br>
   *  <tag>val</tag>
   *
   * @param tag
   * @param val
   * @throws IOException
   */
  public void property(final QName tag, final String val) throws IOException {
    blanks();
    openTagSameLine(tag);
    value(val);
    closeTagSameLine(tag);
    newline();
  }

  /** Create the sequence<br>
   *  <tag>val</tag>
   *
   * @param tag
   * @param val
   * @throws IOException
   */
  public void cdataProperty(final QName tag, final String val) throws IOException {
    blanks();
    openTagSameLine(tag);
    cdataValue(val);
    closeTagSameLine(tag);
    newline();
  }

  /** Create the sequence<br>
   *  <tag>val</tag> where val is represented by a Reader
   *
   * @param tag
   * @param val
   * @throws IOException
   */
  public void property(final QName tag, final Reader val) throws IOException {
    blanks();
    openTagSameLine(tag);
    writeContent(val, wtr);
    closeTagSameLine(tag);
    newline();
  }

  /** Create the sequence<br>
   *  <tag><tagVal></tag>
   *
   * @param tag
   * @param tagVal
   * @throws IOException
   */
  public void propertyTagVal(final QName tag,
                             final QName tagVal) throws IOException {
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
   * @param val
   * @throws IOException
   */
  public void cdataValue(final String val) throws IOException {
    if (val == null) {
      return;
    }

    int start = 0;

    while (start < val.length()) {
      int end = val.indexOf("]]", start);
      boolean lastSeg = end < 0;
      String seg;

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
   * @param val
   * @throws IOException
   */
  public void value(final String val) throws IOException {
    value(val, null);
  }

  /** Write out a value
   *
   * @param val
   * @param quoteChar
   * @throws IOException
   */
  private void value(final String val,
                     final String quoteChar) throws IOException {
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
   * @throws IOException
   */
  public void flush() throws IOException {
    wtr.flush();
  }

  /** Called before we start to emit any tags.
   *
   * @param val
   * @param makeDefaultNs - true => make this the default
   * @throws IOException
   */
  public void addNs(final NameSpace val,
                    final boolean makeDefaultNs) throws IOException {
    nameSpaces.addNs(val, makeDefaultNs);
  }

  /**
   * @param ns
   * @return NameSpace if present
   */
  public NameSpace getNameSpace(final String ns) {
    return nameSpaces.getNameSpace(ns);
  }

  /**
   * @param ns
   * @return namespace abrev
   */
  public String getNsAbbrev(final String ns) {
    return nameSpaces.getNsAbbrev(ns);
  }

  /** Write a new line
   *
   * @throws IOException
   */
  public void newline() throws IOException {
    out("\n");
  }

  /* ====================================================================
   *                         Private methods
   * ==================================================================== */

  private void quote(final String val) throws IOException {
    if (val.indexOf("\"") < 0) {
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
  private void emitQName(final QName tag) throws IOException {
    nameSpaces.emitNsAbbr(tag.getNamespaceURI(), wtr);

    out(tag.getLocalPart());

    emitNs();
  }

  private void emitNs() throws IOException {
    nameSpaces.emitNs(wtr);
  }

  private void blanks() throws IOException {
    if (indent >= blankLen) {
      out(blank);
    } else {
      out(blank.substring(0, indent));
    }
  }

  private void lb() throws IOException {
    out("<");
  }

  private void rb() throws IOException {
    out(">");
  }

  /* size of buffer used for copying content to response.
   */
  private static final int bufferSize = 4096;

  private void writeContent(final Reader in, final Writer out) throws IOException {
    try {
      char[] buff = new char[bufferSize];
      int len;

      while (true) {
        len = in.read(buff);

        if (len < 0) {
          break;
        }

        out.write(buff, 0, len);
      }
    } finally {
      try {
        in.close();
      } catch (Throwable t) {}
      try {
        out.close();
      } catch (Throwable t) {}
    }
  }

  private void scopeIn() {
    nameSpaces.startScope();
  }

  private void scopeOut() {
    nameSpaces.endScope();
  }

  private void out(final String val) throws IOException {
    if ((notifier != null) && notifier.isEnabled()){
      try {
        notifier.doNotification();
      } catch (IOException ioe) {
        throw ioe;
      } catch (Throwable t) {
        throw new IOException(t);
      }
    }

    if (!started) {
      started = true;

      if (!noHeaders) {
        writeHeader(dtd);
        wtr.write("\n");
      }
    }

    wtr.write(val);
  }

  /* Write out the xml header
   */
  private void writeHeader(final String dtd) throws IOException {
    wtr.write("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\n");

    if (dtd == null) {
      return;
    }

    wtr.write("<!DOCTYPE properties SYSTEM \"");
    wtr.write(dtd);
    wtr.write("\">\n");
  }
}
