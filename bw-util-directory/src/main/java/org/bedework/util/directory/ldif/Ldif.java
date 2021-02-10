package org.bedework.util.directory.ldif;

import org.bedework.util.directory.common.DirRecord;
import org.bedework.util.directory.common.Directory;
import org.bedework.util.logging.BwLogger;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.Enumeration;

import javax.naming.NamingException;
import javax.naming.directory.Attribute;
import javax.naming.directory.Attributes;
import javax.naming.directory.DirContext;
import javax.naming.directory.ModificationItem;

/** This class provides methods to read ldif data from an input stream.
    The stream is considered to be broken up into lines, starting at line 1
    each of which contains an ldif item, start of attribute + value,
    continuation or record terminator (null line).

    Methods allow us to position in the stream, read an entire ldif record,
    or convert a record to a tabular form for processing.

    Various Directory methods probably have no meaning here, searches will
    typically fail with an exception or be ignored.
 */
public class Ldif extends Directory {
  /** LdifOut - out method is called to write ldif output
   */
  public static abstract class LdifOut {
    public abstract void out(String s) throws NamingException;
  }

  private InputStream in;

  private LdifRecord.Input inp;

  /** Constructor required so we can instantiate object dynamically
   */
  @SuppressWarnings("unused")
  public Ldif() throws Exception {
  }

  public Ldif(final String fileName) throws Exception {
    this(new FileInputStream(fileName));
  }

  public Ldif(final File f) throws Exception {
    this(new FileInputStream(f));
  }

  public Ldif(final InputStream in) throws Exception {
    super(null, null);
    this.in = in;
  }

  public void reInit() {
    // Nothing to do here
  }

  public void destroy(final String dn) throws NamingException {
    throw new NamingException("Cannot delete an ldif stream record");
  }

  /** search
   * @param  dn       Used as the pathname
   * @param  filter   Ignored
   * @param  scope    Ignored
   */
  public boolean search(final String dn,
                        final String filter,
                        final int scope) throws NamingException {
    if (debug()) {
      debug("Ldif: About to open " + dn);
    }

    inp = null;
    try {
      this.in = new FileInputStream(dn);
    } catch (final Throwable t) {
      throw new NamingException(t.getMessage());
    }
    return true;
  }

  /** Return the next record in the input stream.
   */
  public DirRecord nextRecord() throws NamingException {
    if (inp == null) {
      if (in == null) {
        throw new NamingException("No ldif input stream");
      }

      inp = new LdifRecord.Input();
      inp.init(new InputStreamReader(in));
    } else if (inp.eof) {
      return null;
    }

    final LdifRecord ldr = new LdifRecord();

    if (!ldr.read(inp)) {
      return null;
    }

    return ldr;
  }

  public boolean create(final DirRecord rec) throws NamingException {
    throw new NamingException("ldif create not implemented");
  }

  public void replace(final String dn,
                      final String attrName,
                      final Object val) throws NamingException {
    throw new NamingException("ldif replace not implemented");
  }

  public void replace(final String dn,
                      final String attrName,
                      final Object[] val)
      throws NamingException {
    throw new NamingException("ldif replace not implemented");
  }

  public void replace(final String dn,
                      final String attrName,
                      final Object oldval,
                      final Object newval)
      throws NamingException {
    throw new NamingException("ldif replace not implemented");
  }

  public void modify(final String dn,
                     final ModificationItem[] mods) throws NamingException {
    throw new NamingException("ldif modify not implemented");
  }

  /** dumpLdif write the entire record as ldif.
   */
  public static void dumpLdif(final LdifOut lo,
                              final DirRecord rec) throws NamingException {
    if (rec == null) {
      throw new NamingException("dumpLdif: No record supplied");
    }

    final String dn = rec.getDn();
    if (dn == null) {
      throw new NamingException("Unable to get dn");
    }

    lo.out("dn: " + dn);

    final int ctype = rec.getChangeType();

    if (!rec.getIsContent()) {
      // Emit a changetype attribute
      lo.out("changeType: " + LdifRecord.changeTypes[ctype]);
    }

    if ((rec.getIsContent()) || (ctype == DirRecord.changeTypeAdd)) {
      final Attributes as = rec.getAttributes();

      if (as == null) throw new NamingException("No attributes");

      final Enumeration<?> e = as.getAll();

      while (e.hasMoreElements()) {
        dumpAttr(lo, (Attribute)e.nextElement());
      } // while
    } else if (ctype == DirRecord.changeTypeDelete) {
      lo.out("changetype: delete");
    } else {
      lo.out("changetype: modify");

      // Dump changes
      final ModificationItem[] mods = rec.getMods();

      if (mods == null) {
        lo.out("# Invalid record - no mods");
      } else {
        for (final ModificationItem m: mods) {
          final int op = m.getModificationOp();
          final Attribute a = m.getAttribute();
          final String aid = a.getID();

          if (op == DirContext.ADD_ATTRIBUTE) {
            lo.out("add: " + aid);
          } else if (op == DirContext.REPLACE_ATTRIBUTE) {
            lo.out("replace: " + aid);
          } else if (op == DirContext.REMOVE_ATTRIBUTE) {
            lo.out("delete: " + aid);
          } else {
            lo.out("# Invalid record - bad mod op " + op);
          }
          dumpAttr(lo, a);
        }
      }
      lo.out("-");
    }

    lo.out(""); // null terminator
  }

  public static void dumpAttr(final LdifOut lo,
                              final Attribute a) throws NamingException {
    final String aid = a.getID();

    final Enumeration<?> av = a.getAll();
    while (av != null && av.hasMoreElements()) {
      final Object o = av.nextElement();
      final StringBuilder sb = new StringBuilder(aid);

      sb.append(':');
      // More work here for non-string values.
      if (o instanceof char[]) {
        sb.append(": ");
        sb.append((char[])o);
      } else {
        sb.append(' ');
        sb.append(o);
      }

      // Dump in 80 byte segments

      int pos = 0;
      int seglen = 80;
      while (pos < sb.length()) {
        final int len = Math.min(seglen, sb.length() - pos);
        if (pos == 0) {
          lo.out(sb.substring(pos, pos + len));
        } else {
          lo.out(" " + sb.substring(pos, pos + len));
        }
        seglen = 79;
        pos += len;
      }
    } // while
  }

  public void close() {
    if (in != null) {
      try {
        in.close();
      } catch (final Throwable ignored) {}

      in = null;
      inp = null;
    }
  }

  /* ====================================================================
   *                   Logged methods
   * ==================================================================== */

  private final BwLogger logger = new BwLogger();

  @Override
  public BwLogger getLogger() {
    if ((logger.getLoggedClass() == null) && (logger.getLoggedName() == null)) {
      logger.setLoggedClass(getClass());
    }

    return logger;
  }
}
