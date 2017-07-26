<!--- Copyright 2013 Michael J. Bernadett.  Do not use, modify or disseminate without permission. --->
<cfparam name="url.entrantID" default="0">
<cfparam name="url.entryID" default="0">
<cfparam name="url.licenseNo" default="">

<cfquery name="changeEntrantLicenseNo" datasource="#dsn#">
	UPDATE entrants
	SET licenseNo = '#url.licenseNo#'
	WHERE entrantID = #url.entrantID#
</cfquery>
<cfquery name="changeEntryLicenseNo" datasource="#dsn#">
	UPDATE entries
	SET licenseNo = '#url.licenseNo#'
	WHERE entryID = #url.entryID#
</cfquery>

