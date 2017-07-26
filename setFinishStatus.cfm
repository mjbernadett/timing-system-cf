<!--- Copyright 2013 Michael J. Bernadett.  Do not use, modify or distribute without permission. --->

<cfparam name="url.entryID" default="0">
<cfparam name="url.finishStatus" default="">

<cfquery name="setFinishStatus" datasource="#dsn#">
	UPDATE entries
	SET finishStatus = '#url.finishStatus#'
	WHERE entryID = #url.entryID#
</cfquery>

