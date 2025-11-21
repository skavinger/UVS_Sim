extends Node2D

const objType = "tracker"

var speed
var damage

func _ready() -> void:
	speed = 4
	damage = 4


func _on_full_block_pressed() -> void:
	setTracker(4, "mid", 4)

func _on_partial_block_pressed() -> void:
	$"../../SyncFunctions".loseHealth(int(ceil(float(damage) / 2)))
	setTracker(4, "mid", 4)

func _on_unblocked_pressed() -> void:
	$"../../SyncFunctions".loseHealth(damage)
	setTracker(4, "mid", 4)

func setTracker(speedNew, zoneNew, damageNew):
	$"../../SyncFunctions".rpc_id(1, "rivalSetTracker", speedNew, zoneNew, damageNew)
	speed = speedNew
	damage = damageNew
	$SpeedVal/SpeedLabel.text = str(int(speedNew))
	$DamageVal/DamageLabel.text = str(int(damageNew))
	if zoneNew == "high":
		$AttackZone/High.changeZone()
	elif zoneNew == "low":
		$AttackZone/Low.changeZone()
	else:
		$AttackZone/Mid.changeZone()
