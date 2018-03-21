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
  <xsl:variable name="bwStr-Head-PageTitle">Bedework: Cliente de Agenda Privada</xsl:variable>

  <!--  xsl:template name="messagesAndErrors" -->

  <!--  xsl:template name="headBar" -->
  <xsl:variable name="bwStr-HdBr-PublicCalendar">Agenda Pública</xsl:variable>
  <xsl:variable name="bwStr-HdBr-PersonalCalendar">Agenda Privada</xsl:variable>
  <xsl:variable name="bwStr-HdBr-UniversityHome">Pág. Inicial de la Universidad</xsl:variable>
  <xsl:variable name="bwStr-HdBr-SchoolHome">Pág. Inicial de la Escuela</xsl:variable>
  <xsl:variable name="bwStr-HdBr-OtherLink">Otro Enlace</xsl:variable>
  <xsl:variable name="bwStr-HdBr-ExampleCalendarHelp">Ayuda de Agenda de Ejemplo</xsl:variable>
  <xsl:variable name="bwStr-HdBr-Print">imprimir</xsl:variable>
  <xsl:variable name="bwStr-HdBr-PrintThisView">imprimir esta vista</xsl:variable>
  <xsl:variable name="bwStr-HdBr-RSS">RSS</xsl:variable>
  <xsl:variable name="bwStr-HdBr-RSSFeed">hoja RSS</xsl:variable>

  <!--  xsl:template name="sideBar" -->
  <xsl:variable name="bwStr-SdBr-Views">vistas</xsl:variable>
  <xsl:variable name="bwStr-SdBr-NoViews">no hay vistas</xsl:variable>
  <xsl:variable name="bwStr-SdBr-SubscribeToCalendarsOrICalFeeds">suscribirse a agendas u hojas iCal</xsl:variable>
  <xsl:variable name="bwStr-SdBr-Subscribe">suscribir</xsl:variable>
  <xsl:variable name="bwStr-SdBr-ManageCalendarsAndSubscriptions">gestionar agendas y suscripciones</xsl:variable>
  <xsl:variable name="bwStr-SdBr-Manage">gestionar</xsl:variable>
  <xsl:variable name="bwStr-SdBr-Calendars">agendas</xsl:variable>
  <xsl:variable name="bwStr-SdBr-Options">opciones</xsl:variable>
  <xsl:variable name="bwStr-SdBr-Preferences">Preferencias</xsl:variable>
  <xsl:variable name="bwStr-SdBr-UploadICal">Cargar fichero iCAL</xsl:variable>
  <xsl:variable name="bwStr-SdBr-AddrBook">Contactos</xsl:variable>
  <xsl:variable name="bwStr-SdBr-ExportCalendars">Exportar Agendas</xsl:variable>
  <xsl:variable name="bwStr-SdBr-UploadEvent">Upload Event</xsl:variable>

  <!--  xsl:template name="tabs" -->
  <xsl:variable name="bwStr-Tabs-LoggedInAs">conectado como</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Logout">desconectar</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Day">DÍA</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Week">SEMANA</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Month">MES</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Year">AÑO</xsl:variable>
  <xsl:variable name="bwStr-Tabs-List">LISTA</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Agenda">AGENDA</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Upcoming">PRÓXIMOS</xsl:variable>

  <!--  xsl:template name="navigation" -->
  <xsl:variable name="bwStr-Navi-WeekOf">Semana de</xsl:variable>
  <xsl:variable name="bwStr-Navi-Go">ir</xsl:variable>
  <xsl:variable name="bwStr-Navi-Today">hoy</xsl:variable>
  <xsl:variable name="bwStr-Navi-Timezone">Zona horaria:</xsl:variable>

  <!--  xsl:template name="utilBar" -->
  <xsl:variable name="bwStr-Util-EventsTitle">eventos</xsl:variable>
  <xsl:variable name="bwStr-Util-Add">añadir...</xsl:variable>
  <xsl:variable name="bwStr-Util-View">Vista</xsl:variable>
  <xsl:variable name="bwStr-Util-DefaultView">vista por defecto</xsl:variable>
  <xsl:variable name="bwStr-Util-AllTopicalAreas">todas las áreas temáticas</xsl:variable>
  <xsl:variable name="bwStr-Util-Search">Buscar</xsl:variable>
  <xsl:variable name="bwStr-Util-Go">ir</xsl:variable>
  <xsl:variable name="bwStr-Util-List">LISTA</xsl:variable>
  <xsl:variable name="bwStr-Util-Cal">AGE.</xsl:variable>
  <xsl:variable name="bwStr-Util-ToggleListCalView">alternar entre vista lista/agenda</xsl:variable>
  <xsl:variable name="bwStr-Util-Summary">SUMARIO</xsl:variable>
  <xsl:variable name="bwStr-Util-Details">DETALLES</xsl:variable>
  <xsl:variable name="bwStr-Util-ToggleSummDetView">alternar entre vista sumario/detalle</xsl:variable>
  <xsl:variable name="bwStr-Util-ShowEvents">Mostrar Eventos</xsl:variable>
  <xsl:variable name="bwStr-Util-Events">EVENTOS</xsl:variable>
  <xsl:variable name="bwStr-Util-ShowFreebusy">Mostrar estado Libre/Ocupado</xsl:variable>
  <xsl:variable name="bwStr-Util-Freebusy">LIBRE/OCUPADO</xsl:variable>

  <!--  xsl:template name="actionIcons" -->
  <xsl:variable name="bwStr-Actn-AddEvent">añadir evento</xsl:variable>
  <xsl:variable name="bwStr-Actn-ScheduleMeeting">planificar reunión</xsl:variable>
  <xsl:variable name="bwStr-Actn-AddTask">añadir tarea</xsl:variable>
  <xsl:variable name="bwStr-Actn-ScheduleTask">planificar tarea</xsl:variable>
  <xsl:variable name="bwStr-Actn-Upload">cargar</xsl:variable>
  <xsl:variable name="bwStr-Actn-UploadEvent">upload event</xsl:variable>

  <!--  xsl:template name="listView" -->
  <xsl:variable name="bwStr-LsVw-NoEventsToDisplay">No hay eventos para mostrar.</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Add">añadir...</xsl:variable>
  <xsl:variable name="bwStr-LsVw-AllDay">todo el día</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Today">hoy</xsl:variable>
  <xsl:variable name="bwStr-LsVw-DownloadEvent">Bajar el evento en formato ical - para Outlook, PDAs, iCal, y otras agendas de sobremesa</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Description">descripción</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Canceled">CANCELADO:</xsl:variable>
  <xsl:variable name="bwStr-LsVw-NoTitle">sin título</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Contact">Contacto:</xsl:variable>

  <!--  <xsl:template name="eventLinks" -->
  <xsl:variable name="bwStr-EvLn-EditMaster">editar el evento entero (evento repetitivo)</xsl:variable>
  <xsl:variable name="bwStr-EvLn-All">todos</xsl:variable>
  <xsl:variable name="bwStr-EvLn-Instance">ocurrencia</xsl:variable>
  <xsl:variable name="bwStr-EvLn-EditInstance">editar ocurrencia (evento repetitivo)</xsl:variable>
  <xsl:variable name="bwStr-EvLn-Edit">Editar</xsl:variable>
  <xsl:variable name="bwStr-EvLn-EditEvent">editar evento</xsl:variable>
  <xsl:variable name="bwStr-EvLn-EditColon">Editar:</xsl:variable>
  <xsl:variable name="bwStr-EvLn-Link">Enlace</xsl:variable>
  <xsl:variable name="bwStr-EvLn-DeleteColon">Borrar:</xsl:variable>
  <xsl:variable name="bwStr-EvLn-DeleteMaster">borrar el evento entero (evento repetitivo)</xsl:variable>
  <xsl:variable name="bwStr-EvLn-DeleteThisEvent">¿Borrar este evento?</xsl:variable>
  <xsl:variable name="bwStr-EvLn-DeleteEvent">borrar evento</xsl:variable>
  <xsl:variable name="bwStr-EvLn-DeleteAllRecurrences">¿Borrar todas las repeeticiones de este evento?</xsl:variable>
  <xsl:variable name="bwStr-EvLn-DeleteInstance">borrar la ocurrencia (evento repetitivo)</xsl:variable>
  <xsl:variable name="bwStr-EvLn-Delete">Borrar</xsl:variable>
  <xsl:variable name="bwStr-EvLn-AddEventReference">add event reference to a calendar</xsl:variable>


  <!-- xsl:template match="events" mode="eventList" -->
  <xsl:variable name="bwStr-LsEv-Upcoming">próximos</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Next7Days">Siguientes 7 Días</xsl:variable>
  <xsl:variable name="bwStr-LsEv-NoEventsToDisplay">No hay eventos para Visualizar</xsl:variable>
  <xsl:variable name="bwStr-LsEv-DownloadEvent">Bajar el evento en formato ical - para Outlook, PDAs, iCal, y otras agendas de sobremesa</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Categories">Categorías:</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Contact">Contacto:</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Canceled">CANCELADO:</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Tentative">INTENTO:</xsl:variable>
  <xsl:variable name="bwStr-LsEv-GoToDay">go to day</xsl:variable>

  <!-- xsl:template name="weekView" -->

  <!-- xsl:template name="monthView" -->

  <!-- xsl:template match="event" mode="calendarLayout" -->
  <xsl:variable name="bwStr-EvCG-Canceled">CANCELADO:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Tentative">INTENTO:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Cont">(cont)</xsl:variable>
  <xsl:variable name="bwStr-EvCG-AllDayColon">todo el día:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-NoTitle">sin título</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Time">Hora:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-AllDay">todo el día</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Location">Lugar:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-TopicalArea">Área Temática:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Calendar">Agenda:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Type">Tipo:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Task">tarea</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Meeting">reunión</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Event">evento</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Recurring">repitiéndose</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Personal">privado</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Public">publico</xsl:variable>
  <xsl:variable name="bwStr-EvCG-ViewDetails">Ver detalles</xsl:variable>
  <xsl:variable name="bwStr-EvCG-DownloadEvent">Bajar el evento en formato ical - para Outlook, PDAs, iCal, y otras agendas de sobremesa</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Download">Bajar</xsl:variable>
  <xsl:variable name="bwStr-EvCG-DownloadMaster">bajar el evento entero (evento repetitivo)</xsl:variable>
  <xsl:variable name="bwStr-EvCG-DownloadThisInstance">bajar esta ocurrencia (evento repetitivo)</xsl:variable>
  <xsl:variable name="bwStr-EvCG-All">todos</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Instance">ocurrencia</xsl:variable>
  <xsl:variable name="bwStr-EvCG-EditColon">Editar:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-EditMaster">editar el evento entero (evento repetitivo)</xsl:variable>
  <xsl:variable name="bwStr-EvCG-EditThisInstance">editar esta ocurrencia(evento repetitivo)</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Edit">Editar</xsl:variable>
  <xsl:variable name="bwStr-EvCG-EditEvent">editar evento</xsl:variable>
  <xsl:variable name="bwStr-EvCG-CopyColon">Copiar:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-CopyMaster">copiar el evento entero (evento repetitivo)</xsl:variable>
  <xsl:variable name="bwStr-EvCG-CopyThisInstance">copiar esta ocurrencia (evento repetitivo)</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Copy">Copiar</xsl:variable>
  <xsl:variable name="bwStr-EvCG-CopyEvent">copiar evento</xsl:variable>
  <xsl:variable name="bwStr-EvCG-LinkColon">Enlace:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Link">Enlace</xsl:variable>
  <xsl:variable name="bwStr-EvCG-DeleteColon">Borrar:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-DeleteThisEvent">¿Borrar este evento?</xsl:variable>
  <xsl:variable name="bwStr-EvCG-DeleteAllRecurrences">¿Borrar todas las repeticiones de este evento?</xsl:variable>
  <xsl:variable name="bwStr-EvCG-DeleteMaster">borrar el evento entero (evento repetitivo)</xsl:variable>
  <xsl:variable name="bwStr-EvCG-DeleteThisInstance">borrar esta ocurrencia (evento repetitivo)</xsl:variable>
  <xsl:variable name="bwStr-EvCG-DeleteEvent">borrar evento</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Delete">Borrar</xsl:variable>
  <xsl:variable name="bwStr-EvCG-AddMasterEventReference">add master event reference to a calendar</xsl:variable>
  <xsl:variable name="bwStr-EvCG-AddThisEventReference">add this event reference to a calendar</xsl:variable>
  <xsl:variable name="bwStr-EvCG-AddEventReference">add event reference to a calendar</xsl:variable>

  <!-- <xsl:template name="yearView" -->

  <!-- <xsl:template match="month" -->

  <!-- <xsl:template name="tasks" -->
  <xsl:variable name="bwStr-Task-Tasks">tareas</xsl:variable>
  <xsl:variable name="bwStr-Task-Reminders">recordatorios</xsl:variable>

  <!-- <xsl:template match="event" mode="tasks" -->
  <xsl:variable name="bwStr-TskE-NoTitle">sin título</xsl:variable>
  <xsl:variable name="bwStr-TskE-Start">Inicio:</xsl:variable>
  <xsl:variable name="bwStr-TskE-Due">Duración:</xsl:variable>

  <!-- <xsl:template match="event" mode="schedNotifications" -->

  <!-- <xsl:template match="event" -->
  <xsl:variable name="bwStr-SgEv-GenerateLinkToThisEvent">generar enlace a este evento</xsl:variable>
  <xsl:variable name="bwStr-SgEv-LinkToThisEvent">enalce a este evento</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Canceled">CANCELADO:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Event">Evento</xsl:variable>
  <xsl:variable name="bwStr-SgEv-NoTitle">sin título</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Delete">Borrar</xsl:variable>
  <xsl:variable name="bwStr-SgEv-DeleteThisEvent">¿Borrar este evento?</xsl:variable>
  <xsl:variable name="bwStr-SgEv-DeleteAllRecurrences">¿Borrar todas las repeticiones de este evento?</xsl:variable>
  <xsl:variable name="bwStr-SgEv-DeleteMaster">borrar el evento entero (evento repetitivo)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-DeleteThisInstance">borrar esta ocurrencia (evento repetitivo)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-DeleteEvent">borrar el evento</xsl:variable>
  <xsl:variable name="bwStr-SgEv-All">todos</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Instance">ocurrencia</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Link">Enlace</xsl:variable>
  <xsl:variable name="bwStr-SgEv-AddMasterEvent">añadir referencia al evento principal a una agenda</xsl:variable>
  <xsl:variable name="bwStr-SgEv-AddThisEvent">añadir referencia a este evento a una agenda</xsl:variable>
  <xsl:variable name="bwStr-SgEv-AddEventReference">añadir referencia del evento a una agenda</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Copy">Copiar</xsl:variable>
  <xsl:variable name="bwStr-SgEv-CopyMaster">copiar el evento entero (evento repetitivo)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-CopyThisInstance">copy this instance (recurring event)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-CopyEvent">copiar evento</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Edit">Editar</xsl:variable>
  <xsl:variable name="bwStr-SgEv-EditMaster">editar el evento entero(evento repetitivo)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-EditThisInstance">editar esta ocurrencia (evento repetitivo)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-EditEvent">editar evento</xsl:variable>
  <xsl:variable name="bwStr-SgEv-DownloadEvent">Bajar el evento en formato ical - para Outlook, PDAs, iCal y otras agendas de sobremesa</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Download">Bajar</xsl:variable>
  <xsl:variable name="bwStr-SgEv-DownloadMaster">bajar el evento entero (evento repetitivo)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-DownloadThisInstance">bajar esta ocurrencia (evento repetitivo)</xsl:variable>

  <xsl:variable name="bwStr-SgEv-Task">Tarea</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Meeting">Reunión</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Event">Evento</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Recurring">Repetitivo</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Public">Público</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Personal">Privado</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Organizer">organizador:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-RecurrenceMaster">evento principal</xsl:variable>
  <xsl:variable name="bwStr-SgEv-When">cuándo:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-AllDay">(todo el día)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-FloatingTime">Floating time</xsl:variable>
  <xsl:variable name="bwStr-SgEv-LocalTime">Hora local</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Start">Inicio:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-End">Fin:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-AddToMyCalendar">añadir a mi agenda</xsl:variable>
  <xsl:variable name="bwStr-SgEv-AddEventToMyCalendar">Añadir evento a MiAgenda</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Where">Dónde:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Complete">Completado:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-ORGANIZER">Organizador:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Description">Descripción:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-STATUS">Estado:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Attendees">Asistentes:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Attendee">Asistente</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Role">papel</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Status">estado</xsl:variable>
  <xsl:variable name="bwStr-SgEv-ChangeMyStatus">cambiar mi estado</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Cost">Precio:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-See">Ver:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Contact">Contacto:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Calendar">Agenda:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Categories">Categorías:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Comments">Comentarios:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-TopicalArea">Área Temática:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Email">email</xsl:variable>

  <!-- <xsl:template match="formElements" mode="addEvent" -->
  <xsl:variable name="bwStr-AddE-AddTask">Añadir Tarea</xsl:variable>
  <xsl:variable name="bwStr-AddE-AddEvent">Añadir Evento</xsl:variable>
  <xsl:variable name="bwStr-AddE-AddMeeting">Añadir Reunión</xsl:variable>

  <!--  <xsl:template match="formElements" mode="editEvent" -->
  <xsl:variable name="bwStr-EdtE-EditTask">Editar tarea</xsl:variable>
  <xsl:variable name="bwStr-EdtE-EditEvent">Editar Evento</xsl:variable>
  <xsl:variable name="bwStr-EdtE-EditMeeting">Editar Reunión</xsl:variable>

  <!--  <xsl:template match="formElements" mode="eventForm" -->
  <xsl:variable name="bwStr-AEEF-Delete">Borrar</xsl:variable>
  <xsl:variable name="bwStr-AEEF-DeleteMaster">borrar el evento entero (evento repetitivo)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-DeleteThisEvent">¿Borrar este evento?</xsl:variable>
  <xsl:variable name="bwStr-AEEF-DeleteAllRecurrences">¿Borrar todas las repeticiones de este evento?</xsl:variable>
  <xsl:variable name="bwStr-AEEF-DeleteThisInstance">borrar esta ocurrencia (evento repetitivo)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-DeleteEvent">borrar el evento</xsl:variable>
  <xsl:variable name="bwStr-AEEF-All">Todas</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Instance">Ocurrencia</xsl:variable>
  <xsl:variable name="bwStr-AEEF-View">Vista</xsl:variable>
  <xsl:variable name="bwStr-AEEF-TASK">Tarea</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Meeting">Reunión</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EVENT">Evento</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Recurring">Repetitivo</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Personal">Privado</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Public">Público</xsl:variable>
  <xsl:variable name="bwStr-AEEF-RecurrenceMaster">evento principal</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Basic">básico</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Details">detalles</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Recurrence">repetitivo</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Scheduling">planificación</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Meetingtab">reunión</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Calendar">Agenda:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Title">Título:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-DateAndTime">Fecha &amp; Hora:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-AllDay">todo el día</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Floating">flotante</xsl:variable>
  <xsl:variable name="bwStr-AEEF-StoreAsUTC">almacenar como UTC</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Start">Inicio:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Date">Fecha</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Due">Duración:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-End">Fin:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Duration">Duración</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Duration-Sched">Duración:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Days">días</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Hours">horas</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Minutes">minutos</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Or">o</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Weeks">semanas</xsl:variable>
  <xsl:variable name="bwStr-AEEF-This">Este/a</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Task">tarea</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Event">evento</xsl:variable>
  <xsl:variable name="bwStr-AEEF-HasNoDurationEndDate">no tiene duración / fecha de fin</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Complete">Completado(a):</xsl:variable>
  <xsl:variable name="bwStr-AEEF-AffectsFreeBusy">Afecta al estado libre/ocupado:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Yes">sí</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Transparent">(transparente: el estado del evento no afecta a su estado libre/ocupado)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-No">no</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Opaque">(opaco: el estado del evento afecta a su estado libre/ocupado)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Categories">Categorías:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-NoCategoriesDefined">no hay categorías definidas</xsl:variable>
  <xsl:variable name="bwStr-AEEF-AddCategory">añadir categoría</xsl:variable>
  <xsl:variable name="bwStr-AEEF-SelectTimezone">seleccionar zona horaria...</xsl:variable>
  <xsl:variable name="bwStr-AEEF-PickPrevious">&#171; Seleccione Anterior</xsl:variable>
  <xsl:variable name="bwStr-AEEF-PickNext">Selección de la Siguiente &#187;</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Options">Opciones &#x25BC;</xsl:variable>
  <xsl:variable name="bwStr-AEEF-24Hours">24 Horas</xsl:variable>
  <xsl:variable name="bwStr-AEEF-FromTheEnd">desde el final</xsl:variable>

  <!-- Details tab (3153)-->
  <xsl:variable name="bwStr-AEEF-Location">Lugar:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Choose">elija:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Select">seleccione...</xsl:variable>
  <xsl:variable name="bwStr-AEEF-OrAddNew">o añada uno nuevo:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EventLink">Enlace del Evento:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Description">Descripción:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Status">Estado:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Confirmed">confirmado</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Tentative">intento</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Canceled">cancelado</xsl:variable>

  <!-- Recurrence tab (3292)-->
  <xsl:variable name="bwStr-AEEF-ThisEventRecurrenceInstance">Este evento es una ocurrencia de repetición.</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EditMasterEvent">editar el evento entero</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EditMaster">editar el evento entero (evento repetitivo)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EventRecurs">el evento se repite</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EventDoesNotRecur">el evento no se repite</xsl:variable>

  <!-- wrapper for all recurrence fields (rrules and rdates): -->
  <xsl:variable name="bwStr-AEEF-RecurrenceRules">Reglas de Repetición</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ChangeRecurrenceRules">modificar reglas de repetición</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ShowAdvancedRecurrenceRules">mostrar reglas de repetición avanzadas</xsl:variable>
  <xsl:variable name="bwStr-AEEF-And">y</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EVERY">Cada</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Every">cada</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Day">día(s)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Hour">hora(s)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Month">mes(es)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Week">semana(s)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Year">año(s)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-On">en</xsl:variable>
  <xsl:variable name="bwStr-AEEF-In">en</xsl:variable>
  <xsl:variable name="bwStr-AEEF-OnThe">en el</xsl:variable>
  <xsl:variable name="bwStr-AEEF-InThe">en el</xsl:variable>
  <xsl:variable name="bwStr-AEEF-TheFirst">el primer</xsl:variable>
  <xsl:variable name="bwStr-AEEF-TheSecond">el segundo</xsl:variable>
  <xsl:variable name="bwStr-AEEF-TheThird">el tercer</xsl:variable>
  <xsl:variable name="bwStr-AEEF-TheFourth">el cuarto</xsl:variable>
  <xsl:variable name="bwStr-AEEF-TheFifth">el quinto</xsl:variable>
  <xsl:variable name="bwStr-AEEF-TheLast">el último</xsl:variable>
  <xsl:variable name="bwStr-AEEF-DayOfTheMonth">día(s) del mes</xsl:variable>
  <xsl:variable name="bwStr-AEEF-DayOfTheYear">día(s) del año</xsl:variable>
  <xsl:variable name="bwStr-AEEF-WeekOfTheYear">semana(s) del año</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Repeating">repitiéndose</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Forever">para siempre</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Until">hasta</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Time">vez/veces</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Frequency">Frecuencia:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-None">ninguna</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Daily">diaria</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Weekly">semanal</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Monthly">mensual</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Yearly">anual</xsl:variable>
  <xsl:variable name="bwStr-AEEF-NoRecurrenceRules">no hay reglas de repetición</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Repeat">Repetir:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Interval">Intervalo:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-InTheseMonths">en los siguientes meses:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-WeekOn">semana(s) en</xsl:variable>
  <xsl:variable name="bwStr-AEEF-SelectWeekdays">seleccionar días laborables</xsl:variable>
  <xsl:variable name="bwStr-AEEF-SelectWeekends">seleccionar fin de semana</xsl:variable>
  <xsl:variable name="bwStr-AEEF-WeekStart">Comienzo de la semana:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-OnTheseDays">en los siguientes días:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-OnTheseDaysOfTheMonth">en los siguientes días del mes:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-InTheseWeeksOfTheYear">en las siguientes semanas del año:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-OnTheseDaysOfTheYear">en los siguientes días del año:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-RecurrenceAndExceptionDates">Fechas de Repetición y Excepción</xsl:variable>
  <xsl:variable name="bwStr-AEEF-RecurrenceDates">Fechas de Repetición</xsl:variable>
  <xsl:variable name="bwStr-AEEF-NoRecurrenceDates">No hay fechas de repetición</xsl:variable>
  <xsl:variable name="bwStr-AEEF-TIME">Hora</xsl:variable>
  <xsl:variable name="bwStr-AEEF-TZid">TZid</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ExceptionDates">Fechas de Excepción</xsl:variable>
  <xsl:variable name="bwStr-AEEF-NoExceptionDates">No hay fechas de excepción</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ExceptionDatesMayBeCreated">Las fechas de excepción pueden crearse al borrar una ocurrencia de un evento repetitivo.</xsl:variable>
  <xsl:variable name="bwStr-AEEF-AddRecurance">añadir repetición</xsl:variable>
  <xsl:variable name="bwStr-AEEF-AddException">añadir excepción</xsl:variable>

  <!-- Access tab -->

  <!-- Scheduling tab -->
  <xsl:variable name="bwStr-AEEF-EditAttendees">editar asistentes</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ChangeMyStatus">cambiar mi estado</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ScheduleThisTask">planificar esta tarea con otros usuarios</xsl:variable>
  <xsl:variable name="bwStr-AEEF-MakeIntoMeeting">convertir en reunión - invitar a asistentes</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Save">guardar</xsl:variable>
  <xsl:variable name="bwStr-AEEF-SaveDraft">guardar borrador</xsl:variable>
  <xsl:variable name="bwStr-AEEF-SaveAndSendInvites">enviar</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Clear">limpiar mensaje de Bandeja de Entrada</xsl:variable>

  <!-- xsl:template match="val" mode="weekMonthYearNumbers" -->

  <!-- xsl:template name="byDayChkBoxList" -->

  <!-- xsl:template name="buildCheckboxList" -->

  <!-- xsl:template name="recurrenceDayPosOptions" -->
  <xsl:variable name="bwStr-RCPO-TheFirst">el primer</xsl:variable>
  <xsl:variable name="bwStr-RCPO-TheSecond">el segundo</xsl:variable>
  <xsl:variable name="bwStr-RCPO-TheThird">el tercer</xsl:variable>
  <xsl:variable name="bwStr-RCPO-TheFourth">el cuarto</xsl:variable>
  <xsl:variable name="bwStr-RCPO-TheFifth">el quinto</xsl:variable>
  <xsl:variable name="bwStr-RCPO-TheLast">el último</xsl:variable>
  <xsl:variable name="bwStr-RCPO-Every">cada</xsl:variable>
  <xsl:variable name="bwStr-RCPO-None">ninguno</xsl:variable>

  <!-- xsl:template name="buildRecurFields" -->
  <xsl:variable name="bwStr-BuRF-And">y</xsl:variable>

  <!-- xsl:template name="buildNumberOptions" -->

  <!-- xsl:template name="clock" -->
  <xsl:variable name="bwStr-Cloc-Bedework24HourClock">Reloj 24-Horas Bedework</xsl:variable>
  <xsl:variable name="bwStr-Cloc-Type">tipo</xsl:variable>
  <xsl:variable name="bwStr-Cloc-SelectTime">seleccione hora</xsl:variable>
  <xsl:variable name="bwStr-Cloc-Switch">cambiar</xsl:variable>
  <xsl:variable name="bwStr-Cloc-Close">cerrar</xsl:variable>
  <xsl:variable name="bwStr-Cloc-CloseClock">close clock</xsl:variable>

  <!-- xsl:template name="newclock" -->
  <xsl:variable name="bwStr-Cloc-Hour">Hora</xsl:variable>
  <xsl:variable name="bwStr-Cloc-Minute">Minuto</xsl:variable>
  <xsl:variable name="bwStr-Cloc-AM">am</xsl:variable>
  <xsl:variable name="bwStr-Cloc-PM">pm</xsl:variable>

  <!-- xsl:template name="attendees" -->
  <xsl:variable name="bwStr-Atnd-Continue">continuar</xsl:variable>
  <xsl:variable name="bwStr-Atnd-SchedulMeetingOrTask">Planificar Reunión o Tarea</xsl:variable>
  <xsl:variable name="bwStr-Atnd-AddAttendees">Añadir asistentes</xsl:variable>
  <xsl:variable name="bwStr-Atnd-Add">añadir</xsl:variable>
  <xsl:variable name="bwStr-Atnd-Recipients">Destinatarios</xsl:variable>
  <xsl:variable name="bwStr-Atnd-Attendee">asistente</xsl:variable>
  <xsl:variable name="bwStr-Atnd-Attendees">Asistentes</xsl:variable>
  <xsl:variable name="bwStr-Atnd-RoleColon">Papel:</xsl:variable>
  <xsl:variable name="bwStr-Atnd-Role">papel</xsl:variable>
  <xsl:variable name="bwStr-Atnd-StatusColon">Estado:</xsl:variable>
  <xsl:variable name="bwStr-Atnd-Status">estado</xsl:variable>
  <xsl:variable name="bwStr-Atnd-RequiredParticipant">participación necesaria</xsl:variable>
  <xsl:variable name="bwStr-Atnd-OptionalParticipant">participación opcional</xsl:variable>
  <xsl:variable name="bwStr-Atnd-Chair">chair</xsl:variable>
  <xsl:variable name="bwStr-Atnd-NonParticipant">sin participación</xsl:variable>
  <xsl:variable name="bwStr-Atnd-NeedsAction">necesita intervención</xsl:variable>
  <xsl:variable name="bwStr-Atnd-Accepted">aceptado</xsl:variable>
  <xsl:variable name="bwStr-Atnd-Declined">rechazado</xsl:variable>
  <xsl:variable name="bwStr-Atnd-Tentative">intento</xsl:variable>
  <xsl:variable name="bwStr-Atnd-Delegated">delegado</xsl:variable>
  <xsl:variable name="bwStr-Atnd-Remove">eliminar</xsl:variable>

  <!-- xsl:template match="partstat" -->
  <xsl:variable name="bwStr-ptst-NeedsAction">necesita intervención</xsl:variable>
  <xsl:variable name="bwStr-ptst-Accepted">aceptado</xsl:variable>
  <xsl:variable name="bwStr-ptst-Declined">rechazado</xsl:variable>
  <xsl:variable name="bwStr-ptst-Tentative">intento</xsl:variable>
  <xsl:variable name="bwStr-ptst-Delegated">delegado</xsl:variable>

  <!-- xsl:template match="freebusy" mode="freeBusyGrid"  -->
  <xsl:variable name="bwStr-FrBu-FreebusyFor">Libre/ocupado para</xsl:variable>
  <xsl:variable name="bwStr-FrBu-AllAttendees">todos los asistentes</xsl:variable>
  <xsl:variable name="bwStr-FrBu-AM">AM</xsl:variable>
  <xsl:variable name="bwStr-FrBu-PM">PM</xsl:variable>
  <xsl:variable name="bwStr-FrBu-Busy">ocupado</xsl:variable>
  <xsl:variable name="bwStr-FrBu-Tentative">intento</xsl:variable>
  <xsl:variable name="bwStr-FrBu-Free">libre</xsl:variable>
  <xsl:variable name="bwStr-FrBu-AllFree">todos libres</xsl:variable>

  <!-- xsl:template match="attendees" -->
  <!-- Stings defined above -->

  <!-- xsl:template match="recipients"-->
  <xsl:variable name="bwStr-Rcpt-Recipient">destinatario</xsl:variable>
  <xsl:variable name="bwStr-Rcpt-Recipients">Destinatarios</xsl:variable>
  <xsl:variable name="bwStr-Rcpt-Remove">eliminar</xsl:variable>

  <!-- xsl:template match="event" mode="addEventRef" -->
  <!-- some strings defined above -->
  <xsl:variable name="bwStr-AEEF-AddEventReference">Añadir Referencia al Evento</xsl:variable>
  <xsl:variable name="bwStr-AEEF-AddEventSubscription">Añadir Suscripción al Evento</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EventColon">Evento:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-NoTitle">sin título</xsl:variable>
  <xsl:variable name="bwStr-AEEF-IntoCalendar">A la agenda:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-DefaultCalendar">agenda por defecto</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Cancel">cancelar</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Continue">continuar</xsl:variable>

  <!-- xsl:template match="freebusy" mode="freeBusyPage" -->
  <xsl:variable name="bwStr-FrBu-YouMayShareYourFreeBusy">Puede compartir su disponibilidad "libre/ocupado" con un usuario o grupo estableciendo como acceso "leer estado libre/ocupado" en las agendas que desee compartir. Para compartir todo su estado libre/ocupado, establezca el acceso "leer estado libre/ocupado" en su carpeta raíz.</xsl:variable>
  <xsl:variable name="bwStr-FrBu-FreeBusy">Libre / Ocupado</xsl:variable>
  <xsl:variable name="bwStr-FrBu-ViewUsersFreeBusy">Ver estado libre/ocupado del usuario:</xsl:variable>

  <!-- xsl:template name="categoryList" -->
  <xsl:variable name="bwStr-Ctgy-ManagePreferences">Gestionar Preferencias</xsl:variable>
  <xsl:variable name="bwStr-Ctgy-General">general</xsl:variable>
  <xsl:variable name="bwStr-Ctgy-Categories">categorías</xsl:variable>
  <xsl:variable name="bwStr-Ctgy-Locations">lugares</xsl:variable>
  <xsl:variable name="bwStr-Ctgy-SchedulingMeetings">planificación/reuniones</xsl:variable>
  <xsl:variable name="bwStr-Ctgy-ManageCategories">Gestionar Categorías</xsl:variable>
  <xsl:variable name="bwStr-Ctgy-Type">Añadir nueva categoría</xsl:variable>
  <xsl:variable name="bwStr-Ctgy-NoCategoriesDefined">No hay categorías definidas</xsl:variable>

  <!-- xsl:template name="modCategory" -->
  <xsl:variable name="bwStr-MCat-ManagePreferences">Gestionar Preferencias</xsl:variable>
  <xsl:variable name="bwStr-MCat-General">general</xsl:variable>
  <xsl:variable name="bwStr-MCat-Categories">categorías</xsl:variable>
  <xsl:variable name="bwStr-MCat-Locations">lugares</xsl:variable>
  <xsl:variable name="bwStr-MCat-SchedulingMeetings">planificación/reuniones</xsl:variable>
  <xsl:variable name="bwStr-MCat-AddCategory">Añadir Categoría</xsl:variable>
  <xsl:variable name="bwStr-MCat-EditCategory">Editar Categoría</xsl:variable>
  <xsl:variable name="bwStr-MCat-UpdateCategory">Modificar Categoría</xsl:variable>
  <xsl:variable name="bwStr-MCat-DeleteCategory">Borrar Categoría</xsl:variable>
  <xsl:variable name="bwStr-MCat-Keyword">Palabra clave:</xsl:variable>
  <xsl:variable name="bwStr-MCat-Description">Descripción:</xsl:variable>
  <xsl:variable name="bwStr-MCat-Cancel">cancelar</xsl:variable>

  <!--  xsl:template name="deleteCategoryConfirm" -->
  <xsl:variable name="bwStr-DlCC-OKtoDeleteCategory">¿Borrar esta categoría?</xsl:variable>
  <xsl:variable name="bwStr-DlCC-DeleteCategory">Borrar Categoría</xsl:variable>
  <xsl:variable name="bwStr-DlCC-Keyword">Palabara clave:</xsl:variable>
  <xsl:variable name="bwStr-DlCC-Description">Descripción:</xsl:variable>
  <xsl:variable name="bwStr-DlCC-YesDeleteCategory">Sí: Borrar Categoría</xsl:variable>
  <xsl:variable name="bwStr-DlCC-NoCancel">No: Cancelar</xsl:variable>

  <!--  xsl:template match="calendars" mode="manageCalendars" -->
  <xsl:variable name="bwStr-Cals-ManageCalendarsSubscriptions">Gestionar Agendas &amp; Suscripciones</xsl:variable>
  <xsl:variable name="bwStr-Cals-Calendars">Agendas</xsl:variable>

  <!--  xsl:template match="calendar" mode="myCalendars"  -->

  <!--  xsl:template match="calendar" mode="mySpecialCalendars" -->
  <xsl:variable name="bwStr-Cals-IncomingSchedulingRequests">incoming scheduling requests</xsl:variable>
  <xsl:variable name="bwStr-Cals-OutgoingSchedulingRequests">outgoing scheduling requests</xsl:variable>

  <!--  xsl:template match="calendar" mode="listForUpdate"  -->
  <xsl:variable name="bwStr-Cals-Update">update</xsl:variable>
  <xsl:variable name="bwStr-Cals-AddCalendarOrFolder">add a calendar or folder</xsl:variable>

  <!--  xsl:template match="calendar" mode="listForDisplay"  -->
  <xsl:variable name="bwStr-Cals-Display">display</xsl:variable>

  <!--  xsl:template name="selectCalForEvent" -->
  <xsl:variable name="bwStr-SCfE-SelectACalendar">seleccione una agenda</xsl:variable>
  <xsl:variable name="bwStr-SCfE-NoWritableCals">no hay agendas con permiso de escritura</xsl:variable>
  <xsl:variable name="bwStr-SCfE-Close">close</xsl:variable>

  <!--  xsl:template match="calendar" mode="selectCalForEventCalTree" -->

  <!--  xsl:template name="selectCalForPublicAlias" -->
  <xsl:variable name="bwStr-SCPA-SelectACalendar">seleccione una agenda</xsl:variable>
  <xsl:variable name="bwStr-SCPA-Close">close</xsl:variable>

  <!--  xsl:template match="calendar" mode="selectCalForPublicAliasCalTree" -->

  <!--  xsl:template match="currentCalendar" mode="addCalendar" -->
  <xsl:variable name="bwStr-CuCa-AddCalOrFolder">Añadir Agenda o Carpeta</xsl:variable>
  <xsl:variable name="bwStr-CuCa-AddSubscription">Añadir Suscripción</xsl:variable>
  <xsl:variable name="bwStr-CuCa-AddCalFolderOrSubscription">Añadir Agenda, Carpeta o Suscripción</xsl:variable>
  <xsl:variable name="bwStr-CuCa-AddCalText">añadir</xsl:variable>
  <xsl:variable name="bwStr-CuCa-AddCalTextLabel">Añadir:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-AddSubText">Añadir suscripción</xsl:variable>
  <xsl:variable name="bwStr-CuCa-HttpStatus">Estado HTTP:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Name">Nombre:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Summary">Sumario:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Description">Descripción:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Color">Color:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Display">Visualizar:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-DisplayItemsInThisCollection">visualizar elementos de esta colección</xsl:variable>
  <xsl:variable name="bwStr-CuCa-FilterExpression">Condición de Filtro:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Type">Tipo:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Calendar">Agenda</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Folder">Carpeta</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Subscription">Sucripción</xsl:variable>
  <xsl:variable name="bwStr-CuCa-SubscriptionType">Tipo de Suscripción:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-PublicCalendar">Agenda Pública</xsl:variable>
  <xsl:variable name="bwStr-CuCa-UserCalendar">Agenda Privada</xsl:variable>
  <xsl:variable name="bwStr-CuCa-URL">URL</xsl:variable>
  <xsl:variable name="bwStr-CuCa-SelectAPublicCalOrFolder">Seleccione una agenda o carpeta públicas</xsl:variable>
  <xsl:variable name="bwStr-CuCa-UsersID">ID de Usuario:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-CalendarPath">Ruta de la Agenda:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-DefaultCalendarOrSomeCalendar">Por ej. "calendar" (por defecto) or "algunaCarpeta/algunaAgenda"</xsl:variable>
  <xsl:variable name="bwStr-CuCa-URLToCalendar">URL de la agenda:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-ID">ID (si fuese necesaria):</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Password">Contraseña (si fuese necesaria):</xsl:variable>
  <xsl:variable name="bwStr-CuCa-SharingMayBeAdded">Nota: Puede añadirse compartición a una agenda una vez ha sido creada.</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Add">Añadir</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Cancel">cancelar</xsl:variable>

  <!--  xsl:template match="currentCalendar" mode="modCalendar -->
  <xsl:variable name="bwStr-CuCa-ModifySubscription">Modificar Subscripción</xsl:variable>
  <xsl:variable name="bwStr-CuCa-ModifyFolder">Modificar Carpeta</xsl:variable>
  <xsl:variable name="bwStr-CuCa-ModifyCalendar">Modificar Agenda</xsl:variable>
  <xsl:variable name="bwStr-CuCa-UpdateSubscription">Actualizar Suscripción</xsl:variable>
  <xsl:variable name="bwStr-CuCa-UpdateFolder">Actualizar Carpeta</xsl:variable>
  <xsl:variable name="bwStr-CuCa-UpdateCalendar">Actualizar Agenda</xsl:variable>
  <xsl:variable name="bwStr-CuCa-DeleteSubscription">Borrar Suscripción</xsl:variable>
  <xsl:variable name="bwStr-CuCa-DeleteFolder">Borrar Carpeta</xsl:variable>
  <xsl:variable name="bwStr-CuCa-DeleteCalendar">Borrar Agenda</xsl:variable>
  <xsl:variable name="bwStr-CuCa-AdvancedOptions">advanced options</xsl:variable>
  <xsl:variable name="bwStr-CuCa-BasicOptions">basic options</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Cancel">cancelar</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Disabled">Desactivado:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-DisabledLabel">desactivado</xsl:variable>
  <xsl:variable name="bwStr-CuCa-EnabledLabel">habilitado</xsl:variable>
  <xsl:variable name="bwStr-CuCa-ThisItemIsInaccessible">Este elemento está inaccesible y ha sido desactivado.  Puede reactivarlo para intentarlo de nuevo.</xsl:variable>
  <xsl:variable name="bwStr-CuCa-FilterExpression">Condición de Filtro:</xsl:variable>
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
  <xsl:variable name="bwStr-CuCa-CurrentAccess">Acceso Actual:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-AccessNote"><p><strong>Nota:</strong> Advanced access controls can break standard sharing.</p><p>Si autoriza permiso de escritura a otro usuario, y desea ver los eventos que pueda introducir dicho usuario en su agenda, <strong>debe autorizar explícitamente acceso a esa agenda para usted mismo.</strong>  Introduzca su ID de usuario en el campo "Quién" mientras establece "todos" en el campo "Permisos". Este es el control de acceso estándar; el motivo por el que usted no ve los eventos introducidos por otros usuarios sin llevar a cabo esta operación es que el acceso por defecto es permitir: todo al "propietario" - y usted no es el propietario de los eventos introducidos por otros usuarios.</p></xsl:variable>
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
  <xsl:variable name="bwStr-CoPi-Pick">elección</xsl:variable>
  <xsl:variable name="bwStr-CoPi-UseDefaultColors">use colores por defecto</xsl:variable>
  <xsl:variable name="bwStr-CoPi-SelectColor">Select a color</xsl:variable>

