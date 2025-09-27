extends Node2D

func animate_card_to_pos(obj, pos):
	var tween = get_tree().create_tween()
	tween.tween_property(obj,"position", pos, 0.2)
