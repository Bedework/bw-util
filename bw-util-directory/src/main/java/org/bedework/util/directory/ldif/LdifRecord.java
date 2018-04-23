package org.bedework.util.directory.ldif;

import org.bedework.util.directory.common.BasicDirRecord;

import org.apache.commons.codec.binary.Base64;

import java.io.BufferedReader;
import java.io.EOFException;
import java.io.Reader;
import java.io.Writer;
import java.util.Enumeration;
import java.util.Vector;

import javax.naming.NamingException;
import javax.naming.directory.BasicAttribute;
import javax.naming.directory.DirContext;
import javax.naming.directory.ModificationItem;

/** This class represents an entire ldif record.
    As yet, this is an incomplete implementation. Not all aspects of ldif, as
    defined in RFC2849 are implemented.
    No schema checking is carried out by this class and only version 1 is
    supported. While we may later allow enforcement of the rule that only
    changes or content be present on a stream, for the present we will allow a
    mixed stream.

    <p>ldif-content records are largely implemented.
        The result of calling read with a valid ldif-content input stream is
        that the record will be populated with a dn and attributes with values
        and the stream will be left positioned at the start of the next record.
        The resulting record can be written as a directory record.
    <p>ldif-changes records are partially (and possibly incorrectly) implemented.
        deletions are complete. A delete record consists of a dn only.
        adds are complete. An add record is the same as a content record.
        modify is incomplete.

    <p>Attribute options are not yet implemented nor recognized.
    base64 encoded dns may be improperly converted to strings. We may need to
    specify the locale. (May be true of any encoded value)
    URL values not implemented.

    <p>While reading input we can be in a number of states. An ldif record consists
    of:<ul>
       <li>dn</li>
       <li>controls</li>
       <li>changetype</li>
       <li>&lt;attributes-or-changes&gt;</li></ul>
    All except the dn are sort of optional. If we don't have a changetype in the
    appropriate place then, once we have started processing attributes, we may
    have an attribute named changetype.
 */
public class LdifRecord extends BasicDirRecord {
  /** This class allows us to keep track of our position in the ldif file.
      We attempt to leave ourselves positioned at the start of the next
      record (or the end of file.

      startpos    Will be set to indicate the position of the dn
      pos         On return from read methods this will be the number of
                  the last line read, presumably the null terminator.
      eof         True if we are at eof.
   */
  public static class Input {
    public Reader in;
    int pos = 0;  // Set to current line after reading.
    public boolean eof = false;

    private BufferedReader rdr = null;

    public Input() {}

    public Input(Reader in) {
      init(in);
    }

    public void init(Reader in) {
      this.in = in;
      this.eof = false;
      this.rdr = null;
      pos = 0;
      nextLine = null;
    }

    /** Read a line from the input stream. Stop at the first line terminator.
        This should handle DOS/UNIX data.

        @return String  null for eof or a null line so check the flag.
     */
    public String readLine() throws NamingException {
      String s = null;

      if (eof) return null;

      if (rdr == null) {
        rdr = new BufferedReader(in);
      }

      try {
        s = rdr.readLine();
        if (s == null) {
          // A buffered reader returns null for EOF
          eof = true;
          return null;
        }
        pos++;
      } catch (final EOFException e) {
        eof = true;
        s = null;
      } catch (final Throwable t) {
        throw new NamingException(t.getMessage());
      }

      return s;
    }

    /** readFullLine handles the concatenation of lines broken up into segments.
        In an ldif file, any line may be borken up, including comments, by
        starting a new line and prefixing the continuation with a single blank.
        We read ahead here and return a complete ldif entry.

        @return String null if eof
     */
    private String nextLine = null;
    public String readFullLine() throws Exception {
      if (nextLine == null) nextLine = readLine();

      String s = nextLine;
      if ((s != null) && (s.length() > 0) && (s.startsWith(" ")))
          throw new Exception("Invalid LDIF data");

      for (;;) {
        nextLine = readLine(); // We'll get null for eof

        if (eof) break;
        if ((nextLine.length() == 0) || (!nextLine.startsWith(" "))) break;

        s += nextLine.substring(1);
      }

      return s;
    }

    /** Read and discard ldif data until a terminator is seen.
     */
    public void skip() throws NamingException {
      while (!eof) {
        String s = readLine();
        if (s == null) return;
      }
    }

    public int getPos() {
      return pos;
    }
  }

  /** We may not do much processing so we first store the unprocessed ldif
      data in a vector. We make no attempt at this stage to deal with
      continuations.
   */
  private Vector ldifData;
  transient private boolean somedata = false; // true if we add any attributes during read.
  transient private int state = stateNeedDn;

  private final static int stateNeedDn = 1;
  private final static int stateHadDn = 2;
  private final static int stateHadChangeType = 3;
  private final static int stateDeleteRec = 4;
  private final static int stateNotModRec = 5;
  private final static int stateModrdn = 6;

  // We've seen changetype: modify
  private final static int stateModify = 7;

