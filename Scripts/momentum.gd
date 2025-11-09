extends Node2D

const CARD_WIDTH = 20
const MOMENTUM_MAX_HEIGHT = 80

const STAGE_POS_CARDPOOL_X = 100
const STAGE_POS_CARDPOOL_Y = 810

var starting_character

var momentum = []

const momentumActions = [
{"Action": "To Hand", "Label": "Add to Hand"}, 
{"Action": "Flip", "Label": "Flip"},
{"Action": "To Card Pool", "Label": "Add To Cardpool"}, 
{"Action": "To Stage", "Label": "Build"}, 
{"Action": "To Discard", "Label": "Spend"}, 
{"Action": "To Removed", "Label": "Remove"}, 
{"Action": "To Top Deck", "Label": "To Top Deck"},
{"Action": "To Bottom Deck", "Label": "To Bottom Deck"}]

var animationMan

func _ready() -> void:
	animationMan = $"../../Field/AnimationManager"

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
		momentum[i].cardObj.rotation = PI/2
		animationMan.animate_card_to_pos(momentum[i].cardObj, Vector2(STAGE_POS_CARDPOOL_X, STAGE_POS_CARDPOOL_Y + (cardWidth * i)))
		momentum[i].cardObj.z_index = 300 + i
