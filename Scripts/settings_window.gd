extends Node2D

func _ready() -> void:
	$PlayerName.text = $"../..".playerData.PlayerName
	$PlayerChatColor.color = Color.html($"../..".playerData.PlayerChatColor)
	$PlayerEventColor.color = Color.html($"../..".playerData.PlayerEventColor)
	$RivalChatColor.color = Color.html($"../..".playerData.RivalChatColor)
	$RivalEventColor.color = Color.html($"../..".playerData.RivalEventColor)

func _on_back_pressed() -> void:
	$"../../StartWindowHolder".spawnWindow()
	$"..".closeWindow()

func _on_player_name_text_changed(new_text: String) -> void:
	$"../..".playerData.PlayerName = new_text

func _on_player_chat_color_color_changed(color: Color) -> void:
	$"../..".playerData.PlayerChatColor = color.to_html(false)

func _on_player_event_color_color_changed(color: Color) -> void:
	$"../..".playerData.PlayerEventColor = color.to_html(false)

func _on_rival_chat_color_color_changed(color: Color) -> void:
	$"../..".playerData.RivalChatColor = color.to_html(false)

func _on_rival_event_color_color_changed(color: Color) -> void:
	$"../..".playerData.RivalEventColor = color.to_html(false)
