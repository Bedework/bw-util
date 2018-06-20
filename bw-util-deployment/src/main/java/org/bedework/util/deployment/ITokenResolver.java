/* ********************************************************************
    Appropriate copyright notice
*/
package org.bedework.util.deployment;

/**
 * Token replacement code based on http://tutorials.jenkov.com/java-howto/replace-strings-in-streams-arrays-files.html
 * User: mike Date: 6/19/18 Time: 23:01
 */
public interface ITokenResolver {
  String resolveToken(String tokenName);
}
