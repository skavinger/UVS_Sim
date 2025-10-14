extends Node2D

@export var DeckbuilderWindow : PackedScene

var deckBuilderObj

func spawnWindow():
	deckBuilderObj = DeckbuilderWindow.instantiate()
	self.add_child(deckBuilderObj)
	
func closeWindow():
	self.remove_child(deckBuilderObj)
	deckBuilderObj = null
