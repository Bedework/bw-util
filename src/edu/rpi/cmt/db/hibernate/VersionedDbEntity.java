/* **********************************************************************
    Copyright 2010 Rensselaer Polytechnic Institute. All worldwide rights reserved.

    Redistribution and use of this distribution in source and binary forms,
    with or without modification, are permitted provided that:
       The above copyright notice and this permission notice appear in all
        copies and supporting documentation;

        The name, identifiers, and trademarks of Rensselaer Polytechnic
        Institute are not used in advertising or publicity without the
        express prior written permission of Rensselaer Polytechnic Institute;

    DISCLAIMER: The software is distributed" AS IS" without any express or
    implied warranty, including but not limited to, any implied warranties
    of merchantability or fitness for a particular purpose or any warrant)'
    of non-infringement of any current or pending patent rights. The authors
    of the software make no representations about the suitability of this
    software for any particular purpose. The entire risk as to the quality
    and performance of the software is with the user. Should the software
    prove defective, the user assumes the cost of all necessary servicing,
    repair or correction. In particular, neither Rensselaer Polytechnic
    Institute, nor the authors of the software are liable for any indirect,
    special, consequential, or incidental damages related to the software,
    to the maximum extent the law permits.
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
