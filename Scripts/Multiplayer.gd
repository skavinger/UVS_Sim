extends Node2D

const serverIP = "localhost"
const PORT  = 25555

const PLAYER_ROOM_PATH = "res://GameObj/Multiplayer/playerRoom.tscn"

var peer = ENetMultiplayerPeer.new()

@export var gameField : PackedScene
@export var playerZones : PackedScene
@export var rivalZones : PackedScene

func _ready() -> void:
	peer.create_client(serverIP,PORT)
	multiplayer.multiplayer_peer = peer
	multiplayer.connected_to_server.connect(_test)

func _test():
	pass

func _on_create_room_pressed() -> void:
	Server.rpc_id(1, "createRoom", $"../../".playerData.PlayerName, $"../../".currentDeckList, $Password.text)
	
	disable_buttons()
	var field = gameField.instantiate()
	$Game.add_child(field)
	var player = playerZones.instantiate()
	$Game.add_child(player)
	$InputManager.playerLoaded()


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
		
func disable_buttons():
	$CreateRoom.disabled = true
	$CreateRoom.visible = false
	var rooms = $OpenGames/ScrollContainer/VBoxContainer.get_children()
	for i in range(rooms.size()):
		rooms[i].disableUI()
	$OpenGames.visible = false
	$Back.disabled = true
	$Back.visible = false
	$PasswordLabel.visible = false
	$Password.editable = false
	$Password.visible = false

func _on_join_pressed(creatorPlayerID) -> void:
	Server.rpc_id(1, "joinRoom", creatorPlayerID, $Password.text)
	
	
func joinRoom(status):
	if status == "joined":
		disable_buttons()
		var field = gameField.instantiate()
		$Game.add_child(field)
		var player = playerZones.instantiate()
		$Game.add_child(player)
		$InputManager.playerLoaded()
		var rival = rivalZones.instantiate()
		$Game.add_child(rival)
		$InputManager.rivalLoaded()
		
		get_node("Game").client_setup()
	elif status == "occupied":
		pass
	elif status == "invalidPassword":
		pass
	
func rivalJoined():
	var rival = rivalZones.instantiate()
	$Game.add_child(rival)
	$InputManager.rivalLoaded()
	get_node("Game").host_setup()
