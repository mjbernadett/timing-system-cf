<!--- Copyright 2014 Michael J. Bernadett.  Do not use, modify or distribute without permission. --->
<cfparam name="url.eventID" default="0">
<cfparam name="url.categoryID" default="0">
<cfparam name="url.showMS" default="0">
<cfparam name="url.showCities" default="1">

<cfquery name="category" datasource="#dsn#">SELECT * FROM categories WHERE categoryID = #url.categoryID#</cfquery>
<cfquery name="event" datasource="#dsn#">SELECT * FROM events WHERE eventID = #url.eventID#</cfquery>
<cfquery name="entries" datasource="#dsn#">
	SELECT
		entries.racenumber,
		entrants.name,
		entrants.entrantID,
		entries.entryID,
		entries.categoryID,
		entries.teamID,
		entries.finishStatus,
		entries.licenseNo,
		entries.city,
		entries.state,
		teams.teamName,
		categories.name AS categoryName,
		categories.catStart,
		count(results.resultID) AS lapCount,
		max(results.finishTime) AS finishTime
	FROM
		(((entries INNER JOIN entrants ON entries.entrantID = entrants.entrantID)
		LEFT JOIN results ON results.entryID = entries.entryID)
		LEFT JOIN categories ON categories.categoryID = entries.categoryID)
		LEFT JOIN teams ON entries.teamID = teams.teamID
	WHERE
		entries.eventID = #url.eventID#
		<cfif relayTeams>
			AND ((entries.teamID = 0) OR (entries.teamID IS NULL))
		</cfif>
		<cfif val(url.categoryID)>
			AND entries.categoryID = #url.categoryID#
		</cfif>
	GROUP BY
		entries.racenumber,
		entrants.name,
		entrants.entrantID,
		entries.entryID,
		entries.categoryID,
		entries.teamID,
		entries.finishStatus,
		entries.licenseNo,
		entries.city,
		entries.state,
		teams.teamName,
		categories.name,
		categories.catStart
	ORDER BY
		<cfif NOT url.categoryID>categories.name,</cfif>
		<cfif isDefined("url.sortNumbers")>
			entries.racenumber
		<cfelse>
			count(results.resultID) DESC,
			max(results.finishTime) ASC
		</cfif>
</cfquery>


<cfoutput>
<cfset resultsSheet = SpreadsheetNew()>

<cfscript>
	SpreadsheetAddRow(resultsSheet, "Event Year,Event Permit,Event Discipline,Race Date,Race Category,Race Gender,Race Class,Race Age Group,Rider Place,Rider First Name,Rider Last Name,Rider Bib ##,Rider Time,Rider Laps,Rider License ##,Rider City,Rider State,Rider Team,Rider Points");
</cfscript>
	
<cfset row = 2>
<cfset place = 1>
<cfset eventDiscipline = "#event.discipline#">
<cfset eventYear = "#event.permitYear#">
<cfset eventPermit = "#event.permit#">
<cfset raceDate = "#event.eventDate#">

<cfset racerPoints=[164,146,130,116,104,94,86,80,75,71,68,65,62,59,56,53,50,47,44,41,39,37,35,33,31,29,27,25,23,21,20,18,17,16,15,14,13,12,11]>
	
