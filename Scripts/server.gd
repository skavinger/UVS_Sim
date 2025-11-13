extends Node

@rpc("any_peer")
func createRoom():
	pass

@rpc("any_peer")
func joinRoom(_creatingPlayerID, _password):
	pass

@rpc("any_peer")
func roomsUpdated(rooms):
	$"../ConnectWindowHolder/ConnectionWindow".updateRooms(rooms)

@rpc("any_peer")
func rivalJoined():
	$"../ConnectWindowHolder/ConnectionWindow".rivalJoined()

@rpc("any_peer")
func joinReply(status):
	$"../ConnectWindowHolder/ConnectionWindow".joinRoom(status)
