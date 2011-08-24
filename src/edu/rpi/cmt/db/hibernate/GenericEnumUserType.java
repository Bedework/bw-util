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

package edu.rpi.cmt.db.hibernate;

import org.hibernate.HibernateException;
import org.hibernate.type.NullableType;
import org.hibernate.type.TypeFactory;
import org.hibernate.usertype.ParameterizedType;
import org.hibernate.usertype.UserType;

import java.io.Serializable;
import java.lang.reflect.Method;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;

/** http://community.jboss.org/wiki/Java5EnumUserType
 *
 * @author Anthony Patricio
 */
public class GenericEnumUserType implements UserType, ParameterizedType {
  private static final String DEFAULT_IDENTIFIER_METHOD_NAME = "name";
  private static final String DEFAULT_VALUE_OF_METHOD_NAME = "valueOf";

  private Class<? extends Enum> enumClass;
  private Class<?> identifierType;
  private Method identifierMethod;
  private Method valueOfMethod;
  private NullableType type;
  private int[] sqlTypes;

  public void setParameterValues(final Properties parameters) {
    String enumClassName = parameters.getProperty("enumClassname");
    try {
      enumClass = Class.forName(enumClassName).asSubclass(Enum.class);
    } catch (ClassNotFoundException cfne) {
      throw new HibernateException("Enum class not found", cfne);
    }

    String identifierMethodName = parameters.getProperty("identifierMethod", DEFAULT_IDENTIFIER_METHOD_NAME);

    try {
      identifierMethod = enumClass.getMethod(identifierMethodName, new Class[0]);
      identifierType = identifierMethod.getReturnType();
    } catch (Exception e) {
      throw new HibernateException("Failed to obtain identifier method", e);
    }

    type = (NullableType) TypeFactory.basic(identifierType.getName());

    if (type == null) {
      throw new HibernateException("Unsupported identifier type " + identifierType.getName());
    }

    sqlTypes = new int[] { type.sqlType() };

    String valueOfMethodName = parameters.getProperty("valueOfMethod", DEFAULT_VALUE_OF_METHOD_NAME);

    try {
      valueOfMethod = enumClass.getMethod(valueOfMethodName, new Class[] { identifierType });
    } catch (Exception e) {
      throw new HibernateException("Failed to obtain valueOf method", e);
    }
  }

  public Class returnedClass() {
    return enumClass;
  }

  public Object nullSafeGet(final ResultSet rs, final String[] names, final Object owner) throws HibernateException, SQLException {
    Object identifier = type.get(rs, names[0]);
    if (rs.wasNull()) {
      return null;
    }

    try {
      return valueOfMethod.invoke(enumClass, new Object[] { identifier });
    } catch (Exception e) {
      throw new HibernateException("Exception while invoking valueOf method '" + valueOfMethod.getName() + "' of " +
          "enumeration class '" + enumClass + "'", e);
    }
  }

  public void nullSafeSet(final PreparedStatement st, final Object value, final int index) throws HibernateException, SQLException {
    try {
      if (value == null) {
        st.setNull(index, type.sqlType());
      } else {
        Object identifier = identifierMethod.invoke(value, new Object[0]);
        type.set(st, identifier, index);
      }
    } catch (Exception e) {
      throw new HibernateException("Exception while invoking identifierMethod '" + identifierMethod.getName() + "' of " +
          "enumeration class '" + enumClass + "'", e);
    }
  }

  public int[] sqlTypes() {
    return sqlTypes;
  }

  public Object assemble(final Serializable cached, final Object owner) throws HibernateException {
    return cached;
  }

  public Object deepCopy(final Object value) throws HibernateException {
    return value;
  }

  public Serializable disassemble(final Object value) throws HibernateException {
    return (Serializable) value;
  }

  public boolean equals(final Object x, final Object y) throws HibernateException {
    return x == y;
  }

  public int hashCode(final Object x) throws HibernateException {
    return x.hashCode();
  }

  public boolean isMutable() {
    return false;
  }

  public Object replace(final Object original, final Object target, final Object owner) throws HibernateException {
    return original;
  }
}