  // We're processing the changes to an attribute
  private final static int stateModSpec = 8;

  // We're looking for (add|delete|replace): <attr-name>
  private final static int stateNeedAttrChangeType = 9;

  // We're looking for <attr-name>: <val> records.
  private final static int stateAttrChanges = 10;

  private static String version = null;
  transient private boolean haveControls = false;

  public static final String[] changeTypes =
      {"Invalid", "add", "delete", "modify", "moddn", "modrdn"};

  /** For modify records we create an ordered array of changes to apply to the
      target. These are used to create a ModificationItems array.
   */
  private class Change {
    int changeType; // See DirContext.(ADD|REPLACE|REMOVE)_ATTRIBUTE
    String name;
    Vector vals;     // Vals to remove or add
  }

  private Vector changes;
  private Change curChange;
  private ModificationItem[] mods = null; // created when getMods is called

  /** Create an LdifRecord object ready for further processing.
   */
  public LdifRecord() {
    super();
  }

  public void clear() {
    super.clear();
    ldifData = new Vector();
    somedata = false; // true if we add any attributes during read.
    haveControls = false;
    state = stateNeedDn;
    version = null;
    changes = null;
    mods = null;
  }

  transient private Input in;
  transient private String crec;

  /** Read an entire ldif record from an input stream
   *
   *  @param   in Input object to read from input stream
   *  @return  boolean  true if we read some ldif data.
   *                    false if there was no data
   */
  public boolean read(Input in) throws NamingException {
    clear();

    this.in = in;
//    somedata = false;
    haveControls = false;
    crec = null;

    for (;;) {
      int alen = -1;

      try {
        crec = in.readFullLine();
      } catch (Exception e) {
        throwmsg(e.getMessage());
      }

      int inLen = 0;
      if (crec != null) {
        inLen = crec.length();
      }

      /*
       System.out.println("ldifrec len=" + inLen + " data=" + crec +
           " state=" + state); */

      if (crec != null) {
        ldifData.addElement(crec);

        alen = crec.indexOf(':');
      }

      // Null terminator means we're done
      if (inLen == 0) {
        // There are some state we should not be in here
        if (state == stateModSpec) { // Any others?
          invalid();
        }
        break;
      }

      if ((inLen > 0) && (crec.startsWith("#"))) {
        // Comment line. Ignore it.
      } else if (alen > 0) {
        /** We have something of the form
               <name> : <val> or
               <name> :: <encoded-val> or    for base-64 encoded data
               <name> :< <url>               for the url of an inclusion
         */
        String attr = null;
        StringBuffer val = null;
        boolean encoded = false;
        boolean url = false;
        int valStart;

        valStart = alen + 1;

        if (valStart == inLen) {
          throw new NamingException("Bad input value \"" + crec + "\"");
        } else if ((alen < inLen) && (crec.charAt(valStart) == ':')) {
          valStart++;
          encoded = true;
        } else if ((alen < inLen) && (crec.charAt(valStart) == '<')) {
          valStart++;
          url = true;
        }

        while ((valStart < inLen) && (crec.charAt(valStart) == ' ')) {
          valStart++;
        }

        attr = crec.substring(0, alen).toLowerCase();
        val = new StringBuffer(crec.substring(valStart));

        addAttrVal(attr, val.toString(), encoded, url);
      } else if ((state == stateModSpec) && (inLen == 1) && (crec.equals("-"))) {
        // We have a current change to add to the change vector.
        if (changes == null) {
          changes = new Vector();
        }
        changes.addElement(curChange);
        curChange = null;
        state = stateModify;
      } else if (inLen > 0) {
        invalid();
      }
    }

    return somedata;
  }

  public void setMods(ModificationItem[] val) {
    mods = val;
  }

  public ModificationItem[] getMods() throws NamingException {
    if (changes == null) {
      return super.getMods();
    }

    if (mods != null) {
      return mods;
    }

    mods = new ModificationItem[changes.size()];
    int modsi = 0;
    Enumeration e = changes.elements();

    while (e.hasMoreElements()) {
      Change c = (Change)e.nextElement();
      BasicAttribute attr = new BasicAttribute(c.name, true);
      if (c.vals != null) {
        Enumeration ve = c.vals.elements();
        while (ve.hasMoreElements()) {
          attr.add((String)ve.nextElement());
        }
      }

      mods[modsi] = new ModificationItem(c.changeType, attr);
      modsi++;
    }

    return mods;
  }

  /** Write the data we built this from
   *
   * @param wtr   Writer to write to
   * @return boolean false for no data
   */
  public boolean writeInputData(Writer wtr) throws Throwable {
    if ((ldifData == null) || (ldifData.size() == 0)) {
      return false;
    }

    synchronized (wtr) {
      for (int i = 0; i < ldifData.size(); i++) {
        String str = (String)ldifData.elementAt(i);

        wtr.write(str);
        wtr.write('\n');
      }

      // terminate with null
      wtr.write('\n');
      wtr.flush();
    }

    return true;
  }

