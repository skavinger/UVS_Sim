extends Node

@rpc("any_peer")
func createRoom():
	print("Called Remotely")

@rpc("any_peer")
func roomsUpdated(rooms):
	$"../ConnectWindowHolder/ConnectionWindow".updateRooms(rooms)
