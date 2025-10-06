extends Node2D

const objType = "trackerArrows"
const INSPECTORWIDTH = 308

var expanded = false
var animationMan

func _ready() -> void:
	animationMan = $"../../AnimationManager"

func toggleTracker():
	if expanded:
		expanded = false
		$Arrows.rotation = PI
		animationMan.animate_card_to_pos($"..", Vector2($"..".position.x + INSPECTORWIDTH, $"..".position.y))
	else:
		expanded = true
		$Arrows.rotation = 0
		animationMan.animate_card_to_pos($"..", Vector2($"..".position.x - INSPECTORWIDTH, $"..".position.y))
