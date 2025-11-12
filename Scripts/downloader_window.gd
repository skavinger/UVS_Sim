extends Node2D

const pathToDownLoadEntry = "res://GameObj/Updater/download_entry.tscn"
const cardRepoBaseURL = "https://raw.githubusercontent.com/skavinger/UVS_Dataset/refs/heads/main/"

var setsToDownLoad = []
var setsToUpdate = []
var databaseUpdate = []

func _ready() -> void:
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(self._http_request_completed)
	
	var error = http_request.request(cardRepoBaseURL + "setList.json")
	if error != OK:
		push_error("Unable to get set list from repo")

func _http_request_completed(_result, _response_code, _headers, body):
	var setList = JSON.parse_string(body.get_string_from_utf8()).listOfSets
	var updatesRequired = false
	for i in range(setList.size()):
		var entry = preload(pathToDownLoadEntry).instantiate()
		$SetModuleList/ScrollContainer/VBoxContainer.add_child(entry)
		entry.setName(setList[i].setID)
		entry.setID = setList[i].setID
		
		var setVersion = FileAccess.get_file_as_string("user://SetData/" + setList[i].setID + "/version.json")
		if setVersion == "":
			entry.setStatus("red")
			entry.status = "download"
			updatesRequired = true
		else:
			setVersion = JSON.parse_string(setVersion)
			if setList[i].Image_Version == setVersion.Image_Version and setList[i].Data_Version == setVersion.Data_Version:
				entry.setStatus("green")
				entry.status = "ready"
			else:
				if setList[i].Image_Version != setVersion.Image_Version:
					entry.imageMissmatch = true
				if setList[i].Data_Version != setVersion.Data_Version:
					entry.dataMissmatch = true
				entry.setStatus("yellow")
				entry.status = "update"
				updatesRequired = true
	if !updatesRequired:
		$UpdateAll.text = "Nothing to Update"
		$UpdateAll.disabled = true

func _on_back_pressed() -> void:
	$"../../StartWindowHolder".spawnWindow()
	$"..".closeWindow()


func _on_update_all_pressed() -> void:
	$UpdateAll.text = "Processing..."
	$UpdateAll.disabled = true
	var sets = $SetModuleList/ScrollContainer/VBoxContainer.get_children()
	for i in range(sets.size()):
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
