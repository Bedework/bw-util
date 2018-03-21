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

  <!-- include the common language string libraries -->
  <xsl:include href="/bedework-common/es_ES/default/errors.xsl" />
  <xsl:include href="/bedework-common/es_ES/default/messages.xsl" />
  <xsl:include href="/bedework-common/es_ES/default/bedeworkAccessStrings.xsl"/>

  <!--  xsl:template match="/" -->
  <xsl:variable name="bwStr-Root-PageTitle">Administración de calendario: Administración de eventos públicos</xsl:variable>
  <xsl:variable name="bwStr-Root-NoAdminGroup">Ningún grupo administrativo</xsl:variable>
  <xsl:variable name="bwStr-Root-YourUseridNotAssigned">Su identificador de usuario (userid) no está asignado a un grupo administrativo. Por favor, informe a su administrador.</xsl:variable>
  <xsl:variable name="bwStr-Root-NoAccess">Sin acceso</xsl:variable>
  <xsl:variable name="bwStr-Root-YouHaveNoAccess">No tiene acceso a la acción que ha intentado. Si cree que debería tenerlo y el problema persiste, contacte con su administrador.</xsl:variable>
  <xsl:variable name="bwStr-Root-Continue">continuar</xsl:variable>
  <xsl:variable name="bwStr-Root-AppError">Error de la aplicación</xsl:variable>
  <xsl:variable name="bwStr-Root-AppErrorOccurred">Un error de la aplicación ha ocurrido.</xsl:variable>

  <!--  xsl:template name="header" -->
  <xsl:variable name="bwStr-Head-BedeworkPubEventsAdmin">Administración de eventos públicos de Bedework</xsl:variable>
  <xsl:variable name="bwStr-Head-CalendarSuite">Calendar Suite</xsl:variable>
  <xsl:variable name="bwStr-Head-None">ninguno</xsl:variable>
  <xsl:variable name="bwStr-Head-Group">Grupo:</xsl:variable>
  <xsl:variable name="bwStr-Head-Change">cambiar</xsl:variable>
  <xsl:variable name="bwStr-Head-LoggedInAs">Conectado como:</xsl:variable>
  <xsl:variable name="bwStr-Head-LogOut">desconectar</xsl:variable>
  <xsl:variable name="bwStr-Head-MainMenu">Menu Principal</xsl:variable>
  <xsl:variable name="bwStr-Head-PendingEvents">Cola pendiente</xsl:variable>
  <xsl:variable name="bwStr-Head-ApprovalQueueEvents">Cola de aprobación</xsl:variable>
  <xsl:variable name="bwStr-Head-SuggestionQueueEvents">Cola de sugerencia</xsl:variable>
  <xsl:variable name="bwStr-Head-Users">Usuarios</xsl:variable>
  <xsl:variable name="bwStr-Head-System">Sistema</xsl:variable>
  <!-- notifications (in header) -->
  <xsl:variable name="bwStr-Notification-EventSuggestion">Sugerencia:</xsl:variable>
  <xsl:variable name="bwStr-Notification-SuggestionTo">Sugerencia a</xsl:variable>
  <xsl:variable name="bwStr-Notification-Awaiting">Espera de aprobación:</xsl:variable>
  <xsl:variable name="bwStr-Notification-Accepted">aceptado</xsl:variable>
  <xsl:variable name="bwStr-Notification-Rejected">rechazar</xsl:variable>
  <xsl:variable name="bwStr-Notification-DeclinedLower">rechazar</xsl:variable>
  <xsl:variable name="bwStr-Notification-AcceptedResp">Aceptado:</xsl:variable>
  <xsl:variable name="bwStr-Notification-Declined">Rechazar:</xsl:variable>
  <xsl:variable name="bwStr-Notification-Dismiss">quitar</xsl:variable>
  <xsl:variable name="bwStr-Notification-ViewEvent">ver evento</xsl:variable>
  <xsl:variable name="bwStr-Notification-EventRemoved">--evento eliminado--</xsl:variable>


  <!--  xsl:template name="messagesAndErrors" -->

  <!--  xsl:template name="mainMenu" -->
  <xsl:variable name="bwStr-MMnu-LoggedInAs">Está conectado como superusuario.</xsl:variable>
  <xsl:variable name="bwStr-MMnu-YouMustBeOperating">Debe estar operando en el contexto de un calendar suite\n para añadir o gestionar eventos.\n\nSu grupo actual no está asociado con un calendar suite\no un hijo de un grupo asociado con un calendar suite.</xsl:variable>
  <xsl:variable name="bwStr-MMnu-AddEvent">Añadir evento</xsl:variable>
  <xsl:variable name="bwStr-MMnu-AddContact">Añadir contacto</xsl:variable>
  <xsl:variable name="bwStr-MMnu-AddLocation">Añadir localización</xsl:variable>
  <xsl:variable name="bwStr-MMnu-AddCategory">Añadir categoría</xsl:variable>
  <xsl:variable name="bwStr-MMnu-ManageEvents">Gestionar eventos</xsl:variable>
  <xsl:variable name="bwStr-MMnu-ManageContacts">Gestionar contactos</xsl:variable>
  <xsl:variable name="bwStr-MMnu-ManageLocations">Gestionar localizaciones</xsl:variable>
  <xsl:variable name="bwStr-MMnu-ManageCategories">Gestionar categorías</xsl:variable>
  <xsl:variable name="bwStr-MMnu-EventSearch">Búsqueda de eventos:</xsl:variable>
  <xsl:variable name="bwStr-MMnu-Go">ir</xsl:variable>
  <xsl:variable name="bwStr-MMnu-Limit">Limitar:</xsl:variable>
  <xsl:variable name="bwStr-MMnu-TodayForward">de hoy en adelante</xsl:variable>
  <xsl:variable name="bwStr-MMnu-PastDates">fechas pasadas</xsl:variable>
  <xsl:variable name="bwStr-MMnu-AddDates">todas las fechas</xsl:variable>

  <!--  xsl:template name="tabPendingEvents" -->
  <xsl:variable name="bwStr-TaPE-PendingEvents">Cola de pendientes</xsl:variable>
  <xsl:variable name="bwStr-TaPE-EventsAwaitingModeration">Los siguientes eventos están pendientes de moderación:</xsl:variable>

  <!--  xsl:template name="tabApprovalQueueEvents" -->
  <xsl:variable name="bwStr-TaAQ-ApprovalQueueEvents">Cola de aprobación</xsl:variable>
  <xsl:variable name="bwStr-TaAQ-EventsAwaitingApproval">Los siguientes eventos están en espera de aprobación:</xsl:variable>

  <!--  xsl:template name="tabSuggestionQueueEvents" -->
  <xsl:variable name="bwStr-TaAQ-SuggestionQueueEvents">Cola sugerencia</xsl:variable>
  <xsl:variable name="bwStr-TaAQ-SuggestedEvents">Los siguientes eventos son sugeridas por otros grupos para su inclusión en su suite:</xsl:variable>
  <xsl:variable name="bwStr-TaAQ-View">Ver:</xsl:variable>
  <xsl:variable name="bwStr-TaAQ-Suggested">sugiere</xsl:variable>
  <xsl:variable name="bwStr-TaAQ-Accepted">aceptado</xsl:variable>
  <xsl:variable name="bwStr-TaAQ-Rejected">rechazar</xsl:variable>
  <xsl:variable name="bwStr-TaAQ-Unknown">ignoto</xsl:variable>

  <!--  xsl:template name="tabCalsuite" -->
  <xsl:variable name="bwStr-TaCS-ManageCalendarSuite">Gestión de Calendar Suite</xsl:variable>
  <xsl:variable name="bwStr-TaCS-CalendarSuite">Calendar Suite:</xsl:variable>
  <xsl:variable name="bwStr-TaCS-Group">Grupo:</xsl:variable>
  <xsl:variable name="bwStr-TaCS-Change">cambiar</xsl:variable>
  <xsl:variable name="bwStr-TaCS-ManageSubscriptions">Gestionar suscripciones</xsl:variable>
  <xsl:variable name="bwStr-TaCS-ManageViews">Gestionar vistas</xsl:variable>
  <xsl:variable name="bwStr-TaCS-ManagePreferences">Gestionar preferencias</xsl:variable>
  <xsl:variable name="bwStr-TaCS-ManageResources">Gestionar los recursos</xsl:variable>

  <!--  xsl:template name="tabUsers" -->
  <xsl:variable name="bwStr-TaUs-ManageUsersAndGroups">Gestionar usuarios y grupos</xsl:variable>
  <xsl:variable name="bwStr-TaUs-ManageAdminRoles">Gestionar roles de administración</xsl:variable>
  <xsl:variable name="bwStr-TaUs-ManageAdminGroups">Gestionar grupos de administración</xsl:variable>
  <xsl:variable name="bwStr-TaUs-ChangeGroup">Cambiar grupo...</xsl:variable>
  <xsl:variable name="bwStr-TaUs-EditUsersPrefs">Editar preferencias del usuario (introducir userid):</xsl:variable>
  <xsl:variable name="bwStr-TaUs-Go">ir</xsl:variable>

  <!--  xsl:template name="tabSystem" -->
  <xsl:variable name="bwStr-TaSy-ManageSys">Gestionar sistema</xsl:variable>
  <xsl:variable name="bwStr-TaSy-ManageCalsAndFolders">Gestionar calendarios y carpetas</xsl:variable>
  <xsl:variable name="bwStr-TaSy-ManageCategories">Gestionar categorías</xsl:variable>
  <xsl:variable name="bwStr-TaSy-ManageCalSuites">Gestionar calendar suites</xsl:variable>
  <xsl:variable name="bwStr-TaSy-UploadICalFile">Cargar archivo ical</xsl:variable>
  <xsl:variable name="bwStr-TaSy-ManageSysPrefs">Gestionar preferencias del sistema</xsl:variable>
  <xsl:variable name="bwStr-TaSy-ManageSysTZs">Gestionar zonas horarias del sistema</xsl:variable>
  <xsl:variable name="bwStr-TaSy-Stats">Estadísticas:</xsl:variable>
  <xsl:variable name="bwStr-TaSy-AdminWebClient">Cliente web administración</xsl:variable>
  <xsl:variable name="bwStr-TaSy-PublicWebClient">Cliente web público</xsl:variable>
  <xsl:variable name="bwStr-TaSy-ManageCalDAVFilters">Gestionar filtros de CalDAV</xsl:variable>
  <xsl:variable name="bwStr-TaSy-ManageGlobalResources">Manage global resources</xsl:variable>

  <!--  xsl:template name="eventList" -->
  <xsl:variable name="bwStr-EvLs-ManageEvents">Gestionar eventos</xsl:variable>
  <xsl:variable name="bwStr-EvLs-SelectEvent">Seleccione el evento que desearía actualizar:</xsl:variable>
  <xsl:variable name="bwStr-EvLs-PageTitle">Añadir nuevo evento</xsl:variable>
  <xsl:variable name="bwStr-EvLs-StartDate">Fecha de inicio:</xsl:variable>
  <xsl:variable name="bwStr-EvLs-Today">Hoy</xsl:variable>
  <xsl:variable name="bwStr-EvLs-Days">Día:</xsl:variable>
  <xsl:variable name="bwStr-EvLs-Show">Mostrar:</xsl:variable>
  <xsl:variable name="bwStr-EvLs-Active">Activo</xsl:variable>
  <xsl:variable name="bwStr-EvLs-All">Todo</xsl:variable>
  <xsl:variable name="bwStr-EvLs-Calendar">Calendar:</xsl:variable>
  <xsl:variable name="bwStr-EvLs-FilterBy">Filtrar por:</xsl:variable>
  <xsl:variable name="bwStr-EvLs-SortBy">Ordenar por:</xsl:variable>
  <xsl:variable name="bwStr-EvLs-SortByStart">Start Date</xsl:variable><!-- XXX translate -->
  <xsl:variable name="bwStr-EvLs-SortByModified">Modified Date</xsl:variable><!-- XXX translate -->
  <xsl:variable name="bwStr-EvLs-SortByCreated">Created Date</xsl:variable><!-- XXX translate -->
  <xsl:variable name="bwStr-EvLs-SelectCategory">seleccionar una categoría</xsl:variable>
  <xsl:variable name="bwStr-EvLs-ClearFilter">limpiar filtro</xsl:variable>
  <xsl:variable name="bwStr-EvLs-Previous">Anterior</xsl:variable>
  <xsl:variable name="bwStr-EvLs-Next">Siguiente</xsl:variable>
  <xsl:variable name="bwStr-EvLs-PublicUrl">URL Pública:</xsl:variable>

  <!--  xsl:template name="eventListCommon" -->
  <xsl:variable name="bwStr-EvLC-Title">Título</xsl:variable>
  <xsl:variable name="bwStr-EvLC-CalSuite">Suite</xsl:variable>
  <xsl:variable name="bwStr-EvLC-ClaimedBy">Solicitado por</xsl:variable>
  <xsl:variable name="bwStr-EvLC-Start">Comienzo</xsl:variable>
  <xsl:variable name="bwStr-EvLC-End">Final</xsl:variable>
  <xsl:variable name="bwStr-EvLC-Suggested">Sugerido</xsl:variable>
  <xsl:variable name="bwStr-EvLC-TopicalAreas">Áreas topicas </xsl:variable>
  <xsl:variable name="bwStr-EvLC-Categories">Categorías</xsl:variable>
  <xsl:variable name="bwStr-EvLC-Author">Autor</xsl:variable>
  <xsl:variable name="bwStr-EvLC-Description">Descripción</xsl:variable>
  <xsl:variable name="bwStr-EvLC-NoEvents">No hay eventos para mostrar</xsl:variable>

  <xsl:variable name="bwStr-EvLC-Page">Página</xsl:variable>
  <xsl:variable name="bwStr-EvLC-Of">de</xsl:variable>
  <xsl:variable name="bwStr-EvLC-Viewing">Viendo</xsl:variable>
  <xsl:variable name="bwStr-EvLC-EventsInA">eventos de</xsl:variable>
  <xsl:variable name="bwStr-EvLC-DayWindow">días</xsl:variable>

  <!--  xsl:template match="event" mode="eventListCommon" -->
  <xsl:variable name="bwStr-EvLC-NoTitle">sin título</xsl:variable>
  <xsl:variable name="bwStr-EvLC-Unclaimed">sin solicitante</xsl:variable>
  <xsl:variable name="bwStr-EvLC-ThisEventCrossTagged">Este evento tiene referencias cruzadas en sus etiquetas.</xsl:variable>
  <xsl:variable name="bwStr-EvLC-ShowTagsByOtherGroups">Mostrar etiquetas por otros grupos</xsl:variable>
  <xsl:variable name="bwStr-EvLC-RecurringEventEdit">Evento recurrente. Editar:</xsl:variable>
  <xsl:variable name="bwStr-EvLC-Master">maestro</xsl:variable>
  <xsl:variable name="bwStr-EvLC-Instance">instance</xsl:variable>
  <xsl:variable name="bwStr-EvLC-Lastmod">Last modified:</xsl:variable><!-- XXX translate -->
  <xsl:variable name="bwStr-EvLC-Created">Created:</xsl:variable><!-- XXX translate -->
  <xsl:variable name="bwStr-EvLC-Cancelled">CANCELLED:</xsl:variable>
  <xsl:variable name="bwStr-EvLC-Tentative">TENTATIVE:</xsl:variable>
  <xsl:variable name="bwStr-EvLC-EditEvent">editar evento</xsl:variable>
  <xsl:variable name="bwStr-EvLC-ShowPublicLink">mostrar enlace pública</xsl:variable>

  <!--  xsl:template match="formElements" mode="modEvent" -->
  <xsl:variable name="bwStr-AEEF-Recurrence">recurrencia</xsl:variable>
  <xsl:variable name="bwStr-AEEF-RECURRANCE">Recurrencia:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EventInfo">Información del evento</xsl:variable>
  <xsl:variable name="bwStr-AEEF-YouMayTag">Puede etiquetar este evento seleccionando áreas tópicas debajo.</xsl:variable>
  <xsl:variable name="bwStr-AEEF-TheFollowingEvent">El evento se ha sugerido para la inclusión en el calendario suite.</xsl:variable>
  <xsl:variable name="bwStr-AEEF-SubmittedBy">Remitido por</xsl:variable>
  <xsl:variable name="bwStr-AEEF-SendMsg">enviar mensaje</xsl:variable>
  <xsl:variable name="bwStr-AEEF-CommentsFromSubmitter">Comentarios del remitente</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ShowHide">mostrar/ocultar</xsl:variable>
  <xsl:variable name="bwStr-AEEF-PopUp">pop-up</xsl:variable>
  <xsl:variable name="bwStr-AEEF-For">Por</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Title">Título:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Deleted">Eliminado:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Type">Tipo:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Calendar">Calendario:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-SelectColon">Seleccionar:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-SubmittedEvents">eventos remitidos</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Preferred">preferido</xsl:variable>
  <xsl:variable name="bwStr-AEEF-All">todos</xsl:variable>
  <xsl:variable name="bwStr-AEEF-DateAndTime">Fecha y hora:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-AllDay">todo el día</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Floating">flotante</xsl:variable>
  <xsl:variable name="bwStr-AEEF-StoreAsUTC">almacenar en UTC</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Start">Comienzo:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Date">Fecha</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EndDate">end date</xsl:variable><!-- trans needed -->
  <xsl:variable name="bwStr-AEEF-StartDateHour">start date hour</xsl:variable><!-- trans needed -->
  <xsl:variable name="bwStr-AEEF-StartDateMinute">start date minute</xsl:variable><!-- trans needed -->
  <xsl:variable name="bwStr-AEEF-StartDateAmPm">start date am/pm</xsl:variable><!-- trans needed -->
  <xsl:variable name="bwStr-AEEF-StartDateTimezone">start date timezone</xsl:variable><!-- trans needed -->
  <xsl:variable name="bwStr-AEEF-Due">Debido a:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-End">Fin:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EndDateHour">end date hour</xsl:variable><!-- trans needed -->
  <xsl:variable name="bwStr-AEEF-EndDateMinute">end date minute</xsl:variable><!-- trans needed -->
  <xsl:variable name="bwStr-AEEF-EndDateAmPm">end date am/pm</xsl:variable><!-- trans needed -->
  <xsl:variable name="bwStr-AEEF-EndDateTimezone">end date timezone</xsl:variable><!-- trans needed -->
  <xsl:variable name="bwStr-AEEF-Duration">Duración</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Days">días</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Hours">horas</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Minutes">minutos</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Or">o</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Weeks">semanas</xsl:variable>
  <xsl:variable name="bwStr-AEEF-This">Este</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Task">tarea</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Event">evento</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Deadline">plazo de entrega</xsl:variable>
  <xsl:variable name="bwStr-AEEF-HasNoDurationEndDate">no tiene duración / fecha de finalización</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ThisEventHasNoDurationEndDate">Este evento no tiene duración / fecha de finalización</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Complete">Completo:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-AffectsFreeBusy">Afecta libre/ocupado:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Yes">sí</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Transparent">(transparente: el estado del evento no afecta su libre/ocupado)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-No">no</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Opaque">(opaco: el estado del evento afecta su libre/ocupado)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Categories">Categorías:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-NoCategoriesDefined">no hay categorías definidas</xsl:variable>
  <xsl:variable name="bwStr-AEEF-AddCategory">añadir categoría</xsl:variable>
  <xsl:variable name="bwStr-AEEF-SelectTimezone">seleccionar zona horaria...</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ThisEventRecurrenceInstance">Este evento es una instancia de recurrencia.</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EditMasterEvent">editar evento maestro</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EditPendingMasterEvent">editar o publicar evento maestro</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EditApprovalQueueMasterEvent">modificar o aprobar el evento principal</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EditMaster">editar maestro (evento recurrente)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EventRecurs">evento recurrente</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EventDoesNotRecur">evento no recurrente</xsl:variable>
  <xsl:variable name="bwStr-AEEF-RecurrenceRules">Reglas de recurrencia</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ChangeRecurrenceRules">cambiar reglas de recurrencia</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ShowAdvancedRecurrenceRules">mostrar reglas de recurrencia avanzadas</xsl:variable>
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
  <xsl:variable name="bwStr-AEEF-Repeating">repetiendose</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Forever">siempre</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Until">hasta</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Times">veces</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Frequency">Frecuencia:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-None">ninguna</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Daily">diaria</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Weekly">semanal</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Monthly">mensual</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Yearly">anual</xsl:variable>
  <xsl:variable name="bwStr-AEEF-NoRecurrenceRules">sin reglas de recurrencia</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Repeat">Repetir:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Interval">Intervalo:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-InTheseMonths">en estos meses:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-WeekOn">semana(s) en</xsl:variable>
  <xsl:variable name="bwStr-AEEF-SelectWeekdays">seleccionar días de la semana</xsl:variable>
  <xsl:variable name="bwStr-AEEF-SelectWeekends">seleccionar fin de semana</xsl:variable>
  <xsl:variable name="bwStr-AEEF-WeekStart">Comienzo de la semana:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-OnTheseDays">en estos días:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-OnTheseDaysOfTheMonth">en estos días del mes:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-InTheseWeeksOfTheYear">en estas semanas del año:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-OnTheseDaysOfTheYear">en estos días del año:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-RecurrenceAndExceptionDates">Fechas de recurrencia y excepción</xsl:variable>
  <xsl:variable name="bwStr-AEEF-RecurrenceDates">Fechas de recurrencia</xsl:variable>
  <xsl:variable name="bwStr-AEEF-NoRecurrenceDates">Sin fechas de recurrencia</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Time">veces</xsl:variable>
  <xsl:variable name="bwStr-AEEF-TIME">Hora</xsl:variable>
  <xsl:variable name="bwStr-AEEF-TZid">Id de zona horaria</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ExceptionDates">Fechas de excepción</xsl:variable>
  <xsl:variable name="bwStr-AEEF-NoExceptionDates">Sin fechas de excepción</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ExceptionDatesMayBeCreated">Las fechas de excepción pueden crearse borrando una instancia de un evento recurrente.</xsl:variable>
  <xsl:variable name="bwStr-AEEF-AddRecurance">añadir recurrencia</xsl:variable>
  <xsl:variable name="bwStr-AEEF-AddException">añadir excepción</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Status">Estado:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Confirmed">confirmado</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Tentative">tentativa</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Canceled">cancelado</xsl:variable>
  <xsl:variable name="bwStr-AEEF-YesOpaque">sí(opaco)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-NoTransparent">no (transparente)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Description">Descripción:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EnterPertientInfo">Introduzca toda la información pertinente</xsl:variable>
  <xsl:variable name="bwStr-AEEF-CharsMax">caracteres max.)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-CharsRemaining">caracter(es) remanente.</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Cost">Coste:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-OptionalPlaceToPurchaseTicks">opcional: si lo hay, y el lugar para obtener las entradas</xsl:variable>
  <xsl:variable name="bwStr-AEEF-EventURL">URL del evento:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-OptionalMoreEventInfo">opcional: para más información sobre el evento</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Image">Imagen:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ImageURL">URL de la imagen:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ImageThumbURL">URL de la thumbnail:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ImageUpload">-o- Cargar la imagen:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ImageDesc">Descripción de la imagen:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ImageAlt">Texto alt:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-OptionalEventImage">opcional: para incluir una imagen</xsl:variable>
  <xsl:variable name="bwStr-AEEF-OptionalEventThumbImage">Enlace opcional de miniatura para listas de eventos, 80px ancho</xsl:variable>
  <xsl:variable name="bwStr-AEEF-UseExisting">Uso existente...</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Overwrite">Sobreescribir</xsl:variable>
  <xsl:variable name="bwStr-AEEF-OptionalImageUpload">Cargas pueden ser JPG, PNG o GIF y sobreponen a las URL de imagen y miniatura.</xsl:variable>
  <xsl:variable name="bwStr-AEEF-RemoveImages">Quitar las imágenes</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Location">Localización:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Add">añadir</xsl:variable>
  <xsl:variable name="bwStr-AEEF-AddC">Añadir:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Address">Dirección:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-IncludeRoom">Por favor, incluir sala, edificio y campus.</xsl:variable>
  <xsl:variable name="bwStr-AEEF-LocationURL">URL de la localización:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-OptionalLocaleInfo">(opcional: para información de la localización)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Contact">Contacto:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Creator">Creador</xsl:variable>
  <xsl:variable name="bwStr-AEEF-TopicalArea">Area tópica:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ContactName">Contacto (nombre):</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ContactPhone">Número de teléfono de contacto:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ContactURL">URL de contacto:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ContactEmail">Dirección de Email de contacto:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Registration">Registration:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-UsersMayRegister">Users may register for this event</xsl:variable>
  <xsl:variable name="bwStr-AEEF-MaxTickets">Max tickets:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-MaxWaitList">Max wait list:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-MaxTicketsInfo">(maximum number of tickets allowed for the event)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-MaxWaitListInfo">(maximum number of people on the wait list for the event. Integer or percent. Leave blank for no limit.)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-TicketsAllowed">Tickets allowed:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-TicketsAllowedInfo">(maximum number of tickets per user)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-RegistrationOpens">Registration opens:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-RegistrationOpensInfo">(date/time registration becomes available)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-RegistrationCloses">Registration closes:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-RegistrationClosesInfo">(date/time of registration cut off)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-CustomFields">Custom fields:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-CustomFieldsBlank">no custom fields defined</xsl:variable>
  <xsl:variable name="bwStr-AEEF-CustomFieldsRefresh">refresh</xsl:variable>
  <xsl:variable name="bwStr-AEEF-CustomFieldsRemove">remove</xsl:variable>
  <xsl:variable name="bwStr-AEEF-CustomFieldsManage">add / manage</xsl:variable>
  <xsl:variable name="bwStr-AEEF-CustomFieldsInfo">(custom form elements)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-CustomFieldsSelect">select custom field collection</xsl:variable>
  <xsl:variable name="bwStr-AEEF-CustomFieldsShowUnpublished">show unpublished</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ViewRegistrations">View event registrations</xsl:variable>
  <xsl:variable name="bwStr-AEEF-DownloadRegistrations">Download registrations</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Optional">(opcional)</xsl:variable>
  <xsl:variable name="bwStr-AEEF-Loading">cargando...</xsl:variable>
  <xsl:variable name="bwStr-AEEF-AddressPrimary">Dirección principal:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-AddressSecondary">Dirección secundaria:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-SelectOrSearch">Seleccionar o Buscar</xsl:variable>
  <xsl:variable name="bwStr-AEEF-AddRoom">Añadir Habitación</xsl:variable>
  <xsl:variable name="bwStr-AEEF-AddSecAddress">añadir una nueva dirección de secundaria</xsl:variable>
  <xsl:variable name="bwStr-AEEF-RoomSuiteArea">habitación, suite o área</xsl:variable>
  <xsl:variable name="bwStr-AEEF-To">De:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-SuggestTo">Sugieren a:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-SuggestionStatus">Sugerencia Estado:</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ChangeGroup1">Usted es un miembro de "</xsl:variable>
  <xsl:variable name="bwStr-AEEF-ChangeGroup2">", el grupo que creó este evento.<br/>Si desea editar completamente, debe </xsl:variable>
  <xsl:variable name="bwStr-AEEF-ChangeGroup3">cambiar grupos de.</xsl:variable>

  <!--  xsl:template match="calendar" mode="showEventFormAliases" -->

  <!--  xsl:template name="submitEventButtons" -->
  <xsl:variable name="bwStr-SEBu-SelectPublishCalendar">Seleccionar un calendario para publicar este evento:</xsl:variable>
  <xsl:variable name="bwStr-SEBu-Select">Seleccionar:</xsl:variable>
  <xsl:variable name="bwStr-SEBu-SubmittedEvents">eventos remitidos</xsl:variable>
  <xsl:variable name="bwStr-SEBu-CalendarDescriptions">descripción de calendarios</xsl:variable>
  <xsl:variable name="bwStr-SEBu-DeleteEvent">Borrar evento</xsl:variable>
  <xsl:variable name="bwStr-SEBu-MarkEventDeleted">Marcar eliminado</xsl:variable>
  <xsl:variable name="bwStr-SEBu-ReturnToList">Volver a la lista</xsl:variable>
  <xsl:variable name="bwStr-SEBu-UpdateEvent">Actualizar evento</xsl:variable>
  <xsl:variable name="bwStr-SEBu-PublishEvent">Publicar evento</xsl:variable>
  <xsl:variable name="bwStr-SEBu-ApproveEvent">Aprobar el evento</xsl:variable>
  <xsl:variable name="bwStr-SEBu-AcceptEvent">Aceptar el evento</xsl:variable>
  <xsl:variable name="bwStr-SEBu-RejectEvent">Rechazar el evento</xsl:variable>
  <xsl:variable name="bwStr-SEBu-Cancel">Cancelar</xsl:variable>
  <xsl:variable name="bwStr-SEBu-ClaimEvent">Solicitar evento</xsl:variable>
  <xsl:variable name="bwStr-SEBu-AddEvent">Añadir evento</xsl:variable>
  <xsl:variable name="bwStr-SEBu-CopyEvent">Copiar evento</xsl:variable>
  <xsl:variable name="bwStr-SEBu-ReleaseEvent">Liberar evento</xsl:variable>
  <xsl:variable name="bwStr-SEBu-Accept">Aceptar</xsl:variable>
  <xsl:variable name="bwStr-SEBu-Reject">Rechazar</xsl:variable>


  <!--  xsl:template match="val" mode="weekMonthYearNumbers" -->

  <!--  xsl:template name="byDayChkBoxList" -->

  <!--  xsl:template name="buildCheckboxList" -->

  <!--  xsl:template name="recurrenceDayPosOptions" -->
  <xsl:variable name="bwStr-RCPO-TheFirst">el primer</xsl:variable>
  <xsl:variable name="bwStr-RCPO-TheSecond">el segundo</xsl:variable>
  <xsl:variable name="bwStr-RCPO-TheThird">el tercer</xsl:variable>
  <xsl:variable name="bwStr-RCPO-TheFourth">el cuarto</xsl:variable>
  <xsl:variable name="bwStr-RCPO-TheFifth">el quinto</xsl:variable>
  <xsl:variable name="bwStr-RCPO-TheLast">el último</xsl:variable>
  <xsl:variable name="bwStr-RCPO-Every">cada</xsl:variable>
  <xsl:variable name="bwStr-RCPO-None">ninguno</xsl:variable>

  <!--  xsl:template name="buildRecurFields" -->
  <xsl:variable name="bwStr-BuRF-And">y</xsl:variable>

  <!--  xsl:template name="buildNumberOptions" -->

  <!--  xsl:template name="clock" -->
  <xsl:variable name="bwStr-Cloc-Bedework24HourClock">Reloj de 24 horas de Bedework</xsl:variable>
  <xsl:variable name="bwStr-Cloc-Type">tipo</xsl:variable>
  <xsl:variable name="bwStr-Cloc-SelectTime">seleccionar hora</xsl:variable>
  <xsl:variable name="bwStr-Cloc-Switch">intercambiar</xsl:variable>
  <xsl:variable name="bwStr-Cloc-Close">cerrar</xsl:variable>

  <!-- xsl:template name="newclock" -->
  <xsl:variable name="bwStr-Cloc-Hour">Hora</xsl:variable>
  <xsl:variable name="bwStr-Cloc-Minute">Minuto</xsl:variable>
  <xsl:variable name="bwStr-Cloc-AM">am</xsl:variable>
  <xsl:variable name="bwStr-Cloc-PM">pm</xsl:variable>

  <!--  xsl:template match="event" mode="displayEvent" -->
  <xsl:variable name="bwStr-DsEv-OkayToDelete">¿Seguro que quiere borrar este evento?</xsl:variable>
  <xsl:variable name="bwStr-DsEv-NoteDontEncourageDeletes">Nota: no se recomienda borrar los eventos antiguos pero correctos; es preferible mantener los eventos antiguos por motivos históricos. Por favor, borre sólo los eventos que son erróneos.</xsl:variable>
  <xsl:variable name="bwStr-DsEv-AllDay">(todo el día)</xsl:variable>
  <xsl:variable name="bwStr-DsEv-YouDeletingPending">Está borrando un evento pendiente.</xsl:variable>
  <xsl:variable name="bwStr-DsEv-YouDeletingApprovalQueue">Se trata de eliminar una entrada en la cola de aprobación.</xsl:variable>
  <xsl:variable name="bwStr-DsEv-SendNotification">Enviar notificación al remitente</xsl:variable>
  <xsl:variable name="bwStr-DsEv-Reason">Razón (dejar en blanco para excluir):</xsl:variable>
  <xsl:variable name="bwStr-DsEv-EventInfo">Información de evento</xsl:variable>
  <xsl:variable name="bwStr-DsEv-Title">Título:</xsl:variable>
  <xsl:variable name="bwStr-DsEv-When">Cuando:</xsl:variable>
  <xsl:variable name="bwStr-DsEv-TopicalAreas">Áreas tópicas:</xsl:variable>
  <xsl:variable name="bwStr-DsEv-Description">Descripción:</xsl:variable>
  <xsl:variable name="bwStr-DsEv-Price">Precio:</xsl:variable>
  <xsl:variable name="bwStr-DsEv-URL">URL:</xsl:variable>
  <xsl:variable name="bwStr-DsEv-Location">Localización:</xsl:variable>
  <xsl:variable name="bwStr-DsEv-Contact">Contacto:</xsl:variable>
  <xsl:variable name="bwStr-DsEv-Owner">Propietario:</xsl:variable>
  <xsl:variable name="bwStr-DsEv-Submitter">Remitente:</xsl:variable>
  <xsl:variable name="bwStr-DsEv-Calendar">Calendario:</xsl:variable>
  <xsl:variable name="bwStr-DsEv-Categories">Categorias:</xsl:variable>
  <xsl:variable name="bwStr-DsEv-TagEvent">Etiquetar o Editar evento</xsl:variable>
  <xsl:variable name="bwStr-DsEv-YesMarkDeleted">Marcar eliminado</xsl:variable>
  <xsl:variable name="bwStr-DsEv-YesDeleteEvent">Borrar evento</xsl:variable>
  <xsl:variable name="bwStr-DsEv-Cancel">Cancelar</xsl:variable>

  <!--  xsl:template name="contactList" -->
  <xsl:variable name="bwStr-Cont-ManageContacts">Gestionar contactos</xsl:variable>
  <xsl:variable name="bwStr-Cont-SelectContact">Seleccionar el contacto que desea actualizar:</xsl:variable>
  <xsl:variable name="bwStr-Cont-Name">Nombre</xsl:variable>
  <xsl:variable name="bwStr-Cont-Phone">Teléfono</xsl:variable>
  <xsl:variable name="bwStr-Cont-Email">Email</xsl:variable>
  <xsl:variable name="bwStr-Cont-Status">Estado</xsl:variable>
  <xsl:variable name="bwStr-Cont-URL">URL</xsl:variable>
  <xsl:variable name="bwStr-Cont-AddNewContact">Añadir nuevo contacto</xsl:variable>
  <xsl:variable name="bwStr-Cont-ListOfContacts">contactos</xsl:variable>

  <!--  xsl:template name="modContact" -->
  <xsl:variable name="bwStr-MdCo-ContactInfo">Información del contacto</xsl:variable>
  <xsl:variable name="bwStr-MdCo-ContactName">Contacto (nombre):</xsl:variable>
  <xsl:variable name="bwStr-MdCo-ContactName-Placeholder">e.g. name, group, or department</xsl:variable>
  <xsl:variable name="bwStr-MdCo-ContactPhone">Número de teléfono del contacto:</xsl:variable>
  <xsl:variable name="bwStr-MdCo-ContactPhone-Placeholder">e.g. 555-555-5555</xsl:variable>
  <xsl:variable name="bwStr-MdCo-ContactURL">URL del contacto:</xsl:variable>
  <xsl:variable name="bwStr-MdCo-ContactURL-Placeholder">link to more information</xsl:variable>
  <xsl:variable name="bwStr-MdCo-ContactEmail">Dirección de Email del contacto:</xsl:variable>
  <xsl:variable name="bwStr-MdCo-ContactDeleted">Borrado:</xsl:variable>
  <xsl:variable name="bwStr-MdCo-Optional">(opcional)</xsl:variable>

  <!--  xsl:template name="deleteContactConfirm" -->
  <xsl:variable name="bwStr-DCoC-OKToDelete">¿Seguro que desea borrar este contacto?</xsl:variable>
  <xsl:variable name="bwStr-DCoC-Name">Nombre</xsl:variable>
  <xsl:variable name="bwStr-DCoC-Phone">Teléfono</xsl:variable>
  <xsl:variable name="bwStr-DCoC-Email">Email</xsl:variable>
  <xsl:variable name="bwStr-DCoC-URL">URL</xsl:variable>
  <xsl:variable name="bwStr-DCoC-DeleteContact">Borrar contacto</xsl:variable>
  <xsl:variable name="bwStr-DCoC-UpdateContact">Actualizar contacto</xsl:variable>
  <xsl:variable name="bwStr-DCoC-AddContact">Añadir contacto</xsl:variable>
  <xsl:variable name="bwStr-DCoC-Cancel">Cancelar</xsl:variable>

  <!--  xsl:template name="contactReferenced" -->
  <xsl:variable name="bwStr-DCoR-ContactInUse">Contacto en uso</xsl:variable>
  <xsl:variable name="bwStr-DCoR-ContactInUseBy">El contacto está en uso por eventos y no puede ser borrado. Por favor, contacte con un administrador.</xsl:variable>
  <xsl:variable name="bwStr-DCoR-Collections">Colecciones:</xsl:variable>
  <xsl:variable name="bwStr-DCoR-Events">Eventos:</xsl:variable>
  <xsl:variable name="bwStr-DCoR-SuperUserMsg">El contacto está referenciado por items más abajo (<em>superusuarios exclusivamente</em>)</xsl:variable>

  <!--  xsl:template name="locationList" -->
  <xsl:variable name="bwStr-LoLi-ManageLocations">Gestionar localizaciones</xsl:variable>
  <xsl:variable name="bwStr-LoLi-SelectLocationToUpdate">Seleccionar la localización que desearía actualizar:</xsl:variable>
  <xsl:variable name="bwStr-LoLi-Name">Nombre</xsl:variable>
  <xsl:variable name="bwStr-LoLi-Room">Room</xsl:variable> <!-- XXX Translate -->
  <xsl:variable name="bwStr-LoLi-Address">Dirección</xsl:variable>
  <xsl:variable name="bwStr-LoLi-SubAddress">Subdirección</xsl:variable>
  <xsl:variable name="bwStr-LoLi-Status">Estado</xsl:variable>
  <xsl:variable name="bwStr-LoLi-URL">URL</xsl:variable>
  <xsl:variable name="bwStr-LoLi-AddNewLocation">Añadir nueva localización</xsl:variable>

  <!--  xsl:template name="modLocation" -->
  <xsl:variable name="bwStr-MoLo-AddLocation">Añadir localización</xsl:variable>
  <xsl:variable name="bwStr-MoLo-UpdateLocation">Actualizar localización</xsl:variable>
  <xsl:variable name="bwStr-MoLo-Name">Name:</xsl:variable>
  <xsl:variable name="bwStr-MoLo-Name-Placeholder">building or location name</xsl:variable>
  <xsl:variable name="bwStr-MoLo-Address">Dirección:</xsl:variable>
  <xsl:variable name="bwStr-MoLo-Address-Placeholder">nombre del edificio o ubicación</xsl:variable>
  <xsl:variable name="bwStr-MoLo-Address-Info"></xsl:variable>
  <xsl:variable name="bwStr-MoLo-SubAddress">Subdirección:</xsl:variable>
  <xsl:variable name="bwStr-MoLo-SubAddress-Placeholder">información suplementario</xsl:variable>
  <xsl:variable name="bwStr-MoLo-Street">Street:</xsl:variable><!-- XXX translate -->
  <xsl:variable name="bwStr-MoLo-Street-Placeholder"></xsl:variable>
  <xsl:variable name="bwStr-MoLo-City">City:</xsl:variable><!-- XXX translate -->
  <xsl:variable name="bwStr-MoLo-City-Placeholder"></xsl:variable>
  <xsl:variable name="bwStr-MoLo-State">State:</xsl:variable><!-- XXX translate -->
  <xsl:variable name="bwStr-MoLo-State-Placeholder"></xsl:variable>
  <xsl:variable name="bwStr-MoLo-PostalCode">Zip:</xsl:variable><!-- XXX translate -->
  <xsl:variable name="bwStr-MoLo-PostalCode-Placeholder"></xsl:variable>
  <xsl:variable name="bwStr-MoLo-Room">Habitación:</xsl:variable>
  <xsl:variable name="bwStr-MoLo-Room-Placeholder">número de habitación, número de la calle o área</xsl:variable>
  <xsl:variable name="bwStr-MoLo-Optional">(opcional)</xsl:variable>
  <xsl:variable name="bwStr-MoLo-Code">Building/Location ID:</xsl:variable>
  <xsl:variable name="bwStr-MoLo-Code-Placeholder"></xsl:variable>
  <xsl:variable name="bwStr-MoLo-AlternateAddress">Alternate address:</xsl:variable>
  <xsl:variable name="bwStr-MoLo-AlternateAddress-Placeholder">alternate address information</xsl:variable>
  <xsl:variable name="bwStr-MoLo-SubField1">Subfield 1:</xsl:variable><!-- XXX translate -->
  <xsl:variable name="bwStr-MoLo-SubField1-Placeholder"></xsl:variable>
  <xsl:variable name="bwStr-MoLo-SubField2">Map URL:</xsl:variable><!-- XXX translate -->
  <xsl:variable name="bwStr-MoLo-SubField2-Placeholder">full URL to map</xsl:variable><!-- XXX translate -->
  <xsl:variable name="bwStr-MoLo-LocationURL">URL de la localización:</xsl:variable>
  <xsl:variable name="bwStr-MoLo-LocationURL-Placeholder">Enlace para obtener más información o mapa</xsl:variable>
  <xsl:variable name="bwStr-MoLo-LocationAccessible">Wheelchair accessible</xsl:variable><!-- XXX translate -->
  <xsl:variable name="bwStr-MoLo-GeoUri">GEO URI:</xsl:variable><!-- XXX translate -->
  <xsl:variable name="bwStr-MoLo-GeoUri-Placeholder"></xsl:variable>
  <xsl:variable name="bwStr-MoLo-Deleted">Borrado:</xsl:variable>
  <xsl:variable name="bwStr-MoLo-DeleteLocation">Borrar localización</xsl:variable>
  <xsl:variable name="bwStr-MoLo-Cancel">Cancelar</xsl:variable>

  <!--  xsl:template name="deleteLocationConfirm" -->
  <xsl:variable name="bwStr-DeLC-OkDeleteLocation">¿Seguro que desea borrar esta localización?</xsl:variable>
  <xsl:variable name="bwStr-DeLC-Address">Dirección:</xsl:variable>
  <xsl:variable name="bwStr-DeLC-SubAddress">Subdirección:</xsl:variable>
  <xsl:variable name="bwStr-DeLC-LocationURL">URL de la localización:</xsl:variable>

  <!--  xsl:template name="locationReferenced" -->
  <xsl:variable name="bwStr-DeLR-LocationInUse">Localización en uso</xsl:variable>
  <xsl:variable name="bwStr-DeLR-LocationInUseBy">La localización está en uso por eventos y no puede ser borrada. Por favor, contacte con un administrador.</xsl:variable>
  <xsl:variable name="bwStr-DeLR-Collections">Colecciones:</xsl:variable>
  <xsl:variable name="bwStr-DeLR-Events">Eventos:</xsl:variable>
  <xsl:variable name="bwStr-DeLR-SuperUserMsg">La localización está referenciada por los items más abajo (<em>superusuarios exclusivamente</em>)</xsl:variable>

  <!--  xsl:template name="categoryList" -->
  <xsl:variable name="bwStr-CtgL-ManageCategories">Gestionar categorías</xsl:variable>
  <xsl:variable name="bwStr-CtgL-SelectCategory">Seleccione la categoría que desearía actualizar:</xsl:variable>
  <xsl:variable name="bwStr-CtgL-AddNewCategory">Añadir nueva categoría</xsl:variable>
  <xsl:variable name="bwStr-CtgL-Keyword">Nombre clave</xsl:variable>
  <xsl:variable name="bwStr-CtgL-Description">Descripción</xsl:variable>
  <xsl:variable name="bwStr-CtgL-Status">Estado</xsl:variable>

  <!--  xsl:template name="modCategory" -->
  <xsl:variable name="bwStr-MoCa-AddCategory">Añadir categoría</xsl:variable>
  <xsl:variable name="bwStr-MoCa-Keyword">Nombre clave:</xsl:variable>
  <xsl:variable name="bwStr-MoCa-Description">Descripción:</xsl:variable>
  <xsl:variable name="bwStr-MoCa-Deleted">Borrado:</xsl:variable>
  <xsl:variable name="bwStr-MoCa-Cancel">Cancelar</xsl:variable>
  <xsl:variable name="bwStr-MoCa-UpdateCategory">Actualizar categoría</xsl:variable>
  <xsl:variable name="bwStr-MoCa-DeleteCategory">Borrar categoría</xsl:variable>

  <!--  xsl:template name="deleteCategoryConfirm" -->
  <xsl:variable name="bwStr-DeCC-CategoryDeleteOK">¿Seguro que desea borrar esta categoría?</xsl:variable>
  <xsl:variable name="bwStr-DeCC-Keyword">Nombre clave:</xsl:variable>
  <xsl:variable name="bwStr-DeCC-Description">Descripción:</xsl:variable>
  <xsl:variable name="bwStr-DeCC-YesDelete">Sí: Borrar categoría</xsl:variable>
  <xsl:variable name="bwStr-DeCC-NoCancel">No: Cancelar</xsl:variable>

  <!--  xsl:template name="categoryReferenced" -->
  <xsl:variable name="bwStr-DeCR-CategoryInUse">Categoría en uso</xsl:variable>
  <xsl:variable name="bwStr-DeCR-CategoryInUseBy">La categoría está en uso por colecciones y/o eventos y no puede ser borrada. Por favor, contacte con un administrador.</xsl:variable>
  <xsl:variable name="bwStr-DeCR-Collections">Colecciones:</xsl:variable>
  <xsl:variable name="bwStr-DeCR-Events">Eventos:</xsl:variable>
  <xsl:variable name="bwStr-DeCR-EventsNote">Nota: si no edita el evento del calendar suite original, puede no ver las áreas tópicas asociadas que marcan la categoría del evento.</xsl:variable>
  <xsl:variable name="bwStr-DeCR-SuperUserMsg">Las categorías están referenciadas por los items de más abajo (<em>superusuarios exclusivamente</em>)</xsl:variable>

  <!--  xsl:template name="categorySelectionWidget" -->
  <xsl:variable name="bwStr-CaSW-ShowHideUnusedCategories">mostrar/ocultar categorías sin usar</xsl:variable>

  <!--  xsl:template match="calendars" mode="calendarCommon" -->
  <xsl:variable name="bwStr-Cals-Collections">Colecciones</xsl:variable>
  <xsl:variable name="bwStr-Cals-SelectByPath">Seleccionar por ruta:</xsl:variable>
  <xsl:variable name="bwStr-Cals-PublicTree">Árbol público</xsl:variable>
  <xsl:variable name="bwStr-Cals-Go">ir</xsl:variable>

  <!--  xsl:template match="calendar" mode="listForUpdate" -->
  <xsl:variable name="bwStr-Cals-Alias">alias</xsl:variable>
  <xsl:variable name="bwStr-Cals-Folder">carpeta</xsl:variable>
  <xsl:variable name="bwStr-Cals-Calendar">calendario</xsl:variable>
  <xsl:variable name="bwStr-Cals-Add">añadir un calendario o una carpeta</xsl:variable>

  <!--  xsl:template match="calendar" mode="listForDisplay" -->

  <!--  xsl:template match="calendar" mode="listForMove" -->

  <!--  xsl:template match="currentCalendar" mode="addCalendar" -->
  <xsl:variable name="bwStr-CuCa-AddCalFileOrSub">Añadir calendario, carpeta, o suscripción</xsl:variable>
  <xsl:variable name="bwStr-CuCa-NoteAccessSet">Nota: el acceso puede ser establecido en un calendario tras su creación.</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Name">Nombre:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Summary">Resumen:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Description">Descripción:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Filter">Filtro:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-ShowHideCategoriesFiltering">mostrar/ocultar categorías para filtrar la salida</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Categories">Categorías:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-ShowHideCategoriesAutoTagging">mostrar/ocultar categorías para auto-etiquetar en la entrada</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Type">Tipo:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Calendar">calendario</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Folder">carpeta</xsl:variable>
  <xsl:variable name="bwStr-CuCa-FOLDER">Carpeta</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Subscription">suscripción</xsl:variable>
  <xsl:variable name="bwStr-CuCa-SubscriptionCanCreateEprops">Allow Location etc create?</xsl:variable>
  <xsl:variable name="bwStr-CuCa-SubscriptionXcategories">Process categories?</xsl:variable>
  <xsl:variable name="bwStr-CuCa-SubscriptionXlocXcontact">Process Locations and Contacts?</xsl:variable>
  <xsl:variable name="bwStr-CuCa-SubscriptionRefresh">Refresh rate: minutes?</xsl:variable>
  <xsl:variable name="bwStr-CuCa-SubscriptionURL">URL de la suscripción</xsl:variable>
  <xsl:variable name="bwStr-CuCa-URLToCalendar">URL al calendario:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-ID">ID (si es necesaria):</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Password">Password (si es necesario):</xsl:variable>
  <xsl:variable name="bwStr-CuCa-OrgSync">Select for orgSync subscription:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-OrgSyncPublicOnly">Select for only events marked public:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-OrgSyncLocKey">Locations key name:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-NoteAliasCanBeAdded">Nota: un alias puede ser añadido a un calendario de Bedework usando una URL del formulario:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Add">Añadir</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Cancel">cancelar</xsl:variable>

  <!--  xsl:template match="currentCalendar" mode="modCalendar" -->
  <xsl:variable name="bwStr-CuCa-ModifySubscription">Modificar suscripción</xsl:variable>
  <xsl:variable name="bwStr-CuCa-ModifyFolder">Modificar carpeta</xsl:variable>
  <xsl:variable name="bwStr-CuCa-ModifyCalendar">Modificar calendario</xsl:variable>
  <xsl:variable name="bwStr-CuCa-TopicalArea">Área tópica:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-True">verdadero</xsl:variable>
  <xsl:variable name="bwStr-CuCa-False">falso</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Display">Mostrar:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-DisplayItemsInCollection">mostrar items en esta colección</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Disabled">Deshabilitado:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-DisabledLabel">deshabilitado</xsl:variable>
  <xsl:variable name="bwStr-CuCa-EnabledLabel">habilitado</xsl:variable>
  <xsl:variable name="bwStr-CuCa-ItemIsInaccessible">Este item es inaccesible y ha sido deshabilitado. Puede rehabilitarlo para intentarlo de nuevo.</xsl:variable>
  <xsl:variable name="bwStr-CuCa-URL">URL:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-CurrentAccess">Acceso actual:</xsl:variable>
  <xsl:variable name="bwStr-CuCa-UpdateSubscription">Actualizar suscripción</xsl:variable>
  <xsl:variable name="bwStr-CuCa-UpdateFolder">Actualizar carpeta</xsl:variable>
  <xsl:variable name="bwStr-CuCa-UpdateCalendar">Actualizar calendario</xsl:variable>

  <!--  xsl:template name="calendarList" -->
  <xsl:variable name="bwStr-CaLi-ManageCalendarsAndFolders">Gestionar calendarios y carpetas</xsl:variable>
  <xsl:variable name="bwStr-CaLi-SelectItemFromPublicTree">Seleccionar un item del árbol público de la izquierda para modificar un calendario o carpeta</xsl:variable>
  <xsl:variable name="bwStr-CaLi-SelectThe">Seleccionar el</xsl:variable>
  <xsl:variable name="bwStr-CaLi-IconToAdd">icono para añadir un nuevo calendario o carpeta al árbol.</xsl:variable>
  <xsl:variable name="bwStr-CaLi-FoldersMayContain">Las carpetas sólo pueden contener calendarios o subcarpetas.</xsl:variable>
  <xsl:variable name="bwStr-CaLi-CalendarsMayContain">Los calendarios sólo pueden contener eventos (y otros items de calendario).</xsl:variable>
  <xsl:variable name="bwStr-CaLi-RetrieveCalendar">Recuperar un calendario o carpeta directamente usando su ruta en el formulario de la izquierda.</xsl:variable>

  <!--  xsl:template name="calendarDescriptions" -->
  <xsl:variable name="bwStr-CaLD-CalendarInfo">Información de calendario</xsl:variable>
  <xsl:variable name="bwStr-CaLD-SelectItemFromCalendarTree">Seleccionar un item del árbol del calendario de la izquierda para ver toda la información sobre ese calendario o carpeta. El árbolo de la izquierda representa la jerarquía del calendario.</xsl:variable>
  <xsl:variable name="bwStr-CaLD-Name">Nombre:</xsl:variable>
  <xsl:variable name="bwStr-CaLD-Path">Ruta:</xsl:variable>
  <xsl:variable name="bwStr-CaLD-Summary">Resumen:</xsl:variable>
  <xsl:variable name="bwStr-CaLD-Description">Descripción:</xsl:variable>

  <!--  xsl:template match="currentCalendar" mode="displayCalendar" -->
  <xsl:variable name="bwStr-CuCa-RemoveSubscription">Borrar suscripción</xsl:variable>
  <xsl:variable name="bwStr-CuCa-FollowingSubscriptionRemoved">La siguiente suscripción será borrada. ¿Continuar?</xsl:variable>
  <xsl:variable name="bwStr-CuCa-DeleteFolder">Borrar carpeta</xsl:variable>
  <xsl:variable name="bwStr-CuCa-FollowingFolderDeleted">La siguiente carpeta <em>y todo su contenido</em> será borrado. ¿Continuar?</xsl:variable>
  <xsl:variable name="bwStr-CuCa-DeleteCalendar">Borrar calendario</xsl:variable>
  <xsl:variable name="bwStr-CuCa-FollowingCalendarDeleted">El siguiente calendario <em>y todo su contenido</em> será borrado. ¿Continuar?</xsl:variable>
  <xsl:variable name="bwStr-CuCa-Path">Ruta:</xsl:variable>

  <!--  xsl:template match="currentCalendar" mode="deleteCalendarConfirm" -->
  <xsl:variable name="bwStr-CuCa-YesRemoveSubscription">Sí: borrar suscripción</xsl:variable>
  <xsl:variable name="bwStr-CuCa-YesDeleteFolder">Sí: borrar carpeta</xsl:variable>
  <xsl:variable name="bwStr-CuCa-YesDeleteCalendar">Sí: borrar calendario</xsl:variable>

 <!--  xsl:template name="selectCalForEvent" -->
  <xsl:variable name="bwStr-SCFE-SelectCal">Seleccionar un calendario</xsl:variable>
  <xsl:variable name="bwStr-SCFE-Calendars">Calendarios</xsl:variable>

  <!--  xsl:template match="calendar" mode="selectCalForEventCalTree" -->

  <!--  xsl:template name="calendarMove" -->
  <xsl:variable name="bwStr-CaMv-MoveCalendar">Mover calendario/carpeta</xsl:variable>
  <xsl:variable name="bwStr-CaMv-CurrentPath">Ruta actual:</xsl:variable>
  <xsl:variable name="bwStr-CaMv-Name">Nombre:</xsl:variable>
  <xsl:variable name="bwStr-CaMv-MailingListID">Mailing List ID:</xsl:variable>
  <xsl:variable name="bwStr-CaMv-Summary">Resumen:</xsl:variable>
  <xsl:variable name="bwStr-CaMv-Description">Descripción:</xsl:variable>
  <xsl:variable name="bwStr-CaMv-SelectNewParentFolder">Seleccionar una carpeta padre nueva:</xsl:variable>

  <!--  xsl:template name="schedulingAccessForm" -->
  <xsl:variable name="bwStr-ScAF-User">usuario</xsl:variable>
  <xsl:variable name="bwStr-ScAF-Group">grupo</xsl:variable>
  <xsl:variable name="bwStr-ScAF-Or">o</xsl:variable>
  <xsl:variable name="bwStr-ScAF-Owner">propietario</xsl:variable>
  <xsl:variable name="bwStr-ScAF-AuthenticatedUsers">usuarios autenticados</xsl:variable>
  <xsl:variable name="bwStr-ScAF-Anyone">cualquiera</xsl:variable>
  <xsl:variable name="bwStr-ScAF-AllScheduling">todas las agendas all scheduling</xsl:variable>
  <xsl:variable name="bwStr-ScAF-SchedReplies">programar respuestas scheduling replies</xsl:variable>
  <xsl:variable name="bwStr-ScAF-FreeBusyReqs">peticiones de libre-ocupado</xsl:variable>
  <xsl:variable name="bwStr-ScAF-SchedReqs">solicitudes de programación</xsl:variable>
  <xsl:variable name="bwStr-ScAF-Update">Actualizar</xsl:variable>
  <xsl:variable name="bwStr-ScAF-Cancel">cancelar</xsl:variable>

  <!--  xsl:template match="acl" mode="currentAccess" -->
  <xsl:variable name="bwStr-ACLs-CurrentAccess">Acceso actual:</xsl:variable>
  <xsl:variable name="bwStr-ACLs-Entry">Entrada Entry</xsl:variable>
  <xsl:variable name="bwStr-ACLs-Access">Acceso</xsl:variable>
  <xsl:variable name="bwStr-ACLs-InheritedFrom">Heredado de</xsl:variable>
  <xsl:variable name="bwStr-ACLs-User">usuario</xsl:variable>
  <xsl:variable name="bwStr-ACLs-Group">grupo</xsl:variable>
  <xsl:variable name="bwStr-ACLs-Auth">autenticado auth</xsl:variable>
  <xsl:variable name="bwStr-ACLs-UnAuth">sin autenticar unauth</xsl:variable>
  <xsl:variable name="bwStr-ACLs-All">todo</xsl:variable>
  <xsl:variable name="bwStr-ACLs-Other">otro</xsl:variable>
  <xsl:variable name="bwStr-ACLs-Anyone">cualquiera (otro)</xsl:variable>
  <xsl:variable name="bwStr-ACLs-Grant">permitir:</xsl:variable>
  <xsl:variable name="bwStr-ACLs-Deny">denegar:</xsl:variable>
  <xsl:variable name="bwStr-ACLs-Local">local</xsl:variable>

  <!--  xsl:template match="calendars" mode="subscriptions" -->

  <!--  xsl:template name="subscriptionIntro" -->
  <xsl:variable name="bwStr-Subs-Subscriptions">Suscripciones</xsl:variable>
  <xsl:variable name="bwStr-Subs-ManagingSubscriptions">Gestionar subscripciones</xsl:variable>
  <xsl:variable name="bwStr-Subs-SelectAnItem">Seleccionar un item del árbol de la izquierda para modificar una suscripción.</xsl:variable>
  <xsl:variable name="bwStr-Subs-SelectThe">Seleccionar el </xsl:variable>
  <xsl:variable name="bwStr-Subs-IconToAdd">icono para añadir una nueva suscripción o carpeta al árbol.</xsl:variable>
  <xsl:variable name="bwStr-Subs-TopicalAreasNote"><ul>
    <li><strong>Áreas tópicas:</strong><ul><li>
          Una suscripción marcada como "área tópica" será presentada a los administradores de eventos cuando se creen eventos.
          Estos son usuados para la entrada (etiquetar) y salida (si son añadidos a una vista).
        </li>
        <li>
          Una suscripción no marcada como "área tópica" puede ser usada en vistas,
          pero no aparecerá cuando se creen eventos. Tales subscripciones son usadas para sálida únicamente,
          por ej. un feed de ical de vacaciones desde una fuente externa.
        </li>
    </ul></li></ul></xsl:variable>

  <!--  xsl:template match="calendar" mode="listForUpdateSubscription" -->
  <xsl:variable name="bwStr-Cals-AddSubscription">añadir una suscripción</xsl:variable>

  <!--  xsl:template match="currentCalendar" mode="addSubscription" -->
  <xsl:variable name="bwStr-CuCa-AddSubscription">Añadir suscripción</xsl:variable>
  <xsl:variable name="bwStr-CuCa-AccessNote">Nota: el acceso puede establecerse en una suscripción tras su creación.</xsl:variable>
  <xsl:variable name="bwStr-CuCa-PublicAlias">Alias público</xsl:variable>
  <xsl:variable name="bwStr-CuCa-SelectPublicCalOrFolder">Seleccionar un calendario público o carpeta</xsl:variable>

  <!--  xsl:template match="calendar" mode="selectCalForPublicAliasCalTree" -->
  <xsl:variable name="bwStr-Cals-Trash">papelera</xsl:variable>

  <!--  xsl:template match="currentCalendar" mode="deleteSubConfirm" -->

  <!-- xsl:template name="listResources" -->
  <xsl:variable name="bwStr-Resource-ManageResources">Manage Resources</xsl:variable>
  <xsl:variable name="bwStr-Resource-ManageResources-Global">Manage Global Resources</xsl:variable>
  <xsl:variable name="bwStr-Resource-ResourcesAre">Resources are files created for and owned by the calendar suite.  They can be CSS, images, or snippets of XML and are unique to each calendar suite.</xsl:variable>
  <xsl:variable name="bwStr-Resource-ResourcesAre-Global">Resources are files created for use by all calendar suites (or any other purpose).  They can be CSS, images, or snippets of XML and are stored in a global area in caldav.</xsl:variable>
  <xsl:variable name="bwStr-Resource-AddNewResource">Add a new resource</xsl:variable>
  <xsl:variable name="bwStr-Resource-Resources">Resources</xsl:variable>
  <xsl:variable name="bwStr-Resource-NameCol">Name</xsl:variable>
  <xsl:variable name="bwStr-Resource-ContentTypeCol">Content Type:</xsl:variable>
  <xsl:variable name="bwStr-Resource-ResourceTypeCol">Resource Type:</xsl:variable>
  <xsl:variable name="bwStr-Resource-ResourceClassCol">Class</xsl:variable>
  <xsl:variable name="bwStr-Resource-Text">Text</xsl:variable>
  <xsl:variable name="bwStr-Resource-NameLabel">Name:</xsl:variable>
  <xsl:variable name="bwStr-Resource-ContentTypeLabel">Content Type:</xsl:variable>
  <xsl:variable name="bwStr-Resource-ResourceTypeLabel">Resource Type:</xsl:variable>
  <xsl:variable name="bwStr-Resource-ClassLabel">Class:</xsl:variable>
  <xsl:variable name="bwStr-Resource-CalendarSuite">Calendar Suite</xsl:variable>
  <xsl:variable name="bwStr-Resource-Admin">Admin</xsl:variable>
  <xsl:variable name="bwStr-Resource-ResourceURL">Resource URL</xsl:variable>

  <!-- xsl:template name="modResource" -->
  <xsl:variable name="bwStr-ModRes-AddResource">Add Resource</xsl:variable>
  <xsl:variable name="bwStr-ModRes-UpdateResource">Update Resource</xsl:variable>
  <xsl:variable name="bwStr-ModRes-EditResource">Edit Resource</xsl:variable>
  <xsl:variable name="bwStr-ModRes-ClickToDownload">Click here to download the current resource content</xsl:variable>
  <xsl:variable name="bwStr-ModRes-NameLabel">Name:</xsl:variable>
  <xsl:variable name="bwStr-ModRes-ContentTypeLabel">Content Type:</xsl:variable>
  <xsl:variable name="bwStr-ModRes-ResourceTypeLabel">Resource Type:</xsl:variable>
  <xsl:variable name="bwStr-ModRes-ClassLabel">Class:</xsl:variable>
  <xsl:variable name="bwStr-ModRes-ResourceContentLabel">Resource Content:</xsl:variable>
  <xsl:variable name="bwStr-ModRes-UploadLabel">Upload Content:</xsl:variable>
  <xsl:variable name="bwStr-ModRes-RemoveResource">Remove Resource</xsl:variable>
  <xsl:variable name="bwStr-ModRes-BackToList">Back to Resource List</xsl:variable>

  <!-- xsl:template name="modResource: featured events strings" -->
  <xsl:variable name="bwStr-ModRes-FeaturedEventsAdmin">Featured Events Admin</xsl:variable>
  <xsl:variable name="bwStr-ModRes-UpdateFeaturedEvents">Update Featured Events</xsl:variable>
  <xsl:variable name="bwStr-ModRes-RemoveFeaturedEvents">Remove Featured Events</xsl:variable>
  <xsl:variable name="bwStr-ModRes-FeaturedEvents">Featured events:</xsl:variable>
  <xsl:variable name="bwStr-ModRes-FeEnabled">enabled</xsl:variable>
  <xsl:variable name="bwStr-ModRes-FeDisabled">disabled</xsl:variable>
  <xsl:variable name="bwStr-ModRes-FeMode">Mode:</xsl:variable>
  <xsl:variable name="bwStr-ModRes-FeTriptychMode">triptych mode (3 panels, 241 x 189 pixels)</xsl:variable>
  <xsl:variable name="bwStr-ModRes-FeSingleMode">single mode (1 panel 725 x 189 pixels)</xsl:variable>
  <xsl:variable name="bwStr-ModRes-FeActive">active</xsl:variable>
  <xsl:variable name="bwStr-ModRes-FePanels">Triptych panels:</xsl:variable>
  <xsl:variable name="bwStr-ModRes-FeImageUrl">Image URL:</xsl:variable>
  <xsl:variable name="bwStr-ModRes-FeLink">Link:</xsl:variable>
  <xsl:variable name="bwStr-ModRes-FeTooltip">Tooltip:</xsl:variable>
  <xsl:variable name="bwStr-ModRes-FeSinglePanel">Single panel:</xsl:variable>
  <xsl:variable name="bwStr-ModRes-FeGenericPanels">Generic panels (when featured events are disabled):</xsl:variable>

  <!--  xsl:template name="deleteResourceConfirm" -->
  <xsl:variable name="bwStr-DelRes-RemoveResource">Remove Resource?</xsl:variable>
  <xsl:variable name="bwStr-DelRes-TheResource">The resource</xsl:variable>
  <xsl:variable name="bwStr-DelRes-WillBeRemoved">will be removed.</xsl:variable>
  <xsl:variable name="bwStr-DelRes-BeForewarned">Be forewarned: if caching is enabled, removing resources from a production system can cause the public interface to behave inconsistently.</xsl:variable>
  <xsl:variable name="bwStr-DelRes-Continue">Continue?</xsl:variable>
  <xsl:variable name="bwStr-DelRes-YesRemoveView">Yes: Remove Resource</xsl:variable>
  <xsl:variable name="bwStr-DelRes-Cancel">No: Cancel</xsl:variable>

  <!--  xsl:template match="views" mode="viewList" -->
  <xsl:variable name="bwStr-View-ManageViews">Gestionar vistas</xsl:variable>
  <xsl:variable name="bwStr-View-ViewsAreNamedAggr">Las vistas son agregaciones de nombres o suscripciones usadas para mostrar conjuntos de eventos dentro de un calendar suite.</xsl:variable>
  <xsl:variable name="bwStr-View-AddNewView">Añadir una nueva vista</xsl:variable>
  <xsl:variable name="bwStr-View-Views">Vistas</xsl:variable>
  <xsl:variable name="bwStr-View-Name">Nombre</xsl:variable>
  <xsl:variable name="bwStr-View-IncludedSubscriptions">Suscripciones incluidas</xsl:variable>

  <!--  xsl:template name="modView" -->
    <xsl:variable name="bwStr-ModV-UpdateView">Actualizar vista</xsl:variable>
  <xsl:variable name="bwStr-ModV-InSomeConfigs">En algunas configuraciones, los cambios hechos aquí no se mostrarán en el calendar suite hasta que la cache sea actualizada (aprox. 5 minutos) o comience una nueva sesión (p.ej. borrando sus cookies).</xsl:variable>
  <xsl:variable name="bwStr-ModV-DeletingAView">Borrar una vista en un sistema en producción debería ser seguido por un reinicio del servidor para limpiar la cache para todos los usuarios.</xsl:variable>
  <xsl:variable name="bwStr-ModV-ToSeeUnderlying">Para ver las suscripciones subyacentes en una carpeta local, abra la carpeta en el árbol</xsl:variable>
  <xsl:variable name="bwStr-ModV-ManageSubscriptions">Gestionar suscripciones</xsl:variable>
  <xsl:variable name="bwStr-ModV-Tree">(esto será mejorado en versiones posteriores...).</xsl:variable>
  <xsl:variable name="bwStr-ModV-IfYouInclude">Si incluye una carpeta en una vista, no necesita incluir sus hijos.</xsl:variable>
  <xsl:variable name="bwStr-ModV-AvailableSubscriptions">Suscripciones disponibles:</xsl:variable>
  <xsl:variable name="bwStr-ModV-ActiveSubscriptions">Suscripciones activas:</xsl:variable>
  <xsl:variable name="bwStr-ModV-DeleteView">Borrar vista</xsl:variable>
  <xsl:variable name="bwStr-ModV-ReturnToViewsListing">Volver al listado de vistas</xsl:variable>

  <!--  xsl:template name="deleteViewConfirm" -->
  <xsl:variable name="bwStr-DeVC-RemoveView">¿Borrar vista?</xsl:variable>
  <xsl:variable name="bwStr-DeVC-TheView">La vista</xsl:variable>
  <xsl:variable name="bwStr-DeVC-WillBeRemoved">será borrada.</xsl:variable>
  <xsl:variable name="bwStr-DeVC-BeForewarned">Está advertido: si el cacheo está habilitado, borrar vistas de un sistema en producción puede provocar que la interfaz pública muestre errores hasta que la cache se haya actualizado (unos minutos).</xsl:variable>
  <xsl:variable name="bwStr-DeVC-Continue">¿Continuar?</xsl:variable>
  <xsl:variable name="bwStr-DeVC-YesRemoveView">Sí: borrar vista</xsl:variable>
  <xsl:variable name="bwStr-DeVC-Cancel">No: cancelar</xsl:variable>

  <!--  xsl:template name="upload" -->
  <xsl:variable name="bwStr-Upld-UploadICalFile">Cargar fichero iCAL</xsl:variable>
  <xsl:variable name="bwStr-Upld-Filename">Nombre de archivo:</xsl:variable>
  <xsl:variable name="bwStr-Upld-IntoCalendar">Dentro del calendario:</xsl:variable>
  <xsl:variable name="bwStr-Upld-NoneSelected"><em>ninguno seleccionado</em></xsl:variable>
  <xsl:variable name="bwStr-Upld-Change">cambiar</xsl:variable>
  <xsl:variable name="bwStr-Upld-AffectsFreeBusy">Afecta libre/ocupado:</xsl:variable>
  <xsl:variable name="bwStr-Upld-AcceptEventsSettings">aceptar los ajustes del evento</xsl:variable>
  <xsl:variable name="bwStr-Upld-Yes">sí</xsl:variable>
  <xsl:variable name="bwStr-Upld-Opaque">(opaco: el estado del evento afecta libre/ocupado)</xsl:variable>
  <xsl:variable name="bwStr-Upld-No">no</xsl:variable>
  <xsl:variable name="bwStr-Upld-Transparent">(transparente: el estado del evento no afecta libre/ocupado)</xsl:variable>
  <xsl:variable name="bwStr-Upld-AcceptEventsStatus">aceptar el estado del evento</xsl:variable>
  <xsl:variable name="bwStr-Upld-Confirmed">confirmado</xsl:variable>
  <xsl:variable name="bwStr-Upld-Tentative">tentativa</xsl:variable>
  <xsl:variable name="bwStr-Upld-Canceled">cancelado</xsl:variable>
  <xsl:variable name="bwStr-Upld-Continue">Continuar</xsl:variable>
  <xsl:variable name="bwStr-Upld-Cancel">Cancelar</xsl:variable>
  <xsl:variable name="bwStr-Upld-DefaultCalendar">calendario por defecto</xsl:variable>
  <xsl:variable name="bwStr-Upld-Status">Estado:</xsl:variable>

  <!--  xsl:template name="modSyspars" -->
  <xsl:variable name="bwStr-MdSP-ManageSysParams">Gestionar las preferencias/parámetros del sistema</xsl:variable>
  <xsl:variable name="bwStr-MdSP-DoNotChangeUnless">No haga cambios salvo que sepa lo que hace. <br/>Los cambios de estos parámetros tienen un profundo impacto en el sistema.</xsl:variable>
  <xsl:variable name="bwStr-MdSP-SystemName">Nombre del sistema:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-SystemNameCannotBeChanged">Nombre para este sistema. No puede ser cambiado.</xsl:variable>
  <xsl:variable name="bwStr-MdSP-DefaultTimezone">Zona horaria por defecto:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-SelectTimeZone">seleccionar zona horaria...</xsl:variable>
  <xsl:variable name="bwStr-MdSP-DefaultNormallyLocal">Identificador de zona horaria por defecto para valores de fecha/hora. Normalmente esto debe estar establecido a su zona horaria local.</xsl:variable>
  <xsl:variable name="bwStr-MdSP-SuperUsers">Superusuarios:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-CommaSeparatedList">Lista de superusuarios separados por coma. Sin espacios.</xsl:variable>
  <xsl:variable name="bwStr-MdSP-SystemID">ID del sistema:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-SystemIDNote">ID del sistema usado cuando se construyen uids y se identifican usuarios. No debería cambiarse.</xsl:variable>
  <xsl:variable name="bwStr-MdSP-Indexing">Indexado:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-IndexingNote">Verdadero si el sistema indexa internamente. Generalmente falso para indexado externo.</xsl:variable>


  <xsl:variable name="bwStr-MdSP-DefaultFBPeriod">Días libre/ocupado por defecto:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-DefaultFBPeriodNote">Periodo de entrega libre/ocupado por defecto</xsl:variable>
  <xsl:variable name="bwStr-MdSP-MaxFBPeriod">Max. días libre/ocupado:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-MaxFBPeriodNote">Periodo de entrega libre/ocupado máximo (para usuarios no superusuario)</xsl:variable>
  <xsl:variable name="bwStr-MdSP-DefaultWebCalPeriod">Días webcal por defecto:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-DefaultWebCalPeriodNote">Periodo de entrega webcal por defecto</xsl:variable>
  <xsl:variable name="bwStr-MdSP-MaxWebCalPeriod">Max. días webcal:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-MaxWebCalPeriodNote">Periodo de entrega webcal máximo (para usuarios no superusuario)</xsl:variable>



  <xsl:variable name="bwStr-MdSP-PubCalendarRoot">Raíz del calendario público:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-PubCalendarRootNote">Nombre de la raíz del directorio de los calendarios públicos. No debería cambiarse.</xsl:variable>
  <xsl:variable name="bwStr-MdSP-UserCalendarRoot">Raíz del calendario de usuario:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-UserCalendarRootNote">Nombre de la raíz del directorio de los calendarios de usuario. No debería cambiarse.</xsl:variable>
  <xsl:variable name="bwStr-MdSP-UserCalendarDefaultName">Nombre por defecto del calendario de usuario:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-UserCalendarDefaultNameNote">Nombre por defecto del calendario de usuario. Usado al inicializar el usuario. Podría cambiarse.</xsl:variable>
  <xsl:variable name="bwStr-MdSP-TrashCalendarDefaultName">Nombre por defecto de la papelera de calendario:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-TrashCalendarDefaultNameNote">Nombre por defecto de la papelera de calendario de usuario. Usada al inicializar el usuario. Podría cambiarse.</xsl:variable>
  <xsl:variable name="bwStr-MdSP-InboxNote">Nombre por defecto del inbox del usuario. Usado al inicializar el usuario. Podría cambiarse.</xsl:variable>
  <xsl:variable name="bwStr-MdSP-UserInboxDefaultName">Nombre por defecto de la bandeja de entrada del usuario:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-UserOutboxDefaultName">Nombre por defecto del outbox del usuario:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-UserOutboxDefaultNameNote">Nombre por defecto del outbox del usuario. Usado al inicializar el usuario. Podría cambiarse.</xsl:variable>
  <xsl:variable name="bwStr-MdSP-UserDeletedCalendarDefaultName">Nombre por defecto del calendario borrado de usuario:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-UserDeletedCalendarDefaultNameNote">Nombre por defecto del calendario de usuario usado para guardar los items borrados. Usado al inicializar el usuario. Podría cambiarse.</xsl:variable>
  <xsl:variable name="bwStr-MdSP-UserBusyCalendarDefaultName">Nombre por defecto del calendario ocupado del usuario:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-UserBusyCalendarDefaultNameNote">Nombre por defecto del calendario de ocupación horaria del usurio. Usado al inicializar el usuario. Podría cambiarse.</xsl:variable>
  <xsl:variable name="bwStr-MdSP-DefaultUserViewName">Nombre de la vista de usuario por defecto:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-DefaultUserViewNameNote">Nombre usado para la vista por defecto creada cuando un nuevo usuario es añadido</xsl:variable>
  <xsl:variable name="bwStr-MdSP-MaxAttendees">Máximo asistentes:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-MaxAttendeesNote">El número máximo de asistentes al evento (para el calendario de usuario)</xsl:variable>
  <!--  Following not used
  <xsl:variable name="bwStr-MdSP-HTTPConnectionsPerUser">Conexiones Http por usuario:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-HTTPConnectionsPerHost">Conexiones Http por host:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-TotalHTTPConnections">Total de conexiones http:</xsl:variable>
  -->
  <xsl:variable name="bwStr-MdSP-MaxLengthPubEventDesc">Máxima longitud de la descripción de evento público:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-MaxLengthUserEventDesc">Máxima longitud de la descripción de evento de usuario:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-MaxSizeUserEntity">Máximo tamaño de la entidad de un usuario:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-DefaultUserQuota">Quota de usuario por defecto:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-MaxRecurringInstances">Max instancias recurrentes:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-MaxRecurringInstancesNote">Usado para limitar los eventos recurrentes a un número razonable de instancias.</xsl:variable>
  <xsl:variable name="bwStr-MdSP-MaxRecurringYears">Max años recurrentes:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-MaxRecurringYearsNotes">Usado para limitar los eventos recurrentes a un periodo de tiempo razonable.</xsl:variable>
  <xsl:variable name="bwStr-MdSP-UserAuthClass">Clase de autorización de usuario:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-UserAuthClassNote">Clase usada para determinar la autorización (no autenticación) para usuarios administrativos. Podría cambiarse sólamente mediante un recompilado de la aplicación.</xsl:variable>
  <xsl:variable name="bwStr-MdSP-MailerClass">Clase del Mailer:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-MailerClassNote">Clase usada para enviar eventos por correo. Podría cambiarse sólo mediante un recompilado de la aplicación.</xsl:variable>
  <xsl:variable name="bwStr-MdSP-AdminGroupsClass">Clase de los grupos de administración:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-AdminGroupsClassNote">Clase usada para consultar y mantener grupos para los usuarios administrativos. Podría cambiarse sólo mediante un recompilado de la aplicación.</xsl:variable>
  <xsl:variable name="bwStr-MdSP-UserGroupsClass">Clase de los grupos de usuario:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-UserGroupsClassNote">Clase usada para consultar y mantener grupos para usuarios no-administrativos. Podría cambiarse sólo mediante un recompilado de la aplicación.</xsl:variable>
  <xsl:variable name="bwStr-MdSP-DirBrowseDisallowd">Navegación de directorio deshabilitada:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-DirBrowseDisallowedNote">Verdadero si el servidor que alberga el xsl deshabilita la navegación de directorios.</xsl:variable>

  <xsl:variable name="bwStr-MdSP-EvregAdmTkn">Eventreg admin token:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-EvregAdmTknNote">Token for event registration. Must be identical to token set in event reg JMX service</xsl:variable>

  <xsl:variable name="bwStr-MdSP-GblResPath">Global resources path:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-GblResPathNote">Path for global resources</xsl:variable>

  <xsl:variable name="bwStr-MdSP-IndexRoot">Raíz del índice (indexado):</xsl:variable>
  <xsl:variable name="bwStr-MdSP-IndexRootNote">Raíz de los índices de eventos. Podría cambiarse sólo si los índices son movidos/copiados</xsl:variable>
  <xsl:variable name="bwStr-MdSP-UseSolr">Use Solr for public indexing:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-UseSolrNote">Use Solr for public indexing:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-SolrURL">Solr Server URL:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-SolrURLNote">Solr Server URL:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-SolrCoreAdmin">Solr Server core admin path:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-SolrCoreAdminNote">Solr Server core admin path:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-SolrDefaultCore">Solr Server Default Core:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-SolrDefaultCoreNote">Solr Server Default Core:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-SupportedLocales">Locales soportados:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-ListOfSupportedLocales">Lista de los locales soportados. El formato es una estricta, separado por comas, lista de lenguas de 2 letras, guión bajo, dos letras de país. Sin espacios. Ejemplo: en_US,fr_CA</xsl:variable>
  <xsl:variable name="bwStr-MdSP-Update">Actualizar</xsl:variable>
  <xsl:variable name="bwStr-MdSP-Cancel">Cancelar</xsl:variable>
  <xsl:variable name="bwStr-MdSP-DefaultNotifications">Default Receive Notifications:</xsl:variable>
  <xsl:variable name="bwStr-MdSP-DefaultNotificationsNote">Default when user has not specified if they wish to receive change notifications for a collection</xsl:variable>

  <!--  xsl:template match="calSuites" mode="calSuiteList" -->
  <xsl:variable name="bwStr-CalS-ManageCalendarSuites">Gestionar calendar suites</xsl:variable>
  <xsl:variable name="bwStr-CalS-AddCalendarSuite">Añadir calendar suite</xsl:variable>
  <xsl:variable name="bwStr-CalS-SwitchGroup">Cambiar grupo</xsl:variable>
  <xsl:variable name="bwStr-CalS-Name">Nombre</xsl:variable>
  <xsl:variable name="bwStr-CalS-AssociatedGroup">Grupo asociado</xsl:variable>

  <!--  xsl:template name="addCalSuite" -->
  <xsl:variable name="bwStr-AdCS-AddCalSuite">Añadir calendar suite</xsl:variable>
  <xsl:variable name="bwStr-AdCS-Name">Nombre:</xsl:variable>
  <xsl:variable name="bwStr-AdCS-NameCalSuite">Nombre de su calendar suite</xsl:variable>
  <xsl:variable name="bwStr-AdCS-Group">Grupo:</xsl:variable>
  <xsl:variable name="bwStr-AdCS-NameAdminGroup">Nombre del grupo de administración que contiene administradores de eventos y propietarios de eventos a los que están adjuntos las preferencias del calendar suite</xsl:variable>
  <xsl:variable name="bwStr-AdCS-Add">Añadir</xsl:variable>
  <xsl:variable name="bwStr-AdCS-Cancel">Cancelar</xsl:variable>

  <!--  xsl:template match="calSuite" name="modCalSuite" -->
  <xsl:variable name="bwStr-CalS-ModifyCalendarSuite">Modificar calendar suite</xsl:variable>
  <xsl:variable name="bwStr-CalS-NameColon">Nombre:</xsl:variable>
  <xsl:variable name="bwStr-CalS-NameOfCalendarSuite">Nombre de su calendar suite</xsl:variable>
  <xsl:variable name="bwStr-CalS-Group">Grupo:</xsl:variable>
  <xsl:variable name="bwStr-CalS-NameOfAdminGroup">Nombre del grupo de administración que contiene administradores de eventos y propietarios de eventos cuyas preferencias para el calendar suite están adjuntas</xsl:variable>
  <xsl:variable name="bwStr-CalS-CurrentAccess">Acceso actual:</xsl:variable>
  <xsl:variable name="bwStr-CalS-DeleteCalendarSuite">Borrar calendar suite</xsl:variable>
  <xsl:variable name="bwStr-CalS-Update">Actualizar</xsl:variable>
  <xsl:variable name="bwStr-CalS-Cancel">Cancelar</xsl:variable>

  <!--  xsl:template name="calSuitePrefs" -->
  <xsl:variable name="bwStr-CSPf-EditCalSuitePrefs">Editar preferencias del calendar suite</xsl:variable>
  <xsl:variable name="bwStr-CSPf-CalSuite">Calendar Suite:</xsl:variable>
  <xsl:variable name="bwStr-CSPf-PreferredView">Vista preferida:</xsl:variable>
  <xsl:variable name="bwStr-CSPf-DefaultViewMode">Modo de vista por defecto:</xsl:variable>
  <xsl:variable name="bwStr-CSPf-DefaultViewModeList">UPCOMING - a list of discrete events from now into the future</xsl:variable>
  <xsl:variable name="bwStr-CSPf-DefaultViewModeDaily">DAY, WEEK, MONTH - a list of events showing entire view period</xsl:variable>
  <xsl:variable name="bwStr-CSPf-DefaultViewModeGrid">GRID - calendar grid for week and month view periods</xsl:variable>
  <xsl:variable name="bwStr-CSPf-PreferredViewPeriod">Periodo de vista preferida para<br/>DAY,WEEk,MONTH mode:</xsl:variable>
  <xsl:variable name="bwStr-CSPf-Day">día</xsl:variable>
  <xsl:variable name="bwStr-CSPf-Today">hoy</xsl:variable>
  <xsl:variable name="bwStr-CSPf-Week">semana</xsl:variable>
  <xsl:variable name="bwStr-CSPf-Month">mes</xsl:variable>
  <xsl:variable name="bwStr-CSPf-Year">año</xsl:variable>
  <xsl:variable name="bwStr-CSPf-DefaultPageSize">Default number of events to display<br/>for 'UPCOMING' mode (paging):</xsl:variable>
  <xsl:variable name="bwStr-CSPf-DefaultCategories">Categorías por defecto:</xsl:variable>
  <xsl:variable name="bwStr-CSPf-ShowHideUnusedCategories">mostrar/ocultar categorías sin usar</xsl:variable>
  <xsl:variable name="bwStr-CSPf-PreferredTimeType">Tipo de horario preferido:</xsl:variable>
  <xsl:variable name="bwStr-CSPf-12Hour">12 horas + AM/PM</xsl:variable>
  <xsl:variable name="bwStr-CSPf-24Hour">24 horas</xsl:variable>
  <xsl:variable name="bwStr-CSPf-PreferredEndDateTimeType">Tipo de fin de fecha/hora preferido:</xsl:variable>
  <xsl:variable name="bwStr-CSPf-Duration">duración</xsl:variable>
  <xsl:variable name="bwStr-CSPf-DateTime">fecha/hora</xsl:variable>
  <xsl:variable name="bwStr-CSPf-DefaultTimezone">Zona horaria por defecto:</xsl:variable>
  <xsl:variable name="bwStr-CSPf-SelectTimezone">seleccionar zona horaria...</xsl:variable>
  <xsl:variable name="bwStr-CSPf-Update">Actualizar</xsl:variable>
  <xsl:variable name="bwStr-CSPf-Cancel">Cancelar</xsl:variable>
  <xsl:variable name="bwStr-CSPf-Approvers">Aprobadores:</xsl:variable>
  <xsl:variable name="bwStr-CSPf-MaxEntitySize">Maximum size for file uploads (in bytes):</xsl:variable>
  <xsl:variable name="bwStr-CSPf-DefaultImageDirectory">Default image directory:</xsl:variable>

  <!--  xsl:template name="uploadTimezones" -->
  <xsl:variable name="bwStr-UpTZ-ManageTZ">Gestionar zonas horarias</xsl:variable>
  <xsl:variable name="bwStr-UpTZ-UploadTZ">Actualizar zonas horarias</xsl:variable>
  <xsl:variable name="bwStr-UpTZ-Cancel">Cancelar</xsl:variable>
  <xsl:variable name="bwStr-UpTZ-FixTZ">Reparar zonas horarias</xsl:variable>
  <xsl:variable name="bwStr-UpTZ-RecalcUTC">(recalcular valores UTC)</xsl:variable>
  <xsl:variable name="bwStr-UpTZ-FixTZNote">Ejecute esto para asegurarse de que no hay valores UTC que hayan cambiado debido a esta actualización (p.ej. cambios DST).</xsl:variable>

  <!--  xsl:template name="authUserList" -->
  <xsl:variable name="bwStr-AuUL-ModifyAdministrators">Modificar administradores</xsl:variable>
  <xsl:variable name="bwStr-AuUL-EditAdminRoles">Editar los roles de administrador por userid:</xsl:variable>
  <xsl:variable name="bwStr-AuUL-UserID">UserId</xsl:variable>
  <xsl:variable name="bwStr-AuUL-Roles">Roles</xsl:variable>
  <xsl:variable name="bwStr-AuUL-Edit">editar</xsl:variable>
  <xsl:variable name="bwStr-AuUL-Go">ir</xsl:variable>

  <!--  xsl:template name="modAuthUser" -->
  <xsl:variable name="bwStr-MoAU-UpdateAdmin">Actualizar administrador</xsl:variable>
  <xsl:variable name="bwStr-MoAU-Account">Cuenta:</xsl:variable>
  <xsl:variable name="bwStr-MoAU-PublicEvents">Eventos públicos:</xsl:variable>
  <xsl:variable name="bwStr-MoAU-ContentAdmin">Contenido Admin:</xsl:variable>
  <xsl:variable name="bwStr-MoAU-Approver">Aprobador:</xsl:variable>
  <xsl:variable name="bwStr-MoAU-Update">Actualizar</xsl:variable>
  <xsl:variable name="bwStr-MoAU-Cancel">Cancelar</xsl:variable>

  <!--  xsl:template name="modPrefs" -->
  <xsl:variable name="bwStr-MoPr-EditUserPrefs">Editar preferencias de usuario</xsl:variable>
  <xsl:variable name="bwStr-MoPr-User">Usario:</xsl:variable>
  <xsl:variable name="bwStr-MoPr-PreferredView">Vista preferida:</xsl:variable>
  <xsl:variable name="bwStr-MoPr-PreferredViewPeriod">Periodo de vista preferida:</xsl:variable>
  <xsl:variable name="bwStr-MoPr-Day">día</xsl:variable>
  <xsl:variable name="bwStr-MoPr-Today">hoy</xsl:variable>
  <xsl:variable name="bwStr-MoPr-Week">semana</xsl:variable>
  <xsl:variable name="bwStr-MoPr-Month">mes</xsl:variable>
  <xsl:variable name="bwStr-MoPr-Year">año</xsl:variable>
  <xsl:variable name="bwStr-MoPr-PageSize">Tamaño de página:</xsl:variable>
  <xsl:variable name="bwStr-MoPr-NoNotifications">Suppress Notifications:</xsl:variable>
  <xsl:variable name="bwStr-MoPr-Update">Actualizar</xsl:variable>
  <xsl:variable name="bwStr-MoPr-Cancel">Cancelar</xsl:variable>

  <!--  xsl:template name="listAdminGroups" -->
  <xsl:variable name="bwStr-LsAG-ModifyGroups">Modificar grupos</xsl:variable>
  <xsl:variable name="bwStr-LsAG-HideMembers">Ocultar miembros</xsl:variable>
  <xsl:variable name="bwStr-LsAG-ShowMembers">Mostrar miembros</xsl:variable>
  <xsl:variable name="bwStr-LsAG-SelectGroupName">Seleccionar un nombre de grupo para modificar el propietario del grupo o la descripción.<br/>Click "miembros" para modificar los miembros del grupo.</xsl:variable>
  <xsl:variable name="bwStr-LsAG-AddNewGroup">Añadir un nuevo grupo</xsl:variable>
  <xsl:variable name="bwStr-LsAG-HighlightedRowsNote">*Las filas resaltadas indican un grupo para el que un calendar suite es adjunto.</xsl:variable>
  <xsl:variable name="bwStr-LsAG-Name">Nombre</xsl:variable>
  <xsl:variable name="bwStr-LsAG-Members">Miembros</xsl:variable>
  <xsl:variable name="bwStr-LsAG-ManageMembership">Gestionar<br/>miembros</xsl:variable>
  <xsl:variable name="bwStr-LsAG-CalendarSuite">Calendar Suite*</xsl:variable>
  <xsl:variable name="bwStr-LsAG-Description">Descripción</xsl:variable>
  <xsl:variable name="bwStr-LsAG-Membership">miembros</xsl:variable>

  <!--  xsl:template match="groups" mode="chooseGroup" -->
  <xsl:variable name="bwStr-Grps-ChooseAdminGroup">Elija su grupo de administración</xsl:variable>
  <xsl:variable name="bwStr-Grps-HighlightedRowsNote">*Las filas resaltadas indican un grupo para el que un calendar suite es adjunto. Seleccione uno de estos grupos para editar atributos del calendar suite asociado.</xsl:variable>
  <xsl:variable name="bwStr-Grps-Superuser"><strong>Superusuario:</strong> para desasociarte de todos los grupos, desconecte y vuelva a conectar con el sistema.</xsl:variable>
  <xsl:variable name="bwStr-Grps-Name">Nombre</xsl:variable>
  <xsl:variable name="bwStr-Grps-Description">Descripción</xsl:variable>
  <xsl:variable name="bwStr-Grps-CalendarSuite">Calendar Suite*</xsl:variable>

  <!--  xsl:template name="modAdminGroup" -->
  <xsl:variable name="bwStr-MoAG-AddGroup">Añadir grupo</xsl:variable>
  <xsl:variable name="bwStr-MoAG-ModifyGroup">Modificar grupo</xsl:variable>
  <xsl:variable name="bwStr-MoAG-Name">Nombre:</xsl:variable>
  <xsl:variable name="bwStr-MoAG-Description">Descripción:</xsl:variable>
  <xsl:variable name="bwStr-MoAG-GroupOwner">Propietario del grupo:</xsl:variable>
  <xsl:variable name="bwStr-MoAG-GroupOwnerFieldInfo">User responsible for the group, e.g. "admin"</xsl:variable>
  <xsl:variable name="bwStr-MoAG-EventsOwner">Propietario de eventos:</xsl:variable>
  <xsl:variable name="bwStr-MoAG-Optional">(opcional)</xsl:variable>
  <xsl:variable name="bwStr-MoAG-EventsOwnerFieldInfo">El dueño del sistema para todos los eventos creados por este grupo.<br/>Este valor será creado por el sistema si no suministrado.</xsl:variable>
  <xsl:variable name="bwStr-MoAG-Delete">Borrar</xsl:variable>
  <xsl:variable name="bwStr-MoAG-AddAdminGroup">Añadir grupo de administración</xsl:variable>
  <xsl:variable name="bwStr-MoAG-Cancel">Cancelar</xsl:variable>
  <xsl:variable name="bwStr-MoAG-UpdateAdminGroup">Actualizar grupo de administración</xsl:variable>

  <!--  xsl:template name="modAdminGroupMembers" -->
  <xsl:variable name="bwStr-MAGM-UpdateGroupMembership">Actualizar miembros de grupo</xsl:variable>
  <xsl:variable name="bwStr-MAGM-EnterUserID">Entre un userid (para usuario o grupo) y haga click en "añadir" para actualizar la memebresía del grupo. Click en el icono de la papelera para eliminar un usuario del grupo.</xsl:variable>
  <xsl:variable name="bwStr-MAGM-AddMember">Añadir miembro:</xsl:variable>
  <xsl:variable name="bwStr-MAGM-User">usuario</xsl:variable>
  <xsl:variable name="bwStr-MAGM-Group">grupo</xsl:variable>
  <xsl:variable name="bwStr-MAGM-Add">Añadir</xsl:variable>
  <xsl:variable name="bwStr-MAGM-ReturnToAdminGroupLS">Volver al listado del grupo de administración</xsl:variable>
  <xsl:variable name="bwStr-MAGM-Name">Nombre:</xsl:variable>
  <xsl:variable name="bwStr-MAGM-Members">Miembros:</xsl:variable>
  <xsl:variable name="bwStr-MAGM-Remove">quitar</xsl:variable>

  <!--  xsl:template name="deleteAdminGroupConfirm" -->
  <xsl:variable name="bwStr-DAGC-DeleteAdminGroup">¿Borrar grupo de administración?</xsl:variable>
  <xsl:variable name="bwStr-DAGC-GroupWillBeDeleted">El siguiente grupo será borrado. ¿Continuar?</xsl:variable>
  <xsl:variable name="bwStr-DAGC-YesDelete">Sí: borrar</xsl:variable>
  <xsl:variable name="bwStr-DAGC-NoCancel">No: cancelar</xsl:variable>

  <!--  xsl:template name="addFilter" -->
  <xsl:variable name="bwStr-AdFi-AddNameCalDAVFilter">Añadir un filtro de CalDAV nombrado Named CalDAV Filter</xsl:variable>
  <xsl:variable name="bwStr-AdFi-Examples">ejemplos</xsl:variable>
  <xsl:variable name="bwStr-AdFi-Name">Nombre:</xsl:variable>
  <xsl:variable name="bwStr-AdFi-Description">Descripción:</xsl:variable>
  <xsl:variable name="bwStr-AdFi-FilterDefinition">Definición de filtro:</xsl:variable>
  <xsl:variable name="bwStr-AdFi-AddFilter">Añadir filtro</xsl:variable>
  <xsl:variable name="bwStr-AdFi-Cancel">Cancelar</xsl:variable>
  <xsl:variable name="bwStr-AdFi-CurrentFilters">Filtros actuales</xsl:variable>
  <xsl:variable name="bwStr-AdFi-FilterName">Nombre de filtro</xsl:variable>
  <xsl:variable name="bwStr-AdFi-DescriptionDefinition">Descripción/Definición</xsl:variable>
  <xsl:variable name="bwStr-AdFi-Delete">Borrar</xsl:variable>
  <xsl:variable name="bwStr-AdFi-ShowHideFilterDef">mostrar/ocultar definición de filtros</xsl:variable>
  <xsl:variable name="bwStr-AdFi-DeleteFilter">borrar filtro</xsl:variable>

  <!--  xsl:template match="sysStats" mode="showSysStats" -->
  <xsl:variable name="bwStr-SysS-SystemStatistics">Estadísticas del sistema</xsl:variable>
  <xsl:variable name="bwStr-SysS-StatsCollection">Colección de estadísticas:</xsl:variable>
  <xsl:variable name="bwStr-SysS-Enable">habilitar</xsl:variable>
  <xsl:variable name="bwStr-SysS-Disable">deshabilitar</xsl:variable>
  <xsl:variable name="bwStr-SysS-FetchRefreshStats">recuperar/refrescar estadísticas</xsl:variable>
  <xsl:variable name="bwStr-SysS-DumpStatsToLog">volcar estadísticas a log</xsl:variable>

  <!--  xsl:template ? -->
  <xsl:variable name="bwStr-Idx-Unindex">Unindex an entity by Href. WARNING - may damage the index</xsl:variable>

  <!--  xsl:template name="searchResult" -->
  <xsl:variable name="bwStr-Srch-Search">Buscar:</xsl:variable>
  <xsl:variable name="bwStr-Srch-Go">ir</xsl:variable>
  <xsl:variable name="bwStr-Srch-ScopeLocal">este grupo</xsl:variable>
  <xsl:variable name="bwStr-Srch-ScopeMine">mis grupos</xsl:variable>
  <xsl:variable name="bwStr-Srch-ScopeAll">todos los grupos</xsl:variable>
  <xsl:variable name="bwStr-Srch-Limit">Limitar:</xsl:variable>
  <xsl:variable name="bwStr-Srch-TodayForward">de hoy en adelante</xsl:variable>
  <xsl:variable name="bwStr-Srch-PastDates">fechas pasadas</xsl:variable>
  <xsl:variable name="bwStr-Srch-AllDates">todas las fechas</xsl:variable>
  <xsl:variable name="bwStr-Srch-SearchResult">Resultados de la búsqueda</xsl:variable>
  <xsl:variable name="bwStr-Srch-Page">página:</xsl:variable>
  <xsl:variable name="bwStr-Srch-Prev">ant</xsl:variable>
  <xsl:variable name="bwStr-Srch-Next">sig</xsl:variable>
  <xsl:variable name="bwStr-Srch-PrevFull">Anterior</xsl:variable>
  <xsl:variable name="bwStr-Srch-NextFull">Siguiente </xsl:variable>
  <xsl:variable name="bwStr-Srch-Starting">Comenzando:</xsl:variable>
  <xsl:variable name="bwStr-Srch-ResultReturnedFor">resultado(s) devueltos para</xsl:variable>
  <xsl:variable name="bwStr-Srch-Relevance">relevancia</xsl:variable>
  <xsl:variable name="bwStr-Srch-Summary">resumen</xsl:variable>
  <xsl:variable name="bwStr-Srch-Title">título</xsl:variable>
  <xsl:variable name="bwStr-Srch-DateAndTime">fecha y hora</xsl:variable>
  <xsl:variable name="bwStr-Srch-Calendar">calendario</xsl:variable>
  <xsl:variable name="bwStr-Srch-Location">localización</xsl:variable>
  <xsl:variable name="bwStr-Srch-NoTitle">sin título</xsl:variable>
  <xsl:variable name="bwStr-Srch-NoResults">no resultados</xsl:variable>
  <xsl:variable name="bwStr-Srch-NoMoreResults">No hay más resultados</xsl:variable>

  <!--  xsl:template name="searchResultPageNav" -->

  <!--  xsl:template name="footer" -->
  <xsl:variable name="bwStr-Foot-BedeworkWebsite">Bedework Website</xsl:variable>
  <xsl:variable name="bwStr-Foot-ShowXML">mostrar XML</xsl:variable>
  <xsl:variable name="bwStr-Foot-RefreshXSLT">refrescar XSLT</xsl:variable>

</xsl:stylesheet>
