extends Node2D

const objType = "mid"

func changeZone():
	$"../Speed".texture = load("res://Assets/mid.png")
	rpc("clientChangeZone")
	
@rpc("any_peer")
func clientChangeZone():
	$"../Speed".texture = load("res://Assets/mid.png")
