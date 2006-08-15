/* **********************************************************************
    Copyright 2006 Rensselaer Polytechnic Institute. All worldwide rights reserved.

    Redistribution and use of this distribution in source and binary forms,
    with or without modification, are permitted provided that:
       The above copyright notice and this permission notice appear in all
        copies and supporting documentation;

        The name, identifiers, and trademarks of Rensselaer Polytechnic
        Institute are not used in advertising or publicity without the
        express prior written permission of Rensselaer Polytechnic Institute;

    DISCLAIMER: The software is distributed" AS IS" without any express or
    implied warranty, including but not limited to, any implied warranties
    of merchantability or fitness for a particular purpose or any warrant)'
    of non-infringement of any current or pending patent rights. The authors
    of the software make no representations about the suitability of this
    software for any particular purpose. The entire risk as to the quality
    and performance of the software is with the user. Should the software
    prove defective, the user assumes the cost of all necessary servicing,
    repair or correction. In particular, neither Rensselaer Polytechnic
    Institute, nor the authors of the software are liable for any indirect,
    special, consequential, or incidental damages related to the software,
    to the maximum extent the law permits.
*/

package edu.rpi.sss.util.xml;

import java.io.IOException;
import java.io.Reader;
import java.io.Writer;
import java.util.HashMap;
import java.util.Iterator;

/** Class to emit XML
 *
 * @author Mike Douglass  douglm@rpi.edu
 */
public class XmlEmit {
  private Writer wtr;
  private boolean mustEmitNS;

  private boolean noHeaders = false;

  /** We need to map the namespaces onto a set of reasonable abbreviations
   * for the generated xml. New set created each request
   */
  private HashMap nsMap;
  private String defaultNs;

  private int nsIndex;

  /** The following allow us to tidy up the output a little.
   */
  int indent;
  private String blank = "                                       " +
                                "                                       ";
  private int blankLen = blank.length();

  /** construct an object which will be used to collect namespace names
   * during the first phase and emit xml afetr startEmit is called.
   */
  public XmlEmit() {
    this(false);
  }

  /** construct an object which will be used to collect namespace names
   * during the first phase and emit xml afetr startEmit is called.
   *
   * @param noHeaders    boolean true to suppress headers
   */
  public XmlEmit(boolean noHeaders) {
    nsMap = new HashMap();
    nsIndex = 0;
    this.noHeaders = noHeaders;
  }

  /** Emit any headers and namespace declarations
   *
   * @param wtr
   * @throws IOException
   */
  public void startEmit(Writer wtr) throws IOException {
    this.wtr = wtr;

    if (!noHeaders) {
      mustEmitNS = true;

      writeHeader();
    }
    newline();
  }

  /**
   * @param tag
   * @throws IOException
   */
  public void openTag(QName tag) throws IOException {
    blanks();
    openTagSameLine(tag);
    newline();
    indent += 2;
  }

  /**
   * @param tag
   * @throws IOException
   */
  public void openTagNoNewline(QName tag) throws IOException {
    blanks();
    openTagSameLine(tag);
    indent += 2;
  }

  /**
   * @param tag
   * @throws IOException
   */
  public void openTagSameLine(QName tag) throws IOException {
    lb();
    tagname(tag);
    rb();
  }