<cfloop query="entries">

	<cfif isnull(entries.finishStatus) OR entries.finishStatus NEQ "DNS">
	<!--- FIGURE OUT THE CORRECT START TIME TO CALCULATE RESULTS
		If a category ID is defined, use the category's start time.
		Otherwise, use the event's start time.
	--->
	<cfif isdate(entries.catStart)><cfset nextCalcTime = entries.catStart>
	<cfelse><cfset nextCalcTime = event.start></cfif>
	<cfset calcStart = nextCalcTime>

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
	<cfif results.recordcount OR entries.finishStatus EQ "DNF" OR entries.finishStatus EQ "DQ">
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
			<cfelse>
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
				<cfset racerCategory = "Pro/1">
				<cfset ageGroup = "">
			</cfif>
		</cfif>
				
		<cfset firstName = GetToken(entries.name, 1, " ")>
		<cfset lastName = Mid(entries.name, Len(firstName)+2, 25)>
		<cfset entryRaceNum = entries.racenumber>
		<cfset rLoop = 0>
		<cfset Fhours = 0>
		<cfset Fminutes = 0>
		<cfset Fseconds = 0>
		<cfloop query="results">
			<!--- Calculate Lap Time --->
			<cfset hours = datediff("h", nextCalcTime, results.finishTime)>
			<cfset minutes = evaluate(datediff("n", nextCalcTime, results.finishTime) - hours*60)>
			<cfset seconds = evaluate(datediff("s", nextCalcTime, results.finishTime) - (hours*60*60+minutes*60))>
			<cfset straightminutes = datediff("n", nextCalcTime, results.finishTime)>
			<cfset nextCalcTime = results.finishTime>
			<!--- Calculate Total Time --->
			<cfset Fhours = datediff("h", calcStart, nextCalcTime)>
			<cfset Fminutes = evaluate(datediff("n", calcStart, nextCalcTime) - Fhours*60)>
			<cfset Fseconds = evaluate(datediff("s", calcStart, nextCalcTime) - (Fhours*60*60+Fminutes*60))>
			<cfset rLoop = rLoop + 1>
		</cfloop>
		<cfif val(Fhours)>
			<cfset time = ":#Fhours#:#trim(numberformat(Fminutes, '00'))#:#numberformat(Fseconds, '00')#">
		<cfelse>
			<cfset time = ":#trim(numberformat(Fminutes, '00'))#:#numberformat(Fseconds, '00')#">
		</cfif>
		<cfif entries.finishStatus NEQ "">
			<cfset placeText = entries.finishStatus>
			<cfset riderPoints = 0>
		<cfelse>
			<cfset placeText = #place#>
			<cfquery name="catentries" datasource = "#dsn#">
				SELECT * from entries
				WHERE eventID = #url.eventID#
				AND categoryID = #entries.categoryID#
				AND ((entries.finishStatus <> 'DNS') OR (entries.finishStatus IS NULL))
			</cfquery>
			<cfset numCatEntries = catentries.recordcount>
			<cfif place LT 40>
				<cfset riderPoints = #racerPoints[place]#>
			<cfelse>
				<cfset riderPoints = 10>
			</cfif>
			<cfif GetToken(entries.categoryName, 1, "_") EQ "C1">
				<cfset riderPoints = riderPoints + cat1Bonus>
			<cfelseif GetToken(entries.categoryName, 1, "_") EQ "C2" ||
				entries.categoryName EQ "OPEN_CLYDESDALE" ||
				entries.categoryName EQ "OPEN_SINGLE_SPEED" ||
				entries.categoryName EQ "OPEN_FAT_BIKE">
				<cfset riderPoints = riderPoints + cat2Bonus>
			</cfif>
			<cfif addFieldSizeToPoints>
				<cfset riderPoints = riderPoints + numCatEntries>
			</cfif>
		</cfif>
		<cfscript>
			SpreadsheetAddRow(resultsSheet, "#eventYear#,#eventPermit#,#event.discipline#,#DateFormat(raceDate, "m/d/yyyy")#,#racerCategory#,#racerGender#,#racerClass#,:#ageGroup#,#placeText#,#firstName#,#lastName#,#entries.racenumber#,#time#,#rLoop#,#entries.licenseNo#,#entries.city#,#entries.state#,#entries.teamName#,#riderPoints#", row, 1);
		</cfscript>
		<cfset row = row + 1>
	</cfif>
	<cfset lastCategory = entries.categoryID>
	<cfif entries.finishStatus EQ ""><cfset place = place + 1></cfif>
	</cfif>
</cfloop>
<cfspreadsheet action="write" filename="#url.filename#" name="resultsSheet" overwrite=true>
</cfoutput>
