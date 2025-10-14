extends Node2D

@export var StartWindow : PackedScene

var startWindowObj

func spawnWindow():
	startWindowObj = StartWindow.instantiate()
	self.add_child(startWindowObj)
	
func closeWindow():
	self.remove_child(startWindowObj)
	startWindowObj = null
