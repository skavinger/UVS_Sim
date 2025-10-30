extends Node2D

const CARD_WIDTH = 20

const MOMENTUM_POS_X = 1820
const MOMENTUM_POS_Y = 270

var starting_character

var momentum = []

const momentumActions = []

var animationMan

func _ready() -> void:
	animationMan = $"../../Field/AnimationManager"

func get_card_by_indexID(ID):
	for i in range(momentum.size()):
		if momentum[i].indexID == ID:
			return momentum[i]

func add_to_momentum(card):
	momentum.append(card)
	update_pos()
	card.cardObj.set_buttons(card, momentumActions.duplicate(true))

func eraseCard(card):
	momentum.erase(card)
	update_pos()

func update_pos():
	for i in range(momentum.size()):
		momentum[i].cardObj.rotation = PI + PI/2
		animationMan.animate_card_to_pos(momentum[i].cardObj, Vector2(MOMENTUM_POS_X, MOMENTUM_POS_Y - (CARD_WIDTH * i)))
		momentum[i].cardObj.z_index = 300 + i
