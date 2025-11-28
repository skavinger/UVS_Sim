extends Node2D

#const serverIP = "138.2.232.82"
var serverIP = "localhost"
var PORT  = 25555

const PLAYER_ROOM_PATH = "res://GameObj/Multiplayer/playerRoom.tscn"

var peer = ENetMultiplayerPeer.new()
var selectedFormat = "Any"

func _ready() -> void:
	var ipConfig = FileAccess.get_file_as_string("user://GameData/IPConfig.json")
	ipConfig = JSON.parse_string(ipConfig)
	serverIP = ipConfig.IP
	PORT = ipConfig.port
	peer.create_client(serverIP,PORT)
	multiplayer.multiplayer_peer = peer
	for i in range($"../../".currentDeckList.Formats.size()):
		if $"../../".currentDeckList.Formats[i] == "Standard":
			selectedFormat = "Standard"
		$Formats.get_popup().add_item($"../../".currentDeckList.Formats[i])
	$Formats.get_popup().id_pressed.connect(_format_selected)

func _format_selected(id):
	var format = $Formats.get_popup().get_item_text(id)
	$Formats.text = format
	selectedFormat = format

func _on_create_room_pressed() -> void:
	Server.rpc_id(1, "createRoom", $"../../".playerData.PlayerName, $"../../".currentDeckList, $Password.text, selectedFormat)
	
	$"../../GameWindowHolder".spawnWindow()
	$"..".closeWindow()

func _on_back_pressed() -> void:
	multiplayer.multiplayer_peer.close()
	$"../../StartWindowHolder".spawnWindow()
	$"..".closeWindow()

func updateRooms(rooms):
	var oldRooms = $OpenGames/ScrollContainer/VBoxContainer.get_children()
	for i in range(oldRooms.size()):
		$OpenGames/ScrollContainer/VBoxContainer.remove_child(oldRooms[i])
		
	for i in range(rooms.size()):
		var room = preload(PLAYER_ROOM_PATH).instantiate()
		room.setPlayerName(rooms[i].creatingPlayerName)
		room.creatorPlayerID = rooms[i].creatingPlayerID
		if !checkRoomPlayable(rooms[i]):
			room.setFormat("Missing Cards")
		else:
			var found = false
			if rooms[i].format == "Any":
				room.setFormat(rooms[i].format)
			else:
				for j in range($"../../".currentDeckList.Formats.size()):
					if $"../../".currentDeckList.Formats[j] == selectedFormat:
						found = true
						break
				if found:
					room.setFormat(rooms[i].format)
				else:
					room.setFormat("Decklist Invalid")
		$OpenGames/ScrollContainer/VBoxContainer.add_child(room)
		

func checkRoomPlayable(room):
	var sets = CardDatabase.getSets()
	var found = false
	for i in range(sets.size()):
		if room.playerDeck.character.cardID.set == sets[i]:
			found = true
			break
	if !found:
			return false
	for i in range(room.playerDeck.main.size()):
		found = false
		for j in range(sets.size()):
			if room.playerDeck.main[i].cardID.set == sets[j]:
				found = true
				break
		if !found:
			return false
	for i in range(room.playerDeck.side.size()):
		found = false
		for j in range(sets.size()):
			if room.playerDeck.side[i].cardID.set == sets[j]:
				found = true
				break
		if !found:
			return false
	return true

func _on_join_pressed(creatorPlayerID) -> void:
	Server.rpc_id(1, "joinRoom", creatorPlayerID, $Password.text)
	
	
func joinRoom(status):
	if status == "joined":
		$"../../GameWindowHolder".spawnWindow()
		$"..".closeWindow()
	elif status == "occupied":
		pass
	elif status == "invalidPassword":
		pass
	
func rivalJoined():
	pass
