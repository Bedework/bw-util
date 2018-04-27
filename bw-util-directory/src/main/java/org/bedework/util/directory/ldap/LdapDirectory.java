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
package org.bedework.util.directory.ldap;

import org.bedework.util.directory.common.BasicDirRecord;
import org.bedework.util.directory.common.DirRecord;
import org.bedework.util.directory.common.Directory;

import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Properties;

import javax.naming.Context;
import javax.naming.NameAlreadyBoundException;
import javax.naming.NameNotFoundException;
import javax.naming.NamingEnumeration;
import javax.naming.NamingException;
import javax.naming.directory.BasicAttribute;
import javax.naming.directory.BasicAttributes;
import javax.naming.directory.DirContext;
import javax.naming.directory.InitialDirContext;
import javax.naming.directory.ModificationItem;
import javax.naming.directory.SearchControls;
import javax.naming.directory.SearchResult;

/** **********************************************************************
 Provide access to ldap directory services.
 If the object is provided with a Properties object it will be queried for
 a number of properties. If they are absent or no Properties object is
 provided they will default to some value. Properties are defined in
 javax.naming.Context and are:

 java.naming.factory.initial
 java.naming.provider.url   Service provider, e.g. ldap://ldap.myhost.edu:389
 java.naming.security.authentication    e.g. "simple"
 java.naming.security.principal         e.g. cn=dirManager
 java.naming.security.credentials       Usually the password
 *************************************************************************/

public class LdapDirectory extends Directory {
  /** The default values
   */
  private static final String defaultCTX = "com.sun.jndi.ldap.LdapCtxFactory";
  private static final String defaultLdapURL = "ldap://localhost";
  private static final String defaultURL = defaultLdapURL;

  private String mngrDN;
  private String pw;

  private DirContext ctx;

  private SearchControls constraints;

  /* From last search */
  private NamingEnumeration recs;
  private String base;

  private Properties pr;

  /** Constructor required so we can instantiate object dynamically
   */
  public LdapDirectory() throws Exception {
  }

  /**
   * @param pr
   * @param mngrDN
   * @param pw
   * @throws NamingException
   */
  public LdapDirectory(final Properties pr, final String mngrDN,
                       final String pw) throws NamingException {
    init(pr, mngrDN, pw);
  }

  public void init(final Properties pr,
                   final String mngrDN,
                   final String pw) throws NamingException {
    if (pr == null) {
      throw new NamingException("No properties supplied");
    }

    this.pr = pr;
    this.mngrDN = mngrDN;
    this.pw = pw;
    reInit();
  }

  @Override
  public void reInit() throws NamingException {
    try {
      /** If we weren't given a url try to get one.
       */

      if (pr == null) {
        throw new Exception("No properties supplied (again)");
      }
      checkProp(pr, Context.PROVIDER_URL, defaultURL);
      checkProp(pr, Context.INITIAL_CONTEXT_FACTORY, defaultCTX);

      if ((mngrDN != null) && (pw != null)) {
        checkProp(pr, Context.SECURITY_AUTHENTICATION, "simple");
        pr.put(Context.SECURITY_PRINCIPAL, mngrDN);
        pr.put(Context.SECURITY_CREDENTIALS, pw);
      }

      // Make simple authentication the default
      checkProp(pr, Context.SECURITY_AUTHENTICATION, "simple");

      if (debug) {
        debug("Directory: get new context for " +
            pr.get(Context.PROVIDER_URL));
      }
      ctx = new InitialDirContext(pr);
      constraints = new SearchControls();
      if (debug) {
        debug("Directory: init OK " + pr.get(Context.PROVIDER_URL));
      }
    } catch (Throwable t) {
      throw new NamingException(t.getMessage());
    }
  }

  @Override
  public void destroy(final String dn) throws NamingException {
    try {
      ctx.destroySubcontext(dn);
    } catch (final Throwable t) {
      throw new NamingException(t.getMessage());
    }
  }

