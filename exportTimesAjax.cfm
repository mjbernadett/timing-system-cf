<!--- Copyright 2014 Michael J. Bernadett.  Do not use, modify or distribute without permission. --->
<cfparam name="url.eventID" default="0">
<cfparam name="url.categoryID" default="0">
<cfparam name="url.filename" default="times.xls">
<cfparam name="url.showCities" default="1">

<cfset headerColor='CBE5FF'>
<cfset lightHighlight='66bbcc'>
<cfset darkHighlight='E62E00'>
<cfset charcoal='404040'>

<cfquery name="category" datasource="#dsn#">SELECT * FROM categories WHERE categoryID = #url.categoryID#</cfquery>
<cfquery name="event" datasource="#dsn#">SELECT * FROM events WHERE eventID = #url.eventID#</cfquery>
<cfquery name="entries" datasource="#dsn#">
	SELECT
		entries.racenumber,
		entrants.name,
		entrants.middleInitial,
		entrants.entrantID,
		entries.entryID,
		entries.categoryID,
		entries.licenseNo,
		entries.city,
		entries.state,
		categories.name AS categoryName
	FROM
		((entries INNER JOIN entrants ON entries.entrantID = entrants.entrantID)
		LEFT JOIN categories ON categories.categoryID = entries.categoryID)
	WHERE
		entries.eventID = #url.eventID#
		<cfif val(url.categoryID)>
		AND entries.categoryID = #url.categoryID#
		</cfif>
	GROUP BY
		entries.racenumber,
		entrants.name,
		entrants.middleInitial,
		entrants.entrantID,
		entries.entryID,
		entries.categoryID,
		entries.licenseNo,
		entries.city,
		entries.state,
		categories.name
	ORDER BY
		<cfif NOT url.categoryID>categories.name,</cfif>
		entries.racenumber
</cfquery>

<cfoutput>
<cfset timesSheet = SpreadsheetNew()>

<cfset eventDate = #DateFormat(event.eventDate, "m/d/yyyy")#>
<cfscript>
	SpreadsheetAddRow(timesSheet, "Event Discipline,Race Category,Race Gender,Race Class,Race Age Group,Rider First Name,Rider Initial,Rider Last Name,Rider Bib ##,Rider License ##,Rider City,Rider State");
</cfscript>
	
<cfset row = 2>
<cfloop query="entries">
	
	<cfif entries.categoryID AND trim(entries.categoryName) NEQ 'DROP'>
	<!--- THE ENTRIES --->
	
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
				<cfset racerGender = "Both">
			</cfif>
			<cfif ageGroup EQ "PRO">
				<cfset racerClass = "Pro/Exp">
				<cfset ageGroup = "">
			</cfif>
		</cfif>
				
		<cfset firstName = GetToken(entries.name, 1, " ")>
		<cfset lastName = Mid(entries.name, Len(firstName)+2, 25)>
		<cfscript>
			SpreadsheetAddRow(timesSheet, "#event.discipline#,#racerCategory#,#racerGender#,#racerClass#,:#ageGroup#,#firstName#,#entries.middleInitial#,#lastName#,#entries.racenumber#,#entries.licenseNo#,#entries.city#,#entries.state#", row, 1);
		</cfscript>
		<cfset col = 13>

		<cfset entryID = entries.entryID>

		<cfquery name="getEntryResults" datasource="#dsn#">
			SELECT *
			FROM results
			WHERE results.entryID = #entryID#
		</cfquery>

		<cfset racerLastStage = 0>

		<cfloop query="getEntryResults">
			<cfset thisStageNumber = getEntryResults.stageNumber>
			<cfif thisStageNumber GT racerLastStage><cfset racerLastStage = thisStageNumber></cfif>
		</cfloop>

		<cfloop from="1" to="#racerLastStage#" index="i">
			<cfquery name="startResults" datasource="#dsn#">
				SELECT TOP 1 * FROM results
				WHERE results.entryID = #entries.entryID#
				AND results.stageNumber = #i#
				AND results.resultType = 'Start'
				AND results.unknownVal = false
				ORDER BY results.resultID DESC
			</cfquery>
			<cfquery name="finishResults" datasource="#dsn#">
				SELECT TOP 1 * FROM results
				WHERE results.entryID = #entries.entryID#
				AND results.stageNumber = #i#
				AND results.resultType = 'Finish'
				AND results.unknownVal = false
				ORDER BY results.resultID DESC
			</cfquery>
			<cfif startResults.recordcount>
				<cfset resultType = "Start">
				<cfset finishTime = startResults.finishTime>
				<cfset ms = startResults.ms>
				<cfscript>
					SpreadsheetSetCellValue(timesSheet, "#i#", row, col);
					SpreadsheetSetCellValue(timesSheet, "#resultType#", row, col + 1);
					SpreadsheetSetCellValue(timesSheet, "{ts '#DateTimeFormat(finishTime, "yyyy-mm-dd HH:nn:ss")#'}", row, col + 2);
					SpreadsheetSetCellValue(timesSheet, "#ms#", row, col + 3);
				</cfscript>
				<cfset col = col + 4>
			</cfif>
			<cfif finishResults.recordcount>
				<cfset resultType = "Finish">
				<cfset finishTime = finishResults.finishTime>
				<cfset ms = finishResults.ms>
				<cfscript>
					SpreadsheetSetCellValue(timesSheet, "#i#", row, col);
					SpreadsheetSetCellValue(timesSheet, "#resultType#", row, col + 1);
					SpreadsheetSetCellValue(timesSheet, "{ts '#DateTimeFormat(finishTime, "yyyy-mm-dd HH:nn:ss")#'}", row, col + 2);
					SpreadsheetSetCellValue(timesSheet, "#ms#", row, col + 3);
				</cfscript>
				<cfset col = col + 4>
			</cfif>
		</cfloop>
		<cfset row = row + 1>
	</cfif>
</cfloop>
<cfspreadsheet action="write" filename="#url.filename#" name="timesSheet" overwrite=true>
</cfoutput>
