## bw-util [![Build Status](https://travis-ci.org/Bedework/bw-util.svg)](https://travis-ci.org/Bedework/bw-util)

This project provides a number of utility classes and methods for
[Bedework](https://www.apereo.org/projects/bedework).

### Requirements

1. JDK 7
2. Maven 3

### Building Locally

> mvn clean install

### Releasing

Releases of this fork are published to Maven Central via Sonatype.

To create a release, you must have:

1. Permissions to publish to the `org.bedework` groupId.
2. `gpg` installed with a published key (release artifacts are signed).

To perform a new release:

> mvn release:clean release:prepare

When prompted, select the desired version; accept the defaults for scm tag and next development version.
When the build completes, and the changes are committed and pushed successfully, execute:

> mvn release:perform

For full details, see [Sonatype's documentation for using Maven to publish releases](http://central.sonatype.org/pages/apache-maven.html).

### Release Notes
#### 4.0.3
  * Add base classes for a jolokia cli
  * Add status operations to the base jmx classes for use by the cli
  * Add some base classes for JMS interactions
  * Update the deploy process to add some wildfly features.

#### 4.0.4
  * Refactor the post-build deployment module to work as a maven plugin.
