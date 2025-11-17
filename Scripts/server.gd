extends Node

@rpc("any_peer")
func createRoom():
	pass

@rpc("any_peer")
func joinRoom(_creatingPlayerID, _password):
	pass

@rpc("any_peer")
func roomsUpdated(rooms):
	if $"../Main/ConnectWindowHolder".get_child_count() != 0:
		$"../Main/ConnectWindowHolder/ConnectionWindow".updateRooms(rooms)

@rpc("any_peer")
func rivalJoined():
	if $"../Main/ConnectWindowHolder".get_child_count() != 0:
		$"../Main/ConnectWindowHolder/ConnectionWindow".rivalJoined()

@rpc("any_peer")
func joinReply(status):
	if $"../Main/ConnectWindowHolder".get_child_count() != 0:
		$"../Main/ConnectWindowHolder/ConnectionWindow".joinRoom(status)

@rpc("any_peer")
func gameLeft():
	pass

@rpc("any_peer")
func checkIfGameReady():
	pass

@rpc("any_peer")
func gameReady(isGameReady):
	if isGameReady:
		$"../Main/GameWindowHolder/GameWindow".setUpGame()
	else:
		$"../Main/GameWindowHolder/GameWindow".setAsHost()
