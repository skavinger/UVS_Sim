extends Node2D

const objType = "high"

func changeZone():
	$"../Speed".texture = load("res://Assets/high.png")
	rpc_id(1, "clientChangeZone")
	
@rpc("any_peer")
func clientChangeZone():
	$"../Speed".texture = load("res://Assets/high.png")
