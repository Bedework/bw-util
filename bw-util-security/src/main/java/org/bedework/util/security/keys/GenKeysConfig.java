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
package org.bedework.util.security.keys;

import org.bedework.util.config.ConfInfo;
import org.bedework.util.jmx.MBeanInfo;

import java.io.Serializable;

/**
 * @author douglm
 *
 */
@ConfInfo(elementName = "genkeys")
public interface GenKeysConfig extends Serializable {
  /**
   *
   * @param val private key file name - full path
   */
  void setPrivKeyFileName(String val);

  /**
   * @return private key file name - full path
   */
  @MBeanInfo("private key file name - full path.")
  String getPrivKeyFileName();

  /**
   *
   * @param val public key file name - full path
   */
  void setPublicKeyFileName(String val);

  /**
   * @return public key file name - full path
   */
  @MBeanInfo("public key file name - full path.")
  String getPublicKeyFileName();
}
