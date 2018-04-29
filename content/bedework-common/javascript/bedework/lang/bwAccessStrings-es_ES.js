/*
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

// JavsScript Access Control strings
// Spanish translations, es_ES 
// not yet translated

var authenticatedStr = "autenticado";
var unauthenticatedStr = "sin verificar";
var ownerStr = "owner";
var otherStr = "other";
var grantStr = "grant";
var denyStr = "deny"
var allStr = "all";

var bwAclWidgetDeleteStr = "remove";
var bwAclWidgetEntryStr = "Entry";
var bwAclWidgetAccessStr = "Access";
var bwAclWidgetInheritedStr = "Inherited from";

// note that resourcesRoot is passed in from the html head section defined in the xslt
var trashIcon = '<img src="' + imagesRoot + '/trashIcon.gif" width="13" height="13" border="0" alt="remove"/>';
var userIcon = '<img src="' + imagesRoot + '/userIcon.gif" width="13" height="13" border="0" alt="user"/>';
var groupIcon = '<img src="' + imagesRoot + '/groupIcon.gif" width="13" height="13" border="0" alt="group"/>';

// How granted accesses appear
var howAllVal = "all";

var howReadVal = "read";
var howReadAclVal = "read-acl";
var howReadCurPrivSetVal = "read-curprivset";
var howReadFreebusyVal = "read-freebusy ";

var howWriteVal = "write";
var howWriteAclVal = "write-acl";
var howWritePropertiesVal = "write-properties";
var howWriteContentVal = "write-content";

var howBindVal = "create";

/* Old scheduling */
var howScheduleVal = "schedule";
var howScheduleRequestVal = "schedule-request";
var howScheduleReplyVal = "schedule-reply";
var howScheduleFreebusyVal = "schedule-freebusy";

var howUnbindVal = "delete";

var howUnlockVal = "unlock";

var howScheduleDeliverVal = "schedule-deliver";
var howScheduleDeliverInviteVal = "schedule-deliver-invite";
var howScheduleDeliverReplyVal = "schedule-deliver-reply";
var howScheduleQueryFreebusyVal = "schedule-query-freebusy";

var howScheduleSendVal = "schedule-send";
var howScheduleSendInviteVal = "schedule-send-invite";
var howScheduleSendReplyVal = "schedule-send-reply";
var howScheduleSendFreebusyVal = "schedule-send-freebusy";

// How denied accesses appear
var howDenyAllVal = "none";

var howDenyReadVal = "not-read";
var howDenyReadAclVal = "not-read-acl";
var howDenyReadCurPrivSetVal = "not-read-curprivset";
var howDenyReadFreebusyVal = "not-read-freebusy ";

var howDenyWriteVal = "not-write";
var howDenyWriteAclVal = "not-write-acl";
var howDenyWritePropertiesVal = "not-write-properties";
var howDenyWriteContentVal = "not-write-content";

var howDenyBindVal = "not-create";
var howDenyScheduleVal = "not-schedule";
var howDenyScheduleRequestVal = "not-schedule-request";
var howDenyScheduleReplyVal = "not-schedule-reply";
var howDenyScheduleFreebusyVal = "not-schedule-freebusy";

var howDenyUnbindVal = "not-delete";

var howDenyUnlockVal = "not-unlock";

var howDenyScheduleDeliverVal = "not-schedule-deliver";
var howDenyScheduleDeliverInviteVal = "not-schedule-deliver-invite";
var howDenyScheduleDeliverReplyVal = "not-schedule-deliver-reply";
var howDenyScheduleQueryFreebusyVal = "not-schedule-query-freebusy";

var howDenyScheduleSendVal = "not-schedule-send";
var howDenyScheduleSendInviteVal = "not-schedule-send-invite";
var howDenyScheduleSendReplyVal = "not-schedule-send-reply";
var howDenyScheduleSendFreebusy = "not-schedule-send-freebusy";

//var howNoneVal = "none";

/* We shouldn't use the word local - it probably doesn't mean too much and it might actually be
   inherited from something called /local for example */
var inheritedStr = "not inherited";