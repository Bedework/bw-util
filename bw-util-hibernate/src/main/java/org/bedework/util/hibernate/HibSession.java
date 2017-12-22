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
package org.bedework.util.hibernate;

import org.hibernate.Criteria;
import org.hibernate.FlushMode;
import org.hibernate.Session;
import org.hibernate.SessionFactory;

import java.io.Serializable;
import java.util.Collection;
import java.util.Date;
import java.util.List;

/** Interface to do hibernate interactions.
 *
 * @author Mike Douglass douglm at rpi.edu
 */
public interface HibSession extends Serializable {
  /** Set up for a hibernate interaction. Throw the object away on exception.
   *
   * @param sessFactory
   * @throws HibException
   */
  public void init(SessionFactory sessFactory) throws HibException;

  /**
   * @return Session
   * @throws HibException
   */
  public Session getSession() throws HibException;

  /**
   * @return boolean true if open
   * @throws HibException
   */
  public boolean isOpen() throws HibException;

  /** Clear a session
   *
   * @throws HibException
   */
  public void clear() throws HibException;

  /** Disconnect a session
   *
   * @throws HibException
   */
  public void disconnect() throws HibException;

  /** set the flushmode
   *
   * @param val
   * @throws HibException
   */
  public void setFlushMode(FlushMode val) throws HibException;

  /** Begin a transaction
   *
   * @throws HibException
   */
  public void beginTransaction() throws HibException;

  /** Return true if we have a transaction started
   *
   * @return boolean
   */
  public boolean transactionStarted();

  /** Commit a transaction
   *
   * @throws HibException
   */
  public void commit() throws HibException;

  /** Rollback a transaction
   *
   * @throws HibException
   */
  public void rollback() throws HibException;

  /** Did we rollback the transaction?
   *
   * @return boolean
   * @throws HibException
   */
  public boolean rolledback() throws HibException;

  /** Create a Criteria ready for the additon of Criterion.
   *
   * @param cl           Class for criteria
   * @return Criteria    created Criteria
   * @throws HibException
   */
  public Criteria createCriteria(Class<?> cl) throws HibException;

  /** Evict an object from the session.
   *
   * @param val          Object to evict
   * @throws HibException
   */
  public void evict(Object val) throws HibException;

  /** Create a query ready for parameter replacement or execution.
   *
   * @param s             String hibernate query
   * @throws HibException
   */
  public void createQuery(String s) throws HibException;

  /** Create a query ready for parameter replacement or execution and flag it
   * for no flush. This assumes that any queued changes will not affect the
   * result of the query.
   *
   * @param s             String hibernate query
   * @throws HibException
   */
  public void createNoFlushQuery(String s) throws HibException;

  /**
   * @return query string
   * @throws HibException
   */
  public String getQueryString() throws HibException;

  /** Create a sql query ready for parameter replacement or execution.
   *
   * @param s             String hibernate query
   * @param returnAlias
   * @param returnClass
   * @throws HibException
   */
  public void createSQLQuery(String s, String returnAlias, Class<?> returnClass)
        throws HibException;

  /** Create a named query ready for parameter replacement or execution.
   *
   * @param name         String named query name
   * @throws HibException
   */
  public void namedQuery(String name) throws HibException;

  /** Mark the query as cacheable
   *
   * @throws HibException
   */
  public void cacheableQuery() throws HibException;

  /** Set the named parameter with the given value
   *
   * @param parName     String parameter name
   * @param parVal      String parameter value
   * @throws HibException
   */
  public void setString(String parName, String parVal) throws HibException;

  /** Set the named parameter with the given value
   *
   * @param parName     String parameter name
   * @param parVal      Date parameter value
   * @throws HibException
   */
  public void setDate(String parName, Date parVal) throws HibException;

  /** Set the named parameter with the given value
   *
   * @param parName     String parameter name
   * @param parVal      boolean parameter value
   * @throws HibException
   */
  public void setBool(String parName, boolean parVal) throws HibException;

  /** Set the named parameter with the given value
   *
   * @param parName     String parameter name
   * @param parVal      int parameter value
   * @throws HibException
   */
  public void setInt(String parName, int parVal) throws HibException;

