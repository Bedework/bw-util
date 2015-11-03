/* ********************************************************************
    Appropriate copyright notice
*/
package org.bedework.util.wildfly;

import org.jboss.security.SimpleGroup;
import org.jboss.security.SimplePrincipal;

import java.security.acl.Group;

import javax.security.auth.login.LoginException;

/**
 * User: mike Date: 11/2/15 Time: 17:27
 */
public class LdapLoginModule extends org.jboss.security.auth.spi.LdapLoginModule {
  public LdapLoginModule() {
    super();
    System.out.println(
            "constructor called ********************************");
    throw new RuntimeException("aaaaaaaaaaaaaaaaarrrrrrrrrggggghhhh");
  }

  /**
   * (required) The groups of the user, there must be at least one group called
   * "Roles" (though it likely can be empty) containing the roles the user has.
   */

  @Override
  protected Group[] getRoleSets() throws LoginException {
    SimpleGroup group = new SimpleGroup("Roles");
    System.out.println(
            "getRoleSets called ********************************");

    try {
      group.addMember(new SimplePrincipal("BedeworkUser"));
    } catch (Exception e) {
      throw new LoginException("Failed to create group member for " + group);
    }

    return new Group[] { group };
  }
}
