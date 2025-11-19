extends Node2D

const serverIP = "localhost"
const PORT  = 25555

const PLAYER_ROOM_PATH = "res://GameObj/Multiplayer/playerRoom.tscn"

var peer = ENetMultiplayerPeer.new()

func _ready() -> void:
	peer.create_client(serverIP,PORT)
	multiplayer.multiplayer_peer = peer
	multiplayer.connected_to_server.connect(_test)

func _test():
	pass

func _on_create_room_pressed() -> void:
	Server.rpc_id(1, "createRoom", $"../../".playerData.PlayerName, $"../../".currentDeckList, $Password.text)
	
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
			room.disableRoom()
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
