extends Node2D

const CARD_WIDTH = 20
const MOMENTUM_MAX_HEIGHT = 80

const MOMENTUM_POS_X = 1820
const MOMENTUM_POS_Y = 270

var starting_character

var momentum = []

const momentumActions = [{"Action": "Select Card", "Label": "Select"}]

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
	var cardWidth
	if CARD_WIDTH * momentum.size() > MOMENTUM_MAX_HEIGHT:
		cardWidth = float(MOMENTUM_MAX_HEIGHT) / float(momentum.size())
	else:
		cardWidth = CARD_WIDTH
	for i in range(momentum.size()):
		momentum[i].cardObj.rotation = PI + PI/2
		animationMan.animate_card_to_pos(momentum[i].cardObj, Vector2(MOMENTUM_POS_X, MOMENTUM_POS_Y - (cardWidth * i)))
		momentum[i].cardObj.z_index = 300 + i
