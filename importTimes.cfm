<!--- Copyright 2013 Michael J. Bernadett  Do not use, modify or disseminate without permission --->
<cfsetting enablecfoutputonly="Yes">
<cfparam name="url.eventID" default=0>
<cfparam name="url.eventDate" default="">
<cfparam name="url.showEventTools" default="0">

<cffile action="upload"
	destination="resultsfiles\"
	nameConflict="makeunique"
	fileField="form.importTimesFile">

<cfset fullPath="#cffile.ServerDirectory#\#cffile.ServerFileName#.#cffile.ServerFileExt#">

<cfset timeSheet = SpreadSheetRead(#fullPath#)>

<!--- process spreadsheet --->
<cfset catColumn=0>
<cfset genderColumn=0>
<cfset classColumn=0>
<cfset agColumn=0>
<cfset firstNameColumn=0>
<cfset initialColumn=0>
<cfset lastNameColumn=0>
<cfset licenseColumn=0>
<cfset cityColumn=0>
<cfset stateColumn=0>
<cfset bibNoColumn=0>
<cfset col = 1>
<cfloop condition="#SpreadsheetGetCellValue(timeSheet, 1, col)# NEQ ''">
	<cfswitch expression = "#SpreadsheetGetCellValue(timeSheet, 1, col)#">
	<cfcase value = "Race Category">
		<cfset catColumn = col>
	</cfcase> 
	<cfcase value = "Race Gender">
		<cfset genderColumn = col>
	</cfcase>
	<cfcase value = "Race Class">
		<cfset classColumn = col>
	</cfcase>
	<cfcase value = "Race Age Group">
		<cfset agColumn = col>
	</cfcase>
	<cfcase value = "Rider First Name">
		<cfset firstNameColumn = col>
	</cfcase>
	<cfcase value = "Rider Initial">
		<cfset initialColumn = col>
	</cfcase>
	<cfcase value = "Rider Last Name">
		<cfset lastNameColumn = col>
	</cfcase>
	<cfcase value = "Rider City">
		<cfset cityColumn = col>
	</cfcase>
	<cfcase value = "Rider State">
		<cfset stateColumn = col>
	</cfcase>
	<cfcase value = "Rider Bib ##">
		<cfset bibNoColumn = col>
	</cfcase>
	<cfcase value = "Rider License ##">
		<cfset licenseColumn = col>
	</cfcase>
	</cfswitch>
	<cfset col = col + 1>
</cfloop>

<cfset i = 2>
<cfloop condition="#SpreadsheetGetCellValue(timeSheet, i, catColumn)# NEQ ''">
	<cfset newRacerName="#SpreadsheetGetCellValue(timeSheet, i, firstNameColumn)# #SpreadsheetGetCellValue(timeSheet, i, lastNameColumn)#">
	<cfif #SpreadsheetGetCellValue(timeSheet, i, classColumn)# EQ "Single Speed">
		<cfset category="OPEN_SINGLE_SPEED">
	<cfelseif #SpreadsheetGetCellValue(timeSheet, i, classColumn)# EQ "Clydesdale">
		<cfset category="OPEN_CLYDESDALE">
	<cfelseif #SpreadsheetGetCellValue(timeSheet, i, classColumn)# EQ "Fat Bike">
		<cfset category="OPEN_FAT_BIKE">
	<cfelseif #SpreadsheetGetCellValue(timeSheet, i, classColumn)# EQ "Pro/Exp">
		<cfif #SpreadsheetGetCellValue(timeSheet, i, genderColumn)# EQ "F">
			<cfset category="C1_#SpreadsheetGetCellValue(timeSheet, i, genderColumn)#_PRO_EXPERT">
		<cfelse>
			<cfset category="C1_#SpreadsheetGetCellValue(timeSheet, i, genderColumn)#_PRO">
		</cfif>
	<cfelse>
		<cfif #SpreadsheetGetCellValue(timeSheet, i, catColumn)# EQ "Cat 1">
			<cfset category="C1_">
		<cfelseif #SpreadsheetGetCellValue(timeSheet, i, catColumn)# EQ "Cat 2">
			<cfset category="C2_">
		<cfelseif #SpreadsheetGetCellValue(timeSheet, i, catColumn)# EQ "Cat 3">
			<cfset category="C3_">
		<cfelseif #SpreadsheetGetCellValue(timeSheet, i, catColumn)# EQ "Open">
			<cfset category="OPEN_">
		</cfif>
		<cfif #SpreadsheetGetCellValue(timeSheet, i, genderColumn)# NEQ "Both">
			<cfset category="#category##SpreadsheetGetCellValue(timeSheet, i, genderColumn)#_">
		</cfif>
		<cfif #SpreadsheetGetCellValue(timeSheet, i, classColumn)# EQ "Junior">
			<cfset category="#category#JR_">
		</cfif>
		<cfset category="#category##GetToken(SpreadsheetGetCellValue(timeSheet, i, agColumn), 1, ":")#">
	</cfif>
	<cfset thisRacerLicenseNo="#SpreadsheetGetCellValue(timeSheet, i, licenseColumn)#">
	<cfset thisRacerMiddleInitial="#SpreadsheetGetCellValue(timeSheet, i, initialColumn)#">
	<cfset racenumber=val(#SpreadsheetGetCellValue(timeSheet, i, bibNoColumn)#)>

	<!--- GET THE RACER IF THEY EXIST --->
	<cfquery name="getRacer" datasource="#dsn#">
		SELECT entrantID, name, licenseNo, city, state, middleInitial FROM entrants
			WHERE ltrim(rtrim(lcase(name))) = '#lcase(trim(newRacerName))#'
			AND ((isnull(licenseNo) AND '#trim(thisRacerLicenseNo)#' = '') OR trim(licenseNo) = '#trim(thisRacerLicenseNo)#')
			AND ((isnull(middleInitial) AND '#trim(thisRacerMiddleInitial)#' = '') OR trim(middleInitial) = '#trim(thisRacerMiddleInitial)#')
	</cfquery>


	<!--- Racer doesn't exist, create them as a new entrant --->
	<cfif NOT getRacer.recordcount>
		<cfset thisEntrantName=newRacerName>
		<cfif cityColumn NEQ 0>
			<cfset thisRacerCity="#SpreadsheetGetCellValue(timeSheet, i, cityColumn)#">
			<cfset thisRacerState="#SpreadsheetGetCellValue(timeSheet, i, stateColumn)#">
		<cfelse>
			<cfset thisRacerCity="">
			<cfset thisRacerState="">
		</cfif>
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
		<cfif #SpreadsheetGetCellValue(timeSheet, i, licenseColumn)# EQ "">
			<cfset thisRacerLicenseNo=getRacer.licenseNo>
		<cfelse>
			<cfset thisRacerLicenseNo=#SpreadsheetGetCellValue(timeSheet, i, licenseColumn)#>
		</cfif>
		<cfif cityColumn NEQ 0>
			<cfif #SpreadsheetGetCellValue(timeSheet, i, cityColumn)# EQ "">
				<cfset thisRacerCity=getRacer.city>
				<cfset thisRacerState=getRacer.state>
			<cfelse>
				<cfset thisRacerCity=#SpreadsheetGetCellValue(timeSheet, i, cityColumn)#>
				<cfset thisRacerState=#SpreadsheetGetCellValue(timeSheet, i, stateColumn)#>
				<cfquery name="updateCity" datasource="#dsn#"><!--- update the city for this entrant --->
					UPDATE entrants
					SET city = '#thisRacerCity#', state = '#thisRacerState#'
					WHERE entrantID = #getRacer.entrantID#
				</cfquery>
			</cfif>
		<cfelse>
			<cfset thisRacerCity="">
			<cfset thisRacerState="">
		</cfif>
	</cfif>

	<cfquery name="getcategory" datasource="#dsn#">SELECT categoryID FROM categories WHERE name = '#category#' AND eventID = val(#url.eventID#)</cfquery>

	<!--- GET THE RACER's ENTRY IN THIS EVENT, IF REGISTERED --->
	<cfquery name="findRacer" datasource="#dsn#">
		SELECT entryID from entries
		WHERE entries.eventID = #url.eventID#
		AND entries.racenumber = #racenumber#
	</cfquery>


	<cfif NOT findRacer.recordcount>
		<!--- CREATE THE NEW EVENT ENTRY FOR THE ENTRANT --->
		<cfif val(url.eventID) AND val(thisEntrantID)>
			<cfquery name="newRaceEntry" datasource="#dsn#"><!--- create a new event entry for this entrant --->
				INSERT INTO entries (eventID, entrantID, categoryID, racenumber, licenseNo, city, state)
				VALUES (#url.eventID#, #thisEntrantID#, #val(getcategory.categoryID)#, #val(racenumber)#, '#thisRacerLicenseNo#', '#thisRacerCity#', '#thisRacerState#')
			</cfquery>
		</cfif>
	</cfif>

	<cfquery name="racer" datasource="#dsn#">
		SELECT entryID from entries
		WHERE entries.eventID = #url.eventID#
		AND entries.racenumber = #racenumber#
	</cfquery>

	<cfif cityColumn NEQ 0>
		<cfset col = stateColumn + 1>
	<cfelse>
		<cfset col = licenseColumn + 1>
	</cfif>
	<cfloop condition="#SpreadsheetGetCellValue(timeSheet, i, col)# NEQ ''">
		<cfset racerEntryID = racer.entryID>
		<cfset resultMs = SpreadsheetGetCellValue(timeSheet, i, col + 3)>
		<cfset resultFinishTime = SpreadsheetGetCellValue(timeSheet, i, col + 2)>
		<cfset thisResultType = SpreadsheetGetCellValue(timeSheet, i, col + 1)>
		<cfset resultStageNumber = SpreadsheetGetCellValue(timeSheet, i, col)>

		<!--- Filter out duplicate results --->
		<cfquery name="findResult" datasource="#dsn#">
			SELECT * from results
			WHERE results.entryID = #racerEntryID#
			AND results.resultType = '#thisResultType#'
			AND results.stageNumber = #resultStageNumber#
			AND results.unknownVal = false
		</cfquery>

		<cfset addRecord = true>
		<cfif findResult.recordcount>
			<cfif findResult.finishTime NEQ resultFinishTime OR findResult.ms NEQ resultMs>
				<cfquery name="oldResult" datasource="#dsn#">
					UPDATE results
					set unknownVal = true
					WHERE results.resultID = #findResult.resultID#
				</cfquery>
			<cfelse>
				<cfset addRecord = false>
			</cfif>
		</cfif>
		<cfif addRecord>
			<cfquery name="newResult" datasource="#dsn#">
				INSERT INTO results (entryID, finishTime, ms, unknownVal, resultType, stageNumber)
				VALUES (#racerEntryID#, #resultFinishTime#, #resultMs#, 0, '#thisResultType#', #resultStageNumber#)
			</cfquery>
		</cfif>

		<cfset col = col + 4>
	</cfloop>

	<cfset i = i + 1>	
</cfloop>

<cfscript>
	FileDelete(#fullPath#);
</cfscript>

<!--- xmlhttp.responseText --->
<!--- <cfoutput>#fullPath#: Cell 1,1: #SpreadsheetGetCellValue(timeSheet, 1, 1)#</cfoutput> --->

<cflocation url="index.cfm?eventID=#val(url.eventID)#&eventDate=#url.eventDate#&showEventTools=#url.showEventTools#">
