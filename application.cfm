<!--- APPLICATION SETTINGS --->

<cfset dsn = "timingFinish">
<cfapplication NAME="UTS" sessionmanagement="Yes" clientmanagement="Yes" clientStorage="#dsn#">
<cfset defaultDiscipline = "XC">
<cfif defaultDiscipline EQ "ED">
	<cfset initialStageNumber = 1>
<cfelse>
	<cfset initialStageNumber = 0>
</cfif>
<cfset unknownRacenumberHead = 9000>
<cfset hotlap = 75>
<cfset podiumcutoff = 3>
<cfset defaultEventStart = "9:00:00 AM">
<cfset quickpost = 1>
<cfif CGI.HTTP_USER_AGENT contains "Windows NT 5.1">
	<cfset clientUsingXP = 1>
<cfelse>
	<cfset clientUsingXP = 0>
</cfif>
<cfparam name="Client.stageRole" default="Start">
<cfparam name="Client.stageNumber" default="1">
<cfparam name="Client.racerNumber" default="1">
<cfset pagebreak = ""><!---page-break-before:always;--->
<cfset localstore = "#getdirectoryfrompath(expandpath("*.*"))#resultsfiles">
<!--- Set to 1 to make teams work as endurance relay teams, 0 for XC points-total teams --->
<cfset relayTeams = 0>
<cfset coedTeams = 1>
<cfset showTeamPoints = 0>
<cfset showSeriesPoints = 1>
<cfset addFieldSizeToPoints = 0>
<cfset teamSize = 5>
<cfset maxOneGender = 5>
<cfset girlsTeamSize = 3>
<cfset cat1Bonus = 0>
<cfset cat2Bonus = 0>

