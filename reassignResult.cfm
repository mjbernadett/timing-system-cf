<!--- Copyright 2014 Michael J. Bernadett.  Do not use, modify or distribute without permission. --->
<cfparam name="url.eventID" default="0">
<cfparam name="url.resultID" default="0">
<cfparam name="url.riderNumber" default="0">

<cfquery name="getEntryID" datasource="#dsn#">
	SELECT entryID
	FROM entries
	WHERE
		eventID = #url.eventID# AND
		racenumber = #url.riderNumber#
</cfquery>

<cfloop query="getEntryID">
	<cfquery name="result" datasource="#dsn#">
		UPDATE results
		SET entryID = #val(getEntryID.entryID)#
		WHERE resultID = #val(url.resultID)#
	</cfquery>
</cfloop>



