/* ********************************************************************
    Appropriate copyright notice
*/
package org.bedework.util.elasticsearch;

/**
 * User: mike Date: 9/1/17 Time: 22:55
 */
public class ESQueryFilterBase {

  public enum OperationType {
    compare,
    timeRange,
    prefix,
    presence,
    absence
  }
}
