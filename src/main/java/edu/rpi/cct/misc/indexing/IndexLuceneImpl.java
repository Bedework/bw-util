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
package edu.rpi.cct.misc.indexing;

import org.apache.log4j.Logger;
import org.apache.lucene.analysis.Analyzer;
import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field;
import org.apache.lucene.document.Field.Store;
import org.apache.lucene.index.IndexReader;
import org.apache.lucene.index.IndexWriter;
import org.apache.lucene.index.Term;
import org.apache.lucene.queryParser.ParseException;
import org.apache.lucene.queryParser.QueryParser;
import org.apache.lucene.search.Filter;
import org.apache.lucene.search.FilteredQuery;
import org.apache.lucene.search.Hits;
import org.apache.lucene.search.IndexSearcher;
import org.apache.lucene.search.Query;
import org.apache.lucene.search.Searcher;
import org.apache.lucene.store.Directory;

import java.io.FileNotFoundException;
import java.io.IOException;

/** This class implements indexing using Lucene.
 * There is an abstract method to create a Lucene Document from an object.
 * Also an abstract method to create the Key object.
 */
public abstract class IndexLuceneImpl implements Index {
  private boolean debug;
  private boolean writeable;
  private String basePath;
  private String defaultFieldName;

  /** We append this to basePath to reach the indexes.
   */
  private final static String indexDir = "/indexes";

  private boolean updatedIndex;
  private boolean isOpen;

  private boolean cleanLocks;

  private transient Logger log;

  /** We try to keep readers and writers open if batchMode is true.
   */
  //private boolean batchMode;

  IndexReader rdr;
  IndexWriter wtr;
  Searcher sch;
  Analyzer defaultAnalyzer;

  QueryParser queryParser;

  Hits lastResult;

  private String[] stopWords;

  /** Simple representation of field options */
  public static class FieldInfo {
    /** lucene name for field. */
    String name;

    /** Do w store it? */
    boolean store;

    /** Do we tokenize it? */
    boolean tokenized;

    /** boost value for this field */
    float boost;

    /* Initialised in constructor from store. */
    Store howStore;

    /* Initialised in constructor from tokenized. */
    Field.Index howIndexed;

    /** Constructor for unstored, unboosted field
     *
     * @param name
     * @param tokenized
     */
    public FieldInfo(final String name, final boolean tokenized) {
      this(name, false, tokenized, 1);
    }

    /** Constructor for unstored field
     *
     * @param name
     * @param tokenized
     * @param boost
     */
    public FieldInfo(final String name, final boolean tokenized, final float boost) {
      this(name, false, tokenized, boost);
    }

    /** Constructor allowing full specification
     *
     * @param name
     * @param store
     * @param tokenized
     * @param boost
     */
    public FieldInfo(final String name, final boolean store,
                     final boolean tokenized, final float boost) {
      this.name = name;
      this.store = store;
      this.tokenized = tokenized;
      this.boost = boost;

      if (store) {
        howStore = Store.YES;
      } else {
        howStore = Store.NO;
      }

      if (tokenized) {
        howIndexed = Field.Index.TOKENIZED;
      } else {
        howIndexed = Field.Index.UN_TOKENIZED;
      }
    }

    Field makeField(final String val) {
      Field f = new Field(name, val, howStore, howIndexed);
      f.setBoost(boost);

      return f;
    }

    /**
     * @return String field name
     */
    public String getName() {
      return name;
    }
  }

  /** Create an indexer with the default set of stop words.
   *
   * @param basePath    String path to where we should read/write indexes
   * @param defaultFieldName  default name for searches
   * @param writeable   true if the caller can update the index
   * @throws IndexException
   */
  public IndexLuceneImpl(final String basePath,
                         final String defaultFieldName,
                         final boolean writeable) throws IndexException {
    this(basePath, defaultFieldName, writeable, null);
  }

  /** Create an indexer with the given set of stop words.
   *
   * @param basePath    String path to where we should read/write indexes
   * @param defaultFieldName  default name for searches
   * @param writeable   true if the caller can update the index
   * @param stopWords   set of stop words, null for default.
   * @throws IndexException
   */
  public IndexLuceneImpl(final String basePath,
                         final String defaultFieldName,
                         final boolean writeable,
                         final String[] stopWords) throws IndexException {
    setDebug(getLog().isDebugEnabled());
    this.writeable = writeable;
    this.basePath = basePath;
    this.defaultFieldName = defaultFieldName;
    this.stopWords = stopWords;
  }

  /**
   * @return boolean debugging flag
   */
  public boolean getDebug() {
    return debug;
  }

