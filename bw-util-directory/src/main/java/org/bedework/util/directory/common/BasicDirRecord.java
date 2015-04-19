package org.bedework.util.directory.common;

import javax.naming.directory.Attributes;
import javax.naming.directory.BasicAttributes;
import javax.naming.NamingException;

/** This class represents a directory record which may be built from a
    number of attributes represented as a BasicAttributes object.
 */
public class BasicDirRecord extends DirRecord {
  private Attributes attrs;

  /** Create a record which can have values added.
   */
  public BasicDirRecord() {
  }

  public BasicDirRecord(Attributes attrs) {
    this.attrs = attrs;
  }

  public Attributes getAttributes() throws NamingException {
    if (attrs == null) attrs = new BasicAttributes(true);

    return attrs;
  }

  public void clear() {
    super.clear();
    attrs = null;
  }
}
