extends Node2D

const objType = "cardInspector"
const INSPECTORHEIGHT = 549

var expandedV = false

func toggleInspector():
	if expandedV:
		expandedV = false
		$Arrows.rotation = PI/2
		$"../..".animationMan.animate_card_to_pos($"..", Vector2($"..".position.x, $"..".position.y - INSPECTORHEIGHT))
	else:
		expandedV = true
		$Arrows.rotation = PI + PI/2
		$"../..".animationMan.animate_card_to_pos($"..", Vector2($"..".position.x, $"..".position.y + INSPECTORHEIGHT))
