<!--- Copyright 2013 Michael J. Bernadett.  Do not use, modify or distribute without permission. --->
<cfparam name="url.eventID" default="0">
<cfparam name="url.categoryID" default="0">
<cfparam name="url.showMS" default="0">
<cfparam name="url.showCities" default="1">
<cfparam name="url.showHomeButton" default="0">

<cfset headerColor='CBE5FF'>
<cfset lightHighlight='66bbcc'>
<cfset darkHighlight='E62E00'>
<cfset charcoal='404040'>

<body style="background-color:#F6F6F6;">

<style type="text/css">
	@media print {
		.nonprint {display:none;}
	}
	@media screen {
/* button 
---------------------------------------------- */
.button {
	display: inline-block;
	zoom: 1; /* zoom and *display = ie7 hack for display:inline-block */
	*display: inline;
	vertical-align: baseline;
	margin: 0 2px;
	outline: none;
	cursor: pointer;
	text-align: center;
	text-decoration: none;
	font: 14px/100% Arial, Helvetica, sans-serif;
	padding: .5em 2em .55em;
	text-shadow: 0 1px 1px rgba(0,0,0,.3);
	-webkit-border-radius: .5em; 
	-moz-border-radius: .5em;
	border-radius: .5em;
	box-shadow: 1px 2px 2px gray; 
	-webkit-box-shadow: 1px 2px 2px gray;
	-moz-box-shadow: 1px 2px 2px gray;
}
.button:hover {
	text-decoration: none;
}
.button:active {
	position: relative;
	top: 1px;
}

.bigrounded {
	-webkit-border-radius: 2em;
	-moz-border-radius: 2em;
	border-radius: 2em;
}

.medrounded {
	font-size: 12px;
	padding: .34em .75em .36em;
	-webkit-border-radius: 1em;
	-moz-border-radius: 1em;
	border-radius: 1em;
}

.smallrounded {
	font-size: 12px;
	padding: .15em .70em .15em;
	-webkit-border-radius: 1em;
	-moz-border-radius: 1em;
	border-radius: 1em;
}

/* medblue */
.medblue {
	color: white;
	border: none;
	background: #9DCEFF;
	background: -webkit-gradient(linear, left top, left bottom, from(#9DCEFF), to(#5CADFF));
	background: -moz-linear-gradient(top,  #9DCEFF,  #5CADFF);
	filter:  progid:DXImageTransform.Microsoft.gradient(startColorstr='#9DCEFF', endColorstr='#5CADFF');
}
.medblue:hover {
	background: #539CE6;
	background: -webkit-gradient(linear, left top, left bottom, from(#7DBDFF), to(#539CE6));
	background: -moz-linear-gradient(top,  #7DBDFF,  #539CE6);
	filter:  progid:DXImageTransform.Microsoft.gradient(startColorstr='#7DBDFF', endColorstr='#539CE6');
}

/* lightblue */
.lightblue {
	color: #303030;
	border: none;
	margin: 0.2em 0.2em 0.2em 0.2em;
	background: #CBE5FF;
	background: -webkit-gradient(linear, left top, left bottom, from(#CBE5FF), to(#9DCEFF));
	background: -moz-linear-gradient(top,  #CBE5FF,  #9DCEFF);
	filter:  progid:DXImageTransform.Microsoft.gradient(startColorstr='#CBE5FF', endColorstr='#9DCEFF');
}
.lightblue:hover {
	background: #9DCEFF;
	background: -webkit-gradient(linear, left top, left bottom, from(#9DCEFF), to(#7DBDFF));
	background: -moz-linear-gradient(top,  #9DCEFF,  #7DBDFF);
	filter:  progid:DXImageTransform.Microsoft.gradient(startColorstr='#9DCEFF', endColorstr='#7DBDFF');
}


/* orange */
.orange {
	color: white;
	border: none;
	background: #f0b966;
	background: -webkit-gradient(linear, left top, left bottom, from(#f0b966), to(#E68A00));
	background: -moz-linear-gradient(top,  #f0b966,  #E68A00);
	filter:  progid:DXImageTransform.Microsoft.gradient(startColorstr='#f0b966', endColorstr='#E68A00');
}
.orange:hover {
	background: #eba133;
	background: -webkit-gradient(linear, left top, left bottom, from(#eba133), to(#b86e00));
	background: -moz-linear-gradient(top,  #eba133,  #b86e00);
	filter:  progid:DXImageTransform.Microsoft.gradient(startColorstr='#eba133', endColorstr='#b86e00');
}
.orange:active {
	color: white;
	background: -webkit-gradient(linear, left top, left bottom, from(#E68A00), to(#f0b966));
	background: -moz-linear-gradient(top,  #E68A00,  #f0b966);
	filter:  progid:DXImageTransform.Microsoft.gradient(startColorstr='#E68A00', endColorstr='#f0b966');
}

/* white */
.white {
	color: #404040;
	border: none;
	margin: 0.2em 0.2em 0.2em 0.2em;
	background: white;
}

/* lighthighlight */
.lighthighlight {
	color: black;
	border: none;
	background: #FFFFAA;
}
.lighthighlight:hover {
	background: #eba133;
	background: -webkit-gradient(linear, left top, left bottom, from(#eba133), to(#b86e00));
	background: -moz-linear-gradient(top,  #eba133,  #b86e00);
	filter:  progid:DXImageTransform.Microsoft.gradient(startColorstr='#eba133', endColorstr='#b86e00');
}


/* Rounded element */
.rounded {
	border-radius:0.4em;
	outline:none;
	box-shadow: 1px 2px 2px gray; 
}

}
</style>

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
		<!--- AND categories.name <> 'DROP' --->
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
<table border="0" cellpadding="0" cellspacing="3px" bordercolor="gray">
<cfset place = 1>
<cfset podiumcutoff = 3>
<cfset eventDate = #DateFormat(event.eventDate, "m/d/yyyy")#>
<cfset eventDiscipline = #event.discipline#>
<tr style="line-height:1em;padding:5pt;#pagebreak#">
	<th style="line-height:1em;padding:5pt" class="lightblue rounded">Event Date</th>
	<th style="line-height:1em;padding:5pt" class="lightblue rounded">Event Discipline</th>
	<th style="line-height:1em;padding:5pt" class="lightblue rounded">Race Category</th>
	<th style="line-height:1em;padding:5pt" class="lightblue rounded">Race Gender</th>
	<th style="line-height:1em;padding:5pt" class="lightblue rounded">Race Class</th>
	<th style="line-height:1em;padding:5pt" class="lightblue rounded">Race Age Group</th>
	<th style="line-height:1em;padding:5pt" class="lightblue rounded">Rider Place</th>
	<th style="line-height:1em;padding:5pt" class="lightblue rounded">Rider First Name</th>
	<th style="line-height:1em;padding:5pt" class="lightblue rounded">Rider Last Name</th>
	<th style="line-height:1em;padding:5pt" class="lightblue rounded">Rider Bib ##</th>
	<th style="line-height:1em;padding:5pt" class="lightblue rounded">Rider Stages</th>
	<th style="line-height:1em;padding:5pt" class="lightblue rounded">Rider Time</th>
	<th style="line-height:1em;padding:5pt" class="lightblue rounded">Rider License ##</th>
	<cfif #url.showCities# EQ 1>
		<th style="line-height:1em;padding:5pt" class="lightblue rounded">Rider City</th>
		<th style="line-height:1em;padding:5pt" class="lightblue rounded">Rider State</th>
	</cfif>

</tr>
	
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
			<cfset podiumcutoff = 3>
		</cfif>
	</cfif>

	<!--- THE RESULTS --->
	<cfif results.recordcount OR finishStatus NEQ "">
	<tr style="font-size:8pt;" class="white rounded" <cfif place LTE podiumcutoff AND finishStatus EQ "">id="top3"<cfelse>id="nonpodium"</cfif>>
		<td style="line-height:1em;padding:5pt" class="white rounded">#eventDate#</td>
		<td style="line-height:1em;padding:5pt" class="white rounded">#eventDiscipline#</td>
		<cfset racerCategory  = "Open">
		<cfset racerGender = "Both">
		<cfset ageGroup = "">
		<cfif entries.categoryName EQ "OPEN_SINGLE_SPEED">
			<cfset racerClass = "Single Speed">
		<cfelseif entries.categoryName EQ "OPEN_CLYDESDALE">
        		<cfset racerClass = "Clydesdale">
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
				
		<td style="line-height:1em;padding:5pt" class="white rounded">
			<cfif trim(entries.categoryName) EQ ""><span style="color:#darkHighlight#;">Open</span></cfif>#racerCategory#
		</td>
		<td style="line-height:1em;padding:5pt" class="white rounded">#racerGender#</td>
		<td style="line-height:1em;padding:5pt" class="white rounded">#racerClass#</td>
		<cfif ageGroup NEQ "" AND val(GetToken(ageGroup, 1, "-")) LE 12>
			<td style="line-height:1em;padding:5pt" class="white rounded">:#ageGroup#</td>
		<cfelse>
			<td style="line-height:1em;padding:5pt" class="white rounded">#ageGroup#</td>
		</cfif>
		<td
			align="center"
			<cfif place LTE podiumcutoff AND finishStatus EQ "">
				class="medblue rounded" style="font-family:arial black;color:###charcoal#;"
			<cfelse>
				class="white rounded"
			</cfif>>
			<cfif finishStatus EQ "">#place#<cfelse>#finishStatus#</cfif>
		</td>
		<cfset firstName = GetToken(entries.name, 1, " ")>
		<cfset lastName = Mid(entries.name, Len(firstName)+2, 25)>
		<td class="white rounded" <cfif entries.name EQ "no name">style="line-height:1em;padding:5pt;color:silver;"<cfelse>style="line-height:1em;padding:5pt"</cfif>>#firstName#</td>
		<td class="white rounded" nowrap <cfif entries.name EQ "no name">style="line-height:1em;padding:5pt;color:silver;"<cfelse>style="line-height:1em;padding:5pt"</cfif>>#lastName#</td>
		<td class="white rounded" style="text-align:center;line-height:1em;padding:5pt">#entries.racenumber#</td>
		<td class="white rounded" style="text-align:center;line-height:1em;padding:5pt">#entries.stageCount#</td>
		<td class="white rounded" style="text-align:center;line-height:1em;padding:5pt">	
			<cfif NOT isnull(entries.totalTime) AND finishStatus EQ "">
				<!--- Show Total Time, round to nearest hundredth, then to second --->
				<!--- Prepend : to prevent Excel from mangling it into time-of-day  --->
				<cfif entries.ms GE 495>
					<cfset riderTime = DateAdd("s", 1, entries.totalTime)>
				<cfelse>
					<cfset riderTime = entries.totalTime>
				</cfif>
	
				<cfset Fhours = evaluate(timeformat(riderTime, "H"))>
				<cfset Fminutes = evaluate(timeformat(riderTime, "nn"))>
				<cfset Fseconds = evaluate(timeformat(riderTime, "ss"))>
				<cfif val(Fhours)>:#Fhours#</cfif>:#trim(numberformat(Fminutes, "00"))#:#numberformat(Fseconds, "00")#
			</cfif>
		</td>
		<td class="white rounded" style="text-align:center;line-height:1em;padding:5pt">#entries.licenseNo#</td>
		<cfif #url.showCities# EQ 1>
    			<td class="white rounded" style="text-align:center;line-height:1em;padding:5pt">#entries.city#</td>
    			<td class="white rounded" style="text-align:center;line-height:1em;padding:5pt">#entries.state#</td>
		</cfif>
	</tr>
	</cfif>
	<cfset lastCategory = entries.categoryID>
	<cfif finishStatus NEQ "DQ"><cfset place = place + 1></cfif>
</cfloop>
</table>

<div class="orange rounded" align="center"><cfoutput>#event.name#</cfoutput></div>
<cfif url.showHomeButton>
	<input type="Button" class="button medrounded medblue nonprint" style="margin-top:0.3em;margin-bottom:0.35em;" value="Home" title="Click to go back to home page" onclick="window.location.href='index.cfm?eventDate=#eventDate#&eventID=#url.eventID#&showResults=1'">
</cfif>
<input type="Button" class="button medrounded medblue nonprint" style="margin-top:0.3em;margin-bottom:0.35em;" value="Marquee View" title="Click to switch to marquee view" onclick="window.location.href='eventResults.cfm?eventID=#url.eventID#&discipline=#event.discipline#'">
</body>
</cfoutput>
