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
  <!-- Apart from the exception - trapped first, these are in alphabetic order of
       error code. -->
  <xsl:template match="error">
    <p>
      <span class="ui-icon ui-icon-alert"><xsl:text> </xsl:text></span>
	    <xsl:choose>
	      <xsl:when test="id='org.bedework.client.error.exc'"><!-- trap exceptions first -->
	        An exception occurred<xsl:if test="param">: <em><xsl:value-of select="param"/></em></xsl:if>
	      </xsl:when>
	      <xsl:when test="id='edu.rpi.sss.util.error.exc'">
	        An exception occurred<xsl:if test="param">: <em><xsl:value-of select="param"/></em></xsl:if>
	      </xsl:when>
	      <xsl:when test="id='org.bedework.exception.norecurrenceinstances'">
	        Event or task has no recurrence instances<xsl:if test="param">: <em><xsl:value-of select="param"/></em></xsl:if>
	      </xsl:when>

	      <!-- client.error messages generally do not quite constitute validation errors
	           which mostly involve changing a field content.
	           Usually when we flag a data error here, it is due to a bug in the xsl -->

	      <xsl:when test="id='org.bedework.client.error.admingroupassignedcs'">
	        Error: admin group is assigned to<xsl:if test="param">: <em><xsl:value-of select="param"/></em></xsl:if>
	      </xsl:when>
	      <xsl:when test="id='org.bedework.client.error.alreadymember'">
	        Error: already a member<xsl:if test="param">: <em><xsl:value-of select="param"/></em></xsl:if>
	      </xsl:when>
	      <xsl:when test="id='org.bedework.client.error.badinterval'">
	        Error: bad interval.
	      </xsl:when>
	      <xsl:when test="id='org.bedework.client.error.badintervalunit'">
	        Error: bad interval unit.
	      </xsl:when>
	      <xsl:when test="id='org.bedework.client.error.badrequest'">
	        Error: Bad request.
	      </xsl:when>
	      <xsl:when test="id='org.bedework.client.error.badschedulewhat'">
	        Error: Bad scheduling what parameter.
	      </xsl:when>
	      <xsl:when test="id='org.bedework.error.scheduling.baddestinationcalendar'">
	        Error: You must set a destination calendar
	      </xsl:when>
	      <xsl:when test="id='org.bedework.client.error.calsuitenotadded'">
	        Error: calendar suite not added.
	      </xsl:when>
	      <xsl:when test="id='org.bedework.client.error.cannotchangecalmode'">
	        Forbidden: you are not allowed to change the mode of the non-empty
	        collection <em><xsl:value-of select="param"/></em>.
	      </xsl:when>
	      <xsl:when test="id='org.bedework.client.error.cannotdeletehome'">
	        Forbidden: you are not allowed to delete your calendar home.
	        <em><xsl:value-of select="param"/></em>.
	      </xsl:when>
	      <xsl:when test="id='org.bedework.client.error.cannotmovehome'">
	        Forbidden: you are not allowed to move your calendar home. */
	        <em><xsl:value-of select="param"/></em>.
	      </xsl:when>
	      <xsl:when test="id='org.bedework.client.error.choosegroupsuppressed'">
	        Error: choose group is suppressed.  You cannot perform that action at this time.
	      </xsl:when>
	      <xsl:when test="id='org.bedework.client.error.duplicatecategory'">
	        Cannot add: the category already exists.
	      </xsl:when>
	      <xsl:when test="id='org.bedework.client.error.duplicatecontact'">
	        Cannot add: the contact already exists.
	      </xsl:when>
	      <xsl:when test="id='org.bedework.client.error.duplicategroup'">
	        Error: duplicate group.  <em><xsl:value-of select="param"/></em> already exists.
	      </xsl:when>
	      <xsl:when test="id='org.bedework.client.error.duplicatelocation'">
	        Cannot add: the location already exists.
	      </xsl:when>
	      <xsl:when test="id='org.bedework.client.error.duplicateuid'">
	          Duplicate uid: this event already exists in this calendar.
	      </xsl:when>
	      <xsl:when test="id='org.bedework.client.error.failed.overrides'">
	          Error: there were <xsl:value-of select="param"/> failed overrides.
	      </xsl:when>
	      <xsl:when test="id='org.bedework.client.error.mail.norecipient'">
	        Error: the email has no recipient.
	      </xsl:when>
	      <xsl:when test="id='org.bedework.client.error.missingcalendarpath'">
	        Error: missing calendar path.
	      </xsl:when>
	      <xsl:when test="id='org.bedework.client.error.already.subscribed'">
	        You are already subscribed to that calendar.
	      </xsl:when>
	      <xsl:when test="id='org.bedework.client.error.missingeventkeyfields'">
	        Error: missing event key fields
	      </xsl:when>
	      <xsl:when test="id='org.bedework.client.error.missingfilename'">
	          You must supply a file name (required).
	      </xsl:when>
	      <xsl:when test="id='org.bedework.client.error.missingrequestpar'">
	          Missing request parameter<xsl:if test="param">: <em><xsl:value-of select="param"/></em></xsl:if>.
	      </xsl:when>
	      <xsl:when test="id='org.bedework.client.error.missingschedulewhat'">
	        Error: Missing scheduling what parameter.
	      </xsl:when>
	      <xsl:when test="id='org.bedework.client.error.multipleevents'">
	        System Error: Multiple events when one expected.
	      </xsl:when>
	      <xsl:when test="id='org.bedework.client.error.noaccess'">
	        Error: no access.
	      </xsl:when>
	      <xsl:when test="id='org.bedework.client.error.nocalsuiteaccess'">
	        Error: no access to calendar suite for group <em><xsl:value-of select="param"/></em>.
	      </xsl:when>
	      <xsl:when test="id='org.bedework.client.error.nodefaultview'">
	          No default view defined
	      </xsl:when>
	      <xsl:when test="id='org.bedework.client.error.norecurrenceinstances'">
	          There are no instances for this recurring event.
	      </xsl:when>
	      <xsl:when test="id='org.bedework.client.error.noschedulingaccess'">
	          You cannot schedule events with user <em><xsl:value-of select="param"/></em>.
	      </xsl:when>
	      <xsl:when test="id='org.bedework.client.error.ongrouppath'">
	        Error: group may not be added to itself.
	      </xsl:when>
	      <xsl:when test="id='org.bedework.client.error.onlyfrominbox'">
	        You can only respond from your inbox.
	      </xsl:when>
	      <xsl:when test="id='org.bedework.client.error.onlytoinbox'">
	        You can only reply to an inbox.
	      </xsl:when>
	      <xsl:when test="id='org.bedework.client.error.referenced.calendar'">
	        Cannot delete: the calendar is not empty.
	      </xsl:when>
	      <xsl:when test="id='org.bedework.client.error.referenced.category'">
	        Cannot delete: the category is referenced by events or collections.
	      </xsl:when>
	      <xsl:when test="id='org.bedework.client.error.referenced.contact'">
	        Cannot delete: the contact is referenced by events.
	      </xsl:when>
	      <xsl:when test="id='org.bedework.client.error.referenced.location'">
	        Cannot delete: the location is referenced by events.
	      </xsl:when>
	      <xsl:when test="id='org.bedework.client.error.referenced.subscription'">
	        Cannot delete: the subscription is included in view <em><xsl:value-of select="param"/></em>.<br/>
	        You must remove the subscription from this view before deleting.
	      </xsl:when>
	      <xsl:when test="id='org.bedework.error.timezones.readerror'">
	        Timzone error: could not read file.
	      </xsl:when>
	      <!-- things we cannot find -->
	      <xsl:when test="id='org.bedework.client.error.unknown.attendee'">
	          Unknown attendee <em><xsl:value-of select="param"/></em>
	      </xsl:when>
	      <xsl:when test="id='org.bedework.client.error.unknown.calendar'">
	        Not found: there is no calendar with the path <em><xsl:value-of select="param"/></em>.
	      </xsl:when>
	      <xsl:when test="id='org.bedework.client.error.unknown.calendarsuite'">
	        There is no calendar suite with the name <em><xsl:value-of select="param"/></em>.
	      </xsl:when>
	      <xsl:when test="id='org.bedework.client.error.unknown.calendartype'">
	        System error: there is no calendar with the type <em><xsl:value-of select="param"/></em>.
	      </xsl:when>
	      <xsl:when test="id='org.bedework.client.error.unknown.category'">
	        Not found: there is no category with the keyword <em><xsl:value-of select="param"/></em>.
	      </xsl:when>
	      <xsl:when test="id='org.bedework.client.error.unknown.contact'">
	        Not found: there is no contact <em><xsl:value-of select="param"/></em>.
	      </xsl:when>
	      <xsl:when test="id='org.bedework.client.error.unknown.event'">
	          Event <xsl:value-of select="param"/> does not exist.
	      </xsl:when>
	      <xsl:when test="id='org.bedework.client.error.unknown.group'">
	        Error: unknown group:  <em><xsl:value-of select="param"/></em>.
	      </xsl:when>
	      <xsl:when test="id='org.bedework.client.error.unknown.location'">
	        Not found: there is no location identified by the id <em><xsl:value-of select="param"/></em>.
	      </xsl:when>
	      <xsl:when test="id='org.bedework.client.error.unknown.subscription'">
	        Not found: there is no user identified by the name <em><xsl:value-of select="param"/></em>.
	      </xsl:when>
	      <xsl:when test="id='org.bedework.client.error.unknown.user'">
	        Not found: the user <em><xsl:value-of select="param"/></em> was not found.
	      </xsl:when>
	      <xsl:when test="id='org.bedework.client.error.unknown.userid'">
	        Not found: there is no user identified by the id <em><xsl:value-of select="param"/></em>.
	      </xsl:when>
	      <xsl:when test="id='org.bedework.client.error.unknown.view'">
	        Not found: there is no view identified by the name <em><xsl:value-of select="param"/></em>.
	      </xsl:when>
	      <xsl:when test="id='org.bedework.client.error.unknown.resource'">
	        Not found: there is no resource identified by the name <em><xsl:value-of select="param"/></em>.
	      </xsl:when>

	      <xsl:when test="id='org.bedework.client.error.viewnotadded'">
	        Error: the view was not added.
	      </xsl:when>

	      <!-- icalendar translation errors -->
	      <xsl:when test="id='org.bedework.exception.ical.noguid'">
	        An event must have a UID property.
	      </xsl:when>

	      <!-- Validation errors mostly dealing with incorrect or missing field values
	           that are explicitly under user control -->

	      <xsl:when test="id='org.bedework.validation.error.expectoneattendee'">
	        You must supply exactly one attendee.
	      </xsl:when>
	      <xsl:when test="id='org.bedework.validation.error.invalid.how'">
	        Error: bad ACL request (bad how setting).
	      </xsl:when>
	      <xsl:when test="id='org.bedework.validation.error.invalid.whotype'">
	        Error: bad who type (user or group).
	      </xsl:when>
	      <xsl:when test="id='org.bedework.validation.error.invalid.attendee'">
	          The attendee uri is invalid
	      </xsl:when>
	      <xsl:when test="id='org.bedework.validation.error.invalid.date'">
	          Bad or out-of-range date.
	      </xsl:when>
	      <xsl:when test="id='org.bedework.validation.error.invalid.duration'">
	        <em>Invalid duration</em> - you may not have a zero-length duration
	        for an all day event.
	      </xsl:when>
	      <xsl:when test="id='org.bedework.validation.error.invalid.endtype'">
	        The endtype <em><xsl:value-of select="param"/></em> is invalid.
	      </xsl:when>
	      <xsl:when test="id='org.bedework.validation.error.invalid.organizer'">
	          The organizer uri is invalid
	      </xsl:when>
	      <xsl:when test="id='org.bedework.validation.error.invalid.invalidschedulingobject'">
	          Cannot change this into a scheduling message
	      </xsl:when>
	      <xsl:when test="id='org.bedework.validation.error.invalid.prefendtype'">
	        The preferred endtype <em><xsl:value-of select="param"/></em> is invalid.
	      </xsl:when>
	      <xsl:when test="id='org.bedework.validation.error.invalid.prefusermode'">
	        The preferred user mode <em><xsl:value-of select="param"/></em> is invalid.
	      </xsl:when>
	      <xsl:when test="id='org.bedework.validation.error.invalid.prefworkdayend'">
	        Error: invalid working days end<xsl:if test="param">: <em><xsl:value-of select="param"/></em></xsl:if>
	      </xsl:when>
	      <xsl:when test="id='org.bedework.validation.error.invalid.prefworkdays'">
	        Error: invalid working days: start after end
	      </xsl:when>
	      <xsl:when test="id='org.bedework.validation.error.invalid.prefworkdaystart'">
	        Error: invalid working days start<xsl:if test="param">: <em><xsl:value-of select="param"/></em></xsl:if>
	      </xsl:when>
	      <xsl:when test="id='org.bedework.validation.error.invalid.recipient'">
	          The recipient uri is invalid
	      </xsl:when>
	      <xsl:when test="id='org.bedework.validation.error.invalid.recurcount'">
	        Error: bad value for recurrence count<xsl:if test="param">: <em><xsl:value-of select="param"/></em></xsl:if>
	      </xsl:when>
	      <xsl:when test="id='org.bedework.validation.error.invalid.recurcountanduntil'">
	        Error: Cannot specify count and until for recurrence
	      </xsl:when>
	      <xsl:when test="id='org.bedework.validation.error.invalid.recurinterval'">
	        Error: bad value for recurrence interval<xsl:if test="param">: <em><xsl:value-of select="param"/></em></xsl:if>
	      </xsl:when>
	      <xsl:when test="id='org.bedework.validation.error.invalid.recurrule'">
	        Error: bad recurrence rule<xsl:if test="param">: <em><xsl:value-of select="param"/></em></xsl:if>
	      </xsl:when>
	      <xsl:when test="id='org.bedework.validation.error.invalid.recuruntil'">
	        Error: bad value for recurrence until<xsl:if test="param">: <em><xsl:value-of select="param"/></em></xsl:if>
	      </xsl:when>
	      <xsl:when test="id='org.bedework.validation.error.cannot.change.method'">
	        Error: you cannot change scheduling method
	      </xsl:when>
	      <xsl:when test="id='org.bedework.validation.error.insubmissionscalendar'">
	        To publish this event, you must move it to a public calendar.  Please select a different calendar.
	      </xsl:when>
	      <xsl:when test="id='org.bedework.client.error.duplicateimage'">
	        Image with that name already uploaded.  Change the file's name, or use the "Overwrite" switch to replace it.
	      </xsl:when>
	      <xsl:when test="id='org.bedework.client.error.imageerror'">
	        The file you attempted to upload is not a recognized image format.  Use JPG, PNG, or GIF.
	      </xsl:when>
	      <xsl:when test="id='org.bedework.validation.error.toolarge'">
	        The file you attempted to upload is too large:  <em><xsl:value-of select="param[position() = 1]"/> bytes</em>.  Max size allowed: <xsl:value-of select="param[position() = 2]"/> bytes.
	      </xsl:when>

	      <!-- Scheduling error codes are defined in CalfacadeException -->

	      <xsl:when test="id='org.bedework.error.scheduling.attendeeaccessdisallowed'">
	         Error: Access is disallowed to one or more attendees.
	      </xsl:when>

	      <xsl:when test="id='org.bedework.error.scheduling.badttendees'">
	         Error: Attendee bad
	      </xsl:when>

	      <xsl:when test="id='org.bedework.error.scheduling.badmethod'">
	        Error: bad scheduling method (should be request or publish).
	      </xsl:when>

	      <xsl:when test="id='org.bedework.error.scheduling.badresponsemethod'">
	        Error: bad scheduling method for response (should be request or publish).
	      </xsl:when>

	      <xsl:when test="id='org.bedework.error.scheduling.badsourcecalendar'">
	         Error: event is not in inbox
	      </xsl:when>

	      <xsl:when test="id='org.bedework.error.scheduling.duplicateuid'">
	         Error: Duplicate uid found in the target calendar
	      </xsl:when>

	      <xsl:when test="id='org.bedework.error.scheduling.expectoneattendee'">
	         Error: Expected exactly one attendee for reply
	      </xsl:when>

	      <xsl:when test="id='org.bedework.error.scheduling.invalidpartstatus'">
	        Error: bad scheduling participation status
	      </xsl:when>

	      <xsl:when test="id='org.bedework.error.scheduling.multipleevents'">
	         Error: Multiple events were found in the target calendar
	      </xsl:when>

	      <xsl:when test="id='org.bedework.error.scheduling.noattendees'">
	         Error: Entity required attendees but had none.
	      </xsl:when>

	      <xsl:when test="id='org.bedework.error.scheduling.noOriginator'">
	         Error: Entity required originator but had none.
	      </xsl:when>

	      <xsl:when test="id='org.bedework.error.scheduling.norecipients'">
	         Error: Entity required recipients but had none.
	      </xsl:when>

	      <xsl:when test="id='org.bedework.error.scheduling.notattendee'">
	         Error: You are not an attendee of this meeting.
	      </xsl:when>

	      <xsl:when test="id='org.bedework.error.scheduling.unknownattendee'">
	         Error: Attendee for reply not in event.
	      </xsl:when>

	      <xsl:when test="id='org.bedework.error.scheduling.unknownevent'">
	        Error: Unknown event - organizer possibly deleted it?
	      </xsl:when>

	      <!--         End of scheduling            -->

	      <!--             Filters            -->

	      <xsl:when test="id='org.bedework.client.error.badfilter'">
	        Error: invalid filter definition<xsl:if test="param">: <em><xsl:value-of select="param"/></em></xsl:if>
	      </xsl:when>
	      <xsl:when test="id='org.bedework.client.error.badvpath'">
	        Error: bad virtual path<xsl:if test="param">: <em><xsl:value-of select="param"/></em></xsl:if>
	      </xsl:when>
	      <xsl:when test="id='org.bedework.client.error.unknown.filter'">
	        Error: unknown filter:  <em><xsl:value-of select="param"/></em>.
	      </xsl:when>
	      <xsl:when test="id='org.bedework.exception.filter.unexpected.eof'">
	        Filter error: Unexpected eof while parsing
	      </xsl:when>
	      <xsl:when test="id='org.bedework.exception.filter.expected.word'">
	        Filter error: expected a word found <em><xsl:value-of select="param"/></em>.
	      </xsl:when>
	      <xsl:when test="id='org.bedework.exception.filter.expected.openparen'">
	        Filter error: expected open paren
	      </xsl:when>
	      <xsl:when test="id='org.bedework.exception.filter.mixedlogicaloperators'">
	        Filter error: Cannot mix logical operators
	      </xsl:when>
	      <xsl:when test="id='org.bedework.exception.unknown.property'">
	        Filter error: unknown property <em><xsl:value-of select="param"/></em>.
	      </xsl:when>
	      <xsl:when test="id='org.bedework.exception.filter.badproperty'">
	        Filter error: Bad property value <em><xsl:value-of select="param"/></em>.
	      </xsl:when>
	      <xsl:when test="id='org.bedework.exception.filter.badoperator'">
	        Filter error: Bad operator <em><xsl:value-of select="param"/></em>.
	      </xsl:when>
	      <xsl:when test="id='org.bedework.exception.filter.syntax'">
	        Filter error: Syntax error
	      </xsl:when>
	      <xsl:when test="id='org.bedework.exception.filter.typeneedsand'">
	        Filter error: Type requires andop
	      </xsl:when>
	      <xsl:when test="id='org.bedework.exception.filter.badtype'">
	        Filter error: Bad type value <em><xsl:value-of select="param"/></em>.
	      </xsl:when>
	      <xsl:when test="id='org.bedework.exception.filter.typefirst'">
	        Filter error: Type must come first
	      </xsl:when>

	      <!--         End of filters            -->

	      <!-- Other error codes defined in CalfacadeException -->

	      <xsl:when test="id='org.bedework.exception.duplicatecalendar'">
	         Error: Duplicate calendar<xsl:if test="param">: <em><xsl:value-of select="param"/></em></xsl:if>
	      </xsl:when>

	      <xsl:when test="id='org.bedework.validation.error.invalid.status'">
	        Error: Invalid status<xsl:if test="param">: <em><xsl:value-of select="param"/></em></xsl:if>
	      </xsl:when>
	      <xsl:when test="id='org.bedework.validation.error.invalid.transparency'">
	        Error: Invalid transparency<xsl:if test="param">: <em><xsl:value-of select="param"/></em></xsl:if>
	      </xsl:when>
	      <xsl:when test="id='org.bedework.validation.error.invalid.uri'">
	        Error: Invalid URI<xsl:if test="param">: <em><xsl:value-of select="param"/></em></xsl:if>
	      </xsl:when>
	      <xsl:when test="id='org.bedework.validation.error.invalid.user'">
	        Error: Invalid user<xsl:if test="param">: <em><xsl:value-of select="param"/></em></xsl:if>
	      </xsl:when>

	      <xsl:when test="id='org.bedework.validation.error.missinghow'">
	        Error: missing how.
	      </xsl:when>

	      <xsl:when test="id='org.bedework.validation.error.missingwho'">
	        Error: missing who (principal name).
	      </xsl:when>

	      <xsl:when test="id='org.bedework.validation.error.missingaddress'">
	        Your information is incomplete: please supply an address.
	      </xsl:when>

	      <xsl:when test="id='org.bedework.validation.error.missingcalendar'">
	        Your information is incomplete: please supply a calendar.
	      </xsl:when>

	      <xsl:when test="id='org.bedework.validation.error.missingtopicalarea'">
	        Your information is incomplete: please supply at least one topical area.
	      </xsl:when>

	      <xsl:when test="id='org.bedework.validation.error.missingcalendarpath'">
	        Your information is incomplete: please supply a calendar path.
	      </xsl:when>

	      <xsl:when test="id='org.bedework.validation.error.missingcalsuitecalendar'">
	        Your information is incomplete: please supply a root calendar path.
	      </xsl:when>

	      <xsl:when test="id='org.bedework.validation.error.missingcategorykeyword'">
	        Your information is incomplete: please supply a category keyword.
	      </xsl:when>

	      <xsl:when test="id='org.bedework.validation.error.missingcontact'">
	        Your information is incomplete: please supply a contact.
	      </xsl:when>

	      <xsl:when test="id='org.bedework.validation.error.missingcontactname'">
	        You must enter a contact <em>name</em>.
	      </xsl:when>

	      <xsl:when test="id='org.bedework.validation.error.missingdescription'">
	        Your information is incomplete: please supply a description.
	      </xsl:when>

	      <xsl:when test="id='org.bedework.validation.error.missingeventowner'">
	        Your information is incomplete: please supply an event owner.
	      </xsl:when>

	      <xsl:when test="id='org.bedework.validation.error.missingfilterdef'">
	        Your information is incomplete: please supply a filter definition.
	      </xsl:when>

	      <xsl:when test="id='org.bedework.validation.error.missinggroupname'">
	        Your information is incomplete: please supply a group name.
	      </xsl:when>

	      <xsl:when test="id='org.bedework.validation.error.missinggroupowner'">
	        Your information is incomplete: please supply a group owner.
	      </xsl:when>

	      <xsl:when test="id='org.bedework.validation.error.missinglocation'">
	        Your information is incomplete: please supply a location.
	      </xsl:when>

	      <xsl:when test="id='org.bedework.validation.error.missingname'">
	        Your information is incomplete: please supply a name.
	      </xsl:when>

	      <xsl:when test="id='org.bedework.validation.error.missingclass'">
	        Your information is incomplete: please supply a class.
	      </xsl:when>

	      <xsl:when test="id='org.bedework.validation.error.missingcontenttype'">
	        Your information is incomplete: please supply a content type.
	      </xsl:when>

	      <xsl:when test="id='org.bedework.validation.error.missingtype'">
	        Your information is incomplete: please supply a type.
	      </xsl:when>

	      <xsl:when test="id='org.bedework.validation.error.missingorganizer'">
	        Your event is missing the organizer
	      </xsl:when>

	      <xsl:when test="id='org.bedework.validation.error.missingoriginator'">
	        Your event is missing the originator
	      </xsl:when>

	      <xsl:when test="id='org.bedework.validation.error.missingrecipients'">
	        You must supply a recipient.
	      </xsl:when>

	      <xsl:when test="id='org.bedework.validation.error.missingsubscriptionid'">
	        Your information is incomplete: please supply a subscription id.
	      </xsl:when>

	      <xsl:when test="id='org.bedework.exception.duplicatesubscription'">
	        Error: duplicate subscription.
	      </xsl:when>

	      <xsl:when test="id='org.bedework.validation.error.missingtitle'">
	        Your information is incomplete: please supply a title.
	      </xsl:when>

	      <xsl:when test="id='org.bedework.validation.error.missingsuburi'">
	        Your information is incomplete: please supply a uri for the subscription.
	      </xsl:when>

	      <xsl:when test="id='org.bedework.validation.error.startafterend'">
	        The <em>end date</em> occurs before the <em>start date</em>.
	      </xsl:when>

	      <xsl:when test="id='org.bedework.validation.error.toolong.description'">
	        Your description is too long.  Please limit your entry to
	          characters.  You may also wish to
	          point the event entry at a supplemental web page by entering a <em>URL</em>.
	      </xsl:when>

	      <xsl:when test="id='org.bedework.validation.error.toolong.name'">
	        Your name is too long.  Please limit your entry to
	      </xsl:when>

	      <xsl:when test="id='org.bedework.validation.error.toolong.summary'">
	        Your summary is too long.  Please limit your entry to
	          characters.  You may also wish to
	          point the event entry at a supplemental web page by entering a <em>URL</em>.
	      </xsl:when>
	      <xsl:otherwise>
	        <xsl:value-of select="id"/> = <xsl:value-of select="param"/>
	      </xsl:otherwise>
	    </xsl:choose>
    </p>
  </xsl:template>
</xsl:stylesheet>

