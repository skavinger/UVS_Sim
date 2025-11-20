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

func _ready() -> void:
	$StartWindowHolder.spawnWindow()
	playerData.PlayerName = "Player " + str(randi_range(1, 99999))
	var saveFile = FileAccess.get_file_as_string("user://Saves/current_list.auto_sav")
	if saveFile != "":
		currentDeckList = JSON.parse_string(saveFile)
	var userSettings = FileAccess.get_file_as_string("user:///user_settings.json")
	if userSettings != "":
		playerData = JSON.parse_string(userSettings)

@rpc("any_peer")
func setRivalPlayerData(rivalData):
	rivalPlayerData = rivalData
