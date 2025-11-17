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
		$OpenGames/ScrollContainer/VBoxContainer.add_child(room)
		

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
