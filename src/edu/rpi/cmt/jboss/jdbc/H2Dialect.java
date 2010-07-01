package edu.rpi.cmt.jboss.jdbc;

import org.hibernate.Hibernate;
import org.hibernate.dialect.function.StandardSQLFunction;

import java.sql.Types;

/**
 * Update the hibernate distributed dialect. Effectively apply changes
 * referred to in http://opensource.atlassian.com/projects/hibernate/browse/HHH-3401
 *
 */
public class H2Dialect extends org.hibernate.dialect.H2Dialect {
  /**
   *
   */
  public H2Dialect() {
    super();

    registerColumnType(Types.BIT, "boolean");
    registerColumnType(Types.NUMERIC, "decimal($p,$s)");

    registerFunction("quarter",
                     new StandardSQLFunction("quarter", Hibernate.INTEGER));
  }
}