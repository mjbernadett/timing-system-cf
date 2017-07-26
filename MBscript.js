<!--- Copyright 2013 Michael J. Bernadett.  Do not use, modify or distribute without permission. --->
 
function ajaxChangeDiscipline(eventID, discipline) {
	var postURL = "changeEventDiscipline.cfm?eventID="+eventID+"&discipline="+discipline;
	xmlhttp.onreadystatechange = function() {
			if (xmlhttp.readyState==4) {
				/* SUCCESS */
				/* console.log("AjaxChangeDiscipline"); */
				window.location.reload(true);

			}else{}
	}
	xmlhttp.open("POST", postURL, true);
	xmlhttp.setRequestHeader("X-Requested-With", "XMLHttpRequest");  // Tells server that this call is made for ajax purposes.
	xmlhttp.send(null);
	return true;
}

function ajaxChangeStageRole(eventID, stageRole) {
	var postURL = "changeStageRole.cfm?eventID="+eventID+"&stageRole="+stageRole;
	xmlhttp.onreadystatechange = function() {
			if (xmlhttp.readyState==4) {
				/* SUCCESS */
				/* console.log("AjaxChangeStageRole"); */
				window.location.reload(true);
			}else{}
	}
	xmlhttp.open("POST", postURL, true);
	xmlhttp.setRequestHeader("X-Requested-With", "XMLHttpRequest");  // Tells server that this call is made for ajax purposes.
	xmlhttp.send(null);
	return true;
}

function ajaxChangeStageNumber(eventID, stageNumber) {
	var postURL = "changeStageNumber.cfm?eventID="+eventID+"&stageNumber="+stageNumber;
	xmlhttp.onreadystatechange = function() {
			if (xmlhttp.readyState==4) {
				/* SUCCESS */
				/* console.log("AjaxChangeStageNumber"); */
				window.location.reload(true);
			}else{}
	}
	xmlhttp.open("POST", postURL, true);
	xmlhttp.setRequestHeader("X-Requested-With", "XMLHttpRequest");  // Tells server that this call is made for ajax purposes.
	xmlhttp.send(null);
	return true;
}


function catchracersubmit(myfield, e, dec, useAjax, currentDisplayCategoryID, eventDate, showResults, eventID, quickPost)
{
  var key;

if (window.event)
   key = window.event.keyCode;
else if (e)
   key = e.keyCode;
else
   return false;

   // keyCode test - show keycode in this field
   // myfield.value = key;

//  - submit - 61 is 'Next' key
if ((key == 61) || (key == 9)) {
      ajaxLap(useAjax, myfield, currentDisplayCategoryID, eventDate, showResults, eventID, quickPost);
      return false;
  }
else if ((key == 229) || (key == 0)) {  // Hack to break focus in Chrome tablet - press any non-numeric key on keypad
      timerLock=0;
      window.parent.focus();
      return false;
  }

return true;

}


function catchnext(nextfield)
{
var key;

if (window.event)
   key = window.event.keyCode;
else if (e)
   key = e.keyCode;
else
   return false;

//  - submit - 61 is 'Next' key
if ((key == 61) || (key == 13)) {
      nextfield.focus();
      return false;
   }

return true;

}


