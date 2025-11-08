extends Node2D

@export var SettingsWindow : PackedScene

var settingsObj

func spawnWindow():
	settingsObj = SettingsWindow.instantiate()
	self.add_child(settingsObj)
	
func closeWindow():
	self.remove_child(settingsObj)
	settingsObj = null
