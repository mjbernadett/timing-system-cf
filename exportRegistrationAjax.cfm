<!--- Copyright 2014 Michael J. Bernadett.  Do not use, modify or distribute without permission. --->
<cfparam name="url.eventID" default="0">
<cfparam name="url.categoryID" default="0">
<cfparam name="url.filename" default="registration.xls">
<cfparam name="url.showCities" default="1">


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
		entries.teamID,
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
		entries.teamID,
		categories.name
	ORDER BY
		<cfif NOT url.categoryID>categories.name,</cfif>
		entries.racenumber
</cfquery>

<cfoutput>
<cfset regSheet = SpreadsheetNew()>

<cfset eventDate = #DateFormat(event.eventDate, "m/d/yyyy")#>
<cfscript>
	SpreadsheetAddRow(regSheet, "Event Discipline,Race Category,Race Gender,Race Class,Race Age Group,Rider First Name,Rider Initial,Rider Last Name,Rider Bib ##,Rider License ##,Rider City,Rider State,Rider Team");
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
		<cfquery name="getteam" datasource="#dsn#">
			SELECT * FROM teams WHERE teamID = #entries.teamID#
		</cfquery>
		<cfscript>
			SpreadsheetAddRow(regSheet, "#event.discipline#,#racerCategory#,#racerGender#,#racerClass#,:#ageGroup#,#firstName#,#entries.middleInitial#,#lastName#,#entries.racenumber#,#entries.licenseNo#,#entries.city#,#entries.state#,#getteam.teamName#", row, 1);
		</cfscript>
		<cfset row = row + 1>
	</cfif>
</cfloop>
<cfspreadsheet action="write" filename="#url.filename#" name="regSheet" overwrite=true>
</cfoutput>
