extends Node2D

const objType = "trackerValueAdjuster"

func adjstValue():
	$"../..".damage = $"../..".damage + 1
	$"../DamageLabel".text = str($"../..".damage)
	rpc_id(1, "adjustValueOnClient")

@rpc("any_peer")
func adjustValueOnClient():
	$"../..".damage = $"../..".damage + 1
	$"../DamageLabel".text = str($"../..".damage)
	
