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

  <!-- xsl:template match="/" -->

  <!-- xsl:template name="headSection" -->
  <xsl:variable name="bwStr-Head-BedeworkSubmitPubEv">Bedework: enviar un evento público</xsl:variable>

  <!-- xsl:template name="header" -->
  <xsl:variable name="bwStr-Head-CalendarSuite">Calendar Suite</xsl:variable>
  <xsl:variable name="bwStr-Head-None">ninguno</xsl:variable>
  <xsl:variable name="bwStr-Hedr-BedeworkPubEventSub">Envío de eventos públicos de Bedework</xsl:variable>
  <xsl:variable name="bwStr-Hedr-LoggedInAs">Conectado como</xsl:variable>
  <xsl:variable name="bwStr-Hedr-Logout">desconectar</xsl:variable>

  <!-- xsl:template name="messagesAndErrors" -->

  <!-- xsl:template name="menuTabs" -->
  <xsl:variable name="bwStr-MeTa-Overview">Presentación</xsl:variable>
  <xsl:variable name="bwStr-MeTa-AddEvent">Añadir evento</xsl:variable>
  <xsl:variable name="bwStr-MeTa-MyPendingEvents">Mis eventos pendientes</xsl:variable>

  <!-- xsl:template name="home" -->
  <xsl:variable name="bwStr-Home-Start">empezar</xsl:variable>
  <xsl:variable name="bwStr-Home-EnteringEvents">Introducir eventos</xsl:variable>
  <xsl:variable name="bwStr-Home-BeforeSubmitting">Antes de enviar un evento público,</xsl:variable>
  <xsl:variable name="bwStr-Home-SeeIfItHasBeenEntered">mire si ya ha sido introducido</xsl:variable>
  <xsl:variable name="bwStr-Home-ItIsPossible">Es posible que un evento pueda ser creado con un título distinto al que podría esperar.</xsl:variable>
  <xsl:variable name="bwStr-Home-MakeYourTitles">Haga que sus títulos sean descriptivos: en lugar de "Conferencia" use "Serie de conferencias musicales: 'Usos del acorde napolitano'". "Club de cine" podría ser bastante ambiguo, mientras que "Club de cine: 'Ciudadano Kane'" es mejor. Tenga en cuenta que su evento "compartirá el escenario" con otros eventos del calendario, trate de ser tan claro como sea posible cuando piense en títulos. No exprese sólo lo que es el evento, intente explicar brevemente de que trata. Dé más detalles del evento en el campo descripción, pero trate de no repetir la misma información. Intente pensar como un usuario cuando sugiera un evento: use lenguaje que explicaría su evento a alguien que no sabe absolutamente nada sobre el mismo.</xsl:variable>
  <xsl:variable name="bwStr-Home-DoNotInclude">No incluya localizaciones y fechas en el campo descripción (a menos que sea para añadir información extra que no está disponible).</xsl:variable>

  <!-- xsl:template match="formElements" mode="addEvent" -->
  <!-- xsl:template match="formElements" mode="editEvent" -->
  <!-- xsl:template match="formElements" mode="eventForm" -->
  <xsl:variable name="bwStr-FoEl-DeleteColon">Borrar:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Instance">instancia</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Delete">Borrar</xsl:variable>
  <xsl:variable name="bwStr-FoEl-All">todo</xsl:variable>
  <xsl:variable name="bwStr-FoEl-TASK">Tarea</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Task">tarea</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Meeting">Reunión</xsl:variable>
  <xsl:variable name="bwStr-FoEl-EVENT">Evento</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Event">evento</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Recurring">Recurrente</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Personal">Personal</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Public">Público</xsl:variable>
  <xsl:variable name="bwStr-FoEl-RecurrenceMaster">(recurrencia maestra)</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Next">siguiente</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Step1"><strong>Paso 1:</strong> Introduzca los detalles del evento. <em>Los campos opcionales están en cursiva.</em></xsl:variable>
  <xsl:variable name="bwStr-FoEl-Previous">anterior</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Step2"><strong>Paso 2:</strong> Seleccione localización.</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Step3"><strong>Paso 3:</strong> Seleccione contacto.</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Step4"><strong>Paso 4:</strong> Sugiera áreas tópicas. <em>Opcional.</em></xsl:variable>
  <xsl:variable name="bwStr-FoEl-Step5"><strong>Paso 5:</strong> Información de contacto y comentarios.</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Calendar">Calendario:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Title">Título:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-MustIncludeTitle">Debe incluir un título.</xsl:variable>
  <xsl:variable name="bwStr-FoEl-DateAndTime">Fecha y hora:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-AllDay">todo el día</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Start">Comienzo:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-SelectTimezone">seleccione zona horaria</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Due">Due:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-End">Final:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Date">Fecha</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Duration">Duración</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Days">días</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Hours">horas</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Minutes">minutos</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Weeks">semanas</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Or">o</xsl:variable>
  <xsl:variable name="bwStr-FoEl-This">Este</xsl:variable>
  <xsl:variable name="bwStr-FoEl-HasNoDurationEndDate">no tiene duración / fecha de finalización</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Description">Descripción</xsl:variable>
  <xsl:variable name="bwStr-FoEl-CharsMax">caracteres max.)</xsl:variable>
  <xsl:variable name="bwStr-FoEl-CharsRemaining">caracter(es) remanente.</xsl:variable>
  <xsl:variable name="bwStr-FoEl-MustIncludeDescription">Debe incluir una descripción.</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Status">Estado:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Confirmed">confirmado</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Tentative">tentativa</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Canceled">cancelado</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Cost">Coste:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-CostOptional">opcional: si lo hubiera, y lugar donde obtener las entradas</xsl:variable>
  <xsl:variable name="bwStr-FoEl-EventURL">URL del evento:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-EventURLOptional">opcional: para más información sobre el evento</xsl:variable>
  <xsl:variable name="bwStr-FoEl-ImageURL">URL de la imagen:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-ImageURLOptional">opcional: para incluir una imagen con la descripción del evento</xsl:variable>
  <xsl:variable name="bwStr-FoEl-MustSelectLocation">Debe seleccionar una localización o sugerir una más abajo.</xsl:variable>
  <xsl:variable name="bwStr-FoEl-SelectExistingLocation">seleccione una localización existente...</xsl:variable>
  <xsl:variable name="bwStr-FoEl-DidntFindLocation">¿No encontró la localización? Sugiera una nueva:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Address">Dirección:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-SubAddress">Sub-dirección:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Optional">opcional</xsl:variable>
  <xsl:variable name="bwStr-FoEl-URL">URL:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-MustSelectContact">Debe seleccionar un contacto o sugerir uno más abajo.</xsl:variable>
  <xsl:variable name="bwStr-FoEl-SelectExistingContact">seleccione un contacto existente...</xsl:variable>
  <xsl:variable name="bwStr-FoEl-DidntFindContact">¿No encontró el contacto que necesita? Sugiera uno nuevo:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-OrganizationName">Nombre de la organización:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-PleaseLimitContacts">Por favor, limite los contactos a organizaciones, no a individuos.</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Phone">Teléfono:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Email">Email:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-MissingTopicalArea">¿Echa en falta un área tópica? Por favor, describa que tipo de evento está enviando:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-TypeOfEvent">Tipo de evento:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-MustIncludeEmail">Debe incluir su dirección de correo electrónico.</xsl:variable>
  <xsl:variable name="bwStr-FoEl-InvalidEmailAddress">Esto no parece ser una dirección de email válida. Por favor, corríjala.</xsl:variable>
  <xsl:variable name="bwStr-FoEl-EnterEmailAddress">Introduzca su dirección de email:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-FinalNotes">Por favor, proporcione cualquier aviso final o instrucciones a tener en cuenta en su evento:</xsl:variable>
  <xsl:variable name="bwStr-FoEl-SubmitForApproval">enviar para ser aprobado</xsl:variable>
  <xsl:variable name="bwStr-FoEl-Cancel">cancelar</xsl:variable>

  <!-- xsl:template match="calendar" mode="showEventFormAliases" -->

  <!-- xsl:template match="val" mode="weekMonthYearNumbers" -->
  <xsl:variable name="bwStr-WMYN-Next">y</xsl:variable>

  <!-- xsl:template name="byDayChkBoxList" -->

  <!-- xsl:template name="buildCheckboxList" -->

  <!-- xsl:template name="recurrenceDayPosOptions" -->
  <xsl:variable name="bwStr-RDPO-None">ninguno</xsl:variable>
  <xsl:variable name="bwStr-RDPO-TheFirst">el primero</xsl:variable>
  <xsl:variable name="bwStr-RDPO-TheSecond">el segundo</xsl:variable>
  <xsl:variable name="bwStr-RDPO-TheThird">el tercero</xsl:variable>
  <xsl:variable name="bwStr-RDPO-TheFourth">el cuarto</xsl:variable>
  <xsl:variable name="bwStr-RDPO-TheFifth">el quinto</xsl:variable>
  <xsl:variable name="bwStr-RDPO-TheLast">el último</xsl:variable>
  <xsl:variable name="bwStr-RDPO-Every">cada</xsl:variable>

  <!-- xsl:template name="buildRecurFields" -->
  <xsl:variable name="bwStr-BReF-And">y</xsl:variable>

  <!-- xsl:template name="buildNumberOptions" -->

  <!-- xsl:template name="clock" -->
  <xsl:variable name="bwStr-Cloc-Bedework24HourClock">Reloj de 24 horas de Bedework</xsl:variable>
  <xsl:variable name="bwStr-Cloc-Type">tipo</xsl:variable>
  <xsl:variable name="bwStr-Cloc-SelectTime">seleccione hora</xsl:variable>
  <xsl:variable name="bwStr-Cloc-Switch">cambiar</xsl:variable>
  <xsl:variable name="bwStr-Cloc-Close">cerrar</xsl:variable>
  
  <!-- xsl:template name="newclock" -->
  <xsl:variable name="bwStr-Cloc-Hour">Hora</xsl:variable>
  <xsl:variable name="bwStr-Cloc-Minute">Minuto</xsl:variable>
  <xsl:variable name="bwStr-Cloc-AM">am</xsl:variable>
  <xsl:variable name="bwStr-Cloc-PM">pm</xsl:variable>
  
  <!-- xsl:template name="eventList" -->
  <xsl:variable name="bwStr-EvLs-PendingEvents">Eventos pendientes</xsl:variable>
  <xsl:variable name="bwStr-EvLs-EventsBelowWaiting">Los eventos de debajo están a la espera de ser publicados por un administrador del calendario. Puede editarlos o borrarlos hasta que hayan sido aceptados. Una vez que el evento es publicado no lo verá más en su lista.</xsl:variable>

  <!-- xsl:template name="eventListCommon" -->
  <xsl:variable name="bwStr-EvLC-Title">Título</xsl:variable>
  <xsl:variable name="bwStr-EvLC-CalSuite">Suite</xsl:variable>
  <xsl:variable name="bwStr-EvLC-ClaimedBy">Reclamado por</xsl:variable>
  <xsl:variable name="bwStr-EvLC-Start">Comienzo</xsl:variable>
  <xsl:variable name="bwStr-EvLC-End">Final</xsl:variable>
  <xsl:variable name="bwStr-EvLC-TopicalAreas">Areas tópicas</xsl:variable>
  <xsl:variable name="bwStr-EvLC-Description">Descripción</xsl:variable>
  <xsl:variable name="bwStr-EvLC-NoTitle">sin título</xsl:variable>
  <xsl:variable name="bwStr-EvLC-Unclaimed">no reclamado</xsl:variable>
  <xsl:variable name="bwStr-EvLC-RecurringEvent">Evento recurrente.</xsl:variable>
  <xsl:variable name="bwStr-EvLC-Edit">Editar:</xsl:variable>
  <xsl:variable name="bwStr-EvLC-Master">maestro</xsl:variable>
  <xsl:variable name="bwStr-EvLC-Instance">instancia</xsl:variable>

  <!-- xsl:template name="upload" -->
  <xsl:variable name="bwStr-Upld-AffectsFreeBusy">Afecta libre/ocupado:</xsl:variable>
  <xsl:variable name="bwStr-Upld-Yes">sí</xsl:variable>
  <xsl:variable name="bwStr-Upld-Transparent">(transparente: el estado del evento no afecta su libre/ocupado)</xsl:variable>
  <xsl:variable name="bwStr-Upld-No">no</xsl:variable>
  <xsl:variable name="bwStr-Upld-Opaque">(opaco: el estado del evento afecta su libre/ocupado)</xsl:variable>
  <xsl:variable name="bwStr-Upld-UploadICalFile">Cargar fichero iCAL</xsl:variable>
  <xsl:variable name="bwStr-Upld-Filename">Nombre del fichero:</xsl:variable>
  <xsl:variable name="bwStr-Upld-IntoCalendar">Dentro del calendario:</xsl:variable>
  <xsl:variable name="bwStr-Upld-DefaultCalendar">calendario por defecto</xsl:variable>
  <xsl:variable name="bwStr-Upld-AcceptEventsSettings">aceptar las características del evento</xsl:variable>
  <xsl:variable name="bwStr-Upld-Status">Estado:</xsl:variable>
  <xsl:variable name="bwStr-Upld-AcceptEventsStatus">aceptar el estado del evento</xsl:variable>
  <xsl:variable name="bwStr-Upld-Confirmed">confirmado</xsl:variable>
  <xsl:variable name="bwStr-Upld-Tentative">tentativa</xsl:variable>
  <xsl:variable name="bwStr-Upld-Canceled">cancelado</xsl:variable>
  <xsl:variable name="bwStr-Upld-Continue">Continuar</xsl:variable>
  <xsl:variable name="bwStr-Upld-Cancel">cancelar</xsl:variable>

  <!-- xsl:template name="timeFormatter" -->
  <xsl:variable name="bwStr-TiFo-AM">AM</xsl:variable>
  <xsl:variable name="bwStr-TiFo-PM">PM</xsl:variable>

  <!-- xsl:template name="footer" -->
  <xsl:variable name="bwStr-Foot-BasedOnThe">Basado en</xsl:variable>
  <xsl:variable name="bwStr-Foot-ShowXML">mostrar XML</xsl:variable>
  <xsl:variable name="bwStr-Foot-RefreshXSLT">refrescar XSLT</xsl:variable>
  <xsl:variable name="bwStr-Foot-BedeworkWebsite">Página web de Bedework</xsl:variable>
  <xsl:variable name="bwStr-Foot-BedeworkCalendarSystem">Sistema de calendario de Bedework</xsl:variable>
  <xsl:variable name="bwStr-Foot-ProductionExamples">Ejemplos en Producción</xsl:variable>

</xsl:stylesheet>