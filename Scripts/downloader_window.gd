extends Node2D

const pathToDownLoadEntry = "res://GameObj/download_entry.tscn"
const cardRepoBaseURL = "https://raw.githubusercontent.com/skavinger/UVS_Dataset/refs/heads/main/"

func _ready() -> void:
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(self._http_request_completed)
	
	var error = http_request.request(cardRepoBaseURL + "setList.json")
	if error != OK:
		push_error("Unable to get set list from repo")

func _http_request_completed(_result, _response_code, _headers, body):
	var setList = JSON.parse_string(body.get_string_from_utf8()).listOfSets
	for i in range(setList.size()):
		var entry = preload(pathToDownLoadEntry).instantiate()
		$SetModuleList/ScrollContainer/VBoxContainer.add_child(entry)
		entry.setName(setList[i].setID)
		entry.setID = setList[i].setID
		
		var setVersion = FileAccess.get_file_as_string("user://SetData/" + setList[i].setID + "/version.json")
		if setVersion == "":
			entry.setStatus("red")
		else:
			setVersion = JSON.parse_string(setVersion)
			if setList[i].Image_Version == setVersion.Image_Version and setList[i].Data_Version == setVersion.Data_Version:
				entry.setStatus("green")
			else:
				if setList[i].Image_Version != setVersion.Image_Version:
					entry.imageMissmatch = true
				if setList[i].Data_Version == setVersion.Data_Version:
					entry.dataMissmatch = true
				entry.setStatus("yellow")

func _on_back_pressed() -> void:
	$"../../StartWindowHolder".spawnWindow()
	$"..".closeWindow()