  /** Indicate if we should try to clean locks.
   *
   * @param val
   */
  public void setCleanLocks(final boolean val) {
    cleanLocks = val;
  }

  /** String appended to basePath
   * @return String
   */
  public static String getPathSuffix() {
    return indexDir;
  }

  /** Called to make or fill in a Key object.
   *
   * @param key   Possible Index.Key object for reuse
   * @param doc   The retrieved Document
   * @param score The rating for this entry
   * @return Index.Key  new or reused object
   * @throws IndexException
   */
  public abstract Index.Key makeKey(Index.Key key,
                                    Document doc,
                                    float score) throws IndexException;

  /** Called to make a key term for a record.
   *
   * @param   rec      The record
   * @return  Term     Lucene term which uniquely identifies the record
   * @throws IndexException
   */
  public abstract Term makeKeyTerm(Object rec) throws IndexException;

  /** Called to make the primary key name for a record.
   *
   * @param   rec      The record
   * @return  String   Name for the field/term
   * @throws IndexException
   */
  public abstract String makeKeyName(Object rec) throws IndexException;

  /** Called to fill in a Document from an object.
   *
   * @param doc   The =Document
   * @param rec   The record
   * @throws IndexException
   */
  public abstract void addFields(Document doc,
                                 Object rec) throws IndexException;

  /** Called to return an array of valid term names.
   *
   * @return  String[]   term names
   */
  public abstract String[] getTermNames();

  public void setDebug(final boolean val) {
    debug = val;
  }

  /** This can be called to open the index in the appropriate manner
   *  probably determined by information passed to the constructor.
   *
   * <p>For a first time call a new analyzer will be created.
   */
  public void open() throws IndexException {
    close();

    if (defaultAnalyzer == null) {
      if (stopWords == null) {
        defaultAnalyzer = new StandardAnalyzer();
      } else {
        defaultAnalyzer = new StandardAnalyzer(stopWords);
      }

      queryParser = new QueryParser(defaultFieldName,
                                    defaultAnalyzer);
    }

    updatedIndex = false;
    isOpen = true;
  }

  /** This can be called to (re)create the index. It will destroy any
   * previously existing index.
   */
  public void create() throws IndexException {
    try {
      if (!writeable) {
        throw new IndexException(IndexException.noIdxCreateAccess);
      }

      close();

      if (basePath == null) {
        throw new IndexException(IndexException.noBasePath);
      }

      IndexWriter iw = new IndexWriter(basePath + indexDir, defaultAnalyzer, true);
      iw.optimize();
      iw.close();
      iw = null;

      open();
    } catch (IOException e) {
      throw new IndexException(e);
    } catch (Throwable t) {
      throw new IndexException(t);
    }
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
    return "LUCENE";
  }

  /** This can be called to obtain some information about the index
   * implementation. id gives a single keyword whereas this gives a more
   * detailed description.
   *
   * @return  String    A descrptive string.
   */
  public String info() {
    return "An implementation of an indexer using jakarta Lucene.";
  }

  /** Called to index a record
   *
   * @param   rec      The record to index
   */
  public void indexRec(final Object rec) throws IndexException {
    unindexRec(rec);
    intIndexRec(rec);
    closeWtr();
  }

  /** Called to unindex a record
   *
   * @param   rec      The record to unindex
   */
  public void unindexRec(final Object rec) throws IndexException {
    try {
      checkOpen();
      closeWtr();
      intUnindexRec(rec);
    } catch (IndexException ie) {
      if (ie.getCause() instanceof FileNotFoundException) {
        // Assume not indexed yet
        throw new IndexException(IndexException.noFiles);
      } else {
        throw ie;
      }
    } finally {
      closeWtr(); // Just in case
      closeRdr();
    }
  }

  /** Called to (re)index a batch of records
   *
   * @param   recs     The records to index
   */
  public void indexRecs(final Object[] recs) throws IndexException {
    if (recs == null) {
      return;
    }

    try {
      unindexRecs(recs);

      for (int i = 0; i < recs.length; i++) {
        if (recs[i] != null) {
          intIndexRec(recs[i]);
        }
      }
    } finally {
      closeWtr();
      closeRdr(); // Just in case
    }
  }

  /** Called to index a batch of new records. More efficient way of
   * rebuilding the index.
   *
   * @param   recs     The records to index
   */
  public void indexNewRecs(final Object[] recs) throws IndexException {
    if (recs == null) {
      return;
    }

    try {
      closeRdr(); // Just in case

      for (int i = 0; i < recs.length; i++) {
        if (recs[i] != null) {
          intIndexRec(recs[i]);
        }
      }
    } finally {
      closeWtr();
    }
  }

