extends Node2D

func setPlayerHealth(health):
	$"../Game/Field/PlayerHealth/Label".text = str(health)
	rpc("syncHealth", health)
	
@rpc("any_peer")
func syncHealth(health):
	$"../Game/Field/RivalHealth/Label".text = str(health)
