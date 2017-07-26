<!--- Copyright 2013 Michael J. Bernadett.  Do not use, modify or distribute without permission. --->
<cfparam name="url.eventID" default="0">
<cfparam name="url.categoryID" default="0">
<cfparam name="url.showMS" default="0">
<cfparam name="url.showCities" default="1">
<cfparam name="url.filename" default="usacStageResults.xls">

<cfquery name="deleteTotalTimes" datasource="#dsn#">
	DELETE FROM totalTimes
</cfquery>

<cfquery name="category" datasource="#dsn#">SELECT * FROM categories WHERE categoryID = #url.categoryID#</cfquery>
<cfquery name="event" datasource="#dsn#">SELECT * FROM events WHERE eventID = #url.eventID#</cfquery>
<cfquery name="getEntries" datasource="#dsn#">SELECT entries.entryID FROM entries WHERE entries.eventID = #url.eventID#</cfquery>
<cfloop query="getEntries">
	<cfquery name="getFinishResults" datasource="#dsn#">
		SELECT results.*
		FROM results
		WHERE results.entryID = #getEntries.entryID#
		AND results.resultType = 'Finish'
		AND results.unknownVal <> 1
		ORDER BY results.stageNumber
	</cfquery>
	<cfset totalTime = 0>
	<cfset totalMs = 0>
	<cfloop query="getFinishResults">
		<cfquery name="getStartResult" datasource="#dsn#">
			SELECT results.*
			FROM results
			WHERE results.entryID = #getFinishResults.entryID#
			AND results.stageNumber = #getFinishResults.stageNumber#
			AND results.resultType = 'Start'
			AND results.unknownVal <> 1
			ORDER BY results.finishTime
		</cfquery>
		<cfif getStartResult.recordcount>
			<cfset totalTime = totalTime + (getFinishResults.finishTime - getStartResult.finishTime)>
			<cfset totalMs = totalMs + (getFinishResults.ms - getStartResult.ms)>
		</cfif>
	</cfloop>
	<cfset addSecs = totalMs / 1000>
	<cfset addMs = totalMs mod 1000>
	<cfif addMs LT 0><cfset addSecs = addSecs - 1><cfset addMs = addMs + 1000></cfif>
	<cfset totalTime = DateAdd("s", addSecs, totalTime)>
	<cfquery name="insertTotal" datasource="#dsn#">
		INSERT INTO totalTimes (entryID, stageCount, totalTime, ms )
		VALUES (#getEntries.entryID#, #getFinishResults.recordcount#, #totalTime#, #addMs#)
	</cfquery>
</cfloop>
		
<cfquery name="entries" datasource="#dsn#">
	SELECT
		entries.racenumber,
		entrants.name,
		entrants.entrantID,
		entries.entryID,
		entries.categoryID,
		entries.finishStatus,
		entries.licenseNo,
		entries.city,
		entries.state,
		categories.name AS categoryName,
		totalTimes.stageCount AS stageCount,
		totalTimes.totalTime,
		totalTimes.ms
	FROM
		((entries LEFT JOIN totalTimes ON totalTimes.entryID = entries.entryID)
		LEFT JOIN categories ON categories.categoryID = entries.categoryID)
		INNER JOIN entrants ON entries.entrantID = entrants.entrantID
	WHERE
		entries.eventID = #url.eventID#
		<cfif val(url.categoryID)>
			AND entries.categoryID = #url.categoryID#
		</cfif>
		AND (isnull(entries.finishStatus) OR entries.finishStatus <> 'DNS')
	GROUP BY
		entries.racenumber,
		entrants.name,
		entrants.entrantID,
		entries.entryID,
		entries.categoryID,
		entries.finishStatus,
		entries.licenseNo,
		entries.city,
		entries.state,
		categories.name,
		totalTimes.stageCount,
		totalTimes.totalTime,
		totalTimes.ms
	ORDER BY
		<cfif NOT url.categoryID>categories.name,</cfif>
		<cfif isDefined("url.sortNumbers")>
			entries.racenumber
		<cfelse>
			totalTimes.stageCount DESC,
			totalTimes.totalTime ASC,
			totalTimes.ms ASC
		</cfif>
</cfquery>


<cfoutput>
<cfset resultsSheet = SpreadsheetNew()>

<cfscript>
	SpreadsheetAddRow(resultsSheet, "Event Year,Event Permit,Event Discipline,Race Date,Race Category,Race Gender,Race Class,Race Age Group,Rider Place,Rider First Name,Rider Last Name,Rider Bib ##,Rider Time,Rider Stages,Rider License ##");
</cfscript>
	
<cfset row = 2>
<cfset place = 1>
<cfset eventDiscipline = #event.discipline#>
<cfset eventYear = "#event.permitYear#">
<cfset eventPermit = "#event.permit#">
<cfset raceDate = "#event.eventDate#">
	
<cfloop query="entries">
	<!--- FIGURE OUT THE CORRECT START TIME TO CALCULATE RESULTS
		If a category ID is defined, use the category's start time.
		Otherwise, use the event's start time.
	--->
	<cfset nextCalcTime = event.start>
	<cfset calcStart = nextCalcTime>
	<cfset finishStatus = #entries.finishStatus#>

	<cfquery name="results" datasource="#dsn#">
		SELECT results.*, entries.racenumber
		FROM results LEFT JOIN entries ON results.entryID = entries.entryID
		WHERE results.entryID = #entries.entryID#
		ORDER BY results.finishTime
	</cfquery>
	
	<cfif isDefined("lastCategory")>
		<cfif entries.categoryID NEQ lastCategory>
			<cfset place = 1>
		</cfif>
	</cfif>

	<!--- THE RESULTS --->
	<cfif (results.recordcount OR finishStatus NEQ "") AND finishStatus NEQ "DNS">
		<cfset racerCategory  = "Open">
		<cfset racerGender = "Both">
		<cfset ageGroup = "">
		<cfif entries.categoryName EQ "OPEN_SINGLE_SPEED">
			<cfset racerClass = "Single Speed">
		<cfelseif entries.categoryName EQ "OPEN_CLYDESDALE">
        		<cfset racerClass = "Clydesdale">
		<cfelseif entries.categoryName EQ "OPEN_FAT_BIKE">
        		<cfset racerClass = "Fat Bike">
		<cfelse>
			<cfset racerClass = "">
			<cfset rawCategory = GetToken(entries.categoryName, 1, "_")>
        		<cfif rawCategory EQ "C1">
			    <cfset racerCategory = "Cat 1">
			<cfelseif rawCategory EQ "C2">
			    <cfset racerCategory = "Cat 2">
			<cfelseif rawCategory EQ "C3">
			    <cfset racerCategory = "Cat 3">
			<cfelseif rawCategory NEQ "">
			    <cfset racerCategory = rawCategory>
			</cfif>
        		<cfset racerGender = GetToken(entries.categoryName, 2, "_")>
			<cfif racerGender NEQ "M" AND racerGender NEQ "F">
				<cfset racerGender = "Both">
			</cfif>
        		<cfset ageMinIndex = "3">
        		<cfif GetToken(entries.categoryName, 3, "_") EQ "JR">
          			<cfset ageMinIndex = "4">
				<cfset racerClass = "Junior">
			<cfelseif GetToken(entries.categoryName, 2, "_") EQ "JR">
				<cfset racerClass = "Junior">
			</cfif>
			<cfset ageGroup = GetToken(entries.categoryName, ageMinIndex, "_")>
			<cfif racerCategory EQ "OPEN">
				<cfset racerCategory = "Open">
			</cfif>
			<cfif ageGroup EQ "PRO">
				<cfset racerClass = "Pro/Exp">
				<cfset ageGroup = "">
			</cfif>
		</cfif>
				
		<cfset firstName = GetToken(entries.name, 1, " ")>
		<cfset lastName = Mid(entries.name, Len(firstName)+2, 25)>
		<cfif NOT isnull(entries.totalTime) >
			<!--- Show Total Time, round to nearest hundredth, then to second --->
			<!--- Prepend : to prevent Excel from mangling it into time-of-day  --->

			<cfif entries.ms GE 950>
				<cfset riderTime = DateAdd("s", 1, entries.totalTime)>
				<cfset Ftenths = 0>
			<cfelse>
				<cfset riderTime = entries.totalTime>
				<cfset Ftenths = entries.ms / 100>
			</cfif>
			<cfset Fhours = evaluate(timeformat(riderTime, "H"))>
			<cfset Fminutes = evaluate(timeformat(riderTime, "nn"))>
			<cfset Fseconds = evaluate(timeformat(riderTime, "ss"))>
			<cfif val(Fhours)>
				<cfset timeText = ":#Fhours#:#trim(numberformat(Fminutes, '00'))#:#numberformat(Fseconds, '00')#.#numberformat(Ftenths, '0')#">
			<cfelse>
				<cfset timeText = ":#trim(numberformat(Fminutes, '00'))#:#numberformat(Fseconds, '00')#.#numberformat(Ftenths, '0')#">
			</cfif>
		</cfif>
		<cfif finishStatus EQ ""><cfset placeText = "#place#"><cfelse><cfset placeText = "#finishStatus#"></cfif>
		<cfscript>
			SpreadsheetAddRow(resultsSheet, "#eventYear#,#eventPermit#,#eventDiscipline#,#DateFormat(raceDate, "m/d/yyyy")#,#racerCategory#,#racerGender#,#racerClass#,:#ageGroup#,#placeText#,#firstName#,#lastName#,#entries.racenumber#,#timeText#,#entries.stageCount#,#entries.licenseNo#", row, 1);
		</cfscript>
		<cfset row = row + 1>
	</cfif>
	<cfset lastCategory = entries.categoryID>
	<cfif finishStatus NEQ "DQ"><cfset place = place + 1></cfif>
</cfloop>
<cfspreadsheet action="write" filename="#url.filename#" name="resultsSheet" overwrite=true>
</cfoutput>
