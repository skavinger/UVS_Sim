extends Node2D

const objType = "trackerValueAdjuster"

func adjstValue():
	$"../../../../../SyncFunctions".loseHealth(int($"../LineEdit".text))
