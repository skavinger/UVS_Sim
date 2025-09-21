extends Node2D

const CARD_WIDTH = 20

const STAGE_POS_CARDPOOL_X = 130
const STAGE_POS_CARDPOOL_Y = 820

var starting_character

var momentum = []

var animationMan

func _ready() -> void:
	animationMan = $"../AnimationManager"

func add_to_momentum(card):
	momentum.append(card)
	update_pos()

func eraseCard(card):
	momentum.erase(card)
	update_pos()

func update_pos():
	for i in range(momentum.size()):
		momentum[i].cardObj.rotation = PI/2
		animationMan.animate_card_to_pos(momentum[i].cardObj, Vector2(STAGE_POS_CARDPOOL_X, STAGE_POS_CARDPOOL_Y + (CARD_WIDTH * i)))
		momentum[i].cardObj.z_index = 200 + i
