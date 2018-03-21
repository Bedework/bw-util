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

  <!-- All text exposed by the stylesheets is set here. -->
  <!-- To change the language of a web client, translate the strings file. -->

  <xsl:variable name="bwStr-Root-PageTitle">Bedework Veranstaltungskalender</xsl:variable>
  <xsl:variable name="bwStr-Error">Fehler:</xsl:variable>
  <xsl:variable name="bwStr-Error-NoPage">Keine Seite anzeigbar</xsl:variable>
  <xsl:variable name="bwStr-Error-PageNotDefined">Seite "<xsl:value-of select="/bedework/appvar[key='page']/value"/>" is not defined.</xsl:variable>
  <xsl:variable name="bwStr-Error-IframeUnsupported">Ihr Browser unterst&#252;tzt keine iframes.</xsl:variable>
  <xsl:variable name="bwStr-Error-NoScript">Ihr Browser unterst&#252;tzt keine JavaScript!</xsl:variable>

  <!-- xsl:template name="headBar" -->
  <xsl:variable name="bwStr-HdBr-SiteTitle">Bedework &#214;ffentlicher Kalender</xsl:variable>
  <xsl:variable name="bwStr-HdBr-PageTitle">Bedework Veranstaltungskalender</xsl:variable>
  <xsl:variable name="bwStr-HdBr-PublicCalendar">&#214;ffentlicher Kalender</xsl:variable>
  <xsl:variable name="bwStr-HdBr-PublicEventsCalendar">&#214;ffentlicher Kalender</xsl:variable>
  <xsl:variable name="bwStr-HdBr-PersonalCalendar">Pers&#246;nlicher Kalender</xsl:variable>
  <xsl:variable name="bwStr-HdBr-UniversityHome">Startseite Universit&#228;t</xsl:variable>
  <xsl:variable name="bwStr-HdBr-SchoolHome">Startseite Schule</xsl:variable>
  <xsl:variable name="bwStr-HdBr-OtherLink">Andere Verkn&#252;pfungen</xsl:variable>
  <xsl:variable name="bwStr-HdBr-ExampleCalendarHelp">Beispiel Kalender Hilfe</xsl:variable>
  <xsl:variable name="bwStr-HdBr-Print">drucken</xsl:variable>
  <xsl:variable name="bwStr-HdBr-PrintThisView">diese Ansicht drucken</xsl:variable>
  <xsl:variable name="bwStr-HdBr-RSS">RSS</xsl:variable>
  <xsl:variable name="bwStr-HdBr-RSSFeed">Daten-Feeds &amp; Widgets</xsl:variable>
  <xsl:variable name="bwStr-HdBr-ExportSubscribe">Export/Abonnieren</xsl:variable>
  <xsl:variable name="bwStr-HdBr-EventInformation">Veranstaltung Information</xsl:variable>
  <xsl:variable name="bwStr-HdBr-BackLink">(zur&#252;ck zur Veranstaltung)</xsl:variable>
  <xsl:variable name="bwStr-HdBr-Back">&#8656; zur&#252;ck</xsl:variable>

  <!-- ongoing events -->
  <xsl:variable name="bwStr-Ongoing-Title">Aktuell</xsl:variable>
  <xsl:variable name="bwStr-Ongoing-NoEvents">Keine laufenden Veranstaltungen in diesem Zeitraum oder dieser Ansicht</xsl:variable>
  <xsl:variable name="bwStr-Ongoing-Ends">Ende</xsl:variable>

  <!-- deadlines -->
  <xsl:variable name="bwStr-Deadline-Title">Deadlines</xsl:variable>
  <xsl:variable name="bwStr-Deadline-NoEvents">Keine Fristen in diesem Zeitraum oder dieser Ansicht</xsl:variable>

  <!--  xsl:template name="tabs" -->
  <xsl:variable name="bwStr-Tabs-LoggedInAs">angemeldet als</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Logout">abmelden</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Today">HEUTE</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Upcoming">AKTUELLE</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Day">TAG</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Week">WOCHE</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Month">MONAT</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Year">JAHR</xsl:variable>
  <xsl:variable name="bwStr-Tabs-List">LISTE</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Search">suchen</xsl:variable>
  <xsl:variable name="bwStr-Tabs-AdvSearch">erweitere</xsl:variable>
  <xsl:variable name="bwStr-Tabs-JumpToDate">Jump To Date</xsl:variable>

  <!--  xsl:template name="datePicker" -->
  <xsl:variable name="bwStr-DatePicker-Today">Heute</xsl:variable>
  <xsl:variable name="bwStr-DatePicker-Upcoming">Aktuelle</xsl:variable>
  <xsl:variable name="bwStr-DatePicker-Range">Zeitraum</xsl:variable>
  <xsl:variable name="bwStr-DatePicker-Day">Tag</xsl:variable>
  <xsl:variable name="bwStr-DatePicker-Week">Woche</xsl:variable>
  <xsl:variable name="bwStr-DatePicker-Month">Monat</xsl:variable>
  <xsl:variable name="bwStr-DatePicker-StartDate">Anfang-Datum:</xsl:variable>
  <xsl:variable name="bwStr-DatePicker-Menu">Menü</xsl:variable>

  <!--  xsl:template name="navigation" -->
  <xsl:variable name="bwStr-Navi-WeekOf">Woche ab</xsl:variable>
  <xsl:variable name="bwStr-Navi-Go">weiter</xsl:variable>
  <xsl:variable name="bwStr-Navi-GoToDate">Weiter zum Datum:</xsl:variable>
  <xsl:variable name="bwStr-Navi-Today">heute</xsl:variable>

  <!--  xsl:template name="searchBar" -->
  <xsl:variable name="bwStr-SrcB-Add">hinzuf&#252;gen...</xsl:variable>
  <xsl:variable name="bwStr-SrcB-View">Ansicht:</xsl:variable>
  <xsl:variable name="bwStr-SrcB-DefaultView">Standardansicht</xsl:variable>
  <xsl:variable name="bwStr-SrcB-AllCalendars">alle Kalender</xsl:variable>
  <xsl:variable name="bwStr-SrcB-Search">Suchen:</xsl:variable>
  <xsl:variable name="bwStr-SrcB-SearchForEvents">Suche nach Veranstaltungen:</xsl:variable>
  <xsl:variable name="bwStr-SrcB-ApplyFilter">Filter anwenden</xsl:variable>
  <xsl:variable name="bwStr-SrcB-Go">weiter</xsl:variable>
  <xsl:variable name="bwStr-Util-List">LISTE</xsl:variable>
  <xsl:variable name="bwStr-Util-Cal">KALENDER</xsl:variable>
  <xsl:variable name="bwStr-SrcB-ToggleListCalView">Umschalten Listen-/Kalenderansicht</xsl:variable>
  <xsl:variable name="bwStr-Util-Summary">KURZFASSUNG</xsl:variable>
  <xsl:variable name="bwStr-Util-Details">DETAILS</xsl:variable>
  <xsl:variable name="bwStr-SrcB-ToggleSummDetView">Umschalten Ansicht Kurzfassung/Details</xsl:variable>
  <xsl:variable name="bwStr-SrcB-ShowDetails">Details anzeigen</xsl:variable>
  <xsl:variable name="bwStr-SrcB-HideDetails">Details ausblenden</xsl:variable>
  <xsl:variable name="bwStr-SrcB-Summary">Kurzfassung</xsl:variable>
  <xsl:variable name="bwStr-SrcB-Details">Details</xsl:variable>
  <xsl:variable name="bwStr-SrcB-Calendar">Kalender:</xsl:variable>
  <xsl:variable name="bwStr-SrcB-CurrentSearch">Aktuelle Suche:</xsl:variable>

  <!--  xsl:template name="leftColumn", "viewList", and "sideBar" -->
  <xsl:variable name="bwStr-LCol-JsMessage">Bitte aktivieren Javascript in ihrem Browser um den interaktiven Kalender anschauen zu k&#246;nnen.</xsl:variable>
  <xsl:variable name="bwStr-LCol-CalendarViews">Kalender Ansicht</xsl:variable>
  <xsl:variable name="bwStr-LCol-Calendars">Kalender</xsl:variable>
  <xsl:variable name="bwStr-LCol-All">Alles</xsl:variable>
  <xsl:variable name="bwStr-LCol-FilterOnCalendars">FILTER AUF KALENDER:</xsl:variable>
  <xsl:variable name="bwStr-LCol-DownloadCalendars">Herunterladen Kalender</xsl:variable>
  <xsl:variable name="bwStr-LCol-ViewAllCalendars">Ansicht aller Kalender</xsl:variable>
  <xsl:variable name="bwStr-LCol-FeedsAndWidgets">Feeds and Widgets</xsl:variable>

  <xsl:variable name="bwStr-LCol-Options">OPTIONEN:</xsl:variable>
  <xsl:variable name="bwStr-LCol-CalInfo">VERANSTALTUNGSKALENDER INFORMATION:</xsl:variable>
  <xsl:variable name="bwStr-LCol-ManageEvents">Veranstaltung verwalten</xsl:variable>
  <xsl:variable name="bwStr-LCol-Submit">Veranstaltung einreichen</xsl:variable>
  <xsl:variable name="bwStr-LCol-Help">Hilfe</xsl:variable>
  <xsl:variable name="bwStr-LCol-OtherCals">KALENDER WEITERER UNIVERSIT&#196;TEN</xsl:variable>
  <xsl:variable name="bwStr-LCol-ExampleLink">Beispiel Verkn&#252;pfung</xsl:variable>
  <xsl:variable name="bwStr-LCol-OtherLinks">WEITERE VERKN&#220;PFUNGEN</xsl:variable>
  <xsl:variable name="bwStr-LCol-MoreDotDotDot">Mehr...</xsl:variable>

  <!--  xsl:template match="event" -->
  <xsl:variable name="bwStr-SgEv-GenerateLinkToThisEvent">Verkn&#252;pfung zu dieser Veranstaltung erzeugen</xsl:variable>
  <xsl:variable name="bwStr-SgEv-LinkToThisEvent">Verkn&#252;pfung zu dieser Veranstaltung</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Canceled">ABBRUCH:</xsl:variable>
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
  <!--Link, add master event reference to a calendar, add this event reference to a calendar, add event reference to a calendar -->
  <xsl:variable name="bwStr-SgEv-Copy">Kopie</xsl:variable>
  <xsl:variable name="bwStr-SgEv-CopyMaster">Hauptveranstaltung kopieren (Dauerveranstaltung)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-CopyThisInstance">Diesen Eintrag kopieren (Dauerveranstaltung)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-CopyEvent">Veranstaltung kopieren</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Edit">Bearbeiten</xsl:variable>
  <xsl:variable name="bwStr-SgEv-EditMaster">Hauptveranstaltung bearbeiten (Dauerveranstaltung)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-EditThisInstance">Diesen Eintrag bearbeiten (Dauerveranstaltung)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-EditEvent">Veranstaltung bearbeiten</xsl:variable>
  <xsl:variable name="bwStr-SgEv-DownloadEvent">Herunterladen ical</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Download">Herunterladen</xsl:variable>
  <xsl:variable name="bwStr-SgEv-DownloadMaster">Hauptveranstaltung herunterladen (Dauerveranstaltung)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-DownloadThisInstance">Diesen Eintrag Herunterladen (Dauerveranstaltung)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Task">Aufgabe</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Meeting">Sitzung</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Recurring">Wiederkehrend</xsl:variable>
  <xsl:variable name="bwStr-SgEv-EventLink">Verweis zur Veranstaltung:</xsl:variable>
  <!--public, private -->
  <xsl:variable name="bwStr-SgEv-Organizer">Veranstalter:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-RecurrenceMaster">Stammeintrag Dauerveranstaltung</xsl:variable>
  <xsl:variable name="bwStr-SgEv-When">Wann:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-AllDay">(ganzt&#228;gig)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-FloatingTime">jeweilige Zeitzone</xsl:variable>
  <xsl:variable name="bwStr-SgEv-LocalTime">Ortszeit</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Start">Start:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-End">Ende:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Ends">Beendet</xsl:variable>
  <xsl:variable name="bwStr-SgEv-DueBy">Eintrag von</xsl:variable>
  <xsl:variable name="bwStr-SgEv-AddToMyCalendar">Zu meinem Kalender hinzuf&#252;gen</xsl:variable>
  <xsl:variable name="bwStr-SgEv-AddEventToMyCalendar">Eintragen in Pers&#246;nlicher Kalender</xsl:variable>
  <xsl:variable name="bwStr-SgEv-AddToGoogleCalendar">Eintragen in Google Calendar</xsl:variable>
  <xsl:variable name="bwStr-SgEv-AddToFacebook">Eintragen in Facebook</xsl:variable>
  <xsl:variable name="bwStr-SgEv-ShareThis">Share This - dies muss noch speziell konfiguriert werden</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Where">Wo:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Location-Accessible">This venue is wheelchair accessible</xsl:variable> <!-- XXX translate-->
  <xsl:variable name="bwStr-SgEv-Location-Map">map</xsl:variable><!-- XXX translate-->
  <xsl:variable name="bwStr-SgEv-Complete">Vollst&#228;ndig:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-ORGANIZER">Veranstalter:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Description">Beschreibung:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-STATUS">Status:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Attendees">Teilnehmer:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Attendee">Teilnehmer</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Role">Funktion</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Status">Status</xsl:variable>
  <xsl:variable name="bwStr-SgEv-ChangeMyStatus">meinen Status &#228;ndern</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Cost">Kosten:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-See">Einsehen:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-MoreInfo">Mehr Informationen</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Contact">Kontakt:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-ContactInfo">Kontaktinformationen:</xsl:variable>
  <!--Recipients:, recipient -->
  <xsl:variable name="bwStr-SgEv-Calendar">Kalender:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Categories">Kategorien:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Comments">Kommentar:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-TopicalArea">Themengebiet:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Calendars">Kalender:</xsl:variable>

  <!--  xsl:template name="listView" -->
  <xsl:variable name="bwStr-LsVw-NoEventsToDisplay">Keine Veranstaltung gefunden. Bitte versuchen sie einen anderen Zeitraum oder eine andere Ansicht.</xsl:variable>
  <xsl:variable name="bwStr-LsVw-NoEventsToDisplayWithOngoing">Keine laufenden Veranstaltung gefunden. Bitte versuchen sie einen anderen Zeitraum oder eine andere Ansicht oder schauen sie in die Liste der laufenden Veranstaltungen.</xsl:variable>
  <xsl:variable name="bwStr-LsVw-NoEventsFromSelection">Ihre Auswahl liefert keine Ergebnisse.</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Add">hinzuf&#252;gen...</xsl:variable>
  <xsl:variable name="bwStr-LsVw-AllDay">Ganzt&#228;gig</xsl:variable>
  <xsl:variable name="bwStr-LsVw-At">am</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Today">Heute</xsl:variable>
  <xsl:variable name="bwStr-LsVw-AddEventToMyCalendar">Eintragen in Pers&#246;nlicher Kalender</xsl:variable>
  <xsl:variable name="bwStr-LsVw-DownloadEvent">Herunterladen als ical</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Description">Beschreibung</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Canceled">ABBRUCH:</xsl:variable>
  <xsl:variable name="bwStr-LsVw-NoTitle">kein Titel</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Contact">Kontakt:</xsl:variable>
  <xsl:variable name="bwStr-LsVw-DispEventsForCal">Darstellung der Veranstaltung im Kalender</xsl:variable>
  <xsl:variable name="bwStr-LsVw-DispEventsForView">Darstellung der Veranstaltung in der Ansicht</xsl:variable>
  <xsl:variable name="bwStr-LsVw-ShowAll">(alles anzeigen)</xsl:variable>
  <xsl:variable name="bwStr-LsVw-TopicalArea">Themengebiete:</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Location">Veranstaltungsort:</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Cost">Kosten:</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Description">Beschreibung:</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Link">Verkn&#252;pfung:</xsl:variable>
  <xsl:variable name="bwStr-LsVw-ListWithinTimeRange">Liste von Ereignissen innerhalb einer Zeitreihe</xsl:variable>

  <!--  xsl:template match="events" mode="eventList" -->
  <xsl:variable name="bwStr-LsEv-Event">Veranstaltung</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Events">Veranstaltungen</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Next7Days">N&#228;chsten 7 Tage</xsl:variable>
  <xsl:variable name="bwStr-LsEv-NoEventsToDisplay">Keine Veranstaltung darstellbar.</xsl:variable>
  <xsl:variable name="bwStr-LsEv-ContinueFrom">Continue from </xsl:variable><!-- XXX translate -->
  <xsl:variable name="bwStr-LsEv-ReturnToToday">Return to Today</xsl:variable><!-- XXX translate -->
  <xsl:variable name="bwStr-LsEv-Calendars">Kalender:</xsl:variable>
  <xsl:variable name="bwStr-LsEv-ClearFilters">(Alle löschen)</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Search">Suchen:</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Filter">Filter:</xsl:variable>
  <xsl:variable name="bwStr-LsEv-ClearSearch">(löschen)</xsl:variable>
  <xsl:variable name="bwStr-LsEv-DownloadEvent">Herunterladen als ical</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Categories">Kategorien:</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Contact">Kontakt:</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Canceled">ABBRUCH:</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Tentative">ENTWURF:</xsl:variable>
  <xsl:variable name="bwStr-LsEv-EventList">Veranstaltungsliste</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Upcoming">Aktuelle Veranstaltungen</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Starting">Beginnend</xsl:variable>

  <!--  xsl:template name="buildListEventsDaysOptions" -->

  <!--  xsl:template name="weekView" -->

  <!--  xsl:template name="monthView" -->

  <!--  xsl:template match="event" mode="calendarLayout" -->
  <xsl:variable name="bwStr-EvCG-CanceledColon">ABBRUCH:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Tentative">ENTWURF:</xsl:variable>
<!-- // TODO cont kontinuierlich -->
  <xsl:variable name="bwStr-EvCG-Cont">(andauernd)</xsl:variable>
  <xsl:variable name="bwStr-EvCG-AllDayColon">ganzt&#228;gig:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-NoTitle">kein Titel</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Time">Zeit:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-AllDay">ganzt&#228;gig</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Location">Veranstaltungsort:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-TopicalArea">Themengebiete:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Calendar">Kalender:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Type">Typ:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Task">Aufgabe</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Meeting">Besprechung</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Event">Veranstaltung</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Recurring">wiederkehrend</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Personal">Pers&#246;nlich</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Public">&#214;ffentlich</xsl:variable>
  <xsl:variable name="bwStr-EvCG-ViewDetails">Details anzeigen</xsl:variable>
  <xsl:variable name="bwStr-EvCG-DownloadEvent">Veranstaltung herunterladen als ical - z.B. f&#252;r Outlook, PDAs, iCal oder andere Arbeitsplatz-Kalender</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Download">Herunterladen</xsl:variable>
  <xsl:variable name="bwStr-EvCG-DownloadMaster">Haupteintrag herunterladen (wiederkehrende Veranstaltung)</xsl:variable>
  <xsl:variable name="bwStr-EvCG-DownloadThisInstance">Einzelnen Eintrag herunterladen (wiederkehrende Veranstaltung)</xsl:variable>
  <xsl:variable name="bwStr-EvCG-All">jeder</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Instance">Eintrag</xsl:variable>
  <xsl:variable name="bwStr-EvCG-EditColon">Bearbeiten:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-EditMaster">Haupteintrag bearbeiten (wiederkehrende Veranstaltung)</xsl:variable>
  <xsl:variable name="bwStr-EvCG-EditThisInstance">Einzelnen Eintrag bearbeiten (wiederkehrende Veranstaltung)</xsl:variable>
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

  <!--  xsl:template name="yearView" -->

  <!--  xsl:template match="month" -->

  <!--  xsl:template match="calendars" -->
  <xsl:variable name="bwStr-Cals-AllCalendars">Alle Kalender</xsl:variable>
  <xsl:variable name="bwStr-Cals-DownloadCalendars">Herunterladen Kalender</xsl:variable>
  <xsl:variable name="bwStr-Cals-SelectCalendar">Wählen Sie einen Kalender zum Herunterladen als ical.</xsl:variable>

  <!--  xsl:template match="calendar" mode="calTree" -->
  <xsl:variable name="bwStr-Calr-Folder">Ordner</xsl:variable>
  <xsl:variable name="bwStr-Calr-Calendar">Kalender</xsl:variable>

  <!--  xsl:template match="currentCalendar" mode="export" -->
  <xsl:variable name="bwStr-Cals-ExportCals">Kalender ausgeben als iCal</xsl:variable>
  <xsl:variable name="bwStr-Cals-CalendarToExport">Ausgeben:</xsl:variable>
  <xsl:variable name="bwStr-Cals-Name">Name:</xsl:variable>
  <xsl:variable name="bwStr-Cals-Path">Pfad:</xsl:variable>
  <xsl:variable name="bwStr-Cals-EventDateLimits">Befristung:</xsl:variable>
  <xsl:variable name="bwStr-Cals-TodayForward">ab Heute</xsl:variable>
  <xsl:variable name="bwStr-Cals-AllDates">jeden Tag</xsl:variable>
  <xsl:variable name="bwStr-Cals-DateRange">zeitraum</xsl:variable>
  <xsl:variable name="bwStr-Cals-Start"><strong>Start:</strong></xsl:variable>
  <xsl:variable name="bwStr-Cals-End"><strong>Ende:</strong></xsl:variable>
  <xsl:variable name="bwStr-Cals-MyCalendars">Mein Kalender</xsl:variable>
  <xsl:variable name="bwStr-Cals-Export">ausgeben</xsl:variable>

  <!--  xsl:template name="searchResult" -->
  <xsl:variable name="bwStr-Srch-Search">Suchen:</xsl:variable>
  <xsl:variable name="bwStr-Srch-Go">weiter</xsl:variable>
  <xsl:variable name="bwStr-Srch-Limit">Limit:</xsl:variable>
  <xsl:variable name="bwStr-Srch-TodayForward">ab Heute</xsl:variable>
  <xsl:variable name="bwStr-Srch-PastDates">vorherige Tage</xsl:variable>
  <xsl:variable name="bwStr-Srch-AllDates">jeden Tag</xsl:variable>
  <xsl:variable name="bwStr-Srch-SearchResults">Suchergebnis</xsl:variable>
  <xsl:variable name="bwStr-Srch-Page">Seite:</xsl:variable>
  <xsl:variable name="bwStr-Srch-Prev">zur&#252;ck</xsl:variable>
  <xsl:variable name="bwStr-Srch-Next">n&#228;chsten</xsl:variable>
  <xsl:variable name="bwStr-Srch-ResultReturnedFor">R&#252;ckgabe Ergebnis(se)</xsl:variable>
  <xsl:variable name="bwStr-Srch-Relevance">Relevanz</xsl:variable>
  <xsl:variable name="bwStr-Srch-Summary">Kurzfassung</xsl:variable>
  <xsl:variable name="bwStr-Srch-DateAndTime">Datum &amp; Uhrzeit</xsl:variable>
  <xsl:variable name="bwStr-Srch-Calendar">Kalender</xsl:variable>
  <xsl:variable name="bwStr-Srch-Location">Veranstaltungsort</xsl:variable>
  <xsl:variable name="bwStr-Srch-NoTitle">kein Titel</xsl:variable>
  <xsl:variable name="bwStr-Srch-NoQuery">keine Abfrage</xsl:variable>
  <xsl:variable name="bwStr-Srch-Result">Ergebnis</xsl:variable>
  <xsl:variable name="bwStr-Srch-Results">Ergebnisse</xsl:variable>
  <xsl:variable name="bwStr-Srch-ReturnedFor">R&#252;ckgabe:</xsl:variable>
  <xsl:variable name="bwStr-Srch-Rank">Rang</xsl:variable>
  <xsl:variable name="bwStr-Srch-Date">Datum</xsl:variable>
  <xsl:variable name="bwStr-Srch-Summary">Kurzfassung</xsl:variable>
  <xsl:variable name="bwStr-Srch-Location">Veranstaltungsort</xsl:variable>
  <xsl:variable name="bwStr-Srch-Pages">Seite:</xsl:variable>
  <xsl:variable name="bwStr-Srch-AdvancedSearch">Erweiterte Suche</xsl:variable>
  <xsl:variable name="bwStr-Srch-CatsToSearch">Kategorien ausw&#228;hlen f&#252;r die Suche (Optional)</xsl:variable>
  <xsl:variable name="bwStr-Srch-SearchTermNotice">Ein Suchbegriff ist nicht erfordertlich wenn eine Kategorie ausgew#228;hlt wurde.</xsl:variable>

  <!--  xsl:template name="searchResultPageNav" -->

  <!--  xsl:template name="stats" -->
  <xsl:variable name="bwStr-Stat-SysStats">System Statistiken</xsl:variable>
  <xsl:variable name="bwStr-Stat-StatsCollection">Sammlung der Statistiken:</xsl:variable>
  <xsl:variable name="bwStr-Stat-Enable">einschalten</xsl:variable>
  <xsl:variable name="bwStr-Stat-Disable">ausschalten</xsl:variable>
  <xsl:variable name="bwStr-Stat-FetchStats">Statistiken sammeln></xsl:variable>
  <xsl:variable name="bwStr-Stat-DumpStats">Statistiken wegschreiben</xsl:variable>

  <!--  xsl:template name="exportSubscribe" -->
  <xsl:variable name="bwStr-exSu-ExportSubscribe">Export / Subscribe</xsl:variable>
  <xsl:variable name="bwStr-exSu-CurrentFiltersColon">Current Filters:</xsl:variable>
  <xsl:variable name="bwStr-exSu-FeedOrWidget">Event feed or embeddable widget?</xsl:variable>
  <xsl:variable name="bwStr-exSu-Feed">Feed</xsl:variable>
  <xsl:variable name="bwStr-exSu-Widget">Widget (code to copy and paste onto a website)</xsl:variable>
  <xsl:variable name="bwStr-exSu-DataFormat">Data format?</xsl:variable>
  <xsl:variable name="bwStr-exSu-HTMLList">HTML list (copy &amp; paste into Word, etc.)</xsl:variable>
  <xsl:variable name="bwStr-exSu-EventCount">Event count</xsl:variable>
  <xsl:variable name="bwStr-exSu-EventCountTotal">Total number of events returned:</xsl:variable>
  <xsl:variable name="bwStr-exSu-IncludeDownloadLink">Include download link?</xsl:variable>
  <xsl:variable name="bwStr-exSu-True">True</xsl:variable>
  <xsl:variable name="bwStr-exSu-False">False</xsl:variable>
  <xsl:variable name="bwStr-exSu-ShowDetailsOrSummary">Show details or summary?</xsl:variable>
  <xsl:variable name="bwStr-exSu-Details">Details</xsl:variable>
  <xsl:variable name="bwStr-exSu-Summary">Summary</xsl:variable>
  <xsl:variable name="bwStr-exSu-Timeframe">Time frame</xsl:variable>
  <xsl:variable name="bwStr-exSu-UseDefaultListing">Use the default listing, limit the number of days (from the current date), or provide a start date and an end date.</xsl:variable>
  <xsl:variable name="bwStr-exSu-Default">Default</xsl:variable>
  <xsl:variable name="bwStr-exSu-LimitTo">Limit to</xsl:variable>
  <xsl:variable name="bwStr-exSu-DaysFromToday">days from "today"</xsl:variable>
  <xsl:variable name="bwStr-exSu-DateRangeColon">Date Range:</xsl:variable>
  <xsl:variable name="bwStr-exSu-StartDateColon">Start Date:</xsl:variable>
  <xsl:variable name="bwStr-exSu-EndDateColon">End Date:</xsl:variable>
  <xsl:variable name="bwStr-exSu-DateRangeNote">Note: Event count takes precedence over date range!</xsl:variable>
  <xsl:variable name="bwStr-exSu-WidgetOptions">Widget Options</xsl:variable>
  <xsl:variable name="bwStr-exSu-LimitEvents">Limit the number of events listed?</xsl:variable>
  <xsl:variable name="bwStr-exSu-DefaultFalse">(default: false)</xsl:variable>
  <xsl:variable name="bwStr-exSu-LimitToColon">Limit to:</xsl:variable>
  <xsl:variable name="bwStr-exSu-Events">events</xsl:variable>
  <xsl:variable name="bwStr-exSu-ShowTitle">Show a title above event list?</xsl:variable>
  <xsl:variable name="bwStr-exSu-DefaultTrue">(default: true)</xsl:variable>
  <xsl:variable name="bwStr-exSu-TitleColon">Title:</xsl:variable>
  <xsl:variable name="bwStr-exSu-UpcomingEvents">Upcoming Events</xsl:variable>
  <xsl:variable name="bwStr-exSu-DefaultUpcomingEvents">(default: "Upcoming Events")</xsl:variable>
  <xsl:variable name="bwStr-exSu-HighlightDatesOrTitles">Highlight event dates or event titles?</xsl:variable>
  <xsl:variable name="bwStr-exSu-ByTitle">By title</xsl:variable>
  <xsl:variable name="bwStr-exSu-ByDate">By date</xsl:variable>
  <xsl:variable name="bwStr-exSu-DefaultByTitle">(default 'by title')</xsl:variable>
  <xsl:variable name="bwStr-exSu-ShowDescription">Show description in listing?</xsl:variable>
  <xsl:variable name="bwStr-exSu-DisplayEndDate">Display end date in listing?</xsl:variable>
  <xsl:variable name="bwStr-exSu-DisplayTime">Display time in listing?</xsl:variable>
  <xsl:variable name="bwStr-exSu-DisplayLocation">Display location in listing?</xsl:variable>
  <xsl:variable name="bwStr-exSu-DisplayDetailsInline">Display event details inline?</xsl:variable>
  <xsl:variable name="bwStr-exSu-DisplayContact">Display contact in event details?</xsl:variable>
  <xsl:variable name="bwStr-exSu-DisplayCost">>Display cost in event details?</xsl:variable>
  <xsl:variable name="bwStr-exSu-DisplayTags">Display tags in event details?</xsl:variable>
  <xsl:variable name="bwStr-exSu-DisplayTimezone">Display timezone in event details?</xsl:variable>
  <xsl:variable name="bwStr-exSu-URL">Your URL:</xsl:variable>
  <xsl:variable name="bwStr-exSu-WidgetCode">Widget Code:</xsl:variable>

  <!--  xsl:template name="footer" -->
  <xsl:variable name="bwStr-Foot-DemonstrationCalendar">Beispiel Kalender; Informationen und Fussnoten bitte hier einf&#252;gen.</xsl:variable>
  <xsl:variable name="bwStr-Foot-BedeworkWebsite">Bedework Internetseite</xsl:variable>
  <xsl:variable name="bwStr-Foot-ShowXML">Anzeigen XML</xsl:variable>
  <xsl:variable name="bwStr-Foot-RefreshXSLT">Aktualisieren XSLT</xsl:variable>
  <xsl:variable name="bwStr-Foot-BasedOnThe">Basierend auf</xsl:variable>
  <xsl:variable name="bwStr-Foot-BedeworkCalendarSystem">Bedework Calendar System</xsl:variable>
  <xsl:variable name="bwStr-Foot-ProductionExamples">Bedework im Einsatz</xsl:variable>
  <xsl:variable name="bwStr-Foot-ExampleStyles">Design Beispiele</xsl:variable>
  <xsl:variable name="bwStr-Foot-Green">gr&#252;n</xsl:variable>
  <xsl:variable name="bwStr-Foot-Red">rot</xsl:variable>
  <xsl:variable name="bwStr-Foot-Blue">blau</xsl:variable>
  <xsl:variable name="bwStr-Foot-ResetSkin">Design zur&#252;cksetzen</xsl:variable>
  <xsl:variable name="bwStr-Foot-ExampleSkins">Beispielthemen/-design:</xsl:variable>
  <xsl:variable name="bwStr-Foot-BwClassic">Bedework Classic</xsl:variable>
  <xsl:variable name="bwStr-Foot-BwWhite">Bedework Weiß</xsl:variable>
  <xsl:variable name="bwStr-Foot-RSSNext3Days">RSS: n&#228;chsten 3 Tage</xsl:variable>
  <xsl:variable name="bwStr-Foot-JavascriptNext3Days">JSON: n&#228;chsten 3 Tage</xsl:variable>
  <xsl:variable name="bwStr-Foot-JavascriptTodaysEvents">javascript: heutige Veranstaltung(en)</xsl:variable>
  <xsl:variable name="bwStr-Foot-ForMobileBrowsers">Bedework iPhone/Mobile</xsl:variable>
  <xsl:variable name="bwStr-Foot-VideoFeed">Video Feed</xsl:variable>
  <xsl:variable name="bwStr-Foot-ResetToCalendarDefault">Bedework Standard (3.10)</xsl:variable>
  <xsl:variable name="bwStr-Foot-BwTheme3p9">Bedework 3.9 Theme</xsl:variable>
  <xsl:variable name="bwStr-Foot-Credits">Dieses Thema basiert auf der Duke and Yale Universities mit besonderem Dank an die University of Chicago</xsl:variable>

</xsl:stylesheet>