  /**
   * @param tag
   * @throws IOException
   */
  public void closeTag(QName tag) throws IOException {
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
  public void closeTagNoblanks(QName tag) throws IOException {
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
  public void closeTagSameLine(QName tag) throws IOException {
    lb();
    wtr.write("/");
    tagname(tag);
    rb();
  }

  /**
   * @param tag
   * @throws IOException
   */
  public void emptyTag(QName tag) throws IOException {
    blanks();
    emptyTagSameLine(tag);
    newline();
  }

  /** Start tag ready for attributes
   *
   * @param tag
   * @throws IOException
   */
  public void startTag(QName tag) throws IOException {
    blanks();
    startTagSameLine(tag);
  }

  /** Add an attribute
   *
   * @param attrName
   * @param attrVal
   * @throws IOException
   */
  public void atribute(String attrName, String attrVal) throws IOException {
    wtr.write(" ");
    wtr.write(attrName);
    wtr.write("=");
    quote(attrVal);
  }

  /** End an empty tag
   *
   * @throws IOException
   */
  public void endEmptyTag() throws IOException {
    wtr.write(" /");
    rb();
  }

  /**
   * @param tag
   * @throws IOException
   */
  public void emptyTagSameLine(QName tag) throws IOException {
    lb();
    tagname(tag);
    wtr.write("/");
    rb();
  }

  /**
   * @param tag
   * @throws IOException
   */
  public void startTagSameLine(QName tag) throws IOException {
    lb();
    tagname(tag);
  }

  private void quote(String val) throws IOException {
    if (val.indexOf("\"") < 0) {
      wtr.write("\"");
      wtr.write(val);
      wtr.write("\"");
    } else {
      wtr.write("'");
      wtr.write(val);
      wtr.write("'");
    }
  }

  /** Create the sequence<br>
   *  <tag>val</tag>
   *
   * @param tag
   * @param val
   * @throws IOException
   */
  public void property(QName tag, String val) throws IOException {
    blanks();
    openTagSameLine(tag);
    if (val != null) {
      wtr.write(val);
    }
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
  public void property(QName tag, Reader val) throws IOException {
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
  public void propertyTagVal(QName tag, QName tagVal) throws IOException {
    blanks();
    openTagSameLine(tag);
    emptyTagSameLine(tagVal);
    closeTagSameLine(tag);
    newline();
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
   */
  public void addNs(String val) {
    if (nsMap.get(val) != null) {
      return;
    }

    String ns = "ns" + nsIndex;
    if (nsIndex == 0) {
      defaultNs = ns;
    }
    nsMap.put(val, ns);
    nsIndex++;
  }

  /**
   * @param ns
   * @return namespace abrev
   */
  public String getNsAbbrev(String ns) {
    return (String)nsMap.get(ns);
  }

  /** Write a new line
   *
   * @throws IOException
   */
  public void newline() throws IOException {
    wtr.write("\n");
  }

  /* Write out the tag name, adding the ns abbreviation.
   * Also add the namespace declarations if this is the first tag
   *
   * @param tag
   * @throws IOException
   */
  private void tagname(QName tag) throws IOException {
    String ns = tag.getNamespaceURI();

    if (ns != null) {
      String abbr = getNsAbbrev(ns);

      if ((abbr != null) && (!abbr.equals(defaultNs))) {
        wtr.write(abbr);
        wtr.write(":");
      }
    }

    wtr.write(tag.getLocalPart());

    if (!noHeaders && mustEmitNS) {
      /* First tag so emit the name space declarations.
       */
      Iterator nss = nsMap.keySet().iterator();

      while (nss.hasNext()) {
        wtr.write(" xmlns");

        ns = (String)nss.next();
        String abbr = getNsAbbrev(ns);

        if ((abbr != null) && (!abbr.equals(defaultNs))) {
          wtr.write(":");
          wtr.write(abbr);
        }

        wtr.write("=\"");
        wtr.write(ns);
        wtr.write("\"");
      }

      mustEmitNS = false;
    }
  }

  /* Write out the xml header
   */
  private void writeHeader() throws IOException {
    wtr.write("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\n");
  }

  private void blanks() throws IOException {
    if (indent >= blankLen) {
      wtr.write(blank);
    } else {
      wtr.write(blank.substring(0, indent));
    }
  }

  private void lb() throws IOException {
    wtr.write("<");
  }

  private void rb() throws IOException {
    wtr.write(">");
  }

  /* size of buffer used for copying content to response.
   */
  private static final int bufferSize = 4096;

  private void writeContent(Reader in, Writer out) throws IOException {
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
}
