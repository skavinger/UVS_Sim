extends Node2D

@export var GameWindow : PackedScene

var gameObj

func spawnWindow():
	gameObj = GameWindow.instantiate()
	self.add_child(gameObj)
	
func closeWindow():
	self.remove_child(gameObj)
	gameObj = null
