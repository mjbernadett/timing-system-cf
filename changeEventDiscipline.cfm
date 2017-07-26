<!--- Copyright 2013 Michael J. Bernadett.  Do not use, modify or distribute without permission. --->
<cfparam name="url.eventID" default="0">
<cfparam name="url.discipline" default="XC">
	
<cfquery name="changeDiscipline" datasource="#dsn#">
	UPDATE events 
	SET discipline = '#url.discipline#'
	WHERE eventID = #url.eventID#
</cfquery>