  /** Write an ldif record representing this object
   *
   * @param wtr   Writer to write to
   */
  public void write(Writer wtr) throws Throwable {
    // First we need the dn

    wtr.write(getDn());
    wtr.write('\n');

    throw new Exception("Incomplete");
  }

  // -------------------------- private methods --------------------------

  private void throwmsg(String m) throws NamingException {
    String msg = m + " at line " + in.pos + " record=" + crec;
    in.skip();
    throw new NamingException(msg);
  }

  private void invalid() throws NamingException {
    throwmsg("Invalid LDIF data");
  }

  /** For all record types we expect an optional version spec first.
      After that comes the dn.
      After that, for content records we expect attrval-spec.
                  for change record we have optional controls followed
                   by changes.
     */
  private void addAttrVal(String attr, String val, boolean encoded,
       boolean url) throws NamingException {
//  System.out.println("addAttr " + attr + " = " + val);

    if (state == stateNeedDn) {
      // Only version or dn here
      if (attr.equals("version")) {
        if (version != null) throwmsg("Repeated version record");
        // Should probably parse this.
        if (!(val.equals("1")))
          throwmsg("Invalid LDIF version " + val.toString());

        version = val;
      } else if (attr.equals("dn")) {
        setDn(makeVal(val, encoded, url));

        state = stateHadDn;
      } else {
        invalid();
      }
    } else if (state == stateHadDn) {
      // We might see a control or changetype here
      if (attr.equals("control")) {
        /** control records occur as an optional part of change records.
            We should not have seen any changesrecords yet.
            Flag this as a change record.
         */

        setIsContent(false);
        throwmsg("controls unimplemented");
      } else if (attr.equals("changetype")) {
        setIsContent(false);
        doChangeType(val);
      } else {
        // We presume that we have an attribute value. If we had control records
        // then we expected a changetype.
        if (haveControls) throwmsg("Missing changetype");
        state = stateNotModRec;

        // Recurse to process the attribute
        addAttrVal(attr, val, encoded, url);
      }
    } else if (state == stateDeleteRec) {
      throwmsg("Should have no values for delete");
    } else if (state == stateNotModRec) {
      /** add or content. Just some attribute and its value.
          Add the attribute name and val to the table.
       */

      addAttr(attr, makeVal(val, encoded, url));
    } else if (state == stateModrdn) {
      /** We expect up to 3 attributes
         newrdn: <rdn-val>
         deleteoldrdn: 0|1
         newsuperior: <dn-val>      ; optional
       */
      throwmsg("changetype: mod(r)dn unimplemented");
    } else if (state == stateModify) {
      // We expect ("add"|"delete"|"replace"): <attr-desc>
      if (encoded || url) {
        throwmsg("Invalid LDIF mod-spec");
      }

      curChange = new Change();
      if (attr.equals("add")) {
        curChange.changeType = DirContext.ADD_ATTRIBUTE;
      } else if (attr.equals("replace")) {
        curChange.changeType = DirContext.REPLACE_ATTRIBUTE;
      } else if (attr.equals("delete")) {
        curChange.changeType = DirContext.REMOVE_ATTRIBUTE;
      } else {
        throwmsg("Invalid LDIF mod-spec changetype");
      }

      curChange.name = val; // ???????? options
      state = stateModSpec;
    } else if (state == stateModSpec) {
      // Attribute + value to add to current change
      if ((curChange == null) || (curChange.name == null)) {
        throwmsg("LDIF software error: No current change");
      }

      if (!curChange.name.equalsIgnoreCase(attr)) {
        throwmsg("Invalid LDIF mod-spec: attribute name mismatch");
      }

      // Add the value to the change
      if (curChange.vals == null) {
        curChange.vals = new Vector();
      }
      curChange.vals.addElement(makeVal(val, encoded, url));
    } else {
      throwmsg("LDIF software error: invalid state " + state);
    }
    somedata = true;
  }

  private String makeVal(String val,
                         boolean encoded,
                         boolean url) throws NamingException {
    /** ?????????????????????????????????????????
        Do we need to set locale?????
     */
    if (encoded) {
      return new String(new Base64().decode(val));
    }

    if (url) {
      throwmsg("url value unimplemented");
    }

    return val;
  }

  private void doChangeType(String val) throws NamingException {
    if (val.equalsIgnoreCase("add")) {
      setChangeType(changeTypeAdd);
      state = stateNotModRec;
    } else if (val.equalsIgnoreCase("delete")) {
      setChangeType(changeTypeDelete);
      state = stateDeleteRec;
    } else if (val.equalsIgnoreCase("modrdn")) {
      setChangeType(changeTypeModdn);
      state = stateModrdn;
    } else if (val.equalsIgnoreCase("moddn")) {
      setChangeType(changeTypeModdn);
      state = stateModrdn;
    } else if (val.equalsIgnoreCase("modify")) {
      setChangeType(changeTypeModify);
      state = stateModify;
    } else {
      throwmsg("invalid changetype " + val);
    }
  }
}
