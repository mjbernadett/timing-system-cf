<cfparam name="url.resultID" default="0">

<cfquery name="unknownStatus" datasource="#dsn#">
	SELECT *
	FROM results
	WHERE resultID = #val(url.resultID)#
</cfquery>

<cfset unknownVal = false>
<cfquery name="missingTime" datasource="#dsn#"> <!--- add a new result entry for the missing time --->
	INSERT INTO results(entryID, finishTime, ms, unknownVal, resultType, stageNumber)
	VALUES (#unknownStatus.entryID#, #dateadd("s", -1, parsedatetime(unknownStatus.finishTime))#, #unknownStatus.ms#, #unknownVal#, '#unknownStatus.resultType#', #val(val(unknownStatus.stageNumber) - 1)#)
	INSERT INTO results(entryID, finishTime, ms, unknownVal, resultType, stageNumber)
	VALUES (#unknownStatus.entryID#, #dateadd("s", -2, parsedatetime(unknownStatus.finishTime))#, #unknownStatus.ms#, #unknownVal#, '#unknownStatus.resultType#', #val(val(unknownStatus.stageNumber) - 1)#)
</cfquery>


