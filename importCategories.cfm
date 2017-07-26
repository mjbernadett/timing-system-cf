<!--- Copyright 2013 Michael J. Bernadett  Do not use, modify or distribute without permission --->
<cfsetting enablecfoutputonly="Yes">
<cfparam name="url.eventID" default=0>
<cfparam name="url.eventDate" default="">
<cfparam name="url.showEventTools" default="0">

<cffile action="upload"
	destination="resultsfiles\"
	nameConflict="makeunique"
	fileField="form.importCategoriesFile">

<cfset fullPath="#cffile.ServerDirectory#\#cffile.ServerFileName#.#cffile.ServerFileExt#">

<cfquery name="event" datasource="#dsn#">
	SELECT * from events
	WHERE events.eventID = #url.eventID#
</cfquery>

<cfset categoriesSheet = SpreadSheetRead(#fullPath#)>

<!--- process spreadsheet --->
<cfset catColumn=0>
<cfset genderColumn=0>
<cfset classColumn=0>
<cfset agColumn=0>
<cfset startOffsetColumn=0>
<cfset lapsColumn=0>
<cfset col = 1>
<cfloop condition="#SpreadsheetGetCellValue(categoriesSheet, 1, col)# NEQ ''">
	<cfswitch expression = "#SpreadsheetGetCellValue(categoriesSheet, 1, col)#">
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
	<cfcase value = "Race Start Offset|Start Offset" delimiters="|">
		<cfset startOffsetColumn = col>
	</cfcase>
	<cfcase value = "Race Laps|Laps" delimiters="|">
		<cfset lapsColumn = col>
	</cfcase>
	</cfswitch>
	<cfset col = col + 1>
</cfloop>

<cfset i = 2>
<cfloop condition="#SpreadsheetGetCellValue(categoriesSheet, i, catColumn)# NEQ ''">
	<cfif #SpreadsheetGetCellValue(categoriesSheet, i, classColumn)# EQ "Single Speed">
		<cfset category="OPEN_SINGLE_SPEED">
	<cfelseif #SpreadsheetGetCellValue(categoriesSheet, i, classColumn)# EQ "Clydesdale">
		<cfset category="OPEN_CLYDESDALE">
	<cfelseif #SpreadsheetGetCellValue(categoriesSheet, i, classColumn)# EQ "Fat Bike">
		<cfset category="OPEN_FAT_BIKE">
	<cfelseif #SpreadsheetGetCellValue(categoriesSheet, i, classColumn)# EQ "Pro/Exp">
		<cfif #SpreadsheetGetCellValue(categoriesSheet, i, genderColumn)# EQ "F">
			<cfset category="C1_#SpreadsheetGetCellValue(categoriesSheet, i, genderColumn)#_PRO_EXPERT">
		<cfelse>
			<cfset category="C1_#SpreadsheetGetCellValue(categoriesSheet, i, genderColumn)#_PRO">
		</cfif>
	<cfelseif #SpreadsheetGetCellValue(categoriesSheet, i, classColumn)# EQ "" AND #SpreadsheetGetCellValue(categoriesSheet, i, genderColumn)# EQ "">
		<cfset category="#SpreadsheetGetCellValue(categoriesSheet, i, catColumn)#">
	<cfelse>
		<cfif #SpreadsheetGetCellValue(categoriesSheet, i, catColumn)# EQ "Cat 1">
			<cfset category="C1_">
		<cfelseif #SpreadsheetGetCellValue(categoriesSheet, i, catColumn)# EQ "Cat 2">
			<cfset category="C2_">
		<cfelseif #SpreadsheetGetCellValue(categoriesSheet, i, catColumn)# EQ "Cat 3">
			<cfset category="C3_">
		<cfelseif #SpreadsheetGetCellValue(categoriesSheet, i, catColumn)# EQ "Open">
			<cfset category="OPEN_">
		<cfelse>
			<cfset category="_#SpreadsheetGetCellValue(categoriesSheet, i, catColumn)#_">
		</cfif>
		<cfif #SpreadsheetGetCellValue(categoriesSheet, i, genderColumn)# NEQ "Both">
			<cfset category="#category##SpreadsheetGetCellValue(categoriesSheet, i, genderColumn)#_">
		</cfif>
		<cfif #SpreadsheetGetCellValue(categoriesSheet, i, classColumn)# EQ "Junior">
			<cfset category="#category#JR_">
		</cfif>
		<cfset category="#category##GetToken(SpreadsheetGetCellValue(categoriesSheet, i, agColumn), 1, ":")#">
	</cfif>
	<cfset startOffset="#SpreadsheetGetCellValue(categoriesSheet, i, startOffsetColumn)#">
	<cfset thisCatStart=dateadd("s", val(GetToken(startOffset, 3, ":")), dateadd("n", val(GetToken(startOffset, 2, ":")), dateadd("h", val(GetToken(startOffset, 1, ":")), event.start)))>
	<cfset catLaps=#SpreadsheetGetCellValue(categoriesSheet, i, lapsColumn)#>

	<!--- GET THE CATEGORY IF IT EXISTS --->
	<cfquery name="getCategory" datasource="#dsn#">
		SELECT * FROM categories
			WHERE eventID = val(#url.eventID#)
			AND name = '#category#'
	</cfquery>


	<!--- Category doesn't exist, create it --->
	<cfif NOT getCategory.recordcount>
		<cfquery name="newCategory" datasource="#dsn#"><!--- create a new category --->
			INSERT INTO categories(eventID, catStart, name, laps)
			VALUES (#url.eventID#, #thisCatStart#, '#category#', #val(catLaps)#)
		</cfquery>
	<cfelse>
		<cfquery name="updateCatStart" datasource="#dsn#"><!--- update the start time for this category --->
			UPDATE categories
			SET catStart = #thisCatStart#, laps = #val(catLaps)#
			WHERE eventID = val(#url.eventID#)
			AND name = '#category#'
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