function setFinishStatus(entryID, finishStatus, srcObj) {
	var prompt1;
	var uRL1;
	var prompt2;
	var uRL2;
	var prompt3;
	var uRL3;
	if (finishStatus == "DNF") {
		prompt1 = "Undo DNF?\nClick Cancel for another choice.";
		uRL1 = "setFinishStatus.cfm?entryID="+entryID+"&finishStatus=";
		pPrompt2 = "Rider is DQ?";
		uRL2 = "setFinishStatus.cfm?entryID="+entryID+"&finishStatus=DQ";
		pPrompt3 = "Rider is DNS?";
		uRL3 = "setFinishStatus.cfm?entryID="+entryID+"&finishStatus=DNS";
	} else if (finishStatus == "DQ") {
		prompt1 = "Undo DQ?\nClick Cancel for another choice.";
		uRL1 = "setFinishStatus.cfm?entryID="+entryID+"&finishStatus=";
		prompt2 = "Rider is DNF?";
		uRL2 = "setFinishStatus.cfm?entryID="+entryID+"&finishStatus=DNF";
		prompt3 = "Rider is DNS?";
		uRL3 = "setFinishStatus.cfm?entryID="+entryID+"&finishStatus=DNS";
	} else {
		prompt1 = "Rider is DNF?\nClick Cancel for another choice.";
		uRL1 = "setFinishStatus.cfm?entryID="+entryID+"&finishStatus=DNF";
		prompt2 = "Rider is DNS?";
		uRL2 = "setFinishStatus.cfm?entryID="+entryID+"&finishStatus=DNS";
		prompt3 = "Rider is DQ?";
		uRL3 = "setFinishStatus.cfm?entryID="+entryID+"&finishStatus=DQ";
	}
	if(confirm(prompt1)){
		xmlhttp.open("POST", uRL1, true);
		xmlhttp.onreadystatechange = function() {
			if (xmlhttp.readyState==4) {
				/* SUCCESS */
				srcObj.style.backgroundColor="orange";
				srcObj.style.color="white";
				srcObj.innerHTML="Updated";
				window.location.reload(true);
			}else{}
		}
		xmlhttp.send(null);
	}else {
		if(confirm(prompt2)){
			xmlhttp.open("POST", uRL2, true);
			xmlhttp.onreadystatechange = function() {
				if (xmlhttp.readyState==4) {
					/* SUCCESS */
					srcObj.style.backgroundColor="orange";
					srcObj.style.color="white";
					srcObj.innerHTML="Updated";
					window.location.reload(true);
				}else{}
			}
			xmlhttp.send(null);
		}else {
			if(confirm(prompt3)){
				xmlhttp.open("POST", uRL3, true);
				xmlhttp.onreadystatechange = function() {
					if (xmlhttp.readyState==4) {
						/* SUCCESS */
						srcObj.style.backgroundColor="orange";
						srcObj.style.color="white";
						srcObj.innerHTML="Updated";
						window.location.reload(true);
					}else{}
				}
				xmlhttp.send(null);
			}
		}
	}
}

function setDNSStatus(entryID, finishStatus, srcObj) {
	var prompt1;
	var uRL1;
	if (finishStatus == "DNS") {
		prompt1 = "Undo DNS?";
		uRL1 = "setFinishStatus.cfm?entryID="+entryID+"&finishStatus=";
	} else {
		prompt1 = "Rider is DNS?";
		uRL1 = "setFinishStatus.cfm?entryID="+entryID+"&finishStatus=DNS";
	}
	if(confirm(prompt1)){
		xmlhttp.open("POST", uRL1, true);
		xmlhttp.onreadystatechange = function() {
			if (xmlhttp.readyState==4) {
				/* SUCCESS */
				srcObj.style.backgroundColor="orange";
				srcObj.style.color="white";
				srcObj.innerHTML="Updated";
				//window.location.reload(true);
			}else{}
		}
		xmlhttp.send(null);
	}
}

/* FUNCTION USED to get rider and team names from keyLog */

function ajaxGetEntryName(eventID, racerNumber){
	var postURL = "getEntryName.cfm?eventID="+eventID+"&racerNumber="+racerNumber;
	xmlhttp.onreadystatechange = function() {
		if (xmlhttp.readyState==4) {
			/* SUCCESS */
			//return new result set
			document.getElementById('statusbar').innerHTML = xmlhttp.responseText;
		}else{}
	}
	xmlhttp.open("POST", postURL, true);
	xmlhttp.setRequestHeader("X-Requested-With", "XMLHttpRequest");  // Tells server that this call is made for ajax purposes.
	xmlhttp.send(null);
}


