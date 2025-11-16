extends Node2D

const objType = "mid"

func changeZone():
	$"../Speed".texture = load("res://Assets/mid.png")
	rpc_id(1, "clientChangeZone")
	
@rpc("any_peer")
func clientChangeZone():
	$"../Speed".texture = load("res://Assets/mid.png")
