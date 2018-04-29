<?xml version="1.0" encoding="UTF-8"?>
<!--
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
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!--  Access Control strings for display using bedeworkAccess.xsl  -->
  <!--  Quickstart default is English -->
  <xsl:variable name="bwStr-Access-Add">Add:</xsl:variable>
  <xsl:variable name="bwStr-Access-Who">Who:</xsl:variable>
  <xsl:variable name="bwStr-Access-User">user</xsl:variable>
  <xsl:variable name="bwStr-Access-Group">group</xsl:variable>
  <xsl:variable name="bwStr-Access-Or">OR</xsl:variable>
  <xsl:variable name="bwStr-Access-Owner">owner</xsl:variable>
  <xsl:variable name="bwStr-Access-Authenticated">authenticated</xsl:variable>
  <xsl:variable name="bwStr-Access-Unauthenticated">unauthenticated</xsl:variable>
  <xsl:variable name="bwStr-Access-AllUsers">all users</xsl:variable>
  <xsl:variable name="bwStr-Access-AddEntry">add entry</xsl:variable>
  <xsl:variable name="bwStr-Access-Basic">basic</xsl:variable>
  <xsl:variable name="bwStr-Access-Advanced">advanced</xsl:variable>
  <xsl:variable name="bwStr-Access-Rights">Rights:</xsl:variable>
  <xsl:variable name="bwStr-Access-AccessType">access type</xsl:variable>
  <xsl:variable name="bwStr-Access-Allow">allow</xsl:variable>
  <xsl:variable name="bwStr-Access-Deny">deny</xsl:variable>
  <xsl:variable name="bwStr-Access-All">All</xsl:variable>
  <xsl:variable name="bwStr-Access-Read">Read</xsl:variable>
  <xsl:variable name="bwStr-Access-ReadACL">read ACL</xsl:variable>
  <xsl:variable name="bwStr-Access-ReadCurrentUserPrivilegeSet">read current user privilege set</xsl:variable>
  <xsl:variable name="bwStr-Access-ReadFreebusy">read freebusy</xsl:variable>
  <xsl:variable name="bwStr-Access-Write">Write</xsl:variable>
  <xsl:variable name="bwStr-Access-WriteACL">write ACL</xsl:variable>
  <xsl:variable name="bwStr-Access-WriteProperties">write properties</xsl:variable>
  <xsl:variable name="bwStr-Access-WriteContent">write content</xsl:variable>
  <xsl:variable name="bwStr-Access-Create">create (bind)</xsl:variable>
  <xsl:variable name="bwStr-Access-Delete">delete (unbind)</xsl:variable>
  <xsl:variable name="bwStr-Access-ScheduleDeliver">Schedule-deliver</xsl:variable>
  <xsl:variable name="bwStr-Access-ScheduleDeliverInvite">schedule-deliver-invite</xsl:variable>
  <xsl:variable name="bwStr-Access-ScheduleDeliverReply">schedule-deliver-reply</xsl:variable>
  <xsl:variable name="bwStr-Access-ScheduleQueryFreebusy">schedule-query-freebusy</xsl:variable>
  <xsl:variable name="bwStr-Access-ScheduleSend">Schedule-send</xsl:variable>
  <xsl:variable name="bwStr-Access-ScheduleSendInvite">schedule-send-invite</xsl:variable>
  <xsl:variable name="bwStr-Access-ScheduleSendReply">schedule-send-reply</xsl:variable>
  <xsl:variable name="bwStr-Access-ScheduleSendFreebusy">schedule-send-freebusy</xsl:variable>
  <xsl:variable name="bwStr-Access-None">None</xsl:variable>
  <xsl:variable name="bwStr-Access-BasicAll">All</xsl:variable>
  <xsl:variable name="bwStr-Access-BasicRead">Read only</xsl:variable>

</xsl:stylesheet>