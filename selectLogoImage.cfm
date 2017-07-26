<!--- Copyright 2014 Michael J. Bernadett  Do not use, modify or distribute without permission --->
<cfsetting enablecfoutputonly="Yes">
<cfparam name="url.eventID" default=0>
<cfparam name="url.eventDate" default="">
<cfparam name="url.showEventTools" default="0">

<cffile action="upload"
	destination="#GetDirectoryFromPath(GetCurrentTemplatePath())#"
	nameConflict="makeunique"
	fileField="form.selectLogoImage">

<cfset fullPath="#cffile.ServerDirectory#\#cffile.ServerFileName#.#cffile.ServerFileExt#">

<cfquery datasource="#dsn#">
	UPDATE events
	SET logoImage = '#cffile.ServerFileName#.#cffile.ServerFileExt#'
	where events.eventID = #url.eventID#
</cfquery>

<!--- xmlhttp.responseText --->
<!--- <cfoutput>File: #fullPath#</cfoutput> --->

<cflocation url="index.cfm?eventID=#val(url.eventID)#&eventDate=#url.eventDate#&showEventTools=#url.showEventTools#">
