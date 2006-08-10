package edu.rpi.cct.misc.indexing;

import org.apache.lucene.analysis.Analyzer;
import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field;
import org.apache.lucene.index.IndexReader;
import org.apache.lucene.index.IndexWriter;
import org.apache.lucene.index.Term;
import org.apache.lucene.queryParser.ParseException;
import org.apache.lucene.queryParser.QueryParser;
import org.apache.lucene.search.Hits;
import org.apache.lucene.search.IndexSearcher;
import org.apache.lucene.search.Query;
import org.apache.lucene.search.Searcher;

import java.io.IOException;
import java.io.StringReader;
import java.sql.Timestamp;

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

  /** Create an indexer with the default set of stop words.
   *
   * @param basePath    String path to where we should read/write indexes
   * @param defaultFieldName  default name for searches
   * @param writeable   true if the caller can update the index
   * @param debug       true if we want to see what's going on
   * @throws IndexException
   */
  public IndexLuceneImpl(String basePath,
                         String defaultFieldName,
                         boolean writeable,
                         boolean debug) throws IndexException {
    this(basePath, defaultFieldName, writeable, null, debug);
  }

  /** Create an indexer with the given set of stop words.
   *
   * @param basePath    String path to where we should read/write indexes
   * @param defaultFieldName  default name for searches
   * @param writeable   true if the caller can update the index
   * @param stopWords   set of stop words, null for default.
   * @param debug       true if we want to see what's going on
   * @throws IndexException
   */
  public IndexLuceneImpl(String basePath,
                         String defaultFieldName,
                         boolean writeable,
                         String[] stopWords,
                         boolean debug) throws IndexException {
    setDebug(debug);
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

  public void setDebug(boolean val) {
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
  public void indexRec(Object rec) throws IndexException {
    unindexRec(rec);
    intIndexRec(rec);
    closeWtr();
  }

  /** Called to unindex a record
   *
   * @param   rec      The record to unindex
   */
  public void unindexRec(Object rec) throws IndexException {
    try {
      checkOpen();
      closeWtr();
      intUnindexRec(rec);
    } finally {
      closeWtr(); // Just in case
      closeRdr();
    }
  }

  /** Called to (re)index a batch of records
   *
   * @param   recs     The records to index
   */
  public void indexRecs(Object[] recs) throws IndexException {
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
  public void indexNewRecs(Object[] recs) throws IndexException {
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
  public void unindexRecs(Object[] recs) throws IndexException {
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
  public int search(String query) throws IndexException {
    checkOpen();

    try {
      if (debug) {
        log("About to search for " + query);
      }

      Query parsed = queryParser.parse(query);

      if (debug) {
        log("     with parsed query " + parsed.toString(null));
      }

      if (sch == null) {
        sch = new IndexSearcher(getRdr());
      }
      lastResult = sch.search(parsed);

      if (debug) {
        log("     found " + lastResult.length());
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
  public int retrieve(int n, Index.Key[] keys) throws IndexException {
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
          wtr.optimize();
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

    try {
      if (wtr == null) {
        wtr = new IndexWriter(basePath + indexDir, defaultAnalyzer, false);
      }

      return wtr;
    } catch (IOException e) {
      throw new IndexException(e);
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
  private void intUnindexRec(Object rec) throws IndexException {
    try {
      Term t = makeKeyTerm(rec);

      int numDeleted = getRdr().deleteDocuments(t);

      if (numDeleted > 1) {
        throw new IndexException(IndexException.dupKey, t.toString());
      }

      if (debug) {
        log("removed " + numDeleted + " entries for " + t);
      }

      updatedIndex = true;
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
  private void intIndexRec(Object rec) throws IndexException {
    Document doc = new Document();

    addFields(doc, rec);

    try {
      closeRdr();
      getWtr().addDocument(doc);

      updatedIndex = true;
    } catch (IOException e) {
      throw new IndexException(e);
    } catch (Throwable t) {
      throw new IndexException(t);
    }
  }

  /** ===================================================================
                Some useful methods
      =================================================================== */

  /** Called to add an array of keys to a document
   *
   * @param   doc      Document object
   * @param   name     String field name
   * @param   ss       String array of keywords
   * @throws IndexException
   */
  protected void addKeyArray(Document doc, String name, String[] ss)
      throws IndexException {
    if (ss == null) {
      return;
    }

    for (int i = 0; i < ss.length; i++) {
      if (ss[i] != null) {
        doc.add(new Field(name, ss[i], Field.Store.YES, Field.Index.UN_TOKENIZED));
      }
    }
  }

  /** Called to add a timestamp date to a document
   *
   * @param   doc      The document
   * @param   name     Field name
   * @param   dt       The timestamp
   * @throws IndexException
   */
  protected void addTimestamp(Document doc, String name, Timestamp dt)
      throws IndexException {
    if (dt == null) {
      return;
    }

    doc.add(new Field(name, dt.toString(), Field.Store.YES, Field.Index.UN_TOKENIZED));
  }

  /** Called to add a String val to a document
   *
   * @param   doc      The document
   * @param   name     Field name
   * @param   val      The value
   * @throws IndexException
   */
  protected void addString(Document doc, String name, String val)
      throws IndexException {
    if (val == null) {
      return;
    }

    doc.add(new Field(name, val, Field.Store.YES, Field.Index.TOKENIZED));
  }

  /** Called to add a cost to a document
   *
   * @param   doc      The document
   * @param   name     Field name
   * @param   cost     The cost in cents
   * @throws IndexException
   */
  protected void addCost(Document doc, String name, Long cost)
      throws IndexException {
    if (cost == null) {
      return;
    }

    doc.add(new Field(name, cost.toString(), Field.Store.YES,
                      Field.Index.UN_TOKENIZED));
  }

  /** Called to add a long value to a document
   *
   * @param   doc      The document
   * @param   name     Field name
   * @param   val      The long value
   */
  protected void addLong(Document doc, String name, long val) {
    doc.add(new Field(name, String.valueOf(val), Field.Store.YES, Field.Index.UN_TOKENIZED));
  }

  /** Called to add an untokenized value to a document
   *
   * @param   doc      The document
   * @param   name     Field name
   * @param   val      The value
   */
  protected void addUntokenized(Document doc, String name, String val) {
    doc.add(new Field(name, val, Field.Store.YES, Field.Index.UN_TOKENIZED));
  }

  /** Called to add a keyword val to a document
   *
   * @param   doc      The document
   * @param   name     Field name
   * @param   val      The value
   * @throws IndexException
   */
  protected void addKey(Document doc, String name, String val)
      throws IndexException {
    if (val == null) {
      return;
    }

    doc.add(new Field(name, val, Field.Store.YES, Field.Index.UN_TOKENIZED));
  }

  /** Called to add a long String val to a document
   *
   * @param   doc      The document
   * @param   name     Field name
   * @param   val      The value
   * @throws IndexException
   */
  protected void addLongStoredString(Document doc, String name, String val)
      throws IndexException {
    if (val == null) {
      return;
    }

    doc.add(new Field(name, new StringReader(val)));
  }

  /** Called to add a long String val to a document
   *
   * @param   doc      The document
   * @param   name     Field name
   * @param   val      The value
   * @throws IndexException
   */
  protected void addLongString(Document doc, String name, String val)
      throws IndexException {
    if (val == null) {
      return;
    }

    doc.add(new Field(name, val, Field.Store.NO, Field.Index.TOKENIZED));
  }

  protected void log(String msg) {
    System.out.println(getClass().getName() + ": " + msg);
  }
}

