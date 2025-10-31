extends Node2D

var max_scroll_length = 0

func _on_line_edit_text_submitted(new_text: String) -> void:
	addToChatLog(new_text)
	$LineEdit.text = ""

func addToChatLog(text):
	var playerName = $"../../../../..".playerData.PlayerName
	$ScrollContainer/RichTextLabel.append_text("[color=green]" + playerName + ": " + text + "[/color]\n")
	$ScrollContainer/RichTextLabel.scroll_to_line($ScrollContainer/RichTextLabel.get_line_count()-1)
	self.rpc("addToOtherPlayerChatLog", text)

@rpc("any_peer")
func addToOtherPlayerChatLog(text):
	var playerName = $"../../../../..".rivalPlayerData.PlayerName
	$ScrollContainer/RichTextLabel.append_text("[color=red]" + playerName + ": " + text + "[/color]\n")
	$ScrollContainer/RichTextLabel.scroll_to_line($ScrollContainer/RichTextLabel.get_line_count()-1)
