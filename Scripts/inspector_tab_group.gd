extends Node2D

const objType = "cardInspector"

const INSPECTORWIDTH = 365

var expandedH = true

func toggleInspector():
	if expandedH:
		expandedH = false
		$Arrows.rotation = 0
		$"..".animationMan.animate_card_to_pos($"..", Vector2($"..".position.x - INSPECTORWIDTH, $"..".position.y))
	else:
		expandedH = true
		$Arrows.rotation = PI
		$"..".animationMan.animate_card_to_pos($"..", Vector2($"..".position.x + INSPECTORWIDTH, $"..".position.y))
