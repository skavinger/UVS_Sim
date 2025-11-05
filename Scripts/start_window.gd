extends Node2D

func _on_connect_pressed() -> void:
	$"../../ConnectWindowHolder".spawnWindow()
	$"..".closeWindow()


func _on_deck_builder_pressed() -> void:
	$"../../DeckbuilderHolder".spawnWindow()
	$"..".closeWindow()


func _on_download_data_pressed() -> void:
	$"../../DownloadWindowHolder".spawnWindow()
	$"..".closeWindow()
