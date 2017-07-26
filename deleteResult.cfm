<cfparam name="url.resultID" default="0">

<cfquery name="deleteResult" datasource="#dsn#">
	DELETE FROM results
	WHERE resultID = #val(url.resultID)#
</cfquery>


