package org.bedework.util.directory.common;

import org.bedework.util.misc.Logged;

import javax.naming.NamingException;
import javax.naming.directory.ModificationItem;
import javax.naming.directory.SearchControls;

/** **********************************************************************
 Provide access to directory services.
 If the object is provided with a Properties object it will be queried for
 a number of properties. If they are absent or no Properties object is
 provided they will default to some value. Properties are defined in
 javax.naming.Context and are:

 java.naming.factory.initial
 java.naming.provider.url   Service provider, e.g. ldap://ldap.example.com:389
 java.naming.security.authentication    e.g. "simple"
 java.naming.security.principal         e.g. cn=dirManager
 java.naming.security.credentials       Usually the password

 The intention is that this class should be able to represent various forms of
 directory, even a sequential input stream of records.
 *************************************************************************/

public abstract class Directory extends Logged {
  /** All other constructors just call init
   */
  public Directory() throws Exception {
    this(null, null);
  }

  public Directory(String mngrDN,
                   String pw) throws Exception {
  }

  /** If possible, reInit should allow reuse after a close
   */
  public abstract void reInit() throws Exception;

  public abstract void destroy(String dn) throws Exception;

  /** These define the values used for scope parameters
   */
  public static final int scopeBase = SearchControls.OBJECT_SCOPE;
  public static final int scopeOne  = SearchControls.ONELEVEL_SCOPE;
  public static final int scopeSub  = SearchControls.SUBTREE_SCOPE;

  /** Carry out a subtree search
   */
  public boolean search(String base, String filter) throws Exception {
    return search(base, filter, scopeSub);
  }

  /** Carry out a base level search. This should be the default if the scope
      is not specified.
   */
  public boolean searchBase(String base, String filter) throws Exception {
    return search(base, filter, scopeBase);
  }

  /** Carry out a one level search
   */
  public boolean searchOne(String base, String filter) throws Exception {
    return search(base, filter, scopeOne);
  }

  /** Carry out a search with specified scope.
      @return  false means no record(s) found.
               true  means it's safe to call nextRecord.
   */
  public abstract boolean search(String base, String filter, int scope)
      throws Exception;

  public abstract DirRecord nextRecord() throws Exception;

  /** newRecord - Return a record which can have attribute values added.
      create should be called to create the directory entry.
   */
  public DirRecord newRecord(String entryDn) throws NamingException {
    DirRecord rec = new BasicDirRecord();
    rec.setDn(entryDn);
    return rec;
  }

  public abstract void create(DirRecord rec) throws Exception;

  /** The replace methods modify a directory record in the directory.
   */

  /** Replace an entire attribute with one containing only the given value
   */
  public abstract void replace(String dn, String attrName, Object val) throws Exception;

  /** Replace an entire attribute with one containing only the given values
   */
  public abstract void replace(String dn, String attrName, Object[] val) throws Exception;

  /** Replace a single given attribute value with the given value
   */
  public abstract void replace(String dn, String attrName, Object oldval, Object newval) throws Exception;

  public abstract void modify(String dn, ModificationItem[] mods) throws Exception;

  public abstract void close();

}
