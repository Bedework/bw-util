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
<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml">

  <!--  xsl:template name="headSection" -->
  <xsl:variable name="bwStr-Head-PageTitle">Bedework: Pers&#246;nlicher Kalender</xsl:variable>

  <!--  xsl:template name="messagesAndErrors" -->

  <!--  xsl:template name="headBar" -->
  <xsl:variable name="bwStr-HdBr-PublicCalendar">&#214;ffentlicher Kalender</xsl:variable>
  <xsl:variable name="bwStr-HdBr-PersonalCalendar">Pers&#246;nlicher Kalender</xsl:variable>
  <xsl:variable name="bwStr-HdBr-UniversityHome">Startseite Universit&#228;t</xsl:variable>
  <xsl:variable name="bwStr-HdBr-SchoolHome">Startseite Schule</xsl:variable>
  <xsl:variable name="bwStr-HdBr-OtherLink">Andere Verkn&#252;pfungen</xsl:variable>
  <xsl:variable name="bwStr-HdBr-ExampleCalendarHelp">Kalender Hilfe</xsl:variable>
  <xsl:variable name="bwStr-HdBr-Print">drucken</xsl:variable>
  <xsl:variable name="bwStr-HdBr-PrintThisView">Hilfe ausdrucken</xsl:variable>
  <xsl:variable name="bwStr-HdBr-RSS">RSS</xsl:variable>
  <xsl:variable name="bwStr-HdBr-RSSFeed">RSS feed</xsl:variable>

  <!--  xsl:template name="sideBar" -->
  <xsl:variable name="bwStr-SdBr-Views">Ansicht</xsl:variable>
  <xsl:variable name="bwStr-SdBr-NoViews">keine Ansicht</xsl:variable>
  <xsl:variable name="bwStr-SdBr-SubscribeToCalendarsOrICalFeeds">Abonnieren von Kalendern oder iCal Feeds</xsl:variable>
  <xsl:variable name="bwStr-SdBr-Subscribe">abonnieren</xsl:variable>
  <xsl:variable name="bwStr-SdBr-ManageCalendarsAndSubscriptions">Verwaltung Kalender und Abonnements</xsl:variable>
  <xsl:variable name="bwStr-SdBr-Manage">Verwaltung</xsl:variable>
  <xsl:variable name="bwStr-SdBr-Calendars">Kalender</xsl:variable>
  <xsl:variable name="bwStr-SdBr-Options">Optionen</xsl:variable>
  <xsl:variable name="bwStr-SdBr-Preferences">Voreinstellungen</xsl:variable>
  <xsl:variable name="bwStr-SdBr-UploadICal">Hochladen iCAL</xsl:variable>
  <xsl:variable name="bwStr-SdBr-AddrBook">Kontakte</xsl:variable>
  <xsl:variable name="bwStr-SdBr-ExportCalendars">Kalender herunterladen</xsl:variable>
  <xsl:variable name="bwStr-SdBr-UploadEvent">Veranstaltung(en) hochladen und importieren aus einer iCAL-Datei</xsl:variable>

  <!--  xsl:template name="tabs" -->
  <xsl:variable name="bwStr-Tabs-LoggedInAs">angemeldet als</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Logout">abmelden</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Day">TAG</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Week">WOCHE</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Month">MONAT</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Year">JAHR</xsl:variable>
  <xsl:variable name="bwStr-Tabs-List">LISTE</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Agenda">AGENDA</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Upcoming">AKTUELLE</xsl:variable>

  <!--  xsl:template name="navigation" -->
  <xsl:variable name="bwStr-Navi-WeekOf">Woche ab</xsl:variable>
  <xsl:variable name="bwStr-Navi-Go">Weiter</xsl:variable>
  <xsl:variable name="bwStr-Navi-Today">Heute</xsl:variable>
  <xsl:variable name="bwStr-Navi-Timezone">Zeitzone:</xsl:variable>

  <!--  xsl:template name="utilBar" -->
  <xsl:variable name="bwStr-Util-EventsTitle">Veranstaltung</xsl:variable>
  <xsl:variable name="bwStr-Util-Add">hinzuf&#252;gen...</xsl:variable>
  <xsl:variable name="bwStr-Util-View">Ansicht</xsl:variable>
  <xsl:variable name="bwStr-Util-DefaultView">Standardansicht</xsl:variable>
  <xsl:variable name="bwStr-Util-AllTopicalAreas">Alle Themengebiete</xsl:variable>
  <xsl:variable name="bwStr-Util-Search">Suchen</xsl:variable>
  <xsl:variable name="bwStr-Util-Go">weiter</xsl:variable>
  <xsl:variable name="bwStr-Util-List">LISTE</xsl:variable>
  <xsl:variable name="bwStr-Util-Cal">KALENDER</xsl:variable>
  <xsl:variable name="bwStr-Util-ToggleListCalView">Umschalten Listen-/Kalenderansicht</xsl:variable>
  <xsl:variable name="bwStr-Util-Summary">KURZFASSUNG</xsl:variable>
  <xsl:variable name="bwStr-Util-Details">DETAILS</xsl:variable>
  <xsl:variable name="bwStr-Util-ToggleSummDetView">Umschalten Kurzfassung/Detailansicht</xsl:variable>
  <xsl:variable name="bwStr-Util-ShowEvents">Anzeige Veranstaltung</xsl:variable>
  <xsl:variable name="bwStr-Util-Events">VERANSTALTUNGEN</xsl:variable>
  <xsl:variable name="bwStr-Util-ShowFreebusy">Anzeige Frei/Gebucht</xsl:variable>
  <xsl:variable name="bwStr-Util-Freebusy">FREI/GEBUCHT</xsl:variable>

  <!--  xsl:template name="actionIcons" -->
  <xsl:variable name="bwStr-Actn-AddEvent">Veranstalung hinzuf&#252;gen</xsl:variable>
  <xsl:variable name="bwStr-Actn-ScheduleMeeting">Sitzung einrichten</xsl:variable>
  <xsl:variable name="bwStr-Actn-AddTask">Aufgabe hinzuf&#252;gen</xsl:variable>
  <xsl:variable name="bwStr-Actn-ScheduleTask">Aufgabe einrichten</xsl:variable>
  <xsl:variable name="bwStr-Actn-Upload">hochladen</xsl:variable>
  <xsl:variable name="bwStr-Actn-UploadEvent">Veranstaltung hochladen</xsl:variable>

  <!--  xsl:template name="listView" -->
  <xsl:variable name="bwStr-LsVw-NoEventsToDisplay">Keine Veranstaltung anzeigbar.</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Add">hinzuf&#252;gen...</xsl:variable>
  <xsl:variable name="bwStr-LsVw-AllDay">ganzt&#228;gig</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Today">Heute</xsl:variable>
  <xsl:variable name="bwStr-LsVw-DownloadEvent">Veranstaltung herunterladen als ical - z.B. f&#252;r Outlook, PDAs, iCal oder andere Arbeitsplatz-Kalender</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Description">Beschreibung</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Canceled">ANNULIERT:</xsl:variable>
  <xsl:variable name="bwStr-LsVw-NoTitle">kein Titel</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Contact">Kontakt:</xsl:variable>

  <!--  <xsl:template name="eventLinks" -->
  <xsl:variable name="bwStr-EvLn-EditMaster">Haupteintrag bearbeiten (wiederkehrende Veranstaltung)</xsl:variable>
  <xsl:variable name="bwStr-EvLn-All">Jeder</xsl:variable>
  <xsl:variable name="bwStr-EvLn-Instance">Eintrag</xsl:variable>
  <xsl:variable name="bwStr-EvLn-EditInstance">Eintrag bearbeiten (wiederkehrende Veranstaltung)</xsl:variable>
  <xsl:variable name="bwStr-EvLn-Edit">Bearbeiten</xsl:variable>
  <xsl:variable name="bwStr-EvLn-EditEvent">Veranstaltung bearbeiten</xsl:variable>
  <xsl:variable name="bwStr-EvLn-EditColon">Bearbeiten:</xsl:variable>
  <xsl:variable name="bwStr-EvLn-Link">Verkn&#252;pfung</xsl:variable>
  <xsl:variable name="bwStr-EvLn-DeleteColon">L&#246;schen:</xsl:variable>
  <xsl:variable name="bwStr-EvLn-DeleteMaster">Haupteintrag l&#246;schen (wiederkehrende Veranstaltung)</xsl:variable>
  <xsl:variable name="bwStr-EvLn-DeleteThisEvent">Diese Veranstaltung l&#246;schen?</xsl:variable>
  <xsl:variable name="bwStr-EvLn-DeleteEvent">Veranstaltung l&#246;schen</xsl:variable>
  <xsl:variable name="bwStr-EvLn-DeleteAllRecurrences">Alle wiederkehrenden Eintr&#228;ge von dieser Veranstaltung l&#246;schen?</xsl:variable>
  <xsl:variable name="bwStr-EvLn-DeleteInstance">Eintrag l&#246;schen (wiederkehrende Veranstaltung)</xsl:variable>
  <xsl:variable name="bwStr-EvLn-Delete">L&#246;schen</xsl:variable>
  <xsl:variable name="bwStr-EvLn-AddEventReference">Veranstaltung hinzuf&#252;gen als Verweis auf einen Kalender</xsl:variable>


  <!-- xsl:template match="events" mode="eventList" -->
  <xsl:variable name="bwStr-LsEv-Upcoming">Aktuelle Veranstaltungen</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Next7Days">N&#228;chsten 7 Tage</xsl:variable>
  <xsl:variable name="bwStr-LsEv-NoEventsToDisplay">Keine Veranstaltung darstellbar</xsl:variable>
  <xsl:variable name="bwStr-LsEv-DownloadEvent">Veranstaltung herunterladen als ical - z.B. f&#252;r Outlook, PDAs, iCal oder andere Arbeitsplatz-Kalender</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Categories">Kategorien:</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Contact">Kontakt:</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Canceled">ANNULIERT:</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Tentative">ENTWURF:</xsl:variable>
  <xsl:variable name="bwStr-LsEv-GoToDay">zum heutigen Tag wechseln</xsl:variable>

  <!-- xsl:template name="weekView" -->

  <!-- xsl:template name="monthView" -->
