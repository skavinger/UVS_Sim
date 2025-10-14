extends Node2D

@export var ConnectWindow : PackedScene

var connectWindowObj

func spawnWindow():
	connectWindowObj = ConnectWindow.instantiate()
	self.add_child(connectWindowObj)
	

func closeWindow():
	self.remove_child(connectWindowObj)
	connectWindowObj = null