function ajaxImportNewRacer(eventID, raceNumber, newRacerName, categoryID, teamID) {
	var postURL = "newEntryAjax.cfm?eventID="+eventID+"&newRaceNumber="+raceNumber+"&newRacerName="+newRacerName+"&teamID="+teamID+"&categoryID="+categoryID;
	xmlhttp.onreadystatechange = function() {
			if (xmlhttp.readyState==4) {
				/* SUCCESS */
				console.log("Filename: %s", xmlhttp.responseText);
				console.log("ConsoleLog");
			}else{}
	}
	xmlhttp.open("POST", postURL, true);
	xmlhttp.setRequestHeader("X-Requested-With", "XMLHttpRequest");  // Tells server that this call is made for ajax purposes.
	xmlhttp.send(null);
	return true;
}

function autocompleteFinish (oTextbox, arrValues, licenseSelect, middleInitialSelect, citySelect) {
	if (oTextbox.value != "") {
		var existingNameOnly = false;
		for (var i=0; i < arrValues.length; i++) {
			if (arrValues[i].name.toLowerCase().indexOf(oTextbox.value.toLowerCase()) == 0) {
				oTextbox.value = arrValues[i].name;
				existingNameOnly |= (arrValues[i].licenseNo == "" && arrValues[i].middleInitial == "");

				var option=document.createElement("option");
				option.text = arrValues[i].licenseNo;
				option.value = i;
				licenseSelect.add(option, null);
				option=document.createElement("option");
				option.text = arrValues[i].middleInitial;
				option.value = i;
				middleInitialSelect.add(option, null);
				option=document.createElement("option");

				if (arrValues[i].city.split(",")[0] != "") {
					option.text = arrValues[i].city;
				} else {
					option.text = "";
				}
				option.value = i;
				citySelect.add(option, null);
			}
		}
		oTextbox.size = oTextbox.value.length + 3;

		var option;
		option=document.createElement("option");
		option.text = "";
		option.title = "Add New Entrant.  If no license, add distinct Middle Initial later."
		middleInitialSelect.add(option,null);

		middleInitialSelect.size = Math.min(middleInitialSelect.length, 8);

		option=document.createElement("option");
		option.text = "NEW ENTRANT";
		option.title = "Add New Entrant.  Edit License Number later and blank out if no license."
		licenseSelect.add(option,null);

		licenseSelect.size = Math.min(licenseSelect.length, 8);


		option=document.createElement("option");
		option.text = "";
		citySelect.add(option,null);

		citySelect.size = Math.min(citySelect.length, 8);
	}

	return true;
}


//in server code replace this array with actual values - this is a prototype.
var arrValues = [{name:"aa", licenseNo:"12345", middleInitial:"Q", city:"Newport"}, {name:"bb", licenseNo:"54321", middleInitial:"R", city:"Shreveport"}]; 

function emptySelect(thisSelect) {
	thisSelect.selectedIndex = 0;
	for (var i=thisSelect.length - 1; i >= 0 ; i--) {
		thisSelect.remove(i)
	}
	thisSelect.size = 1;
	return true;
}

function changeRacerLicenseNo(entrantID, entryID, srcObj) {
	if (srcObj.innerHTML != "" && srcObj.innerHTML.split(" ")[0] != "NEW") {
		if (!confirm("EDIT LICENSE NUMBER OF THIS RIDER? OVERWRITES OLD NUMBER."))
			return;
	}
	var licenseNo = prompt("EDIT LICENSE NUMBER", srcObj.innerHTML);
	if (licenseNo != null) {
		var postURL = "changeRacerlicenseNo.cfm?entrantID="+entrantID+"&entryID="+entryID+"&licenseNo="+licenseNo;
		xmlhttp.open("POST", postURL, true);
		xmlhttp.onreadystatechange = function() {
			if (xmlhttp.readyState==4) {
				/* SUCCESS */
				srcObj.innerHTML = licenseNo;
			}
		}
		xmlhttp.send(null);
	}
}