<!-- // TODO (cont) ? -->
  <!-- xsl:template match="event" mode="calendarLayout" -->
  <xsl:variable name="bwStr-EvCG-Canceled">ANNULIERT:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Tentative">ENTWURF:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Cont">(laufend)</xsl:variable>
  <xsl:variable name="bwStr-EvCG-AllDayColon">ganzt&#228;gig:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-NoTitle">kein Titel</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Time">Zeit:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-AllDay">ganzt&#228;gig</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Location">Veranstaltungsort:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-TopicalArea">Themengebiet:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Calendar">Kalender:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Type">Typ:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Task">Aufgabe</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Meeting">Sitzung</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Event">Veranstaltung</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Recurring">wiederkehrend</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Personal">pers&#246;nliche</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Public">&#214;ffentliche</xsl:variable>
  <xsl:variable name="bwStr-EvCG-ViewDetails">Detailansicht</xsl:variable>
  <xsl:variable name="bwStr-EvCG-DownloadEvent">Veranstaltung herunterladen als ical - z.B. f&#252;r Outlook, PDAs, iCal oder andere Arbeitsplatz-Kalender</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Download">Herunterladen</xsl:variable>
  <xsl:variable name="bwStr-EvCG-DownloadMaster">Haupteintrag herunterladen (wiederkehrende Veranstaltung)</xsl:variable>
  <xsl:variable name="bwStr-EvCG-DownloadThisInstance">Diesen Eintrag herunterladen (wiederkehrende Veranstaltung)</xsl:variable>
  <xsl:variable name="bwStr-EvCG-All">jeden</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Instance">Eintrag</xsl:variable>
  <xsl:variable name="bwStr-EvCG-EditColon">Bearbeiten:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-EditMaster">Haupteintrag bearbeiten (wiederkehrende Veranstaltung)</xsl:variable>
  <xsl:variable name="bwStr-EvCG-EditThisInstance">Diesen Eintrag bearbeiten (wiederkehrende Veranstaltung)</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Edit">Bearbeiten</xsl:variable>
  <xsl:variable name="bwStr-EvCG-EditEvent">Veranstaltung bearbeiten</xsl:variable>
  <xsl:variable name="bwStr-EvCG-CopyColon">Kopieren:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-CopyMaster">Haupteintrag kopieren (wiederkehrende Veranstaltung)</xsl:variable>
  <xsl:variable name="bwStr-EvCG-CopyThisInstance">Diesen Eintrag kopieren (wiederkehrende Veranstaltung)</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Copy">Kopieren</xsl:variable>
  <xsl:variable name="bwStr-EvCG-CopyEvent">Veranstaltung kopieren</xsl:variable>
  <xsl:variable name="bwStr-EvCG-LinkColon">Verkn&#252;pfung:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Link">Verkn&#252;pfung</xsl:variable>
  <xsl:variable name="bwStr-EvCG-DeleteColon">L&#246;schen:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-DeleteThisEvent">Diese Veranstaltung l&#246;schen?</xsl:variable>
  <xsl:variable name="bwStr-EvCG-DeleteAllRecurrences">Alle wiederkehrenden Einträge dieser Veranstaltung l&#246;schen?</xsl:variable>
  <xsl:variable name="bwStr-EvCG-DeleteMaster">Haupteintrag l&#246;schen (wiederkehrende Veranstaltung)</xsl:variable>
  <xsl:variable name="bwStr-EvCG-DeleteThisInstance">Einzelnen Eintrag &#246;schen (wiederkehrende Veranstaltung)</xsl:variable>
  <xsl:variable name="bwStr-EvCG-DeleteEvent">Veranstaltung l&#246;schen</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Delete">L&#246;schen</xsl:variable>
  <xsl:variable name="bwStr-EvCG-AddMasterEventReference">Hauptveranstaltung als Verweis in meinen Kalender hinzuf&#252;gen</xsl:variable>
  <xsl:variable name="bwStr-EvCG-AddThisEventReference">Diese Veranstaltung als Verweis in meinen Kalender hinzuf&#252;gen</xsl:variable>
  <xsl:variable name="bwStr-EvCG-AddEventReference">Veranstaltung als Verweis in meinen Kalender hinzuf&#252;gen</xsl:variable>

  <!-- <xsl:template name="yearView" -->

  <!-- <xsl:template match="month" -->

  <!-- <xsl:template name="tasks" -->
  <xsl:variable name="bwStr-Task-Tasks">Aufgabe</xsl:variable>
  <xsl:variable name="bwStr-Task-Reminders">Erinnerungen</xsl:variable>

  <!-- <xsl:template match="event" mode="tasks" -->
  <xsl:variable name="bwStr-TskE-NoTitle">kein Titel</xsl:variable>
  <xsl:variable name="bwStr-TskE-Start">Start:</xsl:variable>
  <xsl:variable name="bwStr-TskE-Due">F&#228;lligkeit:</xsl:variable>

  <!-- <xsl:template match="event" mode="schedNotifications" -->

  <!-- <xsl:template match="event" -->
  <xsl:variable name="bwStr-SgEv-GenerateLinkToThisEvent">Verkn&#252;pfung zu dieser Veranstaltung erzeugen</xsl:variable>
  <xsl:variable name="bwStr-SgEv-LinkToThisEvent">Verkn&#252;pfung zu dieser Veranstaltung</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Canceled">ANNULIERT:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Event">Veranstaltung</xsl:variable>
  <xsl:variable name="bwStr-SgEv-NoTitle">kein Titel</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Delete">L&#246;schen</xsl:variable>
  <xsl:variable name="bwStr-SgEv-DeleteThisEvent">Diese Veranstaltung l&#246;schen?</xsl:variable>
  <xsl:variable name="bwStr-SgEv-DeleteAllRecurrences">Alle Wiederholungen dieses Ereignisses l&#246;schen?</xsl:variable>
  <xsl:variable name="bwStr-SgEv-DeleteMaster">Hauptveranstaltung (Dauerveranstaltung)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-DeleteThisInstance">Diesen Eintrag l&#246;schen (Dauerveranstaltung)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-DeleteEvent">Veranstaltung l&#246;schen</xsl:variable>
  <xsl:variable name="bwStr-SgEv-All">jeden</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Instance">Eintrag</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Link">Verkn&#252;pfung</xsl:variable>
  <xsl:variable name="bwStr-SgEv-AddMasterEvent">Hauptveranstaltung hinzuf&#252;gen als Verweis auf einen Kalender</xsl:variable>
  <xsl:variable name="bwStr-SgEv-AddThisEvent">Diesen Eintrag hinzuf&#252;gen als Verweis auf einen Kalender</xsl:variable>
  <xsl:variable name="bwStr-SgEv-AddEventReference">Veranstaltung hinzuf&#252;gen als Verweis auf einen Kalender</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Copy">Kopieren</xsl:variable>
  <xsl:variable name="bwStr-SgEv-CopyMaster">Haupteintrag kopieren (wiederkehrende Veranstaltung)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-CopyThisInstance">Diesen Eintrag kopieren (wiederkehrende Veranstaltung)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-CopyEvent">Veranstaltung kopieren</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Edit">Bearbeiten</xsl:variable>
  <xsl:variable name="bwStr-SgEv-EditMaster">Haupteintrag bearbeiten (wiederkehrende Veranstaltung)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-EditThisInstance">Diesen Eintrag bearbeiten (wiederkehrende Veranstaltung)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-EditEvent">Veranstaltung bearbeiten</xsl:variable>
  <xsl:variable name="bwStr-SgEv-DownloadEvent">Veranstaltung herunterladen als ical - z.B. f&#252;r Outlook, PDAs, iCal oder andere Arbeitsplatz-Kalender</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Download">Herunterladen</xsl:variable>
  <xsl:variable name="bwStr-SgEv-DownloadMaster">Haupteintrag herunterladen (wiederkehrende Veranstaltung)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-DownloadThisInstance">Diesen Eintrag herunterladen (wiederkehrende Veranstaltung)</xsl:variable>

  <xsl:variable name="bwStr-SgEv-Task">Aufgabe</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Meeting">Sitzung</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Event">Veranstaltung</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Recurring">Wiederkehrend</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Public">&#214;ffentlich</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Personal">Pers&#246;nlich</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Organizer">Veranstalter:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-RecurrenceMaster">Stammeintrag Dauerveranstaltung</xsl:variable>
  <xsl:variable name="bwStr-SgEv-When">Wann:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-AllDay">(ganzt&#228;gig)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-FloatingTime">Jeweilige Zeitzone</xsl:variable>
  <xsl:variable name="bwStr-SgEv-LocalTime">Ortszeit</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Start">Start:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-End">Ende:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-AddToMyCalendar">Eintragen in Pers&#246;nlicher Kalender</xsl:variable>
  <xsl:variable name="bwStr-SgEv-AddEventToMyCalendar">Veranstaltung eintragen in Pers&#246;nlicher Kalender</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Where">Wo:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Complete">% Vollst&#228;ndig:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-ORGANIZER">Veranstalter:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Description">Beschreibung:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-STATUS">Status:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Attendees">Teilnehmer:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Attendee">Teilnehmer</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Role">Funktion</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Status">Status</xsl:variable>
  <xsl:variable name="bwStr-SgEv-ChangeMyStatus">Status &#228;ndern</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Cost">Kosten:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-See">Einsehen:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Contact">Kontakt:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Calendar">Kalender:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Categories">Kategorien:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Comments">Kommentar:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-TopicalArea">Themengebiete:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Email">Email</xsl:variable>

  <!-- <xsl:template match="formElements" mode="addEvent" -->
  <xsl:variable name="bwStr-AddE-AddTask">Hinzuf&#252;gen Aufgabe</xsl:variable>
  <xsl:variable name="bwStr-AddE-AddEvent">Hinzuf&#252;gen Veranstaltung</xsl:variable>
  <xsl:variable name="bwStr-AddE-AddMeeting">Hinzuf&#252;gen Sitzung</xsl:variable>

  <!--  <xsl:template match="formElements" mode="editEvent" -->
  <xsl:variable name="bwStr-EdtE-EditTask">Bearbeiten Aufgabe</xsl:variable>
  <xsl:variable name="bwStr-EdtE-EditEvent">Bearbeiten Veranstaltung</xsl:variable>
  <xsl:variable name="bwStr-EdtE-EditMeeting">Bearbeiten Sitzung</xsl:variable>

  <!--  <xsl:template match="formElements" mode="eventForm" -->
  <xsl:variable name="bwStr-AEEF-Delete">L&#246;schen</xsl:variable>
  <xsl:variable name="bwStr-AEEF-DeleteMaster">Haupteintrag l&#246;schen (wiederkehrende Veranstaltung)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-DeleteThisEvent">Diesen Eintrag l&#246;schen?</xsl:variable>
  <xsl:variable name="bwStr-AEEF-DeleteAllRecurrences">Alle Wiederholungen von diesem Eintrag l&#246;schen?</xsl:variable>
  <xsl:variable name="bwStr-AEEF-DeleteThisInstance">Einzelnen Eintrag l&#246;schen (wiederkehrende Veranstaltung)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-DeleteEvent">Veranstaltung l&#246;schen</xsl:variable>
  <xsl:variable name="bwStr-AEEF-All">Jeden</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Instance">Eintrag</xsl:variable>
  <xsl:variable name="bwStr-AEEF-View">Ansicht</xsl:variable>
  <xsl:variable name="bwStr-AEEF-TASK">Aufgabe</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Meeting">Sitzung</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EVENT">Veranstaltung</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Recurring">Wiederkehrend</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Personal">Pers&#246;nlich</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Public">&#214;ffentlich</xsl:variable>
  <xsl:variable name="bwStr-AEEF-RecurrenceMaster">Stammeintrag Dauerveranstaltung</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Basic">Einfach</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Details">Details</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Recurrence">Wiederholungen</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Scheduling">Terminplanung</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Meetingtab">Sitzungsplanung</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Calendar">Kalender:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Title">Titel:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-DateAndTime">Datum &amp; Zeit:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-AllDay">ganzt&#228;gig</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Floating">gleitend</xsl:variable>
  <xsl:variable name="bwStr-AEEF-StoreAsUTC">ablegen in UTC</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Start">Start:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Date">Datum</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Due">F&#228;lligkeit:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-End">Ende:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Duration">Dauer</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Duration-Sched">Dauer:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Days">Tage</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Hours">Stunden</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Minutes">Minuten</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Or">oder</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Weeks">Wochen</xsl:variable>
  <xsl:variable name="bwStr-AEEF-This">Diese</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Task">Aufgabe</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Event">Veranstaltung</xsl:variable>
  <xsl:variable name="bwStr-AEEF-HasNoDurationEndDate">hat kein Ende / Enddatum</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Complete">% Vollst&#228;ndig:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-AffectsFreeBusy">Betrifft frei/gebucht:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Yes">ja</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Transparent">(transparent: Veranstaltung betrifft deinen Status von Frei/Gebucht nicht)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-No">nein</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Opaque">(deckend: Veranstaltung betrifft deinen Status von Frei/Gebucht)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Categories">Kategorien:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-NoCategoriesDefined">Keine Kategorien definiert</xsl:variable>
  <xsl:variable name="bwStr-AEEF-AddCategory">Kategorie hinzuf&#252;gen</xsl:variable>
  <xsl:variable name="bwStr-AEEF-SelectTimezone">Zeitzone aussuchen...</xsl:variable>
  <xsl:variable name="bwStr-AEEF-PickPrevious">&#171; W&#228;hlen Zurück</xsl:variable>
  <xsl:variable name="bwStr-AEEF-PickNext">W&#228;hlen Weiter &#187;</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Options">Optionen &#x25BC;</xsl:variable>
  <xsl:variable name="bwStr-AEEF-24Hours">24 Stunden</xsl:variable>
  <xsl:variable name="bwStr-AEEF-FromTheEnd">ab Ende</xsl:variable>

  <!-- Details tab (3153)-->
  <xsl:variable name="bwStr-AEEF-Location">Veranstaltungsort:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Choose">aussuchen:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Select">w&#228;hlen...</xsl:variable>
  <xsl:variable name="bwStr-AEEF-OrAddNew">oder neu hinzuf&#252;gen:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EventLink">Verweis zur Veranstaltung:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Description">Beschreibung:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Status">Status:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Confirmed">best&#228;tigt</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Tentative">vorl&#228;ufig</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Canceled">annulliert</xsl:variable>

  <!-- Recurrence tab (3292)-->
  <xsl:variable name="bwStr-AEEF-ThisEventRecurrenceInstance">Diese Veranstaltung hat wiederkehrende Eintr&#228;ge.</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EditMasterEvent">Hauptveranstaltung bearbeiten</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EditMaster">Hautpeintrag bearbeiten (wiederkehrende Veranstaltung)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EventRecurs">Veranstaltung wiederholt sich</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EventDoesNotRecur">Veranstaltung wiederholt sich nicht</xsl:variable>

  <!-- wrapper for all recurrence fields (rrules and rdates): -->
  <xsl:variable name="bwStr-AEEF-RecurrenceRules">Wiederholungsregeln</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ChangeRecurrenceRules">Wiederholungsregeln bearbeiten</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ShowAdvancedRecurrenceRules">Erweiterte Wiederholungsregeln anzeigen</xsl:variable>
  <xsl:variable name="bwStr-AEEF-And">und</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EVERY">Jeden</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Every">jeden</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Day">Tag(e)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Hour">Stunde(n)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Month">Monat(e)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Week">Woche(n)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Year">Jahr(e)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-On">am</xsl:variable>
  <xsl:variable name="bwStr-AEEF-In">in</xsl:variable>
  <xsl:variable name="bwStr-AEEF-OnThe">an dem</xsl:variable>
  <xsl:variable name="bwStr-AEEF-InThe">in dem</xsl:variable>
  <xsl:variable name="bwStr-AEEF-TheFirst">Ersten</xsl:variable>
  <xsl:variable name="bwStr-AEEF-TheSecond">Zweiten</xsl:variable>
  <xsl:variable name="bwStr-AEEF-TheThird">Dritten</xsl:variable>
  <xsl:variable name="bwStr-AEEF-TheFourth">Vierten</xsl:variable>
  <xsl:variable name="bwStr-AEEF-TheFifth">F&#252;nften</xsl:variable>
  <xsl:variable name="bwStr-AEEF-TheLast">Letzten</xsl:variable>
  <xsl:variable name="bwStr-AEEF-DayOfTheMonth">Tag(e) im Monat</xsl:variable>
  <xsl:variable name="bwStr-AEEF-DayOfTheYear">Tag(e) im Jahr</xsl:variable>
  <xsl:variable name="bwStr-AEEF-WeekOfTheYear">Woche(n) im Jahr</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Repeating">wiederholen</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Forever">andauernd</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Until">bis</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Time">Zeit(en)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Frequency">Frequenz:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-None">kein</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Daily">t&#228;glich</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Weekly">w&#246;chentlich</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Monthly">monatlich</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Yearly">j&#228;hrlich</xsl:variable>
  <xsl:variable name="bwStr-AEEF-NoRecurrenceRules">keine Wiederholungsregeln</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Repeat">Wiederholung:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Interval">Intervall:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-InTheseMonths">in diesem Monaten:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-WeekOn">Woche(n) am</xsl:variable>
  <xsl:variable name="bwStr-AEEF-SelectWeekdays">Wochentage ausw&#228;hlen</xsl:variable>
  <xsl:variable name="bwStr-AEEF-SelectWeekends">Wochenenden ausw&#228;hlen</xsl:variable>
  <xsl:variable name="bwStr-AEEF-WeekStart">Wochenbeginn:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-OnTheseDays">an diesen Tagen:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-OnTheseDaysOfTheMonth">an diesen Tagen im Monat:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-InTheseWeeksOfTheYear">an diesen Wochen im Jahr:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-OnTheseDaysOfTheYear">an diesen Tagen im Jahr:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-RecurrenceAndExceptionDates">Tage mit Wiederholungen und Ausnahmen</xsl:variable>
  <xsl:variable name="bwStr-AEEF-RecurrenceDates">Wiederholungstag</xsl:variable>
  <xsl:variable name="bwStr-AEEF-NoRecurrenceDates">Kein Wiederholungstag</xsl:variable>
  <xsl:variable name="bwStr-AEEF-TIME">Zeit</xsl:variable>
  <xsl:variable name="bwStr-AEEF-TZid">Zeitzone</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ExceptionDates">Ausnahmetag</xsl:variable>
  <xsl:variable name="bwStr-AEEF-NoExceptionDates">kein Ausnahmetag</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ExceptionDatesMayBeCreated">Ausnahmetage k&#246;nnen erzeugt werden wenn ein wiederkehrender Eintrag gel&#246;scht wird.</xsl:variable>
  <xsl:variable name="bwStr-AEEF-AddRecurance">hinzuf&#252;gen Wiederholung</xsl:variable>
  <xsl:variable name="bwStr-AEEF-AddException">hinzuf&#252;gen Ausnahme</xsl:variable>

  <!-- Access tab -->

  <!-- Scheduling tab -->
  <xsl:variable name="bwStr-AEEF-EditAttendees">Teilnehmer bearbeiten</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ChangeMyStatus">Meinen Status &#228;ndern</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ScheduleThisTask">Aufgabe mit anderen Teilnehmern zusammen planen</xsl:variable>
  <xsl:variable name="bwStr-AEEF-MakeIntoMeeting">Sitzung planen - Teilnehmer einladen</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Save">abspeichern</xsl:variable>
  <xsl:variable name="bwStr-AEEF-SaveDraft">abspeichern Vorlage</xsl:variable>
  <xsl:variable name="bwStr-AEEF-SaveAndSendInvites">senden</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Clear">Nachricht vom Eingang entfernen</xsl:variable>

  <!-- xsl:template match="val" mode="weekMonthYearNumbers" -->

  <!-- xsl:template name="byDayChkBoxList" -->

  <!-- xsl:template name="buildCheckboxList" -->

  <!-- xsl:template name="recurrenceDayPosOptions" -->
  <xsl:variable name="bwStr-RCPO-TheFirst">Erster</xsl:variable>
  <xsl:variable name="bwStr-RCPO-TheSecond">Zweiter</xsl:variable>
  <xsl:variable name="bwStr-RCPO-TheThird">Dritter</xsl:variable>
  <xsl:variable name="bwStr-RCPO-TheFourth">Vierter</xsl:variable>
  <xsl:variable name="bwStr-RCPO-TheFifth">F&#252;nfter</xsl:variable>
  <xsl:variable name="bwStr-RCPO-TheLast">Letzter</xsl:variable>
  <xsl:variable name="bwStr-RCPO-Every">Jeder</xsl:variable>
  <xsl:variable name="bwStr-RCPO-None">Keiner</xsl:variable>

  <!-- xsl:template name="buildRecurFields" -->
  <xsl:variable name="bwStr-BuRF-And">und</xsl:variable>

  <!-- xsl:template name="buildNumberOptions" -->

  <!-- xsl:template name="clock" -->
  <xsl:variable name="bwStr-Cloc-Bedework24HourClock">Bedework 24-Stunden Uhrzeit</xsl:variable>
  <xsl:variable name="bwStr-Cloc-Type">Typ</xsl:variable>
  <xsl:variable name="bwStr-Cloc-SelectTime">zeit aussuchen</xsl:variable>
  <xsl:variable name="bwStr-Cloc-Switch">umschalten</xsl:variable>
  <xsl:variable name="bwStr-Cloc-Close">schliessen</xsl:variable>
  <xsl:variable name="bwStr-Cloc-CloseClock">Uhr schliessenk</xsl:variable>

  <!-- xsl:template name="newclock" -->
  <xsl:variable name="bwStr-Cloc-Hour">Stunde</xsl:variable>
  <xsl:variable name="bwStr-Cloc-Minute">Minute</xsl:variable>
  <xsl:variable name="bwStr-Cloc-AM">am</xsl:variable>
  <xsl:variable name="bwStr-Cloc-PM">pm</xsl:variable>

  <!-- xsl:template name="attendees" -->
  <xsl:variable name="bwStr-Atnd-Continue">weiter</xsl:variable>
  <xsl:variable name="bwStr-Atnd-SchedulMeetingOrTask">Ansetzen Sitzung oder Aufgabe</xsl:variable>
  <xsl:variable name="bwStr-Atnd-AddAttendees">Teilnehmer hinzuf&#252;gen</xsl:variable>
  <xsl:variable name="bwStr-Atnd-Add">hinzuf&#252;gen</xsl:variable>
  <xsl:variable name="bwStr-Atnd-Recipients">Empf&#228;nger</xsl:variable>
  <xsl:variable name="bwStr-Atnd-Attendee">Teilnehmer</xsl:variable>
  <xsl:variable name="bwStr-Atnd-Attendees">Teilnehmer</xsl:variable>
  <xsl:variable name="bwStr-Atnd-RoleColon">Funktion:</xsl:variable>
  <xsl:variable name="bwStr-Atnd-Role">Funktion</xsl:variable>
  <xsl:variable name="bwStr-Atnd-StatusColon">Status:</xsl:variable>
  <xsl:variable name="bwStr-Atnd-Status">Status</xsl:variable>
  <xsl:variable name="bwStr-Atnd-RequiredParticipant">erforderlicher Beteiligter</xsl:variable>
  <xsl:variable name="bwStr-Atnd-OptionalParticipant">optionaler Beteiligter</xsl:variable>
  <xsl:variable name="bwStr-Atnd-Chair">Vorsitz</xsl:variable>
  <xsl:variable name="bwStr-Atnd-NonParticipant">Unbeteiligter</xsl:variable>
  <xsl:variable name="bwStr-Atnd-NeedsAction">Handlungsbedarf</xsl:variable>
  <xsl:variable name="bwStr-Atnd-Accepted">angenommen</xsl:variable>
  <xsl:variable name="bwStr-Atnd-Declined">abgelehnt</xsl:variable>
  <xsl:variable name="bwStr-Atnd-Tentative">vorl&#228;ufig</xsl:variable>
  <xsl:variable name="bwStr-Atnd-Delegated">delegiert</xsl:variable>
  <xsl:variable name="bwStr-Atnd-Remove">entfernen</xsl:variable>

  <!-- xsl:template match="partstat" -->
  <xsl:variable name="bwStr-ptst-NeedsAction">Handlungsbedarf</xsl:variable>
  <xsl:variable name="bwStr-ptst-Accepted">angenommen</xsl:variable>
  <xsl:variable name="bwStr-ptst-Declined">abgelehnt</xsl:variable>
  <xsl:variable name="bwStr-ptst-Tentative">vorl&#228;ufig</xsl:variable>
  <xsl:variable name="bwStr-ptst-Delegated">delegiert</xsl:variable>

  <!-- xsl:template match="freebusy" mode="freeBusyGrid"  -->
  <xsl:variable name="bwStr-FrBu-FreebusyFor">Frei/Gebucht f&#252;r</xsl:variable>
  <xsl:variable name="bwStr-FrBu-AllAttendees">alle Teilnehmer</xsl:variable>
  <xsl:variable name="bwStr-FrBu-AM">vorm.</xsl:variable>
  <xsl:variable name="bwStr-FrBu-PM">mitt.</xsl:variable>
  <xsl:variable name="bwStr-FrBu-Busy">gebucht</xsl:variable>
  <xsl:variable name="bwStr-FrBu-Tentative">vorl&#228;ufig</xsl:variable>
  <xsl:variable name="bwStr-FrBu-Free">frei</xsl:variable>
  <xsl:variable name="bwStr-FrBu-AllFree">alles Frei</xsl:variable>

  <!-- xsl:template match="attendees" -->
  <!-- Stings defined above -->

  <!-- xsl:template match="recipients"-->
  <xsl:variable name="bwStr-Rcpt-Recipient">Empf&#228;nger</xsl:variable>
  <xsl:variable name="bwStr-Rcpt-Recipients">Empf&#228;nger</xsl:variable>
  <xsl:variable name="bwStr-Rcpt-Remove">entfernen</xsl:variable>

  <!-- xsl:template match="event" mode="addEventRef" -->
  <!-- some strings defined above -->
  <xsl:variable name="bwStr-AEEF-AddEventReference">Verweis auf die Veranstaltung hinzuf&#252;gen</xsl:variable>
  <xsl:variable name="bwStr-AEEF-AddEventSubscription">Abonnement auf die Veranstaltung hinzuf&#252;gen</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EventColon">Veranstaltung:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-NoTitle">kein Titel</xsl:variable>
  <xsl:variable name="bwStr-AEEF-IntoCalendar">In den Kalender:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-DefaultCalendar">Standardkalender</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Cancel">Abbrechen</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Continue">Weiter</xsl:variable>

  <!-- xsl:template match="freebusy" mode="freeBusyPage" -->
  <xsl:variable name="bwStr-FrBu-YouMayShareYourFreeBusy">Sie k&#246;nnen ihre Frei/Gebucht Informationen f&#252;r einzelnen Benutzer oder Gruppen freigeben indem sie das Zugriffsrecht "read freebusy" auf einzelne Kalender entsprechend eintragen. Um ihre Frei/Gebucht Informationen generell freizugeben richten sie das Zugriffsrecht "read freebusy" auf ihren Startordner ein.</xsl:variable>
  <xsl:variable name="bwStr-FrBu-FreeBusy">Frei / Gebucht</xsl:variable>
  <xsl:variable name="bwStr-FrBu-ViewUsersFreeBusy">Ansehen Benutzer frei/gebucht:</xsl:variable>

  <!-- xsl:template name="categoryList" -->
  <xsl:variable name="bwStr-Ctgy-ManagePreferences">Voreinstellungen bearbeiten</xsl:variable>
  <xsl:variable name="bwStr-Ctgy-General">Generell</xsl:variable>
  <xsl:variable name="bwStr-Ctgy-Categories">Kategorien</xsl:variable>
  <xsl:variable name="bwStr-Ctgy-Locations">Veranstaltungsort</xsl:variable>
  <xsl:variable name="bwStr-Ctgy-SchedulingMeetings">Terminplanung/Sitzung</xsl:variable>
  <xsl:variable name="bwStr-Ctgy-ManageCategories">Verwalten Kategorien</xsl:variable>
  <xsl:variable name="bwStr-Ctgy-Type">Hinzuf&#252;gen neue Kategorie</xsl:variable>
  <xsl:variable name="bwStr-Ctgy-NoCategoriesDefined">Keine Kategorie definiert</xsl:variable>

  <!-- xsl:template name="modCategory" -->
  <xsl:variable name="bwStr-MCat-ManagePreferences">Voreinstellungen bearbeiten</xsl:variable>
  <xsl:variable name="bwStr-MCat-General">Generell</xsl:variable>
  <xsl:variable name="bwStr-MCat-Categories">Kategorien</xsl:variable>
  <xsl:variable name="bwStr-MCat-Locations">Veranstaltungsort</xsl:variable>
  <xsl:variable name="bwStr-MCat-SchedulingMeetings">Terminplanung/Sitzung</xsl:variable>
  <xsl:variable name="bwStr-MCat-AddCategory">Hinzuf&#252;gen Kategorie</xsl:variable>
  <xsl:variable name="bwStr-MCat-EditCategory">Bearbeiten Category</xsl:variable>
  <xsl:variable name="bwStr-MCat-UpdateCategory">Aktualisieren Kategorie</xsl:variable>
  <xsl:variable name="bwStr-MCat-DeleteCategory">L&#246;schen Kategorie</xsl:variable>
  <xsl:variable name="bwStr-MCat-Keyword">Keyword:</xsl:variable>
  <xsl:variable name="bwStr-MCat-Description">Beschreibung:</xsl:variable>
  <xsl:variable name="bwStr-MCat-Cancel">Abbrechen</xsl:variable>

  <!--  xsl:template name="deleteCategoryConfirm" -->
  <xsl:variable name="bwStr-DlCC-OKtoDeleteCategory">Wollen sie diese Kategorie l&#246;schen?</xsl:variable>
  <xsl:variable name="bwStr-DlCC-DeleteCategory">L&#246;schen Kategorie</xsl:variable>
  <xsl:variable name="bwStr-DlCC-Keyword">Schl&#252;sselwort:</xsl:variable>
  <xsl:variable name="bwStr-DlCC-Description">Beschreibung:</xsl:variable>
  <xsl:variable name="bwStr-DlCC-YesDeleteCategory">Ja: Delete Category</xsl:variable>
  <xsl:variable name="bwStr-DlCC-NoCancel">Nein: Abbrechen</xsl:variable>

  <!--  xsl:template match="calendars" mode="manageCalendars" -->
  <xsl:variable name="bwStr-Cals-ManageCalendarsSubscriptions">Verwalten Kalender &amp; Abonnements</xsl:variable>
  <xsl:variable name="bwStr-Cals-Calendars">Kalender</xsl:variable>

  <!--  xsl:template match="calendar" mode="myCalendars"  -->

  <!--  xsl:template match="calendar" mode="mySpecialCalendars" -->
  <xsl:variable name="bwStr-Cals-IncomingSchedulingRequests">Eingang Terminplanung</xsl:variable>
  <xsl:variable name="bwStr-Cals-OutgoingSchedulingRequests">Ausgang Terminplanung</xsl:variable>

  <!--  xsl:template match="calendar" mode="listForUpdate"  -->
  <xsl:variable name="bwStr-Cals-Update">aktualisieren</xsl:variable>
  <xsl:variable name="bwStr-Cals-AddCalendarOrFolder">Hinzuf&#252;gen zu einem Kalender oder Ordner</xsl:variable>

  <!--  xsl:template match="calendar" mode="listForDisplay"  -->
  <xsl:variable name="bwStr-Cals-Display">Anzeige</xsl:variable>

  <!--  xsl:template name="selectCalForEvent" -->
  <xsl:variable name="bwStr-SCfE-SelectACalendar">Kalender ausw&#228;hlen</xsl:variable>
  <xsl:variable name="bwStr-SCfE-NoWritableCals">Kalender nicht schreibbar</xsl:variable>
  <xsl:variable name="bwStr-SCfE-Close">schliessen</xsl:variable>

  <!--  xsl:template match="calendar" mode="selectCalForEventCalTree" -->

  <!--  xsl:template name="selectCalForPublicAlias" -->
  <xsl:variable name="bwStr-SCPA-SelectACalendar">Kalender ausw&#228;hlen</xsl:variable>
  <xsl:variable name="bwStr-SCPA-Close">schliessen</xsl:variable>

  <!--  xsl:template match="calendar" mode="selectCalForPublicAliasCalTree" -->

  <!--  xsl:template match="currentCalendar" mode="addCalendar" -->
  <xsl:variable name="bwStr-CuCa-AddCalOrFolder">Hinzuf&#252;gen Kalender oder Ordner</xsl:variable>
  <xsl:variable name="bwStr-CuCa-AddSubscription">Hinzuf&#252;gen Abonnement</xsl:variable>
  <xsl:variable name="bwStr-CuCa-AddCalFolderOrSubscription">Hinzuf&#252;gen Kalender, Ordner oder Abonnement</xsl:variable>
  <xsl:variable name="bwStr-CuCa-AddCalText">hinzuf&#252;gen</xsl:variable>
  <xsl:variable name="bwStr-CuCa-AddCalTextLabel">Hinzuf&#252;gen:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-AddSubText">Hinzuf&#252;gen abonnement</xsl:variable>
  <xsl:variable name="bwStr-CuCa-HttpStatus">HTTP Status:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Name">Name:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Summary">Kurzfassung:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Description">Beschreibung:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Color">Farbe:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Display">Anzeige:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-DisplayItemsInThisCollection">Element in dieser Sammlung anzeigen</xsl:variable>
  <xsl:variable name="bwStr-CuCa-FilterExpression">Filterausdr&#252;cke:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Type">Typ:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Calendar">Kalender</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Folder">Ordner</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Subscription">Abonnement</xsl:variable>
  <xsl:variable name="bwStr-CuCa-SubscriptionType">Abonnementstyp:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-PublicCalendar">&#214;ffentlicher Kalender</xsl:variable>
  <xsl:variable name="bwStr-CuCa-UserCalendar">Pers&#246;nlicher Kalender</xsl:variable>
  <xsl:variable name="bwStr-CuCa-URL">URL</xsl:variable>
  <xsl:variable name="bwStr-CuCa-SelectAPublicCalOrFolder">&#214;ffentlichen Kalender oder Ordner ausw&#228;hlen</xsl:variable>
  <xsl:variable name="bwStr-CuCa-UsersID">Benutzerkennung:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-CalendarPath">Kalender Pfad:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-DefaultCalendarOrSomeCalendar">z.B. "calendar" (Standard) or "Mein Ordner / Mein Kalender"</xsl:variable>
  <xsl:variable name="bwStr-CuCa-URLToCalendar">URL vom Kalender:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-ID">ID (sofern ben&#246;tigt):</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Password">Kennwort (sofern ben&#246;tigt):</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Sharing">Calendar Sharing</xsl:variable>
  <xsl:variable name="bwStr-CuCa-ShareWith">Share calendar with:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-SharePlaceholder">enter a user account</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Share">share</xsl:variable>
  <xsl:variable name="bwStr-CuCa-DefaultSchedNotShared">This calendar is the default scheduling calendar; it may not be shared.</xsl:variable>
  <xsl:variable name="bwStr-CuCa-CurrentAccess">Aktuelle Zugriffsrechte:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-SharingMayBeAdded">Anmerkung: Eine gemeinsame Benutzung kann erst hinzugef&#252;gt werden, nachdem der Kalender eingerichtet wurde.</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Add">Hinzuf&#252;gen</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Cancel">Abbrechen</xsl:variable>

  <!--  xsl:template match="currentCalendar" mode="modCalendar -->
  <xsl:variable name="bwStr-CuCa-ModifySubscription">Ver&#228;ndern Abonnement</xsl:variable>
  <xsl:variable name="bwStr-CuCa-ModifyFolder">Ver&#228;ndern Ordner</xsl:variable>
  <xsl:variable name="bwStr-CuCa-ModifyCalendar">Ver&#228;ndern Kalender</xsl:variable>
  <xsl:variable name="bwStr-CuCa-UpdateSubscription">Aktualisieren Abonnement</xsl:variable>
  <xsl:variable name="bwStr-CuCa-UpdateFolder">Aktualisieren Ordner</xsl:variable>
  <xsl:variable name="bwStr-CuCa-UpdateCalendar">Aktualisieren Kalender</xsl:variable>
  <xsl:variable name="bwStr-CuCa-DeleteSubscription">L&#246;schen Abonnement</xsl:variable>
  <xsl:variable name="bwStr-CuCa-DeleteFolder">L&#246;schen Ordner</xsl:variable>
  <xsl:variable name="bwStr-CuCa-DeleteCalendar">L&#246;schen Kalender</xsl:variable>
  <xsl:variable name="bwStr-CuCa-AdvancedOptions">advanced options</xsl:variable>
  <xsl:variable name="bwStr-CuCa-BasicOptions">basic options</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Cancel">Abbrechen</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Disabled">Deaktiviert:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-DisabledLabel">deaktiviert</xsl:variable>
  <xsl:variable name="bwStr-CuCa-EnabledLabel">aktiviert</xsl:variable>
  <xsl:variable name="bwStr-CuCa-ThisItemIsInaccessible">Dieser Eintrag nicht zugreifbar und wurde gesperrt. Sie m&#252;ssen in reaktivieren und k&#246;nnen es dann erneut versuchen.</xsl:variable>
  <xsl:variable name="bwStr-CuCa-FilterExpression">Filterausdr&#252;cke:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Sharing">Calendar Sharing</xsl:variable>
  <xsl:variable name="bwStr-CuCa-ShareWith">Share calendar with:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-SharePlaceholder">enter a user account</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Share">share</xsl:variable>
  <xsl:variable name="bwStr-CuCa-SuggestedName">Suggested name:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-SharedBy">Shared by</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Status">Status</xsl:variable>
  <xsl:variable name="bwStr-CuCa-WriteAccess">Write access</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Remove">Remove</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Pending">pending</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Declined">declined</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Accepted">accepted</xsl:variable>
  <xsl:variable name="bwStr-CuCa-DefaultSchedNotShared">This calendar is the default scheduling calendar; it may not be shared.</xsl:variable>
  <xsl:variable name="bwStr-CuCa-CurrentAccess">Aktuelle Zugriffsrechte:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-AccessNote"><p><strong>Anmerkung:</strong> Advanced access controls can break standard sharing.</p><p>Wenn sie f&#252;r einen anderen Benutzer Vollzugriff auf einen Kalender gew&#228;hren und sie wollen die vom anderen Benutzer in ihren Kalender eingetragenen Termine bearbeiten k&#246;nnen,<strong>dann m&#252;ssen sie sich selber ebenfalls Vollzugriff auf ihren eigenen Kalender eintragen.</strong> Tragen sie bitte ihre eigenen Benutzerkennung als Benutzer im Feld "Who" ein und w&#228;hlen sie "All" aus im Feld "Rights". Dies liegt an der Standard Rechteverwaltung. Der genaue Grund wieso sie Eintr&#228;ge von anderen Benutzern in ihrem eigenen (freigegebenen) Kalender sonst nicht sehen k&#246;nnen liegt darin, dass Eintr&#228;ge von zu Veranstaltungen immer mit dem Zugriffsrecht "owner" (Eigner) versehen ist und somit in ihrem Kalender auch die Eintr&#228;ge der anderen Benutzer auch den anderen Benutzern geh&#246;ren.</p></xsl:variable>
  <xsl:variable name="bwStr-CuCa-WriteAccess">grant write access</xsl:variable>

  <!-- notifications.xsl -->
  <xsl:variable name="bwStr-Notif-SharingInvitation">Sharing Invitation</xsl:variable>
  <xsl:variable name="bwStr-Notif-SharingReply">Sharing Reply</xsl:variable>
  <xsl:variable name="bwStr-Notif-SharingRemoval">Sharing Removal</xsl:variable>
  <xsl:variable name="bwStr-Notif-NotificationFrom">Notification from</xsl:variable>
  <xsl:variable name="bwStr-Notif-InviteFrom">Invitation from</xsl:variable>
  <xsl:variable name="bwStr-Notif-ReplyFrom">Reply from</xsl:variable>
  <xsl:variable name="bwStr-Notif-TheUser">The user</xsl:variable>
  <xsl:variable name="bwStr-Notif-HasInvited">has invited you to share the calendar</xsl:variable>
  <xsl:variable name="bwStr-Notif-HasRemoved">has removed sharing to the calendar</xsl:variable>
  <xsl:variable name="bwStr-Notif-Reject">reject</xsl:variable>
  <xsl:variable name="bwStr-Notif-Accept">accept</xsl:variable>
  <xsl:variable name="bwStr-Notif-CalendarName">Calendar Name:</xsl:variable>
  <xsl:variable name="bwStr-Notif-HasAccepted">has <strong>accepted</strong> your invitation to share</xsl:variable>
  <xsl:variable name="bwStr-Notif-HasDeclined">has <strong>declined</strong> your invitation to share</xsl:variable>
  <xsl:variable name="bwStr-Notif-Clear">clear</xsl:variable>

  <!--  xsl:template name="colorPicker"  -->
  <xsl:variable name="bwStr-CoPi-Pick">ausw&#228;hlen</xsl:variable>
  <xsl:variable name="bwStr-CoPi-UseDefaultColors">Standardfarben verwenden</xsl:variable>
  <xsl:variable name="bwStr-CoPi-SelectColor">Bitte eine Farbe ausw&#228;hlen</xsl:variable>

<!--  xsl:template name="calendarList"  -->
  <xsl:variable name="bwStr-CaLi-ManagingCalendars">Verwaltung von Kalendern &amp; Abonnements</xsl:variable>
  <xsl:variable name="bwStr-CaLi-SelectFromCalendar">W&#228;hlen sie ein Symbol im Kalenderbaum links aus f&#252;r Anpassungen der Kalender</xsl:variable>
  <xsl:variable name="bwStr-CaLi-Subscription">Abonnements</xsl:variable>
  <xsl:variable name="bwStr-CaLi-OrFolder"> oder Ordner</xsl:variable>
  <xsl:variable name="bwStr-CaLi-Select">Ausw&#228;hlen vom Symbol</xsl:variable>
  <xsl:variable name="bwStr-CaLi-Icon">um einen neuen Kalender, Abonnement oder Ordner zum Verzeichnisbaum hinzuzuf&#252;gen.</xsl:variable>
  <xsl:variable name="bwStr-CaLi-Folders">Ordner k&#246;nnen nur Kalender oder Unterordner enthalten.</xsl:variable>
  <xsl:variable name="bwStr-CaLi-Calendars">Kalender k&#246;nnen nur Veranstaltungen enthalten (und andere Kalendereintr&#228;ge).</xsl:variable>

  <!--  xsl:template name="calendarDescriptions"  -->
  <xsl:variable name="bwStr-CaDe-CalInfo">Kalender Informatioenn</xsl:variable>
  <xsl:variable name="bwStr-CaDe-SelectAnItem">W&#228;hlen sie einen Eintrag vom Kalenderbaum auf der linken Seite aus um alle Information &#252;ber den Kalender oder Ordner einsehen zu k&#246;nnen. Die Verzeichnisstruktur auf der linken Seite zeigt die Kalender Rangordnung an.</xsl:variable>
  <xsl:variable name="bwStr-CaDe-AllCalDescriptions">Beschreibungen aller Kalender:</xsl:variable>
  <xsl:variable name="bwStr-CaDe-Name">Name</xsl:variable>
  <xsl:variable name="bwStr-CaDe-Description">Beschreibung</xsl:variable>

  <!--  xsl:template match="currentCalendar" mode="displayCalendar"  -->
  <xsl:variable name="bwStr-CuCa-CalendarInformation">Kalendar Information</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Path">Pfad:</xsl:variable>
  <!-- The rest found above -->

  <!--  xsl:template match="currentCalendar" mode="deleteCalendarConfirm"  -->
  <xsl:variable name="bwStr-CuCa-YesDeleteFolder">Ja: L&#246;sch Ordner!</xsl:variable>
  <xsl:variable name="bwStr-CuCa-YesDeleteCalendar">Ja: L&#246;sch Kalender!</xsl:variable>
  <xsl:variable name="bwStr-CuCa-TheFollowingFolder">Der folgende Ordner <em>und sein ganzer Inhalt</em> wird gel&#246;scht.  Weiter?</xsl:variable>
  <xsl:variable name="bwStr-CuCa-TheFollowingCalendar">Der folgende Kalender <em>und sein ganzer Inhalt</em> wird gel&#246;scht.  Weiter?</xsl:variable>
  <!-- The rest found above -->

  <!--  xsl:template match="calendars" mode="exportCalendars" -->
  <xsl:variable name="bwStr-Cals-ExportCals">Kalender herunterladen als iCal</xsl:variable>
  <xsl:variable name="bwStr-Cals-CalendarToExport">Kalender zum herunterladen:</xsl:variable>
  <xsl:variable name="bwStr-Cals-Name">Name:</xsl:variable>
  <xsl:variable name="bwStr-Cals-Path">Pfad:</xsl:variable>
  <xsl:variable name="bwStr-Cals-EventDateLimits">Befristung:</xsl:variable>
  <xsl:variable name="bwStr-Cals-TodayForward">ab Heute</xsl:variable>
  <xsl:variable name="bwStr-Cals-AllDates">ganzt&#228;gig</xsl:variable>
  <xsl:variable name="bwStr-Cals-DateRange">Zeitraum</xsl:variable>
  <xsl:variable name="bwStr-Cals-Start"><strong>Start:</strong></xsl:variable>
  <xsl:variable name="bwStr-Cals-End"><strong>Ende:</strong></xsl:variable>
  <xsl:variable name="bwStr-Cals-MyCalendars">Pers&#246;nlicher Kalender</xsl:variable>

  <!--  xsl:template match="calendar" mode="buildExportTree"  -->

  <!--  xsl:template name="subsMenu"  -->
  <xsl:variable name="bwStr-SuMe-AddSubs">Hinzuf&#252;gen Abonnement</xsl:variable>
  <xsl:variable name="bwStr-SuMe-SubscribeTo">Abonnieren von:</xsl:variable>
  <xsl:variable name="bwStr-SuMe-PublicCal">ein &#246;ffentlicher Kalender (in this system)</xsl:variable>
  <xsl:variable name="bwStr-SuMe-UserCal">ein pers&#246;nlicher Kalender (in this system)</xsl:variable>
  <xsl:variable name="bwStr-SuMe-ExternalFeed">ein externes iCal Feed (z.B. Google, Eventful, etc)</xsl:variable>
  <xsl:variable name="bwStr-SuMe-SubscribeToPublicCalendar">Abonnieren von einem &#246;ffentlichen Kalender</xsl:variable>
  <xsl:variable name="bwStr-SuMe-SubscribeToUserCalendar">Abonnieren von einem pers&#246;nlichen Kalender</xsl:variable>
  <xsl:variable name="bwStr-SuMe-SubscribeToExternalCalendar">Abonnieren von einem externen Kalender</xsl:variable>

  <!--  xsl:template name="addPublicAlias"  -->
  <xsl:variable name="bwStr-AdPA-SubscribeToPublicCal">Abonnieren von eimem &#246;ffentlichen Kalender</xsl:variable>
  <xsl:variable name="bwStr-AdPA-AddPublicSubscription">Hinzuf&#252;gen von einem &#246;ffentlichen Abonnement</xsl:variable>
  <xsl:variable name="bwStr-AdPA-SubscriptionNote">*ein Abonnementsname darf nur einmal vorkommen</xsl:variable>
  <xsl:variable name="bwStr-AdPA-Calendar">Kalender:</xsl:variable>
  <xsl:variable name="bwStr-AdPA-Name">Name:</xsl:variable>
  <xsl:variable name="bwStr-AdPA-AffectsFreeBusy">Betrifft Frei/Gebucht:</xsl:variable>
  <xsl:variable name="bwStr-AdPA-Yes">ja</xsl:variable>
  <xsl:variable name="bwStr-AdPA-No">nein</xsl:variable>
  <xsl:variable name="bwStr-AdPA-Style">Stil:</xsl:variable>
  <xsl:variable name="bwStr-AdPA-Default">default</xsl:variable>
  <xsl:variable name="bwStr-AdPA-AddSubscription">Hinzuf&#252;gen Abonnement</xsl:variable>
  <xsl:variable name="bwStr-AdPA-Cancel">Abbrechen</xsl:variable>

  <!--  xsl:template match="calendar" mode="subscribe" -->
  <xsl:variable name="bwStr-Calr-Folder">Ordner</xsl:variable>
  <xsl:variable name="bwStr-Calr-Calendar">Kalender</xsl:variable>

  <!--  xsl:template name="addAlias" -->
  <xsl:variable name="bwStr-AddA-SubscribeToUserCal">Abonnement von einem pers&#246;nlichen Kalender</xsl:variable>
  <xsl:variable name="bwStr-AddA-SubscriptionMustBeUnique">*ein Abonnementsname darf nur einmal vorkommen</xsl:variable>
  <xsl:variable name="bwStr-AddA-Name">Name:</xsl:variable>
  <xsl:variable name="bwStr-AddA-UserID">Benutzerkennung:</xsl:variable>
  <xsl:variable name="bwStr-AddA-ExJaneDoe">Bs.p: susis007</xsl:variable>
  <xsl:variable name="bwStr-AddA-CalendarPath">Kalendar Pfad:</xsl:variable>
  <xsl:variable name="bwStr-AddA-ExCalendar">Bsp.: Rechenzentrum Kurse</xsl:variable>
  <xsl:variable name="bwStr-AddA-AddSubscription">Hinzuf&#252;gen Abonnement</xsl:variable>
  <xsl:variable name="bwStr-AddA-Cancel">Abbrechen</xsl:variable>
  <xsl:variable name="bwStr-AddA-AffectsFreeBusy">Betrifft Frei/Gebucht:</xsl:variable>
  <xsl:variable name="bwStr-AddA-Yes">ja</xsl:variable>
  <xsl:variable name="bwStr-AddA-No">nein</xsl:variable>
  <xsl:variable name="bwStr-AddA-Style">Stil:</xsl:variable>
  <xsl:variable name="bwStr-AddA-Default">Standard</xsl:variable>
  <xsl:variable name="bwStr-AddA-NoteAboutAccess"><ul class="note" style="margin-left: 2em;">
      <li>Sie m&#252;ssen mindestens Lesezugriff auf den Kalender eines anderen Benutzers eingerichtet bekommen haben um ihn abbonieren zu k&#246;nnen.</li>
      <li>Als <strong>Name</strong> w&#228;hlen sie einen beliebigen Begriff wie sie das Abbonement nennen wollen.</li>
      <li>Als <strong>Benutzerkennung</strong> mussen sie die Benutzerkennung vom Eigner des Kalenders nehmen die in der Kalendersoftware verwendet wird</li>
      <li>Als <strong>Pfad</strong> ist der Name vom Ordner und/oder Kalender in der Kalenderstruktur vom Eigner zu nehmen.  Als Beispiel wenn sie ein Abbonement für susis007/MeinOrdner/MeinKalender einrichten wollen dann nehmen sie "MeinOrdner/MeinKalender". Um sich die Startordner von susis007 von abonnieren lassen sie dieses Feld einfach leer.</li>
      <li>Sie k&#246;nnen ihre eigenen Kalender abbonieren um diese zu Gruppen und Sammlungen zusammen zu schliessen und damit das Teilen mit anderen zu vereinfachen.</li></ul></xsl:variable>

  <!--  xsl:template match="subscription" mode="modSubscription" (Deprecated: Strings left in place)-->

  <!--  xsl:template name="subscriptionList" (Deprecated: Strings left in place)-->

  <!--  xsl:template match="subscription" mode="mySubscriptions" (Deprecated: Strings left in place)-->

  <!--  xsl:template name="subInaccessible" (Deprecated: Strings left in place)-->

  <!--  xsl:template name="alarmOptions" -->
  <xsl:variable name="bwStr-AlOp-AlarmOptions">Alarm Optionen</xsl:variable>
  <xsl:variable name="bwStr-AlOp-AlarmDateTime">Alarm Datum/Uhrzeit:</xsl:variable>
  <xsl:variable name="bwStr-AlOp-At">am</xsl:variable>
  <xsl:variable name="bwStr-AlOp-OrBeforeAfterEvent">oder vor/nach einem Termin:</xsl:variable>
  <xsl:variable name="bwStr-AlOp-Days">Tage</xsl:variable>
  <xsl:variable name="bwStr-AlOp-Hours">Stunden</xsl:variable>
  <xsl:variable name="bwStr-AlOp-Minutes">Minuten</xsl:variable>
  <xsl:variable name="bwStr-AlOp-SecondsOr">Sekunden ODER:</xsl:variable>
  <xsl:variable name="bwStr-AlOp-Weeks">Wochen</xsl:variable>
  <xsl:variable name="bwStr-AlOp-Before">vor</xsl:variable>
  <xsl:variable name="bwStr-AlOp-After">nach</xsl:variable>
  <xsl:variable name="bwStr-AlOp-Start">Start</xsl:variable>
  <xsl:variable name="bwStr-AlOp-End">Ende</xsl:variable>
  <xsl:variable name="bwStr-AlOp-EmailAddress">Emailadresse:</xsl:variable>
  <xsl:variable name="bwStr-AlOp-Subject">Betreff:</xsl:variable>
  <xsl:variable name="bwStr-AlOp-Continue">Weiter</xsl:variable>
  <xsl:variable name="bwStr-AlOp-Cancel">Abbrechen</xsl:variable>

  <!--  xsl:template name="upload" -->
  <xsl:variable name="bwStr-Upld-AffectsFreeBusy">Betrifft Frei/Gebucht:</xsl:variable>
  <xsl:variable name="bwStr-Upld-Yes">ja</xsl:variable>
  <xsl:variable name="bwStr-Upld-Transparent">(transparent: Veranstaltung betrifft deinen Status von Frei/Gebucht nicht)</xsl:variable>
  <xsl:variable name="bwStr-Upld-StripAlarms">Alarm bei Trennung:</xsl:variable>
  <xsl:variable name="bwStr-Upld-No">nein</xsl:variable>
  <xsl:variable name="bwStr-Upld-Opaque">(deckend: Veranstaltung betrifft deinen Status von Frei/Gebucht)</xsl:variable>
  <xsl:variable name="bwStr-Upld-UploadICalFile">Hochladen iCAL Datei</xsl:variable>
  <xsl:variable name="bwStr-Upld-Filename">Dateiname:</xsl:variable>
  <xsl:variable name="bwStr-Upld-IntoCalendar">In den Kalender:</xsl:variable>
  <xsl:variable name="bwStr-Upld-DefaultCalendar">Standardkalender</xsl:variable>
  <xsl:variable name="bwStr-Upld-AcceptEventsSettings">Einstellungen der Veranstaltung akzeptieren</xsl:variable>
  <xsl:variable name="bwStr-Upld-Status">Status:</xsl:variable>
  <xsl:variable name="bwStr-Upld-AcceptEventsStatus">Status der Veranstaltung akzeptieren</xsl:variable>
  <xsl:variable name="bwStr-Upld-Confirmed">best&#228;tigt</xsl:variable>
  <xsl:variable name="bwStr-Upld-Tentative">vorl&#228;ufig</xsl:variable>
  <xsl:variable name="bwStr-Upld-Canceled">Abbruch</xsl:variable>
  <xsl:variable name="bwStr-Upld-Continue">Weiter</xsl:variable>
  <xsl:variable name="bwStr-Upld-Cancel">Abbrechen</xsl:variable>

  <!--  xsl:template name="emailOptions" -->
  <xsl:variable name="bwStr-EmOp-UpdateEmailOptions">Email Einstellungen aktualisieren</xsl:variable>
  <xsl:variable name="bwStr-EmOp-EmailAddress">Emailadresse:</xsl:variable>
  <xsl:variable name="bwStr-EmOp-Subject">Betreff:</xsl:variable>
  <xsl:variable name="bwStr-EmOp-Continue">Weiter</xsl:variable>
  <xsl:variable name="bwStr-EmOp-Cancel">Abbrechen</xsl:variable>

  <!--  xsl:template name="locationList" -->
  <xsl:variable name="bwStr-LocL-ManagePreferences">Verwaltung Voreinstellungen</xsl:variable>
  <xsl:variable name="bwStr-LocL-General">generell</xsl:variable>
  <xsl:variable name="bwStr-LocL-Categories">Kategorien</xsl:variable>
  <xsl:variable name="bwStr-LocL-Locations">Veranstaltungsorte</xsl:variable>
  <xsl:variable name="bwStr-LocL-SchedulingMeetings">Terminplanung/Sitzungen</xsl:variable>
  <xsl:variable name="bwStr-LocL-ManageLocations">Verwaltung Veranstaltungsorte</xsl:variable>
  <xsl:variable name="bwStr-LocL-AddNewLocation">Hinzuf&#252;gen neuen Veranstaltungsort</xsl:variable>

  <!--  xsl:template name="modLocation" -->
  <xsl:variable name="bwStr-ModL-ManagePreferences">Verwaltung Voreinstellungen</xsl:variable>
  <xsl:variable name="bwStr-ModL-General">generell</xsl:variable>
  <xsl:variable name="bwStr-ModL-Categories">Kategorien</xsl:variable>
  <xsl:variable name="bwStr-ModL-Locations">Veranstaltungsorte</xsl:variable>
  <xsl:variable name="bwStr-ModL-SchedulingMeetings">Terminplanung/Sitzungen</xsl:variable>
  <xsl:variable name="bwStr-ModL-AddLocation">Hinzuf&#252;gen Veranstaltungsort</xsl:variable>
  <xsl:variable name="bwStr-ModL-EditLocation">Bearbeiten Veranstaltungsort</xsl:variable>
  <xsl:variable name="bwStr-ModL-MainAddress">Hauptanschrift:</xsl:variable>
  <xsl:variable name="bwStr-ModL-SubAddress">weitere Anschriften:</xsl:variable>
  <xsl:variable name="bwStr-ModL-LocationLink">Veranstaltungsort Verweis:</xsl:variable>
  <xsl:variable name="bwStr-ModL-SubmitLocation">Anlegen Veranstaltungsort</xsl:variable>
  <xsl:variable name="bwStr-ModL-DeleteLocation">L&#246;schen Veranstaltungsort</xsl:variable>
  <xsl:variable name="bwStr-ModL-Cancel">Abbrechen</xsl:variable>

  <!--  xsl:template name="deleteLocationConfirm" -->
  <xsl:variable name="bwStr-OKDL-OKToDeleteLocation">Ok, l&#246;schen von diesem Veranstaltungsort?</xsl:variable>
  <xsl:variable name="bwStr-OKDL-DeleteLocation">L&#246;schen Veranstaltungsort</xsl:variable>
  <xsl:variable name="bwStr-OKDL-MainAddress">Hauptanschrift:</xsl:variable>
  <xsl:variable name="bwStr-OKDL-Subaddress">weitere Anschriften:</xsl:variable>
  <xsl:variable name="bwStr-OKDL-LocationLink">Veranstaltungsort Verweis:</xsl:variable>
  <xsl:variable name="bwStr-OKDL-YesDeleteLocation">Ja: L&#246;schen Veranstaltungsort</xsl:variable>
  <xsl:variable name="bwStr-OKDL-Cancel">Nein: Abbruch</xsl:variable>

  <!--  xsl:template match="inbox" -->
  <xsl:variable name="bwStr-Inbx-Inbox">Eingang</xsl:variable>
  <xsl:variable name="bwStr-Inbx-Sent">Senden</xsl:variable>
  <xsl:variable name="bwStr-Inbx-From">von</xsl:variable>
  <xsl:variable name="bwStr-Inbx-Title">Titel</xsl:variable>
  <xsl:variable name="bwStr-Inbx-Start">Start</xsl:variable>
  <xsl:variable name="bwStr-Inbx-End">Ende</xsl:variable>
  <xsl:variable name="bwStr-Inbx-Method">Methode</xsl:variable>
  <xsl:variable name="bwStr-Inbx-Status">Status</xsl:variable>
  <xsl:variable name="bwStr-Inbx-Unprocessed">Unverarbeitet</xsl:variable>
  <xsl:variable name="bwStr-Inbx-Publish">Ver&#246;ffentlichen</xsl:variable>
  <xsl:variable name="bwStr-Inbx-Request">Anfragen</xsl:variable>
  <xsl:variable name="bwStr-Inbx-Cancel">Abbrechen</xsl:variable>
  <xsl:variable name="bwStr-Inbx-Counter">Einwand</xsl:variable>
  <xsl:variable name="bwStr-Inbx-Processed">Verarbeitet</xsl:variable>
  <xsl:variable name="bwStr-Inbx-CheckMessage">Nachrichten kontrollieren</xsl:variable>
  <xsl:variable name="bwStr-Inbx-Email">Email</xsl:variable>
  <xsl:variable name="bwStr-Inbx-Download">Herunterladen</xsl:variable>
  <xsl:variable name="bwStr-Inbx-Delete">L&#246;schen</xsl:variable>

  <!--  xsl:template match="outbox" -->
  <xsl:variable name="bwStr-Oubx-Outbox">Ausgang</xsl:variable>
  <xsl:variable name="bwStr-Oubx-Sent">Senden</xsl:variable>
  <xsl:variable name="bwStr-Oubx-Start">Start</xsl:variable>
  <xsl:variable name="bwStr-Oubx-End">Ende</xsl:variable>
  <xsl:variable name="bwStr-Oubx-Method">Methode</xsl:variable>
  <xsl:variable name="bwStr-Oubx-Status">Status</xsl:variable>
  <xsl:variable name="bwStr-Oubx-Title">Titel</xsl:variable>
  <xsl:variable name="bwStr-Oubx-Organizer">Veranstalter</xsl:variable>
  <xsl:variable name="bwStr-Oubx-Publish">Ver&#246;ffentlichen</xsl:variable>
  <xsl:variable name="bwStr-Oubx-Request">Anfragen</xsl:variable>
  <xsl:variable name="bwStr-Oubx-Cancel">Abbrechen</xsl:variable>
  <xsl:variable name="bwStr-Oubx-Counter">Einwand</xsl:variable>
  <xsl:variable name="bwStr-Oubx-Unprocessed">Unverarbeitet</xsl:variable>
  <xsl:variable name="bwStr-Oubx-Processed">Verarbeitet</xsl:variable>
  <xsl:variable name="bwStr-Oubx-CheckMessage">Nachrichten kontrollieren</xsl:variable>
  <xsl:variable name="bwStr-Oubx-Email">Email</xsl:variable>
  <xsl:variable name="bwStr-Oubx-Download">Herunterladen</xsl:variable>
  <xsl:variable name="bwStr-Oubx-Delete">L&#246;schen</xsl:variable>

  <!--  xsl:template match="scheduleMethod" -->
  <xsl:variable name="bwStr-ScMe-Publish">Ver&#246;ffentlichen</xsl:variable>
  <xsl:variable name="bwStr-ScMe-Request">Anfragen</xsl:variable>
  <xsl:variable name="bwStr-ScMe-Reply">Antworten</xsl:variable>
  <xsl:variable name="bwStr-ScMe-Add">Hinzuf&#252;gen</xsl:variable>
  <xsl:variable name="bwStr-ScMe-Cancel">Abbrechen</xsl:variable>
  <xsl:variable name="bwStr-ScMe-Refresh">Aktualisieren</xsl:variable>
  <xsl:variable name="bwStr-ScMe-Counter">Einwand</xsl:variable>
  <xsl:variable name="bwStr-ScMe-Declined">Ablehnen</xsl:variable>

  <!--  xsl:template match="formElements" mode="attendeeRespond" -->
  <xsl:variable name="bwStr-AtRe-MeetingCanceled">Sitzung annuliert</xsl:variable>
  <xsl:variable name="bwStr-AtRe-MeetingCounterDeclined">Sitzungs Einwand ablehnen.</xsl:variable>
  <xsl:variable name="bwStr-AtRe-MeetingRequest">Sitzungsanfrage</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Update">(aktualisieren)</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Organizer">Veranstalter:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-ThisMeetingCanceled">Diese Sitzung wurde annuliert.</xsl:variable>
  <xsl:variable name="bwStr-AtRe-CounterReqDeclined">Ihre Einwand/Anfrage wurde abgelehnt.</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Calendar">Kalender:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Action">Ablauf:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-MarkEventAsCanceled">Veranstaltung als annuliert markieren</xsl:variable>
  <xsl:variable name="bwStr-AtRe-DeleteEvent">L&#246;schen Veranstaltung</xsl:variable>
  <xsl:variable name="bwStr-AtRe-ReplyAs">Antworten als</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Accepted">akzeptiert</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Declined">abgelehnt</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Tentative">vorl&#228;ufig</xsl:variable>
  <xsl:variable name="bwStr-AtRe-DelegateTo">&#252;bertragen an</xsl:variable>
  <xsl:variable name="bwStr-AtRe-URIOrAccount">(Uri oder Benutzerkennung)</xsl:variable>
  <xsl:variable name="bwStr-AtRe-CounterSuggest">Einwand (anderen Tag, andere Uhrzeit und/oder Veranstaltungsort vorschlagen)</xsl:variable>
  <xsl:variable name="bwStr-AtRe-NewDateTime">Neues Datum/Uhrzeit:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Invisible">unsichtbar</xsl:variable>
  <xsl:variable name="bwStr-AtRe-TimeFields">Zeitfelder</xsl:variable>
  <xsl:variable name="bwStr-AtRe-AllDayEvent">ganzt&#228;gige Veranstaltung</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Start">Start:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Date">Datum</xsl:variable>
  <xsl:variable name="bwStr-AtRe-End">Ende:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Shown">anzeigen</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Duration">Dauer</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Days">Tage</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Hours">Stunden</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Minutes">Minuten</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Weeks">Wochen</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Or">oder</xsl:variable>
  <xsl:variable name="bwStr-AtRe-ThisEventNoDuration">Diese Veranstaltung hat keine Dauer / Enddatum</xsl:variable>
  <xsl:variable name="bwStr-AtRe-NewLocation">neuer Veranstaltungsort:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Choose">w&#228;hlen:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Select">aussuchen...</xsl:variable>
  <xsl:variable name="bwStr-AtRe-OrAddNew">oder neu hinzuf&#252;gen:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Comment">Kommentar:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Delete">L&#246;schen</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Submit">&#220;bermitteln</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Cancel">Abbrechen</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Title">Titel:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Description">Beschreibung:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-DateAndTime">Datum &amp; Uhrzeit:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-AllDay">(ganzt&#228;gig)</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Location">Veranstaltungsort:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-NotSpecified">nicht festgelegt</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Attendees">Teilnehmer:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Role">Funktion</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Status">Status</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Attendee">Teilnehmer</xsl:variable>
  <xsl:variable name="bwStr-AtRe-See">Einsehen:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Status">Status:</xsl:variable>

  <!--  xsl:template match="event" mode="attendeeReply" -->
  <xsl:variable name="bwStr-AtRy-MeetingChangeRequest">Sitzung &#196;nderungswunsch (Einwand)</xsl:variable>
  <xsl:variable name="bwStr-AtRy-MeetingReply">Sitzung Antwort</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Organizer">Veranstalter:</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Shown">Teilnehmer</xsl:variable>
  <xsl:variable name="bwStr-AtRy-HasRequestedChange">hat einen &#196;nderungswunsch f&#252;r diese Sitzung.</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Attendee">Teilnehmer</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Has">hat</xsl:variable>
  <xsl:variable name="bwStr-AtRy-TentativelyAccepted">VORL&#196;UFIG akzeptiert</xsl:variable>
  <xsl:variable name="bwStr-AtRy-YourInvitation">ihre Einladung.</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Calendar">Kalender:</xsl:variable>
  <xsl:variable name="bwStr-AtRy-EventNoLongerExists">Veranstaltung existiert nicht mehr.</xsl:variable>
  <xsl:variable name="bwStr-AtRy-From">Von:</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Status">Status:</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Comments">Kommentar:</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Action">Ablauf:</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Accept">akzeptieren</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Decline">ablehnen</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Canceled">annuliert</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Update">aktualisieren"</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Title">Titel:</xsl:variable>
  <xsl:variable name="bwStr-AtRy-NoTitle">kein Titel</xsl:variable>
  <xsl:variable name="bwStr-AtRy-When">Wann:</xsl:variable>
  <xsl:variable name="bwStr-AtRy-AllDay">(ganzt&#228;gig)</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Where">Wo:</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Description">Beschreibung:</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Status">Status:</xsl:variable>


  <!--  xsl:template match="event" mode="addEventRef" -->
  <xsl:variable name="bwStr-AERf-AddEventReference">Hinzuf&#252;gen Veranstaltungsabhängigkeit</xsl:variable>
  <xsl:variable name="bwStr-AERf-Event">Veranstaltung:</xsl:variable>
  <xsl:variable name="bwStr-AERf-NoTitle">kein Titel</xsl:variable>
  <xsl:variable name="bwStr-AERf-IntoCalendar">In den Kalender:</xsl:variable>
  <xsl:variable name="bwStr-AERf-DefaultCalendar">Standardkalender</xsl:variable>
  <xsl:variable name="bwStr-AERf-AffectsFreeBusy">Betrifft Frei/Gebucht:</xsl:variable>
  <xsl:variable name="bwStr-AERf-Yes">ja</xsl:variable>
  <xsl:variable name="bwStr-AERf-Opaque">(deckend: Veranstaltung betrifft deinen Status von Frei/Gebucht)</xsl:variable>
  <xsl:variable name="bwStr-AERf-No">nein</xsl:variable>
  <xsl:variable name="bwStr-AERf-Transparent">(transparent: Veranstaltung betrifft deinen Status von Frei/Gebucht nicht)</xsl:variable>
  <xsl:variable name="bwStr-AERf-Cancel">Abbrechen</xsl:variable>
  <xsl:variable name="bwStr-AERf-Continue">Weiter</xsl:variable>

  <!--  xsl:template match="prefs" -->
  <xsl:variable name="bwStr-Pref-ManagePrefs">Verwaltung Voreinstellungen</xsl:variable>
  <xsl:variable name="bwStr-Pref-General">generell</xsl:variable>
  <xsl:variable name="bwStr-Pref-Categories">Kategorien</xsl:variable>
  <xsl:variable name="bwStr-Pref-Locations">Veranstaltungsorte</xsl:variable>
  <xsl:variable name="bwStr-Pref-SchedulingMeetings">Terminplanung/Sitzungen</xsl:variable>
  <xsl:variable name="bwStr-Pref-UserSettings">Benutzereinstellungen:</xsl:variable>
  <xsl:variable name="bwStr-Pref-User">Benutzer:</xsl:variable>
  <xsl:variable name="bwStr-Pref-EmailAddress">Emailadresse:</xsl:variable>
  <xsl:variable name="bwStr-Pref-AddingEvents">Hinzuf&#252;gen Veranstaltungen:</xsl:variable>
  <xsl:variable name="bwStr-Pref-PreferredTimeType">Bevorzugter Zeittyp:</xsl:variable>
  <xsl:variable name="bwStr-Pref-12HourAMPM">12 Stunden + vorm./nachm.</xsl:variable>
  <xsl:variable name="bwStr-Pref-24Hour">24 Stunden</xsl:variable>
  <xsl:variable name="bwStr-Pref-PreferredEndDateTimeType">Bevorzugter Enddatum/Endzeit Typ:</xsl:variable>
  <xsl:variable name="bwStr-Pref-Duration">Zeitdauer</xsl:variable>
  <xsl:variable name="bwStr-Pref-DateTime">Datum/Uhrzeit</xsl:variable>
  <xsl:variable name="bwStr-Pref-DefaultSchedulingCalendar">Standardkalender für Terminplanung:</xsl:variable>
  <xsl:variable name="bwStr-Pref-WorkdaySettings">Einstellung Arbeitstage:</xsl:variable>
  <xsl:variable name="bwStr-Pref-Workdays">Arbeitstage:</xsl:variable>
  <xsl:variable name="bwStr-Pref-Sun">So</xsl:variable>
  <xsl:variable name="bwStr-Pref-Mon">Mo</xsl:variable>
  <xsl:variable name="bwStr-Pref-Tue">Di</xsl:variable>
  <xsl:variable name="bwStr-Pref-Wed">Mi</xsl:variable>
  <xsl:variable name="bwStr-Pref-Thu">Do</xsl:variable>
  <xsl:variable name="bwStr-Pref-Fri">Fr</xsl:variable>
  <xsl:variable name="bwStr-Pref-Sat">Sa</xsl:variable>
  <xsl:variable name="bwStr-Pref-WorkdayStart">Arbeitstage Beginn:</xsl:variable>
  <xsl:variable name="bwStr-Pref-WorkdayEnd">Arbeitstage Ende:</xsl:variable>
  <xsl:variable name="bwStr-Pref-DisplayOptions">Anzeige Optionen:</xsl:variable>
  <xsl:variable name="bwStr-Pref-PreferredView">Bevorzugte Ansicht:</xsl:variable>
  <xsl:variable name="bwStr-Pref-PreferredViewPeriod">Bervorzugter Ansichtszeitraum:</xsl:variable>
  <xsl:variable name="bwStr-Pref-Day">Tag</xsl:variable>
  <xsl:variable name="bwStr-Pref-Today">Heute</xsl:variable>
  <xsl:variable name="bwStr-Pref-Week">Woche</xsl:variable>
  <xsl:variable name="bwStr-Pref-Month">Monat</xsl:variable>
  <xsl:variable name="bwStr-Pref-Year">Jahr</xsl:variable>
  <xsl:variable name="bwStr-Pref-DefaultTimezone">Standard Zeitzone:</xsl:variable>
  <xsl:variable name="bwStr-Pref-SelectTimezone">Aussuchen Zeitzone...</xsl:variable>
  <xsl:variable name="bwStr-Pref-DefaultTimezoneNote">Standard Zeitzone f&#252;r Datums/Uhrzeit Werte. Dies sollte normalerweise ihre lokale Zeitzone sein.</xsl:variable>
  <xsl:variable name="bwStr-Pref-Update">Aktualisieren</xsl:variable>
  <xsl:variable name="bwStr-Pref-Cancel">Abbrechen</xsl:variable>
  <xsl:variable name="bwStr-ScPr-ManagePreferences">Verwaltung Voreinstellungen</xsl:variable>
  <xsl:variable name="bwStr-ScPr-General">generell</xsl:variable>
  <xsl:variable name="bwStr-ScPr-Categories">Kategorien</xsl:variable>
  <xsl:variable name="bwStr-ScPr-Locations">Veranstaltungsorte</xsl:variable>
  <xsl:variable name="bwStr-ScPr-SchedulingMeetings">Terminplanung/Sitzungen</xsl:variable>
  <xsl:variable name="bwStr-ScPr-SchedulingAccess">Terminplanung Zugriffsberechtigung:</xsl:variable>
  <xsl:variable name="bwStr-ScPr-SetScheduleAccess">Zugriffsberechtigung f&#252;r die Terminplanung anpassen, indem sie die Zugriffsrechte im Eingang und Ausgang ver&#228;ndern</xsl:variable>
  <xsl:variable name="bwStr-ScPr-GrantScheduleAccess">Vollzugriff "Terminplanung" und "read freebusy" (Leserecht Frei/Gebucht).</xsl:variable>

  <xsl:variable name="bwStr-ScPr-AccessNote"><ul>
  <li>Eingang: Benutzer, denen sie Vollzugriff auf die Terminplanung zu ihrem Eingang gew&#228;hren, k&#246;nnen ihnen Terminplanungsanfragen zuschicken.</li>
    <li>Ausgang: Benutzer, denen sie Vollzugriff auf die Terminplanung zu ihrem Ausgang gew&#228;hren, k&#246;nnen in ihrem Namen Terminplanungen verschicken.</li></ul>
    <p class="note">*dieses Verfahren ist nur derzeit g&#252;ltig und wird in zukunftigen Versionen verbessert.</p></xsl:variable>
  <xsl:variable name="bwStr-ScPr-SchedulingAutoProcessing">Terminplanung automatische Bearbeitung:</xsl:variable>
  <xsl:variable name="bwStr-ScPr-RespondToSchedReqs">Antwort an Terminplanungsanfragen:</xsl:variable>
  <xsl:variable name="bwStr-ScPr-True">wahr</xsl:variable>
  <xsl:variable name="bwStr-ScPr-False">falsch</xsl:variable>
  <xsl:variable name="bwStr-ScPr-AcceptDoubleBookings">Akzeptieren Doppelbuchungen:</xsl:variable>
  <xsl:variable name="bwStr-ScPr-CancelProcessing">Abbruch Bearbeitung:</xsl:variable>
  <xsl:variable name="bwStr-ScPr-DoNothing">nichts veranlassen</xsl:variable>
  <xsl:variable name="bwStr-ScPr-SetToCanceled">Status der Veranstaltung setzen auf ABBRUCH</xsl:variable>
  <xsl:variable name="bwStr-ScPr-DeleteEvent">L&#246;schen der Veranstaltung</xsl:variable>
  <xsl:variable name="bwStr-ScPr-ReponseProcessing">R&#252;ckantwort bearbeiten:</xsl:variable>
  <xsl:variable name="bwStr-ScPr-LeaveInInbox">im Eingang zur&#252;cklassen f&#252;r manuelle Bearbeitung</xsl:variable>
  <xsl:variable name="bwStr-ScPr-ProcessAccepts">Abarbeiten "Akzeptieren" Antworten - restliche Nachrichten im Eingang belassen</xsl:variable>
  <xsl:variable name="bwStr-ScPr-TryToProcessAll">Versuchen alle Antworten automatisch abzuarbeiten</xsl:variable>
  <xsl:variable name="bwStr-ScPr-UpdateSchedulingProcessing">Aktualisieren Terminplanung mit automatischer Bearbeitung</xsl:variable>
  <xsl:variable name="bwStr-ScPr-Cancel">abbrechen</xsl:variable>

  <!-- xsl:template name="buildWorkdayOptionsList" -->

  <!--  xsl:template name="schedulingAccessForm" -->
  <xsl:variable name="bwStr-ScAF-User">Benutzer</xsl:variable>
  <xsl:variable name="bwStr-ScAF-Group">Gruppe</xsl:variable>
  <xsl:variable name="bwStr-ScAF-Owner">Eigent&#252;mer</xsl:variable>
  <xsl:variable name="bwStr-ScAF-Authenticated">Authentifiziert</xsl:variable>
  <xsl:variable name="bwStr-ScAF-UnAuthenticated">nicht Authentifiziert</xsl:variable>
  <xsl:variable name="bwStr-ScAF-All">Jede</xsl:variable>
  <xsl:variable name="bwStr-ScAF-AllScheduling">Jede Terminplanung</xsl:variable>
  <xsl:variable name="bwStr-ScAF-SchedulingReqs">Anfrage Terminplanung</xsl:variable>
  <xsl:variable name="bwStr-ScAF-SchedulingReplies">Anwort Terminplanung</xsl:variable>
  <xsl:variable name="bwStr-ScAF-FreeBusyReqs">Frei/Gebucht Anfrage</xsl:variable>
  <xsl:variable name="bwStr-ScAF-Update">aktualisieren</xsl:variable>

  <!--  xsl:template match="event" mode="schedNotifications" -->
  <xsl:variable name="bwStr-ScN-Re">Antw.:</xsl:variable>

  <!--  xsl:template name="searchResult" -->
  <xsl:variable name="bwStr-Srch-Search">Suchen:</xsl:variable>
  <xsl:variable name="bwStr-Srch-Go">weiter</xsl:variable>
  <xsl:variable name="bwStr-Srch-Limit">Limit:</xsl:variable>
  <xsl:variable name="bwStr-Srch-TodayForward">ab Heute</xsl:variable>
  <xsl:variable name="bwStr-Srch-PastDates">bis Heute</xsl:variable>
  <xsl:variable name="bwStr-Srch-AllDates">alle tage</xsl:variable>
  <xsl:variable name="bwStr-Srch-SearchResult">Suchergebniss(e)</xsl:variable>
  <xsl:variable name="bwStr-Srch-Page">Seite:</xsl:variable>
  <xsl:variable name="bwStr-Srch-Prev">zur&#252;ck</xsl:variable>
  <xsl:variable name="bwStr-Srch-Next">vor</xsl:variable>
  <xsl:variable name="bwStr-Srch-ResultReturnedFor">Suchergebniss(e) erzeugt f&#252;r</xsl:variable>
  <xsl:variable name="bwStr-Srch-Relevance">Relevanz</xsl:variable>
  <xsl:variable name="bwStr-Srch-Summary">Kurzfassung</xsl:variable>
  <xsl:variable name="bwStr-Srch-DateAndTime">Datum &amp; Uhrzeit</xsl:variable>
  <xsl:variable name="bwStr-Srch-Calendar">Kalender</xsl:variable>
  <xsl:variable name="bwStr-Srch-Location">Veranstaltungsort</xsl:variable>
  <xsl:variable name="bwStr-Srch-NoTitle">kein Titel</xsl:variable>

  <!-- xsl:template name="searchResultPageNav" -->

  <!-- xsl:template match="calendar" mode="sideList" -->

  <!-- xsl:template name="selectPage" -->

  <!-- xsl:template name="noPage" -->

  <!-- xsl:template name="timeFormatter" -->
  <xsl:variable name="bwStr-TiFo-AM">vorm.</xsl:variable>
  <xsl:variable name="bwStr-TiFo-PM">nachm.</xsl:variable>

  <!-- xsl:template name="footer"  -->
  <xsl:variable name="bwStr-Foot-DemonstrationCalendar">Demonstration calendar; place footer information here.</xsl:variable>
  <xsl:variable name="bwStr-Foot-BedeworkWebsite">Bedework Website</xsl:variable>
  <xsl:variable name="bwStr-Foot-ShowXML">show XML</xsl:variable>
  <xsl:variable name="bwStr-Foot-RefreshXSLT">refresh XSLT</xsl:variable>
  <xsl:variable name="bwStr-Foot-BasedOnThe">Based on the</xsl:variable>
  <xsl:variable name="bwStr-Foot-BedeworkCalendarSystem">Bedework Calendar System</xsl:variable>
  <xsl:variable name="bwStr-Foot-ProductionExamples">production examples</xsl:variable>
  <xsl:variable name="bwStr-Foot-ExampleStyles">example styles</xsl:variable>
  <xsl:variable name="bwStr-Foot-Green">green</xsl:variable>
  <xsl:variable name="bwStr-Foot-Red">red</xsl:variable>
  <xsl:variable name="bwStr-Foot-Blue">blue</xsl:variable>
  <xsl:variable name="bwStr-Foot-ExampleSkins">example skins</xsl:variable>
  <xsl:variable name="bwStr-Foot-RSSNext3Days">rss: next 3 days</xsl:variable>
  <xsl:variable name="bwStr-Foot-JavascriptNext3Days">javascript: next 3 days</xsl:variable>
  <xsl:variable name="bwStr-Foot-JavascriptTodaysEvents">javascript: today's events</xsl:variable>
  <xsl:variable name="bwStr-Foot-ForMobileBrowsers">for mobile browsers</xsl:variable>
  <xsl:variable name="bwStr-Foot-VideoFeed">video feed</xsl:variable>
  <xsl:variable name="bwStr-Foot-ResetToCalendarDefault">reset to calendar default</xsl:variable>

</xsl:stylesheet>
