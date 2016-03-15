/* ********************************************************************
    Appropriate copyright notice
*/
package org.bedework.util.elasticsearch;

import java.io.Serializable;
import java.util.Set;
import java.util.TreeSet;

/**
 * User: mike Date: 3/13/16 Time: 23:55
 */
public class IndexInfo implements Comparable<IndexInfo>,
        Serializable {
  private final String indexName;

  private Set<String> aliases;

  /**
   * @param indexName name of the index
   */
  public IndexInfo(final String indexName) {
    this.indexName = indexName;
  }

  /**
   *
   * @return index name
   */
  public String getIndexName() {
    return indexName;
  }

  /**
   * @param val - set of aliases - never null
   */
  public void setAliases(final Set<String> val) {
    aliases = val;
  }

  /**
   * @return - set of aliases - never null
   */
  public Set<String> getAliases() {
    return aliases;
  }

  /**
   * @param val - an alias - never null
   */
  public void addAlias(final String val) {
    if (aliases == null) {
      aliases = new TreeSet<>();
    }

    aliases.add(val);
  }

  @SuppressWarnings("NullableProblems")
  @Override
  public int compareTo(final IndexInfo o) {
    return getIndexName().compareTo(o.getIndexName());
  }
}
