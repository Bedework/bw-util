package edu.rpi.cct.misc.indexing;

/** This class implements a dummy null indexer.
 */
public class IndexDummyImpl implements Index {
  private boolean isOpen;

  /**
   * @throws IndexException
   */
  public IndexDummyImpl() throws IndexException {
  }

  public void setDebug(boolean val) {
  }

  /** This must be called to open the index in the appropriate manner
   *  probably determined by information passed to the constructor.
   */
  public void open() throws IndexException {
    isOpen = true;
  }

  /** This can be called to (re)create the index. It will destroy any
   * previously existing index.
   */
  public void create() throws IndexException {
    isOpen = true;
  }

  /** See if we need to call open
   */
  public boolean getIsOpen() {
    return isOpen;
  }

  /** This gives a single keyword to identify the implementation.
   *
   * @return  String    An identifying key.
   */
  public String id() {
    return "dummy";
  }

  /** This can be called to obtain some information about the index
   * implementation. id gives a single keyword whereas this gives a more
   * detailed description.
   *
   * @return  String    A descrptive string.
   */
  public String info() {
    return "A dummy implementation of an indexer.";
  }

  /** Called to index a record
   *
   * @param   rec      The record to index
   */
  public void indexRec(Object rec) throws IndexException {
  }

  /** Called to unindex a record
   *
   * @param   rec      The record to unindex
   */
  public void unindexRec(Object rec) throws IndexException {
  }

  /** Called to (re)index a batch of records
   *
   * @param   recs     The records to index
   */
  public void indexRecs(Object[] recs) throws IndexException {
  }

  /** Called to index a batch of new records. More efficient way of
   * rebuilding the index.
   *
   * @param   recs     The records to index
   */
  public void indexNewRecs(Object[] recs) throws IndexException {
  }

  /** Called to unindex a batch of records
   *
   * @param   recs      The records to unindex
   */
  public void unindexRecs(Object[] recs) throws IndexException {
  }

  /** Called to find entries that match the search string. This string may
   * be a simple sequence of keywords or some sort of query the syntax of
   * which is determined by the underlying implementation.
   *
   * @param   query    Query string
   * @return  int      Number found. 0 means none found,
   *                                -1 means indeterminate
   */
  public int search(String query) throws IndexException {
    return 0;
  }

  /** Called to retrieve record keys from the result.
   *
   * @param   n        Starting index
   * @param   keys     Array for the record keys
   * @return  int      Actual number of records
   */
  public int retrieve(int n, Index.Key[] keys) throws IndexException {
    return 0;
  }

  /** Called if we intend to run a batch of updates. endBatch MUST be
   * called or manual intervention may be required to remove locks.
   */
  public void startBatch() throws IndexException {
  }

  /** Called at the end of a batch of updates.
   */
  public void endBatch() throws IndexException {
  }

  /** Called to close at the end of a session.
   */
  public void close() {
    isOpen = false;
  }

  /** Called to provide some debugging dump info.
   */
  public void dump() {
  }

  /** Called to provide some statistics.
   */
  public void stats() {
  }
}
