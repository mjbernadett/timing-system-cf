<cfparam name="url.finishResultID" default="0">
<cfparam name="url.startResultID" default="0">
<cfparam name="url.ignore" default="1">

<cfquery name="finishResult" datasource="#dsn#">
	UPDATE results
	SET unknownVal = #val(url.ignore)#
	WHERE resultID = #val(url.finishResultID)#
</cfquery>

<cfquery name="startResult" datasource="#dsn#">
	UPDATE results
	SET unknownVal = #val(url.ignore)#
	WHERE resultID = #val(url.startResultID)#
</cfquery>



