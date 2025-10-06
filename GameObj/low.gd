extends Node2D

const objType = "low"

func changeZone():
	$"../Speed".texture = load("res://Assets/low.png")
	rpc("clientChangeZone")
	
@rpc("any_peer")
func clientChangeZone():
	$"../Speed".texture = load("res://Assets/low.png")
	
