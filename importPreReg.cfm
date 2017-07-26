<!--- Copyright 2013 Michael J. Bernadett  Do not use, modify or distribute without permission --->
<cfsetting enablecfoutputonly="Yes">
<cfparam name="url.eventID" default=0>
<cfparam name="url.eventDate" default="">
<cfparam name="url.showEventTools" default="0">

<cffile action="upload"
	destination="resultsfiles\"
	nameConflict="makeunique"
	fileField="form.importPreRegFile">

<cfset fullPath="#cffile.ServerDirectory#\#cffile.ServerFileName#.#cffile.ServerFileExt#">

<cfset preRegSheet = SpreadSheetRead(#fullPath#)>

<!--- process spreadsheet --->
<cfset catColumn=0>
<cfset genderColumn=0>
<cfset classColumn=0>
<cfset agColumn=0>
<cfset firstNameColumn=0>
<cfset initialColumn=0>
<cfset lastNameColumn=0>
<cfset lapsColumn=0>
<cfset licenseColumn=0>
<cfset cityColumn=0>
<cfset stateColumn=0>
<cfset teamColumn=0>
<cfset bibNoColumn=0>
<cfset teamColumn=0>
<cfset col = 1>
<cfloop condition="#SpreadsheetGetCellValue(preRegSheet, 1, col)# NEQ ''">
	<cfswitch expression = "#SpreadsheetGetCellValue(preRegSheet, 1, col)#">
	<cfcase value = "Race Category|Category" delimiters="|">
		<cfset catColumn = col>
	</cfcase> 
	<cfcase value = "Race Gender|Gender" delimiters="|">
		<cfset genderColumn = col>
	</cfcase>
	<cfcase value = "Race Class|Class" delimiters="|">
		<cfset classColumn = col>
	</cfcase>
	<cfcase value = "Race Age Group|Age Group" delimiters="|">
		<cfset agColumn = col>
	</cfcase>
	<cfcase value = "Rider First Name|First Name" delimiters="|">
		<cfset firstNameColumn = col>
	</cfcase>
	<cfcase value = "Rider Initial|Initial" delimiters="|">
		<cfset initialColumn = col>
	</cfcase>
	<cfcase value = "Rider Last Name|Last Name" delimiters="|">
		<cfset lastNameColumn = col>
	</cfcase>
	<cfcase value = "Rider Bib ##|Bib ##" delimiters="|">
		<cfset bibNoColumn = col>
	</cfcase>
	<cfcase value = "USAC ##|Rider License ##" delimiters="|">
		<cfset licenseColumn = col>
	</cfcase>
	<cfcase value = "Rider City|City" delimiters="|">
		<cfset cityColumn = col>
	</cfcase>
	<cfcase value = "Rider State|State" delimiters="|">
		<cfset stateColumn = col>
	</cfcase>
	<cfcase value = "Rider Team|Team" delimiters="|">
		<cfset teamColumn = col>
	</cfcase>
	</cfswitch>
	<cfset col = col + 1>
</cfloop>

<cfset i = 2>
<cfloop condition="#SpreadsheetGetCellValue(preRegSheet, i, catColumn)# NEQ ''">
	<cfset newRacerName="#SpreadsheetGetCellValue(preRegSheet, i, firstNameColumn)# #SpreadsheetGetCellValue(preRegSheet, i, lastNameColumn)#">
	<cfif #SpreadsheetGetCellValue(preRegSheet, i, classColumn)# EQ "Single Speed">
		<cfset category="OPEN_SINGLE_SPEED">
	<cfelseif #SpreadsheetGetCellValue(preRegSheet, i, classColumn)# EQ "Clydesdale">
		<cfset category="OPEN_CLYDESDALE">
	<cfelseif #SpreadsheetGetCellValue(preRegSheet, i, classColumn)# EQ "Fat Bike">
		<cfset category="OPEN_FAT_BIKE">
	<cfelseif #SpreadsheetGetCellValue(preRegSheet, i, classColumn)# EQ "Pro/Exp">
		<cfif #SpreadsheetGetCellValue(preRegSheet, i, genderColumn)# EQ "F">
			<cfset category="C1_#SpreadsheetGetCellValue(preRegSheet, i, genderColumn)#_PRO_EXPERT">
		<cfelse>
			<cfset category="C1_#SpreadsheetGetCellValue(preRegSheet, i, genderColumn)#_PRO">
		</cfif>
	<cfelse>
		<cfif #SpreadsheetGetCellValue(preRegSheet, i, catColumn)# EQ "Cat 1">
			<cfset category="C1_">
		<cfelseif #SpreadsheetGetCellValue(preRegSheet, i, catColumn)# EQ "Cat 2">
			<cfset category="C2_">
		<cfelseif #SpreadsheetGetCellValue(preRegSheet, i, catColumn)# EQ "Cat 3">
			<cfset category="C3_">
		<cfelseif #SpreadsheetGetCellValue(preRegSheet, i, catColumn)# EQ "Open">
			<cfset category="OPEN_">
		<cfelse>
			<cfset category="_#SpreadsheetGetCellValue(preRegSheet, i, catColumn)#_">
		</cfif>
		<cfif #SpreadsheetGetCellValue(preRegSheet, i, genderColumn)# NEQ "Both">
			<cfset category="#category##SpreadsheetGetCellValue(preRegSheet, i, genderColumn)#_">
		</cfif>
		<cfif #SpreadsheetGetCellValue(preRegSheet, i, classColumn)# EQ "Junior">
			<cfset category="#category#JR_">
		</cfif>
		<cfset category="#category##GetToken(SpreadsheetGetCellValue(preRegSheet, i, agColumn), 1, ":")#">
	</cfif>
	<cfset thisRacerLicenseNo="#SpreadsheetGetCellValue(preRegSheet, i, licenseColumn)#">
	<cfset thisRacerMiddleInitial="#SpreadsheetGetCellValue(preRegSheet, i, initialColumn)#">
	<cfset racenumber=val(#SpreadsheetGetCellValue(preRegSheet, i, bibNoColumn)#)>
	<cfset thisRacerCity="#SpreadsheetGetCellValue(preRegSheet, i, cityColumn)#">
	<cfset thisRacerTeam="#SpreadsheetGetCellValue(preRegSheet, i, teamColumn)#">

	<!--- GET THE RACER IF THEY EXIST --->
	<cfquery name="getRacer" datasource="#dsn#">
		SELECT entrantID, name, licenseNo, city, state, middleInitial FROM entrants
			WHERE (ltrim(rtrim(lcase(name))) = '#lcase(trim(newRacerName))#'
			AND ((isnull(middleInitial) AND '#trim(thisRacerMiddleInitial)#' = '') OR trim(middleInitial) = '#trim(thisRacerMiddleInitial)#')
			AND ltrim(rtrim(city)) = '#trim(thisRacerCity)#')
			OR (isnumeric(trim(licenseNo)) AND trim(licenseNo) = '#trim(thisRacerLicenseNo)#')
	</cfquery>


	<!--- Racer doesn't exist, create them as a new entrant --->
	<cfif NOT getRacer.recordcount>
		<cfset thisEntrantName=newRacerName>
		<cfset thisRacerCity="#SpreadsheetGetCellValue(preRegSheet, i, cityColumn)#">
		<cfset thisRacerState="#SpreadsheetGetCellValue(preRegSheet, i, stateColumn)#">
		<cfquery name="newEntrant" datasource="#dsn#"><!--- create a new entrant --->
			INSERT INTO entrants(name, middleInitial, licenseNo, city, state)
			VALUES ('#thisEntrantName#', '#thisRacerMiddleInitial#', '#thisRacerLicenseNo#', '#thisRacerCity#', '#thisRacerState#')
		</cfquery>
		<cfquery name="getNewRacer" datasource="#dsn#"><!--- get the new entrant ID --->
			SELECT max(entrantID) AS eID
			FROM entrants
		</cfquery>
		<cfset thisEntrantID=getNewRacer.eID>
	<cfelse>
		<cfset thisEntrantID=getRacer.entrantID>
		<cfset thisEntrantName=getRacer.name>
		<cfif #SpreadsheetGetCellValue(preRegSheet, i, licenseColumn)# EQ "">
			<cfset thisRacerLicenseNo=getRacer.licenseNo>
		<cfelse>
			<cfset thisRacerLicenseNo=#SpreadsheetGetCellValue(preRegSheet, i, licenseColumn)#>
		</cfif>
		<cfif #SpreadsheetGetCellValue(preRegSheet, i, cityColumn)# EQ "">
			<cfset thisRacerCity=getRacer.city>
			<cfset thisRacerState=getRacer.state>
		<cfelse>
			<cfset thisRacerCity=#SpreadsheetGetCellValue(preRegSheet, i, cityColumn)#>
			<cfset thisRacerState=#SpreadsheetGetCellValue(preRegSheet, i, stateColumn)#>
			<cfquery name="updateCity" datasource="#dsn#"><!--- update the city for this entrant --->
				UPDATE entrants
				SET city = '#thisRacerCity#', state = '#thisRacerState#'
				WHERE entrantID = #getRacer.entrantID#
			</cfquery>
		</cfif>
	</cfif>

	<cfquery name="getcategory" datasource="#dsn#">SELECT categoryID FROM categories WHERE name = '#category#' AND eventID = val(#url.eventID#)</cfquery>
	
	<!--- Filter out duplicate entries --->
	<cfquery name="findEntry" datasource="#dsn#">
		SELECT entryID, teamID from entries
		WHERE entries.eventID = #url.eventID#
		AND entries.entrantID = #thisEntrantID#
		AND entries.racenumber = #racenumber#
	</cfquery>

	<cfif (NOT isnull(#thisRacerTeam#)) AND #thisRacerTeam# NEQ "">
		<cfquery name="getteam" datasource="#dsn#">SELECT teamID FROM teams WHERE teamName = '#thisRacerTeam#'</cfquery>

		<cfif NOT getteam.recordcount>
			<!--- Team doesn't exist, create new team record --->
			<cfquery name = "newTeam" datasource="#dsn#">
				INSERT INTO teams (teamName)
				VALUES ('#thisRacerTeam#')
			</cfquery>
		</cfif>

		<cfquery name="getteamNew" datasource="#dsn#">SELECT teamID FROM teams WHERE teamName = '#thisRacerTeam#'</cfquery>
		<cfset thisRacerTeamID=getteamNew.teamID>
	<cfelse>
		<cfset thisRacerTeamID=findEntry.teamID>
	</cfif>

	<cfif NOT findEntry.recordcount>
		<!--- CREATE THE NEW EVENT ENTRY FOR THE ENTRANT --->
		<cfif val(url.eventID) AND val(thisEntrantID)>
			<cfquery name="newRaceEntry" datasource="#dsn#"><!--- create a new event entry for this entrant --->
				INSERT INTO entries (eventID, entrantID, categoryID, teamID, racenumber, licenseNo, city, state)
				VALUES (#url.eventID#, #thisEntrantID#, #val(getcategory.categoryID)#, #val(thisRacerteamID)#, #val(racenumber)#, '#thisRacerLicenseNo#', '#thisRacerCity#', '#thisRacerState#')
			</cfquery>
		</cfif>
	<cfelse>
		<cfquery name="updateTeam" datasource="#dsn#"><!--- update the team for this entry --->
			UPDATE entries
			SET teamID = #thisRacerteamID#
			WHERE entryID = #findEntry.entryID#
		</cfquery>
	</cfif>
	<cfset i = i + 1>	
</cfloop>

<cfscript>
	FileDelete(#fullPath#);
</cfscript>

<!--- xmlhttp.responseText --->
<!--- <cfoutput>#fullPath#: Cell 1,1: #SpreadsheetGetCellValue(preRegSheet, 1, 1)#</cfoutput> --->

<cflocation url="index.cfm?eventID=#val(url.eventID)#&eventDate=#url.eventDate#&showEventTools=#url.showEventTools#">
