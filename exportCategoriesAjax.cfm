<!--- Copyright 2014 Michael J. Bernadett.  Do not use, modify or distribute without permission. --->
<cfparam name="url.eventID" default="0">
<cfparam name="url.filename" default="categories.xls">

<cfquery name="event" datasource="#dsn#">SELECT * FROM events WHERE eventID = #url.eventID#</cfquery>
<cfquery name="categories" datasource="#dsn#">
	SELECT * FROM categories
	WHERE eventID = #url.eventID#
	ORDER BY catStart, name
</cfquery>

<cfoutput>
<cfset catSheet = SpreadsheetNew()>

<cfscript>
	SpreadsheetAddRow(catSheet, "Race Category,Race Gender,Race Class,Race Age Group,Race Start Offset,Race Laps");
</cfscript>
	
<cfset row = 2>
	
<cfloop query="categories">
	
	<!--- THE CATEGORIES --->
		<cfset racerCategory  = "Open">
		<cfset racerGender = "Both">
		<cfset ageGroup = "">
		<cfif categories.name EQ "OPEN_SINGLE_SPEED">
			<cfset racerClass = "Single Speed">
		<cfelseif categories.name EQ "OPEN_CLYDESDALE">
        		<cfset racerClass = "Clydesdale">
		<cfelseif categories.name EQ "OPEN_FAT_BIKE">
        		<cfset racerClass = "Fat Bike">
		<cfelse>
			<cfset racerClass = "">
			<cfset rawCategory = GetToken(categories.name, 1, "_")>
        		<cfif rawCategory EQ "C1">
			    <cfset racerCategory = "Cat 1">
			<cfelseif rawCategory EQ "C2">
			    <cfset racerCategory = "Cat 2">
			<cfelseif rawCategory EQ "C3">
			    <cfset racerCategory = "Cat 3">
			<cfelse>
			    <cfset racerCategory = rawCategory>
			</cfif>
        		<cfset racerGender = GetToken(categories.name, 2, "_")>
			<cfif racerGender NEQ "M" AND racerGender NEQ "F">
				<cfset racerGender = "Both">
			</cfif>
        		<cfset ageMinIndex = "3">
        		<cfif GetToken(categories.name, 3, "_") EQ "JR">
          			<cfset ageMinIndex = "4">
				<cfset racerClass = "Junior">
			<cfelseif GetToken(categories.name, 2, "_") EQ "JR">
				<cfset racerClass = "Junior">
			</cfif>
			<cfset ageGroup = GetToken(categories.name, ageMinIndex, "_")>
			<cfif racerCategory EQ "OPEN">
				<cfset racerCategory = "Open">
			</cfif>
			<cfif ageGroup EQ "PRO">
				<cfset racerClass = "Pro/Exp">
				<cfset ageGroup = "">
			</cfif>
		</cfif>
				
		<cfset hours = datediff("h", event.start, categories.catStart)>
		<cfset minutes = evaluate(datediff("n", event.start, categories.catStart) - hours*60)>
		<cfset seconds = evaluate(datediff("s", event.start, categories.catStart) - (hours*60*60+minutes*60))>
		<!--- Prepend : to prevent Excel from mangling age group into a date or time-of-day --->
		<cfscript>
			SpreadsheetAddRow(catSheet, "#racerCategory#,#racerGender#,#racerClass#,:#ageGroup#,:#numberformat(hours, '00')#:#numberformat(minutes, '00')#:#numberformat(seconds, '00')#,#categories.laps#", row, 1);
		</cfscript>
		<cfset row = row + 1>
</cfloop>
<cfspreadsheet action="write" filename="#url.filename#" name="catSheet" overwrite=true>
</cfoutput>
