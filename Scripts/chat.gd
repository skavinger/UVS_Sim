extends Node2D

var max_scroll_length = 0
var currentLog = "Chat"
var fullLogList = []
var eventLogList = []
var comboLogList = []
var chatLogList = []


func _on_line_edit_text_submitted(new_text: String) -> void:
	addToChatLog(new_text)
	$LineEdit.text = ""

func addToChatLog(text):
	var playerName = $"../../../..".playerData.PlayerName
	var message = "[color=" + $"../../../..".playerData.PlayerChatColor + "]" + playerName + ": " + text + "[/color]\n"
	fullLogList.append(message)
	comboLogList.append(message)
	chatLogList.append(message)
	if currentLog == "Chat" or currentLog == "Combo" or currentLog == "Full":
		$ScrollContainer/RichTextLabel.append_text(message)
		$ScrollContainer/RichTextLabel.scroll_to_line($ScrollContainer/RichTextLabel.get_line_count()-1)
	self.rpc_id(1, "addToOtherPlayerChatLog", playerName, text)

func addGameEventToLog(publicEvent, privateEvent):
	var playerName = $"../../../..".playerData.PlayerName
	var privateMessage = "[color=" + $"../../../..".playerData.PlayerEventColor + "]" + playerName + ": " + privateEvent + "[/color]\n"
	fullLogList.append(privateMessage)
	comboLogList.append(privateMessage)
	eventLogList.append(privateMessage)
	if currentLog == "Event" or currentLog == "Combo" or currentLog == "Full":
		$ScrollContainer/RichTextLabel.append_text(privateMessage)
		$ScrollContainer/RichTextLabel.scroll_to_line($ScrollContainer/RichTextLabel.get_line_count()-1)
	self.rpc_id(1, "addToOtherPlayerEventLog", playerName, publicEvent, privateEvent)

@rpc("any_peer")
func addToOtherPlayerChatLog(rivalname, text):
	var message = "[color=" + $"../../../..".playerData.RivalChatColor + "]" + rivalname + ": " + text + "[/color]\n"
	fullLogList.append(message)
	comboLogList.append(message)
	chatLogList.append(message)
	if currentLog == "Chat" or currentLog == "Combo" or currentLog == "Full":
		$ScrollContainer/RichTextLabel.append_text(message)
		$ScrollContainer/RichTextLabel.scroll_to_line($ScrollContainer/RichTextLabel.get_line_count()-1)

@rpc("any_peer")
func addToOtherPlayerEventLog(rivalName, publicEvent, privateEvent):
	var publicMessage = "[color=" + $"../../../..".playerData.RivalEventColor + "]" + rivalName + ": " + publicEvent + "[/color]\n"
	var privateMessage = "[color=" + $"../../../..".playerData.RivalEventColor + "]" + rivalName + ": " + privateEvent + "[/color]\n"
	fullLogList.append(privateMessage)
	comboLogList.append(publicMessage)
	eventLogList.append(publicMessage)
	if currentLog == "Event" or currentLog == "Combo":
		$ScrollContainer/RichTextLabel.append_text(publicMessage)
		$ScrollContainer/RichTextLabel.scroll_to_line($ScrollContainer/RichTextLabel.get_line_count()-1)
	elif currentLog == "Full":
		$ScrollContainer/RichTextLabel.append_text(privateMessage)
		$ScrollContainer/RichTextLabel.scroll_to_line($ScrollContainer/RichTextLabel.get_line_count()-1)


func _on_display_chat_pressed() -> void:
	currentLog = "Chat"
	$ScrollContainer/RichTextLabel.text = ""
	for i in range(chatLogList.size()):
		$ScrollContainer/RichTextLabel.append_text(chatLogList[i])
	$ScrollContainer/RichTextLabel.scroll_to_line($ScrollContainer/RichTextLabel.get_line_count()-1)


func _on_display_combo_pressed() -> void:
	currentLog = "Combo"
	$ScrollContainer/RichTextLabel.text = ""
	for i in range(comboLogList.size()):
		$ScrollContainer/RichTextLabel.append_text(comboLogList[i])
	$ScrollContainer/RichTextLabel.scroll_to_line($ScrollContainer/RichTextLabel.get_line_count()-1)


func _on_discplay_log_pressed() -> void:
	currentLog = "Event"
	$ScrollContainer/RichTextLabel.text = ""
	for i in range(eventLogList.size()):
		$ScrollContainer/RichTextLabel.append_text(eventLogList[i])
	$ScrollContainer/RichTextLabel.scroll_to_line($ScrollContainer/RichTextLabel.get_line_count()-1)