function changeRacerMiddleInitial(entrantID, srcObj) {
	if (srcObj.innerHTML != "" && srcObj.innerHTML.split(" ")[0] != "NEW") {
		if (!confirm("EDIT MIDDLE INITIAL OF THIS RIDER? OVERWRITES OLD MIDDLE INITIAL."))
			return;
	}
	var middleInitial = prompt("EDIT MIDDLE INITIAL", srcObj.innerHTML);
	if (middleInitial != null) {
		var postURL = "changeRacerMIddleInitial.cfm?entrantID="+entrantID+"&middleInitial="+middleInitial;
		xmlhttp.open("POST", postURL, true);
		xmlhttp.onreadystatechange = function() {
			if (xmlhttp.readyState==4) {
				/* SUCCESS */
				srcObj.innerHTML = middleInitial;
			}
		}
		xmlhttp.send(null);
	}
}

function changeRacerCity(entrantID, entryID, srcObj) {
	if (srcObj.innerHTML != "") {
		if (!confirm("EDIT CITY OF THIS RIDER? OVERWRITES OLD CITY."))
			return;
	}
	var cityState = prompt("Enter City, State", srcObj.innerHTML);
	if (cityState != null) {
		var city = cityState.split(",")[0];
		var state = cityState.split(",")[1];
		if (city == null)
			city = "";
		else
			city = city.trim();
		if (state == null)
			state = "";
		else
			state = state.trim();

		var postURL = "changeRacerCity.cfm?entrantID="+entrantID+"&entryID="+entryID+"&city="+city+"&state="+state;
		xmlhttp.open("POST", postURL, true);
		xmlhttp.onreadystatechange = function() {
			if (xmlhttp.readyState==4) {
				/* SUCCESS */
				if (city == "" && state == "")
					srcObj.innerHTML = "";
				else
					srcObj.innerHTML = city+", "+state;
			}
		}
		xmlhttp.send(null);
	}
}

function syncSelectors(srcObj) {
	middleInitialSelect = document.getElementById('middleInitialSelect');
	licenseSelect = document.getElementById('licenseSelect');
	citySelect = document.getElementById('citySelect');
	
	if (srcObj != middleInitialSelect) middleInitialSelect.selectedIndex = srcObj.selectedIndex;
	if (srcObj != licenseSelect) licenseSelect.selectedIndex = srcObj.selectedIndex;
	if (srcObj != citySelect) citySelect.selectedIndex = srcObj.selectedIndex;
}

var toggle = 0;

function toggleDisplayButton(srcObj, hideText, showText, element) {
	if (element.style.display == "none") {
		srcObj.value=hideText;
		element.style.display='table-row';
	}
	else {
		srcObj.value=showText;
		element.style.display='none';
	}
}

function toggleEventToolsButton(eventDate, eventID, showEventTools, srcObj, element) {
	if (showEventTools) {
		srcObj.value="Show Event Tools";
		element.style.display='none';
		window.location.href="index.cfm?eventDate="+eventDate+"&eventID="+eventID+"&showEventTools=0";
	}	
	else {
		srcObj.value="Hide Event Tools";
		element.style.display='table-row';
		window.location.href="index.cfm?eventDate="+eventDate+"&eventID="+eventID+"&showEventTools=1";
	}
}