  /** Called to unindex a batch of records
   *
   * @param   recs      The records to unindex
   */
  public void unindexRecs(final Object[] recs) throws IndexException {
    if (recs == null) {
      return;
    }

    try {
      checkOpen();
      closeWtr();

      for (int i = 0; i < recs.length; i++) {
        if (recs[i] != null) {
          intUnindexRec(recs[i]);
        }
      }
    } finally {
      closeWtr(); // Just in case
      closeRdr();
    }
  }

  /** Called to find entries that match the search string. This string may
   * be a simple sequence of keywords or some sort of query the syntax of
   * which is determined by the underlying implementation.
   *
   * @param   query    Query string
   * @return  int      Number found. 0 means none found,
   *                                -1 means indeterminate
   */
  public int search(final String query) throws IndexException {
    return search(query, null);
  }

  /** Called to find entries that match the search string. This string may
   * be a simple sequence of keywords or some sort of query the syntax of
   * which is determined by the underlying implementation.
   *
   * @param   query    Query string
   * @param   filter   Filter to apply or null
   * @return  int      Number found. 0 means none found,
   *                                -1 means indeterminate
   * @throws IndexException
   */
  public int search(final String query, final Filter filter) throws IndexException {

    checkOpen();

    try {
      if (debug) {
        trace("About to search for " + query);
      }

      Query parsed = queryParser.parse(query);

      if (filter != null) {
        parsed = new FilteredQuery(parsed, filter);
      }

      if (debug) {
        trace("     with parsed query " + parsed.toString(null));
      }

      if (sch == null) {
        IndexReader rdr = getRdr();

        if (rdr != null) {
          sch = new IndexSearcher(rdr);
        }
      }

      if (sch == null) {
        lastResult = null;
        return 0;
      }

      lastResult = sch.search(parsed);

      if (debug) {
        trace("     found " + lastResult.length());
      }

      return lastResult.length();
    } catch (ParseException pe) {
      throw new IndexException(pe);
    } catch (IOException e) {
      throw new IndexException(e);
    } catch (Throwable t) {
      throw new IndexException(t);
    }
  }

  /** Called to retrieve record keys from the result.
   *
   * @param   n        Starting index
   * @param   keys     Array for the record keys
   * @return  int      Actual number of records
   */
  public int retrieve(final int n, final Index.Key[] keys) throws IndexException {
    checkOpen();

    if ((lastResult == null) ||
        (keys == null) ||
        (n >= lastResult.length())) {
      return 0;
    }

    int i;

    for (i = 0; i < keys.length; i++) {
      int hi = i + n;
      if (hi >= lastResult.length()) {
        break;
      }

      try {
        keys[i] = makeKey(keys[i], lastResult.doc(hi), lastResult.score(hi));
      } catch (IOException e) {
        throw new IndexException(e);
      } catch (Throwable t) {
        throw new IndexException(t);
      }
    }

    return i;
  }

  /** Called if we intend to run a batch of updates. endBatch MUST be
   * called or manual intervention may be required to remove locks.
   */
  public void startBatch() throws IndexException {
    //batchMode = true;
  }

  /** Called at the end of a batch of updates.
   */
  public void endBatch() throws IndexException {
    //batchMode = false;
    close();
  }

  /** Called to close at the end of a session.
   */
  public synchronized void close() throws IndexException {
    closeWtr();
    closeRdr();

    isOpen = false;
  }

  /** Called if we need to close the writer
   *
   * @throws IndexException
   */
  public synchronized void closeWtr() throws IndexException {
    try {
      if (wtr != null) {
        if (updatedIndex) {
//          wtr.optimize();
          updatedIndex = false;
        }
        wtr.close();
        wtr = null;
      }
    } catch (IOException e) {
      throw new IndexException(e);
    } catch (Throwable t) {
      throw new IndexException(t);
    }
  }

  /** Called if we need to close the reader
   *
   * @throws IndexException
   */
  public synchronized void closeRdr() throws IndexException {
    try {
      if (sch != null) {
        try {
          sch.close();
        } catch (Exception e) {}
        sch = null;
      }

      if (rdr != null) {
        rdr.close();
        rdr = null;
      }
    } catch (IOException e) {
      throw new IndexException(e);
    } catch (Throwable t) {
      throw new IndexException(t);
    }
  }

  /** Called to provide some debugging dump info.
   */
  public void dump() {
  }

  /** Called to provide some statistics.
   */
  public void stats() {
  }

  /** ===================================================================
                    Private methods
      =================================================================== */

  /** Ensure we're open
   *
   * @throws IndexException
   */
  private void checkOpen() throws IndexException {
    if (isOpen) {
      return;
    }

    open();
  }

