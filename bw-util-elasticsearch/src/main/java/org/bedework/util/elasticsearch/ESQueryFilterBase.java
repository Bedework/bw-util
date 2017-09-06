/* ********************************************************************
    Appropriate copyright notice
*/
package org.bedework.util.elasticsearch;

import org.bedework.util.misc.Logged;

/**
 * User: mike Date: 9/1/17 Time: 22:55
 */
public class ESQueryFilterBase extends Logged {

  public enum OperationType {
    compare,
    timeRange,
    prefix,
    presence,
    absence
  }
}
