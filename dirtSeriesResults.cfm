<!--- Copyright 2016 Michael J. Bernadett.  Do not use, modify or distribute without permission. --->
<cfparam name="url.eventID" default="0">
<cfparam name="url.categoryID" default="0">
<cfparam name="url.showMS" default="0">
<cfparam name="url.showCities" default="1">


<cfset racerPoints=[164,146,130,116,104,94,86,80,75,71,68,65,62,59,56,53,50,47,44,41,39,37,35,33,31,29,27,25,23,21,20,18,17,16,15,14,13,12,11]>

<!--- Override add Field size while state series is going on --->
<cfset addFieldSizeToPoints = 1>

<html>
<cfoutput>
<cfquery name="event" datasource="#dsn#">SELECT * FROM events WHERE eventID = #url.eventID#</cfquery>

<head>
	<title>NC Dirt Series Results, Permit #event.permitYear#-#event.permit#</title>
</head>
<body>

<cfif isnull(event.permitYear) OR isnull(event.permit) OR val(event.permitYear) EQ 0 OR val(event.permit) EQ 0>
	<span style="font-size:14pt;font-weight:bold;">Permit field not set in event database record, eventID = #event.eventID#.</span>
<cfelse>

<cfquery name="events" datasource="#dsn#">
	SELECT eventID FROM events
	WHERE permitYear = #val(event.permitYear)# AND permit = #val(event.permit)#
	ORDER BY eventID
</cfquery>

<!---
<cfset resultsSheet = SpreadsheetNew()>
<cfscript>
	SpreadsheetAddRow(resultsSheet, "Race Gender,Rider Name,Rider Points");
</cfscript>
--->

<style type="text/css">
table {
    border-collapse: collapse;
}

table, th, td {
   border: 1px solid black;
}

th {
   font: courier new;
}
</style>

<table>
<tr><th colspan="6" style="font-size:16pt;">Dirt Series Results after #event.name#</th></tr>
<th>Count</th><th>Place</th><th style="width:4em;">Race Gender</th><th style="width:11em;">Rider Name</th><th>Points</th><th>Podiums</th>

<cfquery name="deleteSeriesPoints" datasource="#dsn#">
	DELETE FROM seriesPoints
</cfquery>

<cfloop query="events">
<cfquery name="category" datasource="#dsn#">SELECT * FROM categories WHERE categoryID = #url.categoryID#</cfquery>
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
		entries.eventID = #events.eventID#
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

<cfset place = 1>
	
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
		<cfset racerGender = "Open">
		<cfif GetToken(entries.categoryName, 1, "_") NEQ "OPEN">
       			<cfset racerGender = GetToken(entries.categoryName, 2, "_")>
			<cfif racerGender NEQ "M" AND racerGender NEQ "F">
				<cfset racerGender = "Open">
			</cfif>
		</cfif>
				
		<cfif entries.finishStatus NEQ "">
			<cfset riderPoints = 0>
		<cfelse>
			<cfquery name="catentries" datasource = "#dsn#">
				SELECT * from entries
				WHERE eventID = #events.eventID#
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
				<cfset riderPoints = riderPoints + 15>
			<cfelseif GetToken(entries.categoryName, 1, "_") EQ "C2" ||
				entries.categoryName EQ "OPEN_CLYDESDALE" ||
				entries.categoryName EQ "OPEN_SINGLE_SPEED" ||
				entries.categoryName EQ "OPEN_FAT_BIKE">
				<cfset riderPoints = riderPoints + 8>
			</cfif>
			<cfif addFieldSizeToPoints>
				<cfset riderPoints = riderPoints + numCatEntries>
			</cfif>
		</cfif>
	</cfif>
	<cfset lastCategory = entries.categoryID>
	<cfset podium = 0>
	<cfif entries.finishStatus EQ "">
		<cfif place LTE podiumcutoff>
			<cfset podium = 1>
		</cfif>
		<cfset place = place + 1>
	</cfif>

	<cfquery name="gettotal" datasource="#dsn#">SELECT * from seriesPoints where entrantID = #entries.entrantID#</cfquery>
	<cfif gettotal.recordcount>
		<cfquery name="updatetotal" datasource="#dsn#">UPDATE seriesPoints SET totalPoints = #val(gettotal.totalPoints + riderPoints)#
			, podiums = #val(gettotal.podiums + podium)#
			WHERE entrantID = #entries.entrantID#
		</cfquery>
	<cfelse>
		<cfquery name="settotal" datasource="#dsn#">INSERT INTO seriesPoints (entrantID, gender, totalPoints, podiums) 
		VALUES (#entries.entrantID#, '#racerGender#', #riderPoints#, #podium#)
		</cfquery>
	</cfif>
   </cfif>
</cfloop>
<cfif events.eventID EQ event.eventID>
	<cfbreak>
</cfif>
</cfloop>

<cfquery name="getentrants" datasource="#dsn#">
	SELECT
		entrantID,
		gender,
		totalPoints,
		podiums
	FROM seriesPoints
	GROUP BY
		entrantID,
		gender,
		totalPoints,
		podiums
	ORDER BY totalPoints desc</cfquery>
<cfset row=2>
<cfset seriesPlace=1>
<cfset prevPoints=-1>
<cfloop query="getentrants">
	<cfquery name="getentrant" datasource="#dsn#">SELECT name from entrants WHERE entrantID = #getentrants.entrantID#
	</cfquery>
<!---
	<cfscript>
		SpreadsheetAddRow(resultsSheet, "#racerGender#,#getentrant.name#,#getentrants.totalPoints#,#getentrants.podiums#", row, 1);
	</cfscript>
--->
	<cfif getentrants.totalPoints NEQ prevPoints>
		<cfset seriesPlace = row - 1>
		<cfset prevPoints = getentrants.totalPoints>
	</cfif>

		
	<tr><td>#row - 1#</td><td>#seriesPlace#</td><td>#getentrants.gender#</td><td>#getentrant.name#</td><td>#getentrants.totalPoints#</td><td>#getentrants.podiums#</td></tr>
	<cfset row = row + 1>
</cfloop>

<!--- <cfspreadsheet action="write" filename="#url.filename#" name="seriesSheet" overwrite=true> --->
</cfif>
</body>
</cfoutput>
</html>
