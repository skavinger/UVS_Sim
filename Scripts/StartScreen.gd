extends Node2D

var currentDeckList = {
	"DeckName": "",
	"character": null,
	"main": [],
	"side": []
}

func _ready() -> void:
	$StartWindowHolder.spawnWindow()
