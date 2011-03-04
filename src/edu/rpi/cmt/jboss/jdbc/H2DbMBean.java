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
package edu.rpi.cmt.jboss.jdbc;

/**
 *
 * @author douglm
 *
 */
public interface H2DbMBean {
  /** Name apparently must be the same as the name attribute in the
   * jboss service definition
   *
   * @return Name
   */
  public String getName();

  /** Account we run under
   *
   * @param val
   */
  public void setAccount(String val);

  /**
   * @return String account we use
   */
  public String getAccount();

  /** Password
   *
   * @param val
   */
  public void setPw(String val);

  /**
   * @return String password
   */
  public String getPw();

  /** Tracing
   *
   * @param val
   */
  public void setTrace(boolean val);

  /**
   * @return boolean
   */
  public boolean getTrace();

  /** An absolute path
   *
   * @param val
   */
  public void setDbName(final String val);

  /**
   * @return name of database
   */
  public String getDbName();

  /** Set the port to use
   * @param val
   */
  public void setPort(final int val);

  /** Get the port
   *
   * @return port number
   */
  public int getPort();

  /** Lifecycle
   *
   */
  public void start();

  /** Lifecycle
   *
   */
  public void stop();

  /** Lifecycle
   *
   * @return true if started
   */
  public boolean isStarted();

}
