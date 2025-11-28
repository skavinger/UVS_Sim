extends Node2D

var currentDeckList = {
	"DeckName": "",
	"Formats": [],
	"character": null,
	"main": [],
	"side": []
}

var playerData = {
	"PlayerName": "",
	"PlayerChatColor": "#008000",
	"PlayerEventColor": "#90EE90",
	"RivalChatColor": "#FF0000",
	"RivalEventColor": "#FFC0CB"
}
var rivalPlayerData

var keywordRequest
var keywordEffectsRequest
var ipConfigRequest

var pendingRequests = []

func _ready() -> void:
	playerData.PlayerName = "Player " + str(randi_range(1, 99999))
	var saveFile = FileAccess.get_file_as_string("user://Saves/current_list.auto_sav")
	if saveFile != "":
		currentDeckList = JSON.parse_string(saveFile)
	var userSettings = FileAccess.get_file_as_string("user:///user_settings.json")
	if userSettings != "":
		playerData = JSON.parse_string(userSettings)
		
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(self._http_request_completed)
	var error = http_request.request("https://github.com/skavinger/UVS_Sim/raw/refs/heads/main/GameData/version.json")
	if error != OK:
		push_error("Unable to get game version data from repo")

func loadStartScreen():
	$StartWindowHolder.spawnWindow()

@rpc("any_peer")
func setRivalPlayerData(rivalData):
	rivalPlayerData = rivalData

func _http_request_completed(_result, _response_code, _headers, body):
	var gameDataVersion = JSON.parse_string(body.get_string_from_utf8())
	var currentGameDataVersion = FileAccess.get_file_as_string("user://GameData/version.json")
	if currentGameDataVersion != "":
		currentGameDataVersion = JSON.parse_string(currentGameDataVersion)
	else:
		currentGameDataVersion = null
	DirAccess.remove_absolute("user://GameData/version.json")
	if !DirAccess.dir_exists_absolute("user://GameData/"):
		DirAccess.make_dir_absolute("user://GameData/")
	var saveFile = FileAccess.open("user://GameData/version.json",FileAccess.WRITE)
	saveFile.store_string(JSON.stringify(gameDataVersion))
	
	var updateRequired = false
	if currentGameDataVersion == null or gameDataVersion.keywords != currentGameDataVersion.keywords:
		updateKeywords()
		updateRequired = true
	if currentGameDataVersion == null or gameDataVersion.IPConfig != currentGameDataVersion.IPConfig:
		updateIPConfig()
		updateRequired = true
	if !updateRequired:
		loadStartScreen()

func updateKeywords():
	DirAccess.remove_absolute("user://GameData/keywords.json")
	DirAccess.remove_absolute("user://GameData/KeywordAbilityScripts/")
	keywordRequest = HTTPRequest.new()
	add_child(keywordRequest)
	keywordRequest.request_completed.connect(self._download_completed.bind(["keywordList"]))
	keywordRequest.download_file = "user://GameData/keywords.json"
	pendingRequests.push_back("keywordList")
	var error = keywordRequest.request("https://github.com/skavinger/UVS_Sim/raw/refs/heads/main/GameData/Keywords/keywords.json")
	if error != OK:
		push_error("Unable to get keywords list from repo")
		
	keywordEffectsRequest = HTTPRequest.new()
	add_child(keywordEffectsRequest)
	keywordEffectsRequest.request_completed.connect(self._download_completed.bind(["keywordEffects"]))
	keywordEffectsRequest.download_file = "user://GameData/KeywordAbilityScripts.zip"
	pendingRequests.push_back("keywordEffects")
	error = keywordEffectsRequest.request("https://github.com/skavinger/UVS_Sim/raw/refs/heads/main/GameData/Keywords/KeywordAbilityScripts.zip")
	if error != OK:
		push_error("Unable to get keywords list from repo")

func updateIPConfig():
	DirAccess.remove_absolute("user://GameData/IPConfig.json")
	ipConfigRequest = HTTPRequest.new()
	add_child(ipConfigRequest)
	ipConfigRequest.request_completed.connect(self._download_completed.bind(["ipConfig"]))
	ipConfigRequest.download_file = "user://GameData/IPConfig.json"
	pendingRequests.push_back("ipConfig")
	var error = ipConfigRequest.request("https://github.com/skavinger/UVS_Sim/raw/refs/heads/main/GameData/IPConfig.json")
	if error != OK:
		push_error("Unable to get keywords list from repo")

func _download_completed(result, _response_code, _headers, _body, extra):
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("Download Failed")
	if extra[0] == "keywordList":
		remove_child(keywordRequest)
		CardDatabase.loadKeywords()
	elif extra[0] == "keywordEffects":
		remove_child(keywordEffectsRequest)
		extractZip("user://GameData/KeywordAbilityScripts.zip","user://GameData/")
	elif extra[0] == "ipConfig":
		remove_child(ipConfigRequest)
		
	if pendingRequests.size() == 0:
		loadStartScreen()


func extractZip(zipPath, unzipPath):
	var zipReader = ZIPReader.new()
	zipReader.open(zipPath)
	
	var unzipDir = DirAccess.open(unzipPath)
	var files = zipReader.get_files()
	
	for filePath in files:
		if filePath.ends_with("/"):
			unzipDir.make_dir_recursive(filePath)
			continue
		
		unzipDir.make_dir_recursive(unzipDir.get_current_dir().path_join(filePath).get_base_dir())
		var file = FileAccess.open(unzipDir.get_current_dir().path_join(filePath), FileAccess.WRITE)
		var buffer = zipReader.read_file(filePath)
		file.store_buffer(buffer)
	zipReader.close()
	DirAccess.remove_absolute(zipPath)
