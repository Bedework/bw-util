/* ********************************************************************
    Appropriate copyright notice
*/
package org.bedework.util.elasticsearch;

import org.bedework.util.misc.ToString;

import org.elasticsearch.common.xcontent.XContentBuilder;

/**
 * User: mike Date: 3/14/16 Time: 01:03
 */
public class EsDocInfo {
  private final XContentBuilder source;
  private final String type;
  private final long version;
  private final String id;

  public EsDocInfo(final XContentBuilder source,
                   final String type,
                   final long version,
                   final String id) {
    this.source = source;
    this.type = type;
    this.version = version;
    this.id = id;
  }

  public XContentBuilder getSource() {
    return source;
  }

  public String getType() {
    return type;
  }

  public long getVersion() {
    return version;
  }

  public String getId() {
    return id;
  }

  public String toString() {
    ToString ts = new ToString(this);

    ts.append("type", type);
    ts.append("version", version);
    ts.append("id", id);

    return ts.toString();
  }
}
