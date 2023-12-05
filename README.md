## bw-util [![Build Status](https://travis-ci.org/Bedework/bw-util.svg)](https://travis-ci.org/Bedework/bw-util)

This project provides a number of utility classes and methods for
[Bedework](https://www.apereo.org/projects/bedework).

### Requirements

1. JDK 11
2. Maven 3

### Building Locally

> mvn clean install

### Releasing

Releases of this fork are published to Maven Central via Sonatype.

To create a release, you must have:

1. Permissions to publish to the `org.bedework` groupId.
2. `gpg` installed with a published key (release artifacts are signed).

To perform a new release:

> mvn -P bedework-dev release:clean release:prepare

When prompted, select the desired version; accept the defaults for scm tag and next development version.
When the build completes, and the changes are committed and pushed successfully, execute:

> mvn -P bedework-dev release:perform

For full details, see [Sonatype's documentation for using Maven to publish releases](http://central.sonatype.org/pages/apache-maven.html).

### Release Notes
#### 4.0.3
  * Add base classes for a jolokia cli
  * Add status operations to the base jmx classes for use by the cli
  * Add some base classes for JMS interactions
  * Update the deploy process to add some wildfly features.

#### 4.0.4
  * Refactor the post-build deployment module to work as a maven plugin.

#### 4.0.5
  * Add setHostLimit method to BasicHttpClient.
  * Deployment class ProcessEars renamed to Process

#### 4.0.6
  * Add more tokenizer methods to JolokiaCli.

#### 4.0.7
  * Fix tokenizer so that string method will pushback.
  * More help support

#### 4.0.9
  * Property replacement on non-string values. Lost this version trying to release

#### 4.0.11
  * Update hibernate to 5.2.5.Final

#### 4.0.14
  * Fix UTC timestamp format
  * Add error, audit and metrics log streams

#### 4.0.19
  * Add command to get system monitor figures.
  * Many logging changes
  * Factor out hibernate classes
  * Update jackson libraries to avoid security warnings. Not vulnerable.
  * Fixes to maven deployment code
  * BasicHttpClient wasn't sending headers
  * Move SerializableProperties into util class
  * Tidy up directory classes

#### 4.0.20
  * Move all logging api references to a single module - bw-util-logging

#### 4.0.21
  * Add pooled http client
  * Add a defaulted class for configs
  * Remove bw-util-deploy module. No longer needed
  
#### 4.0.22
  * Fix HttpUtils post method. Setting Accept - not Content-type
  * Move deployment classes into new bw-util-deploy module
  
#### 4.0.23
  * Fix FlushMap in utils. Current fetched value was not discarded.
  
#### 4.0.24
  * Update jackson version
  * Update servlet-api
  
#### 4.0.25
  * Update javadoc plugin config
  * ES 7.2 changes
  
#### 4.0.26
  * Lowercase account unless mixed case environment variable BEDEWORK_MIXEDCASE_ACCOUNTS is set to true
  * Switch to PooledHttpClient
  
#### 4.0.27
  * Update to jackson version and fix PooledHttClient
  * Refactor: move cli support out of bw-util into bw-cliutil
  * Refactor: move bw-util-struts out of bw-util into bw-calendar-client-util
  * Refactor - move a bunch of modules into new util projects
  * For dav tester
    * Make some classes public
    * Add clear method to clean an XML node
    * Clean up exceptions
  * Move response objects out of CalFacade so they can be used within other modules.
  * Add a node diff class - allows diffing parsed XML but should work for any Document.
  * Add sortMap method

#### 4.0.28
  * Minor fix to check for null. Resulted in many changes to remove throws clauses from the xml emit utility class methods. This of course resulted in many changes up the call hierarchy
  * Add datauri convenience method.
  * Update commons-codec version

#### 4.0.29
* Remove last traces of util-deploy-wfmodule
* Update library versions

#### 4.0.30
* Update AbstractProcessorThread.java for category server

#### 4.0.31
* Pass class loader as parameter when creating new objects. JMX interactions were failing.
* Try comparing names as classloader differences cause this to fail.
* Try to get better handling of interrupted exceptions

#### 5.0.1
* Use bedework-parent for builds
* Upgrade library versions

#### 5.0.2
* Upgrade library versions


  
