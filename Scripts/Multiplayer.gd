extends Node2D

const serverIP = "localhost"
const PORT  = 1234

var peer = ENetMultiplayerPeer.new()

@export var gameField : PackedScene
@export var playerZones : PackedScene
@export var rivalZones : PackedScene

func _on_host_pressed() -> void:
	disable_buttons()
	peer.create_server(PORT)
	
	multiplayer.peer_connected.connect(_on_peer_connected)
	
	multiplayer.multiplayer_peer = peer
	var field = gameField.instantiate()
	$Game.add_child(field)
	var player = playerZones.instantiate()
	$Game.add_child(player)
	$InputManager.playerLoaded()

func _on_join_pressed() -> void:
	disable_buttons()
	peer.create_client(serverIP,PORT)
	multiplayer.multiplayer_peer = peer
	
	var field = gameField.instantiate()
	$Game.add_child(field)
	var player = playerZones.instantiate()
	$Game.add_child(player)
	$InputManager.playerLoaded()
	var rival = rivalZones.instantiate()
	$Game.add_child(rival)
	$InputManager.rivalLoaded()
	
func _on_peer_connected(peer_id):
	var rival = rivalZones.instantiate()
	$Game.add_child(rival)
	$InputManager.rivalLoaded()

func disable_buttons():
	$Host.disabled = true
	$Host.visible = false
	$Join.disabled =true
	$Join.visible = false
