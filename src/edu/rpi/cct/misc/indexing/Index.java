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
package edu.rpi.cct.misc.indexing;

import java.io.Serializable;

/** This interface describes how we build and search indexes for
 * applications such as Luwak, forum systems etc.
 */
public interface Index extends Serializable {
  /**
   * @param val
   */
  public void setDebug(boolean val);

  /** This might need to be called to open the index in the appropriate manner
   *  probably determined by information passed to the constructor.
   *
   * @throws IndexException
   */
  public void open() throws IndexException;

  /** This can be called to (re)create the index. It will destroy any
   * previously existing index.
   *
   * @throws IndexException
   */
  public void create() throws IndexException;

  /** See if we need to call open
   *
   * @return boolean
   */
  public boolean getIsOpen();

  /** This gives a single keyword to identify the implementation.
   *
   * @return  String    An identifying key.
   */
  public String id();

  /** This can be called to obtain some information about the index
   * implementation. id gives a single keyword whereas this gives a more
   * detailed description.
   *
   * @return  String    A descrptive string.
   */
  public String info();

  /** Called to (re)index a record
   *
   * @param   rec      The record to index
   * @throws IndexException
   */
  public void indexRec(Object rec) throws IndexException;

  /** Called to unindex a record
   *
   * @param   rec      The record to unindex
   * @throws IndexException
   */
  public void unindexRec(Object rec) throws IndexException;

  /** Called to (re)index a batch of records
   *
   * @param   recs     The records to index
   * @throws IndexException
   */
  public void indexRecs(Object[] recs) throws IndexException;

  /** Called to index a batch of new records. More efficient way of
   * rebuilding the index.
   *
   * @param   recs     The records to index
   * @throws IndexException
   */
  public void indexNewRecs(Object[] recs) throws IndexException;

  /** Called to unindex a batch of records
   *
   * @param   recs      The records to unindex
   * @throws IndexException
   */
  public void unindexRecs(Object[] recs) throws IndexException;

  /** Called to find entries that match the search string. This string may
   * be a simple sequence of keywords or some sort of query the syntax of
   * which is determined by the underlying implementation.
   *
   * @param   query    Query string
   * @return  int      Number found. 0 means none found,
   *                                -1 means indeterminate
   * @throws IndexException
   */
  public int search(String query) throws IndexException;

  /** The implementation will determine what information the Key object
   * actually contains. The getRecord method can be called to retrieve the
   * referenced entry.
   */
  public abstract class Key {
    /** Score this record */
    public float score;

    /**
     * @return  Object entity
     * @throws IndexException
     */
    public abstract Object getRecord() throws IndexException;
  }

  /** Called to retrieve record keys from the result.
   *
   * @param   n        Starting index
   * @param   keys     Array for the record keys
   * @return  int      Actual number of records
   * @throws IndexException
   */
  public int retrieve(int n, Key[] keys) throws IndexException;

  /** Called if we intend to run a batch of updates. endBatch MUST be
   * called or manual intervention may be required to remove locks.
   *
   * @throws IndexException
   */
  public void startBatch() throws IndexException;

  /** Called at the end of a batch of updates.
   *
   * @throws IndexException
   */
  public void endBatch() throws IndexException;

  /** Called to close at the end of a session.
   *
   * @throws IndexException
   */
  public void close() throws IndexException;

  /** Called to provide some debugging dump info. Must be open.
   */
  public void dump();

  /** Called to provide some statistics. Must be open.
   */
  public void stats();

}
