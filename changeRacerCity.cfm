<!--- Copyright 2013 Michael J. Bernadett.  Do not use, modify or disseminate without permission. --->
<cfparam name="url.entrantID" default="0">
<cfparam name="url.entryID" default="0">
<cfparam name="url.city" default="">
<cfparam name="url.state" default="">

<cfquery name="changeEntrantCity" datasource="#dsn#">
	UPDATE entrants
	SET city = '#url.city#', state = '#url.state#'
	WHERE entrantID = #url.entrantID#
</cfquery>

<cfquery name="changeEntryCity" datasource="#dsn#">
	UPDATE entries
	SET city = '#url.city#', state = '#url.state#'
	WHERE entryID = #url.entryID#
</cfquery>
