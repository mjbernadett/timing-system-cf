<!--- Copyright 2014 Michael J. Bernadett.  Do not use, modify or distribute without permission. --->
<cfparam name="url.eventID" default="0">
<cfparam name="url.categoryID" default="0">
<cfparam name="url.eventDate" default="#dateformat(now(), "m/d/yy")#">
<cfparam name="url.showResults" default="0">
<cfparam name="url.showMS" default="1">
<cfparam name="url.showHomeButton" default="0">
<cfparam name="url.print" default="">

<cfset headerColor='B5DAFF'>
<cfset lightHighlight='66bbcc'>
<cfset lighterHighlight='FFE6B2'>
<cfset editColor='FFAD33'>
<cfset darkHighlight='E62E00'>
<cfset blueHighlight='3040b0'>
<cfset charcoal='404040'>

<style type="text/css">
	@media print {
		.nonprint {display:none;}
		td {color:black; border: 1px solid gray; padding: 0.1em 0.2em 0.1em 0.2em;}
		th {color:black; border-top: 3px double gray;border-right: 1px solid gray;border-bottom: 1px solid gray;border-left: 1px solid gray; padding: 0.1em 0.2em 0.1em 0.2em;}
		table {border-collapse:collapse;}
		.medblue {
			color: black;
			background-color: #5CADFF;
		}
		.lightblue {
			color: black;
			background-color: #CBE5FF;
		}
	}
	@media screen {
		th, td {border: none; padding: 0.05em 0.4em 0.05em 0.4em;}
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
	background: #5CADFF;
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
	color: #404040;
	border: none;
	margin: 0.2em 0.2em 0.2em 0.2em;
	background: #CBE5FF;
	background: -webkit-gradient(linear, left top, left bottom, from(#CBE5FF), to(#9DCEFF));
	background: -moz-linear-gradient(top,  #CBE5FF,  #9DCEFF);
	filter:  progid:DXImageTransform.Microsoft.gradient(startColorstr='#CBE5FF', endColorstr='#9DCEFF');
}
.lightblue:hover {
	background: #9DCEFF;
	background: -webkit-gradient(linear, left top, left bottom, from(#9DCEFF), to(#539CFF));
	background: -moz-linear-gradient(top,  #9DCEFF,  #539CFF);
	filter:  progid:DXImageTransform.Microsoft.gradient(startColorstr='#9DCEFF', endColorstr='#539CFF');
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

/* whiteedit */
.whiteedit {
	color: #404040;
	border: none;
	margin: 0.2em 0.2em 0.2em 0.2em;
	background: white;
}
.whiteedit:hover {
	background: #eba133;
	background: -webkit-gradient(linear, left top, left bottom, from(#eba133), to(#b86e00));
	background: -moz-linear-gradient(top,  #eba133,  #b86e00);
	filter:  progid:DXImageTransform.Microsoft.gradient(startColorstr='#eba133', endColorstr='#b86e00');
}

/* lighthighlight */
.lighthighlight {
	color: black;
	border: none;
	background: #FCF5CC;
}
.lighthighlight:hover {
	background: #eba133;
	background: -webkit-gradient(linear, left top, left bottom, from(#eba133), to(#b86e00));
	background: -moz-linear-gradient(top,  #eba133,  #b86e00);
	filter:  progid:DXImageTransform.Microsoft.gradient(startColorstr='#eba133', endColorstr='#b86e00');
}

/* darkhighlight */
.darkhighlight {
	color: black;
	border: none;
	background: #E62E00;
}
.darkhighlight:hover {
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

<body style="background-color:#F6F6F6;">

<cfoutput>

<cfquery name="category" datasource="#dsn#">SELECT * FROM categories WHERE categoryID = #url.categoryID#</cfquery>
<cfquery name="event" datasource="#dsn#">SELECT * FROM events WHERE eventID = #url.eventID#</cfquery>

<cfset timeStamp1 = now()>

<cfquery name="emptyStageTimes" datasource="#dsn#">
	DELETE FROM stageTimes
</cfquery>

<cfquery name="deleteTotalTimes" datasource="#dsn#">
	DELETE FROM totalTimes
</cfquery>

<!--- This single query and the resulting complicated loop/state machine are here for speed optimization.
	Selecting and joining all the relevant records with one query is much more time-efficient than generating
	a series of targeted queries within loops, per-category, per-rider, per-stage.
 
	This compiles the stage times and total times, and puts them in separate temporary tables so they can be
	sorted for both overal and stage ranking and joined with riders for display.  --->

<cfquery name="getEntries" datasource="#dsn#">
	SELECT results.entryID, results.resultID, results.finishTime, results.ms, results.unknownVal, results.resultType, results.stageNumber, entries.categoryID 
	FROM results INNER JOIN entries ON results.entryID = entries.entryID
	WHERE entries.eventID = #url.eventID#
	GROUP BY results.entryID, results.resultID, results.finishTime, results.ms, results.unknownVal, results.resultType, results.stageNumber, entries.categoryID
	ORDER BY results.entryID, results.stageNumber, results.resultType DESC, results.resultID
</cfquery>

<cfset raceStageCount = 1>

<cfset entryID = 0>
<cfset lastEntryID = getEntries.entryID>
<cfset lastCategoryID = getEntries.categoryID>
<cfset totalTime = 0>
<cfset totalMs = 0>
<cfset racerStageCount = 0>
<cfset thisStartTime = 0>
<cfset startMs = 0>
<cfset thisFinishTime = 0>
<cfset finishMs = 0>
<cfset startResultID = 0>
<cfset finishResultID = 0>
<cfset lastStageNumber = 1>

<cfloop query="getEntries">

	<cfset entryID = getEntries.entryID>
	<cfset categoryID = getEntries.categoryID>
	<cfset stageNumber = getEntries.stageNumber>

	<cfif entryID NEQ lastEntryID>
		<cfif thisStartTime NEQ 0 AND thisFinishTime NEQ 0>

			<!-- Milliseconds get truncated from times when stored in database, so a single datediff for seconds works -->
			<cfset stageSeconds = datediff("s", thisStartTime, thisFinishTime)>
			<cfset addMs = (finishMs - startMs)>
			<cfif addMs LT 0><cfset stageSeconds = stageSeconds - 1><cfset addMs = addMs + 1000></cfif>
			<cfset totalTime = DateAdd("s", stageSeconds, totalTime)>
			<cfset totalMs = totalMs + addMs>
			<cfquery name="insertStage" datasource="#dsn#">
				INSERT INTO stageTimes (entryID, categoryID, stageNumber, stageTime, startResultID, finishResultID)
				VALUES (#lastEntryID#, #lastCategoryID#, #lastStageNumber#, #val(stageSeconds*1000+addMs)#, #startResultID#, #finishResultID#)
			</cfquery>

			<cfset racerStageCount = racerStageCount + 1>
		<cfelseif startResultID OR finishResultID>

			<cfquery datasource="#dsn#">
				INSERT INTO stageTimes (entryID, categoryID, stageNumber, stageTime, startResultID, finishResultID)
				VALUES (#lastEntryID#, #lastCategoryID#, #lastStageNumber#, 0, #startResultID#, #finishResultID#)
			</cfquery>

		</cfif>
		<cfif stageNumber GT 1>
			<cfloop from="1" to="#val(stageNumber - 1)#" index="i">
				<cfquery datasource="#dsn#">
					INSERT INTO stageTimes (entryID, categoryID, stageNumber, stageTime, startResultID, finishResultID)
					VALUES (#entryID#, #categoryID#, #i#, 0, 0, 0)
				</cfquery>
			</cfloop>
		</cfif>
		<cfif (totalTime NEQ 0) OR (totalMs NEQ 0)>
			<cfset addSecs = fix(totalMs / 1000)>
			<cfset addMs = totalMs mod 1000>
			<cfif addMs LT 0><cfset addSecs = addSecs - 1><cfset addMs = addMs + 1000></cfif>
			<cfset totalTime = DateAdd("s", addSecs, totalTime)>
			<cfquery name="insertTotal" datasource="#dsn#">
				INSERT INTO totalTimes (entryID, stageCount, totalTime, ms )
				VALUES (#lastEntryID#, #racerStageCount#, #totalTime#, #addMs#)
			</cfquery>
			<cfset totalTime = 0>
			<cfset totalMs = 0>
		</cfif>

		<cfset thisStartTime = 0>
		<cfset thisFinishTime = 0>
		<cfset startResultID = 0>
		<cfset finishResultID = 0>
		<cfset racerStageCount = 0>
		<cfset lastCategoryID = categoryID>

	<cfelseif stageNumber NEQ lastStageNumber>
		<cfif thisStartTime NEQ 0 AND thisFinishTime NEQ 0>

			<!-- Milliseconds get truncated from times when stored in database, so a single datediff for seconds works -->
			<cfset stageSeconds = datediff("s", thisStartTime, thisFinishTime)>
			<cfset addMs = (finishMs - startMs)>
			<cfif addMs LT 0><cfset stageSeconds = stageSeconds - 1><cfset addMs = addMs + 1000></cfif>
			<cfset totalTime = DateAdd("s", stageSeconds, totalTime)>
			<cfset totalMs = totalMs + addMs>
			<cfquery name="insertStage" datasource="#dsn#">
				INSERT INTO stageTimes (entryID, categoryID, stageNumber, stageTime, startResultID, finishResultID)
				VALUES (#lastEntryID#, #lastCategoryID#, #lastStageNumber#, #val(stageSeconds*1000+addMs)#, #startResultID#, #finishResultID#)
			</cfquery>

			<cfset racerStageCount = racerStageCount + 1>

		<cfelseif startResultID OR finishResultID>

			<cfquery datasource="#dsn#">
				INSERT INTO stageTimes (entryID, categoryID, stageNumber, stageTime, startResultID, finishResultID)
				VALUES (#lastEntryID#, #lastCategoryID#, #lastStageNumber#, 0, #startResultID#, #finishResultID#)
			</cfquery>
		</cfif>
	
		<cfif stageNumber GT lastStageNumber + 1>
			<cfloop from="#val(lastStageNumber + 1)#" to="#val(stageNumber - 1)#" index="i">
				<cfquery datasource="#dsn#">
					INSERT INTO stageTimes (entryID, categoryID, stageNumber, stageTime, startResultID, finishResultID)
					VALUES (#entryID#, #categoryID#, #i#, 0, 0, 0)
				</cfquery>
			</cfloop>
		</cfif>
		<cfset startResultID = 0>
		<cfset finishResultID = 0>
		<cfset thisStartTime = 0>
		<cfset thisFinishTime = 0>
		<cfset lastStageNumber = stageNumber>
	</cfif>
			

	<cfif getEntries.resultType EQ 'Start'>

		<cfset startResultID = getEntries.resultID>

		<cfif NOT getEntries.unknownVal>

			<cfset thisStartTime = getEntries.finishTime>
			<cfset startMs = getEntries.ms>
		</cfif>

	<cfelseif getEntries.resultType EQ 'Finish'>

		<cfset finishResultID = getEntries.resultID>

		<cfif NOT getEntries.unknownVal>

			<cfset thisFinishTime = getEntries.finishTime>
			<cfset finishMs = getEntries.ms>

		</cfif>
	</cfif>
	<cfset lastEntryID = entryID>
	<cfset lastStageNumber = stageNumber>

	<cfif stageNumber GT raceStageCount><cfset raceStageCount = stageNumber></cfif>
</cfloop>

<cfif stageNumber EQ lastStageNumber>
		<cfif thisStartTime NEQ 0 AND thisFinishTime NEQ 0>

			<!-- Milliseconds get truncated from times when stored in database, so a single datediff for seconds works -->
			<cfset stageSeconds = datediff("s", thisStartTime, thisFinishTime)>
			<cfset addMs = (finishMs - startMs)>
			<cfif addMs LT 0><cfset stageSeconds = stageSeconds - 1><cfset addMs = addMs + 1000></cfif>
			<cfset totalTime = DateAdd("s", stageSeconds, totalTime)>
			<cfset totalMs = totalMs + addMs>
			<cfquery name="insertStage" datasource="#dsn#">
				INSERT INTO stageTimes (entryID, categoryID, stageNumber, stageTime, startResultID, finishResultID)
				VALUES (#lastEntryID#, #lastCategoryID#, #lastStageNumber#, #val(stageSeconds*1000+addMs)#, #startResultID#, #finishResultID#)
			</cfquery>

			<cfset racerStageCount = racerStageCount + 1>

		<cfelseif startResultID OR finishResultID>

			<cfquery datasource="#dsn#">
				INSERT INTO stageTimes (entryID, categoryID, stageNumber, stageTime, startResultID, finishResultID)
				VALUES (#lastEntryID#, #lastCategoryID#, #lastStageNumber#, 0, #startResultID#, #finishResultID#)
			</cfquery>
		</cfif>
</cfif>


<cfif (entryID EQ lastEntryID) AND ((totalTime NEQ 0) OR (totalMs NEQ 0))>
	<cfset addSecs = fix(totalMs / 1000)>
	<cfset addMs = totalMs mod 1000>
	<cfif addMs LT 0><cfset addSecs = addSecs - 1><cfset addMs = addMs + 1000></cfif>
	<cfset totalTime = DateAdd("s", addSecs, totalTime)>
	<cfquery name="insertTotal2" datasource="#dsn#">
		INSERT INTO totalTimes (entryID, stageCount, totalTime, ms )
		VALUES (#entryID#, #racerStageCount#, #totalTime#, #addMs#)
	</cfquery>
</cfif>

<cfloop from = "1" to = "#raceStageCount#" index = "stage">
	<cfquery name="getCategories" datasource="#dsn#">
		SELECT categories.categoryID
		FROM categories WHERE categories.eventID = #url.eventID#
	</cfquery>
	<cfloop query="getCategories">
		<cfquery name="getStageWins" datasource="#dsn#">
			SELECT TOP 3 *
			FROM stageTimes
			WHERE stageTimes.categoryID = #getCategories.categoryID#
			AND stageTimes.stageNumber = #stage#
			AND stageTimes.stageTime > 0
			ORDER BY stageTimes.stageTime
		</cfquery>
		<cfset stagePlace = 1>
		<cfloop query = "getStageWins">
			<cfquery name="markStageWins" datasource="#dsn#">
				UPDATE stageTimes
				set stageTimes.rank = #stagePlace#
				WHERE stageTimes.stageID = #getStageWins.stageID#
			</cfquery>
			<cfset stagePlace = stagePlace + 1>
		</cfloop>
	</cfloop>
</cfloop>
		

<!--- <cfset raceStageCount = 5> --->
		
<cfquery name="entries" datasource="#dsn#">
	SELECT
		entries.racenumber,
		entrants.name,
		entrants.entrantID,
		entries.entryID,
		entries.categoryID,
		entries.finishStatus,
		categories.name AS categoryName,
		totalTimes.stageCount AS stageCount,
		totalTimes.totalTime,
		totalTimes.ms
	FROM
		((entries LEFT JOIN totalTimes ON totalTimes.entryID = entries.entryID)
		LEFT JOIN categories ON categories.categoryID = entries.categoryID)
		INNER JOIN entrants ON entrants.entrantID = entries.entrantID
		WHERE entries.eventID = #url.eventID#
		<cfif val(url.categoryID)>
			AND entries.categoryID = #url.categoryID#
		</cfif>
	GROUP BY
		entries.racenumber,
		entrants.name,
		entrants.entrantID,
		entries.entryID,
		entries.categoryID,
		entries.finishStatus,
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

<cfset eventDate = #DateFormat(event.eventDate, "m/d/yyyy")#>

<cfif #url.showHomeButton#>
	<input type="Button" class="button medrounded medblue nonprint" style="margin-top:0.3em;" value="Home" title="Click to go back to home page" onclick="window.location.href='index.cfm?eventDate=#eventDate#&eventID=#url.eventID#&showResults=1'">
</cfif>

<cfif url.print EQ "">
	<input
		type="Button"
		value="Print Preliminary Results"
		class="button medrounded orange nonprint"
		style="margin-top:0.3em;"
		onclick="urlPushElement('print=prelim');">

	<input
		type="Button"
		value="Print Results for Protest"
		class="button medrounded orange nonprint"
		style="margin-top:0.3em;"
		onclick="urlPushElement('print=protest');">

	<input
		type="Button"
		value="Print Final Results for Podium"
		class="button medrounded orange nonprint"
		style="margin-top:0.3em;"
		onclick="urlPushElement('print=final');">

	<cfif NOT url.autoRefresh>
		<cfset resultsFile = "resultsfiles/UsacResults#Session.CFID#.xls">
		<cfset clientFileName = "#event.name# USAC Results">
		<input type="Button" class="button medrounded medblue nonprint" style="margin-top:0.3em;" value="Export USAC Results" onclick="ajaxPostDownload(document.getElementById('download5'), 'stageUsacResultsAjax.cfm?eventID=#event.eventID#&filename=#resultsFile#', '#resultsFile#', '#clientFileName#');this.style.display='none';">
		<span class="button medrounded medblue nonprint" id="download5" style="margin-top:0.3em;cursor:arrow;min-height:1em;white-space:nowrap;display:none;"></span>
	</cfif>
</cfif>

<table border="0" outline="0" cellpadding="0px" cellspacing="4px">
<cfset place = 1>
<cfset podiumcutoff = 3>

<cfloop query="entries">
	<!--- Arbitrarily use the event's start time. --->
	<cfset nextCalcTime = event.start>
	<cfset calcStart = nextCalcTime>

	<cfset isDrop = (entries.finishStatus EQ 'DNS')>

	<cfif isDefined("lastCategory")>
		<cfif entries.categoryID NEQ lastCategory>
			<cfset place = 1>
			<cfset newCat = true>
		<cfelse>
			<cfset newCat = false>
		</cfif>
	<cfelse>
		<cfset newCat = true>
	</cfif>

	<cfif newCat>
		<tr style="#pagebreak#" <cfif isDrop>id="drop"</cfif>>
			<th rowspan="2" class="lightblue rounded" >Place</th>
			<th rowspan="2" class="lightblue rounded" style="font-size:8pt;font-family:arial black;" nowrap>
				<cfif trim(entries.categoryName) EQ ""><span style="color:#darkHighlight#;">open</span></cfif>#entries.categoryName#
			</th>
			<th rowspan="2" class="lightblue rounded">##</th>
			<th colspan="#raceStageCount#" nowrap class="lightblue rounded">Stage Times</th>
			<th rowspan="2" nowrap valign="top" class="medblue rounded">Total <span style="color:###blueHighlight#;font-family:courier new;font-size:8pt;">(avg)</span></th>
		</tr>
		<tr style="font-size:8pt;font-weight:bold;font-family:lucida console;" <cfif isDrop>id="drop"</cfif>>
		<cfloop from="1" to="#raceStageCount#" index="i"><td class="lightblue rounded" align="center">#i#</td></cfloop>
		</tr>
	</cfif>

	<!--- Calculate the results --->
	<tr style="background-color:white;font-size:8pt;" <cfif isDrop>id="drop"<cfelseif place LTE podiumcutoff AND entries.finishStatus EQ "">id="top3"<cfelse>id="nonpodium"</cfif>>
		<td
			align="center"
			<cfif place LTE podiumcutoff AND entries.finishStatus EQ "">class="medblue rounded" style="font-family:arial black;color:#charcoal#"<cfelse>class="rounded"</cfif>><cfif entries.finishStatus EQ "DQ">X<cfelse>#place#</cfif></td>
		<td style="cursor:hand;font-family:arial black;font-size:8pt;"
			class="whiteedit rounded"
			nowrap
			onmousedown="timerLock=0;"
			<cfif entries.name EQ "no name">style="color:silver;"</cfif>
			title="Edit rider name"
			onclick="changeRacerName(#entries.entrantID#, this, '#entries.name#');">
				#entries.name#
			</td>
		<td style="cursor:hand;font-family:arial black;font-size:8pt;"
			align="center"
			class="whiteedit rounded"
			onmousedown="timerLock=0;"
			title="Edit rider number"
			onclick="changeRacerNumber(#entries.entryID#, this);">#entries.racenumber#</td>

		<cfset thisStageNumber = 0>

		<cfquery name="getStageTimes" datasource="#dsn#">
			SELECT *
			FROM stageTimes
			WHERE stageTimes.entryID = #entries.entryID#
			ORDER BY stageTimes.stageNumber
		</cfquery>

		<cfloop query="getStageTimes">
		
			<cfset thisStageNumber = getStageTimes.stageNumber>

			<cfif getStageTimes.stageTime>
				<!--- Display Segment Time --->
					
				<cfset stageTime = getStageTimes.stageTime>
				<cfset hours = fix(stageTime / 3600000)>
				<cfset remainder = stageTime - hours * 3600000>
				<cfset minutes = fix(remainder / 60000)>
				<cfset remainder = remainder - minutes * 60000>
				<cfset straightSeconds = fix(stageTime / 1000)>
				<cfset seconds = fix(remainder / 1000)>
				<cfset straightminutes = fix(stageTime / 60000)>
				<cfset addMs = remainder - seconds * 1000>
				<cfset stageRank = val(getStageTimes.rank)>
				<td
					nowrap
					onclick="setIgnoreStage(#event.eventID#, #getStageTimes.startResultID#, #getStageTimes.finishResultID#, this, true);"
		
					title="Reassign or Ignore Stage"
					class="whiteedit rounded"
					<cfif stageRank EQ 1>
						style="text-align:center;cursor:hand;font-family:arial narrow;line-height:1em;font-size:8pt;color:blue;font-weight:bold;"
					<cfelseif stageRank EQ 2>
						style="text-align:center;cursor:hand;font-family:arial narrow;line-height:1em;font-size:8pt;color:green;font-weight:bold;"
					<cfelseif stageRank EQ 3>
						style="text-align:center;cursor:hand;font-family:arial narrow;line-height:1em;font-size:8pt;color:purple;font-weight:bold;"
					<cfelse>
						style="text-align:center;cursor:hand;font-family:arial narrow;line-height:1em;font-size:8pt;color:black;font-weight:bold;"
					</cfif>
					valign="middle">

					<!--- Show Stage Time --->
					<cfif val(hours)>#hours#</cfif>:#numberformat(minutes, "00")#:#numberformat(seconds, "00")#<cfif url.showMS>.#numberformat(addMs, "000")#</cfif><cfif stageRank> #stageRank#</cfif>
				</td>

			<cfelse>
				<cfquery name="finishResults" datasource="#dsn#">
					SELECT *
					FROM results
					WHERE results.resultID = #getStageTimes.finishResultID#
				</cfquery>
	
				<cfquery name="startResults" datasource="#dsn#">
					SELECT *
					FROM results
					WHERE results.resultID = #getStageTimes.startResultID#
				</cfquery>

				<cfif startResults.recordCount AND finishResults.recordCount>
					<cfif finishResults.unknownVal EQ false>
						<td
							nowrap
							onclick="setIgnoreStage(#event.eventID#, #val(startResults.resultID)#, #val(finishResults.resultID)#, this, false);"
	
							title="Unignore Time"
							class="whiteedit rounded"
							style="text-align:center;cursor:hand;font-family:arial narrow;line-height:1em;font-size:8pt;font-weight:bold;color:black;"
							valign="middle">
							I - #timeformat(finishResults.finishTime, "hh:nn:ss tt")#
						</td>
					<cfelseif startResults.unknownVal EQ false>
						<td
							nowrap
							onclick="setIgnoreStage(#event.eventID#, #val(startResults.resultID)#, #val(finishResults.resultID)#, this, false);"
	
							title="Unignore Time"
							class="whiteedit rounded"
							style="text-align:center;cursor:hand;font-family:arial narrow;line-height:1em;font-size:8pt;font-weight:bold;color:black;"
							valign="middle">
							#timeformat(startResults.finishTime, "hh:nn:ss tt")# - I
						</td>
					<cfelse>
						<td
							nowrap
							onclick="setIgnoreStage(#event.eventID#, #val(startResults.resultID)#, #val(finishResults.resultID)#, this, false);"

							title="Unignore Stage"
							class="whiteedit rounded"
							style="text-align:center;cursor:hand;font-family:arial narrow;line-height:1em;font-size:8pt;font-weight:bold;color:black;"
							valign="middle">
							I - I
						</td>
					</cfif>
				<cfelseif startResults.recordcount>
					<cfif startResults.unknownVal EQ false>
						<td
							nowrap
							onclick="setIgnoreStage(#event.eventID#, #val(startResults.resultID)#, #val(finishResults.resultID)#, this, true);"
		
							title="Reassign or Ignore Time"
							class="whiteedit rounded"
							style="text-align:center;cursor:hand;font-family:arial narrow;line-height:1em;font-size:8pt;font-weight:bold;color:black;"
							valign="middle">
							#timeformat(startResults.finishTime, "hh:mm:ss tt")# - x
						</td>
					<cfelse>
						<td
							nowrap
							onclick="setIgnoreStage(#event.eventID#, #val(startResults.resultID)#, #val(finishResults.resultID)#, this, false);"
		
							title="Unignore Time"
							class="whiteedit rounded"
							style="text-align:center;cursor:hand;font-family:arial narrow;line-height:1em;font-size:8pt;font-weight:bold;color:black;"
							valign="middle">
							I - x
						</td>
					</cfif>
				<cfelseif finishResults.recordCount>
					<cfif finishResults.unknownVal EQ false>
						<td
							nowrap
							onclick="setIgnoreStage(#event.eventID#, #val(startResults.resultID)#, #val(finishResults.resultID)#, this, true);"
		
							title="Reassign or Ignore Time"
							class="whiteedit rounded"
							style="text-align:center;cursor:hand;font-family:arial narrow;line-height:1em;font-size:8pt;font-weight:bold;color:black;"
							valign="middle">
							x - #timeformat(finishResults.finishTime, "hh:mm:ss tt")#
						</td>
					<cfelse>
						<td
							nowrap
							onclick="setIgnoreStage(#event.eventID#, #val(startResults.resultID)#, #val(finishResults.resultID)#, this, false);"
		
							title="Unignore Time"
							class="whiteedit rounded"
							style="text-align:center;cursor:hand;font-family:arial narrow;line-height:1em;font-size:8pt;font-weight:bold;color:black;"
							valign="middle">
							x - I
						</td>
					</cfif>
				<cfelse>
					<td 	class="white rounded"
						style="text-align:center;font-family:arial narrow;line-height:1em;font-size:8pt;font-weight:bold;color:black;"
						align="center"> </td>
				</cfif>
			</cfif>
		</cfloop>

		<cfloop from="#val(thisStageNumber + 1)#" to="#raceStageCount#" index="i">
			<td 	class="white rounded"
				style="text-align:center;font-family:arial narrow;line-height:1em;font-size:8pt;font-weight:bold;color:black;"
				align="center"> </td>
		</cfloop>

		<cfif val(entries.totalTime)>
			<cfset cumulativeTime = datediff("s", 0, entries.totalTime)>
		<cfelse>
			<cfset cumulativeTime = 0>
		</cfif>

		<!--- Break into hours, minutes, seconds for our own formatting --->
		<cfset Fhours = fix(cumulativeTime / 3600)>
		<cfset remainder = cumulativeTime - Fhours * 3600>
		<cfset Fminutes = fix(remainder / 60)>
		<cfset Fseconds = remainder - Fminutes * 60>
		<cfset addMS = entries.ms>
		<!--- Calculate Average --->
		<cfset avgLoop = Fhours*60*60 + Fminutes*60 + Fseconds>
		<cfif stageCount GT 0>
			<cfset avgSeconds = (avgLoop/stageCount) + 0.5>
		<cfelse>
			<cfset avgSeconds = 0>
		</cfif>
		<td 	onclick="setFinishStatus(#val(entries.entryID)#, '#entries.finishStatus#',this);"
			class="lightblue rounded"
			style="padding:0px 5px 0px 5px;cursor:hand;font-family:arial narrow;line-height:1em;font-size:8pt;font-weight:bold;" valign="middle" align="center" nowrap
			onmouseover="this.style.backgroundColor='#editColor#';"
			onmouseout="this.style.backgroundColor='#headerColor#';"
			title="Change DNF, DNS or DQ status for this rider">
			<!--- Show Total Time --->
			<cfif val(Fhours)>#Fhours#</cfif>:#trim(numberformat(Fminutes, "00"))#:#numberformat(Fseconds, "00")#<cfif url.showMS>.#numberformat(addMs, "000")#</cfif>
			<span style="color:###blueHighlight#;">(#int(avgSeconds/60)#:#numberformat(avgSeconds mod 60, "00")#)</span>
		</td>
		<cfif entries.finishStatus NEQ "">
			<td class="lightblue rounded" style="text-align:center;font-family:arial narrow;line-height:1em;font-size:8pt;font-weight:bold;">
			#entries.finishStatus#</td>
		</cfif>
	</tr>
	<cfset lastCategory = entries.categoryID>
	<cfif entries.finishStatus NEQ "DQ">
		<cfset place = place + 1>
	</cfif>
</cfloop>

</table>

<cfset timeStamp2 = now()>
<cfset dSeconds = datediff("s", 0, timeStamp2) - datediff("s", 0, timeStamp1)>
<cfset addMs = timeformat(timeStamp2, "l") - timeformat(timeStamp1, "l")>
<cfif addMs LT 0><cfset dSeconds = dSeconds - 1><cfset addMs = addMs + 1000></cfif>

<!---
<div class="nonprint">Display: #dSeconds#.#numberformat(addMs, "000")# Seconds</div>
--->
<br>
<div align="center">Results presented by Youth Bicyclists of Nevada County Foundation</div>

</cfoutput>

</body>
