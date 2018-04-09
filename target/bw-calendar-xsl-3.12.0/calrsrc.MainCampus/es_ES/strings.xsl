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

  <xsl:variable name="bwStr-Root-PageTitle">Agenda de Eventos Bedework</xsl:variable>
  <xsl:variable name="bwStr-Error">Error:</xsl:variable>
  <xsl:variable name="bwStr-Error-NoPage">No hay ninguna página para visualizar</xsl:variable>
  <xsl:variable name="bwStr-Error-PageNotDefined">La Página "<xsl:value-of select="/bedework/appvar[key='page']/value"/>" no está definida.</xsl:variable>
  <xsl:variable name="bwStr-Error-IframeUnsupported">Su navegador no soporta marcos.</xsl:variable>
  <xsl:variable name="bwStr-Error-NoScript">Su navegador no soporta JavaScript!</xsl:variable>

  <!-- xsl:template name="headBar" -->
  <xsl:variable name="bwStr-HdBr-SiteTitle">Agenda Pública BEDEWORK</xsl:variable>
  <xsl:variable name="bwStr-HdBr-PageTitle">Agenda de Eventos BEDEWORK</xsl:variable>
  <xsl:variable name="bwStr-HdBr-PublicCalendar">Agenda Pública</xsl:variable>
  <xsl:variable name="bwStr-HdBr-PublicEventsCalendar">Agenda Pública</xsl:variable>
  <xsl:variable name="bwStr-HdBr-PersonalCalendar">Agenda Privada</xsl:variable>
  <xsl:variable name="bwStr-HdBr-UniversityHome">Página de Inicio de la Universidad</xsl:variable>
  <xsl:variable name="bwStr-HdBr-SchoolHome">Página de Inicio de la Escuela</xsl:variable>
  <xsl:variable name="bwStr-HdBr-OtherLink">Otro Enlace</xsl:variable>
  <xsl:variable name="bwStr-HdBr-ExampleCalendarHelp">Ejemplo de Ayuda de la Agenda</xsl:variable>
  <xsl:variable name="bwStr-HdBr-Print">imprimir</xsl:variable>
  <xsl:variable name="bwStr-HdBr-PrintThisView">imprimir esta vista</xsl:variable>
  <xsl:variable name="bwStr-HdBr-RSS">RSS</xsl:variable>
  <xsl:variable name="bwStr-HdBr-RSSFeed">Fuentes de datos y Reproductores</xsl:variable>
  <xsl:variable name="bwStr-HdBr-ExportSubscribe">Exportar/Suscribirse</xsl:variable>
  <xsl:variable name="bwStr-HdBr-EventInformation">Información del Evento</xsl:variable>
  <xsl:variable name="bwStr-HdBr-BackLink">(volver a los eventos)</xsl:variable>
  <xsl:variable name="bwStr-HdBr-Back">&#8656; atrás</xsl:variable>

  <!-- ongoing events -->
  <xsl:variable name="bwStr-Ongoing-Title">Eventos Activos</xsl:variable>
  <xsl:variable name="bwStr-Ongoing-NoEvents">No hay eventos activos en este intervalo de tiempo o en esta vista</xsl:variable>
  <xsl:variable name="bwStr-Ongoing-Ends">Termina</xsl:variable>

  <!-- deadlines -->
  <xsl:variable name="bwStr-Deadline-Title">Fechas límite</xsl:variable>
  <xsl:variable name="bwStr-Deadline-NoEvents">No hay fechas límite en este intervalo de tiempo o en esta vista</xsl:variable>

  <!--  xsl:template name="tabs" -->
  <xsl:variable name="bwStr-Tabs-LoggedInAs">conectado como</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Logout">desconectar</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Today">HOY</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Upcoming">PRÓXIMOS</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Day">DÍA</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Week">SEMANA</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Month">MES</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Year">AÑO</xsl:variable>
  <xsl:variable name="bwStr-Tabs-List">LISTA</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Search">buscar</xsl:variable>
  <xsl:variable name="bwStr-Tabs-AdvSearch">avanzada</xsl:variable>
  <xsl:variable name="bwStr-Tabs-JumpToDate">Jump To Date</xsl:variable>

  <!--  xsl:template name="datePicker" -->
  <xsl:variable name="bwStr-DatePicker-Today">hoy</xsl:variable>
  <xsl:variable name="bwStr-DatePicker-Upcoming">próximos</xsl:variable>
  <xsl:variable name="bwStr-DatePicker-Range">rango</xsl:variable>
  <xsl:variable name="bwStr-DatePicker-Day">día</xsl:variable>
  <xsl:variable name="bwStr-DatePicker-Week">semana</xsl:variable>
  <xsl:variable name="bwStr-DatePicker-Month">mes</xsl:variable>
  <xsl:variable name="bwStr-DatePicker-StartDate">Fecha de inicio:</xsl:variable>
  <xsl:variable name="bwStr-DatePicker-Menu">menú</xsl:variable>

  <!--  xsl:template name="navigation" -->
  <xsl:variable name="bwStr-Navi-WeekOf">Semana de</xsl:variable>
  <xsl:variable name="bwStr-Navi-Go">ir</xsl:variable>
  <xsl:variable name="bwStr-Navi-GoToDate">Ir a la fecha:</xsl:variable>
  <xsl:variable name="bwStr-Navi-Today">hoy</xsl:variable>

  <!--  xsl:template name="searchBar" -->
  <xsl:variable name="bwStr-SrcB-Add">Añadir...</xsl:variable>
  <xsl:variable name="bwStr-SrcB-View">Vista:</xsl:variable>
  <xsl:variable name="bwStr-SrcB-DefaultView">vista por defecto</xsl:variable>
  <xsl:variable name="bwStr-SrcB-AllCalendars">todas las agendas</xsl:variable>
  <xsl:variable name="bwStr-SrcB-Search">Buscar:</xsl:variable>
  <xsl:variable name="bwStr-SrcB-SearchForEvents">Búsqueda de eventos:</xsl:variable>
  <xsl:variable name="bwStr-SrcB-ApplyFilter">aplicar filtro</xsl:variable>
  <xsl:variable name="bwStr-SrcB-Go">ir</xsl:variable>
  <xsl:variable name="bwStr-Util-List">LISTA</xsl:variable>
  <xsl:variable name="bwStr-Util-Cal">CAL</xsl:variable>
  <xsl:variable name="bwStr-SrcB-ToggleListCalView">alternar entre las vistas lista/agenda</xsl:variable>
  <xsl:variable name="bwStr-Util-Summary">SUMARIO</xsl:variable>
  <xsl:variable name="bwStr-Util-Details">DETALLES</xsl:variable>
  <xsl:variable name="bwStr-SrcB-ToggleSummDetView">alternar entre las vistas sumario/detalles</xsl:variable>
  <xsl:variable name="bwStr-SrcB-ShowDetails">Mostrar Detalles</xsl:variable>
  <xsl:variable name="bwStr-SrcB-HideDetails">Ocultar Detalles</xsl:variable>
  <xsl:variable name="bwStr-SrcB-Summary">Sumario</xsl:variable>
  <xsl:variable name="bwStr-SrcB-Details">Detalles</xsl:variable>
  <xsl:variable name="bwStr-SrcB-Calendar">Agenda:</xsl:variable>
  <xsl:variable name="bwStr-SrcB-CurrentSearch">Búsqueda actual:</xsl:variable>

  <!--  xsl:template name="leftColumn", "viewList", and "sideBar" -->
  <xsl:variable name="bwStr-LCol-JsMessage">Para ver la agenda interactiva, active Javascript en su navegador.</xsl:variable>
  <xsl:variable name="bwStr-LCol-CalendarViews">Vistas de Agenda</xsl:variable>
  <xsl:variable name="bwStr-LCol-Calendars">Agendas</xsl:variable>
  <xsl:variable name="bwStr-LCol-All">Todas</xsl:variable>
  <xsl:variable name="bwStr-LCol-FilterOnCalendars">FILTRAR AGENDAS:</xsl:variable>
  <xsl:variable name="bwStr-LCol-DownloadCalendars">Descargar Calendarios</xsl:variable>
  <xsl:variable name="bwStr-LCol-ViewAllCalendars">Ver Todas las Agendas</xsl:variable>
  <xsl:variable name="bwStr-LCol-FeedsAndWidgets">Feeds and Widgets</xsl:variable>

  <xsl:variable name="bwStr-LCol-Options">OPCIONES:</xsl:variable>
  <xsl:variable name="bwStr-LCol-CalInfo">INFORMACIÓN DE EVENTOS DE LA AGENDA:</xsl:variable>
  <xsl:variable name="bwStr-LCol-ManageEvents">Gestionar Eventos</xsl:variable>
  <xsl:variable name="bwStr-LCol-Submit">Enviar un Evento</xsl:variable>
  <xsl:variable name="bwStr-LCol-Help">Ayuda</xsl:variable>
  <xsl:variable name="bwStr-LCol-OtherCals">OTRAS AGENDAS DE LA UNIVERSIDAD</xsl:variable>
  <xsl:variable name="bwStr-LCol-ExampleLink">Enlace de ejemplo</xsl:variable>
  <xsl:variable name="bwStr-LCol-OtherLinks">OTROS ENLACES</xsl:variable>
  <xsl:variable name="bwStr-LCol-MoreDotDotDot">Mas...</xsl:variable>

  <!--  xsl:template match="event" -->
  <xsl:variable name="bwStr-SgEv-GenerateLinkToThisEvent">generar un enlace a este evento</xsl:variable>
  <xsl:variable name="bwStr-SgEv-LinkToThisEvent">enlace a este evento</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Canceled">CANCELADO:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Event">Evento</xsl:variable>
  <xsl:variable name="bwStr-SgEv-NoTitle">sin título</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Delete">Borrar</xsl:variable>
  <xsl:variable name="bwStr-SgEv-DeleteThisEvent">¿Borrar este evento?</xsl:variable>
  <xsl:variable name="bwStr-SgEv-DeleteAllRecurrences">¿Borrar todas las repeticiones de este evento?</xsl:variable>
  <xsl:variable name="bwStr-SgEv-DeleteMaster">Borrar todas las repeticiones (evento repetitivo)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-DeleteThisInstance">borrar esta ocurrencia (evento repetitivo)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-DeleteEvent">borrar el evento</xsl:variable>
  <xsl:variable name="bwStr-SgEv-All">todos</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Instance">instancia</xsl:variable>
  <!--Link, add master event reference to a calendar, add this event reference to a calendar, add event reference to a calendar -->
  <xsl:variable name="bwStr-SgEv-Copy">Copiar</xsl:variable>
  <xsl:variable name="bwStr-SgEv-CopyMaster">copiar el evento entero (evento repetitivo)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-CopyThisInstance">copiar esta ocurrencia (evento repetitivo)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-CopyEvent">copiar el evento</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Edit">Editar</xsl:variable>
  <xsl:variable name="bwStr-SgEv-EditMaster">editar el evento entero (evento repetitivo)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-EditThisInstance">editar esta ocurrencia (evento repetitivo)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-EditEvent">editar el evento</xsl:variable>
  <xsl:variable name="bwStr-SgEv-DownloadEvent">Bajar en formato ical</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Download">Bajar</xsl:variable>
  <xsl:variable name="bwStr-SgEv-DownloadMaster">bajar el evento entero (evento repetitivo)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-DownloadThisInstance">bajar esta ocurrencia (evento repetitivo)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Task">Tarea</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Meeting">Reunión</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Recurring">Repetitivo</xsl:variable>
  <xsl:variable name="bwStr-SgEv-EventLink">Evento Enlace:</xsl:variable>
  <!--public, private -->
  <xsl:variable name="bwStr-SgEv-Organizer">organizador:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-RecurrenceMaster">recurrence master</xsl:variable>
  <xsl:variable name="bwStr-SgEv-When">Cuándo:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-AllDay">(todo el día)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-FloatingTime">Hora flotante (Floating time)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-LocalTime">Hora local</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Start">Inicio:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-End">Fin:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Ends">Finaliza</xsl:variable>
  <xsl:variable name="bwStr-SgEv-DueBy">Gracias a</xsl:variable>
  <xsl:variable name="bwStr-SgEv-AddToMyCalendar">añadir a mi agenda</xsl:variable>
  <xsl:variable name="bwStr-SgEv-AddEventToMyCalendar">Añadir a MyCalendar</xsl:variable>
  <xsl:variable name="bwStr-SgEv-AddToGoogleCalendar">Añadir a Google Calendar</xsl:variable>
  <xsl:variable name="bwStr-SgEv-AddToFacebook">Añadir a Facebook</xsl:variable>
  <xsl:variable name="bwStr-SgEv-ShareThis">Compartir Esto - debe estar configurado explicitamente para su sitio.</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Where">Dónde:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Location-Accessible">This venue is wheelchair accessible</xsl:variable> <!-- XXX translate-->
  <xsl:variable name="bwStr-SgEv-Location-Map">map</xsl:variable><!-- XXX translate-->
  <xsl:variable name="bwStr-SgEv-Complete">Complete:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-ORGANIZER">Organizador:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Description">Descripción:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-STATUS">Estado:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Attendees">Asistentes:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Attendee">Asistente</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Role">papel</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Status">estado</xsl:variable>
  <xsl:variable name="bwStr-SgEv-ChangeMyStatus">cambiar mi estado</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Cost">Coste:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-See">Ver:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-MoreInfo">Más Información</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Contact">Contacto:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-ContactInfo">Información de Contacto:</xsl:variable>
  <!--Recipients:, recipient -->
  <xsl:variable name="bwStr-SgEv-Calendar">Agenda:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Categories">Etiquetas:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Comments">Comentarios:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-TopicalArea">Áreas Temáticas:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Calendars">Agendas:</xsl:variable>

  <!--  xsl:template name="listView" -->
  <xsl:variable name="bwStr-LsVw-NoEventsToDisplay">No se han encontrado eventos. Por favor, inténtelo con una vista o un intervalo de tiempo distintos.</xsl:variable>
  <xsl:variable name="bwStr-LsVw-NoEventsToDisplayWithOngoing">No se han encontrado eventos inactivos. Por favor, inténtelo con una vista o un intervalo de tiempo distintos en la lista de eventos activos.</xsl:variable>
  <xsl:variable name="bwStr-LsVw-NoEventsFromSelection">Su selección no devuelve resultados.</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Add">añadir...</xsl:variable>
  <xsl:variable name="bwStr-LsVw-AllDay">Todo el Día</xsl:variable>
  <xsl:variable name="bwStr-LsVw-At">a las</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Today">Hoy</xsl:variable>
  <xsl:variable name="bwStr-LsVw-AddEventToMyCalendar">Añadir a MyCalendar</xsl:variable>
  <xsl:variable name="bwStr-LsVw-DownloadEvent">Bajar en formato ical</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Description">descripción</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Canceled">CANCELADO:</xsl:variable>
  <xsl:variable name="bwStr-LsVw-NoTitle">sin título</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Contact">Contacto:</xsl:variable>
  <xsl:variable name="bwStr-LsVw-DispEventsForCal">Mostrando Eventos para la Agenda</xsl:variable>
  <xsl:variable name="bwStr-LsVw-DispEventsForView">Mostrando Eventos para la Vista</xsl:variable>
  <xsl:variable name="bwStr-LsVw-ShowAll">(mostrar todas)</xsl:variable>
  <xsl:variable name="bwStr-LsVw-TopicalArea">Áreas Temáticas:</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Location">Lugar:</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Cost">Coste:</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Description">Descripción:</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Link">Enlace:</xsl:variable>
  <xsl:variable name="bwStr-LsVw-ListWithinTimeRange">Lista de eventos dentro de un rango de tiempo</xsl:variable>

  <!--  xsl:template match="events" mode="eventList" -->
  <xsl:variable name="bwStr-LsEv-Event">evento</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Events">eventos</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Next7Days">Siguientes 7 Días</xsl:variable>
  <xsl:variable name="bwStr-LsEv-NoEventsToDisplay">No eventos para mostrar.</xsl:variable>
  <xsl:variable name="bwStr-LsEv-ContinueFrom">Continue from </xsl:variable><!-- XXX translate -->
  <xsl:variable name="bwStr-LsEv-ReturnToToday">Return to Today</xsl:variable><!-- XXX translate -->
  <xsl:variable name="bwStr-LsEv-Calendars">Agendas:</xsl:variable>
  <xsl:variable name="bwStr-LsEv-ClearFilters">(borrar toda)</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Search">Buscar:</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Filter">Filtro:</xsl:variable>
  <xsl:variable name="bwStr-LsEv-ClearSearch">(borrar)</xsl:variable>
  <xsl:variable name="bwStr-LsEv-DownloadEvent">Bajar en formato ical</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Categories">Categorías:</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Contact">Contacto:</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Canceled">CANCELADO:</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Tentative">INTENTO:</xsl:variable>
  <xsl:variable name="bwStr-LsEv-EventList">Lista de Eventos</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Upcoming">Próximos Eventos</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Starting">A partir</xsl:variable>

  <!--  xsl:template name="buildListEventsDaysOptions" -->

  <!--  xsl:template name="weekView" -->

  <!--  xsl:template name="monthView" -->

  <!--  xsl:template match="event" mode="calendarLayout" -->
  <xsl:variable name="bwStr-EvCG-CanceledColon">CANCELADO:</xsl:variable>
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
  <xsl:variable name="bwStr-EvCG-Recurring">petitivo</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Personal">privado</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Public">público</xsl:variable>
  <xsl:variable name="bwStr-EvCG-ViewDetails">Ver detalles</xsl:variable>
  <xsl:variable name="bwStr-EvCG-DownloadEvent">Bajar el evento en formato ical - para Outlook, PDAs, iCal, y otras agendas de sobremesa</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Download">Bajar</xsl:variable>
  <xsl:variable name="bwStr-EvCG-DownloadMaster">bajar el evento entero (evento repetitivo)</xsl:variable>
  <xsl:variable name="bwStr-EvCG-DownloadThisInstance">bajar esta ocurrencia (evento repetitivo)</xsl:variable>
  <xsl:variable name="bwStr-EvCG-All">todos</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Instance">ocurrencia</xsl:variable>
  <xsl:variable name="bwStr-EvCG-EditColon">Editar:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-EditMaster">editar el evento entero (evento repetitivo)</xsl:variable>
  <xsl:variable name="bwStr-EvCG-EditThisInstance">editar esta ocurrencia (evento repetitivo)</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Edit">Editar</xsl:variable>
  <xsl:variable name="bwStr-EvCG-EditEvent">editar el evento</xsl:variable>
  <xsl:variable name="bwStr-EvCG-CopyColon">Copiar:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-CopyMaster">copiar el evento entero (evento repetitivo)</xsl:variable>
  <xsl:variable name="bwStr-EvCG-CopyThisInstance">copiar esta ocurrencia (evento repetitivo)</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Copy">Copiar</xsl:variable>
  <xsl:variable name="bwStr-EvCG-CopyEvent">copiar el evento</xsl:variable>
  <xsl:variable name="bwStr-EvCG-LinkColon">Enlace:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Link">Enlace</xsl:variable>
  <xsl:variable name="bwStr-EvCG-DeleteColon">Borrar:</xsl:variable>
  <xsl:variable name="bwStr-EvCG-DeleteThisEvent">¿Borrar este evento?</xsl:variable>
  <xsl:variable name="bwStr-EvCG-DeleteAllRecurrences">¿Borrar todas las ocurrencias de este evento?</xsl:variable>
  <xsl:variable name="bwStr-EvCG-DeleteMaster">borrar el evento entero (evento repetitivo)</xsl:variable>
  <xsl:variable name="bwStr-EvCG-DeleteThisInstance">borrar esta ocurrencia (evento repetitivo)</xsl:variable>
  <xsl:variable name="bwStr-EvCG-DeleteEvent">borrar el evento</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Delete">Borrar</xsl:variable>

  <!--  xsl:template name="yearView" -->

  <!--  xsl:template match="month" -->

  <!--  xsl:template match="calendars" -->
  <xsl:variable name="bwStr-Cals-AllCalendars">Todas las Agendas</xsl:variable>
  <xsl:variable name="bwStr-Cals-DownloadCalendars">Download Calendars</xsl:variable>
  <xsl:variable name="bwStr-Cals-SelectCalendar">Seleccionar una agenda para descargar sus eventos en formato ical.</xsl:variable>

  <!--  xsl:template match="calendar" mode="calTree" -->
  <xsl:variable name="bwStr-Calr-Folder">carpeta</xsl:variable>
  <xsl:variable name="bwStr-Calr-Calendar">agenda</xsl:variable>

  <!--  xsl:template match="currentCalendar" mode="export" -->
  <xsl:variable name="bwStr-Cals-ExportCals">Exportar la Agenda en formato iCal</xsl:variable>
  <xsl:variable name="bwStr-Cals-CalendarToExport">Exportando:</xsl:variable>
  <xsl:variable name="bwStr-Cals-Name">Nombre:</xsl:variable>
  <xsl:variable name="bwStr-Cals-Path">Ruta:</xsl:variable>
  <xsl:variable name="bwStr-Cals-EventDateLimits">Limitar eventos por fecha:</xsl:variable>
  <xsl:variable name="bwStr-Cals-TodayForward">de hoy en adelante</xsl:variable>
  <xsl:variable name="bwStr-Cals-AllDates">todas las fechas</xsl:variable>
  <xsl:variable name="bwStr-Cals-DateRange">rango de fechas</xsl:variable>
  <xsl:variable name="bwStr-Cals-Start"><strong>Inicio:</strong></xsl:variable>
  <xsl:variable name="bwStr-Cals-End"><strong>Fin:</strong></xsl:variable>
  <xsl:variable name="bwStr-Cals-MyCalendars">Mis Agendas</xsl:variable>
  <xsl:variable name="bwStr-Cals-Export">exportar</xsl:variable>

  <!--  xsl:template name="searchResult" -->
  <xsl:variable name="bwStr-Srch-Search">Buscar:</xsl:variable>
  <xsl:variable name="bwStr-Srch-Go">go</xsl:variable>
  <xsl:variable name="bwStr-Srch-Limit">Limitar:</xsl:variable>
  <xsl:variable name="bwStr-Srch-TodayForward">de hoy en adelante</xsl:variable>
  <xsl:variable name="bwStr-Srch-PastDates">fechas pasadas</xsl:variable>
  <xsl:variable name="bwStr-Srch-AllDates">todas las fechas</xsl:variable>
  <xsl:variable name="bwStr-Srch-SearchResults">Resultados de la Búsqueda</xsl:variable>
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
  <xsl:variable name="bwStr-Srch-NoQuery">no hay consulta</xsl:variable>
  <xsl:variable name="bwStr-Srch-Result">resultado</xsl:variable>
  <xsl:variable name="bwStr-Srch-Results">resultados</xsl:variable>
  <xsl:variable name="bwStr-Srch-ReturnedFor">devueltos para:</xsl:variable>
  <xsl:variable name="bwStr-Srch-Rank">Rango</xsl:variable>
  <xsl:variable name="bwStr-Srch-Date">Fecha</xsl:variable>
  <xsl:variable name="bwStr-Srch-Summary">Sumario</xsl:variable>
  <xsl:variable name="bwStr-Srch-Location">Lugar</xsl:variable>
  <xsl:variable name="bwStr-Srch-Pages">Página:</xsl:variable>
  <xsl:variable name="bwStr-Srch-AdvancedSearch">Búsqueda Avanzada</xsl:variable>
  <xsl:variable name="bwStr-Srch-CatsToSearch">Seleccionar Categorías a Buscar (Opcional)</xsl:variable>
  <xsl:variable name="bwStr-Srch-SearchTermNotice">No es necesario un término de búsqueda si se ha seleccionado al menos una categoría.</xsl:variable>

  <!--  xsl:template name="searchResultPageNav" -->

  <!--  xsl:template name="stats" -->
  <xsl:variable name="bwStr-Stat-SysStats">Estadísticas del Sistema</xsl:variable>
  <xsl:variable name="bwStr-Stat-StatsCollection">Colección de estadísticas:</xsl:variable>
  <xsl:variable name="bwStr-Stat-Enable">activar</xsl:variable>
  <xsl:variable name="bwStr-Stat-Disable">desactivar</xsl:variable>
  <xsl:variable name="bwStr-Stat-FetchStats">recopilar estadísticas</xsl:variable>
  <xsl:variable name="bwStr-Stat-DumpStats">volcar estadísticas al log</xsl:variable>

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
  <xsl:variable name="bwStr-Foot-DemonstrationCalendar">Agenda de demostración; poner pie de información aqui.</xsl:variable>
  <xsl:variable name="bwStr-Foot-BedeworkWebsite">Sito Web de Bedework</xsl:variable>
  <xsl:variable name="bwStr-Foot-ShowXML">Mostrar XML</xsl:variable>
  <xsl:variable name="bwStr-Foot-RefreshXSLT">Refrescar XSLT</xsl:variable>
  <xsl:variable name="bwStr-Foot-BasedOnThe">Basado en el</xsl:variable>
  <xsl:variable name="bwStr-Foot-BedeworkCalendarSystem">Sistema de Agenda Bedework</xsl:variable>
  <xsl:variable name="bwStr-Foot-ProductionExamples">Ejemplos en Producción</xsl:variable>
  <xsl:variable name="bwStr-Foot-ExampleStyles">ejemplos de estilo</xsl:variable>
  <xsl:variable name="bwStr-Foot-Green">verde</xsl:variable>
  <xsl:variable name="bwStr-Foot-Red">rojo</xsl:variable>
  <xsl:variable name="bwStr-Foot-Blue">azúl</xsl:variable>
  <xsl:variable name="bwStr-Foot-ResetSkin">Reiniciar Skin</xsl:variable>
  <xsl:variable name="bwStr-Foot-ExampleSkins">ejemplos de temas/skins:</xsl:variable>
  <xsl:variable name="bwStr-Foot-BwClassic">Bedework Clásico</xsl:variable>
  <xsl:variable name="bwStr-Foot-BwWhite">Bedework Blanco</xsl:variable>
  <xsl:variable name="bwStr-Foot-RSSNext3Days">RSS: siguientes 3 días</xsl:variable>
  <xsl:variable name="bwStr-Foot-JavascriptNext3Days">JSON: siguientes 3 días</xsl:variable>
  <xsl:variable name="bwStr-Foot-JavascriptTodaysEvents">javascript: eventos para hoy</xsl:variable>
  <xsl:variable name="bwStr-Foot-ForMobileBrowsers">Bedework iPhone/Móvil</xsl:variable>
  <xsl:variable name="bwStr-Foot-VideoFeed">hoja de video</xsl:variable>
  <xsl:variable name="bwStr-Foot-ResetToCalendarDefault">Bedework por Defecto (3.10)</xsl:variable>
  <xsl:variable name="bwStr-Foot-BwTheme3p9">Bedework 3.9 Theme</xsl:variable>
  <xsl:variable name="bwStr-Foot-Credits">Este tema está basado en el trabajo de las Universidades Duke y Yale, agradeciendo igualmente la colaboración de la Universidad de Chicago</xsl:variable>

</xsl:stylesheet>
