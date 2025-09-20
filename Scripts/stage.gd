extends Node2D

const CARD_WIDTH = 70

const CH_POS_X = 130
const CH_POS_Y = 670

const STAGE_POS_START_X = 270
const STAGE_POS_START_Y = 890

var starting_character

var stage = []

var animationMan

func _ready() -> void:
	animationMan = $"../AnimationManager"

func add_character_to_stage(character):
	starting_character = character
	animationMan.animate_card_to_pos(starting_character.cardObj, Vector2(CH_POS_X, CH_POS_Y))

func build_card(card):
	stage.append(card)
	update_pos()
	
func update_pos():
	for i in range(stage.size()):
		animationMan.animate_card_to_pos(stage[i].cardObj, Vector2(STAGE_POS_START_X + (CARD_WIDTH * i), STAGE_POS_START_Y))
		stage[i].cardObj.z_index = 200 + i
