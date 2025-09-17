extends Node2D

func animate_card_to_pos(card, pos):
	var tween = get_tree().create_tween()
	tween.tween_property(card,"position", pos, 0.2)