  @Override
  public boolean search(final String base, String filter,
                        final int scope) throws NamingException {
    if (debug) {
      debug("About to search: base=" + base + " filter=" + filter +
               " scope=" + scope);
    }

    this.base = base;

    constraints.setSearchScope(scope);
    constraints.setCountLimit(1000);

    try {
      if (filter == null) {
        filter = "(objectClass=*)";
      }

      recs = ctx.search(base, filter, constraints);

      if ((recs == null) || !recs.hasMore()) {
        recs = null;
      }
    } catch (final NameNotFoundException e) {
      // Allow that one.
      if (debug) {
        debug("NameNotFoundException: return with null");
      }
      recs = null;
    } catch (final Throwable t) {
      throw new NamingException(t.getMessage());
    }

    return recs != null;
  }

  @Override
  public DirRecord nextRecord() throws NamingException {
    try {
      SearchResult s = null;

      if (recs == null) {
        throw new NamingException("null search result");
      }

      if (!recs.hasMore()) {
        recs = null;
        return null;
      }

      try {
        s = (SearchResult)recs.next();
      } finally {
        if (s == null) {
          try {
            recs.close();
          } catch (Exception e) {};

          recs = null;
        }
      }

      if (s == null) {
        return null;
      }

      final DirRecord rec = new BasicDirRecord(s.getAttributes());

      rec.setName(s.getName());

      return rec;
    } catch (final Throwable t) {
      throw new NamingException(t.getMessage());
    }
  }

  @Override
  public boolean create(final DirRecord rec) throws NamingException {
    try {
      ctx.createSubcontext(rec.getDn(), rec.getAttributes());
      return true;
    } catch (final NameAlreadyBoundException nabe) {
      return false;
    } catch (final Throwable t) {
      throw new NamingException(t.getMessage());
    }
  }

  @Override
  public void replace(final String dn,
                      final String attrName,
                      final Object val) throws NamingException {
    final BasicAttributes attrs = new BasicAttributes(attrName, val);
    ctx.modifyAttributes(dn, DirContext.REPLACE_ATTRIBUTE, attrs);
  }

  @Override
  public void replace(final String dn,
                      final String attrName,
                      final Object[] val) throws NamingException {
    final BasicAttributes attrs = new BasicAttributes();
    final BasicAttribute attr = new BasicAttribute(attrName);

    for (final Object o: val) {
      attr.add(o);
    }
    ctx.modifyAttributes(dn, DirContext.REPLACE_ATTRIBUTE, attrs);
  }

  @Override
  public void replace(final String dn,
                      final String attrName,
                      final Object oldval,
                      final Object newval) throws NamingException {
    throw new NamingException("ldap replace(old, new) not implemented");
  }

  @Override
  public void modify(final String dn, final ModificationItem[] mods) throws NamingException {
    ctx.modifyAttributes(dn, mods);
  }

  public Properties getEnvironment() throws NamingException {
    final Properties pr = new Properties();

    final Hashtable<?, ?> tbl = ctx.getEnvironment();
    final Enumeration e = tbl.keys();
    while (e.hasMoreElements()) {
      final String name = (String)e.nextElement();
      final String val = (String)tbl.get(name);

      pr.put(name, val);
    }
    return pr;
  }

  @Override
  public void close() {
    if (ctx != null) {
      try {
        ctx.close();
      } catch (final Exception ignored) {};

      ctx = null;
    }
  }

  /** If the named property is present and has a value use that.
   *  Otherwise, set the value to the given default and use that.
   *
   * @param pr
   * @param name
   * @param defaultVal
   * @return String
   */
  public String checkProp(final Properties pr, final String name, final String defaultVal) {
    String val = pr.getProperty(name);

    if (val == null) {
      pr.put(name, defaultVal);
      val = defaultVal;
    }

    return val;
  }
}
