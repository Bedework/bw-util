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

import java.util.Collection;

/** Base type for a database entity. We require an id and the subclasses must
 * implement hashcode and compareTo.
 *
 * @author Mike Douglass
 * @version 1.0
 *
 * @param <K>  Id type
 * @param <T>
 */
public abstract class VersionedDbEntity<K, T> extends UnversionedDbentity<K, T> {
  /* Hibernate does not implicitly delete db entities during update or
   * save, except for those referenced as part of a Collection.
   *
   * These lists allows us to do explicit deletes when we delete or
   * update the entry.
   */

  private Collection<VersionedDbEntity<?, ?>> deletedEntities;

  /* db version number */
  private Integer seq;

  /** No-arg constructor
   *
   */
  public VersionedDbEntity() {
  }

  /** Set the seq for this entity
   *
   * @param val    int seq
   */
  public void setSeq(final Integer val) {
    seq = val;
  }

  /** Get the entity seq
   *
   * @return int    the entity seq
   */
  public Integer getSeq() {
    return seq;
  }

  /**
   * @return deleted entities or null
   */
  @NoDump
  public Collection<VersionedDbEntity<?, ?>> getDeletedEntities() {
    return deletedEntities;
  }

  /** Called when we are about to delete from the db
   *
   */
  public void beforeDeletion() {
  }

  /** Called after delete from the db
   *
   */
  public void afterDeletion() {
  }

  /** Called when we are about to update the object.
   *
   */
  public void beforeUpdate() {
  }

  /** Called when we are about to save the object. Default to calling before
   * update
   *
   */
  public void beforeSave() {
    beforeUpdate();
  }
}
