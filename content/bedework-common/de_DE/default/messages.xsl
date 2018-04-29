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
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml">
  <xsl:template match="message">
    <xsl:choose>
      <xsl:when test="id='org.bedework.client.message.added.calendar'">
        Calendar added.
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.added.categories'">
        <xsl:choose>
          <xsl:when test="param='1'">
            1 category added
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="param"/> categories added
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.added.contact'">
        Contact added
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.added.eventrefs'">
        <xsl:choose>
          <xsl:when test="param='1'">
            1 event reference added.
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="param"/> event references added.
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.added.events'">
        <xsl:choose>
          <xsl:when test="param='1'">
            1 event added.
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="param"/> events added.
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.added.folder'">
        Folder added.
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.added.locations'">
        <xsl:choose>
          <xsl:when test="param='1'">
            1 location added
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="param"/> locations added
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="id='org.bedework.client.message.added.tasks'">
        <xsl:choose>
          <xsl:when test="param='1'">
            1 task added.
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="param"/> tasks added.
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="id='org.bedework.client.message.cancelled'">
          Action canceled.
      </xsl:when>

      <xsl:when test="id='org.bedework.client.message.moved.calendar'">
        Moved <xsl:value-of select="param"/>
      </xsl:when>

      <xsl:when test="id='org.bedework.client.message.deleted.authuser'">
        Administrator removed
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.deleted.calendar'">
        Deleted <xsl:value-of select="param"/>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.deleted.category'">
        Category deleted.
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.deleted.contact'">
        Contact deleted
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.deleted.events'">
        <xsl:choose>
          <xsl:when test="param='1'">
            1 event deleted.
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="param"/> events deleted.
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.deleted.group'">
        Group deleted
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.deleted.locations'">
        <xsl:choose>
          <xsl:when test="param='1'">
            1 location removed.
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="param"/> locations removed.
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.deleted.subscription'">
        Subscription removed.
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.deleted.view'">
        View deleted
      </xsl:when>

      <xsl:when test="id='org.bedework.client.message.freebusy.unavailable'">
        Freebusy information is (currently) unavailable for
          <xsl:value-of select="param"/>
      </xsl:when>

      <xsl:when test="id='org.bedework.client.message.imported.timezones'">
        Timezones successfully imported
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.fixed.timezones'">
        Timezones successfully fixed
      </xsl:when>

      <xsl:when test="id='org.bedework.client.message.mailed.event'">
        Event has been mailed
      </xsl:when>

      <xsl:when test="id='org.bedework.client.message.schedule.added'">
        Schedule added
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.schedule.deferred'">
        Schedule deferred
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.schedule.ignored'">
        Schedule ignored
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.schedule.rescheduled'">
        Schedule rescheduled
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.schedule.sent'">
        Scheduling message sent to <xsl:value-of select="param"/>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.schedule.updated'">
        Schedule updated
      </xsl:when>

      <xsl:when test="id='org.bedework.client.message.set.alarm'">
        Alarm has been set
      </xsl:when>

      <xsl:when test="id='org.bedework.client.message.updated.authuser'">
        Administrator updated
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.updated.calendar'">
        Calendar updated.
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.updated.category'">
        Category updated.
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.updated.contact'">
        Contact updated
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.updated.event'">
        Event updated
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.updated.events'">
        <xsl:choose>
          <xsl:when test="param='1'">
            1 event updated.
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="param"/> events updated.
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.updated.folder'">
        Folder updated.
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.updated.group'">
        Group updated
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.updated.location'">
        Location updated
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.updated.prefs'">
        Preferences updated.
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.updated.syspars'">
        System preferences updated
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.updated.task'">
        Task updated
      </xsl:when>
      <xsl:when test="id='org.bedework.client.message.updated.userinfo'">
        User information updated
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="id"/> = <xsl:value-of select="param"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>

