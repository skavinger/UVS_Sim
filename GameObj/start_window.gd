extends Node2D

func _on_connect_pressed() -> void:
	$"../../ConnectWindowHolder".spawnWindow()
	$"..".closeWindow()
