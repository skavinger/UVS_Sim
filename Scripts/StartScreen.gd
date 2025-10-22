extends Node2D

var currentDeckList = {
	"DeckName": "",
	"character": null,
	"main": [],
	"side": []
}

func _ready() -> void:
	$StartWindowHolder.spawnWindow()
	var saveFile = FileAccess.get_file_as_string("user://Saves/current_list.auto_sav")
	saveFile = JSON.parse_string(saveFile)
	if saveFile != null:
		currentDeckList = saveFile
