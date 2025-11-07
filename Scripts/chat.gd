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
	var playerName = $"../../../../..".playerData.PlayerName
	var message = "[color=green]" + playerName + ": " + text + "[/color]\n"
	fullLogList.append(message)
	comboLogList.append(message)
	chatLogList.append(message)
	if currentLog == "Chat" or currentLog == "Combo" or currentLog == "Full":
		$ScrollContainer/RichTextLabel.append_text(message)
		$ScrollContainer/RichTextLabel.scroll_to_line($ScrollContainer/RichTextLabel.get_line_count()-1)
	self.rpc("addToOtherPlayerChatLog", playerName, text)

func addGameEventToLog(publicEvent, privateEvent):
	var playerName = $"../../../../..".playerData.PlayerName
	var privateMessage = "[color=lightgreen]" + playerName + ": " + privateEvent + "[/color]\n"
	fullLogList.append(privateMessage)
	comboLogList.append(privateMessage)
	eventLogList.append(privateMessage)
	if currentLog == "Event" or currentLog == "Combo" or currentLog == "Full":
		$ScrollContainer/RichTextLabel.append_text(privateMessage)
		$ScrollContainer/RichTextLabel.scroll_to_line($ScrollContainer/RichTextLabel.get_line_count()-1)
	self.rpc("addToOtherPlayerEventLog", playerName, publicEvent, privateEvent)

@rpc("any_peer")
func addToOtherPlayerChatLog(rivalname, text):
	var message = "[color=red]" + rivalname + ": " + text + "[/color]\n"
	fullLogList.append(message)
	comboLogList.append(message)
	chatLogList.append(message)
	if currentLog == "Chat" or currentLog == "Combo" or currentLog == "Full":
		$ScrollContainer/RichTextLabel.append_text(message)
		$ScrollContainer/RichTextLabel.scroll_to_line($ScrollContainer/RichTextLabel.get_line_count()-1)

@rpc("any_peer")
func addToOtherPlayerEventLog(rivalName, publicEvent, privateEvent):
	var publicMessage = "[color=rightred]" + rivalName + ": " + publicEvent + "[/color]\n"
	var privateMessage = "[color=rightred]" + rivalName + ": " + privateEvent + "[/color]\n"
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
	$ScrollContainer/RichTextLabel.text = ""
	for i in range(chatLogList.size()):
		$ScrollContainer/RichTextLabel.append_text(chatLogList[i])
	$ScrollContainer/RichTextLabel.scroll_to_line($ScrollContainer/RichTextLabel.get_line_count()-1)


func _on_display_combo_pressed() -> void:
	$ScrollContainer/RichTextLabel.text = ""
	for i in range(comboLogList.size()):
		$ScrollContainer/RichTextLabel.append_text(comboLogList[i])
	$ScrollContainer/RichTextLabel.scroll_to_line($ScrollContainer/RichTextLabel.get_line_count()-1)


func _on_discplay_log_pressed() -> void:
	$ScrollContainer/RichTextLabel.text = ""
	for i in range(eventLogList.size()):
		$ScrollContainer/RichTextLabel.append_text(eventLogList[i])
	$ScrollContainer/RichTextLabel.scroll_to_line($ScrollContainer/RichTextLabel.get_line_count()-1)