<!--  xsl:template name="calendarList"  -->
  <xsl:variable name="bwStr-CaLi-ManagingCalendars">Gestionar Agendas &amp; Suscripciones</xsl:variable>
  <xsl:variable name="bwStr-CaLi-SelectFromCalendar">Seleccione un elemento del árbol de agendas de la izquierda para modificar una agenda</xsl:variable>
  <xsl:variable name="bwStr-CaLi-Subscription">suscripción</xsl:variable>
  <xsl:variable name="bwStr-CaLi-OrFolder"> o carpeta</xsl:variable>
  <xsl:variable name="bwStr-CaLi-Select">Selecccione el </xsl:variable>
  <xsl:variable name="bwStr-CaLi-Icon">icono para añadir una nueva agenda, suscripción o carpeta al árbol.</xsl:variable>
  <xsl:variable name="bwStr-CaLi-Folders">Las carpetas pueden contener sólo agendas y subcarpetas.</xsl:variable>
  <xsl:variable name="bwStr-CaLi-Calendars">Las agendas pueden contener sólo eventos (y otros elementos de agenda).</xsl:variable>

  <!--  xsl:template name="calendarDescriptions"  -->
  <xsl:variable name="bwStr-CaDe-CalInfo">Información de Agenda</xsl:variable>
  <xsl:variable name="bwStr-CaDe-SelectAnItem">Seleccione un elemento del árbol de agendas de la izquierda para ver toda la información sobre esa agenda o carpeta.  El árbol de la izquierda representa la jerarquía de agendas.</xsl:variable>
  <xsl:variable name="bwStr-CaDe-AllCalDescriptions">Todas las Descripciones de Agendas:</xsl:variable>
  <xsl:variable name="bwStr-CaDe-Name">Nombre</xsl:variable>
  <xsl:variable name="bwStr-CaDe-Description">Descripción</xsl:variable>

  <!--  xsl:template match="currentCalendar" mode="displayCalendar"  -->
  <xsl:variable name="bwStr-CuCa-CalendarInformation">Información de Agenda</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Path">Ruta:</xsl:variable>
  <!-- The rest found above -->

  <!--  xsl:template match="currentCalendar" mode="deleteCalendarConfirm"  -->
  <xsl:variable name="bwStr-CuCa-YesDeleteFolder">Sí: ¡Borrar Carpeta!</xsl:variable>
  <xsl:variable name="bwStr-CuCa-YesDeleteCalendar">Sí: ¡Borrar Agenda!</xsl:variable>
  <xsl:variable name="bwStr-CuCa-TheFollowingFolder">La siguiente carpeta <em>y todo su contenido</em> serán borrados.  ¿Continuar?</xsl:variable>
  <xsl:variable name="bwStr-CuCa-TheFollowingCalendar">La siguiente agenda <em>y todo su contenido</em> serán borrados.  ¿Continuar?</xsl:variable>
  <!-- The rest found above -->

  <!--  xsl:template match="calendars" mode="exportCalendars" -->
  <xsl:variable name="bwStr-Cals-ExportCals">Exportar Agendas en formato iCal</xsl:variable>
  <xsl:variable name="bwStr-Cals-CalendarToExport">Agenda a exportar:</xsl:variable>
  <xsl:variable name="bwStr-Cals-Name">Nombre:</xsl:variable>
  <xsl:variable name="bwStr-Cals-Path">Ruta:</xsl:variable>
  <xsl:variable name="bwStr-Cals-EventDateLimits">Limitar eventos por fecha:</xsl:variable>
  <xsl:variable name="bwStr-Cals-TodayForward">de hoy en adelante</xsl:variable>
  <xsl:variable name="bwStr-Cals-AllDates">todas las fechas</xsl:variable>
  <xsl:variable name="bwStr-Cals-DateRange">rango de fechas</xsl:variable>
  <xsl:variable name="bwStr-Cals-Start"><strong>Inicio:</strong></xsl:variable>
  <xsl:variable name="bwStr-Cals-End"><strong>Fin:</strong></xsl:variable>
  <xsl:variable name="bwStr-Cals-MyCalendars">Mis Agendas</xsl:variable>

  <!--  xsl:template match="calendar" mode="buildExportTree"  -->

  <!--  xsl:template name="subsMenu"  -->
  <xsl:variable name="bwStr-SuMe-AddSubs">Añadir Suscripciones</xsl:variable>
  <xsl:variable name="bwStr-SuMe-SubscribeTo">Suscribir a:</xsl:variable>
  <xsl:variable name="bwStr-SuMe-PublicCal">una agenda pública (en este sistema)</xsl:variable>
  <xsl:variable name="bwStr-SuMe-UserCal">una agenda privada (en este sistema)</xsl:variable>
  <xsl:variable name="bwStr-SuMe-ExternalFeed">una hoja iCal esterna (por ej. Google, Eventful, etc)</xsl:variable>
  <xsl:variable name="bwStr-SuMe-SubscribeToPublicCalendar">subscribe to a public calendar</xsl:variable>
  <xsl:variable name="bwStr-SuMe-SubscribeToUserCalendar">subscribe to a user calendar</xsl:variable>
  <xsl:variable name="bwStr-SuMe-SubscribeToExternalCalendar">subscribe to an external calendar</xsl:variable>

  <!--  xsl:template name="addPublicAlias"  -->
  <xsl:variable name="bwStr-AdPA-SubscribeToPublicCal">Suscribir a una Agenda Pública</xsl:variable>
  <xsl:variable name="bwStr-AdPA-AddPublicSubscription">Añadir una suscripción pública</xsl:variable>
  <xsl:variable name="bwStr-AdPA-SubscriptionNote">*el nombre de la suscripción debe ser único</xsl:variable>
  <xsl:variable name="bwStr-AdPA-Calendar">Agenda:</xsl:variable>
  <xsl:variable name="bwStr-AdPA-Name">Nombre:</xsl:variable>
  <xsl:variable name="bwStr-AdPA-AffectsFreeBusy">Afecta al estado Libre/Ocupado:</xsl:variable>
  <xsl:variable name="bwStr-AdPA-Yes">sí</xsl:variable>
  <xsl:variable name="bwStr-AdPA-No">no</xsl:variable>
  <xsl:variable name="bwStr-AdPA-Style">Estilo:</xsl:variable>
  <xsl:variable name="bwStr-AdPA-Default">por defecto</xsl:variable>
  <xsl:variable name="bwStr-AdPA-AddSubscription">Añadir Suscripción</xsl:variable>
  <xsl:variable name="bwStr-AdPA-Cancel">cancelar</xsl:variable>

  <!--  xsl:template match="calendar" mode="subscribe" -->
  <xsl:variable name="bwStr-Calr-Folder">carpeta</xsl:variable>
  <xsl:variable name="bwStr-Calr-Calendar">agenda</xsl:variable>

  <!--  xsl:template name="addAlias" -->
  <xsl:variable name="bwStr-AddA-SubscribeToUserCal">Suscribirse a una Agenda Privada</xsl:variable>
  <xsl:variable name="bwStr-AddA-SubscriptionMustBeUnique">*el nombre de la suscripción debe ser único</xsl:variable>
  <xsl:variable name="bwStr-AddA-Name">Nombre:</xsl:variable>
  <xsl:variable name="bwStr-AddA-UserID">Id de Usuario:</xsl:variable>
  <xsl:variable name="bwStr-AddA-ExJaneDoe">ej: pedro.lopez</xsl:variable>
  <xsl:variable name="bwStr-AddA-CalendarPath">Ruta de la agenda:</xsl:variable>
  <xsl:variable name="bwStr-AddA-ExCalendar">ej: calendar</xsl:variable>
  <xsl:variable name="bwStr-AddA-AddSubscription">Añadir Suscripción</xsl:variable>
  <xsl:variable name="bwStr-AddA-Cancel">cancelar</xsl:variable>
  <xsl:variable name="bwStr-AddA-AffectsFreeBusy">Afecta al estado Libre/Ocupado:</xsl:variable>
  <xsl:variable name="bwStr-AddA-Yes">sí</xsl:variable>
  <xsl:variable name="bwStr-AddA-No">no</xsl:variable>
  <xsl:variable name="bwStr-AddA-Style">Estilo:</xsl:variable>
  <xsl:variable name="bwStr-AddA-Default">por defecto</xsl:variable>
  <xsl:variable name="bwStr-AddA-NoteAboutAccess"><ul class="note" style="margin-left: 2em;">
      <li>Debe usted tener al menos permiso de lectura sobre la agenda a la que desea suscribirse.</li>
      <li>El <strong>Nombre</strong> cualquiera que usted desee asignarle a la suscripción.</li>
      <li>El <strong>Id de Usuario</strong> el id. del usuario propietario de la agenda</li>
      <li>La <strong>Ruta</strong> es el nombre de la carpeta y/o agenda dentro del árbol de agendas del usuario remoto.  Por ejemplo, para suscribirse a pedro.lopez/algunaCarpeta/algunaAgenda, introduzca "algunaCarpeta/algunaAgenda".  Para suscribirse a la carpeta raíz de pedro.lopez, deje este campo en blanco.</li>
      <li>Puede añadir suscripciones a sus propias agendas para ayudar a agrupar y organizar colecciones que pudiese desear compartir.</li></ul></xsl:variable>

  <!--  xsl:template match="subscription" mode="modSubscription" (Deprecated: Strings left in place)-->

  <!--  xsl:template name="subscriptionList" (Deprecated: Strings left in place)-->

  <!--  xsl:template match="subscription" mode="mySubscriptions" (Deprecated: Strings left in place)-->

  <!--  xsl:template name="subInaccessible" (Deprecated: Strings left in place)-->

  <!--  xsl:template name="alarmOptions" -->
  <xsl:variable name="bwStr-AlOp-AlarmOptions">Opciones de alarma</xsl:variable>
  <xsl:variable name="bwStr-AlOp-AlarmDateTime">Fecha/Hora de Alarma:</xsl:variable>
  <xsl:variable name="bwStr-AlOp-At">a las</xsl:variable>
  <xsl:variable name="bwStr-AlOp-OrBeforeAfterEvent">o Antes/Después del evento:</xsl:variable>
  <xsl:variable name="bwStr-AlOp-Days">días</xsl:variable>
  <xsl:variable name="bwStr-AlOp-Hours">horas</xsl:variable>
  <xsl:variable name="bwStr-AlOp-Minutes">minutos</xsl:variable>
  <xsl:variable name="bwStr-AlOp-SecondsOr">segundos O:</xsl:variable>
  <xsl:variable name="bwStr-AlOp-Weeks">semanas</xsl:variable>
  <xsl:variable name="bwStr-AlOp-Before">antes</xsl:variable>
  <xsl:variable name="bwStr-AlOp-After">después</xsl:variable>
  <xsl:variable name="bwStr-AlOp-Start">inicio</xsl:variable>
  <xsl:variable name="bwStr-AlOp-End">fin</xsl:variable>
  <xsl:variable name="bwStr-AlOp-EmailAddress">Dirección Email:</xsl:variable>
  <xsl:variable name="bwStr-AlOp-Subject">Asunto:</xsl:variable>
  <xsl:variable name="bwStr-AlOp-Continue">Continuar</xsl:variable>
  <xsl:variable name="bwStr-AlOp-Cancel">cancelar</xsl:variable>

  <!--  xsl:template name="upload" -->
  <xsl:variable name="bwStr-Upld-AffectsFreeBusy">Afecta al estado libre/ocupado:</xsl:variable>
  <xsl:variable name="bwStr-Upld-Yes">sí</xsl:variable>
  <xsl:variable name="bwStr-Upld-Transparent">(transparente: el estado del evento no afecta a su estado libre/ocupado)</xsl:variable>
  <xsl:variable name="bwStr-Upld-StripAlarms">Quitar Alarmas:</xsl:variable>
  <xsl:variable name="bwStr-Upld-No">no</xsl:variable>
  <xsl:variable name="bwStr-Upld-Opaque">(opaco: el estado del evento afecta a su estado libre/ocupado)</xsl:variable>
  <xsl:variable name="bwStr-Upld-UploadICalFile">Cargar Fichero en Formato iCAL</xsl:variable>
  <xsl:variable name="bwStr-Upld-Filename">Nombre de fichero:</xsl:variable>
  <xsl:variable name="bwStr-Upld-IntoCalendar">A la agenda:</xsl:variable>
  <xsl:variable name="bwStr-Upld-DefaultCalendar">agenda por defecto</xsl:variable>
  <xsl:variable name="bwStr-Upld-AcceptEventsSettings">aceptar características del evento</xsl:variable>
  <xsl:variable name="bwStr-Upld-Status">Estado:</xsl:variable>
  <xsl:variable name="bwStr-Upld-AcceptEventsStatus">aceptar estado del evento</xsl:variable>
  <xsl:variable name="bwStr-Upld-Confirmed">confirmado</xsl:variable>
  <xsl:variable name="bwStr-Upld-Tentative">intento</xsl:variable>
  <xsl:variable name="bwStr-Upld-Canceled">cancelado</xsl:variable>
  <xsl:variable name="bwStr-Upld-Continue">Continuar</xsl:variable>
  <xsl:variable name="bwStr-Upld-Cancel">cancelar</xsl:variable>

  <!--  xsl:template name="emailOptions" -->
  <xsl:variable name="bwStr-EmOp-UpdateEmailOptions">Modificar opciones de email</xsl:variable>
  <xsl:variable name="bwStr-EmOp-EmailAddress">Dirección de Email:</xsl:variable>
  <xsl:variable name="bwStr-EmOp-Subject">Asunto:</xsl:variable>
  <xsl:variable name="bwStr-EmOp-Continue">Continuar</xsl:variable>
  <xsl:variable name="bwStr-EmOp-Cancel">cancelar</xsl:variable>

  <!--  xsl:template name="locationList" -->
  <xsl:variable name="bwStr-LocL-ManagePreferences">Gestionar Preferencias</xsl:variable>
  <xsl:variable name="bwStr-LocL-General">general</xsl:variable>
  <xsl:variable name="bwStr-LocL-Categories">categorías</xsl:variable>
  <xsl:variable name="bwStr-LocL-Locations">lugares</xsl:variable>
  <xsl:variable name="bwStr-LocL-SchedulingMeetings">planificación/reuniones</xsl:variable>
  <xsl:variable name="bwStr-LocL-ManageLocations">Gestionar Lugares</xsl:variable>
  <xsl:variable name="bwStr-LocL-AddNewLocation">Añadir nuevo lugar</xsl:variable>

  <!--  xsl:template name="modLocation" -->
  <xsl:variable name="bwStr-ModL-ManagePreferences">Gestionar Preferencias</xsl:variable>
  <xsl:variable name="bwStr-ModL-General">general</xsl:variable>
  <xsl:variable name="bwStr-ModL-Categories">categorías</xsl:variable>
  <xsl:variable name="bwStr-ModL-Locations">lugares</xsl:variable>
  <xsl:variable name="bwStr-ModL-SchedulingMeetings">plafinicación/reuniones</xsl:variable>
  <xsl:variable name="bwStr-ModL-AddLocation">Añadir Lugar</xsl:variable>
  <xsl:variable name="bwStr-ModL-EditLocation">Editar Lugar</xsl:variable>
  <xsl:variable name="bwStr-ModL-MainAddress">Dirección Principal:</xsl:variable>
  <xsl:variable name="bwStr-ModL-SubAddress">Subdirección:</xsl:variable>
  <xsl:variable name="bwStr-ModL-LocationLink">Enlace al Lugar:</xsl:variable>
  <xsl:variable name="bwStr-ModL-SubmitLocation">Enviar Lugar</xsl:variable>
  <xsl:variable name="bwStr-ModL-DeleteLocation">Borrar Lugar</xsl:variable>
  <xsl:variable name="bwStr-ModL-Cancel">cancelar</xsl:variable>

  <!--  xsl:template name="deleteLocationConfirm" -->
  <xsl:variable name="bwStr-OKDL-OKToDeleteLocation">¿Borrar este lugar?</xsl:variable>
  <xsl:variable name="bwStr-OKDL-DeleteLocation">Borrar Lugar</xsl:variable>
  <xsl:variable name="bwStr-OKDL-MainAddress">Dirección Principal:</xsl:variable>
  <xsl:variable name="bwStr-OKDL-Subaddress">Subdirección:</xsl:variable>
  <xsl:variable name="bwStr-OKDL-LocationLink">Enlace al Lugar:</xsl:variable>
  <xsl:variable name="bwStr-OKDL-YesDeleteLocation">Sí: Borrar Lugar</xsl:variable>
  <xsl:variable name="bwStr-OKDL-Cancel">No: Cancelar</xsl:variable>


  <!--  xsl:template match="inbox" -->
  <xsl:variable name="bwStr-Inbx-Inbox">Bandeja de Entrada</xsl:variable>
  <xsl:variable name="bwStr-Inbx-Sent">enviado</xsl:variable>
  <xsl:variable name="bwStr-Inbx-From">de</xsl:variable>
  <xsl:variable name="bwStr-Inbx-Title">título</xsl:variable>
  <xsl:variable name="bwStr-Inbx-Start">inicio</xsl:variable>
  <xsl:variable name="bwStr-Inbx-End">fin</xsl:variable>
  <xsl:variable name="bwStr-Inbx-Method">método</xsl:variable>
  <xsl:variable name="bwStr-Inbx-Status">estado</xsl:variable>
  <xsl:variable name="bwStr-Inbx-Unprocessed">sin procesar</xsl:variable>
  <xsl:variable name="bwStr-Inbx-Publish">publicado</xsl:variable>
  <xsl:variable name="bwStr-Inbx-Request">solicitado</xsl:variable>
  <xsl:variable name="bwStr-Inbx-Cancel">cancelado</xsl:variable>
  <xsl:variable name="bwStr-Inbx-Counter">contrapropuesta</xsl:variable>
  <xsl:variable name="bwStr-Inbx-Processed">procesado</xsl:variable>
  <xsl:variable name="bwStr-Inbx-CheckMessage">check message</xsl:variable>
  <xsl:variable name="bwStr-Inbx-Email">email</xsl:variable>
  <xsl:variable name="bwStr-Inbx-Download">download</xsl:variable>
  <xsl:variable name="bwStr-Inbx-Delete">delete</xsl:variable>

  <!--  xsl:template match="outbox" -->
  <xsl:variable name="bwStr-Oubx-Outbox">Bandeja de Salida</xsl:variable>
  <xsl:variable name="bwStr-Oubx-Sent">enviado</xsl:variable>
  <xsl:variable name="bwStr-Oubx-Start">inicio</xsl:variable>
  <xsl:variable name="bwStr-Oubx-End">fin</xsl:variable>
  <xsl:variable name="bwStr-Oubx-Method">método</xsl:variable>
  <xsl:variable name="bwStr-Oubx-Status">estado</xsl:variable>
  <xsl:variable name="bwStr-Oubx-Title">título</xsl:variable>
  <xsl:variable name="bwStr-Oubx-Organizer">organizador</xsl:variable>
  <xsl:variable name="bwStr-Oubx-Publish">publicado</xsl:variable>
  <xsl:variable name="bwStr-Oubx-Request">solicitado</xsl:variable>
  <xsl:variable name="bwStr-Oubx-Cancel">cancelado</xsl:variable>
  <xsl:variable name="bwStr-Oubx-Counter">contrapropuesta</xsl:variable>
  <xsl:variable name="bwStr-Oubx-Unprocessed">sin procesar</xsl:variable>
  <xsl:variable name="bwStr-Oubx-Processed">procesado</xsl:variable>
  <xsl:variable name="bwStr-Oubx-CheckMessage">check message</xsl:variable>
  <xsl:variable name="bwStr-Oubx-Email">email</xsl:variable>
  <xsl:variable name="bwStr-Oubx-Download">download</xsl:variable>
  <xsl:variable name="bwStr-Oubx-Delete">delete</xsl:variable>

  <!--  xsl:template match="scheduleMethod" -->
  <xsl:variable name="bwStr-ScMe-Publish">publicado</xsl:variable>
  <xsl:variable name="bwStr-ScMe-Request">solicitado</xsl:variable>
  <xsl:variable name="bwStr-ScMe-Reply">contestar</xsl:variable>
  <xsl:variable name="bwStr-ScMe-Add">añadir</xsl:variable>
  <xsl:variable name="bwStr-ScMe-Cancel">cancelar</xsl:variable>
  <xsl:variable name="bwStr-ScMe-Refresh">refrescar</xsl:variable>
  <xsl:variable name="bwStr-ScMe-Counter">contrapropuesta</xsl:variable>
  <xsl:variable name="bwStr-ScMe-Declined">rechazar</xsl:variable>

  <!--  xsl:template match="formElements" mode="attendeeRespond" -->
  <xsl:variable name="bwStr-AtRe-MeetingCanceled">Reunión Cancelada</xsl:variable>
  <xsl:variable name="bwStr-AtRe-MeetingCounterDeclined">Contrapropuesta de Reunión Rechazada</xsl:variable>
  <xsl:variable name="bwStr-AtRe-MeetingRequest">Solicitudes de Reunión</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Update">(actualizar)</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Organizer">Organizador:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-ThisMeetingCanceled">Esta reunión ha sido cancelada.</xsl:variable>
  <xsl:variable name="bwStr-AtRe-CounterReqDeclined">Su solicitud de contrapropuesta ha sido rechazada.</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Calendar">Agenda:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Action">Acción:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-MarkEventAsCanceled">marcar evento como cancelado</xsl:variable>
  <xsl:variable name="bwStr-AtRe-DeleteEvent">borrar evento</xsl:variable>
  <xsl:variable name="bwStr-AtRe-ReplyAs">contestar como</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Accepted">acceptado</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Declined">rechazado</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Tentative">intento</xsl:variable>
  <xsl:variable name="bwStr-AtRe-DelegateTo">delegar en</xsl:variable>
  <xsl:variable name="bwStr-AtRe-URIOrAccount">(uri o cuenta)</xsl:variable>
  <xsl:variable name="bwStr-AtRe-CounterSuggest">contrapropuesta (sugerir una fecha, hora y/o lugar diferentes)</xsl:variable>
  <xsl:variable name="bwStr-AtRe-NewDateTime">Nueva Fecha/Hora:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Invisible">invisible</xsl:variable>
  <xsl:variable name="bwStr-AtRe-TimeFields">Campos de hora</xsl:variable>
  <xsl:variable name="bwStr-AtRe-AllDayEvent">evento de todo el día</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Start">Inicio:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Date">Fecha</xsl:variable>
  <xsl:variable name="bwStr-AtRe-End">Fin:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Shown">mostrado</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Duration">Duración</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Days">días</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Hours">horas</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Minutes">minutos</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Weeks">semanas</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Or">o</xsl:variable>
  <xsl:variable name="bwStr-AtRe-ThisEventNoDuration">Este evento no tiene duración / fecha de fin</xsl:variable>
  <xsl:variable name="bwStr-AtRe-NewLocation">Nuevo Lugar:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Choose">seleccione:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Select">seleccione...</xsl:variable>
  <xsl:variable name="bwStr-AtRe-OrAddNew">o añada nueva:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Comment">Comentario:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Delete">Borrar</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Submit">Enviar</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Cancel">cancelar</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Title">Título:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Description">Descripción:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-DateAndTime">Fecha &amp; Hora:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-AllDay">(todo el día)</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Location">Lugar:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-NotSpecified">sin especificar</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Attendees">Asistentes:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Role">papel</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Status">estado</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Attendee">asistente</xsl:variable>
  <xsl:variable name="bwStr-AtRe-See">Ver:</xsl:variable>
  <xsl:variable name="bwStr-AtRe-Status">Estado:</xsl:variable>

  <!--  xsl:template match="event" mode="attendeeReply" -->
  <xsl:variable name="bwStr-AtRy-MeetingChangeRequest">Solicitud de Cambio de Reunión (Contrapropuesta)</xsl:variable>
  <xsl:variable name="bwStr-AtRy-MeetingReply">Respuesta a Reunión</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Organizer">Organizador:</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Shown">Asistente</xsl:variable>
  <xsl:variable name="bwStr-AtRy-HasRequestedChange">ha solicitado un cambio a esta reunión.</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Attendee">Asistente</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Has">ha</xsl:variable>
  <xsl:variable name="bwStr-AtRy-TentativelyAccepted">INTENTO aceptado</xsl:variable>
  <xsl:variable name="bwStr-AtRy-YourInvitation">su invitación.</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Calendar">Agenda:</xsl:variable>
  <xsl:variable name="bwStr-AtRy-EventNoLongerExists">El evento ya no existe.</xsl:variable>
  <xsl:variable name="bwStr-AtRy-From">De:</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Status">Estado:</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Comments">Comentario:</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Action">Acción:</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Accept">aceptar</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Decline">rechazar</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Canceled">cancelado</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Update">actualizar"</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Title">Título:</xsl:variable>
  <xsl:variable name="bwStr-AtRy-NoTitle">sin título</xsl:variable>
  <xsl:variable name="bwStr-AtRy-When">Cuándo:</xsl:variable>
  <xsl:variable name="bwStr-AtRy-AllDay">(todo el día)</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Where">Dónde:</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Description">Descripción:</xsl:variable>
  <xsl:variable name="bwStr-AtRy-Status">Estado:</xsl:variable>


  <!--  xsl:template match="event" mode="addEventRef" -->
  <xsl:variable name="bwStr-AERf-AddEventReference">Añadir Referencia al Evento</xsl:variable>
  <xsl:variable name="bwStr-AERf-Event">Evento:</xsl:variable>
  <xsl:variable name="bwStr-AERf-NoTitle">sin título</xsl:variable>
  <xsl:variable name="bwStr-AERf-IntoCalendar">A la agenda:</xsl:variable>
  <xsl:variable name="bwStr-AERf-DefaultCalendar">agenda por defecto</xsl:variable>
  <xsl:variable name="bwStr-AERf-AffectsFreeBusy">Afecta al estado Libre/ocupado:</xsl:variable>
  <xsl:variable name="bwStr-AERf-Yes">sí</xsl:variable>
  <xsl:variable name="bwStr-AERf-Opaque">(opaco: el estado del evento afecta a su estado libre/ocupado)</xsl:variable>
  <xsl:variable name="bwStr-AERf-No">no</xsl:variable>
  <xsl:variable name="bwStr-AERf-Transparent">(transparente: el estado del evento no afecta a su estado libre/ocupado)</xsl:variable>
  <xsl:variable name="bwStr-AERf-Cancel">cancelar</xsl:variable>
  <xsl:variable name="bwStr-AERf-Continue">Continuar</xsl:variable>

  <!--  xsl:template match="prefs" -->
  <xsl:variable name="bwStr-Pref-ManagePrefs">Gestionar Preferencias</xsl:variable>
  <xsl:variable name="bwStr-Pref-General">general</xsl:variable>
  <xsl:variable name="bwStr-Pref-Categories">categorías</xsl:variable>
  <xsl:variable name="bwStr-Pref-Locations">lugares</xsl:variable>
  <xsl:variable name="bwStr-Pref-SchedulingMeetings">planificación/reuniones</xsl:variable>
  <xsl:variable name="bwStr-Pref-UserSettings">Ajustes de usuario:</xsl:variable>
  <xsl:variable name="bwStr-Pref-User">Usuario:</xsl:variable>
  <xsl:variable name="bwStr-Pref-EmailAddress">Dirección Email:</xsl:variable>
  <xsl:variable name="bwStr-Pref-AddingEvents">Al añadir eventos:</xsl:variable>
  <xsl:variable name="bwStr-Pref-PreferredTimeType">Tipo de hora Preferida:</xsl:variable>
  <xsl:variable name="bwStr-Pref-12HourAMPM">12 horas + AM/PM</xsl:variable>
  <xsl:variable name="bwStr-Pref-24Hour">24 horas</xsl:variable>
  <xsl:variable name="bwStr-Pref-PreferredEndDateTimeType">Tipo de fecha/hora de fin preferida:</xsl:variable>
  <xsl:variable name="bwStr-Pref-Duration">duración</xsl:variable>
  <xsl:variable name="bwStr-Pref-DateTime">fecha/hora</xsl:variable>
  <xsl:variable name="bwStr-Pref-DefaultSchedulingCalendar">Agenda de planificación por defecto:</xsl:variable>
  <xsl:variable name="bwStr-Pref-WorkdaySettings">Ajustes de días laborables:</xsl:variable>
  <xsl:variable name="bwStr-Pref-Workdays">Días laborables:</xsl:variable>
  <xsl:variable name="bwStr-Pref-Sun">Dom</xsl:variable>
  <xsl:variable name="bwStr-Pref-Mon">Lun</xsl:variable>
  <xsl:variable name="bwStr-Pref-Tue">Mar</xsl:variable>
  <xsl:variable name="bwStr-Pref-Wed">Mié</xsl:variable>
  <xsl:variable name="bwStr-Pref-Thu">Jue</xsl:variable>
  <xsl:variable name="bwStr-Pref-Fri">Vie</xsl:variable>
  <xsl:variable name="bwStr-Pref-Sat">Sáb</xsl:variable>
  <xsl:variable name="bwStr-Pref-WorkdayStart">Día laborable inicial:</xsl:variable>
  <xsl:variable name="bwStr-Pref-WorkdayEnd">Día laborable final:</xsl:variable>
  <xsl:variable name="bwStr-Pref-DisplayOptions">Opciones de visualización:</xsl:variable>
  <xsl:variable name="bwStr-Pref-PreferredView">Vista preferida:</xsl:variable>
  <xsl:variable name="bwStr-Pref-PreferredViewPeriod">Periodo de vista Preferida:</xsl:variable>
  <xsl:variable name="bwStr-Pref-Day">día</xsl:variable>
  <xsl:variable name="bwStr-Pref-Today">hoy</xsl:variable>
  <xsl:variable name="bwStr-Pref-Week">semana</xsl:variable>
  <xsl:variable name="bwStr-Pref-Month">mes</xsl:variable>
  <xsl:variable name="bwStr-Pref-Year">año</xsl:variable>
  <xsl:variable name="bwStr-Pref-DefaultTimezone">Zona horaria por defecto:</xsl:variable>
  <xsl:variable name="bwStr-Pref-SelectTimezone">seleccione zona horaria...</xsl:variable>
  <xsl:variable name="bwStr-Pref-DefaultTimezoneNote">Id. de Zona horaria por defecto para valores de  fecha/hora. Normalmente debería ser su zona horaria local.</xsl:variable>
  <xsl:variable name="bwStr-Pref-Update">Actualizar</xsl:variable>
  <xsl:variable name="bwStr-Pref-Cancel">cancelar</xsl:variable>
  <xsl:variable name="bwStr-ScPr-ManagePreferences">Gestionar Preferencias</xsl:variable>
  <xsl:variable name="bwStr-ScPr-General">general</xsl:variable>
  <xsl:variable name="bwStr-ScPr-Categories">categorías</xsl:variable>
  <xsl:variable name="bwStr-ScPr-Locations">lugares</xsl:variable>
  <xsl:variable name="bwStr-ScPr-SchedulingMeetings">planificación/reuniones</xsl:variable>
  <xsl:variable name="bwStr-ScPr-SchedulingAccess">Acceso para planificación:</xsl:variable>
  <xsl:variable name="bwStr-ScPr-SetScheduleAccess">Establezca el acceso para planificación modificando las listas de acceso de su bandeja de entrada y de su bandeja de salida</xsl:variable>
  <xsl:variable name="bwStr-ScPr-GrantScheduleAccess">Permita acceso "planificación" y "leer libre/ocupado".</xsl:variable>
  <xsl:variable name="bwStr-ScPr-AccessNote"><ul>
  <li>Bandeja de entrada: los usuarios a los que se otorga acceso para planificación en su bandeja de entrada pueden enviarle solicitudes de planificación.</li>
    <li>Bandeja de salida: los usuarios a los que se otorga acceso para planificación en su bandeja de salida pueden planificar por usted.</li></ul>
    <p class="note">*este enfoque es temporal y se mejorará en versiones posteriores.</p></xsl:variable>
  <xsl:variable name="bwStr-ScPr-SchedulingAutoProcessing">Auto-procesamiento de planificación:</xsl:variable>
  <xsl:variable name="bwStr-ScPr-RespondToSchedReqs">Responder a solicitudes de planificación:</xsl:variable>
  <xsl:variable name="bwStr-ScPr-True">verdadero</xsl:variable>
  <xsl:variable name="bwStr-ScPr-False">falso</xsl:variable>
  <xsl:variable name="bwStr-ScPr-AcceptDoubleBookings">Aceptar dobles-reservas:</xsl:variable>
  <xsl:variable name="bwStr-ScPr-CancelProcessing">Cancelar procesamiento:</xsl:variable>
  <xsl:variable name="bwStr-ScPr-DoNothing">no hacer nada</xsl:variable>
  <xsl:variable name="bwStr-ScPr-SetToCanceled">establecer el estado del evento a CANCELADO</xsl:variable>
  <xsl:variable name="bwStr-ScPr-DeleteEvent">borrar el evento</xsl:variable>
  <xsl:variable name="bwStr-ScPr-ReponseProcessing">Procesamiento de respuestas:</xsl:variable>
  <xsl:variable name="bwStr-ScPr-LeaveInInbox">dejar en Bandeja de Entrada para procesamiento manual</xsl:variable>
  <xsl:variable name="bwStr-ScPr-ProcessAccepts">procesar respuestas de  "Aceptar" - dejar el resto en la Bandeja de Entrada</xsl:variable>
  <xsl:variable name="bwStr-ScPr-TryToProcessAll">intentar procesar todas las respuestas</xsl:variable>
  <xsl:variable name="bwStr-ScPr-UpdateSchedulingProcessing">Actualizar auto-procesamiento de planificaciones</xsl:variable>
  <xsl:variable name="bwStr-ScPr-Cancel">cancelar</xsl:variable>

  <!-- xsl:template name="buildWorkdayOptionsList" -->

  <!--  xsl:template name="schedulingAccessForm" -->
  <xsl:variable name="bwStr-ScAF-User">usuario</xsl:variable>
  <xsl:variable name="bwStr-ScAF-Group">grupo</xsl:variable>
  <xsl:variable name="bwStr-ScAF-Owner">propietario</xsl:variable>
  <xsl:variable name="bwStr-ScAF-Authenticated">autenticado</xsl:variable>
  <xsl:variable name="bwStr-ScAF-UnAuthenticated">sin autenticar</xsl:variable>
  <xsl:variable name="bwStr-ScAF-All">todos</xsl:variable>
  <xsl:variable name="bwStr-ScAF-AllScheduling">cualquier planificación</xsl:variable>
  <xsl:variable name="bwStr-ScAF-SchedulingReqs">solicitudes de planificación</xsl:variable>
  <xsl:variable name="bwStr-ScAF-SchedulingReplies">respuestas de planificación</xsl:variable>
  <xsl:variable name="bwStr-ScAF-FreeBusyReqs">solicitudes libre-ocupado</xsl:variable>
  <xsl:variable name="bwStr-ScAF-Update">actualizar</xsl:variable>

  <!--  xsl:template match="event" mode="schedNotifications" -->
  <xsl:variable name="bwStr-ScN-Re">Re:</xsl:variable>

  <!--  xsl:template name="searchResult" -->
  <xsl:variable name="bwStr-Srch-Search">Buscar:</xsl:variable>
  <xsl:variable name="bwStr-Srch-Go">ir</xsl:variable>
  <xsl:variable name="bwStr-Srch-Limit">Limitar:</xsl:variable>
  <xsl:variable name="bwStr-Srch-TodayForward">de hoy en adelante</xsl:variable>
  <xsl:variable name="bwStr-Srch-PastDates">fechas pasadas</xsl:variable>
  <xsl:variable name="bwStr-Srch-AllDates">todas las fechas</xsl:variable>
  <xsl:variable name="bwStr-Srch-SearchResult">Resultados de la Búsqueda</xsl:variable>
  <xsl:variable name="bwStr-Srch-Page">página:</xsl:variable>
  <xsl:variable name="bwStr-Srch-Prev">ant.</xsl:variable>
  <xsl:variable name="bwStr-Srch-Next">sig.</xsl:variable>
  <xsl:variable name="bwStr-Srch-ResultReturnedFor">resultado(s) devueltos para</xsl:variable>
  <xsl:variable name="bwStr-Srch-Relevance">relevancia</xsl:variable>
  <xsl:variable name="bwStr-Srch-Summary">sumario</xsl:variable>
  <xsl:variable name="bwStr-Srch-DateAndTime">fecha &amp; hora</xsl:variable>
  <xsl:variable name="bwStr-Srch-Calendar">agenda</xsl:variable>
  <xsl:variable name="bwStr-Srch-Location">lugar</xsl:variable>
  <xsl:variable name="bwStr-Srch-NoTitle">sin título</xsl:variable>

  <!-- xsl:template name="searchResultPageNav" -->

  <!-- xsl:template match="calendar" mode="sideList" -->

  <!-- xsl:template name="selectPage" -->

  <!-- xsl:template name="noPage" -->

  <!-- xsl:template name="timeFormatter" -->
  <xsl:variable name="bwStr-TiFo-AM">AM</xsl:variable>
  <xsl:variable name="bwStr-TiFo-PM">PM</xsl:variable>

  <!-- xsl:template name="footer"  -->
  <xsl:variable name="bwStr-Foot-DemonstrationCalendar">Agenda de prueba; poner información de pie de página aqui.</xsl:variable>
  <xsl:variable name="bwStr-Foot-BedeworkWebsite">Sito Web Bedework</xsl:variable>
  <xsl:variable name="bwStr-Foot-ShowXML">Mostrar XML</xsl:variable>
  <xsl:variable name="bwStr-Foot-RefreshXSLT">refrescar XSLT</xsl:variable>
  <xsl:variable name="bwStr-Foot-BasedOnThe">Basado en el</xsl:variable>
  <xsl:variable name="bwStr-Foot-BedeworkCalendarSystem">Sistema de Agenda Bedework</xsl:variable>
  <xsl:variable name="bwStr-Foot-ProductionExamples">ejemplos en producción</xsl:variable>
  <xsl:variable name="bwStr-Foot-ExampleStyles">estilos de ejemplo</xsl:variable>
  <xsl:variable name="bwStr-Foot-Green">verde</xsl:variable>
  <xsl:variable name="bwStr-Foot-Red">rojo</xsl:variable>
  <xsl:variable name="bwStr-Foot-Blue">azúl</xsl:variable>
  <xsl:variable name="bwStr-Foot-ExampleSkins">máscaras de ejemplo</xsl:variable>
  <xsl:variable name="bwStr-Foot-RSSNext3Days">rss: siguientes 3 días</xsl:variable>
  <xsl:variable name="bwStr-Foot-JavascriptNext3Days">javascript: siguientes 3 días</xsl:variable>
  <xsl:variable name="bwStr-Foot-JavascriptTodaysEvents">javascript: eventos para hoy</xsl:variable>
  <xsl:variable name="bwStr-Foot-ForMobileBrowsers">para navegadores móviles</xsl:variable>
  <xsl:variable name="bwStr-Foot-VideoFeed">hoja de video</xsl:variable>
  <xsl:variable name="bwStr-Foot-ResetToCalendarDefault">restablecer a agenda por defecto</xsl:variable>

</xsl:stylesheet>
