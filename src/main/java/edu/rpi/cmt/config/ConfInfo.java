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
package edu.rpi.cmt.config;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/** This is used to annotate a method in a configuration class.
 *
 * @author Mike Douglass
 *
 */
@Retention(RetentionPolicy.RUNTIME)
@Target({ElementType.METHOD, ElementType.TYPE})
public @interface ConfInfo {
  /** Name of element to use in xml dump
   */
  String elementName() default "";

  /** Type of element for collections
   */
  String elementType() default "java.lang.String";

  /** For a collection, if this is not defaulted, each element of the
   * collection will be wrapped in this extra tag
   */
  String collectionElementName() default "";

  /** set true for getters when we don't want to save as part of the config.
   */
  boolean dontSave() default false;

  /** Set this for an attribute defining the class to be used when read. It may
   * not be clear from the context which class to use when reading the object.
   *
   * <p>If not set the class of the object being written is assumed.
   */
  String type() default "";
}
