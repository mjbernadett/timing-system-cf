<!--- Copyright 2013 Michael J. Bernadett.  Do not use, modify or disseminate without permission. --->
<cfparam name="url.entrantID" default="0">
<cfparam name="url.entryID" default="0">
<cfparam name="url.middleInitial" default="">

<cfquery name="changeEntrantMiddleInitial" datasource="#dsn#">
	UPDATE entrants
	SET middleInitial = '#url.middleInitial#'
	WHERE entrantID = #url.entrantID#
</cfquery>
