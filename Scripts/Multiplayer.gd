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
	
	multiplayer.connected_to_server.connect(_on_server_connected)


func _on_back_pressed() -> void:
	$"../../StartWindowHolder".spawnWindow()
	$"..".closeWindow()

func _on_peer_connected(_peer_id):
	var rival = rivalZones.instantiate()
	$Game.add_child(rival)
	$InputManager.rivalLoaded()
	call_deferred("hostSetup")

func _on_server_connected():
	call_deferred("client_setup")

func hostSetup():
	get_node("Game").host_setup()
	
	
func client_setup():
	get_node("Game").client_setup()

func disable_buttons():
	$Host.disabled = true
	$Host.visible = false
	$Join.disabled =true
	$Join.visible = false
	$Back.disabled = true
	$Back.visible = false
