extends Node2D

const CARD_WIDTH = 70
const HAND_Y_POS = 1100

const CH_POS_X = 120
const CH_POS_Y = 670

var starting_character

var stage = []

func add_character_to_stage(character):
	starting_character = character
	animate_card_to_pos(starting_character, Vector2(CH_POS_X, CH_POS_Y))
	starting_character.scale = Vector2(0.6,0.6)
	
func animate_card_to_pos(card, pos):
	var tween = get_tree().create_tween()
	tween.tween_property(card,"position", pos, 0.2)
