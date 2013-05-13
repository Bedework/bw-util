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
package edu.rpi.cmt.util.test;

import edu.rpi.cmt.config.ConfInfo;
import edu.rpi.cmt.config.ConfigBase;

import java.util.List;

/** Test the Util class
 */
@ConfInfo(elementName="try-this")
public class AnObject extends ConfigBase {
  private String a;
  private int b;
  private boolean c;

  private List<String> props;
  private List<Integer> nums;

  /**
   * @param val
   */
  public void setA(final String val) {
    a = val;
  }

  /**
   * @return String
   */
  public String getA() {
    return a;
  }

  /**
   * @param val
   */
  public void setB(final int val) {
    b = val;
  }

  /**
   * @return int
   */
  public int getB() {
    return b;
  }

  /**
   * @param val
   */
  public void setC(final boolean val) {
    c = val;
  }

  /**
   * @return boolean
   */
  public boolean getC() {
    return c;
  }

  /**
   * @param val
   */
  public void setProps(final List<String> val) {
    props = val;
  }

  /**
   * @return List<String>
   */
  @ConfInfo(collectionElementName = "prop")
  public List<String> getProps() {
    return props;
  }

  /**
   * @param val
   */
  public void setNums(final List<Integer> val) {
    nums = val;
  }

  /**
   * @return List<String>
   */
  @ConfInfo(collectionElementName = "num")
  public List<Integer> getNums() {
    return nums;
  }
}

