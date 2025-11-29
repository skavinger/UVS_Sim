extends Node2D

const pathToDownLoadEntry = "res://GameObj/Updater/download_entry.tscn"
const formatEntry = "res://GameObj/Updater/download_spacer.tscn"
const cardRepoBaseURL = "https://raw.githubusercontent.com/skavinger/UVS_Dataset/refs/heads/main/"

var setsToDownLoad = []
var setsToUpdate = []
var databaseUpdate = []

var standardDownloader
var retroDownloader
var legacyDownloader

func _ready() -> void:
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(self._http_request_completed)
	
	var error = http_request.request(cardRepoBaseURL + "setList.json")
	if error != OK:
		push_error("Unable to get set list from repo")

func _http_request_completed(_result, _response_code, _headers, body):
	var setList = JSON.parse_string(body.get_string_from_utf8())
	var updatesRequired = false
	
	var standardUpdate = false
	standardDownloader = preload(formatEntry).instantiate()
	$SetModuleList/ScrollContainer/VBoxContainer.add_child(standardDownloader)
	standardDownloader.setName("Standard")
	for i in range(setList.standardSets.size()):
		var entry = preload(pathToDownLoadEntry).instantiate()
		$SetModuleList/ScrollContainer/VBoxContainer.add_child(entry)
		entry.setName(setList.standardSets[i].DisplayName)
		entry.setID = setList.standardSets[i].setID
		standardDownloader.formatSets.push_back(entry)
		
		var setVersion = FileAccess.get_file_as_string("user://SetData/" + setList.standardSets[i].setID + "/version.json")
		if setVersion == "":
			entry.setStatus("red")
			entry.status = "download"
			updatesRequired = true
			standardUpdate = true
		else:
			setVersion = JSON.parse_string(setVersion)
			if setList.standardSets[i].Image_Version == setVersion.Image_Version and setList.standardSets[i].Data_Version == setVersion.Data_Version:
				entry.setStatus("green")
				entry.status = "ready"
			else:
				if setList.standardSets[i].Image_Version != setVersion.Image_Version:
					entry.imageMissmatch = true
				if setList.standardSets[i].Data_Version != setVersion.Data_Version:
					entry.dataMissmatch = true
				entry.setStatus("yellow")
				entry.status = "update"
				updatesRequired = true
				standardUpdate = true
	if !standardUpdate:
		standardDownloader.disableButton()
	
	var retroUpdate = false
	retroDownloader = preload(formatEntry).instantiate()
	$SetModuleList/ScrollContainer/VBoxContainer.add_child(retroDownloader)
	retroDownloader.setName("Retro")
	for i in range(setList.retroSets.size()):
		var entry = preload(pathToDownLoadEntry).instantiate()
		$SetModuleList/ScrollContainer/VBoxContainer.add_child(entry)
		entry.setName(setList.retroSets[i].DisplayName)
		entry.setID = setList.retroSets[i].setID
		retroDownloader.formatSets.push_back(entry)
		
		var setVersion = FileAccess.get_file_as_string("user://SetData/" + setList.retroSets[i].setID + "/version.json")
		if setVersion == "":
			entry.setStatus("red")
			entry.status = "download"
			updatesRequired = true
			retroUpdate = true
		else:
			setVersion = JSON.parse_string(setVersion)
			if setList.retroSets[i].Image_Version == setVersion.Image_Version and setList.retroSets[i].Data_Version == setVersion.Data_Version:
				entry.setStatus("green")
				entry.status = "ready"
			else:
				if setList.retroSets[i].Image_Version != setVersion.Image_Version:
					entry.imageMissmatch = true
				if setList.retroSets[i].Data_Version != setVersion.Data_Version:
					entry.dataMissmatch = true
				entry.setStatus("yellow")
				entry.status = "update"
				updatesRequired = true
				retroUpdate = true
	if !retroUpdate:
		retroDownloader.disableButton()
	
	var legacyUpdate = false
	legacyDownloader = preload(formatEntry).instantiate()
	$SetModuleList/ScrollContainer/VBoxContainer.add_child(legacyDownloader)
	legacyDownloader.setName("Legacy")
	for i in range(setList.legacySets.size()):
		var entry = preload(pathToDownLoadEntry).instantiate()
		$SetModuleList/ScrollContainer/VBoxContainer.add_child(entry)
		entry.setName(setList.legacySets[i].DisplayName)
		entry.setID = setList.legacySets[i].setID
		legacyDownloader.formatSets.push_back(entry)
		
		var setVersion = FileAccess.get_file_as_string("user://SetData/" + setList.legacySets[i].setID + "/version.json")
		if setVersion == "":
			entry.setStatus("red")
			entry.status = "download"
			updatesRequired = true
			legacyUpdate = true
		else:
			setVersion = JSON.parse_string(setVersion)
			if setList.legacySets[i].Image_Version == setVersion.Image_Version and setList.legacySets[i].Data_Version == setVersion.Data_Version:
				entry.setStatus("green")
				entry.status = "ready"
			else:
				if setList.legacySets[i].Image_Version != setVersion.Image_Version:
					entry.imageMissmatch = true
				if setList.legacySets[i].Data_Version != setVersion.Data_Version:
					entry.dataMissmatch = true
				entry.setStatus("yellow")
				entry.status = "update"
				updatesRequired = true
				legacyUpdate = true
	if !legacyUpdate:
		legacyDownloader.disableButton()
	
	if !updatesRequired:
		$UpdateAll.text = "Nothing to Update"
		$UpdateAll.disabled = true

func _on_back_pressed() -> void:
	$"../../StartWindowHolder".spawnWindow()
	$"..".closeWindow()

func downloadSubSet(sets):
	$UpdateAll.text = "Processing..."
	$UpdateAll.disabled = true
	for i in range(sets.size()):
		if sets[i].listItemType == "entry":
			if sets[i].status == "download" or sets[i].status == "update":
				setsToDownLoad.append(sets[i])
				sets[i].queForDownload()
	downloadNext()

func _on_update_all_pressed() -> void:
	$UpdateAll.text = "Processing..."
	$UpdateAll.disabled = true
	var sets = $SetModuleList/ScrollContainer/VBoxContainer.get_children()
	for i in range(sets.size()):
		if sets[i].listItemType == "entry":
			if sets[i].status == "download" or sets[i].status == "update":
				setsToDownLoad.append(sets[i])
				sets[i].queForDownload()
	downloadNext()

func downloadNext():
	if setsToDownLoad.size() != 0:
		var setToDownload = setsToDownLoad.pop_front()
		if setToDownload.status == "download":
			setToDownload.downloadSet()
		elif setToDownload.status == "update":
			setToDownload.updateSet()
		databaseUpdate.append(setToDownload.setID)
	else:
		$UpdateAll.text = "Complete!"
		$UpdateAll.disabled = true
		CardDatabase.AddSets(databaseUpdate)
