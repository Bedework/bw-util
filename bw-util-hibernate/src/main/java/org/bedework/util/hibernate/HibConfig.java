/* ********************************************************************
    Appropriate copyright notice
*/
package org.bedework.util.hibernate;

import org.bedework.util.config.HibernateConfigBase;
import org.bedework.util.misc.Logged;

import org.hibernate.cfg.Configuration;

import java.io.StringReader;
import java.util.List;
import java.util.Properties;

/** Get configuration from JMX bean
 * User: mike
 * Date: 1/24/17
 * Time: 00:17
 */
public class HibConfig extends Logged {
  private final HibernateConfigBase config;
  
  public HibConfig(final HibernateConfigBase config) {
    this.config = config;
  }
  
  /**
   * @return Configuration based on the properties
   */
  public synchronized Configuration getHibConfiguration() {
    try {
      final Configuration hibCfg = new Configuration();

      final StringBuilder sb = new StringBuilder();

      @SuppressWarnings("unchecked")
      final List<String> ps = config.getHibernateProperties();

      for (final String p: ps) {
        sb.append(p);
        sb.append("\n");
      }

      final Properties hprops = new Properties();
      hprops.load(new StringReader(sb.toString()));

      hibCfg.addProperties(hprops).configure();

      return hibCfg;
    } catch (final Throwable t) {
      // Always bad.
      error(t);
      
      return null;
    }
  }
}
