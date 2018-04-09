<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml">

  <!-- All text exposed by the stylesheets is set here. -->
  <!-- To change the language of a web client, translate the strings file. -->

  <xsl:variable name="bwStr-Root-PageTitle">Escuela de Ingeniería - Agenda de Eventos Bedework</xsl:variable>
  <xsl:variable name="bwStr-Error">Error:</xsl:variable>

  <!-- xsl:template name="headBar" -->
  <xsl:variable name="bwStr-HdBr-PageTitle">Agenda de Eventos Bedework</xsl:variable>
  <xsl:variable name="bwStr-HdBr-PublicCalendar">Agenda Pública</xsl:variable>
  <xsl:variable name="bwStr-HdBr-PersonalCalendar">Agenda Privada</xsl:variable>
  <xsl:variable name="bwStr-HdBr-SchoolOfEng">Escuela de Ingeniería</xsl:variable>
  <xsl:variable name="bwStr-HdBr-SchoolOfEngHome">Página inicial de la Escuela de Ingeniería</xsl:variable>
  <xsl:variable name="bwStr-HdBr-UniversityHome">Página Inicial de la  Universidad</xsl:variable>
  <xsl:variable name="bwStr-HdBr-SchoolHome">Página Inicial de la Escuela</xsl:variable>
  <xsl:variable name="bwStr-HdBr-OtherLink">Otro Enlace</xsl:variable>
  <xsl:variable name="bwStr-HdBr-ExampleCalendarHelp">Ayuda de la Agenda de Ejemplo</xsl:variable>
  <xsl:variable name="bwStr-HdBr-Print">imprimir</xsl:variable>
  <xsl:variable name="bwStr-HdBr-PrintThisView">imprimir esta vista</xsl:variable>
  <xsl:variable name="bwStr-HdBr-RSS">RSS</xsl:variable>
  <xsl:variable name="bwStr-HdBr-RSSFeed">hoja RSS</xsl:variable>
  <xsl:variable name="bwStr-HdBr-EventInformation">Información del Evento</xsl:variable>
  <xsl:variable name="bwStr-HdBr-BackLink">(volver a los eventos)</xsl:variable>
  <xsl:variable name="bwStr-HdBr-Back">&#8656; atrás</xsl:variable>

  <!-- ongoing events -->
  <xsl:variable name="bwStr-Ongoing-Title">En curso</xsl:variable>
  <xsl:variable name="bwStr-Ongoing-NoEvents">No hay eventos en curso en esta vista o periodo de tiempo</xsl:variable>

  <!-- deadlines -->
  <xsl:variable name="bwStr-Deadline-Title">Fechas tope</xsl:variable>
  <xsl:variable name="bwStr-Deadline-NoEvents">No hay fechas tope en esta vista o periodo de tiempo</xsl:variable>


  <!--  xsl:template name="tabs" -->
  <xsl:variable name="bwStr-Tabs-LoggedInAs">conectado como</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Logout">desconectar</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Today">HOY</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Day">DÍA</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Week">SEMANA</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Month">MES</xsl:variable>
  <xsl:variable name="bwStr-Tabs-Year">AÑO</xsl:variable>
  <xsl:variable name="bwStr-Tabs-List">LISTA</xsl:variable>

  <!--  xsl:template name="navigation" -->
  <xsl:variable name="bwStr-Navi-WeekOf">Semana de</xsl:variable>
  <xsl:variable name="bwStr-Navi-Go">ir</xsl:variable>
  <xsl:variable name="bwStr-Navi-Today">hoy</xsl:variable>

  <!--  xsl:template name="searchBar" -->
  <xsl:variable name="bwStr-SrcB-Add">Añadir...</xsl:variable>
  <xsl:variable name="bwStr-SrcB-View">Vista:</xsl:variable>
  <xsl:variable name="bwStr-SrcB-Select">seleccionar...</xsl:variable>
  <xsl:variable name="bwStr-SrcB-DefaultView">vista por defecto</xsl:variable>
  <xsl:variable name="bwStr-SrcB-AllCalendars">todas las agendas</xsl:variable>
  <xsl:variable name="bwStr-SrcB-Search">Buscar:</xsl:variable>
  <xsl:variable name="bwStr-SrcB-Go">ir</xsl:variable>
  <xsl:variable name="bwStr-Util-List">LISTA</xsl:variable>
  <xsl:variable name="bwStr-Util-Cal">AGENDA</xsl:variable>
  <xsl:variable name="bwStr-SrcB-ToggleListCalView">alternar vista lista/agenda</xsl:variable>
  <xsl:variable name="bwStr-Util-Summary">SUMARIO</xsl:variable>
  <xsl:variable name="bwStr-Util-Details">DETALLES</xsl:variable>
  <xsl:variable name="bwStr-SrcB-ToggleSummDetView">alternar vista sumario/detalle</xsl:variable>
  <xsl:variable name="bwStr-SrcB-ShowDetails">Mostrar Detalles</xsl:variable>
  <xsl:variable name="bwStr-SrcB-HideDetails">Ocultar Detalles</xsl:variable>
  <xsl:variable name="bwStr-SrcB-Summary">Sumario</xsl:variable>
  <xsl:variable name="bwStr-SrcB-Details">Detalles</xsl:variable>
  <xsl:variable name="bwStr-SrcB-Calendar">Agenda:</xsl:variable>
  <xsl:variable name="bwStr-SrcB-CurrentSearch">Búsqueda actual:</xsl:variable>
  <xsl:variable name="bwStr-SrcB-Clear">quitar</xsl:variable>

  <!--  xsl:template name="leftColumn", "viewList", and "sideBar" -->
  <xsl:variable name="bwStr-LCol-JsMessage">Para ver la agenda interactiva, por favor active Javascript en su navegador.</xsl:variable>
  <xsl:variable name="bwStr-LCol-CalendarViews">Vistas de Agendas</xsl:variable>
  <xsl:variable name="bwStr-LCol-FilterOnCalendars">FILTROS EN AGENDAS:</xsl:variable>
  <xsl:variable name="bwStr-LCol-ViewAllCalendars">Ver Todas las Agendas</xsl:variable>

  <xsl:variable name="bwStr-LCol-CalInfo">INFO. AGENDA DE EVENTOS:</xsl:variable>
  <xsl:variable name="bwStr-LCol-ManageEvents">Gestionar Eventos</xsl:variable>
  <xsl:variable name="bwStr-LCol-Submit">Enviar un Evento</xsl:variable>
  <xsl:variable name="bwStr-LCol-Help">Ayuda</xsl:variable>
  <xsl:variable name="bwStr-LCol-OtherCals">OTRAS AGENDAS DE LA UNIVERSIDAD</xsl:variable>
  <xsl:variable name="bwStr-LCol-ExampleLink">Enlace de ejemplo</xsl:variable>
  <xsl:variable name="bwStr-LCol-OtherLinks">OTROS ENLACES</xsl:variable>


  <!--  xsl:template match="event" -->
  <xsl:variable name="bwStr-SgEv-GenerateLinkToThisEvent">generar enlace a este evento</xsl:variable>
  <xsl:variable name="bwStr-SgEv-LinkToThisEvent">enlace a este evento</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Canceled">CANCELADO</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Event">Evento</xsl:variable>
  <xsl:variable name="bwStr-SgEv-NoTitle">sin título</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Delete">Borrar</xsl:variable>
  <xsl:variable name="bwStr-SgEv-DeleteThisEvent">¿Borrar este evento?</xsl:variable>
  <xsl:variable name="bwStr-SgEv-DeleteAllRecurrences">¿Borrar todas las repeticiones de este evento?</xsl:variable>
  <xsl:variable name="bwStr-SgEv-DeleteMaster">borrar el evento entero (evento repetitivo)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-DeleteThisInstance">borrar esta ocurrencia (evento repetitivo)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-DeleteEvent">borrar evento</xsl:variable>
  <xsl:variable name="bwStr-SgEv-All">todas</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Instance">ocurrencia</xsl:variable>
  <!--Link, add master event reference to a calendar, add this event reference to a calendar, add event reference to a calendar -->
  <xsl:variable name="bwStr-SgEv-Copy">Copiar</xsl:variable>
  <xsl:variable name="bwStr-SgEv-CopyMaster">copiar el evento entero (evento repetitivo)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-CopyThisInstance">copiar esta ocurrencia (evento repetitivo)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-CopyEvent">copiar evento</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Edit">Editar</xsl:variable>
  <xsl:variable name="bwStr-SgEv-EditMaster">editar el evento entero(evento repetitivo)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-EditThisInstance">editar esta ocurrencia (evento repetitivo)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-EditEvent">editar evento</xsl:variable>
  <xsl:variable name="bwStr-SgEv-DownloadEvent">Bajar en formato ical</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Download">Bajar</xsl:variable>
  <xsl:variable name="bwStr-SgEv-DownloadMaster">bajar el evento entero (evento repetitivo)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-DownloadThisInstance">bajar esta ocurrencia (evento repetitivo)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Task">Tarea</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Meeting">Reunión</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Recurring">Repetitivo</xsl:variable>
  <xsl:variable name="bwStr-SgEv-EventLink">Event Link:</xsl:variable>
  <!--public, private -->
  <xsl:variable name="bwStr-SgEv-Organizer">organizador:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-RecurrenceMaster">evento principal</xsl:variable>
  <xsl:variable name="bwStr-SgEv-When">Cuándo:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-AllDay">(todo el día)</xsl:variable>
  <xsl:variable name="bwStr-SgEv-FloatingTime">Hora flotante</xsl:variable>
  <xsl:variable name="bwStr-SgEv-LocalTime">Hora local</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Start">Inicio:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-End">Final:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Ends">Finaliza</xsl:variable>
  <xsl:variable name="bwStr-SgEv-DueBy">Promovido por</xsl:variable>
  <xsl:variable name="bwStr-SgEv-AddToMyCalendar">añadir a mi agenda</xsl:variable>
  <xsl:variable name="bwStr-SgEv-AddEventToMyCalendar">Añadir a MyAgenda</xsl:variable>
  <xsl:variable name="bwStr-SgEv-AddToGoogleCalendar">Añadir a Google Calendar</xsl:variable>
  <xsl:variable name="bwStr-SgEv-AddToFacebook">Añadir a Facebook</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Where">Cuándo:</xsl:variable>
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
  <xsl:variable name="bwStr-SgEv-MoreInfo">Más Inf.</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Contact">Contacto:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-ContactInfo">Información de Contacto:</xsl:variable>
  <!--Recipients:, recipient -->
  <xsl:variable name="bwStr-SgEv-Calendar">Agenda:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Categories">Etiquetas:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-Comments">Comentarios:</xsl:variable>
  <xsl:variable name="bwStr-SgEv-TopicalArea">Áreas Temáticas:</xsl:variable>

  <!--  xsl:template name="listView" -->
  <xsl:variable name="bwStr-LsVw-NoEventsToDisplay">No se han encontrado eventos. Por favor, inténtelo con una vista o periodo de tiempo distintos.</xsl:variable>
  <xsl:variable name="bwStr-LsVw-NoEventsToDisplayWithOngoing">No se han encontrado eventos que no estén en curso. Por favor, inténtelo con una vista o periodo de tiempo distintos o vea la lista de eventos En Curso.</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Add">añadir...</xsl:variable>
  <xsl:variable name="bwStr-LsVw-AllDay">Todo el Día</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Today">Hoy</xsl:variable>
  <xsl:variable name="bwStr-LsVw-AddEventToMyCalendar">Añadir a MyAgenda</xsl:variable>
  <xsl:variable name="bwStr-LsVw-DownloadEvent">Bajar en formato ical</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Description">descripción</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Canceled">CANCELADO:</xsl:variable>
  <xsl:variable name="bwStr-LsVw-NoTitle">sin título</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Contact">Contacto:</xsl:variable>
  <xsl:variable name="bwStr-LsVw-DispEventsForCal">Visualizando Eventos para Agenda</xsl:variable>
  <xsl:variable name="bwStr-LsVw-DispEventsForView">Visualizando Eventos para Vista</xsl:variable>
  <xsl:variable name="bwStr-LsVw-ShowAll">(mostrar todos)</xsl:variable>
  <xsl:variable name="bwStr-LsVw-TopicalArea">Áreas Temáticas:</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Location">Lugar:</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Cost">Precio:</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Description">Descripción:</xsl:variable>
  <xsl:variable name="bwStr-LsVw-Link">Enlace:</xsl:variable>

  <!--  xsl:template match="events" mode="eventList" -->
  <xsl:variable name="bwStr-LsEv-Next7Days">Siguientes 7 Días</xsl:variable>
  <xsl:variable name="bwStr-LsEv-NoEventsToDisplay">No hay eventos para mostrar.</xsl:variable>
  <xsl:variable name="bwStr-LsEv-DownloadEvent">Bajar en formato ical</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Categories">Categorías:</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Contact">Contacto:</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Canceled">CANCELADO:</xsl:variable>
  <xsl:variable name="bwStr-LsEv-Tentative">INTENTO:</xsl:variable>
  <xsl:variable name="bwStr-LsEv-EventList">Lista de Eventos</xsl:variable>

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
  <xsl:variable name="bwStr-EvCG-Recurring">repitiéndose</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Personal">privado</xsl:variable>
  <xsl:variable name="bwStr-EvCG-Public">público</xsl:variable>
  <xsl:variable name="bwStr-EvCG-ViewDetails">Ver detalles</xsl:variable>
  <xsl:variable name="bwStr-EvCG-DownloadEvent">Bajar el evento en formato ical - para Outlook, PDAs, iCal y otras agendas de escritorio </xsl:variable>
  <xsl:variable name="bwStr-EvCG-Download">Bajar</xsl:variable>
  <xsl:variable name="bwStr-EvCG-DownloadMaster">bajar el evento entero (evento repetitivo)</xsl:variable>
  <xsl:variable name="bwStr-EvCG-DownloadThisInstance">bajar esta ocurrencia (evento repetitivo)</xsl:variable>
  <xsl:variable name="bwStr-EvCG-All">todas</xsl:variable>
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

  <!--  xsl:template name="yearView" -->

  <!--  xsl:template match="month" -->

  <!--  xsl:template match="calendars" -->
  <xsl:variable name="bwStr-Cals-AllCalendars">Todas las Agendas</xsl:variable>
  <xsl:variable name="bwStr-Cals-SelectCalendar">Seleccione una agenda para ver sólo sus eventos.</xsl:variable>

  <!--  xsl:template match="calendar" mode="calTree" -->
  <xsl:variable name="bwStr-Calr-Folder">carpeta</xsl:variable>
  <xsl:variable name="bwStr-Calr-Calendar">agenda</xsl:variable>

  <!--  xsl:template match="currentCalendar" mode="export" -->
  <xsl:variable name="bwStr-Cals-ExportCals">Exportar Agendas en Formato iCal</xsl:variable>
  <xsl:variable name="bwStr-Cals-CalendarToExport">Exportando:</xsl:variable>
  <xsl:variable name="bwStr-Cals-Name">Nombre:</xsl:variable>
  <xsl:variable name="bwStr-Cals-Path">Ruta:</xsl:variable>
  <xsl:variable name="bwStr-Cals-EventDateLimits">Límites de fecha de eventos:</xsl:variable>
  <xsl:variable name="bwStr-Cals-TodayForward">de hoy en adelante</xsl:variable>
  <xsl:variable name="bwStr-Cals-AllDates">todas las fechas</xsl:variable>
  <xsl:variable name="bwStr-Cals-DateRange">rango de fechas</xsl:variable>
  <xsl:variable name="bwStr-Cals-Start"><strong>Inicio:</strong></xsl:variable>
  <xsl:variable name="bwStr-Cals-End"><strong>Fin:</strong></xsl:variable>
  <xsl:variable name="bwStr-Cals-MyCalendars">Mis Agendas</xsl:variable>
  <xsl:variable name="bwStr-Cals-Export">exportar</xsl:variable>

  <!--  xsl:template name="searchResult" -->
  <xsl:variable name="bwStr-Srch-Search">Buscar:</xsl:variable>
  <xsl:variable name="bwStr-Srch-Go">ir</xsl:variable>
  <xsl:variable name="bwStr-Srch-Limit">Limitar:</xsl:variable>
  <xsl:variable name="bwStr-Srch-TodayForward">de hoy en adelante</xsl:variable>
  <xsl:variable name="bwStr-Srch-PastDates">fechas pasadas</xsl:variable>
  <xsl:variable name="bwStr-Srch-AllDates">todas las fechas</xsl:variable>
  <xsl:variable name="bwStr-Srch-SearchResults">Resultados de Búsqueda</xsl:variable>
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
  <xsl:variable name="bwStr-Srch-ReturnedFor">devuelto(s) para:</xsl:variable>
  <xsl:variable name="bwStr-Srch-Rank">Rango</xsl:variable>
  <xsl:variable name="bwStr-Srch-Date">Fecha</xsl:variable>
  <xsl:variable name="bwStr-Srch-Summary">Sumario</xsl:variable>
  <xsl:variable name="bwStr-Srch-Location">Lugar</xsl:variable>
  <xsl:variable name="bwStr-Srch-Pages">Página(s):</xsl:variable>
  <xsl:variable name="bwStr-Srch-AdvancedSearch">Búsqueda Avanzada</xsl:variable>
  <xsl:variable name="bwStr-Srch-CatsToSearch">Selecccione Categorías a Buscar (Opcional)</xsl:variable>
  <xsl:variable name="bwStr-Srch-SearchTermNotice">No se requiere un término de búsqueda si se ha seleccionado al menos una categoría.</xsl:variable>

  <!--  xsl:template name="searchResultPageNav" -->

  <!--  xsl:template name="stats" -->
  <xsl:variable name="bwStr-Stat-SysStats">Estadísticas del Sistema</xsl:variable>
  <xsl:variable name="bwStr-Stat-StatsCollection">Colección de estadísticas:</xsl:variable>
  <xsl:variable name="bwStr-Stat-Enable">activar</xsl:variable>
  <xsl:variable name="bwStr-Stat-Disable">desactivar</xsl:variable>
  <xsl:variable name="bwStr-Stat-FetchStats">recopilar estadísticas</xsl:variable>
  <xsl:variable name="bwStr-Stat-DumpStats">volcar estadísticas al log</xsl:variable>

  <!--  xsl:template name="footer" -->
  <xsl:variable name="bwStr-Foot-DemonstrationCalendar">Agenda de Ejemplo; poner información de pie de página aquí.</xsl:variable>
  <xsl:variable name="bwStr-Foot-BedeworkWebsite">Sitio Web de Bedework</xsl:variable>
  <xsl:variable name="bwStr-Foot-ShowXML">Mostrar XML</xsl:variable>
  <xsl:variable name="bwStr-Foot-RefreshXSLT">Refrescar XSLT</xsl:variable>
  <xsl:variable name="bwStr-Foot-BasedOnThe">Basado en</xsl:variable>
  <xsl:variable name="bwStr-Foot-BedeworkCalendarSystem">Sistema de Agenda Bedework</xsl:variable>
  <xsl:variable name="bwStr-Foot-ProductionExamples">Ejemplos en Producción</xsl:variable>
  <xsl:variable name="bwStr-Foot-ExampleStyles">estilos de ejemplo</xsl:variable>
  <xsl:variable name="bwStr-Foot-Green">verde</xsl:variable>
  <xsl:variable name="bwStr-Foot-Red">rojo</xsl:variable>
  <xsl:variable name="bwStr-Foot-Blue">azúl</xsl:variable>
  <xsl:variable name="bwStr-Foot-ResetSkin">Restablecer Máscara</xsl:variable>
  <xsl:variable name="bwStr-Foot-ExampleSkins">temas/máscaras de ejemplo:</xsl:variable>
  <xsl:variable name="bwStr-Foot-BwClassic">Bedework Clásico</xsl:variable>
  <xsl:variable name="bwStr-Foot-RSSNext3Days">RSS: siguientes 3 días</xsl:variable>
  <xsl:variable name="bwStr-Foot-JavascriptNext3Days">JSON: siguientes 3 días</xsl:variable>
  <xsl:variable name="bwStr-Foot-JavascriptTodaysEvents">javascript: eventos para hoy</xsl:variable>
  <xsl:variable name="bwStr-Foot-ForMobileBrowsers">Bedework iPhone/Móvil</xsl:variable>
  <xsl:variable name="bwStr-Foot-VideoFeed">hoja de video</xsl:variable>
  <xsl:variable name="bwStr-Foot-ResetToCalendarDefault">Bedework por Defecto</xsl:variable>
  <xsl:variable name="bwStr-Foot-Credits">Este tema está basado en el trabajo de las Universidades Duke y Yale, agradeciendo igualmente la colaboración de la Universidad de Chicago</xsl:variable>

</xsl:stylesheet>
