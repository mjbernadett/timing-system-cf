<!--- Copyright 2015 Michael J. Bernadett  Do not use, modify or distribute without permission --->
<cfparam name="url.eventID" default="0">
<cfparam name="url.autoRefresh" default="2000">
<cfparam name="url.maxRows" default="10">

<html>
<head>
	<title>Racer Log</title>
</head>

<body style="background-color:#F6F6F6;">

<cfoutput>

<!--- Auto-refresh --->
<cfif #url.autoRefresh#>
<script language="JavaScript" type="text/javascript">
	var refreshInterval = #url.autoRefresh#;
	var pauseTimeout = null;
		
	document.body.onload = refreshInit;
	
	function refreshInit(){
		pauseTimeout = window.setTimeout(kickoff, refreshInterval);
	}
	
	function kickoff(){
		window.location.reload(true);
		pauseTimeout = window.setTimeout(kickoff, refreshInterval);
	}
</script>
</cfif>

<cfquery name="racerlog" datasource="#dsn#">
	SELECT 
		entries.entryID,
		entries.racenumber,
		teams.teamName,
		entrants.name,
		results.resultID,
		results.finishTime,
		categories.categoryID,
		categories.catStart,
		categories.name AS categoryName,
		categories.laps
	FROM
		(((entries LEFT JOIN teams ON entries.teamID = teams.teamID)
		LEFT JOIN entrants ON entries.entrantID = entrants.entrantID)
		LEFT JOIN results ON entries.entryID = results.entryID)
		LEFT JOIN categories ON entries.categoryID = categories.categoryID 
	WHERE
		entries.eventID = #url.eventID#
		AND (entries.finishStatus = '' OR entries.finishStatus IS NULL)
		AND NOT (results.finishTime IS NULL)
	GROUP BY
		entries.entryID,
		entries.racenumber,
		teams.teamName,
		entrants.name,
		results.resultID,
		results.finishTime,
		categories.categoryID,
		categories.catStart,
		categories.name,
		categories.laps
	ORDER BY
		results.finishTime
</cfquery>

<cfquery name="eventcats" datasource="#dsn#">
	SELECT
		MIN(categories.catStart) AS eventStart
	FROM
		categories
	WHERE
		categories.eventID = #url.eventID#
</cfquery>

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

<th style="width:3em;">Bib ##</th><th style="width:4em;">Running Time</th>
<th style="width:9em;">Name</th><th>Team</th><th style="width:9em;">Category</th>
<th style="width:3em;">Place</th><th style="width:4em;">Time Back</th><th style="width:3em;">Laps</th>
<th style="width:4em;">Lap Time</th>

<cfset eventStart = eventcats.eventStart>
<cfset logCount = racerlog.recordcount>
<cfset racerCategoryID = 0>
<cfset racerEntryID = 0>

<cfloop query="racerlog">
	<cfset racerCategoryID = racerlog.categoryID>
	<cfset racerEntryID = racerlog.entryID>
</cfloop>

<cfquery name="getnewlaps" datasource="#dsn#">
	SELECT
		results.resultID
	FROM	results
	WHERE
		results.entryID = #racerEntryID#
</cfquery>

<cfset newRacerLaps = getnewlaps.recordcount>	
<cfset skip = 0>
<cfloop query="racerlog">
   <cfset skip = skip + 1>
   <cfif skip GT (logCount - url.maxRows)>
	<cfquery name="lapcount" datasource="#dsn#">
		SELECT 
			results.resultID,
			results.entryID
		FROM results
		WHERE
			results.entryID = #racerlog.entryID#
			AND results.resultID <= #val(racerlog.resultID)#
		GROUP BY 
			results.resultID,			
			results.entryID
	</cfquery>
	<cfquery name="categoryentries" datasource="#dsn#">
		SELECT	entryID
		FROM
			entries
		WHERE
			entries.categoryID = #racerlog.categoryID#
			AND (entries.finishStatus <> 'DNS' OR entries.finishStatus IS NULL)
	</cfquery>
	<cfquery name="opponenttime" datasource="#dsn#">
		SELECT 
			results.resultID,
			results.entryID,
			results.finishTime
		FROM
			results LEFT JOIN entries ON results.entryID = entries.entryID
		WHERE
			entries.categoryID = #racerlog.categoryID#
			AND (entries.finishStatus <> 'DNS' OR entries.finishStatus IS NULL)
		GROUP BY
			results.resultID,
			results.entryID,
			results.finishTime
		ORDER BY
			results.finishTime DESC
	</cfquery>
	<cfset racerLaps=lapcount.recordcount>

	<cfset raceFinish=(racerLaps EQ racerlog.laps)>
	<cfif raceFinish>
		<cfset timeBack = "Winner">
	<cfelse>
		<cfset timeBack = "Leader">
	</cfif>

	<cfset place=1>
	<cfset racerLapTime=0>
	<cfloop query="opponenttime">
		<cfquery name="infrontlaps" datasource="#dsn#">
			SELECT entryID
			FROM results
			WHERE
				results.entryID = #opponenttime.entryID#
				AND results.resultID <= #val(opponenttime.resultID)#
		</cfquery>
		<cfif opponenttime.entryID NEQ #val(racerlog.entryID)#>
			<cfif infrontlaps.recordcount EQ racerLaps>
				<cfif opponenttime.resultID LT #val(racerlog.resultID)#>
					<!--- <cfif place EQ 1> from rider ahead, vs from cat leader --->
						<cfset timeBack = #TimeFormat(racerlog.finishTime - opponenttime.finishTime, "H:mm:ss")#>
					<!--- </cfif> --->
					<cfset place=place + 1>
				</cfif>
			</cfif>
		<cfelseif infrontlaps.recordcount>
			<cfif infrontlaps.recordcount EQ (racerLaps - 1)>
				<cfset racerLapTime = #TimeFormat(racerlog.finishTime - opponenttime.finishTime, "H:mm:ss")#>
			<cfelseif racerLaps EQ 1>
				<cfset racerLapTime = #TimeFormat(racerlog.finishTime - racerlog.catStart, "H:mm:ss")#>
			</cfif>
		</cfif>
	</cfloop>
	
	<tr style="<cfif #racerlog.categoryID# EQ racerCategoryID and racerLaps EQ newRacerLaps>background-color:cyan;</cfif>font-family:arial black;font-size:8pt;">
		<td align="center">#racerlog.racenumber#</td>
		<td align="center">#TimeFormat(racerlog.finishTime - eventStart, "H:mm:ss")#</td>
		<td>#racerlog.name#</td>
		<td>#racerlog.teamName#</td><td>#racerlog.categoryName#</td>
		<td align="center" <cfif raceFinish>style="font-weight:bold;"</cfif>>#place#/#categoryentries.recordcount#</td>
		<td align="center" <cfif raceFinish>style="font-weight:bold;"</cfif>>#timeBack#</td>
		<td align="center" <cfif raceFinish>style="font-weight:bold;"</cfif>>#racerLaps#/#racerlog.laps#</td>
		<td align="center">#racerLapTime#</td></tr>
   </cfif>
</cfloop>

</table>
</cfoutput>

</body>
</html>