function addOrDeleteResult(eventID, resultID, srcObj, unknownVal, lapBased) {
	var addPrompt = (unknownVal?"Show Time?":"Add Missing "+(lapBased?"Lap?":"Stage?")+"\nClick Cancel for more choices.");
	if(confirm(addPrompt)){
		var postURL = "unknownResult.cfm?resultID="+resultID;
		xmlhttp.open("POST", postURL, true);
		xmlhttp.onreadystatechange = function() {
			if (xmlhttp.readyState==4) {
				/* SUCCESS */
				srcObj.style.backgroundColor="orange";
				srcObj.style.color="white";
				srcObj.innerHTML="Updated";
				/* window.location.reload(true); - reloading right away can be confusing - wait for an update*/
			}else{}
		}
		xmlhttp.send(null);
	}else if(confirm("DELETE THIS RESULT?\nClick Cancel for another choice.")){
		var postURL = "deleteResult.cfm?resultID="+resultID;
		xmlhttp.open("POST", postURL, true);
		xmlhttp.onreadystatechange = function() {
			if (xmlhttp.readyState==4) {
				/* SUCCESS */
				srcObj.style.backgroundColor=redHighlight;
				srcObj.style.color="black";
				srcObj.innerHTML="X";
			}else{}
		}
		xmlhttp.send(null);
	}else if(confirm("REASSIGN THIS RESULT?")){
		var riderNumber = prompt("Enter New Rider Number");
		var postURL = "reassignResult.cfm?eventID="+eventID+"&resultID="+resultID+"&riderNumber="+riderNumber;
		xmlhttp.open("POST", postURL, true);
		xmlhttp.onreadystatechange = function() {
			if (xmlhttp.readyState==4) {
				/* SUCCESS */
				srcObj.style.backgroundColor=orange;
				srcObj.style.color="white";
				srcObj.innerHTML="Updated";
			}else{}
		}
		xmlhttp.send(null);
	}
}

function setIgnoreStage(eventID, startResultID, finishResultID, srcObj, ignore) {
	var deletePrompt = (ignore?"IGNORE ":"UNIGNORE ")+"THIS "+((startResultID == 0 || finishResultID == 0)?"TIME":"STAGE")+"?";
	var postURL;
	if(ignore && confirm("REASSIGN THIS RESULT?\nClick Cancel for another choice")){
		var riderNumber = prompt("Enter New Rider Number");
		var resultID = (finishResultID == 0?startResultID:finishResultID);
		postURL = "reassignResult.cfm?eventID="+eventID+"&resultID="+resultID+"&riderNumber="+riderNumber;
		ignore = false;
	}else if(confirm(deletePrompt)){
		postURL = "setIgnoreStage.cfm?startResultID="+startResultID+"&finishResultID="+finishResultID+"&ignore="+(ignore?"1":"0");
	}else{
		postURL = "";
	}

	if(postURL != ""){
		xmlhttp.open("POST", postURL, true);
		xmlhttp.onreadystatechange = function() {
			if (xmlhttp.readyState==4) {
				/* SUCCESS */
				if (ignore) {
					srcObj.style.backgroundColor=redHighlight;
					srcObj.style.color="black";
					srcObj.innerHTML="X";
				}
				else {
					srcObj.style.backgroundColor="orange";
					srcObj.style.color="white";
					srcObj.innerHTML="Updated";
				}
			}else{}
		}
		xmlhttp.send(null);
	}
}

function ajaxPost(postURL, refreshWhenDone) {
	xmlhttp.onreadystatechange = function() {
			if (xmlhttp.readyState==4) {
				/* SUCCESS */
				/* console.log("AjaxPost"); */
				if (refreshWhenDone) {
					window.location.reload(true);
				}
			}else{}
	}
	xmlhttp.open("POST", postURL, true);
	xmlhttp.setRequestHeader("X-Requested-With", "XMLHttpRequest");  // Tells server that this call is made for ajax purposes.
	xmlhttp.send(null);
	return true;
}

function ajaxPostDownload(srcObj, postURL, serverFileName, clientFileName) {
	srcObj.innerHTML="Generating "+clientFileName+"...";
	srcObj.style.display="inline-block";
	xmlhttp.onreadystatechange = function() {
		if (xmlhttp.readyState==4) {
			/* SUCCESS */
			/* console.log("AjaxPost"); */
			srcObj.innerHTML="<a href='"+serverFileName+"' download='"+clientFileName+"' onclick='window.location.reload(true);'>Save "+clientFileName+"</a>";
		}else{}
	}
	xmlhttp.open("POST", postURL, true);
	xmlhttp.setRequestHeader("X-Requested-With", "XMLHttpRequest");  // Tells server that this call is made for ajax purposes.
	xmlhttp.send(null);
	return true;
}