  /** Set the named parameter with the given value
   *
   * @param parName     String parameter name
   * @param parVal      long parameter value
   * @throws HibException
   */
  public void setLong(String parName, long parVal) throws HibException;

  /** Set the named parameter with the given value
   *
   * @param parName     String parameter name
   * @param parVal      Object parameter value
   * @throws HibException
   */
  public void setEntity(String parName, Object parVal) throws HibException;

  /** Set the named parameter with the given value
   *
   * @param parName     String parameter name
   * @param parVal      Object parameter value
   * @throws HibException
   */
  public void setParameter(String parName, Object parVal) throws HibException ;

  /** Set the named parameter with the given Collection
   *
   * @param parName     String parameter name
   * @param parVal      Collection parameter value
   * @throws HibException
   */
  public void setParameterList(String parName,
                               Collection<?> parVal) throws HibException ;

  /** Set the first result for a paged batch
   *
   * @param val      int first index
   * @throws HibException
   */
  public void setFirstResult(int val) throws HibException;

  /** Set the max number of results for a paged batch
   *
   * @param val      int max number
   * @throws HibException
   */
  public void setMaxResults(int val) throws HibException;

  /** Return the single object resulting from the query.
   *
   * @return Object          retrieved object or null
   * @throws HibException
   */
  public Object getUnique() throws HibException;

  /** Return a list resulting from the query.
   *
   * @return List          list from query
   * @throws HibException
   */
  public List getList() throws HibException;

  /**
   * @return int number updated
   * @throws HibException
   */
  public int executeUpdate() throws HibException;

  /** Update an object which may have been loaded in a previous hibernate
   * session
   *
   * @param obj
   * @throws HibException
   */
  public void update(Object obj) throws HibException;

  /** Merge and update an object which may have been loaded in a previous hibernate
   * session
   *
   * @param obj
   * @return Object   the persiatent object
   * @throws HibException
   */
  public Object merge(Object obj) throws HibException;

  /** Save a new object or update an object which may have been loaded in a
   * previous hibernate session
   *
   * @param obj
   * @throws HibException
   */
  public void saveOrUpdate(Object obj) throws HibException;

  /** Copy the state of the given object onto the persistent object with the
   * same identifier. If there is no persistent instance currently associated
   * with the session, it will be loaded. Return the persistent instance.
   * If the given instance is unsaved or does not exist in the database,
   * save it and return it as a newly persistent instance. Otherwise, the
   * given instance does not become associated with the session.
   *
   * @param obj
   * @return Object
   * @throws HibException
   */
  public Object saveOrUpdateCopy(Object obj) throws HibException;

  /** Return an object of the given class with the given id if it is
   * already associated with this session. This must be called for specific
   * key queries or we can get a NonUniqueObjectException later.
   *
   * @param  cl    Class of the instance
   * @param  id    A serializable key
   * @return Object
   * @throws HibException
   */
  public Object get(Class cl, Serializable id) throws HibException;

  /** Return an object of the given class with the given id if it is
   * already associated with this session. This must be called for specific
   * key queries or we can get a NonUniqueObjectException later.
   *
   * @param  cl    Class of the instance
   * @param  id    int key
   * @return Object
   * @throws HibException
   */
  public Object get(Class cl, int id) throws HibException;

  /** Save a new object.
   *
   * @param obj
   * @throws HibException
   */
  public void save(Object obj) throws HibException;

  /** Delete an object
   *
   * @param obj
   * @throws HibException
   */
  public void delete(Object obj) throws HibException;

  /** Save a new object with the given id. This should only be used for
   * restoring the db from a save.
   *
   * @param obj
   * @throws HibException
   */
  public void restore(Object obj) throws HibException;

  /**
   * @param val
   * @throws HibException
   */
  public void reAttach(UnversionedDbentity<?, ?> val) throws HibException;

  /**
   * @param o
   * @throws HibException
   */
  public void lockRead(Object o) throws HibException;

  /**
   * @param o
   * @throws HibException
   */
  public void lockUpdate(Object o) throws HibException;

  /**
   * @throws HibException
   */
  public void flush() throws HibException;

  /**
   * @throws HibException
   */
  public void close() throws HibException;
}
