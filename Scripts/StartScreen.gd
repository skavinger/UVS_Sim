extends Node2D

var currentDeckList = {
	"DeckName": "",
	"character": null,
	"main": [],
	"side": []
}

var playerData = {
	"PlayerName": ""
}
var rivalPlayerData

func _ready() -> void:
	$StartWindowHolder.spawnWindow()
	playerData.PlayerName = "Player " + str(randi_range(1, 99999))
	var saveFile = FileAccess.get_file_as_string("user://Saves/current_list.auto_sav")
	saveFile = JSON.parse_string(saveFile)
	if saveFile != null:
		currentDeckList = saveFile

@rpc("any_peer")
func setRivalPlayerData(rivalData):
	rivalPlayerData = rivalData
