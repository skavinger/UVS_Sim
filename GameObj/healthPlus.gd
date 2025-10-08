extends Node2D

const objType = "trackerValueAdjuster"

func adjstValue():
	$"../../../../../SyncFunctions".gainHealth(int($"../LineEdit".text))
