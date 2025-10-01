extends Node2D

const CARD_WIDTH = 20

const STAGE_POS_CARDPOOL_X = 100
const STAGE_POS_CARDPOOL_Y = 790

var starting_character

var momentum = []

const momentumActions = [
{"Action": "To Hand", "Label": "Add to Hand"}, 
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
	for i in range(momentum.size()):
		momentum[i].cardObj.rotation = PI/2
		animationMan.animate_card_to_pos(momentum[i].cardObj, Vector2(STAGE_POS_CARDPOOL_X, STAGE_POS_CARDPOOL_Y + (CARD_WIDTH * i)))
		momentum[i].cardObj.z_index = 300 + i
