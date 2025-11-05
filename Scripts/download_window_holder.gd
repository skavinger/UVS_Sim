extends Node2D

@export var DownloaderWindow : PackedScene

var downloaderObj

func spawnWindow():
	downloaderObj = DownloaderWindow.instantiate()
	self.add_child(downloaderObj)
	
func closeWindow():
	self.remove_child(downloaderObj)
	downloaderObj = null
