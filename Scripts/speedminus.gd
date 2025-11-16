extends Node2D

const objType = "trackerValueAdjuster"

func adjstValue():
	$"../..".speed = $"../..".speed - 1
	$"../SpeedLabel".text = str($"../..".speed)
	rpc_id(1, "adjustValueOnClient")

@rpc("any_peer")
func adjustValueOnClient():
	$"../..".speed = $"../..".speed - 1
	$"../SpeedLabel".text = str($"../..".speed)
