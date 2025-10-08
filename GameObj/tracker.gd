extends Node2D

const objType = "tracker"

var speed
var damage

func _ready() -> void:
	speed = 4
	damage = 4


func _on_full_block_pressed() -> void:
	resetTracker()

func _on_partial_block_pressed() -> void:
	$"../../../SyncFunctions".loseHealth(int(ceil(float(damage) / 2)))
	resetTracker()


func _on_unblocked_pressed() -> void:
	$"../../../SyncFunctions".loseHealth(damage)
	resetTracker()

func resetTracker():
	speed = 4
	damage = 4
	$SpeedVal/SpeedLabel.text = str(4)
	$DamageVal/DamageLabel.text = str(4)