  /* Called to obtain the current or a new writer.
   *
   * @return IndexWriter  writer to our index
   */
  private IndexWriter getWtr() throws IndexException {
    if (!writeable) {
      throw new IndexException(IndexException.noAccess);
    }

    String dirPath = basePath + indexDir;

    try {
      if (wtr == null) {
        wtr = new IndexWriter(dirPath, defaultAnalyzer, false);
      }

      return wtr;
    } catch (IOException e) {
      if (e instanceof FileNotFoundException) {
        // Assume not indexed yet
        throw new IndexException(IndexException.noFiles);
      }

      if (!cleanLocks) {
        error(e);
        throw new IndexException(e);
      }

      info("Had exception: " + e.getMessage());
      info("Will try to clean lock");

      try {
        // There should really be a lucene exception for this one
        if (IndexReader.isLocked(dirPath)) {
          Directory d = getRdr().directory();
          IndexReader.unlock(d);
        }
        wtr = new IndexWriter(dirPath, defaultAnalyzer, false);
        info("Clean lock succeeded");
        return wtr;
      } catch (Throwable t) {
        info("Clean lock failed");
        throw new IndexException(t);
      }
    } catch (Throwable t) {
      throw new IndexException(t);
    }
  }

  /* Called to obtain the current or a new reader.
   *
   * @return IndexReader  reader of our index
   */
  private IndexReader getRdr() throws IndexException {
    if (basePath == null) {
      throw new IndexException(IndexException.noBasePath);
    }

    try {
      if (rdr == null) {
        rdr = IndexReader.open(basePath + indexDir);
      }

      return rdr;
    } catch (IOException e) {
      if (e instanceof FileNotFoundException) {
        throw new IndexException(IndexException.noFiles);
      }
      throw new IndexException(e);
    } catch (Throwable t) {
      throw new IndexException(t);
    }
  }


  /* Called to unindex a record. The reader will be left
   * open. The writer must be closed and will stay closed.
   *
   * @param   rec      The record to unindex
   */
  private boolean intUnindexRec(final Object rec) throws IndexException {
    try {
      Term t = makeKeyTerm(rec);

      int numDeleted = getRdr().deleteDocuments(t);

      if (numDeleted > 1) {
        throw new IndexException(IndexException.dupKey, t.toString());
      }

      if (debug) {
        trace("removed " + numDeleted + " entries for " + t);
      }

      updatedIndex = true;
      return true;
    } catch (IndexException ie) {
      if (ie.getCause() instanceof FileNotFoundException) {
        // ignore
        return false;
      }
      throw ie;
    } catch (IOException e) {
      throw new IndexException(e);
    } catch (Throwable t) {
      throw new IndexException(t);
    }
  }

  /* Called to index a record. The writer will be left open and the reader
   * must be closed on entry and will stay closed.
   *
   * @param   rec      The record to index
   */
  private void intIndexRec(final Object rec) throws IndexException {
    Document doc = new Document();

    addFields(doc, rec);

    try {
      closeRdr();
      getWtr().addDocument(doc);

      updatedIndex = true;
    } catch (IndexException ie) {
      throw ie;
    } catch (IOException e) {
      throw new IndexException(e);
    } catch (Throwable t) {
      throw new IndexException(t);
    }
  }

  /** ===================================================================
                Some useful methods
      =================================================================== */

  /** Called to add an array of objects to a document
   *
   * @param   doc      Document object
   * @param   fld      Field info
   * @param   os       Object array
   * @throws IndexException
   */
  protected void addField(final Document doc, final FieldInfo fld, final Object[] os)
      throws IndexException {
    if (os == null) {
      return;
    }

    for (Object o: os) {
      if (o != null) {
        doc.add(fld.makeField(String.valueOf(o)));
      }
    }
  }

  /** Called to add a String val to a document
   *
   * @param   doc      The document
   * @param   fld      Field info
   * @param   val      The value
   * @throws IndexException
   */
  protected void addField(final Document doc, final FieldInfo fld, final Object val)
      throws IndexException {
    if (val == null) {
      return;
    }

    doc.add(fld.makeField(String.valueOf(val)));
  }

  protected Logger getLog() {
    if (log == null) {
      log = Logger.getLogger(this.getClass());
    }

    return log;
  }

  protected void error(final Throwable e) {
    getLog().error(this, e);
  }

  protected void error(final String msg) {
    getLog().error(msg);
  }

  protected void info(final String msg) {
    getLog().info(msg);
  }

  protected void trace(final String msg) {
    getLog().debug(msg);
  }
}
